Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758159Ab2DMJRl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 05:17:41 -0400
Received: from smtprelay-b21.telenor.se ([195.54.99.212]:44787 "EHLO
	smtprelay-b21.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758026Ab2DMJRj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 05:17:39 -0400
X-SENDER-IP: [85.230.169.225]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AqBnAB7uh09V5qnhPGdsb2JhbABFiiisSgSBBBkBAQEBNzSCCQEBBAEnExwjBQsIAw44FCUKGhOICQm5cBOLSYUYYwSVa4YCg1WJSQ
X-IronPort-AV: E=Sophos;i="4.75,416,1330902000"; 
   d="scan'208";a="312655343"
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Fri, 13 Apr 2012 11:20:14 +0200
To: Daniel Kurtz <djkurtz@chromium.org>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Nick Dyer <nick.dyer@itdev.co.uk>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, Benson Leung <bleung@chromium.org>,
        Yufeng Shen <miletus@chromium.org>
Subject: Re: [PATCH 15/16 v2] Input: atmel_mxt_ts - send all MT-B slots in
 one input report
Message-ID: <20120413092014.GC3923@polaris.bitmath.org>
References: <1333039766-8617-1-git-send-email-djkurtz@chromium.org>
 <1333039766-8617-16-git-send-email-djkurtz@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1333039766-8617-16-git-send-email-djkurtz@chromium.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Daniel,

> Each interrupt contains information for all contacts with changing
> properties.  Process all of this information at once, and send it all in a
> a single input report (ie input events ending in EV_SYN/SYN_REPORT).
> 
> This patch was tested using an MXT224E.
> 
> Signed-off-by: Daniel Kurtz <djkurtz@chromium.org>
> ---
>  drivers/input/touchscreen/atmel_mxt_ts.c |   11 ++++++++---
>  1 files changed, 8 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/input/touchscreen/atmel_mxt_ts.c b/drivers/input/touchscreen/atmel_mxt_ts.c
> index be1e2ec..d8b23ad 100644
> --- a/drivers/input/touchscreen/atmel_mxt_ts.c
> +++ b/drivers/input/touchscreen/atmel_mxt_ts.c
> @@ -532,9 +532,6 @@ static void mxt_input_touch(struct mxt_data *data, struct mxt_message *message)
>  		input_report_abs(input_dev, ABS_MT_TOUCH_MAJOR, area);
>  		/* TODO: Use vector to report ORIENTATION & TOUCH_MINOR */
>  	}
> -
> -	input_mt_report_pointer_emulation(input_dev, false);
> -	input_sync(input_dev);
>  }
>  
>  static irqreturn_t mxt_interrupt(int irq, void *dev_id)
> @@ -542,7 +539,9 @@ static irqreturn_t mxt_interrupt(int irq, void *dev_id)
>  	struct mxt_data *data = dev_id;
>  	struct mxt_message message;
>  	struct device *dev = &data->client->dev;
> +	bool update_input;
>  
> +	update_input = false;
>  	do {
>  		if (mxt_read_message(data, &message)) {
>  			dev_err(dev, "Failed to read message\n");
> @@ -552,11 +551,17 @@ static irqreturn_t mxt_interrupt(int irq, void *dev_id)
>  		if (message.reportid >= data->T9_reportid_min &&
>  		    message.reportid <= data->T9_reportid_max) {
>  			mxt_input_touch(data, &message);
> +			update_input = true;
>  		} else {
>  			mxt_dump_message(dev, &message);
>  		}
>  	} while (message.reportid != 0xff);
>  
> +	if (update_input) {
> +		input_mt_report_pointer_emulation(data->input_dev, false);
> +		input_sync(data->input_dev);
> +	}
> +

Strictly speaking, the update_input variable is not needed either,
although it will save some cycles. The input core will omit the sync
when there is nothing to report.

>  end:
>  	return IRQ_HANDLED;
>  }
> -- 
> 1.7.7.3
> 

Thanks,
Henrik
