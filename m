Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756580Ab0LHUlQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 15:41:16 -0500
Received: from hera.kernel.org ([140.211.167.34]:34227 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756189Ab0LHUlO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 15:41:14 -0500
Date: Wed, 8 Dec 2010 20:40:43 GMT
From: tip-bot for Mike Galbraith <efault@gmx.de>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, bbb.lst@gmail.com, efault@gmx.de,
        tglx@linutronix.de, yong.zhang0@gmail.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, efault@gmx.de, bbb.lst@gmail.com,
        tglx@linutronix.de, yong.zhang0@gmail.com, mingo@elte.hu
In-Reply-To: <1291802742.1417.9.camel@marge.simson.net>
References: <1291802742.1417.9.camel@marge.simson.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/urgent] Sched: fix skip_clock_update optimization
Message-ID: <tip-f26f9aff6aaf67e9a430d16c266f91b13a5bff64@git.kernel.org>
Git-Commit-ID: f26f9aff6aaf67e9a430d16c266f91b13a5bff64
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 08 Dec 2010 20:40:43 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f26f9aff6aaf67e9a430d16c266f91b13a5bff64
Gitweb:     http://git.kernel.org/tip/f26f9aff6aaf67e9a430d16c266f91b13a5bff64
Author:     Mike Galbraith <efault@gmx.de>
AuthorDate: Wed, 8 Dec 2010 11:05:42 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 8 Dec 2010 20:15:06 +0100

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
Reported-by: Bjoern B. Brandenburg <bbb.lst@gmail.com>
Tested-by: Yong Zhang <yong.zhang0@gmail.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: stable@kernel.org
LKML-Reference: <1291802742.1417.9.camel@marge.simson.net>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/fork.c  |    1 +
 kernel/sched.c |   26 ++++++++++++++------------
 2 files changed, 15 insertions(+), 12 deletions(-)

diff --git a/kernel/fork.c b/kernel/fork.c
index 3b159c5..5447dc7 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -273,6 +273,7 @@ static struct task_struct *dup_task_struct(struct task_struct *orig)
 
 	setup_thread_stack(tsk, orig);
 	clear_user_return_notifier(tsk);
+	clear_tsk_need_resched(tsk);
 	stackend = end_of_stack(tsk);
 	*stackend = STACK_END_MAGIC;	/* for overflow detection */
 
diff --git a/kernel/sched.c b/kernel/sched.c
index 6b7c26a..da14302 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -641,17 +641,18 @@ static void sched_irq_time_avg_update(struct rq *rq, u64 irq_time);
 
 inline void update_rq_clock(struct rq *rq)
 {
-	if (!rq->skip_clock_update) {
-		int cpu = cpu_of(rq);
-		u64 irq_time;
+	int cpu = cpu_of(rq);
+	u64 irq_time;
 
-		rq->clock = sched_clock_cpu(cpu);
-		irq_time = irq_time_cpu(cpu);
-		if (rq->clock - irq_time > rq->clock_task)
-			rq->clock_task = rq->clock - irq_time;
+	if (rq->skip_clock_update)
+		return;
 
-		sched_irq_time_avg_update(rq, irq_time);
-	}
+	rq->clock = sched_clock_cpu(cpu);
+	irq_time = irq_time_cpu(cpu);
+	if (rq->clock - irq_time > rq->clock_task)
+		rq->clock_task = rq->clock - irq_time;
+
+	sched_irq_time_avg_update(rq, irq_time);
 }
 
 /*
@@ -2129,7 +2130,7 @@ static void check_preempt_curr(struct rq *rq, struct task_struct *p, int flags)
 	 * A queue event has occurred, and we're going to schedule.  In
 	 * this case, we can save a useless back to back clock update.
 	 */
-	if (test_tsk_need_resched(rq->curr))
+	if (rq->curr->se.on_rq && test_tsk_need_resched(rq->curr))
 		rq->skip_clock_update = 1;
 }
 
@@ -3973,7 +3974,6 @@ static void put_prev_task(struct rq *rq, struct task_struct *prev)
 {
 	if (prev->se.on_rq)
 		update_rq_clock(rq);
-	rq->skip_clock_update = 0;
 	prev->sched_class->put_prev_task(rq, prev);
 }
 
@@ -4031,7 +4031,6 @@ need_resched_nonpreemptible:
 		hrtick_clear(rq);
 
 	raw_spin_lock_irq(&rq->lock);
-	clear_tsk_need_resched(prev);
 
 	switch_count = &prev->nivcsw;
 	if (prev->state && !(preempt_count() & PREEMPT_ACTIVE)) {
@@ -4063,6 +4062,8 @@ need_resched_nonpreemptible:
 
 	put_prev_task(rq, prev);
 	next = pick_next_task(rq);
+	clear_tsk_need_resched(prev);
+	rq->skip_clock_update = 0;
 
 	if (likely(prev != next)) {
 		sched_info_switch(prev, next);
@@ -4071,6 +4072,7 @@ need_resched_nonpreemptible:
 		rq->nr_switches++;
 		rq->curr = next;
 		++*switch_count;
+		WARN_ON_ONCE(test_tsk_need_resched(next));
 
 		context_switch(rq, prev, next); /* unlocks the rq */
 		/*
