Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754920Ab1DIPtE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Apr 2011 11:49:04 -0400
Received: from ppsw-50.csi.cam.ac.uk ([131.111.8.150]:47830 "EHLO
	ppsw-50.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754758Ab1DIPtD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Apr 2011 11:49:03 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4DA08052.2060904@cam.ac.uk>
Date: Sat, 09 Apr 2011 16:50:42 +0100
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20110122 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: Jon Brenner <jbrenner@taosinc.com>
CC: linux-iio <linux-iio@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V3]TAOS 258x: Device Driver
References: <1301089260.29448.22.camel@jonz-ubuntu>
In-Reply-To: <1301089260.29448.22.camel@jonz-ubuntu>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/25/11 21:41, Jon Brenner wrote:
> [PATCH v3] for TAOS tsl2580/81/83 Device driver 
> 
> Added suspend/resume functions.
> Changed attribute names to match existing where applicable and updated or documented new ABI as discussed.
> Changed integration time ABI from using index (0 to 3) to use actual gain values (1x,8x, etc.).
> Removed various unused variables, declarations, and functions.
> Revised code to accommodate different endianess (le16_to_cpu).
> Updated error return codes in various functions.
> Changed from mdelay to msleep after determining that longer wait would be acceptable.

Hi Jon,

Check patch is giving me the following that you'll want to clear up before sending this
to Greg KH.
WARNING: space required after Signed-off-by:
#60: 
Signed-off-by:Jon August Brenner <jbrenner@taosinc.com>

WARNING: line over 80 characters
#414: FILE: drivers/staging/iio/light/tsl2583.c:244:
+               (TSL258X_CMD_REG | TSL258X_CMD_SPL_FN | TSL258X_CMD_ALS_INT_CLR));

Otherwise couple of nitpicks in line.

It's rather late to moan about it but I'd have prefered to not have the generic
prefix 'taos' used, but rather the name of some part.  Afterall this isn't the
only taos part out there!  Still it's unlikely a name clash will occur so I'm
not suggesting you change it at this point, more suggesting you are careful
about that in future drivers.

All the nitpicks are totally trivial changes to comments, or layout of code,
so no need to post for review again assuming Datta is happy (looks to
me like you answered all of his points)  Hence fix this stuff up or
tell me I'm being silly then send it on to Greg KH <greg@kroah.com>
with my Ack.  Do verify it applies and builds against staging next before
sending it on. (It's obviously but I'm always forgetting to do that for
starters!).
> 
> Signed-off-by:Jon August Brenner <jbrenner@taosinc.com>
Acked-by: Jonathan Cameron <jic23@cam.ac.uk>

Nice driver. I'm looking forward to lots more in future ;)

Jonathan
> 
> ---
>  drivers/staging/iio/Documentation/sysfs-bus-iio    |    6 +
>  .../staging/iio/Documentation/sysfs-bus-iio-light  |   13 +
>  .../iio/Documentation/sysfs-bus-iio-light-tsl2583  |   20 +
>  drivers/staging/iio/light/Kconfig                  |    9 +
>  drivers/staging/iio/light/Makefile                 |    1 +
>  drivers/staging/iio/light/tsl2583.c                |  962 ++++++++++++++++++++
>  6 files changed, 1011 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/staging/iio/Documentation/sysfs-bus-iio b/drivers/staging/iio/Documentation/sysfs-bus-iio
> index 2dde97d..6a86ad2 100644
> --- a/drivers/staging/iio/Documentation/sysfs-bus-iio
> +++ b/drivers/staging/iio/Documentation/sysfs-bus-iio
> @@ -6,6 +6,12 @@ Description:
>  		Corresponds to a grouping of sensor channels. X is the IIO
>  		index of the device.
>  
> +What:		/sys/bus/iio/devices/device[n]/power_state
> +KernelVersion:	2.6.37
> +Contact:	linux-iio@vger.kernel.org
> +Description:
> +		This property gets/sets the device power state.
> +
>  What:		/sys/bus/iio/devices/triggerX
>  KernelVersion:	2.6.35
>  Contact:	linux-iio@vger.kernel.org
> diff --git a/drivers/staging/iio/Documentation/sysfs-bus-iio-light b/drivers/staging/iio/Documentation/sysfs-bus-iio-light
> index 5d84856..21d2774 100644
> --- a/drivers/staging/iio/Documentation/sysfs-bus-iio-light
> +++ b/drivers/staging/iio/Documentation/sysfs-bus-iio-light
> @@ -62,3 +62,16 @@ Description:
>  		sensing mode. This value should be the output from a reading
>  		and if expressed in SI units, should include _input. If this
>  		value is not in SI units, then it should include _raw.
> +
> +What:		/sys/bus/iio/devices/device[n]/illuminance0_target
> +KernelVersion:	2.6.37
> +Contact:	linux-iio@vger.kernel.org
> +Description:
> +		This property gets/sets the last known external
> +		lux measurement used in/for calibration.
Really not keen on the word property.  Doesn't to my mind really apply when these
are separate files...  Still don't really care about that if you are really keen on
it.  It is pretty obvious what means.
> +
> +What:		/sys/bus/iio/devices/device[n]/illuminance0_integration_time
> +KernelVersion:	2.6.37
> +Contact:	linux-iio@vger.kernel.org
> +Description:
> +		This property gets/sets the sensors ADC analog integration time.
Units are?  (I know we are lax in this elsewhere in the docs, but might as well fix
up new stuff!)
> diff --git a/drivers/staging/iio/Documentation/sysfs-bus-iio-light-tsl2583 b/drivers/staging/iio/Documentation/sysfs-bus-iio-light-tsl2583
> new file mode 100644
> index 0000000..660781d
> --- /dev/null
> +++ b/drivers/staging/iio/Documentation/sysfs-bus-iio-light-tsl2583
> @@ -0,0 +1,20 @@
> +What:		/sys/bus/iio/devices/device[n]/lux_table
> +KernelVersion:	2.6.37
> +Contact:	linux-iio@vger.kernel.org
> +Description:
> +		This property gets/sets the table of coefficients
property -> 'attribute' or 'control' 
> +		used in calculating illuminance in lux.
> +
> +What:		/sys/bus/iio/devices/device[n]/illuminance0_calibrate
> +KernelVersion:	2.6.37
> +Contact:	linux-iio@vger.kernel.org
> +Description:
> +		This property causes an internal calibration of the als gain trim
property -> 'attribute' or 'control'
> +		value which is later used in calculating illuminance in lux.
> +
> +What:		/sys/bus/iio/devices/device[n]/illuminance0_input_target
> +KernelVersion:	2.6.37
> +Contact:	linux-iio@vger.kernel.org
> +Description:
> +		This property is the known externally illuminance (in lux).
externally -> external ?  eternally measured ?
> +		It is used in the process of calibrating the device accuracy.
...
> +struct taos_lux {
> +	unsigned int ratio;
> +	unsigned int ch0;
> +	unsigned int ch1;
> +};
> +
> +/* This structure is intentionally large to accommodate updates via sysfs. */
> +/* Sized to 11 = max 10 segments + 1 termination segment */
> +/* Assumption is is one and only one type of glass used  */
This is a multiline comment, so do the formatting the same as all of
the others.

> +struct taos_lux taos_device_lux[11] = {
> +	{  9830,  8520, 15729 },
> +	{ 12452, 10807, 23344 },
> +	{ 14746,  6383, 11705 },
> +	{ 17695,  4063,  6554 },
...
> +/*
> + * Turn the device on.
> + * Configuration must be set before calling this function.
> + */
> +static int taos_chip_on(struct i2c_client *client)
> +{
> +	int i;
> +	int ret = 0;
> +	u8 *uP;
> +	u8 utmp;
> +	int als_count;
> +	int als_time;
> +	struct tsl2583_chip *chip = i2c_get_clientdata(client);
> +
> +	/* and make sure we're not already on */
> +	if (chip->taos_chip_status == TSL258X_CHIP_WORKING) {
> +		/* if forcing a register update - turn off, then on */
> +		dev_info(&client->dev, "device is already enabled\n");
> +		return   -EINVAL;
> +	}
> +
> +	/* determine als integration regster */
> +	als_count = (chip->taos_settings.als_time * 100 + 135) / 270;
> +	if (als_count == 0)
> +		als_count = 1; /* ensure at least one cycle */
> +
> +	/* convert back to time (encompasses overrides) */
> +	als_time = (als_count * 27 + 5) / 10;
> +	chip->taos_config[TSL258X_ALS_TIME] = 256 - als_count;
> +
> +	/* Set the gain based on taos_settings struct */
> +	chip->taos_config[TSL258X_GAIN] = chip->taos_settings.als_gain;
> +
> +	/* set chip struct re scaling and saturation */
> +	chip->als_saturation = als_count * 922; /* 90% of full scale */
> +	chip->als_time_scale = (als_time + 25) / 50;
> +
> +	/* TSL258x Specific power-on / adc enable sequence
> +	 * Power on the device 1st. */
> +	utmp = TSL258X_CNTL_PWR_ON;
> +	ret = i2c_smbus_write_byte_data(client, TSL258X_CMD_REG | TSL258X_CNTRL,
> +					utmp);
> +	if (ret < 0) {
> +		dev_err(&client->dev, "taos_chip_on failed on CNTRL reg.\n");
> +		return -1;
> +	}
> +
> +	/* Use the following shadow copy for our delay before enabling ADC.
> +	 * Write all the registers. */
> +	for (i = 0, uP = chip->taos_config; i < TSL258X_REG_MAX; i++) {
> +		ret = i2c_smbus_write_byte_data(client, TSL258X_CMD_REG + i,
> +						*uP++);
> +		if (ret < 0) {
> +			dev_err(&client->dev,
> +				"taos_chip_on failed on reg %d.\n", i);
> +			return -1;
> +		}
> +	}
> +
> +	msleep(3);
> +	/* NOW enable the ADC
> +	 * initialize the desired mode of operation */
> +	utmp = TSL258X_CNTL_PWR_ON | TSL258X_CNTL_ADC_ENBL;
> +	ret = i2c_smbus_write_byte_data(client, TSL258X_CMD_REG | TSL258X_CNTRL,
> +					utmp);
> +	if (ret < 0) {
> +		dev_err(&client->dev, "taos_chip_on failed on 2nd CTRL reg.\n");
> +		return -1;
> +	}
> +	chip->taos_chip_status = TSL258X_CHIP_WORKING;
> +
> +	return ret;
> +}
> +
> +static int taos_chip_off(struct i2c_client *client)
> +{
> +	struct tsl2583_chip *chip = i2c_get_clientdata(client);
> +	int ret;
> +
> +	/* turn device off */
> +	chip->taos_chip_status = TSL258X_CHIP_SUSPENDED;
> +	ret = i2c_smbus_write_byte_data(client, TSL258X_CMD_REG | TSL258X_CNTRL,
> +					0x00);
> +	return ret;
> +}
> +
> +/* Sysfs Interface Functions */
> +static ssize_t taos_device_id(struct device *dev,
> +struct device_attribute *attr, char *buf)
Indentation on this parameter list looks rather odd.  Please check.
> +{
> +	struct iio_dev *indio_dev = dev_get_drvdata(dev);
> +	struct tsl2583_chip *chip = indio_dev->dev_data;
> +
> +	return sprintf(buf, "%s\n", chip->client->name);
> +}
> +

...

> +	if ((value < 50) || (value > 650))
> +		return -EINVAL;
> +
> +	if (value % 50)
> +		return -EINVAL;
> +
> +	 chip->taos_settings.als_time = value;
> +
> +	return len;
> +}
> +
> +static ssize_t taos_als_time_available_show(struct device *dev,
taos_als_int_time_avaialble_show perhaps?
> +	struct device_attribute *attr, char *buf)
> +{
> +	return sprintf(buf, "%s\n",
> +		"50 100 150 200 250 300 350 400 450 500 550 600 650");
> +}
> +

...

> +	int i, ret = 0;
> +	unsigned char buf[TSL258X_MAX_DEVICE_REGS];
> +	static struct tsl2583_chip *chip;
> +
> +	if (!i2c_check_functionality(clientp->adapter,
> +		I2C_FUNC_SMBUS_BYTE_DATA)) {
> +		dev_err(&clientp->dev,
> +			"taos_probe() - i2c smbus byte data "
> +			"functions unsupported\n");
> +		return -EOPNOTSUPP;
> +	}
> +
> +	chip = kzalloc(sizeof(struct tsl2583_chip), GFP_KERNEL);
> +	if (!chip)
> +		return -ENOMEM;
> +
> +	chip->client = clientp;
> +	i2c_set_clientdata(clientp, chip);
> +
> +	mutex_init(&chip->als_mutex);
> +	chip->taos_chip_status = TSL258X_CHIP_UNKNOWN;
> +	memcpy(chip->taos_config, taos_config, sizeof(chip->taos_config));
> +
> +	for (i = 0; i < TSL258X_MAX_DEVICE_REGS; i++) {
> +		ret = i2c_smbus_write_byte(clientp,
> +				(TSL258X_CMD_REG | (TSL258X_CNTRL + i)));
> +		if (ret < 0) {
> +			dev_err(&clientp->dev, "i2c_smbus_write_bytes() to cmd "
> +				"reg failed in taos_probe(), err = %d\n", ret);
> +			goto fail1;
> +		}
> +		ret = i2c_smbus_read_byte(clientp);
> +		if (ret < 0) {
> +			dev_err(&clientp->dev, "i2c_smbus_read_byte from "
> +				"reg failed in taos_probe(), err = %d\n", ret);

Please don't break strings in error messages across lines.  This is the one place
where it is preferable to ignore checkpatch.  Otherwise people can't grep the
tree for where the heck the message they are seeing came from!

> +
> +			goto fail1;
> +		}
> +		buf[i] = ret;
> +	}
> +
> +	if (!taos_tsl258x_device(buf)) {
> +		dev_info(&clientp->dev, "i2c device found but does not match "
> +			"expected id in taos_probe()\n");
> +		goto fail1;
> +	}
> +
> +	ret = i2c_smbus_write_byte(clientp, (TSL258X_CMD_REG | TSL258X_CNTRL));
> +	if (ret < 0) {
> +		dev_err(&clientp->dev, "i2c_smbus_write_byte() to cmd reg "
> +			"failed in taos_probe(), err = %d\n", ret);
> +		goto fail1;
> +	}
...

