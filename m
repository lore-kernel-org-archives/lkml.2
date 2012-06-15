Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756708Ab2FOMPw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 08:15:52 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:59132 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755818Ab2FOMPv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 08:15:51 -0400
MIME-Version: 1.0
Date: Fri, 15 Jun 2012 20:15:50 +0800
Message-ID: <CAJd=RBAsbVXossVZxPjyXzrOqKEVjg77vRwDD9RZxtvvrqeggg@mail.gmail.com>
Subject: [patch] BFS 421: change task cpu with runqueue lock held
From: Hillf Danton <dhillf@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>, Hillf Danton <dhillf@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Set tasks cpu after grabbing runqueue lock.


--- a/kernel/sched/bfs.c	Fri Jun 15 19:57:30 2012
+++ b/kernel/sched/bfs.c	Fri Jun 15 20:00:52 2012
@@ -1031,11 +1031,10 @@ void set_task_cpu(struct task_struct *p,
 	WARN_ON_ONCE(debug_locks && !lockdep_is_held(&grq.lock));
 #endif
 	trace_sched_migrate_task(p, cpu);
-	if (task_cpu(p) != cpu)
-		perf_sw_event(PERF_COUNT_SW_CPU_MIGRATIONS, 1, NULL, 0);
-
-	if (task_thread_info(p)->cpu != cpu)
+	if (task_cpu(p) != cpu) {
 		task_thread_info(p)->cpu = cpu;
+		perf_sw_event(PERF_COUNT_SW_CPU_MIGRATIONS, 1, NULL, 0);
+	}
 }

 static inline void clear_sticky(struct task_struct *p)
@@ -1638,7 +1637,6 @@ void sched_fork(struct task_struct *p)
 	 * event cannot wake it up and insert it on the runqueue either.
 	 */
 	p->state = TASK_RUNNING;
-	set_task_cpu(p, cpu);

 	/* Should be reset in fork.c but done here for ease of bfs patching */
 	p->sched_time = p->stime_pc = p->utime_pc = 0;
@@ -1688,8 +1686,6 @@ void sched_fork(struct task_struct *p)
 	/* Want to start with kernel preemption disabled. */
 	task_thread_info(p)->preempt_count = 1;
 #endif
-	if (unlikely(p->policy == SCHED_FIFO))
-		goto out;
 	/*
 	 * Share the timeslice between parent and child, thus the
 	 * total amount of pending timeslices in the system doesn't change,
@@ -1700,6 +1696,9 @@ void sched_fork(struct task_struct *p)
 	 * is always equal to current->deadline.
 	 */
 	rq = task_grq_lock_irq(curr);
+	set_task_cpu(p, cpu);
+	if (unlikely(p->policy == SCHED_FIFO))
+		goto out;
 	if (likely(rq->rq_time_slice >= RESCHED_US * 2)) {
 		rq->rq_time_slice /= 2;
 		p->time_slice = rq->rq_time_slice;
@@ -1715,8 +1714,8 @@ void sched_fork(struct task_struct *p)
 		time_slice_expired(p);
 	}
 	p->last_ran = rq->rq_last_ran;
-	task_grq_unlock_irq();
 out:
+	task_grq_unlock_irq();
 	put_cpu();
 }

--
