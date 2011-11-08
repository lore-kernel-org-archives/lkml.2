Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932278Ab1KHNfj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 08:35:39 -0500
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:43026 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932093Ab1KHNfg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 08:35:36 -0500
Message-ID: <4EB93027.7000706@kernel.org>
Date: Tue, 08 Nov 2011 13:35:35 +0000
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20111001 Thunderbird/7.0.1
MIME-Version: 1.0
To: Lars-Peter Clausen <lars@metafoo.de>
CC: jic23@cam.ac.uk, linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org,
        guenter.roeck@ericsson.com, khali@linux-fr.org,
        dmitry.torokhov@gmail.com, broonie@opensource.wolfsonmicro.com,
        gregkh@suse.de, alan@lxorguk.ukuu.org.uk, arnd@arndb.de,
        linus.walleij@linaro.org, maxime.ripard@free-electrons.com,
        Michael Hennerich <michael.hennerich@analog.com>
Subject: Re: [PATCH 3/6] IIO:ADC:ad799x initial import.
References: <1320677563-18378-1-git-send-email-jic23@cam.ac.uk> <1320677563-18378-4-git-send-email-jic23@cam.ac.uk> <4EB9298A.40105@metafoo.de>
In-Reply-To: <4EB9298A.40105@metafoo.de>
X-Enigmail-Version: 1.3.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/08/2011 01:07 PM, Lars-Peter Clausen wrote:
> On 11/07/2011 03:52 PM, jic23@cam.ac.uk wrote:
>> From: Michael Hennerich <michael.hennerich@analog.com>
>>
>> Signed-off-by: Jonathan Cameron <jic23@cam.ac.uk>
>> Signed-off-by: Michael Hennerich <michael.hennerich@analog.com>
>> ---
>>  drivers/iio/adc/Kconfig       |   11 +
>>  drivers/iio/adc/Makefile      |    5 +-
>>  drivers/iio/adc/ad799x_core.c |  761 +++++++++++++++++++++++++++++++++++++++++
>>  include/linux/iio/ad799x.h    |   12 +
>>  4 files changed, 788 insertions(+), 1 deletions(-)
>>
>> diff --git a/drivers/iio/adc/Kconfig b/drivers/iio/adc/Kconfig
>> index 0673d78..3d97b21 100644
>> --- a/drivers/iio/adc/Kconfig
>> +++ b/drivers/iio/adc/Kconfig
>> @@ -3,6 +3,17 @@
>>  #
>>  menu "Analog to digital convertors"
>>  
>> +config IIO_AD799X
>> +	tristate "Analog Devices AD799x ADC driver"
>> +	depends on I2C
>> +	select IIO_TRIGGER if IIO_BUFFER
>> +	select AD799X_RING_BUFFER
> 
> ringbuffer and trigger support is still in staging.
> 
Good point.
> Also we have another problem here, we now have to drivers for the same
> device, both with the same symbol name. This won't really work.
which name?  iio_ prefix deals with everything other than udev getting
confused about which module to load.
> 
> 
>> +	help
>> +	  Say yes here to build support for Analog Devices:
>> +	  ad7991, ad7995, ad7999, ad7992, ad7993, ad7994, ad7997, ad7998
>> +	  i2c analog to digital convertors (ADC). Provides direct access
>> +	  via sysfs.
>> +
>>  config IIO_MAX1363
>>  	tristate "Maxim max1363 ADC driver"
>>  	depends on I2C
>> diff --git a/drivers/iio/adc/Makefile b/drivers/iio/adc/Makefile
>> index 6064fff..c197334 100644
>> --- a/drivers/iio/adc/Makefile
>> +++ b/drivers/iio/adc/Makefile
>> @@ -2,5 +2,8 @@
>>  # Makefile for IIO ADCs
>>  #
>>  
>> +iio_ad799x-y := ad799x_core.o
>> +obj-$(CONFIG_IIO_AD799X) += iio_ad799x.o
>> +
>>  iio_max1363-y := max1363_core.o
>> -obj-$(CONFIG_IIO_MAX1363) += iio_max1363.o
>> +obj-$(CONFIG_IIO_MAX1363) += iio_max1363.o
>> \ No newline at end of file
>> diff --git a/drivers/iio/adc/ad799x_core.c b/drivers/iio/adc/ad799x_core.c
>> new file mode 100644
>> index 0000000..a9e8f5f
>> --- /dev/null
>> +++ b/drivers/iio/adc/ad799x_core.c
>> @@ -0,0 +1,761 @@
>> +/*
>> + * iio/adc/ad799x.c
>> + * Copyright (C) 2010-1011 Michael Hennerich, Analog Devices Inc.
>> + *
>> + * based on iio/adc/max1363
>> + * Copyright (C) 2008-2010 Jonathan Cameron
>> + *
>> + * based on linux/drivers/i2c/chips/max123x
>> + * Copyright (C) 2002-2004 Stefan Eletzhofer
>> + *
>> + * based on linux/drivers/acron/char/pcf8583.c
>> + * Copyright (C) 2000 Russell King
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License version 2 as
>> + * published by the Free Software Foundation.
>> + *
>> + * ad799x.c
>> + *
>> + * Support for ad7991, ad7995, ad7999, ad7992, ad7993, ad7994, ad7997,
>> + * ad7998 and similar chips.
>> + *
>> + */
>> +
>> +#include <linux/interrupt.h>
>> +#include <linux/device.h>
>> +#include <linux/kernel.h>
>> +#include <linux/sysfs.h>
>> +#include <linux/i2c.h>
>> +#include <linux/regulator/consumer.h>
>> +#include <linux/slab.h>
>> +#include <linux/types.h>
>> +#include <linux/err.h>
>> +#include <linux/module.h>
>> +
>> +#include <linux/iio/iio.h>
>> +#include <linux/iio/sysfs.h>
>> +#include <linux/iio/ad799x.h>
>> +
>> +#define AD799X_CHANNEL_SHIFT			4
>> +/*
>> + * AD7991, AD7995 and AD7999 defines
>> + */
>> +
>> +#define AD7991_REF_SEL				0x08
>> +#define AD7991_FLTR				0x04
>> +#define AD7991_BIT_TRIAL_DELAY			0x02
>> +#define AD7991_SAMPLE_DELAY			0x01
>> +
>> +/*
>> + * AD7992, AD7993, AD7994, AD7997 and AD7998 defines
>> + */
>> +
>> +#define AD7998_FLTR				0x08
>> +#define AD7998_ALERT_EN				0x04
>> +#define AD7998_BUSY_ALERT			0x02
>> +#define AD7998_BUSY_ALERT_POL			0x01
>> +
>> +#define AD7998_CONV_RES_REG			0x0
>> +#define AD7998_ALERT_STAT_REG			0x1
>> +#define AD7998_CONF_REG				0x2
>> +#define AD7998_CYCLE_TMR_REG			0x3
>> +#define AD7998_DATALOW_CH1_REG			0x4
>> +#define AD7998_DATAHIGH_CH1_REG			0x5
>> +#define AD7998_HYST_CH1_REG			0x6
>> +#define AD7998_DATALOW_CH2_REG			0x7
>> +#define AD7998_DATAHIGH_CH2_REG			0x8
>> +#define AD7998_HYST_CH2_REG			0x9
>> +#define AD7998_DATALOW_CH3_REG			0xA
>> +#define AD7998_DATAHIGH_CH3_REG			0xB
>> +#define AD7998_HYST_CH3_REG			0xC
>> +#define AD7998_DATALOW_CH4_REG			0xD
>> +#define AD7998_DATAHIGH_CH4_REG			0xE
>> +#define AD7998_HYST_CH4_REG			0xF
>> +
>> +#define AD7998_CYC_MASK				0x7
>> +#define AD7998_CYC_DIS				0x0
>> +#define AD7998_CYC_TCONF_32			0x1
>> +#define AD7998_CYC_TCONF_64			0x2
>> +#define AD7998_CYC_TCONF_128			0x3
>> +#define AD7998_CYC_TCONF_256			0x4
>> +#define AD7998_CYC_TCONF_512			0x5
>> +#define AD7998_CYC_TCONF_1024			0x6
>> +#define AD7998_CYC_TCONF_2048			0x7
>> +
>> +#define AD7998_ALERT_STAT_CLEAR			0xFF
>> +
>> +/*
>> + * AD7997 and AD7997 defines
>> + */
>> +
>> +#define AD7997_8_READ_SINGLE			0x80
>> +#define AD7997_8_READ_SEQUENCE			0x70
>> +/* TODO: move this into a common header */
>> +#define RES_MASK(bits)	((1 << (bits)) - 1)
>> +
>> +enum {
>> +	ad7991,
>> +	ad7995,
>> +	ad7999,
>> +	ad7992,
>> +	ad7993,
>> +	ad7994,
>> +	ad7997,
>> +	ad7998
>> +};
>> +
>> +struct ad799x_state;
>> +
>> +/**
>> + * struct ad799x_chip_info - chip specifc information
>> + * @channel:		channel specification
>> + * @num_channels:	number of channels
>> + * @int_vref_mv:	the internal reference voltage
>> + */
>> +struct ad799x_chip_info {
>> +	struct iio_chan_spec		channel[9];
>> +	int				num_channels;
>> +	u16				int_vref_mv;
>> +};
>> +
>> +struct ad799x_state {
>> +	struct i2c_client		*client;
>> +	const struct ad799x_chip_info	*chip_info;
>> +	struct regulator		*reg;
>> +	u16				int_vref_mv;
>> +	unsigned			id;
>> +	char				*name;
>> +	u16				config;
>> +};
>> +
>> +/*
>> + * ad799x register access by I2C
>> + */
>> +static int ad799x_i2c_read16(struct ad799x_state *st, u8 reg, u16 *data)
>> +{
>> +	struct i2c_client *client = st->client;
>> +	int ret = 0;
>> +
>> +	ret = i2c_smbus_read_word_data(client, reg);
>> +	if (ret < 0) {
>> +		dev_err(&client->dev, "I2C read error\n");
>> +		return ret;
>> +	}
>> +
>> +	*data = swab16((u16)ret);
>> +
>> +	return 0;
>> +}
>> +
>> +static int ad799x_scan_direct(struct ad799x_state *st, unsigned ch)
>> +{
>> +	u16 rxbuf;
>> +	u8 cmd;
>> +	int ret;
>> +
>> +	switch (st->id) {
>> +	case ad7991:
>> +	case ad7995:
>> +	case ad7999:
>> +		cmd = st->config | ((1 << ch) << AD799X_CHANNEL_SHIFT);
>> +		break;
>> +	case ad7992:
>> +	case ad7993:
>> +	case ad7994:
>> +		cmd = (1 << ch) << AD799X_CHANNEL_SHIFT;
>> +		break;
>> +	case ad7997:
>> +	case ad7998:
>> +		cmd = (ch << AD799X_CHANNEL_SHIFT) | AD7997_8_READ_SINGLE;
>> +		break;
>> +	default:
>> +		return -EINVAL;
>> +	}
>> +
>> +	ret = ad799x_i2c_read16(st, cmd, &rxbuf);
>> +	if (ret < 0)
>> +		return ret;
>> +
>> +	return rxbuf;
>> +}
>> +
>> +static int ad799x_read_raw(struct iio_dev *indio_dev,
>> +			   struct iio_chan_spec const *chan,
>> +			   int *val,
>> +			   int *val2,
>> +			   long m)
>> +{
>> +	int ret;
>> +	struct ad799x_state *st = iio_priv(indio_dev);
>> +	unsigned int scale_uv;
>> +
>> +	switch (m) {
>> +	case 0:
>> +		mutex_lock(&indio_dev->mlock);
>> +		ret = ad799x_scan_direct(st, chan->channel);
>> +		mutex_unlock(&indio_dev->mlock);
>> +
>> +		if (ret < 0)
>> +			return ret;
>> +		*val = (ret >> chan->scan_type.shift) &
>> +			RES_MASK(chan->scan_type.realbits);
>> +		return IIO_VAL_INT;
>> +	case IIO_CHAN_INFO_SCALE:
>> +		scale_uv = (st->int_vref_mv * 1000) >> chan->scan_type.realbits;
>> +		*val =  scale_uv / 1000;
>> +		*val2 = (scale_uv % 1000) * 1000;
>> +		return IIO_VAL_INT_PLUS_MICRO;
>> +	}
>> +	return -EINVAL;
>> +}
>> +
>> +static const struct iio_info ad799X_info = {
>> +	.read_raw = &ad799x_read_raw,
>> +	.driver_module = THIS_MODULE,
>> +};
>> +
>> +
>> +static const struct ad799x_chip_info ad799x_chip_info_tbl[] = {
>> +	[ad7991] = {
>> +		.channel = {
>> +			[0] = {
>> +				.type = IIO_VOLTAGE,
>> +				.indexed = 1,
>> +				.channel = 0,
>> +				.info_mask = IIO_CHAN_INFO_SCALE_SHARED_BIT,
>> +				.scan_type =  {
>> +					.realbits = 12,
>> +					.shift = 0,
>> +				},
>> +			},
>> +			[1] = {
>> +				.type = IIO_VOLTAGE,
>> +				.indexed = 1,
>> +				.channel = 1,
>> +				.info_mask = IIO_CHAN_INFO_SCALE_SHARED_BIT,
>> +				.scan_type = {
>> +					.realbits = 12,
>> +					.shift = 0,
>> +				},
>> +			},
>> +			[2] = {
>> +				.type = IIO_VOLTAGE,
>> +				.indexed = 1,
>> +				.channel = 2,
>> +				.info_mask = IIO_CHAN_INFO_SCALE_SHARED_BIT,
>> +				.scan_type = {
>> +					.realbits = 12,
>> +					.shift = 0,
>> +				},
>> +			},
>> +			[3] = {
>> +				.type = IIO_VOLTAGE,
>> +				.indexed = 1,
>> +				.channel = 3,
>> +				.info_mask = IIO_CHAN_INFO_SCALE_SHARED_BIT,
>> +				.scan_type = {
>> +					.realbits = 12,
>> +					.shift = 0,
>> +				},
>> +			},
>> +		},
>> +		.num_channels = 5,
>> +		.int_vref_mv = 4096,
>> +	},
>> +	[ad7995] = {
>> +		.channel = {
>> +			[0] = {
>> +				.type = IIO_VOLTAGE,
>> +				.indexed = 1,
>> +				.channel = 0,
>> +				.info_mask = IIO_CHAN_INFO_SCALE_SHARED_BIT,
>> +				.scan_type = {
>> +					.realbits = 10,
>> +					.shift = 2,
>> +				},
>> +			},
>> +			[1] = {
>> +				.type = IIO_VOLTAGE,
>> +				.indexed = 1,
>> +				.channel = 1,
>> +				.info_mask = IIO_CHAN_INFO_SCALE_SHARED_BIT,
>> +				.scan_type = {
>> +					.realbits = 10,
>> +					.shift = 2,
>> +				},
>> +			},
>> +			[2] = {
>> +				.type = IIO_VOLTAGE,
>> +				.indexed = 1,
>> +				.channel = 2,
>> +				.info_mask = IIO_CHAN_INFO_SCALE_SHARED_BIT,
>> +				.scan_type = {
>> +					.realbits = 10,
>> +					.shift = 2,
>> +				},
>> +			},
>> +			[3] = {
>> +				.type = IIO_VOLTAGE,
>> +				.indexed = 1,
>> +				.channel = 3,
>> +				.info_mask = IIO_CHAN_INFO_SCALE_SHARED_BIT,
>> +				.scan_type = {
>> +					.realbits = 10,
>> +					.shift = 2,
>> +				},
>> +			},
>> +		},
>> +		.num_channels = 5,
>> +		.int_vref_mv = 1024,
>> +	},
>> +	[ad7999] = {
>> +		.channel = {
>> +			[0] = {
>> +				.type = IIO_VOLTAGE,
>> +				.indexed = 1,
>> +				.channel = 0,
>> +				.info_mask = IIO_CHAN_INFO_SCALE_SHARED_BIT,
>> +				.scan_type = {
>> +					.realbits = 8,
>> +					.shift = 4,
>> +				},
>> +			},
>> +			[1] = {
>> +				.type = IIO_VOLTAGE,
>> +				.indexed = 1,
>> +				.channel = 1,
>> +				.info_mask = IIO_CHAN_INFO_SCALE_SHARED_BIT,
>> +				.scan_type = {
>> +					.realbits = 8,
>> +					.shift = 4,
>> +				},
>> +			},
>> +			[2] = {
>> +				.type = IIO_VOLTAGE,
>> +				.indexed = 1,
>> +				.channel = 2,
>> +				.info_mask = IIO_CHAN_INFO_SCALE_SHARED_BIT,
>> +				.scan_type = {
>> +					.realbits = 8,
>> +					.shift = 4,
>> +				},
>> +			},
>> +			[3] = {
>> +				.type = IIO_VOLTAGE,
>> +				.indexed = 1,
>> +				.channel = 3,
>> +				.info_mask = IIO_CHAN_INFO_SCALE_SHARED_BIT,
>> +				.scan_type = {
>> +					.realbits = 8,
>> +					.shift = 4,
>> +				},
>> +			},
>> +		},
>> +		.num_channels = 5,
>> +		.int_vref_mv = 1024,
>> +	},
>> +	[ad7992] = {
>> +		.channel = {
>> +			[0] = {
>> +				.type = IIO_VOLTAGE,
>> +				.indexed = 1,
>> +				.channel = 0,
>> +				.info_mask = IIO_CHAN_INFO_SCALE_SHARED_BIT,
>> +				.scan_type = {
>> +					.realbits = 12,
>> +					.shift = 0,
>> +				},
>> +			},
>> +			[1] = {
>> +				.type = IIO_VOLTAGE,
>> +				.indexed = 1,
>> +				.channel = 1,
>> +				.info_mask = IIO_CHAN_INFO_SCALE_SHARED_BIT,
>> +				.scan_type = {
>> +					.realbits = 12,
>> +					.shift = 0,
>> +				},
>> +			},
>> +		},
>> +		.num_channels = 3,
>> +		.int_vref_mv = 4096,
>> +	},
>> +	[ad7993] = {
>> +		.channel = {
>> +			[0] = {
>> +				.type = IIO_VOLTAGE,
>> +				.indexed = 1,
>> +				.channel = 0,
>> +				.info_mask = IIO_CHAN_INFO_SCALE_SHARED_BIT,
>> +				.scan_type = {
>> +					.realbits = 10,
>> +					.shift = 2,
>> +				},
>> +			},
>> +			[1] = {
>> +				.type = IIO_VOLTAGE,
>> +				.indexed = 1,
>> +				.channel = 1,
>> +				.info_mask = IIO_CHAN_INFO_SCALE_SHARED_BIT,
>> +				.scan_type = {
>> +					.realbits = 10,
>> +					.shift = 2,
>> +				},
>> +			},
>> +			[2] = {
>> +				.type = IIO_VOLTAGE,
>> +				.indexed = 1,
>> +				.channel = 2,
>> +				.info_mask = IIO_CHAN_INFO_SCALE_SHARED_BIT,
>> +				.scan_type = {
>> +					.realbits = 10,
>> +					.shift = 2,
>> +				},
>> +			},
>> +			[3] = {
>> +				.type = IIO_VOLTAGE,
>> +				.indexed = 1,
>> +				.channel = 3,
>> +				.info_mask = IIO_CHAN_INFO_SCALE_SHARED_BIT,
>> +				.scan_type = {
>> +					.realbits = 10,
>> +					.shift = 2,
>> +				},
>> +			},
>> +		},
>> +		.num_channels = 5,
>> +		.int_vref_mv = 1024,
>> +	},
>> +	[ad7994] = {
>> +		.channel = {
>> +			[0] = {
>> +				.type = IIO_VOLTAGE,
>> +				.indexed = 1,
>> +				.channel = 0,
>> +				.info_mask = IIO_CHAN_INFO_SCALE_SHARED_BIT,
>> +				.scan_type = {
>> +					.realbits = 12,
>> +					.shift = 0,
>> +				},
>> +			},
>> +			[1] = {
>> +				.type = IIO_VOLTAGE,
>> +				.indexed = 1,
>> +				.channel = 1,
>> +				.info_mask = IIO_CHAN_INFO_SCALE_SHARED_BIT,
>> +				.scan_type = {
>> +					.realbits = 12,
>> +					.shift = 0,
>> +				},
>> +			},
>> +			[2] = {
>> +				.type = IIO_VOLTAGE,
>> +				.indexed = 1,
>> +				.channel = 2,
>> +				.info_mask = IIO_CHAN_INFO_SCALE_SHARED_BIT,
>> +				.scan_type = {
>> +					.realbits = 12,
>> +					.shift = 0,
>> +				},
>> +			},
>> +			[3] = {
>> +				.type = IIO_VOLTAGE,
>> +				.indexed = 1,
>> +				.channel = 3,
>> +				.info_mask = IIO_CHAN_INFO_SCALE_SHARED_BIT,
>> +				.scan_type = {
>> +					.realbits = 12,
>> +					.shift = 0,
>> +				},
>> +			},
>> +		},
>> +		.num_channels = 5,
>> +		.int_vref_mv = 4096,
>> +	},
>> +	[ad7997] = {
>> +		.channel = {
>> +			[0] = {
>> +				.type = IIO_VOLTAGE,
>> +				.indexed = 1,
>> +				.channel = 0,
>> +				.info_mask = IIO_CHAN_INFO_SCALE_SHARED_BIT,
>> +				.scan_type = {
>> +					.realbits = 10,
>> +					.shift = 2,
>> +				},
>> +			},
>> +			[1] = {
>> +				.type = IIO_VOLTAGE,
>> +				.indexed = 1,
>> +				.channel = 1,
>> +				.info_mask = IIO_CHAN_INFO_SCALE_SHARED_BIT,
>> +				.scan_type = {
>> +					.realbits = 10,
>> +					.shift = 2,
>> +				},
>> +			},
>> +			[2] = {
>> +				.type = IIO_VOLTAGE,
>> +				.indexed = 1,
>> +				.channel = 2,
>> +				.info_mask = IIO_CHAN_INFO_SCALE_SHARED_BIT,
>> +				.scan_type = {
>> +					.realbits = 10,
>> +					.shift = 2,
>> +				},
>> +			},
>> +			[3] = {
>> +				.type = IIO_VOLTAGE,
>> +				.indexed = 1,
>> +				.channel = 3,
>> +				.info_mask = IIO_CHAN_INFO_SCALE_SHARED_BIT,
>> +				.scan_type = {
>> +					.realbits = 10,
>> +					.shift = 2,
>> +				},
>> +			},
>> +			[4] = {
>> +				.type = IIO_VOLTAGE,
>> +				.indexed = 1,
>> +				.channel = 4,
>> +				.info_mask = IIO_CHAN_INFO_SCALE_SHARED_BIT,
>> +				.scan_type = {
>> +					.realbits = 10,
>> +					.shift = 2,
>> +				},
>> +			},
>> +			[5] = {
>> +				.type = IIO_VOLTAGE,
>> +				.indexed = 1,
>> +				.channel = 5,
>> +				.info_mask = IIO_CHAN_INFO_SCALE_SHARED_BIT,
>> +				.scan_type = {
>> +					.realbits = 10,
>> +					.shift = 2,
>> +				},
>> +			},
>> +			[6] = {
>> +				.type = IIO_VOLTAGE,
>> +				.indexed = 1,
>> +				.channel = 6,
>> +				.info_mask = IIO_CHAN_INFO_SCALE_SHARED_BIT,
>> +				.scan_type = {
>> +					.realbits = 10,
>> +					.shift = 2,
>> +				},
>> +			},
>> +			[7] = {
>> +				.type = IIO_VOLTAGE,
>> +				.indexed = 1,
>> +				.channel = 7,
>> +				.info_mask = IIO_CHAN_INFO_SCALE_SHARED_BIT,
>> +				.scan_type = {
>> +					.realbits = 10,
>> +					.shift = 2,
>> +				},
>> +			},
>> +		},
>> +		.num_channels = 9,
>> +		.int_vref_mv = 1024,
>> +	},
>> +	[ad7998] = {
>> +		.channel = {
>> +			[0] = {
>> +				.type = IIO_VOLTAGE,
>> +				.indexed = 1,
>> +				.channel = 0,
>> +				.info_mask = IIO_CHAN_INFO_SCALE_SHARED_BIT,
>> +				.scan_type = {
>> +					.realbits = 12,
>> +					.shift = 0,
>> +				},
>> +			},
>> +			[1] = {
>> +				.type = IIO_VOLTAGE,
>> +				.indexed = 1,
>> +				.channel = 1,
>> +				.info_mask = IIO_CHAN_INFO_SCALE_SHARED_BIT,
>> +				.scan_type = {
>> +					.realbits = 12,
>> +					.shift = 0,
>> +				},
>> +			},
>> +			[2] = {
>> +				.type = IIO_VOLTAGE,
>> +				.indexed = 1,
>> +				.channel = 2,
>> +				.info_mask = IIO_CHAN_INFO_SCALE_SHARED_BIT,
>> +				.scan_type = {
>> +					.realbits = 12,
>> +					.shift = 0,
>> +				},
>> +			},
>> +			[3] = {
>> +				.type = IIO_VOLTAGE,
>> +				.indexed = 1,
>> +				.channel = 3,
>> +				.info_mask = IIO_CHAN_INFO_SCALE_SHARED_BIT,
>> +				.scan_type = {
>> +					.realbits = 12,
>> +					.shift = 0,
>> +				},
>> +			},
>> +			[4] = {
>> +				.type = IIO_VOLTAGE,
>> +				.indexed = 1,
>> +				.channel = 4,
>> +				.info_mask = IIO_CHAN_INFO_SCALE_SHARED_BIT,
>> +				.scan_type = {
>> +					.realbits = 12,
>> +					.shift = 0,
>> +				},
>> +			},
>> +			[5] = {
>> +				.type = IIO_VOLTAGE,
>> +				.indexed = 1,
>> +				.channel = 5,
>> +				.info_mask = IIO_CHAN_INFO_SCALE_SHARED_BIT,
>> +				.scan_type = {
>> +					.realbits = 12,
>> +					.shift = 0,
>> +				},
>> +			},
>> +			[6] = {
>> +				.type = IIO_VOLTAGE,
>> +				.indexed = 1,
>> +				.channel = 6,
>> +				.info_mask = IIO_CHAN_INFO_SCALE_SHARED_BIT,
>> +				.scan_type = {
>> +					.realbits = 12,
>> +					.shift = 0,
>> +				},
>> +			},
>> +			[7] = {
>> +				.type = IIO_VOLTAGE,
>> +				.indexed = 1,
>> +				.channel = 7,
>> +				.info_mask = IIO_CHAN_INFO_SCALE_SHARED_BIT,
>> +				.scan_type = {
>> +					.realbits = 12,
>> +					.shift = 0,
>> +				},
>> +			},
>> +		},
>> +		.num_channels = 9,
>> +		.int_vref_mv = 4096,
>> +	},
>> +};
> 
> All 'num_channels' fields needs to be decremented by one since the
> IIO_CHAN_SOFT_TIMESTAMP channel was removed.
Excellent point.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-iio" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

