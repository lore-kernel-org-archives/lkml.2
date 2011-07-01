Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755503Ab1GAIhz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 04:37:55 -0400
Received: from ppsw-52.csi.cam.ac.uk ([131.111.8.152]:45712 "EHLO
	ppsw-52.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755320Ab1GAIhv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 04:37:51 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4E0D8943.5040907@cam.ac.uk>
Date: Fri, 01 Jul 2011 09:45:55 +0100
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110509 Lightning/1.0b3pre Thunderbird/3.1.10
MIME-Version: 1.0
To: Bryan Freed <bfreed@chromium.org>
CC: linux-kernel@vger.kernel.org, gregkh@suse.de, rklein@nvidia.com,
        linux-iio@vger.kernel.org
Subject: Re: [PATCH] staging:iio:light:isl29018: Convert some of the isl29018
 driver to the new IIO_CHAN framework.
References: <1309463164-17775-1-git-send-email-bfreed@chromium.org>
In-Reply-To: <1309463164-17775-1-git-send-email-bfreed@chromium.org>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/30/11 20:46, Bryan Freed wrote:
> Add the "proximity" string to the iio_chan_type_name_spec_shared list
> and rearrange the list to match the iio.h enum format for easy comparison.
> 
> Remove the driver's get_sensor_data() interfaces and replace them with
> IIO_CHAN channels.  This converts 4 files to the new framework.
> Driver ABI change: The intensity_infrared_raw file is now intensity_ir_raw.

Hi Brian,

Thanks for doing this. I know it's a bit more work, but could you please
break this into 3 patches (right now the name hides the core changes!)

1) Reorder the lists to match iio.h enum format (excellent point btw!)
2) Add proximity to that list.
3) Convert the driver.

Couple of trivial notes inline.  One bug, but the others are really up to you.

On another note, what is the use case for adc resolution control?  The read
path is slow anyway so does it ever hurt the application to just read at
full resolution?

Thanks,

Jonathan

> 
> Signed-off-by: Bryan Freed <bfreed@chromium.org>
> ---
>  drivers/staging/iio/industrialio-core.c |   11 +-
>  drivers/staging/iio/light/isl29018.c    |  159 +++++++++++++-----------------
>  2 files changed, 75 insertions(+), 95 deletions(-)
> 
> diff --git a/drivers/staging/iio/industrialio-core.c b/drivers/staging/iio/industrialio-core.c
> index 94d3bfa..ef9a11e 100644
> --- a/drivers/staging/iio/industrialio-core.c
> +++ b/drivers/staging/iio/industrialio-core.c
> @@ -44,20 +44,21 @@ struct bus_type iio_bus_type = {
>  EXPORT_SYMBOL(iio_bus_type);
>  
>  static const char * const iio_chan_type_name_spec_shared[] = {
> -	[IIO_TIMESTAMP] = "timestamp",
> -	[IIO_ACCEL] = "accel",
>  	[IIO_IN] = "in",
>  	[IIO_CURRENT] = "current",
>  	[IIO_POWER] = "power",
> +	[IIO_ACCEL] = "accel",
>  	[IIO_IN_DIFF] = "in-in",
>  	[IIO_GYRO] = "gyro",
> -	[IIO_TEMP] = "temp",
>  	[IIO_MAGN] = "magn",
> +	[IIO_LIGHT] = "illuminance",
> +	[IIO_INTENSITY] = "intensity",
> +	[IIO_PROXIMITY] = "proximity",
> +	[IIO_TEMP] = "temp",
>  	[IIO_INCLI] = "incli",
>  	[IIO_ROT] = "rot",
> -	[IIO_INTENSITY] = "intensity",
> -	[IIO_LIGHT] = "illuminance",
>  	[IIO_ANGL] = "angl",
> +	[IIO_TIMESTAMP] = "timestamp",
>  };
>  
>  static const char * const iio_chan_type_name_spec_complex[] = {
> diff --git a/drivers/staging/iio/light/isl29018.c b/drivers/staging/iio/light/isl29018.c
> index cd88311..aac4e39 100644
> --- a/drivers/staging/iio/light/isl29018.c
> +++ b/drivers/staging/iio/light/isl29018.c
> @@ -225,74 +225,7 @@ static int isl29018_read_proximity_ir(struct i2c_client *client, int scheme,
>  	return 0;
>  }
>  
> -static ssize_t get_sensor_data(struct device *dev, char *buf, int mode)
> -{
> -	struct iio_dev *indio_dev = dev_get_drvdata(dev);
> -	struct isl29018_chip *chip = indio_dev->dev_data;
> -	struct i2c_client *client = chip->client;
> -	int value = 0;
> -	int status;
> -
> -	mutex_lock(&chip->lock);
> -	switch (mode) {
> -	case COMMMAND1_OPMODE_PROX_ONCE:
> -		status = isl29018_read_proximity_ir(client,
> -				chip->prox_scheme, &value);
> -		break;
> -
> -	case COMMMAND1_OPMODE_ALS_ONCE:
> -		status = isl29018_read_lux(client, &value);
> -		break;
> -
> -	case COMMMAND1_OPMODE_IR_ONCE:
> -		status = isl29018_read_ir(client, &value);
> -		break;
> -
> -	default:
> -		dev_err(&client->dev, "Mode %d is not supported\n", mode);
> -		mutex_unlock(&chip->lock);
> -		return -EBUSY;
> -	}
> -	if (status < 0) {
> -		dev_err(&client->dev, "Error in Reading data");
> -		mutex_unlock(&chip->lock);
> -		return status;
> -	}
> -
> -	mutex_unlock(&chip->lock);
> -
> -	return sprintf(buf, "%d\n", value);
> -}
> -
>  /* Sysfs interface */
> -/* lux_scale */
> -static ssize_t show_lux_scale(struct device *dev,
> -			struct device_attribute *attr, char *buf)
> -{
> -	struct iio_dev *indio_dev = dev_get_drvdata(dev);
> -	struct isl29018_chip *chip = indio_dev->dev_data;
> -
> -	return sprintf(buf, "%d\n", chip->lux_scale);
> -}
> -
> -static ssize_t store_lux_scale(struct device *dev,
> -		struct device_attribute *attr, const char *buf, size_t count)
> -{
> -	struct iio_dev *indio_dev = dev_get_drvdata(dev);
> -	struct isl29018_chip *chip = indio_dev->dev_data;
> -	unsigned long lval;
> -
> -	lval = simple_strtoul(buf, NULL, 10);
> -	if (lval == 0)
> -		return -EINVAL;
> -
> -	mutex_lock(&chip->lock);
> -	chip->lux_scale = lval;
> -	mutex_unlock(&chip->lock);
> -
> -	return count;
> -}
> -
>  /* range */
>  static ssize_t show_range(struct device *dev,
>  			struct device_attribute *attr, char *buf)
> @@ -410,27 +343,78 @@ static ssize_t store_prox_infrared_supression(struct device *dev,
>  	return count;
>  }
>  
> -/* Read lux */
> -static ssize_t show_lux(struct device *dev,
> -		struct device_attribute *devattr, char *buf)
> +/* Channel IO */
> +static int isl29018_write_raw(struct iio_dev *indio_dev,
> +			      struct iio_chan_spec const *chan,
> +			      int val,
> +			      int val2,
> +			      long mask)
>  {
> -	return get_sensor_data(dev, buf, COMMMAND1_OPMODE_ALS_ONCE);
> -}
> +	struct isl29018_chip *chip = indio_dev->dev_data;
> +	int ret = -EINVAL;
>  
> -/* Read ir */
> -static ssize_t show_ir(struct device *dev,
> -		struct device_attribute *devattr, char *buf)
> -{
> -	return get_sensor_data(dev, buf, COMMMAND1_OPMODE_IR_ONCE);
> +	mutex_lock(&chip->lock);
> +	if (mask == (1 << IIO_CHAN_INFO_CALIBSCALE_SEPARATE) &&
> +	    chan->type == IIO_LIGHT) {
> +		chip->lux_scale = val;
> +		ret = 0;
> +	}
> +	mutex_unlock(&chip->lock);
> +
> +	return 0;
>  }
>  
> -/* Read nearest ir */
> -static ssize_t show_proxim_ir(struct device *dev,
> -		struct device_attribute *devattr, char *buf)
> +static int isl29018_read_raw(struct iio_dev *indio_dev,
> +			     struct iio_chan_spec const *chan,
> +			     int *val,
> +			     int *val2,
> +			     long mask)
>  {
> -	return get_sensor_data(dev, buf, COMMMAND1_OPMODE_PROX_ONCE);
> +	int ret = -EINVAL;
> +	struct isl29018_chip *chip = indio_dev->dev_data;
> +	struct i2c_client *client = chip->client;
> +
> +	mutex_lock(&chip->lock);
> +	switch (mask) {
> +	case 0:
> +		switch (chan->type) {
> +		case IIO_LIGHT:
> +			ret = isl29018_read_lux(client, val);
> +			break;
> +		case IIO_INTENSITY:
> +			ret = isl29018_read_ir(client, val);
> +			break;
> +		case IIO_PROXIMITY:
> +			ret = isl29018_read_proximity_ir(client,
> +					chip->prox_scheme, val);
> +			break;
> +		default:
> +			break;
> +		}
> +		if (!ret)
> +			ret = IIO_VAL_INT;
> +		break;
> +	case (1 << IIO_CHAN_INFO_CALIBSCALE_SEPARATE):
> +		if (chan->type == IIO_LIGHT) {
> +			*val = chip->lux_scale;
> +			ret = IIO_VAL_INT;
> +		}
> +		break;
> +	default:
> +		break;
> +	}
> +	mutex_unlock(&chip->lock);
> +	return ret;
>  }
>  
> +#define LIGHT_INFO_MASK (1 << IIO_CHAN_INFO_CALIBSCALE_SEPARATE)
> +static const struct iio_chan_spec isl29018_channels[] = {
> +	IIO_CHAN(IIO_LIGHT,     0, 1, 1, NULL, 0, 0, LIGHT_INFO_MASK,
> +							0, 0, {}, 0),
> +	IIO_CHAN(IIO_INTENSITY, 1, 0, 0, NULL, 0, 1, 0, 0, 0, {}, 0),
> +	IIO_CHAN(IIO_PROXIMITY, 0, 0, 0, NULL, 0, 0, 0, 0, 0, {}, 0),
> +};
Given these are very simply, I'd prefer explicit initialization of the
structure. (I've only done this myself in the very latest changes, but
it is easier to follow as long as it doesn't cost obscene numbers of lines)
It also quickly highlights any issues. For example compare the above with
what I think we want. (Yes it's longer, but it is clearer to read and not
that long really!)

static const struct iio_chan_spec isl29018[] = {
       {
		.type = IIO_LIGHT,
		.indexed = 1,
		.channel = 0, /* clearer to put this here than not */
		.processed_val = 1,
		.info_mask = (1 << IIO_CHAN_INFO_CALIBSCALE_SEPARATE),
		
	}, {
		.type = IIO_INTENSITY,
		.modfiied = 1,
		.channel2 = IIO_MOD_LIGHT_IR,
		/* missing modfifier spec
		 * gives wrong one LIGHT_BOTH in above macro usage */
	}, {
		.type = IIO_PROXIMITY,
		/* I'd possibly argue this one should be indexed, but that would be an abi change */
	}   
};
> +
>  static IIO_DEVICE_ATTR(range, S_IRUGO | S_IWUSR, show_range, store_range, 0);
>  static IIO_CONST_ATTR(range_available, "1000 4000 16000 64000");
>  static IIO_CONST_ATTR(adc_resolution_available, "4 8 12 16");
> @@ -440,11 +424,6 @@ static IIO_DEVICE_ATTR(proximity_on_chip_ambient_infrared_supression,
>  					S_IRUGO | S_IWUSR,
>  					show_prox_infrared_supression,
>  					store_prox_infrared_supression, 0);
> -static IIO_DEVICE_ATTR(illuminance0_input, S_IRUGO, show_lux, NULL, 0);
> -static IIO_DEVICE_ATTR(illuminance0_calibscale, S_IRUGO | S_IWUSR,
> -					show_lux_scale, store_lux_scale, 0);
> -static IIO_DEVICE_ATTR(intensity_infrared_raw, S_IRUGO, show_ir, NULL, 0);
> -static IIO_DEVICE_ATTR(proximity_raw, S_IRUGO, show_proxim_ir, NULL, 0);
>  
>  #define ISL29018_DEV_ATTR(name) (&iio_dev_attr_##name.dev_attr.attr)
>  #define ISL29018_CONST_ATTR(name) (&iio_const_attr_##name.dev_attr.attr)
> @@ -454,10 +433,6 @@ static struct attribute *isl29018_attributes[] = {
>  	ISL29018_DEV_ATTR(adc_resolution),
>  	ISL29018_CONST_ATTR(adc_resolution_available),
>  	ISL29018_DEV_ATTR(proximity_on_chip_ambient_infrared_supression),
> -	ISL29018_DEV_ATTR(illuminance0_input),
> -	ISL29018_DEV_ATTR(illuminance0_calibscale),
> -	ISL29018_DEV_ATTR(intensity_infrared_raw),
> -	ISL29018_DEV_ATTR(proximity_raw),
>  	NULL
>  };
>  
> @@ -490,6 +465,8 @@ static int isl29018_chip_init(struct i2c_client *client)
>  static const struct iio_info isl29108_info = {
>  	.attrs = &isl29108_group,
>  	.driver_module = THIS_MODULE,
> +	.read_raw = &isl29018_read_raw,
> +	.write_raw = &isl29018_write_raw,
>  };
>  
>  static int __devinit isl29018_probe(struct i2c_client *client,
> @@ -524,6 +501,8 @@ static int __devinit isl29018_probe(struct i2c_client *client,
>  		goto exit_free;
>  	}
>  	chip->indio_dev->info = &isl29108_info;
> +	chip->indio_dev->channels = isl29018_channels;
> +	chip->indio_dev->num_channels = ARRAY_SIZE(isl29018_channels);
>  	chip->indio_dev->name = id->name;
>  	chip->indio_dev->dev.parent = &client->dev;
>  	chip->indio_dev->dev_data = (void *)(chip);

