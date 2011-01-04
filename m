Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752407Ab1ADPMJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 10:12:09 -0500
Received: from casper.infradead.org ([85.118.1.10]:59931 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752221Ab1ADPMH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 10:12:07 -0500
Message-Id: <20110104150102.911325900@chello.nl>
User-Agent: quilt/0.48-1
Date: Tue, 04 Jan 2011 15:59:41 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Chris Mason <chris.mason@oracle.com>,
        Frank Rowand <frank.rowand@am.sony.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, Mike Galbraith <efault@gmx.de>,
        Oleg Nesterov <oleg@redhat.com>, Paul Turner <pjt@google.com>,
        Jens Axboe <axboe@kernel.dk>, Yong Zhang <yong.zhang0@gmail.com>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [RFC][PATCH 12/18] sched: Drop rq->lock from first part of wake_up_new_task()
References: <20110104145929.772813816@chello.nl>
Content-Disposition: inline; filename=sched-wunt.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since p->pi_lock now protects all things needed to call
select_task_rq() avoid the double remote rq->lock acquisition and rely
on p->pi_lock.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/sched.c |   20 +++++---------------
 1 file changed, 5 insertions(+), 15 deletions(-)

Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -2681,28 +2681,18 @@ void wake_up_new_task(struct task_struct
 {
 	unsigned long flags;
 	struct rq *rq;
-	int cpu __maybe_unused = get_cpu();
 
+	raw_spin_lock_irqsave(&p->pi_lock, flags);
 #ifdef CONFIG_SMP
-	rq = task_rq_lock(p, &flags);
-	p->state = TASK_WAKING;
-
 	/*
 	 * Fork balancing, do it here and not earlier because:
 	 *  - cpus_allowed can change in the fork path
 	 *  - any previously selected cpu might disappear through hotplug
-	 *
-	 * We set TASK_WAKING so that select_task_rq() can drop rq->lock
-	 * without people poking at ->cpus_allowed.
 	 */
-	cpu = select_task_rq(p, SD_BALANCE_FORK, 0);
-	set_task_cpu(p, cpu);
-
-	p->state = TASK_RUNNING;
-	task_rq_unlock(rq, &flags);
+	set_task_cpu(p, select_task_rq(p, SD_BALANCE_FORK, 0));
 #endif
 
-	rq = task_rq_lock(p, &flags);
+	rq = __task_rq_lock(p);
 	activate_task(rq, p, 0);
 	trace_sched_wakeup_new(p, true);
 	check_preempt_curr(rq, p, WF_FORK);
@@ -2710,8 +2700,8 @@ void wake_up_new_task(struct task_struct
 	if (p->sched_class->task_woken)
 		p->sched_class->task_woken(rq, p);
 #endif
-	task_rq_unlock(rq, &flags);
-	put_cpu();
+	__task_rq_unlock(rq);
+	raw_spin_unlock_irqrestore(&p->pi_lock, flags);
 }
 
 #ifdef CONFIG_PREEMPT_NOTIFIERS


