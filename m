Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935612Ab1ETKXJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 06:23:09 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:65347 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935394Ab1ETKXF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 06:23:05 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 2/3] ARM: mxs: add gpio-mxs platform devices
Date: Fri, 20 May 2011 12:23:00 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.39-rc4+; KDE/4.5.1; x86_64; ; )
Cc: Shawn Guo <shawn.guo@linaro.org>, linux-kernel@vger.kernel.org,
        patches@linaro.org, linus.walleij@linaro.org,
        grant.likely@secretlab.ca, kernel@pengutronix.de
References: <1305885446-27404-1-git-send-email-shawn.guo@linaro.org> <1305885446-27404-3-git-send-email-shawn.guo@linaro.org>
In-Reply-To: <1305885446-27404-3-git-send-email-shawn.guo@linaro.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201105201223.00427.arnd@arndb.de>
X-Provags-ID: V02:K0:NDuroCm6fKAyTrlPeYwKeDhP/Rs/vFeBFf9I+cZy0Pk
 V8GFu/iRm+QZox1deF118rX5g4eaO9Rftzof1sulsgTZmf7Qjd
 0k92dDSKqku6F3vBtwdLUBApItMIgqKWpsTzHjwQ6uCAcbtcs/
 EcorJ74W4YFhkuq1lJIVnxPU+iEdOBn15ANybXyJjFQHvjIt7y
 UY4YcEZgbgDu5a8Kqjtxg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 20 May 2011 11:57:25 Shawn Guo wrote:

> --- /dev/null
> +++ b/arch/arm/mach-mxs/devices/platform-gpio-mxs.c
> @@ -0,0 +1,92 @@
> +/*
> + * Copyright 2011 Freescale Semiconductor, Inc. All Rights Reserved.
> + *
> + * This program is free software; you can redistribute it and/or modify it under
> + * the terms of the GNU General Public License version 2 as published by the
> + * Free Software Foundation.
> + */

Hmm, I forgot to discuss this in Budapest, but I'm still not convinced about
the code ownership here, I think it should be Copyright Linaro Ltd when a
Linaro assignee writes it, not the member company that you work for.

If your manager thinks it should be copyright Freescale, I would suggest
we discuss it on the Linaro private mailing list so we can find a solution
that everyone is happy with. No need to bother the public with this.

> +#include <linux/compiler.h>
> +#include <linux/err.h>
> +#include <linux/init.h>
> +
> +#include <mach/mx23.h>
> +#include <mach/mx28.h>
> +#include <mach/devices-common.h>
> +
> +struct mxs_gpio_data {
> +	int id;
> +	resource_size_t iobase;
> +	resource_size_t iosize;
> +	resource_size_t irq;
> +};

You don't use iosize anywhere.

> +#define mxs_gpio_data_entry_single(soc, _id)				\
> +	{								\
> +		.id = _id,						\
> +		.iobase = soc ## _PINCTRL ## _BASE_ADDR,		\
> +		.irq = soc ## _INT_GPIO ## _id,				\
> +	}
> +
> +#define mxs_gpio_data_entry(soc, _id)					\
> +	[_id] = mxs_gpio_data_entry_single(soc, _id)
> +
> +#ifdef CONFIG_SOC_IMX23
> +const struct mxs_gpio_data mx23_gpio_data[] __initconst = {
> +#define mx23_gpio_data_entry(_id)					\
> +	mxs_gpio_data_entry(MX23, _id)

I know it's tempting to use macros for these, but I think it obscures
the code a lot, especially when you use them to concatenate identifier
names. Why not just do:

	struct platform_device *gpios;
	gpios = platform_device_register_simple(mxs_host_bus, "mxs-gpio-master", 0, NULL, 0);

	mxs_register_gpio(gpios, 0, MX23_PINCTRL_BASE_ADDR, MX23_INT_GPIO_0);
	mxs_register_gpio(gpios, 1, MX23_PINCTRL_BASE_ADDR, MX23_INT_GPIO_1);
	mxs_register_gpio(gpios, 2, MX23_PINCTRL_BASE_ADDR, MX23_INT_GPIO_2);
	mxs_register_gpio(gpios, 3, MX23_PINCTRL_BASE_ADDR, MX23_INT_GPIO_3);

This is actually shorter and it makes it possible to grep for the
macros you use.

> +struct platform_device *__init mxs_add_gpio(
> +		const struct mxs_gpio_data *data)
> +{
> +	struct resource res[] = {
> +		{
> +			.start = data->iobase,
> +			.end = data->iobase + SZ_8K - 1,
> +			.flags = IORESOURCE_MEM,
> +		}, {
> +			.start = data->irq,
> +			.end = data->irq,
> +			.flags = IORESOURCE_IRQ,
> +		},
> +	};
> +
> +	return mxs_add_platform_device("mxs-gpio", data->id,
> +					res, ARRAY_SIZE(res), NULL, 0);
> +}

mxs_add_platform_device doesn't set the parent pointer correctly, I think you
should either fix that or open-code the platform device creation to do it
right.

	Arnd
