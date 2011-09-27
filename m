Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753873Ab1I0Lrg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 07:47:36 -0400
Received: from smtprelay-h22.telenor.se ([195.54.99.197]:38824 "EHLO
	smtprelay-h22.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753788Ab1I0Lra (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 07:47:30 -0400
X-SENDER-IP: [85.230.28.149]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AmRkAIK3gU5V5hyVPGdsb2JhbABCiSucJ4IkCwEBAQE3M4FTAQEEAScTDw0jBQsIA0YUDRgKGhOHeAK5CQ6GHWAEmQKEaIce
X-IronPort-AV: E=Sophos;i="4.68,449,1312149600"; 
   d="scan'208";a="485572322"
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Tue, 27 Sep 2011 13:52:07 +0200
To: Javier Martinez Canillas <martinez.javier@gmail.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Greg Kroah-Hartman <gregkh@suse.de>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V3 1/3] Input: cyttsp - Cypress TTSP capacitive
 multi-touch screen support
Message-ID: <20110927115207.GA3701@polaris.bitmath.org>
References: <1316311297-12765-1-git-send-email-martinez.javier@gmail.com>
 <1316311297-12765-2-git-send-email-martinez.javier@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1316311297-12765-2-git-send-email-martinez.javier@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Javier,

> Cypress TrueTouch(tm) Standard Product controllers are found in
> a wide range of embedded devices. This driver add support for a
> variety of TTSP controllers.

please find some comments below.

> diff --git a/drivers/input/touchscreen/cyttsp/cyttsp_core.c b/drivers/input/touchscreen/cyttsp/cyttsp_core.c
> new file mode 100644
> index 0000000..8e7bd66
> --- /dev/null
> +++ b/drivers/input/touchscreen/cyttsp/cyttsp_core.c
> @@ -0,0 +1,853 @@
> +/*
> + * Core Source for:
> + * Cypress TrueTouch(TM) Standard Product (TTSP) touchscreen drivers.
> + * For use with Cypress Txx3xx parts.
> + * Supported parts include:
> + * CY8CTST341
> + * CY8CTMA340
> + *
> + * Copyright (C) 2009, 2010, 2011 Cypress Semiconductor, Inc.
> + * Copyright (C) 2011 Javier Martinez Canillas <martinez.javier@gmail.com>
> + *
> + * Added multi-touch protocol type B support by Javier Martinez Canillas
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
> +#include "cyttsp_core.h"
> +
> +#include <linux/delay.h>
> +#include <linux/input.h>
> +#include <linux/input/mt.h>
> +#include <linux/gpio.h>
> +#include <linux/interrupt.h>
> +#include <linux/slab.h>
> +
> +/* Bootloader number of command keys */
> +#define CY_NUM_BL_KEYS    8
> +
> +/* helpers */
> +#define GET_NUM_TOUCHES(x)          ((x) & 0x0F)
> +#define IS_LARGE_AREA(x)            (((x) & 0x10) >> 4)
> +#define IS_BAD_PKT(x)               ((x) & 0x20)
> +#define IS_VALID_APP(x)             ((x) & 0x01)
> +#define IS_OPERATIONAL_ERR(x)       ((x) & 0x3F)
> +#define GET_HSTMODE(reg)            ((reg & 0x70) >> 4)
> +#define GET_BOOTLOADERMODE(reg)     ((reg & 0x10) >> 4)
> +
> +#define CY_REG_BASE                 0x00
> +#define CY_REG_ACT_DIST             0x1E
> +#define CY_REG_ACT_INTRVL           0x1D
> +#define CY_REG_TCH_TMOUT            (CY_REG_ACT_INTRVL+1)
> +#define CY_REG_LP_INTRVL            (CY_REG_TCH_TMOUT+1)
> +#define CY_MAXZ                     255
> +#define CY_DELAY_DFLT               20 /* ms */
> +#define CY_DELAY_MAX                (500/CY_DELAY_DFLT) /* half second */
> +#define CY_ACT_DIST_DFLT            0xF8
> +#define CY_HNDSHK_BIT               0x80
> +/* device mode bits */
> +#define CY_OPERATE_MODE             0x00
> +#define CY_SYSINFO_MODE             0x10
> +/* power mode select bits */
> +#define CY_SOFT_RESET_MODE          0x01 /* return to Bootloader mode */
> +#define CY_DEEP_SLEEP_MODE          0x02
> +#define CY_LOW_POWER_MODE           0x04
> +
> +/* Slots management */
> +#define CY_MAX_FINGER               4
> +#define CY_UNUSED                   0
> +#define CY_USED                     1

These two look like bool, please use as bool instead.

> +#define CY_MAX_ID                   15

Why not 16 here?

> +struct cyttsp_tch {
> +	__be16 x, y;
> +	u8 z;
> +} __packed;
> +
> +/* TrueTouch Standard Product Gen3 interface definition */
> +struct cyttsp_xydata {
> +	u8 hst_mode;
> +	u8 tt_mode;
> +	u8 tt_stat;
> +	struct cyttsp_tch tch1;
> +	u8 touch12_id;
> +	struct cyttsp_tch tch2;
> +	u8 gest_cnt;
> +	u8 gest_id;
> +	struct cyttsp_tch tch3;
> +	u8 touch34_id;
> +	struct cyttsp_tch tch4;
> +	u8 tt_undef[3];
> +	u8 act_dist;
> +	u8 tt_reserved;
> +} __packed;

Too bad the touches are not an array here...

> +
> +/* TTSP System Information interface definition */
> +struct cyttsp_sysinfo_data {
> +	u8 hst_mode;
> +	u8 mfg_cmd;
> +	u8 mfg_stat;
> +	u8 cid[3];
> +	u8 tt_undef1;
> +	u8 uid[8];
> +	u8 bl_verh;
> +	u8 bl_verl;
> +	u8 tts_verh;
> +	u8 tts_verl;
> +	u8 app_idh;
> +	u8 app_idl;
> +	u8 app_verh;
> +	u8 app_verl;
> +	u8 tt_undef[5];
> +	u8 scn_typ;
> +	u8 act_intrvl;
> +	u8 tch_tmout;
> +	u8 lp_intrvl;
> +};
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
> +struct cyttsp {
> +	struct device *dev;
> +	int irq;
> +	struct input_dev *input;
> +	char phys[32];
> +	const struct cyttsp_platform_data *platform_data;
> +	struct cyttsp_bus_ops *bus_ops;
> +	struct cyttsp_bootloader_data bl_data;
> +	struct cyttsp_sysinfo_data sysinfo_data;
> +	struct completion bl_ready;
> +	enum cyttsp_powerstate power_state;
> +	int slot_curr[CY_MAX_ID];
> +	int slot_prev[CY_MAX_ID];

These two are not needed; the input core will take care of duplicates,
so slot_prev can be removed. Also, the set of current slots can be
tracked using a temporary bitmask, so slot_curr can be removed as well.

<snip>

> +static void cyttsp_report_slot(struct input_dev *dev, int slot,
> +			       int x, int y, int z)
> +{
> +	input_mt_slot(dev, slot);
> +	input_mt_report_slot_state(dev, MT_TOOL_FINGER, true);
> +	input_report_abs(dev, ABS_MT_POSITION_X, x);
> +	input_report_abs(dev, ABS_MT_POSITION_Y, y);
> +	input_report_abs(dev, ABS_MT_TOUCH_MAJOR, z);
> +}
> +
> +static void cyttsp_report_slot_empty(struct input_dev *dev, int slot)
> +{
> +	input_mt_slot(dev, slot);
> +	input_mt_report_slot_state(dev, MT_TOOL_FINGER, false);
> +}
> +
> +static void cyttsp_extract_track_ids(struct cyttsp_xydata *xy_data, int *ids)
> +{
> +	ids[0] = xy_data->touch12_id >> 4;
> +	ids[1] = xy_data->touch12_id & 0xF;
> +	ids[2] = xy_data->touch34_id >> 4;
> +	ids[3] = xy_data->touch34_id & 0xF;
> +}
> +
> +static void cyttsp_get_tch(struct cyttsp_xydata *xy_data, int idx,
> +			   struct cyttsp_tch **tch)
> +{
> +	switch (idx) {
> +	case 0:
> +		*tch = &xy_data->tch1;
> +		break;
> +	case 1:
> +		*tch = &xy_data->tch2;
> +		break;
> +	case 2:
> +		*tch = &xy_data->tch3;
> +		break;
> +	case 3:
> +		*tch = &xy_data->tch4;
> +		break;
> +	}
> +}

How about returning a const struct cyttsp_tch* here instead.

> +static int cyttsp_handle_tchdata(struct cyttsp *ts)
> +{
> +	struct cyttsp_xydata xy_data;
> +	u8 num_cur_tch;
> +	int i;
> +	int ids[4];
> +	struct cyttsp_tch *tch = NULL;
> +	int x, y, z;
> +
> +	/* Get touch data from CYTTSP device */
> +	if (ttsp_read_block_data(ts,
> +		CY_REG_BASE, sizeof(struct cyttsp_xydata), &xy_data))
> +		return 0;
> +
> +	/* touch extension handling */
> +	if (ttsp_tch_ext(ts, &xy_data))
> +		return 0;
> +
> +	/* provide flow control handshake */
> +	if (ts->platform_data->use_hndshk)
> +		if (cyttsp_hndshk(ts, xy_data.hst_mode))
> +			return 0;
> +
> +	/* determine number of currently active touches */
> +	num_cur_tch = GET_NUM_TOUCHES(xy_data.tt_stat);
> +
> +	/* check for any error conditions */
> +	if (ts->power_state == CY_IDLE_STATE)
> +		return 0;
> +	else if (GET_BOOTLOADERMODE(xy_data.tt_mode)) {
> +		return -1;
> +	} else if (IS_LARGE_AREA(xy_data.tt_stat) == 1) {
> +		/* terminate all active tracks */
> +		num_cur_tch = 0;
> +		dev_dbg(ts->dev, "%s: Large area detected\n", __func__);
> +	} else if (num_cur_tch > CY_MAX_FINGER) {
> +		/* terminate all active tracks */
> +		num_cur_tch = 0;
> +		dev_dbg(ts->dev, "%s: Num touch error detected\n", __func__);
> +	} else if (IS_BAD_PKT(xy_data.tt_mode)) {
> +		/* terminate all active tracks */
> +		num_cur_tch = 0;
> +		dev_dbg(ts->dev, "%s: Invalid buffer detected\n", __func__);
> +	}
> +
> +	cyttsp_extract_track_ids(&xy_data, ids);
> +
> +	for (i = 0; i < num_cur_tch; i++) {
> +		ts->slot_curr[ids[i] - 1] = CY_USED;

Why the -1 here? Since the values are provably between 0 and 15, there
is no need to change them further.

Also, the above line could be replaced by "used |= 1 << ids[i]", for instance.

> +
> +		cyttsp_get_tch(&xy_data, i, &tch);
> +
> +		x = be16_to_cpu(tch->x);
> +		y = be16_to_cpu(tch->y);
> +		z = tch->z;
> +
> +		cyttsp_report_slot(ts->input, ids[i] - 1, x, y, z);

Ditto, -1.

> +	}
> +
> +	for (i = 0; i < CY_MAX_ID; i++) {
> +		if (ts->slot_prev[i] == CY_USED &&
> +		    ts->slot_curr[i] == CY_UNUSED)
> +			cyttsp_report_slot_empty(ts->input, i);
> +		ts->slot_prev[i] = ts->slot_curr[i];
> +		ts->slot_curr[i] = CY_UNUSED;
> +	}

Input core handles duplicate calls, so the above could be simplified.

> +
> +	input_sync(ts->input);
> +
> +	return 0;
> +}

<snip>

> +void *cyttsp_core_init(struct cyttsp_bus_ops *bus_ops, struct device *dev, int irq)
> +{
> +	struct input_dev *input_device;
> +	int i;
> +	int ret;
> +
> +	struct cyttsp *ts = kzalloc(sizeof(*ts), GFP_KERNEL);
> +
> +	if (!ts) {
> +		pr_err("%s: Error, kzalloc\n", __func__);
> +		goto error_alloc_data;
> +	}
> +
> +	if (dev == NULL || bus_ops == NULL) {
> +		kfree(ts);
> +		goto error_alloc_data;
> +	}
> +
> +	ts->dev = dev;
> +	ts->platform_data = dev->platform_data;
> +	ts->bus_ops = bus_ops;
> +	init_completion(&ts->bl_ready);
> +
> +	if (ts->platform_data->init) {
> +		if (ts->platform_data->init()) {
> +			dev_dbg(ts->dev, "%s: Error, platform init failed!\n",
> +				__func__);
> +			goto error_init;
> +		}
> +	}
> +
> +	ts->irq = irq;
> +	if (ts->irq <= 0) {
> +		dev_dbg(ts->dev, "%s: Error, failed to allocate irq\n",
> +			__func__);
> +			goto error_init;
> +	}
> +
> +	/* Create the input device and register it. */
> +	input_device = input_allocate_device();
> +	if (!input_device) {
> +		dev_dbg(ts->dev, "%s: Error, failed to allocate input device\n",
> +			__func__);
> +		goto error_input_allocate_device;
> +	}
> +
> +	ts->input = input_device;
> +	input_device->name = ts->platform_data->name;
> +	snprintf(ts->phys, sizeof(ts->phys), "%s", dev_name(dev));
> +	input_device->phys = ts->phys;
> +	input_device->dev.parent = ts->dev;
> +	input_device->open = cyttsp_open;
> +	input_device->close = cyttsp_close;
> +	input_set_drvdata(input_device, ts);
> +
> +	__set_bit(EV_SYN, input_device->evbit);
> +	__set_bit(EV_KEY, input_device->evbit);
> +	__set_bit(EV_ABS, input_device->evbit);
> +
> +	input_set_abs_params(input_device, ABS_MT_POSITION_X,
> +			     0, ts->platform_data->maxx, 0, 0);
> +	input_set_abs_params(input_device, ABS_MT_POSITION_Y,
> +			     0, ts->platform_data->maxy, 0, 0);
> +	input_set_abs_params(input_device, ABS_MT_TOUCH_MAJOR,
> +			     0, CY_MAXZ, 0, 0);
> +
> +	input_mt_init_slots(input_device, CY_MAX_ID);
> +
> +	for (i = 0; i < CY_MAX_ID; i++) {
> +		ts->slot_prev[i] = CY_UNUSED;
> +		ts->slot_curr[i] = CY_UNUSED;
> +	}

Could be removed.

> +	ret = input_register_device(input_device);
> +	if (ret) {
> +		dev_err(ts->dev, "%s: Error, failed to register input device: %d\n",
> +			__func__, ret);
> +		goto error_input_register_device;
> +	}
> +
> +	goto no_error;
> +
> +error_input_register_device:
> +	input_free_device(input_device);
> +error_input_allocate_device:
> +	if (ts->platform_data->exit)
> +		ts->platform_data->exit();
> +error_init:
> +	kfree(ts);
> +error_alloc_data:
> +no_error:
> +	return ts;
> +}

Thanks,
Henrik
