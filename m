Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752600Ab1GVFQ0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jul 2011 01:16:26 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:48346 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751432Ab1GVFQY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jul 2011 01:16:24 -0400
Date: Thu, 21 Jul 2011 22:16:17 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Eric Andersson <eric.andersson@unixphere.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        zhengguang.guo@bosch-sensortec.com, stefan.nilsson@unixphere.com,
        alan@lxorguk.ukuu.org.uk, Albert Zhang <xu.zhang@bosch-sensortec.com>
Subject: Re: [PATCH v5 1/1] input: add driver for Bosch Sensortec's BMA150
 accelerometer
Message-ID: <20110722051617.GB16040@core.coreip.homeip.net>
References: <1311281268-9498-1-git-send-email-eric.andersson@unixphere.com>
 <1311281268-9498-2-git-send-email-eric.andersson@unixphere.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1311281268-9498-2-git-send-email-eric.andersson@unixphere.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Eric,

On Thu, Jul 21, 2011 at 10:47:48PM +0200, Eric Andersson wrote:
> Signed-off-by: Albert Zhang <xu.zhang@bosch-sensortec.com>
> Signed-off-by: Eric Andersson <eric.andersson@unixphere.com>

Mostly looks good to me, a few comments below.

> ---
>  drivers/input/misc/Kconfig  |   11 +
>  drivers/input/misc/Makefile |    1 +
>  drivers/input/misc/bma150.c |  667 +++++++++++++++++++++++++++++++++++++++++++
>  include/linux/bma150.h      |   64 ++++
>  4 files changed, 743 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/input/misc/bma150.c
>  create mode 100644 include/linux/bma150.h
> 
> diff --git a/drivers/input/misc/Kconfig b/drivers/input/misc/Kconfig
> index 45dc6aa..e6681d2 100644
> --- a/drivers/input/misc/Kconfig
> +++ b/drivers/input/misc/Kconfig
> @@ -478,4 +478,15 @@ config INPUT_XEN_KBDDEV_FRONTEND
>  	  To compile this driver as a module, choose M here: the
>  	  module will be called xen-kbdfront.
>  
> +config INPUT_BMA150
> +	tristate "BMA150/SMB380 acceleration sensor support"
> +	depends on I2C
> +	select INPUT_POLLDEV
> +	help
> +	  Say Y here if you have Bosch Sensortec's BMA150 or SMB380
> +	  acceleration sensor hooked to an I2C bus.
> +
> +	  To compile this driver as a module, choose M here: the
> +	  module will be called bma150.
> +
>  endif
> diff --git a/drivers/input/misc/Makefile b/drivers/input/misc/Makefile
> index 38efb2c..9b13e0e 100644
> --- a/drivers/input/misc/Makefile
> +++ b/drivers/input/misc/Makefile
> @@ -45,4 +45,5 @@ obj-$(CONFIG_INPUT_WISTRON_BTNS)	+= wistron_btns.o
>  obj-$(CONFIG_INPUT_WM831X_ON)		+= wm831x-on.o
>  obj-$(CONFIG_INPUT_XEN_KBDDEV_FRONTEND)	+= xen-kbdfront.o
>  obj-$(CONFIG_INPUT_YEALINK)		+= yealink.o
> +obj-$(CONFIG_INPUT_BMA150)		+= bma150.o
>  
> diff --git a/drivers/input/misc/bma150.c b/drivers/input/misc/bma150.c
> new file mode 100644
> index 0000000..157f7cf
> --- /dev/null
> +++ b/drivers/input/misc/bma150.c
> @@ -0,0 +1,667 @@
> +/*
> + * Copyright (c) 2011 Bosch Sensortec GmbH
> + * Copyright (c) 2011 Unixphere
> + *
> + * This driver adds support for Bosch Sensortec's digital acceleration
> + * sensors BMA150 and SMB380.
> + * The SMB380 is fully compatible with BMA150 and only differs in packaging.
> + *
> + * The datasheet for the BMA150 chip can be found here:
> + * http://www.bosch-sensortec.com/content/language1/downloads/BST-BMA150-DS000-07.pdf
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
> + */
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/i2c.h>
> +#include <linux/input.h>
> +#include <linux/input-polldev.h>
> +#include <linux/interrupt.h>
> +#include <linux/delay.h>
> +#include <linux/slab.h>
> +#include <linux/pm.h>
> +#include <linux/pm_runtime.h>
> +#include <linux/bma150.h>
> +
> +#define ABSMAX_ACC_VAL		0x01FF
> +#define ABSMIN_ACC_VAL		-(ABSMAX_ACC_VAL)
> +/* Each axis is represented by a 2-byte data word */
> +#define BMA150_XYZ_DATA_SIZE	6
> +/* Input poll interval in milliseconds */
> +#define BMA150_POLL_INTERVAL	10
> +#define BMA150_POLL_MAX		200
> +#define BMA150_POLL_MIN		0
> +
> +#define BMA150_BW_25HZ		0
> +#define BMA150_BW_50HZ		1
> +#define BMA150_BW_100HZ		2
> +#define BMA150_BW_190HZ		3
> +#define BMA150_BW_375HZ		4
> +#define BMA150_BW_750HZ		5
> +#define BMA150_BW_1500HZ	6
> +
> +#define BMA150_RANGE_2G		0
> +#define BMA150_RANGE_4G		1
> +#define BMA150_RANGE_8G		2
> +
> +#define BMA150_MODE_NORMAL	0
> +#define BMA150_MODE_SLEEP	2
> +#define BMA150_MODE_WAKE_UP	3
> +
> +#define BMA150_CHIP_ID		2
> +#define BMA150_CHIP_ID_REG	BMA150_DATA_0_REG
> +
> +#define BMA150_ACC_X_LSB_REG	BMA150_DATA_2_REG
> +
> +#define BMA150_SLEEP_POS	0
> +#define BMA150_SLEEP_MSK	0x01
> +#define BMA150_SLEEP_REG	BMA150_CTRL_0_REG
> +
> +#define BMA150_BANDWIDTH_POS	0
> +#define BMA150_BANDWIDTH_MSK	0x07
> +#define BMA150_BANDWIDTH_REG	BMA150_CTRL_2_REG
> +
> +#define BMA150_RANGE_POS	3
> +#define BMA150_RANGE_MSK	0x18
> +#define BMA150_RANGE_REG	BMA150_CTRL_2_REG
> +
> +#define BMA150_WAKE_UP_POS	0
> +#define BMA150_WAKE_UP_MSK	0x01
> +#define BMA150_WAKE_UP_REG	BMA150_CTRL_3_REG
> +
> +#define BMA150_SW_RES_POS	1
> +#define BMA150_SW_RES_MSK	0x02
> +#define BMA150_SW_RES_REG	BMA150_CTRL_0_REG
> +
> +/* Any-motion interrupt register fields */
> +#define BMA150_ANY_MOTION_EN_POS	6
> +#define BMA150_ANY_MOTION_EN_MSK	0x40
> +#define BMA150_ANY_MOTION_EN_REG	BMA150_CTRL_1_REG
> +
> +#define BMA150_ANY_MOTION_DUR_POS	6
> +#define BMA150_ANY_MOTION_DUR_MSK	0xC0
> +#define BMA150_ANY_MOTION_DUR_REG	BMA150_CFG_5_REG
> +
> +#define BMA150_ANY_MOTION_THRES_REG	BMA150_CFG_4_REG
> +
> +/* Advanced interrupt register fields */
> +#define BMA150_ADV_INT_EN_POS		6
> +#define BMA150_ADV_INT_EN_MSK		0x40
> +#define BMA150_ADV_INT_EN_REG		BMA150_CTRL_3_REG
> +
> +/* High-G interrupt register fields */
> +#define BMA150_HIGH_G_EN_POS		1
> +#define BMA150_HIGH_G_EN_MSK		0x02
> +#define BMA150_HIGH_G_EN_REG		BMA150_CTRL_1_REG
> +
> +#define BMA150_HIGH_G_HYST_POS		3
> +#define BMA150_HIGH_G_HYST_MSK		0x38
> +#define BMA150_HIGH_G_HYST_REG		BMA150_CFG_5_REG
> +
> +#define BMA150_HIGH_G_DUR_REG		BMA150_CFG_3_REG
> +#define BMA150_HIGH_G_THRES_REG		BMA150_CFG_2_REG
> +
> +/* Low-G interrupt register fields */
> +#define BMA150_LOW_G_EN_POS		0
> +#define BMA150_LOW_G_EN_MSK		0x01
> +#define BMA150_LOW_G_EN_REG		BMA150_CTRL_1_REG
> +
> +#define BMA150_LOW_G_HYST_POS		0
> +#define BMA150_LOW_G_HYST_MSK		0x07
> +#define BMA150_LOW_G_HYST_REG		BMA150_CFG_5_REG
> +
> +#define BMA150_LOW_G_DUR_REG		BMA150_CFG_1_REG
> +#define BMA150_LOW_G_THRES_REG		BMA150_CFG_0_REG
> +
> +struct bma150_data {
> +	struct i2c_client *client;
> +	struct bma150_cfg cfg;
> +	struct input_polled_dev *input_polled;
> +	struct input_dev *input;
> +	struct mutex mutex;
> +};
> +
> +/*
> + * The settings for the given range, bandwidth and interrupt features
> + * are stated and verified by Bosch Sensortec where they are configured
> + * to provide a generic sensitivity performance.
> + */
> +static const struct bma150_cfg def_cfg = {
> +	BMA150_RANGE_2G,	/* Range */
> +	BMA150_BW_50HZ,		/* Bandwidth */
> +	1,			/* Any-motion interrupt */
> +	1,			/* High-G interrupt */
> +	1,			/* Low-G interrupt */
> +	0,			/* Any-motion duration */
> +	0,			/* Any-motion threshold */
> +	0,			/* High-G hysteresis */
> +	150,			/* High-G duration */
> +	140,			/* High-G threshold */
> +	0,			/* Low-G hysteresis */
> +	150,			/* Low-G duration */
> +	40			/* Low-G threshold */

Instead of using comments why don't you use named structure
initializers. It will also be safer should bma150_cfg change.

> +};
> +
> +static int bma150_write_byte(struct i2c_client *client, u8 reg, u8 val)
> +{
> +	s32 ret;
> +	/* As per specification, disable irq in between register writes */
> +	if (client->irq)
> +		disable_irq_nosync(client->irq);
> +	ret = i2c_smbus_write_byte_data(client, reg, val);
> +	if (client->irq)
> +		enable_irq(client->irq);
> +	return ret;
> +}
> +
> +static int bma150_set_reg_bits(struct i2c_client *client,
> +					int val, int shift, u8 mask, u8 reg)
> +{
> +	int data = i2c_smbus_read_byte_data(client, reg);
> +
> +	if (data < 0)
> +		return data;
> +
> +	data = (data & ~mask) | ((val << shift) & mask);
> +	return bma150_write_byte(client, reg, data);
> +}
> +
> +static int bma150_soft_reset(struct i2c_client *client)
> +{

__devinit?

> +	s32 ret;
> +	struct bma150_data *bma150 = i2c_get_clientdata(client);
> +
> +	mutex_lock(&bma150->mutex);

What are we racing with?

> +	ret = bma150_set_reg_bits(client, 1, BMA150_SW_RES_POS,
> +			BMA150_SW_RES_MSK, BMA150_SW_RES_REG);
> +	msleep(2);
> +	mutex_unlock(&bma150->mutex);
> +	return ret;
> +}
> +
> +static int bma150_set_mode(struct i2c_client *client, u8 mode)
> +{
> +	s32 ret;
> +	struct bma150_data *bma150 = i2c_get_clientdata(client);
> +
> +	mutex_lock(&bma150->mutex);

What are we racing with?

Overall, I think runtime PM methods should take input device's mutex and
then you can get rid of bma150->mutex.

> +	ret = bma150_set_reg_bits(client, mode, BMA150_WAKE_UP_POS,
> +				BMA150_WAKE_UP_MSK, BMA150_WAKE_UP_REG);
> +	if (ret < 0)
> +		goto error;
> +	ret = bma150_set_reg_bits(client, mode, BMA150_SLEEP_POS,
> +				BMA150_SLEEP_MSK, BMA150_SLEEP_REG);
> +	if (ret < 0)
> +		goto error;
> +	if (mode == BMA150_MODE_NORMAL)
> +		msleep(2);
> +error:
> +	mutex_unlock(&bma150->mutex);
> +	return ret;
> +}
> +
> +static int bma150_set_range(struct i2c_client *client, u8 range)
> +{
> +	s32 ret;
> +	struct bma150_data *bma150 = i2c_get_clientdata(client);
> +
> +	mutex_lock(&bma150->mutex);
> +	ret = bma150_set_reg_bits(client, range, BMA150_RANGE_POS,
> +				BMA150_RANGE_MSK, BMA150_RANGE_REG);
> +	mutex_unlock(&bma150->mutex);
> +	return ret;
> +}
> +
> +static int bma150_set_bandwidth(struct i2c_client *client, u8 bw)
> +{
> +	s32 ret;
> +	struct bma150_data *bma150 = i2c_get_clientdata(client);
> +
> +	mutex_lock(&bma150->mutex);
> +	ret = bma150_set_reg_bits(client, bw, BMA150_BANDWIDTH_POS,
> +				BMA150_BANDWIDTH_MSK, BMA150_BANDWIDTH_REG);
> +	mutex_unlock(&bma150->mutex);
> +	return ret;
> +}
> +
> +static int bma150_set_low_g_interrupt(struct i2c_client *client, u8 enable,
> +						u8 hyst, u8 dur, u8 thres)
> +{
> +	s32 ret;
> +	struct bma150_data *bma150 = i2c_get_clientdata(client);
> +
> +	mutex_lock(&bma150->mutex);
> +	ret = bma150_set_reg_bits(bma150->client, hyst,
> +				BMA150_LOW_G_HYST_POS,
> +					BMA150_LOW_G_HYST_MSK,
> +						BMA150_LOW_G_HYST_REG);
> +	if (ret < 0)
> +		goto error;
> +
> +	ret = bma150_write_byte(bma150->client,	BMA150_LOW_G_DUR_REG, dur);
> +	if (ret < 0)
> +		goto error;
> +
> +	ret = bma150_write_byte(bma150->client,	BMA150_LOW_G_THRES_REG, thres);
> +	if (ret < 0)
> +		goto error;
> +
> +	ret = bma150_set_reg_bits(bma150->client, !!enable,
> +				BMA150_LOW_G_EN_POS, BMA150_LOW_G_EN_MSK,
> +					BMA150_LOW_G_EN_REG);
> +error:
> +	mutex_unlock(&bma150->mutex);
> +	return ret;
> +}
> +
> +static int bma150_set_high_g_interrupt(struct i2c_client *client, u8 enable,
> +						u8 hyst, u8 dur, u8 thres)
> +{
> +	s32 ret;
> +	struct bma150_data *bma150 = i2c_get_clientdata(client);
> +
> +	mutex_lock(&bma150->mutex);
> +	ret = bma150_set_reg_bits(bma150->client, hyst,
> +				BMA150_HIGH_G_HYST_POS,
> +					BMA150_HIGH_G_HYST_MSK,
> +						BMA150_HIGH_G_HYST_REG);
> +	if (ret < 0)
> +		goto error;
> +
> +	ret = bma150_write_byte(bma150->client,	BMA150_HIGH_G_DUR_REG, dur);
> +	if (ret < 0)
> +		goto error;
> +
> +	ret = bma150_write_byte(bma150->client,	BMA150_HIGH_G_THRES_REG, thres);
> +	if (ret < 0)
> +		goto error;
> +
> +	ret = bma150_set_reg_bits(bma150->client, !!enable,
> +				BMA150_HIGH_G_EN_POS, BMA150_HIGH_G_EN_MSK,
> +					BMA150_HIGH_G_EN_REG);
> +error:
> +	mutex_unlock(&bma150->mutex);
> +	return ret;
> +}
> +
> +
> +static int bma150_set_any_motion_interrupt(struct i2c_client *client, u8 enable,
> +							u8 dur, u8 thres)
> +{
> +	s32 ret;
> +	struct bma150_data *bma150 = i2c_get_clientdata(client);
> +
> +	mutex_lock(&bma150->mutex);
> +	ret = bma150_set_reg_bits(bma150->client, dur,
> +				BMA150_ANY_MOTION_DUR_POS,
> +					BMA150_ANY_MOTION_DUR_MSK,
> +						BMA150_ANY_MOTION_DUR_REG);
> +	if (ret < 0)
> +		goto error;
> +
> +	ret = bma150_write_byte(bma150->client,
> +					BMA150_ANY_MOTION_THRES_REG, thres);
> +	if (ret < 0)
> +		goto error;
> +
> +	ret = bma150_set_reg_bits(bma150->client, !!enable,
> +				BMA150_ADV_INT_EN_POS, BMA150_ADV_INT_EN_MSK,
> +					BMA150_ADV_INT_EN_REG);
> +	if (ret < 0)
> +		goto error;
> +
> +	ret = bma150_set_reg_bits(bma150->client, !!enable,
> +				BMA150_ANY_MOTION_EN_POS,
> +					BMA150_ANY_MOTION_EN_MSK,
> +						BMA150_ANY_MOTION_EN_REG);
> +error:
> +	mutex_unlock(&bma150->mutex);
> +	return ret;
> +}
> +
> +static int bma150_initialize(struct i2c_client *client, struct bma150_cfg *cfg)
> +{
> +	s32 ret = bma150_soft_reset(client);
> +	if (ret < 0)
> +		return ret;
> +
> +	ret = bma150_set_bandwidth(client, cfg->bandwidth);
> +	if (ret < 0)
> +		return ret;
> +
> +	ret = bma150_set_range(client, cfg->range);
> +	if (ret < 0)
> +		return ret;
> +
> +	if (!client->irq)
> +		goto exit;
> +
> +	ret = bma150_set_any_motion_interrupt(client, cfg->any_motion_int,
> +			cfg->any_motion_dur, cfg->any_motion_thres);
> +	if (ret < 0)
> +		return ret;
> +
> +	ret = bma150_set_high_g_interrupt(client, cfg->hg_int,
> +			cfg->hg_hyst, cfg->hg_dur, cfg->hg_thres);
> +	if (ret < 0)
> +		return ret;
> +
> +	ret = bma150_set_low_g_interrupt(client, cfg->lg_int,
> +			cfg->lg_hyst, cfg->lg_dur, cfg->lg_thres);
> +	if (ret < 0)
> +		return ret;
> +exit:
> +	ret = bma150_set_mode(client, BMA150_MODE_SLEEP);
> +	return ret;
> +}
> +
> +static void bma150_report_xyz(struct bma150_data *bma150)
> +{
> +	u8 data[BMA150_XYZ_DATA_SIZE];
> +	s16 x, y, z;
> +	s32 ret;
> +
> +	mutex_lock(&bma150->mutex);

Do we need to take this lock? What can race with us here?

> +	ret = i2c_smbus_read_i2c_block_data(bma150->client,
> +			BMA150_ACC_X_LSB_REG, BMA150_XYZ_DATA_SIZE, data);
> +	if (ret != BMA150_XYZ_DATA_SIZE)
> +		return;
> +
> +	x = ((0xc0 & data[0]) >> 6) | (data[1] << 2);
> +	y = ((0xc0 & data[2]) >> 6) | (data[3] << 2);
> +	z = ((0xc0 & data[4]) >> 6) | (data[5] << 2);
> +
> +	/* sign extension */
> +	x = (s16) (x << 6) >> 6;
> +	y = (s16) (y << 6) >> 6;
> +	z = (s16) (z << 6) >> 6;
> +	mutex_unlock(&bma150->mutex);
> +
> +	input_report_abs(bma150->input, ABS_X, x);
> +	input_report_abs(bma150->input, ABS_Y, y);
> +	input_report_abs(bma150->input, ABS_Z, z);
> +	input_sync(bma150->input);
> +}
> +
> +static irqreturn_t bma150_irq_thread(int irq, void *dev)
> +{
> +	bma150_report_xyz(dev);
> +	return IRQ_HANDLED;
> +}
> +
> +static void bma150_poll(struct input_polled_dev *dev)
> +{
> +	bma150_report_xyz(dev->private);
> +}
> +
> +static int bma150_open(struct bma150_data *bma150)
> +{
> +#ifdef CONFIG_PM_RUNTIME
> +	return pm_runtime_get_sync(&bma150->client->dev);
> +#else
> +	return bma150_set_mode(bma150->client, BMA150_MODE_NORMAL);

Hmm, this is kind of weird. I'd expect you want to try waking up the
parent in both cases (if no runtime pm then call to pm_runtime_get_sync
is basically a noop) and then wake up your device.

> +#endif
> +}
> +
> +static void bma150_close(struct bma150_data *bma150)
> +{
> +#ifdef CONFIG_PM_RUNTIME
> +	pm_runtime_put(&bma150->client->dev);
> +#else
> +	bma150_set_mode(bma150->client, BMA150_MODE_SLEEP);
> +#endif
> +}
> +
> +static int bma150_irq_open(struct input_dev *input)
> +{
> +	struct bma150_data *bma150 = input_get_drvdata(input);

Empty line between variable declaration and code please.

> +	return bma150_open(bma150);
> +}
> +
> +static void bma150_irq_close(struct input_dev *input)
> +{
> +	struct bma150_data *bma150 = input_get_drvdata(input);
> +	bma150_close(bma150);
> +}
> +
> +static void bma150_poll_open(struct input_polled_dev *ipoll_dev)
> +{
> +	struct bma150_data *bma150 = ipoll_dev->private;
> +	bma150_open(bma150);
> +}
> +
> +static void bma150_poll_close(struct input_polled_dev *ipoll_dev)
> +{
> +	struct bma150_data *bma150 = ipoll_dev->private;
> +	bma150_close(bma150);
> +}
> +
> +static void bma150_free_input_device(struct bma150_data *bma150)
> +{
> +	if (bma150->client->irq > 0)
> +		input_unregister_device(bma150->input);
> +	else
> +		input_unregister_polled_device(bma150->input_polled);
> +}
> +
> +static int bma150_setup_input_device(struct bma150_data *bma150)

Can be marked __devinit as well.

> +{
> +	struct input_polled_dev *ipoll_dev;
> +	struct input_dev *idev;
> +	int ret;
> +
> +	if (bma150->client->irq > 0) {
> +		idev = input_allocate_device();
> +		if (!idev)
> +			return -ENOMEM;
> +		idev->open = bma150_irq_open;
> +		idev->close = bma150_irq_close;
> +		input_set_drvdata(idev, bma150);
> +	} else {
> +		ipoll_dev = input_allocate_polled_device();
> +		if (!ipoll_dev)
> +			return -ENOMEM;
> +		ipoll_dev->private = bma150;
> +		ipoll_dev->open = bma150_poll_open;
> +		ipoll_dev->close = bma150_poll_close;
> +		ipoll_dev->poll = bma150_poll;
> +		ipoll_dev->poll_interval = BMA150_POLL_INTERVAL;
> +		ipoll_dev->poll_interval_min = BMA150_POLL_MIN;
> +		ipoll_dev->poll_interval_max = BMA150_POLL_MAX;
> +
> +		idev = ipoll_dev->input;
> +	}
> +
> +	idev->name = BMA150_DRIVER;
> +	idev->phys = BMA150_DRIVER "/input0";
> +	idev->id.bustype = BUS_I2C;
> +	idev->dev.parent = &bma150->client->dev;
> +
> +	input_set_capability(idev, EV_ABS, ABS_MISC);

I do not see you sending ABS_MISC events anywhere.

> +	input_set_abs_params(idev, ABS_X, ABSMIN_ACC_VAL, ABSMAX_ACC_VAL, 0, 0);
> +	input_set_abs_params(idev, ABS_Y, ABSMIN_ACC_VAL, ABSMAX_ACC_VAL, 0, 0);
> +	input_set_abs_params(idev, ABS_Z, ABSMIN_ACC_VAL, ABSMAX_ACC_VAL, 0, 0);
> +
> +	if (bma150->client->irq > 0) {
> +		ret = input_register_device(idev);
> +		if (ret < 0) {
> +			input_free_device(idev);
> +			return ret;
> +		}
> +		ret = request_threaded_irq(bma150->client->irq, NULL,
> +			bma150_irq_thread, IRQF_TRIGGER_RISING,
> +			BMA150_DRIVER, bma150);
> +		if (ret < 0) {
> +			dev_err(&bma150->client->dev,
> +				"irq request failed %d, ret %d\n",
> +				bma150->client->irq, ret);
> +			goto error_irq;
> +		}
> +	} else {
> +		ret = input_register_polled_device(ipoll_dev);
> +		if (ret < 0) {
> +			input_free_polled_device(ipoll_dev);
> +			return ret;
> +		}
> +		bma150->input_polled = ipoll_dev;
> +	}
> +	bma150->input = idev;
> +	return ret;
> +
> +error_irq:
> +	bma150_free_input_device(bma150);
> +	return ret;
> +}
> +
> +static int __devinit bma150_probe(struct i2c_client *client,
> +				  const struct i2c_device_id *id)
> +{
> +	struct bma150_data *bma150;
> +	struct bma150_platform_data *pdata;
> +	int ret;
> +
> +	if (!i2c_check_functionality(client->adapter, I2C_FUNC_I2C)) {
> +		dev_err(&client->dev, "i2c_check_functionality error\n");
> +		return -EIO;
> +	}
> +
> +	ret = i2c_smbus_read_byte_data(client, BMA150_CHIP_ID_REG);
> +	if (ret != BMA150_CHIP_ID) {
> +		dev_err(&client->dev, "BMA150 chip id error: %d\n", ret);
> +		return -EINVAL;
> +	}
> +
> +	bma150 = kzalloc(sizeof(struct bma150_data), GFP_KERNEL);
> +	if (!bma150)
> +		return -ENOMEM;
> +
> +	i2c_set_clientdata(client, bma150);
> +	bma150->client = client;
> +
> +	pdata = client->dev.platform_data;
> +	if (pdata) {
> +		bma150->cfg.range = pdata->cfg.range;
> +		bma150->cfg.bandwidth = pdata->cfg.bandwidth;
> +		if (pdata->irq_gpio_cfg && (pdata->irq_gpio_cfg() < 0)) {
> +			dev_err(&client->dev,
> +				"IRQ GPIO conf. error %d, ret %d\n",
> +				client->irq, ret);
> +			goto kfree_exit;
> +		}
> +		if (client->irq > 0) {
> +			bma150->cfg.any_motion_int = pdata->cfg.any_motion_int;
> +			bma150->cfg.hg_int = pdata->cfg.hg_int;
> +			bma150->cfg.lg_int = pdata->cfg.lg_int;
> +			bma150->cfg.any_motion_thres =
> +				pdata->cfg.any_motion_thres;
> +			bma150->cfg.any_motion_dur = pdata->cfg.any_motion_dur;
> +			bma150->cfg.lg_thres = pdata->cfg.lg_thres;
> +			bma150->cfg.lg_hyst = pdata->cfg.lg_hyst;
> +			bma150->cfg.lg_dur = pdata->cfg.lg_dur;
> +			bma150->cfg.hg_thres = pdata->cfg.hg_thres;
> +			bma150->cfg.hg_hyst = pdata->cfg.hg_hyst;
> +			bma150->cfg.hg_dur = pdata->cfg.hg_dur;

Why copy the config data conditionally? Just do:

	bma150->cfg = pdata->cfg;

and be done with it. If we are in polled mode we do not care what
garbage might be in the config fields that are not applicable to this
mode of operation.


> +		}
> +	} else {
> +		memcpy(&bma150->cfg, &def_cfg, sizeof(struct bma150_cfg));

Or:
		bma150->cfg = def_cfg;

> +	}
> +	mutex_init(&bma150->mutex);
> +	ret = bma150_initialize(client, &bma150->cfg);
> +	if (ret < 0)
> +		goto kfree_exit;
> +
> +	ret = bma150_setup_input_device(bma150);
> +	if (ret < 0)
> +		goto kfree_exit;
> +
> +	pm_runtime_set_active(&client->dev);
> +	pm_runtime_enable(&client->dev);
> +
> +	dev_info(&client->dev, "Registered BMA150 I2C driver\n");
> +	return 0;
> +
> +kfree_exit:
> +	kfree(bma150);
> +	return ret;
> +}
> +
> +#if defined(CONFIG_PM) || defined(CONFIG_PM_RUNTIME)
> +static int bma150_suspend(struct device *dev)
> +{
> +	struct i2c_client *client = to_i2c_client(dev);
> +
> +	return bma150_set_mode(client, BMA150_MODE_SLEEP);
> +}
> +
> +static int bma150_resume(struct device *dev)
> +{
> +	struct i2c_client *client = to_i2c_client(dev);
> +	return bma150_set_mode(client, BMA150_MODE_NORMAL);
> +}
> +#endif
> +
> +static int bma150_remove(struct i2c_client *client)

__devexit

> +{
> +	struct bma150_data *bma150 = i2c_get_clientdata(client);
> +
> +	bma150_free_input_device(bma150);
> +	kfree(bma150);
> +
> +	return 0;
> +}
> +
> +static const struct dev_pm_ops bma150_pm = {
> +	SET_SYSTEM_SLEEP_PM_OPS(bma150_suspend, bma150_resume)
> +	SET_RUNTIME_PM_OPS(bma150_suspend, bma150_resume, NULL)
> +};


Just say:

static UNIVERSAL_DEV_PM_OPS(bma150_pm, bma150_suspend, bma150_resume, NULL);

> +
> +static const struct i2c_device_id bma150_id[] = {
> +	{ "bma150", 0 },
> +	{ "smb380", 0 },
> +	{ "bma023", 0 },
> +	{ }
> +};
> +
> +MODULE_DEVICE_TABLE(i2c, bma150_id);
> +
> +static struct i2c_driver bma150_driver = {
> +	.driver = {
> +		.owner	= THIS_MODULE,
> +		.name	= BMA150_DRIVER,
> +		.pm	= &bma150_pm,
> +	},
> +	.class          = I2C_CLASS_HWMON,
> +	.id_table	= bma150_id,
> +	.probe		= bma150_probe,
> +	.remove		= __devexit_p(bma150_remove),
> +};
> +
> +static int __init BMA150_init(void)
> +{
> +	return i2c_add_driver(&bma150_driver);
> +}
> +
> +static void __exit BMA150_exit(void)
> +{
> +	i2c_del_driver(&bma150_driver);
> +}
> +
> +MODULE_AUTHOR("Albert Zhang <xu.zhang@bosch-sensortec.com>");
> +MODULE_DESCRIPTION("BMA150 driver");
> +MODULE_LICENSE("GPL");
> +
> +module_init(BMA150_init);
> +module_exit(BMA150_exit);
> +
> diff --git a/include/linux/bma150.h b/include/linux/bma150.h
> new file mode 100644
> index 0000000..3a582db
> --- /dev/null
> +++ b/include/linux/bma150.h
> @@ -0,0 +1,64 @@
> +/*
> + * Copyright (c) 2011 Bosch Sensortec GmbH
> + * Copyright (c) 2011 Unixphere
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
> + */
> +
> +#ifndef _BMA150_H_
> +#define _BMA150_H_
> +
> +#define BMA150_DRIVER		"bma150"
> +
> +/* Data register addresses */
> +#define BMA150_DATA_0_REG	0x00
> +#define BMA150_DATA_1_REG	0x01
> +#define BMA150_DATA_2_REG	0x02
> +/* Control register addresses */
> +#define BMA150_CTRL_0_REG	0x0A
> +#define BMA150_CTRL_1_REG	0x0B
> +#define BMA150_CTRL_2_REG	0x14
> +#define BMA150_CTRL_3_REG	0x15
> +/* Configuration/Setting register addresses */
> +#define BMA150_CFG_0_REG	0x0C
> +#define BMA150_CFG_1_REG	0x0D
> +#define BMA150_CFG_2_REG	0x0E
> +#define BMA150_CFG_3_REG	0x0F
> +#define BMA150_CFG_4_REG	0x10
> +#define BMA150_CFG_5_REG	0x11
> +
> +struct bma150_cfg {
> +	unsigned char range;		/* BMA0150_RANGE_xxx */
> +	unsigned char bandwidth;	/* BMA0150_BW_xxx */
> +	unsigned char any_motion_int;	/* Set to enable any-motion interrupt */
> +	unsigned char hg_int;		/* Set to enable high-G interrupt */
> +	unsigned char lg_int;		/* Set to enable low-G interrupt */
> +	unsigned char any_motion_dur;	/* Any-motion duration */
> +	unsigned char any_motion_thres;	/* Any-motion threshold */
> +	unsigned char hg_hyst;		/* High-G hysterisis */
> +	unsigned char hg_dur;		/* High-G duration */
> +	unsigned char hg_thres;		/* High-G threshold */
> +	unsigned char lg_hyst;		/* Low-G hysterisis */
> +	unsigned char lg_dur;		/* Low-G duration */
> +	unsigned char lg_thres;		/* Low-G threshold */
> +};
> +
> +struct bma150_platform_data {
> +	struct bma150_cfg cfg;
> +	int (*irq_gpio_cfg)(void);
> +};
> +
> +#endif /* _BMA150_H_ */
> +
> -- 
> 1.7.3.4
> 

Thanks.

-- 
Dmitry
