Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759029Ab2C2KvR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 06:51:17 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:38807 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753790Ab2C2KvE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 06:51:04 -0400
Date: Thu, 29 Mar 2012 12:50:57 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] scheduler fixes
Message-ID: <20120329105057.GA29113@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest sched-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git sched-urgent-for-linus

   HEAD: 160594e99dbbb0a5600ad922c630952c7c1c14bf cpusets: Remove an unused variable

 Thanks,

	Ingo

------------------>
Dan Carpenter (1):
      cpusets: Remove an unused variable

Ingo Molnar (1):
      MAINTAINERS: Update email address for SCHEDULER and PERF EVENTS

Michael J Wang (1):
      sched/rt: Improve pick_next_highest_task_rt()

Peter Zijlstra (3):
      sched: Fix compiler warning about declared inline after use
      sched/x86/smp: Do not enable IRQs over calibrate_delay()
      sched: Fix select_fallback_rq() vs cpu_active/cpu_online


 MAINTAINERS               |    4 +-
 arch/x86/kernel/smpboot.c |    5 ---
 include/linux/cpuset.h    |    6 +---
 kernel/cpuset.c           |   21 +++------------
 kernel/sched/core.c       |   62 +++++++++++++++++++++++++++++++++-----------
 kernel/sched/fair.c       |   16 ++++++------
 kernel/sched/rt.c         |    2 +-
 7 files changed, 63 insertions(+), 53 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 3321d75..1ad6a06 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5112,7 +5112,7 @@ F:	kernel/delayacct.c
 PERFORMANCE EVENTS SUBSYSTEM
 M:	Peter Zijlstra <a.p.zijlstra@chello.nl>
 M:	Paul Mackerras <paulus@samba.org>
-M:	Ingo Molnar <mingo@elte.hu>
+M:	Ingo Molnar <mingo@redhat.com>
 M:	Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git perf/core
 S:	Supported
@@ -5736,7 +5736,7 @@ S:	Maintained
 F:	drivers/watchdog/sc1200wdt.c
 
 SCHEDULER
-M:	Ingo Molnar <mingo@elte.hu>
+M:	Ingo Molnar <mingo@redhat.com>
 M:	Peter Zijlstra <peterz@infradead.org>
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git sched/core
 S:	Maintained
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 58f7816..89571a0 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -219,14 +219,9 @@ static void __cpuinit smp_callin(void)
 	 * Update loops_per_jiffy in cpu_data. Previous call to
 	 * smp_store_cpu_info() stored a value that is close but not as
 	 * accurate as the value just calculated.
-	 *
-	 * Need to enable IRQs because it can take longer and then
-	 * the NMI watchdog might kill us.
 	 */
-	local_irq_enable();
 	calibrate_delay();
 	cpu_data(cpuid).loops_per_jiffy = loops_per_jiffy;
-	local_irq_disable();
 	pr_debug("Stack at about %p\n", &cpuid);
 
 	/*
diff --git a/include/linux/cpuset.h b/include/linux/cpuset.h
index e9eaec5..e0ffaf0 100644
--- a/include/linux/cpuset.h
+++ b/include/linux/cpuset.h
@@ -22,7 +22,7 @@ extern int cpuset_init(void);
 extern void cpuset_init_smp(void);
 extern void cpuset_update_active_cpus(void);
 extern void cpuset_cpus_allowed(struct task_struct *p, struct cpumask *mask);
-extern int cpuset_cpus_allowed_fallback(struct task_struct *p);
+extern void cpuset_cpus_allowed_fallback(struct task_struct *p);
 extern nodemask_t cpuset_mems_allowed(struct task_struct *p);
 #define cpuset_current_mems_allowed (current->mems_allowed)
 void cpuset_init_current_mems_allowed(void);
@@ -144,10 +144,8 @@ static inline void cpuset_cpus_allowed(struct task_struct *p,
 	cpumask_copy(mask, cpu_possible_mask);
 }
 
-static inline int cpuset_cpus_allowed_fallback(struct task_struct *p)
+static inline void cpuset_cpus_allowed_fallback(struct task_struct *p)
 {
-	do_set_cpus_allowed(p, cpu_possible_mask);
-	return cpumask_any(cpu_active_mask);
 }
 
 static inline nodemask_t cpuset_mems_allowed(struct task_struct *p)
diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index a09ac2b..4ef4d7e 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -2195,10 +2195,9 @@ void cpuset_cpus_allowed(struct task_struct *tsk, struct cpumask *pmask)
 	mutex_unlock(&callback_mutex);
 }
 
-int cpuset_cpus_allowed_fallback(struct task_struct *tsk)
+void cpuset_cpus_allowed_fallback(struct task_struct *tsk)
 {
 	const struct cpuset *cs;
-	int cpu;
 
 	rcu_read_lock();
 	cs = task_cs(tsk);
@@ -2219,22 +2218,10 @@ int cpuset_cpus_allowed_fallback(struct task_struct *tsk)
 	 * changes in tsk_cs()->cpus_allowed. Otherwise we can temporary
 	 * set any mask even if it is not right from task_cs() pov,
 	 * the pending set_cpus_allowed_ptr() will fix things.
+	 *
+	 * select_fallback_rq() will fix things ups and set cpu_possible_mask
+	 * if required.
 	 */
-
-	cpu = cpumask_any_and(&tsk->cpus_allowed, cpu_active_mask);
-	if (cpu >= nr_cpu_ids) {
-		/*
-		 * Either tsk->cpus_allowed is wrong (see above) or it
-		 * is actually empty. The latter case is only possible
-		 * if we are racing with remove_tasks_in_empty_cpuset().
-		 * Like above we can temporary set any mask and rely on
-		 * set_cpus_allowed_ptr() as synchronization point.
-		 */
-		do_set_cpus_allowed(tsk, cpu_possible_mask);
-		cpu = cpumask_any(cpu_active_mask);
-	}
-
-	return cpu;
 }
 
 void cpuset_init_current_mems_allowed(void)
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index e3ccc13..9c1629c 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -1263,29 +1263,59 @@ EXPORT_SYMBOL_GPL(kick_process);
  */
 static int select_fallback_rq(int cpu, struct task_struct *p)
 {
-	int dest_cpu;
 	const struct cpumask *nodemask = cpumask_of_node(cpu_to_node(cpu));
+	enum { cpuset, possible, fail } state = cpuset;
+	int dest_cpu;
 
 	/* Look for allowed, online CPU in same node. */
-	for_each_cpu_and(dest_cpu, nodemask, cpu_active_mask)
+	for_each_cpu_mask(dest_cpu, *nodemask) {
+		if (!cpu_online(dest_cpu))
+			continue;
+		if (!cpu_active(dest_cpu))
+			continue;
 		if (cpumask_test_cpu(dest_cpu, tsk_cpus_allowed(p)))
 			return dest_cpu;
+	}
 
-	/* Any allowed, online CPU? */
-	dest_cpu = cpumask_any_and(tsk_cpus_allowed(p), cpu_active_mask);
-	if (dest_cpu < nr_cpu_ids)
-		return dest_cpu;
+	for (;;) {
+		/* Any allowed, online CPU? */
+		for_each_cpu_mask(dest_cpu, *tsk_cpus_allowed(p)) {
+			if (!cpu_online(dest_cpu))
+				continue;
+			if (!cpu_active(dest_cpu))
+				continue;
+			goto out;
+		}
 
-	/* No more Mr. Nice Guy. */
-	dest_cpu = cpuset_cpus_allowed_fallback(p);
-	/*
-	 * Don't tell them about moving exiting tasks or
-	 * kernel threads (both mm NULL), since they never
-	 * leave kernel.
-	 */
-	if (p->mm && printk_ratelimit()) {
-		printk_sched("process %d (%s) no longer affine to cpu%d\n",
-				task_pid_nr(p), p->comm, cpu);
+		switch (state) {
+		case cpuset:
+			/* No more Mr. Nice Guy. */
+			cpuset_cpus_allowed_fallback(p);
+			state = possible;
+			break;
+
+		case possible:
+			do_set_cpus_allowed(p, cpu_possible_mask);
+			state = fail;
+			break;
+
+		case fail:
+			BUG();
+			break;
+		}
+	}
+
+out:
+	if (state != cpuset) {
+		/*
+		 * Don't tell them about moving exiting tasks or
+		 * kernel threads (both mm NULL), since they never
+		 * leave kernel.
+		 */
+		if (p->mm && printk_ratelimit()) {
+			printk_sched("process %d (%s) no longer affine to cpu%d\n",
+					task_pid_nr(p), p->comm, cpu);
+		}
 	}
 
 	return dest_cpu;
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 11f3979..258f430 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -416,8 +416,8 @@ find_matching_se(struct sched_entity **se, struct sched_entity **pse)
 
 #endif	/* CONFIG_FAIR_GROUP_SCHED */
 
-static void account_cfs_rq_runtime(struct cfs_rq *cfs_rq,
-				   unsigned long delta_exec);
+static __always_inline
+void account_cfs_rq_runtime(struct cfs_rq *cfs_rq, unsigned long delta_exec);
 
 /**************************************************************
  * Scheduling class tree data structure manipulation methods:
@@ -1162,7 +1162,7 @@ static void clear_buddies(struct cfs_rq *cfs_rq, struct sched_entity *se)
 		__clear_buddies_skip(se);
 }
 
-static void return_cfs_rq_runtime(struct cfs_rq *cfs_rq);
+static __always_inline void return_cfs_rq_runtime(struct cfs_rq *cfs_rq);
 
 static void
 dequeue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int flags)
@@ -1546,8 +1546,8 @@ static void __account_cfs_rq_runtime(struct cfs_rq *cfs_rq,
 		resched_task(rq_of(cfs_rq)->curr);
 }
 
-static __always_inline void account_cfs_rq_runtime(struct cfs_rq *cfs_rq,
-						   unsigned long delta_exec)
+static __always_inline
+void account_cfs_rq_runtime(struct cfs_rq *cfs_rq, unsigned long delta_exec)
 {
 	if (!cfs_bandwidth_used() || !cfs_rq->runtime_enabled)
 		return;
@@ -2073,11 +2073,11 @@ void unthrottle_offline_cfs_rqs(struct rq *rq)
 }
 
 #else /* CONFIG_CFS_BANDWIDTH */
-static void account_cfs_rq_runtime(struct cfs_rq *cfs_rq,
-				     unsigned long delta_exec) {}
+static __always_inline
+void account_cfs_rq_runtime(struct cfs_rq *cfs_rq, unsigned long delta_exec) {}
 static void check_cfs_rq_runtime(struct cfs_rq *cfs_rq) {}
 static void check_enqueue_throttle(struct cfs_rq *cfs_rq) {}
-static void return_cfs_rq_runtime(struct cfs_rq *cfs_rq) {}
+static __always_inline void return_cfs_rq_runtime(struct cfs_rq *cfs_rq) {}
 
 static inline int cfs_rq_throttled(struct cfs_rq *cfs_rq)
 {
diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
index b60dad7..44af55e 100644
--- a/kernel/sched/rt.c
+++ b/kernel/sched/rt.c
@@ -1428,7 +1428,7 @@ static struct task_struct *pick_next_highest_task_rt(struct rq *rq, int cpu)
 next_idx:
 		if (idx >= MAX_RT_PRIO)
 			continue;
-		if (next && next->prio < idx)
+		if (next && next->prio <= idx)
 			continue;
 		list_for_each_entry(rt_se, array->queue + idx, run_list) {
 			struct task_struct *p;
