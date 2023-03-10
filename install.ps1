#Requires -RunAsAdministrator

Function main() {

    $wallpaper = "https://raw.githubusercontent.com/stefvbc/install/main/wallpaper.jpg";
    $teamviewer = "https://raw.githubusercontent.com/stefvbc/install/main/teamviewer.exe";
    $folder = "C:\VBC NV"

    $exists = Test-CommandExists winget

    if ($exists) {
        winget install -h -e --id Adobe.Acrobat.Reader.64-bit
        winget install -h -e --id Mozilla.Firefox
        winget install -h -e --id Google.Chrome
        winget install -h -e --id BelgianGovernment.Belgium-eIDmiddleware
        winget install -h -e --id BelgianGovernment.eIDViewer
    }

    if(!(Test-Path -Path $folder)){
        New-Item -Path $folder -ItemType Directory | Out-Null
    }
    Invoke-WebRequest -Uri $wallpaper -OutFile "$folder\wallpaper.jpg"
    Set-Wallpaper("$folder\wallpaper.jpg")
    Invoke-WebRequest -Uri $teamviewer -OutFile "~\Desktop\TeamViewer VBC.exe"
}

Function Test-CommandExists
{
    Param ($command)
 
    $oldPreference = $ErrorActionPreference
    $ErrorActionPreference = 'stop'
 
    Try { if (Get-Command $command) { $true } }
    Catch { $false }
    Finally { $ErrorActionPreference = $oldPreference }
}

Function Set-Wallpaper($MyWallpaper) {

    $code = @' 
    using System.Runtime.InteropServices; 
    namespace Win32{ 
        
        public class Wallpaper{ 
            [DllImport("user32.dll", CharSet=CharSet.Auto)] 
            static extern int SystemParametersInfo (int uAction , int uParam , string lpvParam , int fuWinIni) ; 
            
            public static void SetWallpaper(string thePath){ 
                SystemParametersInfo(20,0,thePath,3); 
            }
        }
    }
'@

    add-type $code 
    [Win32.Wallpaper]::SetWallpaper($MyWallpaper)
}

# Run the main function
main
