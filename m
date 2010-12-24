Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752577Ab0LXMmY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Dec 2010 07:42:24 -0500
Received: from casper.infradead.org ([85.118.1.10]:52594 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752253Ab0LXMmX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Dec 2010 07:42:23 -0500
Message-Id: <20101224123742.993148061@chello.nl>
User-Agent: quilt/0.48-1
Date: Fri, 24 Dec 2010 13:23:48 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Chris Mason <chris.mason@oracle.com>,
        Frank Rowand <frank.rowand@am.sony.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, Mike Galbraith <efault@gmx.de>,
        Oleg Nesterov <oleg@redhat.com>, Paul Turner <pjt@google.com>,
        Jens Axboe <axboe@kernel.dk>, Yong Zhang <yong.zhang0@gmail.com>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [RFC][PATCH 10/17] sched: Add TASK_WAKING to task_rq_lock
References: <20101224122338.172750730@chello.nl>
Content-Disposition: inline; filename=sched-task_rq_lock.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In order to be able to call set_task_cpu() without holding the
appropriate rq->lock during ttwu(), add a TASK_WAKING clause to the
task_rq_lock() primitive.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/sched.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -928,12 +928,13 @@ static inline void finish_lock_switch(st
 #endif /* __ARCH_WANT_UNLOCKED_CTXSW */
 
 /*
- * Check whether the task is waking, we use this to synchronize ->cpus_allowed
- * against ttwu().
+ * In order to be able to call set_task_cpu() without holding the current
+ * task_rq(p)->lock during wake-ups we need to serialize on something else,
+ * use the wakeup task state.
  */
 static inline int task_is_waking(struct task_struct *p)
 {
-	return unlikely(p->state == TASK_WAKING);
+	return p->state == TASK_WAKING;
 }
 
 /*
@@ -948,7 +949,7 @@ static inline struct rq *__task_rq_lock(
 	for (;;) {
 		rq = task_rq(p);
 		raw_spin_lock(&rq->lock);
-		if (likely(rq == task_rq(p)))
+		if (likely(rq == task_rq(p) && !task_is_waking(p)))
 			return rq;
 		raw_spin_unlock(&rq->lock);
 	}
@@ -956,8 +957,7 @@ static inline struct rq *__task_rq_lock(
 
 /*
  * task_rq_lock - lock the runqueue a given task resides on and disable
- * interrupts. Note the ordering: we can safely lookup the task_rq without
- * explicitly disabling preemption.
+ * interrupts.
  */
 static struct rq *task_rq_lock(struct task_struct *p, unsigned long *flags)
 	__acquires(rq->lock)
@@ -968,7 +968,7 @@ static struct rq *task_rq_lock(struct ta
 		local_irq_save(*flags);
 		rq = task_rq(p);
 		raw_spin_lock(&rq->lock);
-		if (likely(rq == task_rq(p)))
+		if (likely(rq == task_rq(p) && !task_is_waking(p)))
 			return rq;
 		raw_spin_unlock_irqrestore(&rq->lock, *flags);
 	}


