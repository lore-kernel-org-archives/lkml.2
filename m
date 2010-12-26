Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751605Ab0LZHXN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Dec 2010 02:23:13 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:48620 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1751385Ab0LZHXM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Dec 2010 02:23:12 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/znD8goEbzZCqRj4SY2l43uNP16XRLB3R7RMcUwu
	U+nXtLkDRGn0le
Subject: Re: [PATCH] sched: Buggy comparison in check_preempt_tick
From: Mike Galbraith <efault@gmx.de>
To: Venkatesh Pallipadi <venki@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org, Ranjit Manomohan <ranjitm@google.com>
In-Reply-To: <AANLkTintN2e-NHB=USQ4RSi1LMrC8TxB7BB0MNpPscSB@mail.gmail.com>
References: <1293236813-31550-1-git-send-email-venki@google.com>
	 <1293263418.6896.54.camel@marge.simson.net>
	 <AANLkTintN2e-NHB=USQ4RSi1LMrC8TxB7BB0MNpPscSB@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 26 Dec 2010 08:23:04 +0100
Message-ID: <1293348184.6942.72.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-12-25 at 16:05 -0800, Venkatesh Pallipadi wrote: 
> On Fri, Dec 24, 2010 at 11:50 PM, Mike Galbraith <efault@gmx.de> wrote:
> > On Fri, 2010-12-24 at 16:26 -0800, Venkatesh Pallipadi wrote:
> >> A preempt comparison line in check_preempt_tick has two bugs.
> >> * It compares signed and unsigned quantities, which breaks when signed
> >>   quantity happens to be negative
> >
> > Oops, that's a bug.
> >
> >> * It compares runtime and vruntime, which breaks when there are niced tasks
> >
> > This imho isn't.
> >
> > vruntimes advance at different rates for differently weighted tasks, so
> > they're already weighted, as is ideal_runtime.
> >
> > For wakeup preemption we use wakeup_gran() as the weighted ruler to
> > limit spread.  This test just uses a different weighted ruler for the
> > same purpose at tick time, one already computed.
> >
> > If you're a heavily niced task, you were very likely booted before you
> > got this far.  If you haven't run for considerable wall time, you won't
> > get further, you keep on running.  You only get booted if giving you a
> > full wall slice will spread vruntimes too much, for which you'll pay if
> > you keep running, and leftmost will pay now if we don't boot you.
> >
> 
> May be I am all confused.
> - se->vruntime update in __update_curr() is based on
> delta_exec_weighted ( i.e., calc_delta_fair(delta_exec, curr) with
> delta_exec being wall clock time.

Yeah, vruntime is weighted, delta exec is not.

> - We have earlier in check_preempt_tick(), ideal_runtime getting
> compared with delta exec, which is wall clock time

Yeah, you can't run uninterrupted longer than your (weighted!) portion
of the latency target.

[to meet that target, you must be using HRTICK, and even precise tick
(precise? slice can change many times between timer set/fire yes?) won't
help your _wakeup_ latency target.] 

> - delta in check_preempt_tick is se->vruntime difference, which should
> be the weighted time and comparing that with ideal_runtime (which is
> compared with wall clock earlier) seems wrong.

What is sched_wakeup_granularity, and why is it different than
sched_latency?  Why is it OK to scale sched_wakeup_granularity, and use
it as a caliper, and NOT OK to scale sched_latency (which is what
__sched_period() returns, and sched_slice() scales) to do the same?

> This is debug output with trace_printk outside this if statement and
> if based on (s64)ideal_runtime.
> Task 17807 is nice 0 task and task 6363 is nice -2.
> Ideal slice for Task 17807 is 8168151
> Ideal slice for Task 6363 is 15798460
> <...>-17807 [002] 15851.352247: task_tick_fair: delta 3538447 rt
> 8168151 vrt 10200199
> <...>-17807 [002] 15851.353246: task_tick_fair: delta 4799848 rt
> 8168151 vrt 10200199
> <...>-17807 [002] 15851.354245: task_tick_fair: delta 6036141 rt
> 8168151 vrt 10200199
> <...>-17807 [002] 15851.355244: task_tick_fair: delta 7297361 rt
> 8168151 vrt 10200199
> <...>-17807 [002] 15851.356244: task_tick_fair: delta 8546469 rt
> 8168151 vrt 10200199
> 
> Here delta is increasing faster than wall time due to relative lower
> nice value of this task and we are comparing this delta with
> ideal_slice, which is wall clock time and hence we preempt this task
> earlier. No?

Is preempting sooner a bad thing if there's large spread?  It'll keep
him from having to wait so long for his next bit of CPU.

What the thing is supposed to help is this: wakeup happens just after a
hog gets the CPU, the wakee doesn't quite have enough lag to preempt, so
has to wait for nearly a full slice to get service.  That increases
spread, inducing latency spikes.

What would make more sense to me would be to use the exact same criteria
for wakeup/tick preemption, and do away with some knobs, just treat the
tick as nothing but another preemption opportunity.  Set your spread
target knob, and that's it.

But anyway..

echo NO_WAKEUP_PREEMPT > sched_features
echo NO_TESTME > sched_features
two hogs running on isolcpu 3, pid 6890 at nice -2

while sleep 1; do  grep 'pert.*6890' /proc/sched_debug; done

runnable tasks:
            task   PID         tree-key  switches  prio
-------------------------------------------------------
R           pert  6890     50201.071851      7453   118
R           pert  6890     50596.171290      7513   118  +60
R           pert  6890     50991.265264      7572   118  +59
R           pert  6890     51383.781965      7631   118  +59
            pert  6890     51781.463129      7691   118  +60

echo TESTME > sched_features
            pert  6890    126881.306733     18977   118
R           pert  6890    127273.825719     19036   118  +59
R           pert  6890    127668.928218     19095   118  +59
R           pert  6890    128064.031372     19154   118  +59
R           pert  6890    128459.134339     19213   118  +59

...with a compute load, the thing should be a noop, and appears to be so
(with busted compare fixed anyway;).  You have to be well overloaded for
buddies to kick in these days, so it's probably pretty hard to get
enough spread for the thing to fire.

---
 kernel/sched_fair.c     |    4 ++--
 kernel/sched_features.h |    1 +
 2 files changed, 3 insertions(+), 2 deletions(-)

Index: linux-2.6.37.git/kernel/sched_fair.c
===================================================================
--- linux-2.6.37.git.orig/kernel/sched_fair.c
+++ linux-2.6.37.git/kernel/sched_fair.c
@@ -862,7 +862,7 @@ check_preempt_tick(struct cfs_rq *cfs_rq
 	 * narrow margin doesn't have to wait for a full slice.
 	 * This also mitigates buddy induced latencies under load.
 	 */
-	if (!sched_feat(WAKEUP_PREEMPT))
+	if (!sched_feat(TESTME))
 		return;
 
 	if (delta_exec < sysctl_sched_min_granularity)
@@ -872,7 +872,7 @@ check_preempt_tick(struct cfs_rq *cfs_rq
 		struct sched_entity *se = __pick_next_entity(cfs_rq);
 		s64 delta = curr->vruntime - se->vruntime;
 
-		if (delta > ideal_runtime)
+		if (delta > (s64)ideal_runtime)
 			resched_task(rq_of(cfs_rq)->curr);
 	}
 }
Index: linux-2.6.37.git/kernel/sched_features.h
===================================================================
--- linux-2.6.37.git.orig/kernel/sched_features.h
+++ linux-2.6.37.git/kernel/sched_features.h
@@ -66,3 +66,4 @@ SCHED_FEAT(OWNER_SPIN, 1)
  * Decrement CPU power based on irq activity
  */
 SCHED_FEAT(NONIRQ_POWER, 1)
+SCHED_FEAT(TESTME, 1)


