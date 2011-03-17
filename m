Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754640Ab1CQQIq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 12:08:46 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:63565 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754226Ab1CQQIn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 12:08:43 -0400
MIME-Version: 1.0
In-Reply-To: <20110317084328.41831b4c@debxo>
References: <4D81D7FD.1040602@wildgooses.com> <20110317084328.41831b4c@debxo>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Thu, 17 Mar 2011 10:08:22 -0600
X-Google-Sender-Auth: n0zONnAGlXptML2yErudwiE9GYk
Message-ID: <AANLkTikga=zrNgfsuN4=8tCfZz0n7vkk6i0xW-zj6zSD@mail.gmail.com>
Subject: Re: Feedback please: [PATCH] leds: New PCEngines Alix LED driver
 using gpio interface
To: Andres Salomon <dilinger@queued.net>
Cc: Ed W <lists@wildgooses.com>, rpurdie@rpsys.net,
        linux-geode@lists.infradead.org, const@mimas.ru,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 17, 2011 at 9:43 AM, Andres Salomon <dilinger@queued.net> wrote:
> On Thu, 17 Mar 2011 09:44:29 +0000
> Ed W <lists@wildgooses.com> wrote:
>
>> Hi, please be gentle, first kernel patch.  I have already posted this
>> to the
>> kernel mailing list, but I didn't obviously get any response.
>
> It's best to Cc maintainers directly, as many of them (such as myself)
> don't follow lkml all that closely.
>
>> Grateful if someone could please take a look and guide me as to what
>> adjustments might be required and also the correct person to address
>> this to? Rather hoping that this might make 2.6.39?
>
> Comments below.  BTW, Grant is the new GPIO maintainer, so I've cc'd
> him as well.

Thanks Andres.

Hi Ed.  Thanks for digging in to clean up this driver.  It's
considered very bad form for a driver to both register a device and
then register the driver that binds against it, so this cleanup is
most welcome.

Actually, it looks like with your changes this isn't even a driver
anymore.  It is merely code to register a device on a specific
platform.  Is there any other alix-specific initialization code in the
kernel?  If so, you should consider relocating the device registration
with the rest of the alix setup code.

More comments below...

>
>>
>> The patch basically simplifies the Alix LED driver by making it use
>> the leds_gpio instead of driving GPIOs directly.  This allows us to
>> use the normal kernel gpio facilities to access the rest of the board
>> normally (Alix has a number of user controllable GPIOs)
>>
>> I have already mailed the original authors of the old alix led code,
>> but without a response.
>>
>> It's hard to know, before pressing send, if my mail client will mangle
>> my patch? Copy to the kernel mailing list direct from git is here:
>>     http://marc.info/?l=linux-kernel&m=129943074113312&w=2
>>
>> Thanks for any feedback
>>
>> Ed W
>>
>> -------- Original Message --------
>> Subject:      [PATCH] leds: New PCEngines Alix LED driver using
>> gpio interface Date:  Sun, 6 Mar 2011 16:51:25 +0000
>> From:         kernel@wildgooses.com
>> To:   rpurdie@rpsys.net
>> CC:   const@mimas.ru, daniel@caiaq.de, a.zummo@towertech.it,
>> linux-kernel@vger.kernel.org, Ed Wildgoose <kernel@wildgooses.com>
>>
>>
>>
>> From: Ed Wildgoose <kernel@wildgooses.com>
>>
>> This new driver replaces the old PCEngines Alix 2/3 LED driver with
>> a new driver that controls the LEDs through the leds-gpio driver.
>> The old driver accessed GPIOs directly, which created a conflict
>> and prevented also loading the cs5535-gio driver to read other
>> GPIOs on the Alix board. With this new driver, both are loaded
>> and therefore it's possible to access both the LEDs and onboard GPIOs
>>
>> This driver is based on leds-net5501.c
>> by: Alessandro Zummo <a.zummo@towertech.it>
>> Additionally it relies on parts of the patch: 7f131cf3ed
>> by: Daniel Mack <daniel@caiaq.de> to perform detection of the Alix
>> board
>>
>> Signed-off-by: Ed Wildgoose <kernel@wildgooses.com>
>> ---
>> :100644 100644 6f190f4... 25f0285... M        drivers/leds/Kconfig
>> :100644 100644 f59ffad... 62c8fff... M
>> drivers/leds/leds-alix2.c drivers/leds/Kconfig      |    2 +-
>>  drivers/leds/leds-alix2.c |  196
>> ++++++++++---------------------------------- 2 files changed, 46
>> insertions(+), 152 deletions(-)
>>
>> diff --git a/drivers/leds/Kconfig b/drivers/leds/Kconfig
>> index 6f190f4..25f0285 100644
>> --- a/drivers/leds/Kconfig
>> +++ b/drivers/leds/Kconfig
>> @@ -100,7 +100,7 @@ config LEDS_WRAP
>>  config LEDS_ALIX2
>>       tristate "LED Support for ALIX.2 and ALIX.3 series"
>>       depends on LEDS_CLASS
>> -     depends on X86 && !GPIO_CS5535 && !CS5535_GPIO
>> +     depends on X86 && LEDS_GPIO_PLATFORM && GPIO_CS5535
>>       help
>>         This option enables support for the PCEngines ALIX.2 and
>> ALIX.3 LEDs. You have to set leds-alix2.force=1 for boards with Award
>> BIOS. diff --git a/drivers/leds/leds-alix2.c
>> b/drivers/leds/leds-alix2.c index f59ffad..62c8fff 100644
>> --- a/drivers/leds/leds-alix2.c
>> +++ b/drivers/leds/leds-alix2.c
>> @@ -1,119 +1,66 @@
>>  /*
>>   * LEDs driver for PCEngines ALIX.2 and ALIX.3
>>   *
>> - * Copyright (C) 2008 Constantin Baranov <const@mimas.ru>
>
> This copyright line should not be removed, so long as parts of the
> original driver (such as alix_present) remain.
>
>
>> + * Copyright (C) 2011 Nippy Networks Ltd
>> + * Written by Ed Wildgoose <kernel@wildgooses.com>
>> + * Based on leds-net5501.c by Alessandro Zummo <a.zummo@towertech.it>
>> + *
>> + * This program is free software; you can redistribute it and/or
>> modify
>> + * it under the terms of the GNU General Public License version 2
>> + * as published by the Free Software Foundation.
>>   */
>>
>> -#include <linux/err.h>
>> -#include <linux/io.h>
>>  #include <linux/kernel.h>
>> +#include <linux/init.h>
>> +#include <linux/io.h>
>> +#include <linux/string.h>
>>  #include <linux/leds.h>
>> -#include <linux/module.h>
>>  #include <linux/platform_device.h>
>> -#include <linux/string.h>
>> -#include <linux/pci.h>
>> +#include <linux/gpio.h>
>> +
>> +#include <asm/geode.h>
>>
>>  static int force = 0;
>>  module_param(force, bool, 0444);
>>  MODULE_PARM_DESC(force, "Assume system has ALIX.2/ALIX.3 style
>> LEDs");
>> -#define MSR_LBAR_GPIO                0x5140000C
>> -#define CS5535_GPIO_SIZE     256
>> -
>> -static u32 gpio_base;
>> -
>> -static struct pci_device_id divil_pci[] = {
>> -     { PCI_DEVICE(PCI_VENDOR_ID_NS,
>> PCI_DEVICE_ID_NS_CS5535_ISA) },
>> -     { PCI_DEVICE(PCI_VENDOR_ID_AMD,
>> PCI_DEVICE_ID_AMD_CS5536_ISA) },
>> -     { } /* NULL entry */
>> -};
>> -MODULE_DEVICE_TABLE(pci, divil_pci);
>> -
>> -struct alix_led {
>> -     struct led_classdev cdev;
>> -     unsigned short port;
>> -     unsigned int on_value;
>> -     unsigned int off_value;
>> -};
>> -
>> -static void alix_led_set(struct led_classdev *led_cdev,
>> -                      enum led_brightness brightness)
>> -{
>> -     struct alix_led *led_dev =
>> -             container_of(led_cdev, struct alix_led, cdev);
>> -
>> -     if (brightness)
>> -             outl(led_dev->on_value, gpio_base + led_dev->port);
>> -     else
>> -             outl(led_dev->off_value, gpio_base + led_dev->port);
>> -}
>> -
>> -static struct alix_led alix_leds[] = {
>> +static struct gpio_led alix_leds[] = {
>>       {
>> -             .cdev = {
>> -                     .name = "alix:1",
>> -                     .brightness_set = alix_led_set,
>> -             },
>> -             .port = 0x00,
>> -             .on_value = 1 << 22,
>> -             .off_value = 1 << 6,
>> +             .name = "alix:1",
>> +             .gpio = 6,
>> +             .default_trigger = "default-on",
>> +             .active_low = 1,
>>       },
>>       {
>> -             .cdev = {
>> -                     .name = "alix:2",
>> -                     .brightness_set = alix_led_set,
>> -             },
>> -             .port = 0x80,
>> -             .on_value = 1 << 25,
>> -             .off_value = 1 << 9,
>> +             .name = "alix:2",
>> +             .gpio = 25,
>> +             .default_trigger = "default-off",
>> +             .active_low = 1,
>>       },
>>       {
>> -             .cdev = {
>> -                     .name = "alix:3",
>> -                     .brightness_set = alix_led_set,
>> -             },
>> -             .port = 0x80,
>> -             .on_value = 1 << 27,
>> -             .off_value = 1 << 11,
>> +             .name = "alix:3",
>> +             .gpio = 27,
>> +             .default_trigger = "default-off",
>> +             .active_low = 1,
>>       },
>>  };
>>
>> -static int __init alix_led_probe(struct platform_device *pdev)
>> -{
>> -     int i;
>> -     int ret;
>> -
>> -     for (i = 0; i < ARRAY_SIZE(alix_leds); i++) {
>> -             alix_leds[i].cdev.flags |= LED_CORE_SUSPENDRESUME;
>> -             ret = led_classdev_register(&pdev->dev,
>> &alix_leds[i].cdev);
>> -             if (ret < 0)
>> -                     goto fail;
>> -     }
>> -     return 0;
>> +static struct gpio_led_platform_data alix_leds_data = {
>> +     .num_leds = ARRAY_SIZE(alix_leds),
>> +     .leds = alix_leds,
>> +};
>>
>> -fail:
>> -     while (--i >= 0)
>> -             led_classdev_unregister(&alix_leds[i].cdev);
>> -     return ret;
>> -}
>> +static struct platform_device alix_leds_dev = {
>> +     .name = "leds-gpio",
>
> This should probably be more unique; something like "leds-alix2".

He is pretty much required to use "leds-gpio" so it will get bound to
the leds-gpio driver.

>
>> +     .id = -1,
>> +     .dev.platform_data = &alix_leds_data,
>> +};
>>
>> -static int alix_led_remove(struct platform_device *pdev)
>> +static void __init register_alix(void)
>>  {
>> -     int i;
>> -
>> -     for (i = 0; i < ARRAY_SIZE(alix_leds); i++)
>> -             led_classdev_unregister(&alix_leds[i].cdev);
>> -     return 0;
>> +     platform_device_register(&alix_leds_dev);
>>  }
>>
>> -static struct platform_driver alix_led_driver = {
>> -     .remove = alix_led_remove,
>> -     .driver = {
>> -             .name = KBUILD_MODNAME,
>> -             .owner = THIS_MODULE,
>> -     },
>> -};
>> -
>>  static int __init alix_present(unsigned long bios_phys,
>>                               const char *alix_sig,
>>                               size_t alix_sig_len)
>> @@ -164,76 +111,23 @@ static int __init alix_present(unsigned long
>> bios_phys, return 0;
>>  }
>>
>> -static struct platform_device *pdev;
>> -
>> -static int __init alix_pci_led_init(void)
>> -{
>> -     u32 low, hi;
>> -
>> -     if (pci_dev_present(divil_pci) == 0) {
>> -             printk(KERN_WARNING KBUILD_MODNAME": DIVIL not
>> found\n");
>> -             return -ENODEV;
>> -     }
>> -
>> -     /* Grab the GPIO I/O range */
>> -     rdmsr(MSR_LBAR_GPIO, low, hi);
>> -
>> -     /* Check the mask and whether GPIO is enabled (sanity check)
>> */
>> -     if (hi != 0x0000f001) {
>> -             printk(KERN_WARNING KBUILD_MODNAME": GPIO not
>> enabled\n");
>> -             return -ENODEV;
>> -     }
>> -
>> -     /* Mask off the IO base address */
>> -     gpio_base = low & 0x0000ff00;
>> -
>> -     if (!request_region(gpio_base, CS5535_GPIO_SIZE,
>> KBUILD_MODNAME)) {
>> -             printk(KERN_ERR KBUILD_MODNAME": can't allocate I/O
>> for GPIO\n");
>> -             return -ENODEV;
>> -     }
>> -
>> -     /* Set GPIO function to output */
>> -     outl(1 << 6, gpio_base + 0x04);
>> -     outl(1 << 9, gpio_base + 0x84);
>> -     outl(1 << 11, gpio_base + 0x84);
>> -
>> -     return 0;
>> -}
>> -
>> -static int __init alix_led_init(void)
>> +static int __init alix_init(void)
>>  {
>> -     int ret = -ENODEV;
>>       const char tinybios_sig[] = "PC Engines ALIX.";
>>       const char coreboot_sig[] = "PC Engines\0ALIX.";
>>
>> +     if (!is_geode())
>> +             return 0;
>> +
>
> Presumably you want to return -ENODEV here, especially since your
> driver has no method for unloading.

It looks to me that this isn't actually a driver anymore.  It is
merely a hunk of code that registers a platform_device.  Return 0
should be just fine.

>
>
>>       if (alix_present(0xf0000, tinybios_sig, sizeof(tinybios_sig)
>> - 1) || alix_present(0x500, coreboot_sig, sizeof(coreboot_sig) - 1))
>> -             ret = alix_pci_led_init();
>> +             register_alix();
>
> Ditto.
>
>
>>
>> -     if (ret < 0)
>> -             return ret;
>> -
>> -     pdev = platform_device_register_simple(KBUILD_MODNAME, -1,
>> NULL, 0);
>> -     if (!IS_ERR(pdev)) {
>> -             ret = platform_driver_probe(&alix_led_driver,
>> alix_led_probe);
>> -             if (ret)
>> -                     platform_device_unregister(pdev);
>> -     } else
>> -             ret = PTR_ERR(pdev);
>> -
>> -     return ret;
>> -}
>> -
>> -static void __exit alix_led_exit(void)
>> -{
>> -     platform_device_unregister(pdev);
>> -     platform_driver_unregister(&alix_led_driver);
>> -     release_region(gpio_base, CS5535_GPIO_SIZE);
>> +     return 0;
>>  }
>>
>> -module_init(alix_led_init);
>> -module_exit(alix_led_exit);
>> +arch_initcall(alix_init);
>
> Why is this arch_initcall rather than module_init?   If possible, it
> would be good to have an unload hook as well.

Yes, unless you've got specific ordering constraints this should
definitely be module_init().

g.
