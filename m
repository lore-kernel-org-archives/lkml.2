Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932126Ab0FAOhx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 10:37:53 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:46700 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756510Ab0FAOhw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 10:37:52 -0400
Date: Tue, 1 Jun 2010 15:37:49 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Mike Frysinger <vapier@gentoo.org>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lrg@slimlogic.co.uk>,
       uclinux-dist-devel@blackfin.uclinux.org,
       Sonic Zhang <sonic.zhang@analog.com>
Subject: Re: [PATCH 1/2] regulator: new driver for the AD5398 and AD5821
Message-ID: <20100601143749.GE863@rakim.wolfsonmicro.main>
References: <1275399239-6788-1-git-send-email-vapier@gentoo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1275399239-6788-1-git-send-email-vapier@gentoo.org>
X-Cookie: Some settling may occur.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 01, 2010 at 09:33:58AM -0400, Mike Frysinger wrote:
> From: Sonic Zhang <sonic.zhang@analog.com>

> This driver supports both the AD5398 and the AD5821.  It adapts into the
> voltage and current framework.  The generic userspace-consumer and virtual

Might be useful to put something here saying what these chips do...

> consumer should be selected to access devices via this driver.

Please remove the comment about the userspace and virtual consumers from
the driver, the driver should support all consumer drivers and the use
of userspace consumers will normally be very unusual.

> +static int ad5398_get(struct regulator_dev *rdev)
> +{
> +	struct ad5398_chip_info *chip = rdev_get_drvdata(rdev);
> +	struct i2c_client *client = chip->client;
> +	unsigned short data;
> +	int ret;
> +
> +	ret = i2c_master_recv(client, (char *)&data, 2);
> +	if (ret < 0) {
> +		dev_err(&client->dev, "I2C read error\n");
> +		return ret;
> +	}

I strongly suggest implementing register I/O functions rather than open
coding with the I2C API each time.

> +
> +	ret = (be16_to_cpu(data) & chip->current_mask) >> chip->current_offset;
> +
> +	return ad5398_calc_current(chip, ret);

This function should really have a much clearer name than just plain
_get() - it looks like it's intended to read the current limit.

> +static int ad5398_set(struct regulator_dev *rdev, int min_uA, int max_uA)
> +{

Same here - this should have a much clearer name saying what's being
set.

> +	/* prepare register data */
> +	selector = (selector << chip->current_offset) & chip->current_mask;
> +	selector |= (data & CURRENT_EN_MASK);

This CURRENT_EN_MASK configuration looks fishy, what does that setting
do and why is it being unconditionally set?

> +static struct regulator_ops ad5398_ops = {
> +	.get_current_limit = ad5398_get,
> +	.set_current_limit = ad5398_set,
> +	.enable = ad5398_enable,
> +	.disable = ad5398_disable,
> +	.is_enabled = ad5398_is_enabled,
> +	.set_suspend_enable = ad5398_enable,
> +	.set_suspend_disable = ad5398_disable,

If the chip does not have suspend mode configuration it should not
supply any suspend mode configuration functions.

> +	i2c_set_clientdata(client, chip);
> +	dev_info(&client->dev, "%s regulator driver loaded\n", id->name);

Remove this or tone it down to a debug level print.

> +static int ad5398_remove(struct i2c_client *client)
> +{
> +	struct ad5398_chip_info *chip = i2c_get_clientdata(client);
> +
> +	if (chip) {
> +		regulator_unregister(&chip->rdev);
> +		kfree(chip);
> +	}

If you failed to register the regulator you should've failed the probe
and therefore this check for chip should not be required.

> +#define CURRENT_EN_MASK		0x8000
> +#define CURRENT_BITS_MAX	16

These defines should be namespaced.

> +/**
> + * ad5398_platform_data - platform data for ad5398
> + * @current_bits: effective bits in register
> + * @current_offset: offset of effective bits in register
> + * @ad5398_init_data: regulator init data
> + */
> +struct ad5398_platform_data {
> +	unsigned short current_bits;
> +	unsigned short current_offset;
> +	struct regulator_init_data *regulator_data;
> +};

Why are the current bits and offset being suppied as platform data?  I
would *very* strongly expect that the location of the control in the
register will be fixed by the device type and should therefore be
figured out by the driver.  Having the machine specifying this seems
redundant and error prone.
