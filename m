Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754864Ab0JNHwv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 03:52:51 -0400
Received: from canuck.infradead.org ([134.117.69.58]:53341 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754794Ab0JNHwu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 03:52:50 -0400
Subject: Re: [PATCH v3 1/7] sched: introduce primitives to account for CFS
 bandwidth tracking
From: Peter Zijlstra <peterz@infradead.org>
To: balbir@linux.vnet.ibm.com
Cc: Bharata B Rao <bharata@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
        Dhaval Giani <dhaval.giani@gmail.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Pavel Emelyanov <xemul@openvz.org>,
        Herbert Poetzl <herbert@13thfloor.at>, Avi Kivity <avi@redhat.com>,
        Chris Friesen <cfriesen@nortel.com>, Paul Menage <menage@google.com>,
        Mike Waychison <mikew@google.com>, Paul Turner <pjt@google.com>,
        Nikhil Rao <ncrao@google.com>
In-Reply-To: <20101013130018.GC3914@balbir.in.ibm.com>
References: <20101012074910.GA9893@in.ibm.com>
	 <20101012075023.GB9893@in.ibm.com>
	 <20101013130018.GC3914@balbir.in.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 14 Oct 2010 09:52:17 +0200
Message-ID: <1287042737.29097.153.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-10-13 at 18:30 +0530, Balbir Singh wrote:

> > -static void start_rt_bandwidth(struct rt_bandwidth *rt_b)
> > +static void start_bandwidth_timer(struct hrtimer *period_timer, ktime_t period)
> >  {
> > -	ktime_t now;
> > +	unsigned long delta;
> > +	ktime_t soft, hard, now;
> > +
> > +	for (;;) {
> > +		if (hrtimer_active(period_timer))
> > +			break;
> > 
> > +		now = hrtimer_cb_get_time(period_timer);
> > +		hrtimer_forward(period_timer, now, period);
> > +
> > +		soft = hrtimer_get_softexpires(period_timer);
> > +		hard = hrtimer_get_expires(period_timer);
> > +		delta = ktime_to_ns(ktime_sub(hard, soft));
> > +		__hrtimer_start_range_ns(period_timer, soft, delta,
> > +					 HRTIMER_MODE_ABS_PINNED, 0);
> 
> This code can be replaced with
> 
> hrtimer_start_expires(period_timer, HRTIMER_MODE_ABS_PINNED) if we
> don't care about wakeup_softirq, is there a reason we prefer to keep
> wakeup as 0?

You cannot do wakeups while holding the rq->lock, can you? :-)

> > +	}
> > +}


> > +static enum hrtimer_restart sched_cfs_period_timer(struct hrtimer *timer)
> > +{
> > +	struct cfs_bandwidth *cfs_b =
> > +		container_of(timer, struct cfs_bandwidth, period_timer);
> > +	ktime_t now;
> > +	int overrun;
> > +	int idle = 0;
> > +
> > +	for (;;) {
> > +		now = hrtimer_cb_get_time(timer);
> > +		overrun = hrtimer_forward(timer, now, cfs_b->period);
> > +
> > +		if (!overrun)
> > +			break;
> 
> What is the significance of overrun? overrun is set when delta >
> interval. The logic seems to be that hrtimer is forwarded in steps of
> cfs_b->period till we reach the desired time.
> 

Overrun is the number of periods missed. The goal is to increment the
quota for each period, if the timer is late 3 periods, we still need to
increment it 3 times, that's what overrun does.

> > +
> > +		idle = do_sched_cfs_period_timer(cfs_b, overrun);
> > +	}
> > +
> > +	return idle ? HRTIMER_NORESTART : HRTIMER_RESTART;
> > +}

> > +static void start_cfs_bandwidth(struct cfs_bandwidth *cfs_b)
> > +{
> > +	if (cfs_b->quota == RUNTIME_INF)
> > +		return;
> > +
> > +	if (hrtimer_active(&cfs_b->period_timer))
> > +		return;
> 
> Why the double check, start_bandwidth_timer also checks this. Is it to
> avoid doing the check under cfs_b->lock?

Basically..

> > +
> > +	raw_spin_lock(&cfs_b->lock);
> > +	start_bandwidth_timer(&cfs_b->period_timer, cfs_b->period);
> > +	raw_spin_unlock(&cfs_b->lock);
> > +}
> > +

> > +#ifdef CONFIG_CFS_BANDWIDTH
> > +static int tg_set_cfs_bandwidth(struct task_group *tg, u64 period, u64 quota)
> > +{
> > +	int i;
> > +	static DEFINE_MUTEX(mutex);
> > +
> > +	if (tg == &init_task_group)
> > +		return -EINVAL;
> > +
> > +	if (!period)
> > +		return -EINVAL;
> > +
> > +	/*
> > +	 * Ensure we have at least one tick of bandwidth every period.  This is
> > +	 * to prevent reaching a state of large arrears when throttled via
> > +	 * entity_tick() resulting in prolonged exit starvation.
> > +	 */
> > +	if (NS_TO_JIFFIES(quota) < 1)
> > +		return -EINVAL;
> 
> I hope we document this in the Documentation :)

/me went and looked up arrears in a dictionary and wonders why 'debt'
wasn't good enough.

> > +
> > +	mutex_lock(&mutex);
> > +	raw_spin_lock_irq(&tg->cfs_bandwidth.lock);
> > +	tg->cfs_bandwidth.period = ns_to_ktime(period);
> > +	tg->cfs_bandwidth.runtime = tg->cfs_bandwidth.quota = quota;
> > +	raw_spin_unlock_irq(&tg->cfs_bandwidth.lock);
> > +
> > +	for_each_possible_cpu(i) {
> 
> Why not for_each_online_cpu()?

Probably could be cured with a hotplug handler, but then you need to
track more state iirc.

> > +		struct cfs_rq *cfs_rq = tg->cfs_rq[i];
> > +		struct rq *rq = rq_of(cfs_rq);
> > +
> > +		raw_spin_lock_irq(&rq->lock);
> > +		init_cfs_rq_quota(cfs_rq);
> > +		raw_spin_unlock_irq(&rq->lock);
> > +	}
> > +	mutex_unlock(&mutex);
> > +
> > +	return 0;
> > +}

