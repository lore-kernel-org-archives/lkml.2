Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754598Ab0ICHSh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 03:18:37 -0400
Received: from ppsw-33.csi.cam.ac.uk ([131.111.8.133]:53155 "EHLO
	ppsw-33.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752755Ab0ICHSf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 03:18:35 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4C80A26F.6020408@cam.ac.uk>
Date: Fri, 03 Sep 2010 08:23:27 +0100
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.8) Gecko/20100830 Lightning/1.0b2pre Thunderbird/3.1.2
MIME-Version: 1.0
To: samu.p.onkalo@nokia.com
CC: alan@lxorguk.ukuu.org.uk, achew@nvidia.com, linux-kernel@vger.kernel.org,
        linux-iio@vger.kernel.org, linux-i2c@vger.kernel.org,
        akpm@linux-foundation.org, khali@linux-fr.org, ldewangan@nvidia.com
Subject: Re: [PATCH 1/1] iio: ak8975: Add Ak8975 magnetometer sensor
References: <1283463351-15816-1-git-send-email-achew@nvidia.com> <20100902231942.21375cc0@lxorguk.ukuu.org.uk> <62697B07E9803846BC582181BD6FB6B82B9C057FFC@NOK-EUMSG-02.mgdnok.nokia.com>
In-Reply-To: <62697B07E9803846BC582181BD6FB6B82B9C057FFC@NOK-EUMSG-02.mgdnok.nokia.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/03/10 06:18, samu.p.onkalo@nokia.com wrote:
> 
> 
>> -----Original Message-----
>> From: linux-iio-owner@vger.kernel.org [mailto:linux-iio-
>> owner@vger.kernel.org] On Behalf Of ext Alan Cox
>> Sent: 03 September, 2010 01:20
>> To: achew@nvidia.com
>> Cc: linux-kernel@vger.kernel.org; linux-iio@vger.kernel.org; linux-
>> i2c@vger.kernel.org; akpm@linux-foundation.org; khali@linux-fr.org;
>> ldewangan@nvidia.com
>> Subject: Re: [PATCH 1/1] iio: ak8975: Add Ak8975 magnetometer sensor
>>
>>> +/*
>>> + * Shows the device's mode.  0 = off, 1 = on.
>>> + */
>>
>> Should this not be handled by runtime pm nowdays ?
>>
>>> +	if ((oval < 0) || (oval > 1)) {
>>> +		dev_err(dev, "mode value is not supported\n");
>>> +		return -EINVAL;
>>> +	}
>>
>> ulong cannot be < 0 and doesn't need all the brackets
>>
>>
>>> +	/* Wait for the conversion to complete. */
>>> +	while (timeout_ms) {
>>> +		msleep(AK8975_CONVERSION_DONE_POLL_TIME);
>>> +		state = (gpio_get_value(data->eoc_gpio) ? 1 : 0);
>>> +		if (state)
>>> +			break;
>>> +		timeout_ms -= AK8975_CONVERSION_DONE_POLL_TIME;
>>> +	}
>>
>> This makes some fairly specific wiring assumptions about how the ak8975
>> is configured. I'm looking at the ak8974 driver in our tree and also
>> wondering if they can be combined sanely.
> 
> With ak8974 chip, it is possible to have similar functionality without interrupt
> pin. This is most probably true also for ak8975 chip. It is not good to assume
> that everyone uses interrupt pin if the same functionally can be achieved
> another way. I mean polling via I2C instead of checking GPIO state after the
> sleep. 
Of course this can be done, but it's up to Andrew to decide whether he wants to.
I think the usual principal of writing only what people currently need applies
here.  Perhaps a comment in the code to point out this could be done is a sensible
compromise?  
> 
> Based on the this driver it seems that ak8974 and ak8975 are quite similar, but
> also there are many differences like different register map. Maybe combining
> these two makes implementation just messy.
> 
> 
>>
>>> +	status = ak8975_read_data(client, AK8975_REG_ST1, 1,
>> &read_status);
>>> +	if (!status) {
>>> +		dev_err(&client->dev, "Error in reading ST1\n");
>>> +		return false;
>>
>> I would have expected these to return a meaningful error code not 0 ?
>>
>>> +static IIO_DEVICE_ATTR(mode, S_IRUGO | S_IWUSR, show_mode,
>> store_mode, 0);
>>> +static IIO_DEVICE_ATTR(magn_x_calibscale, S_IRUGO, show_calibscale,
>> NULL, 0);
>>> +static IIO_DEVICE_ATTR(magn_y_calibscale, S_IRUGO, show_calibscale,
>> NULL, 1);
>>> +static IIO_DEVICE_ATTR(magn_z_calibscale, S_IRUGO, show_calibscale,
>> NULL, 2);
>>> +static IIO_DEV_ATTR_MAGN_X(show_raw, AK8975_REG_HXL);
>>> +static IIO_DEV_ATTR_MAGN_Y(show_raw, AK8975_REG_HYL);
>>> +static IIO_DEV_ATTR_MAGN_Z(show_raw, AK8975_REG_HZL);
>>
>> This seems odd as an interface as it's raw when the maths to provide
>> non-raw (and thus abstract and easy for user space) data is trivial
>> enough to do in kernel
>>
>> (but then I still suspect it should jusst be an input device of course)
>>
>>> +static int ak8975_probe(struct i2c_client *client,
>>> +			const struct i2c_device_id *id)
>>> +{
>>> +	struct ak8975_data *data;
>>> +	int err;
>>> +
>>> +	/* Allocate our device context. */
>>> +	data = kzalloc(sizeof(struct ak8975_data), GFP_KERNEL);
>>> +	if (!data) {
>>> +		dev_err(&client->dev, "Memory allocation fails\n");
>>> +		err = -ENOMEM;
>>> +		goto exit;
>>> +	}
>>> +
>>> +	i2c_set_clientdata(client, data);
>>> +	data->client = client;
>>> +
>>> +	mutex_init(&data->lock);
>>> +
>>> +	/* Grab and set up the supplied GPIO. */
>>> +	data->eoc_irq = client->irq;
>>> +	data->eoc_gpio = irq_to_gpio(client->irq);
>>
>> It may not be via a GPIO. Better to do the GPIO handling in platform
>> abstraction or accept passing IRQ and no GPIO value to mean "just use
>> the
>> IRQ". Ie do all the gpio foo if (data->eoc_gpio) { ... }
>>
>>
>>> +
>>> +	err = gpio_request(data->eoc_gpio, "ak_8975");
>>> +	if (err < 0) {
>>> +		dev_err(&client->dev, "failed to request GPIO %d, error
>> %d\n",
>>> +			data->eoc_gpio, err);
>>> +		goto exit_free;
>>> +	}
>>> +
>>> +	err = gpio_direction_input(data->eoc_gpio);
>>> +	if (err < 0) {
>>> +		dev_err(&client->dev, "Failed to configure input direction
>> for"
>>> +			" GPIO %d, error %d\n", data->eoc_gpio, err);
>>> +		gpio_free(data->eoc_gpio);
>>
>> This frees the GPIO twice ?
>>
>> Looks basically sound to me.
>>
>> Alan
