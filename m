Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758082Ab2GKPS0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 11:18:26 -0400
Received: from www.linutronix.de ([62.245.132.108]:33653 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755751Ab2GKPSY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 11:18:24 -0400
Date: Wed, 11 Jul 2012 17:18:15 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
cc: Prarit Bhargava <prarit@redhat.com>, John Stultz <johnstul@us.ibm.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, stable@vger.kernel.org
Subject: Re: [PATCH 1/6] hrtimer: Provide clock_was_set_delayed()
In-Reply-To: <1342011904.3462.152.camel@twins>
Message-ID: <alpine.LFD.2.02.1207111539060.32033@ionos>
References: <1341960205-56738-1-git-send-email-johnstul@us.ibm.com>  <1341960205-56738-2-git-send-email-johnstul@us.ibm.com>  <4FFD6E5A.9060206@redhat.com> <alpine.LFD.2.02.1207111425260.32033@ionos> <1342011904.3462.152.camel@twins>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Jul 2012, Peter Zijlstra wrote:
> On Wed, 2012-07-11 at 14:45 +0200, Thomas Gleixner wrote:
> > On Wed, 11 Jul 2012, Prarit Bhargava wrote:
> > > On 07/10/2012 06:43 PM, John Stultz wrote:
> > > > clock_was_set() cannot be called from hard interrupt context because
> > > > it calls on_each_cpu(). For fixing the widely reported leap seconds
> > > > issue it's necessary to call it from the timer interrupt context.
> > > > 
> > > > Provide a new function which denotes it in the hrtimer cpu base
> > > > structure of the cpu on which it is called and raising the timer
> > > > softirq.
> > > > 
> > > > We then execute the clock_was_set() notificiation in the timer softirq
> > > > context in hrtimer_run_pending().
> > > 
> > > I wish there was a nicer way to do this ... but looking at the code I can't
> > > figure out a better way.  (no offense John, it's just the way the code is ;) )
> > 
> > Yeah, I had the same discussion with Peter earlier today. There is
> > only a rather limited set of options.
> > 
> > 1) Retrigger the timer interrupt vectors on all CPUs - except the one
> >    we are running on, but we have no interface for that at the moment
> > 
> > 2) Do the nasty __smp_call_function_single() hack
> > 
> >    Preallocate call_single_data for all cpus and do a
> >    __smp_call_function_single() on all online cpus.
> > 
> >    This can be called from hard interrupt context or irq disabled
> >    regions.
> > 
> >    That would allow to get rid of the whole delay magic all
> >    together.
> > 
> > Thoughts?
> 
> The __smp_call_function_single() thing isn't particularly pretty either
> and a lot more code to boot.. 
> 
> static DEFINE_PER_CPU(struct call_single_data, cws_csd);
> 
> void clock_was_set(void)
> {
> 	int cpu;
> 
> 	for_each_online_cpu(cpu) {
> 		struct call_single_data *csd = &per_cpu(cws_csd, cpu);
> 
> 		if (csd->flags & CSD_FLAG_LOCK)
> 			continue; /* a pending request is good enough */
> 
> 		csd->func = retrigger_next_event;
> 
> 		__smp_call_function_single(cpu, csd, 0);
> 	}
> 
> 	timerfd_clock_was_set();
> }
> 
> It also is a for_each_cpu loop with preemption disabled, not pretty :/

Right. I think with the atomic update of the offset in the timer
interrupt we are on the safe side. The main problem of timers expiring
early forever is covered by this.

Thinking more about it.

If time goes backwards, then the IPI is pointless. The already armed
clockevent device will fire too early, hrtimer_interrupt will update
and just rearm it. That's one "spurious" event.

So we only need it in the case of time going forward. 

Though with the leap second the maximum observable delay is 1 second
on a completely idle core. Surely nothing to worry about for an event
which happens rarely. So we could safely avoid the whole delayed
business and just do the timerfd notification, though I wonder if even
that is necessary in the leap second case.

On NOHZ=n systems the IPI is pointless as well. The maximum lateness
will be 10ms for HZ=100. Nothing we should worry about.

That leaves NOHZ enabled systems and there we might be clever and
avoid the IPIs to those cores which are not idle and let the tick
interrupt deal with it. And we can make the calls async and just let
them raise the hrtimer softirq on those cores, which will run the
hrtimer interrupt code and take care of everything.

Thoughts?

	tglx




