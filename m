Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755012Ab1KSEJD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 23:09:03 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:47547 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751457Ab1KSEJB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 23:09:01 -0500
Date: Sat, 19 Nov 2011 12:08:37 +0800
From: Yong Zhang <yong.zhang0@gmail.com>
To: Jeff Ohlstein <johlstei@codeaurora.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] hrtimer: Fix extra wakeups from __remove_hrtimer()
Message-ID: <20111119040836.GA1885@zhy>
Reply-To: Yong Zhang <yong.zhang0@gmail.com>
References: <1321660030-8520-1-git-send-email-johlstei@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1321660030-8520-1-git-send-email-johlstei@codeaurora.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 18, 2011 at 03:47:10PM -0800, Jeff Ohlstein wrote:
> __remove_hrtimer() attempts to reprogram the clockevent device when
> the timer being removed is the next to expire. However,
> __remove_hrtimer() reprograms the clockevent *before* removing the
> timer from the timerqueue and thus when hrtimer_force_reprogram()
> finds the next timer to expire it finds the timer we're trying to
> remove.
> 
> This is especially noticeable when the system switches to NOHz mode
> and the system tick is removed. The timer tick is removed from the
> system but the clockevent is programmed to wakeup in another HZ
> anyway.

Reduced one needless call of hrtimer_interrupt() indeed.

> 
> Silence the extra wakeup by removing the timer from the timerqueue
> before calling hrtimer_force_reprogram() so that we actually program
> the clockevent for the next timer to expire.
> 
> This was broken by 998adc3 "hrtimers: Convert hrtimers to use
> timerlist infrastructure".

The issue also exists before 998adc3.

Apart from that.

Reviewed-by: Yong Zhang <yong.zhang0@gmail.com>

> 
> Signed-off-by: Jeff Ohlstein <johlstei@codeaurora.org>
> ---
>  kernel/hrtimer.c |    6 ++++--
>  1 files changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
> index 422e567..ae34bf5 100644
> --- a/kernel/hrtimer.c
> +++ b/kernel/hrtimer.c
> @@ -885,10 +885,13 @@ static void __remove_hrtimer(struct hrtimer *timer,
>  			     struct hrtimer_clock_base *base,
>  			     unsigned long newstate, int reprogram)
>  {
> +	struct timerqueue_node *next_timer;
>  	if (!(timer->state & HRTIMER_STATE_ENQUEUED))
>  		goto out;
>  
> -	if (&timer->node == timerqueue_getnext(&base->active)) {
> +	next_timer = timerqueue_getnext(&base->active);
> +	timerqueue_del(&base->active, &timer->node);
> +	if (&timer->node == next_timer) {
>  #ifdef CONFIG_HIGH_RES_TIMERS
>  		/* Reprogram the clock event device. if enabled */
>  		if (reprogram && hrtimer_hres_active()) {
> @@ -901,7 +904,6 @@ static void __remove_hrtimer(struct hrtimer *timer,
>  		}
>  #endif
>  	}
> -	timerqueue_del(&base->active, &timer->node);
>  	if (!timerqueue_getnext(&base->active))
>  		base->cpu_base->active_bases &= ~(1 << base->index);
>  out:
> -- 
> Sent by an employee of the Qualcomm Innovation Center, Inc.
> The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
