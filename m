Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756712Ab1CXDwW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 23:52:22 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:58491 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754927Ab1CXDwT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 23:52:19 -0400
Date: Wed, 23 Mar 2011 21:52:14 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: kernel@wildgooses.com
Cc: lists@wildgooses.com, dilinger@queued.net, linux-geode@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] leds: New PCEngines Alix system driver (enables LEDs via
 gpio interface)
Message-ID: <20110324035214.GB27881@ponder.secretlab.ca>
References: <AANLkTinJNFZ-c_+Cuan5ebuRadrOvdfivxQjnN9GZPt=@mail.gmail.com>
 <1300553466-23873-1-git-send-email-kernel@wildgooses.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1300553466-23873-1-git-send-email-kernel@wildgooses.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 19, 2011 at 04:51:06PM +0000, kernel@wildgooses.com wrote:
> From: Ed Wildgoose <git@wildgooses.com>
> 
> This new driver replaces the old PCEngines Alix 2/3 LED driver with
> a new driver that controls the LEDs through the leds-gpio driver.
> The old driver accessed GPIOs directly, which created a conflict
> and prevented also loading the cs5535-gpio driver to read other
> GPIOs on the Alix board. With this new driver, we hook into leds-gpio
> which in turn uses GPIO to control the LEDs and therefore it's
> possible to control both the LEDs and access onboard GPIOs
> 
> Driver is moved to platform/geode and any other geode
> initialisation modules should move here also.
> 
> This driver is inspired by leds-net5501.c
> by: Alessandro Zummo <a.zummo@towertech.it>
> Ideally, leds-net5501.c should also be moved to platform/geode.
> Additionally the driver relies on parts of the patch: 7f131cf3ed
> by: Daniel Mack <daniel@caiaq.de> to perform detection of the Alix board
> Signed-off-by: Ed Wildgoose <kernel@wildgooses.com>
> ---

[grafting in comments from 2nd email]
> 
> Hi Grant
> 
> I *think* this patch should now be satisfactory and I believe to be
> implemented as we discussed:
> 
> - I have made the driver look like a straightforward platform
> initialisation routine and so further platform setup could be added here
> if required.
> 
> My only thought is that it's quite tucked away and hard to find here,
> given that at present it only enables LEDs on this platform (and seems
> reasonably unlikely to grow beyond that). Would it be
> acceptable/sensible to put the Kconfig entry under LEDs for the time
> being (but the code under /platform/)? Obviously if it starts to do more
> initialisation/setup then the KConfig can be moved back to /arch/x86/ ?
> 
> However, grateful if you could please now review this for inclusion?
> 
> I will submit a second patch momentarily which adds the extra dependency
> of -gpio on -mfd as we discussed in the previous email

Hi Ed,

Reviewed-by: Grant Likely <grant.likely@secretlab.ca>

You'll need to get one of the x86 maintainers to pick this patch up.

Also, a few notes on patch submission etiquette...

(this is not a chastisement, just some things to remember for the next
patch you submit.  You do not need to resubmit your patch)

When following up with new versions of a patch, it is common to
include the version number in the subject line in; something like
'[PATCH v2]', and to also include a changelog in the commit text that
describes what has changed.  It makes it easier to know with patch a
reviewer should be looking at when there are multiple in the INBOX at
one time.  The revision history also helps after a patch is committed
to know at a later date exactly which version actually made it into
Linux mainline.

Also if you want to add personal notes to a patch, you can simply add
them below the '---' cut line.  Text above that line gets committed,
while text below it is culled when committing with git.  So, instead
of replying to your own patch, you can put the text inline.

Cheers,
g.


---

> :100644 100644 d5ed94d... a10556d... M	arch/x86/Kconfig
> :100644 100644 021eee9... 8d87439... M	arch/x86/platform/Makefile
> :000000 100644 0000000... 07c9cd0... A	arch/x86/platform/geode/Makefile
> :000000 100644 0000000... f3f01e2... A	arch/x86/platform/geode/alix.c
> :100644 100644 6f190f4... e4573d6... M	drivers/leds/Kconfig
> :100644 100644 aae6989... bf5a00c... M	drivers/leds/Makefile
> :100644 000000 f59ffad... 0000000... D	drivers/leds/leds-alix2.c
>  arch/x86/Kconfig                 |   14 +++
>  arch/x86/platform/Makefile       |    1 +
>  arch/x86/platform/geode/Makefile |    1 +
>  arch/x86/platform/geode/alix.c   |  141 ++++++++++++++++++++++
>  drivers/leds/Kconfig             |    8 --
>  drivers/leds/Makefile            |    1 -
>  drivers/leds/leds-alix2.c        |  239 --------------------------------------
>  7 files changed, 157 insertions(+), 248 deletions(-)
> 
> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index d5ed94d..a10556d 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -2094,6 +2094,20 @@ config OLPC_OPENFIRMWARE_DT
>  	default y if OLPC_OPENFIRMWARE && PROC_DEVICETREE
>  	select OF_PROMTREE
>  
> +config ALIX
> +	bool "PCEngines ALIX System Support (LED setup)"
> +	select GPIOLIB
> +	---help---
> +	  This option enables system support for the PCEngines ALIX.
> +	  At present this just sets up LEDs for GPIO control on
> +	  ALIX2/3/6 boards.  However, other system specific setup should
> +	  get added here.
> +
> +	  Note: You must still enable the drivers for GPIO and LED support
> +	  (GPIO_CS5535 & LEDS_GPIO) to actually use the LEDs
> +
> +	  Note: You have to set alix.force=1 for boards with Award BIOS.
> +
>  endif # X86_32
>  
>  config AMD_NB
> diff --git a/arch/x86/platform/Makefile b/arch/x86/platform/Makefile
> index 021eee9..8d87439 100644
> --- a/arch/x86/platform/Makefile
> +++ b/arch/x86/platform/Makefile
> @@ -1,6 +1,7 @@
>  # Platform specific code goes here
>  obj-y	+= ce4100/
>  obj-y	+= efi/
> +obj-y	+= geode/
>  obj-y	+= iris/
>  obj-y	+= mrst/
>  obj-y	+= olpc/
> diff --git a/arch/x86/platform/geode/Makefile b/arch/x86/platform/geode/Makefile
> new file mode 100644
> index 0000000..07c9cd0
> --- /dev/null
> +++ b/arch/x86/platform/geode/Makefile
> @@ -0,0 +1 @@
> +obj-$(CONFIG_ALIX)		+= alix.o
> diff --git a/arch/x86/platform/geode/alix.c b/arch/x86/platform/geode/alix.c
> new file mode 100644
> index 0000000..f3f01e2
> --- /dev/null
> +++ b/arch/x86/platform/geode/alix.c
> @@ -0,0 +1,141 @@
> +/*
> + * System Specific setup for PCEngines ALIX.
> + * At the moment this means setup of GPIO control of LEDs
> + * on Alix.2/3/6 boards.
> + *
> + *
> + * Copyright (C) 2008 Constantin Baranov <const@mimas.ru>
> + * Copyright (C) 2011 Ed Wildgoose <kernel@wildgooses.com>
> + *
> + * TODO: There are large similarities with leds-net5501.c
> + * by Alessandro Zummo <a.zummo@towertech.it>
> + * In the future leds-net5501.c should be migrated over to platform
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2
> + * as published by the Free Software Foundation.
> + */
> +
> +#include <linux/kernel.h>
> +#include <linux/init.h>
> +#include <linux/io.h>
> +#include <linux/string.h>
> +#include <linux/leds.h>
> +#include <linux/platform_device.h>
> +#include <linux/gpio.h>
> +
> +#include <asm/geode.h>
> +
> +static int force = 0;
> +module_param(force, bool, 0444);
> +/* FIXME: Award bios is not automatically detected as Alix platform */
> +MODULE_PARM_DESC(force, "Force detection as ALIX.2/ALIX.3 platform");
> +
> +static struct gpio_led alix_leds[] = {
> +	{
> +		.name = "alix:1",
> +		.gpio = 6,
> +		.default_trigger = "default-on",
> +		.active_low = 1,
> +	},
> +	{
> +		.name = "alix:2",
> +		.gpio = 25,
> +		.default_trigger = "default-off",
> +		.active_low = 1,
> +	},
> +	{
> +		.name = "alix:3",
> +		.gpio = 27,
> +		.default_trigger = "default-off",
> +		.active_low = 1,
> +	},
> +};
> +
> +static struct gpio_led_platform_data alix_leds_data = {
> +	.num_leds = ARRAY_SIZE(alix_leds),
> +	.leds = alix_leds,
> +};
> +
> +static struct platform_device alix_leds_dev = {
> +	.name = "leds-gpio",
> +	.id = -1,
> +	.dev.platform_data = &alix_leds_data,
> +};
> +
> +static void __init register_alix(void)
> +{
> +	/* Setup LED control through leds-gpio driver */
> +	platform_device_register(&alix_leds_dev);
> +}
> +
> +static int __init alix_present(unsigned long bios_phys,
> +				const char *alix_sig,
> +				size_t alix_sig_len)
> +{
> +	const size_t bios_len = 0x00010000;
> +	const char *bios_virt;
> +	const char *scan_end;
> +	const char *p;
> +	char name[64];
> +
> +	if (force) {
> +		printk(KERN_NOTICE "%s: forced to skip BIOS test, "
> +		       "assume system is ALIX.2/ALIX.3\n",
> +		       KBUILD_MODNAME);
> +		return 1;
> +	}
> +
> +	bios_virt = phys_to_virt(bios_phys);
> +	scan_end = bios_virt + bios_len - (alix_sig_len + 2);
> +	for (p = bios_virt; p < scan_end; p++) {
> +		const char *tail;
> +		char *a;
> +
> +		if (memcmp(p, alix_sig, alix_sig_len) != 0)
> +			continue;
> +
> +		memcpy(name, p, sizeof(name));
> +
> +		/* remove the first \0 character from string */
> +		a = strchr(name, '\0');
> +		if (a)
> +			*a = ' ';
> +
> +		/* cut the string at a newline */
> +		a = strchr(name, '\r');
> +		if (a)
> +			*a = '\0';
> +
> +		tail = p + alix_sig_len;
> +		if ((tail[0] == '2' || tail[0] == '3')) {
> +			printk(KERN_INFO
> +			       "%s: system is recognized as \"%s\"\n",
> +			       KBUILD_MODNAME, name);
> +			return 1;
> +		}
> +	}
> +
> +	return 0;
> +}
> +
> +static int __init alix_init(void)
> +{
> +	const char tinybios_sig[] = "PC Engines ALIX.";
> +	const char coreboot_sig[] = "PC Engines\0ALIX.";
> +
> +	if (!is_geode())
> +		return 0;
> +
> +	if (alix_present(0xf0000, tinybios_sig, sizeof(tinybios_sig) - 1) ||
> +	    alix_present(0x500, coreboot_sig, sizeof(coreboot_sig) - 1))
> +		register_alix();
> +
> +	return 0;
> +}
> +
> +module_init(alix_init);
> +
> +MODULE_AUTHOR("Ed Wildgoose <kernel@wildgooses.com>");
> +MODULE_DESCRIPTION("PCEngines ALIX System Setup");
> +MODULE_LICENSE("GPL");
> diff --git a/drivers/leds/Kconfig b/drivers/leds/Kconfig
> index 6f190f4..e4573d6 100644
> --- a/drivers/leds/Kconfig
> +++ b/drivers/leds/Kconfig
> @@ -97,14 +97,6 @@ config LEDS_WRAP
>  	help
>  	  This option enables support for the PCEngines WRAP programmable LEDs.
>  
> -config LEDS_ALIX2
> -	tristate "LED Support for ALIX.2 and ALIX.3 series"
> -	depends on LEDS_CLASS
> -	depends on X86 && !GPIO_CS5535 && !CS5535_GPIO
> -	help
> -	  This option enables support for the PCEngines ALIX.2 and ALIX.3 LEDs.
> -	  You have to set leds-alix2.force=1 for boards with Award BIOS.
> -
>  config LEDS_H1940
>  	tristate "LED Support for iPAQ H1940 device"
>  	depends on LEDS_CLASS
> diff --git a/drivers/leds/Makefile b/drivers/leds/Makefile
> index aae6989..bf5a00c 100644
> --- a/drivers/leds/Makefile
> +++ b/drivers/leds/Makefile
> @@ -15,7 +15,6 @@ obj-$(CONFIG_LEDS_AMS_DELTA)		+= leds-ams-delta.o
>  obj-$(CONFIG_LEDS_NET48XX)		+= leds-net48xx.o
>  obj-$(CONFIG_LEDS_NET5501)		+= leds-net5501.o
>  obj-$(CONFIG_LEDS_WRAP)			+= leds-wrap.o
> -obj-$(CONFIG_LEDS_ALIX2)		+= leds-alix2.o
>  obj-$(CONFIG_LEDS_H1940)		+= leds-h1940.o
>  obj-$(CONFIG_LEDS_COBALT_QUBE)		+= leds-cobalt-qube.o
>  obj-$(CONFIG_LEDS_COBALT_RAQ)		+= leds-cobalt-raq.o
> diff --git a/drivers/leds/leds-alix2.c b/drivers/leds/leds-alix2.c
> deleted file mode 100644
> index f59ffad..0000000
> --- a/drivers/leds/leds-alix2.c
> +++ /dev/null
> @@ -1,239 +0,0 @@
> -/*
> - * LEDs driver for PCEngines ALIX.2 and ALIX.3
> - *
> - * Copyright (C) 2008 Constantin Baranov <const@mimas.ru>
> - */
> -
> -#include <linux/err.h>
> -#include <linux/io.h>
> -#include <linux/kernel.h>
> -#include <linux/leds.h>
> -#include <linux/module.h>
> -#include <linux/platform_device.h>
> -#include <linux/string.h>
> -#include <linux/pci.h>
> -
> -static int force = 0;
> -module_param(force, bool, 0444);
> -MODULE_PARM_DESC(force, "Assume system has ALIX.2/ALIX.3 style LEDs");
> -
> -#define MSR_LBAR_GPIO		0x5140000C
> -#define CS5535_GPIO_SIZE	256
> -
> -static u32 gpio_base;
> -
> -static struct pci_device_id divil_pci[] = {
> -	{ PCI_DEVICE(PCI_VENDOR_ID_NS,  PCI_DEVICE_ID_NS_CS5535_ISA) },
> -	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_CS5536_ISA) },
> -	{ } /* NULL entry */
> -};
> -MODULE_DEVICE_TABLE(pci, divil_pci);
> -
> -struct alix_led {
> -	struct led_classdev cdev;
> -	unsigned short port;
> -	unsigned int on_value;
> -	unsigned int off_value;
> -};
> -
> -static void alix_led_set(struct led_classdev *led_cdev,
> -			 enum led_brightness brightness)
> -{
> -	struct alix_led *led_dev =
> -		container_of(led_cdev, struct alix_led, cdev);
> -
> -	if (brightness)
> -		outl(led_dev->on_value, gpio_base + led_dev->port);
> -	else
> -		outl(led_dev->off_value, gpio_base + led_dev->port);
> -}
> -
> -static struct alix_led alix_leds[] = {
> -	{
> -		.cdev = {
> -			.name = "alix:1",
> -			.brightness_set = alix_led_set,
> -		},
> -		.port = 0x00,
> -		.on_value = 1 << 22,
> -		.off_value = 1 << 6,
> -	},
> -	{
> -		.cdev = {
> -			.name = "alix:2",
> -			.brightness_set = alix_led_set,
> -		},
> -		.port = 0x80,
> -		.on_value = 1 << 25,
> -		.off_value = 1 << 9,
> -	},
> -	{
> -		.cdev = {
> -			.name = "alix:3",
> -			.brightness_set = alix_led_set,
> -		},
> -		.port = 0x80,
> -		.on_value = 1 << 27,
> -		.off_value = 1 << 11,
> -	},
> -};
> -
> -static int __init alix_led_probe(struct platform_device *pdev)
> -{
> -	int i;
> -	int ret;
> -
> -	for (i = 0; i < ARRAY_SIZE(alix_leds); i++) {
> -		alix_leds[i].cdev.flags |= LED_CORE_SUSPENDRESUME;
> -		ret = led_classdev_register(&pdev->dev, &alix_leds[i].cdev);
> -		if (ret < 0)
> -			goto fail;
> -	}
> -	return 0;
> -
> -fail:
> -	while (--i >= 0)
> -		led_classdev_unregister(&alix_leds[i].cdev);
> -	return ret;
> -}
> -
> -static int alix_led_remove(struct platform_device *pdev)
> -{
> -	int i;
> -
> -	for (i = 0; i < ARRAY_SIZE(alix_leds); i++)
> -		led_classdev_unregister(&alix_leds[i].cdev);
> -	return 0;
> -}
> -
> -static struct platform_driver alix_led_driver = {
> -	.remove = alix_led_remove,
> -	.driver = {
> -		.name = KBUILD_MODNAME,
> -		.owner = THIS_MODULE,
> -	},
> -};
> -
> -static int __init alix_present(unsigned long bios_phys,
> -				const char *alix_sig,
> -				size_t alix_sig_len)
> -{
> -	const size_t bios_len = 0x00010000;
> -	const char *bios_virt;
> -	const char *scan_end;
> -	const char *p;
> -	char name[64];
> -
> -	if (force) {
> -		printk(KERN_NOTICE "%s: forced to skip BIOS test, "
> -		       "assume system has ALIX.2 style LEDs\n",
> -		       KBUILD_MODNAME);
> -		return 1;
> -	}
> -
> -	bios_virt = phys_to_virt(bios_phys);
> -	scan_end = bios_virt + bios_len - (alix_sig_len + 2);
> -	for (p = bios_virt; p < scan_end; p++) {
> -		const char *tail;
> -		char *a;
> -
> -		if (memcmp(p, alix_sig, alix_sig_len) != 0)
> -			continue;
> -
> -		memcpy(name, p, sizeof(name));
> -
> -		/* remove the first \0 character from string */
> -		a = strchr(name, '\0');
> -		if (a)
> -			*a = ' ';
> -
> -		/* cut the string at a newline */
> -		a = strchr(name, '\r');
> -		if (a)
> -			*a = '\0';
> -
> -		tail = p + alix_sig_len;
> -		if ((tail[0] == '2' || tail[0] == '3')) {
> -			printk(KERN_INFO
> -			       "%s: system is recognized as \"%s\"\n",
> -			       KBUILD_MODNAME, name);
> -			return 1;
> -		}
> -	}
> -
> -	return 0;
> -}
> -
> -static struct platform_device *pdev;
> -
> -static int __init alix_pci_led_init(void)
> -{
> -	u32 low, hi;
> -
> -	if (pci_dev_present(divil_pci) == 0) {
> -		printk(KERN_WARNING KBUILD_MODNAME": DIVIL not found\n");
> -		return -ENODEV;
> -	}
> -
> -	/* Grab the GPIO I/O range */
> -	rdmsr(MSR_LBAR_GPIO, low, hi);
> -
> -	/* Check the mask and whether GPIO is enabled (sanity check) */
> -	if (hi != 0x0000f001) {
> -		printk(KERN_WARNING KBUILD_MODNAME": GPIO not enabled\n");
> -		return -ENODEV;
> -	}
> -
> -	/* Mask off the IO base address */
> -	gpio_base = low & 0x0000ff00;
> -
> -	if (!request_region(gpio_base, CS5535_GPIO_SIZE, KBUILD_MODNAME)) {
> -		printk(KERN_ERR KBUILD_MODNAME": can't allocate I/O for GPIO\n");
> -		return -ENODEV;
> -	}
> -
> -	/* Set GPIO function to output */
> -	outl(1 << 6, gpio_base + 0x04);
> -	outl(1 << 9, gpio_base + 0x84);
> -	outl(1 << 11, gpio_base + 0x84);
> -
> -	return 0;
> -}
> -
> -static int __init alix_led_init(void)
> -{
> -	int ret = -ENODEV;
> -	const char tinybios_sig[] = "PC Engines ALIX.";
> -	const char coreboot_sig[] = "PC Engines\0ALIX.";
> -
> -	if (alix_present(0xf0000, tinybios_sig, sizeof(tinybios_sig) - 1) ||
> -	    alix_present(0x500, coreboot_sig, sizeof(coreboot_sig) - 1))
> -		ret = alix_pci_led_init();
> -
> -	if (ret < 0)
> -		return ret;
> -
> -	pdev = platform_device_register_simple(KBUILD_MODNAME, -1, NULL, 0);
> -	if (!IS_ERR(pdev)) {
> -		ret = platform_driver_probe(&alix_led_driver, alix_led_probe);
> -		if (ret)
> -			platform_device_unregister(pdev);
> -	} else
> -		ret = PTR_ERR(pdev);
> -
> -	return ret;
> -}
> -
> -static void __exit alix_led_exit(void)
> -{
> -	platform_device_unregister(pdev);
> -	platform_driver_unregister(&alix_led_driver);
> -	release_region(gpio_base, CS5535_GPIO_SIZE);
> -}
> -
> -module_init(alix_led_init);
> -module_exit(alix_led_exit);
> -
> -MODULE_AUTHOR("Constantin Baranov <const@mimas.ru>");
> -MODULE_DESCRIPTION("PCEngines ALIX.2 and ALIX.3 LED driver");
> -MODULE_LICENSE("GPL");
> -- 
> 1.7.4
> 
