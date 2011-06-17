Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757103Ab1FQLjP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jun 2011 07:39:15 -0400
Received: from rtits2.realtek.com ([60.250.210.242]:46726 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755759Ab1FQLjO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jun 2011 07:39:14 -0400
X-SpamFilter-By: BOX Solutions SpamTrap 5.11 with qID p5HBcuCf011244, This message is released by code: ctaloc0852
X-BOX-Message-Id: p5HBcuCf011244
Message-ID: <4DFB3CD0.8030603@realsil.com.cn>
Date: Fri, 17 Jun 2011 19:38:56 +0800
From: edwin_rong <edwin_rong@realsil.com.cn>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.17) Gecko/20110516 Thunderbird/3.1.10
MIME-Version: 1.0
To: Dan Carpenter <error27@gmail.com>
CC: "gregkh@suse.de" <gregkh@suse.de>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Realtek cr: Add autosuspend function.
References: <1308208235-3603-1-git-send-email-edwin_rong@realsil.com.cn> <20110616112355.GG23739@shale.localdomain>
In-Reply-To: <20110616112355.GG23739@shale.localdomain>
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/16/2011 07:23 PM, Dan Carpenter wrote:
> This patch means we poll 20 times a second and test to see if we
> have gone for 1000 polls without doing anything if so then we sleep.
> Is there a way to get the same effect without the polling?  Like
> maybe set a timer for 50 seconds in the future and every time we do
> something then push the timer further into the future?
>

Dear Dan,
Thanks for your suggestions, which have been applied to new patches, and
patches have been sent out.
Please help review.

BRs
Edwin

> On Thu, Jun 16, 2011 at 03:10:35PM +0800, edwin_rong@realsil.com.cn wrote:
>> +config REALTEK_AUTOPM
>> +     bool "Realtek Card Reader autosuspend support"
>> +     depends on USB_STORAGE_REALTEK
>> +     default y
>>
> This should probably depend on CONFIG_PM_RUNTIME as well.
>
>>  struct rts51x_chip {
>> -	u16			vendor_id;
>> -	u16			product_id;
>> -	char			max_lun;
>> +	u16 vendor_id;
>> +	u16 product_id;
>> +	char max_lun;
> There are about 50 lines of whitespace changes in this patch, but
> those should be separated out and sent as a second patch.  I'm not
> going to go through the patch and point out all 50 lines
> individually.
>
>>  /* flag definition */
>> @@ -97,9 +139,28 @@ struct rts51x_chip {
>>  #define RTS51X_GET_VID(chip)		((chip)->vendor_id)
>>  #define RTS51X_GET_PID(chip)		((chip)->product_id)
>>
>> +#define VENDOR_ID(chip)			((chip)->status->vid)
>> +#define PRODUCT_ID(chip)		((chip)->status->pid)
>> +#ifdef CONFIG_REALTEK_AUTOPM
>> +#define FW_VERSION(chip)		((chip)->status->fw_ver)
>> +#else
>>  #define FW_VERSION(chip)		((chip)->status[0].fw_ver)
> These definitions of FW_VERSION() produce the same thing, so we only
> need one.  The original definition is better because chip->status
> is an array, it's allocated in init_realtek_cr()
>
> 	size = (chip->max_lun + 1) * sizeof(struct rts51x_status);
> 	chip->status = kzalloc(size, GFP_KERNEL);
>
> VENDOR_ID() and PRODUCT_ID() should be defined the same way.
>
>> -#define wait_timeout_x(task_state, msecs)	\
>> -do {						\
>> -	set_current_state((task_state));	\
>> -	schedule_timeout((msecs) * HZ / 1000);	\
>> -} while (0)
>> -
>> -#define wait_timeout(msecs)		\
>> -		wait_timeout_x(TASK_INTERRUPTIBLE, (msecs))
>> -
> Removing these unused macros is a nice cleanup, but it should go in
> a separate patch.
>
>> +static int fw5895_init(struct us_data *us)
>> +{
>> +	struct rts51x_chip *chip = (struct rts51x_chip *)(us->extra);
>> +	int retval;
>> +	u8 val;
>> +
>> +	US_DEBUGP("-- %s --\n", __func__);
>> +
>> +	if ((PRODUCT_ID(chip) != 0x0158) || (FW_VERSION(chip) != 0x5895)) {
>> +		US_DEBUGP("Not the specified device, return immediately!\n");
>> +		return STATUS_SUCCESS;
> Should we really return SUCCESS here?  No one actually checks the
> return value of this function so I suppose it doesn't matter either
> way.
>
>> +	}
>> +
>> +	retval = rts51x_read_mem(us, 0xFD6F, &val, 1);
>> +	if (retval != STATUS_SUCCESS) {
>> +		US_DEBUGP("Read memory fail\n");
>> +		RETURN(STATUS_FAIL);
> There are two debug output lines in a row here.  One is enough.
>
>> +void rts51x_polling(struct work_struct *work)
>> +{
>> +	struct rts51x_chip *chip = container_of(work, struct rts51x_chip,
>> +						rts51x_delayed_work.work);
>> +	struct us_data *us = chip->us;
>> +
>> +	/* lock the device pointers */
>> +	mutex_lock(&(us->dev_mutex));
>                     ^             ^
> 	These parens are not needed.  (My static checker sucks and
> 	it complains that the mutex_lock() and mutex_unlock() don't
> 	match because one has parens and one doesn't).
>
>> +
>> +	US_DEBUGP("%s: <---\n", __func__);
>> +
>> +	switch (rts51x_get_stat(chip)) {
>> +	case RTS51X_STAT_INIT:
>> +		break;
>> +	case RTS51X_STAT_RUN:
>> +		chip->idle_counter = 0;
>> +		break;
>> +	case RTS51X_STAT_IDLE:{
>> +		if (chip->idle_counter <
>> +				(ss_delay * 1000 / POLLING_INTERVAL)) {
>> +			US_DEBUGP("%s: idle_counter ++\n", __func__);
>> +			chip->idle_counter++;
>> +			break;
>> +			}
>                         ^
> 	Should be back one indent level.
>
>> +		}
>                 ^
> 	This pair of braces is not needed.
>
>> +	case RTS51X_STAT_SS:{
>> +		US_DEBUGP("%s: RTS51X_STAT_SS, intf->pm_usage_cnt:%d,"
>> +			"power.usage:%d\n", __func__,
>> +			atomic_read(&us->pusb_intf->pm_usage_cnt),
>> +			atomic_read(&us->pusb_intf->dev.power.usage_count));
>> +
>> +		if (atomic_read(&us->pusb_intf->pm_usage_cnt) > 0) {
>> +			US_DEBUGP("%s: Ready to enter SS state.\n",
>> +				  __func__);
>> +			rts51x_set_stat(chip, RTS51X_STAT_SS);
>> +			/* ignore mass storage interface's children */
>> +			pm_suspend_ignore_children(&us->pusb_intf->dev, true);
>> +			usb_autopm_put_interface(us->pusb_intf);
>> +			US_DEBUGP("%s: RTS51X_STAT_SS 01,"
>> +				"intf->pm_usage_cnt:%d, power.usage:%d\n",
>> +				__func__,
>> +				atomic_read(&us->pusb_intf->pm_usage_cnt),
>> +				atomic_read(
>> +					&us->pusb_intf->dev.power.usage_count));
>> +		}
>> +		break;
>> +		}
>                 ^
> 	Same situation with these braces.
>
>
>> +	default:
>> +		US_DEBUGP("%s: Unknonwn state !!!\n", __func__);
>> +		break;
>> +	}
>> +
>> +	if (rts51x_get_stat(chip) != RTS51X_STAT_SS)
>> +		queue_delayed_work(chip->rts51x_wq,
>> +				   &(chip->rts51x_delayed_work),
>                                     ^                         ^
> 	These parens are not needed.
>
>> +				   POLLING_INTERVAL * HZ / 1000);
>                                    ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> 	Use msecs_to_jiffies(POLLING_INTERVAL)
>
>> +	/* unlock the device pointers */
>> +	mutex_unlock(&us->dev_mutex);
>> +
>> +	US_DEBUGP("%s: --->\n", __func__);
>> +}
>> +
> regards,
> dan carpenter

