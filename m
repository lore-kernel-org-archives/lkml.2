Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755784Ab1DHQ7o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Apr 2011 12:59:44 -0400
Received: from ppsw-41.csi.cam.ac.uk ([131.111.8.141]:47592 "EHLO
	ppsw-41.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752161Ab1DHQ7n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Apr 2011 12:59:43 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4D9F3F64.7060909@cam.ac.uk>
Date: Fri, 08 Apr 2011 18:01:24 +0100
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20110122 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: Alan Cox <alan@linux.intel.com>
CC: linux-kernel@vger.kernel.org, greg@kroah.com
Subject: Re: [PATCH] oaktrail AK8975 support via IIO
References: <20110406123114.17742.10936.stgit@localhost.localdomain>
In-Reply-To: <20110406123114.17742.10936.stgit@localhost.localdomain>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/06/11 13:31, Alan Cox wrote:
> Actually this is generic 'I have no GPIO' support for the AK8975, instead
> we have to go bus polling.
> 
> Huang Liang produced an initial patch which worked by removing the support
> for GPIO pins. This patch instead makes GPIO support optional and Huang then
> fixed some bugs in it.

I think this is just a resend in which case I'll add my ack again (it was
buried deep in the thread last time.)
> 
> Signed-off-by: Alan Cox <alan@linux.intel.com>
Acked-by: Jonathan Cameron <jic23@cam.ac.uk>
> > 

> ---
> 
>  drivers/staging/iio/magnetometer/ak8975.c |  120 ++++++++++++++++++++---------
>  1 files changed, 83 insertions(+), 37 deletions(-)
> 
> diff --git a/drivers/staging/iio/magnetometer/ak8975.c b/drivers/staging/iio/magnetometer/ak8975.c
> index 420f206..d71904a 100644
> --- a/drivers/staging/iio/magnetometer/ak8975.c
> +++ b/drivers/staging/iio/magnetometer/ak8975.c
> @@ -206,7 +206,7 @@ static int ak8975_setup(struct i2c_client *client)
>  	}
>  
>  	/* Precalculate scale factor for each axis and
> -           store in the device data. */
> +	   store in the device data. */
>  	data->raw_to_gauss[0] = ((data->asa[0] + 128) * 30) >> 8;
>  	data->raw_to_gauss[1] = ((data->asa[1] + 128) * 30) >> 8;
>  	data->raw_to_gauss[2] = ((data->asa[2] + 128) * 30) >> 8;
> @@ -316,6 +316,59 @@ static ssize_t show_scale(struct device *dev, struct device_attribute *devattr,
>  	return sprintf(buf, "%ld\n", data->raw_to_gauss[this_attr->address]);
>  }
>  
> +static int wait_conversion_complete_gpio(struct ak8975_data *data)
> +{
> +	struct i2c_client *client = data->client;
> +	u8 read_status;
> +	u32 timeout_ms = AK8975_MAX_CONVERSION_TIMEOUT;
> +	int ret;
> +
> +	/* Wait for the conversion to complete. */
> +	while (timeout_ms) {
> +		msleep(AK8975_CONVERSION_DONE_POLL_TIME);
> +		if (gpio_get_value(data->eoc_gpio))
> +			break;
> +		timeout_ms -= AK8975_CONVERSION_DONE_POLL_TIME;
> +	}
> +	if (!timeout_ms) {
> +		dev_err(&client->dev, "Conversion timeout happened\n");
> +		return -EINVAL;
> +	}
> +
> +	ret = ak8975_read_data(client, AK8975_REG_ST1, 1, &read_status);
> +	if (ret < 0) {
> +		dev_err(&client->dev, "Error in reading ST1\n");
> +		return ret;
> +	}
> +	return read_status;
> +}
> +
> +static int wait_conversion_complete_polled(struct ak8975_data *data)
> +{
> +	struct i2c_client *client = data->client;
> +	u8 read_status;
> +	u32 timeout_ms = AK8975_MAX_CONVERSION_TIMEOUT;
> +	int ret;
> +
> +	/* Wait for the conversion to complete. */
> +	while (timeout_ms) {
> +		msleep(AK8975_CONVERSION_DONE_POLL_TIME);
> +		ret = ak8975_read_data(client, AK8975_REG_ST1, 1, &read_status);
> +		if (ret < 0) {
> +			dev_err(&client->dev, "Error in reading ST1\n");
> +			return ret;
> +		}
> +		if (read_status)
> +			break;
> +		timeout_ms -= AK8975_CONVERSION_DONE_POLL_TIME;
> +	}
> +	if (!timeout_ms) {
> +		dev_err(&client->dev, "Conversion timeout happened\n");
> +		return -EINVAL;
> +	}
> +	return read_status;
> +}
> +
>  /*
>   * Emits the raw flux value for the x, y, or z axis.
>   */
> @@ -326,7 +379,6 @@ static ssize_t show_raw(struct device *dev, struct device_attribute *devattr,
>  	struct ak8975_data *data = indio_dev->dev_data;
>  	struct i2c_client *client = data->client;
>  	struct iio_dev_attr *this_attr = to_iio_dev_attr(devattr);
> -	u32 timeout_ms = AK8975_MAX_CONVERSION_TIMEOUT;
>  	u16 meas_reg;
>  	s16 raw;
>  	u8 read_status;
> @@ -352,23 +404,14 @@ static ssize_t show_raw(struct device *dev, struct device_attribute *devattr,
>  	}
>  
>  	/* Wait for the conversion to complete. */
> -	while (timeout_ms) {
> -		msleep(AK8975_CONVERSION_DONE_POLL_TIME);
> -		if (gpio_get_value(data->eoc_gpio))
> -			break;
> -		timeout_ms -= AK8975_CONVERSION_DONE_POLL_TIME;
> -	}
> -	if (!timeout_ms) {
> -		dev_err(&client->dev, "Conversion timeout happened\n");
> -		ret = -EINVAL;
> +	if (data->eoc_gpio)
> +		ret = wait_conversion_complete_gpio(data);
> +	else
> +		ret = wait_conversion_complete_polled(data);
> +	if (ret < 0)
>  		goto exit;
> -	}
>  
> -	ret = ak8975_read_data(client, AK8975_REG_ST1, 1, &read_status);
> -	if (ret < 0) {
> -		dev_err(&client->dev, "Error in reading ST1\n");
> -		goto exit;
> -	}
> +	read_status = ret;
>  
>  	if (read_status & AK8975_REG_ST1_DRDY_MASK) {
>  		ret = ak8975_read_data(client, AK8975_REG_ST2, 1, &read_status);
> @@ -454,25 +497,26 @@ static int ak8975_probe(struct i2c_client *client,
>  	data->eoc_irq = client->irq;
>  	data->eoc_gpio = irq_to_gpio(client->irq);
>  
> -	if (!data->eoc_gpio) {
> -		dev_err(&client->dev, "failed, no valid GPIO\n");
> -		err = -EINVAL;
> -		goto exit_free;
> -	}
> -
> -	err = gpio_request(data->eoc_gpio, "ak_8975");
> -	if (err < 0) {
> -		dev_err(&client->dev, "failed to request GPIO %d, error %d\n",
> -			data->eoc_gpio, err);
> -		goto exit_free;
> -	}
> +	/* We may not have a GPIO based IRQ to scan, that is fine, we will
> +	   poll if so */
> +	if (data->eoc_gpio > 0) {
> +		err = gpio_request(data->eoc_gpio, "ak_8975");
> +		if (err < 0) {
> +			dev_err(&client->dev,
> +				"failed to request GPIO %d, error %d\n",
> +							data->eoc_gpio, err);
> +			goto exit_free;
> +		}
>  
> -	err = gpio_direction_input(data->eoc_gpio);
> -	if (err < 0) {
> -		dev_err(&client->dev, "Failed to configure input direction for"
> -			" GPIO %d, error %d\n", data->eoc_gpio, err);
> -		goto exit_gpio;
> -	}
> +		err = gpio_direction_input(data->eoc_gpio);
> +		if (err < 0) {
> +			dev_err(&client->dev,
> +				"Failed to configure input direction for GPIO %d, error %d\n",
> +						data->eoc_gpio, err);
> +			goto exit_gpio;
> +		}
> +	} else
> +		data->eoc_gpio = 0;	/* No GPIO available */
>  
>  	/* Perform some basic start-of-day setup of the device. */
>  	err = ak8975_setup(client);
> @@ -503,7 +547,8 @@ static int ak8975_probe(struct i2c_client *client,
>  exit_free_iio:
>  	iio_free_device(data->indio_dev);
>  exit_gpio:
> -	gpio_free(data->eoc_gpio);
> +	if (data->eoc_gpio)
> +		gpio_free(data->eoc_gpio);
>  exit_free:
>  	kfree(data);
>  exit:
> @@ -517,7 +562,8 @@ static int ak8975_remove(struct i2c_client *client)
>  	iio_device_unregister(data->indio_dev);
>  	iio_free_device(data->indio_dev);
>  
> -	gpio_free(data->eoc_gpio);
> +	if (data->eoc_gpio)
> +		gpio_free(data->eoc_gpio);
>  
>  	kfree(data);
>  
> 
> 

