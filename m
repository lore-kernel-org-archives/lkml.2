Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932705Ab0HEUqT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 16:46:19 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:43589 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758935Ab0HEUqP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 16:46:15 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6065"; a="49900636"
Message-ID: <4C5B22F8.1030204@codeaurora.org>
Date: Fri, 06 Aug 2010 02:15:44 +0530
From: Trilok Soni <tsoni@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.2.7) Gecko/20100713 Thunderbird/3.1.1
MIME-Version: 1.0
To: Kevin McNeely <kev@cypress.com>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        David Brown <davidb@codeaurora.org>,
        Fred <fwk@ubuntu.linuxcertified.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Eric Miao <eric.y.miao@gmail.com>, Ben Dooks <ben-linux@fluff.org>,
        Simtec Linux Team <linux@simtec.co.uk>,
        Todd Fischer <todd.fischer@ridgerun.com>,
        Arnaud Patard <arnaud.patard@rtp-net.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Henrik Rydberg <rydberg@euromail.se>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] i2c: cyttsp i2c and spi touchscreen driver init submit
References: <Kevin McNeely <kev@cypress.com> <1281031924-3032-1-git-send-email-kev@cypress.com>
In-Reply-To: <1281031924-3032-1-git-send-email-kev@cypress.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kevin,

On 8/5/2010 11:42 PM, Kevin McNeely wrote:
> From: Fred <fwk@ubuntu.linuxcertified.com>
> 

E-mail address is is wrong again it seems. Please fix. 

You may want to divide this whole patch into three patches:

1. core driver
2. i2c driver
3. spi driver

> This is a new touchscreen driver for the Cypress Semiconductor
> cyttsp family of devices.  This updated driver is for both the i2c and spi
> versions of the devices. The driver code consists of common core code for
> both i2c and spi driver.  This submission is in response to review comments
> from the initial submission.
> 
> Signed-off-by: Kevin McNeely <kev@cypress.com>
> ---
>  drivers/input/touchscreen/Kconfig            |   33 +
>  drivers/input/touchscreen/Makefile           |    3 +
>  drivers/input/touchscreen/cyttsp_board-xxx.c |  110 ++
>  drivers/input/touchscreen/cyttsp_core.c      | 1778 ++++++++++++++++++++++++++
>  drivers/input/touchscreen/cyttsp_core.h      |   49 +
>  drivers/input/touchscreen/cyttsp_i2c.c       |  183 +++
>  drivers/input/touchscreen/cyttsp_spi.c       |  339 +++++
>  include/linux/cyttsp.h                       |  104 ++
>  8 files changed, 2599 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/input/touchscreen/cyttsp_board-xxx.c
>  create mode 100755 drivers/input/touchscreen/cyttsp_core.c
>  create mode 100755 drivers/input/touchscreen/cyttsp_core.h
>  create mode 100755 drivers/input/touchscreen/cyttsp_i2c.c
>  create mode 100755 drivers/input/touchscreen/cyttsp_spi.c
>  create mode 100755 include/linux/cyttsp.h

File modes are wrong.


> 
> diff --git a/drivers/input/touchscreen/Kconfig b/drivers/input/touchscreen/Kconfig
> index 3b9d5e2..b923379 100644
> --- a/drivers/input/touchscreen/Kconfig
> +++ b/drivers/input/touchscreen/Kconfig
> @@ -603,4 +603,37 @@ config TOUCHSCREEN_TPS6507X
>  	  To compile this driver as a module, choose M here: the
>  	  module will be called tps6507x_ts.
>  
> +config TOUCHSCREEN_CYTTSP_I2C
> +	default n

default n is not required.

> +	tristate "Cypress TTSP i2c touchscreen"
> +	depends on I2C
> +	help
> +	  Say Y here if you have a Cypress TTSP touchscreen
> +	  connected to your system's i2c bus.
> +
> +	  If unsure, say N.
> +
> +	  To compile this driver as a module, choose M here: the
> +	  module will be called cyttsp_i2c.
> +
> +config TOUCHSCREEN_CYTTSP_SPI
> +	default n

Ditto.

> +	tristate "Cypress TTSP spi touchscreen"
> +	depends on SPI_MASTER
> +	help
> +	  Say Y here if you have a Cypress TTSP touchscreen
> +	  connected to your system's spi bus.
> +
> +	  If unsure, say N.
> +
> +	  To compile this driver as a module, choose M here: the
> +	  module will be called cyttsp_spi.
> +
> +config TOUCHSCREEN_CYTTSP_CORE
> +	default y

We don't want anything to be default y unless it is curing a cancer.

> diff --git a/drivers/input/touchscreen/cyttsp_board-xxx.c b/drivers/input/touchscreen/cyttsp_board-xxx.c

This file is good as example only but not for check in. This is a board specific code and the board-xxx.c
code in appropriate arch will carry this code. Please remove this file from the patch.

> diff --git a/drivers/input/touchscreen/cyttsp_core.c b/drivers/input/touchscreen/cyttsp_core.c
> new file mode 100755
> index 0000000..95019e9
> --- /dev/null
> +++ b/drivers/input/touchscreen/cyttsp_core.c
> @@ -0,0 +1,1778 @@
> +/* Core Source for:
> + * Cypress TrueTouch(TM) Standard Product (TTSP) touchscreen drivers.
> + * For use with Cypress Txx2xx and Txx3xx parts.
> + * Supported parts include:
> + * CY8CTST241
> + * CY8CTMG240
> + * CY8CTST341
> + * CY8CTMA340
> + *
> + * Copyright (C) 2009, 2010 Cypress Semiconductor, Inc.
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License
> + * version 2, and only version 2, as published by the
> + * Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License along
> + * with this program; if not, write to the Free Software Foundation, Inc.,
> + * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA.
> + *
> + * Contact Cypress Semiconductor at www.cypress.com (kev@cypress.com)
> + *
> + */
> +
> +#include <linux/delay.h>
> +#include <linux/init.h>
> +#include <linux/module.h>
> +#include <linux/input.h>
> +#include <linux/slab.h>
> +#include <linux/gpio.h>
> +#include <linux/irq.h>
> +#include <linux/interrupt.h>
> +#include <linux/timer.h>
> +#include <linux/workqueue.h>
> +#include <linux/byteorder/generic.h>
> +#include <linux/bitops.h>
> +#include <linux/cyttsp.h>
> +#include <linux/ctype.h>
> +#include "cyttsp_core.h"
> +
> +#define DBG(x)
> +
> +/* rely on kernel input.h to define Multi-Touch capability */
> +#ifndef ABS_MT_TRACKING_ID
> +/* define only if not defined already by system; */
> +/* value based on linux kernel 2.6.30.10 */
> +#define ABS_MT_TRACKING_ID (ABS_MT_BLOB_ID + 1)
> +#endif /* ABS_MT_TRACKING_ID */

We always support and base our code from latest kernel only. Please remove the code
which relies on supporting older kernels. 

> +
> +#define	TOUCHSCREEN_TIMEOUT (msecs_to_jiffies(28))
> +/* Bootloader File 0 offset */
> +#define CY_BL_FILE0       0x00
> +/* Bootloader command directive */
> +#define CY_BL_CMD         0xFF
> +/* Bootloader Enter Loader mode */
> +#define CY_BL_ENTER       0x38
> +/* Bootloader Write a Block */
> +#define CY_BL_WRITE_BLK   0x39
> +/* Bootloader Terminate Loader mode */
> +#define CY_BL_TERMINATE   0x3B
> +/* Bootloader Exit and Verify Checksum command */
> +#define CY_BL_EXIT        0xA5
> +/* Bootloader default keys */
> +#define CY_BL_KEY0 0
> +#define CY_BL_KEY1 1
> +#define CY_BL_KEY2 2
> +#define CY_BL_KEY3 3
> +#define CY_BL_KEY4 4
> +#define CY_BL_KEY5 5
> +#define CY_BL_KEY6 6
> +#define CY_BL_KEY7 7
> +
> +#define CY_DIFF(m, n)               ((m) != (n))

And why such macro is required? Why can't we just do "if (i != j)"?

> +
> +/* TTSP Bootloader Register Map interface definition */
> +#define CY_BL_CHKSUM_OK 0x01
> +struct cyttsp_bootloader_data {
> +	u8 bl_file;
> +	u8 bl_status;
> +	u8 bl_error;
> +	u8 blver_hi;
> +	u8 blver_lo;
> +	u8 bld_blver_hi;
> +	u8 bld_blver_lo;
> +	u8 ttspver_hi;
> +	u8 ttspver_lo;
> +	u8 appid_hi;
> +	u8 appid_lo;
> +	u8 appver_hi;
> +	u8 appver_lo;
> +	u8 cid_0;
> +	u8 cid_1;
> +	u8 cid_2;
> +};
> +
> +#define cyttsp_wake_data cyttsp_xydata

Why we need to such assignments and introduce these kind of macros? I don't think it is necessary.

> +
> +struct cyttsp {
> +	struct device *pdev;

Most of the time kernel people understands "pdev == platform device and not just device", so better rename this variable
to "dev" only.

> +	int irq;
> +	struct input_dev *input;
> +	struct work_struct work;
> +	struct timer_list timer;
> +	struct mutex mutex;
> +	char phys[32];
> +	struct cyttsp_platform_data *platform_data;
> +	struct cyttsp_bootloader_data bl_data;
> +	struct cyttsp_sysinfo_data sysinfo_data;
> +	u8 num_prv_st_tch;
> +	u16 act_trk[CY_NUM_TRK_ID];
> +	u16 prv_mt_tch[CY_NUM_MT_TCH_ID];
> +	u16 prv_st_tch[CY_NUM_ST_TCH_ID];
> +	u16 prv_mt_pos[CY_NUM_TRK_ID][2];
> +	struct cyttsp_bus_ops *bus_ops;
> +	unsigned fw_loader_mode:1;
> +	unsigned suspended:1;
> +};
> +
> +struct cyttsp_track_data {
> +	u8 prv_tch;
> +	u8 cur_tch;
> +	u16 tmp_trk[CY_NUM_MT_TCH_ID];
> +	u16 snd_trk[CY_NUM_MT_TCH_ID];
> +	u16 cur_trk[CY_NUM_TRK_ID];
> +	u16 cur_st_tch[CY_NUM_ST_TCH_ID];
> +	u16 cur_mt_tch[CY_NUM_MT_TCH_ID];
> +	/* if NOT CY_USE_TRACKING_ID then only */
> +	/* uses CY_NUM_MT_TCH_ID positions */
> +	u16 cur_mt_pos[CY_NUM_TRK_ID][2];
> +	/* if NOT CY_USE_TRACKING_ID then only */
> +	/* uses CY_NUM_MT_TCH_ID positions */
> +	u8 cur_mt_z[CY_NUM_TRK_ID];
> +	u8 tool_width;
> +	u16 st_x1;
> +	u16 st_y1;
> +	u8 st_z1;
> +	u16 st_x2;
> +	u16 st_y2;
> +	u8 st_z2;
> +};
> +
> +static const u8 bl_cmd[] = {
> +	CY_BL_FILE0, CY_BL_CMD, CY_BL_EXIT,
> +	CY_BL_KEY0, CY_BL_KEY1, CY_BL_KEY2,
> +	CY_BL_KEY3, CY_BL_KEY4, CY_BL_KEY5,
> +	CY_BL_KEY6, CY_BL_KEY7
> +};
> +
> +#define LOCK(m) do { \
> +	DBG(printk(KERN_INFO "%s: lock\n", __func__);) \
> +	mutex_lock(&(m)); \
> +} while (0);
> +
> +#define UNLOCK(m) do { \
> +	DBG(printk(KERN_INFO "%s: unlock\n", __func__);) \
> +	mutex_unlock(&(m)); \
> +} while (0);

Un-necessary debug macros and abstractions. This is not allowed. Please use mutext_lock and unlock
APIs directly wherever they are required.

> +
> +DBG(
> +static void print_data_block(const char *func, u8 command,
> +			u8 length, void *data)
> +{
> +	char buf[1024];
> +	unsigned buf_len = sizeof(buf);
> +	char *p = buf;
> +	int i;
> +	int l;
> +
> +	l = snprintf(p, buf_len, "cmd 0x%x: ", command);
> +	buf_len -= l;
> +	p += l;
> +	for (i = 0; i < length && buf_len; i++, p += l, buf_len -= l)
> +		l = snprintf(p, buf_len, "%02x ", *((char *)data + i));
> +	printk(KERN_DEBUG "%s: %s\n", func, buf);
> +})

Please don't do like DBG(...) like things. As it is strictly for debugging purpose only
please remove this function from the code itself. Developer in need of such debugging routines
will write down their own when they sit for debugging the problem. I don't see any need
of such debugging helpers in the mainlined version of the driver.

> +
> +static int ttsp_read_block_data(struct cyttsp *ts, u8 command,
> +	u8 length, void *buf)
> +{
> +	int rc;
> +	int tries;
> +	DBG(printk(KERN_INFO"%s: Enter\n", __func__);)
> +
> +	if (!buf || !length) {
> +		printk(KERN_ERR "%s: Error, buf:%s len:%u\n",
> +				__func__, !buf ? "NULL" : "OK", length);
> +		return -EIO;
> +	}
> +
> +	for (tries = 0, rc = 1; tries < CY_NUM_RETRY && rc; tries++)
> +		rc = ts->bus_ops->read(ts->bus_ops, command, length, buf);
> +
> +	if (rc < 0)
> +		printk(KERN_ERR "%s: error %d\n", __func__, rc);
> +	DBG(print_data_block(__func__, command, length, buf);)

Please use dev_dbg(...) or pr_debug(...) macros directly instead of putting
them under DBG(...). 

It is better you remove DBG(..) from whole driver and replace them with
dev_dbg(...) if you have device pointer or use pr_debug(...).

> +
> +static int ttsp_tch_ext(struct cyttsp *ts, void *buf)
> +{
> +	int rc;
> +	DBG(printk(KERN_INFO"%s: Enter\n", __func__);)

Un-necessary debug statements. Such statements should be removed from the driver.

> +
> +/* ************************************************************************
> + * The cyttsp_xy_worker function reads the XY coordinates and sends them to
> + * the input layer.  It is scheduled from the interrupt (or timer).
> + * *************************************************************************/
> +void handle_single_touch(struct cyttsp_xydata *xy, struct cyttsp_track_data *t,
> +			 struct cyttsp *ts)
> +{

functions should be "static". I would leave a decision to Dmitry if he wants the driver
to support old single touch protocol hacked up with HAT_xx bits so that driver can support
two touches with the old single touch protocol itself. 

I would prefer not to support this single touch because we are hacking up this
because the userspace frameworks are not converted or supporting the new MT based protocols.

> +
> +void handle_multi_touch(struct cyttsp_track_data *t, struct cyttsp *ts)
> +{

static please.

> +
> +void cyttsp_xy_worker(struct cyttsp *ts)
> +{

static please.

> +
> +	DBG(
> +	if (trc.cur_tch) {
> +		unsigned i;
> +		u8 *pdata = (u8 *)&xy_data;
> +
> +		printk(KERN_INFO "%s: TTSP data_pack: ", __func__);
> +		for (i = 0; i < sizeof(struct cyttsp_xydata); i++)
> +			printk(KERN_INFO "[%d]=0x%x ", i, pdata[i]);
> +		printk(KERN_INFO "\n");
> +	})

I would really like to remove such DBG formatted code.

> +
> +	/* Determine if display is tilted */
> +	tilt = !!FLIP_DATA(ts->platform_data->flags);
> +	/* Check for switch in origin */
> +	rev_x = !!REVERSE_X(ts->platform_data->flags);
> +	rev_y = !!REVERSE_Y(ts->platform_data->flags);
> +

...

> +
> +	/* update platform data for the current multi-touch information */
> +	memcpy(ts->act_trk, trc.cur_trk, CY_NUM_TRK_ID);
> +
> +exit_xy_worker:
> +	DBG(printk(KERN_INFO"%s: finished.\n", __func__);)
> +	return;

Do you need this return statment?

> +}
> +
> +/* ************************************************************************
> + * ISR function. This function is general, initialized in drivers init
> + * function and disables further IRQs until this IRQ is processed in worker.
> + * *************************************************************************/
> +static irqreturn_t cyttsp_irq(int irq, void *handle)
> +{
> +	struct cyttsp *ts = (struct cyttsp *)handle;

Casting is not required when the source is void *.

> +
> +	DBG(printk(KERN_INFO"%s: Got IRQ!\n", __func__);)

Un-necessary debug statements.

> +	cyttsp_xy_worker(ts);
> +	return IRQ_HANDLED;
> +}
> +
> +/* schedulable worker entry for timer polling method */
> +void cyttsp_xy_worker_(struct work_struct *work)
> +{
> +	struct cyttsp *ts = container_of(work, struct cyttsp, work);
> +	cyttsp_xy_worker(ts);
> +}

I would really prefer that you remove the polling method from this code as it will simplify
a code lot. We can delete the whole workqueue because as you will be using request_threaded_irq(...),
you will not need any workqueue.

> +
> +/* Timer function used as touch interrupt generator for polling method */
> +static void cyttsp_timer(unsigned long handle)
> +{
> +	struct cyttsp *ts = (struct cyttsp *)handle;
> +
> +	DBG(printk(KERN_INFO"%s: TTSP timer event!\n", __func__);)
> +	/* schedule motion signal handling */
> +	if (!work_pending(&ts->work))
> +		schedule_work(&ts->work);
> +	mod_timer(&ts->timer, jiffies + TOUCHSCREEN_TIMEOUT);
> +	return;
> +}

I don't see any need of this timer. Better remove the polling method all together to simplify the code.
Only support interrupt based approach only. 


> +
> +
> +/* ************************************************************************
> + * Probe initialization functions
> + * ************************************************************************ */
> +static int cyttsp_load_bl_regs(struct cyttsp *ts)
> +{
> +	int retval;
> +
> +	DBG(printk(KERN_INFO"%s: Enter\n", __func__);)
> +
> +	retval =  ttsp_read_block_data(ts, CY_REG_BASE,
> +				sizeof(ts->bl_data), &(ts->bl_data));
> +
> +	if (retval < 0) {
> +		DBG(printk(KERN_INFO "%s: Failed reading block data, err:%d\n",
> +			__func__, retval);)
> +		goto fail;
> +	}
> +
> +	DBG({
> +	      int i;
> +	      u8 *bl_data = (u8 *)&(ts->bl_data);
> +	      for (i = 0; i < sizeof(struct cyttsp_bootloader_data); i++)
> +			printk(KERN_INFO "%s bl_data[%d]=0x%x\n",
> +				__func__, i, bl_data[i]);
> +	})

Better remove such debug code.

> +
> +	return 0;
> +fail:
> +	return retval;
> +}

...

> +
> +static ssize_t firmware_write(struct kobject *kobj,
> +				struct bin_attribute *bin_attr,
> +				char *buf, loff_t pos, size_t size)
> +{
> +	struct device *dev = container_of(kobj, struct device, kobj);
> +	struct cyttsp *ts = dev_get_drvdata(dev);
> +	LOCK(ts->mutex);
> +	DBG({
> +		char str[128];
> +		char *p = str;
> +		int i;
> +		for (i = 0; i < size; i++, p += 2)
> +			sprintf(p, "%02x", (unsigned char)buf[i]);
> +		printk(KERN_DEBUG "%s: size %d, pos %ld payload %s\n",
> +		       __func__, size, (long)pos, str);
> +	})
> +	ttsp_write_block_data(ts, CY_REG_BASE, size, buf);
> +	UNLOCK(ts->mutex);
> +	return size;
> +}
> +
> +static ssize_t firmware_read(struct kobject *kobj,
> +	struct bin_attribute *ba,
> +	char *buf, loff_t pos, size_t size)
> +{
> +	int count = 0;
> +	struct device *dev = container_of(kobj, struct device, kobj);
> +	struct cyttsp *ts = dev_get_drvdata(dev);
> +
> +	LOCK(ts->mutex);
> +	if (!ts->fw_loader_mode)
> +		goto exit;
> +	if (!cyttsp_load_bl_regs(ts)) {
> +		*(unsigned short *)buf = ts->bl_data.bl_status << 8 |
> +			ts->bl_data.bl_error;
> +		count = sizeof(unsigned short);
> +	} else {
> +		printk(KERN_ERR "%s: error reading status\n", __func__);
> +		count = 0;
> +	}
> +exit:
> +	UNLOCK(ts->mutex);
> +	return count;
> +}

This kind of custom interface may not be allowed in the kernel driver. Please use
request_firmware(...) call based interface to support firmware loading.

> +
> +void *cyttsp_core_init(struct cyttsp_bus_ops *bus_ops, struct device *pdev)
> +{
> +	struct input_dev *input_device;
> +	struct cyttsp *ts;
> +	int retval = 0;
> +
> +	DBG(printk(KERN_INFO"%s: Enter\n", __func__);)
> +
> +	ts = kzalloc(sizeof(*ts), GFP_KERNEL);
> +	if (ts == NULL) {
> +		printk(KERN_ERR "%s: Error, kzalloc\n", __func__);
> +		goto error_alloc_data_failed;
> +	}
> +	mutex_init(&ts->mutex);
> +	ts->pdev = pdev;
> +	ts->platform_data = pdev->platform_data;
> +	ts->bus_ops = bus_ops;
> +
> +	if (ts->platform_data->init)
> +		retval = ts->platform_data->init(1);
> +	if (retval) {
> +		printk(KERN_ERR "%s: platform init failed!\n", __func__);
> +		goto error_init;
> +	}
> +
> +	if (ts->platform_data->use_timer)
> +		ts->irq = -1;
> +	else
> +		ts->irq = gpio_to_irq(ts->platform_data->irq_gpio);
> +
> +	retval = cyttsp_power_on(ts);
> +	if (retval < 0) {
> +		printk(KERN_ERR "%s: Error, power on failed!\n", __func__);
> +		goto error_power_on;
> +	}
> +
> +	/* Create the input device and register it. */
> +	input_device = input_allocate_device();
> +	if (!input_device) {
> +		retval = -ENOMEM;
> +		printk(KERN_ERR "%s: Error, failed to allocate input device\n",
> +			__func__);
> +		goto error_input_allocate_device;
> +	}
> +
> +	ts->input = input_device;
> +	input_device->name = ts->platform_data->name;
> +	input_device->phys = ts->phys;
> +	input_device->dev.parent = ts->pdev;
> +	/* init the touch structures */
> +	ts->num_prv_st_tch = CY_NTCH;
> +	memset(ts->act_trk, CY_NTCH, sizeof(ts->act_trk));
> +	memset(ts->prv_mt_pos, CY_NTCH, sizeof(ts->prv_mt_pos));
> +	memset(ts->prv_mt_tch, CY_IGNR_TCH, sizeof(ts->prv_mt_tch));
> +	memset(ts->prv_st_tch, CY_IGNR_TCH, sizeof(ts->prv_st_tch));
> +
> +	__set_bit(EV_SYN, input_device->evbit);
> +	__set_bit(EV_KEY, input_device->evbit);
> +	__set_bit(EV_ABS, input_device->evbit);
> +	__set_bit(BTN_TOUCH, input_device->keybit);
> +	__set_bit(BTN_2, input_device->keybit);
> +	if (ts->platform_data->use_gestures)
> +		__set_bit(BTN_3, input_device->keybit);
> +
> +	input_set_abs_params(input_device, ABS_X, 0, ts->platform_data->maxx,
> +			     0, 0);
> +	input_set_abs_params(input_device, ABS_Y, 0, ts->platform_data->maxy,
> +			     0, 0);
> +	input_set_abs_params(input_device, ABS_TOOL_WIDTH, 0,
> +			     CY_LARGE_TOOL_WIDTH, 0, 0);
> +	input_set_abs_params(input_device, ABS_PRESSURE, 0, CY_MAXZ, 0, 0);
> +	input_set_abs_params(input_device, ABS_HAT0X, 0,
> +			     ts->platform_data->maxx, 0, 0);
> +	input_set_abs_params(input_device, ABS_HAT0Y, 0,
> +			     ts->platform_data->maxy, 0, 0);
> +	if (ts->platform_data->use_gestures) {
> +		input_set_abs_params(input_device, ABS_HAT1X, 0, CY_MAXZ,
> +				     0, 0);
> +		input_set_abs_params(input_device, ABS_HAT1Y, 0, CY_MAXZ,
> +				     0, 0);
> +	}
> +	if (ts->platform_data->use_mt) {
> +		input_set_abs_params(input_device, ABS_MT_POSITION_X, 0,
> +				     ts->platform_data->maxx, 0, 0);
> +		input_set_abs_params(input_device, ABS_MT_POSITION_Y, 0,
> +				     ts->platform_data->maxy, 0, 0);
> +		input_set_abs_params(input_device, ABS_MT_TOUCH_MAJOR, 0,
> +				     CY_MAXZ, 0, 0);
> +		input_set_abs_params(input_device, ABS_MT_WIDTH_MAJOR, 0,
> +				     CY_LARGE_TOOL_WIDTH, 0, 0);
> +		if (ts->platform_data->use_trk_id)
> +			input_set_abs_params(input_device, ABS_MT_TRACKING_ID,
> +					0, CY_NUM_TRK_ID, 0, 0);
> +	}
> +
> +	if (ts->platform_data->use_virtual_keys)
> +		input_set_capability(input_device, EV_KEY, KEY_PROG1);
> +
> +	retval = input_register_device(input_device);
> +	if (retval) {
> +		printk(KERN_ERR "%s: Error, failed to register input device\n",
> +			__func__);
> +		goto error_input_register_device;
> +	}
> +	DBG(printk(KERN_INFO "%s: Registered input device %s\n",
> +		   __func__, input_device->name);)
> +
> +	/* Prepare our worker structure prior to setting up the timer ISR */
> +	INIT_WORK(&ts->work, cyttsp_xy_worker_);
> +
> +	/* Timer or Interrupt setup */
> +	if (ts->platform_data->use_timer) {
> +		DBG(printk(KERN_INFO "%s: Setting up Timer\n", __func__);)
> +		setup_timer(&ts->timer, cyttsp_timer, (unsigned long) ts);
> +		mod_timer(&ts->timer, jiffies + TOUCHSCREEN_TIMEOUT);
> +	} else {
> +		DBG(
> +		printk(KERN_INFO "%s: Setting up Interrupt. Device name=%s\n",
> +			__func__, input_device->name);)
> +		retval = request_threaded_irq(ts->irq, NULL, cyttsp_irq,
> +				   IRQF_TRIGGER_FALLING | IRQF_ONESHOT,
> +				   input_device->name, ts);
> +
> +		if (retval) {
> +			printk(KERN_ERR "%s: Error, could not request irq\n",
> +				__func__);
> +			goto error_free_irq;
> +		} else {
> +			DBG(printk(KERN_INFO "%s: Interrupt=%d\n",
> +				__func__, ts->irq);)
> +		}
> +	}
> +	retval = device_create_file(pdev, &fwloader);
> +	if (retval) {
> +		printk(KERN_ERR "%s: Error, could not create attribute\n",
> +			__func__);
> +		goto device_create_error;
> +	}
> +	dev_set_drvdata(pdev, ts);
> +	printk(KERN_INFO "%s: Successful.\n", __func__);
> +	return ts;
> +
> +device_create_error:
> +error_free_irq:
> +	if (ts->irq >= 0)
> +		free_irq(ts->irq, ts);
> +	input_unregister_device(input_device);
> +error_input_register_device:
> +	input_free_device(input_device);
> +error_input_allocate_device:
> +error_power_on:
> +	if (ts->platform_data->init)
> +		ts->platform_data->init(0);
> +error_init:
> +	kfree(ts);
> +error_alloc_data_failed:
> +	return NULL;
> +}
> +
EXPORT_SYMBOL_GPL(...)?

> +/* registered in driver struct */
> +void cyttsp_core_release(void *handle)
> +{
> +	struct cyttsp *ts = handle;
> +
> +	DBG(printk(KERN_INFO"%s: Enter\n", __func__);)
> +	cancel_work_sync(&ts->work);
> +	if (ts->platform_data->use_timer)
> +		del_timer_sync(&ts->timer);
> +	else
> +		free_irq(ts->irq, ts);
> +	input_unregister_device(ts->input);
> +	input_free_device(ts->input);

No need of input_free_device after input_unregister_device.

> +	if (ts->platform_data->init)
> +		ts->platform_data->init(0);
> +	kfree(ts);
> +}

EXPORT_SYMBOL_GPL(...)?

> +MODULE_LICENSE("GPL");
> +MODULE_DESCRIPTION("Cypress TrueTouch(R) Standard touchscreen driver core");
> +MODULE_AUTHOR("Cypress");
> +


> diff --git a/drivers/input/touchscreen/cyttsp_i2c.c b/drivers/input/touchscreen/cyttsp_i2c.c
> new file mode 100755
> index 0000000..ef96105
> --- /dev/null
> +++ b/drivers/input/touchscreen/cyttsp_i2c.c
> @@ -0,0 +1,183 @@
> +/* Source for:
> + * Cypress TrueTouch(TM) Standard Product (TTSP) I2C touchscreen driver.
> + * For use with Cypress Txx2xx and Txx3xx parts with I2C interface.
> + * Supported parts include:
> + * CY8CTST241
> + * CY8CTMG240
> + * CY8CTST341
> + * CY8CTMA340
> + *
> + * Copyright (C) 2009, 2010 Cypress Semiconductor, Inc.
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License
> + * version 2, and only version 2, as published by the
> + * Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License along
> + * with this program; if not, write to the Free Software Foundation, Inc.,
> + * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA.
> + *
> + * Contact Cypress Semiconductor at www.cypress.com (kev@cypress.com)
> + *
> + */
> +
> +#include <linux/init.h>
> +#include <linux/module.h>
> +#include <linux/i2c.h>
> +#include <linux/cyttsp.h>
> +#include "cyttsp_core.h"
> +
> +#define DBG(x)
> +
> +struct cyttsp_i2c {
> +	struct cyttsp_bus_ops ops;
> +	struct i2c_client *client;
> +	void *ttsp_client;
> +};
> +
> +static s32 ttsp_i2c_read_block_data(void *handle, u8 addr,
> +	u8 length, void *values)
> +{
> +	struct cyttsp_i2c *ts = container_of(handle, struct cyttsp_i2c, ops);
> +	return i2c_smbus_read_i2c_block_data(ts->client,
> +		addr, length, values);
> +}
> +
> +static s32 ttsp_i2c_write_block_data(void *handle, u8 addr,
> +	u8 length, const void *values)
> +{
> +	struct cyttsp_i2c *ts = container_of(handle, struct cyttsp_i2c, ops);
> +	return i2c_smbus_write_i2c_block_data(ts->client,
> +		addr, length, values);
> +}
> +
> +static s32 ttsp_i2c_tch_ext(void *handle, void *values)
> +{
> +	int retval = 0;
> +	struct cyttsp_i2c *ts = container_of(handle, struct cyttsp_i2c, ops);
> +
> +	DBG(printk(KERN_INFO "%s: Enter\n", __func__);)
> +
> +	/* Add custom touch extension handling code here */
> +	/* set: retval < 0 for any returned system errors,
> +		retval = 0 if normal touch handling is required,
> +		retval > 0 if normal touch handling is *not* required */
> +	if (!ts || !values)
> +		retval = -EIO;
> +
> +	return retval;
> +}
> +static int __devinit cyttsp_i2c_probe(struct i2c_client *client,
> +	const struct i2c_device_id *id)
> +{
> +	struct cyttsp_i2c *ts;
> +	int retval;
> +
> +	DBG(printk(KERN_INFO"%s: Enter\n", __func__);)
> +
> +	if (!i2c_check_functionality(client->adapter,
> +		I2C_FUNC_SMBUS_READ_WORD_DATA))
> +		return -EIO;
> +
> +	/* allocate and clear memory */
> +	ts = kzalloc(sizeof(*ts), GFP_KERNEL);
> +	if (ts == NULL) {
> +		printk(KERN_ERR "%s: Error, kzalloc.\n", __func__);
> +		retval = -ENOMEM;
> +		goto error_alloc_data_failed;
> +	}
> +
> +	/* register driver_data */
> +	ts->client = client;
> +	i2c_set_clientdata(client, ts);
> +	ts->ops.write = ttsp_i2c_write_block_data;
> +	ts->ops.read = ttsp_i2c_read_block_data;
> +	ts->ops.ext = ttsp_i2c_tch_ext;
> +
> +	ts->ttsp_client = cyttsp_core_init(&ts->ops, &client->dev);
> +	if (!ts->ttsp_client)
> +		goto ttsp_core_err;
> +
> +	printk(KERN_INFO "%s: Successful registration %s\n",
> +		__func__, CY_I2C_NAME);
> +	return 0;
> +
> +ttsp_core_err:
> +	kfree(ts);
> +error_alloc_data_failed:
> +	return retval;
> +}
> +
> +
> +/* registered in driver struct */
> +static int __devexit cyttsp_i2c_remove(struct i2c_client *client)
> +{
> +	struct cyttsp_i2c *ts;
> +
> +	DBG(printk(KERN_INFO"%s: Enter\n", __func__);)
> +	ts = i2c_get_clientdata(client);
> +	cyttsp_core_release(ts->ttsp_client);
> +	kfree(ts);
> +	return 0;
> +}
> +
> +#ifdef CONFIG_PM
> +static int cyttsp_i2c_suspend(struct i2c_client *client, pm_message_t message)
> +{
> +	return cyttsp_suspend(dev_get_drvdata(&client->dev));
> +}
> +
> +static int cyttsp_i2c_resume(struct i2c_client *client)
> +{
> +	return cyttsp_resume(dev_get_drvdata(&client->dev));
> +}
> +#endif
> +
> +static const struct i2c_device_id cyttsp_i2c_id[] = {
> +	{ CY_I2C_NAME, 0 },  { }
> +};
> +
> +static struct i2c_driver cyttsp_i2c_driver = {
> +	.driver = {
> +		.name = CY_I2C_NAME,
> +		.owner = THIS_MODULE,
> +	},
> +	.probe = cyttsp_i2c_probe,
> +	.remove = __devexit_p(cyttsp_i2c_remove),
> +	.id_table = cyttsp_i2c_id,
> +#ifdef CONFIG_PM
> +	.suspend = cyttsp_i2c_suspend,
> +	.resume = cyttsp_i2c_resume,
> +#endif
> +};
> +
> +static int cyttsp_i2c_init(void)
> +{

Please add __init like

static int __init cyttsp_i2c_init(void)

> +	int retval;
> +	retval = i2c_add_driver(&cyttsp_i2c_driver);
> +	printk(KERN_INFO "%s: Cypress TrueTouch(R) Standard Product I2C "
> +		"Touchscreen Driver (Built %s @ %s) returned %d\n",
> +		 __func__, __DATE__, __TIME__, retval);
> +
> +	return retval;
> +}
> +
> +static void cyttsp_i2c_exit(void)

__exit

> +{
> +	return i2c_del_driver(&cyttsp_i2c_driver);
> +}
> +
> +module_init(cyttsp_i2c_init);
> +module_exit(cyttsp_i2c_exit);
> +
> +MODULE_ALIAS("i2c:cyttsp");
> +MODULE_LICENSE("GPL");
> +MODULE_DESCRIPTION("Cypress TrueTouch(R) Standard Product (TTSP) I2C driver");
> +MODULE_AUTHOR("Cypress");
> +MODULE_DEVICE_TABLE(i2c, cyttsp_i2c_id);
> diff --git a/drivers/input/touchscreen/cyttsp_spi.c b/drivers/input/touchscreen/cyttsp_spi.c
> new file mode 100755
> index 0000000..cb6432a
> --- /dev/null
> +++ b/drivers/input/touchscreen/cyttsp_spi.c

I will comment on spi driver interface later.

---Trilok Soni

-- 
Sent by a consultant of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
