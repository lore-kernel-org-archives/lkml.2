Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754264Ab1JBTYU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Oct 2011 15:24:20 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:8948 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751620Ab1JBTW3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Oct 2011 15:22:29 -0400
From: Glauber Costa <glommer@parallels.com>
To: linux-kernel@vger.kernel.org
Cc: paul@paulmenage.org, lizf@cn.fujitsu.com, daniel.lezcano@free.fr,
        a.p.zijlstra@chello.nl, jbottomley@parallels.com,
        Glauber Costa <glommer@parallels.com>
Subject: [PATCH 04/10] Display /proc/stat information per cgroup
Date: Sun,  2 Oct 2011 23:21:21 +0400
Message-Id: <1317583287-18300-5-git-send-email-glommer@parallels.com>
X-Mailer: git-send-email 1.7.6.2
In-Reply-To: <1317583287-18300-1-git-send-email-glommer@parallels.com>
References: <1317583287-18300-1-git-send-email-glommer@parallels.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Each cgroup has its own file, cpu.proc.stat that will
display the exact same format as /proc/stat. Users
that want to have access to a per-cgroup version of
this information, can query it for that purpose.

Signed-off-by: Glauber Costa <glommer@parallels.com>
---
 fs/proc/stat.c              |    2 +-
 include/linux/kernel_stat.h |   11 ++-
 include/linux/sched.h       |    5 +-
 kernel/sched.c              |  202 +++++++++++++++++++++++++++++++------------
 4 files changed, 160 insertions(+), 60 deletions(-)

diff --git a/fs/proc/stat.c b/fs/proc/stat.c
index 6b10387..c9b2ae9 100644
--- a/fs/proc/stat.c
+++ b/fs/proc/stat.c
@@ -13,7 +13,7 @@
 
 static int show_stat(struct seq_file *p, void *v)
 {
-	return cpu_cgroup_proc_stat(p);
+	return cpu_cgroup_proc_stat(NULL, NULL, p);
 }
 
 static int stat_open(struct inode *inode, struct file *file)
diff --git a/include/linux/kernel_stat.h b/include/linux/kernel_stat.h
index 897eabf..71a69a0 100644
--- a/include/linux/kernel_stat.h
+++ b/include/linux/kernel_stat.h
@@ -27,6 +27,8 @@ enum cpu_usage_stat {
 	STEAL,
 	GUEST,
 	GUEST_NICE,
+	IDLE_BASE,
+	IOWAIT_BASE,
 	NR_STATS,
 };
 
@@ -39,11 +41,18 @@ struct kernel_stat {
 	unsigned int softirqs[NR_SOFTIRQS];
 };
 
-DECLARE_PER_CPU(struct kernel_stat, kstat);
+#ifdef CONFIG_CGROUP_SCHED
+struct kernel_stat *task_group_kstat(struct task_struct *p);
 
 /* Must have preemption disabled for this to be meaningful. */
+#define kstat_this_cpu	this_cpu_ptr(task_group_kstat(current))
+#define kstat_cpu(cpu) (*per_cpu_ptr(task_group_kstat(current), cpu))
+#else
+DECLARE_PER_CPU(struct kernel_stat, kstat);
+
 #define kstat_this_cpu (&__get_cpu_var(kstat))
 #define kstat_cpu(cpu) per_cpu(kstat, cpu)
+#endif
 
 extern unsigned long long nr_context_switches(void);
 
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 25658d8..64c5ba5 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -2712,7 +2712,10 @@ static inline unsigned long rlimit_max(unsigned int limit)
 	return task_rlimit_max(current, limit);
 }
 
-int cpu_cgroup_proc_stat(struct seq_file *p);
+struct cgroup;
+struct cftype;
+int cpu_cgroup_proc_stat(struct cgroup *cgrp, struct cftype *cft,
+			 struct seq_file *p);
 #endif /* __KERNEL__ */
 
 #endif
diff --git a/kernel/sched.c b/kernel/sched.c
index 482e645..89d2248 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -278,6 +278,7 @@ struct task_group {
 #ifdef CONFIG_SCHED_AUTOGROUP
 	struct autogroup *autogroup;
 #endif
+	struct kernel_stat __percpu *cpustat;
 };
 
 /* task_group_lock serializes the addition/removal of task groups */
@@ -631,6 +632,17 @@ static inline struct task_group *task_group(struct task_struct *p)
 	return autogroup_task_group(p, tg);
 }
 
+struct kernel_stat *task_group_kstat(struct task_struct *p)
+{
+	struct task_group *tg;
+	struct kernel_stat *kstat;
+
+	rcu_read_lock();
+	tg = task_group(p);
+	kstat = tg->cpustat;
+	rcu_read_unlock();
+	return kstat;
+}
 /* Change a task's cfs_rq and parent entity if it moves across CPUs/groups */
 static inline void set_task_rq(struct task_struct *p, unsigned int cpu)
 {
@@ -645,6 +657,22 @@ static inline void set_task_rq(struct task_struct *p, unsigned int cpu)
 #endif
 }
 
+static inline void task_group_account_field(struct task_struct *p,
+					     u64 tmp, int index)
+{
+	struct kernel_stat *kstat;
+	struct task_group *tg;
+
+	rcu_read_lock();
+	tg = task_group(p);
+	do {
+		kstat = this_cpu_ptr(tg->cpustat);
+		kstat->cpustat[index] += tmp;
+		tg = tg->parent;
+	} while (tg);
+	rcu_read_unlock();
+}
+
 #else /* CONFIG_CGROUP_SCHED */
 
 static inline void set_task_rq(struct task_struct *p, unsigned int cpu) { }
@@ -653,6 +681,14 @@ static inline struct task_group *task_group(struct task_struct *p)
 	return NULL;
 }
 
+DEFINE_PER_CPU(struct kernel_stat, kstat);
+EXPORT_PER_CPU_SYMBOL(kstat);
+
+static inline void task_group_account_field(struct task_struct *p,
+					     u64 tmp, int index)
+{
+	__this_cpu_add(kstat.cpustat[index], tmp);
+}
 #endif /* CONFIG_CGROUP_SCHED */
 
 static void update_rq_clock_task(struct rq *rq, s64 delta);
@@ -3669,10 +3705,6 @@ unlock:
 
 #endif
 
-DEFINE_PER_CPU(struct kernel_stat, kstat);
-
-EXPORT_PER_CPU_SYMBOL(kstat);
-
 /*
  * Return any ns on the sched_clock that have not yet been accounted in
  * @p in case that task is currently running.
@@ -3757,7 +3789,6 @@ unsigned long long thread_group_sched_runtime(struct task_struct *p)
 void account_user_time(struct task_struct *p, cputime_t cputime,
 		       cputime_t cputime_scaled)
 {
-	u64 *cpustat = kstat_this_cpu->cpustat;
 	u64 tmp;
 
 	/* Add user time to process. */
@@ -3769,9 +3800,9 @@ void account_user_time(struct task_struct *p, cputime_t cputime,
 	tmp = cputime_to_cputime64(cputime);
 
 	if (TASK_NICE(p) > 0)
-		cpustat[NICE] += tmp;
+		task_group_account_field(p, tmp, NICE);
 	else
-		cpustat[USER] += tmp;
+		task_group_account_field(p, tmp, USER);
 
 	cpuacct_update_stats(p, CPUACCT_STAT_USER, cputime);
 	/* Account for user time used */
@@ -3788,7 +3819,6 @@ static void account_guest_time(struct task_struct *p, cputime_t cputime,
 			       cputime_t cputime_scaled)
 {
 	u64 tmp;
-	u64 *cpustat = kstat_this_cpu->cpustat;
 
 	tmp = cputime_to_cputime64(cputime);
 
@@ -3800,11 +3830,11 @@ static void account_guest_time(struct task_struct *p, cputime_t cputime,
 
 	/* Add guest time to cpustat. */
 	if (TASK_NICE(p) > 0) {
-		cpustat[NICE] += tmp;
-		cpustat[GUEST_NICE] += tmp;
+		task_group_account_field(p, tmp, NICE);
+		task_group_account_field(p, tmp, GUEST_NICE);
 	} else {
-		cpustat[USER] += tmp;
-		cpustat[GUEST] += tmp;
+		task_group_account_field(p, tmp, USER);
+		task_group_account_field(p, tmp, GUEST);
 	}
 }
 
@@ -3817,7 +3847,7 @@ static void account_guest_time(struct task_struct *p, cputime_t cputime,
  */
 static inline
 void __account_system_time(struct task_struct *p, cputime_t cputime,
-			cputime_t cputime_scaled, u64 *target_cputime64)
+			cputime_t cputime_scaled, int index)
 {
 	u64 tmp = cputime_to_cputime64(cputime);
 
@@ -3827,7 +3857,7 @@ void __account_system_time(struct task_struct *p, cputime_t cputime,
 	account_group_system_time(p, cputime);
 
 	/* Add system time to cpustat. */
-	*target_cputime64 += tmp;
+	task_group_account_field(p, tmp, index);
 	cpuacct_update_stats(p, CPUACCT_STAT_SYSTEM, cputime);
 
 	/* Account for system time used */
@@ -3844,8 +3874,7 @@ void __account_system_time(struct task_struct *p, cputime_t cputime,
 void account_system_time(struct task_struct *p, int hardirq_offset,
 			 cputime_t cputime, cputime_t cputime_scaled)
 {
-	u64 *cpustat = kstat_this_cpu->cpustat;
-	u64 *target_cputime64;
+	int index;
 
 	if ((p->flags & PF_VCPU) && (irq_count() - hardirq_offset == 0)) {
 		account_guest_time(p, cputime, cputime_scaled);
@@ -3853,13 +3882,13 @@ void account_system_time(struct task_struct *p, int hardirq_offset,
 	}
 
 	if (hardirq_count() - hardirq_offset)
-		target_cputime64 = &cpustat[IRQ];
+		index = IRQ;
 	else if (in_serving_softirq())
-		target_cputime64 = &cpustat[SOFTIRQ];
+		index = SOFTIRQ;
 	else
-		target_cputime64 = &cpustat[SYSTEM];
+		index = SYSTEM;
 
-	__account_system_time(p, cputime, cputime_scaled, target_cputime64);
+	__account_system_time(p, cputime, cputime_scaled, index);
 }
 
 /*
@@ -3868,10 +3897,14 @@ void account_system_time(struct task_struct *p, int hardirq_offset,
  */
 void account_steal_time(cputime_t cputime)
 {
-	u64 *cpustat = kstat_this_cpu->cpustat;
+	struct kernel_stat *kstat;
 	u64 cputime64 = cputime_to_cputime64(cputime);
-
-	cpustat[STEAL] += cputime64;
+#ifdef CONFIG_CGROUP_SCHED
+	kstat = this_cpu_ptr(root_task_group.cpustat);
+#else
+	kstat = __get_cpu_var(kstat);
+#endif
+	kstat->cpustat[STEAL] += cputime64;
 }
 
 /*
@@ -3880,14 +3913,18 @@ void account_steal_time(cputime_t cputime)
  */
 void account_idle_time(cputime_t cputime)
 {
-	u64 *cpustat = kstat_this_cpu->cpustat;
+	struct kernel_stat *kstat;
 	u64 cputime64 = cputime_to_cputime64(cputime);
 	struct rq *rq = this_rq();
-
+#ifdef CONFIG_CGROUP_SCHED
+	kstat = this_cpu_ptr(root_task_group.cpustat);
+#else
+	kstat = __get_cpu_var(kstat);
+#endif
 	if (atomic_read(&rq->nr_iowait) > 0)
-		cpustat[IOWAIT] += cputime64;
+		kstat->cpustat[IOWAIT] += cputime64;
 	else
-		cpustat[IDLE] += cputime64;
+		kstat->cpustat[IDLE] += cputime64;
 }
 
 static __always_inline bool steal_account_process_tick(void)
@@ -3934,27 +3971,26 @@ static __always_inline bool steal_account_process_tick(void)
  * softirq as those do not count in task exec_runtime any more.
  */
 static void irqtime_account_process_tick(struct task_struct *p, int user_tick,
-						struct rq *rq)
+					 struct rq *rq)
 {
 	cputime_t one_jiffy_scaled = cputime_to_scaled(cputime_one_jiffy);
 	u64 tmp = cputime_to_cputime64(cputime_one_jiffy);
-	u64 *cpustat = kstat_this_cpu->cpustat;
 
 	if (steal_account_process_tick())
 		return;
 
 	if (irqtime_account_hi_update()) {
-		cpustat[IRQ] += tmp;
+		task_group_account_field(p, tmp, IRQ);
 	} else if (irqtime_account_si_update()) {
-		cpustat[SOFTIRQ] += tmp;
+		task_group_account_field(p, tmp, SOFTIRQ);
 	} else if (this_cpu_ksoftirqd() == p) {
 		/*
 		 * ksoftirqd time do not get accounted in cpu_softirq_time.
 		 * So, we have to handle it separately here.
 		 * Also, p->stime needs to be updated for ksoftirqd.
 		 */
-		__account_system_time(p, cputime_one_jiffy, one_jiffy_scaled,
-					&cpustat[SOFTIRQ]);
+		__account_system_time(p, cputime_one_jiffy,
+				      one_jiffy_scaled, SOFTIRQ);
 	} else if (user_tick) {
 		account_user_time(p, cputime_one_jiffy, one_jiffy_scaled);
 	} else if (p == rq->idle) {
@@ -3962,8 +3998,8 @@ static void irqtime_account_process_tick(struct task_struct *p, int user_tick,
 	} else if (p->flags & PF_VCPU) { /* System time or guest time */
 		account_guest_time(p, cputime_one_jiffy, one_jiffy_scaled);
 	} else {
-		__account_system_time(p, cputime_one_jiffy, one_jiffy_scaled,
-					&cpustat[SYSTEM]);
+		__account_system_time(p, cputime_one_jiffy,
+				      one_jiffy_scaled, SYSTEM);
 	}
 }
 
@@ -8085,6 +8121,10 @@ void __init sched_init(void)
 	INIT_LIST_HEAD(&root_task_group.children);
 	INIT_LIST_HEAD(&root_task_group.siblings);
 	autogroup_init(&init_task);
+
+	root_task_group.cpustat = alloc_percpu(struct kernel_stat);
+	/* Failing that early an allocation means we're screwed anyway */
+	BUG_ON(!root_task_group.cpustat);
 #endif /* CONFIG_CGROUP_SCHED */
 
 	for_each_possible_cpu(i) {
@@ -8519,6 +8559,7 @@ static void free_sched_group(struct task_group *tg)
 	free_fair_sched_group(tg);
 	free_rt_sched_group(tg);
 	autogroup_free(tg);
+	free_percpu(tg->cpustat);
 	kfree(tg);
 }
 
@@ -8527,6 +8568,7 @@ struct task_group *sched_create_group(struct task_group *parent)
 {
 	struct task_group *tg;
 	unsigned long flags;
+	int i;
 
 	tg = kzalloc(sizeof(*tg), GFP_KERNEL);
 	if (!tg)
@@ -8538,6 +8580,19 @@ struct task_group *sched_create_group(struct task_group *parent)
 	if (!alloc_rt_sched_group(tg, parent))
 		goto err;
 
+	tg->cpustat = alloc_percpu(struct kernel_stat);
+	if (!tg->cpustat)
+		goto err;
+
+	for_each_possible_cpu(i) {
+		struct kernel_stat *kstat, *root_kstat;
+
+		kstat = per_cpu_ptr(tg->cpustat, i);
+		root_kstat = per_cpu_ptr(root_task_group.cpustat, i);
+		kstat->cpustat[IDLE_BASE]  = root_kstat->cpustat[IDLE];
+		kstat->cpustat[IOWAIT_BASE] = root_kstat->cpustat[IOWAIT];
+	}
+
 	spin_lock_irqsave(&task_group_lock, flags);
 	list_add_rcu(&tg->list, &task_groups);
 
@@ -9062,6 +9117,10 @@ static struct cftype cpu_files[] = {
 		.write_u64 = cpu_rt_period_write_uint,
 	},
 #endif
+	{
+		.name = "proc.stat",
+		.read_seq_string = cpu_cgroup_proc_stat,
+	},
 };
 
 static int cpu_cgroup_populate(struct cgroup_subsys *ss, struct cgroup *cont)
@@ -9093,7 +9152,8 @@ struct cgroup_subsys cpu_cgroup_subsys = {
 #define arch_idle_time(cpu) 0
 #endif
 
-int cpu_cgroup_proc_stat(struct seq_file *p)
+int cpu_cgroup_proc_stat(struct cgroup *cgrp, struct cftype *cft,
+			 struct seq_file *p)
 {
 	int i, j;
 	unsigned long jif;
@@ -9103,6 +9163,14 @@ int cpu_cgroup_proc_stat(struct seq_file *p)
 	u64 sum_softirq = 0;
 	unsigned int per_softirq_sums[NR_SOFTIRQS] = {0};
 	struct timespec boottime;
+#ifdef CONFIG_CGROUP_SCHED
+	struct task_group *tg;
+
+	if (cgrp)
+		tg = cgroup_tg(cgrp);
+	else
+		tg = &root_task_group;
+#endif
 
 	user = nice = system = idle = iowait =
 		irq = softirq = steal = 0;
@@ -9111,17 +9179,28 @@ int cpu_cgroup_proc_stat(struct seq_file *p)
 	jif = boottime.tv_sec;
 
 	for_each_possible_cpu(i) {
-		user += kstat_this_cpu->cpustat[USER];
-		nice += kstat_this_cpu->cpustat[NICE];
-		system += kstat_this_cpu->cpustat[SYSTEM];
-		idle += kstat_this_cpu->cpustat[IDLE];
+		struct kernel_stat *kstat, *idle_kstat;
+#ifdef CONFIG_CGROUP_SCHED
+		kstat = per_cpu_ptr(tg->cpustat, i);
+		idle_kstat = per_cpu_ptr(root_task_group.cpustat, i);
+#else
+		kstat = per_cpu(kstat, i);
+		idle_kstat = kstat;
+#endif
+
+		user += kstat->cpustat[USER];
+		nice += kstat->cpustat[NICE];
+		system += kstat->cpustat[SYSTEM];
+		idle += idle_kstat->cpustat[IDLE];
 		idle += arch_idle_time(i);
-		iowait += kstat_this_cpu->cpustat[IOWAIT];
-		irq += kstat_this_cpu->cpustat[IRQ];
-		softirq += kstat_this_cpu->cpustat[SOFTIRQ];
-		steal += kstat_this_cpu->cpustat[STEAL];
-		guest += kstat_this_cpu->cpustat[GUEST];
-		guest_nice += kstat_this_cpu->cpustat[GUEST_NICE];
+		idle -= kstat->cpustat[IDLE_BASE];
+		iowait += idle_kstat->cpustat[IOWAIT];
+		iowait -= kstat->cpustat[IOWAIT_BASE];
+		irq += kstat->cpustat[IRQ];
+		softirq += kstat->cpustat[SOFTIRQ];
+		steal += kstat->cpustat[STEAL];
+		guest += kstat->cpustat[GUEST];
+		guest_nice += kstat->cpustat[GUEST_NICE];
 		sum += kstat_cpu_irqs_sum(i);
 		sum += arch_irq_stat_cpu(i);
 
@@ -9147,19 +9226,28 @@ int cpu_cgroup_proc_stat(struct seq_file *p)
 		(unsigned long long)cputime64_to_clock_t(guest),
 		(unsigned long long)cputime64_to_clock_t(guest_nice));
 	for_each_online_cpu(i) {
-
+		struct kernel_stat *kstat, *idle_kstat;
+#ifdef CONFIG_CGROUP_SCHED
+		kstat = per_cpu_ptr(tg->cpustat, i);
+		idle_kstat = per_cpu_ptr(root_task_group.cpustat, i);
+#else
+		kstat = per_cpu(kstat, i);
+		idle_kstat = kstat;
+#endif
 		/* Copy values here to work around gcc-2.95.3, gcc-2.96 */
-		user = kstat_this_cpu->cpustat[USER];
-		nice = kstat_this_cpu->cpustat[NICE];
-		system = kstat_this_cpu->cpustat[SYSTEM];
-		idle = kstat_this_cpu->cpustat[IDLE];
+		user = kstat->cpustat[USER];
+		nice = kstat->cpustat[NICE];
+		system = kstat->cpustat[SYSTEM];
+		idle = idle_kstat->cpustat[IDLE];
 		idle += arch_idle_time(i);
-		iowait = kstat_this_cpu->cpustat[IOWAIT];
-		irq = kstat_this_cpu->cpustat[IRQ];
-		softirq = kstat_this_cpu->cpustat[SOFTIRQ];
-		steal = kstat_this_cpu->cpustat[STEAL];
-		guest = kstat_this_cpu->cpustat[GUEST];
-		guest_nice = kstat_this_cpu->cpustat[GUEST_NICE];
+		idle -= kstat->cpustat[IDLE_BASE];
+		iowait = idle_kstat->cpustat[IOWAIT];
+		iowait -= kstat->cpustat[IOWAIT_BASE];
+		irq = kstat->cpustat[IRQ];
+		softirq = kstat->cpustat[SOFTIRQ];
+		steal = kstat->cpustat[STEAL];
+		guest = kstat->cpustat[GUEST];
+		guest_nice = kstat->cpustat[GUEST_NICE];
 		seq_printf(p,
 			"cpu%d %llu %llu %llu %llu %llu %llu %llu %llu %llu "
 			"%llu\n",
-- 
1.7.6

