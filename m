Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932501Ab2C1RwR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 13:52:17 -0400
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:50898 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752220Ab2C1RwN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 13:52:13 -0400
Message-ID: <4F734FB7.6020609@kernel.org>
Date: Wed, 28 Mar 2012 18:51:51 +0100
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120314 Thunderbird/11.0
MIME-Version: 1.0
To: Jon Brenner <jbrenner@TAOSinc.com>
CC: Jonathan Cameron <jic23@cam.ac.uk>, linux-iio <linux-iio@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V4] TAOS tsl2x7x
References: <1332346584.15943.2.camel@jonz-ub2> <4F6C806B.2090909@cam.ac.uk> <B4B07CCC7B7A084E989CF9386538EA1D011CFFE1@exchsrvr.taosinc.com>
In-Reply-To: <B4B07CCC7B7A084E989CF9386538EA1D011CFFE1@exchsrvr.taosinc.com>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/27/2012 08:58 PM, Jon Brenner wrote:
> Hello Jonathan,
> Still a little confused (and stuck) here.
> Using your code from the tsl2563:
> 1. The case for IIO_LIGHT appears to return the computed LUX.
> Yet you have no ".processed_val = 1: in your channel table - so where in in_illuminance0_input (aka lux)  coming from?
Indeed. That's bug number 1...
>  
> 2. The case for IIO_INTENSITY looks for 'chan->channel' to determine when to present 'chip->data0' or 'chip->data1' - 
> But it appears that 'chan->channel' will always be 0 as '.channel =' isn't defined in the table?
> So how can you ever get chip->data01?
> 
Gah, this driver clearly needs another look.  You are quite correct,
that is a bug as well as it will always return the first channel.

Clearly a little bit of code rot has occured here.  Oops.
Do you want to do the patch, or shall I (with a reported by
of course!).

Jonathan
> For example, tsl2563 code portion follows.
> 
> <Snip>
> static int tsl2563_read_raw(struct iio_dev *indio_dev,
> 			    struct iio_chan_spec const *chan,
> 			    int *val,
> 			    int *val2,
> 			    long m)
> {
> 	int ret = -EINVAL;
> 	u32 calib0, calib1;
> 	struct tsl2563_chip *chip = iio_priv(indio_dev);
> 
> 	mutex_lock(&chip->lock);
> 	switch (m) {
> 	case 0:
> 		switch (chan->type) {
> 		case IIO_LIGHT:
> 			ret = tsl2563_get_adc(chip);
> 			if (ret)
> 				goto error_ret;
> 			calib0 = calib_adc(chip->data0, chip->calib0) *
> 				chip->cover_comp_gain;
> 			calib1 = calib_adc(chip->data1, chip->calib1) *
> 				chip->cover_comp_gain;
> 			*val = adc_to_lux(calib0, calib1);
> 			ret = IIO_VAL_INT;
> 			break;
> 		case IIO_INTENSITY:
> 			ret = tsl2563_get_adc(chip);
> 			if (ret)
> 				goto error_ret;
> 			if (chan->channel == 0)
> 				*val = chip->data0;
> 			else
> 				*val = chip->data1;
> 			ret = IIO_VAL_INT;
> 			break;
> 		default:
> 			break;
> 		}
> 		break;
> 
> 	case IIO_CHAN_INFO_CALIBSCALE:
> 		if (chan->channel == 0)
> 			*val = calib_to_sysfs(chip->calib0);
> 		else
> 			*val = calib_to_sysfs(chip->calib1);
> 		ret = IIO_VAL_INT;
> 		break;
> 	default:
> 		ret = -EINVAL;
> 		goto error_ret;
> 	}
> 
> error_ret:
> 	mutex_unlock(&chip->lock);
> 	return ret;
> }
> 
> static const struct iio_chan_spec tsl2563_channels[] = {
> 	{
> 		.type = IIO_LIGHT,
> 		.indexed = 1,
> 		.channel = 0,
> 	}, {
> 		.type = IIO_INTENSITY,
> 		.modified = 1,
> 		.channel2 = IIO_MOD_LIGHT_BOTH,
> 		.info_mask = IIO_CHAN_INFO_CALIBSCALE_SEPARATE_BIT,
> 		.event_mask = (IIO_EV_BIT(IIO_EV_TYPE_THRESH,
> 					  IIO_EV_DIR_RISING) |
> 			       IIO_EV_BIT(IIO_EV_TYPE_THRESH,
> 					  IIO_EV_DIR_FALLING)),
> 	}, {
> 		.type = IIO_INTENSITY,
> 		.modified = 1,
> 		.channel2 = IIO_MOD_LIGHT_IR,
> 		.info_mask = IIO_CHAN_INFO_CALIBSCALE_SEPARATE_BIT,
> 	}
> };
> 
> 
> What am I not seeing here?
> 
> Jon
> 
>> -----Original Message-----
>> From: Jonathan Cameron [mailto:jic23@cam.ac.uk]
>> Sent: Friday, March 23, 2012 8:54 AM
>> To: Jon Brenner
>> Cc: linux-iio; Linux Kernel
>> Subject: Re: [PATCH V4] TAOS tsl2x7x
>>
>> On 3/21/2012 4:16 PM, Jon Brenner wrote:
>>> TAOS device driver (version 4) for the tsl/tmd 2771 and 2772 device families
>> (inc. all variants).
>> Mostly looking good...
>>
>> Couple of issues remaining.
>> * Why have processed and raw accesses to the same channels?  That is
>> definitely not the intent.
>> Either it's worth processing these raw adc channels in kernel, or not.
>> If it isn't you certainly shouldn't
>> be munging together the two adc's into a single value.
>>
>> So you have done this for two reasons...
>> * For light sensors it was to allow the processed illuminance value and
>> also the raw adc values.
>> Previously we have done this by having IIO_LIGHT (and hence illuminance)
>> for the processed one
>> and marking the other two as IIO_INTENSITY with modifiers for the
>> frequency range they cover...
>> * For proximity one is the raw reading (fine), the other is a means of
>> getting at the threshold event
>> if interrupts are not supported.  It is done by a software comparison of
>> the threshold and the raw
>> reading.  This should not be in driver as if the functionality is
>> desired, it should be done in userspace.
>>
>> Various other minor bits like error paths that don't clean up commented
>> inline.
>>
>>
>>>
>>> Signed-off-by: Jon Brenner<jbrenner@taosinc.com>
>>> ---
>>>   .../light/sysfs-bus-iio-light-tsl2583              |    6 +
>>>   .../light/sysfs-bus-iio-light-tsl2x7x              |   20 +
>>>   drivers/staging/iio/Documentation/sysfs-bus-iio    |    7 +
>>>   .../staging/iio/Documentation/sysfs-bus-iio-light  |    8 +-
>>>   .../iio/Documentation/sysfs-bus-iio-light-tsl2583  |   20 -
>>>   drivers/staging/iio/light/Kconfig                  |    8 +
>>>   drivers/staging/iio/light/Makefile                 |    1 +
>>>   drivers/staging/iio/light/tsl2x7x_core.c           | 1911 ++++++++++++++++++++
>>>   drivers/staging/iio/light/tsl2x7x_core.h           |   75 +
>>>   9 files changed, 2032 insertions(+), 24 deletions(-)
>>>
>>> diff --git a/drivers/staging/iio/Documentation/light/sysfs-bus-iio-light-tsl2583
>> b/drivers/staging/iio/Documentation/light/sysfs-bus-iio-light-tsl2583
>>> new file mode 100644
>>> index 0000000..8f2a038
>>> --- /dev/null
>>> +++ b/drivers/staging/iio/Documentation/light/sysfs-bus-iio-light-tsl2583
>>> @@ -0,0 +1,6 @@
>>> +What:		/sys/bus/iio/devices/device[n]/illuminance0_calibrate
>>> +KernelVersion:	2.6.37
>>> +Contact:	linux-iio@vger.kernel.org
>>> +Description:
>>> +		This property causes an internal calibration of the als gain trim
>>> +		value which is later used in calculating illuminance in lux.
>>> diff --git a/drivers/staging/iio/Documentation/light/sysfs-bus-iio-light-tsl2x7x
>> b/drivers/staging/iio/Documentation/light/sysfs-bus-iio-light-tsl2x7x
>>> new file mode 100644
>>> index 0000000..cceadae
>>> --- /dev/null
>>> +++ b/drivers/staging/iio/Documentation/light/sysfs-bus-iio-light-tsl2x7x
>>> @@ -0,0 +1,20 @@
>>> +What:		/sys/bus/iio/devices/device[n]/illuminance0_calibrate
>>> +KernelVersion:	2.6.37
>>> +Contact:	linux-iio@vger.kernel.org
>>> +Description:
>>> +		This property causes an internal calibration of the als gain trim
>>> +		value which is later used in calculating illuminance in lux.
>>> +
>>> +What:		/sys/bus/iio/devices/device[n]/illuminance0_both_raw
>>> +KernelVersion:	3.3-rc1
>>> +Contact:	linux-iio@vger.kernel.org
>>> +Description:
>>> +		Simultainious ALS channel data.
>> That wasn't the intent of 'both' at all.  (+ typo).  It means a raw
>> reading from a diod that
>> detects the 'sum' of infrared and visible.
>>> +
>>> +What:		/sys/bus/iio/devices/device[n]/proximity_calibrate
>>> +KernelVersion:	3.3-rc1
>>> +Contact:	linux-iio@vger.kernel.org
>>> +Description:
>>> +		Causes an recalculation and adjustment to the
>>> +		proximity_thresh_rising_value.
>>> +
>>> diff --git a/drivers/staging/iio/Documentation/sysfs-bus-iio
>> b/drivers/staging/iio/Documentation/sysfs-bus-iio
>>> index 46a995d..5b2b5d3 100644
>>> --- a/drivers/staging/iio/Documentation/sysfs-bus-iio
>>> +++ b/drivers/staging/iio/Documentation/sysfs-bus-iio
>>> @@ -258,6 +258,8 @@ What
>> 	/sys/bus/iio/devices/iio:deviceX/in_accel_z_calibscale
>>>   What
>> 	/sys/bus/iio/devices/iio:deviceX/in_anglvel_x_calibscale
>>>   What
>> 	/sys/bus/iio/devices/iio:deviceX/in_anglvel_y_calibscale
>>>   What
>> 	/sys/bus/iio/devices/iio:deviceX/in_anglvel_z_calibscale
>>> +what
>> 	/sys/bus/iio/devices/iio:deviceX/illuminance0_calibscale
>>> +what		/sys/bus/iio/devices/iio:deviceX/proximity_calibscale
>>>   KernelVersion:	2.6.35
>>>   Contact:	linux-iio@vger.kernel.org
>>>   Description:
>>> @@ -457,6 +459,10 @@ What:
>> 	/sys/.../events/in_voltageY_raw_thresh_falling_value
>>>   What:		/sys/.../events/in_voltageY_raw_thresh_falling_value
>>>   What:		/sys/.../events/in_tempY_raw_thresh_falling_value
>>>   What:		/sys/.../events/in_tempY_raw_thresh_falling_value
>>> +What:		/sys/.../events/illuminance0_thresh_falling_value
>>> +what:		/sys/.../events/illuminance0_thresh_rising_value
>>> +what:		/sys/.../events/proximity_thresh_falling_value
>>> +what:		/sys/.../events/proximity_thresh_rising_value
>>>   KernelVersion:	2.6.37
>>>   Contact:	linux-iio@vger.kernel.org
>>>   Description:
>>> @@ -739,3 +745,4 @@ Description:
>>>   		system. To minimize the current consumption of the system,
>>>   		the bridge can be disconnected (when it is not being used
>>>   		using the bridge_switch_en attribute.
>>> +
>> spurious blank line?
>>> diff --git a/drivers/staging/iio/Documentation/sysfs-bus-iio-light
>> b/drivers/staging/iio/Documentation/sysfs-bus-iio-light
>>> index edbf470..4385c70 100644
>>> --- a/drivers/staging/iio/Documentation/sysfs-bus-iio-light
>>> +++ b/drivers/staging/iio/Documentation/sysfs-bus-iio-light
>>> @@ -76,10 +76,10 @@ Contact:	linux-iio@vger.kernel.org
>>>   Description:
>>>   		This property gets/sets the sensors ADC analog integration
>> time.
>>>
>>> -What:		/sys/bus/iio/devices/device[n]/illuminance0_calibscale
>>> +What:		/sys/bus/iio/devices/device[n]/lux_table
>>>   KernelVersion:	2.6.37
>>>   Contact:	linux-iio@vger.kernel.org
>>>   Description:
>>> -		Hardware or software applied calibration scale factor assumed
>>> -		to account for attenuation due to industrial design (glass
>>> -		filters or aperture holes).
>>> +		This property gets/sets the table of coefficients
>>> +		used in calculating illuminance in lux.
>>> +
>>> diff --git a/drivers/staging/iio/Documentation/sysfs-bus-iio-light-tsl2583
>> b/drivers/staging/iio/Documentation/sysfs-bus-iio-light-tsl2583
>>> deleted file mode 100644
>>> index 660781d..0000000
>>> --- a/drivers/staging/iio/Documentation/sysfs-bus-iio-light-tsl2583
>>> +++ /dev/null
>>> @@ -1,20 +0,0 @@
>>> -What:		/sys/bus/iio/devices/device[n]/lux_table
>>> -KernelVersion:	2.6.37
>>> -Contact:	linux-iio@vger.kernel.org
>>> -Description:
>>> -		This property gets/sets the table of coefficients
>>> -		used in calculating illuminance in lux.
>>> -
>>> -What:		/sys/bus/iio/devices/device[n]/illuminance0_calibrate
>>> -KernelVersion:	2.6.37
>>> -Contact:	linux-iio@vger.kernel.org
>>> -Description:
>>> -		This property causes an internal calibration of the als gain trim
>>> -		value which is later used in calculating illuminance in lux.
>>> -
>>> -What:
>> 	/sys/bus/iio/devices/device[n]/illuminance0_input_target
>>> -KernelVersion:	2.6.37
>>> -Contact:	linux-iio@vger.kernel.org
>>> -Description:
>>> -		This property is the known externally illuminance (in lux).
>>> -		It is used in the process of calibrating the device accuracy.
>>> diff --git a/drivers/staging/iio/light/Kconfig b/drivers/staging/iio/light/Kconfig
>>> index e7e9159..976f790 100644
>>> --- a/drivers/staging/iio/light/Kconfig
>>> +++ b/drivers/staging/iio/light/Kconfig
>>> @@ -31,4 +31,12 @@ config TSL2583
>>>   	 Provides support for the TAOS tsl2580, tsl2581 and tsl2583 devices.
>>>   	 Access ALS data via iio, sysfs.
>>>
>>> +config TSL2x7x
>>> +	tristate "TAOS TSL/TMD2x71 and TSL/TMD2x72 Family of light and
>> proximity sensors"
>>> +	depends on I2C
>>> +	help
>>> +	 Support for: tsl2571, tsl2671, tmd2671, tsl2771, tmd2771, tsl2572,
>> tsl2672,
>>> +	 tmd2672, tsl2772, tmd2772 devices.
>>> +	 Provides iio_events and direct access via sysfs.
>>> +
>>>   endmenu
>>> diff --git a/drivers/staging/iio/light/Makefile
>> b/drivers/staging/iio/light/Makefile
>>> index 3011fbf..ff12c4b 100644
>>> --- a/drivers/staging/iio/light/Makefile
>>> +++ b/drivers/staging/iio/light/Makefile
>>> @@ -5,3 +5,4 @@
>>>   obj-$(CONFIG_SENSORS_TSL2563)	+= tsl2563.o
>>>   obj-$(CONFIG_SENSORS_ISL29018)	+= isl29018.o
>>>   obj-$(CONFIG_TSL2583)	+= tsl2583.o
>>> +obj-$(CONFIG_TSL2x7x)	+= tsl2x7x_core.o
>>> diff --git a/drivers/staging/iio/light/tsl2x7x_core.c
>> b/drivers/staging/iio/light/tsl2x7x_core.c
>>> new file mode 100644
>>> index 0000000..c0d9d6e
>>> --- /dev/null
>>> +++ b/drivers/staging/iio/light/tsl2x7x_core.c
>>> @@ -0,0 +1,1911 @@
>>> +/*
>>> + * Device driver for monitoring ambient light intensity in (lux)
>>> + * and proximity detection (prox) within the TAOS TSL2X7X family of devices.
>>> + *
>>> + * Copyright (c) 2012, TAOS Corporation.
>>> + *
>>> + * This program is free software; you can redistribute it and/or modify
>>> + * it under the terms of the GNU General Public License as published by
>>> + * the Free Software Foundation; either version 2 of the License, or
>>> + * (at your option) any later version.
>>> + *
>>> + * This program is distributed in the hope that it will be useful, but WITHOUT
>>> + * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
>> or
>>> + * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
>> for
>>> + * more details.
>>> + *
>>> + * You should have received a copy of the GNU General Public License along
>>> + * with this program; if not, write to the Free Software Foundation, Inc.,
>>> + * 51 Franklin Street, Fifth Floor, Boston, MA        02110-1301, USA.
>>> + */
>>> +
>>> +#include<linux/kernel.h>
>>> +#include<linux/i2c.h>
>>> +#include<linux/errno.h>
>>> +#include<linux/delay.h>
>>> +#include<linux/mutex.h>
>>> +#include<linux/interrupt.h>
>>> +#include<linux/slab.h>
>>> +#include<linux/module.h>
>>> +#include<linux/version.h>
>>> +#include "tsl2x7x_core.h"
>>> +#include "../events.h"
>>> +#include "../iio.h"
>>> +#include "../sysfs.h"
>>> +
>>> +/* Cal defs*/
>>> +#define PROX_STAT_CAL        0
>>> +#define PROX_STAT_SAMP       1
>>> +#define MAX_SAMPLES_CAL      200
>>> +
>>> +/* TSL2X7X Device ID */
>>> +#define TRITON_ID    0x00
>>> +#define SWORDFISH_ID 0x30
>>> +#define HALIBUT_ID   0x20
>>> +
>>> +/* Lux calculation constants */
>>> +#define TSL2X7X_LUX_CALC_OVER_FLOW     65535
>>> +
>>> +/* TAOS Register definitions - note:
>>> + * depending on device, some of these register are not used and the
>>> + * register address is benign.
>>> + */
>>> +/* 2X7X register offsets */
>>> +#define TSL2X7X_MAX_CONFIG_REG         16
>>> +
>>> +/* Device Registers and Masks */
>>> +#define TSL2X7X_CNTRL                  0x00
>>> +#define TSL2X7X_ALS_TIME               0X01
>>> +#define TSL2X7X_PRX_TIME               0x02
>>> +#define TSL2X7X_WAIT_TIME              0x03
>>> +#define TSL2X7X_ALS_MINTHRESHLO        0X04
>>> +#define TSL2X7X_ALS_MINTHRESHHI        0X05
>>> +#define TSL2X7X_ALS_MAXTHRESHLO        0X06
>>> +#define TSL2X7X_ALS_MAXTHRESHHI        0X07
>>> +#define TSL2X7X_PRX_MINTHRESHLO        0X08
>>> +#define TSL2X7X_PRX_MINTHRESHHI        0X09
>>> +#define TSL2X7X_PRX_MAXTHRESHLO        0X0A
>>> +#define TSL2X7X_PRX_MAXTHRESHHI        0X0B
>>> +#define TSL2X7X_PERSISTENCE            0x0C
>>> +#define TSL2X7X_PRX_CONFIG             0x0D
>>> +#define TSL2X7X_PRX_COUNT              0x0E
>>> +#define TSL2X7X_GAIN                   0x0F
>>> +#define TSL2X7X_NOTUSED                0x10
>>> +#define TSL2X7X_REVID                  0x11
>>> +#define TSL2X7X_CHIPID                 0x12
>>> +#define TSL2X7X_STATUS                 0x13
>>> +#define TSL2X7X_ALS_CHAN0LO            0x14
>>> +#define TSL2X7X_ALS_CHAN0HI            0x15
>>> +#define TSL2X7X_ALS_CHAN1LO            0x16
>>> +#define TSL2X7X_ALS_CHAN1HI            0x17
>>> +#define TSL2X7X_PRX_LO                 0x18
>>> +#define TSL2X7X_PRX_HI                 0x19
>>> +
>>> +/* tsl2X7X cmd reg masks */
>>> +#define TSL2X7X_CMD_REG                0x80
>>> +#define TSL2X7X_CMD_SPL_FN             0x60
>>> +
>>> +#define TSL2X7X_CMD_PROX_INT_CLR       0X05
>>> +#define TSL2X7X_CMD_ALS_INT_CLR        0x06
>>> +#define TSL2X7X_CMD_PROXALS_INT_CLR    0X07
>>> +
>>> +/* tsl2X7X cntrl reg masks */
>>> +#define TSL2X7X_CNTL_ADC_ENBL          0x02
>>> +#define TSL2X7X_CNTL_PWR_ON            0x01
>>> +
>>> +/* tsl2X7X status reg masks */
>>> +#define TSL2X7X_STA_ADC_VALID          0x01
>>> +#define TSL2X7X_STA_PRX_VALID          0x02
>>> +#define TSL2X7X_STA_ADC_PRX_VALID      0x03
>>> +#define TSL2X7X_STA_ALS_INTR           0x10
>>> +#define TSL2X7X_STA_ADC_INTR           0x10
>>> +#define TSL2X7X_STA_PRX_INTR           0x20
>>> +
>>> +#define TSL2X7X_STA_ADC_INTR           0x10
>>> +
>>> +/* tsl2X7X cntrl reg masks */
>>> +#define TSL2X7X_CNTL_REG_CLEAR         0x00
>>> +#define TSL2X7X_CNTL_PROX_INT_ENBL     0X20
>>> +#define TSL2X7X_CNTL_ALS_INT_ENBL      0X10
>>> +#define TSL2X7X_CNTL_WAIT_TMR_ENBL     0X08
>>> +#define TSL2X7X_CNTL_PROX_DET_ENBL     0X04
>>> +#define TSL2X7X_CNTL_PWRON             0x01
>>> +#define TSL2X7X_CNTL_ALSPON_ENBL       0x03
>>> +#define TSL2X7X_CNTL_INTALSPON_ENBL    0x13
>>> +#define TSL2X7X_CNTL_PROXPON_ENBL      0x0F
>>> +#define TSL2X7X_CNTL_INTPROXPON_ENBL   0x2F
>>> +
>>> +/*Prox diode to use */
>>> +#define TSL2X7X_DIODE0                 0x10
>>> +#define TSL2X7X_DIODE1                 0x20
>>> +#define TSL2X7X_DIODE_BOTH             0x30
>>> +
>>> +/* LED Power */
>>> +#define TSL2X7X_mA100                  0x00
>>> +#define TSL2X7X_mA50                   0x40
>>> +#define TSL2X7X_mA25                   0x80
>>> +#define TSL2X7X_mA13                   0xD0
>>> +
>>> +/*Common device IIO EventMask */
>>> +#define TSL2X7X_EVENT_MASK \
>>> +		(IIO_EV_BIT(IIO_EV_TYPE_THRESH, IIO_EV_DIR_RISING) | \
>>> +		IIO_EV_BIT(IIO_EV_TYPE_THRESH, IIO_EV_DIR_FALLING)),
>>> +
>>> +/* TAOS txx2x7x Device family members */
>>> +enum {
>>> +	tsl2571,
>>> +	tsl2671,
>>> +	tmd2671,
>>> +	tsl2771,
>>> +	tmd2771,
>>> +	tsl2572,
>>> +	tsl2672,
>>> +	tmd2672,
>>> +	tsl2772,
>>> +	tmd2772
>>> +};
>>> +
>>> +enum {
>>> +	TSL2X7X_CHIP_UNKNOWN = 0,
>>> +	TSL2X7X_CHIP_WORKING = 1,
>>> +	TSL2X7X_CHIP_SUSPENDED = 2
>>> +};
>>> +
>>> +/* Per-device data */
>>> +struct tsl2x7x_als_info {
>>> +	u16 als_ch0;
>>> +	u16 als_ch1;
>>> +	u16 lux;
>>> +};
>>> +
>>> +/* proximity data */
>>> +struct tsl2x7x_prox_info {
>>> +	u16 prox_data;
>>> +	int prox_event;
>>> +};
>>> +
>>> +struct prox_stat {
>>> +	u16 min;
>>> +	u16 max;
>>> +	u16 mean;
>>> +	unsigned long stddev;
>>> +};
>>> +
>>> +struct tsl2x7x_chip_info {
>>> +	int num_channels;
>>> +	struct iio_chan_spec		channel[9];
>>> +	const struct iio_info		*info;
>>> +};
>>> +
>>> +struct tsl2X7X_chip {
>>> +	kernel_ulong_t id;
>>> +	struct mutex prox_mutex;
>>> +	struct mutex als_mutex;
>>> +	struct i2c_client *client;
>>> +	struct tsl2x7x_prox_info prox_cur_info;
>>> +	struct tsl2x7x_als_info als_cur_info;
>>> +	struct tsl2x7x_settings tsl2x7x_settings;
>>> +	struct tsl2X7X_platform_data *pdata;
>>> +	int als_time_scale;
>>> +	int als_saturation;
>>> +	int tsl2x7x_chip_status;
>>> +	u8 tsl2x7x_config[TSL2X7X_MAX_CONFIG_REG];
>>> +	const struct tsl2x7x_chip_info	*chip_info;
>>> +	const struct iio_info *info;
>>> +	s64 event_timestamp;
>>> +	/* This structure is intentionally large to accommodate
>>> +	 * updates via sysfs. */
>>> +	/* Sized to 9 = max 8 segments + 1 termination segment */
>>> +	struct tsl2x7x_lux tsl2x7x_device_lux[TSL2X7X_MAX_LUX_TABLE_SIZE];
>>> +};
>>> +
>>> +/* Different devices require different coefficents */
>>> +static const struct tsl2x7x_lux tsl2x71_lux_table[] = {
>>> +	{ 14461,   611,   1211 },
>>> +	{ 18540,   352,    623 },
>>> +	{     0,     0,      0 },
>>> +};
>>> +
>>> +static const struct tsl2x7x_lux tmd2x71_lux_table[] = {
>>> +	{ 11635,   115,    256 },
>>> +	{ 15536,    87,    179 },
>>> +	{     0,     0,      0 },
>>> +};
>>> +
>>> +static const struct tsl2x7x_lux tsl2x72_lux_table[] = {
>>> +	{ 14013,   466,   917 },
>>> +	{ 18222,   310,   552 },
>>> +	{     0,     0,     0 },
>>> +};
>>> +
>>> +static const struct tsl2x7x_lux tmd2x72_lux_table[] = {
>>> +	{ 13218,   130,   262 },
>>> +	{ 17592,   92,    169 },
>>> +	{     0,     0,     0 },
>>> +};
>>> +
>>> +static const struct tsl2x7x_lux *tsl2x7x_default_lux_table_group[] = {
>> check white space around here.  looks like a mixture of tabs and spaces...
>>> +	[tsl2571] = tsl2x71_lux_table,
>>> +	[tsl2671] =	tsl2x71_lux_table,
>>> +	[tmd2671] =	tmd2x71_lux_table,
>>> +	[tsl2771] =	tsl2x71_lux_table,
>>> +	[tmd2771] =	tmd2x71_lux_table,
>>> +	[tsl2572] =	tsl2x72_lux_table,
>>> +	[tsl2672] =	tsl2x72_lux_table,
>>> +	[tmd2672] = tmd2x72_lux_table,
>>> +	[tsl2772] =	tsl2x72_lux_table,
>>> +	[tmd2772] =	tmd2x72_lux_table,
>>> +};
>>> +
>>> +static const struct tsl2x7x_settings tsl2x7x_default_settings = {
>>> +	.als_time = 200,
>>> +	/* must be a multiple of 50mS */
>>> +	.als_gain = 0,
>>> +	/* this is actually an index into the gain table */
>>> +	.prx_time = 0xfe, /*5.4 mS */
>>> +	/* 2.7ms prox integration time - decrease to increase time */
>>> +	/* decreases in 2.7 ms intervals */
>>> +	.prox_gain = 1,
>>> +	/* these are bits 3:2 of reg 0x0f: 0=x1,1=x2,2=x4,3=x8 */
>>> +	/* assume clear glass as default */
>>> +	.wait_time = 245,
>>> +	/* Time between PRX and ALS cycles -decrease to increase time */
>>> +	/* decreases in 2.7 ms intervals */
>>> +	.prox_config = 0,
>>> +	/* Prox configuration filters */
>>> +	.als_gain_trim = 1000,
>>> +	/* default gain trim to account for aperture effects */
>>> +	.als_cal_target = 150,
>>> +	/* Known external ALS reading used for calibration */
>>> +	.als_thresh_low = 200,
>>> +	/* CH0 'low' count to trigger interrupt */
>>> +	.als_thresh_high = 256,
>>> +	/* CH0 'high' count to trigger interrupt */
>>> +	.als_persistence = 0xFF,
>>> +	/* Number of 'out of limits' ADC readings PRX/ALS*/
>>> +	.interrupts_en = 0x00,
>>> +	/* Default interrupt(s) enabled.
>>> +	 * 0x00 = none, 0x10 = als, 0x20 = prx 0x30 = bth */
>>> +	.prox_thres_low  = 0,
>>> +	.prox_thres_high = 512,
>>> +	/*default threshold adjust either manually or with cal routine*/
>>> +	.prox_max_samples_cal = 30,
>>> +	.prox_pulse_count = 8
>>> +};
>>> +
>>> +static const s16 tsl2X7X_als_gainadj[] = {
>>> +	1,
>>> +	8,
>>> +	16,
>>> +	120
>>> +};
>>> +
>>> +static const s16 tsl2X7X_prx_gainadj[] = {
>>> +	1,
>>> +	2,
>>> +	4,
>>> +	8
>>> +};
>>> +
>>> +/* Channel variations */
>>> +enum {
>>> +	ALS,
>>> +	PRX,
>>> +	ALSPRX,
>>> +	PRX2,
>>> +	ALSPRX2,
>>> +};
>>> +
>>> +const u8 device_channel_config[] = {
>>> +	ALS,
>>> +	PRX,
>>> +	PRX,
>>> +	ALSPRX,
>>> +	ALSPRX,
>>> +	ALS,
>>> +	PRX2,
>>> +	PRX2,
>>> +	ALSPRX2,
>>> +	ALSPRX2
>>> +};
>>> +
>>> +/*
>>> + * Read a number of bytes starting at register (reg) location.
>>> + * Return 0, or i2c_smbus_write_byte ERROR code.
>>> + */
>>> +static int
>>> +tsl2x7x_i2c_read(struct i2c_client *client, u8 reg, u8 *val)
>>> +{
>>> +	int ret;
>>> +
>>> +	/* select register to write */
>>> +	ret = i2c_smbus_write_byte(client, (TSL2X7X_CMD_REG | reg));
>>> +	if (ret<  0) {
>>> +		dev_err(&client->dev, "%s: failed to write register %x\n"
>>> +				, __func__, reg);
>>> +		return ret;
>>> +	}
>>> +	/* read the data */
>>> +	*val = i2c_smbus_read_byte(client);
>>> +
>>> +	return 0;
>>> +}
>>> +
>> I would much prefer if you'd use kernel-doc for comments oabout functions.
>>> +/*
>>> + * Reads and calculates current lux value.
>>> + * The raw ch0 and ch1 values of the ambient light sensed in the last
>>> + * integration cycle are read from the device.
>>> + * Time scale factor array values are adjusted based on the integration time.
>>> + * The raw values are multiplied by a scale factor, and device gain is obtained
>>> + * using gain index. Limit checks are done next, then the ratio of a multiple
>>> + * of ch1 value, to the ch0 value, is calculated. The array tsl2x7x_device_lux[]
>>> + * declared above is then scanned to find the first ratio value that is just
>>> + * above the ratio we just calculated. The ch0 and ch1 multiplier constants in
>>> + * the array are then used along with the time scale factor array values, to
>>> + * calculate the lux.
>>> + */
>>> +static int tsl2x7x_get_lux(struct iio_dev *indio_dev)
>>> +{
>>> +	u16 ch0, ch1; /* separated ch0/ch1 data from device */
>>> +	u32 lux; /* raw lux calculated from device data */
>>> +	u64 lux64;
>>> +	u32 ratio;
>>> +	u8 buf[4];
>>> +	struct tsl2x7x_lux *p;
>>> +	struct tsl2X7X_chip *chip = iio_priv(indio_dev);
>>> +	int i, ret;
>>> +	u32 ch0lux = 0;
>>> +	u32 ch1lux = 0;
>>> +
>>> +	if (mutex_trylock(&chip->als_mutex) == 0) {
>>> +		dev_info(&chip->client->dev, "tsl2x7x_get_lux device is
>> busy\n");
>>> +		return chip->als_cur_info.lux; /* busy, so return LAST VALUE */
>>> +	}
>>> +
>>> +	if (chip->tsl2x7x_chip_status != TSL2X7X_CHIP_WORKING) {
>>> +		/* device is not enabled */
>>> +		dev_err(&chip->client->dev, "%s: device is not enabled\n",
>>> +				__func__);
>>> +		ret = -EBUSY ;
>>> +		goto out_unlock;
>>> +	}
>>> +
>>> +	ret = tsl2x7x_i2c_read(chip->client,
>>> +		(TSL2X7X_CMD_REG | TSL2X7X_STATUS),&buf[0]);
>>> +	if (ret<  0) {
>>> +		dev_err(&chip->client->dev,
>>> +			"%s: failed to read CMD_REG\n", __func__);
>>> +		goto out_unlock;
>>> +	}
>>> +	/* is data new&  valid */
>>> +	if (!(buf[0]&  TSL2X7X_STA_ADC_VALID)) {
>>> +		dev_err(&chip->client->dev,
>>> +			"%s: data not valid yet\n", __func__);
>>> +		ret = chip->als_cur_info.lux; /* return LAST VALUE */
>>> +		goto out_unlock;
>>> +	}
>>> +
>>> +	for (i = 0; i<  4; i++) {
>>> +		ret = tsl2x7x_i2c_read(chip->client,
>>> +			(TSL2X7X_CMD_REG | (TSL2X7X_ALS_CHAN0LO + i)),
>>> +			&buf[i]);
>>> +		if (ret<  0) {
>>> +			dev_err(&chip->client->dev,
>>> +				"%s: failed to read. err=%x\n", __func__, ret);
>>> +			goto out_unlock;
>>> +		}
>>> +	}
>>> +
>>> +	/* clear status, really interrupt status ( are off),
>>> +	but we use the bit anyway */
>>> +	ret = i2c_smbus_write_byte(chip->client,
>>> +		(TSL2X7X_CMD_REG |
>>> +				TSL2X7X_CMD_SPL_FN |
>>> +				TSL2X7X_CMD_ALS_INT_CLR));
>>> +
>>> +	if (ret<  0) {
>>> +		dev_err(&chip->client->dev,
>>> +		"i2c_write_command failed in %s, err = %d\n",
>>> +			__func__, ret);
>>> +		goto out_unlock; /* have no data, so return failure */
>>> +	}
>>> +
>>> +	/* extract ALS/lux data */
>>> +	ch0 = le16_to_cpup((const __le16 *)&buf[0]);
>>> +	ch1 = le16_to_cpup((const __le16 *)&buf[2]);
>>> +
>>> +	chip->als_cur_info.als_ch0 = ch0;
>>> +	chip->als_cur_info.als_ch1 = ch1;
>>> +
>>> +	if ((ch0>= chip->als_saturation) || (ch1>= chip->als_saturation)) {
>>> +		lux = TSL2X7X_LUX_CALC_OVER_FLOW;
>>> +		goto return_max;
>>> +	}
>>> +
>>> +	if (ch0 == 0) {
>>> +		/* have no data, so return LAST VALUE */
>>> +		ret = chip->als_cur_info.lux = 0;
>>> +		goto out_unlock;
>>> +	}
>>> +	/* calculate ratio */
>>> +	ratio = (ch1<<  15) / ch0;
>>> +	/* convert to unscaled lux using the pointer to the table */
>>> +	p = (struct tsl2x7x_lux *) chip->tsl2x7x_device_lux;
>>> +	while (p->ratio != 0&&  p->ratio<  ratio)
>>> +			p++;
>>> +
>>> +	if (p->ratio == 0) {
>>> +		lux = 0;
>>> +	} else {
>>> +		ch0lux = DIV_ROUND_UP((ch0 * p->ch0),
>>> +			tsl2X7X_als_gainadj[chip->tsl2x7x_settings.als_gain]);
>>> +		ch1lux = DIV_ROUND_UP((ch1 * p->ch1),
>>> +			tsl2X7X_als_gainadj[chip->tsl2x7x_settings.als_gain]);
>>> +		lux = ch0lux - ch1lux;
>>> +	}
>>> +
>>> +	/* note: lux is 31 bit max at this point */
>>> +	if (ch1lux>  ch0lux) {
>>> +		dev_dbg(&chip->client->dev, "Returning last value\n");
>>> +		ret = chip->als_cur_info.lux;
>>> +		goto out_unlock;
>>> +	}
>>> +
>>> +	/* adjust for active time scale */
>>> +	if (chip->als_time_scale == 0)
>>> +		lux = 0;
>>> +	else
>>> +		lux = (lux + (chip->als_time_scale>>  1)) /
>>> +			chip->als_time_scale;
>>> +
>>> +	/* adjust for active gain scale
>>> +	 * The tsl2x7x_device_lux tables have a factor of 256 built-in.
>>> +	 * User-specified gain provides a multiplier.
>>> +	 * Apply user-specified gain before shifting right to retain precision.
>>> +	 * Use 64 bits to avoid overflow on multiplication.
>>> +	 * Then go back to 32 bits before division to avoid using div_u64().
>>> +	 */
>>> +	lux64 = lux;
>>> +	lux64 = lux64 * chip->tsl2x7x_settings.als_gain_trim;
>>> +	lux64>>= 8;
>>> +	lux = lux64;
>>> +	lux = (lux + 500) / 1000;
>>> +
>>> +	if (lux>  TSL2X7X_LUX_CALC_OVER_FLOW) /* check for overflow */
>>> +		lux = TSL2X7X_LUX_CALC_OVER_FLOW;
>>> +
>>> +	/* Update the structure with the latest lux. */
>>> +return_max:
>>> +	chip->als_cur_info.lux = lux;
>>> +	ret = lux;
>>> +
>>> +out_unlock:
>>> +	mutex_unlock(&chip->als_mutex);
>>> +
>>> +	return ret;
>>> +}
>>> +
>>> +/*
>>> + * Proximity poll function - if valid data is available, read and form the ch0
>>> + * and prox data values, check for limits on the ch0 value, and check the prox
>>> + * data against the current thresholds, to set the event status accordingly.
>>> + */
>>> +static int tsl2x7x_prox_poll(struct iio_dev *indio_dev)
>>> +{
>>> +#define CONSECUTIVE_RETRIES 50
>>> +
>>> +	int i;
>>> +	int ret;
>>> +	u8 status;
>>> +	u8 chdata[2];
>>> +	int err_cnt;
>>> +	struct tsl2X7X_chip *chip = iio_priv(indio_dev);
>>> +
>>> +	if (mutex_trylock(&chip->prox_mutex) == 0) {
>>> +		dev_err(&chip->client->dev,
>>> +			"%s: Can't get prox mutex\n", __func__);
>>> +		return -EBUSY;
>>> +	}
>>> +
>>> +	err_cnt = 0;
>>> +
>>> +try_again:
>> I'd like a comment on why this looping is necessary....
>>> +
>>> +	ret = tsl2x7x_i2c_read(chip->client,
>>> +		(TSL2X7X_CMD_REG | TSL2X7X_STATUS),&status);
>>> +	if (ret<  0) {
>>> +		dev_err(&chip->client->dev,
>>> +		"%s: i2c err=%d\n", __func__, ret);
>>> +		goto prox_poll_err;
>>> +	}
>>> +
>>> +	if (chip->id<  tsl2572) {
>>> +		if (!(status&  TSL2X7X_STA_ADC_VALID)) {
>>> +			err_cnt++;
>>> +			if (err_cnt>  CONSECUTIVE_RETRIES) {
>>> +				dev_err(&chip->client->dev,
>>> +				"%s: Consec. retries exceeded\n", __func__);
>>> +				goto prox_poll_err;
>>> +			}
>>> +		goto try_again;
>>> +		}
>>> +	} else {
>>> +		if (!(status&  TSL2X7X_STA_PRX_VALID)) {
>>> +			err_cnt++;
>>> +			if (err_cnt>  CONSECUTIVE_RETRIES) {
>>> +				dev_err(&chip->client->dev,
>>> +				"%s: Consec. retries exceeded\n", __func__);
>>> +				goto prox_poll_err;
>>> +			}
>>> +		goto try_again;
>>> +		}
>>> +	}
>>> +
>>> +	for (i = 0; i<  2; i++) {
>>> +		ret = tsl2x7x_i2c_read(chip->client,
>>> +			(TSL2X7X_CMD_REG |
>>> +					(TSL2X7X_PRX_LO + i)),&chdata[i]);
>>> +		if (ret<  0)
>>> +			goto prox_poll_err;
>>> +	}
>>> +
>>> +	chip->prox_cur_info.prox_data = (chdata[1]<<8)|chdata[0];
>>> +	if (chip->prox_cur_info.prox_data == 0)
>>> +		goto try_again;
>>> +
>>> +	if (chip->prox_cur_info.prox_data>=
>>> +			chip->tsl2x7x_settings.prox_thres_high)
>>> +		chip->prox_cur_info.prox_event = 1;
>>> +	else
>>> +		chip->prox_cur_info.prox_event = 0;
>> So this is manually polling the event signal. I'd argue that this is a
>> job for userspace
>> if the device isn't doing it hardware (or the interrupt signal is
>> connected).
>>> +
>>> +	mutex_unlock(&chip->prox_mutex);
>>> +	return chip->prox_cur_info.prox_event;
>>> +
>>> +prox_poll_err:
>>> +	mutex_unlock(&chip->prox_mutex);
>>> +
>>> +	return ret;
>>> +}
>>> +
>>> +/*
>>> + * Provides initial operational parameter defaults.
>>> + * These defaults may be changed through the device's sysfs files.
>>> + */
>>> +static void tsl2x7x_defaults(struct tsl2X7X_chip *chip)
>>> +{
>>> +	/* If Operational settings defined elsewhere.. */
>>> +	if (chip->pdata&&  chip->pdata->platform_default_settings != 0)
>>> +		memcpy(&(chip->tsl2x7x_settings),
>>> +			chip->pdata->platform_default_settings,
>>> +			sizeof(tsl2x7x_default_settings));
>>> +	else
>>> +		memcpy(&(chip->tsl2x7x_settings),
>>> +			&tsl2x7x_default_settings,
>>> +			sizeof(tsl2x7x_default_settings));
>>> +
>>> +	/* Load up the proper lux table. */
>>> +	if (chip->pdata&&  chip->pdata->platform_lux_table[0].ratio != 0)
>>> +		memcpy(chip->tsl2x7x_device_lux,
>>> +			chip->pdata->platform_lux_table,
>>> +			sizeof(chip->pdata->platform_lux_table));
>>> +	else
>>> +		memcpy(chip->tsl2x7x_device_lux,
>>> +		(struct tsl2x7x_lux *)tsl2x7x_default_lux_table_group[chip->id],
>>> +				MAX_DEFAULT_TABLE_BYTES);
>>> +
>>> +}
>>> +
>>> +/*
>>> + * Obtain single reading and calculate the als_gain_trim
>>> + * (later used to derive actual lux).
>>> + * Return updated gain_trim value.
>>> + */
>>> +static int tsl2x7x_als_calibrate(struct iio_dev *indio_dev)
>>> +{
>>> +	struct tsl2X7X_chip *chip = iio_priv(indio_dev);
>>> +	u8 reg_val;
>>> +	int gain_trim_val;
>>> +	int ret;
>>> +	int lux_val;
>>> +
>>> +	ret = i2c_smbus_write_byte(chip->client,
>>> +			(TSL2X7X_CMD_REG | TSL2X7X_CNTRL));
>>> +	if (ret<  0) {
>>> +		dev_err(&chip->client->dev,
>>> +		"%s: failed to write CNTRL register, ret=%d\n",
>>> +		__func__, ret);
>>> +		return ret;
>>> +	}
>>> +
>>> +	reg_val = i2c_smbus_read_byte(chip->client);
>>> +	if ((reg_val&  (TSL2X7X_CNTL_ADC_ENBL | TSL2X7X_CNTL_PWR_ON))
>>> +		!= (TSL2X7X_CNTL_ADC_ENBL | TSL2X7X_CNTL_PWR_ON)) {
>>> +		dev_err(&chip->client->dev,
>>> +			"%s: failed: ADC not enabled\n", __func__);
>>> +		return -1;
>>> +	}
>>> +
>>> +	ret = i2c_smbus_write_byte(chip->client,
>>> +			(TSL2X7X_CMD_REG | TSL2X7X_CNTRL));
>>> +	if (ret<  0) {
>>> +		dev_err(&chip->client->dev,
>>> +			"%s: failed to write ctrl reg: ret=%d\n",
>>> +			__func__, ret);
>>> +		return ret;
>>> +	}
>>> +
>>> +	reg_val = i2c_smbus_read_byte(chip->client);
>>> +	if ((reg_val&  TSL2X7X_STA_ADC_VALID) != TSL2X7X_STA_ADC_VALID) {
>>> +		dev_err(&chip->client->dev,
>>> +			"%s: failed: STATUS - ADC not valid.\n", __func__);
>>> +		return -ENODATA;
>>> +	}
>>> +
>>> +	lux_val = tsl2x7x_get_lux(indio_dev);
>>> +	if (lux_val<  0) {
>>> +		dev_err(&chip->client->dev,
>>> +		"%s: failed to get lux\n", __func__);
>>> +		return lux_val;
>>> +	}
>>> +
>>> +	gain_trim_val =  (((chip->tsl2x7x_settings.als_cal_target)
>>> +			* chip->tsl2x7x_settings.als_gain_trim) / lux_val);
>>> +	if ((gain_trim_val<  250) || (gain_trim_val>  4000))
>>> +		return -ERANGE;
>>> +
>>> +	chip->tsl2x7x_settings.als_gain_trim = gain_trim_val;
>>> +	dev_info(&chip->client->dev,
>>> +		"%s als_calibrate completed\n", chip->client->name);
>>> +
>>> +	return (int) gain_trim_val;
>>> +}
>>> +
>>> +/*
>>> + * Turn the device on.
>>> + * Configuration must be set before calling this function.
>>> + */
>>> +static int tsl2x7x_chip_on(struct iio_dev *indio_dev)
>>> +{
>>> +	int i;
>>> +	int ret = 0;
>>> +	u8 *dev_reg;
>>> +	u8 utmp;
>>> +	int als_count;
>>> +	int als_time;
>>> +	struct tsl2X7X_chip *chip = iio_priv(indio_dev);
>>> +	u8 reg_val = 0;
>>> +
>>> +	if (chip->pdata&&  chip->pdata->power_on)
>>> +		chip->pdata->power_on(indio_dev);
>>> +
>>> +	/* Non calculated parameters */
>>> +	chip->tsl2x7x_config[TSL2X7X_PRX_TIME] =
>>> +			chip->tsl2x7x_settings.prx_time;
>>> +	chip->tsl2x7x_config[TSL2X7X_WAIT_TIME] =
>>> +			chip->tsl2x7x_settings.wait_time;
>>> +	chip->tsl2x7x_config[TSL2X7X_PRX_CONFIG] =
>>> +			chip->tsl2x7x_settings.prox_config;
>>> +
>>> +	chip->tsl2x7x_config[TSL2X7X_ALS_MINTHRESHLO] =
>>> +		(chip->tsl2x7x_settings.als_thresh_low)&  0xFF;
>>> +	chip->tsl2x7x_config[TSL2X7X_ALS_MINTHRESHHI] =
>>> +		(chip->tsl2x7x_settings.als_thresh_low>>  8)&  0xFF;
>>> +	chip->tsl2x7x_config[TSL2X7X_ALS_MAXTHRESHLO] =
>>> +		(chip->tsl2x7x_settings.als_thresh_high)&  0xFF;
>>> +	chip->tsl2x7x_config[TSL2X7X_ALS_MAXTHRESHHI] =
>>> +		(chip->tsl2x7x_settings.als_thresh_high>>  8)&  0xFF;
>>> +	chip->tsl2x7x_config[TSL2X7X_PERSISTENCE] =
>>> +		chip->tsl2x7x_settings.als_persistence;
>>> +
>>> +	chip->tsl2x7x_config[TSL2X7X_PRX_COUNT] =
>>> +			chip->tsl2x7x_settings.prox_pulse_count;
>>> +	chip->tsl2x7x_config[TSL2X7X_PRX_MINTHRESHLO] =
>>> +	chip->tsl2x7x_settings.prox_thres_low;
>>> +	chip->tsl2x7x_config[TSL2X7X_PRX_MAXTHRESHLO] =
>>> +			chip->tsl2x7x_settings.prox_thres_high;
>>> +
>>> +	/* and make sure we're not already on */
>>> +	if (chip->tsl2x7x_chip_status == TSL2X7X_CHIP_WORKING) {
>>> +		/* if forcing a register update - turn off, then on */
>>> +		dev_info(&chip->client->dev, "device is already enabled\n");
>>> +		return -EINVAL;
>>> +	}
>>> +
>>> +	/* determine als integration regster */
>>> +	als_count = (chip->tsl2x7x_settings.als_time * 100 + 135) / 270;
>>> +	if (als_count == 0)
>>> +		als_count = 1; /* ensure at least one cycle */
>>> +
>>> +	/* convert back to time (encompasses overrides) */
>>> +	als_time = (als_count * 27 + 5) / 10;
>>> +	chip->tsl2x7x_config[TSL2X7X_ALS_TIME] = 256 - als_count;
>>> +
>>> +	/* Set the gain based on tsl2x7x_settings struct */
>>> +	chip->tsl2x7x_config[TSL2X7X_GAIN] =
>>> +		(chip->tsl2x7x_settings.als_gain |
>>> +			(TSL2X7X_mA100 | TSL2X7X_DIODE1)
>>> +			| ((chip->tsl2x7x_settings.prox_gain)<<  2));
>>> +
>>> +	/* set chip struct re scaling and saturation */
>>> +	chip->als_saturation = als_count * 922; /* 90% of full scale */
>>> +	chip->als_time_scale = (als_time + 25) / 50;
>>> +
>>> +	/* TSL2X7X Specific power-on / adc enable sequence
>>> +	 * Power on the device 1st. */
>>> +	utmp = TSL2X7X_CNTL_PWR_ON;
>>> +	ret = i2c_smbus_write_byte_data(chip->client,
>>> +		TSL2X7X_CMD_REG | TSL2X7X_CNTRL, utmp);
>>> +	if (ret<  0) {
>>> +		dev_err(&chip->client->dev,
>>> +			"%s: failed on CNTRL reg.\n", __func__);
>>> +		return -1;
>>> +	}
>>> +
>>> +	/* Use the following shadow copy for our delay before enabling ADC.
>>> +	 * Write all the registers. */
>>> +	for (i = 0, dev_reg = chip->tsl2x7x_config;
>>> +			i<  TSL2X7X_MAX_CONFIG_REG; i++) {
>>> +		ret = i2c_smbus_write_byte_data(chip->client,
>>> +				TSL2X7X_CMD_REG + i, *dev_reg++);
>>> +		if (ret<  0) {
>>> +			dev_err(&chip->client->dev,
>>> +			"%s: failed on write to reg %d.\n", __func__, i);
>>> +			return ret;
>>> +		}
>>> +	}
>>> +
>>> +	udelay(3000);	/* Power-on settling time */
>>> +
>>> +	/* NOW enable the ADC
>>> +	 * initialize the desired mode of operation */
>>> +	utmp = TSL2X7X_CNTL_PWR_ON |
>>> +			TSL2X7X_CNTL_ADC_ENBL |
>>> +			TSL2X7X_CNTL_PROX_DET_ENBL;
>>> +	ret = i2c_smbus_write_byte_data(chip->client,
>>> +			TSL2X7X_CMD_REG | TSL2X7X_CNTRL, utmp);
>>> +	if (ret<  0) {
>>> +		dev_err(&chip->client->dev,
>>> +			"%s: failed on 2nd CTRL reg.\n", __func__);
>>> +		return ret;
>>> +		}
>>> +
>>> +	chip->tsl2x7x_chip_status = TSL2X7X_CHIP_WORKING;
>>> +
>>> +	if (chip->tsl2x7x_settings.interrupts_en != 0) {
>>> +		dev_info(&chip->client->dev, "Setting Up Interrupt(s)\n");
>>> +
>>> +		reg_val = TSL2X7X_CNTL_PWR_ON |
>> TSL2X7X_CNTL_ADC_ENBL;
>>> +		if ((chip->tsl2x7x_settings.interrupts_en == 0x20) ||
>>> +			(chip->tsl2x7x_settings.interrupts_en == 0x30))
>>> +			reg_val |= TSL2X7X_CNTL_PROX_DET_ENBL;
>>> +
>>> +		reg_val |= chip->tsl2x7x_settings.interrupts_en;
>>> +		ret = i2c_smbus_write_byte_data(chip->client,
>>> +			(TSL2X7X_CMD_REG | TSL2X7X_CNTRL), reg_val);
>>> +		if (ret<  0)
>>> +			dev_err(&chip->client->dev,
>>> +				"%s: failed in tsl2x7x_IOCTL_INT_SET.\n",
>>> +				__func__);
>>> +
>>> +		/* Clear out any initial interrupts  */
>>> +		ret = i2c_smbus_write_byte(chip->client,
>>> +			TSL2X7X_CMD_REG | TSL2X7X_CMD_SPL_FN |
>>> +			TSL2X7X_CMD_PROXALS_INT_CLR);
>>> +		if (ret<  0) {
>>> +			dev_err(&chip->client->dev,
>>> +				"%s: failed in tsl2x7x_chip_on\n",
>>> +				__func__);
>>> +		return ret;
>>> +		}
>>> +	}
>>> +
>>> +	return ret;
>>> +}
>>> +
>>> +static int tsl2x7x_chip_off(struct iio_dev *indio_dev)
>>> +{
>>> +	int ret;
>>> +	struct tsl2X7X_chip *chip = iio_priv(indio_dev);
>>> +
>>> +	/* turn device off */
>>> +	chip->tsl2x7x_chip_status = TSL2X7X_CHIP_SUSPENDED;
>>> +
>>> +	ret = i2c_smbus_write_byte_data(chip->client,
>>> +		TSL2X7X_CMD_REG | TSL2X7X_CNTRL, 0x00);
>>> +
>>> +	if (chip->pdata&&  chip->pdata->power_off)
>>> +		chip->pdata->power_off(chip->client);
>>> +
>>> +	return ret;
>>> +}
>>> +
>>> +/*
>>> + * Proximity calibration helper function
>>> + * runs through a collection of data samples,
>>> + * sets the min, max, mean, and std dev.
>>> + */
>>> +static
>>> +void tsl2x7x_prox_calculate(u16 *data, int length, struct prox_stat *statP)
>>> +{
>>> +	int i;
>>> +	int min, max, sum, mean;
>>> +	unsigned long stddev;
>>> +	int tmp;
>>> +
>>> +	if (length == 0)
>>> +		length = 1;
>>> +
>>> +	sum = 0;
>>> +	min = INT_MAX;
>>> +	max = INT_MIN;
>>> +	for (i = 0; i<  length; i++) {
>>> +		sum += data[i];
>> avoid using min as a variable name (as it's also an appropriate function)
>> _min = MIN(data[i], _min); saves you a line of code.
>>> +		if (data[i]<  min)
>>> +			min = data[i];
>>> +		if (data[i]>  max)
>>> +			max = data[i];
>>> +	}
>>> +	mean = sum/length;
>>> +	statP->min = min;
>>> +	statP->max = max;
>>> +	statP->mean = mean;
>>> +
>>> +	sum = 0;
>>> +	for (i = 0; i<  length; i++) {
>>> +		tmp = data[i]-mean;
>>> +		sum += tmp * tmp;
>>> +	}
>>> +	stddev = int_sqrt((long)sum)/length;
>>> +	statP->stddev = stddev;
>>> +}
>>> +
>>> +/**
>>> + * Proximity calibration - collects a number of samples,
>>> + * calculates a standard deviation based on the samples, and
>>> + * sets the threshold accordingly.
>>> + */
>>> +static void tsl2x7x_prox_cal(struct iio_dev *indio_dev)
>>> +{
>>> +	u16 prox_history[MAX_SAMPLES_CAL+1];
>> spaces around that +
>>> +	int i;
>>> +	struct prox_stat prox_stat_data[2];
>>> +	struct prox_stat *calP;
>>> +	struct tsl2X7X_chip *chip = iio_priv(indio_dev);
>>> +	u8 tmp_irq_settings;
>>> +	u8 current_state = chip->tsl2x7x_chip_status;
>>> +
>>> +	if (chip->tsl2x7x_settings.prox_max_samples_cal>  MAX_SAMPLES_CAL)
>> {
>>> +		dev_err(&chip->client->dev,
>>> +			"%s: max prox samples cal is too big: %d\n",
>>> +			__func__, chip-
>>> tsl2x7x_settings.prox_max_samples_cal);
>>> +		chip->tsl2x7x_settings.prox_max_samples_cal =
>> MAX_SAMPLES_CAL;
>>> +	}
>>> +
>>> +	/* have to stop to change settings */
>>> +	tsl2x7x_chip_off(indio_dev);
>>> +
>>> +	/* Enable proximity detection save just in case prox not wanted yet*/
>>> +	tmp_irq_settings = chip->tsl2x7x_settings.interrupts_en;
>>> +	chip->tsl2x7x_settings.interrupts_en |=
>> TSL2X7X_CNTL_PROX_INT_ENBL;
>>> +
>>> +	/*turn on device if not already on*/
>>> +	tsl2x7x_chip_on(indio_dev);
>>> +
>>> +	/*gather the samples*/
>>> +	for (i = 0; i<  chip->tsl2x7x_settings.prox_max_samples_cal; i++) {
>>> +		mdelay(15);
>>> +		tsl2x7x_prox_poll(indio_dev);
>>> +		prox_history[i] = chip->prox_cur_info.prox_data;
>>> +		dev_info(&chip->client->dev, "2 i=%d prox data= %d\n",
>>> +			i, chip->prox_cur_info.prox_data);
>>> +	}
>>> +
>>> +	tsl2x7x_chip_off(indio_dev);
>>> +	calP =&prox_stat_data[PROX_STAT_CAL];
>>> +	tsl2x7x_prox_calculate(prox_history,
>>> +		chip->tsl2x7x_settings.prox_max_samples_cal, calP);
>>> +	chip->tsl2x7x_settings.prox_thres_high = (calP->max<<  1) - calP-
>>> mean;
>>> +
>>> +	dev_info(&chip->client->dev, " cal min=%d mean=%d max=%d\n",
>>> +		calP->min, calP->mean, calP->max);
>>> +	dev_info(&chip->client->dev,
>>> +		"%s proximity threshold set to %d\n",
>>> +		chip->client->name, chip->tsl2x7x_settings.prox_thres_high);
>>> +
>>> +	/* back to the way they were */
>>> +	chip->tsl2x7x_settings.interrupts_en = tmp_irq_settings;
>>> +	if (current_state == TSL2X7X_CHIP_WORKING)
>>> +		tsl2x7x_chip_on(indio_dev);
>>> +}
>>> +
>>> +static ssize_t tsl2x7x_power_state_show(struct device *dev,
>>> +	struct device_attribute *attr, char *buf)
>>> +{
>>> +	struct iio_dev *indio_dev = dev_get_drvdata(dev);
>>> +	struct tsl2X7X_chip *chip = iio_priv(indio_dev);
>>> +
>>> +	return snprintf(buf, PAGE_SIZE, "%d\n", chip->tsl2x7x_chip_status);
>>> +}
>>> +
>>> +static ssize_t tsl2x7x_power_state_store(struct device *dev,
>>> +	struct device_attribute *attr, const char *buf, size_t len)
>>> +{
>>> +	struct iio_dev *indio_dev = dev_get_drvdata(dev);
>>> +	bool value;
>>> +
>>> +	if (strtobool(buf,&value))
>>> +		return -EINVAL;
>>> +
>>> +	if (!value)
>>> +		tsl2x7x_chip_off(indio_dev);
>>> +	else
>>> +		tsl2x7x_chip_on(indio_dev);
>>> +
>>> +	return len;
>>> +}
>>> +
>>> +static ssize_t tsl2x7x_gain_available_show(struct device *dev,
>>> +	struct device_attribute *attr, char *buf)
>>> +{
>>> +	struct iio_dev *indio_dev = dev_get_drvdata(dev);
>>> +	struct tsl2X7X_chip *chip = iio_priv(indio_dev);
>>> +
>>> +	if (chip->id>  tsl2771)
>>> +		return snprintf(buf, PAGE_SIZE, "%s\n", "1 8 16 128");
>>> +	else
>>> +		return snprintf(buf, PAGE_SIZE, "%s\n", "1 8 16 120");
>>> +}
>>> +
>>> +static ssize_t tsl2x7x_prox_gain_available_show(struct device *dev,
>>> +	struct device_attribute *attr, char *buf)
>>> +{
>>> +		return snprintf(buf, PAGE_SIZE, "%s\n", "1 2 4 8");
>>> +}
>>> +
>>> +static ssize_t tsl2x7x_als_time_show(struct device *dev,
>>> +	struct device_attribute *attr, char *buf)
>>> +{
>>> +	struct iio_dev *indio_dev = dev_get_drvdata(dev);
>>> +	struct tsl2X7X_chip *chip = iio_priv(indio_dev);
>>> +
>>> +	return snprintf(buf, PAGE_SIZE, "%d\n",
>>> +			chip->tsl2x7x_settings.als_time);
>>> +}
>>> +
>>> +static ssize_t tsl2x7x_als_time_store(struct device *dev,
>>> +	struct device_attribute *attr, const char *buf, size_t len)
>>> +{
>>> +	struct iio_dev *indio_dev = dev_get_drvdata(dev);
>>> +	struct tsl2X7X_chip *chip = iio_priv(indio_dev);
>>> +	unsigned long value;
>>> +
>>> +	if (kstrtoul(buf, 0,&value))
>>> +		return -EINVAL;
>>> +
>>> +	if ((value<  50) || (value>  650))
>>> +		return -EINVAL;
>>> +
>>> +	if (value % 50)
>>> +		return -EINVAL;
>>> +
>>> +	 chip->tsl2x7x_settings.als_time = value;
>>> +
>>> +	return len;
>>> +}
>>> +
>>> +static IIO_CONST_ATTR(illuminance0_integration_time_available,
>>> +		"50 100 150 200 250 300 350 400 450 500 550 600 650");
>>> +
>>> +static ssize_t tsl2x7x_als_cal_target_show(struct device *dev,
>>> +	struct device_attribute *attr, char *buf)
>>> +{
>>> +	struct iio_dev *indio_dev = dev_get_drvdata(dev);
>>> +	struct tsl2X7X_chip *chip = iio_priv(indio_dev);
>>> +
>>> +	return snprintf(buf, PAGE_SIZE, "%d\n",
>>> +			chip->tsl2x7x_settings.als_cal_target);
>>> +}
>>> +
>>> +static ssize_t tsl2x7x_als_cal_target_store(struct device *dev,
>>> +	struct device_attribute *attr, const char *buf, size_t len)
>>> +{
>>> +	struct iio_dev *indio_dev = dev_get_drvdata(dev);
>>> +	struct tsl2X7X_chip *chip = iio_priv(indio_dev);
>>> +	unsigned long value;
>>> +
>>> +	if (kstrtoul(buf, 0,&value))
>>> +		return -EINVAL;
>>> +
>>> +	if (value)
>>> +		chip->tsl2x7x_settings.als_cal_target = value;
>>> +
>>> +	return len;
>>> +}
>>> +
>>> +/* sampling_frequency AKA persistence in data sheet */
>>> +static ssize_t tsl2x7x_als_persistence_show(struct device *dev,
>>> +	struct device_attribute *attr, char *buf)
>>> +{
>>> +	struct iio_dev *indio_dev = dev_get_drvdata(dev);
>>> +	struct tsl2X7X_chip *chip = iio_priv(indio_dev);
>>> +
>>> +	return snprintf(buf, PAGE_SIZE, "%d\n",
>>> +			chip->tsl2x7x_settings.als_persistence);
>>> +}
>>> +
>>> +static ssize_t tsl2x7x_als_persistence_store(struct device *dev,
>>> +	struct device_attribute *attr, const char *buf, size_t len)
>>> +{
>>> +	struct iio_dev *indio_dev = dev_get_drvdata(dev);
>>> +	struct tsl2X7X_chip *chip = iio_priv(indio_dev);
>>> +	unsigned long value;
>>> +
>>> +	if (kstrtoul(buf, 0,&value))
>>> +		return -EINVAL;
>>> +
>>> +	chip->tsl2x7x_settings.als_persistence = value;
>>> +
>>> +	return len;
>>> +}
>>> +
>>> +static IIO_CONST_ATTR(sampling_frequency_available,
>>> +		"0x00 - 0xFF (0 - 255)");
>>> +
>>> +static ssize_t tsl2x7x_do_calibrate(struct device *dev,
>>> +	struct device_attribute *attr, const char *buf, size_t len)
>>> +{
>>> +	struct iio_dev *indio_dev = dev_get_drvdata(dev);
>>> +	bool value;
>>> +
>>> +	if (strtobool(buf,&value))
>>> +		return -EINVAL;
>>> +
>>> +	if (value)
>>> +		tsl2x7x_als_calibrate(indio_dev);
>>> +
>>> +	return len;
>>> +}
>>> +
>>> +static ssize_t tsl2x7x_luxtable_show(struct device *dev,
>>> +	struct device_attribute *attr, char *buf)
>>> +{
>>> +	struct iio_dev *indio_dev = dev_get_drvdata(dev);
>>> +	struct tsl2X7X_chip *chip = iio_priv(indio_dev);
>>> +	int i;
>>> +	int offset = 0;
>>> +
>>> +	i = 0;
>> Set i at the declaration above.
>>> +	while (i<  (TSL2X7X_MAX_LUX_TABLE_SIZE * 3)) {
>>> +		offset += snprintf(buf + offset, PAGE_SIZE, "%d,%d,%d,",
>>> +			chip->tsl2x7x_device_lux[i].ratio,
>>> +			chip->tsl2x7x_device_lux[i].ch0,
>>> +			chip->tsl2x7x_device_lux[i].ch1);
>>> +		if (chip->tsl2x7x_device_lux[i].ratio == 0) {
>>> +			/* We just printed the first "0" entry.
>>> +			 * Now get rid of the extra "," and break. */
>>> +			offset--;
>>> +			break;
>>> +		}
>>> +		i++;
>>> +	}
>>> +
>>> +	offset += snprintf(buf + offset, PAGE_SIZE, "\n");
>>> +	return offset;
>>> +}
>>> +
>>> +static ssize_t tsl2x7x_luxtable_store(struct device *dev,
>>> +	struct device_attribute *attr, const char *buf, size_t len)
>>> +{
>>> +	struct iio_dev *indio_dev = dev_get_drvdata(dev);
>>> +	struct tsl2X7X_chip *chip = iio_priv(indio_dev);
>>> +	int value[ARRAY_SIZE(chip->tsl2x7x_device_lux)*3 + 1];
>>> +	int n;
>>> +
>>> +	get_options(buf, ARRAY_SIZE(value), value);
>>> +
>>> +	/* We now have an array of ints starting at value[1], and
>>> +	 * enumerated by value[0].
>>> +	 * We expect each group of three ints is one table entry,
>>> +	 * and the last table entry is all 0.
>>> +	 */
>>> +	n = value[0];
>>> +	if ((n % 3) || n<  6 ||
>>> +			n>  ((ARRAY_SIZE(chip->tsl2x7x_device_lux) - 1) * 3)) {
>>> +		dev_info(dev, "LUX TABLE INPUT ERROR 1 Value[0]=%d\n", n);
>>> +		return -EINVAL;
>>> +	}
>>> +
>>> +	if ((value[(n - 2)] | value[(n - 1)] | value[n]) != 0) {
>>> +		dev_info(dev, "LUX TABLE INPUT ERROR 2 Value[0]=%d\n", n);
>>> +		return -EINVAL;
>>> +	}
>>> +
>>> +	if (chip->tsl2x7x_chip_status == TSL2X7X_CHIP_WORKING)
>>> +		tsl2x7x_chip_off(indio_dev);
>>> +
>>> +	/* Zero out the table */
>>> +	memset(chip->tsl2x7x_device_lux, 0, sizeof(chip->tsl2x7x_device_lux));
>>> +	memcpy(chip->tsl2x7x_device_lux,&value[1], (value[0] * 4));
>>> +
>>> +	return len;
>>> +}
>>> +
>>> +static ssize_t tsl2x7x_do_prox_calibrate(struct device *dev,
>>> +	struct device_attribute *attr, const char *buf, size_t len)
>>> +{
>>> +	struct iio_dev *indio_dev = dev_get_drvdata(dev);
>>> +	bool value;
>>> +
>>> +	if (strtobool(buf,&value))
>>> +		return -EINVAL;
>>> +
>>> +	if (value)
>>> +		tsl2x7x_prox_cal(indio_dev);
>>> +
>>> +	return len;
>>> +}
>>> +
>>> +static int tsl2x7x_read_interrupt_config(struct iio_dev *indio_dev,
>>> +					 u64 event_code)
>>> +{
>>> +	struct tsl2X7X_chip *chip = iio_priv(indio_dev);
>>> +	int ret;
>>> +
>>> +	if (IIO_EVENT_CODE_EXTRACT_CHAN_TYPE(event_code) == IIO_LIGHT)
>>> +		ret = !!(chip->tsl2x7x_settings.interrupts_en&  0x10);
>>> +	else
>>> +		ret = !!(chip->tsl2x7x_settings.interrupts_en&  0x20);
>>> +
>>> +	return ret;
>>> +}
>>> +
>>> +static int tsl2x7x_write_interrupt_config(struct iio_dev *indio_dev,
>>> +					  u64 event_code,
>>> +					  int val)
>>> +{
>>> +	struct tsl2X7X_chip *chip = iio_priv(indio_dev);
>>> +
>>> +	if (IIO_EVENT_CODE_EXTRACT_CHAN_TYPE(event_code) == IIO_LIGHT)
>> {
>>> +		if (val)
>>> +			chip->tsl2x7x_settings.interrupts_en |= 0x10;
>>> +		else
>>> +			chip->tsl2x7x_settings.interrupts_en&= 0x20;
>>> +	} else {
>>> +		if (val)
>>> +			chip->tsl2x7x_settings.interrupts_en |= 0x20;
>>> +		else
>>> +			chip->tsl2x7x_settings.interrupts_en&= 0x10;
>>> +	}
>>> +
>>> +	return 0;
>>> +}
>>> +
>>> +static int tsl2x7x_write_thresh(struct iio_dev *indio_dev,
>>> +				  u64 event_code,
>>> +				  int val)
>>> +{
>>> +	struct tsl2X7X_chip *chip = iio_priv(indio_dev);
>>> +
>>> +	if (IIO_EVENT_CODE_EXTRACT_CHAN_TYPE(event_code) == IIO_LIGHT)
>> {
>>> +		switch (IIO_EVENT_CODE_EXTRACT_DIR(event_code)) {
>>> +		case IIO_EV_DIR_RISING:
>>> +			chip->tsl2x7x_settings.als_thresh_high = val;
>>> +			break;
>>> +		case IIO_EV_DIR_FALLING:
>>> +			chip->tsl2x7x_settings.als_thresh_low = val;
>>> +			break;
>>> +		default:
>>> +			return -EINVAL;
>>> +		}
>>> +	} else {
>>> +		switch (IIO_EVENT_CODE_EXTRACT_DIR(event_code)) {
>>> +		case IIO_EV_DIR_RISING:
>>> +			chip->tsl2x7x_settings.prox_thres_high = val;
>>> +			break;
>>> +		case IIO_EV_DIR_FALLING:
>>> +			chip->tsl2x7x_settings.prox_thres_low = val;
>>> +			break;
>>> +		default:
>>> +			return -EINVAL;
>>> +		}
>>> +	}
>>> +
>>> +	return 0;
>>> +}
>>> +
>>> +static int tsl2x7x_read_thresh(struct iio_dev *indio_dev,
>>> +			       u64 event_code,
>>> +			       int *val)
>>> +{
>>> +	struct tsl2X7X_chip *chip = iio_priv(indio_dev);
>>> +
>>> +	if (IIO_EVENT_CODE_EXTRACT_CHAN_TYPE(event_code) == IIO_LIGHT)
>> {
>>> +		switch (IIO_EVENT_CODE_EXTRACT_DIR(event_code)) {
>>> +		case IIO_EV_DIR_RISING:
>>> +			*val = chip->tsl2x7x_settings.als_thresh_high;
>>> +			break;
>>> +		case IIO_EV_DIR_FALLING:
>>> +			*val = chip->tsl2x7x_settings.als_thresh_low;
>>> +			break;
>>> +		default:
>>> +			return -EINVAL;
>>> +		}
>>> +	} else {
>>> +		switch (IIO_EVENT_CODE_EXTRACT_DIR(event_code)) {
>>> +		case IIO_EV_DIR_RISING:
>>> +			*val = chip->tsl2x7x_settings.prox_thres_high;
>>> +			break;
>>> +		case IIO_EV_DIR_FALLING:
>>> +			*val = chip->tsl2x7x_settings.prox_thres_low;
>>> +			break;
>>> +		default:
>>> +			return -EINVAL;
>>> +		}
>>> +	}
>>> +
>>> +	return 0;
>>> +}
>>> +
>>> +static int tsl2x7x_read_raw(struct iio_dev *indio_dev,
>>> +			    struct iio_chan_spec const *chan,
>>> +			    int *val,
>>> +			    int *val2,
>>> +			    long mask)
>>> +{
>>> +	int ret = -EINVAL;
>>> +	struct tsl2X7X_chip *chip = iio_priv(indio_dev);
>>> +
>>> +	switch (mask) {
>>> +	case 0:
>>> +		switch (chan->type) {
>>> +		case IIO_LIGHT:
>>> +			tsl2x7x_get_lux(indio_dev);
>>> +			if (chan->processed_val)
>>> +				*val = chip->als_cur_info.lux;
>>> +			else
>>> +				*val = (((chip->als_cur_info.als_ch0<<  16) |
>>> +					chip->als_cur_info.als_ch1));
>> Why have a processed read back and a raw readback?
>>> +			ret = IIO_VAL_INT;
>>> +			break;
>>> +		case IIO_PROXIMITY:
>>> +			tsl2x7x_prox_poll(indio_dev);
>>> +			if (chan->processed_val)
>> Hmm.. this is uggly.  We effectively have polling of an event status.
>> Normally
>> I'd expect the event to only occur as a an IIO event rather than being
>> readable like
>> this...
>>> +				*val = chip->prox_cur_info.prox_event;
>>> +			else
>>> +				*val = chip->prox_cur_info.prox_data;
>>> +			ret = IIO_VAL_INT;
>>> +			break;
>>> +		default:
>>> +			return -EINVAL;
>>> +			break;
>>> +		}
>>> +		break;
>>> +	case IIO_CHAN_INFO_CALIBSCALE:
>>> +		if (chan->type == IIO_LIGHT)
>>> +			*val =
>>> +			tsl2X7X_als_gainadj[chip->tsl2x7x_settings.als_gain];
>>> +		else
>>> +			*val =
>>> +			tsl2X7X_prx_gainadj[chip->tsl2x7x_settings.prox_gain];
>>> +		ret = IIO_VAL_INT;
>>> +		break;
>>> +	case IIO_CHAN_INFO_CALIBBIAS:
>>> +		*val = chip->tsl2x7x_settings.als_gain_trim;
>>> +		ret = IIO_VAL_INT;
>>> +		break;
>>> +
>>> +	default:
>>> +		ret = -EINVAL;
>>> +	}
>>> +
>>> +	return ret;
>>> +}
>>> +
>>> +static int tsl2x7x_write_raw(struct iio_dev *indio_dev,
>>> +			       struct iio_chan_spec const *chan,
>>> +			       int val,
>>> +			       int val2,
>>> +			       long mask)
>>> +{
>>> +	struct tsl2X7X_chip *chip = iio_priv(indio_dev);
>>> +
>>> +	switch (mask) {
>>> +	case IIO_CHAN_INFO_CALIBSCALE:
>>> +		if (chan->type == IIO_LIGHT) {
>>> +			switch (val) {
>>> +			case 1:
>>> +				chip->tsl2x7x_settings.als_gain = 0;
>>> +				break;
>>> +			case 8:
>>> +				chip->tsl2x7x_settings.als_gain = 1;
>>> +				break;
>>> +			case 16:
>>> +				chip->tsl2x7x_settings.als_gain = 2;
>>> +				break;
>>> +			case 120:
>>> +				if (chip->id>  tsl2771)
>>> +					return -EINVAL;
>>> +				chip->tsl2x7x_settings.als_gain = 3;
>>> +				break;
>>> +			case 128:
>>> +				if (chip->id<  tsl2572)
>>> +					return -EINVAL;
>>> +				chip->tsl2x7x_settings.als_gain = 3;
>>> +				break;
>>> +			default:
>>> +				return -EINVAL;
>>> +			}
>>> +		} else {
>>> +			switch (val) {
>>> +			case 1:
>>> +				chip->tsl2x7x_settings.prox_gain = 0;
>>> +				break;
>>> +			case 2:
>>> +				chip->tsl2x7x_settings.prox_gain = 1;
>>> +				break;
>>> +			case 4:
>>> +				chip->tsl2x7x_settings.prox_gain = 2;
>>> +				break;
>>> +			case 8:
>>> +				chip->tsl2x7x_settings.prox_gain = 3;
>>> +				break;
>>> +			default:
>>> +				return -EINVAL;
>>> +			}
>>> +		}
>>> +		break;
>>> +	case IIO_CHAN_INFO_CALIBBIAS:
>>> +		chip->tsl2x7x_settings.als_gain_trim = val;
>>> +		break;
>>> +
>>> +	default:
>>> +		return -EINVAL;
>>> +	}
>>> +
>>> +	return 0;
>>> +}
>>> +
>>> +static DEVICE_ATTR(power_state, S_IRUGO | S_IWUSR,
>>> +		tsl2x7x_power_state_show, tsl2x7x_power_state_store);
>>> +
>>> +static DEVICE_ATTR(proximity_calibscale_available, S_IRUGO,
>>> +		tsl2x7x_prox_gain_available_show, NULL);
>>> +
>>> +static DEVICE_ATTR(illuminance0_calibscale_available, S_IRUGO,
>>> +		tsl2x7x_gain_available_show, NULL);
>>> +
>>> +static DEVICE_ATTR(illuminance0_integration_time, S_IRUGO | S_IWUSR,
>>> +		tsl2x7x_als_time_show, tsl2x7x_als_time_store);
>>> +
>>> +static DEVICE_ATTR(illuminance0_target_input, S_IRUGO | S_IWUSR,
>>> +		tsl2x7x_als_cal_target_show, tsl2x7x_als_cal_target_store);
>>> +
>>> +static DEVICE_ATTR(illuminance0_calibrate, S_IWUSR, NULL,
>>> +		tsl2x7x_do_calibrate);
>>> +
>>> +static DEVICE_ATTR(proximity_calibrate, S_IWUSR, NULL,
>>> +		tsl2x7x_do_prox_calibrate);
>>> +
>>> +static DEVICE_ATTR(illuminance0_lux_table, S_IRUGO | S_IWUSR,
>>> +		tsl2x7x_luxtable_show, tsl2x7x_luxtable_store);
>>> +
>>> +static DEVICE_ATTR(sampling_frequency, S_IRUGO | S_IWUSR,
>>> +		tsl2x7x_als_persistence_show, tsl2x7x_als_persistence_store);
>>> +
>>> +/* Use the default register values to identify the Taos device */
>>> +static int tsl2x7x_device_id(unsigned char *id, int target)
>>> +{
>>> +	switch (target) {
>>> +	case tsl2571:
>>> +	case tsl2671:
>>> +	case tsl2771:
>>> +		return ((*id&  0xf0) == TRITON_ID);
>>> +	break;
>>> +	case tmd2671:
>>> +	case tmd2771:
>>> +		return ((*id&  0xf0) == HALIBUT_ID);
>>> +	break;
>>> +	case tsl2572:
>>> +	case tsl2672:
>>> +	case tmd2672:
>>> +	case tsl2772:
>>> +	case tmd2772:
>>> +		return ((*id&  0xf0) == SWORDFISH_ID);
>>> +	break;
>>> +	}
>>> +
>>> +	return -EINVAL;
>>> +}
>>> +
>>> +/*
>>> + * Interrupt Event Handler */
>>> +static irqreturn_t tsl2x7x_event_handler(int irq, void *private)
>>> +{
>>> +	struct iio_dev *indio_dev = private;
>>> +	struct tsl2X7X_chip *chip = iio_priv(indio_dev);
>>> +	s64 timestamp = iio_get_time_ns();
>>> +	int ret;
>>> +	int value;
>>> +
>>> +	value = i2c_smbus_read_byte_data(chip->client,
>>> +		TSL2X7X_CMD_REG | TSL2X7X_STATUS);
>>> +
>>> +	/* What type of interrupt do we need to process */
>>> +	if (value&  TSL2X7X_STA_PRX_INTR) {
>>> +		tsl2x7x_prox_poll(indio_dev);
>>> +		iio_push_event(indio_dev,
>>> +			       IIO_UNMOD_EVENT_CODE(IIO_PROXIMITY,
>>> +						    0,
>>> +						    IIO_EV_TYPE_THRESH,
>>> +						    IIO_EV_DIR_EITHER),
>>> +						    timestamp);
>>> +	}
>>> +
>>> +	if (value&  TSL2X7X_STA_ALS_INTR) {
>>> +		tsl2x7x_get_lux(indio_dev);
>> why the get value?  No real guarantee you'll get the one that caused the
>> event as far as I can see.
>>> +		iio_push_event(indio_dev,
>>> +		       IIO_UNMOD_EVENT_CODE(IIO_LIGHT,
>>> +					    0,
>>> +					    IIO_EV_TYPE_THRESH,
>>> +					    IIO_EV_DIR_EITHER),
>>> +					    timestamp);
>>> +	}
>>> +	/* Clear interrupt now that we have the status */
>>> +	ret = i2c_smbus_write_byte(chip->client,
>>> +		TSL2X7X_CMD_REG | TSL2X7X_CMD_SPL_FN |
>>> +		TSL2X7X_CMD_PROXALS_INT_CLR);
>>> +	if (ret<  0)
>>> +		dev_err(&chip->client->dev,
>>> +			"%s: Failed to clear irq from event handler. err = %d\n",
>>> +			__func__, ret);
>>> +
>>> +	return IRQ_HANDLED;
>>> +}
>>> +
>>> +static struct attribute *tsl2x7x_ALS_device_attrs[] = {
>>> +	&dev_attr_power_state.attr,
>>> +	&dev_attr_illuminance0_calibscale_available.attr,
>>> +	&dev_attr_illuminance0_integration_time.attr,
>>> +	&iio_const_attr_illuminance0_integration_time_available.dev_attr.attr,
>>> +	&dev_attr_illuminance0_target_input.attr,
>>> +	&dev_attr_illuminance0_calibrate.attr,
>>> +	&dev_attr_illuminance0_lux_table.attr,
>>> +	&dev_attr_sampling_frequency.attr,
>>> +	&iio_const_attr_sampling_frequency_available.dev_attr.attr,
>>> +	NULL
>>> +};
>>> +
>>> +static struct attribute *tsl2x7x_PRX_device_attrs[] = {
>>> +	&dev_attr_power_state.attr,
>>> +	&dev_attr_sampling_frequency.attr,
>>> +	&iio_const_attr_sampling_frequency_available.dev_attr.attr,
>>> +	&dev_attr_proximity_calibrate.attr,
>>> +	NULL
>>> +};
>>> +
>>> +static struct attribute *tsl2x7x_ALSPRX_device_attrs[] = {
>>> +	&dev_attr_power_state.attr,
>>> +	&dev_attr_illuminance0_calibscale_available.attr,
>>> +	&dev_attr_illuminance0_integration_time.attr,
>>> +	&iio_const_attr_illuminance0_integration_time_available.dev_attr.attr,
>>> +	&dev_attr_illuminance0_target_input.attr,
>>> +	&dev_attr_illuminance0_calibrate.attr,
>>> +	&dev_attr_illuminance0_lux_table.attr,
>>> +	&dev_attr_sampling_frequency.attr,
>>> +	&iio_const_attr_sampling_frequency_available.dev_attr.attr,
>>> +	&dev_attr_proximity_calibrate.attr,
>>> +	NULL
>>> +};
>>> +
>>> +static struct attribute *tsl2x7x_PRX2_device_attrs[] = {
>>> +	&dev_attr_power_state.attr,
>>> +	&dev_attr_sampling_frequency.attr,
>>> +	&iio_const_attr_sampling_frequency_available.dev_attr.attr,
>>> +	&dev_attr_proximity_calibrate.attr,
>>> +	&dev_attr_proximity_calibscale_available.attr,
>>> +	NULL
>>> +};
>>> +
>>> +static struct attribute *tsl2x7x_ALSPRX2_device_attrs[] = {
>>> +	&dev_attr_power_state.attr,
>>> +	&dev_attr_illuminance0_calibscale_available.attr,
>>> +	&dev_attr_illuminance0_integration_time.attr,
>>> +	&iio_const_attr_illuminance0_integration_time_available.dev_attr.attr,
>>> +	&dev_attr_illuminance0_target_input.attr,
>>> +	&dev_attr_illuminance0_calibrate.attr,
>>> +	&dev_attr_illuminance0_lux_table.attr,
>>> +	&dev_attr_sampling_frequency.attr,
>>> +	&iio_const_attr_sampling_frequency_available.dev_attr.attr,
>>> +	&dev_attr_proximity_calibrate.attr,
>>> +	&dev_attr_proximity_calibscale_available.attr,
>>> +	NULL
>>> +};
>>> +
>>> +static const struct attribute_group tsl2X7X_device_attr_group_tbl[] = {
>>> +	[ALS] = {
>>> +		.attrs = tsl2x7x_ALS_device_attrs,
>>> +	},
>>> +	[PRX] = {
>>> +		.attrs = tsl2x7x_PRX_device_attrs,
>>> +	},
>>> +	[ALSPRX] = {
>>> +		.attrs = tsl2x7x_ALSPRX_device_attrs,
>>> +	},
>>> +	[PRX2] = {
>>> +		.attrs = tsl2x7x_PRX2_device_attrs,
>>> +	},
>>> +	[ALSPRX2] = {
>>> +		.attrs = tsl2x7x_ALSPRX2_device_attrs,
>>> +	},
>>> +};
>>> +
>>> +static const struct iio_info tsl2X7X_device_info[] = {
>>> +	[ALS] = {
>>> +		.attrs =&tsl2X7X_device_attr_group_tbl[ALS],
>>> +		.driver_module = THIS_MODULE,
>>> +		.read_raw =&tsl2x7x_read_raw,
>>> +		.write_raw =&tsl2x7x_write_raw,
>>> +		.read_event_value =&tsl2x7x_read_thresh,
>>> +		.write_event_value =&tsl2x7x_write_thresh,
>>> +		.read_event_config =&tsl2x7x_read_interrupt_config,
>>> +		.write_event_config =&tsl2x7x_write_interrupt_config,
>>> +	},
>>> +	[PRX] = {
>>> +		.attrs =&tsl2X7X_device_attr_group_tbl[PRX],
>>> +		.driver_module = THIS_MODULE,
>>> +		.read_raw =&tsl2x7x_read_raw,
>>> +		.write_raw =&tsl2x7x_write_raw,
>>> +		.read_event_value =&tsl2x7x_read_thresh,
>>> +		.write_event_value =&tsl2x7x_write_thresh,
>>> +		.read_event_config =&tsl2x7x_read_interrupt_config,
>>> +		.write_event_config =&tsl2x7x_write_interrupt_config,
>>> +	},
>>> +	[ALSPRX] = {
>>> +		.attrs =&tsl2X7X_device_attr_group_tbl[ALSPRX],
>>> +		.driver_module = THIS_MODULE,
>>> +		.read_raw =&tsl2x7x_read_raw,
>>> +		.write_raw =&tsl2x7x_write_raw,
>>> +		.read_event_value =&tsl2x7x_read_thresh,
>>> +		.write_event_value =&tsl2x7x_write_thresh,
>>> +		.read_event_config =&tsl2x7x_read_interrupt_config,
>>> +		.write_event_config =&tsl2x7x_write_interrupt_config,
>>> +	},
>>> +	[PRX2] = {
>>> +		.attrs =&tsl2X7X_device_attr_group_tbl[PRX2],
>>> +		.driver_module = THIS_MODULE,
>>> +		.read_raw =&tsl2x7x_read_raw,
>>> +		.write_raw =&tsl2x7x_write_raw,
>>> +		.read_event_value =&tsl2x7x_read_thresh,
>>> +		.write_event_value =&tsl2x7x_write_thresh,
>>> +		.read_event_config =&tsl2x7x_read_interrupt_config,
>>> +		.write_event_config =&tsl2x7x_write_interrupt_config,
>>> +	},
>>> +	[ALSPRX2] = {
>>> +		.attrs =&tsl2X7X_device_attr_group_tbl[ALSPRX2],
>>> +		.driver_module = THIS_MODULE,
>>> +		.read_raw =&tsl2x7x_read_raw,
>>> +		.write_raw =&tsl2x7x_write_raw,
>>> +		.read_event_value =&tsl2x7x_read_thresh,
>>> +		.write_event_value =&tsl2x7x_write_thresh,
>>> +		.read_event_config =&tsl2x7x_read_interrupt_config,
>>> +		.write_event_config =&tsl2x7x_write_interrupt_config,
>>> +	},
>>> +};
>>> +
>>> +static const struct tsl2x7x_chip_info tsl2x7x_chip_info_tbl[] = {
>>> +	[ALS] = {
>>> +		.channel = {
>>> +			[0] = {
>>> +				.type = IIO_LIGHT,
>>> +				.indexed = 1,
>>> +				.channel = 0,
>>> +				.processed_val = 1,
>>> +			},
>>> +			[1] = {
>>> +				.type = IIO_LIGHT,
>>> +				.indexed = 1,
>>> +				.channel = 0,
>>> +				.info_mask =
>>> +
>> 	IIO_CHAN_INFO_CALIBSCALE_SEPARATE_BIT |
>>> +
>> 	IIO_CHAN_INFO_CALIBBIAS_SEPARATE_BIT,
>>> +				.event_mask = TSL2X7X_EVENT_MASK
>>> +			},
>>> +		},
>>> +	.num_channels = 2,
>>> +	.info =&tsl2X7X_device_info[ALS],
>>> +	},
>>> +	[PRX] = {
>>> +		.channel = {
>>> +			[0] = {
>>> +				.type = IIO_PROXIMITY,
>>> +				.indexed = 1,
>>> +				.channel = 0,
>>> +				.processed_val = 1,
>>> +			},
>>> +			[1] = {
>>> +				.type = IIO_PROXIMITY,
>>> +				.indexed = 1,
>>> +				.channel = 0,
>>> +				.event_mask = TSL2X7X_EVENT_MASK
>>> +			},
>>> +		},
>>> +	.num_channels = 2,
>>> +	.info =&tsl2X7X_device_info[PRX],
>>> +	},
>>> +	[ALSPRX] = {
>>> +		.channel = {
>>> +			[0] = {
>>> +				.type = IIO_LIGHT,
>>> +				.indexed = 1,
>>> +				.channel = 0,
>>> +				.processed_val = 1,
>>> +			},
>>> +			[1] = {
>>> +				.type = IIO_LIGHT,
>>> +				.indexed = 1,
>>> +				.channel = 0,
>>> +				.info_mask =
>>> +
>> 	IIO_CHAN_INFO_CALIBSCALE_SEPARATE_BIT |
>>> +
>> 	IIO_CHAN_INFO_CALIBBIAS_SEPARATE_BIT,
>>> +				.event_mask = TSL2X7X_EVENT_MASK
>>> +			},
>>> +			[2] = {
>>> +				.type = IIO_PROXIMITY,
>>> +				.indexed = 1,
>>> +				.channel = 0,
>>> +				.processed_val = 1,
>>> +			},
>>> +			[3] = {
>>> +				.type = IIO_PROXIMITY,
>>> +				.indexed = 1,
>>> +				.channel = 0,
>>> +				.processed_val = 0,
>>> +				.event_mask = TSL2X7X_EVENT_MASK
>>> +			},
>>> +		},
>>> +	.num_channels = 4,
>>> +	.info =&tsl2X7X_device_info[ALSPRX],
>>> +	},
>>> +	[PRX2] = {
>>> +		.channel = {
>>> +			[0] = {
>>> +				.type = IIO_PROXIMITY,
>>> +				.indexed = 1,
>>> +				.channel = 0,
>>> +				.processed_val = 1,
>>> +			},
>>> +			[1] = {
>>> +				.type = IIO_PROXIMITY,
>>> +				.indexed = 1,
>>> +				.channel = 0,
>>> +				.info_mask =
>>> +
>> 	IIO_CHAN_INFO_CALIBSCALE_SEPARATE_BIT,
>>> +				.event_mask = TSL2X7X_EVENT_MASK
>>> +			},
>>> +		},
>>> +	.num_channels = 2,
>>> +	.info =&tsl2X7X_device_info[PRX2],
>>> +	},
>>> +	[ALSPRX2] = {
>>> +		.channel = {
>>> +				[0] = {
>>> +				.type = IIO_LIGHT,
>>> +				.indexed = 1,
>>> +				.channel = 0,
>>> +				.processed_val = 1,
>>> +			},
>>> +			[1] = {
>>> +				.type = IIO_LIGHT,
>>> +				.indexed = 1,
>>> +				.channel = 0,
>>> +				.info_mask =
>>> +
>> 	IIO_CHAN_INFO_CALIBSCALE_SEPARATE_BIT |
>>> +
>> 	IIO_CHAN_INFO_CALIBBIAS_SEPARATE_BIT,
>>> +				.event_mask = TSL2X7X_EVENT_MASK
>>> +			},
>>> +			[2] = {
>>> +				.type = IIO_PROXIMITY,
>>> +				.indexed = 1,
>>> +				.channel = 0,
>>> +				.processed_val = 1,
>>> +			},
>>> +			[3] = {
>> I'm more than a little confused here.  There are only 2 actually
>> channels?  If so I don't
>> see why we have 4 channels here...
>>> +				.type = IIO_PROXIMITY,
>>> +				.indexed = 1,
>>> +				.channel = 0,
>>> +				.info_mask =
>>> +
>> 	IIO_CHAN_INFO_CALIBSCALE_SEPARATE_BIT,
>>> +				.event_mask = TSL2X7X_EVENT_MASK
>>> +			},
>>> +		},
>>> +	.num_channels = 4,
>>> +	.info =&tsl2X7X_device_info[ALSPRX2],
>>> +	},
>>> +};
>>> +
>>> +/*
>>> + * Client probe function.
>>> + */
>>> +static int __devinit tsl2x7x_probe(struct i2c_client *clientp,
>>> +	const struct i2c_device_id *id)
>>> +{
>>> +	int ret;
>>> +	unsigned char device_id;
>>> +	struct iio_dev *indio_dev;
>>> +	struct tsl2X7X_chip *chip;
>>> +
>>> +	indio_dev = iio_allocate_device(sizeof(*chip));
>>> +	if (!indio_dev)
>>> +		return -ENOMEM;
>>> +
>>> +	chip = iio_priv(indio_dev);
>>> +	chip->client = clientp;
>>> +	i2c_set_clientdata(clientp, indio_dev);
>>> +
>>> +	ret = tsl2x7x_i2c_read(chip->client,
>>> +		TSL2X7X_CHIPID,&device_id);
>>> +	if (ret<  0)
>>> +		goto fail1;
>>> +
>>> +	if ((!tsl2x7x_device_id(&device_id, id->driver_data)) ||
>>> +		(tsl2x7x_device_id(&device_id, id->driver_data) == -EINVAL)) {
>>> +		dev_info(&chip->client->dev,
>>> +				"i2c device found does not match expected id
>> in %s\n",
>>> +				__func__);
>>> +		goto fail1;
>>> +	}
>>> +
>>> +	ret = i2c_smbus_write_byte(clientp, (TSL2X7X_CMD_REG |
>> TSL2X7X_CNTRL));
>>> +	if (ret<  0) {
>>> +		dev_err(&clientp->dev, "%s: write to cmd reg failed. err =
>> %d\n",
>>> +				__func__, ret);
>>> +		goto fail1;
>>> +	}
>>> +
>>> +	/* ALS and PROX functions can be invoked via user space poll
>>> +	 * or H/W interrupt. If busy return last sample. */
>>> +	mutex_init(&chip->als_mutex);
>>> +	mutex_init(&chip->prox_mutex);
>>> +
>>> +	chip->tsl2x7x_chip_status = TSL2X7X_CHIP_UNKNOWN;
>>> +	chip->pdata = clientp->dev.platform_data;
>>> +	chip->id = id->driver_data;
>>> +	chip->chip_info =
>>> +		&tsl2x7x_chip_info_tbl[device_channel_config[id-
>>> driver_data]];
>>> +
>>> +	indio_dev->info = chip->chip_info->info;
>>> +	indio_dev->dev.parent =&clientp->dev;
>>> +	indio_dev->modes = INDIO_DIRECT_MODE;
>>> +	indio_dev->name = chip->client->name;
>>> +	indio_dev->channels = chip->chip_info->channel;
>>> +	indio_dev->num_channels = chip->chip_info->num_channels;
>>> +
>>> +	if (clientp->irq) {
>>> +		ret = request_threaded_irq(clientp->irq,
>>> +					   NULL,
>>> +					&tsl2x7x_event_handler,
>>> +					   IRQF_TRIGGER_RISING |
>> IRQF_ONESHOT,
>>> +					   "TSL2X7X_event",
>>> +					   indio_dev);
>>> +		if (ret) {
>>> +			dev_err(&clientp->dev,
>>> +				"%s: irq request failed", __func__);
>>> +			goto fail2;
>>> +		}
>>> +	}
>>> +
>>> +	/* Load up the defaults */
>>> +	tsl2x7x_defaults(chip);
>>> +	/* Make sure the chip is on */
>>> +	tsl2x7x_chip_on(indio_dev);
>>> +
>>> +	ret = iio_device_register(indio_dev);
>>> +	if (ret) {
>>> +		dev_err(&clientp->dev,
>>> +			"%s: iio registration failed\n", __func__);
>>> +		goto fail3;
>>> +	}
>>> +
>>> +	dev_info(&clientp->dev, "%s Light sensor found.\n", id->name);
>>> +
>>> +	return 0;
>>> +
>>> +fail3:
>>> +	if (clientp->irq)
>>> +		free_irq(clientp->irq, indio_dev);
>>> +fail2:
>>> +	iio_free_device(indio_dev);
>>> +fail1:
>>> +	kfree(chip);
>> double free of chip.  It's allocated and managed by the
>> iio_allocate_device and iio_free_device calls.
>> For that matter, most of the goto fail2's need the iio_free_device call..
>>> +	return ret;
>>> +}
>>> +
>>> +static int tsl2x7x_suspend(struct device *dev)
>>> +{
>>> +	struct iio_dev *indio_dev = dev_get_drvdata(dev);
>>> +	struct tsl2X7X_chip *chip = iio_priv(indio_dev);
>>> +	int ret = 0;
>>> +
>>> +	if (chip->tsl2x7x_chip_status == TSL2X7X_CHIP_WORKING) {
>>> +		ret = tsl2x7x_chip_off(indio_dev);
>>> +		chip->tsl2x7x_chip_status = TSL2X7X_CHIP_SUSPENDED;
>>> +	}
>>> +
>>> +	if (chip->pdata&&  chip->pdata->platform_power) {
>>> +		pm_message_t pmm = {PM_EVENT_SUSPEND};
>>> +		chip->pdata->platform_power(dev, pmm);
>>> +	}
>>> +
>>> +	return ret;
>>> +}
>>> +
>>> +static int tsl2x7x_resume(struct device *dev)
>>> +{
>>> +	struct iio_dev *indio_dev = dev_get_drvdata(dev);
>>> +	struct tsl2X7X_chip *chip = iio_priv(indio_dev);
>>> +	int ret = 0;
>>> +
>>> +	if (chip->pdata&&  chip->pdata->platform_power) {
>>> +		pm_message_t pmm = {PM_EVENT_RESUME};
>>> +		chip->pdata->platform_power(dev, pmm);
>>> +	}
>>> +
>>> +	if (chip->tsl2x7x_chip_status == TSL2X7X_CHIP_SUSPENDED)
>>> +		ret = tsl2x7x_chip_on(indio_dev);
>>> +
>>> +	return ret;
>>> +}
>>> +
>>> +static int __devexit tsl2x7x_remove(struct i2c_client *client)
>>> +{
>>> +	struct iio_dev *indio_dev = i2c_get_clientdata(client);
>>> +	struct tsl2X7X_chip *chip = i2c_get_clientdata(client);
>> These shouldn't both be true....
>> would expect an iio_unregister_device call here.
>>> +
>>> +	tsl2x7x_chip_off(indio_dev);
>>> +
>>> +	if (client->irq)
>>> +		free_irq(client->irq, chip->client->name);
>>> +
>>> +	iio_free_device(indio_dev);
>>> +
>>> +	return 0;
>>> +}
>>> +
>>> +static struct i2c_device_id tsl2x7x_idtable[] = {
>>> +	{ "tsl2571", tsl2571 },
>>> +	{ "tsl2671", tsl2671 },
>>> +	{ "tmd2671", tmd2671 },
>>> +	{ "tsl2771", tsl2771 },
>>> +	{ "tmd2771", tmd2771 },
>>> +	{ "tsl2572", tsl2572 },
>>> +	{ "tsl2672", tsl2672 },
>>> +	{ "tmd2672", tmd2672 },
>>> +	{ "tsl2772", tsl2772 },
>>> +	{ "tmd2772", tmd2772 },
>>> +	{}
>>> +};
>>> +
>>> +MODULE_DEVICE_TABLE(i2c, tsl2x7x_idtable);
>>> +
>>> +static const struct dev_pm_ops tsl2x7x_pm_ops = {
>>> +	.suspend = tsl2x7x_suspend,
>>> +	.resume  = tsl2x7x_resume,
>>> +};
>>> +
>>> +/* Driver definition */
>>> +static struct i2c_driver tsl2x7x_driver = {
>>> +	.driver = {
>>> +		.name = "tsl2x7x",
>>> +		.pm =&tsl2x7x_pm_ops,
>>> +	},
>>> +	.id_table = tsl2x7x_idtable,
>>> +	.probe = tsl2x7x_probe,
>>> +	.remove = __devexit_p(tsl2x7x_remove),
>>> +};
>>> +
>>> +module_i2c_driver(tsl2x7x_driver);
>>> +
>>> +MODULE_AUTHOR("J. August Brenner<jbrenner@taosinc.com>");
>>> +MODULE_DESCRIPTION("TAOS tsl2x7x ambient and proximity light sensor
>> driver");
>>> +MODULE_LICENSE("GPL");
>>> diff --git a/drivers/staging/iio/light/tsl2x7x_core.h
>> b/drivers/staging/iio/light/tsl2x7x_core.h
>>> new file mode 100644
>>> index 0000000..663e846
>>> --- /dev/null
>>> +++ b/drivers/staging/iio/light/tsl2x7x_core.h
>> why not just tsl2x7x.h?
>>> @@ -0,0 +1,75 @@
>>> +/*
>>> + * Device driver for monitoring ambient light intensity (lux)
>>> + * and proximity (prox) within the TAOS TSL2X7X family of devices.
>>> + *
>>> + * Copyright (c) 2012, TAOS Corporation.
>>> + *
>>> + * This program is free software; you can redistribute it and/or modify
>>> + * it under the terms of the GNU General Public License as published by
>>> + * the Free Software Foundation; either version 2 of the License, or
>>> + * (at your option) any later version.
>>> + *
>>> + * This program is distributed in the hope that it will be useful, but WITHOUT
>>> + * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
>> or
>>> + * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
>> for
>>> + * more details.
>>> + *
>>> + * You should have received a copy of the GNU General Public License along
>>> + * with this program; if not, write to the Free Software Foundation, Inc.,
>>> + * 51 Franklin Street, Fifth Floor, Boston, MA	02110-1301, USA.
>>> + */
>>> +
>>> +#ifndef __TSL2X7X_H
>>> +#define __TSL2X7X_H
>>> +#include<linux/pm.h>
>>> +
>>> +/* Max number of segments allowable in LUX table */
>>> +#define TSL2X7X_MAX_LUX_TABLE_SIZE		9
>>> +#define MAX_DEFAULT_TABLE_BYTES (sizeof(int) *
>> TSL2X7X_MAX_LUX_TABLE_SIZE)
>>> +
>>> +struct iio_dev;
>>
>> Why the forward declaration of iio_chan_spec?
>>> +struct iio_chan_spec;
>>> +
>>> +struct tsl2x7x_lux {
>>> +	unsigned int ratio;
>>> +	unsigned int ch0;
>>> +	unsigned int ch1;
>>> +};
>>> +
>>> +/* Refer to tsl2x7x_default_settings for member desc. */
>>> +struct tsl2x7x_settings {
>>> +	int als_time;
>>> +	int als_gain;
>>> +	int als_gain_trim;
>>> +	int wait_time;
>>> +	int prx_time;
>>> +	int prox_gain;
>>> +	int prox_config;
>>> +	int als_cal_target;
>>> +	u8  interrupts_en;
>>> +	u8  als_persistence;
>>> +	int als_thresh_low;
>>> +	int als_thresh_high;
>>> +	int prox_thres_low;
>>> +	int prox_thres_high;
>>> +	int prox_pulse_count;
>>> +	int prox_max_samples_cal;
>>> +};
>>> +
>>> +/* struct tsl2x7x_platform_data -
>>> + * Platform unique glass and defaults
>>> + * Platform PM functions. */
>> Would prefer this to be in kernel doc.
>>> +struct tsl2X7X_platform_data {
>>> +	/* Suspend/resume platform cb */
>>> +	int (*platform_power)(struct device *dev, pm_message_t);
>>> +	/* The following callback gets called when the device is powered on */
>>> +	int (*power_on)      (struct iio_dev *indio_dev);
>>> +	/* The following callback gets called when the device is powered off */
>>> +	int (*power_off)     (struct i2c_client *dev);
>>> +	/* These are the device specific glass coefficents used to
>>> +	 * calculate Lux */
>>> +	struct tsl2x7x_lux platform_lux_table[TSL2X7X_MAX_LUX_TABLE_SIZE];
>>> +	struct tsl2x7x_settings *platform_default_settings;
>>> +};
>>> +
>>> +#endif /* __TSL2X7X_H */
>>> --
>>> 1.7.4.1
>>>
> 

