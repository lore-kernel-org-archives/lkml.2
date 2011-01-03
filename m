Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932069Ab1ACRIh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jan 2011 12:08:37 -0500
Received: from ns2.cypress.com ([157.95.67.5]:49696 "EHLO ns2.cypress.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754565Ab1ACRIf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jan 2011 12:08:35 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [v3 1/3] 1/3 Touchscreen: Cypress TTSP G3 MTDEV Core Driver
Date: Mon, 3 Jan 2011 09:03:34 -0800
Message-ID: <FB9C2CB29A07AB45B575A4E8D2AABC09013FFF98@labamba.mis.cypress.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [v3 1/3] 1/3 Touchscreen: Cypress TTSP G3 MTDEV Core Driver
Thread-Index: Acuo4htoI+k/dxOAT+2DW7Ci8VLE1wChRAYA
References: <kev@cypress.com> <1293650268-1561-1-git-send-email-kev@cypress.com> <20101231115323.GA9709@polaris.bitmath.org>
From: "Kevin McNeely" <Kevin.McNeely@cypress.com>
To: "Henrik Rydberg" <rydberg@euromail.se>
Cc: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>,
        "David Brown" <davidb@codeaurora.org>,
        "Trilok Soni" <tsoni@codeaurora.org>,
        "Samuel Ortiz" <sameo@linux.intel.com>,
        "Eric Miao" <eric.y.miao@gmail.com>,
        "Mike Frysinger" <vapier@gentoo.org>,
        "Alan Cox" <alan@linux.intel.com>, <linux-input@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 03 Jan 2011 17:04:23.0982 (UTC) FILETIME=[456B9CE0:01CBAB68]
X-Brightmail-Tracker: AAAAAA==
X-MailScanner: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Henrik,

Thanks for your comments. Comments and questions inline below...

> -----Original Message-----
> From: Henrik Rydberg [mailto:rydberg@euromail.se]
> Sent: Friday, December 31, 2010 3:53 AM
> To: Kevin McNeely
> Cc: Dmitry Torokhov; David Brown; Trilok Soni; Samuel Ortiz; Eric
Miao;
> Mike Frysinger; Alan Cox; linux-input@vger.kernel.org; linux-
> kernel@vger.kernel.org
> Subject: Re: [v3 1/3] 1/3 Touchscreen: Cypress TTSP G3 MTDEV Core
> Driver
> 
> Hi Kevin,
> 
> Thanks for the changes, it looks much better now. Some comments on the
> MT
> part inline.
> 
> > diff --git a/drivers/input/touchscreen/Kconfig
> b/drivers/input/touchscreen/Kconfig
> > index 06ea8da..7d886bc 100644
> > --- a/drivers/input/touchscreen/Kconfig
> > +++ b/drivers/input/touchscreen/Kconfig
> > @@ -124,6 +124,11 @@ config TOUCHSCREEN_CY8CTMG110
> >  	  To compile this driver as a module, choose M here: the
> >  	  module will be called cy8ctmg110_ts.
> >
> > +config TOUCHSCREEN_CYTTSP_CORE
> > +	bool "Cypress TTSP touchscreen core"
> > +	help
> > +	  Always activated for Cypress TTSP touchscreen
> > +
> 
> Tristate please.

This will be changed.

> 
> [...]
> > +
> > +struct cyttsp_tch {
> > +	u16 x;
> > +	u16 y;
> > +	u8 z;
> > +};
> 
> Does not appear to be used anywhere.

This will be removed.

> 
> [...]
> > +struct cyttsp {
> > +	struct device *dev;
> > +	int irq;
> > +	struct input_dev *input;
> > +	struct mutex mutex;
> 
> Is this really used?

No. This will be removed.

> 
> > +	char phys[32];
> > +	const struct bus_type *bus_type;
> > +	const struct cyttsp_platform_data *platform_data;
> > +	struct cyttsp_bus_ops *bus_ops;
> > +	struct cyttsp_xydata xy_data;
> > +	struct cyttsp_bootloader_data bl_data;
> > +	struct cyttsp_sysinfo_data sysinfo_data;
> > +	struct completion bl_ready;
> > +	enum cyttsp_powerstate power_state;
> > +};
> > +
> > +static const u8 bl_command[] = {
> > +	CY_BL_FILE0, CY_BL_CMD, CY_BL_EXIT,
> > +	CY_BL_KEY0, CY_BL_KEY1, CY_BL_KEY2,
> > +	CY_BL_KEY3, CY_BL_KEY4, CY_BL_KEY5,
> > +	CY_BL_KEY6, CY_BL_KEY7
> > +};
> 
> If the CY_BL* values are only used here, how about putting the numbers
> here directly?

This will be done.

> 
> [...]
> > +static int ttsp_read_block_data(struct cyttsp *ts, u8 command,
> > +	u8 length, void *buf)
> > +{
> > +	int retval;
> > +	int tries;
> > +
> > +	if (!buf || !length)
> > +		return -EIO;
> 
> -EINVAL?

This will be changed.

> 
> > +
> > +	for (tries = 0, retval = -1;
> > +		tries < CY_NUM_RETRY && (retval < 0);
> > +		tries++)
> > +		retval = ts->bus_ops->read(ts->bus_ops, command, length,
> buf);
> > +
> > +	return retval;
> > +}
> 
> [...]
> > +/* process current touches */
> > +static int cyttsp_xy_worker(struct cyttsp *ts)
> > +{
> > +	u8 num_cur_tch = 0;
> 
> Does not appear to need initialization.

This will be cleaned up.

> 
> > +	u16 x;
> > +	u16 y;
> > +	u8 z;
> 
> Perhaps x[2], y[2] etc here.

This will be implemented.

> 
> > +
> > +	/* Get touch data from CYTTSP device */
> > +	if (ttsp_read_block_data(ts,
> > +		CY_REG_BASE, sizeof(struct cyttsp_xydata),
&ts->xy_data))
> > +		return 0;
> > +
> > +	/* touch extension handling */
> > +	if (ttsp_tch_ext(ts, &ts->xy_data))
> > +		return 0;
> > +
> > +	/* provide flow control handshake */
> > +	if (ts->platform_data->use_hndshk)
> > +		if (cyttsp_hndshk(ts, ts->xy_data.hst_mode))
> > +			return 0;
> > +
> > +	/* determine number of currently active touches */
> > +	num_cur_tch = GET_NUM_TOUCHES(ts->xy_data.tt_stat);
> > +
> > +	/* check for any error conditions */
> > +	if (ts->power_state == CY_IDLE_STATE)
> > +		return 0;
> > +	else if (GET_BOOTLOADERMODE(ts->xy_data.tt_mode)) {
> > +		return -1;
> > +	} else if (IS_LARGE_AREA(ts->xy_data.tt_stat) == 1) {
> > +		/* terminate all active tracks */
> > +		num_cur_tch = 0;
> > +		dev_dbg(ts->dev, "%s: Large area detected\n", __func__);
> > +	} else if (num_cur_tch > 2) {
> > +		/* terminate all active tracks */
> > +		num_cur_tch = 0;
> > +		dev_dbg(ts->dev, "%s: Num touch error detected\n",
> __func__);
> > +	} else if (IS_BAD_PKT(ts->xy_data.tt_mode)) {
> > +		/* terminate all active tracks */
> > +		num_cur_tch = 0;
> > +		dev_dbg(ts->dev, "%s: Invalid buffer detected\n",
> __func__);
> > +	}
> > +
> > +	/* send touches */
> > +	if (!num_cur_tch)
> > +		/* terminate previous active touch */
> > +		input_mt_sync(ts->input);
> > +
> > +	if (num_cur_tch) {
> > +		/* send touch 1 */
> > +		/*
> > +		 * If there is only one current active touch,
> > +		 * it will be reported in the touch 1 regardless
> > +		 * if it was reported in the touch 2 previously
> > +		 */
> 
> Perhaps "touch" should be "track" or "slot" here?

I plan to keep the "touch" in order to match our part documentation.

> 
> > +		x = (ts->xy_data.tch1_xhi << 8) + ts->xy_data.tch1_xlo;
> > +		y = (ts->xy_data.tch1_yhi << 8) + ts->xy_data.tch1_ylo;
> > +		z = ts->xy_data.tch1_z;
> 
> Perhaps x[0] = ... here

This will be implemented.

> 
> > +		input_report_abs(ts->input, ABS_MT_POSITION_X, x);
> > +		input_report_abs(ts->input, ABS_MT_POSITION_Y, y);
> > +		input_report_abs(ts->input, ABS_MT_TOUCH_MAJOR, z);
> > +		input_mt_sync(ts->input);
> 
> Then these could still be collected in a loop.

The loop will be added.

> 
> > +	}
> > +
> > +	if (num_cur_tch > 1) {
> > +		/* send touch 2 */
> > +		x = (ts->xy_data.tch2_xhi << 8) + ts->xy_data.tch2_xlo;
> > +		y = (ts->xy_data.tch2_yhi << 8) + ts->xy_data.tch2_ylo;
> > +		z = ts->xy_data.tch2_z;
> 
> And x[1] = ...

The same, x[1] and the loop will be added.

> 
> > +		input_report_abs(ts->input, ABS_MT_POSITION_X, x);
> > +		input_report_abs(ts->input, ABS_MT_POSITION_Y, y);
> > +		input_report_abs(ts->input, ABS_MT_TOUCH_MAJOR, z);
> > +		input_mt_sync(ts->input);
> > +	}
> 
> Ditto.

The same.

> 
> > +
> > +	input_sync(ts->input);
> > +
> > +	return 0;
> > +}
> 
> If the in-kernel tracking module was in place, would you consider
> switching to the slots protocol?

Hi Henrik, can you please clarify?  Should I remove MTDEV from the patch
title?

Thanks and best regards,
Kevin

> 
> Thanks,
> Henrik

---------------------------------------------------------------
This message and any attachments may contain Cypress (or its
subsidiaries) confidential information. If it has been received
in error, please advise the sender and immediately delete this
message.
---------------------------------------------------------------

