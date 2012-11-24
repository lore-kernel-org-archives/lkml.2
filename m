Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751536Ab2KXPyL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Nov 2012 10:54:11 -0500
Received: from mailhost.informatik.uni-hamburg.de ([134.100.9.70]:37225 "EHLO
	mailhost.informatik.uni-hamburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751038Ab2KXPyK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Nov 2012 10:54:10 -0500
Message-ID: <50B0EDC4.9000409@metafoo.de>
Date: Sat, 24 Nov 2012 16:54:44 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20121027 Icedove/3.0.11
MIME-Version: 1.0
To: Jonathan Cameron <jic23@kernel.org>
CC: Thierry Reding <thierry.reding@avionic-design.de>,
        Jonathan Cameron <jic23@cam.ac.uk>, linux-iio@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] iio: adc: Add Texas Instruments ADC081C021/027 support
References: <1353683583-19779-1-git-send-email-thierry.reding@avionic-design.de> <50B0A74B.10707@kernel.org>
In-Reply-To: <50B0A74B.10707@kernel.org>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/24/2012 11:54 AM, Jonathan Cameron wrote:
> On 11/23/2012 03:13 PM, Thierry Reding wrote:
>> Add support for reading conversion results from the ADC and provide them
>> through a single IIO channel. A proper scaling factor is also exported
>> based on the reference voltage provided by a regulator.
>>
>> Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
> 
> Looks good to me.  I think timing is against you (depending on what Linus
> says with his next rc).  IIO patches are routed through Greg KH. His cut
> off is 1 week before the merge window opens.  Mine tends to as a result
> be a few days before that.  Linus stated in last rc message that the one he'll
> do today or tomorrow will be the last for this cycle (and hence merge window
> will open in a week from now). Hence this will probably hit linux next after
> the merge window closes and merge in the 3.9 cycle.
> 
> Shall I add a reviewed by from you Lars? Looks like Thierry has directly
> addressed all your comments (thanks for doing the review by the way!)

Yes, Reviewed-by: Lars-Peter Clausen <lars@metafoo.de>

> 
>> ---
>> Changes in v2:
>> - use the more common IIO_VAL_FRACTIONAL_LOG2 instead of IIO_VAL_INT_PLUS_MICRO
>>   for the ADC scale factor
>> - make the channel specification static const since it is the same for
>>   all devices
>> - convert the scale factor such that the result of multiplying the raw
>>   value with the scale factor yields a voltage in millivolts
>>
>>  drivers/iio/adc/Kconfig      |  10 +++
>>  drivers/iio/adc/Makefile     |   1 +
>>  drivers/iio/adc/ti-adc081c.c | 161 +++++++++++++++++++++++++++++++++++++++++++
>>  3 files changed, 172 insertions(+)
>>  create mode 100644 drivers/iio/adc/ti-adc081c.c
>>
>> diff --git a/drivers/iio/adc/Kconfig b/drivers/iio/adc/Kconfig
>> index b719f3b..e8be025 100644
>> --- a/drivers/iio/adc/Kconfig
>> +++ b/drivers/iio/adc/Kconfig
>> @@ -91,6 +91,16 @@ config MAX1363
>>  	  max11646, max11647) Provides direct access via sysfs and buffered
>>  	  data via the iio dev interface.
>>
>> +config TI_ADC081C
>> +	tristate "Texas Instruments ADC081C021/027"
>> +	depends on I2C
>> +	help
>> +	  If you say yes here you get support for Texas Instruments ADC081C021
>> +	  and ADC081C027 ADC chips.
>> +
>> +	  This driver can also be built as a module. If so, the module will be
>> +	  called ti-adc081c.
>> +
>>  config TI_AM335X_ADC
>>  	tristate "TI's ADC driver"
>>  	depends on MFD_TI_AM335X_TSCADC
>> diff --git a/drivers/iio/adc/Makefile b/drivers/iio/adc/Makefile
>> index 19d709c..6ad20aa 100644
>> --- a/drivers/iio/adc/Makefile
>> +++ b/drivers/iio/adc/Makefile
>> @@ -10,4 +10,5 @@ obj-$(CONFIG_AD7887) += ad7887.o
>>  obj-$(CONFIG_AT91_ADC) += at91_adc.o
>>  obj-$(CONFIG_LP8788_ADC) += lp8788_adc.o
>>  obj-$(CONFIG_MAX1363) += max1363.o
>> +obj-$(CONFIG_TI_ADC081C) += ti-adc081c.o
>>  obj-$(CONFIG_TI_AM335X_ADC) += ti_am335x_adc.o
>> diff --git a/drivers/iio/adc/ti-adc081c.c b/drivers/iio/adc/ti-adc081c.c
>> new file mode 100644
>> index 0000000..f4a46dd
>> --- /dev/null
>> +++ b/drivers/iio/adc/ti-adc081c.c
>> @@ -0,0 +1,161 @@
>> +/*
>> + * Copyright (C) 2012 Avionic Design GmbH
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License version 2 as
>> + * published by the Free Software Foundation.
>> + */
>> +
>> +#include <linux/err.h>
>> +#include <linux/i2c.h>
>> +#include <linux/module.h>
>> +
>> +#include <linux/iio/iio.h>
>> +#include <linux/regulator/consumer.h>
>> +
>> +struct adc081c {
>> +	struct i2c_client *i2c;
>> +	struct regulator *ref;
>> +};
>> +
>> +#define REG_CONV_RES 0x00
>> +
>> +static int adc081c_read_raw(struct iio_dev *iio,
>> +			    struct iio_chan_spec const *channel, int *value,
>> +			    int *shift, long mask)
>> +{
>> +	struct adc081c *adc = iio_priv(iio);
>> +	int err;
>> +
>> +	switch (mask) {
>> +	case IIO_CHAN_INFO_RAW:
>> +		err = i2c_smbus_read_word_swapped(adc->i2c, REG_CONV_RES);
>> +		if (err < 0)
>> +			return err;
>> +
>> +		*value = (err >> 4) & 0xff;
>> +		return IIO_VAL_INT;
>> +
>> +	case IIO_CHAN_INFO_SCALE:
>> +		err = regulator_get_voltage(adc->ref);
>> +		if (err < 0)
>> +			return err;
>> +
>> +		*value = err / 1000;
>> +		*shift = 8;
>> +
>> +		return IIO_VAL_FRACTIONAL_LOG2;
>> +
>> +	default:
>> +		break;
>> +	}
>> +
>> +	return -EINVAL;
>> +}
>> +
>> +static const struct iio_chan_spec adc081c_channel = {
>> +	.type = IIO_VOLTAGE,
>> +	.info_mask = IIO_CHAN_INFO_SCALE_SHARED_BIT |
>> +		     IIO_CHAN_INFO_RAW_SEPARATE_BIT,
>> +};
>> +
>> +static const struct iio_info adc081c_info = {
>> +	.read_raw = adc081c_read_raw,
>> +	.driver_module = THIS_MODULE,
>> +};
>> +
>> +static int adc081c_probe(struct i2c_client *client,
>> +			 const struct i2c_device_id *id)
>> +{
>> +	struct iio_dev *iio;
>> +	struct adc081c *adc;
>> +	int err;
>> +
>> +	if (!i2c_check_functionality(client->adapter, I2C_FUNC_SMBUS_WORD_DATA))
>> +		return -ENODEV;
>> +
>> +	iio = iio_device_alloc(sizeof(*adc));
>> +	if (!iio)
>> +		return -ENOMEM;
>> +
>> +	adc = iio_priv(iio);
>> +	adc->i2c = client;
>> +
>> +	adc->ref = regulator_get(&client->dev, "vref");
>> +	if (IS_ERR(adc->ref)) {
>> +		err = PTR_ERR(adc->ref);
>> +		goto iio_free;
>> +	}
>> +
>> +	err = regulator_enable(adc->ref);
>> +	if (err < 0)
>> +		goto regulator_put;
>> +
>> +	iio->dev.parent = &client->dev;
>> +	iio->name = dev_name(&client->dev);
>> +	iio->modes = INDIO_DIRECT_MODE;
>> +	iio->info = &adc081c_info;
>> +
>> +	iio->channels = &adc081c_channel;
>> +	iio->num_channels = 1;
>> +
>> +	err = iio_device_register(iio);
>> +	if (err < 0)
>> +		goto regulator_disable;
>> +
>> +	i2c_set_clientdata(client, iio);
>> +
>> +	return 0;
>> +
>> +regulator_disable:
>> +	regulator_disable(adc->ref);
>> +regulator_put:
>> +	regulator_put(adc->ref);
>> +iio_free:
>> +	iio_device_free(iio);
>> +
>> +	return err;
>> +}
>> +
>> +static int adc081c_remove(struct i2c_client *client)
>> +{
>> +	struct iio_dev *iio = i2c_get_clientdata(client);
>> +	struct adc081c *adc = iio_priv(iio);
>> +
>> +	iio_device_unregister(iio);
>> +	regulator_disable(adc->ref);
>> +	regulator_put(adc->ref);
>> +	iio_device_free(iio);
>> +
>> +	return 0;
>> +}
>> +
>> +static const struct i2c_device_id adc081c_id[] = {
>> +	{ "adc081c", 0 },
>> +	{ }
>> +};
>> +MODULE_DEVICE_TABLE(i2c, adc081c_id);
>> +
>> +#ifdef CONFIG_OF
>> +static const struct of_device_id adc081c_of_match[] = {
>> +	{ .compatible = "ti,adc081c" },
>> +	{ }
>> +};
>> +MODULE_DEVICE_TABLE(of, adc081c_of_match);
>> +#endif
>> +
>> +static struct i2c_driver adc081c_driver = {
>> +	.driver = {
>> +		.name = "adc081c",
>> +		.owner = THIS_MODULE,
>> +		.of_match_table = of_match_ptr(adc081c_of_match),
>> +	},
>> +	.probe = adc081c_probe,
>> +	.remove = adc081c_remove,
>> +	.id_table = adc081c_id,
>> +};
>> +module_i2c_driver(adc081c_driver);
>> +
>> +MODULE_AUTHOR("Thierry Reding <thierry.reding@avionic-design.de>");
>> +MODULE_DESCRIPTION("Texas Instruments ADC081C021/027 driver");
>> +MODULE_LICENSE("GPL v2");
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-iio" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

