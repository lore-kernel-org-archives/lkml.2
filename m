Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756005Ab2CTSyt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 14:54:49 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:59665 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754890Ab2CTSyr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 14:54:47 -0400
Subject: Re: [PATCH] Added backlight driver for Acer Aspire 4736
From: Pradeep Subrahmanion <subrahmanion.pradeep@gmail.com>
To: joeyli <jlee@suse.com>
Cc: Matthew Garrett <mjg@redhat.com>, rpurdie@rpsys.net,
        FlorianSchandinat@gmx.de, akpm@linux-foundation.org,
        linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <1332241764.10557.329.camel@linux-s257.site>
References: <1331608337.2267.67.camel@debian.Gayathri>
	 <20120312175130.GA18002@srcf.ucam.org>
	 <1331640592.3485.50.camel@debian.Gayathri>
	 <20120313124738.GB10822@srcf.ucam.org>
	 <CABNxG=Dqg26EHmC3vibf3-SjVhby1qgQfMniQObUeh9eJ6SwEw@mail.gmail.com>
	 <20120313133458.GA11574@srcf.ucam.org>
	 <1331688294.2577.19.camel@debian.Gayathri>
	 <1331680373.10557.169.camel@linux-s257.site>
	 <1331692996.3052.8.camel@debian.Gayathri>
	 <1331704278.10557.190.camel@linux-s257.site>
	 <CABNxG=D3y2GQqS1XN=+B0QRScXpufBkPQtP5-SSNEjSavhtW7g@mail.gmail.com>
	 <1331798740.10557.245.camel@linux-s257.site>
	 <1332047432.6304.13.camel@debian.Gayathri>
	 <1332122514.10557.270.camel@linux-s257.site>
	 <1332241764.10557.329.camel@linux-s257.site>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 21 Mar 2012 00:25:10 +0530
Message-ID: <1332269710.3921.31.camel@debian.Gayathri>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> >From 5da43d2ee6c87dcf17fda34f0b50fe11b04a16bf Mon Sep 17 00:00:00 2001
> From: "Lee, Chun-Yi" <jlee@suse.com>
> Date: Tue, 20 Mar 2012 19:00:58 +0800
> Subject: [PATCH] acer-wmi: add quirk table for video backlight vendor mode
> 
> There have some acer laptop have broken _BCM implemenation, the AML
> code wrote value to EC register but firmware didn't change brighenss.
> 
> Fortunately, the brightness control works on those machines with
> vendor mode. So, add quirk table for video backlight vendor mode
> and unregister acpi video interface on those machines.
> 
> Tested on Acer TravelMate 4750
> 
> Signed-off-by: Lee, Chun-Yi <jlee@suse.com>
> ---
>  drivers/platform/x86/Kconfig    |    4 ++++
>  drivers/platform/x86/acer-wmi.c |   38 +++++++++++++++++++++++++++++++++++---
>  2 files changed, 39 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/platform/x86/Kconfig b/drivers/platform/x86/Kconfig
> index 15dbd8c..fe3a494 100644
> --- a/drivers/platform/x86/Kconfig
> +++ b/drivers/platform/x86/Kconfig
> @@ -26,6 +26,10 @@ config ACER_WMI
>  	depends on RFKILL || RFKILL = n
>  	depends on ACPI_WMI
>  	select INPUT_SPARSEKMAP
> +	# Acer WMI depends on ACPI_VIDEO when ACPI is enabled
> +	# but for select to work, need to select ACPI_VIDEO's dependencies, ick
> +        select VIDEO_OUTPUT_CONTROL if ACPI
> +        select ACPI_VIDEO if ACPI
>  	---help---
>  	  This is a driver for newer Acer (and Wistron) laptops. It adds
>  	  wireless radio and bluetooth control, and on some laptops,
> diff --git a/drivers/platform/x86/acer-wmi.c b/drivers/platform/x86/acer-wmi.c
> index 1e5290b..984a7b5 100644
> --- a/drivers/platform/x86/acer-wmi.c
> +++ b/drivers/platform/x86/acer-wmi.c
> @@ -43,6 +43,7 @@
>  #include <linux/input/sparse-keymap.h>
>  
>  #include <acpi/acpi_drivers.h>
> +#include <acpi/video.h>
>  
>  MODULE_AUTHOR("Carlos Corbacho");
>  MODULE_DESCRIPTION("Acer Laptop WMI Extras Driver");
> @@ -478,6 +479,33 @@ static struct dmi_system_id acer_quirks[] = {
>  	{}
>  };
>  
> +static int video_set_backlight_video_vendor(const struct dmi_system_id *d)
> +{
> +	interface->capability &= ~ACER_CAP_BRIGHTNESS;
> +	pr_info("Brightness must be controlled by generic video driver\n");
> +	return 0;
> +}
> +
> +static const struct dmi_system_id video_vendor_dmi_table[] = {
> +	{
> +		.callback = video_set_backlight_video_vendor,
> +		.ident = "Acer Aspire 4736",
> +		.matches = {
> +			DMI_MATCH(DMI_BOARD_VENDOR, "Acer"),
> +			DMI_MATCH(DMI_PRODUCT_NAME, "Aspire 4736"),
> +		},
> +	},
> +	{
> +		.callback = video_set_backlight_video_vendor,
> +		.ident = "Acer TravelMate 4750",
> +		.matches = {
> +			DMI_MATCH(DMI_BOARD_VENDOR, "Acer"),
> +			DMI_MATCH(DMI_PRODUCT_NAME, "TravelMate 4750"),
> +		},
> +	},
> +	{}
> +};
> +
>  /* Find which quirks are needed for a particular vendor/ model pair */
>  static void find_quirks(void)
>  {
> @@ -1981,9 +2009,13 @@ static int __init acer_wmi_init(void)
>  	set_quirks();
>  
>  	if (acpi_video_backlight_support()) {
> -		interface->capability &= ~ACER_CAP_BRIGHTNESS;
> -		pr_info("Brightness must be controlled by "
> -		       "generic video driver\n");
> +		if (dmi_check_system(video_vendor_dmi_table)) {
> +			acpi_video_unregister();
> +		} else {
> +			interface->capability &= ~ACER_CAP_BRIGHTNESS;
> +			pr_info("Brightness must be controlled by "
> +				"acpi video driver\n");
> +		}
>  	}
>  
>  	if (wmi_has_guid(WMID_GUID3)) {

I tried out applied your patch . Boot message shows , 

[11.220410] acer_wmi: Brightness must be controlled by generic video
driver

Now 'acpi_video0' and 'intel_backlight' are present
inside /sys/class/backlight .Hot key works like earlier ( ie problem
after maximum level still exists).
I tried following commands , 

echo 5 > /sys/class/backlight/acpi_video0/brightness 
echo 5 > /sys/class/backlight/intel_backlight/brightness

But it doesn't make any change . 

In my case  , 'acpi_backlight = vendor' does not make any difference since the hot key control 

already starts working with 'acpi_osi=Linux' option.

cat /proc/cmdline gives , 

BOOT_IMAGE=/boot/vmlinuz-3.3.0+
root=UUID=f0197a59-c067-4fd8-ad90-c4d721816077 ro acpi_osi=Linux 


Thanks , 

Pradeep Subrahmanion

