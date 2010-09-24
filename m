Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758170Ab0IXVqH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 17:46:07 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43383 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752642Ab0IXVqF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 17:46:05 -0400
Date: Fri, 24 Sep 2010 14:45:35 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Anton Vorontsov <cbouatmailru@gmail.com>
Cc: David Brownell <david-b@pacbell.net>, Samuel Ortiz <sameo@linux.intel.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        David Brownell <dbrownell@users.sourceforge.net>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7] gpio: Add driver for basic memory-mapped GPIO
 controllers
Message-Id: <20100924144535.3714beab.akpm@linux-foundation.org>
In-Reply-To: <20100907140132.GA31782@oksana.dev.rtsoft.ru>
References: <20100831175839.GA32468@oksana.dev.rtsoft.ru>
	<755774.85376.qm@web180301.mail.gq1.yahoo.com>
	<20100907140132.GA31782@oksana.dev.rtsoft.ru>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 7 Sep 2010 18:01:32 +0400
Anton Vorontsov <cbouatmailru@gmail.com> wrote:

> The basic GPIO controllers may be found in various on-board FPGA
> and ASIC solutions that are used to control board's switches, LEDs,
> chip-selects, Ethernet/USB PHY power, etc.
> 
> These controllers may not provide any means of pin setup
> (in/out/open drain).
> 
> The driver supports:
> - 8/16/32/64 bits registers;
> - GPIO controllers with clear/set registers;
> - GPIO controllers with a single "data" register;
> - Big endian bits/GPIOs ordering (mostly used on PowerPC).
> 
>
> ...
>
> --- /dev/null
> +++ b/drivers/gpio/basic_mmio_gpio.c
> @@ -0,0 +1,281 @@
> +/*
> + * Driver for basic memory-mapped GPIO controllers.
> + *
> + * Copyright 2008 MontaVista Software, Inc.
> + * Copyright 2008,2010 Anton Vorontsov <cbouatmailru@gmail.com>
> + *
> + * This program is free software; you can redistribute  it and/or modify it
> + * under  the terms of  the GNU General  Public License as published by the
> + * Free Software Foundation;  either version 2 of the  License, or (at your
> + * option) any later version.
> + *
> + * ....``.```~~~~````.`.`.`.`.```````'',,,.........`````......`.......
> + * ...``                                                         ```````..
> + * ..The simplest form of a GPIO controller that the driver supports is``
> + *  `.just a single "data" register, where GPIO state can be read and/or `
> + *    `,..written. ,,..``~~~~ .....``.`.`.~~.```.`.........``````.```````
> + *        `````````
> +                                    ___
> +_/~~|___/~|   . ```~~~~~~       ___/___\___     ,~.`.`.`.`````.~~...,,,,...
> +__________|~$@~~~        %~    /o*o*o*o*o*o\   .. Implementing such a GPIO .
> +o        `                     ~~~~\___/~~~~    ` controller in FPGA is ,.`
> +                                                 `....trivial..'~`.```.```
> + *                                                    ```````
> + *  .```````~~~~`..`.``.``.
> + * .  The driver supports  `...       ,..```.`~~~```````````````....````.``,,
> + * .   big-endian notation, just`.  .. A bit more sophisticated controllers ,
> + *  . register the device with -be`. .with a pair of set/clear-bit registers ,
> + *   `.. suffix.  ```~~`````....`.`   . affecting the data register and the .`
> + *     ``.`.``...```                  ```.. output pins are also supported.`
> + *                        ^^             `````.`````````.,``~``~``~~``````
> + *                                                   .                  ^^
> + *   ,..`.`.`...````````````......`.`.`.`.`.`..`.`.`..
> + * .. The expectation is that in at least some cases .    ,-~~~-,
> + *  .this will be used with roll-your-own ASIC/FPGA .`     \   /
> + *  .logic in Verilog or VHDL. ~~~`````````..`````~~`       \ /
> + *  ..````````......```````````                             \o_
> + *                                                           |
> + *                              ^^                          / \
> + *
> + *           ...`````~~`.....``.`..........``````.`.``.```........``.
> + *            `  8, 16, 32 and 64 bits registers are supported, and``.
> + *            . the number of GPIOs is determined by the width of   ~
> + *             .. the registers. ,............```.`.`..`.`.~~~.`.`.`~
> + *               `.......````.```
> + */

ooh, sparkly!

>
> ...
>
> +struct bgpio_chip {
> +	struct gpio_chip gc;
> +	void __iomem *reg_dat;
> +	void __iomem *reg_set;
> +	void __iomem *reg_clr;
> +	spinlock_t lock;
> +
> +	int bits;
> +	int big_endian_bits;
> +
> +	/* shadowed data register to clear/set bits safely */
> +	unsigned long data;
> +};

It would be good to document `bits' and `big_endian_bits', and to
describe what `lock' locks.

>
> ...
>
> +static int bgpio_dir_in(struct gpio_chip *gc, unsigned int gpio)
> +{
> +	return 0;
> +}

hm, what does this mean.  The hardware cannot set pin directions to
"in"?  If so, shouldn't we tell someone that their attempt to do this
failed?

>
> ...
>
> +static int __devinit bgpio_probe(struct platform_device *pdev)
> +{
> +	const struct platform_device_id *platid = platform_get_device_id(pdev);
> +	struct device *dev = &pdev->dev;
> +	struct bgpio_pdata *pdata = dev_get_platdata(dev);
> +	struct bgpio_chip *bgc;
> +	struct resource *res_dat;
> +	struct resource *res_set;
> +	struct resource *res_clr;
> +	resource_size_t dat_sz;
> +	int bits;
> +
> +	res_dat = platform_get_resource_byname(pdev, IORESOURCE_MEM, "dat");
> +	if (!res_dat)
> +		return -EINVAL;
> +
> +	dat_sz = resource_size(res_dat);
> +	if (!is_power_of_2(dat_sz))
> +		return -EINVAL;
> +
> +	bits = dat_sz * 8;
> +	if (bits > BITS_PER_LONG)
> +		return -EINVAL;
> +
> +	bgc = devm_kzalloc(dev, sizeof(*bgc), GFP_KERNEL);
> +	if (!bgc)
> +		return -ENOMEM;
> +
> +	bgc->reg_dat = devm_ioremap(dev, res_dat->start, dat_sz);
> +	if (!bgc->reg_dat)
> +		return -ENOMEM;
> +
> +	res_set = platform_get_resource_byname(pdev, IORESOURCE_MEM, "set");
> +	res_clr = platform_get_resource_byname(pdev, IORESOURCE_MEM, "clr");
> +	if (res_set && res_clr) {
> +		if (resource_size(res_set) != resource_size(res_clr) ||
> +				resource_size(res_set) != dat_sz)
> +			return -EINVAL;
> +
> +		bgc->reg_set = devm_ioremap(dev, res_set->start, dat_sz);
> +		bgc->reg_clr = devm_ioremap(dev, res_clr->start, dat_sz);
> +		if (!bgc->reg_set || !bgc->reg_clr)
> +			return -ENOMEM;
> +	} else if (res_set || res_clr) {
> +		return -EINVAL;
> +	}
> +
> +	spin_lock_init(&bgc->lock);
> +
> +	bgc->bits = bits;
> +	bgc->big_endian_bits = !strcmp(platid->name, "basic-mmio-gpio-be");
> +	bgc->data = bgpio_in(bgc);
> +
> +	bgc->gc.ngpio = bits;
> +	bgc->gc.direction_input = bgpio_dir_in;
> +	bgc->gc.direction_output = bgpio_dir_out;
> +	bgc->gc.get = bgpio_get;
> +	bgc->gc.set = bgpio_set;
> +	bgc->gc.dev = dev;
> +	bgc->gc.label = dev_name(dev);
> +
> +	if (pdata)
> +		bgc->gc.base = pdata->base;
> +	else
> +		bgc->gc.base = -1;
> +
> +	dev_set_drvdata(dev, bgc);
> +
> +	return gpiochip_add(&bgc->gc);
> +}

If this function returns -EINVAL then much head-scratching will ensue. 
It might make your life easier to emit a diagnostic just before the
failure so you can work out why it failed.

