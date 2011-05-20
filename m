Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933885Ab1ETN6v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 09:58:51 -0400
Received: from ch1ehsobe004.messaging.microsoft.com ([216.32.181.184]:49565
	"EHLO CH1EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932916Ab1ETN6u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 09:58:50 -0400
X-SpamScore: -12
X-BigFish: VS-12(zz179dN1432N98dKc8kzz1202hzzz2dh2a8h668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Date: Fri, 20 May 2011 22:03:17 +0800
From: Shawn Guo <shawn.guo@freescale.com>
To: Arnd Bergmann <arnd@arndb.de>
CC: <linux-arm-kernel@lists.infradead.org>, Shawn Guo <shawn.guo@linaro.org>,
        <linux-kernel@vger.kernel.org>, <patches@linaro.org>,
        <linus.walleij@linaro.org>, <grant.likely@secretlab.ca>,
        <kernel@pengutronix.de>
Subject: Re: [PATCH 2/3] ARM: mxs: add gpio-mxs platform devices
Message-ID: <20110520140316.GA27551@S2100-06.ap.freescale.net>
References: <1305885446-27404-1-git-send-email-shawn.guo@linaro.org>
 <1305885446-27404-3-git-send-email-shawn.guo@linaro.org>
 <201105201223.00427.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <201105201223.00427.arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 20, 2011 at 12:23:00PM +0200, Arnd Bergmann wrote:
> On Friday 20 May 2011 11:57:25 Shawn Guo wrote:
> 
> > --- /dev/null
> > +++ b/arch/arm/mach-mxs/devices/platform-gpio-mxs.c
> > @@ -0,0 +1,92 @@
> > +/*
> > + * Copyright 2011 Freescale Semiconductor, Inc. All Rights Reserved.
> > + *
> > + * This program is free software; you can redistribute it and/or modify it under
> > + * the terms of the GNU General Public License version 2 as published by the
> > + * Free Software Foundation.
> > + */
> 
> Hmm, I forgot to discuss this in Budapest, but I'm still not convinced about
> the code ownership here, I think it should be Copyright Linaro Ltd when a
> Linaro assignee writes it, not the member company that you work for.
> 
> If your manager thinks it should be copyright Freescale, I would suggest
> we discuss it on the Linaro private mailing list so we can find a solution
> that everyone is happy with. No need to bother the public with this.
> 
For this particular case, I started from copying platform-dma.c and
chose not to touch the copyright.

Speaking of the copyright between Linaro and Freescale, I would prefer
copyright both for most cases, as the patches from me will generally
be based on or referring to Freescale BSP.

Yes, we should discuss it in private.

> > +#include <linux/compiler.h>
> > +#include <linux/err.h>
> > +#include <linux/init.h>
> > +
> > +#include <mach/mx23.h>
> > +#include <mach/mx28.h>
> > +#include <mach/devices-common.h>
> > +
> > +struct mxs_gpio_data {
> > +	int id;
> > +	resource_size_t iobase;
> > +	resource_size_t iosize;
> > +	resource_size_t irq;
> > +};
> 
> You don't use iosize anywhere.
> 
Sorry, it's a rushed copy/past.

> > +#define mxs_gpio_data_entry_single(soc, _id)				\
> > +	{								\
> > +		.id = _id,						\
> > +		.iobase = soc ## _PINCTRL ## _BASE_ADDR,		\
> > +		.irq = soc ## _INT_GPIO ## _id,				\
> > +	}
> > +
> > +#define mxs_gpio_data_entry(soc, _id)					\
> > +	[_id] = mxs_gpio_data_entry_single(soc, _id)
> > +
> > +#ifdef CONFIG_SOC_IMX23
> > +const struct mxs_gpio_data mx23_gpio_data[] __initconst = {
> > +#define mx23_gpio_data_entry(_id)					\
> > +	mxs_gpio_data_entry(MX23, _id)
> 
> I know it's tempting to use macros for these, but I think it obscures
> the code a lot, especially when you use them to concatenate identifier
> names. Why not just do:
> 
The pattern is being widely used in mxc/mxs platform device codes.
If you are not extremely unhappy about this, I would leave it as it
is to keep consistency.

> 	struct platform_device *gpios;
> 	gpios = platform_device_register_simple(mxs_host_bus, "mxs-gpio-master", 0, NULL, 0);
> 
> 	mxs_register_gpio(gpios, 0, MX23_PINCTRL_BASE_ADDR, MX23_INT_GPIO_0);
> 	mxs_register_gpio(gpios, 1, MX23_PINCTRL_BASE_ADDR, MX23_INT_GPIO_1);
> 	mxs_register_gpio(gpios, 2, MX23_PINCTRL_BASE_ADDR, MX23_INT_GPIO_2);
> 	mxs_register_gpio(gpios, 3, MX23_PINCTRL_BASE_ADDR, MX23_INT_GPIO_3);
> 
> This is actually shorter and it makes it possible to grep for the
> macros you use.
> 
> > +struct platform_device *__init mxs_add_gpio(
> > +		const struct mxs_gpio_data *data)
> > +{
> > +	struct resource res[] = {
> > +		{
> > +			.start = data->iobase,
> > +			.end = data->iobase + SZ_8K - 1,
> > +			.flags = IORESOURCE_MEM,
> > +		}, {
> > +			.start = data->irq,
> > +			.end = data->irq,
> > +			.flags = IORESOURCE_IRQ,
> > +		},
> > +	};
> > +
> > +	return mxs_add_platform_device("mxs-gpio", data->id,
> > +					res, ARRAY_SIZE(res), NULL, 0);
> > +}
> 
> mxs_add_platform_device doesn't set the parent pointer correctly, I think you
> should either fix that or open-code the platform device creation to do it
> right.
> 
I see the following in drivers/base/platform.c, function
platform_device_add():

        if (!pdev->dev.parent)
                pdev->dev.parent = &platform_bus;

So we are fine?

-- 
Regards,
Shawn

