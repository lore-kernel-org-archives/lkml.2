Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752056Ab0KVQUE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Nov 2010 11:20:04 -0500
Received: from mailout-de.gmx.net ([213.165.64.23]:36510 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1751282Ab0KVQUB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Nov 2010 11:20:01 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18Z80I9ZYgZnwybB6F2d1oquxs/0QzgKJJXXeRP6k
	n/SlJcQsrdqe+P
Subject: Re: Scheduler bug related to rq->skip_clock_update?
From: Mike Galbraith <efault@gmx.de>
To: "Bjoern B. Brandenburg" <bbb.lst@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Andrea Bastoni <bastoni@sprg.uniroma2.it>,
        "James H. Anderson" <anderson@cs.unc.edu>,
        linux-kernel@vger.kernel.org
In-Reply-To: <alpine.LNX.2.00.1011212327250.8927@jupiter-cs.cs.unc.edu>
References: <alpine.LNX.2.00.1011202315290.8927@jupiter-cs.cs.unc.edu>
	 <1290359641.4816.69.camel@maggy.simson.net>
	 <alpine.LNX.2.00.1011212327250.8927@jupiter-cs.cs.unc.edu>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 22 Nov 2010 09:19:41 -0700
Message-ID: <1290442781.16393.22.camel@maggy.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 
Content-Transfer-Encoding: 8bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-11-21 at 23:29 -0500, Bjoern B. Brandenburg wrote:
> On Sun, 21 Nov 2010, Mike Galbraith wrote:
> 
> > On Sat, 2010-11-20 at 23:22 -0500, Bjoern B. Brandenburg wrote:
> >
> > > I was under the impression that, as an invariant, tasks should not have
> > > TIF_NEED_RESCHED set after they've blocked. In this case, the idle load
> > > balancer should not mark the task that's on its way out with
> > > set_tsk_need_resched().
> >
> > Nice find.
> >
> > > In any case, check_preempt_curr() seems to assume that a resuming task cannot
> > > have TIF_NEED_RESCHED already set. Setting skip_clock_update on a remote CPU
> > > that hasn't even been notified via IPI seems wrong.
> >
> > Yes. Does the below fix it up for you?
> 
> The patch definitely changes the behavior, but it doesn't seem to solve (all
> of) the root cause(s). The failsafe kicks in and clears the flag the next
> time that update_rq_clock() is called, but there can still be a significant
> delay between setting and clearing the flag. Right after boot, I'm now seeing
> values that go up to ~21ms.

A pull isn't the only vulnerability.  Since idle_balance() drops
rq->lock, so another cpu can wake to this rq.

> Please let me know if there is something else that I should test.

Sched: clear_tsk_need_resched() after NEWIDLE balancing

idle_balance() drops/retakes rq->lock, leaving the previous task
vulnerable to set_tsk_need_resched() from another CPU.  Clear it
after NEWIDLE balancing to maintain the invariant that descheduled
tasks are NOT marked for resched.

This also confuses the skip_clock_update logic, which assumes that
the next call to update_rq_clock() will come nearly ĩmmediately after
being set.  Make the optimization more robust by clearing before we
balance and in update_rq_clock().

Signed-off-by: Mike Galbraith <efault@gmx.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Bjoern B. Brandenburg <bbb.lst@gmail.com>
Reported-by: Bjoern B. Brandenburg <bbb.lst@gmail.com>

---
 kernel/sched.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -657,6 +657,7 @@ inline void update_rq_clock(struct rq *r
 
 		sched_irq_time_avg_update(rq, irq_time);
 	}
+	rq->skip_clock_update = 0;
 }
 
 /*
@@ -3714,7 +3715,6 @@ static void put_prev_task(struct rq *rq,
 {
 	if (prev->se.on_rq)
 		update_rq_clock(rq);
-	rq->skip_clock_update = 0;
 	prev->sched_class->put_prev_task(rq, prev);
 }
 
@@ -3799,8 +3799,16 @@ need_resched_nonpreemptible:
 
 	pre_schedule(rq, prev);
 
-	if (unlikely(!rq->nr_running))
+	if (unlikely(!rq->nr_running)) {
 		idle_balance(cpu, rq);
+		/*
+		 * idle_balance() releases/retakes rq->lock, leaving prev
+		 * vulnerable to set_tsk_need_resched() from another cpu.
+		 * Clock updates should not be skipped while we're away.
+		 */
+		clear_tsk_need_resched(prev);
+		rq->skip_clock_update = 0;
+	}
 
 	put_prev_task(rq, prev);
 	next = pick_next_task(rq);


