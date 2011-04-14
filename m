Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758456Ab1DNIfv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 04:35:51 -0400
Received: from hera.kernel.org ([140.211.167.34]:49642 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756574Ab1DNIfs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 04:35:48 -0400
Date: Thu, 14 Apr 2011 08:34:40 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Message-ID: <tip-7608dec2ce2004c234339bef8c8074e5e601d0e9@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        torvalds@linux-foundation.org, a.p.zijlstra@chello.nl, efault@gmx.de,
        npiggin@kernel.dk, akpm@linux-foundation.org, tglx@linutronix.de,
        frank.rowand@am.sony.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, torvalds@linux-foundation.org, efault@gmx.de,
        npiggin@kernel.dk, akpm@linux-foundation.org, frank.rowand@am.sony.com,
        tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20110405152729.031077745@chello.nl>
References: <20110405152729.031077745@chello.nl>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/locking] sched: Drop the rq argument to sched_class::select_task_rq()
Git-Commit-ID: 7608dec2ce2004c234339bef8c8074e5e601d0e9
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 14 Apr 2011 08:34:40 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7608dec2ce2004c234339bef8c8074e5e601d0e9
Gitweb:     http://git.kernel.org/tip/7608dec2ce2004c234339bef8c8074e5e601d0e9
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Tue, 5 Apr 2011 17:23:46 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 14 Apr 2011 08:52:36 +0200

sched: Drop the rq argument to sched_class::select_task_rq()

In preparation of calling select_task_rq() without rq->lock held, drop
the dependency on the rq argument.

Reviewed-by: Frank Rowand <frank.rowand@am.sony.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Nick Piggin <npiggin@kernel.dk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Link: http://lkml.kernel.org/r/20110405152729.031077745@chello.nl
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/sched.h   |    3 +--
 kernel/sched.c          |   20 +++++++++++---------
 kernel/sched_fair.c     |    2 +-
 kernel/sched_idletask.c |    2 +-
 kernel/sched_rt.c       |   38 ++++++++++++++++++++++++++------------
 kernel/sched_stoptask.c |    3 +--
 6 files changed, 41 insertions(+), 27 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index b33a700..ff4e2f9 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1067,8 +1067,7 @@ struct sched_class {
 	void (*put_prev_task) (struct rq *rq, struct task_struct *p);
 
 #ifdef CONFIG_SMP
-	int  (*select_task_rq)(struct rq *rq, struct task_struct *p,
-			       int sd_flag, int flags);
+	int  (*select_task_rq)(struct task_struct *p, int sd_flag, int flags);
 
 	void (*pre_schedule) (struct rq *this_rq, struct task_struct *task);
 	void (*post_schedule) (struct rq *this_rq);
diff --git a/kernel/sched.c b/kernel/sched.c
index d398f2f..d4b815d 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -2195,13 +2195,15 @@ static int migration_cpu_stop(void *data);
  * The task's runqueue lock must be held.
  * Returns true if you have to wait for migration thread.
  */
-static bool migrate_task(struct task_struct *p, struct rq *rq)
+static bool need_migrate_task(struct task_struct *p)
 {
 	/*
 	 * If the task is not on a runqueue (and not running), then
 	 * the next wake-up will properly place the task.
 	 */
-	return p->on_rq || task_running(rq, p);
+	bool running = p->on_rq || p->on_cpu;
+	smp_rmb(); /* finish_lock_switch() */
+	return running;
 }
 
 /*
@@ -2376,9 +2378,9 @@ static int select_fallback_rq(int cpu, struct task_struct *p)
  * The caller (fork, wakeup) owns p->pi_lock, ->cpus_allowed is stable.
  */
 static inline
-int select_task_rq(struct rq *rq, struct task_struct *p, int sd_flags, int wake_flags)
+int select_task_rq(struct task_struct *p, int sd_flags, int wake_flags)
 {
-	int cpu = p->sched_class->select_task_rq(rq, p, sd_flags, wake_flags);
+	int cpu = p->sched_class->select_task_rq(p, sd_flags, wake_flags);
 
 	/*
 	 * In order not to call set_task_cpu() on a blocking task we need
@@ -2533,7 +2535,7 @@ static int try_to_wake_up(struct task_struct *p, unsigned int state,
 		en_flags |= ENQUEUE_WAKING;
 	}
 
-	cpu = select_task_rq(rq, p, SD_BALANCE_WAKE, wake_flags);
+	cpu = select_task_rq(p, SD_BALANCE_WAKE, wake_flags);
 	if (cpu != orig_cpu)
 		set_task_cpu(p, cpu);
 	__task_rq_unlock(rq);
@@ -2744,7 +2746,7 @@ void wake_up_new_task(struct task_struct *p, unsigned long clone_flags)
 	 * We set TASK_WAKING so that select_task_rq() can drop rq->lock
 	 * without people poking at ->cpus_allowed.
 	 */
-	cpu = select_task_rq(rq, p, SD_BALANCE_FORK, 0);
+	cpu = select_task_rq(p, SD_BALANCE_FORK, 0);
 	set_task_cpu(p, cpu);
 
 	p->state = TASK_RUNNING;
@@ -3474,7 +3476,7 @@ void sched_exec(void)
 	int dest_cpu;
 
 	rq = task_rq_lock(p, &flags);
-	dest_cpu = p->sched_class->select_task_rq(rq, p, SD_BALANCE_EXEC, 0);
+	dest_cpu = p->sched_class->select_task_rq(p, SD_BALANCE_EXEC, 0);
 	if (dest_cpu == smp_processor_id())
 		goto unlock;
 
@@ -3482,7 +3484,7 @@ void sched_exec(void)
 	 * select_task_rq() can race against ->cpus_allowed
 	 */
 	if (cpumask_test_cpu(dest_cpu, &p->cpus_allowed) &&
-	    likely(cpu_active(dest_cpu)) && migrate_task(p, rq)) {
+	    likely(cpu_active(dest_cpu)) && need_migrate_task(p)) {
 		struct migration_arg arg = { p, dest_cpu };
 
 		task_rq_unlock(rq, &flags);
@@ -5911,7 +5913,7 @@ int set_cpus_allowed_ptr(struct task_struct *p, const struct cpumask *new_mask)
 		goto out;
 
 	dest_cpu = cpumask_any_and(cpu_active_mask, new_mask);
-	if (migrate_task(p, rq)) {
+	if (need_migrate_task(p)) {
 		struct migration_arg arg = { p, dest_cpu };
 		/* Need help from migration thread: drop lock and wait. */
 		__task_rq_unlock(rq);
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 4ee50f0..96b2c95 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -1657,7 +1657,7 @@ static int select_idle_sibling(struct task_struct *p, int target)
  * preempt must be disabled.
  */
 static int
-select_task_rq_fair(struct rq *rq, struct task_struct *p, int sd_flag, int wake_flags)
+select_task_rq_fair(struct task_struct *p, int sd_flag, int wake_flags)
 {
 	struct sched_domain *tmp, *affine_sd = NULL, *sd = NULL;
 	int cpu = smp_processor_id();
diff --git a/kernel/sched_idletask.c b/kernel/sched_idletask.c
index a776a63..0a51882 100644
--- a/kernel/sched_idletask.c
+++ b/kernel/sched_idletask.c
@@ -7,7 +7,7 @@
 
 #ifdef CONFIG_SMP
 static int
-select_task_rq_idle(struct rq *rq, struct task_struct *p, int sd_flag, int flags)
+select_task_rq_idle(struct task_struct *p, int sd_flag, int flags)
 {
 	return task_cpu(p); /* IDLE tasks as never migrated */
 }
diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
index 9ca4f5f..19ecb31 100644
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -977,13 +977,23 @@ static void yield_task_rt(struct rq *rq)
 static int find_lowest_rq(struct task_struct *task);
 
 static int
-select_task_rq_rt(struct rq *rq, struct task_struct *p, int sd_flag, int flags)
+select_task_rq_rt(struct task_struct *p, int sd_flag, int flags)
 {
+	struct task_struct *curr;
+	struct rq *rq;
+	int cpu;
+
 	if (sd_flag != SD_BALANCE_WAKE)
 		return smp_processor_id();
 
+	cpu = task_cpu(p);
+	rq = cpu_rq(cpu);
+
+	rcu_read_lock();
+	curr = ACCESS_ONCE(rq->curr); /* unlocked access */
+
 	/*
-	 * If the current task is an RT task, then
+	 * If the current task on @p's runqueue is an RT task, then
 	 * try to see if we can wake this RT task up on another
 	 * runqueue. Otherwise simply start this RT task
 	 * on its current runqueue.
@@ -997,21 +1007,25 @@ select_task_rq_rt(struct rq *rq, struct task_struct *p, int sd_flag, int flags)
 	 * lock?
 	 *
 	 * For equal prio tasks, we just let the scheduler sort it out.
+	 *
+	 * Otherwise, just let it ride on the affined RQ and the
+	 * post-schedule router will push the preempted task away
+	 *
+	 * This test is optimistic, if we get it wrong the load-balancer
+	 * will have to sort it out.
 	 */
-	if (unlikely(rt_task(rq->curr)) &&
-	    (rq->curr->rt.nr_cpus_allowed < 2 ||
-	     rq->curr->prio < p->prio) &&
+	if (curr && unlikely(rt_task(curr)) &&
+	    (curr->rt.nr_cpus_allowed < 2 ||
+	     curr->prio < p->prio) &&
 	    (p->rt.nr_cpus_allowed > 1)) {
-		int cpu = find_lowest_rq(p);
+		int target = find_lowest_rq(p);
 
-		return (cpu == -1) ? task_cpu(p) : cpu;
+		if (target != -1)
+			cpu = target;
 	}
+	rcu_read_unlock();
 
-	/*
-	 * Otherwise, just let it ride on the affined RQ and the
-	 * post-schedule router will push the preempted task away
-	 */
-	return task_cpu(p);
+	return cpu;
 }
 
 static void check_preempt_equal_prio(struct rq *rq, struct task_struct *p)
diff --git a/kernel/sched_stoptask.c b/kernel/sched_stoptask.c
index f607de4..6f43763 100644
--- a/kernel/sched_stoptask.c
+++ b/kernel/sched_stoptask.c
@@ -9,8 +9,7 @@
 
 #ifdef CONFIG_SMP
 static int
-select_task_rq_stop(struct rq *rq, struct task_struct *p,
-		    int sd_flag, int flags)
+select_task_rq_stop(struct task_struct *p, int sd_flag, int flags)
 {
 	return task_cpu(p); /* stop tasks as never migrate */
 }
