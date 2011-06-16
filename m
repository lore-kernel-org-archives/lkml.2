Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755707Ab1FPLYZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 07:24:25 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:52334 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754478Ab1FPLYX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 07:24:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=xIhzUU3n8wBlTxlV7VlzzvVOeM23JaYU58Ib0F1bHX8xiT3dlnt0KDz068AdqXpK++
         kOvqDmb4mtu57HPuA8mD0vAqHIwqogWw/Am0FrIXl8M7YBTSr90O5N/oCRcHH6HkdHNl
         msmcqiqCDRdAgBUIZfgG3N0Eg/YgYjt99AmXg=
Date: Thu, 16 Jun 2011 14:23:55 +0300
From: Dan Carpenter <error27@gmail.com>
To: edwin_rong@realsil.com.cn
Cc: gregkh@suse.de, devel@linuxdriverproject.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Realtek cr: Add autosuspend function.
Message-ID: <20110616112355.GG23739@shale.localdomain>
References: <1308208235-3603-1-git-send-email-edwin_rong@realsil.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1308208235-3603-1-git-send-email-edwin_rong@realsil.com.cn>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch means we poll 20 times a second and test to see if we
have gone for 1000 polls without doing anything if so then we sleep.
Is there a way to get the same effect without the polling?  Like
maybe set a timer for 50 seconds in the future and every time we do
something then push the timer further into the future?

On Thu, Jun 16, 2011 at 03:10:35PM +0800, edwin_rong@realsil.com.cn wrote:
> +config REALTEK_AUTOPM
> +     bool "Realtek Card Reader autosuspend support"
> +     depends on USB_STORAGE_REALTEK
> +     default y
>

This should probably depend on CONFIG_PM_RUNTIME as well.

>  struct rts51x_chip {
> -	u16			vendor_id;
> -	u16			product_id;
> -	char			max_lun;
> +	u16 vendor_id;
> +	u16 product_id;
> +	char max_lun;

There are about 50 lines of whitespace changes in this patch, but
those should be separated out and sent as a second patch.  I'm not
going to go through the patch and point out all 50 lines
individually.

>  /* flag definition */
> @@ -97,9 +139,28 @@ struct rts51x_chip {
>  #define RTS51X_GET_VID(chip)		((chip)->vendor_id)
>  #define RTS51X_GET_PID(chip)		((chip)->product_id)
>
> +#define VENDOR_ID(chip)			((chip)->status->vid)
> +#define PRODUCT_ID(chip)		((chip)->status->pid)
> +#ifdef CONFIG_REALTEK_AUTOPM
> +#define FW_VERSION(chip)		((chip)->status->fw_ver)
> +#else
>  #define FW_VERSION(chip)		((chip)->status[0].fw_ver)

These definitions of FW_VERSION() produce the same thing, so we only
need one.  The original definition is better because chip->status
is an array, it's allocated in init_realtek_cr()

	size = (chip->max_lun + 1) * sizeof(struct rts51x_status);
	chip->status = kzalloc(size, GFP_KERNEL);

VENDOR_ID() and PRODUCT_ID() should be defined the same way.

> -#define wait_timeout_x(task_state, msecs)	\
> -do {						\
> -	set_current_state((task_state));	\
> -	schedule_timeout((msecs) * HZ / 1000);	\
> -} while (0)
> -
> -#define wait_timeout(msecs)		\
> -		wait_timeout_x(TASK_INTERRUPTIBLE, (msecs))
> -

Removing these unused macros is a nice cleanup, but it should go in
a separate patch.

> +static int fw5895_init(struct us_data *us)
> +{
> +	struct rts51x_chip *chip = (struct rts51x_chip *)(us->extra);
> +	int retval;
> +	u8 val;
> +
> +	US_DEBUGP("-- %s --\n", __func__);
> +
> +	if ((PRODUCT_ID(chip) != 0x0158) || (FW_VERSION(chip) != 0x5895)) {
> +		US_DEBUGP("Not the specified device, return immediately!\n");
> +		return STATUS_SUCCESS;

Should we really return SUCCESS here?  No one actually checks the
return value of this function so I suppose it doesn't matter either
way.

> +	}
> +
> +	retval = rts51x_read_mem(us, 0xFD6F, &val, 1);
> +	if (retval != STATUS_SUCCESS) {
> +		US_DEBUGP("Read memory fail\n");
> +		RETURN(STATUS_FAIL);

There are two debug output lines in a row here.  One is enough.

> +void rts51x_polling(struct work_struct *work)
> +{
> +	struct rts51x_chip *chip = container_of(work, struct rts51x_chip,
> +						rts51x_delayed_work.work);
> +	struct us_data *us = chip->us;
> +
> +	/* lock the device pointers */
> +	mutex_lock(&(us->dev_mutex));
                    ^             ^
	These parens are not needed.  (My static checker sucks and
	it complains that the mutex_lock() and mutex_unlock() don't
	match because one has parens and one doesn't).

> +
> +	US_DEBUGP("%s: <---\n", __func__);
> +
> +	switch (rts51x_get_stat(chip)) {
> +	case RTS51X_STAT_INIT:
> +		break;
> +	case RTS51X_STAT_RUN:
> +		chip->idle_counter = 0;
> +		break;
> +	case RTS51X_STAT_IDLE:{
> +		if (chip->idle_counter <
> +				(ss_delay * 1000 / POLLING_INTERVAL)) {
> +			US_DEBUGP("%s: idle_counter ++\n", __func__);
> +			chip->idle_counter++;
> +			break;
> +			}
                        ^
	Should be back one indent level.

> +		}
                ^
	This pair of braces is not needed.

> +	case RTS51X_STAT_SS:{
> +		US_DEBUGP("%s: RTS51X_STAT_SS, intf->pm_usage_cnt:%d,"
> +			"power.usage:%d\n", __func__,
> +			atomic_read(&us->pusb_intf->pm_usage_cnt),
> +			atomic_read(&us->pusb_intf->dev.power.usage_count));
> +
> +		if (atomic_read(&us->pusb_intf->pm_usage_cnt) > 0) {
> +			US_DEBUGP("%s: Ready to enter SS state.\n",
> +				  __func__);
> +			rts51x_set_stat(chip, RTS51X_STAT_SS);
> +			/* ignore mass storage interface's children */
> +			pm_suspend_ignore_children(&us->pusb_intf->dev, true);
> +			usb_autopm_put_interface(us->pusb_intf);
> +			US_DEBUGP("%s: RTS51X_STAT_SS 01,"
> +				"intf->pm_usage_cnt:%d, power.usage:%d\n",
> +				__func__,
> +				atomic_read(&us->pusb_intf->pm_usage_cnt),
> +				atomic_read(
> +					&us->pusb_intf->dev.power.usage_count));
> +		}
> +		break;
> +		}
                ^
	Same situation with these braces.


> +	default:
> +		US_DEBUGP("%s: Unknonwn state !!!\n", __func__);
> +		break;
> +	}
> +
> +	if (rts51x_get_stat(chip) != RTS51X_STAT_SS)
> +		queue_delayed_work(chip->rts51x_wq,
> +				   &(chip->rts51x_delayed_work),
                                    ^                         ^
	These parens are not needed.

> +				   POLLING_INTERVAL * HZ / 1000);
                                   ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
	Use msecs_to_jiffies(POLLING_INTERVAL)

> +	/* unlock the device pointers */
> +	mutex_unlock(&us->dev_mutex);
> +
> +	US_DEBUGP("%s: --->\n", __func__);
> +}
> +
regards,
dan carpenter
