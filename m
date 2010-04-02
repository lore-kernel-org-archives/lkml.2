Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755187Ab0DBTMX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Apr 2010 15:12:23 -0400
Received: from hera.kernel.org ([140.211.167.34]:38795 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755098Ab0DBTML (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Apr 2010 15:12:11 -0400
Date: Fri, 2 Apr 2010 19:11:43 GMT
From: tip-bot for Oleg Nesterov <oleg@redhat.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, oleg@redhat.com, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, oleg@redhat.com,
       mingo@elte.hu
In-Reply-To: <20100315091003.GA9123@redhat.com>
References: <20100315091003.GA9123@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Kill the broken and deadlockable cpuset_lock/cpuset_cpus_allowed_locked code
Message-ID: <tip-897f0b3c3ff40b443c84e271bef19bd6ae885195@git.kernel.org>
Git-Commit-ID: 897f0b3c3ff40b443c84e271bef19bd6ae885195
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 02 Apr 2010 19:11:44 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  897f0b3c3ff40b443c84e271bef19bd6ae885195
Gitweb:     http://git.kernel.org/tip/897f0b3c3ff40b443c84e271bef19bd6ae885195
Author:     Oleg Nesterov <oleg@redhat.com>
AuthorDate: Mon, 15 Mar 2010 10:10:03 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 2 Apr 2010 20:12:01 +0200

sched: Kill the broken and deadlockable cpuset_lock/cpuset_cpus_allowed_locked code

This patch just states the fact the cpusets/cpuhotplug interaction is
broken and removes the deadlockable code which only pretends to work.

- cpuset_lock() doesn't really work. It is needed for
  cpuset_cpus_allowed_locked() but we can't take this lock in
  try_to_wake_up()->select_fallback_rq() path.

- cpuset_lock() is deadlockable. Suppose that a task T bound to CPU takes
  callback_mutex. If cpu_down(CPU) happens before T drops callback_mutex
  stop_machine() preempts T, then migration_call(CPU_DEAD) tries to take
  cpuset_lock() and hangs forever because CPU is already dead and thus
  T can't be scheduled.

- cpuset_cpus_allowed_locked() is deadlockable too. It takes task_lock()
  which is not irq-safe, but try_to_wake_up() can be called from irq.

Kill them, and change select_fallback_rq() to use cpu_possible_mask, like
we currently do without CONFIG_CPUSETS.

Also, with or without this patch, with or without CONFIG_CPUSETS, the
callers of select_fallback_rq() can race with each other or with
set_cpus_allowed() pathes.

The subsequent patches try to to fix these problems.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <20100315091003.GA9123@redhat.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/cpuset.h |   13 -------------
 kernel/cpuset.c        |   27 +--------------------------
 kernel/sched.c         |   10 +++-------
 3 files changed, 4 insertions(+), 46 deletions(-)

diff --git a/include/linux/cpuset.h b/include/linux/cpuset.h
index a5740fc..eeaaee7 100644
--- a/include/linux/cpuset.h
+++ b/include/linux/cpuset.h
@@ -21,8 +21,6 @@ extern int number_of_cpusets;	/* How many cpusets are defined in system? */
 extern int cpuset_init(void);
 extern void cpuset_init_smp(void);
 extern void cpuset_cpus_allowed(struct task_struct *p, struct cpumask *mask);
-extern void cpuset_cpus_allowed_locked(struct task_struct *p,
-				       struct cpumask *mask);
 extern nodemask_t cpuset_mems_allowed(struct task_struct *p);
 #define cpuset_current_mems_allowed (current->mems_allowed)
 void cpuset_init_current_mems_allowed(void);
@@ -69,9 +67,6 @@ struct seq_file;
 extern void cpuset_task_status_allowed(struct seq_file *m,
 					struct task_struct *task);
 
-extern void cpuset_lock(void);
-extern void cpuset_unlock(void);
-
 extern int cpuset_mem_spread_node(void);
 
 static inline int cpuset_do_page_mem_spread(void)
@@ -105,11 +100,6 @@ static inline void cpuset_cpus_allowed(struct task_struct *p,
 {
 	cpumask_copy(mask, cpu_possible_mask);
 }
-static inline void cpuset_cpus_allowed_locked(struct task_struct *p,
-					      struct cpumask *mask)
-{
-	cpumask_copy(mask, cpu_possible_mask);
-}
 
 static inline nodemask_t cpuset_mems_allowed(struct task_struct *p)
 {
@@ -157,9 +147,6 @@ static inline void cpuset_task_status_allowed(struct seq_file *m,
 {
 }
 
-static inline void cpuset_lock(void) {}
-static inline void cpuset_unlock(void) {}
-
 static inline int cpuset_mem_spread_node(void)
 {
 	return 0;
diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index d109467..9a747f5 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -2182,19 +2182,10 @@ void __init cpuset_init_smp(void)
 void cpuset_cpus_allowed(struct task_struct *tsk, struct cpumask *pmask)
 {
 	mutex_lock(&callback_mutex);
-	cpuset_cpus_allowed_locked(tsk, pmask);
-	mutex_unlock(&callback_mutex);
-}
-
-/**
- * cpuset_cpus_allowed_locked - return cpus_allowed mask from a tasks cpuset.
- * Must be called with callback_mutex held.
- **/
-void cpuset_cpus_allowed_locked(struct task_struct *tsk, struct cpumask *pmask)
-{
 	task_lock(tsk);
 	guarantee_online_cpus(task_cs(tsk), pmask);
 	task_unlock(tsk);
+	mutex_unlock(&callback_mutex);
 }
 
 void cpuset_init_current_mems_allowed(void)
@@ -2383,22 +2374,6 @@ int __cpuset_node_allowed_hardwall(int node, gfp_t gfp_mask)
 }
 
 /**
- * cpuset_lock - lock out any changes to cpuset structures
- *
- * The out of memory (oom) code needs to mutex_lock cpusets
- * from being changed while it scans the tasklist looking for a
- * task in an overlapping cpuset.  Expose callback_mutex via this
- * cpuset_lock() routine, so the oom code can lock it, before
- * locking the task list.  The tasklist_lock is a spinlock, so
- * must be taken inside callback_mutex.
- */
-
-void cpuset_lock(void)
-{
-	mutex_lock(&callback_mutex);
-}
-
-/**
  * cpuset_unlock - release lock on cpuset changes
  *
  * Undo the lock taken in a previous cpuset_lock() call.
diff --git a/kernel/sched.c b/kernel/sched.c
index 52b7efd..c0b3ebc 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -2296,11 +2296,9 @@ static int select_fallback_rq(int cpu, struct task_struct *p)
 		return dest_cpu;
 
 	/* No more Mr. Nice Guy. */
-	if (dest_cpu >= nr_cpu_ids) {
-		rcu_read_lock();
-		cpuset_cpus_allowed_locked(p, &p->cpus_allowed);
-		rcu_read_unlock();
-		dest_cpu = cpumask_any_and(cpu_active_mask, &p->cpus_allowed);
+	if (unlikely(dest_cpu >= nr_cpu_ids)) {
+		cpumask_copy(&p->cpus_allowed, cpu_possible_mask);
+		dest_cpu = cpumask_any(cpu_active_mask);
 
 		/*
 		 * Don't tell them about moving exiting tasks or
@@ -5866,7 +5864,6 @@ migration_call(struct notifier_block *nfb, unsigned long action, void *hcpu)
 
 	case CPU_DEAD:
 	case CPU_DEAD_FROZEN:
-		cpuset_lock(); /* around calls to cpuset_cpus_allowed_lock() */
 		migrate_live_tasks(cpu);
 		rq = cpu_rq(cpu);
 		kthread_stop(rq->migration_thread);
@@ -5879,7 +5876,6 @@ migration_call(struct notifier_block *nfb, unsigned long action, void *hcpu)
 		rq->idle->sched_class = &idle_sched_class;
 		migrate_dead_tasks(cpu);
 		raw_spin_unlock_irq(&rq->lock);
-		cpuset_unlock();
 		migrate_nr_uninterruptible(rq);
 		BUG_ON(rq->nr_running != 0);
 		calc_global_load_remove(rq);
