Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935673Ab2JaPGK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 11:06:10 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:58403 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932631Ab2JaPGE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 11:06:04 -0400
MIME-Version: 1.0
In-Reply-To: <1351457210-25222-5-git-send-email-stigge@antcom.de>
References: <1351457210-25222-1-git-send-email-stigge@antcom.de> <1351457210-25222-5-git-send-email-stigge@antcom.de>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Wed, 31 Oct 2012 16:05:43 +0100
X-Google-Sender-Auth: Rt6M7wEIHqzspCvZFhWd2wHYheg
Message-ID: <CACxGe6uUJAKyJMbYGWQsnGdie1bYMr3=S5kc3mucPFicjygMBA@mail.gmail.com>
Subject: Re: [PATCH RESEND 4/5 v6] gpio: Add device tree support to block GPIO API
To: Roland Stigge <stigge@antcom.de>
Cc: gregkh@linuxfoundation.org, linus.walleij@linaro.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        w.sang@pengutronix.de, jbe@pengutronix.de, plagnioj@jcrosoft.com,
        highguy@gmail.com, broonie@opensource.wolfsonmicro.com,
        daniel-gl@gmx.net, rmallon@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 28, 2012 at 9:46 PM, Roland Stigge <stigge@antcom.de> wrote:
> This patch adds device tree support to the block GPIO API.
>
> Signed-off-by: Roland Stigge <stigge@antcom.de>

I'm deferring review on this binding since the API issues need to be
resolved first.

g.

>
> ---
>  Documentation/devicetree/bindings/gpio/gpio-block.txt |   36 +++++++
>  drivers/gpio/Makefile                                 |    1
>  drivers/gpio/gpioblock-of.c                           |   84 ++++++++++++++++++
>  3 files changed, 121 insertions(+)
>
> --- /dev/null
> +++ linux-2.6/Documentation/devicetree/bindings/gpio/gpio-block.txt
> @@ -0,0 +1,36 @@
> +Block GPIO definition
> +=====================
> +
> +This binding specifies arbitrary blocks of gpios, combining gpios from one or
> +more GPIO controllers together, to form a word for r/w access.
> +
> +Required property:
> +- compatible: must be "linux,gpio-block"
> +
> +Required subnodes:
> +- the name will be the registered name of the block
> +- property "gpios" is a list of gpios for the respective block
> +
> +Example:
> +
> +        blockgpio {
> +                compatible = "linux,gpio-block";
> +
> +                block0 {
> +                        gpios = <&gpio 3 0 0>,
> +                                <&gpio 3 1 0>;
> +                };
> +                block1 {
> +                        gpios = <&gpio 4 1 0>,
> +                                <&gpio 4 3 0>,
> +                                <&gpio 4 2 0>,
> +                                <&gpio 4 4 0>,
> +                                <&gpio 4 5 0>,
> +                                <&gpio 4 6 0>,
> +                                <&gpio 4 7 0>,
> +                                <&gpio 4 8 0>,
> +                                <&gpio 4 9 0>,
> +                                <&gpio 4 10 0>,
> +                                <&gpio 4 19 0>;
> +                };
> +        };
> --- linux-2.6.orig/drivers/gpio/Makefile
> +++ linux-2.6/drivers/gpio/Makefile
> @@ -4,6 +4,7 @@ ccflags-$(CONFIG_DEBUG_GPIO)    += -DDEBUG
>
>  obj-$(CONFIG_GPIOLIB)          += gpiolib.o devres.o
>  obj-$(CONFIG_OF_GPIO)          += gpiolib-of.o
> +obj-$(CONFIG_OF_GPIO)          += gpioblock-of.o
>
>  # Device drivers. Generally keep list sorted alphabetically
>  obj-$(CONFIG_GPIO_GENERIC)     += gpio-generic.o
> --- /dev/null
> +++ linux-2.6/drivers/gpio/gpioblock-of.c
> @@ -0,0 +1,84 @@
> +/*
> + * OF implementation for Block GPIO
> + *
> + * Copyright (C) 2012 Roland Stigge <stigge@antcom.de>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + */
> +
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/platform_device.h>
> +#include <linux/gpio.h>
> +#include <linux/of.h>
> +#include <linux/of_gpio.h>
> +#include <linux/module.h>
> +#include <linux/slab.h>
> +#include <linux/err.h>
> +
> +static int __devinit gpioblock_of_probe(struct platform_device *pdev)
> +{
> +       struct device_node *block;
> +       unsigned *gpios;
> +       int ngpio;
> +       int ret;
> +       struct gpio_block *gb;
> +
> +       for_each_available_child_of_node(pdev->dev.of_node, block) {
> +               int i;
> +
> +               ngpio = of_gpio_count(block);
> +               gpios = kzalloc(ngpio * sizeof(*gpios), GFP_KERNEL);
> +               if (!gpios)
> +                       return -ENOMEM;
> +               for (i = 0; i < ngpio; i++) {
> +                       ret = of_get_gpio(block, i);
> +                       if (ret < 0)
> +                               return ret; /* expect -EPROBE_DEFER */
> +                       gpios[i] = ret;
> +               }
> +               gb = gpio_block_create(gpios, ngpio, block->name);
> +               if (IS_ERR(gb)) {
> +                       dev_err(&pdev->dev,
> +                               "Error creating GPIO block from device tree\n");
> +                       return PTR_ERR(gb);
> +               }
> +               ret = gpio_block_register(gb);
> +               if (ret < 0) {
> +                       gpio_block_free(gb);
> +                       return ret;
> +               }
> +               kfree(gpios);
> +               dev_info(&pdev->dev, "Registered gpio block %s: %d gpios\n",
> +                        block->name, ngpio);
> +       }
> +       return 0;
> +}
> +
> +#ifdef CONFIG_OF
> +static struct of_device_id gpioblock_of_match[] __devinitdata = {
> +       { .compatible = "linux,gpio-block", },
> +       { },
> +};
> +MODULE_DEVICE_TABLE(of, gpioblock_of_match);
> +#endif
> +
> +static struct platform_driver gpioblock_of_driver = {
> +       .driver = {
> +               .name = "gpio-block",
> +               .owner = THIS_MODULE,
> +               .of_match_table = of_match_ptr(gpioblock_of_match),
> +
> +       },
> +       .probe  = gpioblock_of_probe,
> +};
> +
> +module_platform_driver(gpioblock_of_driver);
> +
> +MODULE_DESCRIPTION("GPIO Block driver");
> +MODULE_AUTHOR("Roland Stigge <stigge@antcom.de>");
> +MODULE_LICENSE("GPL");
> +MODULE_ALIAS("platform:gpioblock-of");



-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
