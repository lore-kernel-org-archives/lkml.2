Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756642Ab1CBRqy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 12:46:54 -0500
Received: from casper.infradead.org ([85.118.1.10]:45935 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756493Ab1CBRqu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 12:46:50 -0500
Message-Id: <20110302174121.270015003@chello.nl>
User-Agent: quilt/0.48-1
Date: Wed, 02 Mar 2011 18:38:45 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Chris Mason <chris.mason@oracle.com>,
        Frank Rowand <frank.rowand@am.sony.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, Mike Galbraith <efault@gmx.de>,
        Oleg Nesterov <oleg@redhat.com>, Paul Turner <pjt@google.com>,
        Jens Axboe <axboe@kernel.dk>, Yong Zhang <yong.zhang0@gmail.com>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 14/22] sched: Drop rq->lock from first part of wake_up_new_task()
References: <20110302173831.295031866@chello.nl>
Content-Disposition: inline; filename=sched-wunt.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since p->pi_lock now protects all things needed to call
select_task_rq() avoid the double remote rq->lock acquisition and rely
on p->pi_lock.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <new-submission>
---
 kernel/sched.c |   17 +++--------------
 1 file changed, 3 insertions(+), 14 deletions(-)

Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -2726,28 +2726,18 @@ void wake_up_new_task(struct task_struct
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
-	task_rq_unlock(rq, p, &flags);
+	set_task_cpu(p, select_task_rq(p, SD_BALANCE_FORK, 0));
 #endif
 
-	rq = task_rq_lock(p, &flags);
+	rq = __task_rq_lock(p);
 	activate_task(rq, p, 0);
 	trace_sched_wakeup_new(p, true);
 	check_preempt_curr(rq, p, WF_FORK);
@@ -2756,7 +2746,6 @@ void wake_up_new_task(struct task_struct
 		p->sched_class->task_woken(rq, p);
 #endif
 	task_rq_unlock(rq, p, &flags);
-	put_cpu();
 }
 
 #ifdef CONFIG_PREEMPT_NOTIFIERS


