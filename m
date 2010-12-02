Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755619Ab0LBAeZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 19:34:25 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:59131 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751764Ab0LBAeY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 19:34:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=BgobhXQJr9grvC6sJn7UC9I6TKKl4k+Z2Rjx/FeGm3vbTgOi7Ge0F2hRs8nQyCSZJB
         EZSgsMRboFhrKFsBQhTHnUSiUDJMHNuNloD7Dev9MX/Y6u7Ev/2L7HThztrVklfKQ0SS
         VBXGFFX84IJmN3YgmT1FSBRcrARYYmvfPBDxA=
Date: Wed, 1 Dec 2010 16:34:11 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Kevin McNeely <kev@cypress.com>
Cc: David Brown <davidb@codeaurora.org>, Trilok Soni <tsoni@codeaurora.org>,
        Henrik Rydberg <rydberg@euromail.se>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Eric Miao <eric.y.miao@gmail.com>,
        Simtec Linux Team <linux@simtec.co.uk>,
        Luotao Fu <l.fu@pengutronix.de>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] touchscreen: Cypress TTSP G3 MTDEV Core Driver
Message-ID: <20101202003411.GB31397@core.coreip.homeip.net>
References: <kev@cypress.com>
 <1289327120-2612-1-git-send-email-kev@cypress.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1289327120-2612-1-git-send-email-kev@cypress.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kevin,

On Tue, Nov 09, 2010 at 10:25:17AM -0800, Kevin McNeely wrote:
>  
> +config TOUCHSCREEN_CYTTSP_CORE
> +	bool "Cypress TTSP touchscreen core"

Tristate please - i see no reason why it can't be compiled as a module.
Same goes for I2C and SPI parts.

> +	help
> +	  Say Y here if you have a Cypress TTSP touchscreen
> +	  connected to your system.
> +
> +	  If unsure, say N.
> +

To compile this driver as a module...

> +
> +/* Touch structure */
> +struct cyttsp_touch {
> +	u16 x __attribute__ ((packed));
> +	u16 y __attribute__ ((packed));

Why packed? Natural alignment will give exactly same layout.

> +
> +struct cyttsp {
> +	struct device *dev;
> +	int irq;
> +	struct input_dev *input;
> +	struct mutex mutex;
> +	char phys[32];
> +	struct bus_type *bus_type;

const.

> +	struct cyttsp_platform_data *platform_data;

const.

> +	struct cyttsp_xydata xy_data;
> +	struct cyttsp_bootloader_data bl_data;
> +	struct cyttsp_sysinfo_data sysinfo_data;
> +	struct cyttsp_trk prv_trk[CY_NUM_TRK_ID];
> +	struct cyttsp_tch tch_map[CY_NUM_TCH_ID];
> +	struct cyttsp_bus_ops *bus_ops;

const.

> +	struct timer_list to_timer;
> +	bool bl_ready;
> +};
> +
> +struct cyttsp_track_data {
> +	struct cyttsp_trk cur_trk[CY_NUM_TRK_ID];

Do you expect to extend this? Otherwise just pass around struct
cyttsp_trk *.

> +
> +static irqreturn_t cyttsp_bl_ready_irq(int irq, void *handle)
> +{
> +	struct cyttsp *ts = handle;
> +
> +	ts->bl_ready = true;
> +	return IRQ_HANDLED;
> +}
> +
> +static int cyttsp_load_bl_regs(struct cyttsp *ts)
> +{
> +	int retval;
> +
> +	memset(&(ts->bl_data), 0, sizeof(struct cyttsp_bootloader_data));
> +
> +	retval =  ttsp_read_block_data(ts, CY_REG_BASE,
> +		sizeof(ts->bl_data), &(ts->bl_data));
> +
> +	return retval;
> +}
> +
> +static int cyttsp_bl_app_valid(struct cyttsp *ts)
> +{
> +	int retval;
> +
> +	retval = cyttsp_load_bl_regs(ts);
> +
> +	if (retval < 0)
> +		return -ENODEV;
> +
> +	if (GET_BOOTLOADERMODE(ts->bl_data.bl_status)) {
> +		if (IS_VALID_APP(ts->bl_data.bl_status)) {
> +			dev_dbg(ts->dev, "%s: App found; normal boot\n",
> +				__func__);
> +			return 0;
> +		} else {
> +			dev_dbg(ts->dev, "%s: NO APP; load firmware!!\n",
> +				__func__);
> +			return -ENODEV;
> +		}
> +	} else if (GET_HSTMODE(ts->bl_data.bl_file) == CY_OPERATE_MODE) {
> +		if (!(IS_OPERATIONAL_ERR(ts->bl_data.bl_status))) {
> +			dev_dbg(ts->dev, "%s: Operational\n",
> +				__func__);
> +			return 1;
> +		} else {
> +			dev_dbg(ts->dev, "%s: Operational failure\n",
> +				__func__);
> +			return -ENODEV;
> +		}
> +	} else {
> +		dev_dbg(ts->dev, "%s: Non-Operational failure\n",
> +			__func__);
> +			return -ENODEV;
> +	}
> +
> +}
> +
> +static bool cyttsp_wait_bl_ready(struct cyttsp *ts, int loop_delay, int max_try)
> +{
> +	int tries = 0;
> +
> +	ts->bl_ready = false;	/* wait for interrupt to set ready flag */
> +
> +	while (!ts->bl_ready && (tries++ < max_try))
> +		msleep(loop_delay);

Ewwww! wait_event_timeout() or wait_for_completion_timeout().

> +
> +static int cyttsp_set_sysinfo_regs(struct cyttsp *ts)
> +{
> +	int retval = 0;
> +
> +	if ((ts->platform_data->act_intrvl != CY_ACT_INTRVL_DFLT) ||
> +		(ts->platform_data->tch_tmout != CY_TCH_TMOUT_DFLT) ||
> +		(ts->platform_data->lp_intrvl != CY_LP_INTRVL_DFLT)) {

Too many parens.

> +
> +static int cyttsp_soft_reset(struct cyttsp *ts)
> +{
> +	int retval;
> +	u8 cmd = CY_SOFT_RESET_MODE;
> +
> +	/* enable bootloader interrupts */
> +	retval = request_irq(ts->irq, cyttsp_bl_ready_irq,
> +		IRQF_TRIGGER_FALLING, ts->platform_data->name, ts);
> +	if (retval)
> +		return retval;
> +
> +	retval = ttsp_write_block_data(ts, CY_REG_BASE, sizeof(cmd), &cmd);
> +	if (!retval) {
> +		if (!cyttsp_wait_bl_ready(ts, 20, 100))
> +			retval = -ENODEV;
> +		else
> +			retval = 0;
> +	}

Oh, yes, this should be a completion.

> +
> +	free_irq(ts->irq, ts);
> +	return retval;
> +}
> +
> +

...

> +static void cyttsp_init_prv_trks(struct cyttsp *ts)
> +{
> +	/* init the touch structures */
> +	memset(ts->prv_trk, CY_NTCH, sizeof(ts->prv_trk));
> +}
> +
> +static void cyttsp_init_cur_trks(struct cyttsp_track_data *t)
> +{
> +	memset(t->cur_trk, CY_NTCH, sizeof(t->cur_trk));
> +}

Do we really need these helpers?

> +
> +static int cyttsp_xy_worker(struct cyttsp *ts)
> +{
> +	u8 cur_tch = 0;
> +	u8 tch;
> +	struct cyttsp_track_data trk;
> +
> +	/* get event data from CYTTSP device */
> +	if (ttsp_read_block_data(ts,
> +		CY_REG_BASE, sizeof(struct cyttsp_xydata), &ts->xy_data))
> +		return 0;
> +
> +	/* touch extension handling */
> +	if (ttsp_tch_ext(ts, &ts->xy_data))
> +		return 0;
> +
> +	/* provide flow control handshake */
> +	if (ts->platform_data->use_hndshk)
> +		if (cyttsp_hndshk(ts, ts->xy_data.hst_mode))
> +			return 0;
> +
> +	cur_tch = GET_NUM_TOUCHES(ts->xy_data.tt_stat);
> +
> +	if (ts->bus_ops->power_state == CY_IDLE_STATE)
> +		return 0;
> +	else if (GET_BOOTLOADERMODE(ts->xy_data.tt_mode)) {
> +		return -1;
> +	} else if (IS_LARGE_AREA(ts->xy_data.tt_stat) == 1) {
> +		/* terminate all active tracks */
> +		cur_tch = CY_NTCH;
> +		dev_dbg(ts->dev, "%s: Large area detected\n", __func__);
> +	} else if (cur_tch > CY_NUM_TCH_ID) {
> +		/* terminate all active tracks */
> +		cur_tch = CY_NTCH;
> +		dev_dbg(ts->dev, "%s: Num touch error detected\n", __func__);
> +	} else if (IS_BAD_PKT(ts->xy_data.tt_mode)) {
> +		/* terminate all active tracks */
> +		cur_tch = CY_NTCH;
> +		dev_dbg(ts->dev, "%s: Invalid buffer detected\n", __func__);
> +	}
> +
> +	/* process the touches */
> +	cyttsp_init_cur_trks(&trk);
> +
> +	for (tch = 0; tch < cur_tch; tch++) {
> +		cyttsp_get_xydata(ts, &trk,
> +			tch & 0x01 ?
> +			(*(ts->tch_map[tch].id) & 0x0F) :
> +			(*(ts->tch_map[tch].id) & 0xF0) >> 4,
> +			CY_SMALL_TOOL_WIDTH,
> +			be16_to_cpu((ts->tch_map[tch].tch)->x),
> +			be16_to_cpu((ts->tch_map[tch].tch)->y),
> +			(ts->tch_map[tch].tch)->z);


You know, open-coding instead of passing so many complex arguments would
be cleaner.

> +	}
> +
> +	handle_multi_touch(&trk, ts);
> +
> +	return 0;
> +}
> +
> +static irqreturn_t cyttsp_irq(int irq, void *handle)
> +{
> +	struct cyttsp *ts = handle;
> +	int retval;
> +
> +	retval = cyttsp_xy_worker(ts);
> +
> +	if (retval < 0) {
> +		/* TTSP device has reset back to bootloader mode
> +		 * Reset driver touch history and restore operational mode
> +		 */
> +		cyttsp_init_prv_trks(ts);
> +		retval = cyttsp_exit_bl_mode(ts);
> +		if (retval)
> +			ts->bus_ops->power_state = CY_IDLE_STATE;
> +		dev_info(ts->dev, "%s: %s\n",
> +			__func__,
> +			(ts->bus_ops->power_state == CY_ACTIVE_STATE) ?
> +			"ACTIVE" : "IDLE");
> +	}
> +	return IRQ_HANDLED;
> +}
> +
> +static int cyttsp_power_on(struct cyttsp *ts)
> +{
> +	int retval = 0;
> +
> +	ts->bus_ops->power_state = CY_IDLE_STATE;
> +
> +	retval = cyttsp_bl_app_valid(ts);
> +	if (retval < 0)
> +		goto bypass;
> +	else if (retval > 0) {
> +		retval = cyttsp_soft_reset(ts);
> +		if (retval < 0)
> +			goto bypass;
> +	}
> +
> +	retval = cyttsp_exit_bl_mode(ts);
> +	if (retval < 0)
> +		goto bypass;
> +
> +	retval = cyttsp_set_sysinfo_mode(ts);
> +	if (retval < 0)
> +		goto bypass;
> +
> +	retval = cyttsp_set_sysinfo_regs(ts);
> +	if (retval < 0)
> +		goto bypass;
> +
> +	retval = cyttsp_set_operational_mode(ts);
> +	if (retval < 0)
> +		goto bypass;
> +
> +	/* enable touch interrupts */
> +	retval = request_threaded_irq(ts->irq, NULL, cyttsp_irq,
> +		IRQF_TRIGGER_FALLING | IRQF_ONESHOT,
> +		ts->platform_data->name, ts);
> +	if (retval < 0)
> +		goto bypass;
> +
> +	/* init gesture setup; required for active distance */
> +	retval = cyttsp_gesture_setup(ts);
> +
> +bypass:
> +	if (!retval)
> +		ts->bus_ops->power_state = CY_ACTIVE_STATE;
> +
> +	dev_info(ts->dev, "%s: %s\n",
> +		__func__,
> +		(ts->bus_ops->power_state == CY_ACTIVE_STATE) ?
> +		"ACTIVE" : "IDLE");
> +	return retval;
> +}
> +
> +#ifdef CONFIG_PM
> +int cyttsp_resume(void *handle)
> +{
> +	struct cyttsp *ts = handle;
> +	int retval = 0;
> +	struct cyttsp_xydata xydata;
> +
> +	if (ts->platform_data->use_sleep && (ts->bus_ops->power_state !=
> +		CY_ACTIVE_STATE)) {
> +		if (ts->platform_data->wakeup) {
> +			retval = ts->platform_data->wakeup();
> +			if (retval < 0)
> +				dev_dbg(ts->dev, "%s: Error, wakeup failed!\n",
> +					__func__);
> +		} else {
> +			dev_dbg(ts->dev, "%s: Error, wakeup not implemented "
> +				"(check board file).\n", __func__);
> +			retval = -ENOSYS;
> +		}
> +		if (!(retval < 0)) {
> +			retval = ttsp_read_block_data(ts, CY_REG_BASE,
> +				sizeof(xydata), &xydata);
> +			if (!(retval < 0) && !GET_HSTMODE(xydata.hst_mode))
> +				ts->bus_ops->power_state = CY_ACTIVE_STATE;
> +		}
> +	}
> +	dev_dbg(ts->dev, "%s: Wake Up %s\n", __func__,
> +		(retval < 0) ? "FAIL" : "PASS");
> +	return retval;
> +}
> +EXPORT_SYMBOL_GPL(cyttsp_resume);
> +
> +int cyttsp_suspend(void *handle)
> +{
> +	struct cyttsp *ts = handle;
> +	u8 sleep_mode = 0;
> +	int retval = 0;
> +
> +	if (ts->platform_data->use_sleep &&
> +		(ts->bus_ops->power_state == CY_ACTIVE_STATE)) {
> +		sleep_mode = CY_DEEP_SLEEP_MODE;
> +		retval = ttsp_write_block_data(ts,
> +			CY_REG_BASE, sizeof(sleep_mode), &sleep_mode);
> +		if (!(retval < 0))
> +			ts->bus_ops->power_state = CY_SLEEP_STATE;
> +	}
> +	dev_dbg(ts->dev, "%s: Sleep Power state is %s\n", __func__,
> +		(ts->bus_ops->power_state == CY_ACTIVE_STATE) ?
> +		"ACTIVE" :
> +		((ts->bus_ops->power_state == CY_SLEEP_STATE) ?
> +		"SLEEP" : "LOW POWER"));
> +	return retval;
> +}
> +EXPORT_SYMBOL_GPL(cyttsp_suspend);
> +#endif
> +
> +int cyttsp_core_init(struct cyttsp_bus_ops *bus_ops,
> +	struct device *dev, void *handle)
> +{
> +	struct input_dev *input_device;
> +	struct cyttsp *ts;
> +	int retval = 0;
> +
> +	if ((dev == NULL) || (bus_ops == NULL))
> +		goto error_alloc_data;
> +
> +	ts = kzalloc(sizeof(*ts), GFP_KERNEL);
> +	if (ts == NULL) {
> +		dev_dbg(ts->dev, "%s: Error, kzalloc\n", __func__);
> +		retval = -ENOMEM;
> +		goto error_alloc_data;
> +	}
> +	mutex_init(&ts->mutex);
> +	ts->dev = dev;
> +	ts->platform_data = dev->platform_data;
> +	ts->bus_ops = bus_ops;
> +	ts->platform_data->dev = ts->dev;
> +
> +	if (ts->platform_data->init) {
> +		retval = ts->platform_data->init(ts->platform_data, 1);
> +		if (retval) {
> +			dev_dbg(ts->dev, "%s: Error, platform init failed!\n",
> +				__func__);
> +			retval = -EIO;
> +			goto error_init;
> +		}
> +	}
> +
> +	ts->irq = gpio_to_irq(ts->platform_data->irq_gpio);
> +	if (ts->irq <= 0) {
> +		dev_dbg(ts->dev, "%s: Error, failed to allocate irq\n",
> +			__func__);
> +			retval = -EIO;
> +			goto error_init;
> +	}
> +
> +	/* Create the input device and register it. */
> +	input_device = input_allocate_device();
> +	if (!input_device) {
> +		retval = -ENOMEM;
> +		dev_dbg(ts->dev, "%s: Error, failed to allocate input device\n",
> +			__func__);
> +			retval = -ENODEV;
> +		goto error_input_allocate_device;
> +	}
> +
> +	ts->input = input_device;
> +	input_device->name = ts->platform_data->name;
> +	input_device->phys = ts->phys;
> +	input_device->dev.parent = ts->dev;
> +	ts->bus_type = bus_ops->dev->bus;
> +
> +	cyttsp_init_tch_map(ts);
> +	cyttsp_init_prv_trks(ts);
> +
> +	__set_bit(EV_SYN, input_device->evbit);
> +	__set_bit(EV_KEY, input_device->evbit);
> +	__set_bit(EV_ABS, input_device->evbit);
> +
> +	input_set_abs_params(input_device, ABS_MT_POSITION_X,
> +		0, ts->platform_data->maxx, 0, 0);
> +	input_set_abs_params(input_device, ABS_MT_POSITION_Y,
> +		0, ts->platform_data->maxy, 0, 0);
> +	input_set_abs_params(input_device, ABS_MT_TOUCH_MAJOR,
> +		0, CY_MAXZ, 0, 0);
> +	input_set_abs_params(input_device, ABS_MT_WIDTH_MAJOR,
> +		0, CY_LARGE_TOOL_WIDTH, 0, 0);
> +	input_set_abs_params(input_device, ABS_MT_TRACKING_ID,
> +		0, CY_NUM_TRK_ID, 0, 0);
> +
> +	retval = input_register_device(input_device);
> +	if (retval) {
> +		dev_dbg(ts->dev, "%s: Error, failed to register input device\n",
> +			__func__);
> +			retval = -ENODEV;
> +		goto error_input_register_device;
> +	}
> +
> +	retval = cyttsp_power_on(ts);

This should probably go into input->open() method. No need to power up
until there are users.

> +
> +	if (retval < 0) {
> +		dev_dbg(ts->dev, "%s: Error, power on failed!\n", __func__);
> +		retval = -ENODEV;
> +		goto error_power_on;
> +	}
> +
> +	handle = ts;
> +	goto no_error;
> +
> +error_power_on:
> +	free_irq(ts->irq, ts);
> +error_input_register_device:
> +	input_unregister_device(input_device);
> +error_input_allocate_device:
> +	if (ts->platform_data->init)
> +		ts->platform_data->init(ts->platform_data, 0);
> +error_init:
> +	mutex_destroy(&ts->mutex);
> +	kfree(ts);
> +error_alloc_data:
> +	handle = NULL;

Why?

Btw, have it return struct cyttsp * and check for errors with IS_ERR().

> +no_error:
> +	return retval;
> +}
> +EXPORT_SYMBOL_GPL(cyttsp_core_init);
> +
> +/* registered in driver struct */
> +void cyttsp_core_release(void *handle)
> +{
> +	struct cyttsp *ts = handle;
> +
> +	mutex_destroy(&ts->mutex);
> +	free_irq(ts->irq, ts);
> +	input_unregister_device(ts->input);
> +	if (ts->platform_data->init)
> +		ts->platform_data->init(ts->platform_data, 0);

Maybe call it platform_data->exit()?

> +	kfree(ts);
> +}
> +EXPORT_SYMBOL_GPL(cyttsp_core_release);
> +
> +MODULE_LICENSE("GPL");
> +MODULE_DESCRIPTION("Cypress TrueTouch(R) Standard touchscreen driver core");
> +MODULE_AUTHOR("Cypress");
> +
> diff --git a/drivers/input/touchscreen/cyttsp_core.h b/drivers/input/touchscreen/cyttsp_core.h
> new file mode 100644
> index 0000000..43fe438
> --- /dev/null
> +++ b/drivers/input/touchscreen/cyttsp_core.h
> @@ -0,0 +1,55 @@
> +/* Header file for:
> + * Cypress TrueTouch(TM) Standard Product (TTSP) touchscreen drivers.
> + * For use with Cypress Txx3xx parts.
> + * Supported parts include:
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
> + * Contact Cypress Semiconductor at www.cypress.com <kev@cypress.com>
> + *
> + */
> +
> +
> +#ifndef __CYTTSP_CORE_H__
> +#define __CYTTSP_CORE_H__
> +
> +#include <linux/kernel.h>
> +#include <linux/input/cyttsp.h>
> +
> +#define CY_NUM_RETRY                4 /* max number of retries for read ops */
> +
> +
> +struct cyttsp_bus_ops {
> +	s32 (*write)(void *handle, u8 addr, u8 length, const void *values);
> +	s32 (*read)(void *handle, u8 addr, u8 length, void *values);
> +	s32 (*ext)(void *handle, void *values);
> +	struct device *dev;
> +	enum cyttsp_powerstate power_state;
> +};
> +
> +int cyttsp_core_init(struct cyttsp_bus_ops *bus_ops,
> +	struct device *dev, void *handle);
> +
> +void cyttsp_core_release(void *handle);
> +#ifdef CONFIG_PM
> +int cyttsp_resume(void *handle);
> +int cyttsp_suspend(void *handle);
> +#endif
> +
> +#endif /* __CYTTSP_CORE_H__ */
> diff --git a/include/linux/input/cyttsp.h b/include/linux/input/cyttsp.h
> new file mode 100644
> index 0000000..5280252
> --- /dev/null
> +++ b/include/linux/input/cyttsp.h
> @@ -0,0 +1,78 @@
> +/* Header file for:
> + * Cypress TrueTouch(TM) Standard Product (TTSP) touchscreen drivers.
> + * For use with Cypress Txx3xx parts.
> + * Supported parts include:
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
> +#ifndef _CYTTSP_H_
> +#define _CYTTSP_H_
> +
> +#define CY_SPI_NAME "cyttsp-spi"
> +#define CY_I2C_NAME "cyttsp-i2c"
> +/* Active Power state scanning/processing refresh interval */
> +#define CY_ACT_INTRVL_DFLT 0x00
> +/* touch timeout for the Active power */
> +#define CY_TCH_TMOUT_DFLT 0xFF
> +/* Low Power state scanning/processing refresh interval */
> +#define CY_LP_INTRVL_DFLT 0x0A
> +/*
> + * Active distance in pixels for a gesture to be reported
> + * if set to 0, then all gesture movements are reported
> + * Valid range is 0 - 15
> + */
> +#define CY_ACT_DIST_DFLT 8
> +#define CY_ACT_DIST CY_ACT_DIST_DFLT
> +
> +enum cyttsp_gest {
> +	CY_GEST_GRP_NONE = 0,
> +	CY_GEST_GRP1 =	0x10,
> +	CY_GEST_GRP2 = 0x20,
> +	CY_GEST_GRP3 = 0x40,
> +	CY_GEST_GRP4 = 0x80,
> +};
> +
> +enum cyttsp_powerstate {
> +	CY_IDLE_STATE,
> +	CY_ACTIVE_STATE,
> +	CY_LOW_PWR_STATE,
> +	CY_SLEEP_STATE,
> +};
> +
> +struct cyttsp_platform_data {
> +	struct device *dev;

Hm, platform data might be shared, not a good idea to have device
pointer here.

> +	u32 maxx;
> +	u32 maxy;
> +	unsigned use_hndshk:1;

bool.

> +	unsigned use_sleep:1;

bool.

> +	u8 gest_set;	/* Active distance */
> +	u8 act_intrvl;  /* Active refresh interval; ms */
> +	u8 tch_tmout;   /* Active touch timeout; ms */
> +	u8 lp_intrvl;   /* Low power refresh interval; ms */
> +	int (*wakeup)(void);
> +	int (*init)(struct cyttsp_platform_data *, int on_off);
> +	char *name;
> +	s16 irq_gpio;
> +	u8 *bl_keys;
> +};
> +

Thanks.

-- 
Dmitry
