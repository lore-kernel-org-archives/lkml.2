Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751875Ab2LDTKw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2012 14:10:52 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:51466 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751308Ab2LDTKt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2012 14:10:49 -0500
Date: Tue, 4 Dec 2012 11:10:42 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Li Wu <willy.woo@gmail.com>
Cc: Li Wu <li.wu@st.com>, Henrik Rydberg <rydberg@euromail.se>,
        Andrew Morton <akpm@linux-foundation.org>,
        Joe Perches <joe@perches.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Shawn Landden <shawnlandden@gmail.com>, Felipe Balbi <balbi@ti.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Jianchun <jcbian@pixcir.com.cn>, David Dajun Chen <dchen@diasemi.com>,
        Ashish Jangam <ashish.jangam@kpitcummins.com>,
        simon.budig@kernelconcepts.de, rachna@ti.com,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        device-drivers-devel@blackfin.uclinux.org, victor.phay@st.com
Subject: Re: [PATCH v2 1/1] Input: STMicroelectronics multi touch capacitive
 touchscreen ftk
Message-ID: <20121204191042.GD23964@core.coreip.homeip.net>
References: <1354620389-1841-1-git-send-email-willy.woo@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1354620389-1841-1-git-send-email-willy.woo@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Li,

On Tue, Dec 04, 2012 at 06:26:29AM -0500, Li Wu wrote:
> +STM FTK TOUCHSCREEN DRIVER
> +M:      Li Wu <li.wu@st.com>
> +L:      device-drivers-devel@blackfin.uclinux.org
> +W:      http://www.st.com
> +S:      Supported
> +F:      drivers/input/touchscreen/ftk.c
> +
> +

You have an extra blank line here.

>  ADDRESS SPACE LAYOUT RANDOMIZATION (ASLR)
>  M:	Jiri Kosina <jkosina@suse.cz>
>  S:	Maintained
> diff --git a/drivers/input/touchscreen/Kconfig b/drivers/input/touchscreen/Kconfig
> index f7668b2..c81e2e7 100644
> --- a/drivers/input/touchscreen/Kconfig
> +++ b/drivers/input/touchscreen/Kconfig
> @@ -900,4 +900,15 @@ config TOUCHSCREEN_TPS6507X
>  	  To compile this driver as a module, choose M here: the
>  	  module will be called tps6507x_ts.
>  
> +config TOUCHSCREEN_FTK
> +        tristate "STMicroelectronics i2c multitouch touchscreen with FingerTipK"
> +        depends on I2C
> +        help
> +          Say Y here to enable STMicroelectronics touchscreen support.
> +
> +          If unsure, say N.
> +
> +          To compile this driver as a module, choose M here: the
> +          module will be called STM_ts.

Uppercase? And the module I think is currently called ftk, although you
might want to rename to ftk_ts. There is no corrsponding SPI part by any
chance?

> +
>  endif
> diff --git a/drivers/input/touchscreen/Makefile b/drivers/input/touchscreen/Makefile
> index 178eb12..6feba9b 100644
> --- a/drivers/input/touchscreen/Makefile
> +++ b/drivers/input/touchscreen/Makefile
> @@ -73,3 +73,4 @@ obj-$(CONFIG_TOUCHSCREEN_WM97XX_MAINSTONE)	+= mainstone-wm97xx.o
>  obj-$(CONFIG_TOUCHSCREEN_WM97XX_ZYLONITE)	+= zylonite-wm97xx.o
>  obj-$(CONFIG_TOUCHSCREEN_W90X900)	+= w90p910_ts.o
>  obj-$(CONFIG_TOUCHSCREEN_TPS6507X)	+= tps6507x-ts.o
> +obj-$(CONFIG_TOUCHSCREEN_FTK)           += ftk.o
> diff --git a/drivers/input/touchscreen/ftk.c b/drivers/input/touchscreen/ftk.c
> new file mode 100644
> index 0000000..fa98409
> --- /dev/null
> +++ b/drivers/input/touchscreen/ftk.c
> @@ -0,0 +1,638 @@
> +/*
> + * drivers/input/touchscreen/ftk.c

Please no file names in the source.

> + *
> + * Driver for STMicroelectronics FTK capacity touchscreen
> + *
> + * Author: JH Jang <jh.jang@st.com>
> + *         Victor Phay <victor.phay@st.com>
> + *         Li Wu <li.wu@st.com>, <willy.woo@gmail.com>
> + *
> + * Copyright (c) 2012 STMicroelectronics Limited
> + *
> + * This program is free software; you can redistribute  it and/or modify it
> + * under  the terms of  the GNU General  Public License as published by the
> + * Free Software Foundation;  either version 2 of the  License, or (at your
> + * option) any later version.
> + *

Extra line here.

> + */
> +
> +#include <linux/ctype.h>
> +#include <linux/delay.h>
> +#include <linux/errno.h>
> +#include <linux/firmware.h>
> +#include <linux/fs.h>
> +#include <linux/gpio.h>
> +#include <linux/hrtimer.h>
> +#include <linux/i2c.h>
> +#include <linux/i2c-dev.h>
> +#include <linux/init.h>
> +#include <linux/input.h>
> +#include <linux/interrupt.h>
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/platform_device.h>
> +#include <linux/serio.h>

You certainly do not need serio.h, platform_device.h, or gpio.h. Why do you need fs.h?
You probably do not need slab.h but do need gfp.h.

> +#include <linux/slab.h>
> +#include <linux/uaccess.h>

What do you need uaccess.h for?

> +
> +/*
> + * Definitions & global arrays.
> + */
> +#define DRIVER_DESC                   "ftk i2c touchscreen driver"

"FTK I2C Touchscreen Driver"?

> +#define FTK_TS_DRV_NAME               "ftk"
> +#define X_AXIS_MAX                    800
> +#define X_AXIS_MIN                    0
> +#define Y_AXIS_MAX                    480
> +#define Y_AXIS_MIN                    0
> +#define PRESSURE_MIN                  0
> +#define PRESSURE_MAX                  256
> +#define P70_PATCH_ADDR_START          0x00420000
> +#define LEAVE_EVENT                   0x04
> +#define ENTER_EVENT                   0x03
> +#define MOTION_EVENT                  0x05
> +#define RESET_EVENT                   0x10
> +#define MAX_SUPPORTED_FINGERS         10
> +#define MAX_TRANSACTION_LENGTH        8
> +#define NUM_DIM                       3
> +
> +#define FTK_SOFT_RESET                0x9E
> +#define FTK_TSSON                     0x83
> +#define FTK_READ_OLDESE_EVENT         0x85
> +#define FTK_BASE_ADDR                 0xB0
> +#define FTK_TYPE_B1                   0xB1
> +#define FTK_TYPE_B3                   0xB3
> +
> +
> +static struct i2c_driver stm_ts_driver;
> +static struct workqueue_struct *stmtouch_wq;
> +static int cor_xyz[MAX_SUPPORTED_FINGERS][NUM_DIM];
> +static unsigned char id_indx[MAX_SUPPORTED_FINGERS];
> +struct ftk_i2c_platform_data {
> +	int (*power)(int on);
> +};

Any chance to do without it? What does it do on your platform?

> +
> +struct ftk_ts {
> +	struct device *dev;
> +	struct i2c_client *client;
> +	struct input_dev *input_dev;
> +	struct hrtimer timer;
> +	struct work_struct work;

Please kill the timer and work. Production driver needs to use
interrupts.

> +	spinlock_t lock;
> +	int x;
> +	int y;
> +	int z;
> +	int irq;
> +	int (*power)(int on);
> +};
> +
> +static int ftk_write_reg(struct ftk_ts *ftk_ts, u8 *reg, u16 num_com)
> +{
> +	struct i2c_msg xfer_msg[2];
> +
> +	xfer_msg[0].addr = ftk_ts->client->addr;
> +	xfer_msg[0].len = num_com;
> +	xfer_msg[0].flags = 0;
> +	xfer_msg[0].buf = reg;
> +
> +	return i2c_transfer(ftk_ts->client->adapter, xfer_msg, 1);
> +}
> +
> +static int ftk_read_reg(struct ftk_ts *ftk_ts, u8 *reg, int cnum, u8 *buf,
> +			int num)
> +{
> +	u16 left = num;
> +	u16 offset = 0;
> +
> +	struct i2c_msg xfer_msg[2];
> +
> +	xfer_msg[0].addr = ftk_ts->client->addr;
> +	xfer_msg[0].len = cnum;
> +	xfer_msg[0].flags = 0;
> +	xfer_msg[0].buf = reg;
> +
> +	xfer_msg[1].addr = ftk_ts->client->addr;
> +	xfer_msg[1].flags = I2C_M_RD;
> +
> +	/* MTK platform */
> +	/* Can only transfer 8 bytes per transaction */
> +	while (left > 0) {
> +		xfer_msg[1].buf = &buf[offset];
> +
> +		if (left > MAX_TRANSACTION_LENGTH) {
> +			xfer_msg[1].len = MAX_TRANSACTION_LENGTH;
> +			left -= MAX_TRANSACTION_LENGTH;
> +			offset += MAX_TRANSACTION_LENGTH;
> +		} else {
> +			xfer_msg[1].len = left;
> +			left = 0;
> +		}
> +
> +		if (i2c_transfer(ftk_ts->client->adapter, xfer_msg, 2) != 2) {
> +			dev_err(ftk_ts->dev, "FTK - i2c Transfer error!\n");
> +			return 1;

Errors are usually negative.

> +		}
> +	}
> +
> +	return 0;
> +}
> +
> +static void touch_on(struct ftk_ts *ftkts, int x, int y, int z, int id)
> +{
> +	input_report_key(ftkts->input_dev, BTN_TOUCH, 1);
> +	input_report_abs(ftkts->input_dev, ABS_MT_POSITION_X, x);
> +	input_report_abs(ftkts->input_dev, ABS_MT_POSITION_Y, y);
> +	input_report_abs(ftkts->input_dev, ABS_MT_TOUCH_MAJOR, z);
> +	input_report_abs(ftkts->input_dev, ABS_MT_TRACKING_ID, id);
> +	input_mt_sync(ftkts->input_dev);
> +}
> +
> +static void touch_off(struct ftk_ts *ftkts)
> +{
> +	input_report_key(ftkts->input_dev, BTN_TOUCH, 0);
> +	input_report_abs(ftkts->input_dev, ABS_MT_TRACKING_ID, 0);
> +	input_mt_sync(ftkts->input_dev);
> +}
> +
> +static u8 load_config(struct ftk_ts *ftk_ts, const struct firmware *firmware)
> +{
> +	u16 one_group_length = 0;
> +	u16 patch_length = 0;
> +	u16 config_length = 0;
> +	u16 i = 0;
> +	u8 *pdata;
> +	u8 reg_add[8];
> +	u8 val[8];
> +	int ret;
> +
> +	patch_length = firmware->data[0] * 256 + firmware->data[1];

	patch_length = be16_to_cpup(firmware->data);

> +	config_length =
> +		firmware->data[patch_length + 2] * 256 +
> +		firmware->data[patch_length + 2 + 1];

	config_length = be16_to_cpup(...);

> +	pdata = (u8 *)&firmware->data[patch_length + 4];
> +
> +	while (i < config_length) {
> +		one_group_length = pdata[i] * 256 + pdata[i + 1];

		Again looks like BE data.

> +
> +		if ((pdata[i + 2] == 0xFF) && (pdata[i + 3] == 0xFF))
> +			mdelay(pdata[i + 4]);
> +		else{
> +			ftk_write_reg(ftk_ts, &(pdata[i + 2]),
> +				      one_group_length);
> +			mdelay(100);
> +		}
> +
> +		i = i + 2;
> +		i = i + one_group_length;
> +	}
> +
> +	reg_add[0] = FTK_BASE_ADDR;
> +	reg_add[1] = 0x05;       /* Set Interrupt Polarity */
> +	reg_add[2] = 0x00;       /* '00' - level interrupt */
> +	ftk_write_reg(ftk_ts, &reg_add[0], 3);
> +	mdelay(5);
> +
> +	reg_add[0] = FTK_BASE_ADDR;
> +	reg_add[1] = 0x06;       /* Enable Touch Detect Interrupt */
> +	reg_add[2] = 0x40;       /* 0xC0 */
> +	ftk_write_reg(ftk_ts, &reg_add[0], 3);
> +	mdelay(5);
> +
> +	reg_add[0] = FTK_BASE_ADDR;
> +	reg_add[1] = 0x07;       /* Read 0x07 to clear ISR */
> +	ret = ftk_read_reg(ftk_ts, &reg_add[0], 2, &val[0], 1);
> +	mdelay(5);
> +
> +	reg_add[0] = FTK_READ_OLDESE_EVENT;
> +	ret = ftk_read_reg(ftk_ts, &reg_add[0], 1, &val[0], 8);
> +	mdelay(20);
> +
> +	reg_add[0] = FTK_READ_OLDESE_EVENT;
> +	ret = ftk_read_reg(ftk_ts, &reg_add[0], 1, &val[0], 8);
> +	mdelay(20);
> +
> +	reg_add[0] = FTK_BASE_ADDR;
> +	reg_add[1] = 0x03;
> +	ret = ftk_read_reg(ftk_ts, reg_add, 2, val, 1);
> +	mdelay(5);
> +	dev_info(ftk_ts->dev, "Patch loaded, Version =%X\n", val[0]);
> +
> +	reg_add[0] = FTK_TSSON;       /* TS Sense on */
> +	reg_add[1] = 0x00;
> +	ret = ftk_write_reg(ftk_ts, &reg_add[0], 1);
> +	mdelay(5);
> +	return ret;
> +}
> +
> +static u8 load_patch(struct ftk_ts *ftk_ts, const struct firmware *firmware)
> +{
> +	u32 write_addr, j = 0, i = 0;
> +	u16 patch_length = 0;
> +	u8 byte_work[256 + 3] = { 0 };
> +	u8 reg_add[3] = { 0 };
> +
> +	patch_length = firmware->data[0] * 256 + firmware->data[1];
> +
> +	while (j < patch_length) {
> +		write_addr = P70_PATCH_ADDR_START + j;
> +
> +		reg_add[0] = FTK_TYPE_B3;
> +		reg_add[1] = (write_addr >> 24) & 0xFF;
> +		reg_add[2] = (write_addr >> 16) & 0xFF;
> +		ftk_write_reg(ftk_ts, &reg_add[0], 3);
> +
> +		byte_work[0] = FTK_TYPE_B1;
> +		byte_work[1] = (write_addr >> 8) & 0xFF;
> +		byte_work[2] = write_addr & 0xFF;
> +
> +		i = 0;
> +		while ((j < firmware->size) && (i < 256)) {
> +			byte_work[i + 3] = firmware->data[j + 2];
> +			i++;
> +			j++;
> +		}
> +		ftk_write_reg(ftk_ts, &byte_work[0], 256 + 3);
> +	}
> +
> +	return 0;
> +}
> +
> +static int verify_firmware(const struct firmware *firmware)
> +{
> +	u16 firmware_length;
> +	u16 patch_length;
> +	u16 config_length;
> +
> +	firmware_length = firmware->size;
> +	patch_length = firmware->data[0] * 256 + firmware->data[1];
> +	config_length =
> +		firmware->data[patch_length + 2] * 256 +
> +		firmware->data[patch_length + 2 + 1];
> +
> +	if (firmware_length == patch_length + config_length + 4)
> +		return 0;
> +	else
> +		return -1;
> +}
> +
> +static int init_ftk(struct ftk_ts *ftk_ts)
> +{
> +	const struct firmware *firmware;
> +	u8 reg_add[7];
> +	u8 val[8];
> +	int ret;
> +
> +	reg_add[0] = FTK_BASE_ADDR;
> +	reg_add[1] = 0x00;
> +	ret = ftk_read_reg(ftk_ts, reg_add, 2, val, 3);
> +
> +	if (ret < 0)
> +		dev_err(ftk_ts->dev, "i2c_transfer failed\n");
> +
> +	mdelay(1);
> +	dev_dbg(ftk_ts->dev, "Chip ID = %x %x %x\n", val[0], val[1], val[2]);
> +
> +	reg_add[0] = FTK_SOFT_RESET; /* TS Soft Reset */
> +	ret = ftk_write_reg(ftk_ts, &reg_add[0], 1);
> +	mdelay(1);
> +
> +	ret = request_firmware(&firmware, "ftk/ftk.bin", ftk_ts->dev);
> +	if (ret < 0) {
> +		dev_err(ftk_ts->dev, "request fw fail ,err = %d\n", ret);
> +		return ret;
> +	}
> +
> +	ret = verify_firmware(firmware);
> +	if (ret == 0) {
> +		load_patch(ftk_ts, firmware);
> +		load_config(ftk_ts, firmware);
> +
> +	}
> +
> +	release_firmware(firmware);
> +
> +	reg_add[0] = FTK_TYPE_B3;
> +	reg_add[1] = 0xFF;
> +	reg_add[2] = 0xFF;
> +	ftk_write_reg(ftk_ts, &reg_add[0], 3);
> +
> +	/*wait till this operation ends, to be safe */
> +	mdelay(5);
> +
> +	reg_add[0] = 0xA0;
> +	ftk_write_reg(ftk_ts, &reg_add[0], 1);
> +	mdelay(5);
> +
> +	if (ret < 0)
> +		dev_err(ftk_ts->dev, "ftk Not Initialised\n");
> +	else
> +		dev_info(ftk_ts->dev, "ftk Initialised\n");
> +
> +	return 0;
> +}
> +
> +static enum hrtimer_restart st_ts_timer_func(struct hrtimer *timer)
> +{
> +	struct ftk_ts *ftkts = container_of(timer, struct ftk_ts, timer);
> +
> +	queue_work(stmtouch_wq, &ftkts->work);
> +	return HRTIMER_NORESTART;
> +}
> +
> +static irqreturn_t ts_interrupt(int irq, void *handle)
> +{
> +	struct ftk_ts *ftk_ts = handle;
> +
> +	disable_irq_nosync(ftk_ts->client->irq);
> +	queue_work(stmtouch_wq, &ftk_ts->work);
> +	return IRQ_HANDLED;

Given that you are using threaded interrupt handler this does not  make
any sense.

> +}
> +
> +static u8 decode_data_packet(struct ftk_ts *ftkts, unsigned char data[],
> +			     unsigned char left_event)
> +{
> +	u8 event_num;
> +	u8 touch_id, event_id;
> +	u8 last_left_event = 0;
> +	u8 i, num_released_finger;
> +	u8 valid_id = 0;
> +
> +	for (event_num = 0; event_num < left_event; event_num++) {
> +		last_left_event = data[7 + event_num * 8] & 0x0F;
> +		touch_id = data[1 + event_num * 8] & 0x0F;
> +		event_id = data[event_num * 8] & 0xFF;
> +
> +		if ((event_id == LEAVE_EVENT) || (event_id == ENTER_EVENT) ||
> +		    (event_id == MOTION_EVENT)) {
> +			/* Enter, Leave or Motion Event */
> +			if (touch_id < MAX_SUPPORTED_FINGERS) {
> +				valid_id = 1;
> +
> +				id_indx[touch_id] = event_id;
> +				cor_xyz[touch_id][0] =
> +					((data[4 + event_num *
> +					       8] &
> +					  0xF0) >>
> +					 4) | ((data[2 + event_num * 8]) << 4);
> +				cor_xyz[touch_id][1] =
> +					((data[4 + event_num *
> +					       8] &
> +					  0x0F) |
> +					 ((data[3 + event_num * 8]) << 4));
> +				cor_xyz[touch_id][2] = data[5 + event_num * 8];
> +			}
> +		} else if (event_id == RESET_EVENT) {
> +			/* Reset happened */
> +			for (i = 0; i < MAX_SUPPORTED_FINGERS; i++)
> +				id_indx[i] = 0;
> +
> +			touch_off(ftkts);
> +
> +			input_sync(ftkts->input_dev);
> +			init_ftk(ftkts);
> +			return 0;
> +		}
> +	}
> +
> +	if (valid_id) {
> +		/* Report all fingers on panel */
> +		num_released_finger = 0;
> +		for (i = 0; i < MAX_SUPPORTED_FINGERS; i++) {
> +			if (id_indx[i]) {
> +				if (id_indx[i] == LEAVE_EVENT) {
> +					id_indx[i] = 0;
> +					num_released_finger++;
> +				}
> +
> +				touch_on(ftkts, cor_xyz[i][0], cor_xyz[i][1],
> +					 cor_xyz[i][2],
> +					 i);
> +			} else
> +				num_released_finger++;
> +		}
> +
> +		input_sync(ftkts->input_dev);
> +
> +		/* Check if all fingers are released */
> +		if (num_released_finger == MAX_SUPPORTED_FINGERS) {
> +			/* All fingers are released */
> +			touch_off(ftkts);
> +			input_sync(ftkts->input_dev);
> +		}
> +	}
> +
> +	return last_left_event;
> +}
> +
> +static void ts_tasklet_proc(struct work_struct *work)
> +{
> +	struct ftk_ts *ftkts = container_of(work, struct ftk_ts, work);
> +
> +	unsigned char data[256];
> +	int ret;
> +	u8 status;
> +	u8 reg_add;
> +	u8 i;
> +	u8 first_left_event = 0;
> +
> +	data[0] = FTK_BASE_ADDR;
> +	data[1] = 0x07;
> +	ret = ftk_read_reg(ftkts, &data[0], 2, &status, 1);
> +
> +	if (status & 0x40) {
> +		reg_add = FTK_READ_OLDESE_EVENT;
> +		if (ftk_read_reg(ftkts, &reg_add, 1, data, 8) == 0) {
> +			first_left_event = decode_data_packet(ftkts, data, 1);
> +
> +			/* Read and process 1 event (8bytes) at a time */
> +			for (i = 0; i < first_left_event; i++) {
> +				reg_add = FTK_READ_OLDESE_EVENT;
> +				if (ftk_read_reg(ftkts, &reg_add, 1, data,
> +						 8) == 0)
> +					first_left_event = decode_data_packet(
> +						ftkts, data, 1);
> +			}
> +		}
> +	}
> +
> +	if (!ftkts->irq)
> +		hrtimer_start(&ftkts->timer, ktime_set(0, 10000000),
> +			      HRTIMER_MODE_REL);
> +	else
> +		enable_irq(ftkts->client->irq);
> +}
> +
> +static int stm_ts_probe(struct i2c_client *client,
> +			const struct i2c_device_id *idp)
> +{
> +	struct ftk_ts *ftk_ts = NULL;
> +	struct ftk_i2c_platform_data *pdata;
> +	int ret = 0;
> +	int err = 0;
> +
> +	if (!i2c_check_functionality(client->adapter, I2C_FUNC_I2C)) {
> +		dev_err(ftk_ts->dev, "err = EIO!\n");
> +		err = EIO;

Errors are negative.

> +		goto fail;
> +	}
> +
> +	ftk_ts = kzalloc(sizeof(struct ftk_ts), GFP_KERNEL);
> +	if (!ftk_ts) {
> +		dev_err(ftk_ts->dev, "err = ENOMEM!\n");
> +		err = ENOMEM;
> +		goto fail;
> +	}
> +
> +	INIT_WORK(&ftk_ts->work, ts_tasklet_proc);
> +
> +	ftk_ts->client = client;
> +	i2c_set_clientdata(client, ftk_ts);
> +
> +	pdata = client->dev.platform_data;
> +
> +	if (pdata)
> +		ftk_ts->power = pdata->power;
> +
> +	if (ftk_ts->power) {
> +		ret = ftk_ts->power(1);
> +
> +		pdata->power(1);
> +
> +		if (ret < 0) {
> +			pr_err("ftk_probe power on failed\n");
> +			goto fail;
> +		}
> +	}
> +
> +	ftk_ts->dev = &ftk_ts->client->dev;
> +	ftk_ts->input_dev = input_allocate_device();
> +	if (!ftk_ts->input_dev) {
> +		dev_err(ftk_ts->dev, "err = ENOMEM!\n");
> +		err = ENOMEM;
> +		goto fail;
> +	}
> +	ftk_ts->input_dev->dev.parent = &client->dev;
> +	ftk_ts->input_dev->name = "ftk";
> +	ftk_ts->input_dev->phys = "ftk/input0";
> +	ftk_ts->input_dev->id.bustype = BUS_I2C;
> +	ftk_ts->input_dev->id.vendor = 0x0001;
> +	ftk_ts->input_dev->id.product = 0x0002;
> +	ftk_ts->input_dev->id.version = 0x0100;
> +
> +	ftk_ts->input_dev->evbit[0] = BIT_MASK(EV_KEY) | BIT_MASK(EV_ABS);
> +	ftk_ts->input_dev->keybit[BIT_WORD(BTN_TOUCH)] = BIT_MASK(BTN_TOUCH);
> +	set_bit(EV_SYN, ftk_ts->input_dev->evbit);

EV_SYN is always set by the core.


> +	set_bit(EV_KEY, ftk_ts->input_dev->evbit);
> +	set_bit(BTN_TOUCH, ftk_ts->input_dev->keybit);
> +	set_bit(BTN_2, ftk_ts->input_dev->keybit);

What is BTN_2? You never report it.

> +	set_bit(EV_ABS, ftk_ts->input_dev->evbit);

__set_bit() please.

> +
> +	input_set_abs_params(ftk_ts->input_dev, ABS_X, X_AXIS_MIN, X_AXIS_MAX,
> +			     0, 0);
> +	input_set_abs_params(ftk_ts->input_dev, ABS_Y, Y_AXIS_MIN, Y_AXIS_MAX,
> +			     0, 0);
> +	input_set_abs_params(ftk_ts->input_dev, ABS_PRESSURE, PRESSURE_MIN,
> +			     PRESSURE_MAX, 0, 0);
> +	input_set_abs_params(ftk_ts->input_dev, ABS_MT_TRACKING_ID, 0, 10, 0,
> +			     0);
> +	input_set_abs_params(ftk_ts->input_dev, ABS_MT_TOUCH_MAJOR,
> +			     PRESSURE_MIN, PRESSURE_MAX, 0, 0);
> +	input_set_abs_params(ftk_ts->input_dev, ABS_MT_WIDTH_MAJOR,
> +			     PRESSURE_MIN, PRESSURE_MAX, 0, 0);

I do not see you reporting pressure.

> +	input_set_abs_params(ftk_ts->input_dev, ABS_MT_POSITION_X, X_AXIS_MIN,
> +			     X_AXIS_MAX, 0, 0);
> +	input_set_abs_params(ftk_ts->input_dev, ABS_MT_POSITION_Y, Y_AXIS_MIN,
> +			     Y_AXIS_MAX, 0, 0);
> +
> +	err = input_register_device(ftk_ts->input_dev);
> +	if (err) {
> +		dev_err(ftk_ts->dev, "input_register_device fail!\n");
> +		goto fail;
> +	}
> +
> +	err = init_ftk(ftk_ts);
> +	if (err) {
> +		dev_err(ftk_ts->dev, "init_ftk  fail!\n");
> +		goto fail;
> +	}
> +
> +	ftk_ts->irq = client->irq;
> +
> +	if (!ftk_ts->irq) {
> +		hrtimer_init(&ftk_ts->timer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
> +		ftk_ts->timer.function = st_ts_timer_func;
> +		hrtimer_start(&ftk_ts->timer, ktime_set(1, 0),
> +			      HRTIMER_MODE_REL);
> +	} else {
> +		ret = devm_request_threaded_irq(ftk_ts->dev, ftk_ts->irq,
> +						NULL, ts_interrupt,
> +						IRQF_TRIGGER_LOW | IRQF_ONESHOT,
> +						client->name,
> +						ftk_ts);

If you are using devm_request_threaded_irq() why not devm_kzalloc and
devm_input_allocate_device()?

> +		if (ret) {
> +			dev_err(ftk_ts->dev, "request_irq  fail!\n");
> +			err = -EBUSY;
> +			goto fail;
> +		}
> +	}
> +
> +	return 0;
> +fail:
> +	if (ftk_ts) {
> +		if (ftk_ts->input_dev)
> +			input_free_device(ftk_ts->input_dev);
> +		kfree(ftk_ts);
> +	}
> +	dev_info(ftk_ts->dev, "--ftkts_probe ret=%d\n", err);
> +	return err;
> +}
> +
> +static int stm_ts_remove(struct i2c_client *client)
> +{
> +	struct ftk_ts *ts = i2c_get_clientdata(client);
> +
> +	if (ts->irq)
> +		devm_free_irq(ts->dev, client->irq, ts);
> +	else
> +		hrtimer_cancel(&ts->timer);
> +
> +	input_unregister_device(ts->input_dev);
> +	kfree(ts);
> +	return 0;
> +}
> +
> +static const struct i2c_device_id stm_ts_id[] = {
> +	{ "ftk", 0 },
> +	{}
> +};
> +
> +static struct i2c_driver stm_ts_driver = {
> +	.driver		= {
> +		.name	= "ftk",
> +	},
> +	.probe		= stm_ts_probe,
> +	.remove		= stm_ts_remove,
> +	.id_table	= stm_ts_id,
> +};
> +
> +static int __init stm_ts_init(void)
> +{
> +	stmtouch_wq = create_singlethread_workqueue("stmtouch_wq");
> +	if (!stmtouch_wq)
> +		return -ENOMEM;
> +
> +	return i2c_add_driver(&stm_ts_driver);
> +}
> +
> +static void __exit stm_ts_exit(void)
> +{
> +	i2c_del_driver(&stm_ts_driver);
> +	if (stmtouch_wq)
> +		destroy_workqueue(stmtouch_wq);
> +}
> +
> +MODULE_DESCRIPTION("STM MultiTouch IC Driver");
> +MODULE_AUTHOR("Li Wu <li.wu@st.com>");
> +MODULE_LICENSE("GPL");
> +
> +module_init(stm_ts_init);
> +module_exit(stm_ts_exit);

Please use module_i2c_driver().

Also please CC Jean Delvare on your next submission so he can look over
I2C bits.

Thanks.

-- 
Dmitry
