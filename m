Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757560Ab0DFS75 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 14:59:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41493 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757084Ab0DFS7v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 14:59:51 -0400
Date: Tue, 6 Apr 2010 14:59:38 -0400
From: Don Zickus <dzickus@redhat.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: mingo@elte.hu, peterz@infradead.org, gorcunov@gmail.com, aris@redhat.com,
       linux-kernel@vger.kernel.org
Subject: Re: [watchdog] combine nmi_watchdog and softlockup
Message-ID: <20100406185938.GT15159@redhat.com>
References: <20100323213338.GA29170@redhat.com>
 <20100406141321.GA8416@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100406141321.GA8416@nowhere>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 06, 2010 at 04:13:30PM +0200, Frederic Weisbecker wrote:
> On Tue, Mar 23, 2010 at 05:33:38PM -0400, Don Zickus wrote:
> > +/* Callback function for perf event subsystem */
> > +void watchdog_overflow_callback(struct perf_event *event, int nmi,
> > +		 struct perf_sample_data *data,
> > +		 struct pt_regs *regs)
> > +{
> > +	int this_cpu = smp_processor_id();
> > +	unsigned long touch_ts = per_cpu(watchdog_touch_ts, this_cpu);
> > +	int duration;
> > +
> > +	if (touch_ts == 0) {
> > +		__touch_watchdog();
> > +		return;
> > +	}
> > +
> > +	/* check for a hardlockup
> > +	 * This is done by making sure our timer interrupt
> > +	 * is incrementing.  The timer interrupt should have
> > +	 * fired multiple times before we overflow'd.  If it hasn't
> > +	 * then this is a good indication the cpu is stuck
> > +	 */
> > +	if (is_hardlockup(this_cpu)) {
> > +		if (hardlockup_panic)
> > +			panic("Watchdog detected hard LOCKUP on cpu %d", this_cpu);
> > +		else
> > +			WARN(1, "Watchdog detected hard LOCKUP on cpu %d", this_cpu);
> 
> 
> 
> panic is going to endless loop so this is fine.
> But if you only warn, the path continues, and if you have a
> hardlockup then you also have a softlockup, which will probably
> warn in turn, making the hardlockup report to vanish. But if
> any hardlockup, its report is much more important as it is the real point,
> a softlockup that follows is only a consequence of the hardlockup.

Good point.

> 
> Btw, you don't have any cpumask that keeps track of the cpus
> that have warned already?

No I haven't implemented that.  I'll add that to my todo list.

> 
> 
> > +static int watchdog_enable(int cpu)
> > +{
> > +	struct perf_event_attr *wd_attr;
> > +	struct perf_event *event = per_cpu(watchdog_ev, cpu);
> > +	struct task_struct *p = per_cpu(softlockup_watchdog, cpu);
> > +
> > +	/* is it already setup and enabled? */
> > +	if (event && event->state > PERF_EVENT_STATE_OFF)
> > +		goto out;
> > +
> > +	/* it is setup but not enabled */
> > +	if (event != NULL)
> > +		goto out_enable;
> > +
> > +	/* Try to register using hardware perf events first */
> > +	wd_attr = &wd_hw_attr;
> > +	wd_attr->sample_period = hw_nmi_get_sample_period();
> > +	event = perf_event_create_kernel_counter(wd_attr, cpu, -1, watchdog_overflow_callback);
> > +	if (!IS_ERR(event)) {
> > +		printk(KERN_INFO "NMI watchdog enabled, takes one hw-pmu counter.\n");
> > +		goto out_save;
> > +	}
> > +
> > +	/* hardware doesn't exist or not supported, fallback to software events */
> > +	printk(KERN_INFO "NMI watchdog: hardware not available, trying software events\n");
> > +	wd_attr = &wd_sw_attr;
> > +	wd_attr->sample_period = softlockup_thresh * NSEC_PER_SEC;
> > +	event = perf_event_create_kernel_counter(wd_attr, cpu, -1, watchdog_overflow_callback);
> 
> 
> 
> I fear the cpu clock is not going to help you detecting any hard lockups.
> If you're stuck in an interrupt or an irq disabled loop, your cpu clock is
> not going to fire.

Yup.  I put that in the changelog of some nmi code I posted a few weeks
ago.  I believe Ingo was looking to have a fallback plan in case hw perf
events wasn't available.

With this code, moving to sw perf events, kinda kills the ability to
detect hard lockups, but you can still detect softlockups.

Cheers,
Don
