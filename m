Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751809Ab1GWHWL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jul 2011 03:22:11 -0400
Received: from www.linutronix.de ([62.245.132.108]:52567 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751673Ab1GWHWI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jul 2011 03:22:08 -0400
Date: Sat, 23 Jul 2011 09:22:06 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andrew Morton <akpm@linux-foundation.org>
cc: LKML <linux-kernel@vger.kernel.org>, John Stultz <john.stultz@linaro.org>,
        Ingo Molnar <mingo@elte.hu>, Ben Greear <greearb@candelatech.com>,
        stable@kernel.org
Subject: Re: [patch 2/3] rtc: Fix hrtimer deadlock
In-Reply-To: <20110722151107.e1c9996d.akpm@linux-foundation.org>
Message-ID: <alpine.LFD.2.02.1107230917160.2702@ionos>
References: <20110722091011.717194327@linutronix.de> <20110722091045.476900421@linutronix.de> <20110722151107.e1c9996d.akpm@linux-foundation.org>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 Jul 2011, Andrew Morton wrote:

> On Fri, 22 Jul 2011 09:12:51 -0000
> Thomas Gleixner <tglx@linutronix.de> wrote:
> 
> > Ben reported a lockup related to rtc. The lockup happens due to:
> > 
> > CPU0                                        CPU1
> > 
> > rtc_irq_set_state()			    __run_hrtimer()	
> >   spin_lock_irqsave(&rtc->irq_task_lock)    rtc_handle_legacy_irq();
> > 					      spin_lock(&rtc->irq_task_lock);
> >   hrtimer_cancel()
> >     while (callback_running);
> > 
> > So the running callback never finishes as it's blocked on
> > rtc->irq_task_lock.  
> > 
> > Use hrtimer_try_to_cancel() instead and drop rtc->irq_task_lock while
> > waiting for the callback. Fix this for both rtc_irq_set_state() and
> > rtc_irq_set_freq().
> > 
> > ...
> >
> > +static int rtc_update_hrtimer(struct rtc_device *rtc, int enabled)
> > +{
> > +	/*
> > +	 * We unconditionally cancel the timer here, because otherwise
> 
> The comment seems wrong.  If hrtimer_try_to_cancel() fails, we simply
> bale out so we did not "unconditionally cancel the timer"?

Well, what I meant is that we cancel it before we start it. That's
required for self rearming timers. Will reword.
 
> > +	 * we could run into BUG_ON(timer->state != HRTIMER_STATE_CALLBACK);
> > +	 * when we manage to start the timer before the callback
> > +	 * returns HRTIMER_RESTART.
> > +	 *
> > +	 * We cannot use hrtimer_cancel() here as a running callback
> > +	 * could be blocked on rtc->irq_task_lock and hrtimer_cancel()
> > +	 * would spin forever.
> > +	 */
> > +	if (hrtimer_try_to_cancel(&rtc->pie_timer) < 0)
> > +		return -1;
> > +
> > +	if (enabled) {
> > +		ktime_t period = ktime_set(0, NSEC_PER_SEC / rtc->irq_freq);
> > +
> > +		hrtimer_start(&rtc->pie_timer, period, HRTIMER_MODE_REL);
> > +	}
> > +	return 0;
> > +}
> > +
> >  /**
> >   * rtc_irq_set_state - enable/disable 2^N Hz periodic IRQs
> >   * @rtc: the rtc device
> > @@ -651,24 +674,21 @@ int rtc_irq_set_state(struct rtc_device 
> >  	int err = 0;
> >  	unsigned long flags;
> >  
> > +retry:
> >  	spin_lock_irqsave(&rtc->irq_task_lock, flags);
> >  	if (rtc->irq_task != NULL && task == NULL)
> >  		err = -EBUSY;
> >  	if (rtc->irq_task != task)
> >  		err = -EACCES;
> > -	if (err)
> > -		goto out;
> > -
> > -	if (enabled) {
> > -		ktime_t period = ktime_set(0, NSEC_PER_SEC/rtc->irq_freq);
> > -		hrtimer_start(&rtc->pie_timer, period, HRTIMER_MODE_REL);
> > -	} else {
> > -		hrtimer_cancel(&rtc->pie_timer);
> > +	if (!err) {
> > +		if (rtc_update_hrtimer(rtc, enabled) < 0) {
> > +			spin_unlock_irqrestore(&rtc->irq_task_lock, flags);
> > +			cpu_relax();
> > +			goto retry;
> > +		}
> > +		rtc->pie_enabled = enabled;
> 
> Well this is rather nasty.  Sort of an open-coded expensive spinlock. 
> All rather pointless on SMP=n builds, too.
> 
> Is there no better way, such as fixing up the locking properly?

Probably there is, but that requires a rather large patch and a
complete locking rewrite, nothing you want to push back into
stable. And we want this as the deadlock has been observed and
reported already.

