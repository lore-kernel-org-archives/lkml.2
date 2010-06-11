Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759821Ab0FKK61 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 06:58:27 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:43234 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753549Ab0FKK60 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 06:58:26 -0400
Date: Fri, 11 Jun 2010 11:58:24 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>, linux-kernel@vger.kernel.org,
       kyungmin.park@samsung.com
Subject: Re: [PATCH] drivers: regulator: add Maxim 8998 driver
Message-ID: <20100611105823.GA17546@rakim.wolfsonmicro.main>
References: <1276239765-26234-1-git-send-email-m.szyprowski@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1276239765-26234-1-git-send-email-m.szyprowski@samsung.com>
X-Cookie: Marriage causes dating problems.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 11, 2010 at 09:02:45AM +0200, Marek Szyprowski wrote:

> This patch adds voltage regulator driver for Maxim 8998 chip. This chip
> is used on Samsung Aquila and GONI boards.

Overall this looks pretty good - some comments below, though.

A few things in the code make it look like the driver should be using
the MFD framework - there's references in here for things like a battery
charger which should be being supported via the power subsystem, for
example.

> +	ret = i2c_smbus_read_byte_data(client, reg);
> +	if (ret < 0)
> +		return -EIO;

It probably makes more sense to pass back the actual error you got from
the I2C subsystem here.

> +static void max8998_cache_register_init(struct i2c_client *client)
> +{
> +	u8 value;
> +	int ret;
> +
> +	ret = max8998_i2c_read(client, MAX8998_REG_STATUS1, &value);
> +	if (ret)
> +		return;
> +	ret = max8998_i2c_read(client, MAX8998_REG_STATUS2, &value);
> +	if (ret)
> +		return;

Should these registers really be cached at all?  They're not used but
the name and the fact that you read them dynamically makes 

Also, it looks like you're initialising things like the voltage settings
and regulator enables from the cache rather than from the chip - this
seems like it'll cause problems if the bootloader or similar has done
something to the chip prior to the driver taking control.  For PMICs and
regulators I'd generally expect to see the driver initialise itself from
the chip rather than fixed defaults.

> +static const int ldo23_voltage_map[] = {
> +	 800,  850,  900,  950, 1000,
> +	1050, 1100, 1150, 1200, 1250,
> +	1300,

I may have missed something in these tables but they all look like
simple functions of the register value - perhaps they could be replaced
with calculations?

> +static int max8998_get_ldo(struct regulator_dev *rdev)
> +{
> +	return rdev_get_id(rdev);
> +}

Probably worth shoving an inline in there, though I'm not sure if the
function is really adding anything.

> +	value = max8998_read_reg(max8998, reg);
> +	value |= (1 << shift);
> +	ret = max8998_write_reg(max8998, reg, value);

This is racy - there's nothing preventing another thread coming in and
running the same code so you get something like:

	reg_read(1)
	reg_read(2)
	reg_write(1)
	reg_write(2)

You could fix this with an atomic max8998_update_bits() function.

> +static int max8998_set_voltage(struct regulator_dev *rdev,
> +				int min_uV, int max_uV)
> +{
> +	struct max8998_data *max8998 = rdev_get_drvdata(rdev);
> +	int min_vol = min_uV / 1000, max_vol = max_uV / 1000;
> +	int ldo = max8998_get_ldo(rdev);
> +	const int *vol_map = ldo_voltage_map[ldo];
> +	int reg, shift = -1, mask, value, ret;
> +	int i;
> +
> +	for (i = 0; i < vol_map[i]; i++) {
> +		if (vol_map[i] >= min_vol)

This vol_map[] checking is pretty obscure...  Are you sure the check
you're using in the for loop shouldn't be based on the table size for
the voltage map rather than on the values in the table?

> +			break;
> +	}
> +
> +	if (!vol_map[i] || vol_map[i] > max_vol)
> +		return -EINVAL;

Your voltage maps aren't null terminated so the check for vol_map[i]
doesn't do what you think it does - you should be checking to see if you
fell off the end of the arary, not to see if you have a zero value.

> +static irqreturn_t max8998_ono_irq(int irq, void *data)
> +{
> +	return IRQ_HANDLED;
> +}

This needs at least a comment explaining why you don't need to do
anything for the interrupt.

> +	if (gpio_is_valid(max8998->ono_pin)) {
> +		ret = gpio_request(max8998->ono_pin, "MAX8998 nONO");
> +		if (ret)
> +			goto out_ono;
> +		irq = gpio_to_irq(max8998->ono_pin);
> +		ret = request_irq(irq, max8998_ono_irq,
> +				IRQF_TRIGGER_FALLING | IRQF_TRIGGER_RISING,
> +				"max8998 nPower", max8998);
> +		if (ret) {
> +			dev_err(&client->dev, "Can't get interrupt pin\n");
> +			goto out_ono_irq;
> +		}
> +
> +		/* enable wakeup source for power button */
> +		set_irq_wake(irq, 1);
> +		max8998->ono_irq = irq;
> +	}

Should this not just be specified as an IRQ?  The gpio API doesn't
appear to be being used at all by the driver.

> +	i2c_set_clientdata(client, max8998);
> +
> +	max8998_cache_register_init(client);

I'd expect the cache initialisation to be done before the regulators are
initialised so that the regulator API can use the cache while it does
the setup.  This will improve performance on startup.
