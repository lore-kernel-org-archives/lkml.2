Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755201Ab1JWIhJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Oct 2011 04:37:09 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:35896 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755151Ab1JWIhH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Oct 2011 04:37:07 -0400
Date: Sun, 23 Oct 2011 09:37:05 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Sangbeom Kim <sbkim73@samsung.com>
Cc: "'Samuel Ortiz'" <sameo@linux.intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] mfd: Add S5M core driver
Message-ID: <20111023083704.GA3135@opensource.wolfsonmicro.com>
References: <009201cc915a$cae8f290$60bad7b0$@com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <009201cc915a$cae8f290$60bad7b0$@com>
X-Cookie: Do not overtax your powers.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 23, 2011 at 05:07:22PM +0900, Sangbeom Kim wrote:

>  drivers/mfd/s5m-core.c               |  235 +++++++++++++++++++++++++
>  include/linux/mfd/s5m87xx/s5m-core.h |  313
> ++++++++++++++++++++++++++++++++++

Naughty Outlook!

> +int s5m_reg_read(struct s5m87xx_dev *s5m87xx, u8 reg, u8 *dest)
> +{
> +	int ret;
> +	unsigned int val;
> +
> +	ret = regmap_read(s5m87xx->regmap, reg, &val);
> +
> +	if (ret < 0)
> +		return ret;
> +
> +	ret &= 0xff;
> +	*dest = ret;

This should be manipulating val rather than ret.  You shouldn't need the
&= 0xff bit but it's understandable for paranoia.

Actually, looking at this what I'm thinking is that we should put some
inline functions in the regmap header which let you write this as
something like

	int s5m_reg_read(struct s5m87xx_dev *s5m87xx, u8 reg, u8 *dest)
	{
		return regmap_read_u8(s5m87xx->dev, reg, dest);
	}

(which might be inline itself) as most of what you're doing here is the
type conversion for the arguments.

> +EXPORT_SYMBOL(s5m_bulk_read);

All this stuff should be _GPL as the regmap core is _GPL - you shouldn't
wrap a _GPL function with a non-GPL one.

> +static struct mfd_cell s5m87xx_devs[] = {
> +	{
> +		.name = "s5m8763-pmic",
> +	}, {
> +		.name = "s5m8767-pmic",
> +	}, {

It looks a bit odd to have both simultaneously but I guess this will
become more obvious later on?  I guess what I'd expect is one of these
arrays per device variant.

> +	s5m87xx->dev = &i2c->dev;
> +	s5m87xx->i2c = i2c;
> +	s5m87xx->irq = i2c->irq;

Is SPI supported?

> +	dev_info(s5m87xx->dev ,"SAMSUNG S5M MFD\n");

Probably best to remove this for mainline, it's not really adding
anything.

> +static const struct i2c_device_id s5m87xx_i2c_id[] = {
> +	{ "s5m87xx", 0 },
> +	{ }
> +};
> +MODULE_DEVICE_TABLE(i2c, s5m87xx_i2c_id);

It'd be better to have one entry per chip explicitly naming the device,
that way boards are describing which they have and the kernel can apply
any device specific configuration.

> +static int s5m_suspend(struct i2c_client *i2c, pm_message_t state)
> +{
> +	struct s5m87xx_dev *s5m87xx = i2c_get_clientdata(i2c);
> +
> +	if (s5m87xx->wakeup)
> +		enable_irq_wake(s5m87xx->irq);
> +
> +	disable_irq(s5m87xx->irq);

Enabling wake and disabling the IRQ looks odd...  perhaps an else?
