Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752321Ab0ICFTX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 01:19:23 -0400
Received: from smtp.nokia.com ([192.100.105.134]:42932 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750809Ab0ICFTV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 01:19:21 -0400
From: <samu.p.onkalo@nokia.com>
To: <alan@lxorguk.ukuu.org.uk>, <achew@nvidia.com>
CC: <linux-kernel@vger.kernel.org>, <linux-iio@vger.kernel.org>,
        <linux-i2c@vger.kernel.org>, <akpm@linux-foundation.org>,
        <khali@linux-fr.org>, <ldewangan@nvidia.com>
Date: Fri, 3 Sep 2010 07:18:34 +0200
Subject: RE: [PATCH 1/1] iio: ak8975: Add Ak8975 magnetometer sensor
Thread-Topic: [PATCH 1/1] iio: ak8975: Add Ak8975 magnetometer sensor
Thread-Index: ActK6npYXcHL3g40TOyVwAQ2WpP23gAOwmSw
Message-ID: <62697B07E9803846BC582181BD6FB6B82B9C057FFC@NOK-EUMSG-02.mgdnok.nokia.com>
References: <1283463351-15816-1-git-send-email-achew@nvidia.com>
 <20100902231942.21375cc0@lxorguk.ukuu.org.uk>
In-Reply-To: <20100902231942.21375cc0@lxorguk.ukuu.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginalArrivalTime: 03 Sep 2010 05:18:37.0627 (UTC) FILETIME=[76A120B0:01CB4B27]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



>-----Original Message-----
>From: linux-iio-owner@vger.kernel.org [mailto:linux-iio-
>owner@vger.kernel.org] On Behalf Of ext Alan Cox
>Sent: 03 September, 2010 01:20
>To: achew@nvidia.com
>Cc: linux-kernel@vger.kernel.org; linux-iio@vger.kernel.org; linux-
>i2c@vger.kernel.org; akpm@linux-foundation.org; khali@linux-fr.org;
>ldewangan@nvidia.com
>Subject: Re: [PATCH 1/1] iio: ak8975: Add Ak8975 magnetometer sensor
>
>> +/*
>> + * Shows the device's mode.  0 = off, 1 = on.
>> + */
>
>Should this not be handled by runtime pm nowdays ?
>
>> +	if ((oval < 0) || (oval > 1)) {
>> +		dev_err(dev, "mode value is not supported\n");
>> +		return -EINVAL;
>> +	}
>
>ulong cannot be < 0 and doesn't need all the brackets
>
>
>> +	/* Wait for the conversion to complete. */
>> +	while (timeout_ms) {
>> +		msleep(AK8975_CONVERSION_DONE_POLL_TIME);
>> +		state = (gpio_get_value(data->eoc_gpio) ? 1 : 0);
>> +		if (state)
>> +			break;
>> +		timeout_ms -= AK8975_CONVERSION_DONE_POLL_TIME;
>> +	}
>
>This makes some fairly specific wiring assumptions about how the ak8975
>is configured. I'm looking at the ak8974 driver in our tree and also
>wondering if they can be combined sanely.

With ak8974 chip, it is possible to have similar functionality without interrupt
pin. This is most probably true also for ak8975 chip. It is not good to assume
that everyone uses interrupt pin if the same functionally can be achieved
another way. I mean polling via I2C instead of checking GPIO state after the
sleep. 

Based on the this driver it seems that ak8974 and ak8975 are quite similar, but
also there are many differences like different register map. Maybe combining
these two makes implementation just messy.


>
>> +	status = ak8975_read_data(client, AK8975_REG_ST1, 1,
>&read_status);
>> +	if (!status) {
>> +		dev_err(&client->dev, "Error in reading ST1\n");
>> +		return false;
>
>I would have expected these to return a meaningful error code not 0 ?
>
>> +static IIO_DEVICE_ATTR(mode, S_IRUGO | S_IWUSR, show_mode,
>store_mode, 0);
>> +static IIO_DEVICE_ATTR(magn_x_calibscale, S_IRUGO, show_calibscale,
>NULL, 0);
>> +static IIO_DEVICE_ATTR(magn_y_calibscale, S_IRUGO, show_calibscale,
>NULL, 1);
>> +static IIO_DEVICE_ATTR(magn_z_calibscale, S_IRUGO, show_calibscale,
>NULL, 2);
>> +static IIO_DEV_ATTR_MAGN_X(show_raw, AK8975_REG_HXL);
>> +static IIO_DEV_ATTR_MAGN_Y(show_raw, AK8975_REG_HYL);
>> +static IIO_DEV_ATTR_MAGN_Z(show_raw, AK8975_REG_HZL);
>
>This seems odd as an interface as it's raw when the maths to provide
>non-raw (and thus abstract and easy for user space) data is trivial
>enough to do in kernel
>
>(but then I still suspect it should jusst be an input device of course)
>
>> +static int ak8975_probe(struct i2c_client *client,
>> +			const struct i2c_device_id *id)
>> +{
>> +	struct ak8975_data *data;
>> +	int err;
>> +
>> +	/* Allocate our device context. */
>> +	data = kzalloc(sizeof(struct ak8975_data), GFP_KERNEL);
>> +	if (!data) {
>> +		dev_err(&client->dev, "Memory allocation fails\n");
>> +		err = -ENOMEM;
>> +		goto exit;
>> +	}
>> +
>> +	i2c_set_clientdata(client, data);
>> +	data->client = client;
>> +
>> +	mutex_init(&data->lock);
>> +
>> +	/* Grab and set up the supplied GPIO. */
>> +	data->eoc_irq = client->irq;
>> +	data->eoc_gpio = irq_to_gpio(client->irq);
>
>It may not be via a GPIO. Better to do the GPIO handling in platform
>abstraction or accept passing IRQ and no GPIO value to mean "just use
>the
>IRQ". Ie do all the gpio foo if (data->eoc_gpio) { ... }
>
>
>> +
>> +	err = gpio_request(data->eoc_gpio, "ak_8975");
>> +	if (err < 0) {
>> +		dev_err(&client->dev, "failed to request GPIO %d, error
>%d\n",
>> +			data->eoc_gpio, err);
>> +		goto exit_free;
>> +	}
>> +
>> +	err = gpio_direction_input(data->eoc_gpio);
>> +	if (err < 0) {
>> +		dev_err(&client->dev, "Failed to configure input direction
>for"
>> +			" GPIO %d, error %d\n", data->eoc_gpio, err);
>> +		gpio_free(data->eoc_gpio);
>
>This frees the GPIO twice ?
>
>Looks basically sound to me.
>
>Alan
>
>--
>To unsubscribe from this list: send the line "unsubscribe linux-iio" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
