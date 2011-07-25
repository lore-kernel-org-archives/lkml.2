Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752592Ab1GYVRO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 17:17:14 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:33072 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751772Ab1GYVRL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 17:17:11 -0400
Date: Mon, 25 Jul 2011 14:17:06 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Carsten Emde <ce@ceag.ch>,
        Clark Williams <williams@redhat.com>,
        Kumar Gala <galak@gate.crashing.org>,
        Ralf Baechle <ralf@linux-mips.org>, rostedt <rostedt@goodmis.org>
Subject: Re: On migrate_disable() and latencies
Message-ID: <20110725211706.GT2327@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1311329992.27400.23.camel@twins>
 <20110723003934.GP2382@linux.vnet.ibm.com>
 <1311582653.2617.49.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1311582653.2617.49.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 25, 2011 at 10:30:53AM +0200, Peter Zijlstra wrote:
> On Fri, 2011-07-22 at 17:39 -0700, Paul E. McKenney wrote:
> > > Therefore the worst case latency is in the order of
> > > max-migrate-disable-period * nr-cpus.
> > 
> > OK, but wouldn't that be the latency as seen be the lowest-priority
> > task?  
> 
> It would indeed, the utility loss is added to the preemption cost of the
> lower priority tasks.

OK.

> > Or are migrate-disable tasks given preferential treatment?
> > If not, a prio-99 task would get the same latency either way, right?
> 
> Right.
> 
> > Migration-disable can magnify the latency seen by low-priority tasks, if
> > I understand correctly.  If you disabled preemption, when a low-priority
> > task became runnable, it would find an idle CPU.  But with migration
> > disable, the lowest-priority task might enter a migration-disable region,
> > then be preempted by a marginally higher-priority task that also enters
> > a migration-diable region, and is also preempted, and so on.  The
> > lowest-priority task cannot run on the current CPU because of all
> > the higher-priority tasks, and cannot migrate due to being in a
> > migration-disable section.
> 
> Exactly so.
> 
> > In other words, as is often the case, better worst-case service to
> > the high-priority tasks can multiply the latency seen by the
> > low-priority tasks.
> > 
> > So is the topic to quantify this?  
> 
> I suppose it is indeed. Even for the SoftRT case we need to make sure
> the total utilization loss is indeed acceptable.

OK.  If you are doing strict priority, then everything below the highest
priority is workload dependent.  OK, OK, given Linux's throttling,
everything below the two highest priorities is workload dependent
(assuming I understand the throttling correctly).  The higher-priority
tasks can absolutely starve the lower-priority ones, with or without
the migrate-disable capability.

Another way of looking at it is from the viewpoint of the additional
priority-boost events.  If preemption is disabled, the low-priority task
will execute through the preempt-disable region without context switching.
In contrast, given a migration-disable region, the low-priority task
might be preempted and then boosted.  (If I understand correctly, if some
higher-priority task tries to enter the same type of migration-disable
region, it will acquire the associated lock, thus priority-boosting the
task that is already in that region.)

One stupid-but-tractable way to model this is to have an interarrival
rate for the various process priorities, and then calculate the odds of
(1) a higher priority process arriving while the low-priority one is
in a *-disable region and (2) that higher priority process needing to
enter a conflicting *-disable region.  This would give you some measure
of the added boosting load due to migration-disable as compared to
preemption-disable.

Would this sort of result be useful?

> > If so, my take is that the latency
> > to the highest-priority task decreases by an amount roughly equal to
> > the duration of the longest preempt_disable() region that turned into a
> > migration-disable region, while that to the lowest-priority task increases
> > by N-1 times the CPU overhead of the longest migration-disable region,
> > plus context switches.  (Yes, this is a very crude rule-of-thumb model.
> > A real model would have much higher mathematics and might use a more
> > detailed understanding of the workload.)
> > 
> > Or am I misunderstanding how all this works? 
> 
> No, I think you're gettin' it.

I was afraid of that.  ;-)

> My main worry with all this is that we have these insane long !preempt
> regions in mainline that are now !migrate regions, and thus per all the
> above we could be looking at a substantial utilization loss.
> 
> Alternatively we could all be missing something far more horrid, but
> that might just be my paranoia talking.

Ah, good point -- if each migration-disable region is associated with
a lock, then you -could- allow migration and gain better utilization
at the expense of worse caching behavior.  Is that the concern?

							Thanx, Paul
