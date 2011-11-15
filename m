Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756712Ab1KOQAi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 11:00:38 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:24557 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756651Ab1KOQAg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 11:00:36 -0500
From: Glauber Costa <glommer@parallels.com>
To: linux-kernel@vger.kernel.org
Cc: paul@paulmenage.org, lizf@cn.fujitsu.com, daniel.lezcano@free.fr,
        a.p.zijlstra@chello.nl, jbottomley@parallels.com, pjt@google.com,
        cgroups@vger.kernel.org, Glauber Costa <glommer@parallels.com>
Subject: [PATCH 3/4] Keep scheduler statistics per cgroup
Date: Tue, 15 Nov 2011 13:59:16 -0200
Message-Id: <1321372757-1581-4-git-send-email-glommer@parallels.com>
X-Mailer: git-send-email 1.7.6.4
In-Reply-To: <1321372757-1581-1-git-send-email-glommer@parallels.com>
References: <1321372757-1581-1-git-send-email-glommer@parallels.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes the scheduler statistics, such as user ticks,
system ticks, etc, per-cgroup. With this information, we are
able to display the same information we currently do in cpuacct
cgroup, but within the normal cpu cgroup.

For all cgroups other than the root, those statistics are only
collected when the top level file sched_stats is set to 1. This
guarantees that the overhead of the patchset is negligible if we're
not collecting statistics, even if all the bits are in.

Signed-off-by: Glauber Costa <glommer@parallels.com>
CC: Paul Tuner <pjt@google.com>
---
 arch/s390/appldata/appldata_os.c       |    2 +
 drivers/cpufreq/cpufreq_conservative.c |   16 +++-
 drivers/cpufreq/cpufreq_ondemand.c     |   16 +++-
 drivers/macintosh/rack-meter.c         |    2 +
 fs/proc/stat.c                         |   40 ++++----
 fs/proc/uptime.c                       |    7 +-
 include/linux/kernel_stat.h            |   20 ++++-
 kernel/sched.c                         |  170 ++++++++++++++++++++++++--------
 8 files changed, 207 insertions(+), 66 deletions(-)

diff --git a/arch/s390/appldata/appldata_os.c b/arch/s390/appldata/appldata_os.c
index 695388a..0612a7c 100644
--- a/arch/s390/appldata/appldata_os.c
+++ b/arch/s390/appldata/appldata_os.c
@@ -114,6 +114,7 @@ static void appldata_get_os_data(void *data)
 
 	j = 0;
 	for_each_online_cpu(i) {
+		kstat_lock();
 		os_data->os_cpu[j].per_cpu_user =
 			cputime_to_jiffies(kcpustat_cpu(i).cpustat[USER]);
 		os_data->os_cpu[j].per_cpu_nice =
@@ -131,6 +132,7 @@ static void appldata_get_os_data(void *data)
 		os_data->os_cpu[j].per_cpu_steal =
 			cputime_to_jiffies(kcpustat_cpu(i).cpustat[STEAL]);
 		os_data->os_cpu[j].cpu_id = i;
+		kstat_unlock();
 		j++;
 	}
 
diff --git a/drivers/cpufreq/cpufreq_conservative.c b/drivers/cpufreq/cpufreq_conservative.c
index a3a739f..ca98530 100644
--- a/drivers/cpufreq/cpufreq_conservative.c
+++ b/drivers/cpufreq/cpufreq_conservative.c
@@ -102,6 +102,7 @@ static inline cputime64_t get_cpu_idle_time_jiffy(unsigned int cpu,
 	cputime64_t cur_wall_time;
 	cputime64_t busy_time;
 
+	kstat_lock();
 	cur_wall_time = jiffies64_to_cputime64(get_jiffies_64());
 	busy_time = cputime64_add(kcpustat_cpu(cpu).cpustat[USER],
 			kcpustat_cpu(cpu).cpustat[SYSTEM]);
@@ -110,6 +111,7 @@ static inline cputime64_t get_cpu_idle_time_jiffy(unsigned int cpu,
 	busy_time = cputime64_add(busy_time, kcpustat_cpu(cpu).cpustat[SOFTIRQ]);
 	busy_time = cputime64_add(busy_time, kcpustat_cpu(cpu).cpustat[STEAL]);
 	busy_time = cputime64_add(busy_time, kcpustat_cpu(cpu).cpustat[NICE]);
+	kstat_unlock();
 
 	idle_time = cputime64_sub(cur_wall_time, busy_time);
 	if (wall)
@@ -271,8 +273,11 @@ static ssize_t store_ignore_nice_load(struct kobject *a, struct attribute *b,
 		dbs_info = &per_cpu(cs_cpu_dbs_info, j);
 		dbs_info->prev_cpu_idle = get_cpu_idle_time(j,
 						&dbs_info->prev_cpu_wall);
-		if (dbs_tuners_ins.ignore_nice)
+		if (dbs_tuners_ins.ignore_nice) {
+			kstat_lock();
 			dbs_info->prev_cpu_nice = kcpustat_cpu(j).cpustat[NICE];
+			kstat_unlock();
+		}
 	}
 	return count;
 }
@@ -365,8 +370,10 @@ static void dbs_check_cpu(struct cpu_dbs_info_s *this_dbs_info)
 			cputime64_t cur_nice;
 			unsigned long cur_nice_jiffies;
 
+			kstat_lock();
 			cur_nice = cputime64_sub(kcpustat_cpu(j).cpustat[NICE],
 					 j_dbs_info->prev_cpu_nice);
+			kstat_unlock();
 			/*
 			 * Assumption: nice time between sampling periods will
 			 * be less than 2^32 jiffies for 32 bit sys
@@ -374,7 +381,9 @@ static void dbs_check_cpu(struct cpu_dbs_info_s *this_dbs_info)
 			cur_nice_jiffies = (unsigned long)
 					cputime64_to_jiffies64(cur_nice);
 
+			kstat_lock();
 			j_dbs_info->prev_cpu_nice = kcpustat_cpu(j).cpustat[NICE];
+			kstat_unlock();
 			idle_time += jiffies_to_usecs(cur_nice_jiffies);
 		}
 
@@ -501,9 +510,12 @@ static int cpufreq_governor_dbs(struct cpufreq_policy *policy,
 
 			j_dbs_info->prev_cpu_idle = get_cpu_idle_time(j,
 						&j_dbs_info->prev_cpu_wall);
-			if (dbs_tuners_ins.ignore_nice)
+			if (dbs_tuners_ins.ignore_nice) {
+				kstat_lock();
 				j_dbs_info->prev_cpu_nice =
 						kcpustat_cpu(j).cpustat[NICE];
+				kstat_unlock();
+			}
 		}
 		this_dbs_info->down_skip = 0;
 		this_dbs_info->requested_freq = policy->cur;
diff --git a/drivers/cpufreq/cpufreq_ondemand.c b/drivers/cpufreq/cpufreq_ondemand.c
index 46e89663..4076453 100644
--- a/drivers/cpufreq/cpufreq_ondemand.c
+++ b/drivers/cpufreq/cpufreq_ondemand.c
@@ -126,6 +126,7 @@ static inline cputime64_t get_cpu_idle_time_jiffy(unsigned int cpu,
 	cputime64_t cur_wall_time;
 	cputime64_t busy_time;
 
+	kstat_lock();
 	cur_wall_time = jiffies64_to_cputime64(get_jiffies_64());
 	busy_time = cputime64_add(kcpustat_cpu(cpu).cpustat[USER],
 			kcpustat_cpu(cpu).cpustat[SYSTEM]);
@@ -134,6 +135,7 @@ static inline cputime64_t get_cpu_idle_time_jiffy(unsigned int cpu,
 	busy_time = cputime64_add(busy_time, kcpustat_cpu(cpu).cpustat[SOFTIRQ]);
 	busy_time = cputime64_add(busy_time, kcpustat_cpu(cpu).cpustat[STEAL]);
 	busy_time = cputime64_add(busy_time, kcpustat_cpu(cpu).cpustat[NICE]);
+	kstat_unlock();
 
 	idle_time = cputime64_sub(cur_wall_time, busy_time);
 	if (wall)
@@ -344,8 +346,11 @@ static ssize_t store_ignore_nice_load(struct kobject *a, struct attribute *b,
 		dbs_info = &per_cpu(od_cpu_dbs_info, j);
 		dbs_info->prev_cpu_idle = get_cpu_idle_time(j,
 						&dbs_info->prev_cpu_wall);
-		if (dbs_tuners_ins.ignore_nice)
+		if (dbs_tuners_ins.ignore_nice) {
+			kstat_lock();
 			dbs_info->prev_cpu_nice = kcpustat_cpu(j).cpustat[NICE];
+			kstat_unlock();
+		}
 
 	}
 	return count;
@@ -458,8 +463,10 @@ static void dbs_check_cpu(struct cpu_dbs_info_s *this_dbs_info)
 			cputime64_t cur_nice;
 			unsigned long cur_nice_jiffies;
 
+			kstat_lock();
 			cur_nice = cputime64_sub(kcpustat_cpu(j).cpustat[NICE],
 					 j_dbs_info->prev_cpu_nice);
+			kstat_unlock();
 			/*
 			 * Assumption: nice time between sampling periods will
 			 * be less than 2^32 jiffies for 32 bit sys
@@ -467,7 +474,9 @@ static void dbs_check_cpu(struct cpu_dbs_info_s *this_dbs_info)
 			cur_nice_jiffies = (unsigned long)
 					cputime64_to_jiffies64(cur_nice);
 
+			kstat_lock();
 			j_dbs_info->prev_cpu_nice = kcpustat_cpu(j).cpustat[NICE];
+			kstat_unlock();
 			idle_time += jiffies_to_usecs(cur_nice_jiffies);
 		}
 
@@ -646,9 +655,12 @@ static int cpufreq_governor_dbs(struct cpufreq_policy *policy,
 
 			j_dbs_info->prev_cpu_idle = get_cpu_idle_time(j,
 						&j_dbs_info->prev_cpu_wall);
-			if (dbs_tuners_ins.ignore_nice)
+			if (dbs_tuners_ins.ignore_nice) {
+				kstat_lock();
 				j_dbs_info->prev_cpu_nice =
 						kcpustat_cpu(j).cpustat[NICE];
+				kstat_unlock();
+			}
 		}
 		this_dbs_info->cpu = cpu;
 		this_dbs_info->rate_mult = 1;
diff --git a/drivers/macintosh/rack-meter.c b/drivers/macintosh/rack-meter.c
index c8e67b0..196244f 100644
--- a/drivers/macintosh/rack-meter.c
+++ b/drivers/macintosh/rack-meter.c
@@ -83,11 +83,13 @@ static inline cputime64_t get_cpu_idle_time(unsigned int cpu)
 {
 	cputime64_t retval;
 
+	kstat_lock();
 	retval = cputime64_add(kcpustat_cpu(cpu).cpustat[IDLE],
 			kcpustat_cpu(cpu).cpustat[IOWAIT]);
 
 	if (rackmeter_ignore_nice)
 		retval = cputime64_add(retval, kcpustat_cpu(cpu).cpustat[NICE]);
+	kstat_unlock();
 
 	return retval;
 }
diff --git a/fs/proc/stat.c b/fs/proc/stat.c
index 6ab20db..ee01403 100644
--- a/fs/proc/stat.c
+++ b/fs/proc/stat.c
@@ -28,7 +28,7 @@ static u64 get_idle_time(int cpu)
 
 	if (idle_time == -1ULL) {
 		/* !NO_HZ so we can rely on cpustat.idle */
-		idle = kcpustat_cpu(cpu).cpustat[IDLE];
+		idle = root_kcpustat_cpu(cpu).cpustat[IDLE];
 		idle += arch_idle_time(cpu);
 	} else
 		idle = usecs_to_cputime(idle_time);
@@ -42,7 +42,7 @@ static u64 get_iowait_time(int cpu)
 
 	if (iowait_time == -1ULL)
 		/* !NO_HZ so we can rely on cpustat.iowait */
-		iowait = kcpustat_cpu(cpu).cpustat[IOWAIT];
+		iowait = root_kcpustat_cpu(cpu).cpustat[IOWAIT];
 	else
 		iowait = usecs_to_cputime(iowait_time);
 
@@ -67,16 +67,18 @@ static int show_stat(struct seq_file *p, void *v)
 	jif = boottime.tv_sec;
 
 	for_each_possible_cpu(i) {
-		user += kcpustat_cpu(i).cpustat[USER];
-		nice += kcpustat_cpu(i).cpustat[NICE];
-		system += kcpustat_cpu(i).cpustat[SYSTEM];
+		kstat_lock();
+		user += root_kcpustat_cpu(i).cpustat[USER];
+		nice += root_kcpustat_cpu(i).cpustat[NICE];
+		system += root_kcpustat_cpu(i).cpustat[SYSTEM];
 		idle += get_idle_time(i);
 		iowait += get_iowait_time(i);
-		irq += kcpustat_cpu(i).cpustat[IRQ];
-		softirq += kcpustat_cpu(i).cpustat[SOFTIRQ];
-		steal += kcpustat_cpu(i).cpustat[STEAL];
-		guest += kcpustat_cpu(i).cpustat[GUEST];
-		guest_nice += kcpustat_cpu(i).cpustat[GUEST_NICE];
+		irq += root_kcpustat_cpu(i).cpustat[IRQ];
+		softirq += root_kcpustat_cpu(i).cpustat[SOFTIRQ];
+		steal += root_kcpustat_cpu(i).cpustat[STEAL];
+		guest += root_kcpustat_cpu(i).cpustat[GUEST];
+		guest_nice += root_kcpustat_cpu(i).cpustat[GUEST_NICE];
+		kstat_unlock();
 
 		for (j = 0; j < NR_SOFTIRQS; j++) {
 			unsigned int softirq_stat = kstat_softirqs_cpu(j, i);
@@ -100,17 +102,19 @@ static int show_stat(struct seq_file *p, void *v)
 		(unsigned long long)cputime64_to_clock_t(guest),
 		(unsigned long long)cputime64_to_clock_t(guest_nice));
 	for_each_online_cpu(i) {
+		kstat_lock();
 		/* Copy values here to work around gcc-2.95.3, gcc-2.96 */
-		user = kcpustat_cpu(i).cpustat[USER];
-		nice = kcpustat_cpu(i).cpustat[NICE];
-		system = kcpustat_cpu(i).cpustat[SYSTEM];
+		user = root_kcpustat_cpu(i).cpustat[USER];
+		nice = root_kcpustat_cpu(i).cpustat[NICE];
+		system = root_kcpustat_cpu(i).cpustat[SYSTEM];
 		idle = get_idle_time(i);
 		iowait = get_iowait_time(i);
-		irq = kcpustat_cpu(i).cpustat[IRQ];
-		softirq = kcpustat_cpu(i).cpustat[SOFTIRQ];
-		steal = kcpustat_cpu(i).cpustat[STEAL];
-		guest = kcpustat_cpu(i).cpustat[GUEST];
-		guest_nice = kcpustat_cpu(i).cpustat[GUEST_NICE];
+		irq = root_kcpustat_cpu(i).cpustat[IRQ];
+		softirq = root_kcpustat_cpu(i).cpustat[SOFTIRQ];
+		steal = root_kcpustat_cpu(i).cpustat[STEAL];
+		guest = root_kcpustat_cpu(i).cpustat[GUEST];
+		guest_nice = root_kcpustat_cpu(i).cpustat[GUEST_NICE];
+		kstat_unlock();
 		seq_printf(p,
 			"cpu%d %llu %llu %llu %llu %llu %llu %llu %llu %llu "
 			"%llu\n",
diff --git a/fs/proc/uptime.c b/fs/proc/uptime.c
index 76737bc..acb9ba8 100644
--- a/fs/proc/uptime.c
+++ b/fs/proc/uptime.c
@@ -14,8 +14,11 @@ static int uptime_proc_show(struct seq_file *m, void *v)
 	int i;
 	u64 idletime = 0;
 
-	for_each_possible_cpu(i)
-		idletime += kstat_cpu(i).cpustat[IDLE];
+	for_each_possible_cpu(i) {
+		kstat_lock();
+		idletime += kcpustat_cpu(i).cpustat[IDLE];
+		kstat_unlock();
+	}
 
 	do_posix_clock_monotonic_gettime(&uptime);
 	monotonic_to_bootbased(&uptime);
diff --git a/include/linux/kernel_stat.h b/include/linux/kernel_stat.h
index f0e31a9..4c8ff41 100644
--- a/include/linux/kernel_stat.h
+++ b/include/linux/kernel_stat.h
@@ -45,11 +45,27 @@ struct kernel_stat {
 DECLARE_PER_CPU(struct kernel_stat, kstat);
 DECLARE_PER_CPU(struct kernel_cpustat, kernel_cpustat);
 
-/* Must have preemption disabled for this to be meaningful. */
 #define kstat_this_cpu (&__get_cpu_var(kstat))
-#define kcpustat_this_cpu (&__get_cpu_var(kernel_cpustat))
 #define kstat_cpu(cpu) per_cpu(kstat, cpu)
+
+#ifdef CONFIG_CGROUP_SCHED
+struct kernel_cpustat *task_group_kstat(struct task_struct *p);
+
+#define kcpustat_this_cpu      this_cpu_ptr(task_group_kstat(current))
+#define kcpustat_cpu(cpu) (*per_cpu_ptr(task_group_kstat(current), cpu))
+#define kstat_lock()   rcu_read_lock()
+#define kstat_unlock() rcu_read_unlock()
+#else
+#define kcpustat_this_cpu (&__get_cpu_var(kernel_cpustat))
 #define kcpustat_cpu(cpu) per_cpu(kernel_cpustat, cpu)
+#define kstat_lock()
+#define kstat_unlock()
+#endif
+/*
+ * This makes sure the root cgroup is the one we read from when cpu
+ * cgroup is on, and is just equivalent to kcpustat_cpu when it is off
+ */
+#define root_kcpustat_cpu(cpu) per_cpu(kernel_cpustat, cpu)
 
 extern unsigned long long nr_context_switches(void);
 
diff --git a/kernel/sched.c b/kernel/sched.c
index efdd4d8..934f631 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -301,6 +301,7 @@ struct task_group {
 #endif
 
 	struct cfs_bandwidth cfs_bandwidth;
+	struct kernel_cpustat __percpu *cpustat;
 };
 
 /* task_group_lock serializes the addition/removal of task groups */
@@ -740,6 +741,12 @@ static inline int cpu_of(struct rq *rq)
 #define cpu_curr(cpu)		(cpu_rq(cpu)->curr)
 #define raw_rq()		(&__raw_get_cpu_var(runqueues))
 
+DEFINE_PER_CPU(struct kernel_stat, kstat);
+DEFINE_PER_CPU(struct kernel_cpustat, kernel_cpustat);
+
+EXPORT_PER_CPU_SYMBOL(kstat);
+EXPORT_PER_CPU_SYMBOL(kernel_cpustat);
+
 #ifdef CONFIG_CGROUP_SCHED
 
 /*
@@ -763,6 +770,21 @@ static inline struct task_group *task_group(struct task_struct *p)
 	return autogroup_task_group(p, tg);
 }
 
+static struct jump_label_key sched_cgroup_enabled;
+static int sched_has_sched_stats = 0;
+
+struct kernel_cpustat *task_group_kstat(struct task_struct *p)
+{
+	if (static_branch(&sched_cgroup_enabled)) {
+		struct task_group *tg;
+		tg = task_group(p);
+		return tg->cpustat;
+	}
+
+	return &kernel_cpustat;
+}
+EXPORT_SYMBOL(task_group_kstat);
+
 /* Change a task's cfs_rq and parent entity if it moves across CPUs/groups */
 static inline void set_task_rq(struct task_struct *p, unsigned int cpu)
 {
@@ -784,9 +806,36 @@ static inline struct task_group *task_group(struct task_struct *p)
 {
 	return NULL;
 }
-
 #endif /* CONFIG_CGROUP_SCHED */
 
+static inline void task_group_account_field(struct task_struct *p,
+					     u64 tmp, int index)
+{
+	/*
+	 * Since all updates are sure to touch the root cgroup, we
+	 * get ourselves ahead and touch it first. If the root cgroup
+	 * is the only cgroup, then nothing else should be necessary.
+	 *
+	 */
+	__get_cpu_var(kernel_cpustat).cpustat[index] += tmp;
+
+#ifdef CONFIG_CGROUP_SCHED
+	if (static_branch(&sched_cgroup_enabled)) {
+		struct kernel_cpustat *kcpustat;
+		struct task_group *tg;
+
+		rcu_read_lock();
+		tg = task_group(p);
+		while (tg && (tg != &root_task_group)) {
+			kcpustat = this_cpu_ptr(tg->cpustat);
+			kcpustat->cpustat[index] += tmp;
+			tg = tg->parent;
+		}
+		rcu_read_unlock();
+	}
+#endif
+}
+
 static void update_rq_clock_task(struct rq *rq, s64 delta);
 
 static void update_rq_clock(struct rq *rq)
@@ -2158,30 +2207,36 @@ static void update_rq_clock_task(struct rq *rq, s64 delta)
 #ifdef CONFIG_IRQ_TIME_ACCOUNTING
 static int irqtime_account_hi_update(void)
 {
-	u64 *cpustat = kcpustat_this_cpu->cpustat;
 	unsigned long flags;
 	u64 latest_ns;
+	u64 *cpustat;
 	int ret = 0;
 
 	local_irq_save(flags);
 	latest_ns = this_cpu_read(cpu_hardirq_time);
+	kstat_lock();
+	cpustat = kcpustat_this_cpu->cpustat;
 	if (cputime64_gt(nsecs_to_cputime64(latest_ns), cpustat[IRQ]))
 		ret = 1;
+	kstat_unlock();
 	local_irq_restore(flags);
 	return ret;
 }
 
 static int irqtime_account_si_update(void)
 {
-	u64 *cpustat = kcpustat_this_cpu->cpustat;
+	u64 *cpustat;
 	unsigned long flags;
 	u64 latest_ns;
 	int ret = 0;
 
 	local_irq_save(flags);
 	latest_ns = this_cpu_read(cpu_softirq_time);
+	kstat_lock();
+	cpustat = kcpustat_this_cpu->cpustat;
 	if (cputime64_gt(nsecs_to_cputime64(latest_ns), cpustat[SOFTIRQ]))
 		ret = 1;
+	kstat_unlock();
 	local_irq_restore(flags);
 	return ret;
 }
@@ -3802,12 +3857,6 @@ unlock:
 
 #endif
 
-DEFINE_PER_CPU(struct kernel_stat, kstat);
-DEFINE_PER_CPU(struct kernel_cpustat, kernel_cpustat);
-
-EXPORT_PER_CPU_SYMBOL(kstat);
-EXPORT_PER_CPU_SYMBOL(kernel_cpustat);
-
 /*
  * Return any ns on the sched_clock that have not yet been accounted in
  * @p in case that task is currently running.
@@ -3868,7 +3917,6 @@ unsigned long long task_sched_runtime(struct task_struct *p)
 void account_user_time(struct task_struct *p, cputime_t cputime,
 		       cputime_t cputime_scaled)
 {
-	u64 *cpustat = kcpustat_this_cpu->cpustat;
 	u64 tmp;
 
 	/* Add user time to process. */
@@ -3880,9 +3928,9 @@ void account_user_time(struct task_struct *p, cputime_t cputime,
 	tmp = cputime_to_cputime64(cputime);
 
 	if (TASK_NICE(p) > 0)
-		cpustat[NICE] += tmp;
+		task_group_account_field(p, tmp, NICE);
 	else
-		cpustat[USER] += tmp;
+		task_group_account_field(p, tmp, USER);
 
 	cpuacct_update_stats(p, CPUACCT_STAT_USER, cputime);
 	/* Account for user time used */
@@ -3899,7 +3947,6 @@ static void account_guest_time(struct task_struct *p, cputime_t cputime,
 			       cputime_t cputime_scaled)
 {
 	u64 tmp;
-	u64 *cpustat = kcpustat_this_cpu->cpustat;
 
 	tmp = cputime_to_cputime64(cputime);
 
@@ -3911,11 +3958,11 @@ static void account_guest_time(struct task_struct *p, cputime_t cputime,
 
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
 
@@ -3928,7 +3975,7 @@ static void account_guest_time(struct task_struct *p, cputime_t cputime,
  */
 static inline
 void __account_system_time(struct task_struct *p, cputime_t cputime,
-			cputime_t cputime_scaled, u64 *target_cputime64)
+			cputime_t cputime_scaled, int index)
 {
 	u64 tmp = cputime_to_cputime64(cputime);
 
@@ -3938,7 +3985,7 @@ void __account_system_time(struct task_struct *p, cputime_t cputime,
 	account_group_system_time(p, cputime);
 
 	/* Add system time to cpustat. */
-	*target_cputime64 += tmp;
+	task_group_account_field(p, tmp, index);
 	cpuacct_update_stats(p, CPUACCT_STAT_SYSTEM, cputime);
 
 	/* Account for system time used */
@@ -3955,8 +4002,7 @@ void __account_system_time(struct task_struct *p, cputime_t cputime,
 void account_system_time(struct task_struct *p, int hardirq_offset,
 			 cputime_t cputime, cputime_t cputime_scaled)
 {
-	u64 *cpustat = kcpustat_this_cpu->cpustat;
-	u64 *target_cputime64;
+	int index;
 
 	if ((p->flags & PF_VCPU) && (irq_count() - hardirq_offset == 0)) {
 		account_guest_time(p, cputime, cputime_scaled);
@@ -3964,13 +4010,13 @@ void account_system_time(struct task_struct *p, int hardirq_offset,
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
@@ -3979,10 +4025,8 @@ void account_system_time(struct task_struct *p, int hardirq_offset,
  */
 void account_steal_time(cputime_t cputime)
 {
-	u64 *cpustat = kcpustat_this_cpu->cpustat;
 	u64 cputime64 = cputime_to_cputime64(cputime);
-
-	cpustat[STEAL] += cputime64;
+	__get_cpu_var(kernel_cpustat).cpustat[STEAL] += cputime64;
 }
 
 /*
@@ -3991,14 +4035,19 @@ void account_steal_time(cputime_t cputime)
  */
 void account_idle_time(cputime_t cputime)
 {
-	u64 *cpustat = kcpustat_this_cpu->cpustat;
+	struct kernel_cpustat *kcpustat;
 	u64 cputime64 = cputime_to_cputime64(cputime);
 	struct rq *rq = this_rq();
 
+	kstat_lock();
+	kcpustat = kcpustat_this_cpu;
+
 	if (atomic_read(&rq->nr_iowait) > 0)
-		cpustat[IOWAIT] += cputime64;
+		kcpustat->cpustat[IOWAIT] += cputime64;
 	else
-		cpustat[IDLE] += cputime64;
+		/* idle is always accounted to the root cgroup */
+		__get_cpu_var(kernel_cpustat).cpustat[IDLE] += cputime64;
+	kstat_unlock();
 }
 
 static __always_inline bool steal_account_process_tick(void)
@@ -4045,27 +4094,26 @@ static __always_inline bool steal_account_process_tick(void)
  * softirq as those do not count in task exec_runtime any more.
  */
 static void irqtime_account_process_tick(struct task_struct *p, int user_tick,
-						struct rq *rq)
+					 struct rq *rq)
 {
 	cputime_t one_jiffy_scaled = cputime_to_scaled(cputime_one_jiffy);
 	u64 tmp = cputime_to_cputime64(cputime_one_jiffy);
-	u64 *cpustat = kcpustat_this_cpu->cpustat;
 
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
@@ -4073,8 +4121,8 @@ static void irqtime_account_process_tick(struct task_struct *p, int user_tick,
 	} else if (p->flags & PF_VCPU) { /* System time or guest time */
 		account_guest_time(p, cputime_one_jiffy, one_jiffy_scaled);
 	} else {
-		__account_system_time(p, cputime_one_jiffy, one_jiffy_scaled,
-					&cpustat[SYSTEM]);
+		__account_system_time(p, cputime_one_jiffy,
+				      one_jiffy_scaled, SYSTEM);
 	}
 }
 
@@ -8237,6 +8285,8 @@ void __init sched_init(void)
 	INIT_LIST_HEAD(&root_task_group.children);
 	INIT_LIST_HEAD(&root_task_group.siblings);
 	autogroup_init(&init_task);
+
+	root_task_group.cpustat = &kernel_cpustat;
 #endif /* CONFIG_CGROUP_SCHED */
 
 	for_each_possible_cpu(i) {
@@ -8674,6 +8724,7 @@ static void free_sched_group(struct task_group *tg)
 	free_fair_sched_group(tg);
 	free_rt_sched_group(tg);
 	autogroup_free(tg);
+	free_percpu(tg->cpustat);
 	kfree(tg);
 }
 
@@ -8693,6 +8744,10 @@ struct task_group *sched_create_group(struct task_group *parent)
 	if (!alloc_rt_sched_group(tg, parent))
 		goto err;
 
+	tg->cpustat = alloc_percpu(struct kernel_cpustat);
+	if (!tg->cpustat)
+		goto err;
+
 	spin_lock_irqsave(&task_group_lock, flags);
 	list_add_rcu(&tg->list, &task_groups);
 
@@ -9437,6 +9492,23 @@ static u64 cpu_rt_period_read_uint(struct cgroup *cgrp, struct cftype *cft)
 }
 #endif /* CONFIG_RT_GROUP_SCHED */
 
+static u64 cpu_has_sched_stats(struct cgroup *cgrp, struct cftype *cft)
+{
+	return sched_has_sched_stats;
+}
+
+static int cpu_set_sched_stats(struct cgroup *cgrp, struct cftype *cft, u64 val)
+{
+	if (!val && sched_has_sched_stats)
+		jump_label_dec(&sched_cgroup_enabled);
+
+	if (val && !sched_has_sched_stats)
+		jump_label_inc(&sched_cgroup_enabled);
+
+	sched_has_sched_stats = !!val;
+	return 0;
+}
+
 static struct cftype cpu_files[] = {
 #ifdef CONFIG_FAIR_GROUP_SCHED
 	{
@@ -9475,9 +9547,27 @@ static struct cftype cpu_files[] = {
 #endif
 };
 
+/*
+ * Files appearing here will be shown at the top level only. Although we could
+ * show them unconditionally, and then return an error when read/writen from
+ * non-root cgroups, this is less confusing for users
+ */
+static struct cftype cpu_root_files[] = {
+	{
+		.name = "sched_stats",
+		.read_u64 = cpu_has_sched_stats,
+		.write_u64 = cpu_set_sched_stats,
+	},
+};
+
 static int cpu_cgroup_populate(struct cgroup_subsys *ss, struct cgroup *cont)
 {
-	return cgroup_add_files(cont, ss, cpu_files, ARRAY_SIZE(cpu_files));
+	int ret;
+	ret = cgroup_add_files(cont, ss, cpu_files, ARRAY_SIZE(cpu_files));
+	if (!ret)
+		ret = cgroup_add_files(cont, ss, cpu_root_files,
+				       ARRAY_SIZE(cpu_root_files));
+	return ret;
 }
 
 struct cgroup_subsys cpu_cgroup_subsys = {
-- 
1.7.6.4

