Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752628Ab2AGK7i (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jan 2012 05:59:38 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:59322 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751450Ab2AGK7h convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jan 2012 05:59:37 -0500
MIME-Version: 1.0
In-Reply-To: <CAOesGMiMervHeVZeTitC20QScGhHOL2nqnmZTBRc17s-K1OhZA@mail.gmail.com>
References: <1325778146-27056-1-git-send-email-thomas.abraham@linaro.org>
	<CAOesGMiMervHeVZeTitC20QScGhHOL2nqnmZTBRc17s-K1OhZA@mail.gmail.com>
Date: Sat, 7 Jan 2012 16:29:35 +0530
Message-ID: <CAJuYYwQjiWj=KVptnO--OSAxDOy4QUV-+AAvyxXuK=8DkJUApQ@mail.gmail.com>
Subject: Re: [PATCH] backlight: lcd: add driver for raster-type lcd's with
 gpio controlled panel reset
From: Thomas Abraham <thomas.abraham@linaro.org>
To: Olof Johansson <olof@lixom.net>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        rpurdie@rpsys.net, linux-samsung-soc@vger.kernel.org,
        grant.likely@secretlab.ca, rob.herring@calxeda.com,
        kgene.kim@samsung.com, jg1.han@samsung.com,
        broonie@opensource.wolfsonmicro.com, kyungmin.park@samsung.com,
        cbou@mail.ru, kwangwoo.lee@gmail.com, augulis.darius@gmail.com,
        ben-linux@fluff.org, lars@metafoo.de, patches@linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Olof,

On 6 January 2012 12:16, Olof Johansson <olof@lixom.net> wrote:
> Hi,
>
> This looks much better than the previous approach. Some comments on
> the binding below.
>
> On Thu, Jan 5, 2012 at 7:42 AM, Thomas Abraham
> <thomas.abraham@linaro.org> wrote:
>
>> diff --git a/Documentation/devicetree/bindings/lcd/lcd-pwrctrl.txt b/Documentation/devicetree/bindings/lcd/lcd-pwrctrl.txt
>> new file mode 100644
>> index 0000000..941e2ff
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/lcd/lcd-pwrctrl.txt
>> @@ -0,0 +1,39 @@
>> +* Power controller for simple lcd panels
>> +
>> +Some LCD panels provide a simple control interface for the host system. The
>> +control mechanism would include a nRESET line connected to a gpio of the host
>> +system and a Vcc supply line which the host can optionally be controlled using
>> +a voltage regulator. Such simple panels do not support serial command
>> +interface (such as i2c or spi) or memory-mapped-io interface.
>> +
>> +Required properties:
>> +- compatible: should be 'lcd,powerctrl'
>
> The convention for names is "vendor,product", so it would be better to
> name this something like "lcd-powercontrol"

Ok. I will change this.

>
>> +- gpios: The GPIO number of the host system used to control the nRESET line.
>> +  The format of the gpio specifier depends on the gpio controller of the
>> +  host system.
>> +
>> +Optional properties:
>> +- lcd,pwrctrl-nreset-gpio-invert: When the nRESET line is asserted low, the
>> +  lcd panel is reset and stays in reset mode as long as the nRESET line is
>> +  asserted low. This is the default behaviour of most lcd panels. If a lcd
>> +  panel requires the nRESET line to be asserted high for panel reset, then
>> +  this property is used.
>> +- lcd,pwrctrl-min-uV: If a regulator controls the Vcc voltage of the lcd panel,
>> +  this property specifies the minimum voltage the regulator should supply.
>> +  The value of this property should in in micro-volts.
>> +- lcd,pwrctrl-max-uV: If a regulator controls the Vcc voltage of the lcd panel,
>> +  this property specifies the maximum voltage the regulator should limit to
>> +  on the Vcc line. The value of this property should in in micro-volts.
>> +- vcc-lcd-supply: phandle of the regulator that controls the vcc supply to
>> +  the lcd panel.
>
> The above names are somewhat inconsistent. Why abbreviate powercontrol
> in different ways between compatible and properties, for example.
>
> Also, since there's no vendor to prefix with, it might just be easier
> to avoid the prefix alltogether, or use a <word>-<property> prefix
> instead, such as:
>
> lcd-reset-gpios
> lcd-reset-active-low   (some platforms can specify polarity in the
> gpio specifier, so I'm not sure if this is needed?
> lcd-power-min-uV
> lcd-power-max-uV
> lcd-power-supply

Ok. This seems better. I will redo the code.

>
>> +
>> +Example:
>> +
>> +       lcd_pwrctrl {
>> +               compatible = "lcd,powerctrl";
>> +               gpios = <&gpe0 4 1 0 0>;
>> +               lcd,pwrctrl-nreset-gpio-invert;
>> +               lcd,pwrctrl-min-uV = <2500000>;
>> +               lcd,pwrctrl-max-uV = <3300000>;
>> +               lcd-vcc-supply - <&regulator7>;
>> +       };
>
>
> [...]
>> +
>> +#ifdef CONFIG_OF
>> +static void __devinit lcd_pwrctrl_parse_dt(struct device *dev,
>> +                                       struct lcd_pwrctrl_data *pdata)
>> +{
>> +       struct device_node *np = dev->of_node;
>> +
>> +       pdata->gpio = of_get_gpio(np, 0);
>> +       if (of_get_property(np, "lcd,pwrctrl-nreset-gpio-invert", NULL))
>> +               pdata->invert = true;
>> +       of_property_read_u32(np, "lcd,pwrctrl-min-uV", &pdata->min_uV);
>> +       of_property_read_u32(np, "lcd,pwrctrl-max-uV", &pdata->max_uV);
>> +}
>> +#endif
>> +
>> +static int __devinit lcd_pwrctrl_probe(struct platform_device *pdev)
>> +{
>> +       struct lcd_pwrctrl *lp;
>> +       struct lcd_pwrctrl_data *pdata = pdev->dev.platform_data;
>> +       struct device *dev = &pdev->dev;
>> +       int err;
>> +
>> +#ifdef CONFIG_OF
>> +       if (dev->of_node) {
>> +               pdata = devm_kzalloc(dev, sizeof(*pdata), GFP_KERNEL);
>> +               if (!pdata) {
>> +                       dev_err(dev, "memory allocation for pdata failed\n");
>> +                       return -ENOMEM;
>> +               }
>> +               lcd_pwrctrl_parse_dt(dev, pdata);
>> +       }
>> +#endif
>
> The usual way of handling this is by checking if pdata is NULL, and if
> so, call lcd_pwrctrl_fill_pdata() that returns an allocated pdata
> structure (and check pdata for NULL again). That can also be done by
> doing a stub that returns NULL and not use ifdef in the C code.

Ok. In case of kernel image that has support for both dt and non-dt
platforms, the check of pdata == NULL would not be a sufficient
condition to start parsing dt. So the dev->of_node is checked. The
#ifdef is used here to keep this portion of code out if kernel is
compiled only for non-dt platforms.

>
> [...]
>
>> diff --git a/include/video/lcd_pwrctrl.h b/include/video/lcd_pwrctrl.h
>> new file mode 100644
>> index 0000000..75b6ce2
>> --- /dev/null
>> +++ b/include/video/lcd_pwrctrl.h
>> @@ -0,0 +1,30 @@
>> +/*
>> + * Simple lcd panel power control driver.
>> + *
>> + * Copyright (c) 2011-2012 Samsung Electronics Co., Ltd.
>> + * Copyright (c) 2011-2012 Linaro Ltd.
>> + *
>> + * This driver is derived from platform-lcd.h which was written by
>> + * Ben Dooks <ben@simtec.co.uk>
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License version 2 as
>> + * published by the Free Software Foundation.
>> + *
>> +*/
>> +
>> +/**
>> + * struct lcd_pwrctrl_data - platform data for lcd_pwrctrl driver.
>> + * @gpio: GPIO number of the host system that connects to nRESET line.
>> + * @invert: True, if output of gpio connected to nRESET should be inverted.
>> + * @min_uV: Minimum required voltage output from the regulator. The voltage
>> + *   should be specified in micro-volts.
>> + * @max_uV: Maximum acceptable voltage output from the regulator. The voltage
>> + *   should be specified in micro-volts.
>> + */
>> +struct lcd_pwrctrl_data {
>> +       int             gpio;
>> +       bool            invert;
>> +       int             min_uV;
>> +       int             max_uV;
>> +};
>
> If this is a pure open firmware driver, then there is no need to
> export this, you can just keep it internal to the C file.

This driver does support non-dt platforms as well and platform code
can supply the platform data using this structure.

Thanks Olof for your review.

Regards,
Thomas.
