Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756142Ab1DFOC0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 10:02:26 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:44118 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755984Ab1DFOCZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 10:02:25 -0400
Date: Wed, 6 Apr 2011 15:02:32 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jonathan Cameron <jic23@cam.ac.uk>
Cc: Alan Cox <alan@linux.jf.intel.com>, linux-kernel@vger.kernel.org,
        greg@kroah.com,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>
Subject: Re: [PATCH] oaktrail AK8975 support via IIO
Message-ID: <20110406150232.56ab2408@lxorguk.ukuu.org.uk>
In-Reply-To: <4D9C6F82.5060404@cam.ac.uk>
References: <20110406123114.17742.10936.stgit@localhost.localdomain>
	<4D9C6D1F.30007@cam.ac.uk>
	<4D9C6F82.5060404@cam.ac.uk>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >> +static int wait_conversion_complete_gpio(struct ak8975_data *data)
> >> +{
> >> +	struct i2c_client *client = data->client;
> >> +	u8 read_status;
> >> +	u32 timeout_ms = AK8975_MAX_CONVERSION_TIMEOUT;
> >> +	int ret;
> >> +
> >> +	/* Wait for the conversion to complete. */
> >> +	while (timeout_ms) {
> >> +		msleep(AK8975_CONVERSION_DONE_POLL_TIME);
> >> +		if (gpio_get_value(data->eoc_gpio))
> >> +			break;
> >> +		timeout_ms -= AK8975_CONVERSION_DONE_POLL_TIME;
> >> +	}
> >> +	if (!timeout_ms) {
> >> +		dev_err(&client->dev, "Conversion timeout happened\n");
> >> +		return -EINVAL;
> >> +	}
> >> +
> >> +	ret = ak8975_read_data(client, AK8975_REG_ST1, 1, &read_status);
> >> +	if (ret < 0) {
> >> +		dev_err(&client->dev, "Error in reading ST1\n");
> >> +		return ret;
> >> +	}
> >> +	return read_status;
> >> +}
> >> +
> Its not immediately obvious to me why we need these two separate functions.
> They only differ by a couple of lines.  Perhaps push querying if the gpio
> down into a single function?

That was actually my starting point but they are quite different - one
does the gpio check each loop then a read, the other does a read each
loop and then nothing. Mixed together you get 

	while() {
		if
			if
		else
			if
		
	}
	if

	else

and it looks like spagetti ..




> >> +static int wait_conversion_complete_polled(struct ak8975_data *data)
> >> +{
> >> +	struct i2c_client *client = data->client;
> >> +	u8 read_status;
> >> +	u32 timeout_ms = AK8975_MAX_CONVERSION_TIMEOUT;
> >> +	int ret;
> >> +
> >> +	/* Wait for the conversion to complete. */
> >> +	while (timeout_ms) {
> >> +		msleep(AK8975_CONVERSION_DONE_POLL_TIME);
> >> +		ret = ak8975_read_data(client, AK8975_REG_ST1, 1, &read_status);
> >> +		if (ret < 0) {
> >> +			dev_err(&client->dev, "Error in reading ST1\n");
> >> +			return ret;
> >> +		}
> >> +		if (read_status)
> >> +			break;
> >> +		timeout_ms -= AK8975_CONVERSION_DONE_POLL_TIME;
> >> +	}
> >> +	if (!timeout_ms) {
> >> +		dev_err(&client->dev, "Conversion timeout happened\n");
> >> +		return -EINVAL;
> >> +	}
> >> +	return read_status;
> >> +}
> >> +
> >>  /*
> >>   * Emits the raw flux value for the x, y, or z axis.
> >>   */
> >> @@ -326,7 +379,6 @@ static ssize_t show_raw(struct device *dev, struct device_attribute *devattr,
> >>  	struct ak8975_data *data = indio_dev->dev_data;
> >>  	struct i2c_client *client = data->client;
> >>  	struct iio_dev_attr *this_attr = to_iio_dev_attr(devattr);
> >> -	u32 timeout_ms = AK8975_MAX_CONVERSION_TIMEOUT;
> >>  	u16 meas_reg;
> >>  	s16 raw;
> >>  	u8 read_status;
> >> @@ -352,23 +404,14 @@ static ssize_t show_raw(struct device *dev, struct device_attribute *devattr,
> >>  	}
> >>  
> >>  	/* Wait for the conversion to complete. */
> >> -	while (timeout_ms) {
> >> -		msleep(AK8975_CONVERSION_DONE_POLL_TIME);
> >> -		if (gpio_get_value(data->eoc_gpio))
> >> -			break;
> >> -		timeout_ms -= AK8975_CONVERSION_DONE_POLL_TIME;
> >> -	}
> >> -	if (!timeout_ms) {
> >> -		dev_err(&client->dev, "Conversion timeout happened\n");
> >> -		ret = -EINVAL;
> >> +	if (data->eoc_gpio)
> >> +		ret = wait_conversion_complete_gpio(data);
> >> +	else
> >> +		ret = wait_conversion_complete_polled(data);
> >> +	if (ret < 0)
> >>  		goto exit;
> >> -	}
> >>  
> >> -	ret = ak8975_read_data(client, AK8975_REG_ST1, 1, &read_status);
> >> -	if (ret < 0) {
> >> -		dev_err(&client->dev, "Error in reading ST1\n");
> >> -		goto exit;
> >> -	}
> >> +	read_status = ret;
> >>  
> >>  	if (read_status & AK8975_REG_ST1_DRDY_MASK) {
> >>  		ret = ak8975_read_data(client, AK8975_REG_ST2, 1, &read_status);
> >> @@ -454,25 +497,26 @@ static int ak8975_probe(struct i2c_client *client,
> >>  	data->eoc_irq = client->irq;
> >>  	data->eoc_gpio = irq_to_gpio(client->irq);
> >>  
> >> -	if (!data->eoc_gpio) {
> >> -		dev_err(&client->dev, "failed, no valid GPIO\n");
> >> -		err = -EINVAL;
> >> -		goto exit_free;
> >> -	}
> >> -
> >> -	err = gpio_request(data->eoc_gpio, "ak_8975");
> >> -	if (err < 0) {
> >> -		dev_err(&client->dev, "failed to request GPIO %d, error %d\n",
> >> -			data->eoc_gpio, err);
> >> -		goto exit_free;
> >> -	}
> >> +	/* We may not have a GPIO based IRQ to scan, that is fine, we will
> >> +	   poll if so */
> >> +	if (data->eoc_gpio > 0) {
> >> +		err = gpio_request(data->eoc_gpio, "ak_8975");
> >> +		if (err < 0) {
> >> +			dev_err(&client->dev,
> >> +				"failed to request GPIO %d, error %d\n",
> >> +							data->eoc_gpio, err);
> >> +			goto exit_free;
> >> +		}
> >>  
> >> -	err = gpio_direction_input(data->eoc_gpio);
> >> -	if (err < 0) {
> >> -		dev_err(&client->dev, "Failed to configure input direction for"
> >> -			" GPIO %d, error %d\n", data->eoc_gpio, err);
> >> -		goto exit_gpio;
> >> -	}
> >> +		err = gpio_direction_input(data->eoc_gpio);
> >> +		if (err < 0) {
> >> +			dev_err(&client->dev,
> >> +				"Failed to configure input direction for GPIO %d, error %d\n",
> >> +						data->eoc_gpio, err);
> >> +			goto exit_gpio;
> Not really relevant to this patch, but this handling could be cleaned up using gpio_request_one.
> >> +		}
> >> +	} else
> >> +		data->eoc_gpio = 0;	/* No GPIO available */
> >>  
> >>  	/* Perform some basic start-of-day setup of the device. */
> >>  	err = ak8975_setup(client);
> >> @@ -503,7 +547,8 @@ static int ak8975_probe(struct i2c_client *client,
> >>  exit_free_iio:
> >>  	iio_free_device(data->indio_dev);
> >>  exit_gpio:
> >> -	gpio_free(data->eoc_gpio);
> >> +	if (data->eoc_gpio)
> >> +		gpio_free(data->eoc_gpio);
> >>  exit_free:
> >>  	kfree(data);
> >>  exit:
> >> @@ -517,7 +562,8 @@ static int ak8975_remove(struct i2c_client *client)
> >>  	iio_device_unregister(data->indio_dev);
> >>  	iio_free_device(data->indio_dev);
> >>  
> >> -	gpio_free(data->eoc_gpio);
> >> +	if (data->eoc_gpio)
> >> +		gpio_free(data->eoc_gpio);
> >>  
> >>  	kfree(data);
> >>  
> >>
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-iio" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


-- 
--
	"Alan, I'm getting a bit worried about you."
				-- Linus Torvalds
