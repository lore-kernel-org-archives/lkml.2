Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755507Ab1F2MGp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 08:06:45 -0400
Received: from ppsw-52.csi.cam.ac.uk ([131.111.8.152]:35347 "EHLO
	ppsw-52.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755172Ab1F2MGn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 08:06:43 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4E0B1737.4060402@cam.ac.uk>
Date: Wed, 29 Jun 2011 13:14:47 +0100
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110509 Lightning/1.0b3pre Thunderbird/3.1.10
MIME-Version: 1.0
To: Bryan Freed <bfreed@chromium.org>
CC: linux-kernel@vger.kernel.org, linux-iio@vger.kernel.org, rklein@nvidia.com,
        gregkh@suse.de, arnd@arndb.de
Subject: Re: [PATCH v2] light sensor: Add a calibscale file to the isl29018
 light sensor driver.
References: <1309304793-21886-1-git-send-email-bfreed@chromium.org>
In-Reply-To: <1309304793-21886-1-git-send-email-bfreed@chromium.org>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/29/11 00:46, Bryan Freed wrote:
> Defaulting to 1, this gives a way to amplify the lux value before being
> reduced by the programmed adc_bit shift.
> Only support whole numbers right now.  When this driver is converted to the new
> IIO_CHAN framework, it will be easy to support the framework's pseudo float.
Hohum. Guess I'll get round to the conversion at some point if no one else
beats me to it, as long as someone with hardware can test that I don't mess it up!
> 
> Add illuminance0_calibscale documentation to sysfs-bus-iio-light.
Hmm.. I do wonder if we should just squash that file into the main abi file.
Overlaps like the one we have here just tend to lead to confusion + the
fact there is a separate file sometimes means people don't also check
the main abi docs.  I'd have acked this in either location currently.

Anyhow, that's a job for another day.
> 
> Signed-off-by: Bryan Freed <bfreed@chromium.org>
Acked-by: Jonathan Cameron <jic23@cam.ac.uk>

> ---
>  .../staging/iio/Documentation/sysfs-bus-iio-light  |    8 ++++
>  drivers/staging/iio/light/isl29018.c               |   35 +++++++++++++++++++-
>  2 files changed, 42 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/staging/iio/Documentation/sysfs-bus-iio-light b/drivers/staging/iio/Documentation/sysfs-bus-iio-light
> index 21d2774..edbf470 100644
> --- a/drivers/staging/iio/Documentation/sysfs-bus-iio-light
> +++ b/drivers/staging/iio/Documentation/sysfs-bus-iio-light
> @@ -75,3 +75,11 @@ KernelVersion:	2.6.37
>  Contact:	linux-iio@vger.kernel.org
>  Description:
>  		This property gets/sets the sensors ADC analog integration time.
> +
> +What:		/sys/bus/iio/devices/device[n]/illuminance0_calibscale
> +KernelVersion:	2.6.37
> +Contact:	linux-iio@vger.kernel.org
> +Description:
> +		Hardware or software applied calibration scale factor assumed
> +		to account for attenuation due to industrial design (glass
> +		filters or aperture holes).
> diff --git a/drivers/staging/iio/light/isl29018.c b/drivers/staging/iio/light/isl29018.c
> index 4794ffd..cd88311 100644
> --- a/drivers/staging/iio/light/isl29018.c
> +++ b/drivers/staging/iio/light/isl29018.c
> @@ -57,6 +57,7 @@ struct isl29018_chip {
>  	struct iio_dev		*indio_dev;
>  	struct i2c_client	*client;
>  	struct mutex		lock;
> +	unsigned int		lux_scale;
>  	unsigned int		range;
>  	unsigned int		adc_bit;
>  	int			prox_scheme;
> @@ -166,7 +167,7 @@ static int isl29018_read_lux(struct i2c_client *client, int *lux)
>  	if (lux_data < 0)
>  		return lux_data;
>  
> -	*lux = (lux_data * chip->range) >> chip->adc_bit;
> +	*lux = (lux_data * chip->range * chip->lux_scale) >> chip->adc_bit;
>  
>  	return 0;
>  }
> @@ -264,6 +265,34 @@ static ssize_t get_sensor_data(struct device *dev, char *buf, int mode)
>  }
>  
>  /* Sysfs interface */
> +/* lux_scale */
> +static ssize_t show_lux_scale(struct device *dev,
> +			struct device_attribute *attr, char *buf)
> +{
> +	struct iio_dev *indio_dev = dev_get_drvdata(dev);
> +	struct isl29018_chip *chip = indio_dev->dev_data;
> +
> +	return sprintf(buf, "%d\n", chip->lux_scale);
> +}
> +
> +static ssize_t store_lux_scale(struct device *dev,
> +		struct device_attribute *attr, const char *buf, size_t count)
> +{
> +	struct iio_dev *indio_dev = dev_get_drvdata(dev);
> +	struct isl29018_chip *chip = indio_dev->dev_data;
> +	unsigned long lval;
> +
> +	lval = simple_strtoul(buf, NULL, 10);
> +	if (lval == 0)
> +		return -EINVAL;
> +
> +	mutex_lock(&chip->lock);
> +	chip->lux_scale = lval;
> +	mutex_unlock(&chip->lock);
> +
> +	return count;
> +}
> +
>  /* range */
>  static ssize_t show_range(struct device *dev,
>  			struct device_attribute *attr, char *buf)
> @@ -412,6 +441,8 @@ static IIO_DEVICE_ATTR(proximity_on_chip_ambient_infrared_supression,
>  					show_prox_infrared_supression,
>  					store_prox_infrared_supression, 0);
>  static IIO_DEVICE_ATTR(illuminance0_input, S_IRUGO, show_lux, NULL, 0);
> +static IIO_DEVICE_ATTR(illuminance0_calibscale, S_IRUGO | S_IWUSR,
> +					show_lux_scale, store_lux_scale, 0);
>  static IIO_DEVICE_ATTR(intensity_infrared_raw, S_IRUGO, show_ir, NULL, 0);
>  static IIO_DEVICE_ATTR(proximity_raw, S_IRUGO, show_proxim_ir, NULL, 0);
>  
> @@ -424,6 +455,7 @@ static struct attribute *isl29018_attributes[] = {
>  	ISL29018_CONST_ATTR(adc_resolution_available),
>  	ISL29018_DEV_ATTR(proximity_on_chip_ambient_infrared_supression),
>  	ISL29018_DEV_ATTR(illuminance0_input),
> +	ISL29018_DEV_ATTR(illuminance0_calibscale),
>  	ISL29018_DEV_ATTR(intensity_infrared_raw),
>  	ISL29018_DEV_ATTR(proximity_raw),
>  	NULL
> @@ -478,6 +510,7 @@ static int __devinit isl29018_probe(struct i2c_client *client,
>  
>  	mutex_init(&chip->lock);
>  
> +	chip->lux_scale = 1;
>  	chip->range = 1000;
>  	chip->adc_bit = 16;
>  

