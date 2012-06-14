Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755448Ab2FNKEE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 06:04:04 -0400
Received: from charybdis-ext.suse.de ([195.135.221.2]:26144 "EHLO
	nat.nue.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753202Ab2FNKEC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 06:04:02 -0400
Subject: Re: [PATCH 2/7] drivers-platform-x86: use
 acpi_video_dmi_promote_vendor()
From: joeyli <jlee@suse.com>
To: Corentin Chary <corentin.chary@gmail.com>
Cc: Len Brown <lenb@kernel.org>, Matthew Garrett <mjg59@srcf.ucam.org>,
        linux-acpi@vger.kernel.org, platform-driver-x86@vger.kernel.org,
        Joey Lee <jlee@novell.com>, Matthew Garrett <mjg@redhat.com>,
        linux-kernel@vger.kernel.org
In-Reply-To: <1339572727-24744-3-git-send-email-corentin.chary@gmail.com>
References: <1339572727-24744-1-git-send-email-corentin.chary@gmail.com>
	 <1339572727-24744-3-git-send-email-corentin.chary@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 14 Jun 2012 17:58:57 +0800
Message-ID: <1339667937.9598.97.camel@linux-s257.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Corentin, 

於 三，2012-06-13 於 09:32 +0200，Corentin Chary 提到：
> Instead of using directly acpi_video_unregister(), use
> acpi_video_dmi_promote_vendor() (and make it call
> acpi_video_unregister() if needed)
> 
> Signed-off-by: Corentin Chary <corentin.chary@gmail.com>
> ---
>  drivers/platform/x86/acer-wmi.c       |   16 +++++++++-------
>  drivers/platform/x86/apple-gmux.c     |    6 ++++++
>  drivers/platform/x86/samsung-laptop.c |   22 ++++++++++++----------
>  3 files changed, 27 insertions(+), 17 deletions(-)
> 
> diff --git a/drivers/platform/x86/acer-wmi.c b/drivers/platform/x86/acer-wmi.c
> index ce875dc..ffc53df 100644
> --- a/drivers/platform/x86/acer-wmi.c
> +++ b/drivers/platform/x86/acer-wmi.c
> @@ -2060,14 +2060,16 @@ static int __init acer_wmi_init(void)
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
> +#ifdef CONFIG_ACPI_VIDEO

The 'ifdef CONFIG_ACPI_VIDEO' didn't work on my machine with v3.4
kernel, the acpi video didn't unregister. 

My autoconf.h like following:

include/generated/autoconf.h:#define CONFIG_ACPI_VIDEO_MODULE 1


Need use:

-#ifdef CONFIG_ACPI_VIDEO
+#if (defined CONFIG_ACPI_VIDEO || defined CONFIG_ACPI_VIDEO_MODULE)
	pr_info("Disabling ACPI video driver\n"); 
	acpi_video_unregister();
#endif

I tested the above change works to me.


Thanks a lot!
Joey Lee

