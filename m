Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755608Ab1BQAB5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 19:01:57 -0500
Received: from cantor2.suse.de ([195.135.220.15]:51679 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751758Ab1BQABy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 19:01:54 -0500
Date: Wed, 16 Feb 2011 15:58:07 -0800
From: Greg KH <gregkh@suse.de>
To: Frederick van der Wyck <fvanderwyck@gmail.com>
Cc: mjg@redhat.com, platform-driver-x86@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Platform: Samsung Q10 backlight driver
Message-ID: <20110216235807.GA6210@suse.de>
References: <20110216233029.GB17288@ntl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110216233029.GB17288@ntl>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 16, 2011 at 11:30:29PM +0000, Frederick van der Wyck wrote:
> This adds backlight control on the Samsung Q10 laptop, which does not support 
> the SABI interface. Also tested successfully on the Dell Latitude X200.
> 
> Signed-off-by: Frederick van der Wyck <fvanderwyck@gmail.com>
> ---
>  drivers/platform/x86/Kconfig       |    8 ++
>  drivers/platform/x86/Makefile      |    1 +
>  drivers/platform/x86/samsung-q10.c |  152 ++++++++++++++++++++++++++++++++++++
>  3 files changed, 161 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/platform/x86/samsung-q10.c
> 
> The Samsung Q10 is an old model, which does not support the SABI interface, so
> the samsung-laptop driver does not work. Backlight control is not exposed via
> ACPI either. This driver works in the same way as the SMI handler triggered by 
> pressing the brightness function keys. Please let me know any feedback towards 
> getting this driver included.
> 
> diff --git a/drivers/platform/x86/Kconfig b/drivers/platform/x86/Kconfig
> index faec777..7432817 100644
> --- a/drivers/platform/x86/Kconfig
> +++ b/drivers/platform/x86/Kconfig
> @@ -639,4 +639,12 @@ config XO1_RFKILL
>  	  Support for enabling/disabling the WLAN interface on the OLPC XO-1
>  	  laptop.
>  
> +config SAMSUNG_Q10
> +	tristate "Samsung Q10 Extras"
> +	select BACKLIGHT_CLASS_DEVICE
> +	default n
> +	---help---
> +          This driver provides support for backlight control on Samsung Q10
> +          and some other laptops, including Dell Latitude X200.
> +
>  endif # X86_PLATFORM_DEVICES
> diff --git a/drivers/platform/x86/Makefile b/drivers/platform/x86/Makefile
> index 9950ccc..2cd3e52 100644
> --- a/drivers/platform/x86/Makefile
> +++ b/drivers/platform/x86/Makefile
> @@ -33,3 +33,4 @@ obj-$(CONFIG_INTEL_IPS)		+= intel_ips.o
>  obj-$(CONFIG_GPIO_INTEL_PMIC)	+= intel_pmic_gpio.o
>  obj-$(CONFIG_XO1_RFKILL)	+= xo1-rfkill.o
>  obj-$(CONFIG_IBM_RTL)		+= ibm_rtl.o
> +obj-$(CONFIG_SAMSUNG_Q10)	+= samsung-q10.o
> diff --git a/drivers/platform/x86/samsung-q10.c b/drivers/platform/x86/samsung-q10.c
> new file mode 100644
> index 0000000..ec1e004
> --- /dev/null
> +++ b/drivers/platform/x86/samsung-q10.c
> @@ -0,0 +1,152 @@
> +/*
> + *  Driver for Samsung Q10: controls the backlight
> + *
> + *  Also works on Dell Latitude X200
> + *
> + *  Copyright (c) 2011 Frederick van der Wyck <fvanderwyck@gmail.com>
> + *
> + *  This program is free software; you can redistribute it and/or modify
> + *  it under the terms of the GNU General Public License version 2 as
> + *  published by the Free Software Foundation.
> + *
> + */
> +
> +#include <linux/module.h>
> +#include <linux/kernel.h>
> +#include <linux/init.h>
> +#include <linux/platform_device.h>
> +#include <linux/backlight.h>
> +#include <linux/io.h>
> +
> +#define SAMSUNGQ10_BL_MAX_INTENSITY 255
> +#define SAMSUNGQ10_BL_DEFAULT_INTENSITY 185
> +
> +static int samsungq10_suspended;
> +
> +static void samsungq10_bl_send_intensity(struct backlight_device *bd)
> +{
> +	int brightness = bd->props.brightness;
> +
> +	if (!samsungq10_suspended) {
> +		while (inb(0x64)&2)
> +			;
> +		outb_p(0xbe, 0x64);
> +		while (inb(0x64)&2)
> +			;
> +		outb_p(0x89, 0x60);
> +		while (inb(0x64)&2)
> +			;
> +		outb_p(0x91, 0x60);
> +		while (inb(0x64)&2)
> +			;

Potentially endless loops are not good, please timeout if you don't get
the proper value over a time.


> +		outb_p((unsigned char)brightness, 0x60);
> +	};
> +}
> +
> +#ifdef CONFIG_PM
> +static int samsungq10_suspend(struct platform_device *pdev, pm_message_t state)
> +{
> +	samsungq10_suspended = 1;
> +	return 0;
> +}
> +
> +static int samsungq10_resume(struct platform_device *pdev)
> +{
> +	struct backlight_device *bd = platform_get_drvdata(pdev);
> +	samsungq10_suspended = 0;
> +	samsungq10_bl_send_intensity(bd);
> +	return 0;
> +}
> +#else
> +#define samsungq10_suspend	NULL
> +#define samsungq10_resume	NULL
> +#endif
> +
> +static int samsungq10_bl_set_intensity(struct backlight_device *bd)
> +{
> +	samsungq10_bl_send_intensity(bd);
> +	return 0;
> +}
> +
> +static int samsungq10_bl_get_intensity(struct backlight_device *bd)
> +{
> +	return 0;
> +}
> +
> +static const struct backlight_ops samsungq10_bl_ops = {
> +	.get_brightness = samsungq10_bl_get_intensity,
> +	.update_status	= samsungq10_bl_set_intensity,
> +};
> +
> +static int __devinit samsungq10_probe(struct platform_device *pdev)
> +{
> +	struct backlight_properties props;
> +	struct backlight_device *bd;
> +
> +	memset(&props, 0, sizeof(struct backlight_properties));
> +	props.max_brightness = SAMSUNGQ10_BL_MAX_INTENSITY;
> +	bd = backlight_device_register("samsungq10bl", &pdev->dev, NULL,
> +				       &samsungq10_bl_ops, &props);

Why the name "samsungq10bl"?  Why not just "samsung"?

> +	if (IS_ERR(bd))
> +		return PTR_ERR(bd);
> +
> +	platform_set_drvdata(pdev, bd);
> +
> +	bd->props.brightness = SAMSUNGQ10_BL_DEFAULT_INTENSITY;
> +	samsungq10_bl_send_intensity(bd);
> +
> +	return 0;
> +}
> +
> +static int samsungq10_remove(struct platform_device *pdev)
> +{
> +	struct backlight_device *bd = platform_get_drvdata(pdev);
> +
> +	bd->props.brightness = SAMSUNGQ10_BL_DEFAULT_INTENSITY;
> +	samsungq10_bl_send_intensity(bd);
> +
> +	backlight_device_unregister(bd);
> +
> +	return 0;
> +}
> +
> +static struct platform_driver samsungq10_driver = {
> +	.probe		= samsungq10_probe,
> +	.remove		= samsungq10_remove,
> +	.suspend	= samsungq10_suspend,
> +	.resume		= samsungq10_resume,
> +	.driver		= {
> +		.name	= "samsungq10",

Same with the driver name here.

> +	},
> +};
> +
> +static struct platform_device *samsungq10_device;
> +
> +static int __init samsungq10_init(void)
> +{
> +	int ret;
> +
> +	ret = platform_driver_register(&samsungq10_driver);
> +	if (ret)
> +		return ret;
> +	samsungq10_device = platform_device_register_simple("samsungq10", -1,
> +							    NULL, 0);
> +	if (IS_ERR(samsungq10_device)) {
> +		platform_driver_unregister(&samsungq10_driver);
> +		return PTR_ERR(samsungq10_device);
> +	}
> +	return 0;
> +}
> +
> +static void __exit samsungq10_exit(void)
> +{
> +	platform_device_unregister(samsungq10_device);
> +	platform_driver_unregister(&samsungq10_driver);
> +}
> +
> +module_init(samsungq10_init);
> +module_exit(samsungq10_exit);
> +
> +MODULE_AUTHOR("Frederick van der Wyck <fvanderwyck@gmail.com>");
> +MODULE_DESCRIPTION("Samsung Q10 Driver");
> +MODULE_LICENSE("GPL");

No DMI matching to auto-load the driver and also fail to load on any
non-supported hardware?

thanks,

greg k-h
