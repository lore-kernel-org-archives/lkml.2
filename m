Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754743Ab0KUROV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Nov 2010 12:14:21 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:48252 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1754512Ab0KUROU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Nov 2010 12:14:20 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1//R/NL0fn/G0dvktCvs3aBAfsftOpSouklZ7+Aqo
	jZaaA0OPJz7Hkd
Subject: Re: Scheduler bug related to rq->skip_clock_update?
From: Mike Galbraith <efault@gmx.de>
To: "Bjoern B. Brandenburg" <bbb.lst@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Andrea Bastoni <bastoni@sprg.uniroma2.it>,
        "James H. Anderson" <anderson@cs.unc.edu>,
        linux-kernel@vger.kernel.org
In-Reply-To: <alpine.LNX.2.00.1011202315290.8927@jupiter-cs.cs.unc.edu>
References: <alpine.LNX.2.00.1011202315290.8927@jupiter-cs.cs.unc.edu>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 21 Nov 2010 10:14:01 -0700
Message-ID: <1290359641.4816.69.camel@maggy.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-11-20 at 23:22 -0500, Bjoern B. Brandenburg wrote:

> I was under the impression that, as an invariant, tasks should not have
> TIF_NEED_RESCHED set after they've blocked. In this case, the idle load
> balancer should not mark the task that's on its way out with
> set_tsk_need_resched().

Nice find.

> In any case, check_preempt_curr() seems to assume that a resuming task cannot
> have TIF_NEED_RESCHED already set. Setting skip_clock_update on a remote CPU
> that hasn't even been notified via IPI seems wrong.

Yes. Does the below fix it up for you?

Sched: clear_tsk_need_resched() after pull_task() when NEWIDLE balancing

pull_task() may call set_tsk_need_resched() on a deactivated task,
leaving it vulnerable to an inappropriate preemption after wakeup.

This also confuses the skip_clock_update logic, which assumes that
schedule() will be called in very short order after being set.  Make
that logic more robust by clearing in update_rq_clock() itself, so
only one update can be skipped.

Signed-off-by: Mike Galbraith <efault@gmx.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Bjoern B. Brandenburg <bbb.lst@gmail.com>
Reported-by: Bjoern B. Brandenburg <bbb.lst@gmail.com>

---
 kernel/sched.c      |    3 ++-
 kernel/sched_fair.c |   10 ++++++++--
 2 files changed, 10 insertions(+), 3 deletions(-)

Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -657,6 +657,8 @@ inline void update_rq_clock(struct rq *r
 
 		sched_irq_time_avg_update(rq, irq_time);
 	}
+
+	rq->skip_clock_update = 0;
 }
 
 /*
@@ -3714,7 +3716,6 @@ static void put_prev_task(struct rq *rq,
 {
 	if (prev->se.on_rq)
 		update_rq_clock(rq);
-	rq->skip_clock_update = 0;
 	prev->sched_class->put_prev_task(rq, prev);
 }
 
Index: linux-2.6/kernel/sched_fair.c
===================================================================
--- linux-2.6.orig/kernel/sched_fair.c
+++ linux-2.6/kernel/sched_fair.c
@@ -2019,15 +2019,21 @@ balance_tasks(struct rq *this_rq, int th
 		pulled++;
 		rem_load_move -= p->se.load.weight;
 
-#ifdef CONFIG_PREEMPT
 		/*
+		 * pull_task() may have set_tsk_need_resched().  Clear it
+		 * lest a sleeper awaken and be inappropriately preempted
+		 * shortly thereafter.
+		 *
 		 * NEWIDLE balancing is a source of latency, so preemptible
 		 * kernels will stop after the first task is pulled to minimize
 		 * the critical section.
 		 */
-		if (idle == CPU_NEWLY_IDLE)
+		if (idle == CPU_NEWLY_IDLE) {
+			clear_tsk_need_resched(this_rq->curr);
+#ifdef CONFIG_PREEMPT
 			break;
 #endif
+		}
 
 		/*
 		 * We only want to steal up to the prescribed amount of


