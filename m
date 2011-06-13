Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754964Ab1FMIs7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 04:48:59 -0400
Received: from ppsw-50.csi.cam.ac.uk ([131.111.8.150]:33570 "EHLO
	ppsw-50.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754570Ab1FMIs4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 04:48:56 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4DF5D0DC.5090205@cam.ac.uk>
Date: Mon, 13 Jun 2011 09:57:00 +0100
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110509 Lightning/1.0b3pre Thunderbird/3.1.10
MIME-Version: 1.0
To: Bryan Freed <bfreed@chromium.org>
CC: linux-kernel@vger.kernel.org, jbrenner@taosinc.com, gregkh@suse.de,
        arnd@arndb.de, "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>
Subject: Re: [PATCH 1/2] light sensor: Add a calibration file to the isl29018
 driver.
References: <1307737580-14131-1-git-send-email-bfreed@chromium.org>
In-Reply-To: <1307737580-14131-1-git-send-email-bfreed@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cc'd linux-iio 
On 06/10/11 21:26, Bryan Freed wrote:
> This is the same tuning file used in tsl2583.c.
> Add documentation for it to sysfs-bus-iio-light.
> Normalize it at 1024 instead of 1000 so we can avoid 64bit division (div_u64).
> Use u64 so we can do all multiplication before division to avoid loss of
> granularity on amplified values.
Hi  Brian.

This attribute is a general IIO one rather than a light specific one so is
already documented in sysfs-bus-iio.

Now it is supposed to be an offset rather than a gain.  The current docs say:

"Hardware applied calibration offset. (assumed to fix production
 inaccuracies). If shared across all channels, <type>_calibbias
 is used."

I do note that the illuminance variant isn't actually listed and would be
happy to have a patch adding it alongside the gyro and accel ones already there.

My first issue here is that it supposed to be an offset not a gain.  Secondly that
description could clearly do with amending to make it clear that this can be used
for devices with complex non linear transformations to SI units which is what it
is supposed to be doing here.  In cases where there is no '_raw' output we can assume
something complex may be happening, so changing this value won't result in a additive
change the output.

If we are playing with a gain, then calibscale is the parameter name that should be used
(also a core attribute definition, not a light specific one).

"Hardware applied calibration scale factor. (assumed to fix
 production inaccuracies).  If shared across all channels,
 <type>_calibscale is used."

Note all these attributes are defined to be pseudo floating point.  The chan_spec approach
to registration handles this cleanly (particularly with Michael Hennerich's additional
callbacks added last week).  It's a gain, so 1 is the no change value. Sorry, but anything
that assumes 1024 is the no effect value is never going to generalize well
so is a non starter.

Sorry, I'll be happy to see a patch adding the support you want to the isl29018 driver
but it must conform to the existing abi.  It looks like you may have found a discrepancy
between a driver and the spec, but I'll leave Jon to comment on that. 

Jonathan
> 
> Signed-off-by: Bryan Freed <bfreed@chromium.org>
> ---
>  .../staging/iio/Documentation/sysfs-bus-iio-light  |   10 +++++
>  drivers/staging/iio/light/isl29018.c               |   36 +++++++++++++++++++-
>  2 files changed, 45 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/staging/iio/Documentation/sysfs-bus-iio-light b/drivers/staging/iio/Documentation/sysfs-bus-iio-light
> index 21d2774..704b6c9 100644
> --- a/drivers/staging/iio/Documentation/sysfs-bus-iio-light
> +++ b/drivers/staging/iio/Documentation/sysfs-bus-iio-light
> @@ -75,3 +75,13 @@ KernelVersion:	2.6.37
>  Contact:	linux-iio@vger.kernel.org
>  Description:
>  		This property gets/sets the sensors ADC analog integration time.
> +
> +What:		/sys/bus/iio/devices/device[n]/illuminance0_calibbias
> +KernelVersion:	2.6.38
> +Contact:	linux-iio@vger.kernel.org
> +Description:
> +		This property gets/sets the illuminance0_input amplification
> +		value.  The calculated lux reading is multiplied by this value
> +		and divided by 1024.  Default of 1024 gives no amplification.
> +		This provides compensation for glass or bezel that can
> +		attenuate the ambient light.
> diff --git a/drivers/staging/iio/light/isl29018.c b/drivers/staging/iio/light/isl29018.c
> index 4794ffd..a106f16 100644
> --- a/drivers/staging/iio/light/isl29018.c
> +++ b/drivers/staging/iio/light/isl29018.c
> @@ -57,6 +57,7 @@ struct isl29018_chip {
>  	struct iio_dev		*indio_dev;
>  	struct i2c_client	*client;
>  	struct mutex		lock;
> +	unsigned int		calibbias;
>  	unsigned int		range;
>  	unsigned int		adc_bit;
>  	int			prox_scheme;
> @@ -157,6 +158,7 @@ static int isl29018_read_sensor_input(struct i2c_client *client, int mode)
>  
>  static int isl29018_read_lux(struct i2c_client *client, int *lux)
>  {
> +	u64 lux64;
>  	int lux_data;
>  	struct isl29018_chip *chip = i2c_get_clientdata(client);
>  
> @@ -166,7 +168,8 @@ static int isl29018_read_lux(struct i2c_client *client, int *lux)
>  	if (lux_data < 0)
>  		return lux_data;
>  
> -	*lux = (lux_data * chip->range) >> chip->adc_bit;
> +	lux64 = lux_data * chip->range;
> +	*lux = (lux64 * chip->calibbias) >> (10 + chip->adc_bit);
>  
>  	return 0;
>  }
> @@ -264,6 +267,33 @@ static ssize_t get_sensor_data(struct device *dev, char *buf, int mode)
>  }
>  
>  /* Sysfs interface */
> +/* calibbias */
> +static ssize_t show_calibbias(struct device *dev,
> +			struct device_attribute *attr, char *buf)
> +{
> +	struct iio_dev *indio_dev = dev_get_drvdata(dev);
> +	struct isl29018_chip *chip = indio_dev->dev_data;
> +
> +	return sprintf(buf, "%u\n", chip->calibbias);
> +}
> +
> +static ssize_t store_calibbias(struct device *dev,
> +		struct device_attribute *attr, const char *buf, size_t count)
> +{
> +	struct iio_dev *indio_dev = dev_get_drvdata(dev);
> +	struct isl29018_chip *chip = indio_dev->dev_data;
> +	unsigned long lval;
> +
> +	if (strict_strtoul(buf, 10, &lval))
> +		return -EINVAL;
> +
> +	mutex_lock(&chip->lock);
> +	chip->calibbias = lval;
> +	mutex_unlock(&chip->lock);
> +
> +	return count;
> +}
> +
>  /* range */
>  static ssize_t show_range(struct device *dev,
>  			struct device_attribute *attr, char *buf)
> @@ -412,6 +442,8 @@ static IIO_DEVICE_ATTR(proximity_on_chip_ambient_infrared_supression,
>  					show_prox_infrared_supression,
>  					store_prox_infrared_supression, 0);
>  static IIO_DEVICE_ATTR(illuminance0_input, S_IRUGO, show_lux, NULL, 0);
> +static IIO_DEVICE_ATTR(illuminance0_calibbias, S_IRUGO | S_IWUSR,
> +					show_calibbias, store_calibbias, 0);
>  static IIO_DEVICE_ATTR(intensity_infrared_raw, S_IRUGO, show_ir, NULL, 0);
>  static IIO_DEVICE_ATTR(proximity_raw, S_IRUGO, show_proxim_ir, NULL, 0);
>  
> @@ -424,6 +456,7 @@ static struct attribute *isl29018_attributes[] = {
>  	ISL29018_CONST_ATTR(adc_resolution_available),
>  	ISL29018_DEV_ATTR(proximity_on_chip_ambient_infrared_supression),
>  	ISL29018_DEV_ATTR(illuminance0_input),
> +	ISL29018_DEV_ATTR(illuminance0_calibbias),
>  	ISL29018_DEV_ATTR(intensity_infrared_raw),
>  	ISL29018_DEV_ATTR(proximity_raw),
>  	NULL
> @@ -478,6 +511,7 @@ static int __devinit isl29018_probe(struct i2c_client *client,
>  
>  	mutex_init(&chip->lock);
>  
> +	chip->calibbias = 1024;
>  	chip->range = 1000;
>  	chip->adc_bit = 16;
>  

