Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761138Ab2DKTxu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 15:53:50 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:39025 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761089Ab2DKTxq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 15:53:46 -0400
Date: Wed, 11 Apr 2012 22:55:40 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: jic23@cam.ac.uk, gregkh@linuxfoundation.org, grant.likely@secretlab.ca,
        rob.herring@calxeda.com, jbrenner@taosinc.com, rklein@nvidia.com,
        max@stro.at, linux-iio@vger.kernel.org, devel@driverdev.osuosl.org,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V1 1/2] staging: iio: add driver for isl29028
Message-ID: <20120411195503.GD5589@mwanda>
References: <1334165284-11326-1-git-send-email-ldewangan@nvidia.com>
 <1334165284-11326-2-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1334165284-11326-2-git-send-email-ldewangan@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-CT-RefId: str=0001.0A090207.4F85E135.003E,ss=1,re=-2.300,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 11, 2012 at 10:58:03PM +0530, Laxman Dewangan wrote:
> Intersil's ISL29028 is concurrent Ambient Light and
> Proximity Sensor device.
> Add driver to access the light and IR intensity and
> proximity value via iio interface.
> 
> Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
> ---
>  drivers/staging/iio/light/Kconfig    |   10 +
>  drivers/staging/iio/light/Makefile   |    1 +
>  drivers/staging/iio/light/isl29028.c |  538 ++++++++++++++++++++++++++++++++++
>  3 files changed, 549 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/staging/iio/light/isl29028.c
> 
> diff --git a/drivers/staging/iio/light/Kconfig b/drivers/staging/iio/light/Kconfig
> index e7e9159..53b49f7 100644
> --- a/drivers/staging/iio/light/Kconfig
> +++ b/drivers/staging/iio/light/Kconfig
> @@ -14,6 +14,16 @@ config SENSORS_ISL29018
>           in lux, proximity infrared sensing and normal infrared sensing.
>           Data from sensor is accessible via sysfs.
>  
> +config SENSORS_ISL29028
> +	tristate "Intersil ISL29028 Concurrent Light and Proximity Sensor"
> +	depends on I2C
> +	select REGMAP_I2C
> +	help
> +	 Provides driver for the Intersil's ISL29028 device.
> +	 This driver supports the sysfs interface to get the ALS, IR intensity,
> +	 Proximity value via iio. The ISL29028 provides the concurrent sensing
> +	 of ambient light and proximity.
> +
>  config SENSORS_TSL2563
>  	tristate "TAOS TSL2560, TSL2561, TSL2562 and TSL2563 ambient light sensors"
>  	depends on I2C
> diff --git a/drivers/staging/iio/light/Makefile b/drivers/staging/iio/light/Makefile
> index 3011fbf..535d313 100644
> --- a/drivers/staging/iio/light/Makefile
> +++ b/drivers/staging/iio/light/Makefile
> @@ -4,4 +4,5 @@
>  
>  obj-$(CONFIG_SENSORS_TSL2563)	+= tsl2563.o
>  obj-$(CONFIG_SENSORS_ISL29018)	+= isl29018.o
> +obj-$(CONFIG_SENSORS_ISL29028)	+= isl29028.o
>  obj-$(CONFIG_TSL2583)	+= tsl2583.o
> diff --git a/drivers/staging/iio/light/isl29028.c b/drivers/staging/iio/light/isl29028.c
> new file mode 100644
> index 0000000..ccd1f7c
> --- /dev/null
> +++ b/drivers/staging/iio/light/isl29028.c
> @@ -0,0 +1,538 @@
> +/*
> + * A iio driver for the light sensor ISL29028.
> + * ISL29028 is Concurrent Ambient Light and Proximity Sensor
> + *
> + * Copyright (c) 2012, NVIDIA CORPORATION.  All rights reserved.
> + *
> + * This program is free software; you can redistribute it and/or modify it
> + * under the terms and conditions of the GNU General Public License,
> + * version 2, as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope it will be useful, but WITHOUT
> + * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
> + * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
> + * more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program.  If not, see <http://www.gnu.org/licenses/>.
> + */
> +
> +#include <linux/module.h>
> +#include <linux/i2c.h>
> +#include <linux/err.h>
> +#include <linux/mutex.h>
> +#include <linux/delay.h>
> +#include <linux/slab.h>
> +#include <linux/regmap.h>
> +#include "../iio.h"
> +#include "../sysfs.h"
> +
> +#define CONVERSION_TIME_MS		100
> +
> +#define ISL29028_REG_CONFIGURE		0x01
> +
> +#define CONFIGURE_ALS_IR_MODE_ALS	0
> +#define CONFIGURE_ALS_IR_MODE_IR	BIT(0)
> +#define CONFIGURE_ALS_IR_MODE_MASK	BIT(0)
> +
> +#define CONFIGURE_ALS_RANGE_LOW_LUX	0
> +#define CONFIGURE_ALS_RANGE_HIGH_LUX	BIT(1)
> +#define CONFIGURE_ALS_RANGE_MASK	BIT(1)
> +
> +#define CONFIGURE_ALS_DIS		0
> +#define CONFIGURE_ALS_EN		BIT(2)
> +#define CONFIGURE_ALS_EN_MASK		BIT(2)
> +
> +#define CONFIGURE_PROX_DRIVE		BIT(3)
> +
> +#define CONFIGURE_PROX_SLP_SH		4
> +#define CONFIGURE_PROX_SLP_MASK		(7 << CONFIGURE_PROX_SLP_SH)
> +
> +#define CONFIGURE_PROX_EN		BIT(7)
> +#define CONFIGURE_PROX_EN_MASK		BIT(7)
> +
> +#define ISL29028_REG_INTERRUPT		0x02
> +
> +#define ISL29028_REG_PROX_DATA		0x08
> +#define ISL29028_REG_ALSIR_L		0x09
> +#define ISL29028_REG_ALSIR_U		0x0A
> +
> +#define ISL29028_REG_TEST1_MODE		0x0E
> +#define ISL29028_REG_TEST2_MODE		0x0F
> +
> +#define ISL29028_MAX_REGS		(ISL29028_REG_TEST2_MODE + 1)
> +
> +enum als_ir_mode {
> +	MODE_NONE = 0,
> +	MODE_ALS,
> +	MODE_IR
> +};
> +
> +struct isl29028_chip {
> +	struct device		*dev;
> +	struct mutex		lock;
> +
> +	int			prox_period;
> +	bool			enable_prox;
> +
> +	int			lux_scale;
> +	int			als_ir_mode;
> +
> +	struct regmap		*regmap;
> +};
> +
> +static int isl29028_set_proxim_period(struct isl29028_chip *chip, int period)
> +{
> +	static int prox_period[] = {800, 400, 200, 100, 75, 50, 12, 0};
> +	int sel;
> +
> +	for (sel = 0; sel < ARRAY_SIZE(prox_period); ++sel) {
> +		if (period >= prox_period[sel])
> +			break;
> +	}

We allow the user to pass negative numbers here so it's possible to
make it through the for loop without hitting the break statement.
Probably we should make "period" unsigned.

> +	return regmap_update_bits(chip->regmap, ISL29028_REG_CONFIGURE,
> +			CONFIGURE_PROX_SLP_MASK, sel << CONFIGURE_PROX_SLP_SH);
> +}
> +
> +static int isl29028_enable_proximity(struct isl29028_chip *chip, bool enable)
> +{
> +	int ret;
> +	int val = 0;

Leave a blank line between declarations and code.

> +	if (enable)
> +		val = CONFIGURE_PROX_EN;
> +	ret = regmap_update_bits(chip->regmap, ISL29028_REG_CONFIGURE,
> +			CONFIGURE_PROX_EN_MASK, val);
> +
> +	/* Wait for conversion to be complete for first sample */
> +	if (!ret && chip->prox_period)
> +		mdelay(chip->prox_period);
> +	return ret;
> +}
> +
> +static int isl29028_set_als_range(struct isl29028_chip *chip, int lux_scale)
> +{
> +	int val = (lux_scale == 2000) ? CONFIGURE_ALS_RANGE_HIGH_LUX :
> +					CONFIGURE_ALS_RANGE_LOW_LUX;
> +
> +	return regmap_update_bits(chip->regmap, ISL29028_REG_CONFIGURE,
> +		CONFIGURE_ALS_RANGE_MASK, val);
> +}
> +
> +static int isl29028_set_als_ir_mode(struct isl29028_chip *chip,
> +	enum als_ir_mode mode)
> +{
> +	int ret = 0;

Blank line here.

> +	switch (mode) {
> +	case MODE_ALS:
> +		ret = regmap_update_bits(chip->regmap, ISL29028_REG_CONFIGURE,
> +			CONFIGURE_ALS_IR_MODE_MASK, CONFIGURE_ALS_IR_MODE_ALS);
> +		if (!ret)
> +			ret = regmap_update_bits(chip->regmap,
> +				ISL29028_REG_CONFIGURE,
> +				CONFIGURE_ALS_RANGE_MASK,
> +				CONFIGURE_ALS_RANGE_HIGH_LUX);

Could you go through the whole file and change all the places where
you test for success to tests for failure?

		if (ret)
			return ret;

It's more readable to handle failures as close to the call site as
possible.  It often lets you pull the code in one indent level.  In
this function we put an "if (!ret) ..." in front of almost every
line.

> +		break;
> +	case MODE_IR:
> +		ret = regmap_update_bits(chip->regmap, ISL29028_REG_CONFIGURE,
> +			CONFIGURE_ALS_IR_MODE_MASK, CONFIGURE_ALS_IR_MODE_IR);
> +		break;
> +
> +	case MODE_NONE:
> +		return regmap_update_bits(chip->regmap, ISL29028_REG_CONFIGURE,
> +			CONFIGURE_ALS_EN_MASK, CONFIGURE_ALS_DIS);
> +	}
> +
> +	/* Enable the ALS/IR */
> +	if (!ret)
> +		ret = regmap_update_bits(chip->regmap, ISL29028_REG_CONFIGURE,
> +				CONFIGURE_ALS_EN_MASK, CONFIGURE_ALS_EN);
> +
> +	/* Need to wait for conversion time if ALS/IR mode enabled */
> +	if (!ret)
> +		mdelay(CONVERSION_TIME_MS);
> +
> +	return ret;
> +}
> +
> +static int isl29028_read_als_ir(struct isl29028_chip *chip, int *als_ir)
> +{
> +	unsigned int lsb;
> +	unsigned int msb;
> +	int ret;
> +
> +	ret = regmap_read(chip->regmap, ISL29028_REG_ALSIR_L, &lsb);
> +	if (!ret)
> +		ret = regmap_read(chip->regmap, ISL29028_REG_ALSIR_U, &msb);
> +
> +	if (ret < 0)
> +		dev_err(chip->dev,
> +			"Error in reading register ALSIR_x err %d\n", ret);
> +	else
> +		*als_ir = ((msb & 0xF) << 8) | (lsb & 0xFF);
> +	return ret;
> +}
> +
> +static int isl29028_read_proxim(struct isl29028_chip *chip, int *prox)
> +{
> +	unsigned int data;
> +	int ret;

Blank line.

> +	ret = regmap_read(chip->regmap, ISL29028_REG_PROX_DATA, &data);
> +	if (ret < 0)
> +		dev_err(chip->dev, "Error in reading register %d, error %d\n",
> +				ISL29028_REG_PROX_DATA, ret);
> +	else
> +		*prox = (int)data;
                        ^^^^^
This cast isn't needed.  It's automatic.

> +	return ret;
> +}
> +
> +static int isl29028_proxim_get(struct isl29028_chip *chip, int *prox_data)
> +{
> +	int ret = 0;
               ^^^^
Remove this initialization.

> +
> +	if (!chip->enable_prox) {
> +		ret = isl29028_enable_proximity(chip, true);
> +		if (ret < 0)
> +			return ret;
> +		chip->enable_prox = true;
> +	}
> +	return isl29028_read_proxim(chip, prox_data);
> +}
> +
> +static int isl29028_als_get(struct isl29028_chip *chip, int *als_data)
> +{
> +	int ret = 0;
            ^^^^^^^
Not needed.

> +	int als_ir_data;
> +
> +	if (chip->als_ir_mode != MODE_ALS) {
> +		ret = isl29028_set_als_ir_mode(chip, MODE_ALS);
> +		if (ret < 0) {
> +			dev_err(chip->dev,
> +				"Error in enabling ALS mode err %d\n", ret);
> +			return ret;
> +		}
> +		chip->als_ir_mode = MODE_ALS;
> +	}
> +
> +	ret = isl29028_read_als_ir(chip, &als_ir_data);
> +	if (!ret) {
> +		/*
> +		 * convert als data count to lux.
> +		 * if lux_scale = 125,  lux = count * 0.031
> +		 * if lux_scale = 2000, lux = count * 0.49
> +		 */
> +		if (chip->lux_scale == 125)
> +			als_ir_data = (als_ir_data * 31) / 1000;
> +		else
> +			als_ir_data = (als_ir_data * 49) / 100;
> +
> +		*als_data = als_ir_data;
> +	}
> +	return ret;
> +}
> +
> +static int isl29028_ir_get(struct isl29028_chip *chip, int *ir_data)
> +{
> +	int ret;

Blank line.

> +	if (chip->als_ir_mode != MODE_IR) {
> +		ret = isl29028_set_als_ir_mode(chip, MODE_IR);
> +		if (ret < 0) {
> +			dev_err(chip->dev,
> +				"Error in enabling IR mode err %d\n", ret);
> +			return ret;
> +		}
> +		chip->als_ir_mode = MODE_IR;
> +	}
> +	return isl29028_read_als_ir(chip, ir_data);
> +}
> +
> +/* Sysfs interface */
> +/* proximity period  */
> +static ssize_t show_prox_period(struct device *dev,
> +	struct device_attribute *attr, char *buf)
> +{
> +	struct iio_dev *indio_dev = dev_get_drvdata(dev);
> +	struct isl29028_chip *chip = iio_priv(indio_dev);
> +	return sprintf(buf, "%d\n", chip->prox_period);
> +}
> +
> +static ssize_t store_prox_period(struct device *dev,
> +		struct device_attribute *attr, const char *buf, size_t count)
> +{
> +	struct iio_dev *indio_dev = dev_get_drvdata(dev);
> +	struct isl29028_chip *chip = iio_priv(indio_dev);
> +	unsigned long lval;
> +	int ret;
> +
> +	if (kstrtoul(buf, 10, &lval))
> +		return -EINVAL;


	Instead of passing an unsigned long we could pass an int or
	and unsigned int.

	int lval;

	ret = kstrtoint(buf, 10, &lval);
	if (ret)
		return ret;
	if (lval < 0 || lval > 800)
		return -EINVAL;

Except 800 should probably be a define or something.  Otherwise if
the user puts in the wrong value by mistake it could lead to a long
mdelay().

> +
> +	mutex_lock(&chip->lock);
> +	ret = isl29028_set_proxim_period(chip, (int)lval);
                                               ^^^^^
This cast isn't needed.  Also we should make period unsigned.

> +	if (!ret) {
> +		chip->prox_period = (int)lval;
                                    ^^^^^
Unneeded cast.
> +		ret = count;
> +	} else {
> +		dev_err(dev, "Error in setting the proximity period\n");
> +	}
> +	mutex_unlock(&chip->lock);
> +	return ret;
> +}
> +
> +static ssize_t show_range(struct device *dev,
> +	struct device_attribute *attr, char *buf)
> +{
> +	struct iio_dev *indio_dev = dev_get_drvdata(dev);
> +	struct isl29028_chip *chip = iio_priv(indio_dev);
> +	return sprintf(buf, "%d\n", chip->lux_scale);
> +}
> +
> +static ssize_t store_range(struct device *dev,
> +		struct device_attribute *attr, const char *buf, size_t count)
> +{
> +	struct iio_dev *indio_dev = dev_get_drvdata(dev);
> +	struct isl29028_chip *chip = iio_priv(indio_dev);
> +	unsigned long lval;
> +	int ret;
> +
> +	if (kstrtoul(buf, 10, &lval))
> +		return -EINVAL;

	ret = kstrtoul(buf, 10, &lval);
	if (ret)
		return ret;

> +
> +	if ((lval != 125) && (lval != 2000)) {
> +		dev_err(dev, "Invalid range %lu\n", lval);
> +		return -EINVAL;
> +	}
> +
> +	mutex_lock(&chip->lock);
> +	ret = isl29028_set_als_range(chip, (int)lval);
                                           ^^^^^
Unneeded cast.

> +	if (!ret) {
> +		chip->lux_scale = (int)lval;
                                  ^^^^^
Unneeded cast.
> +		ret = count;
> +	} else {
> +		dev_err(dev, "Error in setting the range\n");
> +	}
> +
> +	mutex_unlock(&chip->lock);
> +	return ret;
> +}
> +
> +/* Channel IO */
> +static int isl29028_read_raw(struct iio_dev *indio_dev,
> +	     struct iio_chan_spec const *chan, int *val, int *val2, long mask)
> +{
> +	int ret = -EINVAL;
> +	struct isl29028_chip *chip = iio_priv(indio_dev);
> +
> +	mutex_lock(&chip->lock);
> +	switch (mask) {
> +	case 0:
> +		switch (chan->type) {
> +		case IIO_LIGHT:
> +			ret = isl29028_als_get(chip, val);
> +			break;
> +		case IIO_INTENSITY:
> +			ret = isl29028_ir_get(chip, val);
> +			break;
> +		case IIO_PROXIMITY:
> +			ret = isl29028_proxim_get(chip, val);
> +			break;
> +		default:
> +			break;
> +		}
> +		if (!ret)
> +			ret = IIO_VAL_INT;
> +		break;
> +
> +	default:
> +		break;
> +	}
> +	mutex_unlock(&chip->lock);
> +	return ret;
> +}
> +
> +
> +static IIO_DEVICE_ATTR(proximity_sampling_period, S_IRUGO | S_IWUSR,
> +				show_prox_period, store_prox_period, 0);
> +static IIO_CONST_ATTR(proximity_sampling_period_available,
> +				"800, 400, 200, 100, 75, 50, 12, 0");
> +
> +static IIO_DEVICE_ATTR(range, S_IRUGO | S_IWUSR,
> +				show_range, store_range, 0);
> +static IIO_CONST_ATTR(range_available, "125, 2000");
> +
> +#define ISL29028_DEV_ATTR(name) (&iio_dev_attr_##name.dev_attr.attr)
> +#define ISL29028_CONST_ATTR(name) (&iio_const_attr_##name.dev_attr.attr)
> +static struct attribute *isl29028_attributes[] = {
> +	ISL29028_DEV_ATTR(proximity_sampling_period),
> +	ISL29028_CONST_ATTR(proximity_sampling_period_available),
> +	ISL29028_DEV_ATTR(range),
> +	ISL29028_CONST_ATTR(range_available),
> +	NULL,
> +};
> +
> +static const struct attribute_group isl29108_group = {
> +	.attrs = isl29028_attributes,
> +};
> +
> +static const struct iio_chan_spec isl29028_channels[] = {
> +	{
> +		.type = IIO_LIGHT,
> +		.processed_val = 1,
> +	}, {
> +		.type = IIO_INTENSITY,
> +	}, {
> +		.type = IIO_PROXIMITY,
> +	}
> +};
> +
> +static const struct iio_info isl29028_info = {
> +	.attrs = &isl29108_group,
> +	.driver_module = THIS_MODULE,
> +	.read_raw = &isl29028_read_raw,
> +};
> +
> +static int isl29028_chip_init(struct isl29028_chip *chip)
> +{
> +	int ret;
> +
> +	chip->enable_prox  = false;
> +	chip->prox_period = 50;
> +	chip->lux_scale = 2000;
> +	chip->als_ir_mode = MODE_NONE;
> +
> +	ret = regmap_write(chip->regmap, ISL29028_REG_TEST1_MODE, 0x0);
> +	if (ret < 0) {
> +		dev_err(chip->dev, "%s(): write to reg %d failed, err = %d\n",
> +			__func__, ISL29028_REG_TEST1_MODE, ret);
> +		return ret;
> +	}
> +	ret = regmap_write(chip->regmap, ISL29028_REG_TEST2_MODE, 0x0);
> +	if (ret < 0) {
> +		dev_err(chip->dev, "%s(): write to reg %d failed, err = %d\n",
> +			__func__, ISL29028_REG_TEST2_MODE, ret);
> +		return ret;
> +	}
> +
> +	ret = regmap_write(chip->regmap, ISL29028_REG_CONFIGURE, 0x0);
> +	if (ret < 0) {
> +		dev_err(chip->dev, "%s(): write to reg %d failed, err = %d\n",
> +			__func__, ISL29028_REG_CONFIGURE, ret);
> +		return ret;
> +	}
> +
> +	ret = isl29028_set_als_range(chip, chip->lux_scale);
> +	if (ret < 0)
> +		dev_err(chip->dev, "%s(): setting als range failed, err = %d\n",
> +			__func__, ret);
> +	return ret;
> +}
> +
> +static bool is_volatile_reg(struct device *dev, unsigned int reg)
> +{
> +	switch (reg) {
> +	case ISL29028_REG_INTERRUPT:
> +	case ISL29028_REG_PROX_DATA:
> +	case ISL29028_REG_ALSIR_L:
> +	case ISL29028_REG_ALSIR_U:
> +		return true;
> +	default:
> +		return false;
> +	}
> +}
> +
> +static const struct regmap_config isl29028_regmap_config = {
> +	.reg_bits = 8,
> +	.val_bits = 8,
> +	.volatile_reg = is_volatile_reg,
> +	.max_register = ISL29028_MAX_REGS,
> +	.num_reg_defaults_raw = ISL29028_MAX_REGS,
> +	.cache_type = REGCACHE_RBTREE,
> +};
> +
> +static int __devinit isl29028_probe(struct i2c_client *client,
> +	const struct i2c_device_id *id)
> +{
> +	struct isl29028_chip *chip;
> +	struct iio_dev *indio_dev;
> +	int ret;
> +
> +	indio_dev = iio_allocate_device(sizeof(*chip));
> +	if (!indio_dev) {
> +		dev_err(&client->dev, "iio allocation fails\n");
> +		return -ENOMEM;
> +	}
> +
> +	chip = iio_priv(indio_dev);
> +
> +	i2c_set_clientdata(client, indio_dev);
> +	chip->dev = &client->dev;
> +	mutex_init(&chip->lock);
> +
> +	chip->regmap = devm_regmap_init_i2c(client, &isl29028_regmap_config);
> +	if (IS_ERR(chip->regmap)) {
> +		ret = PTR_ERR(chip->regmap);
> +		dev_err(chip->dev, "regmap initialization failed: %d\n", ret);
> +		goto exit_iio_free;
> +	}
> +
> +	ret = isl29028_chip_init(chip);
> +	if (ret < 0) {
> +		dev_err(chip->dev, "chip initialization failed: %d\n", ret);
> +		goto exit_iio_free;
> +	}
> +
> +	indio_dev->info = &isl29028_info;
> +	indio_dev->channels = isl29028_channels;
> +	indio_dev->num_channels = ARRAY_SIZE(isl29028_channels);
> +	indio_dev->name = id->name;
> +	indio_dev->dev.parent = &client->dev;
> +	indio_dev->modes = INDIO_DIRECT_MODE;
> +	ret = iio_device_register(indio_dev);
> +	if (ret < 0) {
> +		dev_err(chip->dev, "iio registration fails\n");
> +		goto exit_iio_free;
> +	}
> +	return 0;
> +
> +exit_iio_free:
> +	iio_free_device(indio_dev);
> +	return ret;
> +}
> +
> +static int __devexit isl29028_remove(struct i2c_client *client)
> +{
> +	struct iio_dev *indio_dev = i2c_get_clientdata(client);
> +
> +	iio_device_unregister(indio_dev);
> +	iio_free_device(indio_dev);
> +	return 0;
> +}
> +
> +static const struct i2c_device_id isl29028_id[] = {
> +	{"isl29028", 0},
> +	{}
> +};
> +MODULE_DEVICE_TABLE(i2c, isl29028_id);
> +
> +static const struct of_device_id isl29028_of_match[] = {
> +	{ .compatible = "isl,isl29028", },
> +	{ },
> +};
> +MODULE_DEVICE_TABLE(of, isl29028_of_match);
> +
> +static struct i2c_driver isl29028_driver = {
> +	.class	= I2C_CLASS_HWMON,
> +	.driver  = {
> +		.name = "isl29028",
> +		.owner = THIS_MODULE,
> +		.of_match_table = isl29028_of_match,
> +	},
> +	.probe	 = isl29028_probe,
> +	.remove  = __devexit_p(isl29028_remove),
> +	.id_table = isl29028_id,
> +};
> +
> +module_i2c_driver(isl29028_driver);
> +
> +MODULE_DESCRIPTION("ISL29028 Ambient Light and Proximity Sensor driver");
> +MODULE_LICENSE("GPL v2");
> +MODULE_AUTHOR("Laxman Dewangan <ldewangan@nvidia.com>");
> -- 
> 1.7.1.1
> 
> _______________________________________________
> devel mailing list
> devel@linuxdriverproject.org
> http://driverdev.linuxdriverproject.org/mailman/listinfo/devel
