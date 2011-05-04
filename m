Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752717Ab1EDQAv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 12:00:51 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:52837 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751285Ab1EDQAu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 12:00:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=J4YTKL9VaBfhlYj86kxhFFWAr1NeDe4FlqGVVAWPoa5Vr3DJf5hb3wY+wA1MsMqUbM
         UIZyWTfcwKZffHOziO/l2UuEkkVEQgyo4Q2pdzEv52upkYfKyhRgjcak/phTRSvGFXyX
         xB1oLexN+C1JEO02v8IqPJcLbyABelUKdOwj0=
MIME-Version: 1.0
In-Reply-To: <E2CAE7F7B064EA49B5CE7EE9A4BB167D151BA5B8B0@KCINPUNHJCMS01.kpit.com>
References: <E2CAE7F7B064EA49B5CE7EE9A4BB167D151BA5B8B0@KCINPUNHJCMS01.kpit.com>
Date: Wed, 4 May 2011 13:00:48 -0300
Message-ID: <BANLkTinBd6dWQnD-BeQrA6QLpUoSrvA14g@mail.gmail.com>
Subject: Re: [PATCHv1 -next] BACKLIGHT: Backlight module for DA9052 PMIC driver
From: Thiago Farina <tfransosi@gmail.com>
To: Ashish Jangam <Ashish.Jangam@kpitcummins.com>
Cc: Richard Purdie <rpurdie@rpsys.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Dajun Chen <Dajun.Chen@diasemi.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 4, 2011 at 6:17 AM, Ashish Jangam
<Ashish.Jangam@kpitcummins.com> wrote:
> Hi Richard,
>
> Backlight Driver for Dialog Semiconductor DA9052 PMICs.
>
> Changes made since last submission:
> . read and write moved to MFD
>
> Signed-off-by: Dajun Chen <dchen@diasemi.com>
> ---
> diff -Naur linux-next-20110421.orig/drivers/video/backlight/da9052_bl.c linux-next-20110421/drivers/video/backlight/da9052_bl.c
> --- linux-next-20110421.orig/drivers/video/backlight/da9052_bl.c        1970-01-01 05:00:00.000000000 +0500
> +++ linux-next-20110421/drivers/video/backlight/da9052_bl.c     2011-04-26 10:41:20.000000000 +0500
> @@ -0,0 +1,215 @@
> +/*
> + * Backlight Driver for Dialog DA9052 PMICs
> + *
> + * Copyright(c) 2011 Dialog Semiconductor Ltd.
> + *
> + * Author: Dajun Chen <dchen@diasemi.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + *
> + */
> +
> +#include <linux/platform_device.h>
> +#include <linux/fb.h>
> +#include <linux/backlight.h>
> +#include <linux/delay.h>
Please, could you sort these includes in alphabetical order?

> +
> +#include <linux/mfd/da9052/da9052.h>
> +#include <linux/mfd/da9052/reg.h>
> +
> +#define DA9052_MAX_BRIGHTNESS          0xFF
> +
> +enum {
> +       DA9052_WLEDS_OFF,
> +       DA9052_WLEDS_ON,
> +       };
There is some unnecessary spaces here. I think }; should be vertical
aligned with 'e'.

Please, could you think all the other cases below?

> +
> +u8 wled_bank[] = {
> +                       DA9052_LED1_CONF_REG,
> +                       DA9052_LED2_CONF_REG,
> +                       DA9052_LED3_CONF_REG,
> +               };
> +
static?

> +struct da9052_bl {
> +       struct da9052 *da9052;
> +       uint brightness;
> +       uint state;
> +       uint led_reg;
> +       };
> +
static ?

> +static int da9052_adjust_wled_brightness(struct da9052_bl *wleds)
> +{
> +       u8 boost_en, i_sink;
> +       int ret = 0;
> +
> +       boost_en = 0x3F;
> +       i_sink   = 0xFF;
> +       if (wleds->state == DA9052_WLEDS_OFF) {
> +               boost_en = 0x00;
> +               i_sink   = 0x00;
> +       }
> +
> +       ret = da9052_reg_write(wleds->da9052, DA9052_BOOST_REG, boost_en);
> +       if (ret < 0) {
> +               dev_err(wleds->da9052->dev,
> +                       "Failed to write boost reg, %d\n", ret);
> +               return ret;
> +       }
> +
> +       ret = da9052_reg_write(wleds->da9052, DA9052_LED_CONT_REG, i_sink);
> +       if (ret < 0) {
> +               dev_err(wleds->da9052->dev,
> +                       "Failed to write led cont reg, %d\n", ret);
> +               return ret;
> +       }
> +
> +       ret = da9052_reg_write(wleds->da9052, wled_bank[wleds->led_reg],
> +                                                       0x0);
> +       if (ret < 0) {
> +               dev_err(wleds->da9052->dev,
> +                       "Failed to write led conf reg, %d", ret);
> +               return ret;
> +       }
> +
> +       if (wleds->brightness) {
> +               msleep(10);
> +               ret = da9052_reg_write(wleds->da9052,
> +               wled_bank[wleds->led_reg], wleds->brightness);
> +               if (ret < 0)
> +                       dev_err(wleds->da9052->dev,
> +                               "Failed to write led conf reg, %d", ret);
> +       }
> +
> +       return ret;
> +
> +}
> +
> +static int da9052_backlight_update_status(struct backlight_device *bl)
> +{
> +       int brightness = bl->props.brightness;
> +       struct da9052_bl *wleds = bl_get_data(bl);
> +
> +       wleds->brightness = brightness;
> +       wleds->state = DA9052_WLEDS_ON;
> +
> +       return da9052_adjust_wled_brightness(wleds);
> +}
> +
> +static int da9052_backlight_get_brightness(struct backlight_device *bl)
> +{
> +       struct da9052_bl *wleds = bl_get_data(bl);
> +       return wleds->brightness;
> +}
> +
> +struct backlight_ops da9052_backlight_ops = {
> +       .update_status  = da9052_backlight_update_status,
> +       .get_brightness = da9052_backlight_get_brightness,
> +};
> +
static?

> +static int da9052_backlight_probe(struct platform_device *pdev)
> +{
> +       struct backlight_device *bl;
> +       struct backlight_properties props;
> +       int ret = 0;
> +       static int led_reg_num;
> +       struct da9052_bl *wleds;
> +
remove this extra blank line. One empty line is fine to separate the
declarations from the rest.

> +
> +       wleds = kzalloc(sizeof(struct da9052_bl), GFP_KERNEL);
> +
please, could you remove this blank line too?

> +       if (!wleds)
> +               return -ENOMEM;
> +
> +       wleds->da9052   = dev_get_drvdata(pdev->dev.parent);
> +       wleds->brightness = 0;
> +       wleds->led_reg = led_reg_num++;
> +       wleds->state = DA9052_WLEDS_OFF;
> +
> +       bl = backlight_device_register(pdev->name, wleds->da9052->dev,
> +                       wleds, &da9052_backlight_ops, &props);
> +
> +       if (IS_ERR(bl)) {
> +               dev_err(&pdev->dev, "Failed to register backlight\n");
> +               return PTR_ERR(bl);
> +       }
> +
> +       bl->props.max_brightness = DA9052_MAX_BRIGHTNESS;
> +       bl->props.brightness = 0;
> +       platform_set_drvdata(pdev, bl);
> +
> +       ret = da9052_adjust_wled_brightness(wleds);
> +       if (ret)
> +               return ret;
> +
> +       return 0;
> +}
> +
> +static int da9052_backlight_remove(struct platform_device *pdev)
> +{
> +       struct backlight_device *bl = platform_get_drvdata(pdev);
> +       struct da9052_bl *wleds = bl_get_data(bl);
> +
> +       wleds->brightness = 0;
> +       wleds->state = DA9052_WLEDS_OFF;
> +
> +       da9052_adjust_wled_brightness(wleds);
> +       backlight_device_unregister(bl);
> +
> +       return 0;
> +}
> +
> +static struct platform_driver da9052_wled1_driver = {
> +       .driver.name    = "da9052-WLED1",
> +       .driver.owner   = THIS_MODULE,
> +       .probe                  = da9052_backlight_probe,
> +       .remove                 = da9052_backlight_remove,
> +};
> +
> +static struct platform_driver da9052_wled2_driver = {
> +       .driver.name    = "da9052-WLED2",
> +       .driver.owner   = THIS_MODULE,
> +       .probe                  = da9052_backlight_probe,
> +       .remove                 = da9052_backlight_remove,
> +};
> +static struct platform_driver da9052_wled3_driver = {
> +       .driver.name    = "da9052-WLED3",
> +       .driver.owner   = THIS_MODULE,
> +       .probe                  = da9052_backlight_probe,
> +       .remove                 = da9052_backlight_remove,
> +};
> +
> +static int __init da9052_backlight_init(void)
> +{
> +       s32 ret;
Add a blank line here?

> +       ret = platform_driver_register(&da9052_wled1_driver);
> +       if (ret)
> +               return ret;
> +       ret = platform_driver_register(&da9052_wled2_driver);
> +       if (ret)
> +               return ret;
> +
> +       ret = platform_driver_register(&da9052_wled3_driver);
> +       if (ret)
> +               return ret;
> +
> +       return 0;
> +}
> +module_init(da9052_backlight_init);
> +
> +static void __exit da9052_backlight_exit(void)
> +{
> +       platform_driver_unregister(&da9052_wled1_driver);
> +       platform_driver_unregister(&da9052_wled2_driver);
> +       platform_driver_unregister(&da9052_wled3_driver);
> +}
> +module_exit(da9052_backlight_exit);
> +
> +MODULE_AUTHOR("Dajun Chen <dchen@diasemi.com>");
> +MODULE_DESCRIPTION("Backlight driver for Dialog DA9052 PMIC");
> +MODULE_LICENSE("GPL v2");
> +MODULE_ALIAS("platform:da9052-backlight");
> +
> +
> diff -Naur linux-next-20110421.orig/drivers/video/backlight/Kconfig linux-next-20110421/drivers/video/backlight/Kconfig
> --- linux-next-20110421.orig/drivers/video/backlight/Kconfig    2011-04-26 09:33:59.000000000 +0500
> +++ linux-next-20110421/drivers/video/backlight/Kconfig 2011-04-26 10:47:08.000000000 +0500
> @@ -237,6 +237,12 @@
>          If you have a LCD backlight connected to the WLED output of DA9030
>          or DA9034 WLED output, say Y here to enable this driver.
>
> +config BACKLIGHT_DA9052
> +       tristate "Dialog DA9052 WLED"
> +       depends on PMIC_DA9052
> +       help
> +         Enable the DA9052 Backlight Driver
> +
>  config BACKLIGHT_MAX8925
>        tristate "Backlight driver for MAX8925"
>        depends on MFD_MAX8925
> diff -Naur linux-next-20110421.orig/drivers/video/backlight/Makefile linux-next-20110421/drivers/video/backlight/Makefile
> --- linux-next-20110421.orig/drivers/video/backlight/Makefile   2011-04-26 09:33:59.000000000 +0500
> +++ linux-next-20110421/drivers/video/backlight/Makefile        2011-04-26 10:45:49.000000000 +0500
> @@ -26,6 +26,7 @@
>  obj-$(CONFIG_BACKLIGHT_CARILLO_RANCH) += cr_bllcd.o
>  obj-$(CONFIG_BACKLIGHT_PWM)            += pwm_bl.o
>  obj-$(CONFIG_BACKLIGHT_DA903X) += da903x_bl.o
> +obj-$(CONFIG_BACKLIGHT_DA9052) += da9052_bl.o
>  obj-$(CONFIG_BACKLIGHT_MAX8925)        += max8925_bl.o
>  obj-$(CONFIG_BACKLIGHT_APPLE)  += apple_bl.o
>  obj-$(CONFIG_BACKLIGHT_TOSA)           += tosa_bl.o
>
> Regards,
> Ashish
>
>
>
