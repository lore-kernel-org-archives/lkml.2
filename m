Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753385Ab2KSJds (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 04:33:48 -0500
Received: from smtp-out-217.synserver.de ([212.40.185.217]:1166 "EHLO
	smtp-out-217.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753266Ab2KSJdq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 04:33:46 -0500
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 3603
Message-ID: <50A9FCFC.60002@metafoo.de>
Date: Mon, 19 Nov 2012 10:33:48 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.10) Gecko/20121027 Icedove/10.0.10
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@avionic-design.de>
CC: Jonathan Cameron <jic23@cam.ac.uk>, linux-iio@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] iio: adc: Add Texas Instruments ADC081C021/027 support
References: <1353313289-983-1-git-send-email-thierry.reding@avionic-design.de>
In-Reply-To: <1353313289-983-1-git-send-email-thierry.reding@avionic-design.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/19/2012 09:21 AM, Thierry Reding wrote:
> Add support for reading conversion results from the ADC and provide them
> through a single IIO channel. A proper scaling factor is also exported
> based on the reference voltage provided by a regulator.
> 
> Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
> ---
[...]
> +static int adc081c_read_raw(struct iio_dev *iio,
> +			    struct iio_chan_spec const *channel, int *value,
> +			    int *micro, long mask)
> +{
> +	struct adc081c *adc = iio_priv(iio);
> +	int err, scale;
> +
> +	switch (mask) {
> +	case IIO_CHAN_INFO_RAW:
> +		err = i2c_smbus_read_word_swapped(adc->i2c, REG_CONV_RES);
> +		if (err < 0)
> +			return err;
> +
> +		*value = (err >> 4) & 0xff;
> +		return IIO_VAL_INT;
> +
> +	case IIO_CHAN_INFO_SCALE:
> +		err = regulator_get_voltage(adc->ref);
> +		if (err < 0)
> +			return err;
> +
> +		scale = err / 255;

Shouldn't this be 256?

> +
> +		*value = scale / 1000000;
> +		*micro = scale % 1000000;

scale for voltages is in microvolt, so I think it this is off by a factor of
1000.

For ADCs it often makes sense to use IIO_VAL_FRACTIONAL_LOG2 with the val
being set to the reference voltage (in mV) and val2 being set to the number
of bits.

E.g in your case

		*val = err / 1000;
		*val2 = 8;

> +
> +		return IIO_VAL_INT_PLUS_MICRO;
> +
> +	default:
> +		break;
> +	}
> +
> +	return -EINVAL;
> +}
> +
> +static const struct iio_info adc081c_info = {
> +	.read_raw = adc081c_read_raw,
> +	.driver_module = THIS_MODULE,
> +};
> +
> +static int adc081c_probe(struct i2c_client *client,
> +			 const struct i2c_device_id *id)
> +{
> +	struct iio_dev *iio;
> +	struct adc081c *adc;
> +	int err;
> +
> +	if (!i2c_check_functionality(client->adapter, I2C_FUNC_SMBUS_WORD_DATA))
> +		return -ENODEV;
> +
> +	iio = iio_device_alloc(sizeof(*adc));
> +	if (!iio)
> +		return -ENOMEM;
> +
> +	adc = iio_priv(iio);
> +	adc->i2c = client;
> +
> +	adc->ref = regulator_get(&client->dev, "vref");
> +	if (IS_ERR(adc->ref)) {
> +		err = PTR_ERR(adc->ref);
> +		goto iio_free;
> +	}
> +
> +	err = regulator_enable(adc->ref);
> +	if (err < 0)
> +		goto regulator_put;
> +
> +	iio->dev.parent = &client->dev;
> +	iio->name = dev_name(&client->dev);
> +	iio->modes = INDIO_DIRECT_MODE;
> +	iio->info = &adc081c_info;
> +
> +	adc->channel.type = IIO_VOLTAGE;
> +	adc->channel.info_mask = IIO_CHAN_INFO_SCALE_SHARED_BIT |
> +				 IIO_CHAN_INFO_RAW_SEPARATE_BIT;

nitpick: Since it is the same for each driver I'd make the channel static const.

> +
> +	iio->channels = &adc->channel;
> +	iio->num_channels = 1;
> +
[...]

