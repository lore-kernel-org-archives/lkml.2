Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756049Ab1KQUY2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 15:24:28 -0500
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:60380 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754410Ab1KQUY0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 15:24:26 -0500
Message-ID: <4EC56D7B.9080700@kernel.org>
Date: Thu, 17 Nov 2011 20:24:27 +0000
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111108 Thunderbird/8.0
MIME-Version: 1.0
To: Lars-Peter Clausen <lars@metafoo.de>
CC: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        Michael Hennerich <michael.hennerich@analog.com>,
        linux-kernel@vger.kernel.org, linux-iio@vger.kernel.org,
        device-drivers-devel@blackfin.uclinux.org, drivers@analog.com
Subject: Re: [PATCH 7/7] staging:iio:dac: Add AD5380 driver
References: <1321457302-8724-1-git-send-email-lars@metafoo.de> <1321457302-8724-7-git-send-email-lars@metafoo.de>
In-Reply-To: <1321457302-8724-7-git-send-email-lars@metafoo.de>
X-Enigmail-Version: 1.3.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/16/2011 03:28 PM, Lars-Peter Clausen wrote:
> This patch adds support for the Analog Devices D5380, AD5381,
> AD5382, AD5383, AD5384, AD5390, AD5391, AD5392 multi-channel
> Digital to Analog Converters.
> 
> Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
> 
> ---
> There should be no compile time dependencies to the regmap patches earlier in
> this series, so this patch can be merged independently of it.
Should probably have been a separate series!  Doesn't matter for review
though and I guess you justified some of the other patches with it.
> ---
>  drivers/staging/iio/dac/Kconfig  |   11 +
>  drivers/staging/iio/dac/Makefile |    1 +
>  drivers/staging/iio/dac/ad5380.c |  669 ++++++++++++++++++++++++++++++++++++++
>  3 files changed, 681 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/staging/iio/dac/ad5380.c
> 
> diff --git a/drivers/staging/iio/dac/Kconfig b/drivers/staging/iio/dac/Kconfig
> index a71defb..aaa6d46 100644
> --- a/drivers/staging/iio/dac/Kconfig
> +++ b/drivers/staging/iio/dac/Kconfig
> @@ -24,6 +24,17 @@ config AD5360
>  	  To compile this driver as module choose M here: the module will be called
>  	  ad5360.
>  
> +config AD5380
> +	tristate "Analog Devices AD5380/81/82/83/84/90/91/92 DAC driver"
> +	depends on (SPI_MASTER || I2C)
> +	help
> +	  Say yes here to build support for Analog Devices AD5380, AD5381,
> +	  AD5382, AD5383, AD5384, AD5390, AD5391, AD5392 multi-channel
> +	  Digital to Analog Converters (DAC).
> +
> +	  To compile this driver as module choose M here: the module will be called
> +	  ad5380.
> +
>  config AD5421
>  	tristate "Analog Devices AD5421 DAC driver"
>  	depends on SPI
> diff --git a/drivers/staging/iio/dac/Makefile b/drivers/staging/iio/dac/Makefile
> index e75b0c8..840e94e 100644
> --- a/drivers/staging/iio/dac/Makefile
> +++ b/drivers/staging/iio/dac/Makefile
> @@ -3,6 +3,7 @@
>  #
>  
>  obj-$(CONFIG_AD5360) += ad5360.o
> +obj-$(CONFIG_AD5380) += ad5380.o
>  obj-$(CONFIG_AD5421) += ad5421.o
>  obj-$(CONFIG_AD5624R_SPI) += ad5624r_spi.o
>  obj-$(CONFIG_AD5064) += ad5064.o
> diff --git a/drivers/staging/iio/dac/ad5380.c b/drivers/staging/iio/dac/ad5380.c
> new file mode 100644
> index 0000000..0d5536a
> --- /dev/null
> +++ b/drivers/staging/iio/dac/ad5380.c
> @@ -0,0 +1,669 @@
> +/*
> + * Analog devices AD5380, AD5381, AD5382, AD5383, AD5370, AD5371, AD5373
> + * multi-channel Digital to Analog Converters driver
> + *
> + * Copyright 2011 Analog Devices Inc.
> + *
> + * Licensed under the GPL-2.
> + */
> +
> +#include <linux/device.h>
> +#include <linux/err.h>
> +#include <linux/i2c.h>
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/spi/spi.h>
> +#include <linux/slab.h>
> +#include <linux/sysfs.h>
> +#include <linux/regmap.h>
> +#include <linux/regulator/consumer.h>
> +
> +#include "../iio.h"
> +#include "../sysfs.h"
> +#include "dac.h"
> +
> +
> +#define AD5380_REG_DATA(x)	(((x) << 2) | 3)
> +#define AD5380_REG_OFFSET(x)	(((x) << 2) | 2)
> +#define AD5380_REG_GAIN(x)	(((x) << 2) | 1)
> +#define AD5380_REG_SF_PWR_DOWN	(8 << 2)
> +#define AD5380_REG_SF_PWR_UP	(9 << 2)
> +#define AD5380_REG_SF_CTRL	(12 << 2)
> +
Could make this a bit as well... (then as follows where it is used)
> +#define AD5380_CTRL_PWR_DOWN_MODE_OFFSET	13
> +#define AD5380_CTRL_INT_VREF_2V5		BIT(12)
> +#define AD5380_CTRL_INT_VREF_EN			BIT(10)
> +
> +/**
> + * struct ad5380_chip_info - chip specific information
> + * @channel_template:	channel specification template
> + * @num_channels:	number of channels
> + * @int_vref:		internal vref in uV
> +*/
> +
> +struct ad5380_chip_info {
> +	struct iio_chan_spec	channel_template;
> +	unsigned int		num_channels;
> +	unsigned int		int_vref;
> +};
> +
> +/**
> + * struct ad5380_state - driver instance specific data
> + * @regmap:		regmap instance used by the device
> + * @chip_info:		chip model specific constants, available modes etc
> + * @vref_reg:		vref supply regulator
> + * @vref:		actual reference voltage used in uA
> + * @pwr_down:		whether the chip is currently in power down mode
> + */
> +
> +struct ad5380_state {
> +	struct regmap			*regmap;
> +	const struct ad5380_chip_info	*chip_info;
> +	struct regulator		*vref_reg;
> +	int				vref;
> +	bool				pwr_down;
> +};
> +
> +enum ad5380_type {
> +	ID_AD5380_3,
> +	ID_AD5380_5,
> +	ID_AD5381_3,
> +	ID_AD5381_5,
> +	ID_AD5382_3,
> +	ID_AD5382_5,
> +	ID_AD5383_3,
> +	ID_AD5383_5,
> +	ID_AD5384_3,
> +	ID_AD5384_5,
> +	ID_AD5390_3,
> +	ID_AD5390_5,
> +	ID_AD5391_3,
> +	ID_AD5391_5,
> +	ID_AD5392_3,
> +	ID_AD5392_5,
> +};
> +
> +#define AD5380_CHANNEL(_bits) {					\
> +	.type = IIO_VOLTAGE,					\
> +	.indexed = 1,						\
> +	.output = 1,						\
> +	.info_mask = IIO_CHAN_INFO_SCALE_SHARED_BIT |		\
> +		IIO_CHAN_INFO_CALIBSCALE_SEPARATE_BIT |		\
> +		IIO_CHAN_INFO_CALIBBIAS_SEPARATE_BIT,		\
> +	.scan_type = IIO_ST('u', (_bits), 16, 14 - (_bits))	\
> +}
> +
> +static const struct ad5380_chip_info ad5380_chip_info_tbl[] = {
> +	[ID_AD5380_3] = {
> +		.channel_template = AD5380_CHANNEL(14),
> +		.num_channels = 40,
> +		.int_vref = 1250000,
> +	},
> +	[ID_AD5380_5] = {
> +		.channel_template = AD5380_CHANNEL(14),
> +		.num_channels = 40,
> +		.int_vref = 2500000,
> +	},
> +	[ID_AD5381_3] = {
> +		.channel_template = AD5380_CHANNEL(12),
> +		.num_channels = 16,
> +		.int_vref = 1250000,
> +	},
> +	[ID_AD5381_5] = {
> +		.channel_template = AD5380_CHANNEL(12),
> +		.num_channels = 16,
> +		.int_vref = 2500000,
> +	},
> +	[ID_AD5382_3] = {
> +		.channel_template = AD5380_CHANNEL(14),
> +		.num_channels = 32,
> +		.int_vref = 1250000,
> +	},
> +	[ID_AD5382_5] = {
> +		.channel_template = AD5380_CHANNEL(14),
> +		.num_channels = 32,
> +		.int_vref = 2500000,
> +	},
> +	[ID_AD5383_3] = {
> +		.channel_template = AD5380_CHANNEL(12),
> +		.num_channels = 32,
> +		.int_vref = 1250000,
> +	},
> +	[ID_AD5383_5] = {
> +		.channel_template = AD5380_CHANNEL(12),
> +		.num_channels = 32,
> +		.int_vref = 2500000,
> +	},
> +	[ID_AD5390_3] = {
> +		.channel_template = AD5380_CHANNEL(14),
> +		.num_channels = 16,
> +		.int_vref = 1250000,
> +	},
> +	[ID_AD5390_5] = {
> +		.channel_template = AD5380_CHANNEL(14),
> +		.num_channels = 16,
> +		.int_vref = 2500000,
> +	},
> +	[ID_AD5391_3] = {
> +		.channel_template = AD5380_CHANNEL(12),
> +		.num_channels = 16,
> +		.int_vref = 1250000,
> +	},
> +	[ID_AD5392_5] = {
> +		.channel_template = AD5380_CHANNEL(12),
> +		.num_channels = 16,
> +		.int_vref = 2500000,
> +	},
> +	[ID_AD5392_3] = {
> +		.channel_template = AD5380_CHANNEL(14),
> +		.num_channels = 8,
> +		.int_vref = 1250000,
> +	},
> +	[ID_AD5392_5] = {
> +		.channel_template = AD5380_CHANNEL(14),
> +		.num_channels = 8,
> +		.int_vref = 2500000,
> +	},
> +};
> +
> +static ssize_t ad5380_read_dac_powerdown(struct device *dev,
> +	struct device_attribute *attr, char *buf)
> +{
> +	struct iio_dev *indio_dev = dev_get_drvdata(dev);
> +	struct ad5380_state *st = iio_priv(indio_dev);
> +
> +	return sprintf(buf, "%d\n", st->pwr_down);
> +}
> +
> +static ssize_t ad5380_write_dac_powerdown(struct device *dev,
> +	struct device_attribute *attr, const char *buf, size_t len)
> +{
> +	struct iio_dev *indio_dev = dev_get_drvdata(dev);
> +	struct ad5380_state *st = iio_priv(indio_dev);
> +	bool pwr_down;
> +	int ret;
> +
> +	ret = strtobool(buf, &pwr_down);
> +	if (ret)
> +		return ret;
> +
> +	mutex_lock(&indio_dev->mlock);
> +
> +	if (pwr_down)
> +		ret = regmap_write(st->regmap, AD5380_REG_SF_PWR_DOWN, 0);
> +	else
> +		ret = regmap_write(st->regmap, AD5380_REG_SF_PWR_UP, 0);
> +
> +	st->pwr_down = pwr_down;
> +
> +	mutex_unlock(&indio_dev->mlock);
> +
> +	return ret ? ret : len;
> +}
> +
> +static IIO_DEVICE_ATTR(out_voltage_powerdown,
> +			S_IRUGO | S_IWUSR,
> +			ad5380_read_dac_powerdown,
> +			ad5380_write_dac_powerdown, 0);
> +
> +static const char ad5380_powerdown_modes[][15] = {
> +	[0]	= "100kohm_to_gnd",
> +	[1]	= "three_state",
> +};
> +
> +static ssize_t ad5380_read_powerdown_mode(struct device *dev,
> +	struct device_attribute *attr, char *buf)
> +{
> +	struct iio_dev *indio_dev = dev_get_drvdata(dev);
> +	struct ad5380_state *st = iio_priv(indio_dev);
> +	unsigned int mode;
> +	int ret;
> +
> +	ret = regmap_read(st->regmap, AD5380_REG_SF_CTRL, &mode);
> +	if (ret)
> +		return ret;
> +
This is the clunkiest change if you make it a bit, but not too bad.
mode = !!(mode & AD5380_CTRL_PWR_DOWN_MODE_BIT);
> +	mode = (mode >> AD5380_CTRL_PWR_DOWN_MODE_OFFSET) & 1;
> +
> +	return sprintf(buf, "%s\n",
> +		ad5380_powerdown_modes[mode]);
> +}
> +
> +static ssize_t ad5380_write_powerdown_mode(struct device *dev,
> +	struct device_attribute *attr, const char *buf, size_t len)
> +{
> +	struct iio_dev *indio_dev = dev_get_drvdata(dev);
> +	struct ad5380_state *st = iio_priv(indio_dev);
> +	unsigned int i;
> +	int ret;
> +
Excess brackets for that for loop I think
> +	for (i = 0; i < ARRAY_SIZE(ad5380_powerdown_modes); ++i) {
> +		if (sysfs_streq(buf, ad5380_powerdown_modes[i]))
> +			break;
> +	}
> +
> +	if (i == ARRAY_SIZE(ad5380_powerdown_modes))
> +		return -EINVAL;
> +
> +	ret = regmap_update_bits(st->regmap, AD5380_REG_SF_CTRL,
> +		1 << AD5380_CTRL_PWR_DOWN_MODE_OFFSET,
> +		i << AD5380_CTRL_PWR_DOWN_MODE_OFFSET);
Obviously both of these will be cleaner with it as a bit.
> +
> +	return ret ? ret : len;
> +}
> +
Not a comment on this driver, but we need to have a think about
whether these will ever want to be controlled via in kernel
interfaces and if so how the heck we are going to do it!
> +static IIO_DEVICE_ATTR(out_voltage_powerdown_mode,
> +			S_IRUGO | S_IWUSR,
> +			ad5380_read_powerdown_mode,
> +			ad5380_write_powerdown_mode, 0);
> +
> +static IIO_CONST_ATTR(out_voltage_powerdown_mode_available,
> +			"100kohm_to_gnd three_state");
> +
> +static struct attribute *ad5380_attributes[] = {
> +	&iio_dev_attr_out_voltage_powerdown.dev_attr.attr,
> +	&iio_dev_attr_out_voltage_powerdown_mode.dev_attr.attr,
> +	&iio_const_attr_out_voltage_powerdown_mode_available.dev_attr.attr,
> +	NULL,
> +};
> +
> +static const struct attribute_group ad5380_attribute_group = {
> +	.attrs = ad5380_attributes,
> +};
> +
> +static unsigned int ad5380_info_to_reg(struct iio_chan_spec const *chan,
> +	long info)
> +{
> +	switch (info) {
> +	case 0:
> +		return AD5380_REG_DATA(chan->address);
> +	case IIO_CHAN_INFO_CALIBBIAS:
> +		return AD5380_REG_OFFSET(chan->address);
> +	case IIO_CHAN_INFO_CALIBSCALE:
> +		return AD5380_REG_GAIN(chan->address);
> +	default:
> +		BUG();
> +		break;
> +	}
> +
> +	return 0;
> +}
> +
> +static int ad5380_write_raw(struct iio_dev *indio_dev,
> +	struct iio_chan_spec const *chan, int val, int val2, long info)
> +{
> +	const unsigned int max_val = (1 << chan->scan_type.realbits);
> +	struct ad5380_state *st = iio_priv(indio_dev);
> +
> +	switch (info) {
> +	case IIO_CHAN_INFO_CALIBBIAS:
> +		val += (1 << chan->scan_type.realbits) / 2;
> +	case 0:
> +	case IIO_CHAN_INFO_CALIBSCALE:
> +		if (val >= max_val || val < 0)
> +			return -EINVAL;
> +
This is a somewhat uggly structure, I'd write this stuff out longhand for
readability or move this stuff that is shared out of the switch and make
default return -EINVAL;  Bit longer probably, but easier to read.
> +		return regmap_write(st->regmap, ad5380_info_to_reg(chan, info),
> +			val << chan->scan_type.shift);
> +	default:
> +		break;
> +	}
> +
> +	return -EINVAL;
> +}
> +
> +static int ad5380_read_raw(struct iio_dev *indio_dev,
> +	struct iio_chan_spec const *chan, int *val, int *val2, long info)
> +{
> +	struct ad5380_state *st = iio_priv(indio_dev);
> +	unsigned long scale_uv;
> +	int ret;
> +
> +	switch (info) {
> +	case 0:
> +	case IIO_CHAN_INFO_CALIBBIAS:
> +	case IIO_CHAN_INFO_CALIBSCALE:
> +		ret = regmap_read(st->regmap, ad5380_info_to_reg(chan, info),
> +					val);
> +		if (ret)
> +			return ret;
> +
Again, I'd unwrap this.  Marginally longer that way but simpler flow.
> +		if (info == IIO_CHAN_INFO_CALIBSCALE)
> +			val -= (1 << chan->scan_type.realbits) / 2;
> +
> +		*val >>= chan->scan_type.shift;
> +
> +		return IIO_VAL_INT;
> +	case IIO_CHAN_INFO_SCALE:
> +		scale_uv = ((2 * st->vref) >> chan->scan_type.realbits) * 100;
> +		*val =  scale_uv / 100000;
> +		*val2 = (scale_uv % 100000) * 10;
> +		return IIO_VAL_INT_PLUS_MICRO;
> +	default:
> +		return -EINVAL;
> +	}
> +
> +	return IIO_VAL_INT;
> +}
> +
> +static const struct iio_info ad5380_info = {
> +	.read_raw = ad5380_read_raw,
> +	.write_raw = ad5380_write_raw,
> +	.attrs = &ad5380_attribute_group,
> +	.driver_module = THIS_MODULE,
> +};
> +
> +static int __devinit ad5380_alloc_channels(struct iio_dev *indio_dev)
> +{
> +	struct ad5380_state *st = iio_priv(indio_dev);
> +	struct iio_chan_spec *channels;
> +	unsigned int i;
> +
> +	channels = kcalloc(sizeof(struct iio_chan_spec),
> +			st->chip_info->num_channels, GFP_KERNEL);
> +
> +	if (!channels)
> +		return -ENOMEM;
> +
> +	for (i = 0; i < st->chip_info->num_channels; ++i) {
> +		channels[i] = st->chip_info->channel_template;
> +		channels[i].channel = i;
> +		channels[i].address = i;
> +	}
> +
> +	indio_dev->channels = channels;
> +
> +	return 0;
> +}
> +
> +static int __devinit ad5380_probe(struct device *dev, struct regmap *regmap,
> +	enum ad5380_type type, const char *name)
> +{
> +	struct iio_dev *indio_dev;
> +	struct ad5380_state *st;
> +	unsigned int ctrl = 0;
> +	int ret;
> +
> +	indio_dev = iio_allocate_device(sizeof(*st));
> +	if (indio_dev == NULL) {
> +		dev_err(dev, "Failed to allocate iio device\n");
> +		ret = -ENOMEM;
> +		goto error_regmap_exit;
> +	}
> +
> +	st = iio_priv(indio_dev);
> +	dev_set_drvdata(dev, indio_dev);
> +
> +	st->chip_info = &ad5380_chip_info_tbl[type];
> +	st->regmap = regmap;
> +
> +	indio_dev->dev.parent = dev;
> +	indio_dev->name = name;
> +	indio_dev->info = &ad5380_info;
> +	indio_dev->modes = INDIO_DIRECT_MODE;
> +	indio_dev->num_channels = st->chip_info->num_channels;
> +
> +	ret = ad5380_alloc_channels(indio_dev);
> +	if (ret) {
> +		dev_err(dev, "Failed to allocate channel spec: %d\n", ret);
> +		goto error_free;
> +	}
> +
> +	if (st->chip_info->int_vref == 2500000)
> +		ctrl |= AD5380_CTRL_INT_VREF_2V5;
> +
> +	st->vref_reg = regulator_get(dev, "vref");
> +	if (!IS_ERR(st->vref_reg)) {
> +		ret = regulator_enable(st->vref_reg);
> +		if (ret) {
Overly long line?
> +			dev_err(dev, "Failed to enable vref regulators: %d\n", ret);
> +			goto error_free_reg;
> +		}
> +
> +		st->vref = regulator_get_voltage(st->vref_reg);
> +	} else {
> +		st->vref = st->chip_info->int_vref;
> +		ctrl |= AD5380_CTRL_INT_VREF_EN;
> +	}
> +
> +	ret = regmap_write(st->regmap, AD5380_REG_SF_CTRL, ctrl);
> +	if (ret) {
This isn't exactly an informative message!  Perhaps drop it or
make it more useful.
> +		dev_err(dev, "Failed: %d\n", ret);
> +		goto error_disable_reg;
> +	}
> +
> +	ret = iio_device_register(indio_dev);
> +	if (ret) {
> +		dev_err(dev, "Failed to register iio device: %d\n", ret);
> +		goto error_disable_reg;
> +	}
> +
> +	return 0;
> +
> +error_disable_reg:
> +	if (!IS_ERR(st->vref_reg))
> +		regulator_disable(st->vref_reg);
> +error_free_reg:
> +	if (!IS_ERR(st->vref_reg))
> +		regulator_put(st->vref_reg);
> +
> +	kfree(indio_dev->channels);
> +error_free:
> +	iio_free_device(indio_dev);
> +error_regmap_exit:
> +	regmap_exit(regmap);
> +
> +	return ret;
> +}
> +
> +static int __devexit ad5380_remove(struct device *dev)
> +{
> +	struct iio_dev *indio_dev = dev_get_drvdata(dev);
> +	struct ad5380_state *st = iio_priv(indio_dev);
> +
> +	iio_device_unregister(indio_dev);
> +
> +	kfree(indio_dev->channels);
> +
> +	if (!IS_ERR(st->vref_reg)) {
> +		regulator_disable(st->vref_reg);
> +		regulator_put(st->vref_reg);
> +	}
> +
> +	iio_free_device(indio_dev);
> +	regmap_exit(st->regmap);
> +
> +	return 0;
> +}
> +
> +static bool ad5380_reg_false(struct device *dev, unsigned int reg)
> +{
> +	return false;
> +}
> +
> +static const struct regmap_config ad5380_regmap_config = {
> +	.reg_bits = 10,
> +	.val_bits = 14,
> +
> +	.max_register = AD5380_REG_DATA(40),
> +	.cache_type = REGCACHE_RBTREE,
> +
> +	.volatile_reg = ad5380_reg_false,
> +	.readable_reg = ad5380_reg_false,
> +};
> +
> +#if IS_ENABLED(CONFIG_SPI_MASTER)
> +
> +static int __devinit ad5380_spi_probe(struct spi_device *spi)
> +{
> +	const struct spi_device_id *id = spi_get_device_id(spi);
> +	struct regmap *regmap;
> +
> +	regmap = regmap_init_spi(spi, &ad5380_regmap_config);
> +
> +	if (IS_ERR(regmap))
> +		return PTR_ERR(regmap);
> +
> +	return ad5380_probe(&spi->dev, regmap,
> +		id->driver_data, id->name);
> +}
> +
> +static int __devexit ad5380_spi_remove(struct spi_device *spi)
> +{
> +	return ad5380_remove(&spi->dev);
> +}
> +
> +static const struct spi_device_id ad5380_spi_ids[] = {
> +	{ "ad5380-3", ID_AD5380_3 },
> +	{ "ad5380-5", ID_AD5380_5 },
> +	{ "ad5381-3", ID_AD5381_3 },
> +	{ "ad5381-5", ID_AD5381_5 },
> +	{ "ad5382-3", ID_AD5382_3 },
> +	{ "ad5382-5", ID_AD5382_5 },
> +	{ "ad5383-3", ID_AD5383_3 },
> +	{ "ad5383-5", ID_AD5383_5 },
> +	{ "ad5390-3", ID_AD5380_3 },
> +	{ "ad5390-5", ID_AD5380_5 },
> +	{ "ad5391-3", ID_AD5381_3 },
> +	{ "ad5391-5", ID_AD5381_5 },
> +	{ "ad5392-3", ID_AD5382_3 },
> +	{ "ad5392-5", ID_AD5382_5 },
as below, I'm guessing the id missmatch isn't intentional as
you defined the other ids.
> +	{ }
> +};
> +MODULE_DEVICE_TABLE(spi, ad5380_ids);
> +
> +static struct spi_driver ad5380_spi_driver = {
> +	.driver = {
> +		   .name = "ad5380",
> +		   .owner = THIS_MODULE,
> +	},
> +	.probe = ad5380_spi_probe,
> +	.remove = __devexit_p(ad5380_spi_remove),
> +	.id_table = ad5380_spi_ids,
> +};
> +
> +static inline int ad5380_spi_register_driver(void)
> +{
> +	return spi_register_driver(&ad5380_spi_driver);
> +}
> +
> +static inline void ad5380_spi_unregister_driver(void)
> +{
> +	spi_unregister_driver(&ad5380_spi_driver);
> +}
> +
> +#else
> +
> +static inline int ad5380_spi_register_driver(void)
> +{
> +	return 0;
> +}
> +
> +static inline void ad5380_spi_unregister_driver(void)
> +{
> +}
> +
> +#endif
> +
> +#if IS_ENABLED(CONFIG_I2C)
> +
> +static int __devinit ad5380_i2c_probe(struct i2c_client *i2c,
> +	const struct i2c_device_id *id)
> +{
> +	struct regmap *regmap;
> +
> +	regmap = regmap_init_i2c(i2c, &ad5380_regmap_config);
> +
> +	if (IS_ERR(regmap))
> +		return PTR_ERR(regmap);
> +
Looks like the following is sub 80 chars on one line?
> +	return ad5380_probe(&i2c->dev, regmap,
> +		id->driver_data, id->name);
> +}
> +
> +static int __devexit ad5380_i2c_remove(struct i2c_client *i2c)
> +{
> +	return ad5380_remove(&i2c->dev);
> +}
> +
> +static const struct i2c_device_id ad5380_i2c_ids[] = {
> +	{ "ad5380-3", ID_AD5380_3 },
> +	{ "ad5380-5", ID_AD5380_5 },
> +	{ "ad5381-3", ID_AD5381_3 },
> +	{ "ad5381-5", ID_AD5381_5 },
> +	{ "ad5382-3", ID_AD5382_3 },
> +	{ "ad5382-5", ID_AD5382_5 },
> +	{ "ad5383-3", ID_AD5383_3 },
> +	{ "ad5383-5", ID_AD5383_5 },
> +	{ "ad5390-3", ID_AD5380_3 },
> +	{ "ad5390-5", ID_AD5380_5 },
> +	{ "ad5391-3", ID_AD5381_3 },
> +	{ "ad5391-5", ID_AD5381_5 },
> +	{ "ad5392-3", ID_AD5382_3 },
> +	{ "ad5392-5", ID_AD5382_5 },
I'm guessing you defined the ID_AD5392 etc for a reason?
> +	{ }
> +};
> +MODULE_DEVICE_TABLE(i2c, ad5380_ids);
> +
> +static struct i2c_driver ad5380_i2c_driver = {
> +	.driver = {
> +		   .name = "ad5380",
> +		   .owner = THIS_MODULE,
> +	},
> +	.probe = ad5380_i2c_probe,
> +	.remove = __devexit_p(ad5380_i2c_remove),
> +	.id_table = ad5380_i2c_ids,
> +};
> +
> +static inline int ad5380_i2c_register_driver(void)
> +{
> +	return i2c_add_driver(&ad5380_i2c_driver);
> +}
> +
> +static inline void ad5380_i2c_unregister_driver(void)
> +{
> +	i2c_del_driver(&ad5380_i2c_driver);
> +}
> +
> +#else
> +
> +static inline int ad5380_i2c_register_driver(void)
> +{
> +	return 0;
> +}
> +
> +static inline void ad5380_i2c_unregister_driver(void)
> +{
> +}
> +
> +#endif
> +
> +static __init int ad5380_spi_init(void)
> +{
> +	int ret;
> +
> +	ret = ad5380_spi_register_driver();
> +	if (ret)
> +		return ret;
> +
> +	ret = ad5380_i2c_register_driver();
> +	if (ret) {
> +		ad5380_spi_unregister_driver();
> +		return ret;
> +	}
> +
> +	return 0;
> +}
> +module_init(ad5380_spi_init);
> +
> +static __exit void ad5380_spi_exit(void)
> +{
> +	ad5380_i2c_unregister_driver();
> +	ad5380_spi_unregister_driver();
> +
> +}
> +module_exit(ad5380_spi_exit);
> +
> +MODULE_AUTHOR("Lars-Peter Clausen <lars@metafoo.de>");
> +MODULE_DESCRIPTION("Analog Devices AD5380/81/82/83/90/91/92 DAC");
> +MODULE_LICENSE("GPL v2");

