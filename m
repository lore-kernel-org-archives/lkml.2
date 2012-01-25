Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751784Ab2AYKs3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jan 2012 05:48:29 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:43465 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751151Ab2AYKs1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jan 2012 05:48:27 -0500
MIME-Version: 1.0
In-Reply-To: <20120124180707.223ce9b1@debxo>
References: <4F1F3F17.8060201@gmail.com> <20120124180707.223ce9b1@debxo>
From: Christian Gmeiner <christian.gmeiner@gmail.com>
Date: Wed, 25 Jan 2012 11:48:06 +0100
Message-ID: <CAH9NwWc9WNDWC3HkWJU=-4a0i-AgfB01Qy1NfBYuvCiQPXLesQ@mail.gmail.com>
Subject: Re: [PATCH] backlight: Add backlight driver for Bachmann's ot200
To: Andres Salomon <dilinger@queued.net>
Cc: rpurdie@rpsys.net, linux-kernel@vger.kernel.org,
        linux-geode@lists.infradead.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/1/25 Andres Salomon <dilinger@queued.net>:
> On Wed, 25 Jan 2012 00:30:31 +0100
> Christian Gmeiner <christian.gmeiner@gmail.com> wrote:
>
>> From 27574197e9f8425c6aeadffef199c8b7eb969233 Mon Sep 17 00:00:00 2001
>> From: Christian Gmeiner <christian.gmeiner@gmail.com>
>> Date: Fri, 13 Jan 2012 15:31:01 +0100
>> Subject: [PATCH] backlight: Add backlight driver for Bachmann's ot200
>>
>> Add backlight driver for Bachmann's ot200 visualisation device. The
>> driver uses MFGPT 7 of CS5535 silicon to regulate the backlight.
>>
>> Signed-off-by: Christian Gmeiner <christian.gmeiner@gmail.com>
>> ---
>>  drivers/video/backlight/Kconfig    |    9 ++
>>  drivers/video/backlight/Makefile   |    2 +-
>>  drivers/video/backlight/ot200_bl.c |  167
>> ++++++++++++++++++++++++++++++++++++ 3 files changed, 177
>> insertions(+), 1 deletions(-) create mode 100644
>> drivers/video/backlight/ot200_bl.c
>>
>> diff --git a/drivers/video/backlight/Kconfig
>> b/drivers/video/backlight/Kconfig index 278aeaa..ab02544 100644
>> --- a/drivers/video/backlight/Kconfig
>> +++ b/drivers/video/backlight/Kconfig
>> @@ -342,6 +342,15 @@ config BACKLIGHT_AAT2870
>>         If you have a AnalogicTech AAT2870 say Y to enable the
>>         backlight driver.
>>
>> +config BACKLIGHT_OT200
>> +     tristate "Backlight Driver for Bachmann's OT200"
>
> This is purely personal preference, but the possessive apostrophe for
> the manufacturer's device seems weird.
>

okay
>
>> +     depends on BACKLIGHT_CLASS_DEVICE
>> +     select MFD_CS5535
>> +     select CS5535_MFGPT
>
> This is modular; is there any reason to select these instead of simply
> depending upon them?  A strict dependency would be preferrable.
>
> Also, CS5535_MFGPT already depends upon MFD_CS5535, so you can probably
> drop that.
>

good argument - will change it
>
>> +     help
>> +       To compile this driver as a module, choose M here: the
>> module will be
>> +       called ot200_bl.
>> +
>>  endif # BACKLIGHT_CLASS_DEVICE
>>
>>  endif # BACKLIGHT_LCD_SUPPORT
>> diff --git a/drivers/video/backlight/Makefile
>> b/drivers/video/backlight/Makefile index fdd1fc4..4f07d3f 100644
>> --- a/drivers/video/backlight/Makefile
>> +++ b/drivers/video/backlight/Makefile
>> @@ -39,4 +39,4 @@ obj-$(CONFIG_BACKLIGHT_ADP8870)     +=
>> adp8870_bl.o obj-$(CONFIG_BACKLIGHT_88PM860X) += 88pm860x_bl.o
>>  obj-$(CONFIG_BACKLIGHT_PCF50633)     += pcf50633-backlight.o
>>  obj-$(CONFIG_BACKLIGHT_AAT2870) += aat2870_bl.o
>> -
>> +obj-$(CONFIG_BACKLIGHT_OT200) += ot200_bl.o
>> diff --git a/drivers/video/backlight/ot200_bl.c
>> b/drivers/video/backlight/ot200_bl.c new file mode 100644
>> index 0000000..d8e8ba1
>> --- /dev/null
>> +++ b/drivers/video/backlight/ot200_bl.c
>> @@ -0,0 +1,167 @@
>> +/*
>> + * Copyright (C) 2012 Bachmann electronic GmbH
>> + *   Christian Gmeiner <christian.gmeiner@gmail.com>
>> + *
>> + * Backlight driver for Bachmann's ot200.
>> + *
>> + * This program is free software; you can redistribute it and/or
>> modify it
>> + * under the terms of the GNU General Public License version 2 as
>> published by
>> + * the Free Software Foundation.
>> + */
>> +
>> +#include <linux/module.h>
>> +#include <linux/fb.h>
>> +#include <linux/backlight.h>
>> +#include <linux/gpio.h>
>> +#include <linux/cs5535.h>
>> +
>> +static struct cs5535_mfgpt_timer *pwm_timer;
>> +static const  u8 DIM_TABLE[101] = {0, 0, 1, 1, 1, 1, 1, 1, 1, 2, 2,
>
> Please don't use CAPS_VARIABLES unless it's a macro.
>

okay
>
>> 2, 2, 2, 2,
>> +                                2, 2, 2, 2, 3, 3, 3, 3, 3, 3, 3,
>> 4, 4, 4, 4,
>> +                                4, 5, 5, 5, 5, 6, 6, 6, 7, 7, 7,
>> 8, 8, 9, 9,
>> +                                10, 10, 11, 11, 12, 12, 13, 14,
>> 15, 15, 16,
>> +                                17, 18, 19, 20, 21, 22, 23, 24,
>> 26, 27, 28,
>> +                                30, 31, 33, 35, 37, 39, 41, 43,
>> 45, 47, 50,
>> +                                53, 55, 58, 61, 65, 68, 72, 75,
>> 79, 84, 88,
>> +                                93, 97, 103, 108, 114, 120, 126,
>> 133, 140,
>> +                                147, 155, 163};
>
> Also, please describe what this table means, or is for.
>

will do in v2

>
>> +
>> +struct ot200_backlight_data {
>> +     int current_brightness;
>> +};
>> +
>> +#define GPIO_DIMM    27
>> +
>> +static int ot200_backlight_update_status(struct backlight_device *bl)
>> +{
>> +     struct ot200_backlight_data *data = bl_get_data(bl);
>> +     int brightness = bl->props.brightness;
>
> Please use an unsigned here.

okay
>
>> +
>> +     if (bl->props.state & BL_CORE_FBBLANK)
>> +             brightness = 0;
>> +
>> +     /* enable or disable PWM timer */
>> +     if (brightness == 0)
>> +             cs5535_mfgpt_write(pwm_timer, MFGPT_REG_SETUP, 0);
>
> Do you want to disable the timer when the driver/backlight device is
> unloaded, or will that turn off the backlight?
>

I never thought about this use case, but I think it would be the best to
turn brightness of the display to 100%.
>
>> +     else if (brightness != 0 && data->current_brightness == 0) {
>> +             cs5535_mfgpt_write(pwm_timer, MFGPT_REG_COUNTER, 0);
>> +             cs5535_mfgpt_write(pwm_timer, MFGPT_REG_SETUP,
>> 0x8281);
>> +     }
>> +
>> +     /* apply new brightness value */
>> +     cs5535_mfgpt_write(pwm_timer, MFGPT_REG_CMP1,
>> +                                     163 - DIM_TABLE[brightness]);
>> +     data->current_brightness = brightness;
>> +
>> +     return 0;
>> +}
>> +
>> +static int ot200_backlight_get_brightness(struct backlight_device
>> *bl) +{
>> +     struct ot200_backlight_data *data = bl_get_data(bl);
>> +     return data->current_brightness;
>> +}
>> +
>> +static const struct backlight_ops ot200_backlight_ops = {
>> +     .update_status  = ot200_backlight_update_status,
>> +     .get_brightness = ot200_backlight_get_brightness,
>> +};
>> +
>> +static int ot200_backlight_probe(struct platform_device *pdev)
>> +{
>> +     struct backlight_device *bl;
>> +     struct ot200_backlight_data *data;
>> +     struct backlight_properties props;
>> +     int retval = 0;
>> +
>> +     /* request gpio */
>> +     if (gpio_request(GPIO_DIMM, "ot200 backlight dimmer") < 0) {
>> +             printk(KERN_ERR "ot200 backlight: failed to request
>> GPIO %d\n",
>
> I notice you're using dev_err below, but printk(KERN_ERR here.  Any
> reason for that?  My preference would be dev_err here.

upps
>
>> +                             GPIO_DIMM);
>> +             return -ENODEV;
>> +     }
>> +
>> +     /* request timer */
>> +     pwm_timer = cs5535_mfgpt_alloc_timer(7, MFGPT_DOMAIN_ANY);
>> +     if (!pwm_timer) {
>> +             printk(KERN_ERR "ot200 backlight: MFGPT 7 not
>> available\n");
>
> Ditto.
>
>> +             retval = -ENODEV;
>> +             goto error_mfgpt_alloc;
>> +     }
>> +
>> +     data = kzalloc(sizeof(*data), GFP_KERNEL);
>> +     if (data == NULL) {
>
> Please use "if (!data) {" here.
>

okay
>> +             retval = -ENOMEM;
>> +             goto error_kzalloc;
>> +     }
>> +
>> +     /* setup gpio */
>> +     cs5535_gpio_set(GPIO_DIMM, GPIO_OUTPUT_ENABLE);
>> +     cs5535_gpio_set(GPIO_DIMM, GPIO_OUTPUT_AUX1);
>> +
>> +     /* setup timer */
>> +     cs5535_mfgpt_write(pwm_timer, MFGPT_REG_CMP1, 0);
>> +     cs5535_mfgpt_write(pwm_timer, MFGPT_REG_CMP2, 0xa3);
>> +     cs5535_mfgpt_write(pwm_timer, MFGPT_REG_SETUP, 0x8281);
>
> Can you please document this?  This is a backlight driver; what
> are you using timers for?  What is the setup here meant to do?  I'd
> like to see an english description for people so that a glance over
> this doesn't require checking the data sheet, and so that we can verify
> that the code matches the desired effect.
>

I also will have a look into the datasheet, as the driver is port of a vxworks
driver, but I will remove the magic numbers.
>
>> +
>> +     data->current_brightness = 100;
>> +     props.max_brightness = 100;
>> +     props.brightness = 100;
>> +     props.type = BACKLIGHT_RAW;
>> +
>> +     bl = backlight_device_register("ipc", &pdev->dev, data,
>
> What's ipc?

Industrial PC :) I need a name of the backlight device that is equal on
all Bachmann visualisation devices. In the near future I will add post
some patches for an other visualisation device. The goal is to have
it equal on visualisation device - makes the userspace much simpler.

>
>> +                                     &ot200_backlight_ops,
>> &props);
>> +     if (IS_ERR(bl)) {
>> +             dev_err(&pdev->dev, "failed to register
>> backlight\n");
>> +             retval = PTR_ERR(bl);
>> +             goto error_backlight_device_register;
>> +     }
>> +
>> +     platform_set_drvdata(pdev, bl);
>> +
>> +     return 0;
>> +
>> +error_backlight_device_register:
>> +     kfree(data);
>> +error_kzalloc:
>> +     cs5535_mfgpt_free_timer(pwm_timer);
>> +error_mfgpt_alloc:
>> +     gpio_free(GPIO_DIMM);
>> +     return retval;
>> +}
>> +
>> +static int ot200_backlight_remove(struct platform_device *pdev)
>> +{
>> +     struct backlight_device *bl = platform_get_drvdata(pdev);
>> +     struct ot200_backlight_data *data = bl_get_data(bl);
>> +
>> +     backlight_device_unregister(bl);
>> +     kfree(data);
>
> What about freeing the gpio?  Also, the timer?  I know the timer code
> doesn't allow you to reuse the timer once it's been set up, but at
> least you could avoid leaking the pwm_timer memory.
>

good chatch

>
>> +     return 0;
>> +}
>> +
>> +static struct platform_driver ot200_backlight_driver = {
>
> This can probably use __devinitdata.

okay
>
>> +     .driver         = {
>> +             .name   = "ot200-backlight",
>> +             .owner  = THIS_MODULE,
>> +     },
>> +     .probe          = ot200_backlight_probe,
>> +     .remove         = ot200_backlight_remove,
>> +};
>> +
>> +static int __init ot200_backlight_init(void)
>> +{
>> +     return platform_driver_register(&ot200_backlight_driver);
>> +}
>> +module_init(ot200_backlight_init);
>> +
>> +static void __exit ot200_backlight_exit(void)
>> +{
>> +     platform_driver_unregister(&ot200_backlight_driver);
>> +}
>> +module_exit(ot200_backlight_exit);
>> +
>> +MODULE_DESCRIPTION("backlight driver for Bachmann ot200");
>> +MODULE_AUTHOR("Christian Gmeiner <christian.gmeiner@gmail.com>");
>> +MODULE_LICENSE("GPL");
>> +MODULE_ALIAS("platform:ot200-backlight");
>

I will send a v2 of this patch soon
