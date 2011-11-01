Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755986Ab1KAVVH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Nov 2011 17:21:07 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:20754 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932395Ab1KAVVB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Nov 2011 17:21:01 -0400
From: Glauber Costa <glommer@parallels.com>
To: linux-kernel@vger.kernel.org
Cc: paul@paulmenage.org, lizf@cn.fujitsu.com, daniel.lezcano@free.fr,
        a.p.zijlstra@chello.nl, jbottomley@parallels.com, pjt@google.com,
        fweisbec@gmail.com, Glauber Costa <glommer@parallels.com>
Subject: [PATCH v2 09/14] Keep nr_iowait per cgroup
Date: Tue,  1 Nov 2011 19:19:15 -0200
Message-Id: <1320182360-20043-10-git-send-email-glommer@parallels.com>
X-Mailer: git-send-email 1.7.6.4
In-Reply-To: <1320182360-20043-1-git-send-email-glommer@parallels.com>
References: <1320182360-20043-1-git-send-email-glommer@parallels.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since we are able to know precisely which process are waiting for I/O,
keep nr_iowait per-cgroup. this is used by the idle tick to calculate
whether the system is considered to be idle, or waiting for I/O.

When only the root cgroup is enabled, this should be not too much different
from before.

Signed-off-by: Glauber Costa <glommer@parallels.com>
---
 include/linux/kernel_stat.h |    1 +
 kernel/sched.c              |   83 +++++++++++++++++++++++++++++++++++-------
 2 files changed, 70 insertions(+), 14 deletions(-)

diff --git a/include/linux/kernel_stat.h b/include/linux/kernel_stat.h
index a0f1182..77e91f6 100644
--- a/include/linux/kernel_stat.h
+++ b/include/linux/kernel_stat.h
@@ -35,6 +35,7 @@ enum cpu_usage_stat {
 
 struct kernel_cpustat {
 	u64 cpustat[NR_STATS];
+	atomic_t nr_iowait;
 };
 
 struct kernel_stat {
diff --git a/kernel/sched.c b/kernel/sched.c
index c7ac150..800728e 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -639,8 +639,6 @@ struct rq {
 	u64 clock;
 	u64 clock_task;
 
-	atomic_t nr_iowait;
-
 #ifdef CONFIG_SMP
 	struct root_domain *rd;
 	struct sched_domain *sd;
@@ -817,6 +815,7 @@ static inline void task_group_account_field(struct task_struct *p,
 	 * get ourselves ahead and touch it first. If the root cgroup
 	 * is the only cgroup, then nothing else should be necessary.
 	 *
+	 * Same thing applies to the iowait related functions.
 	 */
 	__get_cpu_var(kernel_cpustat).cpustat[index] += tmp;
 
@@ -837,6 +836,50 @@ static inline void task_group_account_field(struct task_struct *p,
 #endif
 }
 
+static inline void task_group_nr_iowait_inc(struct task_struct *p, int cpu)
+{
+
+	atomic_inc(&per_cpu(kernel_cpustat, cpu).nr_iowait);
+
+#ifdef CONFIG_CGROUP_SCHED
+	if (static_branch(&sched_cgroup_enabled)) {
+		struct kernel_cpustat *kcpustat;
+		struct task_group *tg;
+
+		rcu_read_lock();
+		tg = task_group(p);
+		while (tg && (tg != &root_task_group)) {
+			kcpustat = per_cpu_ptr(tg->cpustat, cpu);
+			atomic_inc(&kcpustat->nr_iowait);
+			tg = tg->parent;
+		}
+		rcu_read_unlock();
+	}
+#endif
+}
+
+static inline void task_group_nr_iowait_dec(struct task_struct *p, int cpu)
+{
+
+	atomic_dec(&per_cpu(kernel_cpustat, cpu).nr_iowait);
+
+#ifdef CONFIG_CGROUP_SCHED
+	if (static_branch(&sched_cgroup_enabled)) {
+		struct kernel_cpustat *kcpustat;
+		struct task_group *tg;
+
+		rcu_read_lock();
+		tg = task_group(p);
+		while (tg && (tg != &root_task_group)) {
+			kcpustat = per_cpu_ptr(tg->cpustat, cpu);
+			atomic_dec(&kcpustat->nr_iowait);
+			tg = tg->parent;
+		}
+		rcu_read_unlock();
+	}
+#endif
+}
+
 void task_group_new_fork(struct task_struct *p)
 {
 	task_group_account_field(p, 1, TOTAL_FORKS);
@@ -3442,16 +3485,24 @@ unsigned long nr_iowait(void)
 {
 	unsigned long i, sum = 0;
 
-	for_each_possible_cpu(i)
-		sum += atomic_read(&cpu_rq(i)->nr_iowait);
+	for_each_possible_cpu(i) {
+		kstat_lock();
+		sum += atomic_read(&per_cpu(kernel_cpustat, i).nr_iowait);
+		kstat_unlock();
+	}
 
 	return sum;
 }
 
 unsigned long nr_iowait_cpu(int cpu)
 {
-	struct rq *this = cpu_rq(cpu);
-	return atomic_read(&this->nr_iowait);
+	unsigned long ret;
+
+	kstat_lock();
+	ret = atomic_read(&per_cpu(kernel_cpustat, cpu).nr_iowait);
+	kstat_unlock();
+
+	return ret;
 }
 
 unsigned long this_cpu_load(void)
@@ -4043,12 +4094,11 @@ void account_idle_time(cputime_t cputime)
 {
 	struct kernel_cpustat *kcpustat;
 	u64 cputime64 = cputime_to_cputime64(cputime);
-	struct rq *rq = this_rq();
 
 	kstat_lock();
 	kcpustat = kcpustat_this_cpu;
 
-	if (atomic_read(&rq->nr_iowait) > 0)
+	if (atomic_read(&kcpustat->nr_iowait) > 0)
 		kcpustat->cpustat[IOWAIT] += cputime64;
 	else
 		/* idle is always accounted to the root cgroup */
@@ -5915,14 +5965,15 @@ EXPORT_SYMBOL_GPL(yield_to);
 void __sched io_schedule(void)
 {
 	struct rq *rq = raw_rq();
+	int cpu = cpu_of(rq);
 
 	delayacct_blkio_start();
-	atomic_inc(&rq->nr_iowait);
+	task_group_nr_iowait_inc(current, cpu);
 	blk_flush_plug(current);
 	current->in_iowait = 1;
 	schedule();
 	current->in_iowait = 0;
-	atomic_dec(&rq->nr_iowait);
+	task_group_nr_iowait_dec(current, cpu);
 	delayacct_blkio_end();
 }
 EXPORT_SYMBOL(io_schedule);
@@ -5930,15 +5981,16 @@ EXPORT_SYMBOL(io_schedule);
 long __sched io_schedule_timeout(long timeout)
 {
 	struct rq *rq = raw_rq();
+	int cpu = cpu_of(rq);
 	long ret;
 
 	delayacct_blkio_start();
-	atomic_inc(&rq->nr_iowait);
+	task_group_nr_iowait_inc(current, cpu);
 	blk_flush_plug(current);
 	current->in_iowait = 1;
 	ret = schedule_timeout(timeout);
 	current->in_iowait = 0;
-	atomic_dec(&rq->nr_iowait);
+	task_group_nr_iowait_dec(current, cpu);
 	delayacct_blkio_end();
 	return ret;
 }
@@ -8363,7 +8415,6 @@ void __init sched_init(void)
 #endif
 #endif
 		init_rq_hrtick(rq);
-		atomic_set(&rq->nr_iowait, 0);
 	}
 
 	set_load_weight(&init_task);
@@ -8766,6 +8817,7 @@ struct task_group *sched_create_group(struct task_group *parent)
 		root_kstat = per_cpu_ptr(root_task_group.cpustat, i);
 		kcpustat->cpustat[IDLE_BASE]  = root_kstat->cpustat[IDLE];
 		kcpustat->cpustat[STEAL_BASE]  = root_kstat->cpustat[STEAL];
+		atomic_set(&kcpustat->nr_iowait, 0);
 		kstat_unlock();
 	}
 
@@ -9660,6 +9712,7 @@ int cpu_cgroup_proc_stat(struct cgroup *cgrp, struct cftype *cft,
 	u64 total_forks = 0;
 	unsigned int per_softirq_sums[NR_SOFTIRQS] = {0};
 	struct timespec boottime;
+	unsigned long tg_iowait = 0;
 #ifdef CONFIG_CGROUP_SCHED
 	struct task_group *tg;
 	struct task_group *sib;
@@ -9701,6 +9754,8 @@ int cpu_cgroup_proc_stat(struct cgroup *cgrp, struct cftype *cft,
 		guest += kcpustat->cpustat[GUEST];
 		guest_nice += kcpustat->cpustat[GUEST_NICE];
 		total_forks += kcpustat->cpustat[TOTAL_FORKS];
+		tg_iowait += atomic_read(&kcpustat->nr_iowait);
+
 #ifdef CONFIG_CGROUP_SCHED
 		if (static_branch(&sched_cgroup_enabled)) {
 			list_for_each_entry(sib, &tg->siblings, siblings) {
@@ -9807,7 +9862,7 @@ int cpu_cgroup_proc_stat(struct cgroup *cgrp, struct cftype *cft,
 		(unsigned long)jif,
 		total_forks,
 		nr_running(),
-		nr_iowait());
+		tg_iowait),
 
 	seq_printf(p, "softirq %llu", (unsigned long long)sum_softirq);
 
-- 
1.7.6.4

