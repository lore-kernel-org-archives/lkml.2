Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754445Ab0LHKFs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 05:05:48 -0500
Received: from mailout-de.gmx.net ([213.165.64.23]:53446 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1752289Ab0LHKFr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 05:05:47 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18d/94nt9Qdz77kSKIEvFWCAxdP7QjwWm3EqG7obH
	I4Fo5/4KUaq5Cw
Subject: Re: [patchlet] Re: Scheduler bug related to rq->skip_clock_update?
From: Mike Galbraith <efault@gmx.de>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Yong Zhang <yong.zhang0@gmail.com>,
        "Bjoern B. Brandenburg" <bbb.lst@gmail.com>,
        Ingo Molnar <mingo@elte.hu>, Andrea Bastoni <bastoni@sprg.uniroma2.it>,
        "James H. Anderson" <anderson@cs.unc.edu>,
        linux-kernel@vger.kernel.org
In-Reply-To: <1291748109.7475.20.camel@marge.simson.net>
References: <alpine.LNX.2.00.1011202315290.8927@jupiter-cs.cs.unc.edu>
	 <1290359641.4816.69.camel@maggy.simson.net>
	 <alpine.LNX.2.00.1011212327250.8927@jupiter-cs.cs.unc.edu>
	 <1290442781.16393.22.camel@maggy.simson.net>
	 <alpine.LNX.2.00.1011221310430.8927@jupiter-cs.cs.unc.edu>
	 <20101205052819.GA2878@zhy> <1291613607.9457.5.camel@marge.simson.net>
	 <AANLkTimH0YN0fd4zOk3A=_Q7waqM=6V4pw4N+0g0-k=7@mail.gmail.com>
	 <1291624329.9457.38.camel@marge.simson.net>
	 <1291740081.2032.751.camel@laptop>
	 <1291748109.7475.20.camel@marge.simson.net>
Content-Type: text/plain
Date: Wed, 08 Dec 2010 11:05:42 +0100
Message-Id: <1291802742.1417.9.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-12-07 at 19:55 +0100, Mike Galbraith wrote:
> On Tue, 2010-12-07 at 17:41 +0100, Peter Zijlstra wrote:
> > On Mon, 2010-12-06 at 09:32 +0100, Mike Galbraith wrote:
> > 
> > >  kernel/fork.c  |    1 +
> > >  kernel/sched.c |    6 +++---
> > >  2 files changed, 4 insertions(+), 3 deletions(-)
> > > 
> > > Index: linux-2.6.37.git/kernel/sched.c
> > > ===================================================================
> > > --- linux-2.6.37.git.orig/kernel/sched.c
> > > +++ linux-2.6.37.git/kernel/sched.c
> > > @@ -660,6 +660,7 @@ inline void update_rq_clock(struct rq *r
> > >  
> > >  		sched_irq_time_avg_update(rq, irq_time);
> > >  	}
> > > +	rq->skip_clock_update = 0;
> > >  }
> > >  
> > >  /*
> > 
> > Shouldn't we do that at the end of schedule()? Since the purpose of
> > ->skip_clock_update is to avoid multiple calls to:
> >   - avoid overhead
> >   - ensure scheduling is accounted at a single point
> > 
> > [ for that latter purpose it might also make sense to put that point
> > somewhere around context_switch() but due to the fact that we need a
> > clock update early that's a bit impractical. ]
> > 
> > Hmm?
> 
> Yeah, could do that instead.  There's no gain in any call that may
> happen in the interval between.  Think I'll measure though, this bug was
> a surprise :)

Did that, all is well.

> > OK.. have we looked if there's more TIF flags that could do with a
> > reset?
> 
> mmm, no.

Crawling over flags had to be left for another day.

Sched: fix skip_clock_update optimization

idle_balance() drops/retakes rq->lock, leaving the previous task
vulnerable to set_tsk_need_resched().  Clear it after we return
from balancing instead, and in setup_thread_stack() as well, so
no successfully descheduled or never scheduled task has it set.
 
Need resched confused the skip_clock_update logic, which assumes
that the next call to update_rq_clock() will come nearly immediately
after being set.  Make the optimization robust against the waking
a sleeper before it sucessfully deschedules case by checking that
the current task has not been dequeued before setting the flag,
since it is that useless clock update we're trying to save, and
clear unconditionally in schedule() proper instead of conditionally
in put_prev_task().

Signed-off-by: Mike Galbraith <efault@gmx.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Bjoern B. Brandenburg <bbb.lst@gmail.com>
Reported-by: Bjoern B. Brandenburg <bbb.lst@gmail.com>
Tested-by: Yong Zhang <yong.zhang0@gmail.com>

---
 kernel/fork.c  |    1 +
 kernel/sched.c |   28 +++++++++++++++-------------
 2 files changed, 16 insertions(+), 13 deletions(-)

Index: linux-2.6.37.git/kernel/sched.c
===================================================================
--- linux-2.6.37.git.orig/kernel/sched.c
+++ linux-2.6.37.git/kernel/sched.c
@@ -649,17 +649,18 @@ static void sched_irq_time_avg_update(st
 
 inline void update_rq_clock(struct rq *rq)
 {
-	if (!rq->skip_clock_update) {
-		int cpu = cpu_of(rq);
-		u64 irq_time;
-
-		rq->clock = sched_clock_cpu(cpu);
-		irq_time = irq_time_cpu(cpu);
-		if (rq->clock - irq_time > rq->clock_task)
-			rq->clock_task = rq->clock - irq_time;
+	int cpu = cpu_of(rq);
+	u64 irq_time;
 
-		sched_irq_time_avg_update(rq, irq_time);
-	}
+	if (rq->skip_clock_update)
+		return;
+
+	rq->clock = sched_clock_cpu(cpu);
+	irq_time = irq_time_cpu(cpu);
+	if (rq->clock - irq_time > rq->clock_task)
+		rq->clock_task = rq->clock - irq_time;
+
+	sched_irq_time_avg_update(rq, irq_time);
 }
 
 /*
@@ -2138,7 +2139,7 @@ static void check_preempt_curr(struct rq
 	 * A queue event has occurred, and we're going to schedule.  In
 	 * this case, we can save a useless back to back clock update.
 	 */
-	if (test_tsk_need_resched(rq->curr))
+	if (rq->curr->se.on_rq && test_tsk_need_resched(rq->curr))
 		rq->skip_clock_update = 1;
 }
 
@@ -3854,7 +3855,6 @@ static void put_prev_task(struct rq *rq,
 {
 	if (prev->se.on_rq)
 		update_rq_clock(rq);
-	rq->skip_clock_update = 0;
 	prev->sched_class->put_prev_task(rq, prev);
 }
 
@@ -3912,7 +3912,6 @@ need_resched_nonpreemptible:
 		hrtick_clear(rq);
 
 	raw_spin_lock_irq(&rq->lock);
-	clear_tsk_need_resched(prev);
 
 	switch_count = &prev->nivcsw;
 	if (prev->state && !(preempt_count() & PREEMPT_ACTIVE)) {
@@ -3944,6 +3943,8 @@ need_resched_nonpreemptible:
 
 	put_prev_task(rq, prev);
 	next = pick_next_task(rq);
+	clear_tsk_need_resched(prev);
+	rq->skip_clock_update = 0;
 
 	if (likely(prev != next)) {
 		sched_info_switch(prev, next);
@@ -3952,6 +3953,7 @@ need_resched_nonpreemptible:
 		rq->nr_switches++;
 		rq->curr = next;
 		++*switch_count;
+		WARN_ON_ONCE(test_tsk_need_resched(next));
 
 		context_switch(rq, prev, next); /* unlocks the rq */
 		/*
Index: linux-2.6.37.git/kernel/fork.c
===================================================================
--- linux-2.6.37.git.orig/kernel/fork.c
+++ linux-2.6.37.git/kernel/fork.c
@@ -275,6 +275,7 @@ static struct task_struct *dup_task_stru
 
 	setup_thread_stack(tsk, orig);
 	clear_user_return_notifier(tsk);
+	clear_tsk_need_resched(tsk);
 	stackend = end_of_stack(tsk);
 	*stackend = STACK_END_MAGIC;	/* for overflow detection */
 


