Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756919Ab1CNTSZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 15:18:25 -0400
Received: from ppsw-52.csi.cam.ac.uk ([131.111.8.152]:36503 "EHLO
	ppsw-52.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756342Ab1CNTSW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 15:18:22 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4D7E6A38.7010801@cam.ac.uk>
Date: Mon, 14 Mar 2011 19:19:20 +0000
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20110122 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: mems applications <mems.applications@st.com>
CC: rdunlap@xenotime.net, carmine.iascone@st.com, matteo.dameno@st.com,
        rubini@cvml.unipv.it, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Add STMicroelectronics LPS001WP pressure sensor device
 driver into misc
References: <> <1300128906-1066-1-git-send-email-matteo.dameno@st.com>
In-Reply-To: <1300128906-1066-1-git-send-email-matteo.dameno@st.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/14/11 18:55, mems applications wrote:

Couple of general patch points first

1) Always have a description of what has changed since the previous version.
  That way those reviewing can quickly see how you have responded to the various comments.
2) Always denote what version of the patch we are seeing in the email title.  [Patch V?]
  As that way everyone can make sure they are reading the latest version.
3) If you do change the email title (which makes sense here) please make sure you
  give a reference to the original thread so people can look back.
http://marc.info/?t=129104558600005&r=1&w=2  does the job for that.



Anyhow, on to a review.

The big issue raised last time around is that this is not a conventional human
input device.  Hence Dmitry isn't going to take it into input.  That doesn't
just mean that you have to move it's physical location; it also means you have
to not use the input interfaces at all.

Good to see the documentation. Couple of nitpicks in there, but mostly well
written and easy to understand.

Various other comments through the code.  

> ---
>  Documentation/ABI/testing/sysfs-i2c-lps001wp_prs |   64 ++
>  drivers/misc/Kconfig                             |   10 +
>  drivers/misc/Makefile                            |    1 +
>  drivers/misc/lps001wp.h                          |   67 ++
>  drivers/misc/lps001wp_prs.c                      | 1137 ++++++++++++++++++++++
>  5 files changed, 1279 insertions(+), 0 deletions(-)
>  create mode 100644 Documentation/ABI/testing/sysfs-i2c-lps001wp_prs
>  create mode 100644 drivers/misc/lps001wp.h
>  create mode 100644 drivers/misc/lps001wp_prs.c
> 
> diff --git a/Documentation/ABI/testing/sysfs-i2c-lps001wp_prs b/Documentation/ABI/testing/sysfs-i2c-lps001wp_prs
> new file mode 100644
> index 0000000..55c87c9
> --- /dev/null
> +++ b/Documentation/ABI/testing/sysfs-i2c-lps001wp_prs
> @@ -0,0 +1,64 @@
> +What:		/sys/bus/i2c/devices/<busnum>-<devaddr>/enable_device
> +Date:		March 2011
> +Contact:	Matteo Dameno <matteo.dameno@st.com>
> +Contact:	Carmine Iascone <carmine.iascone@st.com>
> +Description:	Enables the devices: switches it between Power Down and Normal
> +		working modes. Switches the device on or off.
> +
> +		Reading: returns 0 if Power Down mode is set;
> +			 returns 1 if Normal mode is set.
> +
> +		Writing: sets the working mode.
> +		Accepted values: 0, 1.
This is getting silly (not your fault!). We have a steadily increasing set of drivers
offering a parameter like this all with subtly different names.  
> +
> +
> +What:		/sys/bus/i2c/devices/<busnum>-<devaddr>/poll_period_ms
> +Date:		March 2011
> +Contact:	Matteo Dameno <matteo.dameno@st.com>
> +Contact:	Carmine Iascone <carmine.iascone@st.com>
> +Description:	Shows/Stores the data output polling period experessed in msec.
> +		The driver automatically selects to better ODR to support the
> +		polling period choise.
> +		The data output is diverted to input device.
> +		The updated values are polled at a 1/poll_period_ms (KHz)
> +		frequency.
> +
> +		Reading: returns the current polling period (msec).
> +		Writing: sets the current polling period to the given integer
> +			number of msec.
> +		Accepted values: 1,2,3,..,1000,...
A nice general interface.  However, for a device that lists on it's datasheet maximum
Pressure output data rate of 12.5Hz, polling at 1KHz seems a little silly.
> +
> +
> +What:		/sys/bus/i2c/devices/<busnum>-<devaddr>/enable_differential_output
> +Date:		March 2011
> +Contact:	Matteo Dameno <matteo.dameno@st.com>
> +Contact:	Carmine Iascone <carmine.iascone@st.com>
> +Description:	Tells the lps001wp to enable circuitry to calculate
> +		differential pressure and start to output it.
> +		Differential pressure is calculated as the difference between a
> +		constant reference value, stored in pressure_reference_level as
> +		described below, and the actual pressure measured.
> +
nitpick. For consistency with the above, only one blank line here.
> +
> +		Reading: returns 0 if differential output is disabled;
> +			 returns 1 if differential output is enabled.
> +
> +		Writing: enables the differential output.
> +		Accepted values: 0, 1.
Nice description.  You also need to either have another what line for pressure_reference_level.
It would be reasonable to define those two together.  Looks like you simply forgot
it when writing these docs as they currently stand.
> +
> +
> +What:		/sys/bus/i2c/devices/<busnum>-<devaddr>/lowpower_enable
> +Date:		March 2011
> +Contact:	Matteo Dameno <matteo.dameno@st.com>
> +Contact:	Carmine Iascone <carmine.iascone@st.com>
> +Description:	Tells the lps001wp to switch to low power mode.
> +		This options let the device to work at a lower power consumption
> +		rate. The cost is a decay on output resolution/noise density.
> +
> +
> +		Reading: returns 0 if low power mode is disabled;
> +			 returns 1 if low power mode is enabled.
> +
> +		Writing: enables the low power consumtion working mode .
mode . -> mode.
> +		Accepted values: 0, 1.
> +
> diff --git a/drivers/misc/Kconfig b/drivers/misc/Kconfig
> index 203500d..c728f10 100644
> --- a/drivers/misc/Kconfig
> +++ b/drivers/misc/Kconfig
> @@ -448,6 +448,16 @@ config BMP085
>  	  To compile this driver as a module, choose M here: the
>  	  module will be called bmp085.
> 
> +config LPS001WP_PRS
> +       tristate "STMicroelectronics LPS001WP MEMS Pressure Temperature Sensor"
> +       depends on I2C
> +       default n
> +       help
> +         If you say yes here you get support for the
> +         STM LPS001WP Barometer/Thermometer on I2C bus.
> +         This driver can also be built as a module (choose M).
> +         If so, the module will be called lps001wp_prs.
> +
>  config PCH_PHUB
>  	tristate "PCH Packet Hub of Intel Topcliff / OKI SEMICONDUCTOR ML7213"
>  	depends on PCI
> diff --git a/drivers/misc/Makefile b/drivers/misc/Makefile
> index 804f421..621f42a 100644
> --- a/drivers/misc/Makefile
> +++ b/drivers/misc/Makefile
> @@ -10,6 +10,7 @@ obj-$(CONFIG_ATMEL_PWM)		+= atmel_pwm.o
>  obj-$(CONFIG_ATMEL_SSC)		+= atmel-ssc.o
>  obj-$(CONFIG_ATMEL_TCLIB)	+= atmel_tclib.o
>  obj-$(CONFIG_BMP085)		+= bmp085.o
> +obj-$(CONFIG_LPS001WP_PRS)	+= lps001wp_prs.o
>  obj-$(CONFIG_ICS932S401)	+= ics932s401.o
>  obj-$(CONFIG_LKDTM)		+= lkdtm.o
>  obj-$(CONFIG_TIFM_CORE)       	+= tifm_core.o
> diff --git a/drivers/misc/lps001wp.h b/drivers/misc/lps001wp.h
> new file mode 100644
> index 0000000..52a7bb0
> --- /dev/null
> +++ b/drivers/misc/lps001wp.h
> @@ -0,0 +1,67 @@
> +/*
> +* STMicroelectronics LPS001WP Pressure / Temperature Sensor module driver
> +*
> +* Copyright (C)  2010 STMicroelectronics
> +* Matteo Dameno (matteo.dameno@st.com)
> +* Carmine Iascone (carmine.iascone@st.com)
> +*
> +* Both authors are willing to be considered the contact and update points for
> +* the driver.
> +*
> +*
> +* This program is free software; you can redistribute it and/or
> +* modify it under the terms of the GNU General Public License
> +* version 2 as published by the Free Software Foundation.
> +*
> +* This program is distributed in the hope that it will be useful, but
> +* WITHOUT ANY WARRANTY; without even the implied warranty of
> +* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
> +* General Public License for more details.
> +*
> +* You should have received a copy of the GNU General Public License
> +* along with this program; if not, write to the Free Software
> +* Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
> +* 02110-1301 USA
> +*
> +*/
> +
> +#ifndef	__LPS001WP_H__
> +#define	__LPS001WP_H__
> +
> +#define	SAD0L				0x00
> +#define	SAD0H				0x01
> +#define	LPS001WP_PRS_I2C_SADROOT	0x2E
> +#define	LPS001WP_PRS_I2C_SAD_L		((LPS001WP_PRS_I2C_SADROOT<<1)|SAD0L)
> +#define	LPS001WP_PRS_I2C_SAD_H		((LPS001WP_PRS_I2C_SADROOT<<1)|SAD0H)
> +#define	LPS001WP_PRS_DEV_NAME		"lps001wp_prs"
> +
> +/* input define mappings */
> +#define ABS_PR		ABS_PRESSURE
> +#define ABS_TEMP	ABS_GAS
> +#define ABS_DLTPR	ABS_MISC
> +
> +/* Pressure section defines */
> +
> +/* Pressure Sensor Operating Mode */
> +#define	LPS001WP_PRS_ENABLE		0x01
> +#define	LPS001WP_PRS_DISABLE		0x00
> +
> +#define	LPS001WP_PRS_PM_NORMAL		0x40
> +#define	LPS001WP_PRS_PM_OFF		LPS001WP_PRS_DISABLE
> +
> +#define	SENSITIVITY_T		64	/** =	64 LSB/degrC	*/
> +#define	SENSITIVITY_P		16	/** =	16 LSB/mbar	*/
> +
> +#ifdef __KERNEL__

This platform data structure could do with somd documentation.
Not immediately obvious why one would need the init and exit
functions for starters.  Also units for the intervals should be
specified.  Also what are power_on and power_off for?
The look suspiciously like work around regulator issues which
should probably be handled properly.

> +struct lps001wp_prs_platform_data {
> +	int poll_interval;
> +	int min_interval;
> +
> +	int (*init)(void);
> +	void (*exit)(void);
> +	int (*power_on)(void);
> +	int (*power_off)(void);
> +};
> +#endif /* __KERNEL__ */
> +
> +#endif  /* __LPS001WP_H__ */
> diff --git a/drivers/misc/lps001wp_prs.c b/drivers/misc/lps001wp_prs.c
> new file mode 100644
> index 0000000..5ed8398
> --- /dev/null
> +++ b/drivers/misc/lps001wp_prs.c
> @@ -0,0 +1,1137 @@
> +/*
> +* drivers/misc/lps001wp_prs.c
> +*
> +* STMicroelectronics LPS001WP Pressure / Temperature Sensor module driver
> +*
> +* Copyright (C)  2010 STMicroelectronics
> +* Matteo Dameno (matteo.dameno@st.com)
> +* Carmine Iascone (carmine.iascone@st.com)
> +*
> +* Both authors are willing to be considered the contact and update points for
> +* the driver.
> +*
> +* This driver supports the STMicroelectronics LPS001WP digital pressure and
> +* temperature sensor. The datasheet for the device is avaliable from STM
> +* website, currently at:
> +*
> +* http://www.st.com/internet/analog/product/251247.jsp
> +*
> +* Output data from the device are available from the assigned
> +* /dev/input/eventX device;
> +*
> +* LPS001WP can be controlled by sysfs interface looking inside:
> +* /sys/bus/i2c/devices/<busnum>-<devaddr>/
> +*
> +* LPS001WP make available to i2C addresses selectable from platform_data
> +* by the LPS001WP_PRS_I2C_SAD_H or LPS001WP_PRS_I2C_SAD_L.
> +*
> +* Read pressures and temperatures output can be converted in units of
> +* measurement by deviding them for SENSITIVITY_P and SENSITIVITY_T
> +* respectively.
> +* Obtained values are then  expessed as
> +* mbar (=0.1 kPa) and Celsius degrees.
> +*
> +* This program is free software; you can redistribute it and/or
> +* modify it under the terms of the GNU General Public License
> +* version 2 as published by the Free Software Foundation.
> +*
> +* This program is distributed in the hope that it will be useful, but
> +* WITHOUT ANY WARRANTY; without even the implied warranty of
> +* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
> +* General Public License for more details.
> +*
> +* You should have received a copy of the GNU General Public License
> +* along with this program; if not, write to the Free Software
> +* Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
> +* 02110-1301 USA
> +*
> +*/
> +
> +#include <linux/err.h>
> +#include <linux/errno.h>
> +#include <linux/delay.h>
> +#include <linux/fs.h>
> +#include <linux/i2c.h>
> +

> +#include <linux/input.h>
> +#include <linux/uaccess.h>
> +
> +#include <linux/workqueue.h>
> +#include <linux/irq.h>
No irqs that I can see

> +#include <linux/gpio.h>
No gpio's in driver.

> +#include <linux/interrupt.h>
why? No interrupts present in driver.

> +#include <linux/device.h>
> +#include <linux/slab.h>
> +#include <linux/kernel.h>
> +
> +#include "lps001wp.h"
> +
> +
All of these definces should probably have a LPS001WP at the start 
otherwise the chances are you'll clash with some header sometime
in the future.
> +#define	PR_ABS_MAX	USHRT_MAX
> +
> +#define	PR_ABS_MIN	(u16)(0U)
> +#define	PR_DLT_MAX	SHRT_MAX
> +#define	PR_DLT_MIN	SHRT_MIN
> +#define	TEMP_MAX	SHRT_MAX
> +#define TEMP_MIN	SHRT_MIN
> +
> +
> +#define	SENSITIVITY_T_SHIFT	6	/** =	64 LSB/degrC	*/
> +#define	SENSITIVITY_P_SHIFT	4	/** =	16 LSB/mbar	*/
> +
> +/* output/reference first registers */
> +#define	OUTDATA_REG	0x28
> +#define	INDATA_REG	0X30
> +
> +#define	WHOAMI_LPS001WP_PRS	0xBA	/*	Expctd content for WAI	*/
> +
> +/*	CONTROL REGISTERS	*/
> +#define	WHO_AM_I	0x0F		/*	WhoAmI register		*/
> +#define	CTRL_REG1	0x20		/*	power / ODR control reg	*/
> +#define	CTRL_REG2	0x21		/*	boot reg		*/
> +#define	CTRL_REG3	0x22		/*	interrupt control reg	*/
> +
> +#define	STATUS_REG	0X27		/*	status reg		*/
> +
> +#define PRESS_OUT_L	OUTDATA_REG	/*	output data		*/
> +
> +#define	REF_P_L		INDATA_REG	/*	pressure reference L	*/
> +#define	REF_P_H		0x31		/*	pressure reference H	*/
> +#define	THS_P_L		0x32		/*	pressure threshold L	*/
> +#define	THS_P_H		0x33		/*	pressure threshold H	*/
> +
> +#define	INT_CFG		0x34		/*	interrupt config	*/
> +#define	INT_SRC		0x35		/*	interrupt source	*/
> +#define	INT_ACK		0x36		/*	interrupt acknoledge	*/
> +
> +
> +/* Barometer and Termometer output data rate ODR */
> +#define	LPS001WP_PRS_ODR_MASK	0x30	/* Mask to access odr bits only	*/
> +#define	LPS001WP_PRS_ODR_7_1	0x00	/* 7Hz baro and 1Hz term ODR	*/
> +#define	LPS001WP_PRS_ODR_7_7	0x01	/* 7Hz baro and 7Hz term ODR	*/
> +#define	LPS001WP_PRS_ODR_12_12	0x11	/* 12.5Hz baro and 12.5Hz term ODR */
> +
> +/* control bit masks */
> +#define	LPS001WP_PRS_ENABLE_MASK	0x40
> +#define	LPS001WP_PRS_DIFF_MASK		0x08
> +#define LPS001WP_PRS_LPOW_MASK		0x80
> +
> +#define	LPS001WP_PRS_DIFF_ON		0x08
> +#define	LPS001WP_PRS_DIFF_OFF		0x00
> +
> +#define	LPS001WP_PRS_LPOW_ON		0x80
> +#define	LPS001WP_PRS_LPOW_OFF		0x00
> +
> +#define	FUZZ			0
> +#define	FLAT			0
> +#define	I2C_AUTO_INCREMENT	0x80
Again, please prefix these to avoid name clashes in future.
> +
> +/* RESUME STATE INDICES */
> +#define	LPS001WP_RES_CTRL_REG1		0
> +#define	LPS001WP_RES_CTRL_REG2		1
> +#define	LPS001WP_RES_CTRL_REG3		2
> +#define	LPS001WP_RES_REF_P_L		3
> +#define	LPS001WP_RES_REF_P_H		4
> +#define	LPS001WP_RES_THS_P_L		5
> +#define	LPS001WP_RES_THS_P_H		6
> +#define	LPS001WP_RES_INT_CFG		7
> +#define	LPS001WP_RESUME_ENTRIES		8
> +
> +
> +static const struct {
> +	unsigned int cutoff_ms;
> +	unsigned int mask;
> +} lps001wp_prs_odr_table[] = {
> +		{80,	LPS001WP_PRS_ODR_12_12 },
> +		{143,	LPS001WP_PRS_ODR_7_7 },
> +		{1000,	LPS001WP_PRS_ODR_7_1 },
> +};
> +
> +struct lps001wp_prs_data {
> +	struct i2c_client *client;
> +	struct lps001wp_prs_platform_data *pdata;
> +
> +	struct mutex lock;
> +	struct delayed_work input_work;
> +
> +	struct input_dev *input_dev;
> +
> +	int hw_initialized;
> +	/* hw_working=-1 means not tested yet */
> +	int hw_working;
> +	u8 pressure_delta_enabled;
> +	u8 lpowmode_enabled ;
> +
> +	atomic_t enabled;
> +	int on_before_suspend;
> +
> +	u8 resume_state[LPS001WP_RESUME_ENTRIES];
> +
> +#ifdef DEBUG
> +	u8 reg_addr;
> +#endif
> +};
> +
> +struct outputdata {
> +	u16 abspress;
> +	s16 temperature;
> +	s16 deltapress;
> +};
> +
> +static int lps001wp_prs_i2c_read(struct lps001wp_prs_data *prs,
> +				  u8 *buf, int len)
> +{
> +	int err;
> +	struct i2c_msg msgs[] = {
> +		{
> +		 .addr = prs->client->addr,
> +		 .flags = prs->client->flags & I2C_M_TEN,
Why this & I2C_M_TEN?  which flags are you avoiding having set?
> +		 .len = 1,
> +		 .buf = buf,
> +		 }, {
> +		 .addr = prs->client->addr,
> +		 .flags = (prs->client->flags & I2C_M_TEN) | I2C_M_RD,
> +		 .len = len,
> +		 .buf = buf,
> +		 },
> +	};
> +
> +
> +	err = i2c_transfer(prs->client->adapter, msgs, 2);
> +	if (err != 2) {
> +		dev_err(&prs->client->dev, "read transfer error\n");
> +		err = -EIO;
> +	}
> +	return 0;
> +}
> +
> +static int lps001wp_prs_i2c_write(struct lps001wp_prs_data *prs,
> +				   u8 *buf, int len)
> +{
> +	int err;
> +	struct i2c_msg msgs[] = {
> +		{
> +		 .addr = prs->client->addr,
> +		 .flags = prs->client->flags & I2C_M_TEN,
> +		 .len = len + 1,
> +		 .buf = buf,
> +		 },
> +	};
> +
Is this direct equivalent of i2c_smbus_write_i2c_block_data? Certainly looks
similar and if you can use those standard functions it would probably be a good
idea. 
> +	err = i2c_transfer(prs->client->adapter, msgs, 1);
> +	if (err != 1) {
> +		dev_err(&prs->client->dev, "write transfer error\n");
> +		err = -EIO;
> +	}
> +	return 0;
> +}
> +
> +static int lps001wp_prs_i2c_update(struct lps001wp_prs_data *prs,
> +			u8 reg_address, u8 mask, u8 new_bit_values)
> +{
> +	int err;
> +	u8 rdbuf[1] = { reg_address };
> +	u8 wrbuf[2] = { reg_address , 0x00 };
> +
> +	u8 init_val;
> +	u8 updated_val;
> +	err = lps001wp_prs_i2c_read(prs, rdbuf, 1);

i2c_smbus_read_byte I think...
> +	if (!(err < 0)) {
> +		init_val = rdbuf[0];
> +		updated_val = ((mask & new_bit_values) | ((~mask) & init_val));
> +		wrbuf[1] = updated_val;
> +		err = lps001wp_prs_i2c_write(prs, wrbuf, 1);
> +	}
> +	return err;
> +}
> +
> +static int lps001wp_prs_register_write(struct lps001wp_prs_data *prs, u8 *buf,
> +		u8 reg_address, u8 new_value)
> +{
> +	int err;
> +
> +	/* Sets configuration register at reg_address
> +	 *  NOTE: this is a straight overwrite  */
> +	buf[0] = reg_address;
> +	buf[1] = new_value;
> +	err = lps001wp_prs_i2c_write(prs, buf, 1);
i2c_smbus_write_byte?
> +	if (err < 0)
> +		return err;
> +
> +	return err;
> +}
> +
> +static int lps001wp_prs_register_read(struct lps001wp_prs_data *prs, u8 *buf,
> +		u8 reg_address)
> +{
> +	int err;
> +	buf[0] = reg_address;
> +	err = lps001wp_prs_i2c_read(prs, buf, 1);
> +	return err;
> +}
> +
> +static int lps001wp_prs_register_update(struct lps001wp_prs_data *prs, u8 *buf,
> +		u8 reg_address, u8 mask, u8 new_bit_values)
> +{
> +	int err;
> +	u8 init_val;
> +	u8 updated_val;
> +	err = lps001wp_prs_register_read(prs, buf, reg_address);
> +	if (!(err < 0)) {
> +		init_val = buf[0];
> +		updated_val = ((mask & new_bit_values) | ((~mask) & init_val));
> +		err = lps001wp_prs_register_write(prs, buf, reg_address,
> +				updated_val);
> +	}
> +	return err;
> +}
> +
> +static int lps001wp_prs_hw_init(struct lps001wp_prs_data *prs)
> +{
> +	int err;
> +	u8 buf[6];
> +
> +	buf[0] = WHO_AM_I;
> +	err = lps001wp_prs_i2c_read(prs, buf, 1);
> +	if (err < 0)
> +		goto error_firstread;
> +	else
> +		prs->hw_working = 1;
> +	if (buf[0] != WHOAMI_LPS001WP_PRS) {
> +		err = -1; /* TODO:choose the right coded error */
> +		goto error_unknown_device;
> +	}
> +
> +
> +	buf[0] = (I2C_AUTO_INCREMENT | INDATA_REG);
> +	buf[1] = prs->resume_state[LPS001WP_RES_REF_P_L];
> +	buf[2] = prs->resume_state[LPS001WP_RES_REF_P_H];
> +	buf[3] = prs->resume_state[LPS001WP_RES_THS_P_L];
> +	buf[4] = prs->resume_state[LPS001WP_RES_THS_P_H];
> +	err = lps001wp_prs_i2c_write(prs, buf, 4);
> +	if (err < 0)
> +		goto error1;
> +
> +	buf[0] = (I2C_AUTO_INCREMENT | CTRL_REG1);
> +	buf[1] = prs->resume_state[LPS001WP_RES_CTRL_REG1];
> +	buf[2] = prs->resume_state[LPS001WP_RES_CTRL_REG2];
> +	buf[3] = prs->resume_state[LPS001WP_RES_CTRL_REG3];
> +	err = lps001wp_prs_i2c_write(prs, buf, 3);
> +	if (err < 0)
> +		goto error1;
> +
> +	buf[0] = INT_CFG;
> +	buf[1] = prs->resume_state[LPS001WP_RES_INT_CFG];
> +	err = lps001wp_prs_i2c_write(prs, buf, 1);
> +	if (err < 0)
> +		goto error1;
> +
> +	prs->hw_initialized = 1;
> +	return 0;
> +
> +error_firstread:
> +	prs->hw_working = 0;
> +	dev_warn(&prs->client->dev, "Error reading WHO_AM_I: is device "
> +		"available/working?\n");
> +	goto error1;
> +error_unknown_device:
> +	dev_err(&prs->client->dev,
> +		"device unknown. Expected: 0x%x,"
> +		" Replies: 0x%x\n", WHOAMI_LPS001WP_PRS, buf[0]);
> +error1:
> +	prs->hw_initialized = 0;
> +	dev_err(&prs->client->dev, "hw init error 0x%x,0x%x: %d\n", buf[0],
> +			buf[1], err);
> +	return err;
> +}
> +
> +static void lps001wp_prs_device_power_off(struct lps001wp_prs_data *prs)
> +{
> +	int err;
> +	u8 buf[2] = { CTRL_REG1, LPS001WP_PRS_PM_OFF };
> +
> +	err = lps001wp_prs_i2c_write(prs, buf, 1);
> +	if (err < 0)
> +		dev_err(&prs->client->dev, "soft power off failed: %d\n", err);
> +
> +	if (prs->pdata->power_off) {
> +		prs->pdata->power_off();
> +		prs->hw_initialized = 0;
> +	}
> +	if (prs->hw_initialized)
> +		prs->hw_initialized = 0;
> +}
> +
> +static int lps001wp_prs_device_power_on(struct lps001wp_prs_data *prs)
> +{
> +	int err = -1;
Don't think there are any exit routes where this -1 is returned so don't bother
assigning it.
> +
> +	if (prs->pdata->power_on) {
> +		err = prs->pdata->power_on();
> +		if (err < 0) {
> +			dev_err(&prs->client->dev,
> +					"power_on failed: %d\n", err);
> +			return err;
> +		}
> +	}
> +
> +	if (!prs->hw_initialized) {
> +		err = lps001wp_prs_hw_init(prs);
> +		if (prs->hw_working == 1 && err < 0) {
> +			lps001wp_prs_device_power_off(prs);
> +			return err;
> +		}
> +	}
> +
> +	return 0;
> +}
> +
> +
> +
> +int lps001wp_prs_update_odr(struct lps001wp_prs_data *prs, int poll_interval_ms)
> +{
> +	int err = -1;
> +	int i;
> +
> +	u8 buf[2];
> +	u8 updated_val;
> +	u8 init_val;
> +	u8 new_val;
> +	u8 mask = LPS001WP_PRS_ODR_MASK;
> +
> +	/* Following, looks for the longest possible odr interval scrolling the
> +	 * odr_table vector from the end (shortest interval) backward (longest
> +	 * interval), to support the poll_interval requested by the system.
> +	 * It must be the longest interval lower then the poll interval.*/
> +	for (i = ARRAY_SIZE(lps001wp_prs_odr_table) - 1; i >= 0; i--) {
> +		if (lps001wp_prs_odr_table[i].cutoff_ms <= poll_interval_ms)
> +			break;
> +	}
unnecessary brackets.
> +
> +	new_val = lps001wp_prs_odr_table[i].mask;
> +
> +	/* If device is currently enabled, we need to write new
> +	 *  configuration out to it */
> +	if (atomic_read(&prs->enabled)) {
> +		buf[0] = CTRL_REG1;
> +		err = lps001wp_prs_i2c_read(prs, buf, 1);
> +		if (err < 0)
> +			goto error;
> +		init_val = buf[0];
> +		prs->resume_state[LPS001WP_RES_CTRL_REG1] = init_val;
> +
> +		updated_val = ((mask & new_val) | ((~mask) & init_val));
> +		buf[0] = CTRL_REG1;
> +		buf[1] = updated_val;
> +		err = lps001wp_prs_i2c_write(prs, buf, 1);
> +		if (err < 0)
> +			goto error;
> +		prs->resume_state[LPS001WP_RES_CTRL_REG1] = updated_val;
> +	}
> +	return err;
Is it correct to return -1 if prs->enabled is false?
> +
> +error:
> +	dev_err(&prs->client->dev, "update odr failed 0x%x,0x%x: %d\n",
> +			buf[0], buf[1], err);
> +
> +	return err;
> +}
> +
> +static int lps001wp_prs_set_press_reference(struct lps001wp_prs_data *prs,
> +				u16 new_reference)
> +{
> +	int err;
Does it really simplify the code to have these two consts?  Why not
just put them straight into the body of the code.
> +	u8 const reg_addressL = REF_P_L;
> +	u8 const reg_addressH = REF_P_H;
> +	u8 bit_valuesL, bit_valuesH;
> +	u8 buf[2];
> +
> +	bit_valuesL = (u8) (new_reference & 0x00FF);
> +	bit_valuesH = (u8)((new_reference & 0xFF00) >> 8);
> +
> +	err = lps001wp_prs_register_write(prs, buf, reg_addressL,
> +			bit_valuesL);
> +	if (err < 0)
> +		return err;
> +	err = lps001wp_prs_register_write(prs, buf, reg_addressH,
> +			bit_valuesH);
> +	if (err < 0) {
> +		lps001wp_prs_register_write(prs, buf, reg_addressL,
> +				prs->resume_state[LPS001WP_RES_REF_P_L]);
> +		return err;
> +	}
> +	prs->resume_state[LPS001WP_RES_REF_P_L] = bit_valuesL;
> +	prs->resume_state[LPS001WP_RES_REF_P_H] = bit_valuesH;
> +	return err;
> +}
> +
> +static int lps001wp_prs_get_press_reference(struct lps001wp_prs_data *prs,
> +		u16 *buf16)
> +{
> +	int err;
> +	u8 bit_valuesL, bit_valuesH;
> +	u8 buf[2];
> +	u16 temp = 0;
> +
> +	err = lps001wp_prs_register_read(prs, buf, REF_P_L);
> +	if (err < 0)
> +		return err;
> +	bit_valuesL = buf[0];
> +	err = lps001wp_prs_register_read(prs, buf, REF_P_H);
> +	if (err < 0)
> +		return err;
> +	bit_valuesH = buf[0];
> +
> +	temp = (((u16) bit_valuesH) << 8);
> +	*buf16 = (temp | ((u16) bit_valuesL));
> +
> +	return err;
> +}
> +
> +static int lps001wp_prs_lpow_manage(struct lps001wp_prs_data *prs, u8 control)
> +{
> +	int err;
> +	u8 buf[2];
> +	u8 const mask = LPS001WP_PRS_LPOW_MASK;
> +	u8 bit_values = LPS001WP_PRS_LPOW_OFF;
> +
> +	if (control)
> +		bit_values = LPS001WP_PRS_LPOW_ON;
> +
> +	err = lps001wp_prs_register_update(prs, buf, CTRL_REG1,
> +			mask, bit_values);
> +
> +	if (err < 0)
> +		return err;
> +	prs->resume_state[LPS001WP_RES_CTRL_REG1] = ((mask & bit_values) |
> +			(~mask & prs->resume_state[LPS001WP_RES_CTRL_REG1]));
> +	if (bit_values == LPS001WP_PRS_LPOW_ON)
> +		prs->lpowmode_enabled = 1;
> +	else
> +		prs->lpowmode_enabled = 0;
> +	return err;
> +}
> +
> +static int lps001wp_prs_diffen_manage(struct lps001wp_prs_data *prs, u8 control)
> +{
> +	int err;
> +	u8 buf[2];
> +	u8 const mask = LPS001WP_PRS_DIFF_MASK;
> +	u8 bit_values = LPS001WP_PRS_DIFF_OFF;
> +
> +	if (control)
> +		bit_values = LPS001WP_PRS_DIFF_ON;
> +
> +	err = lps001wp_prs_register_update(prs, buf, CTRL_REG1,
> +			mask, bit_values);
> +
> +	if (err < 0)
> +		return err;
> +	prs->resume_state[LPS001WP_RES_CTRL_REG1] = ((mask & bit_values) |
> +			(~mask & prs->resume_state[LPS001WP_RES_CTRL_REG1]));
> +	prs->pressure_delta_enabled = !!(bit_values ==  LPS001WP_PRS_DIFF_ON);
> +	return err;
> +}
> +
> +
> +static int lps001wp_prs_get_presstemp_data(struct lps001wp_prs_data *prs,
> +						struct outputdata *out)
> +{
> +	int err;
> +	/* Data bytes from hardware	PRESS_OUT_L, PRESS_OUT_H,
> +	 *				TEMP_OUT_L, TEMP_OUT_H,
> +	 *				DELTA_L, DELTA_H */
> +	u8 prs_data[6] = {
> +		(I2C_AUTO_INCREMENT | OUTDATA_REG),
> +	};
> +
> +	int regToRead = 4;
> +
> +	if (prs->pressure_delta_enabled)
> +		regToRead = 6;
> +
> +	err = lps001wp_prs_i2c_read(prs, prs_data, regToRead);
This is the only case that doesn't fit nicely into standard i2c functions.
Hence you need your device specific read for this.
> +	if (err < 0)
> +		return err;
> +
> +	out->abspress = ((((u16) prs_data[1] << 8) | ((u16) prs_data[0])));
> +	out->temperature = ((s16) (((u16) prs_data[3] << 8) |
> +							((u16)prs_data[2])));
> +	/* if not enabled delta output is set to zero */
> +	out->deltapress = ((s16) (((u16) prs_data[5] << 8) |
> +							((u16)prs_data[4])));
Looks like an endianess conversion to me. Please use be16tocpu or similar
(I haven't thought about which).  That makes it free on which ever machine it
is already correct for.  This is true of all of these.
> +
> +	return err;
> +}
> +
> +static void lps001wp_prs_report_values(struct lps001wp_prs_data *prs,
> +					struct outputdata *out)
> +{
> +	input_report_abs(prs->input_dev, ABS_PR, out->abspress);
> +	input_report_abs(prs->input_dev, ABS_TEMP, out->temperature);
> +	input_report_abs(prs->input_dev, ABS_DLTPR, out->deltapress);
> +	input_sync(prs->input_dev);
> +}
> +
> +static int lps001wp_prs_enable(struct lps001wp_prs_data *prs)
> +{
> +	int err;
> +
> +	if (!atomic_cmpxchg(&prs->enabled, 0, 1)) {
> +		err = lps001wp_prs_device_power_on(prs);
> +		if (err < 0) {
> +			atomic_set(&prs->enabled, 0);
> +			return err;
> +		}
> +		schedule_delayed_work(&prs->input_work,
> +			msecs_to_jiffies(prs->pdata->poll_interval));
> +	}
> +
> +	return 0;
> +}
> +
> +static int lps001wp_prs_disable(struct lps001wp_prs_data *prs)
> +{
> +	if (atomic_cmpxchg(&prs->enabled, 1, 0)) {
> +		cancel_delayed_work_sync(&prs->input_work);
> +		lps001wp_prs_device_power_off(prs);
> +	}
> +
> +	return 0;
> +}
> +
> +static ssize_t attr_polling_period_show(struct device *dev,
> +				     struct device_attribute *attr,
> +				     char *buf)
> +{
> +	int val;
> +	struct lps001wp_prs_data *prs = dev_get_drvdata(dev);
> +	mutex_lock(&prs->lock);
> +	val = prs->pdata->poll_interval;
> +	mutex_unlock(&prs->lock);
> +	return sprintf(buf, "%d\n", val);
> +}
> +
> +static ssize_t attr_polling_period_store(struct device *dev,
> +				     struct device_attribute *attr,
> +				     const char *buf, size_t size)
> +{
> +	struct lps001wp_prs_data *prs = dev_get_drvdata(dev);
> +	unsigned long interval_ms;
> +
> +	if (strict_strtoul(buf, 10, &interval_ms))
> +		return -EINVAL;
> +	if (!interval_ms)
> +		return -EINVAL;
> +	mutex_lock(&prs->lock);
> +	prs->pdata->poll_interval = interval_ms;
> +	lps001wp_prs_update_odr(prs, interval_ms);
> +	mutex_unlock(&prs->lock);
> +	return size;
> +}
> +
> +static ssize_t attr_enable_differential_output_show(struct device *dev,
> +				     struct device_attribute *attr,
> +				     char *buf)
> +{
> +	u8 val;
> +	struct lps001wp_prs_data *prs = dev_get_drvdata(dev);
> +	mutex_lock(&prs->lock);
> +	val = prs->pressure_delta_enabled;
> +	mutex_unlock(&prs->lock);
> +	return sprintf(buf, "%d\n", val);
> +}
> +
> +static ssize_t attr_enable_differential_output_store(struct device *dev,
> +				     struct device_attribute *attr,
> +				     const char *buf, size_t size)
> +{
> +	struct lps001wp_prs_data *prs = dev_get_drvdata(dev);
> +	unsigned long val;
> +
> +	if (strict_strtoul(buf, 10, &val))
> +		return -EINVAL;
> +
> +	mutex_lock(&prs->lock);
only user of diffen_manage.  Might be better to simply squash that function into
here.
> +	lps001wp_prs_diffen_manage(prs, (u8) val);
> +	mutex_unlock(&prs->lock);
> +	return size;
> +}
> +
> +static ssize_t attr_enable_device_show(struct device *dev,
> +				struct device_attribute *attr, char *buf)
> +{
> +	struct lps001wp_prs_data *prs = dev_get_drvdata(dev);
> +	int val = atomic_read(&prs->enabled);
> +	return sprintf(buf, "%d\n", val);
> +}
> +
> +static ssize_t attr_enable_device_store(struct device *dev,
> +				struct device_attribute *attr,
> +				const char *buf, size_t size)
> +{
> +	struct lps001wp_prs_data *prs = dev_get_drvdata(dev);
> +	unsigned long val;
> +
> +	if (strict_strtoul(buf, 10, &val))
> +		return -EINVAL;
> +
> +	if (val)
> +		lps001wp_prs_enable(prs);
> +	else
> +		lps001wp_prs_disable(prs);
> +
> +	return size;
> +}
> +
> +static ssize_t attr_pressure_reference_show(struct device *dev,
> +				  struct device_attribute *attr, char *buf)
> +{
> +	int err;
> +	struct lps001wp_prs_data *prs = dev_get_drvdata(dev);
> +	u16 val = 0;
> +
> +	mutex_lock(&prs->lock);
> +	err = lps001wp_prs_get_press_reference(prs, &val);
> +	mutex_unlock(&prs->lock);
> +	if (err < 0)
> +		return err;
> +
> +	return sprintf(buf, "%d\n", val);
> +}
> +
> +static ssize_t attr_pressure_reference_store(struct device *dev,
> +				  struct device_attribute *attr,
> +				  const char *buf, size_t size)
> +{
> +	int err;
> +	struct lps001wp_prs_data *prs = dev_get_drvdata(dev);
> +	unsigned long val = 0;
> +
> +	if (strict_strtoul(buf, 10, &val))
> +		return -EINVAL;
> +
> +	if (val < PR_ABS_MIN || val > PR_ABS_MAX)
> +		return -EINVAL;
> +
> +	mutex_lock(&prs->lock);
> +	err = lps001wp_prs_set_press_reference(prs, val);
> +	mutex_unlock(&prs->lock);
> +	if (err < 0)
> +		return err;
> +	return size;
> +}
> +
> +
> +static ssize_t attr_enable_lowpowermode_show(struct device *dev,
> +				   struct device_attribute *attr, char *buf)
> +{
> +	u8 val;
> +	struct lps001wp_prs_data *prs = dev_get_drvdata(dev);
> +	mutex_lock(&prs->lock);
> +	val = prs->lpowmode_enabled;
> +	mutex_unlock(&prs->lock);
> +	return sprintf(buf, "%d\n", val);
> +}
> +
> +static ssize_t attr_enable_lowpowermode_store(struct device *dev,
> +				   struct device_attribute *attr,
> +				   const char *buf, size_t size)
> +{
> +	int err;
> +	struct lps001wp_prs_data *prs = dev_get_drvdata(dev);
> +	unsigned long val;
> +
> +	if (strict_strtoul(buf, 10, &val))
> +		return -EINVAL;
> +
> +	mutex_lock(&prs->lock);
> +	err = lps001wp_prs_lpow_manage(prs, (u8) val);
As this is the only place lpow_manage is used does it make sense to have
a separate function for it?

> +	/*This looks like it might involve some magic numbers. Documentation
> + might show be to be wrong, but it certainly looks suspicious.
> +*/
:)  This piece of giberish is a comment from my last review. Probably wasn't
meant to end up in the code!  Still. What does this do if I write 133 to it?
I would like to see some range checking in this function.
> +	mutex_unlock(&prs->lock);
> +	if (err < 0)
> +		return err;
> +
> +	return size;
> +}
> +
> +static struct device_attribute attributes[] = {
> +	__ATTR(enable_device, 0664,
There are nice #defines for modes that make for easier reading.
S_IRUGO | S_IWUSR for example.
> +			attr_enable_device_show,
> +						attr_enable_device_store),
> +	__ATTR(poll_period_ms, 0664,
> +			attr_polling_period_show,
> +						 attr_polling_period_store),
> +	__ATTR(enable_differential_output, 0664,
> +			attr_enable_differential_output_show,
> +				attr_enable_differential_output_store),
> +	__ATTR(pressure_reference_level, 0664,
> +			attr_pressure_reference_show,
> +					attr_pressure_reference_store),
> +	__ATTR(lowpower_enable, 0664,
> +			attr_enable_lowpowermode_show,
> +					attr_enable_lowpowermode_store),
> +};
> +
> +static int lps001wp_prs_create_sysfs_interfaces(struct device *dev)
> +{
> +	int i, ret;
This looks like a reimplementation of the sysfs_create_group code.
Please use that instead of reinventing the wheel.
> +	for (i = 0; i < ARRAY_SIZE(attributes); i++)
> +		ret = device_create_file(dev, attributes + i);
> +		if (ret < 0)
> +			goto error;
> +	return 0;
> +
> +error:
> +	for ( ; i >= 0; i--)
> +		device_remove_file(dev, attributes + i);
> +	dev_err(dev, "%s:Unable to create interface\n", __func__);
> +	return ret;
> +}
> +
> +static void lps001wp_prs_remove_sysfs_interfaces(struct device *dev)
> +{
> +	int i;
> +	for (i = 0; i < ARRAY_SIZE(attributes); i++)
> +		device_remove_file(dev, attributes + i);
> +}
> +
> +
> +static void lps001wp_prs_input_work_func(struct work_struct *work)
> +{
> +	struct lps001wp_prs_data *prs = container_of(
> +			(struct delayed_work *)work,
> +			struct lps001wp_prs_data,
> +			input_work);
> +
> +	struct outputdata output;
> +	int err;
> +
> +	mutex_lock(&prs->lock);
> +	err = lps001wp_prs_get_presstemp_data(prs, &output);
> +	if (err < 0)
> +		dev_err(&prs->client->dev, "get_pressure_data failed\n");
> +	else
> +		lps001wp_prs_report_values(prs, &output);
> +
> +	schedule_delayed_work(&prs->input_work,
> +				msecs_to_jiffies(prs->pdata->poll_interval));
> +	mutex_unlock(&prs->lock);
> +}
> +
> +int lps001wp_prs_input_open(struct input_dev *input)
> +{
> +	struct lps001wp_prs_data *prs = input_get_drvdata(input);
> +
Could be considerably more consistent between this and the next function.
Either is fine but it makes for easier reading if you use the same names
and layout.
> +	return lps001wp_prs_enable(prs);
> +}
> +
> +void lps001wp_prs_input_close(struct input_dev *dev)
> +{
> +	lps001wp_prs_disable(input_get_drvdata(dev));
> +}
> +
> +
> +static int lps001wp_prs_validate_pdata(struct lps001wp_prs_data *prs)
> +{
> +	/* Enforce minimum polling interval */
> +	if (prs->pdata->poll_interval < prs->pdata->min_interval) {
> +		dev_err(&prs->client->dev, "minimum poll interval violated\n");
> +		return -EINVAL;
> +	}
> +	return 0;
> +}
> +
> +static int lps001wp_prs_input_init(struct lps001wp_prs_data *prs)
> +{
> +	int err;
> +
> +	INIT_DELAYED_WORK(&prs->input_work, lps001wp_prs_input_work_func);
> +	prs->input_dev = input_allocate_device();
> +	if (!prs->input_dev) {
> +		err = -ENOMEM;
> +		dev_err(&prs->client->dev, "input device allocate failed\n");
> +		goto err0;
> +	}
> +
> +	prs->input_dev->open = lps001wp_prs_input_open;
> +	prs->input_dev->close = lps001wp_prs_input_close;
> +	prs->input_dev->name = LPS001WP_PRS_DEV_NAME;
> +	prs->input_dev->id.bustype = BUS_I2C;
> +	prs->input_dev->dev.parent = &prs->client->dev;
> +
> +	input_set_drvdata(prs->input_dev, prs);
> +
> +	set_bit(EV_ABS, prs->input_dev->evbit);
> +
> +	input_set_abs_params(prs->input_dev, ABS_PR,
> +			PR_ABS_MIN, PR_ABS_MAX, FUZZ, FLAT);
> +	input_set_abs_params(prs->input_dev, ABS_TEMP,
> +			PR_DLT_MIN, PR_DLT_MAX, FUZZ, FLAT);
> +	input_set_abs_params(prs->input_dev, ABS_DLTPR,
> +			TEMP_MIN, TEMP_MAX, FUZZ, FLAT);
> +
> +
> +	prs->input_dev->name = "LPS001WP barometer";
> +
> +	err = input_register_device(prs->input_dev);
> +	if (err) {
> +		dev_err(&prs->client->dev,
> +			"unable to register input polled device %s\n",
> +			prs->input_dev->name);
> +		goto err1;
> +	}
> +
> +	return 0;
> +
> +err1:
> +	input_free_device(prs->input_dev);
> +err0:
> +	return err;
> +}
> +
> +static void lps001wp_prs_input_cleanup(struct lps001wp_prs_data *prs)
> +{
> +	input_unregister_device(prs->input_dev);
> +	input_free_device(prs->input_dev);
> +}
> +
> +static int __devinit lps001wp_prs_probe(struct i2c_client *client,
> +					const struct i2c_device_id *id)
> +{
> +	struct lps001wp_prs_data *prs;
> +	int err = -1;
> +	int tempvalue;
> +
> +	pr_info("%s: probe start.\n", LPS001WP_PRS_DEV_NAME);
This sort of debugging info probably wants to be cleared out of
a driver before submitting.
> +
> +	if (client->dev.platform_data == NULL) {
> +		dev_err(&client->dev, "platform data is NULL. exiting.\n");
> +		err = -ENODATA;
> +		goto err_exit_check_functionality_failed;
> +	}
> +
> +	if (!i2c_check_functionality(client->adapter, I2C_FUNC_I2C)) {
> +		dev_err(&client->dev, "client not i2c capable\n");
> +		err = -EIO;
> +		goto err_exit_check_functionality_failed;
> +	}
> +
> +	if (!i2c_check_functionality(client->adapter,
> +					I2C_FUNC_SMBUS_BYTE |
> +					I2C_FUNC_SMBUS_BYTE_DATA |
> +					I2C_FUNC_SMBUS_WORD_DATA)) {
> +		dev_err(&client->dev, "client not smb-i2c capable\n");
> +		err = -EIO;
> +		goto err_exit_check_functionality_failed;
> +	}
> +
> +
> +	if (!i2c_check_functionality(client->adapter,
> +						I2C_FUNC_SMBUS_I2C_BLOCK)){
> +		dev_err(&client->dev, "client not smb-i2c block capable\n");
> +		err = -EIO;
> +		goto err_exit_check_functionality_failed;
> +	}
> +
> +
> +	prs = kzalloc(sizeof(struct lps001wp_prs_data), GFP_KERNEL);
> +	if (prs == NULL) {
> +		err = -ENOMEM;
> +		dev_err(&client->dev,
> +				"failed to allocate memory for module data: "
> +					"%d\n", err);
> +		goto err_exit_alloc_data_failed;
> +	}
> +
> +	mutex_init(&prs->lock);
> +	mutex_lock(&prs->lock);
> +
> +	prs->client = client;
> +	i2c_set_clientdata(client, prs);
> +
> +
> +	if (i2c_smbus_read_byte(client) < 0) {
Please retain the error value returned by i2c_smbus_read_byte and
return that from this function.  Where possible it is best to
pass as much information about errors as possible on.

> +		printk(KERN_ERR "i2c_smbus_read_byte error\n");
> +		goto err_mutexunlockfreedata;
> +	}
> +
> +	/* read chip id */
> +	tempvalue = i2c_smbus_read_word_data(client, WHO_AM_I);
> +	if ((tempvalue & 0x00FF) == WHOAMI_LPS001WP_PRS) {
> +		printk(KERN_INFO "%s I2C driver registered\n",
> +							LPS001WP_PRS_DEV_NAME);
> +	} else {
> +		prs->client = NULL;
> +		printk(KERN_ERR "I2C driver not registered!"
> +				" Device unknown\n");
Please handle the wrong returned value vs a return code being returned separately.

> +		err = -ENODEV;
> +		goto err_mutexunlockfreedata;
> +	}
> +
> +	prs->pdata = kmemdup(client->dev.platform_data,
> +					sizeof(*prs->pdata), GFP_KERNEL);
> +	if (!prs->pdata) {
> +		err = -ENOMEM;
> +		dev_err(&client->dev,
> +				"failed to allocate memory for pdata: %d\n",
> +				err);
> +		goto err_mutexunlockfreedata;
> +	}
> +
> +
> +	err = lps001wp_prs_validate_pdata(prs);
> +	if (err < 0) {
> +		dev_err(&client->dev, "failed to validate platform data\n");
> +		goto err_exit_kfree_pdata;
> +	}
> +
> +	if (prs->pdata->init) {
> +		err = prs->pdata->init();
> +		if (err < 0) {
> +			dev_err(&client->dev, "init failed: %d\n", err);
> +			goto err_exit_pointer;
Should generally be the the init function that clears up an internal errors.
Hence if it fails, you probably don't want to run the exit function.
> +		}
> +	}
> +
> +	/* init registers which need values different from zero:
> +	   zeros are set by kzallok above */
> +	prs->resume_state[LPS001WP_RES_CTRL_REG1] = LPS001WP_PRS_PM_NORMAL;
> +
> +	err = lps001wp_prs_device_power_on(prs);
> +	if (err < 0) {
> +		dev_err(&client->dev, "power on failed: %d\n", err);
> +		goto err_exit_pointer;
> +	}
> +
> +	prs->pressure_delta_enabled = 0;
> +	prs->lpowmode_enabled = 0;
> +	atomic_set(&prs->enabled, 1);
> +
> +	err = lps001wp_prs_update_odr(prs, prs->pdata->poll_interval);
> +	if (err < 0) {
> +		dev_err(&client->dev, "update_odr failed\n");
> +		goto err_power_off;
> +	}
> +
> +	err = lps001wp_prs_input_init(prs);
> +	if (err < 0) {
> +		dev_err(&client->dev, "input init failed\n");
> +		goto err_power_off;
> +	}
> +
> +
> +	err = lps001wp_prs_create_sysfs_interfaces(&client->dev);
> +	if (err < 0)
> +		goto err_input_cleanup;
> +
> +	lps001wp_prs_device_power_off(prs);
> +
> +	/* As default, do not report information */
> +	atomic_set(&prs->enabled, 0);
> +
> +
> +	mutex_unlock(&prs->lock);
> +
> +	dev_info(&client->dev, "%s: probed\n", LPS001WP_PRS_DEV_NAME);
> +
> +	return 0;
> +
> +/*
> +err_remove_sysfs_int:
> +	lps001wp_prs_remove_sysfs_interfaces(&client->dev);
> +*/
Guessing this commented out line is a left over from some debugging?
Please clean it up.
> +err_input_cleanup:
> +	lps001wp_prs_input_cleanup(prs);
> +err_power_off:
> +	lps001wp_prs_device_power_off(prs);
> +err_exit_pointer:
> +	if (prs->pdata->exit)
> +		prs->pdata->exit();
> +err_exit_kfree_pdata:
> +	kfree(prs->pdata);
loose this blank line.
> +
> +err_mutexunlockfreedata:
> +	mutex_unlock(&prs->lock);
> +	kfree(prs);
> +err_exit_alloc_data_failed:
> +err_exit_check_functionality_failed:
> +	printk(KERN_ERR "%s: Driver Init failed\n", LPS001WP_PRS_DEV_NAME);
> +	return err;
> +}
> +
> +static int __devexit lps001wp_prs_remove(struct i2c_client *client)
> +{
> +	struct lps001wp_prs_data *prs = i2c_get_clientdata(client);
> +
> +	lps001wp_prs_input_cleanup(prs);
> +	lps001wp_prs_device_power_off(prs);
> +	lps001wp_prs_remove_sysfs_interfaces(&client->dev);
> +
> +	if (prs->pdata->exit)
> +		prs->pdata->exit();
> +	kfree(prs->pdata);
> +	kfree(prs);
> +
> +	return 0;
> +}
> +
> +#ifdef CONFIG_PM
> +static int lps001wp_prs_resume(struct i2c_client *client)
> +{
> +	struct lps001wp_prs_data *prs = i2c_get_clientdata(client);
> +
> +	if (prs->on_before_suspend)
> +		return lps001wp_prs_enable(prs);
> +	return 0;
> +}
> +
> +static int lps001wp_prs_suspend(struct i2c_client *client, pm_message_t mesg)
> +{
> +	struct lps001wp_prs_data *prs = i2c_get_clientdata(client);
> +
> +	prs->on_before_suspend = atomic_read(&prs->enabled);
> +	return lps001wp_prs_disable(prs);
> +}
> +#else
> +#define lps001wp_prs_resume	NULL
> +#define	lps001wp_prs_suspend	NULL
Formatting consistency issue.  Two lines above is a space, one line
above a tab.  Either option is fine, but they want to be the same.
> +#endif /* CONFIG_PM */
> +
> +static const struct i2c_device_id lps001wp_prs_id[]
> +		= { { LPS001WP_PRS_DEV_NAME, 0}, { },};
> +
> +MODULE_DEVICE_TABLE(i2c, lps001wp_prs_id);
> +
> +static struct i2c_driver lps001wp_prs_driver = {
> +	.driver = {
> +			.name = LPS001WP_PRS_DEV_NAME,
> +			.owner = THIS_MODULE,
> +	},
> +	.probe = lps001wp_prs_probe,
> +	.remove = __devexit_p(lps001wp_prs_remove),
> +	.id_table = lps001wp_prs_id,
> +	.resume = lps001wp_prs_resume,
> +	.suspend = lps001wp_prs_suspend,
> +};
> +
> +static int __init lps001wp_prs_init(void)
> +{
> +	return i2c_add_driver(&lps001wp_prs_driver);
> +}
> +
> +static void __exit lps001wp_prs_exit(void)
> +{
> +	i2c_del_driver(&lps001wp_prs_driver);
> +	return;
> +}
> +
> +module_init(lps001wp_prs_init);
> +module_exit(lps001wp_prs_exit);
> +
> +MODULE_DESCRIPTION("STMicrolelectronics lps001wp pressure sensor sysfs driver");
> +MODULE_AUTHOR("Matteo Dameno, Carmine Iascone, STMicroelectronics");
> +MODULE_LICENSE("GPL");
> +
> --
> 1.5.4.3
> 
> 

