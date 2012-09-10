Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756649Ab2IJJHT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 05:07:19 -0400
Received: from smtp-out-022.synserver.de ([212.40.185.22]:1170 "EHLO
	smtp-out-022.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755703Ab2IJJHN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 05:07:13 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 14518
Message-ID: <504DADE1.6010303@metafoo.de>
Date: Mon, 10 Sep 2012 11:07:45 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.6esrpre) Gecko/20120817 Icedove/10.0.6
MIME-Version: 1.0
To: "Kim, Milo" <Milo.Kim@ti.com>
CC: Jonathan Cameron <jic23@kernel.org>, Jonathan Cameron <jic23@cam.ac.uk>,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v5] iio: adc: add new lp8788 adc driver
References: <A874F61F95741C4A9BA573A70FE3998F41EF45CC@DQHE02.ent.ti.com>
In-Reply-To: <A874F61F95741C4A9BA573A70FE3998F41EF45CC@DQHE02.ent.ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/10/2012 10:02 AM, Kim, Milo wrote:
>  TI LP8788 PMU provides regulators, battery charger, ADC,
>  RTC, backlight driver and current sinks.
> 
>  This patch enables the LP8788 ADC functions.
> 
>  The LP8788 ADC has 13 ADC input selection and supports 12-bit resolution.
>  Internal operation of getting ADC is access to registers of LP8788.
>  The LP8788 ADC uses exported functions for accessing these registers.
>  (exported by LP8788 MFD device driver)
> 
>  This driver supports IIO_CHAN_INFO_RAW and SCALE.
>  The scale is micro unit.
>  So the IIO consumer can get the result as following.
> 
>    result = ADC raw value * (scale_int + scale_part / 1000000)
> 
>  (The IIO map for the IIO consumer)
> 
>  The ADC input can be selective in the platform side.
>  Even though this platform data is not defined,
>  the default IIO map is created for supporting the power supply driver.
>  The battery voltage and temperature are used inside this driver.
> 


Hi,

One issue and a couple of nitpicks inline.

> Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
> ---
>  drivers/iio/adc/Kconfig      |    6 +
>  drivers/iio/adc/Makefile     |    1 +
>  drivers/iio/adc/lp8788_adc.c |  270 ++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 277 insertions(+)
[...]
> diff --git a/drivers/iio/adc/lp8788_adc.c b/drivers/iio/adc/lp8788_adc.c
> new file mode 100644
> index 0000000..6079f9e
> --- /dev/null
> +++ b/drivers/iio/adc/lp8788_adc.c
> @@ -0,0 +1,270 @@
[...]
> +
> +static const int lp8788_scale[LPADC_MAX] = {
> +	[LPADC_VBATT_5P5] = 1343,
> +	[LPADC_VIN_CHG]   = 3052,
> +	[LPADC_IBATT]     = 610,
> +	[LPADC_IC_TEMP]   = 610,
> +	[LPADC_VBATT_6P0] = 1465,
> +	[LPADC_VBATT_5P0] = 1221,
> +	[LPADC_ADC1]      = 610,
> +	[LPADC_ADC2]      = 610,
> +	[LPADC_VDD]       = 1025,
> +	[LPADC_VCOIN]     = 757,
> +	[LPADC_VDD_LDO]   = 610,
> +	[LPADC_ADC3]      = 610,
> +	[LPADC_ADC4]      = 610,
> +};
> +
[...]
> +static int lp8788_adc_read_raw(struct iio_dev *indio_dev,
> +			struct iio_chan_spec const *chan,
> +			int *val, int *val2, long mask)
> +{
> +	struct lp8788_adc *adc = iio_priv(indio_dev);
> +	enum lp8788_adc_id id = chan->channel;
> +	int ret;
> +
> +	mutex_lock(&adc->lock);
> +
> +	switch (mask) {
> +	case IIO_CHAN_INFO_RAW:
> +		ret = lp8788_get_adc_result(adc, id, val) ? -EIO : IIO_VAL_INT;
> +		break;
> +	case IIO_CHAN_INFO_SCALE:
> +		*val = (lp8788_scale[id] / 1000) * 1000;
> +		*val2 = (lp8788_scale[id] % 1000) * 1000000;

This looks suspicious. E.g. if the entry in your table has the value "1234"
you'd end up with a scale factor of 1000.234000000. Which looks wrong for
two reasons, given that you return INT_PLUS_MICRO val2 should never exceed 6
decimal digits and secondly val is multiplied by a factor of thousand.

Can you tell us in what unit the values in lp8788_scale are, that would make
review easier.

> +		ret = IIO_VAL_INT_PLUS_MICRO;
> +		break;
> +	default:
> +		ret = -EINVAL;
> +		break;
> +	}
> +
> +	mutex_unlock(&adc->lock);
> +
> +	return ret;
> +}
> +
> +static const struct iio_info lp8788_adc_info = {
> +	.read_raw = &lp8788_adc_read_raw,
> +	.driver_module = THIS_MODULE,
> +};
> +
> +#define LP8788_CHAN(_id, _type) {				\
> +		.type = _type,					\
> +		.indexed = 1,					\
> +		.channel = LPADC_##_id,				\
> +		.info_mask = IIO_CHAN_INFO_RAW_SEPARATE_BIT |	\
> +			IIO_CHAN_INFO_SCALE_SEPARATE_BIT,	\
> +		.address = LP8788_ADC_RAW,			\
> +		.scan_type = IIO_ST('u', 12, 16, 0),		\
> +		.scan_index = 1,				\
> +		.datasheet_name = "LP8788_"#_id,			\

I'd drop the "LP8788_" prefix.

> +}
> +
[...]
> +static int lp8788_iio_map_register(struct iio_dev *indio_dev,
> +				struct lp8788_platform_data *pdata,
> +				struct lp8788_adc *adc)
> +{
> +	struct iio_map *map;
> +	int ret;
> +
> +	map = !pdata || !pdata->adc_pdata ?

This could use a pair of parenthesis.

> +		lp8788_default_iio_maps : pdata->adc_pdata;
> +
> +	ret = iio_map_array_register(indio_dev, map);
> +	if (ret) {
> +		dev_err(adc->lp->dev, "iio map err: %d\n", ret);
> +		return ret;
> +	}
> +
> +	adc->map = map;
> +	return 0;
> +}
> +

[...]
> +static int __devexit lp8788_adc_remove(struct platform_device *pdev)
> +{
> +	struct iio_dev *indio_dev =  platform_get_drvdata(pdev);

extra space.

> +	struct lp8788_adc *adc = iio_priv(indio_dev);
> +
> +	iio_device_unregister(indio_dev);
> +	lp8788_iio_map_unregister(indio_dev, adc);
> +	iio_device_free(indio_dev);
> +
> +	return 0;
> +}


