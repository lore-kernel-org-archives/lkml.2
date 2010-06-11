Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760273Ab0FKM4M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 08:56:12 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:45949 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755811Ab0FKM4J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 08:56:09 -0400
Date: Fri, 11 Jun 2010 14:55:07 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: RE: [PATCH] drivers: regulator: add Maxim 8998 driver
In-reply-to: <20100611105823.GA17546@rakim.wolfsonmicro.main>
To: "'Mark Brown'" <broonie@opensource.wolfsonmicro.com>
Cc: "'Liam Girdwood'" <lrg@slimlogic.co.uk>, linux-kernel@vger.kernel.org,
       kyungmin.park@samsung.com,
       "'Marek Szyprowski'" <m.szyprowski@samsung.com>
Message-id: <007201cb0965$542b6cb0$fc824610$%szyprowski@samsung.com>
MIME-version: 1.0
X-Mailer: Microsoft Office Outlook 12.0
Content-type: text/plain; charset=us-ascii
Content-language: pl
Content-transfer-encoding: 7BIT
Thread-index: AcsJVRY6Ks7hE7bvR6W/4GPNQXcY+QAB6e5A
References: <1276239765-26234-1-git-send-email-m.szyprowski@samsung.com>
 <20100611105823.GA17546@rakim.wolfsonmicro.main>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Friday, June 11, 2010 12:58 PM Mark Brown wrote:

> On Fri, Jun 11, 2010 at 09:02:45AM +0200, Marek Szyprowski wrote:
> 
> > This patch adds voltage regulator driver for Maxim 8998 chip. This chip
> > is used on Samsung Aquila and GONI boards.
> 
> Overall this looks pretty good - some comments below, though.

Thanks for comments, we will try to address these issues soon.

> A few things in the code make it look like the driver should be using
> the MFD framework - there's references in here for things like a battery
> charger which should be being supported via the power subsystem, for
> example.

You are right, this chip is really complicated and should work with more
than one kernel subsystem. However in this initial version of the driver
we tried to make it as simple as possible. It can be converted to MFD
framework later, but if you want we can prepare this driver as MFD from
the beginning.

> > +static void max8998_cache_register_init(struct i2c_client *client)
> > +{
> > +	u8 value;
> > +	int ret;
> > +
> > +	ret = max8998_i2c_read(client, MAX8998_REG_STATUS1, &value);
> > +	if (ret)
> > +		return;
> > +	ret = max8998_i2c_read(client, MAX8998_REG_STATUS2, &value);
> > +	if (ret)
> > +		return;
> 
> Should these registers really be cached at all?  They're not used but
> the name and the fact that you read them dynamically makes
> 
> Also, it looks like you're initialising things like the voltage settings
> and regulator enables from the cache rather than from the chip - this
> seems like it'll cause problems if the bootloader or similar has done
> something to the chip prior to the driver taking control.  For PMICs and
> regulators I'd generally expect to see the driver initialise itself from
> the chip rather than fixed defaults.

ok.
 
> > +static const int ldo23_voltage_map[] = {
> > +	 800,  850,  900,  950, 1000,
> > +	1050, 1100, 1150, 1200, 1250,
> > +	1300,
> 
> I may have missed something in these tables but they all look like
> simple functions of the register value - perhaps they could be replaced
> with calculations?

We thought that this way the code will be easier to read. If you think that
encoding these tables into the common table of the {min, step, max} values 
is more appropriate I can change this.

> > +	value = max8998_read_reg(max8998, reg);
> > +	value |= (1 << shift);
> > +	ret = max8998_write_reg(max8998, reg, value);
> 
> This is racy - there's nothing preventing another thread coming in and
> running the same code so you get something like:
> 
> 	reg_read(1)
> 	reg_read(2)
> 	reg_write(1)
> 	reg_write(2)
> 
> You could fix this with an atomic max8998_update_bits() function.

Right, I will fix this.
 
> > +	if (gpio_is_valid(max8998->ono_pin)) {
> > +		ret = gpio_request(max8998->ono_pin, "MAX8998 nONO");
> > +		if (ret)
> > +			goto out_ono;
> > +		irq = gpio_to_irq(max8998->ono_pin);
> > +		ret = request_irq(irq, max8998_ono_irq,
> > +				IRQF_TRIGGER_FALLING | IRQF_TRIGGER_RISING,
> > +				"max8998 nPower", max8998);
> > +		if (ret) {
> > +			dev_err(&client->dev, "Can't get interrupt pin\n");
> > +			goto out_ono_irq;
> > +		}
> > +
> > +		/* enable wakeup source for power button */
> > +		set_irq_wake(irq, 1);
> > +		max8998->ono_irq = irq;
> > +	}
> 
> Should this not just be specified as an IRQ?  The gpio API doesn't
> appear to be being used at all by the driver.

I was not sure whether we should use gpio pin or irq number for this.
I can change it to irq, a in fact gpio functions wouldn't be used for
it.

Best regards
--
Marek Szyprowski
Samsung Poland R&D Center


