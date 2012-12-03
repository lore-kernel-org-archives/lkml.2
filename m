Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754169Ab2LCGhV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 01:37:21 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:37576 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751700Ab2LCGhU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 01:37:20 -0500
Date: Mon, 3 Dec 2012 15:36:48 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Daniel Jeong <gshark.jeong@gmail.com>
Cc: Liam Gridwood <lrg@ti.com>, Daniel Jeong <daniel.jeong@ti.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] regulator: new driver for LP8755
Message-ID: <20121203063642.GB9848@opensource.wolfsonmicro.com>
References: <1354509864-30001-1-git-send-email-gshark.jeong@gmail.com>
 <1354509864-30001-2-git-send-email-gshark.jeong@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1354509864-30001-2-git-send-email-gshark.jeong@gmail.com>
X-Cookie: Reply hazy, ask again later.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 03, 2012 at 01:44:24PM +0900, Daniel Jeong wrote:

> +	regval &= ~(0x01 << id);
> +
> +	/* mode fast means forced pwm mode.
> +	   mode normal means not forced pwm mode, according to
> +	   current load it could be one of modes, PWM/PFM/LPPFM. */
> +	return regval ? REGULATOR_MODE_FAST : REGULATOR_MODE_NORMAL;

Your set_mode() implemented an idle mode as well but it can't be read
back..

> +err_i2c:
> +	dev_err(pchip->dev, "i2c acceess error %s\n", __func__);
> +	return -EINVAL;

Your approach to errors throughout the driver is very unhelpful - the
code returned by regmap will be discarded entirely, it's neither
displayed nor returned to the caller.  I'd also be inclined to avoid the
goto idiom, it normally means there's some unwinding to be done but
that's not the case here, just return.

> +/* buck voltage table */
> +static const int lp8755_buck_vtbl[] = {
> +	500000, 510000, 520000, 530000, 540000,
> +	550000, 560000, 570000, 580000, 590000,

There is no point in this being a table, as far as I can see it's a
nice linear map of values with some extras at the end which could just
be dropped.

> +	/* check vendor id and write init value */

There's no writes...

> +	ret = lp8755_read(pchip, 0x18, &regval);

Magic numbers!

> +	if (ret < 0)
> +		goto out_i2c_error;
> +	dev_info(pchip->dev, "lp8755 : chip ID is 0x%x\n", regval);

This isn't actually checking anything except the I/O.  Can the chip ID
really vary?

> +	}
> +
> +	dev_info(pchip->dev, "regulator init Done %s\n", __func__);

This isn't adding anything, drop it.

> +	/* read & clear flag register */
> +	ret = lp8755_read(pchip, 0x0D, &flag0);
> +	ret |= lp8755_write(pchip, 0x0D, 0x00);

More magic numbers.

> +	if (pdata == NULL) {
> +		dev_err(&client->dev, "platform data is NULL.\n");
> +		return -ENOMEM;
> +	}

Platform data should be optional, you should be able to read back the
current regulator state even if you can't set it.

> +	dev_info(&client->dev, "lp8755 init done.\n");
> +	return ret;

Again, drop these noisy prints.  They're not adding anything.

> +/**
> + * struct lp8755_platform_data
> + * @mphase_type    : Multiphase Switcher Configurations 0~8
> + * @buck_init_volt : buck0~6 init voltage in uV.
> + */
> +struct lp8755_platform_data {
> +	int mphase;
> +	struct regulator_init_data *buck_data[LP8755_BUCK_MAX];
> +};

The comments don't match the struct.
