Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753583Ab2HOSXP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 14:23:15 -0400
Received: from mailhost.informatik.uni-hamburg.de ([134.100.9.70]:57865 "EHLO
	mailhost.informatik.uni-hamburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751872Ab2HOSXN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 14:23:13 -0400
Message-ID: <502BE8F2.4090902@metafoo.de>
Date: Wed, 15 Aug 2012 20:22:42 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20120613 Icedove/3.0.11
MIME-Version: 1.0
To: Anthony Olech <anthony.olech.opensource@diasemi.com>
CC: Jonathan Cameron <jic23@cam.ac.uk>, linux-iio@vger.kernel.org,
        Samuel Ortiz <sameo@linux.intel.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Steven Toth <stoth@kernellabs.com>,
        Michael Krufky <mkrufky@kernellabs.com>,
        LKML <linux-kernel@vger.kernel.org>,
        David Dajun Chen <david.chen@diasemi.com>
Subject: Re: [NEW DRIVER V3 2/8] DA9058 ADC driver
References: <201208151518.q7FFIN9d011634@latitude.olech.com>
In-Reply-To: <201208151518.q7FFIN9d011634@latitude.olech.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/15/2012 05:05 PM, Anthony Olech wrote:
> This is the ADC component driver of the Dialog DA9058 PMIC.
> This driver is just one component of the whole DA9058 PMIC
> driver. It depends on the DA9058 CORE component driver.
> The HWMON and BATTERY component drivers depend on this ADC
> component driver.
> 
> This component driver recieves the actual platform data from
> the DA9058 CORE driver, whose settings may be overridden from
> the platform data supplied from the machine driver, but that
> config data has the nature of overides from sensible default
> values. Thus it is not essential to provide any real platform
> data at all.
> 
> Signed-off-by: Anthony Olech <anthony.olech.opensource@diasemi.com>
> Signed-off-by: David Dajun Chen <david.chen@diasemi.com>
> ---
>  drivers/iio/adc/Kconfig      |   10 +
>  drivers/iio/adc/Makefile     |    1 +
>  drivers/iio/adc/da9058-adc.c |  397 ++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 408 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/iio/adc/da9058-adc.c
> 
> diff --git a/drivers/iio/adc/Kconfig b/drivers/iio/adc/Kconfig
> index 9a0df81..54077d2 100644
> --- a/drivers/iio/adc/Kconfig
> +++ b/drivers/iio/adc/Kconfig
> @@ -13,4 +13,14 @@ config AT91_ADC
>  	help
>  	  Say yes here to build support for Atmel AT91 ADC.
>  
> +config DA9058_ADC
> +	tristate "Dialog DA9058 PMIC ADC"
> +	select IIO_BUFFER
> +	select IIO_KFIFO_BUF

You don't seem to have buffer support in your driver at this moment.

> +	select IIO_TRIGGER
> +	select SYSFS
> +	help
> +	  Say yes here to build support for the ADC component of the DAILOG
> +	  DA9058 PMCI
> +
>  endmenu
> diff --git a/drivers/iio/adc/Makefile b/drivers/iio/adc/Makefile
> index 175c8d4..5cfc4de 100644
> --- a/drivers/iio/adc/Makefile
> +++ b/drivers/iio/adc/Makefile
> @@ -3,3 +3,4 @@
>  #
>  
>  obj-$(CONFIG_AT91_ADC) += at91_adc.o
> +obj-$(CONFIG_DA9058_ADC) += da9058-adc.o
> diff --git a/drivers/iio/adc/da9058-adc.c b/drivers/iio/adc/da9058-adc.c
> new file mode 100644
> index 0000000..4053b7b
> --- /dev/null
> +++ b/drivers/iio/adc/da9058-adc.c
> @@ -0,0 +1,397 @@
> +/*
> + *  Copyright (C) 2012 Dialog Semiconductor Ltd.
> + *
> + *  This program is free software; you can redistribute it and/or modify
> + *  it under the terms of the GNU General Public License as published by
> + *  the Free Software Foundation; either version 2 of the License, or
> + *  (at your option) any later version.
> + *
> + */
> +
> +#include <linux/module.h>
> +#include <linux/interrupt.h>
> +#include <linux/iio/iio.h>
> +#include <linux/regmap.h>

You are not using regmap directly in this file. I'm wondering a bit though why,
since da9058_reg_read and friends just seem to wrap the regmap functions.

> +#include <linux/mfd/core.h>
> +
> +#include <linux/mfd/da9058/core.h>
> +#include <linux/mfd/da9058/registers.h>
> +#include <linux/mfd/da9058/irq.h>
> +#include <linux/mfd/da9058/pdata.h>
> +#include <linux/mfd/da9058/adc.h>
> +#include <linux/mfd/da9058/conf.h>
> +#include <linux/mfd/da9058/version.h>
> +
> +struct da9058_adc {
> +	struct da9058 *da9058;
> +	struct platform_device *pdev;

pdev is never used, only assigned once.

> +	struct rtc_device *rtc_dev;

rtc device?

> +	int use_automatic_adc;
> +	int irq;
> +};
> +
> +/*
> + *  if the PMIC is in automatic ADC consersion mode we have the choice
> + *  of just getting the last (automatic) conversion or doing a manual
> + *  conversion anyway.
> + *
> + *  if the PMIC is not in automatic ADC consersion mode we have no choice
> + *  we just have to ignore the requested mode and just do a manual
> + *  ADC conversion.
> + */
> +static int da9058_automatic_adc_conversion(struct da9058 *da9058,
> +				const int channel, int *value)
> +{
> +	unsigned int adc_msh, adc_lsh;
> +	int ret;
> +
> +	switch (channel) {

How is selected which channel is sampled in automatic mode? Or will it just go
round robin through the channels?

> +	case DA9058_ADCMAN_MUXSEL_VBAT:
> +		ret = da9058_reg_read(da9058, DA9058_VBATRES_REG_MSB,
> +						&adc_msh);
> +		if (ret)
> +			return ret;
> +
> +		ret = da9058_reg_read(da9058, DA9058_AUTORES_REG_1,
> +					&adc_lsh);
> +		if (ret)
> +			return ret;
> +
> +		*value = (adc_lsh & 0x0F) | (adc_msh << 4);
> +
> +		return 0;
> +	case DA9058_ADCMAN_MUXSEL_TEMP:
> +		ret = da9058_reg_read(da9058, DA9058_TEMPRES_REG_MSB,
> +						&adc_msh);
> +		if (ret)
> +			return ret;
> +
> +		ret = da9058_reg_read(da9058, DA9058_AUTORES_REG_1,
> +					&adc_lsh);
> +		if (ret)
> +			return ret;
> +
> +		*value = (adc_lsh >> 4) | (adc_msh << 4);
> +
> +		return 0;
> +	case DA9058_ADCMAN_MUXSEL_VF:
> +		ret = da9058_reg_read(da9058, DA9058_VREF_REG,
> +					&adc_msh);
> +		if (ret)
> +			return ret;
> +
> +		ret = da9058_reg_read(da9058, DA9058_AUTORES_REG_2,
> +					&adc_lsh);
> +		if (ret)
> +			return ret;
> +
> +		*value = (adc_lsh & 0x0F) | (adc_msh << 4);
> +
> +		return 0;
> +	case DA9058_ADCMAN_MUXSEL_ADCIN:
> +		ret = da9058_reg_read(da9058, DA9058_ADCINRES_REG_MSB,
> +					&adc_msh);
> +		if (ret)
> +			return ret;
> +
> +		ret = da9058_reg_read(da9058, DA9058_AUTORES_REG_2,
> +					&adc_lsh);
> +		if (ret)
> +			return ret;
> +
> +		*value = (adc_lsh >> 4) | (adc_msh << 4);
> +
> +		return 0;
> +	case DA9058_ADCMAN_MUXSEL_TJUNC:
> +		ret = da9058_reg_read(da9058, DA9058_TJUNCRES_REG,
> +					&adc_msh);
> +		if (ret)
> +			return ret;
> +
> +		ret = da9058_reg_read(da9058, DA9058_AUTORES_REG_3,
> +					&adc_lsh);
> +		if (ret)
> +			return ret;
> +
> +		*value = (adc_lsh >> 4) | (adc_msh << 4);
> +
> +		return 0;
> +	default:
> +		dev_err(da9058->dev, "ADC Channel %d is reserved\n", channel);
> +		return -EIO;
> +	}

The different channels all have awfully similar code. This could be simplified
e.g. using a look-up table for the register addresses.

> +}
> +
> +static int da9058_manual_adc_conversion(struct da9058 *da9058,
> +				const int channel, int *value)
> +{
> +	unsigned int adc_msh, adc_lsh;
> +	int ret;
> +
> +	mutex_lock(&da9058->adc_mutex);
> +
> +	ret = da9058_reg_write(da9058, DA9058_ADCMAN_REG,
> +					DA9058_ADCMAN_MANCONV | channel);
> +	if (ret < 0)
> +		goto err;
> +
> +	if (!wait_for_completion_timeout(&da9058->adc_read_done,
> +						msecs_to_jiffies(500))) {
> +		dev_err(da9058->dev,
> +			"timeout waiting for ADC conversion interrupt\n");
> +		ret = -ETIMEDOUT;
> +		goto err;
> +	}
> +
> +	ret = da9058_reg_read(da9058, DA9058_ADCRESH_REG, &adc_msh);
> +	if (ret < 0)
> +		goto err;
> +
> +	ret = da9058_reg_read(da9058, DA9058_ADCRESL_REG, &adc_lsh);
> +	if (ret < 0)
> +		goto err;
> +
> +	*value = (adc_msh << 4) | (adc_lsh & 0x0F);
> +
> +err:
> +	mutex_unlock(&da9058->adc_mutex);
> +	return ret;
> +}
> +
> +static int da9058_adc_conversion_read(struct da9058 *da9058, const int channel,
> +					int automatic_mode, int *value)
> +{
> +	if (!value)
> +		return -EINVAL;
> +
> +	if (automatic_mode) {
> +		unsigned int adc_ctrl;
> +		int ret;
> +
> +		ret = da9058_reg_read(da9058, DA9058_ADCCONT_REG, &adc_ctrl);
> +		if (ret)
> +			return ret;
> +
> +		if (adc_ctrl & DA9058_ADCCONT_AUTOADCEN)
> +			return da9058_automatic_adc_conversion(da9058,
> +						channel, value);
> +		else
> +			return da9058_manual_adc_conversion(da9058,
> +						channel, value);
> +	} else {
> +		return da9058_manual_adc_conversion(da9058, channel, value);
> +	}
> +}
> +
> +static irqreturn_t da9058_adc_interrupt(int irq, void *data)
> +{
> +	struct da9058 *da9058 = data;
> +
> +	complete(&da9058->adc_read_done);

Is there any reason why adc_read_done needs to be in the da9058 struct and can
not be in the da9058_adc struct.

> +
> +	return IRQ_HANDLED;
> +}

newline

> +static int da9058_adc_read_raw(struct iio_dev *idev,
> +	struct iio_chan_spec const *chan, int *val, int *val2, long mask)
> +{
> +	struct da9058_adc *adc = iio_priv(idev);
> +	struct da9058 *da9058 = adc->da9058;
> +	int ret;
> +
> +	switch (mask) {
> +	case IIO_CHAN_INFO_RAW:
> +		ret = da9058_adc_conversion_read(da9058, chan->channel,
> +					adc->use_automatic_adc, val);
> +		if (ret)
> +			return ret;
> +		else
> +			return IIO_VAL_INT;
> +	default:
> +		return -EINVAL;
> +	};
> +}
> +
> +static const struct iio_info da9058_adc_info = {
> +	.driver_module = THIS_MODULE,
> +	.read_raw = &da9058_adc_read_raw,
> +};
> +
> +struct iio_chan_spec da9058_adc_channels[] = {

const

> +	{
> +		.type = IIO_VOLTAGE,
> +		.indexed = 1,
> +		.channel = 0,

I'd use the same constants you use for the channel number in
da9058_automatic_adc_conversion, makes it easier to identify which channel is
which.

> +		.scan_index = 0,
> +		.scan_type.sign = 'u',
> +		.scan_type.realbits = 12,
> +		.scan_type.storagebits = 16,
> +		.info_mask = IIO_CHAN_INFO_SCALE_SHARED_BIT |
> +				IIO_CHAN_INFO_RAW_SEPARATE_BIT,
> +	},
> +	{
> +		.type = IIO_VOLTAGE,
> +		.indexed = 1,
> +		.channel = 1,
> +		.scan_index = 1,
> +		.scan_type.sign = 'u',
> +		.scan_type.realbits = 12,
> +		.scan_type.storagebits = 16,
> +		.info_mask = IIO_CHAN_INFO_SCALE_SHARED_BIT |
> +				IIO_CHAN_INFO_RAW_SEPARATE_BIT,
> +	},
> +	{
> +		.type = IIO_VOLTAGE,
> +		.indexed = 1,
> +		.channel = 2,
> +		.scan_index = 2,
> +		.scan_type.sign = 'u',
> +		.scan_type.realbits = 12,
> +		.scan_type.storagebits = 16,
> +		.info_mask = IIO_CHAN_INFO_SCALE_SHARED_BIT |
> +				IIO_CHAN_INFO_RAW_SEPARATE_BIT,
> +	},
> +	{
> +		.type = IIO_VOLTAGE,
> +		.indexed = 1,
> +		.channel = 3,
> +		.scan_index = 3,
> +		.scan_type.sign = 'u',
> +		.scan_type.realbits = 12,
> +		.scan_type.storagebits = 16,
> +		.info_mask = IIO_CHAN_INFO_SCALE_SHARED_BIT |
> +				IIO_CHAN_INFO_RAW_SEPARATE_BIT,
> +	},
> +	{
> +		.type = IIO_VOLTAGE,
> +		.indexed = 1,
> +		.channel = 4,
> +		.scan_index = 4,
> +		.scan_type.sign = 'u',
> +		.scan_type.realbits = 12,
> +		.scan_type.storagebits = 16,
> +		.info_mask = IIO_CHAN_INFO_SCALE_SHARED_BIT |
> +				IIO_CHAN_INFO_RAW_SEPARATE_BIT,
> +	},
> +
> +};
> +unsigned long da9058_scan_masks[] = {
> +
> +	(1 << ARRAY_SIZE(da9058_adc_channels)) - 1,

This means your device can only scan all channels at once, while the code above
suggests that only one channel at a time can be scanned. But since scan_masks
are only relevant for buffer mode I'd just drop this.

> +};
> +
> +static int da9058_adc_probe(struct platform_device *pdev)

__devinit

> +{
> +	struct da9058 *da9058 = dev_get_drvdata(pdev->dev.parent);
> +	const struct mfd_cell *cell = mfd_get_cell(pdev);
> +	struct da9058_adc_pdata *adc_pdata;
> +	struct da9058_adc *adc;
> +	struct iio_dev *idev;

for consistency please use indio_dev for the iio_dev variable name, this is
used althroughout IIO.

> +	int ret;
> +
> +	if (cell == NULL) {
> +		ret = -ENODEV;
> +		goto exit;
> +	}
> +
> +	if (da9058 == NULL) {
> +		ret = -ENODEV;
> +		goto exit;
> +	}
> +
> +	if (da9058->adc_read) {
> +		ret = -EEXIST;
> +		goto exit;
> +	}
> +
> +	adc_pdata = cell->platform_data;
> +
> +	if (adc_pdata == NULL) {
> +		ret = -EINVAL;
> +		goto exit;
> +	}
> +
> +	idev = iio_device_alloc(sizeof(struct da9058_adc));

sizeof(*adc)

> +	if (idev == NULL) {
> +		ret = -ENOMEM;
> +		goto error_ret;
> +	}
> +	adc = iio_priv(idev);
> +
> +	platform_set_drvdata(pdev, idev);
> +
> +	idev->dev.parent = &pdev->dev;
> +	idev->name = dev_name(&pdev->dev);
> +	idev->modes = INDIO_DIRECT_MODE;
> +	idev->info = &da9058_adc_info;
> +
> +	adc->irq = platform_get_irq(pdev, 0);
> +	if (adc->irq < 0) {
> +		dev_err(&pdev->dev, "can not get ADC IRQ error=%d\n",
> +				adc->irq);
> +		ret = -ENODEV;
> +		goto error_free_device;
> +	}
> +
> +	idev->channels = da9058_adc_channels;
> +	idev->num_channels = ARRAY_SIZE(da9058_adc_channels);
> +	idev->available_scan_masks = da9058_scan_masks;
> +	idev->masklength = ARRAY_SIZE(da9058_adc_channels);
> +
> +	platform_set_drvdata(pdev, adc);
> +	adc->da9058 = da9058;
> +	adc->pdev = pdev;
> +	adc->use_automatic_adc = adc_pdata->use_automatic_adc;
> +	da9058->adc_read = da9058_adc_conversion_read;

What will the adc_read callback be used for?

> +
> +	ret = iio_device_register(idev);
> +	if (ret < 0) {
> +		dev_err(&pdev->dev, "Couldn't register the device.\n");
> +		goto error_free_device;
> +	}
> +
> +	ret = request_threaded_irq(da9058_to_virt_irq_num(da9058, adc->irq),
> +				NULL, da9058_adc_interrupt,
> +				IRQF_TRIGGER_RISING | IRQF_ONESHOT,
> +				"DA9058 ADC EOM", da9058);
> +	if (ret)
> +		goto failed_to_get_adc_interrupt;
> +
> +	goto exit;
> +
> +failed_to_get_adc_interrupt:
> +	iio_device_unregister(idev);
> +error_free_device:
> +	platform_set_drvdata(pdev, NULL);

platform_set_drvdata(pdev, NULL) should not be neccessary

> +	iio_device_free(idev);
> +exit:
> +error_ret:
> +	return ret;
> +}
> +
> +static int __devexit da9058_adc_remove(struct platform_device *pdev)
> +{
> +	struct iio_dev *idev = platform_get_drvdata(pdev);
> +	struct da9058_adc *adc = iio_priv(idev);
> +
> +	iio_device_unregister(idev);
> +	free_irq(adc->irq, adc);

Does it work here without the irq number conversion and the devid parameter
does not match, you pass adc here and da9058 when you request it.

> +	iio_device_free(idev);
> +
> +	return 0;
> +}
> +

