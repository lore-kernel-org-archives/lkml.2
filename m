Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932195Ab1E0IYj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 04:24:39 -0400
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:13171 "EHLO
	TX2EHSOBE007.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752602Ab1E0IYh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 04:24:37 -0400
X-SpamScore: -9
X-BigFish: VS-9(zz1432N98dKzz1202hzzz2dh2a8h668h839h)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPVD:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Date: Fri, 27 May 2011 16:29:17 +0800
From: Shawn Guo <shawn.guo@freescale.com>
To: Arnd Bergmann <arnd@arndb.de>
CC: <linux-arm-kernel@lists.infradead.org>, Shawn Guo <shawn.guo@linaro.org>,
        <linux-kernel@vger.kernel.org>, <patches@linaro.org>,
        <linus.walleij@linaro.org>, <grant.likely@secretlab.ca>,
        <kernel@pengutronix.de>
Subject: Re: [PATCH 2/3] ARM: mxs: add gpio-mxs platform devices
Message-ID: <20110527082916.GB30146@S2100-06.ap.freescale.net>
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
[...]
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
> 	struct platform_device *gpios;
> 	gpios = platform_device_register_simple(mxs_host_bus, "mxs-gpio-master", 0, NULL, 0);
> 
platform_device_register_simple does not have parameter for 'parent',
and it sets 'parent' NULL anyway.

-- 
Regards,
Shawn

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

