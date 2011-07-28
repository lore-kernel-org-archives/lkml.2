Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755576Ab1G1MGL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 08:06:11 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:54121 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754366Ab1G1MGG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 08:06:06 -0400
Date: Thu, 28 Jul 2011 05:05:54 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Nicholas Mc Guire <der.herr@hofr.at>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Carsten Emde <ce@ceag.ch>,
        Clark Williams <williams@redhat.com>,
        Kumar Gala <galak@gate.crashing.org>,
        Ralf Baechle <ralf@linux-mips.org>, rostedt <rostedt@goodmis.org>
Subject: Re: On migrate_disable() and latencies
Message-ID: <20110728120554.GA2427@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1311329992.27400.23.camel@twins>
 <20110723003934.GP2382@linux.vnet.ibm.com>
 <1311582653.2617.49.camel@laptop>
 <20110725211706.GT2327@linux.vnet.ibm.com>
 <1311765198.24752.437.camel@twins>
 <20110727183008.GA2407@linux.vnet.ibm.com>
 <20110728075435.GA13833@opentech.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110728075435.GA13833@opentech.at>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 28, 2011 at 09:54:37AM +0200, Nicholas Mc Guire wrote:
> On Wed, 27 Jul 2011, Paul E. McKenney wrote:
> 
> > On Wed, Jul 27, 2011 at 01:13:18PM +0200, Peter Zijlstra wrote:
> > > On Mon, 2011-07-25 at 14:17 -0700, Paul E. McKenney wrote:
> > > 
> > > > > I suppose it is indeed. Even for the SoftRT case we need to make sure
> > > > > the total utilization loss is indeed acceptable.
> > > > 
> > > > OK.  If you are doing strict priority, then everything below the highest
> > > > priority is workload dependent. 
> > > 
> > > <snip throttling, that's a whole different thing>
> > > 
> > > >  The higher-priority
> > > > tasks can absolutely starve the lower-priority ones, with or without
> > > > the migrate-disable capability.
> > > 
> > > Sure, that's how FIFO works, but it also relies on the fact that once
> > > your high priority task completes the lower priority task resumes.
> > > 
> > > The extension to SMP is that we run the m highest priority tasks on n
> > > cpus ; where m <= n. Any loss in utilization (idle time in this
> > > particular case, but irq/preemption/migration and cache overhead are
> > > also time not spend on the actual workload.
> > > 
> > > Now the WCET folks are all about quantifying the needs of applications
> > > and the utilization limits of the OS etc. And while for SoftRT you can
> > > relax quite a few of the various bounds you still need to know them in
> > > order relax them (der Hofrat likes to move from worst case to avg case
> > > IIRC).
> 
> its not about worst case vs. average case its about using the distribution
> rather than boundary values - boundary values are hard to correlate with
> specific events.
> 
> > ;-)
> > 
> > > > Another way of looking at it is from the viewpoint of the additional
> > > > priority-boost events.  If preemption is disabled, the low-priority task
> > > > will execute through the preempt-disable region without context switching.
> > > > In contrast, given a migration-disable region, the low-priority task
> > > > might be preempted and then boosted.  (If I understand correctly, if some
> > > > higher-priority task tries to enter the same type of migration-disable
> > > > region, it will acquire the associated lock, thus priority-boosting the
> > > > task that is already in that region.)
> > > 
> > > No, there is no boosting involved, migrate_disable() isn't intrinsically
> > > tied to a lock or other PI construct. We might needs locks to keep some
> > > of the per-cpu crap correct, but that again, is a whole different ball
> > > game.
> > > 
> > > But even if it was, I don't think PI will help any for this, we still
> > > need to complete the various migrate_disable() sections, see below.
> > 
> > OK, got it.  I think, anyway.  I was incorrectly (or at least unhelpfully)
> > pulling in locks that might be needed to handle per-CPU variables.
> > 
> > > > One stupid-but-tractable way to model this is to have an interarrival
> > > > rate for the various process priorities, and then calculate the odds of
> > > > (1) a higher priority process arriving while the low-priority one is
> > > > in a *-disable region and (2) that higher priority process needing to
> > > > enter a conflicting *-disable region.  This would give you some measure
> > > > of the added boosting load due to migration-disable as compared to
> > > > preemption-disable.
> > > > 
> > > > Would this sort of result be useful?
> > > 
> > > Yes, such type of analysis can be used, and I guess we can measure
> > > various variables related to that.
> > 
> > OK, good.
> > 
> > > > > My main worry with all this is that we have these insane long !preempt
> > > > > regions in mainline that are now !migrate regions, and thus per all the
> > > > > above we could be looking at a substantial utilization loss.
> > > > > 
> > > > > Alternatively we could all be missing something far more horrid, but
> > > > > that might just be my paranoia talking.
> > > > 
> > > > Ah, good point -- if each migration-disable region is associated with
> > > > a lock, then you -could- allow migration and gain better utilization
> > > > at the expense of worse caching behavior.  Is that the concern?
> > > 
> > > I'm not seeing how that would be true, suppose you have this stack of 4
> > > migrate_disable() sections and 3 idle cpus, no amount of boosting will
> > > make the already running task at the top of the stack go any faster, and
> > > it needs to complete the migrate_disable section before it can be
> > > migrated, equally so for the rest, so you still need
> > > 3*migrate-disable-period of time before all your cpus are busy again.
> > > 
> > > You can move another task to the top of the stack by boosting, but
> > > you'll need 3 tasks to complete their resp migrate-disable section, it
> > > doesn't matter which task, so boosting doesn't change anything.
> > 
> > OK, so let me see if I understand what you are looking to model.
> > 
> > o	There are no locks.
> > 
> > o	There are a finite number of tasks with varying priorities.
> > 	(I would initially work with a single task per priority
> > 	level, but IIRC it is not hard to make multiple tasks per
> > 	priority work.  Not a fan of infinite numbers of priorities,
> > 	though!)
> > 
> > o	There are multiple CPUs.
> > 
> > o	Once a task enters a migrate-disable region, it must remain
> > 	on that CPU.  (I will initially model the migrate-disable region
> > 	as consuming a fixed amount of CPU.  If I wanted to really wuss
> > 	out, I would model it as consuming an exponentially distributed
> > 	amount of CPU.)
> > 
> > o	Tasks awakening outside of migrate-disable regions will pick
> > 	the CPU running the lowest-priority task, whether or not this
> > 	task is in migrate-disable state.  (At least I don't see
> > 	anything in 3.0-rt3 that looks like a scheduling decision
> > 	based on ->migrate_disable, perhaps due to blindness.)
> 
> This might be a simple heuristics to minimize the probability of stacking
> in the first place.

Indeed, one heuristic would be to preferentially preempt a CPU without
any runnable migrate-disable tasks, for example, use migrate-disable
as another bit in the priority comparison -- if two CPUs at a given
priority are available, preempt the one without the migrate-disable
runnable task.

But Peter would probably want to know how effective that would be.

> > o	For an example, if all CPUs except for one are running prio-99
> > 	tasks, and the remaining CPU is running a prio-1 task in
> > 	a migrate-disable region, if a prio-2 tasks awakens, it
> > 	will preempt the prio-1 task.
> 
> all CPUs utilized so no utilization loss at all in that szenario 
> 
> > 	On the other hand, if at least one of the CPUs was idle,
> > 	the prio-2 task would have instead run on that idle CPU.
> 
> so what you need to add to the model is the probability of the transitional
> event:
> 
>    * prio-2 task preempts prio-1 task because all CPUs are idle

s/idle/busy/, correct?

>    * atleast one CPU becomes idle while prio-1 task is blocked for migration
>      due to migrate-disable + preemted by prio-2 task
> 
> only in this combination does the system suffer a utilization penalty.

Yep!  Or at least has its priority drop to below prio-1, for example,
starts running a non-realtime task, but yes.

> > o	The transition probabilities depend on the priority
> > 	of the currently running migrate-disable CPU -- the higher
> > 	that priority, the greater the chance that any preempting
> > 	task will find some other CPU instead.
> > 
> > 	The recurrence times depend on the number of tasks stacked
> > 	up in migrate-disable regions on that CPU.
> > 
> > If this all holds, it would be possible to compute the probability
> > of a given migrate-disable region being preempted and if preempted,
> > the expected duration of that preemption, given the following
> > quantities as input:
> > 
> > o	The probability that a given CPU is running a task
> > 	of priority P for each priority.  The usual way to
> > 	estimate this is based on per-thread CPU utilizations.
> > 
> > o	The expected duration of migrate-disable regions.
> > 
> > o	The expected wakeups per second for tasks of each priority.
> > 
> > With the usual disclaimers about cheezy mathematical approximations
> > of reality and all that.
> > 
> > Would this be useful, or am I still missing the point?
> 
> to get an estimation of the latency impact - but to get a estimate of the
> impact on system utilization you would need to include the probability that a 
> different CPU is idle in the system and would in principle allow running
> one of the tasks that can'b be migrated. As I understood it, the initial 
> questions was if migrate_disable has a relevant impact on system utilization
> in multicore systems. For this question I guess two of the key parameters are
> 
>  * probability that migrate-disable stacking occures 
>  * probability of a idle CPU transition while stacking persists

Or at least the probability of a CPU transitioning to a lower
priority than one of the migrate-disable tasks.

> I guess the probability of an idle transition of a CPU is hard to model as it
> is very profile specific.

It is profile specific, but the transition probabilities could be
collected.

One approach is to extend the model all of the CPUs.  If we ignore
non-RT tasks, and if there is one task per priority per CPU, then the
data required for tasks is the transition probabilities between blocked,
running, and migrate-disable modes.  The state of a given task must
also include the CPU if in migrate-disable mode.  Then the "badness" of
the migrate-disable scheme would be the probability of being in states
where a migrate-disable task on one processor was preempted by
migrate-disable tasks on that same processor, and where some other
processor was running a lower-priority task.

This does do a bit of combinatorial explosion, but is tractable for small
numbers of CPUs and tasks.  For example, four tasks on two CPUs gives
256 states:  there are four tasks, and each task can be idle, running,
or running in migrate-disable on either of the two CPUs, so 4^4 states.
This is more than I want to draw, but could be handled automatically.
Debugging and validation of the model would be a bit of a pain, of course.
And approximation of transition probabilities with an exponential 
distribution seems warranted.

For N CPUs and T tasks with P possible priorities (so that T
is equal to N*P), the number of states is given by:

	S = (N+2)^(N*P)

I could expect to calculate probabilities only for this tiniest model,
and maybe 3 CPUs with two priorities, because that involves an SxS matrix.
Unless there is some good sparse-matrix software out there.

But this gives a measure of under-utilization, along with failure to run
a high-priority task (due to its being migrate-disable) while a CPU is
running a lower-priority task.

I bet it is possible to make use of expected transition times: if in a
"badness" state, how long to get to a non-"badness" state?  This should
require memory size proportional to the number of states rather than to
the square of the number of states.  This would permit looking at
somewhat larger (though still quite small) scenarios.

Thoughts?

							Thanx, Paul
