Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756276Ab2HPIRW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 04:17:22 -0400
Received: from mailhost.informatik.uni-hamburg.de ([134.100.9.70]:42216 "EHLO
	mailhost.informatik.uni-hamburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755491Ab2HPIRQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 04:17:16 -0400
Message-ID: <502CAC6F.20105@metafoo.de>
Date: Thu, 16 Aug 2012 10:16:47 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20120613 Icedove/3.0.11
MIME-Version: 1.0
To: "Kim, Milo" <Milo.Kim@ti.com>
CC: Jonathan Cameron <jic23@kernel.org>, "jic23@cam.ac.uk" <jic23@cam.ac.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>,
        Sangwook Lee <sangwook.lee@linaro.org>
Subject: Re: [PATCH v3 3/3] iio: adc: add new lp8788 adc driver
References: <A874F61F95741C4A9BA573A70FE3998F41EEFD7E@DQHE02.ent.ti.com>
In-Reply-To: <A874F61F95741C4A9BA573A70FE3998F41EEFD7E@DQHE02.ent.ti.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/16/2012 09:39 AM, Kim, Milo wrote:
> Patch v3.
> (a) Delete unnecessary blank line of description
> (b) Sort alphabetical order for header
> (c) Replace udelay() with usleep_range()
> (d) Change read_raw() in case of scale and offset
>     : result can be calculated as raw * (scaleint + scalepart * 1000000) + offset.
>       (scale: micro unit)

For IIO it should actually be (raw + offset) * scale and the result should be
in the unit which is specified in the IIO sysfs ABI document. E.g. milivolts
for voltages.

[...]
> +
> +	if (lp8788_read_multi_bytes(adc->lp, LP8788_ADC_RAW, rawdata, size))
> +		goto err;
> +
> +	msb = (rawdata[0] << 4) & 0x00000ff0;
> +	lsb = (rawdata[1] >> 4) & 0x0000000f;
> +	result = msb | lsb;
> +
> +	/* iio consumer: result = raw * scale + offset */
> +	switch (mask) {
> +	case IIO_CHAN_INFO_RAW:
> +		*val = result;
> +		return IIO_VAL_INT;
> +	case IIO_CHAN_INFO_SCALE:
> +		*val = lp8788_scale[id];
> +		*val2 = 0;

Scale should be the number of millivolts per bit. Given the number in the table
above I somehow doubt that this is what you return here. Well or maybe this
part is actually used to measure up to a few kilo volts ;)

> +		return IIO_VAL_INT_PLUS_MICRO;
> +	case IIO_CHAN_INFO_OFFSET:
> +		*val = lp8788_scale[id] / 2;
> +		return IIO_VAL_INT;

As said above offset should be in the same unit as the raw result. I'd expect
it to be same for each channel.

Btw. how does the voltage mapping look in you case?

0x000 raw -> ? V
0x800 raw -> ? V
0xfff raw -> ? V

> +	default:
> +		break;
> +	}
> +
> +err:
> +	return -EINVAL;
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
> +		.scan_type = IIO_ST('u', 8, 12, 4),		\

This says your sample has 8 bits and you want to store them in a 12 bit word.
This seems wrong.


> +		.scan_index = 1,				\
> +		.datasheet_name = #_id,				\
> +}
> +
