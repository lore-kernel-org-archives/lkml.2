Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757209Ab0IBWBq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 18:01:46 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:42871 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754432Ab0IBWBo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 18:01:44 -0400
Date: Thu, 2 Sep 2010 23:19:42 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: achew@nvidia.com
Cc: linux-kernel@vger.kernel.org, linux-iio@vger.kernel.org,
        linux-i2c@vger.kernel.org, akpm@linux-foundation.org,
        khali@linux-fr.org, ldewangan@nvidia.com
Subject: Re: [PATCH 1/1] iio: ak8975: Add Ak8975 magnetometer sensor
Message-ID: <20100902231942.21375cc0@lxorguk.ukuu.org.uk>
In-Reply-To: <1283463351-15816-1-git-send-email-achew@nvidia.com>
References: <1283463351-15816-1-git-send-email-achew@nvidia.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +/*
> + * Shows the device's mode.  0 = off, 1 = on.
> + */

Should this not be handled by runtime pm nowdays ?

> +	if ((oval < 0) || (oval > 1)) {
> +		dev_err(dev, "mode value is not supported\n");
> +		return -EINVAL;
> +	}

ulong cannot be < 0 and doesn't need all the brackets


> +	/* Wait for the conversion to complete. */
> +	while (timeout_ms) {
> +		msleep(AK8975_CONVERSION_DONE_POLL_TIME);
> +		state = (gpio_get_value(data->eoc_gpio) ? 1 : 0);
> +		if (state)
> +			break;
> +		timeout_ms -= AK8975_CONVERSION_DONE_POLL_TIME;
> +	}

This makes some fairly specific wiring assumptions about how the ak8975
is configured. I'm looking at the ak8974 driver in our tree and also
wondering if they can be combined sanely.

> +	status = ak8975_read_data(client, AK8975_REG_ST1, 1, &read_status);
> +	if (!status) {
> +		dev_err(&client->dev, "Error in reading ST1\n");
> +		return false;

I would have expected these to return a meaningful error code not 0 ?

> +static IIO_DEVICE_ATTR(mode, S_IRUGO | S_IWUSR, show_mode, store_mode, 0);
> +static IIO_DEVICE_ATTR(magn_x_calibscale, S_IRUGO, show_calibscale, NULL, 0);
> +static IIO_DEVICE_ATTR(magn_y_calibscale, S_IRUGO, show_calibscale, NULL, 1);
> +static IIO_DEVICE_ATTR(magn_z_calibscale, S_IRUGO, show_calibscale, NULL, 2);
> +static IIO_DEV_ATTR_MAGN_X(show_raw, AK8975_REG_HXL);
> +static IIO_DEV_ATTR_MAGN_Y(show_raw, AK8975_REG_HYL);
> +static IIO_DEV_ATTR_MAGN_Z(show_raw, AK8975_REG_HZL);

This seems odd as an interface as it's raw when the maths to provide
non-raw (and thus abstract and easy for user space) data is trivial
enough to do in kernel

(but then I still suspect it should jusst be an input device of course)

> +static int ak8975_probe(struct i2c_client *client,
> +			const struct i2c_device_id *id)
> +{
> +	struct ak8975_data *data;
> +	int err;
> +
> +	/* Allocate our device context. */
> +	data = kzalloc(sizeof(struct ak8975_data), GFP_KERNEL);
> +	if (!data) {
> +		dev_err(&client->dev, "Memory allocation fails\n");
> +		err = -ENOMEM;
> +		goto exit;
> +	}
> +
> +	i2c_set_clientdata(client, data);
> +	data->client = client;
> +
> +	mutex_init(&data->lock);
> +
> +	/* Grab and set up the supplied GPIO. */
> +	data->eoc_irq = client->irq;
> +	data->eoc_gpio = irq_to_gpio(client->irq);

It may not be via a GPIO. Better to do the GPIO handling in platform
abstraction or accept passing IRQ and no GPIO value to mean "just use the
IRQ". Ie do all the gpio foo if (data->eoc_gpio) { ... }


> +
> +	err = gpio_request(data->eoc_gpio, "ak_8975");
> +	if (err < 0) {
> +		dev_err(&client->dev, "failed to request GPIO %d, error %d\n",
> +			data->eoc_gpio, err);
> +		goto exit_free;
> +	}
> +
> +	err = gpio_direction_input(data->eoc_gpio);
> +	if (err < 0) {
> +		dev_err(&client->dev, "Failed to configure input direction for"
> +			" GPIO %d, error %d\n", data->eoc_gpio, err);
> +		gpio_free(data->eoc_gpio);

This frees the GPIO twice ?

Looks basically sound to me.

Alan

