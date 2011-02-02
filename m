Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752895Ab1BBDAR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 22:00:17 -0500
Received: from e2.ny.us.ibm.com ([32.97.182.142]:42798 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752105Ab1BBDAP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 22:00:15 -0500
Subject: Re: [PATCH] RTC: Fix for issues in the kernel RTC API.
From: John Stultz <john.stultz@linaro.org>
To: Marcelo Roberto Jimenez <mroberto@cpti.cetuc.puc-rio.br>
Cc: a.zummo@towertech.it, rtc-linux@googlegroups.com,
        linux-kernel@vger.kernel.org
In-Reply-To: <1296577820-27456-1-git-send-email-mroberto@cpti.cetuc.puc-rio.br>
References: <1296577820-27456-1-git-send-email-mroberto@cpti.cetuc.puc-rio.br>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 01 Feb 2011 19:00:05 -0800
Message-ID: <1296615605.3336.239.camel@work-vm>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-02-01 at 14:30 -0200, Marcelo Roberto Jimenez wrote:
> This patch fixes the following issues with the RTC API:
> 
> 1 - The alarm_irq_enable() and the update_irq_enable() callbacks were
> not beeing called anywhere in the code. They are necessary if you want
> to write a driver that does not use the kernel pre-existent timer
> implemented alarm and update interrupts.

I'm not sure I totally follow this one. alarm_irq_enable is still being
called in that function.

There are some callbacks that are no longer being made because the
functionality is now virtualized internally to the kernel. Could you
expand on the rational for this a bit more? Possibly showing a userland
example why the virtualized implementation isn't sufficient?

I will admit that I probably should clean out the callback hooks and
remove them from the drivers, as that probably adds to some of the
confusion here.

> 2 - In the current configuration, an update interrupt, for example,
> would be a trigger for an alarm interrupt as well, even though the mode
> variable stated it was an update interrupt. To avoid that, mode is
> beeing checked inside rtc_handle_legacy_irq(). That used to be the
> previous user space behaviour.

Right, we internally use recurring alarm interrupts to emulate the
update interrupt mode. Although I believe I provided the right behavior
to userland, so I'm not sure I see the issue or how your changes correct
things.


> 3 - The irq_set_freq() and rtc_irq_set_state() functions are entry
> points to the RTC API, and were not calling the irq_set_state() and
> irq_set_freq() callbacks. These are also necessary overrides to provide
> a proper independent RTC implementation.

Again, the freq is handled via a hrtimer now, so we shouldn't be calling
out to the hardware specific rtc driver anymore.


> 4 - The rtc-test kernel RTC driver has been updated to work properly
> with the new kernel RTC timer infrastructure. This driver has been used
> together with the rtctest.c source code present in the file
> Documentation/rtc.txt to test the user space behaviour of all the
> modifications in this patch.

So forgive me, as I might just be missing what you're describing. It
might be easier if you break fixes up into multiple patches?

More comments in the code below.

> Signed-off-by: Marcelo Roberto Jimenez <mroberto@cpti.cetuc.puc-rio.br>
> ---
>  drivers/rtc/interface.c |   63 +++++++++++++++++++++++++++++---------
>  drivers/rtc/rtc-dev.c   |   12 ++++----
>  drivers/rtc/rtc-test.c  |   77 ++++++++++++++++++++++++++++++++++++++++------
>  3 files changed, 121 insertions(+), 31 deletions(-)
> 
> diff --git a/drivers/rtc/interface.c b/drivers/rtc/interface.c
> index 90384b9..6cb4b65 100644
> --- a/drivers/rtc/interface.c
> +++ b/drivers/rtc/interface.c
> @@ -194,6 +194,11 @@ int rtc_alarm_irq_enable(struct rtc_device *rtc, unsigned int enabled)
>  	if (err)
>  		return err;
> 
> +	if (rtc->ops->alarm_irq_enable) {
> +		err = rtc->ops->alarm_irq_enable(rtc->dev.parent, enabled);
> +		goto out;
> +	}
> +
>  	if (rtc->aie_timer.enabled != enabled) {
>  		if (enabled) {
>  			rtc->aie_timer.enabled = 1;
> @@ -211,6 +216,7 @@ int rtc_alarm_irq_enable(struct rtc_device *rtc, unsigned int enabled)
>  	else
>  		err = rtc->ops->alarm_irq_enable(rtc->dev.parent, enabled);
> 
> +out:
>  	mutex_unlock(&rtc->ops_lock);
>  	return err;

So first, you're not checking if rtc->ops is valid before dereferencing.
Second, I'm not sure I see why you would call it and then avoid the new
virtualized rtc layer? Esp since we do end up calling the same
alarm_irq_enable function later (see the top of your second chunk).


>  }
> @@ -222,6 +228,11 @@ int rtc_update_irq_enable(struct rtc_device *rtc, unsigned int enabled)
>  	if (err)
>  		return err;
> 
> +	if (rtc->ops->update_irq_enable) {
> +		err = rtc->ops->update_irq_enable(rtc->dev.parent, enabled);
> +		goto out;
> +	}
> +
>  	/* make sure we're changing state */
>  	if (rtc->uie_rtctimer.enabled == enabled)
>  		goto out;

Same issue above here.



> @@ -263,19 +274,23 @@ static void rtc_handle_legacy_irq(struct rtc_device *rtc, int num, int mode)
>  {
>  	unsigned long flags;
> 
> -	/* mark one irq of the appropriate mode */
> -	spin_lock_irqsave(&rtc->irq_lock, flags);
> -	rtc->irq_data = (rtc->irq_data + (num << 8)) | (RTC_IRQF|mode);
> -	spin_unlock_irqrestore(&rtc->irq_lock, flags);
> -
> -	/* call the task func */
> -	spin_lock_irqsave(&rtc->irq_task_lock, flags);
> -	if (rtc->irq_task)
> -		rtc->irq_task->func(rtc->irq_task->private_data);
> -	spin_unlock_irqrestore(&rtc->irq_task_lock, flags);
> -
> -	wake_up_interruptible(&rtc->irq_queue);
> -	kill_fasync(&rtc->async_queue, SIGIO, POLL_IN);
> +	if (((mode & RTC_UF) && rtc->uie_rtctimer.enabled) ||
> +	    ((mode & RTC_AF) && rtc->aie_timer.enabled) ||
> +	    ((mode & RTC_PF) && rtc->pie_enabled)) {
> +		/* mark one irq of the appropriate mode */
> +		spin_lock_irqsave(&rtc->irq_lock, flags);
> +		rtc->irq_data = (rtc->irq_data + (num << 8)) | (RTC_IRQF|mode);
> +		spin_unlock_irqrestore(&rtc->irq_lock, flags);
> +
> +		/* call the task func */
> +		spin_lock_irqsave(&rtc->irq_task_lock, flags);
> +		if (rtc->irq_task)
> +			rtc->irq_task->func(rtc->irq_task->private_data);
> +		spin_unlock_irqrestore(&rtc->irq_task_lock, flags);
> +
> +		wake_up_interruptible(&rtc->irq_queue);
> +		kill_fasync(&rtc->async_queue, SIGIO, POLL_IN);
> +	}
>  }

I don't quite understand what this is doing.


> @@ -423,9 +438,18 @@ EXPORT_SYMBOL_GPL(rtc_irq_unregister);
>   */
>  int rtc_irq_set_state(struct rtc_device *rtc, struct rtc_task *task, int enabled)
>  {
> -	int err = 0;
>  	unsigned long flags;
> 
> +	int err = mutex_lock_interruptible(&rtc->ops_lock);
> +	if (err)
> +		return err;
> +	if (rtc->ops->irq_set_state) {
> +		err = rtc->ops->irq_set_state(rtc->dev.parent, enabled);
> +		mutex_unlock(&rtc->ops_lock);
> +		return err;
> +	}
> +	mutex_unlock(&rtc->ops_lock);
> +
>  	spin_lock_irqsave(&rtc->irq_task_lock, flags);
>  	if (rtc->irq_task != NULL && task == NULL)
>  		err = -EBUSY;

Again, not checking rtc->ops and irq_set_state shouldn't be called
anymore, as the hrtimer handles periodic mode irq emulation now.


> @@ -457,9 +481,18 @@ EXPORT_SYMBOL_GPL(rtc_irq_set_state);
>   */
>  int rtc_irq_set_freq(struct rtc_device *rtc, struct rtc_task *task, int freq)
>  {
> -	int err = 0;
>  	unsigned long flags;
> 
> +	int err = mutex_lock_interruptible(&rtc->ops_lock);
> +	if (err)
> +		return err;
> +	if (rtc->ops->irq_set_freq) {
> +		err = rtc->ops->irq_set_freq(rtc->dev.parent, freq);
> +		mutex_unlock(&rtc->ops_lock);
> +		return err;
> +	}
> +	mutex_unlock(&rtc->ops_lock);
> +

Same as the last comment here. irq_set_freq is handled by generic
emulation code now.


> diff --git a/drivers/rtc/rtc-dev.c b/drivers/rtc/rtc-dev.c
> index 212b16e..d901160 100644
> --- a/drivers/rtc/rtc-dev.c
> +++ b/drivers/rtc/rtc-dev.c
> @@ -261,12 +261,12 @@ static long rtc_dev_ioctl(struct file *file,
>  		return rtc_set_time(rtc, &tm);
> 
>  	case RTC_PIE_ON:
> -		err = rtc_irq_set_state(rtc, NULL, 1);
> -		break;
> +		mutex_unlock(&rtc->ops_lock);
> +		return rtc_irq_set_state(rtc, NULL, 1);
> 
>  	case RTC_PIE_OFF:
> -		err = rtc_irq_set_state(rtc, NULL, 0);
> -		break;
> +		mutex_unlock(&rtc->ops_lock);
> +		return rtc_irq_set_state(rtc, NULL, 0);
> 
>  	case RTC_AIE_ON:
>  		mutex_unlock(&rtc->ops_lock);
> @@ -285,8 +285,8 @@ static long rtc_dev_ioctl(struct file *file,
>  		return rtc_update_irq_enable(rtc, 0);
> 
>  	case RTC_IRQP_SET:
> -		err = rtc_irq_set_freq(rtc, NULL, arg);
> -		break;
> +		mutex_unlock(&rtc->ops_lock);
> +		return rtc_irq_set_freq(rtc, NULL, arg);
> 
>  	case RTC_IRQP_READ:

Why the unlock/return change here?


If I'm being totally daft here, my apologies and please let me know. The
rework I did was fairly large, and its quite possible there are issues
lurking. But I'm not connecting your patch to specific breakage yet.

thanks
-john


