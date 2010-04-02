Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755386Ab0DBTN6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Apr 2010 15:13:58 -0400
Received: from hera.kernel.org ([140.211.167.34]:46689 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755051Ab0DBTNt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Apr 2010 15:13:49 -0400
Date: Fri, 2 Apr 2010 19:13:25 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, oleg@redhat.com, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, oleg@redhat.com,
       mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Fix TASK_WAKING vs fork deadlock
Message-ID: <tip-0017d735092844118bef006696a750a0e4ef6ebd@git.kernel.org>
Git-Commit-ID: 0017d735092844118bef006696a750a0e4ef6ebd
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 02 Apr 2010 19:13:25 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0017d735092844118bef006696a750a0e4ef6ebd
Gitweb:     http://git.kernel.org/tip/0017d735092844118bef006696a750a0e4ef6ebd
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Wed, 24 Mar 2010 18:34:10 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 2 Apr 2010 20:12:03 +0200

sched: Fix TASK_WAKING vs fork deadlock

Oleg noticed a few races with the TASK_WAKING usage on fork.

 - since TASK_WAKING is basically a spinlock, it should be IRQ safe
 - since we set TASK_WAKING (*) without holding rq->lock it could
   be there still is a rq->lock holder, thereby not actually
   providing full serialization.

(*) in fact we clear PF_STARTING, which in effect enables TASK_WAKING.

Cure the second issue by not setting TASK_WAKING in sched_fork(), but
only temporarily in wake_up_new_task() while calling select_task_rq().

Cure the first by holding rq->lock around the select_task_rq() call,
this will disable IRQs, this however requires that we push down the
rq->lock release into select_task_rq_fair()'s cgroup stuff.

Because select_task_rq_fair() still needs to drop the rq->lock we
cannot fully get rid of TASK_WAKING.

Reported-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/sched.h   |    3 +-
 kernel/sched.c          |   65 +++++++++++++++++-----------------------------
 kernel/sched_fair.c     |    8 ++++-
 kernel/sched_idletask.c |    3 +-
 kernel/sched_rt.c       |    5 +--
 5 files changed, 36 insertions(+), 48 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 8bea407..fb6c188 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1046,7 +1046,8 @@ struct sched_class {
 	void (*put_prev_task) (struct rq *rq, struct task_struct *p);
 
 #ifdef CONFIG_SMP
-	int  (*select_task_rq)(struct task_struct *p, int sd_flag, int flags);
+	int  (*select_task_rq)(struct rq *rq, struct task_struct *p,
+			       int sd_flag, int flags);
 
 	void (*pre_schedule) (struct rq *this_rq, struct task_struct *task);
 	void (*post_schedule) (struct rq *this_rq);
diff --git a/kernel/sched.c b/kernel/sched.c
index 9a38c7a..dcd1773 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -916,14 +916,10 @@ static inline void finish_lock_switch(struct rq *rq, struct task_struct *prev)
 /*
  * Check whether the task is waking, we use this to synchronize against
  * ttwu() so that task_cpu() reports a stable number.
- *
- * We need to make an exception for PF_STARTING tasks because the fork
- * path might require task_rq_lock() to work, eg. it can call
- * set_cpus_allowed_ptr() from the cpuset clone_ns code.
  */
 static inline int task_is_waking(struct task_struct *p)
 {
-	return unlikely((p->state == TASK_WAKING) && !(p->flags & PF_STARTING));
+	return unlikely(p->state == TASK_WAKING);
 }
 
 /*
@@ -2320,9 +2316,9 @@ static int select_fallback_rq(int cpu, struct task_struct *p)
  * The caller (fork, wakeup) owns TASK_WAKING, ->cpus_allowed is stable.
  */
 static inline
-int select_task_rq(struct task_struct *p, int sd_flags, int wake_flags)
+int select_task_rq(struct rq *rq, struct task_struct *p, int sd_flags, int wake_flags)
 {
-	int cpu = p->sched_class->select_task_rq(p, sd_flags, wake_flags);
+	int cpu = p->sched_class->select_task_rq(rq, p, sd_flags, wake_flags);
 
 	/*
 	 * In order not to call set_task_cpu() on a blocking task we need
@@ -2393,17 +2389,10 @@ static int try_to_wake_up(struct task_struct *p, unsigned int state,
 	if (p->sched_class->task_waking)
 		p->sched_class->task_waking(rq, p);
 
-	__task_rq_unlock(rq);
-
-	cpu = select_task_rq(p, SD_BALANCE_WAKE, wake_flags);
-	if (cpu != orig_cpu) {
-		/*
-		 * Since we migrate the task without holding any rq->lock,
-		 * we need to be careful with task_rq_lock(), since that
-		 * might end up locking an invalid rq.
-		 */
+	cpu = select_task_rq(rq, p, SD_BALANCE_WAKE, wake_flags);
+	if (cpu != orig_cpu)
 		set_task_cpu(p, cpu);
-	}
+	__task_rq_unlock(rq);
 
 	rq = cpu_rq(cpu);
 	raw_spin_lock(&rq->lock);
@@ -2530,11 +2519,11 @@ void sched_fork(struct task_struct *p, int clone_flags)
 
 	__sched_fork(p);
 	/*
-	 * We mark the process as waking here. This guarantees that
+	 * We mark the process as running here. This guarantees that
 	 * nobody will actually run it, and a signal or other external
 	 * event cannot wake it up and insert it on the runqueue either.
 	 */
-	p->state = TASK_WAKING;
+	p->state = TASK_RUNNING;
 
 	/*
 	 * Revert to default priority/policy on fork if requested.
@@ -2601,28 +2590,25 @@ void wake_up_new_task(struct task_struct *p, unsigned long clone_flags)
 	int cpu __maybe_unused = get_cpu();
 
 #ifdef CONFIG_SMP
+	rq = task_rq_lock(p, &flags);
+	p->state = TASK_WAKING;
+
 	/*
 	 * Fork balancing, do it here and not earlier because:
 	 *  - cpus_allowed can change in the fork path
 	 *  - any previously selected cpu might disappear through hotplug
 	 *
-	 * We still have TASK_WAKING but PF_STARTING is gone now, meaning
-	 * ->cpus_allowed is stable, we have preemption disabled, meaning
-	 * cpu_online_mask is stable.
+	 * We set TASK_WAKING so that select_task_rq() can drop rq->lock
+	 * without people poking at ->cpus_allowed.
 	 */
-	cpu = select_task_rq(p, SD_BALANCE_FORK, 0);
+	cpu = select_task_rq(rq, p, SD_BALANCE_FORK, 0);
 	set_task_cpu(p, cpu);
-#endif
-
-	/*
-	 * Since the task is not on the rq and we still have TASK_WAKING set
-	 * nobody else will migrate this task.
-	 */
-	rq = cpu_rq(cpu);
-	raw_spin_lock_irqsave(&rq->lock, flags);
 
-	BUG_ON(p->state != TASK_WAKING);
 	p->state = TASK_RUNNING;
+	task_rq_unlock(rq, &flags);
+#endif
+
+	rq = task_rq_lock(p, &flags);
 	activate_task(rq, p, 0);
 	trace_sched_wakeup_new(rq, p, 1);
 	check_preempt_curr(rq, p, WF_FORK);
@@ -3068,19 +3054,15 @@ void sched_exec(void)
 {
 	struct task_struct *p = current;
 	struct migration_req req;
-	int dest_cpu, this_cpu;
 	unsigned long flags;
 	struct rq *rq;
-
-	this_cpu = get_cpu();
-	dest_cpu = p->sched_class->select_task_rq(p, SD_BALANCE_EXEC, 0);
-	if (dest_cpu == this_cpu) {
-		put_cpu();
-		return;
-	}
+	int dest_cpu;
 
 	rq = task_rq_lock(p, &flags);
-	put_cpu();
+	dest_cpu = p->sched_class->select_task_rq(rq, p, SD_BALANCE_EXEC, 0);
+	if (dest_cpu == smp_processor_id())
+		goto unlock;
+
 	/*
 	 * select_task_rq() can race against ->cpus_allowed
 	 */
@@ -3098,6 +3080,7 @@ void sched_exec(void)
 
 		return;
 	}
+unlock:
 	task_rq_unlock(rq, &flags);
 }
 
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 49ad993..8a5e763 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -1423,7 +1423,8 @@ select_idle_sibling(struct task_struct *p, struct sched_domain *sd, int target)
  *
  * preempt must be disabled.
  */
-static int select_task_rq_fair(struct task_struct *p, int sd_flag, int wake_flags)
+static int
+select_task_rq_fair(struct rq *rq, struct task_struct *p, int sd_flag, int wake_flags)
 {
 	struct sched_domain *tmp, *affine_sd = NULL, *sd = NULL;
 	int cpu = smp_processor_id();
@@ -1521,8 +1522,11 @@ static int select_task_rq_fair(struct task_struct *p, int sd_flag, int wake_flag
 				  cpumask_weight(sched_domain_span(sd))))
 			tmp = affine_sd;
 
-		if (tmp)
+		if (tmp) {
+			raw_spin_unlock(&rq->lock);
 			update_shares(tmp);
+			raw_spin_lock(&rq->lock);
+		}
 	}
 #endif
 
diff --git a/kernel/sched_idletask.c b/kernel/sched_idletask.c
index a8a6d8a..5af709f 100644
--- a/kernel/sched_idletask.c
+++ b/kernel/sched_idletask.c
@@ -6,7 +6,8 @@
  */
 
 #ifdef CONFIG_SMP
-static int select_task_rq_idle(struct task_struct *p, int sd_flag, int flags)
+static int
+select_task_rq_idle(struct rq *rq, struct task_struct *p, int sd_flag, int flags)
 {
 	return task_cpu(p); /* IDLE tasks as never migrated */
 }
diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
index 012d69b..fde895f 100644
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -948,10 +948,9 @@ static void yield_task_rt(struct rq *rq)
 #ifdef CONFIG_SMP
 static int find_lowest_rq(struct task_struct *task);
 
-static int select_task_rq_rt(struct task_struct *p, int sd_flag, int flags)
+static int
+select_task_rq_rt(struct rq *rq, struct task_struct *p, int sd_flag, int flags)
 {
-	struct rq *rq = task_rq(p);
-
 	if (sd_flag != SD_BALANCE_WAKE)
 		return smp_processor_id();
 
