Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756912Ab2BMPUO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 10:20:14 -0500
Received: from ppsw-41.csi.cam.ac.uk ([131.111.8.141]:57058 "EHLO
	ppsw-41.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752013Ab2BMPUK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 10:20:10 -0500
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4F3929EB.6030505@cam.ac.uk>
Date: Mon, 13 Feb 2012 15:19:07 +0000
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:10.0) Gecko/20120124 Thunderbird/10.0
MIME-Version: 1.0
To: Jon Brenner <jbrenner@TAOSinc.com>
CC: Jonathan Cameron <jic23@kernel.org>, linux-kernel@vger.kernel.org,
        linux-iio <linux-iio@vger.kernel.org>
Subject: Re: [PATCH V1] TAOS tsl2x7x
References: <1328900812.15759.6.camel@jonz-ub2>
In-Reply-To: <1328900812.15759.6.camel@jonz-ub2>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/10/2012 7:06 PM, Jon Brenner wrote:
> TAOS device driver for tsl/tmd 2771 and 2772 device families (inc all variants).
>
> Signed-off-by: Jon Brenner<jbrenner@taosinc.com>
Hi Jon,

Good to see another driver from you. Reasonably keen but couple of 
medium sized issues
a) Use iio_chan_spec and callbacks in iio_info structure where 
possible.  Propose additional
elements where they make sense (such as your integration time).
b) Documentation should be slotted in relevant places in more general files.
c) I'm unconvinced the calibration stuff should be in kernel.

Thanks,

Jonathan
>
> ---
>   .../iio/Documentation/sysfs-bus-iio-light-tsl2x7x  |   71 +
>   drivers/staging/iio/light/Kconfig                  |   11 +
>   drivers/staging/iio/light/Makefile                 |    1 +
>   drivers/staging/iio/light/tsl2x7x_core.c           | 2053 ++++++++++++++++++++
>   drivers/staging/iio/light/tsl2x7x_core.h           |  138 ++
>   5 files changed, 2274 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/staging/iio/Documentation/sysfs-bus-iio-light-tsl2x7x b/drivers/staging/iio/Documentation/sysfs-bus-iio-light-tsl2x7x
> new file mode 100644
> index 0000000..f1bb5f5
> --- /dev/null
> +++ b/drivers/staging/iio/Documentation/sysfs-bus-iio-light-tsl2x7x
> @@ -0,0 +1,71 @@
Most of these are fairly general purpose so should be sysfs-bus-iio or 
sysfs-bus-iio-light.
Some are also shared with the tsl2583 doc so maybe move those into the 
light one.

Generally if the last bit (after the channel type) is restricted to the 
actual device then
it wants to be in this file.
If it's restricted to the class (light / proximity) then it wants to be
in sysfs-bus-iio-light or sysfs-bus-iio-proximity
If like proximity_raw or the thresh_value ones then it wants to be
in sysfs-bus-iio.

Please do fix any cases where this isn't currently the case.  Our 
documentation outside the top
level file is far from well written or organized.

> +What:		/sys/bus/iio/devices/device[n]/lux_table
> +KernelVersion:	2.6.37
> +Contact:	linux-iio@vger.kernel.org
> +Description:
> +		This property gets/sets the table of coefficients
> +		used in calculating illuminance in lux.
> +
> +What:		/sys/bus/iio/devices/device[n]/illuminance0_calibrate
> +KernelVersion:	2.6.37
> +Contact:	linux-iio@vger.kernel.org
> +Description:
> +		This property causes an internal calibration of the als gain trim
> +		value which is later used in calculating illuminance in lux.
> +
> +What:		/sys/bus/iio/devices/device[n]/illuminance0_thresh_falling_value
> +KernelVersion:	3.3-rc1
> +Contact:	linux-iio@vger.kernel.org
> +Description:
> +		Low (falling) trigger point for the internal ALS comparison
> +		function for interrupt generation.
This one just needs adding to sysfs-bus-iio.
> +
> +What:		/sys/bus/iio/devices/device[n]/illuminance0_thresh_rising_value
> +KernelVersion:	3.3-rc1
> +Contact:	linux-iio@vger.kernel.org
> +Description:
> +		high (rising) trigger point for the internal ALS comparison
> +		function for interrupt generation.
> +
> +What:		/sys/bus/iio/devices/device[n]/illuminance0_both_raw
> +KernelVersion:	3.3-rc1
> +Contact:	linux-iio@vger.kernel.org
> +Description:
> +		Simultainious ALS channel 1 and channel 2 data represented as
> +		a 32 bit integer.
err. previously the both has referred to the light frequencies covered. 
Please don't do what you
describe here. If you really need to be sure they are pared then you 
want to use the buffered
infrastructure not sysfs.

> +
> +What:		/sys/bus/iio/devices/device[n]/proximity_calibrate
> +KernelVersion:	3.3-rc1
> +Contact:	linux-iio@vger.kernel.org
> +Description:
> +		Causes an recalculation and adjustment to the
> +		proximity_thresh_rising_value.
> +
> +What:		/sys/bus/iio/devices/device[n]/proximity_thresh_falling_value
> +KernelVersion:	3.3-rc1
> +Contact:	linux-iio@vger.kernel.org
> +Description:
> +		Low (falling) trigger point for the internal proximity comparison
> +		function for interrupt generation.
> +
Again, standard form so add to sysfs-bus-iio.
> +What:		/sys/bus/iio/devices/device[n]/proximity_thresh_rising_value
> +KernelVersion:	3.3-rc1
> +Contact:	linux-iio@vger.kernel.org
> +Description:
> +		high (rising) trigger point for the internal proximity comparison
> +		function for interrupt generation.
> +
> +What:		/sys/bus/iio/devices/device[n]/proximity_calibscale
> +KernelVersion:	3.3-rc1
> +Contact:	linux-iio@vger.kernel.org
> +Description:
> +		Hardware or software applied calibration scale factor assumed
> +		to account for attenuation due to industrial design (glass
> +		filters or aperture holes).
> +
All of these are standard so add to sysfs-bus-iio lists for calibscale
> +What:		/sys/bus/iio/devices/device[n]/proximity_raw
> +KernelVersion:	3.3-rc1
> +Contact:	linux-iio@vger.kernel.org
> +Description:
> +		State of proximity detection based on the
> +		proximity_thresh_rising_value.
If you wouldn't mind can you lift he proximity documentation out of 
sysfs-bus-iio-ilght into sysfs-bus-iio
then we can take all the standard definitions without adding them yet 
again. (as a separate patch).

I'm still kind of regretting ever introducing multiple sysfs 
documentatino files.
> +
> diff --git a/drivers/staging/iio/light/Kconfig b/drivers/staging/iio/light/Kconfig
> index e7e9159..29de333 100644
> --- a/drivers/staging/iio/light/Kconfig
> +++ b/drivers/staging/iio/light/Kconfig
> @@ -31,4 +31,15 @@ config TSL2583
>   	 Provides support for the TAOS tsl2580, tsl2581 and tsl2583 devices.
>   	 Access ALS data via iio, sysfs.
>
> +	 This driver can also be built as a module.  If so, the module
> +	 will be called tsl2583.
errr.  This change to a comment about a completely different driver 
should not be in this patch.
> +
> +config TSL2x7x
> +	tristate "TAOS TSL/TMD2x71 and TSL/TMD2x72 Family of light and proximity sensors"
> +	depends on I2C
> +	help
> +	 Support for: tsl2571, tsl2671, tmd2671, tsl2771, tmd2771, tsl2572, tsl2672,
> +	 tmd2672, tsl2772, tmd2772 devices.
> +	 Provides iio_events and direct access via sysfs.
> +
>   endmenu
> diff --git a/drivers/staging/iio/light/Makefile b/drivers/staging/iio/light/Makefile
> index 3011fbf..ff12c4b 100644
> --- a/drivers/staging/iio/light/Makefile
> +++ b/drivers/staging/iio/light/Makefile
> @@ -5,3 +5,4 @@
>   obj-$(CONFIG_SENSORS_TSL2563)	+= tsl2563.o
>   obj-$(CONFIG_SENSORS_ISL29018)	+= isl29018.o
>   obj-$(CONFIG_TSL2583)	+= tsl2583.o
> +obj-$(CONFIG_TSL2x7x)	+= tsl2x7x_core.o
> diff --git a/drivers/staging/iio/light/tsl2x7x_core.c b/drivers/staging/iio/light/tsl2x7x_core.c
> new file mode 100644
> index 0000000..671f476
> --- /dev/null
> +++ b/drivers/staging/iio/light/tsl2x7x_core.c
> @@ -0,0 +1,2053 @@
> +/*
> + * Device driver for monitoring ambient light intensity in (lux)
> + * and proximity detection (prox) within the TAOS TSL2X7X family of devices.
> + *
> + * Copyright (c) 2012, TAOS Corporation.
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
> + * 51 Franklin Street, Fifth Floor, Boston, MA        02110-1301, USA.
> + */
> +
> +#include<linux/kernel.h>
> +#include<linux/i2c.h>
> +#include<linux/errno.h>
> +#include<linux/delay.h>
> +#include<linux/string.h>
> +#include<linux/mutex.h>
> +#include<linux/unistd.h>
> +#include<linux/interrupt.h>
> +#include<linux/platform_device.h>
> +#include<linux/input.h>
> +#include<linux/slab.h>
> +#include<linux/pm.h>
> +#include<linux/module.h>
> +#include<linux/version.h>
> +
> +#include<linux/cdev.h>
> +#include<linux/stat.h>
> +#include<linux/module.h>
> +#include "tsl2x7x_core.h"
> +#include "../events.h"
> +#include "../buffer.h"
> +#include "../iio.h"
> +#include "../sysfs.h"
> +
> +/* Cal defs*/
> +#define PROX_STAT_CAL        0
> +#define PROX_STAT_SAMP       1
> +#define MAX_SAMPLES_CAL      200
> +
> +/* TSL2X7X Device ID */
> +#define TRITON_ID    0x00
> +#define SWORDFISH_ID 0x30
> +#define HALIBUT_ID   0x20
> +
> +/* Lux calculation constants */
> +#define TSL2X7X_LUX_CALC_OVER_FLOW        65535
> +
> +/* TAOS txx2x7x Device family members */
> +enum {
> +	tsl2571,
> +	tsl2671,
> +	tmd2671,
> +	tsl2771,
> +	tmd2771,
> +	tsl2572,
> +	tsl2672,
> +	tmd2672,
> +	tsl2772,
> +	tmd2772
> +};
> +
> +enum {
> +	TSL2X7X_CHIP_UNKNOWN = 0,
> +	TSL2X7X_CHIP_WORKING = 1,
> +	TSL2X7X_CHIP_SUSPENDED = 2
> +};
> +
> +/* Per-device data */
> +struct tsl2x7x_als_info {
> +	u16 als_ch0;
> +	u16 als_ch1;
> +	u16 lux;
> +};
> +
> +/* proximity data */
> +struct tsl2x7x_prox_info {
> +	u16 prox_data;
> +	int prox_event;
> +};
> +
> +struct prox_stat {
> +	u16 min;
> +	u16 max;
> +	u16 mean;
> +	unsigned long stddev;
> +};
> +
> +struct tsl2x7x_settings {
> +	int als_time;
> +	int als_gain;
> +	int als_gain_trim;
> +	int wait_time;
> +	int prx_time;
> +	int prox_gain;
> +	int prox_config;
> +	int als_cal_target;
> +	u8  interrupts_en;
> +	u8  als_persistence;
> +	int als_thresh_low;
> +	int als_thresh_high;
> +	int prox_thres_low;
> +	int prox_thres_high;
> +	int prox_pulse_count;
> +	int prox_max_samples_cal;/* for calibration mode*/
> +
> +};
> +
> +struct tsl2X7X_chip_info {
> +	struct iio_chan_spec	channel[0];
> +	const struct iio_info	*info;
> +};
err. what is channel[0] for?  Please do the iio_chan_spec stuff fully.
> +
> +struct tsl2X7X_chip {
> +	kernel_ulong_t id;
> +	struct mutex prox_mutex;
> +	struct mutex als_mutex;
> +	struct i2c_client *client;
> +	struct iio_dev *iio_dev;
> +	struct tsl2x7x_prox_info prox_cur_info;
> +	struct tsl2x7x_als_info als_cur_info;
> +	struct tsl2x7x_settings tsl2x7x_settings;
> +	struct tsl2X7X_platform_data *pdata;
> +	int als_time_scale;
> +	int als_saturation;
> +	int tsl2x7x_chip_status;
> +	u8 tsl2x7x_config[TSL2X7X_REG_MAX];
> +	bool init_done;
> +	struct work_struct work_thresh;
> +	s64 event_timestamp;
> +	/* This structure is intentionally large to accommodate
> +	 * updates via sysfs. */
> +	/* Sized to 9 = max 8 segments + 1 termination segment */
> +	/* Assumption is one and only one type of glass used  */
> +	struct tsl2x7x_lux tsl2x7x_device_lux[MAX_TABLE_SIZE];
> +};
> +
> +/* Different devices require different coefficents */
> +static const struct tsl2x7x_lux tsl2x71_lux_table[] = {
> +	{ 14461,   611,   1211 },
> +	{ 18540,   352,    623 },
> +	{     0,     0,      0 },
> +};
> +
> +static const struct tsl2x7x_lux tmd2x71_lux_table[] = {
> +	{ 11635,   115,    256 },
> +	{ 15536,    87,    179 },
> +	{     0,     0,      0 },
> +};
> +
> +static const struct tsl2x7x_lux tsl2x72_lux_table[] = {
> +	{ 14013,   466,   917 },
> +	{ 18222,   310,   552 },
> +	{     0,     0,     0 },
> +};
> +
> +static const struct tsl2x7x_lux tmd2x72_lux_table[] = {
> +	{ 13218,   130,   262 },
> +	{ 17592,   92,    169 },
> +	{     0,     0,     0 },
> +};
> +
> +static const struct tsl2x7x_lux *tsl2x7x_default_lux_table_group[] = {
> +	[tsl2571] = tsl2x71_lux_table,
> +	[tsl2671] =	tsl2x71_lux_table,
> +	[tmd2671] =	tmd2x71_lux_table,
> +	[tsl2771] =	tsl2x71_lux_table,
> +	[tmd2771] =	tmd2x71_lux_table,
> +	[tsl2572] =	tsl2x72_lux_table,
> +	[tsl2672] =	tsl2x72_lux_table,
Check your spacing vs tabs.
> +	[tmd2672] = tmd2x72_lux_table,
> +	[tsl2772] =	tsl2x72_lux_table,
> +	[tmd2772] =	tmd2x72_lux_table,
> +};
> +
> +struct als_gainadj {
> +	s16 ch0;
> +	s16 ch1;
> +};
> +
> +/* Used to validate the ALS gain selection index */
> +static const struct als_gainadj tsl2X7X_als_gainadj[] = {
> +	{ 1, 1 },
> +	{ 8, 8 },
> +	{ 16, 16 },
> +	{ 120, 120 }
> +};
This is a somewhat novel structure....  Any real point in the two columns?
> +
> +
> +/* Not using channels */
> +static const struct iio_chan_spec tsl2X7X_channels[] = {};
> +
> +/*
> + * Read a number of bytes starting at register (reg) location.
> + * Return 0, or i2c_smbus_write_byte ERROR code.
> + */
> +static int
> +tsl2x7x_i2c_read(struct i2c_client *client, u8 reg, u8 *val, unsigned int len)
> +{
> +	int ret;
> +	int i;
> +
> +	for (i = 0; i<  len; i++) {
Just to check, does this correspond to i2c_smbus_read_byte_data(client, 
(TSL2X7X_CMD_REG | REG))?
Also, a quick look makes me think you only ever use this for one byte at 
a time...

> +		/* select register to write */
> +		ret = i2c_smbus_write_byte(client, (TSL2X7X_CMD_REG | reg));
> +		if (ret<  0) {
> +			dev_err(&client->dev, "tsl2x7x_i2c_read failed to write"
> +				" register %x\n", reg);
> +			return ret;
> +		}
> +		/* read the data */
> +		*val = i2c_smbus_read_byte(client);
> +		val++;
> +		reg++;
> +	}
> +	return 0;
> +}
> +
> +/*
Kernel doc please.
> + * Reads and calculates current lux value.
> + * The raw ch0 and ch1 values of the ambient light sensed in the last
> + * integration cycle are read from the device.
> + * Time scale factor array values are adjusted based on the integration time.
> + * The raw values are multiplied by a scale factor, and device gain is obtained
> + * using gain index. Limit checks are done next, then the ratio of a multiple
> + * of ch1 value, to the ch0 value, is calculated. The array tsl2x7x_device_lux[]
> + * declared above is then scanned to find the first ratio value that is just
> + * above the ratio we just calculated. The ch0 and ch1 multiplier constants in
> + * the array are then used along with the time scale factor array values, to
> + * calculate the lux.
> + */
> +static int tsl2x7x_get_lux(struct iio_dev *indio_dev)
> +{
> +	u16 ch0, ch1; /* separated ch0/ch1 data from device */
> +	u32 lux; /* raw lux calculated from device data */
> +	u64 lux64;
> +	u32 ratio;
> +#pragma pack(4)
? that needs some explanation...
> +	u8 buf[4];
> +	struct tsl2x7x_lux *p;
> +	struct tsl2X7X_chip *chip = iio_priv(indio_dev);
> +	int i, ret;
> +	u32 ch0lux = 0;
> +	u32 ch1lux = 0;
> +
as below, I find these try locks rather suspicious.   Please justify.
> +	if (mutex_trylock(&chip->als_mutex) == 0) {
> +		dev_info(&chip->client->dev, "tsl2x7x_get_lux device is busy\n");
> +		return chip->als_cur_info.lux; /* busy, so return LAST VALUE */
> +	}
> +
> +	if (chip->tsl2x7x_chip_status != TSL2X7X_CHIP_WORKING) {
> +		/* device is not enabled */
> +		dev_err(&chip->client->dev, "tsl2x7x_get_lux device is not enabled\n");
> +		ret = -EBUSY ;
> +		goto out_unlock;
> +	}
> +
> +	ret = tsl2x7x_i2c_read(chip->client,
> +		(TSL2X7X_CMD_REG | TSL2X7X_STATUS),&buf[0], 1);
> +	if (ret<  0) {
> +		dev_err(&chip->client->dev,
> +			"tsl2x7x_get_lux failed to read CMD_REG\n");
> +		goto out_unlock;
> +	}
> +	/* is data new&  valid */
> +	if (!(buf[0]&  TSL2X7X_STA_ADC_VALID)) {
> +		dev_err(&chip->client->dev,
> +			"tsl2x7x_get_lux data not valid yet\n");
> +		ret = chip->als_cur_info.lux; /* return LAST VALUE */
> +		goto out_unlock;
> +	}
> +
> +	for (i = 0; i<  4; i++) {
> +		ret = tsl2x7x_i2c_read(chip->client,
> +			(TSL2X7X_CMD_REG | (TSL2X7X_ALS_CHAN0LO + i)),
> +			&buf[i], 1);
> +		if (ret<  0) {
> +			dev_err(&chip->client->dev,
> +				"tsl2x7x_get_lux failed to read"
> +				" ret: %x\n", ret);
> +			goto out_unlock;
> +		}
> +	}
> +
> +	/* clear status, really interrupt status ( are off),
> +	but we use the bit anyway */
> +	ret = i2c_smbus_write_byte(chip->client,
> +		(TSL2X7X_CMD_REG |
> +				TSL2X7X_CMD_SPL_FN |
> +				TSL2X7X_CMD_ALS_INT_CLR));
> +
> +	if (ret<  0) {
> +		dev_err(&chip->client->dev,
> +		"tsl2x7x_i2c_write_command failed in tsl2x7x_get_lux, err = %d\n",
> +			ret);
> +		goto out_unlock; /* have no data, so return failure */
> +	}
> +
> +	/* extract ALS/lux data */
> +	ch0 = le16_to_cpup((const __le16 *)&buf[0]);
> +	ch1 = le16_to_cpup((const __le16 *)&buf[2]);
> +
> +	chip->als_cur_info.als_ch0 = ch0;
> +	chip->als_cur_info.als_ch1 = ch1;
> +
> +	if ((ch0>= chip->als_saturation) || (ch1>= chip->als_saturation))
> +		goto return_max;
> +
> +	if (ch0 == 0) {
> +		/* have no data, so return LAST VALUE */
> +		ret = chip->als_cur_info.lux = 0;
> +		goto out_unlock;
> +	}
> +	/* calculate ratio */
> +	ratio = (ch1<<  15) / ch0;
> +	/* convert to unscaled lux using the pointer to the table */
> +	for (p = (struct tsl2x7x_lux *) chip->tsl2x7x_device_lux;
> +	     p->ratio != 0&&  p->ratio<  ratio; p++)
stray semi colon.
> +		;
> +
> +	if (p->ratio == 0) {
> +		lux = 0;
> +	} else {
> +		ch0lux = ((ch0 * p->ch0) +
> +		(tsl2X7X_als_gainadj[chip->tsl2x7x_settings.als_gain].ch0>>  1))
> +		/ tsl2X7X_als_gainadj[chip->tsl2x7x_settings.als_gain].ch0;
> +
> +		ch1lux = ((ch1 * p->ch1) +
> +		(tsl2X7X_als_gainadj[chip->tsl2x7x_settings.als_gain].ch1>>  1))
> +		/ tsl2X7X_als_gainadj[chip->tsl2x7x_settings.als_gain].ch1;
> +
> +		lux = ch0lux - ch1lux;
> +	}
> +
> +	/* note: lux is 31 bit max at this point */
> +	if (ch1lux>  ch0lux) {
> +		dev_dbg(&chip->client->dev, "No Data - Return last value\n");
> +		ret = chip->als_cur_info.lux = 0;
> +		goto out_unlock;
> +	}
> +
> +	/* adjust for active time scale */
> +	if (chip->als_time_scale == 0)
> +		lux = 0;
> +	else
> +		lux = (lux + (chip->als_time_scale>>  1)) /
> +			chip->als_time_scale;
> +
> +	/* adjust for active gain scale
> +	 * The tsl2x7x_device_lux tables have a factor of 256 built-in.
> +	 * User-specified gain provides a multiplier.
> +	 * Apply user-specified gain before shifting right to retain precision.
> +	 * Use 64 bits to avoid overflow on multiplication.
> +	 * Then go back to 32 bits before division to avoid using div_u64().
> +	 */
> +	lux64 = lux;
> +	lux64 = lux64 * chip->tsl2x7x_settings.als_gain_trim;
> +	lux64>>= 8;
> +	lux = lux64;
> +	lux = (lux + 500) / 1000;
> +
> +	if (lux>  TSL2X7X_LUX_CALC_OVER_FLOW) { /* check for overflow */
> +return_max:
> +		lux = TSL2X7X_LUX_CALC_OVER_FLOW;
> +	}
> +
> +	/* Update the structure with the latest VALID lux. */
> +	chip->als_cur_info.lux = lux;
> +	ret = lux;
> +
> +out_unlock:
> +	mutex_unlock(&chip->als_mutex);
> +	return ret;
> +
> +}
> +
> +/*
> + * Proximity poll function - if valid data is available, read and form the ch0
> + * and prox data values, check for limits on the ch0 value, and check the prox
> + * data against the current thresholds, to set the event status accordingly.
> + */
> +static int tsl2x7x_prox_poll(struct iio_dev *indio_dev)
> +{
> +#define CONSECUTIVE_RETRIES 50
> +
> +	int i;
> +	int ret;
> +	u8 status;
> +	u8 chdata[2];
> +	int err_cnt;
> +	struct tsl2X7X_chip *chip = iio_priv(indio_dev);
> +
> +	if (mutex_trylock(&chip->prox_mutex) == 0) {
> +		dev_err(&chip->client->dev, "Can't get prox mutex\n");
> +		return -EBUSY;
> +	}
Trylocks always need an explanation as far as I am concerned. why not wait?
> +
> +	err_cnt = 0;
> +
> +try_again:
> +	ret = tsl2x7x_i2c_read(chip->client,
> +		(TSL2X7X_CMD_REG | TSL2X7X_STATUS),&status, 1);
> +	if (ret<  0) {
> +		dev_err(&chip->client->dev,
> +			"Read regs failed in tsl2x7x_prox_poll() - A\n");
> +		mutex_unlock(&chip->prox_mutex);
> +		return ret;
> +	}
> +
> +	/*Prox interrupt asserted*/
> +	if (((chip->tsl2x7x_settings.interrupts_en<<  4)
> +			&  CNTL_PROX_INT_ENBL)) {
> +		if (!(status&  TSL2X7X_STA_ADC_VALID)) {
I've not read the datasheet but this seems unusual.  You get an 
interrupt but the
value isn't valid?
> +			err_cnt++;
> +			if (err_cnt>  CONSECUTIVE_RETRIES) {
> +				mutex_unlock(&chip->prox_mutex);
> +				dev_err(&chip->client->dev,
> +				"Consec. retries exceeded\n");
> +				return chip->prox_cur_info.prox_event;
> +			}
> +			goto try_again;
> +		}
> +	}
> +
> +	for (i = 0; i<  2; i++) {
> +		ret = tsl2x7x_i2c_read(chip->client,
> +			(TSL2X7X_CMD_REG |
> +					(TSL2X7X_PRX_LO + i)),&chdata[i], 1);
> +		if (ret<  0) {
Errors like this are extremely unlikely (I hope) so I'd drop the 
message.  Also use a goto
and have the mutex_unlock in only one place as it's easier to read.
> +			dev_err(&chip->client->dev,
> +			"Read regs failed in tsl2x7x_prox_poll() - B\n");
> +			mutex_unlock(&chip->prox_mutex);
> +			return ret;
> +		}
> +	}
> +
> +	chip->prox_cur_info.prox_data = (chdata[1]<<8)|chdata[0];
> +
> +	if (chip->prox_cur_info.prox_data>=
> +			chip->tsl2x7x_settings.prox_thres_high)
> +		chip->prox_cur_info.prox_event = 1;
> +	else
> +		chip->prox_cur_info.prox_event = 0;
use chip->proc_cur_info.prox_event = chip->prox_cur_info.prox_data >= 
chip->tsl2x7x_settings.prox_thresh_high;
> +
> +	mutex_unlock(&chip->prox_mutex);
> +	return chip->prox_cur_info.prox_event;
> +}
> +
> +/*
> + * Provides initial operational parameter defaults.
> + * These defaults may be changed through the device's sysfs files.
> + */
Have a
const static struct tsl2x7x_settings tsl2x7x_defaults =
{
     .als_time = 200,
     ...
};
then memcpy it into place as necessary.
> +static void tsl2x7x_defaults(struct tsl2X7X_chip *chip)
> +{
> +	/* Operational parameters */
> +	chip->tsl2x7x_settings.als_time = 200;
> +	/* must be a multiple of 50mS */
> +	chip->tsl2x7x_settings.als_gain = 0;
> +	/* this is actually an index into the gain table */
> +	chip->tsl2x7x_settings.prx_time = 0xfe; /*5.4 mS */
> +	/* 2.7ms prox integration time - decrease to increase time */
> +	/* decreases in 2.7 ms intervals */
> +	chip->tsl2x7x_settings.prox_gain = 1;
> +	/* these are bits 3:2 of reg 0x0f: 0=x1,1=x2,2=x4,3=x8 */
> +	/* assume clear glass as default */
> +	chip->tsl2x7x_settings.wait_time = 245;
> +	/* Time between PRX and ALS cycles -decrease to increase time */
> +	/* decreases in 2.7 ms intervals */
> +	chip->tsl2x7x_settings.prox_config = 0;
> +	/* Prox configuration filters */
> +	chip->tsl2x7x_settings.als_gain_trim = 1000;
> +	/* default gain trim to account for aperture effects */
> +	chip->tsl2x7x_settings.als_cal_target = 150;
> +	/* Known external ALS reading used for calibration */
> +	chip->tsl2x7x_settings.als_thresh_low = 200;
> +	/* CH0 'low' count to trigger interrupt */
> +	chip->tsl2x7x_settings.als_thresh_high = 256;
> +	/* CH0 'high' count to trigger interrupt */
> +	chip->tsl2x7x_settings.als_persistence = 0xFF;
> +	/* Number of 'out of limits' ADC readings PRX/ALS*/
> +	chip->tsl2x7x_settings.interrupts_en = 0x00;
> +	/* Default interrupt(s) enabled.
> +	 * 0x00 = none, 0x10 = als, 0x20 = prx 0x30 = bth */
> +	chip->tsl2x7x_settings.prox_thres_low  = 0;
> +	chip->tsl2x7x_settings.prox_thres_high = 512;
> +	/*default threshold (adjust either manually or with cal routine*/
> +	chip->tsl2x7x_settings.prox_max_samples_cal = 30;
> +	chip->tsl2x7x_settings.prox_pulse_count = 8;
> +
> +	/* Load up the lux table. Can be changed later via ABI */
> +	if (chip->pdata&&  chip->pdata->platform_lux_table[0].ratio != 0)
> +		memcpy(chip->tsl2x7x_device_lux,
> +			chip->pdata->platform_lux_table,
> +			sizeof(chip->pdata->platform_lux_table));
> +	else
> +		memcpy(chip->tsl2x7x_device_lux,
> +		(struct tsl2x7x_lux *)tsl2x7x_default_lux_table_group[chip->id],
> +				MAX_DEFAULT_TABLE_BYTES);
> +
> +}
> +
As I've stated below, you really need to justify why we have calibration 
in the kernel rather
than userspace..
> +/*
> + * Obtain single reading and calculate the als_gain_trim
> + * (later used to derive actual lux).
> + * Return updated gain_trim value.
> + */
> +static int tsl2x7x_als_calibrate(struct iio_dev *indio_dev)
> +{
> +	struct tsl2X7X_chip *chip = iio_priv(indio_dev);
> +	u8 reg_val;
> +	int gain_trim_val;
> +	int ret;
> +	int lux_val;
> +
> +	ret = i2c_smbus_write_byte(chip->client,
> +			(TSL2X7X_CMD_REG | TSL2X7X_CNTRL));
> +	if (ret<  0) {
> +		dev_err(&chip->client->dev,
> +		"tsl2x7x_als_calibrate failed to write CNTRL register, ret=%d\n",
> +			ret);
> +		return ret;
> +	}
> +
> +	reg_val = i2c_smbus_read_byte(chip->client);
> +	if ((reg_val&  (TSL2X7X_CNTL_ADC_ENBL | TSL2X7X_CNTL_PWR_ON))
> +			!= (TSL2X7X_CNTL_ADC_ENBL | TSL2X7X_CNTL_PWR_ON)) {
> +		dev_err(&chip->client->dev,
> +			"tsl2x7x_als_calibrate failed: ADC not enabled\n");
> +		return -1;
> +	}
> +
> +	ret = i2c_smbus_write_byte(chip->client,
> +			(TSL2X7X_CMD_REG | TSL2X7X_CNTRL));
> +	if (ret<  0) {
> +		dev_err(&chip->client->dev,
> +		"tsl2x7x_als_calibrate failed to write ctrl reg: ret=%d\n",
> +			ret);
> +		return ret;
> +	}
> +	reg_val = i2c_smbus_read_byte(chip->client);
> +
> +	if ((reg_val&  TSL2X7X_STA_ADC_VALID) != TSL2X7X_STA_ADC_VALID) {
> +		dev_err(&chip->client->dev,
> +		"tsl2x7x_als_calibrate failed: STATUS - ADC not valid.\n");
> +		return -ENODATA;
> +	}
> +	lux_val = tsl2x7x_get_lux(indio_dev);
> +	if (lux_val<  0) {
> +		dev_err(&chip->client->dev,
> +		"tsl2x7x_als_calibrate failed to get lux\n");
> +		return lux_val;
> +	}
> +	gain_trim_val =  (((chip->tsl2x7x_settings.als_cal_target)
> +			* chip->tsl2x7x_settings.als_gain_trim) / lux_val);
> +
> +	if ((gain_trim_val<  250) || (gain_trim_val>  4000))
> +		return -ERANGE;
> +
> +	chip->tsl2x7x_settings.als_gain_trim = gain_trim_val;
> +
> +	dev_info(&chip->client->dev,
> +			"%s als_calibrate completed\n", chip->client->name);
> +
> +	return (int) gain_trim_val;
> +}
> +
> +/*
> + * Turn the device on.
> + * Configuration must be set before calling this function.
> + */
> +static int tsl2x7x_chip_on(struct iio_dev *indio_dev)
> +{
> +	int i;
> +	int ret = 0;
> +	u8 *dev_reg;
> +	u8 utmp;
> +	int als_count;
> +	int als_time;
> +	struct tsl2X7X_chip *chip = iio_priv(indio_dev);
> +	u8 reg_val = 0;
> +
> +	if (chip->pdata&&  chip->pdata->power_on)
> +		chip->pdata->power_on(indio_dev);
> +
> +	/* Non calculated parameters */
> +	chip->tsl2x7x_config[TSL2X7X_PRX_TIME] =
> +			chip->tsl2x7x_settings.prx_time;
> +	chip->tsl2x7x_config[TSL2X7X_WAIT_TIME] =
> +			chip->tsl2x7x_settings.wait_time;
> +	chip->tsl2x7x_config[TSL2X7X_PRX_CONFIG] =
> +			chip->tsl2x7x_settings.prox_config;
> +
> +	chip->tsl2x7x_config[TSL2X7X_ALS_MINTHRESHLO] =
> +		(chip->tsl2x7x_settings.als_thresh_low)&  0xFF;
> +	chip->tsl2x7x_config[TSL2X7X_ALS_MINTHRESHHI] =
> +		(chip->tsl2x7x_settings.als_thresh_low>>  8)&  0xFF;
> +	chip->tsl2x7x_config[TSL2X7X_ALS_MAXTHRESHLO] =
> +		(chip->tsl2x7x_settings.als_thresh_high)&  0xFF;
> +	chip->tsl2x7x_config[TSL2X7X_ALS_MAXTHRESHHI] =
> +		(chip->tsl2x7x_settings.als_thresh_high>>  8)&  0xFF;
> +	chip->tsl2x7x_config[TSL2X7X_PERSISTENCE] =
> +		chip->tsl2x7x_settings.als_persistence;
> +
> +	chip->tsl2x7x_config[TSL2X7X_PRX_COUNT] =
> +			chip->tsl2x7x_settings.prox_pulse_count;
> +	chip->tsl2x7x_config[TSL2X7X_PRX_MINTHRESHLO] =
> +	chip->tsl2x7x_settings.prox_thres_low;
> +	chip->tsl2x7x_config[TSL2X7X_PRX_MAXTHRESHLO] =
> +			chip->tsl2x7x_settings.prox_thres_high;
> +
> +	/* and make sure we're not already on */
> +	if (chip->tsl2x7x_chip_status == TSL2X7X_CHIP_WORKING) {
> +		/* if forcing a register update - turn off, then on */
> +		dev_info(&chip->client->dev, "device is already enabled\n");
> +		return -EINVAL;
> +	}
> +
> +	/* determine als integration regster */
> +	als_count = (chip->tsl2x7x_settings.als_time * 100 + 135) / 270;
> +	if (als_count == 0)
> +		als_count = 1; /* ensure at least one cycle */
> +
> +	/* convert back to time (encompasses overrides) */
> +	als_time = (als_count * 27 + 5) / 10;
> +	chip->tsl2x7x_config[TSL2X7X_ALS_TIME] = 256 - als_count;
> +
> +	/* Set the gain based on tsl2x7x_settings struct */
> +	chip->tsl2x7x_config[TSL2X7X_GAIN] =
> +			(chip->tsl2x7x_settings.als_gain | (mA100 | DIODE1)
> +				| ((chip->tsl2x7x_settings.prox_gain)<<  2));
> +
> +	/* set chip struct re scaling and saturation */
> +	chip->als_saturation = als_count * 922; /* 90% of full scale */
> +	chip->als_time_scale = (als_time + 25) / 50;
> +
> +	/* TSL2X7X Specific power-on / adc enable sequence
> +	 * Power on the device 1st. */
> +	utmp = TSL2X7X_CNTL_PWR_ON;
> +	ret = i2c_smbus_write_byte_data(chip->client,
> +		TSL2X7X_CMD_REG | TSL2X7X_CNTRL, utmp);
> +	if (ret<  0) {
> +		dev_err(&chip->client->dev, "tsl2x7x_chip_on failed on CNTRL reg.\n");
> +		return -1;
> +	}
> +
> +	/* Use the following shadow copy for our delay before enabling ADC.
> +	 * Write all the registers. */
> +	for (i = 0, dev_reg = chip->tsl2x7x_config; i<  TSL2X7X_REG_MAX; i++) {
> +		ret = i2c_smbus_write_byte_data(chip->client,
> +				TSL2X7X_CMD_REG + i, *dev_reg++);
> +		if (ret<  0) {
> +			dev_err(&chip->client->dev,
> +			"tsl2x7x_chip_on failed on write to reg %d.\n", i);
> +			return ret;
> +		}
> +	}
> +
> +	udelay(3000);	/* Power-on settling time */
> +
> +	/* NOW enable the ADC
> +	 * initialize the desired mode of operation */
> +	utmp = TSL2X7X_CNTL_PWR_ON | TSL2X7X_CNTL_ADC_ENBL | CNTL_PROX_DET_ENBL;
> +	ret = i2c_smbus_write_byte_data(chip->client,
> +			TSL2X7X_CMD_REG | TSL2X7X_CNTRL, utmp);
> +	if (ret<  0) {
> +		dev_err(&chip->client->dev, "tsl2x7x_chip_on failed on 2nd CTRL reg.\n");
> +		return ret;
> +		}
> +
> +	chip->tsl2x7x_chip_status = TSL2X7X_CHIP_WORKING;
> +
> +	if (chip->tsl2x7x_settings.interrupts_en != 0) {
> +		dev_info(&chip->client->dev, "Setting Up Interrupt(s)\n");
> +		/* first time interrupt */
> +		chip->init_done = 0;
> +
> +
> +	reg_val = TSL2X7X_CNTL_PWR_ON;
> +
> +	if (chip->tsl2x7x_settings.interrupts_en == 0x10)
> +		reg_val |= CNTL_ADC_ENBL;
> +
> +	if (chip->tsl2x7x_settings.interrupts_en == 0x20)
> +		reg_val |= CNTL_PROX_DET_ENBL;
> +
> +	if (chip->tsl2x7x_settings.interrupts_en == 0x30)
> +		reg_val |= (CNTL_ADC_ENBL | CNTL_PROX_DET_ENBL);
> +
> +	reg_val |= chip->tsl2x7x_settings.interrupts_en;
> +
> +	ret = i2c_smbus_write_byte_data(chip->client,
> +		(TSL2X7X_CMD_REG | TSL2X7X_CNTRL), reg_val);
> +	if (ret<  0)
> +		dev_err(&chip->client->dev,
> +		"tsl2x7x_i2c_write to device failed in tsl2x7x_IOCTL_INT_SET.\n");
> +
> +	/* Clear out any initial interrupts  */
> +	ret = i2c_smbus_write_byte(chip->client,
> +		TSL2X7X_CMD_REG | TSL2X7X_CMD_SPL_FN |
> +		TSL2X7X_CMD_PROXALS_INTCLR);
> +	if (ret<  0) {
> +		dev_err(&chip->client->dev,
> +			"tsl2x7x_i2c_write_command failed in tsl2x7x_chip_on\n");
> +		return ret;
> +		}
> +	}
> +	return ret;
> +
> +}
> +
> +static int tsl2x7x_chip_off(struct iio_dev *indio_dev)
> +{
> +	int ret;
> +	struct tsl2X7X_chip *chip = iio_priv(indio_dev);
> +
> +	/* turn device off */
> +	chip->tsl2x7x_chip_status = TSL2X7X_CHIP_SUSPENDED;
> +
> +	ret = i2c_smbus_write_byte_data(chip->client,
> +		TSL2X7X_CMD_REG | TSL2X7X_CNTRL, 0x00);
> +
> +	if (chip->pdata&&  chip->pdata->power_off)
> +		chip->pdata->power_off(chip->client);
> +
> +	return ret;
> +}
> +
> +/**
> + * Integer Square Root
> + * We need an integer version since 1st Floating point is not allowed
> + * in driver world, 2nd, cannot count on the devices having a FPU, and
> + * 3rd software FP emulation may be excessive.
It's exactly this sort of thing that supports my argument below that 
this ought to be
in userspace...
> + */
> +static unsigned long tsl2x7x_isqrt(unsigned long x)
> +{
> +	register unsigned long op, res, one;
> +	op = x;
> +	res = 0;
> +
> +	one = 1<<  30;
> +	while (one>  op)
> +		one>>= 2;
> +
> +	while (one != 0) {
> +		if (op>= res + one) {
> +			op -= res + one;
> +			res += one<<  1;
> +		}
> +		res>>= 1;
> +		one>>= 2;
> +	}
> +	return res;
> +}
> +
> +/*
> + * Proximity calibration helper function
> + * runs through a collection of data samples,
> + * sets the min, max, mean, and std dev.
> + */
> +static
> +void tsl2x7x_prox_calculate(u16 *data, int length, struct prox_stat *statP)
> +{
> +	int i;
> +	int min, max, sum, mean;
> +	unsigned long stddev;
> +	int tmp;
> +
> +	if (length == 0)
> +		length = 1;
> +
> +	sum = 0;
> +	min = 0xffff;
> +	max = 0;
> +	for (i = 0; i<  length; i++) {
> +		sum += data[i];
> +		if (data[i]<  min)
> +			min = data[i];
> +		if (data[i]>  max)
> +			max = data[i];
> +	}
> +	mean = sum/length;
> +	statP->min = min;
> +	statP->max = max;
> +	statP->mean = mean;
> +
> +	sum = 0;
> +	for (i = 0; i<  length; i++) {
> +		tmp = data[i]-mean;
> +		sum += tmp * tmp;
> +	}
> +	stddev = tsl2x7x_isqrt((long)sum)/length;
> +	statP->stddev = stddev;
> +
> +}
> +
> +/**
> + * Proximity calibration - collects a number of samples,
> + * calculates a standard deviation based on the samples, and
> + * sets the threshold accordingly.
> + */
I guess you have a demand for this, but generally I'd feel this had more
of a place in userspace than down in the kernel...
> +static void tsl2x7x_prox_cal(struct iio_dev *indio_dev)
> +{
> +	u16 prox_history[MAX_SAMPLES_CAL+1];
> +	int i;
> +	struct prox_stat prox_stat_data[2];
> +	struct prox_stat *calP;
> +	struct tsl2X7X_chip *chip = iio_priv(indio_dev);
> +	u8 tmp_irq_settings;
> +	u8 current_state = chip->tsl2x7x_chip_status;
> +
> +	if (chip->tsl2x7x_settings.prox_max_samples_cal>  MAX_SAMPLES_CAL) {
> +		dev_err(&chip->client->dev,
> +			"max prox samples cal is too big: %d\n",
> +			chip->tsl2x7x_settings.prox_max_samples_cal);
> +		chip->tsl2x7x_settings.prox_max_samples_cal = MAX_SAMPLES_CAL;
> +	}
> +
> +	/* have to stop to change settings */
> +	tsl2x7x_chip_off(indio_dev);
> +
> +	/* Enable proximity detection save just in case prox not wanted yet*/
> +	tmp_irq_settings = chip->tsl2x7x_settings.interrupts_en;
> +	chip->tsl2x7x_settings.interrupts_en |= CNTL_PROX_INT_ENBL;
> +
> +	/*turn on device if not already on*/
> +	tsl2x7x_chip_on(indio_dev);
> +
> +	/*gather the samples*/
> +	for (i = 0; i<  chip->tsl2x7x_settings.prox_max_samples_cal; i++) {
> +		mdelay(15);
> +		tsl2x7x_prox_poll(indio_dev);
> +		prox_history[i] = chip->prox_cur_info.prox_data;
> +		dev_info(&chip->client->dev, "2 i=%d prox data= %d\n",
> +			i, chip->prox_cur_info.prox_data);
> +
> +	}
> +
> +	tsl2x7x_chip_off(indio_dev);
> +
> +	calP =&prox_stat_data[PROX_STAT_CAL];
> +	tsl2x7x_prox_calculate(prox_history,
> +		chip->tsl2x7x_settings.prox_max_samples_cal, calP);
> +	chip->tsl2x7x_settings.prox_thres_high = (calP->max<<  1) - calP->mean;
> +
> +	dev_info(&chip->client->dev, " cal min=%d mean=%d max=%d\n",
> +		calP->min, calP->mean, calP->max);
> +	dev_info(&chip->client->dev,
> +		"%s proximity threshold set to %d\n",
> +		chip->client->name, chip->tsl2x7x_settings.prox_thres_high);
> +
> +	/* back to the way they were */
> +	chip->tsl2x7x_settings.interrupts_en = tmp_irq_settings;
> +	if (current_state == TSL2X7X_CHIP_WORKING)
> +		tsl2x7x_chip_on(indio_dev);
> +}
> +
> +/* ---------- Sysfs Interface Functions ------------- */
Don't bother with the structure comments. It's readily apparent and they
have a nasty habit of not being true after a year or two.
> +
> +
> +static ssize_t tsl2x7x_power_state_show(struct device *dev,
> +	struct device_attribute *attr, char *buf)
> +{
> +	struct iio_dev *dev_info = dev_get_drvdata(dev);
> +	struct tsl2X7X_chip *chip = iio_priv(dev_info);
> +
> +	return snprintf(buf, PAGE_SIZE, "%d\n", chip->tsl2x7x_chip_status);
> +}
> +
> +static ssize_t tsl2x7x_power_state_store(struct device *dev,
> +	struct device_attribute *attr, const char *buf, size_t len)
> +{
> +	struct iio_dev *dev_info = dev_get_drvdata(dev);
> +	unsigned long value;
> +
> +	if (kstrtoul(buf, 0,&value))
> +		return -EINVAL;
strtobool
> +
> +	if (value == 0)
> +		tsl2x7x_chip_off(dev_info);
> +	else
> +		tsl2x7x_chip_on(dev_info);
> +
> +	return len;
> +}
> +
> +static ssize_t tsl2x7x_proximity_detect_show(struct device *dev,
> +	struct device_attribute *attr, char *buf)
> +{
> +	struct iio_dev *dev_info = dev_get_drvdata(dev);
> +	struct tsl2X7X_chip *chip = iio_priv(dev_info);
> +
> +	tsl2x7x_prox_poll(dev_info);
> +
> +	return snprintf(buf, PAGE_SIZE, "%d\n",
> +			chip->prox_cur_info.prox_event);
> +}
> +
> +static ssize_t tsl2x7x_gain_show(struct device *dev,
> +	struct device_attribute *attr, char *buf)
> +{
> +	struct iio_dev *dev_info = dev_get_drvdata(dev);
> +	struct tsl2X7X_chip *chip = iio_priv(dev_info);
> +
> +	return snprintf(buf, PAGE_SIZE, "%d\n",
> +		tsl2X7X_als_gainadj[chip->tsl2x7x_settings.als_gain].ch0);
> +}
> +
> +static ssize_t tsl2x7x_gain_store(struct device *dev,
> +	struct device_attribute *attr, const char *buf, size_t len)
> +{
> +	struct iio_dev *dev_info = dev_get_drvdata(dev);
> +	struct tsl2X7X_chip *chip = iio_priv(dev_info);
> +	unsigned long value;
> +	if (kstrtoul(buf, 0,&value))
> +		return -EINVAL;
> +
> +	switch (value) {
> +	case 1:
> +		chip->tsl2x7x_settings.als_gain = 0;
> +		break;
> +	case 8:
> +		chip->tsl2x7x_settings.als_gain = 1;
> +		break;
> +	case 16:
> +		chip->tsl2x7x_settings.als_gain = 2;
> +		break;
> +	case 120:
> +		chip->tsl2x7x_settings.als_gain = 3;
> +		break;
It's unlikely but you probably want to verify that 120 is only used
for parts where it is valid.  (for consistency sake).
> +	case 128:
> +		chip->tsl2x7x_settings.als_gain = 3;
> +		break;
> +
> +	default:
> +		dev_err(dev,
> +			"Invalid Gain Index\n");
> +		return -EINVAL;
> +	}
> +
> +	return len;
> +}
> +
> +static ssize_t tsl2x7x_gain_available_show(struct device *dev,
> +	struct device_attribute *attr, char *buf)
> +{
> +	struct iio_dev *dev_info = dev_get_drvdata(dev);
> +	struct tsl2X7X_chip *chip = iio_priv(dev_info);
> +
> +	if (strncmp(chip->client->name, "tsl2772", 7) == 0)
> +		return snprintf(buf, PAGE_SIZE, "%s\n", "1 8 16 128");
> +	else
> +		return snprintf(buf, PAGE_SIZE, "%s\n", "1 8 16 120");
> +}
> +
> +static ssize_t tsl2x7x_prox_gain_show(struct device *dev,
> +	struct device_attribute *attr, char *buf)
> +{
> +	struct iio_dev *dev_info = dev_get_drvdata(dev);
> +	struct tsl2X7X_chip *chip = iio_priv(dev_info);
> +
> +	return snprintf(buf, PAGE_SIZE, "%d\n",
> +			(1<<  chip->tsl2x7x_settings.prox_gain));
> +}
> +
> +static ssize_t tsl2x7x_prox_gain_store(struct device *dev,
> +	struct device_attribute *attr, const char *buf, size_t len)
> +{
> +	struct iio_dev *dev_info = dev_get_drvdata(dev);
> +	struct tsl2X7X_chip *chip = iio_priv(dev_info);
> +	unsigned long value;
> +	if (kstrtoul(buf, 0,&value))
> +		return -EINVAL;
> +
> +	switch (value) {
> +	case 1:
maybe use the relevant log2? Then you just need to check if it's too big.
> +		chip->tsl2x7x_settings.prox_gain = 0;
> +		break;
> +	case 2:
> +		chip->tsl2x7x_settings.prox_gain = 1;
> +		break;
> +	case 4:
> +		chip->tsl2x7x_settings.prox_gain = 2;
> +		break;
> +	case 8:
> +		chip->tsl2x7x_settings.prox_gain = 3;
> +		break;
> +	default:
> +		dev_err(dev,
> +			"Invalid Prox Gain Index\n");
> +		return -EINVAL;
> +	}
> +
> +	return len;
> +}
> +
> +static ssize_t tsl2x7x_prox_gain_available_show(struct device *dev,
> +	struct device_attribute *attr, char *buf)
> +{
> +		return snprintf(buf, PAGE_SIZE, "%s\n", "1 2 4 8");
> +}
> +
> +static ssize_t tsl2x7x_als_time_show(struct device *dev,
> +	struct device_attribute *attr, char *buf)
> +{
> +	struct iio_dev *dev_info = dev_get_drvdata(dev);
> +	struct tsl2X7X_chip *chip = iio_priv(dev_info);
> +
> +	return snprintf(buf, PAGE_SIZE, "%d\n",
> +			chip->tsl2x7x_settings.als_time);
> +}
> +
> +static ssize_t tsl2x7x_als_time_store(struct device *dev,
> +	struct device_attribute *attr, const char *buf, size_t len)
> +{
> +	struct iio_dev *dev_info = dev_get_drvdata(dev);
> +	struct tsl2X7X_chip *chip = iio_priv(dev_info);
> +	unsigned long value;
> +
> +	if (kstrtoul(buf, 0,&value))
> +		return -EINVAL;
> +
> +	if ((value<  50) || (value>  650))
> +		return -EINVAL;
> +
> +	if (value % 50)
> +		return -EINVAL;
> +
> +	 chip->tsl2x7x_settings.als_time = value;
> +
> +	return len;
> +}
> +
> +static ssize_t tsl2x7x_als_time_available_show(struct device *dev,
> +	struct device_attribute *attr, char *buf)
> +{
> +	return snprintf(buf, PAGE_SIZE, "%s\n",
> +		"50 100 150 200 250 300 350 400 450 500 550 600 650");
> +}
> +
> +static ssize_t tsl2x7x_als_trim_show(struct device *dev,
> +	struct device_attribute *attr, char *buf)
> +{
> +	struct iio_dev *dev_info = dev_get_drvdata(dev);
> +	struct tsl2X7X_chip *chip = iio_priv(dev_info);
> +
> +	return snprintf(buf, PAGE_SIZE, "%d\n",
> +			chip->tsl2x7x_settings.als_gain_trim);
> +}
> +
> +static ssize_t tsl2x7x_als_trim_store(struct device *dev,
> +	struct device_attribute *attr, const char *buf, size_t len)
> +{
> +	struct iio_dev *dev_info = dev_get_drvdata(dev);
> +	struct tsl2X7X_chip *chip = iio_priv(dev_info);
> +	unsigned long value;
> +
> +	if (kstrtoul(buf, 0,&value))
> +		return -EINVAL;
> +
> +	if (value)
I'd have thought 0 was a valid gain_trim?
> +		chip->tsl2x7x_settings.als_gain_trim = value;
> +
> +	return len;
> +}
> +
> +static ssize_t tsl2x7x_als_cal_target_show(struct device *dev,
> +	struct device_attribute *attr, char *buf)
> +{
> +	struct iio_dev *dev_info = dev_get_drvdata(dev);
> +	struct tsl2X7X_chip *chip = iio_priv(dev_info);
> +
> +	return snprintf(buf, PAGE_SIZE, "%d\n",
> +			chip->tsl2x7x_settings.als_cal_target);
> +}
> +
> +static ssize_t tsl2x7x_als_cal_target_store(struct device *dev,
> +	struct device_attribute *attr, const char *buf, size_t len)
> +{
> +	struct iio_dev *dev_info = dev_get_drvdata(dev);
> +	struct tsl2X7X_chip *chip = iio_priv(dev_info);
> +	unsigned long value;
> +
> +	if (kstrtoul(buf, 0,&value))
> +		return -EINVAL;
> +
> +	if (value)
> +		chip->tsl2x7x_settings.als_cal_target = value;
> +
> +	return len;
> +}
> +
> +static ssize_t tsl2x7x_interrupts_en_show(struct device *dev,
> +	struct device_attribute *attr, char *buf)
> +{
> +	struct iio_dev *dev_info = dev_get_drvdata(dev);
> +	struct tsl2X7X_chip *chip = iio_priv(dev_info);
> +
> +	if (chip->tsl2x7x_settings.interrupts_en&  0x10)
> +		return snprintf(buf, PAGE_SIZE, "%d\n", 1);
> +	else
> +		return snprintf(buf, PAGE_SIZE, "%d\n", 0);
snprintf(buf, PAGE_SIZE, "%d\n", !!(chip->tsl2x7x_settings.interrupts_en 
& 0x10));
> +}
> +
> +static ssize_t tsl2x7x_interrupts_en_store(struct device *dev,
> +	struct device_attribute *attr, const char *buf, size_t len)
> +{
> +	struct iio_dev *dev_info = dev_get_drvdata(dev);
> +	struct tsl2X7X_chip *chip = iio_priv(dev_info);
> +	unsigned long value;
> +
> +	if (kstrtoul(buf, 0,&value))
> +		return -EINVAL;
> +
strotobool (and use the iio_chan_spec and relevant callbacks please.)
> +	if (value>  1)
> +		return -EINVAL;
> +	if (value)
> +		chip->tsl2x7x_settings.interrupts_en |= 0x10;
> +	else
> +		chip->tsl2x7x_settings.interrupts_en&= 0x20;
> +
> +	return len;
> +}
> +
> +static ssize_t tsl2x7x_prox_interrupt_show(struct device *dev,
> +	struct device_attribute *attr, char *buf)
> +{
> +	struct iio_dev *dev_info = dev_get_drvdata(dev);
> +	struct tsl2X7X_chip *chip = iio_priv(dev_info);
> +
> +	if (chip->tsl2x7x_settings.interrupts_en&  0x20)
> +		return snprintf(buf, PAGE_SIZE, "%d\n", 1);
> +	else
> +		return snprintf(buf, PAGE_SIZE, "%d\n", 0);
> +}
> +
> +static ssize_t tsl2x7x_prox_interrupt_store(struct device *dev,
> +	struct device_attribute *attr, const char *buf, size_t len)
> +{
> +	struct iio_dev *dev_info = dev_get_drvdata(dev);
> +	struct tsl2X7X_chip *chip = iio_priv(dev_info);
> +	unsigned long value;
> +
> +	if (kstrtoul(buf, 0,&value))
> +		return -EINVAL;
> +
> +	if (value>  1)
> +		return -EINVAL;
> +	if (value)
> +		chip->tsl2x7x_settings.interrupts_en |= 0x20;
> +	else
> +		chip->tsl2x7x_settings.interrupts_en&= 0x10;
> +
> +	return len;
> +}
> +
> +static ssize_t tsl2x7x_als_thresh_low_show(struct device *dev,
> +	struct device_attribute *attr, char *buf)
> +{
> +	struct iio_dev *dev_info = dev_get_drvdata(dev);
> +	struct tsl2X7X_chip *chip = iio_priv(dev_info);
> +
> +	return snprintf(buf, PAGE_SIZE, "%d\n",
> +			chip->tsl2x7x_settings.als_thresh_low);
> +}
> +
> +static ssize_t tsl2x7x_als_thresh_low_store(struct device *dev,
> +	struct device_attribute *attr, const char *buf, size_t len)
> +{
> +	struct iio_dev *dev_info = dev_get_drvdata(dev);
> +	struct tsl2X7X_chip *chip = iio_priv(dev_info);
> +	unsigned long value;
> +
> +	if (kstrtoul(buf, 0,&value))
> +		return -EINVAL;
> +
> +	chip->tsl2x7x_settings.als_thresh_low = value;
> +
> +	return len;
> +}
> +
> +static ssize_t tsl2x7x_als_thresh_high_show(struct device *dev,
> +	struct device_attribute *attr, char *buf)
> +{
> +	struct iio_dev *dev_info = dev_get_drvdata(dev);
> +	struct tsl2X7X_chip *chip = iio_priv(dev_info);
> +
> +	return snprintf(buf, PAGE_SIZE, "%d\n",
> +			chip->tsl2x7x_settings.als_thresh_high);
> +}
> +
> +static ssize_t tsl2x7x_als_thresh_high_store(struct device *dev,
> +	struct device_attribute *attr, const char *buf, size_t len)
> +{
> +	struct iio_dev *dev_info = dev_get_drvdata(dev);
> +	struct tsl2X7X_chip *chip = iio_priv(dev_info);
> +	unsigned long value;
> +
> +	if (kstrtoul(buf, 0,&value))
> +		return -EINVAL;
> +
> +	chip->tsl2x7x_settings.als_thresh_high = value;
> +
> +	return len;
> +}
> +
> +static ssize_t tsl2x7x_prox_thresh_low_show(struct device *dev,
> +	struct device_attribute *attr, char *buf)
> +{
> +	struct iio_dev *dev_info = dev_get_drvdata(dev);
> +	struct tsl2X7X_chip *chip = iio_priv(dev_info);
> +
> +	return snprintf(buf, PAGE_SIZE, "%d\n",
> +			chip->tsl2x7x_settings.prox_thres_low);
> +}
> +
> +static ssize_t tsl2x7x_prox_thresh_low_store(struct device *dev,
> +	struct device_attribute *attr, const char *buf, size_t len)
> +{
> +	struct iio_dev *dev_info = dev_get_drvdata(dev);
> +	struct tsl2X7X_chip *chip = iio_priv(dev_info);
> +	unsigned long value;
> +
> +	if (kstrtoul(buf, 0,&value))
> +		return -EINVAL;
> +
> +	chip->tsl2x7x_settings.prox_thres_low = value;
> +
> +	return len;
> +}
> +
> +static ssize_t tsl2x7x_prox_thresh_high_show(struct device *dev,
> +	struct device_attribute *attr, char *buf)
> +{
> +	struct iio_dev *dev_info = dev_get_drvdata(dev);
> +	struct tsl2X7X_chip *chip = iio_priv(dev_info);
> +
> +	return snprintf(buf, PAGE_SIZE, "%d\n",
> +			chip->tsl2x7x_settings.prox_thres_high);
> +}
> +
> +static ssize_t tsl2x7x_prox_thresh_high_store(struct device *dev,
> +	struct device_attribute *attr, const char *buf, size_t len)
> +{
> +	struct iio_dev *dev_info = dev_get_drvdata(dev);
> +	struct tsl2X7X_chip *chip = iio_priv(dev_info);
> +	unsigned long value;
> +
> +	if (kstrtoul(buf, 0,&value))
> +		return -EINVAL;
> +
> +	chip->tsl2x7x_settings.prox_thres_high = value;
> +
> +	return len;
> +}
> +
> +static ssize_t tsl2x7x_prox_data_show(struct device *dev,
> +	struct device_attribute *attr, char *buf)
> +{
> +	struct iio_dev *dev_info = dev_get_drvdata(dev);
> +	struct tsl2X7X_chip *chip = iio_priv(dev_info);
> +	tsl2x7x_prox_poll(dev_info);
> +
> +	return snprintf(buf, PAGE_SIZE, "%d\n",
> +			chip->prox_cur_info.prox_data);
> +}
> +
> +/* sampling_frequency AKA persistence in data sheet */
> +static ssize_t tsl2x7x_als_persistence_show(struct device *dev,
> +	struct device_attribute *attr, char *buf)
> +{
> +	struct iio_dev *dev_info = dev_get_drvdata(dev);
> +	struct tsl2X7X_chip *chip = iio_priv(dev_info);
> +
> +	return snprintf(buf, PAGE_SIZE, "0x%02X\n",
> +			chip->tsl2x7x_settings.als_persistence);
> +}
> +
> +static ssize_t tsl2x7x_als_persistence_store(struct device *dev,
> +	struct device_attribute *attr, const char *buf, size_t len)
> +{
> +	struct iio_dev *dev_info = dev_get_drvdata(dev);
> +	struct tsl2X7X_chip *chip = iio_priv(dev_info);
> +	unsigned long value;
> +
> +	if (kstrtoul(buf, 0,&value))
> +		return -EINVAL;
> +
> +	chip->tsl2x7x_settings.als_persistence = value;
> +
> +	return len;
> +}
> +
> +static
> +ssize_t tsl2x7x_als_persistence_available_show(struct device *dev,
> +	struct device_attribute *attr, char *buf)
> +{
> +	return snprintf(buf, PAGE_SIZE, "0x00 - 0xFF (0 - 255)\n");
> +}
> +
> +static
> +ssize_t tsl2x7x_lux_show(struct device *dev, struct device_attribute *attr,
> +	char *buf)
> +{
> +	struct iio_dev *dev_info = dev_get_drvdata(dev);
> +	int lux;
> +
> +	lux = tsl2x7x_get_lux(dev_info);
> +
> +	return snprintf(buf, PAGE_SIZE, "%d\n", lux);
> +}
> +
> +static
> +ssize_t tsl2x7x_adc_show(struct device *dev, struct device_attribute *attr,
> +	char *buf)
> +{
> +	struct iio_dev *dev_info = dev_get_drvdata(dev);
> +	struct tsl2X7X_chip *chip = iio_priv(dev_info);
> +
> +	tsl2x7x_get_lux(dev_info);
> +
> +	return snprintf(buf, PAGE_SIZE, "0x%08x\n",
> +			((chip->als_cur_info.als_ch0<<  16) |
> +					chip->als_cur_info.als_ch1));
Your outputing in hex? Please don't and please do this through an 
iio_chan_spec
structure and read_raw callback.
> +}
> +
> +static ssize_t tsl2x7x_do_calibrate(struct device *dev,
> +	struct device_attribute *attr, const char *buf, size_t len)
> +{
> +	struct iio_dev *dev_info = dev_get_drvdata(dev);
> +	unsigned long value;
> +
> +	if (kstrtoul(buf, 0,&value))
> +		return -EINVAL;
strtobool?
> +
> +	if (value == 1)
> +		tsl2x7x_als_calibrate(dev_info);
> +
> +	return len;
> +}
> +
> +static ssize_t tsl2x7x_luxtable_show(struct device *dev,
> +	struct device_attribute *attr, char *buf)
> +{
> +	struct iio_dev *dev_info = dev_get_drvdata(dev);
> +	struct tsl2X7X_chip *chip = iio_priv(dev_info);
> +	int i;
> +	int offset = 0;
> +
> +	i = 0;
> +	while (i<  (MAX_TABLE_SIZE * 3)) {
> +		offset += snprintf(buf + offset, PAGE_SIZE, "%d,%d,%d,",
> +			chip->tsl2x7x_device_lux[i].ratio,
> +			chip->tsl2x7x_device_lux[i].ch0,
> +			chip->tsl2x7x_device_lux[i].ch1);
> +		if (chip->tsl2x7x_device_lux[i].ratio == 0) {
> +			/* We just printed the first "0" entry.
> +			 * Now get rid of the extra "," and break. */
> +			offset--;
> +			break;
> +		}
> +		i++;
> +	}
> +
> +	offset += snprintf(buf + offset, PAGE_SIZE, "\n");
> +	return offset;
> +}
> +
> +static ssize_t tsl2x7x_luxtable_store(struct device *dev,
> +	struct device_attribute *attr, const char *buf, size_t len)
> +{
> +	struct iio_dev *dev_info = dev_get_drvdata(dev);
> +	struct tsl2X7X_chip *chip = iio_priv(dev_info);
> +	int value[ARRAY_SIZE(chip->tsl2x7x_device_lux)*3 + 1];
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
> +	if ((n % 3) || n<  6 ||
> +			n>  ((ARRAY_SIZE(chip->tsl2x7x_device_lux) - 1) * 3)) {
> +		dev_info(dev, "LUX TABLE INPUT ERROR 1 Value[0]=%d\n", n);
> +		return -EINVAL;
> +	}
> +
> +	if ((value[(n - 2)] | value[(n - 1)] | value[n]) != 0) {
> +		dev_info(dev, "LUX TABLE INPUT ERROR 2 Value[0]=%d\n", n);
> +		return -EINVAL;
> +	}
> +
> +	if (chip->tsl2x7x_chip_status == TSL2X7X_CHIP_WORKING)
> +		tsl2x7x_chip_off(dev_info);
> +
> +	/* Zero out the table */
> +	memset(chip->tsl2x7x_device_lux, 0, sizeof(chip->tsl2x7x_device_lux));
> +	memcpy(chip->tsl2x7x_device_lux,&value[1], (value[0] * 4));
> +
> +	return len;
> +}
> +
> +static ssize_t tsl2x7x_do_prox_calibrate(struct device *dev,
> +	struct device_attribute *attr, const char *buf, size_t len)
> +{
> +	struct iio_dev *dev_info = dev_get_drvdata(dev);
> +	unsigned long value;
> +
> +	if (kstrtoul(buf, 0,&value))
> +		return -EINVAL;
strtobool probably?
> +
> +	if (value == 1)
> +		tsl2x7x_prox_cal(dev_info);
> +
> +	return len;
> +}
> +
> +static DEVICE_ATTR(power_state, S_IRUGO | S_IWUSR,
> +		tsl2x7x_power_state_show, tsl2x7x_power_state_store);
> +
> +static DEVICE_ATTR(proximity_raw, S_IRUGO,
> +		tsl2x7x_proximity_detect_show, NULL);
> +
> +static DEVICE_ATTR(intensity_infrared_raw, S_IRUGO,
> +		tsl2x7x_prox_data_show, NULL);
> +
> +
> +static DEVICE_ATTR(proximity_calibscale, S_IRUGO | S_IWUSR,
> +		tsl2x7x_prox_gain_show, tsl2x7x_prox_gain_store);
> +static DEVICE_ATTR(proximity_calibscale_available, S_IRUGO,
> +		tsl2x7x_prox_gain_available_show, NULL);
> +
> +static DEVICE_ATTR(illuminance0_calibscale, S_IRUGO | S_IWUSR,
> +		tsl2x7x_gain_show, tsl2x7x_gain_store);
> +static DEVICE_ATTR(illuminance0_calibscale_available, S_IRUGO,
> +		tsl2x7x_gain_available_show, NULL);
> +
> +static DEVICE_ATTR(illuminance0_integration_time, S_IRUGO | S_IWUSR,
> +		tsl2x7x_als_time_show, tsl2x7x_als_time_store);
> +static DEVICE_ATTR(illuminance0_integration_time_available, S_IRUGO,
> +		tsl2x7x_als_time_available_show, NULL);
> +
> +static DEVICE_ATTR(illuminance0_calibbias, S_IRUGO | S_IWUSR,
> +		tsl2x7x_als_trim_show, tsl2x7x_als_trim_store);
> +
> +static DEVICE_ATTR(illuminance0_input_target, S_IRUGO | S_IWUSR,
> +		tsl2x7x_als_cal_target_show, tsl2x7x_als_cal_target_store);
> +
> +static DEVICE_ATTR(illuminance0_both_raw, S_IRUGO, tsl2x7x_adc_show,
> +		NULL);
> +
> +static DEVICE_ATTR(illuminance0_input, S_IRUGO, tsl2x7x_lux_show,
> +		NULL);
> +static DEVICE_ATTR(illuminance0_calibrate, S_IWUSR, NULL,
> +		tsl2x7x_do_calibrate);
> +static DEVICE_ATTR(proximity_calibrate, S_IWUSR, NULL,
> +		tsl2x7x_do_prox_calibrate);
> +
> +static DEVICE_ATTR(illuminance0_lux_table, S_IRUGO | S_IWUSR,
> +		tsl2x7x_luxtable_show, tsl2x7x_luxtable_store);
> +
> +static DEVICE_ATTR(illuminance0_thresh_falling_value, S_IRUGO | S_IWUSR,
> +		tsl2x7x_als_thresh_low_show, tsl2x7x_als_thresh_low_store);
> +
> +static DEVICE_ATTR(illuminance0_thresh_rising_value, S_IRUGO | S_IWUSR,
> +		tsl2x7x_als_thresh_high_show, tsl2x7x_als_thresh_high_store);
> +
> +static DEVICE_ATTR(sampling_frequency, S_IRUGO | S_IWUSR,
> +		tsl2x7x_als_persistence_show, tsl2x7x_als_persistence_store);
> +
> +static DEVICE_ATTR(sampling_frequency_available, S_IRUGO,
> +		tsl2x7x_als_persistence_available_show, NULL);
> +
> +static DEVICE_ATTR(proximity_thresh_rising_value, S_IRUGO | S_IWUSR,
> +		tsl2x7x_prox_thresh_high_show, tsl2x7x_prox_thresh_high_store);
> +
> +static DEVICE_ATTR(proximity_thresh_falling_value, S_IRUGO | S_IWUSR,
> +		tsl2x7x_prox_thresh_low_show, tsl2x7x_prox_thresh_low_store);
> +
A lot of what we having in here is standard and should be done via a 
iio_chan_spec
definition.  That'll cover calibscal, calibbias, input, raw, 
thresh_rising_value, thresh_falling_value
(which incidentally should be in the event attributes).
That leaves us with
power_state - ideally not here but handled via a kernel wide control (it 
gets suggested,
everyone agrees it's a good idea and no one implements it...) but such 
is life.
calibscale_available - fine
integration_time - Propose adding this to the iio_chan_spec via info_mask.
integration_time_available - fine.
input_target -> target_input but otherwise fine.
calibrate -> fine
lux_table -> fine
sampling_frequency, frequency_available fine.

Just for reference, we really need to come up with a way of handing 
'available' within
the iio_chan_spec structures and the same for sampling frequency. Not 
your problem
but  if I say it often enough hopefully someone else will do it ;)
> +static struct attribute *tsl2571_device_attrs[] = {
> +	&dev_attr_power_state.attr,
> +	&dev_attr_illuminance0_calibscale.attr,
> +	&dev_attr_illuminance0_calibscale_available.attr,
> +	&dev_attr_illuminance0_integration_time.attr,
> +	&dev_attr_illuminance0_integration_time_available.attr,
> +	&dev_attr_illuminance0_calibbias.attr,
> +	&dev_attr_illuminance0_input_target.attr,
> +	&dev_attr_illuminance0_both_raw.attr,
> +	&dev_attr_illuminance0_input.attr,
> +	&dev_attr_illuminance0_calibrate.attr,
> +	&dev_attr_illuminance0_lux_table.attr,
> +	&dev_attr_illuminance0_thresh_falling_value.attr,
> +	&dev_attr_illuminance0_thresh_rising_value.attr,
> +	&dev_attr_sampling_frequency.attr,
> +	&dev_attr_sampling_frequency_available.attr,
> +	NULL
> +};
> +
> +static struct attribute *tsl2671_device_attrs[] = {
> +	&dev_attr_power_state.attr,
> +	&dev_attr_proximity_raw.attr,
> +	&dev_attr_intensity_infrared_raw.attr,
> +	&dev_attr_sampling_frequency.attr,
> +	&dev_attr_sampling_frequency_available.attr,
> +	&dev_attr_proximity_thresh_rising_value.attr,
> +	&dev_attr_proximity_thresh_falling_value.attr,
> +	&dev_attr_proximity_calibrate.attr,
> +	NULL
> +};
> +
> +static struct attribute *tsl2771_device_attrs[] = {
> +	&dev_attr_power_state.attr,
> +	&dev_attr_proximity_raw.attr,
> +	&dev_attr_intensity_infrared_raw.attr,
> +	&dev_attr_illuminance0_calibscale.attr,
> +	&dev_attr_illuminance0_calibscale_available.attr,
> +	&dev_attr_illuminance0_integration_time.attr,
> +	&dev_attr_illuminance0_integration_time_available.attr,
> +	&dev_attr_illuminance0_calibbias.attr,
> +	&dev_attr_illuminance0_input_target.attr,
> +	&dev_attr_illuminance0_both_raw.attr,
> +	&dev_attr_illuminance0_input.attr,
> +	&dev_attr_illuminance0_calibrate.attr,
> +	&dev_attr_illuminance0_lux_table.attr,
> +	&dev_attr_illuminance0_thresh_falling_value.attr,
> +	&dev_attr_illuminance0_thresh_rising_value.attr,
> +	&dev_attr_sampling_frequency.attr,
> +	&dev_attr_sampling_frequency_available.attr,
> +	&dev_attr_proximity_thresh_rising_value.attr,
> +	&dev_attr_proximity_thresh_falling_value.attr,
> +	&dev_attr_proximity_calibrate.attr,
> +	NULL
> +};
> +
> +static struct attribute *tsl2572_device_attrs[] = {
> +	&dev_attr_power_state.attr,
> +	&dev_attr_illuminance0_calibscale.attr,
> +	&dev_attr_illuminance0_calibscale_available.attr,
> +	&dev_attr_illuminance0_integration_time.attr,
> +	&dev_attr_illuminance0_integration_time_available.attr,
> +	&dev_attr_illuminance0_calibbias.attr,
> +	&dev_attr_illuminance0_input_target.attr,
> +	&dev_attr_illuminance0_both_raw.attr,
> +	&dev_attr_illuminance0_input.attr,
> +	&dev_attr_illuminance0_calibrate.attr,
> +	&dev_attr_illuminance0_lux_table.attr,
> +	&dev_attr_illuminance0_thresh_falling_value.attr,
> +	&dev_attr_illuminance0_thresh_rising_value.attr,
> +	&dev_attr_sampling_frequency.attr,
> +	&dev_attr_sampling_frequency_available.attr,
> +	NULL
> +};
> +
> +static struct attribute *tsl2672_device_attrs[] = {
> +	&dev_attr_power_state.attr,
> +	&dev_attr_proximity_raw.attr,
> +	&dev_attr_intensity_infrared_raw.attr,
> +	&dev_attr_proximity_calibscale.attr,
> +	&dev_attr_sampling_frequency.attr,
> +	&dev_attr_sampling_frequency_available.attr,
> +	&dev_attr_proximity_thresh_rising_value.attr,
> +	&dev_attr_proximity_thresh_falling_value.attr,
> +	&dev_attr_proximity_calibrate.attr,
> +	NULL
> +};
> +
Indent the same for all of these.
> +static struct attribute *tsl2772_device_attrs[] = {
> +		&dev_attr_power_state.attr,
> +		&dev_attr_proximity_raw.attr,
> +		&dev_attr_proximity_calibscale.attr,
> +		&dev_attr_intensity_infrared_raw.attr,
> +		&dev_attr_illuminance0_calibscale.attr,
> +		&dev_attr_illuminance0_calibscale_available.attr,
> +		&dev_attr_illuminance0_integration_time.attr,
> +		&dev_attr_illuminance0_integration_time_available.attr,
> +		&dev_attr_illuminance0_calibbias.attr,
> +		&dev_attr_illuminance0_input_target.attr,
> +		&dev_attr_illuminance0_both_raw.attr,
> +		&dev_attr_illuminance0_input.attr,
> +		&dev_attr_illuminance0_calibrate.attr,
> +		&dev_attr_illuminance0_lux_table.attr,
> +		&dev_attr_illuminance0_thresh_falling_value.attr,
> +		&dev_attr_illuminance0_thresh_rising_value.attr,
> +		&dev_attr_sampling_frequency.attr,
> +		&dev_attr_sampling_frequency_available.attr,
> +		&dev_attr_proximity_thresh_rising_value.attr,
> +		&dev_attr_proximity_thresh_falling_value.attr,
> +		&dev_attr_proximity_calibrate.attr,
> +		&dev_attr_proximity_calibscale_available.attr,
> +		NULL
> +};
> +
> +static struct attribute_group tsl2X7X_dev_attr_group_tbl[] = {
> +	[tsl2571] = {
> +		.attrs = tsl2571_device_attrs,
> +	},
> +	[tsl2671] = {
> +		.attrs = tsl2671_device_attrs,
> +	},
> +	[tmd2671] = {
> +		.attrs = tsl2671_device_attrs,
> +	},
> +	[tsl2771] = {
> +		.attrs = tsl2771_device_attrs,
> +	},
> +	[tmd2771] = {
> +		.attrs = tsl2771_device_attrs,
> +	},
> +	[tsl2572] = {
> +		.attrs = tsl2572_device_attrs,
> +	},
> +	[tsl2672] = {
> +		.attrs = tsl2672_device_attrs,
> +	},
> +	[tmd2672] = {
> +		.attrs = tsl2672_device_attrs,
> +	},
> +	[tsl2772] = {
> +		.attrs = tsl2772_device_attrs,
> +	},
> +	[tmd2772] = {
> +		.attrs = tsl2772_device_attrs,
> +	},
> +
> +};
> +
> +static IIO_DEVICE_ATTR(illuminance_thresh_both_en,
> +		S_IRUGO | S_IWUSR,
> +		tsl2x7x_interrupts_en_show, tsl2x7x_interrupts_en_store, 0);
> +
> +static IIO_DEVICE_ATTR(proximity_thresh_both_en,
> +		S_IRUGO | S_IWUSR,
> +		tsl2x7x_prox_interrupt_show, tsl2x7x_prox_interrupt_store, 0);
> +
> +static struct attribute *tsl2X7X_prox_event_attributes[] = {
> +	&iio_dev_attr_proximity_thresh_both_en.dev_attr.attr,
> +	NULL,
> +};
> +
> +static struct attribute *tsl2X7X_als_event_attributes[] = {
> +	&iio_dev_attr_illuminance_thresh_both_en.dev_attr.attr,
> +	NULL,
> +};
> +
> +static struct attribute *tsl2X7X_proxals_event_attributes[] = {
> +	&iio_dev_attr_illuminance_thresh_both_en.dev_attr.attr,
> +	&iio_dev_attr_proximity_thresh_both_en.dev_attr.attr,
> +	NULL,
> +};
The way we have handled this for some similar devices is to just have 
the two enables done
via the iio_chan_spec and chain them both to read / write the same 
value.  (By which I mean
the rising enable and falling enable).  It slightly clunkier as an 
interface, but saves code and will
ultimately enable them to be accessed by consumer drivers within the 
kernel (not that we've
even started looking at event pass
> +
> +static struct attribute_group tsl2X7X_event_attr_group_tbl[] = {
> +	[tsl2571] = {
> +		.attrs = tsl2X7X_als_event_attributes,
> +		.name  = "events",
> +	},
> +	[tsl2671] = {
> +		.attrs = tsl2X7X_prox_event_attributes,
> +		.name  = "events",
> +	},
> +	[tmd2671] = {
> +		.attrs = tsl2X7X_prox_event_attributes,
> +		.name  = "events",
> +	},
> +	[tsl2771] = {
> +		.attrs = tsl2X7X_proxals_event_attributes,
> +		.name  = "events",
> +	},
> +	[tmd2771] = {
> +		.attrs = tsl2X7X_proxals_event_attributes,
> +		.name  = "events",
> +	},
> +
> +	[tsl2572] = {
> +		.attrs = tsl2X7X_als_event_attributes,
> +		.name  = "events",
> +	},
> +	[tsl2672] = {
> +		.attrs = tsl2X7X_prox_event_attributes,
> +		.name  = "events",
> +	},
> +	[tmd2672] = {
> +		.attrs = tsl2X7X_prox_event_attributes,
> +		.name  = "events",
> +	},
> +	[tsl2772] = {
> +		.attrs = tsl2X7X_proxals_event_attributes,
> +		.name  = "events",
> +	},
> +	[tmd2772] = {
> +		.attrs = tsl2X7X_proxals_event_attributes,
> +		.name  = "events",
> +	}
> +};
> +
Being fussy, but only one blank line please.
> +
> +/* Use the default register values to identify the Taos device */
> +static int tsl2x7x_device_id(unsigned char *bufp, int target)
> +{
> +	switch (target) {
> +	case tsl2571:
> +	case tsl2671:
> +	case tsl2771:
> +		return ((bufp[TSL2X7X_CHIPID]&  0xf0) == TRITON_ID);
> +	break;
> +	case tmd2671:
> +	case tmd2771:
> +		return ((bufp[TSL2X7X_CHIPID]&  0xf0) == HALIBUT_ID);
> +	break;
> +	case tsl2572:
> +	case tsl2672:
> +	case tmd2672:
> +	case tsl2772:
> +	case tmd2772:
> +		return ((bufp[TSL2X7X_CHIPID]&  0xf0) == SWORDFISH_ID);
> +	break;
> +	}
> +
> +	return -EINVAL;
> +}
> +
> +static const struct iio_info tsl2X7X_info[] = {
> +	[tsl2571] = {
> +			.attrs =&tsl2X7X_dev_attr_group_tbl[tsl2571],
> +			.event_attrs =&tsl2X7X_event_attr_group_tbl[tsl2571],
> +			.driver_module = THIS_MODULE,
> +	},
> +	[tsl2671] = {
> +			.attrs =&tsl2X7X_dev_attr_group_tbl[tsl2671],
> +			.event_attrs =&tsl2X7X_event_attr_group_tbl[tsl2671],
> +			.driver_module = THIS_MODULE,
> +	},
> +	[tmd2671] = {
> +			.attrs =&tsl2X7X_dev_attr_group_tbl[tsl2671],
> +			.event_attrs =&tsl2X7X_event_attr_group_tbl[tsl2671],
> +			.driver_module = THIS_MODULE,
> +	},
> +	[tsl2771] = {
> +			.attrs =&tsl2X7X_dev_attr_group_tbl[tsl2771],
> +			.event_attrs =&tsl2X7X_event_attr_group_tbl[tsl2771],
> +			.driver_module = THIS_MODULE,
> +	},
> +	[tmd2771] = {
> +			.attrs =&tsl2X7X_dev_attr_group_tbl[tsl2771],
> +			.event_attrs =&tsl2X7X_event_attr_group_tbl[tsl2771],
> +			.driver_module = THIS_MODULE,
> +	},
> +	[tsl2572] = {
> +			.attrs =&tsl2X7X_dev_attr_group_tbl[tsl2572],
> +			.event_attrs =&tsl2X7X_event_attr_group_tbl[tsl2572],
> +			.driver_module = THIS_MODULE,
> +	},
> +	[tsl2672] = {
> +			.attrs =&tsl2X7X_dev_attr_group_tbl[tsl2672],
> +			.event_attrs =&tsl2X7X_event_attr_group_tbl[tsl2672],
> +			.driver_module = THIS_MODULE,
> +	},
> +	[tmd2672] = {
> +			.attrs =&tsl2X7X_dev_attr_group_tbl[tsl2672],
> +			.event_attrs =&tsl2X7X_event_attr_group_tbl[tsl2672],
> +			.driver_module = THIS_MODULE,
> +	},
> +	[tsl2772] = {
> +			.attrs =&tsl2X7X_dev_attr_group_tbl[tsl2772],
> +			.event_attrs =&tsl2X7X_event_attr_group_tbl[tsl2772],
> +			.driver_module = THIS_MODULE,
> +	},
> +	[tmd2772] = {
> +			.attrs =&tsl2X7X_dev_attr_group_tbl[tsl2772],
> +			.event_attrs =&tsl2X7X_event_attr_group_tbl[tsl2772],
> +			.driver_module = THIS_MODULE,
A lot of repeats in here, could you not have fewer entries?  Just reuse 
the enum values
in the i2c id table below.
> +	},
> +
> +};
> +
> +/*
> + * Run-time interrupt handler - depending on whether the device is in ambient
> + * light sensing interrupt mode, this handler can queue up
> + * a thread, to handle valid interrupts.
> + */
> +static irqreturn_t tsl2x7x_event_handler(int irq, void *private)
> +{
> +	struct iio_dev *indio_dev = private;
> +	struct tsl2X7X_chip *chip = iio_priv(indio_dev);
> +	s64 timestamp = iio_get_time_ns();
> +	int ret;
> +	int value;
> +
> +	value = i2c_smbus_read_byte_data(chip->client,
> +		TSL2X7X_CMD_REG | TSL2X7X_STATUS);
> +
> +	/* What type of interrupt do we need to process */
> +	if (value&  TSL2X7X_STA_PRX_INTR) {
> +		tsl2x7x_prox_poll(indio_dev);
> +		iio_push_event(indio_dev,
> +			       IIO_UNMOD_EVENT_CODE(IIO_PROXIMITY,
> +						    0,
> +						    IIO_EV_TYPE_THRESH,
> +						    IIO_EV_DIR_EITHER),
> +						    timestamp);
> +	}
> +
> +	if (value&  TSL2X7X_STA_ALS_INTR) {
> +		tsl2x7x_get_lux(indio_dev);
> +		iio_push_event(indio_dev,
> +		       IIO_UNMOD_EVENT_CODE(IIO_LIGHT,
> +					    0,
> +					    IIO_EV_TYPE_THRESH,
> +					    IIO_EV_DIR_EITHER),
> +					    timestamp);
> +	}
> +	/* Clear interrupt now that we have the status */
> +	ret = i2c_smbus_write_byte(chip->client,
> +		TSL2X7X_CMD_REG | TSL2X7X_CMD_SPL_FN |
> +		TSL2X7X_CMD_PROXALS_INTCLR);
> +	if (ret<  0)
> +		dev_err(&chip->client->dev,
> +		"Failed to clear irq from event handler. err = %d\n", ret);
> +
> +	return IRQ_HANDLED;
> +}
> +
> +/*
> + * Client probe function.
> + */
> +static int __devinit tsl2x7x_probe(struct i2c_client *clientp,
> +	const struct i2c_device_id *id)
> +{
> +	int i, ret;
> +	unsigned char buf[TSL2X7X_MAX_DEVICE_REGS];
> +	struct iio_dev *indio_dev =
> +			iio_allocate_device(sizeof(struct tsl2X7X_chip));
Ugly to do non trivial allocation in the variable definitions.  Have
     struct iio_dev *indio_dev;
     struct tsl2x7x_chip *chip;

     indio_dev = iio_allocate_device(sizeof(*chip));
     if (indio_dev == NULL) {
     }
chip = iio_priv(indio_dev);
etc.
> +	struct tsl2X7X_chip	*chip = iio_priv(indio_dev);
> +
> +	if (indio_dev == NULL) {
> +		ret = -ENOMEM;
> +		dev_err(&clientp->dev, "iio allocation failed\n");
> +		goto fail1;
> +	}
> +
> +	chip = iio_priv(indio_dev);
> +	chip->client = clientp;
> +	i2c_set_clientdata(clientp, indio_dev);
> +
> +	mutex_init(&chip->als_mutex);
> +	mutex_init(&chip->prox_mutex);
> +
> +	chip->tsl2x7x_chip_status = TSL2X7X_CHIP_UNKNOWN;
> +
> +	chip->pdata = clientp->dev.platform_data;
> +	if (chip->pdata&&  chip->pdata->init)
> +			chip->pdata->init(clientp);
> +
> +	for (i = 0; i<  TSL2X7X_MAX_DEVICE_REGS; i++) {
> +		ret = i2c_smbus_write_byte(clientp,
> +				(TSL2X7X_CMD_REG | (TSL2X7X_CNTRL + i)));
> +		if (ret<  0) {
> +			dev_err(&clientp->dev, "i2c_smbus_write_bytes() to cmd "
> +			"reg failed in tsl2x7x_probe(), err = %d\n", ret);
> +			goto fail1;
> +		}
> +		ret = i2c_smbus_read_byte(clientp);
> +		if (ret<  0) {
> +			dev_err(&clientp->dev, "i2c_smbus_read_byte from "
> +			"reg failed in tsl2x7x_probe(), err = %d\n", ret);
> +
> +			goto fail1;
> +		}
> +		buf[i] = ret;
> +	}
> +
> +	if ((!tsl2x7x_device_id(buf, id->driver_data)) ||
> +			(tsl2x7x_device_id(buf, id->driver_data) == -EINVAL)) {
> +		dev_info(&chip->client->dev, "i2c device found but does not match "
> +			"expected id in tsl2x7x_probe()\n");
> +		goto fail1;
> +	}
> +
> +	chip->id = id->driver_data;
> +
> +	ret = i2c_smbus_write_byte(clientp, (TSL2X7X_CMD_REG | TSL2X7X_CNTRL));
> +	if (ret<  0) {
> +		dev_err(&clientp->dev, "i2c_smbus_write_byte() to cmd reg "
> +			"failed in tsl2x7x_probe(), err = %d\n", ret);
> +		goto fail1;
> +	}
> +
> +	indio_dev->info =&tsl2X7X_info[id->driver_data];
> +	indio_dev->dev.parent =&clientp->dev;
> +	indio_dev->modes = INDIO_DIRECT_MODE;
> +	indio_dev->name = chip->client->name;
> +	indio_dev->channels = tsl2X7X_channels;
> +	indio_dev->num_channels = ARRAY_SIZE(tsl2X7X_channels);
> +
> +	ret = iio_device_register(indio_dev);
> +	if (ret) {
> +		dev_err(&clientp->dev, "iio registration failed\n");
> +		goto fail2;
one would normally expect a later failure to result in more needing to 
be undone,
but it appears to be the other way around here.
> +	}
> +
> +	if (clientp->irq) {
> +		ret = request_threaded_irq(clientp->irq,
> +					   NULL,
> +					&tsl2x7x_event_handler,
> +					   IRQF_TRIGGER_RISING | IRQF_ONESHOT,
> +					   "TSL2X7X_event",
> +					   indio_dev);
> +		if (ret)
> +			dev_err(&clientp->dev, "irq request failed");
Unwinding after this error?  Generally set the irq up and make the 
iio_device_register
pretty much the last thing to happen rather than this way around.  
Nothing can
touch the device before the iio_device_register so it avoids the chance 
of race
conditions without having to be careful!
> +	}
> +
> +	/* Load up the defaults */
> +	tsl2x7x_defaults(chip);
> +
> +	/* Make sure the chip is on */
> +	tsl2x7x_chip_on(indio_dev);
> +
> +	dev_info(&clientp->dev, "%s Light sensor found.\n", id->name);
> +
> +	return 0;
> +
> +fail1:
> +	if (chip->pdata&&  chip->pdata->teardown)
> +		chip->pdata->teardown(clientp);
> +	iio_free_device(indio_dev);
> +
> +fail2:
> +	return ret;
loose the bonus blank line.
> +
> +}
> +
> +
> +static int tsl2x7x_suspend(struct device *dev)
> +{
> +	struct iio_dev *dev_info = dev_get_drvdata(dev);
standardize the naming please.  indio_dev  preferably but consistency is 
most
important.
> +	struct tsl2X7X_chip *chip = iio_priv(dev_info);
> +
> +	int ret = 0;
> +
> +	/* Blocks if work is active */
> +	cancel_work_sync(&chip->work_thresh);
> +
> +	if (chip->tsl2x7x_chip_status == TSL2X7X_CHIP_WORKING) {
> +		ret = tsl2x7x_chip_off(dev_info);
> +		chip->tsl2x7x_chip_status = TSL2X7X_CHIP_SUSPENDED;
> +	}
> +
> +	if (chip->pdata&&  chip->pdata->platform_power) {
> +		pm_message_t pmm = {PM_EVENT_SUSPEND};
> +		chip->pdata->platform_power(dev, pmm);
> +	}
> +
> +	return ret;
> +}
> +
> +static int tsl2x7x_resume(struct device *dev)
> +{
> +	struct iio_dev *dev_info = dev_get_drvdata(dev);
> +	struct tsl2X7X_chip *chip = iio_priv(dev_info);
> +	int ret = 0;
> +
> +	if (chip->pdata&&  chip->pdata->platform_power) {
> +		pm_message_t pmm = {PM_EVENT_RESUME};
> +		chip->pdata->platform_power(dev, pmm);
> +	}
> +
> +	if (chip->tsl2x7x_chip_status == TSL2X7X_CHIP_SUSPENDED)
> +		ret = tsl2x7x_chip_on(dev_info);
> +
> +	return ret;
> +}
> +
> +static int __devexit tsl2x7x_remove(struct i2c_client *client)
> +{
> +	struct iio_dev *indio_dev = i2c_get_clientdata(client);
> +	struct tsl2X7X_chip *chip = i2c_get_clientdata(client);
Err, the two lines above seem a little implausible.
> +
> +	tsl2x7x_chip_off(indio_dev);
> +
> +	if (client->irq)
> +		free_irq(client->irq, chip->client->name);
> +
> +	flush_scheduled_work();
> +
> +	iio_device_unregister(chip->iio_dev);
or use the indio_dev pointer you already have.  There is rarely a reason
to have a pointer to the iio_dev in the driver private bit.
> +	kfree(chip);
> +
> +	if (chip->pdata&&  chip->pdata->teardown)
> +		chip->pdata->teardown(client);
> +
> +	return 0;
> +}
> +
> +static struct i2c_device_id tsl2x7x_idtable[] = {
I'm guessing there is a magic ordering here, but might be
nicer just to go with alphabetical order..
> +	{ "tsl2571", tsl2571 },
> +	{ "tsl2671", tsl2671 },
> +	{ "tmd2671", tmd2671 },
> +	{ "tsl2771", tsl2771 },
> +	{ "tmd2771", tmd2771 },
> +	{ "tsl2572", tsl2572 },
> +	{ "tsl2672", tsl2672 },
> +	{ "tmd2672", tmd2672 },
> +	{ "tsl2772", tsl2772 },
> +	{ "tmd2772", tmd2772 },
> +	{}
> +};
> +
> +MODULE_DEVICE_TABLE(i2c, tsl2x7x_idtable);
> +
> +static const struct dev_pm_ops tsl2x7x_pm_ops = {
> +	.suspend = tsl2x7x_suspend,
> +	.resume  = tsl2x7x_resume,
> +};
> +
> +/* Driver definition */
> +static struct i2c_driver tsl2x7x_driver = {
> +	.driver = {
> +		.name = "tsl2X7X",
> +		.pm =&tsl2x7x_pm_ops,
> +
> +	},
> +	.id_table = tsl2x7x_idtable,
> +	.probe = tsl2x7x_probe,
> +	.remove = __devexit_p(tsl2x7x_remove),
> +};
> +
> +static int __init tsl2x7x_init(void)
> +{
> +	return i2c_add_driver(&tsl2x7x_driver);
> +}
> +
> +static void __exit tsl2x7x_exit(void)
> +{
> +	i2c_del_driver(&tsl2x7x_driver);
> +}
> +
> +module_init(tsl2x7x_init);
> +module_exit(tsl2x7x_exit);
Some nice new macros to handle this boiler plate.
see module_i2c_driver in include/linux/i2c.h

> +
> +MODULE_AUTHOR("J. August Brenner<jbrenner@taosinc.com>");
> +MODULE_DESCRIPTION("TAOS tsl2X7X ambient light sensor driver");
> +MODULE_LICENSE("GPL");
> diff --git a/drivers/staging/iio/light/tsl2x7x_core.h b/drivers/staging/iio/light/tsl2x7x_core.h
> new file mode 100644
> index 0000000..9a64412
> --- /dev/null
> +++ b/drivers/staging/iio/light/tsl2x7x_core.h
> @@ -0,0 +1,138 @@
> +/*
> + * Device driver for monitoring ambient light intensity (lux)
> + * and proximity (prox) within the TAOS TSL2X7X family of devices.
> + *
> + * Copyright (c) 2012, TAOS Corporation.
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
> +#ifndef __TSL2X7X_H
> +#define __TSL2X7X_H
> +#include<linux/pm.h>
> +
> +#include "../iio.h"
loose this header and just forward declare the pointer.
e.g. struct iio_dev;

> +
> +/* TAOS Register definitions - note:
> + * depending on device, some of these register are not used and the
> + * register address is benign.
> + */
> +/* 2X7X register offsets */
> +#define TSL2X7X_MAX_DEVICE_REGS 32
> +#define TSL2X7X_REG_MAX         16
> +
> +/* Device Registers and Masks */
> +#define TSL2X7X_CNTRL                  0x00
> +#define TSL2X7X_ALS_TIME               0X01
> +#define TSL2X7X_PRX_TIME               0x02
> +#define TSL2X7X_WAIT_TIME              0x03
> +#define TSL2X7X_ALS_MINTHRESHLO        0X04
> +#define TSL2X7X_ALS_MINTHRESHHI        0X05
> +#define TSL2X7X_ALS_MAXTHRESHLO        0X06
> +#define TSL2X7X_ALS_MAXTHRESHHI        0X07
> +#define TSL2X7X_PRX_MINTHRESHLO        0X08
> +#define TSL2X7X_PRX_MINTHRESHHI        0X09
> +#define TSL2X7X_PRX_MAXTHRESHLO        0X0A
> +#define TSL2X7X_PRX_MAXTHRESHHI        0X0B
> +#define TSL2X7X_PERSISTENCE            0x0C
> +#define TSL2X7X_PRX_CONFIG             0x0D
> +#define TSL2X7X_PRX_COUNT              0x0E
> +#define TSL2X7X_GAIN                   0x0F
> +#define TSL2X7X_NOTUSED                0x10
> +#define TSL2X7X_REVID                  0x11
> +#define TSL2X7X_CHIPID                 0x12
> +#define TSL2X7X_STATUS                 0x13
> +#define TSL2X7X_ALS_CHAN0LO            0x14
> +#define TSL2X7X_ALS_CHAN0HI            0x15
> +#define TSL2X7X_ALS_CHAN1LO            0x16
> +#define TSL2X7X_ALS_CHAN1HI            0x17
> +#define TSL2X7X_PRX_LO                 0x18
> +#define TSL2X7X_PRX_HI                 0x19
> +
> +/* tsl2X7X cmd reg masks */
> +#define TSL2X7X_CMD_REG                0x80
> +#define TSL2X7X_CMD_SPL_FN             0x60
> +
> +#define TSL2X7X_CMD_PROX_INT_CLR       0X05
> +#define TSL2X7X_CMD_ALS_INT_CLR        0x06
> +#define CMD_PROXALS_INT_CLR            0X07
> +
> +/* tsl2X7X cntrl reg masks */
> +#define TSL2X7X_CNTL_ADC_ENBL          0x02
> +#define TSL2X7X_CNTL_PWR_ON            0x01
> +
> +/* tsl2X7X status reg masks */
> +#define TSL2X7X_STA_ADC_VALID          0x01
> +#define TSL2X7X_STA_PRX_VALID          0x02
> +#define TSL2X7X_STA_ADC_PRX_VALID      0x03
> +#define TSL2X7X_STA_ALS_INTR           0x10
> +#define TSL2X7X_STA_ADC_INTR           0x10
> +#define TSL2X7X_STA_PRX_INTR           0x20
> +
> +#define TSL2X7X_STA_ADC_INTR           0x10
> +
> +/* tsl2X7X cntrl reg masks */
> +#define CNTL_REG_CLEAR                 0x00
> +#define CNTL_PROX_INT_ENBL             0X20
> +#define CNTL_ALS_INT_ENBL              0X10
> +#define TSL2X7X_CNTL_WAIT_TMR_ENBL     0X08
> +#define CNTL_PROX_DET_ENBL             0X04
> +#define CNTL_ADC_ENBL                  0x02
> +#define TSL2X7X_CNTL_PWRON             0x01
> +#define CNTL_ALSPON_ENBL               0x03
> +#define CNTL_INTALSPON_ENBL            0x13
> +#define CNTL_PROXPON_ENBL              0x0F
> +#define CNTL_INTPROXPON_ENBL           0x2F
> +#define TSL2X7X_CMD_PROXALS_INTCLR     0X07
> +
Chances of a clash on these definitions is extremely high,
Stick a prefix in front of them to avoid that issue.
> +/*Prox diode to use */
> +#define DIODE0                         0x10
> +#define DIODE1                         0x20
> +#define DIODE_BOTH                     0x30
> +
> +/* LED Power */
> +#define mA100                          0x00
> +#define mA50                           0x40
> +#define mA25                           0x80
> +#define mA13                           0xD0
> +
> +/* Max number of segments allowable in LUX table */
> +#define MAX_TABLE_SIZE		9
> +#define MAX_DEFAULT_TABLE_BYTES (sizeof(int) * MAX_TABLE_SIZE)
> +
> +struct tsl2x7x_lux {
> +	unsigned int ratio;
> +	unsigned int ch0;
> +	unsigned int ch1;
> +};
> +
> +
Kernel doc for comments would be preferable.  Can you also give a 
description of what
actually tends to occur in these callbacks?  I can't help feeling there 
are rather more of
them than we'd normally expect.
> +/* struct tsl2x7x_platform_data - Assume all varients will have this */
> +struct tsl2X7X_platform_data {
> +	int (*platform_power)(struct device *dev, pm_message_t);
> +	/* The following callback gets called when the TSL2772 is powered on */
> +	int (*power_on)      (struct iio_dev *indio_dev);
> +	/* The following callback gets called when the TSL2772 is powered off */
> +	int (*power_off)     (struct i2c_client *dev);
> +	/* The following callback gets called when the driver is added */
> +	int (*init)          (struct i2c_client *dev);
> +	/* The following callback gets called when the driver is removed */
> +	int (*teardown)      (struct i2c_client *dev);
> +	/* These are the device specific glass coefficents used to
> +	 * calculate Lux */
> +	struct tsl2x7x_lux platform_lux_table[MAX_TABLE_SIZE];
> +};
> +
> +#endif /* __TSL2X7X_H */
> --
>

