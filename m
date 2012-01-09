Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755750Ab2AIRfl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 12:35:41 -0500
Received: from smtprelay-b11.telenor.se ([62.127.194.20]:58384 "EHLO
	smtprelay-b11.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752011Ab2AIRf1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 12:35:27 -0500
X-SENDER-IP: [85.230.170.239]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AkpaADckC09V5qrvPGdsb2JhbAA9B4lWonwZAQEBATcygXIBAQQBJxMcIwULCANGFCUKGogNArZCE4hKglFjBI00h1SFYYxa
X-IronPort-AV: E=Sophos;i="4.71,480,1320620400"; 
   d="scan'208";a="24351126"
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Mon, 9 Jan 2012 18:35:23 +0100
To: Javier Martinez Canillas <javier@dowhile0.org>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Mohan Pallaka <mpallaka@codeaurora.org>,
        Kevin McNeely <kev@cypress.com>,
        Shubhrajyoti Datta <omaplinuxkernel@gmail.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v8 1/3] Input: cyttsp - Cypress TTSP capacitive
 multi-touch screen support
Message-ID: <20120109173523.GA5613@polaris.bitmath.org>
References: <1325722586-12886-1-git-send-email-javier@dowhile0.org>
 <1325722586-12886-2-git-send-email-javier@dowhile0.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1325722586-12886-2-git-send-email-javier@dowhile0.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Javier,

> Changes for v8:
>     Dmitry Torokhov (9):
>     - Fix use-after-free in cyttsp_release
>     - Remove ext() method from bus ops
>     - Move up into main touchscreen directory
>     - Rework Kconfig entries
>     - Guard PM methods with CONFIG_PM_SLEEP
>     - Device does not belong in bus structure
>     - Set up bus type in input device
>     - Use unified structure for ts object
>     - Consolidate PM methods
> 
>     Javier Martinez Canillas (5):
>     - Add <linux/device.h> macro to cyttsp_core.h
>     - Soft reset returns negative on error, not 0
>     - Use CY_NUM_RETRY instead of CY_DELAY_MAX for retries
>     - Add suspended an on boolean to cyttsp core
>     - Rework PM functions

Looking a lot better now, thank you. Some tiny comments below.

> +static int ttsp_read_block_data(struct cyttsp *ts, u8 command,
> +	u8 length, void *buf)
> +{
> +	int retval = -1;
> +	int tries;
> +
> +	if (!buf || !length)
> +		return -EINVAL;
> +
> +	for (tries = 0; tries < CY_NUM_RETRY && (retval < 0); tries++) {
> +		retval = ts->bus_ops->read(ts->dev, command, length, buf);
> +		if (retval)
> +			msleep(CY_DELAY_DFLT);
> +	}
> +
> +	return retval;
> +}

Still wondering why (retval > 0) is handled the same way as (retval < 0).

> +static int cyttsp_bl_app_valid(struct cyttsp *ts)
> +{
> +	int retval;
> +
> +	retval = cyttsp_load_bl_regs(ts);
> +
> +	if (retval < 0) {
> +		retval = -ENODEV;
> +		goto done;
> +	}
> +
> +	if (GET_BOOTLOADERMODE(ts->bl_data.bl_status)) {
> +		if (IS_VALID_APP(ts->bl_data.bl_status))
> +			return 0;
> +		else
> +			return -ENODEV;
> +	}
> +
> +	if (GET_HSTMODE(ts->bl_data.bl_file) == CY_OPERATE_MODE) {
> +		if (!(IS_OPERATIONAL_ERR(ts->bl_data.bl_status)))
> +			return 1;
> +		else
> +			return -ENODEV;
> +	}
> +
> +	retval = -ENODEV;
> +done:
> +	return retval;

The function seems to always return ENODEV, something to simplify?

> +static int cyttsp_set_sysinfo_mode(struct cyttsp *ts)
> +{
> +	int retval;
> +	int tries;
> +	u8 cmd = CY_SYSINFO_MODE;
> +
> +	memset(&(ts->sysinfo_data), 0, sizeof(struct cyttsp_sysinfo_data));
> +
> +	/* switch to sysinfo mode */
> +	retval = ttsp_write_block_data(ts, CY_REG_BASE, sizeof(cmd), &cmd);
> +	if (retval < 0)
> +		return retval;
> +
> +	/* read sysinfo registers */
> +	tries = 0;
> +	do {
> +		msleep(CY_DELAY_DFLT);
> +		retval = ttsp_read_block_data(ts, CY_REG_BASE,
> +			sizeof(ts->sysinfo_data), &ts->sysinfo_data);
> +	} while ((retval || (!ts->sysinfo_data.tts_verh &&
> +			     !ts->sysinfo_data.tts_verl)) &&
> +		 (tries++ < CY_NUM_RETRY));
> +
> +	if (tries >= CY_NUM_RETRY)
> +		return -EAGAIN;

The loop above seems to appear many times in the code. Something to
simplify?

Thanks,
Henrik
