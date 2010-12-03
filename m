Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752908Ab0LCQV5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Dec 2010 11:21:57 -0500
Received: from ppsw-51.csi.cam.ac.uk ([131.111.8.151]:55484 "EHLO
	ppsw-51.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751450Ab0LCQVz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Dec 2010 11:21:55 -0500
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4CF91AAB.5030408@cam.ac.uk>
Date: Fri, 03 Dec 2010 16:28:27 +0000
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101123 Lightning/1.0b3pre Thunderbird/3.1.6
MIME-Version: 1.0
To: mems applications <mems.applications@st.com>
CC: dmitry.torokhov@gmail.com, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, matteo.dameno@st.com,
        carmine.iascone@st.com
Subject: Re: [PATCH] input: misc: add lps001wp_prs driver
References: <matteo.dameno@st.com> <1291049009-32597-1-git-send-email-matteo.dameno@st.com>
In-Reply-To: <1291049009-32597-1-git-send-email-matteo.dameno@st.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/29/10 16:43, mems applications wrote:
> From: mems <mems@mems-laptopT43.(none)>
> 
> Added STMicroelectronics LPS001WP pressure sensor device driver

Hi All,

Firstly for those not following the thread. I am reviewing under
the assumption the driver will move out of input.


Review done backwards, so reading the email from the bottom may
make more sense...

There is a fair bit of general cleanup needed in this driver, but
the code looks fundamentally fine to me.

I'd like to see some documentation to accompany this driver.  Without
datasheet diving it's unclear what some of the interface elements are
for.

This is very much a first glance, but cleaning up the silly formatting
issues etc will make future reviews a lot easier.  As a general rule
do this sort of stuff before submitting as it keeps reviewers more
likely to read your drivers!

> 
> Signed-off-by: Matteo Dameno <matteo.dameno@st.com>
> ---
>  drivers/input/misc/Kconfig        |   10 +
>  drivers/input/misc/Makefile       |    2 +
>  drivers/input/misc/lps001wp_prs.c | 1288 +++++++++++++++++++++++++++++++++++++
>  include/linux/input/lps001wp.h    |   82 +++
>  4 files changed, 1382 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/input/misc/lps001wp_prs.c
>  create mode 100644 include/linux/input/lps001wp.h
> 
> diff --git a/drivers/input/misc/Kconfig b/drivers/input/misc/Kconfig
> index b99b8cb..689856a 100644
> --- a/drivers/input/misc/Kconfig
> +++ b/drivers/input/misc/Kconfig
> @@ -448,4 +448,14 @@ config INPUT_ADXL34X_SPI
>  	  To compile this driver as a module, choose M here: the
>  	  module will be called adxl34x-spi.
>  
> +config INPUT_LPS001WP_PRS
> +	tristate "STMicro LPS001WP Pressure Temperature Sensor"
> +	depends on I2C
> +	default n
> +	help
> +	 If you say yes here you get support for the 
> +	 STM LPS001D Barometer/Termometer on I2C bus.
Probably a typo in Termometer?  
> +	 This driver can also be built as a module (choose M).
> +	 If so, the module will be called lps001wp_prs.
> +
>  endif
> diff --git a/drivers/input/misc/Makefile b/drivers/input/misc/Makefile
> index 1fe1f6c..0165e60 100644
> --- a/drivers/input/misc/Makefile
> +++ b/drivers/input/misc/Makefile
> @@ -42,4 +42,6 @@ obj-$(CONFIG_INPUT_WINBOND_CIR)		+= winbond-cir.o
>  obj-$(CONFIG_INPUT_WISTRON_BTNS)	+= wistron_btns.o
>  obj-$(CONFIG_INPUT_WM831X_ON)		+= wm831x-on.o
>  obj-$(CONFIG_INPUT_YEALINK)		+= yealink.o
> +obj-$(CONFIG_INPUT_LPS001WP_PRS)	+= lps001wp_prs.o
Side note. The rest of these were in alphabetical order by the look of it...
> +
>  
> diff --git a/drivers/input/misc/lps001wp_prs.c b/drivers/input/misc/lps001wp_prs.c
> new file mode 100644
> index 0000000..e1a3a95
> --- /dev/null
> +++ b/drivers/input/misc/lps001wp_prs.c
> @@ -0,0 +1,1288 @@
> +
> +/******************** (C) COPYRIGHT 2010 STMicroelectronics ********************
> +*
> +* File Name	: lps001wp_prs.c
> +* Authors	: MSH - Motion Mems BU - Application Team
> +*		: Matteo Dameno (matteo.dameno@st.com)
> +*		: Carmine Iascone (carmine.iascone@st.com)
> +*		: Both authors are willing to be considered the contact
> +*		: and update points for the driver.
> +* Version	: V 1.1.1
> +* Date		: 05/11/2010
> +* Description	: LPS001WP 6D module sensor API
> +*
> +********************************************************************************
> +*
> +* This program is free software; you can redistribute it and/or modify
> +* it under the terms of the GNU General Public License version 2 as
> +* published by the Free Software Foundation.
> +*
> +* THE PRESENT SOFTWARE IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES
> +* OR CONDITIONS OF ANY KIND, EITHER EXPRESS OR IMPLIED, FOR THE SOLE
> +* PURPOSE TO SUPPORT YOUR APPLICATION DEVELOPMENT.
> +* AS A RESULT, STMICROELECTRONICS SHALL NOT BE HELD LIABLE FOR ANY DIRECT,
> +* INDIRECT OR CONSEQUENTIAL DAMAGES WITH RESPECT TO ANY CLAIMS ARISING FROM THE
> +* CONTENT OF SUCH SOFTWARE AND/OR THE USE MADE BY CUSTOMERS OF THE CODING
> +* INFORMATION CONTAINED HEREIN IN CONNECTION WITH THEIR PRODUCTS.
> +*
> +* THIS SOFTWARE IS SPECIFICALLY DESIGNED FOR EXCLUSIVE USE WITH ST PARTS.
> +*
> +******************************************************************************
> +
> + Revision 0.9.0 01/10/2010:
> +	first beta release
> + Revision 1.1.0 05/11/2010:
> +	add sysfs management
> + Revision 1.1.1 22/11/2010:
> +	moved to input/misc
> +	updated USHRT_MAX,SHRT_MAX,SHRT_MIN macros
> +******************************************************************************/
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
> +#include <linux/gpio.h>
> +#include <linux/interrupt.h>
> +#include <linux/device.h>
> +#include <linux/slab.h>
> +#include <linux/kernel.h>
> +
> +#include <linux/input/lps001wp.h>
> +
> +
> +
> +#define	DEBUG	1
This shouldn't be in a submitted driver....

> +
> +
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
> +
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
> +#define PRESS_OUT_L	OUTDATA_REG
> +
> +
> +#define	REF_P_L		INDATA_REG	/*	pressure reference	*/
> +#define	REF_P_H		0x31		/*	pressure reference	*/
> +#define	THS_P_L		0x32		/*	pressure threshold	*/
> +#define	THS_P_H		0x33		/*	pressure threshold	*/
> +
> +#define	INT_CFG		0x34		/*	interrupt config	*/
> +#define	INT_SRC		0x35		/*	interrupt source	*/
> +#define	INT_ACK		0x36		/*	interrupt acknoledge	*/
> +/*	end CONTROL REGISTRES	*/
> +
> +
> +/* Barometer and Termometer output data rate ODR */
> +#define	LPS001WP_PRS_ODR_MASK	0x30	/* Mask to access odr bits only	*/
> +#define	LPS001WP_PRS_ODR_7_1	0x00	/* 7Hz baro and 1Hz term ODR	*/
> +#define	LPS001WP_PRS_ODR_7_7	0x01	/* 7Hz baro and 7Hz term ODR	*/
> +#define	LPS001WP_PRS_ODR_12_12	0x11	/* 12.5Hz baro and 12.5Hz term ODR */
> +
> +
> +#define	LPS001WP_PRS_ENABLE_MASK	0x40	/*  */ 
?
> +#define	LPS001WP_PRS_DIFF_MASK		0x08
> +#define LPS001WP_PRS_LPOW_MASK		0x80
inconsistent.
> +
> +#define	LPS001WP_PRS_DIFF_ON		0x08
> +#define	LPS001WP_PRS_DIFF_OFF		0x00
> +
> +#define	LPS001WP_PRS_LPOW_ON		0x80
> +#define	LPS001WP_PRS_LPOW_OFF		0x00
> +
> +#define	FUZZ			0
> +#define	FLAT			0
> +#define	I2C_RETRY_DELAY		5
> +#define	I2C_RETRIES		5
> +#define	I2C_AUTO_INCREMENT	0x80
> +
> +/* RESUME STATE INDICES */
> +#define	RES_CTRL_REG1		0
> +#define	RES_CTRL_REG2		1
> +#define	RES_CTRL_REG3		2
> +#define	RES_REF_P_L		3
> +#define	RES_REF_P_H		4
> +#define	RES_THS_P_L		5
> +#define	RES_THS_P_H		6
> +#define	RES_INT_CFG		7
> +
> +#define	RESUME_ENTRIES		8
Ideally all these defines would be more device specific
LPS001WP_RES_CTRL_REG1 etc as it makes accidental clashes
much less likely in future.

> +/* end RESUME STATE INDICES */
The fact you start something else probably gives this
away without the comment...
> +
> +/* Pressure Sensor Operating Mode */
> +#define	LPS001WP_PRS_DIFF_ENABLE	1
> +#define LPS001WP_PRS_DIFF_DISABLE	0
inconsistent formatting here. Also you appear to be
defining true and false here. Probably not a good idea...

> +#define	LPS001WP_PRS_LPOWER_EN		1
> +#define	LPS001WP_PRS_LPOWER_DIS		0
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
> +	u8 diff_enabled;
> +	u8 lpowmode_enabled ;
> +
> +	atomic_t enabled;
> +	int on_before_suspend;
> +
> +	u8 resume_state[RESUME_ENTRIES];
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
> +
> +static int lps001wp_prs_i2c_read(struct lps001wp_prs_data *prs,
> +				  u8 *buf, int len)
> +{
> +	int err;
> +	int tries = 0;
> +
> +	struct i2c_msg msgs[] = {
> +		{
> +		 .addr = prs->client->addr,
> +		 .flags = prs->client->flags & I2C_M_TEN,
> +		 .len = 1,
> +		 .buf = buf,
> +		 },
}, {
> +		{
> +		 .addr = prs->client->addr,
> +		 .flags = (prs->client->flags & I2C_M_TEN) | I2C_M_RD,
> +		 .len = len,
> +		 .buf = buf,
> +		 },
> +	};
> +
> +	do {
> +		err = i2c_transfer(prs->client->adapter, msgs, 2);
> +		if (err != 2)
> +			msleep_interruptible(I2C_RETRY_DELAY);
> +	} while ((err != 2) && (++tries < I2C_RETRIES));
> +
> +	if (err != 2) {
> +		dev_err(&prs->client->dev, "read transfer error\n");
> +		err = -EIO;
> +	} else {
> +		err = 0;
> +	}
> +
> +	return err;
> +}
> +
> +static int lps001wp_prs_i2c_write(struct lps001wp_prs_data *prs,
> +				   u8 *buf, int len)
> +{
> +	int err;
> +	int tries = 0;
> +	struct i2c_msg msgs[] = {
> +		{
> +		 .addr = prs->client->addr,
> +		 .flags = prs->client->flags & I2C_M_TEN,
> +		 .len = len + 1,
> +		 .buf = buf,
> +		 },
> +	};
> +
> +	do {
> +		err = i2c_transfer(prs->client->adapter, msgs, 1);
> +		if (err != 1)
> +			msleep_interruptible(I2C_RETRY_DELAY);
> +	} while ((err != 1) && (++tries < I2C_RETRIES));
> +
i2c transfre may have given a real error, so check that first and
pass on if it did. This check then confirms that it sent the right
amount of data.  Does this commonly fail?  It's unusual to hard code
in retrying unless you know a part unless there is a very specific
and well understood reason for it.

> +	if (err != 1) {
> +		dev_err(&prs->client->dev, "write transfer error\n");
> +		err = -EIO;
> +	} else {
> +		err = 0;
> +	}
> +
> +	return err;
> +}
> +
> +static int lps001wp_prs_i2c_update(struct lps001wp_prs_data *prs,
> +			u8 reg_address, u8 mask, u8 new_bit_values)
> +{
> +	int err = -1;
Why init?
> +	u8 rdbuf[1] = { reg_address };
> +	u8 wrbuf[2] = { reg_address , 0x00 };
> +
> +	u8 init_val;
> +	u8 updated_val;
> +	err = lps001wp_prs_i2c_read(prs, rdbuf, 1);
> +	if (!(err < 0)) {
> +		init_val = rdbuf[0];
> +		updated_val = ((mask & new_bit_values) | ((~mask) & init_val));
> +		wrbuf[1] = updated_val;
> +		err = lps001wp_prs_i2c_write(prs, wrbuf, 2);
> +	}
> +	return err;
> +}
> +/* */
> +
> +static int lps001wp_prs_register_write(struct lps001wp_prs_data *prs, u8 *buf,
> +		u8 reg_address, u8 new_value)
> +{
> +	int err = -1;
No need to init.
> +
> +	/* Sets configuration register at reg_address
> +	 *  NOTE: this is a straight overwrite  */
> +	buf[0] = reg_address;
> +	buf[1] = new_value;
> +	err = lps001wp_prs_i2c_write(prs, buf, 1);
> +	if (err < 0)
> +		return err;
> +	return err;
> +}
> +
> +static int lps001wp_prs_register_read(struct lps001wp_prs_data *prs, u8 *buf,
> +		u8 reg_address)
> +{
> +
> +	int err = -1;
No need to init.

> +	buf[0] = (reg_address);
No need for brackets.

> +	err = lps001wp_prs_i2c_read(prs, buf, 1);
> +
> +	return err;
> +}
> +
> +static int lps001wp_prs_register_update(struct lps001wp_prs_data *prs, u8 *buf,
> +		u8 reg_address, u8 mask, u8 new_bit_values)
> +{
> +	int err = -1;
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
> +/* */
Nice comment....
> +
> +
> +static int lps001wp_prs_hw_init(struct lps001wp_prs_data *prs)
> +{
> +	int err = -1;
> +	u8 buf[6];
> +
We don't need to know this now the driver is written.
> +	printk(KERN_DEBUG "%s: hw init start\n", LPS001WP_PRS_DEV_NAME);
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
> +	buf[1] = prs->resume_state[RES_REF_P_L];
> +	buf[2] = prs->resume_state[RES_REF_P_H];
> +	buf[3] = prs->resume_state[RES_THS_P_L];
> +	buf[4] = prs->resume_state[RES_THS_P_H];
> +	err = lps001wp_prs_i2c_write(prs, buf, 4);
> +	if (err < 0)
> +		goto error1;
> +
> +	buf[0] = (I2C_AUTO_INCREMENT | CTRL_REG1);
> +	buf[1] = prs->resume_state[RES_CTRL_REG1];
> +	buf[2] = prs->resume_state[RES_CTRL_REG2];
> +	buf[3] = prs->resume_state[RES_CTRL_REG3];
> +	err = lps001wp_prs_i2c_write(prs, buf, 3);
> +	if (err < 0)
> +		goto error1;
> +
> +	buf[0] = INT_CFG;
> +	buf[1] = prs->resume_state[RES_INT_CFG];
> +	err = lps001wp_prs_i2c_write(prs, buf, 1);
> +	if (err < 0)
> +		goto error1;
> +
> +
> +	prs->hw_initialized = 1;
We really don't need to know this unless it commonly fails?
> +	printk(KERN_DEBUG "%s: hw init done\n", LPS001WP_PRS_DEV_NAME);
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
> +	if (prs->hw_initialized) {
> +		; 
?

> +		prs->hw_initialized = 0;
> +	}
checkpatch will tell you that you have unneeded brackets...
> +
> +}
> +
> +static int lps001wp_prs_device_power_on(struct lps001wp_prs_data *prs)
> +{
> +	int err = -1;
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
> +		prs->resume_state[RES_CTRL_REG1] = init_val;
> +
> +		buf[0] = CTRL_REG1;
> +		updated_val = ((mask & new_val) | ((~mask) & init_val));
> +		buf[1] = updated_val;
> +		buf[0] = CTRL_REG1;
You just set buf[0] 3 lines up...

> +		err = lps001wp_prs_i2c_write(prs, buf, 1);
> +		if (err < 0)
> +			goto error;
> +		prs->resume_state[RES_CTRL_REG1] = updated_val;
> +	}
> +	return err;
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
> +	int err = -1;
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
> +				prs->resume_state[RES_REF_P_L]);
> +		return err;
> +	}
> +	prs->resume_state[RES_REF_P_L] = bit_valuesL;
> +	prs->resume_state[RES_REF_P_H] = bit_valuesH;
> +	return err;
> +}
> +
> +static int lps001wp_prs_get_press_reference(struct lps001wp_prs_data *prs,
> +		u16 *buf16)
> +{
> +	int err = -1;
why init?
> +
> +	u8 bit_valuesL, bit_valuesH;
> +	u8 buf[2] = {0};
Does it need to be initilaized?

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
> +	int err = -1;
> +	u8 buf[2] = {0x00, 0x00};
> +	u8 const mask = LPS001WP_PRS_LPOW_MASK;
> +	u8 bit_values = LPS001WP_PRS_LPOW_OFF;
> +
> +	if (control >= LPS001WP_PRS_LPOWER_EN) {
Is this just verifying if the value is not 0?  If so get
rid of the confusing define and just do
if (control)
> +		;
?
> +		bit_values = LPS001WP_PRS_LPOW_ON;
> +	}
> +
> +	err = lps001wp_prs_register_update(prs, buf, CTRL_REG1,
> +			mask, bit_values);
> +
> +	if (err < 0)
> +		return err;
> +	prs->resume_state[RES_CTRL_REG1] = ((mask & bit_values) |
> +			(~mask & prs->resume_state[RES_CTRL_REG1]));
> +	if (bit_values == LPS001WP_PRS_LPOW_ON)
> +		prs->lpowmode_enabled = 1;
> +	else
> +		prs->lpowmode_enabled = 0;
> +	return err;
> +}
> +
> +static int lps001wp_prs_diffen_manage(struct lps001wp_prs_data *prs, u8 control)
> +{
> +	int err = -1;
No need to init.
> +	u8 buf[2] = {0x00, 0x00};
Need to init buf?

> +	u8 const mask = LPS001WP_PRS_DIFF_MASK;
> +	u8 bit_values = LPS001WP_PRS_DIFF_OFF;
> +
> +	if (control >= LPS001WP_PRS_DIFF_ENABLE) {
Checking if 0. Make that apparent, don't hide it in a define.
> +		;
?
> +		bit_values = LPS001WP_PRS_DIFF_ON;
> +	}
Please run checkpatch.pl over this as there are some element I
would imagine it will point out in the formating.

> +
> +	err = lps001wp_prs_register_update(prs, buf, CTRL_REG1,
> +			mask, bit_values);
> +
> +	if (err < 0)
> +		return err;
> +	prs->resume_state[RES_CTRL_REG1] = ((mask & bit_values) |
> +			(~mask & prs->resume_state[RES_CTRL_REG1]));
> +	if (bit_values == LPS001WP_PRS_DIFF_ON)
> +		prs->diff_enabled = 1;
> +	else
> +		prs->diff_enabled = 0;
prs->diff_enabled = !!(bit_values ==  LPS001WP_PRS_DIFF_ON);

> +	return err;
> +}
> +
> +
> +static int lps001wp_prs_get_presstemp_data(struct lps001wp_prs_data *prs,
> +						struct outputdata *out)
> +{
> +	int err = -1;
> +	/* Data bytes from hardware	PRESS_OUT_L, PRESS_OUT_H,
> +	 *				TEMP_OUT_L, TEMP_OUT_H,
> +	 *				DELTA_L, DELTA_H */
> +	u8 prs_data[6];

u8 prs_data[6] = {
   (I2C_AUTO_INCREMENT | OUTDATA_REG),   
}; 

Technically may be more computationaly expensive, but only marginally
and it's easier to read. Note all other values will be zeroed.
> +
> +	u16 abspr;
> +	s16 temperature, deltapr;
> +	int regToRead = 4;
> +	prs_data[4] = 0;
> +	prs_data[5] = 0;
> +
> +	if (prs->diff_enabled)
> +		regToRead = 6;
> +
> +	prs_data[0] = (I2C_AUTO_INCREMENT | OUTDATA_REG);
> +	err = lps001wp_prs_i2c_read(prs, prs_data, regToRead);
> +	if (err < 0)
> +		return err;
> +
> +	abspr = ((((u16) prs_data[1] << 8) | ((u16) prs_data[0])));
As prs_data is aligned you can use soem of the endian switching functions
to do this.

> +	temperature = ((s16) (((u16) prs_data[3] << 8) | ((u16)prs_data[2])));
> +
> +	out->abspress = abspr;
Why the use of temporaries to construct these values if you are only going to
assign them here?
> +	out->temperature = temperature;
> +
> +	deltapr = ((s16) (((u16) prs_data[5] << 8) | ((u16)prs_data[4])));
Again, suitable endian funcs should do this nice and cleanly. It also may
not be necessary depending on endianness of the machine (may be a simple
copy).
> +	out->deltapress = deltapr;
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
> +static ssize_t read_single_reg(struct device *dev, char *buf, u8 reg)
> +{
> +	ssize_t ret;
> +	struct lps001wp_prs_data *prs = dev_get_drvdata(dev);
> +	int rc = 0;
> +
> +	u8 data = reg;
> +	rc = lps001wp_prs_i2c_read(prs, &data, 1);
> +	/*TODO: error need to be managed */
> +	ret = sprintf(buf, "0x%02x\n", data);
That's going to want fixing :) Actually function doesn't seem to be
called so clean it out entirely.

> +	return ret;
> +
> +}
> +
> +static int write_reg(struct device *dev, const char *buf, u8 reg)
Is this used anywhere?
> +{
> +	int rc = 0;
> +	struct lps001wp_prs_data *prs = dev_get_drvdata(dev);
> +	u8 x[2];
> +	unsigned long val;
> +
> +	if (strict_strtoul(buf, 16, &val))
> +		return -EINVAL;
> +
> +	x[0] = reg;
> +	x[1] = val;
> +	rc = lps001wp_prs_i2c_write(prs, x, 1);
> +	/*TODO: error need to be managed */
> +	return rc;
> +}
> +
> +static ssize_t attr_get_polling_rate(struct device *dev,
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
> +static ssize_t attr_set_polling_rate(struct device *dev,
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
> +static ssize_t attr_get_diff_enable(struct device *dev,
> +				     struct device_attribute *attr,
> +				     char *buf)
> +{
> +	u8 val;
> +	struct lps001wp_prs_data *prs = dev_get_drvdata(dev);
> +	mutex_lock(&prs->lock);
> +	val = prs->diff_enabled;
> +	mutex_unlock(&prs->lock);
> +	return sprintf(buf, "%d\n", val);
> +}
> +
> +static ssize_t attr_set_diff_enable(struct device *dev,
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
I'm unclear what values val can take here. They look a little bit
magic to me...
> +	lps001wp_prs_diffen_manage(prs, (u8) val);
> +	mutex_unlock(&prs->lock);
> +	return size;
> +}
> +
> +static ssize_t attr_get_enable(struct device *dev,
> +				struct device_attribute *attr, char *buf)
> +{
> +	struct lps001wp_prs_data *prs = dev_get_drvdata(dev);
> +	int val = atomic_read(&prs->enabled);
> +	return sprintf(buf, "%d\n", val);
> +}
> +
> +static ssize_t attr_set_enable(struct device *dev,
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
> +static ssize_t attr_get_press_ref(struct device *dev,
> +				  struct device_attribute *attr, char *buf)
> +{
> +	int err = -1;
No need to initialize err.
> +	struct lps001wp_prs_data *prs = dev_get_drvdata(dev);
> +	u16 val = 0;
or I'd imagine val?
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
What are the units of the reference pressure?  If they are not
in appropriate SI units, then either you will want to convert them
or take a look at how we handle _scale and _offset in IIO.
> +static ssize_t attr_set_press_ref(struct device *dev,
> +				  struct device_attribute *attr,
> +				  const char *buf, size_t size)
> +{
> +	int err = -1;
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
> +static ssize_t attr_get_lowpowmode(struct device *dev,
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
> +static ssize_t attr_set_lowpowmode(struct device *dev,
> +				   struct device_attribute *attr,
> +				   const char *buf, size_t size)
> +{
> +	int err = -1;
err is always set. So no need to initialize.
> +	struct lps001wp_prs_data *prs = dev_get_drvdata(dev);
> +	unsigned long val;
> +
> +	if (strict_strtoul(buf, 10, &val))
> +		return -EINVAL;
> +
> +	mutex_lock(&prs->lock);
> +	err = lps001wp_prs_lpow_manage(prs, (u8) val);
This looks like it might involve some magic numbers.  Documentation
might show be to be wrong, but it certainly looks suspicious.

> +	mutex_unlock(&prs->lock);
> +	if (err < 0)
> +		return err;
Blank line here would make this more readable.
> +	return size;
> +}
> +
> +
> +#ifdef DEBUG
None of these have any place in a driver being submitted to the kernel.
Please remove them.

> +static ssize_t attr_reg_set(struct device *dev, struct device_attribute *attr,
> +				const char *buf, size_t size)
> +{
> +	int rc;
> +	struct lps001wp_prs_data *prs = dev_get_drvdata(dev);
> +	u8 x[2];
> +	unsigned long val;
> +
> +	if (strict_strtoul(buf, 16, &val))
> +		return -EINVAL;
> +	mutex_lock(&prs->lock);
> +	x[0] = prs->reg_addr;
> +	mutex_unlock(&prs->lock);
> +	x[1] = val;
> +	rc = lps001wp_prs_i2c_write(prs, x, 1);
> +	/*TODO: error need to be managed */
> +	return size;
> +}
> +
> +static ssize_t attr_reg_get(struct device *dev, struct device_attribute *attr,
> +				char *buf)
> +{
> +	ssize_t ret;
> +	struct lps001wp_prs_data *prs = dev_get_drvdata(dev);
> +	int rc;
> +	u8 data;
> +
> +	mutex_lock(&prs->lock);
> +	data = prs->reg_addr;
> +	mutex_unlock(&prs->lock);
> +	rc = lps001wp_prs_i2c_read(prs, &data, 1);
> +	/*TODO: error need to be managed */
> +	ret = sprintf(buf, "0x%02x\n", data);
> +	return ret;
> +}
> +
> +static ssize_t attr_addr_set(struct device *dev, struct device_attribute *attr,
> +				const char *buf, size_t size)
> +{
> +	struct lps001wp_prs_data *prs = dev_get_drvdata(dev);
> +	unsigned long val;
> +	if (strict_strtoul(buf, 16, &val))
> +		return -EINVAL;
> +	mutex_lock(&prs->lock);
> +	prs->reg_addr = val;
> +	mutex_unlock(&prs->lock);
> +	return size;
> +}
> +#endif
> +
> +
> +
> +static struct device_attribute attributes[] = {
* These all need documentation as they add new attributes to sysfs. Documentation/abi/
is the place to put it in the relevant format.
* Secondly we need to standarise these interfaces as much as possible in order
to allow for userspace code to work with different phyiscal sensors. This is a lot
of what we have been doing in IIO. 

First general point on interfaces.  Always take into account that other devices
may provide additional functionality to what you are doing so you MUST make
names specific to what they actually control.

> +	__ATTR(pollrate_ms, 0664, attr_get_polling_rate, attr_set_polling_rate),
Rate is a very confusing term to use.  In many cases, e.g. data rate it would
be measured in say bits per second. Hence it would be a frequency of the sending
of a bit.  Thus it can't be measured in millisecs.  Period is a more appropriate
term. IIO went with frequency in Hz to avoid exactly this confusion.

> +	__ATTR(enable, 0664, attr_get_enable, attr_set_enable),
enable what?

> +	__ATTR(diff_enable, 0664, attr_get_diff_enable, attr_set_diff_enable),
enable difference of what?

> +	__ATTR(press_reference, 0664, attr_get_press_ref, attr_set_press_ref),
This is the first one to mention press (pressure?). That's good, but the meaning
of reference is a bit device specific. Perhaps documentation would convince
me it is a good choice of name.
> +	__ATTR(lowpow_enable, 0664, attr_get_lowpowmode, attr_set_lowpowmode),
Again this is very device specific. With documentation we might be able to discuss
more useful naming or whether this is the appropriate option.

Get these debug elements out of the interface. This sort of raw access doesn't belong is sysfs.
> +#ifdef DEBUG
> +	__ATTR(reg_value, 0664, attr_reg_get, attr_reg_set),
> +	__ATTR(reg_addr, 0220, NULL, attr_addr_set),
> +#endif
> +};
Why not use an attribute_group and standard registration functions to
add this lot?
> +
Please rename function to be more driver specific. This sort
of general name could well be used and exported elsewhere in the kernel.

> +static int create_sysfs_interfaces(struct device *dev)
> +{
> +	int i;
> +	for (i = 0; i < ARRAY_SIZE(attributes); i++)
> +		if (device_create_file(dev, attributes + i))
I guess this returns a useful error. So don't eat it, but instead
return that from this function and pass on appropriately.
> +			goto error;
> +	return 0;
> +
> +error:
> +	for ( ; i >= 0; i--)
> +		device_remove_file(dev, attributes + i);
> +	dev_err(dev, "%s:Unable to create interface\n", __func__);
> +	return -1;
> +}
> +
> +static int remove_sysfs_interfaces(struct device *dev)
> +{
> +	int i;
> +	for (i = 0; i < ARRAY_SIZE(attributes); i++)
> +		device_remove_file(dev, attributes + i);
> +	return 0;
This never returns anything useful so make function void and
don't bother returning anything.
> +}
> +
> +
> +static void lps001wp_prs_input_work_func(struct work_struct *work)
> +{
> +	struct lps001wp_prs_data *prs;
> +
> +	struct outputdata output;
> +	struct outputdata *out = &output;
> +	int err;
> +
> +	prs = container_of((struct delayed_work *)work,
> +				struct lps001wp_prs_data, input_work);
  It's simply macro based pointer magic so i'd just have
struct lps001wp_prs_data *prs = container_of((struct delayed_work *)work,
       			struct lps001wp_prs_data, input_work);
at the top of the function.
> +
> +	mutex_lock(&prs->lock);
> +	err = lps001wp_prs_get_presstemp_data(prs, out);
out is never modified, so why not use &output directly in the call and
remove out entirely?
> +	if (err < 0)
> +		dev_err(&prs->client->dev, "get_pressure_data failed\n");
> +	else
> +		lps001wp_prs_report_values(prs, out);
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
> +	return lps001wp_prs_enable(prs);
> +}
> +
> +void lps001wp_prs_input_close(struct input_dev *dev)
> +{
> +	struct lps001wp_prs_data *prs = input_get_drvdata(dev);
lps001wp_prs_disable(input_get_drvdata(dev));
is shorter and still pretty clear.
> +
> +	lps001wp_prs_disable(prs);
> +}
> +
> +
> +static int lps001wp_prs_validate_pdata(struct lps001wp_prs_data *prs)
> +{
> +	prs->pdata->poll_interval = max(prs->pdata->poll_interval,
> +					prs->pdata->min_interval);
> +
This leave poll_interval as either poll_interval before this or min_interval.

The next line verifies poll_interval is less than min_interval. Obviously
that's not the case if it is min_interval.

Hence I think whole case could be written as
if (poll_interval < min_interval)
   return -EINVAL;
> +	/* Enforce minimum polling interval */
> +	if (prs->pdata->poll_interval < prs->pdata->min_interval) {
> +		dev_err(&prs->client->dev, "minimum poll interval violated\n");
> +		return -EINVAL;
> +	}
> +
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
> +static int lps001wp_prs_probe(struct i2c_client *client,
> +					const struct i2c_device_id *id)
> +{
> +	struct lps001wp_prs_data *prs;
> +	int err = -1;
Don't think you need to initialize err.  Looks to me like it always will
be set to a value anyway.

> +	int tempvalue;
> +
> +	pr_info("%s: probe start.\n", LPS001WP_PRS_DEV_NAME);
> +
> +	if (client->dev.platform_data == NULL) {
> +		dev_err(&client->dev, "platform data is NULL. exiting.\n");
> +		err = -ENODEV;

Going to this error label certainly looks a little 'unusual' given
you haven't checked the functionality yet.  I'd rename it appropriately.
> +		goto exit_check_functionality_failed;
> +	}
> +
If you need all of the following, why not combine them into a single
check?
> +	if (!i2c_check_functionality(client->adapter, I2C_FUNC_I2C)) {
> +		dev_err(&client->dev, "client not i2c capable\n");
We probably don't care about the message here. It's not something
that will occur in any real device...  
> +		err = -ENODEV;
> +		goto exit_check_functionality_failed;
> +	}
> +
> +	if (!i2c_check_functionality(client->adapter,
> +					I2C_FUNC_SMBUS_BYTE |
> +					I2C_FUNC_SMBUS_BYTE_DATA |
> +					I2C_FUNC_SMBUS_WORD_DATA)) {
> +		dev_err(&client->dev, "client not smb-i2c capable:2\n");
> +		err = -EIO;
> +		goto exit_check_functionality_failed;
> +	}
> +
> +
> +	if (!i2c_check_functionality(client->adapter,
> +						I2C_FUNC_SMBUS_I2C_BLOCK)){
> +		dev_err(&client->dev, "client not smb-i2c capable:3\n");
> +		err = -EIO;
> +		goto exit_check_functionality_failed;
> +	}
> +
> +
> +	prs = kzalloc(sizeof(struct lps001wp_prs_data), GFP_KERNEL);
> +	if (prs == NULL) {
> +		err = -ENOMEM;
> +		dev_err(&client->dev,
> +				"failed to allocate memory for module data: "
> +					"%d\n", err);
> +		goto exit_alloc_data_failed;
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
> +		printk(KERN_ERR "i2c_smbus_read_byte error!!\n");
Lose the exclamation marks if not the whole error message.
> +		goto err_mutexunlockfreedata;
> +	} else {
This we definitely don't need to know. It's useful whilst writing
drivers but not when they are normally in use.
> +		printk(KERN_DEBUG "%s Device detected!\n",
> +							LPS001WP_PRS_DEV_NAME);
> +	}
> +
> +	/* read chip id */
> +	tempvalue = i2c_smbus_read_word_data(client, WHO_AM_I);
> +	if ((tempvalue & 0x00FF) == WHOAMI_LPS001WP_PRS) {
> +		printk(KERN_DEBUG "%s I2C driver registered!\n",
> +							LPS001WP_PRS_DEV_NAME);
> +	} else {
> +		prs->client = NULL;
> +		printk(KERN_DEBUG "I2C driver not registered!"
> +				" Device unknown\n");
set the error code appropriately? -ENODEV seems right to me.
> +		goto err_mutexunlockfreedata;
> +	}
> +
> +	prs->pdata = kmalloc(sizeof(*prs->pdata), GFP_KERNEL);
> +	if (prs->pdata == NULL) {
> +		err = -ENOMEM;
> +		dev_err(&client->dev,
> +				"failed to allocate memory for pdata: %d\n",
> +				err);
> +		goto err_mutexunlockfreedata;
> +	}
> +
> +	memcpy(prs->pdata, client->dev.platform_data, sizeof(*prs->pdata));
kmemdup should work for the above.
> +
> +	err = lps001wp_prs_validate_pdata(prs);
> +	if (err < 0) {
> +		dev_err(&client->dev, "failed to validate platform data\n");
> +		goto exit_kfree_pdata;
> +	}
> +
> +	i2c_set_clientdata(client, prs);
You've already done this.
> +
> +
> +	if (prs->pdata->init) {
> +		err = prs->pdata->init();
What does this init typically do?  (just curious!)
> +		if (err < 0) {
> +			dev_err(&client->dev, "init failed: %d\n", err);
> +			goto err2;
After a lot of very specific error labels, this one seems rather out
of place.
> +		}
> +	}
> +
> +	memset(prs->resume_state, 0, ARRAY_SIZE(prs->resume_state));
Would be cleaner (in code) to use kzalloc then get rid of all the code
initializing bits of prs to 0.  It might technically take a tiny
bit longer, but it's probably worth it for the cleaner code.
> +
> +	prs->resume_state[RES_CTRL_REG1] = LPS001WP_PRS_PM_NORMAL;
> +	prs->resume_state[RES_CTRL_REG2] = 0x00;
> +	prs->resume_state[RES_CTRL_REG3] = 0x00;
> +	prs->resume_state[RES_REF_P_L] = 0x00;
> +	prs->resume_state[RES_REF_P_H] = 0x00;
> +	prs->resume_state[RES_THS_P_L] = 0x00;
> +	prs->resume_state[RES_THS_P_H] = 0x00;
> +	prs->resume_state[RES_INT_CFG] = 0x00;
> +
> +	err = lps001wp_prs_device_power_on(prs);
> +	if (err < 0) {
> +		dev_err(&client->dev, "power on failed: %d\n", err);
> +		goto err2;
> +	}
> +
> +	prs->diff_enabled = 0;
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
> +	err = create_sysfs_interfaces(&client->dev);
> +	if (err < 0) {
There is an informative error in the error path of the above function. I don't
think we need another here.
> +		dev_err(&client->dev,
> +			"device LPS001WP_PRS_DEV_NAME sysfs register failed\n");
> +		goto err_input_cleanup;
> +	}
> +
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
> +remove_sysfs_int:
> +	remove_sysfs_interfaces(&client->dev);
> +*/
> +err_input_cleanup:
> +	lps001wp_prs_input_cleanup(prs);
> +err_power_off:
> +	lps001wp_prs_device_power_off(prs);
> +err2:
> +	if (prs->pdata->exit)
> +		prs->pdata->exit();
> +exit_kfree_pdata:
> +	kfree(prs->pdata);
> +
> +err_mutexunlockfreedata:
> +	mutex_unlock(&prs->lock);
> +	kfree(prs);
> +exit_alloc_data_failed:
> +exit_check_functionality_failed:
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
> +	remove_sysfs_interfaces(&client->dev);
> +
> +	if (prs->pdata->exit)
> +		prs->pdata->exit();
> +	kfree(prs->pdata);
> +	kfree(prs);
> +
> +	return 0;
> +}
> +
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
Probably want the usual removal of these if power management
code isn't in the kernel.
> +	.resume = lps001wp_prs_resume,
> +	.suspend = lps001wp_prs_suspend,
> +};
> +
> +static int __init lps001wp_prs_init(void)
> +{
> +	printk(KERN_DEBUG "%s barometer driver: init\n",
> +						LPS001WP_PRS_DEV_NAME);
No 
> +	return i2c_add_driver(&lps001wp_prs_driver);
> +}
> +
> +static void __exit lps001wp_prs_exit(void)
> +{
> +	#if DEBUG
> +	printk(KERN_DEBUG "%s barometer driver exit\n",
> +						LPS001WP_PRS_DEV_NAME);
> +	#endif
Lose these debug statements.  They are handy when writing the driver, but
don't tell us anything terribly useful in one that works.

> +	i2c_del_driver(&lps001wp_prs_driver);
> +	return;
> +}
> +
> +module_init(lps001wp_prs_init);
> +module_exit(lps001wp_prs_exit);
> +
> +MODULE_DESCRIPTION("STMicrolelectronics lps001wp pressure sensor misc driver");
> +MODULE_AUTHOR("Matteo Dameno, Carmine Iascone, STMicroelectronics");
> +MODULE_LICENSE("GPL");
> +
> diff --git a/include/linux/input/lps001wp.h b/include/linux/input/lps001wp.h
> new file mode 100644
> index 0000000..4c3e307
> --- /dev/null
> +++ b/include/linux/input/lps001wp.h
> @@ -0,0 +1,82 @@
> +/******************** (C) COPYRIGHT 2010 STMicroelectronics ********************
> +*
> +* File Name	: lps001wp.h
> +* Authors	: MSH - Motion Mems BU - Application Team
> +*		: Matteo Dameno (matteo.dameno@st.com)*
> +*		: Carmine Iascone (carmine.iascone@st.com)
> +* Version	: V 1.1.1
Don't bother with version numbers or dates in drivers.
They tend not to get updated and git history is often more informative.
I guess if this section is company policy no one will really mind that much.
> +* Date		: 05/11/2010
> +* Description	: LPS001WP 6D module sensor API
> +*
> +********************************************************************************
> +*
> +* This program is free software; you can redistribute it and/or modify
> +* it under the terms of the GNU General Public License version 2 as
> +* published by the Free Software Foundation.
> +*
> +* THE PRESENT SOFTWARE IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES
> +* OR CONDITIONS OF ANY KIND, EITHER EXPRESS OR IMPLIED, FOR THE SOLE
> +* PURPOSE TO SUPPORT YOUR APPLICATION DEVELOPMENT.
> +* AS A RESULT, STMICROELECTRONICS SHALL NOT BE HELD LIABLE FOR ANY DIRECT,
> +* INDIRECT OR CONSEQUENTIAL DAMAGES WITH RESPECT TO ANY CLAIMS ARISING FROM THE
> +* CONTENT OF SUCH SOFTWARE AND/OR THE USE MADE BY CUSTOMERS OF THE CODING
> +* INFORMATION CONTAINED HEREIN IN CONNECTION WITH THEIR PRODUCTS.
I'm not sure what the view on statements like this in kernel is, but it might
cause some comments...
> +*
> +* THIS SOFTWARE IS SPECIFICALLY DESIGNED FOR EXCLUSIVE USE WITH ST PARTS.
Tough.  If someone else finds another part that is sufficiently similar they will
add it to this driver and use your code for something else ;)
> +*
> +*******************************************************************************/
> +
> +#ifndef	__LPS001WP_H__
> +#define	__LPS001WP_H__
> +
> +
> +#include	<linux/input.h>
Why this include?
> +
> +#define	SAD0L				0x00
> +#define	SAD0H				0x01
> +#define	LPS001WP_PRS_I2C_SADROOT	0x2E
> +#define	LPS001WP_PRS_I2C_SAD_L		((LPS001WP_PRS_I2C_SADROOT<<1)|SAD0L)
> +#define	LPS001WP_PRS_I2C_SAD_H		((LPS001WP_PRS_I2C_SADROOT<<1)|SAD0H)
> +#define	LPS001WP_PRS_DEV_NAME		"lps001wp_prs_sysfs"
> +
> +/* input define mappings */
> +#define ABS_PR		ABS_PRESSURE
> +#define ABS_TEMP	ABS_GAS
> +#define ABS_DLTPR	ABS_MISC
> +
> +
> +
That's an awfully heavily hightlighted comment. I'd just
go with the relevant middle line...
> +/************************************************/
> +/* 	Pressure section defines	 	*/
> +/************************************************/
> +
> +/* Pressure Sensor Operating Mode */
> +#define	LPS001WP_PRS_ENABLE		0x01
> +#define	LPS001WP_PRS_DISABLE		0x00
Some excessive white space here.  There is very rarely any
reason to have more than one blank line.  This is true
all over the driver.  Please clean the whole thing up
appropriately.  Other drivers will act as good examples
of the style people tend to use.
> +
> +
> +
> +
> +#define	LPS001WP_PRS_PM_NORMAL		0x40
> +#define	LPS001WP_PRS_PM_OFF		LPS001WP_PRS_DISABLE
> +
> +#define	SENSITIVITY_T		64	/** =	64 LSB/degrC	*/
> +#define	SENSITIVITY_P		16	/** =	16 LSB/mbar	*/
> +
> +
> +#ifdef __KERNEL__
Some kernel doc formated documentation for this structure would be a
good addition.
> +struct lps001wp_prs_platform_data {
> +
> +	int poll_interval;
> +	int min_interval;
> +
> +	int (*init)(void);
> +	void (*exit)(void);
> +	int (*power_on)(void);
> +	int (*power_off)(void);
> +
> +};
> +
> +#endif /* __KERNEL__ */
> +
> +#endif  /* __LPS001WP_H__ */

