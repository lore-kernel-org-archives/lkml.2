Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753392Ab0IPK70 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 06:59:26 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:59857 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751532Ab0IPK7Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 06:59:25 -0400
Date: Thu, 16 Sep 2010 11:59:21 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Liam Girdwood <lrg@slimlogic.co.uk>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [PATCH] Regulator: LP3972 PMIC regulator driver
Message-ID: <20100916105921.GD7837@rakim.wolfsonmicro.main>
References: <1284626929.12168.3.camel@mola>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1284626929.12168.3.camel@mola>
X-Cookie: Now I am depressed ...
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 16, 2010 at 04:48:49PM +0800, Axel Lin wrote:
> This patch adds regulator drivers for National Semiconductors LP3972 PMIC.
> This LP3972 PMIC controller has 3 DC/DC voltage converters and 5 low drop-out
> (LDO) regulators. LP3972 PMIC controller uses I2C interface.

> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

but a few things below which it'd be good to fix up incrementally.

> +#define LP3972_LDO_VOL_MIN_IDX(x) (((x) == 4) ? 0x05 : 0x00)
> +#define LP3972_LDO_VOL_MAX_IDX(x) ((x) ? (((x) == 4) ? 0x1f : 0x0f) : 0x0c)

I suspect that writing these out as inline functions without the ternery
operator would be rather more legible.

> +	ret = i2c_smbus_read_byte_data(i2c, reg);
> +	if (ret < 0)
> +		return -EIO;

Better to return the actual error you got.

> +static u8 lp3972_reg_read(struct lp3972 *lp3972, u8 reg)
> +{
> +	u16 val = 0;
> +
> +	mutex_lock(&lp3972->io_lock);
> +
> +	lp3972_i2c_read(lp3972->i2c, reg, 1, &val);
> +
> +	dev_dbg(lp3972->dev, "reg read 0x%02x -> 0x%02x\n", (int)reg,
> +		(unsigned)val&0xff);

Some spaces here would be helpful for legiblility.

> +	switch (ldo) {
> +	case LP3972_LDO1:
> +	case LP3972_LDO5:
> +		shift = LP3972_LDO_VOL_CHANGE_SHIFT(ldo);
> +		ret = lp3972_set_bits(lp3972, LP3972_VOL_CHANGE_REG,
> +			LP3972_VOL_CHANGE_FLAG_MASK << shift,
> +			LP3972_VOL_CHANGE_FLAG_GO << shift);
> +		if (ret)
> +			return ret;
> +
> +		ret = lp3972_set_bits(lp3972, LP3972_VOL_CHANGE_REG,
> +			LP3972_VOL_CHANGE_FLAG_MASK << shift, 0);
> +		break;
> +	}

A comment explaining why it's OK to only handle these two LDOs here
would be helpful.

> +	reg &= LP3972_BUCK_VOL_MASK;
> +	if (reg <= LP3972_BUCK_VOL_MAX_IDX(buck))
> +		val = 1000 * buck_voltage_map[buck][reg];
> +	else {
> +		val = 0;
> +		dev_warn(&dev->dev, "chip reported incorrect voltage value.\n");

Logging the value would be useful for diagnostics.

> +static int setup_regulators(struct lp3972 *lp3972,
> +	struct lp3972_platform_data *pdata)

This could be flagged as __devinit.

> +	/* Detect LP3972 */
> +	ret = lp3972_i2c_read(i2c, LP3972_SYS_CONTROL1_REG, 1, &val);
> +	if (ret == 0 && (val & SYS_CONTROL1_INIT_MASK) != SYS_CONTROL1_INIT_VAL)
> +		ret = -ENODEV;
> +	if (ret < 0) {
> +		dev_err(&i2c->dev, "failed to detect device\n");
> +		goto err_detect;

Again, logging the rejected value is useful.
