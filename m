Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754412Ab2AYABk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 19:01:40 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:49843 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754350Ab2AYABi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 19:01:38 -0500
Message-ID: <1327449689.11738.34.camel@work-vm>
Subject: Re: [PATCH] hrtimers, timers: eliminate some jiffies-backed code
From: john stultz <johnstul@us.ibm.com>
To: Dmitry Antipov <dmitry.antipov@linaro.org>
Cc: Steve Glendinning <steve.glendinning@smsc.com>,
        linaro-dev@lists.linaro.org, linux-kernel@vger.kernel.org,
        patches@linaro.org, Thomas Gleixner <tglx@linutronix.de>,
        Amit Kucheria <amit.kucheria@linaro.org>
Date: Tue, 24 Jan 2012 16:01:29 -0800
In-Reply-To: <1327333258-20734-1-git-send-email-dmitry.antipov@linaro.org>
References: <1327333258-20734-1-git-send-email-dmitry.antipov@linaro.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12012500-3270-0000-0000-000003781B20
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-01-23 at 19:40 +0400, Dmitry Antipov wrote:
> This patch provides an attempt to get away from jiffies in msleep()
> and msleep_interruptible() to hrtimers-backed usleep_range() and
> usleep_range_interruptible(). Both of the latter now returns an amount
> of microseconds really spent in sleep; another rationale for this
> was to convert msleep()-based wait-for-hardware loops to usleep_range(),
> like this:
> 
> unsigned long timeout = jiffies + msecs_to_jiffies(1000);
> while (hw_is_not_ready()) {
> 	if (time_after(jiffies, timeout))
> 		return -ETIMEDOUT;
> 	msleep(1);
> }
> 
> to:
> 
> unsigned long timeout = 0;
> while (hw_is_not_ready()) {
>       if (timeout > USEC_PER_SEC)
> 	      return -ETIMEDOUT;
>       timeout += usleep_range(500, 1500);
> }
> 
> Signed-off-by: Dmitry Antipov <dmitry.antipov@linaro.org>

So I'm still a little foggy on what actual benefit this change brings.

Why do you want to move loops like the above from jiffies based timeouts
to hrtimers?

Is there an actual need for sub-jiffy granularity in these sorts of
timeouts?

Or is this really just a "getting away from using jiffies" cleanup?


> diff --git a/include/linux/hrtimer.h b/include/linux/hrtimer.h
> index fd0dc30..01d782b 100644
> --- a/include/linux/hrtimer.h
> +++ b/include/linux/hrtimer.h
> @@ -126,6 +126,7 @@ struct hrtimer {
>   * task is set to NULL, when the timer expires.
>   */
>  struct hrtimer_sleeper {
> +	ktime_t kt;

kt? Please use a better name here, as the function of that value is
opaque on initial reading.

>  	struct hrtimer timer;
>  	struct task_struct *task;
>  };
> @@ -428,9 +429,10 @@ extern long hrtimer_nanosleep_restart(struct restart_block *restart_block);
>  extern void hrtimer_init_sleeper(struct hrtimer_sleeper *sl,
>  				 struct task_struct *tsk);
> 
> -extern int schedule_hrtimeout_range(ktime_t *expires, unsigned long delta,
> -						const enum hrtimer_mode mode);
> -extern int schedule_hrtimeout_range_clock(ktime_t *expires,
> +extern int schedule_hrtimeout_range(ktime_t *expires, ktime_t *elapsed,
> +				    unsigned long delta,
> +				    const enum hrtimer_mode mode);

Another silly nit, but is it just me, or does having elapsed as the
second argument in-between the expiration and the slack seem awkward?


> diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
> index ae34bf5..8642c3f 100644
> --- a/kernel/hrtimer.c
> +++ b/kernel/hrtimer.c
> @@ -1475,6 +1475,12 @@ static enum hrtimer_restart hrtimer_wakeup(struct hrtimer *timer)
>  	struct hrtimer_sleeper *t =
>  		container_of(timer, struct hrtimer_sleeper, timer);
>  	struct task_struct *task = t->task;
> +	struct hrtimer_clock_base *base;
> +	unsigned long flags;
> +
> +	base = lock_hrtimer_base(timer, &flags);
> +	t->kt = ktime_sub(base->get_time(), t->kt);
> +	unlock_hrtimer_base(timer, &flags);


Calling get_time() again on each hrtimer_wakeup isn't free. 

With this we end up when the irq fires, calling hrtimer_interrupt, which
reads the time and goes through the timer list running expired timers,
which then runs the sleeper's timer which then reads the time again!
Additinoally, this extra overhead is done even no one wants the elapsed
time.

Personally, given the above, I'm not sure what the benefit of of your
implementation over just doing something like the following where
necessary:

u64 now = ktime_get();
u64 timeout = ktime_to_ns(now) + NSEC_PER_SEC;
while (hw_is_not_ready()) {
	if (now > timeout)
		return -ETIMEDOUT;
	usleep_range(500, 1500);
	now = ktime_get();
}

If you could rework it so you're not calling gettime any additional
times, but still providing the same elapsed sleep time, then it would
atleast have the benefit of an improvement over my example here.

thanks
-john

