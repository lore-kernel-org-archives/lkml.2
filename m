Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754162Ab1CUTFx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 15:05:53 -0400
Received: from ppsw-50.csi.cam.ac.uk ([131.111.8.150]:54959 "EHLO
	ppsw-50.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754133Ab1CUTFu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 15:05:50 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4D87A1D6.2080306@cam.ac.uk>
Date: Mon, 21 Mar 2011 19:07:02 +0000
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20110122 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: Jon Brenner <jbrenner@taosinc.com>
CC: linux-iio <linux-iio@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2.6.38-rc7]TAOS 258x: Device Driver
References: <1300131941.17298.17.camel@jonz-ubuntu>
In-Reply-To: <1300131941.17298.17.camel@jonz-ubuntu>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/14/11 19:45, Jon Brenner wrote:
> From: Jon Brenner <jbrenner@taosinc.com>
> 
> Support for TAOS tsl2580/01/03 ALS devices.
> Uses sysfs/iio methods.
Hi Jon,

As I pm'd you the other day, please remember to make version of patch clear
in title, and include details of what has changed since previous version.

The 'scale' attribute is a problem. I've suggested one possible solution
but I'm open to others.  It ought to be handled in a generalizable way
but isn't currently.

Please document the _target and calibrate attributes in part specific
documentation file.

Otherwise, various small points inline.

Jonathan
> 
> Signed-off-by: Jon August Brenner <jbrenner@taosinc.com>
> 
> ---
>  drivers/staging/iio/Documentation/sysfs-bus-iio    |    6 +
>  .../staging/iio/Documentation/sysfs-bus-iio-light  |    7 +
>  drivers/staging/iio/light/Kconfig                  |    9 +
>  drivers/staging/iio/light/Makefile                 |    1 +
>  drivers/staging/iio/light/tsl2583.c                |  943 ++++++++++++++++++++
>  5 files changed, 966 insertions(+), 0 deletions(-)
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
Where the options are?

There is some on going debate about how best to handle explicit userspace
power control.  For now I'll let this go in, but we will need to clean
it up in the long run.  Basically this is an issue that effects several
subsystems and their ought to be one coherent solution.

> +
>  What:		/sys/bus/iio/devices/triggerX
>  KernelVersion:	2.6.35
>  Contact:	linux-iio@vger.kernel.org
> diff --git a/drivers/staging/iio/Documentation/sysfs-bus-iio-light b/drivers/staging/iio/Documentation/sysfs-bus-iio-light
> index 5d84856..b59cdb4 100644
> --- a/drivers/staging/iio/Documentation/sysfs-bus-iio-light
> +++ b/drivers/staging/iio/Documentation/sysfs-bus-iio-light
> @@ -62,3 +62,10 @@ Description:
>  		sensing mode. This value should be the output from a reading
>  		and if expressed in SI units, should include _input. If this
>  		value is not in SI units, then it should include _raw.
> +
> +What:		/sys/bus/iio/devices/device[n]/lux_table
> +KernelVersion:	2.6.37
> +Contact:	linux-iio@vger.kernel.org
> +Description:
> +		This property gets/sets the table of coefficients
> +		used in calculating illuminance in lux.
This one probably wants to be in a separate file as we only have one user
so far and it's not as though a device agnostic userspace program is going
to know what to do with it.  Put it in syfsf-bus-iio-light-tsl2583 please.

> diff --git a/drivers/staging/iio/light/Kconfig b/drivers/staging/iio/light/Kconfig
> index 36d8bbe..a295e82 100644
> --- a/drivers/staging/iio/light/Kconfig
> +++ b/drivers/staging/iio/light/Kconfig
> @@ -13,6 +13,15 @@ config SENSORS_TSL2563
>  	 This driver can also be built as a module.  If so, the module
>  	 will be called tsl2563.
> 
ouch, how the heck did that SENSORS prefix creep into this file.  That's
the convention for hwmon, not IIO.  Guess I wasn't keeping a close
eye on this. Please drop the prefix.  We may well introduce an IIO one
shortly as part of the move out of staging, but for now no prefix is the norm.
> +config SENSORS_TSL2583
> +	tristate "TAOS TSL2580, TSL2581, and TSL2583 light-to-digital converters"
> +	depends on I2C
> +	help
> +	  Y = in kernel.
> +	  M = as module.
> +	  Provides support for the TAOS tsl2580, tsl2581, and tsl2583 devices.
> +	  Access ALS data via iio, sysfs.
> +
>  config SENSORS_ISL29018
>          tristate "ISL 29018 light and proximity sensor"
>          depends on I2C
> diff --git a/drivers/staging/iio/light/Makefile b/drivers/staging/iio/light/Makefile
> index 9142c0e..9d13b8d 100644
> --- a/drivers/staging/iio/light/Makefile
> +++ b/drivers/staging/iio/light/Makefile
> @@ -3,4 +3,5 @@
>  #
> 
>  obj-$(CONFIG_SENSORS_TSL2563)	+= tsl2563.o
> +obj-$(CONFIG_SENSORS_TSL2583)	+= tsl2583.o
>  obj-$(CONFIG_SENSORS_ISL29018)	+= isl29018.o
> diff --git a/drivers/staging/iio/light/tsl2583.c b/drivers/staging/iio/light/tsl2583.c
> new file mode 100644
> index 0000000..96e4487
> --- /dev/null
> +++ b/drivers/staging/iio/light/tsl2583.c
> @@ -0,0 +1,943 @@
> +/*
> + * Device driver for monitoring ambient light intensity (lux)
> + * within the TAOS tsl258x family of devices (tsl2580, tsl2581).
> + *
> + * Copyright (c) 2011, TAOS Corporation.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful, but WITHOUT
> + * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
> + * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
> + * more details.
> + *
> + * You should have received a copy of the GNU General Public License along
> + * with this program; if not, write to the Free Software Foundation, Inc.,
> + * 51 Franklin Street, Fifth Floor, Boston, MA	02110-1301, USA.
> + */
> +
> +#include <linux/kernel.h>
> +#include <linux/i2c.h>
> +#include <linux/errno.h>
> +#include <linux/delay.h>
> +#include <linux/string.h>
> +#include <linux/mutex.h>
> +#include "../iio.h"
> +
> +
Please prefix this with TSL258X to avoid possible namespace
clashes in future.
> +#define MAX_DEVICE_REGS		32
> +
> +/* Triton register offsets */
> +#define	TAOS_REG_MAX		8
> +
> +/* Device Registers and Masks */
> +#define TSL258X_CNTRL			0x00
> +#define TSL258X_ALS_TIME		0X01
> +#define TSL258X_INTERRUPT		0x02
> +#define TSL258X_GAIN			0x07
> +#define TSL258X_REVID			0x11
> +#define TSL258X_CHIPID			0x12
> +#define TSL258X_ALS_CHAN0LO		0x14
> +#define TSL258X_ALS_CHAN0HI		0x15
> +#define TSL258X_ALS_CHAN1LO		0x16
> +#define TSL258X_ALS_CHAN1HI		0x17
> +#define TSL258X_TMR_LO			0x18
> +#define TSL258X_TMR_HI			0x19
> +
> +/* tsl2583 cmd reg masks */
> +#define TSL258X_CMD_REG			0x80
> +#define TSL258X_CMD_SPL_FN		0x60
> +#define TSL258X_CMD_ALS_INT_CLR	0X01
> +
> +/* tsl2583 cntrl reg masks */
> +#define TSL258X_CNTL_ADC_ENBL	0x02
> +#define TSL258X_CNTL_PWR_ON		0x01
> +
> +/* tsl2583 status reg masks */
> +#define TSL258X_STA_ADC_VALID	0x01
> +#define TSL258X_STA_ADC_INTR	0x10
> +
> +/* Lux calculation constants */
Again please prefix.
> +#define	LUX_CALC_OVER_FLOW		65535
> +
Ideally part names in these. You might have another TAOS driver where
these are defined differently which will make life confusing!
> +enum {
> +	TAOS_CHIP_UNKNOWN = 0, TAOS_CHIP_WORKING = 1, TAOS_CHIP_SLEEP = 2
> +} TAOS_CHIP_WORKING_STATUS;
> +
> +/* Per-device data */
> +struct taos_als_info {
> +	u16 als_ch0;
> +	u16 als_ch1;
> +	u16 lux;
> +};
> +
> +struct taos_settings {
> +	int als_time;
> +	int als_gain;
> +	int als_gain_trim;
> +	int als_cal_target;
> +};
> +
> +struct tsl2583_chip {
> +	struct mutex als_mutex;
> +	struct i2c_client *client;
> +	struct iio_dev *iio_dev;

unused so remove
> +	struct delayed_work update_lux;
unused.
> +	unsigned int addr;

unused.
> +	char taos_id;

I think this is set to 0 then never checked anywhere?  Hence remove
> +	char valid;

never used
> +	unsigned long last_updated;
> +	struct taos_als_info als_cur_info;
> +	struct taos_settings taos_settings;
> +	int als_time_scale;
> +	int als_saturation;
> +	int taos_chip_status;
> +	u8 taos_config[8];
> +};
> +
> +static int taos_i2c_read(struct i2c_client *client, u8 reg, u8 *val,
> +	unsigned int len);
> +static int taos_i2c_write_command(struct i2c_client *client, u8 reg);

Don't need these definitions.
> +
> +/*
> + * Initial values for device - this values can/will be changed by driver.
> + * and applications as needed.
> + * These values are dynamic.
> + */
> +static const u8 taos_config[8] = {
> +		0x00, 0xee, 0x00, 0x03, 0x00, 0xFF, 0xFF, 0x00
> +}; /*	cntrl atime intC  Athl0 Athl1 Athh0 Athh1 gain */
> +
> +struct taos_lux {
> +	unsigned int ratio;
> +	unsigned int ch0;
> +	unsigned int ch1;
> +};
> +
> +/* This structure is intentionally large to accommodate updates via sysfs. */
> +/* Sized to 11 = max 10 segments + 1 termination segment */
> +/* Assumption is is one and only one type of glass used  */
> +struct taos_lux taos_device_lux[11] = {
> +	{  9830,  8520, 15729 },
> +	{ 12452, 10807, 23344 },
> +	{ 14746,  6383, 11705 },
> +	{ 17695,  4063,  6554 },
> +};
> +
I don't think this is used?
> +struct taos_lux taos_lux;
> +
> +struct gainadj {
> +	s16 ch0;
> +	s16 ch1;
> +};
> +
> +/* Index = (0 - 3) Used to validate the gain selection index */
> +static const struct gainadj gainadj[] = {
> +	{ 1, 1 },
> +	{ 8, 8 },
> +	{ 16, 16 },
> +	{ 107, 115 }
> +};
> +
> +/*
> + * Provides initial operational parameter defaults.
> + * These defaults may be changed through the device's sysfs files.
> + */
How about pasing in taos_settings and making all of this func a bit more
readable?
> +static void taos_defaults(struct tsl2583_chip *chip)
> +{
> +	/* Operational parameters */
> +	chip->taos_settings.als_time = 450;
> +	/* must be a multiple of 50mS */
> +	chip->taos_settings.als_gain = 2;
> +	/* this is actually an index into the gain table */
> +	/* assume clear glass as default */
> +	chip->taos_settings.als_gain_trim = 1000;
> +	/* default gain trim to account for aperture effects */
> +	chip->taos_settings.als_cal_target = 130;
> +	/* Known external ALS reading used for calibration */
> +}
> +
> +/*
> + * Read a number of bytes starting at register (reg) location.
> + * Return 0, or i2c_smbus_write_byte ERROR code.
> + */
> +static int
> +taos_i2c_read(struct i2c_client *client, u8 reg, u8 *val, unsigned int len)
> +{
> +	int ret;
> +	int i;
> +
> +	for (i = 0; i < len; i++) {
> +		/* select register to write */
> +		ret = i2c_smbus_write_byte(client, (TSL258X_CMD_REG | reg));
> +		if (ret < 0) {
> +			dev_err(&client->dev, "taos_i2c_read failed to write"
> +				" register %x\n", reg);
> +			return ret;
> +		}
> +		/* read the data */
> +		*val = i2c_smbus_read_byte(client);
> +	  	val++;
> +		reg++;
> +	}
> +	return 0;
> +}
> +
> +/*
> + * This function is used to send a command to device command/control register
> + * All bytes sent using this command have their MSBit set - it's a command!
> + * Return 0, or i2c_smbus_write_byte error code.
> + */
> +static int taos_i2c_write_command(struct i2c_client *client, u8 reg)
> +{
> +	int ret;
> +
> +	/* write the data */
Why update reg?  reg | TSL258X_CMD_REG.

Also this is only used once in the code. I'd just roll this line in
directly there and get rid of this wrapper function.
> +	ret = i2c_smbus_write_byte(client, (reg |= TSL258X_CMD_REG));
> +	if (ret < 0) {
The error is pretty well reported by the one caller anyway
> +		dev_err(&client->dev, "FAILED: i2c_smbus_write_byte\n");
> +		return ret;
> +	}
Could just return ret as you check this for <0 anyway.
> +	return 0;
> +}
> +
> +/*
> + * Reads and calculates current lux value.
> + * The raw ch0 and ch1 values of the ambient light sensed in the last
> + * integration cycle are read from the device.
> + * Time scale factor array values are adjusted based on the integration time.
> + * The raw values are multiplied by a scale factor, and device gain is obtained
> + * using gain index. Limit checks are done next, then the ratio of a multiple
> + * of ch1 value, to the ch0 value, is calculated. The array taos_device_lux[]
> + * declared above is then scanned to find the first ratio value that is just
> + * above the ratio we just calculated. The ch0 and ch1 multiplier constants in
> + * the array are then used along with the time scale factor array values, to
> + * calculate the lux.
> + */
> +static int taos_get_lux(struct i2c_client *client)
> +{
> +	u32 ch0, ch1; /* separated ch0/ch1 data from device */
> +	u32 lux; /* raw lux calculated from device data */
> +	u32 ratio;
> +	u8 buf[5];
> +	struct taos_lux *p;
> +	struct tsl2583_chip *chip = i2c_get_clientdata(client);
> +	int i, ret;
> +	u32 ch0lux = 0;
> +	u32 ch1lux = 0;
> +
> +	if (mutex_trylock(&chip->als_mutex) == 0) {
> +		dev_info(&client->dev, "taos_get_lux device is busy\n");
> +		return chip->als_cur_info.lux; /* busy, so return LAST VALUE */
> +	}
> +
> +	if (chip->taos_chip_status != TAOS_CHIP_WORKING) {
> +		/* device is not enabled */
> +		dev_err(&client->dev, "taos_get_lux device is not enabled\n");
> +		ret = -EBUSY ;
> +		goto out_unlock;
> +	}
> +
> +	ret = taos_i2c_read(client, (TSL258X_CMD_REG), &buf[0], 1);
> +	if (ret < 0) {
> +		dev_err(&client->dev, "taos_get_lux failed to read CMD_REG\n");
> +		goto out_unlock;
> +	}
> +	/* is data new & valid */
> +	if (!(buf[0] & TSL258X_STA_ADC_INTR)) {
> +		dev_err(&client->dev, "taos_get_lux data not valid\n");
> +		ret = chip->als_cur_info.lux; /* return LAST VALUE */
> +		goto out_unlock;
> +	}
> +
> +	for (i = 0; i < 4; i++) {
> +		int reg = TSL258X_CMD_REG | (TSL258X_ALS_CHAN0LO + i);
> +		ret = taos_i2c_read(client, reg, &buf[i], 1);
> +		if (ret < 0) {
> +			dev_err(&client->dev, "taos_get_lux failed to read"
> +				" register %x\n", reg);
> +			goto out_unlock;
> +		}
> +	}
> +
> +	/* clear status, really interrupt status (interrupts are off), but
> +	 * we use the bit anyway */
> +	ret = taos_i2c_write_command(client,
> +		TSL258X_CMD_REG | TSL258X_CMD_SPL_FN | TSL258X_CMD_ALS_INT_CLR);
> +	if (ret < 0) {
> +		dev_err(&client->dev,
> +			"taos_i2c_write_command failed in taos_get_lux, err = %d\n",
> +			ret);
> +		goto out_unlock; /* have no data, so return failure */
> +	}
> +
> +	/* extract ALS/lux data */
These appear to be endianness convesions.  ch0 = le16tocpu(&buf[0])? That way they compile
out to a copy if we happen to be on a little endian machine. Also these seem to be explicitly
16 bits, so u16 makes more sense.
> +	ch0 = (buf[1] << 8) | buf[0];
> +	ch1 = (buf[3] << 8) | buf[2];
> +
> +	chip->als_cur_info.als_ch0 = ch0;
> +	chip->als_cur_info.als_ch1 = ch1;
> +
> +	if ((ch0 >= chip->als_saturation) || (ch1 >= chip->als_saturation))
would be easier to read if you set ret to lux max here an avoid jumping into
the if statement below.
> +		goto return_max;
> +
> +	if (ch0 == 0) {
> +		/* have no data, so return LAST VALUE */
> +		ret = chip->als_cur_info.lux = 0;
> +		goto out_unlock;
> +	}
> +	/* calculate ratio */
> +	ratio = (ch1 << 15) / ch0;
> +	/* convert to unscaled lux using the pointer to the table */
&taos_device_lux[0] perhaps?
> +	for (p = (struct taos_lux *) taos_device_lux;
> +	     p->ratio != 0 && p->ratio < ratio; p++)
> +		;
> +
> +	if (p->ratio == 0) {
> +		lux = 0;
> +	} else {
> +		ch0lux = ((ch0 * p->ch0) +
> +			  (gainadj[chip->taos_settings.als_gain].ch0 >> 1))
> +			 / gainadj[chip->taos_settings.als_gain].ch0;
> +		ch1lux = ((ch1 * p->ch1) +
> +			  (gainadj[chip->taos_settings.als_gain].ch1 >> 1))
> +			 / gainadj[chip->taos_settings.als_gain].ch1;
> +		lux = ch0lux - ch1lux;
> +	}
> +
> +	/* note: lux is 31 bit max at this point */
> +	if (ch1lux > ch0lux) {
> +		dev_dbg(&client->dev, "No Data - Return last value\n");
> +		ret = chip->als_cur_info.lux = 0;
> +		goto out_unlock;
> +	}
> +
> +	/* adjust for active time scale */
> +	if (chip->als_time_scale == 0)
> +		lux = 0;
> +	else
> +		lux = (lux + (chip->als_time_scale >> 1)) /
> +			chip->als_time_scale;
> +
> +	/* adjust for active gain scale */
> +	lux >>= 13; /* tables have factor of 8192 builtin for accuracy */
> +	lux = (lux * chip->taos_settings.als_gain_trim + 500) / 1000;
> +	if (lux > LUX_CALC_OVER_FLOW) { /* check for overflow */
> +return_max:
> +		lux = LUX_CALC_OVER_FLOW;
> +	}
> +
> +	/* Update the structure with the latest VALID lux. */
> +	chip->als_cur_info.lux = lux;
> +	ret = lux;
> +
> +out_unlock:
> +	mutex_unlock(&chip->als_mutex);
> +	return ret;
> +}
> +
> +/*
> + * Obtain single reading and calculate the als_gain_trim (later used
> + * to derive actual lux).
> + * Return updated gain_trim value.
> + */
> +int taos_als_calibrate(struct i2c_client *client)
> +{
> +	struct tsl2583_chip *chip = i2c_get_clientdata(client);
> +	u8 reg_val;
> +	unsigned int gain_trim_val;
> +	int ret;
> +	int lux_val;
> +
> +	ret = i2c_smbus_write_byte(client, (TSL258X_CMD_REG | TSL258X_CNTRL));
> +	if (ret < 0) {
> +		dev_err(&client->dev,
> +			"taos_als_calibrate failed to reach the CNTRL register, ret=%d\n",
> +			ret);
> +		return ret;
> +	}
> +
> +	reg_val = i2c_smbus_read_byte(client);
> +	if ((reg_val & (TSL258X_CNTL_ADC_ENBL | TSL258X_CNTL_PWR_ON))
> +			!= (TSL258X_CNTL_ADC_ENBL | TSL258X_CNTL_PWR_ON)) {
> +		dev_err(&client->dev,
> +			"taos_als_calibrate failed: device not powered on with ADC enabled\n");
> +		return -ENODATA;
> +	}
> +
> +	ret = i2c_smbus_write_byte(client, (TSL258X_CMD_REG | TSL258X_CNTRL));
> +	if (ret < 0) {
> +		dev_err(&client->dev,
> +			"taos_als_calibrate failed to reach the STATUS register, ret=%d\n",
> +			ret);
> +		return ret;
> +	}
> +	reg_val = i2c_smbus_read_byte(client);
> +
what if it's an error?  Then we want to return that rather than -ENODATA.
> +	if ((reg_val & TSL258X_STA_ADC_VALID) != TSL258X_STA_ADC_VALID) {
> +		dev_err(&client->dev,
> +			"taos_als_calibrate failed: STATUS - ADC not valid.\n");
> +		return -ENODATA;
> +	}
> +	lux_val = taos_get_lux(client);
> +	if (lux_val < 0) {
> +		dev_err(&client->dev, "taos_als_calibrate failed to get lux\n");
> +		return lux_val;
> +	}
> +	gain_trim_val = (unsigned int) (((chip->taos_settings.als_cal_target)
> +			* chip->taos_settings.als_gain_trim) / lux_val);
> +
If it is worth printing this to the log, we don't care about where it
is stored just what it is.  Otherwise, shouldn't be here.
> +	dev_info(&client->dev, "taos_settings.als_cal_target = %d\n"
> +		"taos_settings.als_gain_trim = %d\nlux_val = %d\n",
> +		chip->taos_settings.als_cal_target,
> +		chip->taos_settings.als_gain_trim,
> +		lux_val);
> +
> +	if ((gain_trim_val < 250) || (gain_trim_val > 4000)) {
> +		dev_err(&client->dev,
> +			"taos_als_calibrate failed: trim_val of %d is out of range\n",
> +			gain_trim_val);
> +		return -ENODATA;
> +	}
> +	chip->taos_settings.als_gain_trim = (int) gain_trim_val;
> +
> +	return (int) gain_trim_val;
> +}
> +
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
> +	if (chip->taos_chip_status == TAOS_CHIP_WORKING) {
> +		/* if forcing a register update - turn off, then on */
> +		dev_info(&client->dev, "device is already enabled\n");
  -EINVAL perhaps?
> +		return -1;
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
We still don't know what SKATE is...  Any publically available terms possible?
> +	/* SKATE Specific power-on / adc enable sequence
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
> +	for (i = 0, uP = chip->taos_config; i < TAOS_REG_MAX; i++) {
> +		ret = i2c_smbus_write_byte_data(client, TSL258X_CMD_REG + i,
> +						*uP++);
> +		if (ret < 0) {
> +			dev_err(&client->dev,
> +				"taos_chip_on failed on reg %d.\n", i);
> +			return -1;
> +		}
> +	}
> +
If not time critical lest make that a sleep.
> +	mdelay(3);
> +	/* NOW enable the ADC
> +	 * initialize the desired mode of operation */
> +	utmp = TSL258X_CNTL_PWR_ON | TSL258X_CNTL_ADC_ENBL;
> +	ret = i2c_smbus_write_byte_data(client, TSL258X_CMD_REG | TSL258X_CNTRL,
> +					utmp);
> +	if (ret < 0) {
> +		dev_err(&client->dev, "taos_chip_on failed on 2nd CTRL reg.\n");
> +		return -1;
> +	}
> +	chip->taos_chip_status = TAOS_CHIP_WORKING;
conventionally blank line here.
> +	return ret;
> +}
> +
> +/* Turn the device OFF. */
> +static int taos_chip_off(struct i2c_client *client)
> +{
> +	struct tsl2583_chip *chip = i2c_get_clientdata(client);
> +	int ret;
> +	u8 utmp;
> +
> +	/* turn device off */
Kind of obvious comment in this function ;)  Please remove.
> +	chip->taos_chip_status = TAOS_CHIP_SLEEP;
> +	utmp = 0x00;
Why not just put this value into the function call and get rid of utmp as a variable?
> +	ret = i2c_smbus_write_byte_data(client, TSL258X_CMD_REG | TSL258X_CNTRL,
> +					utmp);
> +	return ret;
> +}
> +
> +/* Sysfs Interface Functions */
> +static ssize_t taos_device_id(struct device *dev,
> +    struct device_attribute *attr, char *buf)
> +{
> +	struct iio_dev *indio_dev = dev_get_drvdata(dev);
> +	struct tsl2583_chip *chip = indio_dev->dev_data;
> +
> +	return sprintf(buf, "%s\n", chip->client->name);
> +}
> +
> +static ssize_t taos_power_state_show(struct device *dev,
> +    struct device_attribute *attr, char *buf)
> +{
> +	struct iio_dev *indio_dev = dev_get_drvdata(dev);
> +	struct tsl2583_chip *chip = indio_dev->dev_data;
> +
> +	return sprintf(buf, "%d\n", chip->taos_chip_status);
> +}
> +
> +static ssize_t taos_power_state_store(struct device *dev,
> +    struct device_attribute *attr, const char *buf, size_t len)
> +{
> +	struct iio_dev *indio_dev = dev_get_drvdata(dev);
> +	struct tsl2583_chip *chip = indio_dev->dev_data;
> +	unsigned long value;
> +
> +	if (strict_strtoul(buf, 0, &value))
> +		return -EINVAL;
> +
(wishful thought of the day)
One day someone will write a nice standard 'boolean' test function
that everyone will agree on...  This works for me though ;)
> +	if (value == 0)
> +		taos_chip_off(chip->client);
> +	else
> +		taos_chip_on(chip->client);
> +
> +	return len;
> +}
> +
> +static ssize_t taos_gain_show(struct device *dev,
> +    struct device_attribute *attr, char *buf)
> +{
> +	struct iio_dev *indio_dev = dev_get_drvdata(dev);
> +	struct tsl2583_chip *chip = indio_dev->dev_data;
> +
> +	return sprintf(buf, "%d\n", chip->taos_settings.als_gain);
> +}
> +
> +static ssize_t taos_gain_store(struct device *dev,
> +    struct device_attribute *attr, const char *buf, size_t len)
> +{
> +	struct iio_dev *indio_dev = dev_get_drvdata(dev);
> +	struct tsl2583_chip *chip = indio_dev->dev_data;
> +	unsigned long value;
> +	if (strict_strtoul(buf, 0, &value))
> +		return -EINVAL;
> +
I still wonder if there isn't a way of avoiding this index issue.
It's horrible and really feels like something we ought to able
to handle reasonably well...
> +	if (value > 3) {
> +		dev_err(dev, "Invalid Gain Index: Enter 0-3\n");
> +		return -1;
> +	} else {
> +		chip->taos_settings.als_gain = value;
> +	}
> +	return len;
> +}
> +
> +static ssize_t taos_gain_available_show(struct device *dev,
> +    struct device_attribute *attr, char *buf)
> +{
> +	return sprintf(buf, "%s\n", "0 1 2 3");
> +}
> +
Just to confirm, is this a frequency in Hz? If it is
can we renaming it to taos_als_frequency_show to
avoid confusing me?
> +static ssize_t taos_als_time_show(struct device *dev,
> +    struct device_attribute *attr, char *buf)
> +{
> +	struct iio_dev *indio_dev = dev_get_drvdata(dev);
> +	struct tsl2583_chip *chip = indio_dev->dev_data;
> +
> +	return sprintf(buf, "%d\n", chip->taos_settings.als_time);
> +}
> +
> +static ssize_t taos_als_time_store(struct device *dev,
> +    struct device_attribute *attr, const char *buf, size_t len)
> +{
> +	struct iio_dev *indio_dev = dev_get_drvdata(dev);
> +	struct tsl2583_chip *chip = indio_dev->dev_data;
> +	unsigned long value;
> +
> +	if (strict_strtoul(buf, 0, &value))
> +		return -EINVAL;
> +
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
> +    struct device_attribute *attr, char *buf)
> +{
> +	return sprintf(buf, "%s\n", "50 100 150 200 250 300 350 400 450 500 550 600 650");
> +}
> +
> +static ssize_t taos_als_trim_show(struct device *dev,
> +    struct device_attribute *attr, char *buf)
> +{
> +	struct iio_dev *indio_dev = dev_get_drvdata(dev);
> +	struct tsl2583_chip *chip = indio_dev->dev_data;
> +
> +	return sprintf(buf, "%d\n", chip->taos_settings.als_gain_trim);
> +}
> +
> +static ssize_t taos_als_trim_store(struct device *dev,
> +    struct device_attribute *attr, const char *buf, size_t len)
> +{
> +	struct iio_dev *indio_dev = dev_get_drvdata(dev);
> +	struct tsl2583_chip *chip = indio_dev->dev_data;
> +	unsigned long value;
> +
> +	if (strict_strtoul(buf, 0, &value))
> +		return -EINVAL;
> +
> +	if (value)
> +		chip->taos_settings.als_gain_trim = value;
> +
> +	return len;
> +}
> +
> +static ssize_t taos_als_cal_target_show(struct device *dev,
> +    struct device_attribute *attr, char *buf)
> +{
> +	struct iio_dev *indio_dev = dev_get_drvdata(dev);
> +	struct tsl2583_chip *chip = indio_dev->dev_data;
> +
> +	return sprintf(buf, "%d\n", chip->taos_settings.als_cal_target);
> +}
> +
> +static ssize_t taos_als_cal_target_store(struct device *dev,
> +    struct device_attribute *attr, const char *buf, size_t len)
> +{
> +	struct iio_dev *indio_dev = dev_get_drvdata(dev);
> +	struct tsl2583_chip *chip = indio_dev->dev_data;
> +	unsigned long value;
> +
> +	if (strict_strtoul(buf, 0, &value))
> +		return -EINVAL;
> +
> +	if (value)
> +		chip->taos_settings.als_cal_target = value;
> +
> +	return len;
> +}
> +
> +static ssize_t taos_lux_show(struct device *dev, struct device_attribute *attr,
> +    char *buf)
> +{
> +	struct iio_dev *indio_dev = dev_get_drvdata(dev);
> +	struct tsl2583_chip *chip = indio_dev->dev_data;
> +	int lux;
> +
> +	lux = taos_get_lux(chip->client);
> +
> +	return sprintf(buf, "%d\n", lux);
> +}
> +
> +static ssize_t taos_do_calibrate(struct device *dev,
> +    struct device_attribute *attr, const char *buf, size_t len)
> +{
> +	struct iio_dev *indio_dev = dev_get_drvdata(dev);
> +	struct tsl2583_chip *chip = indio_dev->dev_data;
> +	unsigned long value;
> +
> +	if (strict_strtoul(buf, 0, &value))
> +		return -EINVAL;
> +
> +	if (value == 1)
> +		taos_als_calibrate(chip->client);
> +
> +	return len;
> +}
> +
> +static ssize_t taos_luxtable_show(struct device *dev,
> +    struct device_attribute *attr, char *buf)
> +{
> +	int i;
> +	int offset = 0;
> +
> +	for (i = 0; i < ARRAY_SIZE(taos_device_lux); i++) {
> +		offset += sprintf(buf + offset, "%d,%d,%d,",
> +				  taos_device_lux[i].ratio,
> +				  taos_device_lux[i].ch0,
> +				  taos_device_lux[i].ch1);
> +		if (taos_device_lux[i].ratio == 0) {
> +			/* We just printed the first "0" entry.
> +			 * Now get rid of the extra "," and break. */
> +			offset--;
> +			break;
> +		}
> +	}
> +
> +	offset += sprintf(buf + offset, "\n");
> +	return offset;
> +}
> +
> +static ssize_t taos_luxtable_store(struct device *dev,
> +    struct device_attribute *attr, const char *buf, size_t len)
> +{
> +	struct iio_dev *indio_dev = dev_get_drvdata(dev);
> +	struct tsl2583_chip *chip = indio_dev->dev_data;
> +	int value[ARRAY_SIZE(taos_device_lux)];
> +	int n;
> +
> +	get_options(buf, ARRAY_SIZE(value), value);
> +
> +	/* We now have an array of ints starting at value[1], and
> +	 * enumerated by value[0].
> +	 * We expect each group of three ints is one table entry,
> +	 * and the last table entry is all 0.
> +	 */
> +	n = value[0];
> +	if ((n % 3) || n < 6 || n > (ARRAY_SIZE(taos_device_lux) - 3)) {
> +		dev_info(dev, "LUX TABLE INPUT ERROR 1 Value[0]=%d\n", n);
> +		return -EINVAL;
> +	}
> +	if ((value[(n - 2)] | value[(n - 1)] | value[n]) != 0) {
> +		dev_info(dev, "LUX TABLE INPUT ERROR 2 Value[0]=%d\n", n);
> +		return -EINVAL;
> +	}
> +
> +	if (chip->taos_chip_status == TAOS_CHIP_WORKING)
> +		taos_chip_off(chip->client);
> +
> +	/* Zero out the table */
> +	memset(taos_device_lux, 0, sizeof(taos_device_lux));
> +	memcpy(taos_device_lux, &value[1], (value[0] * 4));
> +
> +	taos_chip_on(chip->client);
> +
> +	return len;
> +}
> +

> +static DEVICE_ATTR(name, S_IRUGO, taos_device_id, NULL);
> +static DEVICE_ATTR(power_state, S_IRUGO | S_IWUSR,
> +		taos_power_state_show, taos_power_state_store);
> +
> +static DEVICE_ATTR(illuminance0_calibscale, S_IRUGO | S_IWUSR,
> +		taos_gain_show, taos_gain_store);
> +static DEVICE_ATTR(illuminance0_calibscale_available, S_IRUGO,
> +		taos_gain_available_show, NULL);
> +
> +static DEVICE_ATTR(sampling_frequency, S_IRUGO | S_IWUSR,
> +		taos_als_time_show, taos_als_time_store);
> +static DEVICE_ATTR(sampling_frequency_available, S_IRUGO,
> +		taos_als_time_available_show, NULL);
> +
scale as a stand alone attribute isn't defined. Please document this.
Looking at what you do with it, it's another factor effecting the overal
gain on the reading that reaches userspace.  Ideally you'd roll this
into your calibscale parameter, but I can see that would get complex
to manage. Will have a think about this. In devices with a simple conversion
function (adc's etc) we handle this by leaving this software value
be applied by userspace (and output it as in_scale). The issue here that
as far as userspace is concerned both of your scales have been applied before
it sees the data and at different more or less random looking points in
the calculation.

Actually, looking at the calculation you could output illuminance0_raw
and let userspace apply a multiplier based on your trim value and offset
+0.5?  If you want to hold trim in driver then just implement
read and write to

illuminance0_scale
and have read only
illuminance0_offset (rather tediously for this device, offset is applied
before scale, so you'll need to divide 0.5 by whatever your trim is).

We'll have to do pin down how to do this before moving out of staging
so best to get it right now.

> +static DEVICE_ATTR(scale, S_IRUGO | S_IWUSR,
> +		taos_als_trim_show, taos_als_trim_store);
> +
> +static DEVICE_ATTR(illuminance0_target, S_IRUGO | S_IWUSR,
> +		taos_als_cal_target_show, taos_als_cal_target_store);
This needs documenting.  Also if it is calculated units (e.g. lux)
needs to be illuminance0_input_target to make that explicit.

> +
> +static DEVICE_ATTR(illuminance0_input, S_IRUGO, taos_lux_show, NULL);
> +static DEVICE_ATTR(calibrate, S_IWUSR, NULL, taos_do_calibrate);
calibrate needs documentation.


> +static DEVICE_ATTR(lux_table, S_IRUGO | S_IWUSR,
> +		taos_luxtable_show, taos_luxtable_store);
> +
> +static struct attribute *sysfs_attrs_ctrl[] = {
> +	&dev_attr_name.attr,
> +	&dev_attr_power_state.attr,
> +	&dev_attr_illuminance0_calibscale.attr,
> +	&dev_attr_illuminance0_calibscale_available.attr,
> +	&dev_attr_sampling_frequency.attr,
> +	&dev_attr_sampling_frequency_available.attr,
> +	&dev_attr_scale.attr,
> +	&dev_attr_illuminance0_target.attr,
> +	&dev_attr_illuminance0_input.attr,
> +	&dev_attr_calibrate.attr,
> +	&dev_attr_lux_table.attr,
> +	NULL
> +};
> +
> +static struct attribute_group tsl2583_attribute_group = {
> +	.attrs = sysfs_attrs_ctrl,
> +};
> +
> +/* Use the default register values to identify the Taos device */
> +static int taos_skate_device(unsigned char *bufp)
> +{
return ((bufp[TSL258X_CHIPID] & 0xf0) == 0x90);
> +	if (((bufp[TSL258X_CHIPID] & 0xf0) == 0x90))
> +		/* tsl2583 */
> +		return 1;
> +	/* else unknown */
> +	return 0;
> +}
> +
> +/*
> + * Client probe function - When a valid device is found, the driver's device
> + * data structure is updated, and initialization completes successfully.
> + */
> +static int __devinit taos_probe(struct i2c_client *clientp,
> +		      const struct i2c_device_id *idp)
> +{
> +	int i, ret = 0;
> +	unsigned char buf[MAX_DEVICE_REGS];
> +	static struct tsl2583_chip *chip;
> +
> +	if (!i2c_check_functionality(clientp->adapter,
> +		I2C_FUNC_SMBUS_BYTE_DATA)) {
> +		dev_err(&clientp->dev,
> +			"taos_probe() - i2c smbus byte data "
> +			"functions unsupported\n");
> +		return -EOPNOTSUPP;
> +	}
> +	if (!i2c_check_functionality(clientp->adapter,
> +		I2C_FUNC_SMBUS_WORD_DATA)) {
> +		dev_warn(&clientp->dev,
> +			"taos_probe() - i2c smbus word data "
> +			"functions unsupported\n");
Why do you care?  I'm not seeing them being used anyway.

> +	}
> +	if (!i2c_check_functionality(clientp->adapter,
> +		I2C_FUNC_SMBUS_BLOCK_DATA)) {
> +		dev_err(&clientp->dev,
> +			"taos_probe() - i2c smbus block data "
> +			"functions unsupported\n");
Nor these.
> +	}
> +
> +	chip = kzalloc(sizeof(struct tsl2583_chip), GFP_KERNEL);
> +	if (!chip) {
Malloc failure would be pretty unusual and knowing what it was probably
won't be helpful, so no need to have this err printing here.
> +		dev_err(&clientp->dev, "taos_device_drvr: kmalloc for "
> +			"struct tsl2583_chip failed in taos_probe()\n");
> +		return -ENOMEM;
> +	}
> +
> +	chip->client = clientp;
> +	i2c_set_clientdata(clientp, chip);
> +
> +	mutex_init(&chip->als_mutex);
> +	chip->taos_chip_status = TAOS_CHIP_UNKNOWN; /* uninitialized to start */
> +	memcpy(chip->taos_config, taos_config, sizeof(chip->taos_config));
> +
> +	for (i = 0; i < MAX_DEVICE_REGS; i++) {
> +		ret = i2c_smbus_write_byte(clientp,
> +				(TSL258X_CMD_REG | (TSL258X_CNTRL + i)));
> +		if (ret < 0) {
> +			dev_err(&clientp->dev, "i2c_smbus_write_byte() to cmd "
> +				"reg failed in taos_probe(), err = %d\n", ret);
> +			goto fail1;
> +		}
> +		buf[i] = i2c_smbus_read_byte(clientp);
  error handling for this read?
> +	}
> +	if (!taos_skate_device(buf)) {
> +		dev_info(&clientp->dev, "i2c device found but does not match "
> +			"expected id in taos_probe()\n");
> +		goto fail1;
> +	} else {
The sort of debug info you want to get rid of for production drivers.  Doesn't
tell anyone anything helpful.
> +		dev_info(&clientp->dev, "i2c device match in probe\n");
> +	}
> +	ret = i2c_smbus_write_byte(clientp, (TSL258X_CMD_REG | TSL258X_CNTRL));
> +	if (ret < 0) {
> +		dev_err(&clientp->dev, "i2c_smbus_write_byte() to cmd reg "
> +			"failed in taos_probe(), err = %d\n", ret);
> +		goto fail1;
> +	}
> +	chip->valid = 0;
> +
> +	chip->iio_dev = iio_allocate_device();
> +	if (!chip->iio_dev) {
> +		ret = -ENOMEM;
> +		dev_err(&clientp->dev, "iio allocation failed\n");
> +		goto fail1;
> +	}
> +
> +	chip->iio_dev->attrs = &tsl2583_attribute_group;
> +	chip->iio_dev->dev.parent = &clientp->dev;
> +	chip->iio_dev->dev_data = (void *)(chip);
> +	chip->iio_dev->driver_module = THIS_MODULE;
> +	chip->iio_dev->modes = INDIO_DIRECT_MODE;
> +	ret = iio_device_register(chip->iio_dev);
> +	if (ret) {
> +		dev_err(&clientp->dev, "iio registration failed\n");
> +		goto fail1;
> +	}
> +
> +	/* Load up the V2 defaults (these are hard coded defaults for now) */
> +	taos_defaults(chip);
> +
> +	/* Make sure the chip is on */
> +	taos_chip_on(clientp);
> +
> +	dev_info(&clientp->dev, "Light sensor found.\n");
> +	return 0;
> +
> +fail1:
> +	kfree(chip);
> +
> +	return ret;
> +}
> +
> +static int __devexit taos_remove(struct i2c_client *client)
> +{
> +	struct tsl2583_chip *chip = i2c_get_clientdata(client);
> +
> +	iio_device_unregister(chip->iio_dev);
> +
> +	kfree(chip);
> +	return 0;
> +}
> +
> +static struct i2c_device_id taos_idtable[] = {
> +	{ "tsl2580", 0 },
> +	{ "tsl2581", 1 },
> +	{ "tsl2583", 2 },
> +	{}
> +};
> +MODULE_DEVICE_TABLE(i2c, taos_idtable);
> +
> +/* Driver definition */
> +static struct i2c_driver taos_driver = {
> +	.driver = {
> +		.name = "tsl2583",
> +	},
> +	.id_table = taos_idtable,
> +	.probe = taos_probe,
> +	.remove = __devexit_p(taos_remove),
> +};
> +
> +static int __init taos_init(void)
> +{
> +	return i2c_add_driver(&taos_driver);
> +}
> +
> +static void __exit taos_exit(void)
> +{
> +	i2c_del_driver(&taos_driver);
> +}
> +
> +module_init(taos_init);
> +module_exit(taos_exit);
> +
> +MODULE_AUTHOR("J. August Brenner<jbrenner@taosinc.com>");
> +MODULE_DESCRIPTION("TAOS tsl2583 ambient light sensor driver");
> +MODULE_LICENSE("GPL");
> +
> --
> 1.7.0.4
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-iio" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

