Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756282Ab2FNUCT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 16:02:19 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:35715 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755919Ab2FNUCR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 16:02:17 -0400
Date: Thu, 14 Jun 2012 15:02:10 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: Corentin Chary <corentin.chary@gmail.com>
Cc: Len Brown <lenb@kernel.org>, Matthew Garrett <mjg59@srcf.ucam.org>,
        linux-acpi@vger.kernel.org, platform-driver-x86@vger.kernel.org,
        Joey Lee <jlee@novell.com>, Matthew Garrett <mjg@redhat.com>,
        Corentin Chary <corentincj@iksaif.net>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/7] drivers-platform-x86: use
 acpi_video_dmi_promote_vendor()
Message-ID: <20120614200210.GG13448@thinkpad-t410>
Mail-Followup-To: Corentin Chary <corentin.chary@gmail.com>,
	Len Brown <lenb@kernel.org>, Matthew Garrett <mjg59@srcf.ucam.org>,
	linux-acpi@vger.kernel.org, platform-driver-x86@vger.kernel.org,
	Joey Lee <jlee@novell.com>, Matthew Garrett <mjg@redhat.com>,
	Corentin Chary <corentincj@iksaif.net>,
	linux-kernel@vger.kernel.org
References: <CAHR064i_0vunKzB_Yg9SGrWQcPxJs2sTekWk6LuP2qf0FEqBOQ@mail.gmail.com>
 <1339671870-27624-1-git-send-email-corentin.chary@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1339671870-27624-1-git-send-email-corentin.chary@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 14, 2012 at 01:04:30PM +0200, Corentin Chary wrote:
> Instead of using directly acpi_video_unregister(), use
> acpi_video_dmi_promote_vendor() (and make it call
> acpi_video_unregister() if needed)
> 
> Signed-off-by: Corentin Chary <corentin.chary@gmail.com>

The changes to apple-gmux.c get rid of the acpi_video backlight under
EFI boot on the Macbook Pro 8,2. Unfortunately userspace still prefers
intel_backlight on this machine, which also doesn't work. I can't help
but think that we need a more generic way of specifying the preferred
backlight for a machine.

All the same, if this gets picked up feel free to add

Tested-by: Seth Forshee <seth.forshee@canonical.com>

> ---
>  drivers/platform/x86/acer-wmi.c       |   14 +++++++-------
>  drivers/platform/x86/apple-gmux.c     |    2 ++
>  drivers/platform/x86/samsung-laptop.c |   20 +++++++++-----------
>  3 files changed, 18 insertions(+), 18 deletions(-)
> 
> diff --git a/drivers/platform/x86/acer-wmi.c b/drivers/platform/x86/acer-wmi.c
> index ce875dc..7057aef 100644
> --- a/drivers/platform/x86/acer-wmi.c
> +++ b/drivers/platform/x86/acer-wmi.c
> @@ -2060,14 +2060,14 @@ static int __init acer_wmi_init(void)
>  
>  	set_quirks();
>  
> +	if (dmi_check_system(video_vendor_dmi_table))
> +		acpi_video_dmi_promote_vendor();
>  	if (acpi_video_backlight_support()) {
> -		if (dmi_check_system(video_vendor_dmi_table)) {
> -			acpi_video_unregister();
> -		} else {
> -			interface->capability &= ~ACER_CAP_BRIGHTNESS;
> -			pr_info("Brightness must be controlled by "
> -				"acpi video driver\n");
> -		}
> +		interface->capability &= ~ACER_CAP_BRIGHTNESS;
> +		pr_info("Brightness must be controlled by acpi video driver\n");
> +	} else {
> +		pr_info("Disabling ACPI video driver\n");
> +		acpi_video_unregister();
>  	}
>  
>  	if (wmi_has_guid(WMID_GUID3)) {
> diff --git a/drivers/platform/x86/apple-gmux.c b/drivers/platform/x86/apple-gmux.c
> index 694a15a..fd61502 100644
> --- a/drivers/platform/x86/apple-gmux.c
> +++ b/drivers/platform/x86/apple-gmux.c
> @@ -193,6 +193,7 @@ static int __devinit gmux_probe(struct pnp_dev *pnp,
>  	 * backlight control and supports more levels than other options.
>  	 * Disable the other backlight choices.
>  	 */
> +	acpi_video_dmi_promote_vendor();
>  	acpi_video_unregister();
>  	apple_bl_unregister();
>  
> @@ -213,6 +214,7 @@ static void __devexit gmux_remove(struct pnp_dev *pnp)
>  	release_region(gmux_data->iostart, gmux_data->iolen);
>  	kfree(gmux_data);
>  
> +	acpi_video_dmi_demote_vendor();
>  	acpi_video_register();
>  	apple_bl_register();
>  }
> diff --git a/drivers/platform/x86/samsung-laptop.c b/drivers/platform/x86/samsung-laptop.c
> index e2a34b4..b822784 100644
> --- a/drivers/platform/x86/samsung-laptop.c
> +++ b/drivers/platform/x86/samsung-laptop.c
> @@ -26,9 +26,7 @@
>  #include <linux/seq_file.h>
>  #include <linux/debugfs.h>
>  #include <linux/ctype.h>
> -#if (defined CONFIG_ACPI_VIDEO || defined CONFIG_ACPI_VIDEO_MODULE)
>  #include <acpi/video.h>
> -#endif
>  
>  /*
>   * This driver is needed because a number of Samsung laptops do not hook
> @@ -1530,15 +1528,16 @@ static int __init samsung_init(void)
>  	samsung->quirks = quirks;
>  
>  
> -#if (defined CONFIG_ACPI_VIDEO || defined CONFIG_ACPI_VIDEO_MODULE)
> +#ifdef CONFIG_ACPI
> +	if (samsung->quirks->broken_acpi_video)
> +		acpi_video_dmi_promote_vendor();
> +
>  	/* Don't handle backlight here if the acpi video already handle it */
>  	if (acpi_video_backlight_support()) {
> -		if (samsung->quirks->broken_acpi_video) {
> -			pr_info("Disabling ACPI video driver\n");
> -			acpi_video_unregister();
> -		} else {
> -			samsung->handle_backlight = false;
> -		}
> +		samsung->handle_backlight = false;
> +	} else if (samsung->quirks->broken_acpi_video) {
> +		pr_info("Disabling ACPI video driver\n");
> +		acpi_video_unregister();
>  	}
>  #endif
>  
> @@ -1552,8 +1551,7 @@ static int __init samsung_init(void)
>  
>  #ifdef CONFIG_ACPI
>  	/* Only log that if we are really on a sabi platform */
> -	if (acpi_video_backlight_support() &&
> -	    !samsung->quirks->broken_acpi_video)
> +	if (acpi_video_backlight_support())
>  		pr_info("Backlight controlled by ACPI video driver\n");
>  #endif
>  
> -- 
> 1.7.9.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe platform-driver-x86" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
