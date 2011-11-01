Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755941Ab1KAVUc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Nov 2011 17:20:32 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:38019 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932259Ab1KAVU2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Nov 2011 17:20:28 -0400
From: Glauber Costa <glommer@parallels.com>
To: linux-kernel@vger.kernel.org
Cc: paul@paulmenage.org, lizf@cn.fujitsu.com, daniel.lezcano@free.fr,
        a.p.zijlstra@chello.nl, jbottomley@parallels.com, pjt@google.com,
        fweisbec@gmail.com, Glauber Costa <glommer@parallels.com>
Subject: [PATCH v2 04/14] split kernel stat in two
Date: Tue,  1 Nov 2011 19:19:10 -0200
Message-Id: <1320182360-20043-5-git-send-email-glommer@parallels.com>
X-Mailer: git-send-email 1.7.6.4
In-Reply-To: <1320182360-20043-1-git-send-email-glommer@parallels.com>
References: <1320182360-20043-1-git-send-email-glommer@parallels.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In a later patch, we will use cpustat information per-task group.
However, some of its fields are naturally global, such as the irq
counters. There is no need to impose the task group overhead to them
in this case. So better separate them.

Signed-off-by: Glauber Costa <glommer@parallels.com>
---
 arch/s390/appldata/appldata_os.c       |   16 +++++-----
 arch/x86/include/asm/i387.h            |    2 +-
 drivers/cpufreq/cpufreq_conservative.c |   20 ++++++------
 drivers/cpufreq/cpufreq_ondemand.c     |   20 ++++++------
 drivers/macintosh/rack-meter.c         |    6 ++--
 include/linux/kernel_stat.h            |    8 ++++-
 kernel/sched.c                         |   54 ++++++++++++++++---------------
 7 files changed, 67 insertions(+), 59 deletions(-)

diff --git a/arch/s390/appldata/appldata_os.c b/arch/s390/appldata/appldata_os.c
index 3d6b672..695388a 100644
--- a/arch/s390/appldata/appldata_os.c
+++ b/arch/s390/appldata/appldata_os.c
@@ -115,21 +115,21 @@ static void appldata_get_os_data(void *data)
 	j = 0;
 	for_each_online_cpu(i) {
 		os_data->os_cpu[j].per_cpu_user =
-			cputime_to_jiffies(kstat_cpu(i).cpustat[USER]);
+			cputime_to_jiffies(kcpustat_cpu(i).cpustat[USER]);
 		os_data->os_cpu[j].per_cpu_nice =
-			cputime_to_jiffies(kstat_cpu(i).cpustat[NICE]);
+			cputime_to_jiffies(kcpustat_cpu(i).cpustat[NICE]);
 		os_data->os_cpu[j].per_cpu_system =
-			cputime_to_jiffies(kstat_cpu(i).cpustat[SYSTEM]);
+			cputime_to_jiffies(kcpustat_cpu(i).cpustat[SYSTEM]);
 		os_data->os_cpu[j].per_cpu_idle =
-			cputime_to_jiffies(kstat_cpu(i).cpustat[IDLE]);
+			cputime_to_jiffies(kcpustat_cpu(i).cpustat[IDLE]);
 		os_data->os_cpu[j].per_cpu_irq =
-			cputime_to_jiffies(kstat_cpu(i).cpustat[IRQ]);
+			cputime_to_jiffies(kcpustat_cpu(i).cpustat[IRQ]);
 		os_data->os_cpu[j].per_cpu_softirq =
-			cputime_to_jiffies(kstat_cpu(i).cpustat[SOFTIRQ]);
+			cputime_to_jiffies(kcpustat_cpu(i).cpustat[SOFTIRQ]);
 		os_data->os_cpu[j].per_cpu_iowait =
-			cputime_to_jiffies(kstat_cpu(i).cpustat[IOWAIT]);
+			cputime_to_jiffies(kcpustat_cpu(i).cpustat[IOWAIT]);
 		os_data->os_cpu[j].per_cpu_steal =
-			cputime_to_jiffies(kstat_cpu(i).cpustat[STEAL]);
+			cputime_to_jiffies(kcpustat_cpu(i).cpustat[STEAL]);
 		os_data->os_cpu[j].cpu_id = i;
 		j++;
 	}
diff --git a/arch/x86/include/asm/i387.h b/arch/x86/include/asm/i387.h
index 56fa4d7..1f1b536 100644
--- a/arch/x86/include/asm/i387.h
+++ b/arch/x86/include/asm/i387.h
@@ -218,7 +218,7 @@ static inline void fpu_fxsave(struct fpu *fpu)
 #ifdef CONFIG_SMP
 #define safe_address (__per_cpu_offset[0])
 #else
-#define safe_address (kstat_cpu(0).cpustat[USER])
+#define safe_address (__get_cpu_var(kernel_cpustat).cpustat[USER])
 #endif
 
 /*
diff --git a/drivers/cpufreq/cpufreq_conservative.c b/drivers/cpufreq/cpufreq_conservative.c
index 2ab538f..a3a739f 100644
--- a/drivers/cpufreq/cpufreq_conservative.c
+++ b/drivers/cpufreq/cpufreq_conservative.c
@@ -103,13 +103,13 @@ static inline cputime64_t get_cpu_idle_time_jiffy(unsigned int cpu,
 	cputime64_t busy_time;
 
 	cur_wall_time = jiffies64_to_cputime64(get_jiffies_64());
-	busy_time = cputime64_add(kstat_cpu(cpu).cpustat[USER],
-			kstat_cpu(cpu).cpustat[SYSTEM]);
+	busy_time = cputime64_add(kcpustat_cpu(cpu).cpustat[USER],
+			kcpustat_cpu(cpu).cpustat[SYSTEM]);
 
-	busy_time = cputime64_add(busy_time, kstat_cpu(cpu).cpustat[IRQ]);
-	busy_time = cputime64_add(busy_time, kstat_cpu(cpu).cpustat[SOFTIRQ]);
-	busy_time = cputime64_add(busy_time, kstat_cpu(cpu).cpustat[STEAL]);
-	busy_time = cputime64_add(busy_time, kstat_cpu(cpu).cpustat[NICE]);
+	busy_time = cputime64_add(busy_time, kcpustat_cpu(cpu).cpustat[IRQ]);
+	busy_time = cputime64_add(busy_time, kcpustat_cpu(cpu).cpustat[SOFTIRQ]);
+	busy_time = cputime64_add(busy_time, kcpustat_cpu(cpu).cpustat[STEAL]);
+	busy_time = cputime64_add(busy_time, kcpustat_cpu(cpu).cpustat[NICE]);
 
 	idle_time = cputime64_sub(cur_wall_time, busy_time);
 	if (wall)
@@ -272,7 +272,7 @@ static ssize_t store_ignore_nice_load(struct kobject *a, struct attribute *b,
 		dbs_info->prev_cpu_idle = get_cpu_idle_time(j,
 						&dbs_info->prev_cpu_wall);
 		if (dbs_tuners_ins.ignore_nice)
-			dbs_info->prev_cpu_nice = kstat_cpu(j).cpustat[NICE];
+			dbs_info->prev_cpu_nice = kcpustat_cpu(j).cpustat[NICE];
 	}
 	return count;
 }
@@ -365,7 +365,7 @@ static void dbs_check_cpu(struct cpu_dbs_info_s *this_dbs_info)
 			cputime64_t cur_nice;
 			unsigned long cur_nice_jiffies;
 
-			cur_nice = cputime64_sub(kstat_cpu(j).cpustat[NICE],
+			cur_nice = cputime64_sub(kcpustat_cpu(j).cpustat[NICE],
 					 j_dbs_info->prev_cpu_nice);
 			/*
 			 * Assumption: nice time between sampling periods will
@@ -374,7 +374,7 @@ static void dbs_check_cpu(struct cpu_dbs_info_s *this_dbs_info)
 			cur_nice_jiffies = (unsigned long)
 					cputime64_to_jiffies64(cur_nice);
 
-			j_dbs_info->prev_cpu_nice = kstat_cpu(j).cpustat[NICE];
+			j_dbs_info->prev_cpu_nice = kcpustat_cpu(j).cpustat[NICE];
 			idle_time += jiffies_to_usecs(cur_nice_jiffies);
 		}
 
@@ -503,7 +503,7 @@ static int cpufreq_governor_dbs(struct cpufreq_policy *policy,
 						&j_dbs_info->prev_cpu_wall);
 			if (dbs_tuners_ins.ignore_nice)
 				j_dbs_info->prev_cpu_nice =
-						kstat_cpu(j).cpustat[NICE];
+						kcpustat_cpu(j).cpustat[NICE];
 		}
 		this_dbs_info->down_skip = 0;
 		this_dbs_info->requested_freq = policy->cur;
diff --git a/drivers/cpufreq/cpufreq_ondemand.c b/drivers/cpufreq/cpufreq_ondemand.c
index 45d8e17..46e89663 100644
--- a/drivers/cpufreq/cpufreq_ondemand.c
+++ b/drivers/cpufreq/cpufreq_ondemand.c
@@ -127,13 +127,13 @@ static inline cputime64_t get_cpu_idle_time_jiffy(unsigned int cpu,
 	cputime64_t busy_time;
 
 	cur_wall_time = jiffies64_to_cputime64(get_jiffies_64());
-	busy_time = cputime64_add(kstat_cpu(cpu).cpustat[USER],
-			kstat_cpu(cpu).cpustat[SYSTEM]);
+	busy_time = cputime64_add(kcpustat_cpu(cpu).cpustat[USER],
+			kcpustat_cpu(cpu).cpustat[SYSTEM]);
 
-	busy_time = cputime64_add(busy_time, kstat_cpu(cpu).cpustat[IRQ]);
-	busy_time = cputime64_add(busy_time, kstat_cpu(cpu).cpustat[SOFTIRQ]);
-	busy_time = cputime64_add(busy_time, kstat_cpu(cpu).cpustat[STEAL]);
-	busy_time = cputime64_add(busy_time, kstat_cpu(cpu).cpustat[NICE]);
+	busy_time = cputime64_add(busy_time, kcpustat_cpu(cpu).cpustat[IRQ]);
+	busy_time = cputime64_add(busy_time, kcpustat_cpu(cpu).cpustat[SOFTIRQ]);
+	busy_time = cputime64_add(busy_time, kcpustat_cpu(cpu).cpustat[STEAL]);
+	busy_time = cputime64_add(busy_time, kcpustat_cpu(cpu).cpustat[NICE]);
 
 	idle_time = cputime64_sub(cur_wall_time, busy_time);
 	if (wall)
@@ -345,7 +345,7 @@ static ssize_t store_ignore_nice_load(struct kobject *a, struct attribute *b,
 		dbs_info->prev_cpu_idle = get_cpu_idle_time(j,
 						&dbs_info->prev_cpu_wall);
 		if (dbs_tuners_ins.ignore_nice)
-			dbs_info->prev_cpu_nice = kstat_cpu(j).cpustat[NICE];
+			dbs_info->prev_cpu_nice = kcpustat_cpu(j).cpustat[NICE];
 
 	}
 	return count;
@@ -458,7 +458,7 @@ static void dbs_check_cpu(struct cpu_dbs_info_s *this_dbs_info)
 			cputime64_t cur_nice;
 			unsigned long cur_nice_jiffies;
 
-			cur_nice = cputime64_sub(kstat_cpu(j).cpustat[NICE],
+			cur_nice = cputime64_sub(kcpustat_cpu(j).cpustat[NICE],
 					 j_dbs_info->prev_cpu_nice);
 			/*
 			 * Assumption: nice time between sampling periods will
@@ -467,7 +467,7 @@ static void dbs_check_cpu(struct cpu_dbs_info_s *this_dbs_info)
 			cur_nice_jiffies = (unsigned long)
 					cputime64_to_jiffies64(cur_nice);
 
-			j_dbs_info->prev_cpu_nice = kstat_cpu(j).cpustat[NICE];
+			j_dbs_info->prev_cpu_nice = kcpustat_cpu(j).cpustat[NICE];
 			idle_time += jiffies_to_usecs(cur_nice_jiffies);
 		}
 
@@ -648,7 +648,7 @@ static int cpufreq_governor_dbs(struct cpufreq_policy *policy,
 						&j_dbs_info->prev_cpu_wall);
 			if (dbs_tuners_ins.ignore_nice)
 				j_dbs_info->prev_cpu_nice =
-						kstat_cpu(j).cpustat[NICE];
+						kcpustat_cpu(j).cpustat[NICE];
 		}
 		this_dbs_info->cpu = cpu;
 		this_dbs_info->rate_mult = 1;
diff --git a/drivers/macintosh/rack-meter.c b/drivers/macintosh/rack-meter.c
index c80e49a..c8e67b0 100644
--- a/drivers/macintosh/rack-meter.c
+++ b/drivers/macintosh/rack-meter.c
@@ -83,11 +83,11 @@ static inline cputime64_t get_cpu_idle_time(unsigned int cpu)
 {
 	cputime64_t retval;
 
-	retval = cputime64_add(kstat_cpu(cpu).cpustat[IDLE],
-			kstat_cpu(cpu).cpustat[IOWAIT]);
+	retval = cputime64_add(kcpustat_cpu(cpu).cpustat[IDLE],
+			kcpustat_cpu(cpu).cpustat[IOWAIT]);
 
 	if (rackmeter_ignore_nice)
-		retval = cputime64_add(retval, kstat_cpu(cpu).cpustat[NICE]);
+		retval = cputime64_add(retval, kcpustat_cpu(cpu).cpustat[NICE]);
 
 	return retval;
 }
diff --git a/include/linux/kernel_stat.h b/include/linux/kernel_stat.h
index 7bfd0fe..f0e31a9 100644
--- a/include/linux/kernel_stat.h
+++ b/include/linux/kernel_stat.h
@@ -30,8 +30,11 @@ enum cpu_usage_stat {
 	NR_STATS,
 };
 
-struct kernel_stat {
+struct kernel_cpustat {
 	u64 cpustat[NR_STATS];
+};
+
+struct kernel_stat {
 #ifndef CONFIG_GENERIC_HARDIRQS
        unsigned int irqs[NR_IRQS];
 #endif
@@ -40,10 +43,13 @@ struct kernel_stat {
 };
 
 DECLARE_PER_CPU(struct kernel_stat, kstat);
+DECLARE_PER_CPU(struct kernel_cpustat, kernel_cpustat);
 
 /* Must have preemption disabled for this to be meaningful. */
 #define kstat_this_cpu (&__get_cpu_var(kstat))
+#define kcpustat_this_cpu (&__get_cpu_var(kernel_cpustat))
 #define kstat_cpu(cpu) per_cpu(kstat, cpu)
+#define kcpustat_cpu(cpu) per_cpu(kernel_cpustat, cpu)
 
 extern unsigned long long nr_context_switches(void);
 
diff --git a/kernel/sched.c b/kernel/sched.c
index 3f42916..c225e41 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -2159,7 +2159,7 @@ static void update_rq_clock_task(struct rq *rq, s64 delta)
 #ifdef CONFIG_IRQ_TIME_ACCOUNTING
 static int irqtime_account_hi_update(void)
 {
-	u64 *cpustat = kstat_this_cpu->cpustat;
+	u64 *cpustat = kcpustat_this_cpu->cpustat;
 	unsigned long flags;
 	u64 latest_ns;
 	int ret = 0;
@@ -2174,7 +2174,7 @@ static int irqtime_account_hi_update(void)
 
 static int irqtime_account_si_update(void)
 {
-	u64 *cpustat = kstat_this_cpu->cpustat;
+	u64 *cpustat = kcpustat_this_cpu->cpustat;
 	unsigned long flags;
 	u64 latest_ns;
 	int ret = 0;
@@ -3804,8 +3804,10 @@ unlock:
 #endif
 
 DEFINE_PER_CPU(struct kernel_stat, kstat);
+DEFINE_PER_CPU(struct kernel_cpustat, kernel_cpustat);
 
 EXPORT_PER_CPU_SYMBOL(kstat);
+EXPORT_PER_CPU_SYMBOL(kernel_cpustat);
 
 /*
  * Return any ns on the sched_clock that have not yet been accounted in
@@ -3867,7 +3869,7 @@ unsigned long long task_sched_runtime(struct task_struct *p)
 void account_user_time(struct task_struct *p, cputime_t cputime,
 		       cputime_t cputime_scaled)
 {
-	u64 *cpustat = kstat_this_cpu->cpustat;
+	u64 *cpustat = kcpustat_this_cpu->cpustat;
 	u64 tmp;
 
 	/* Add user time to process. */
@@ -3898,7 +3900,7 @@ static void account_guest_time(struct task_struct *p, cputime_t cputime,
 			       cputime_t cputime_scaled)
 {
 	u64 tmp;
-	u64 *cpustat = kstat_this_cpu->cpustat;
+	u64 *cpustat = kcpustat_this_cpu->cpustat;
 
 	tmp = cputime_to_cputime64(cputime);
 
@@ -3954,7 +3956,7 @@ void __account_system_time(struct task_struct *p, cputime_t cputime,
 void account_system_time(struct task_struct *p, int hardirq_offset,
 			 cputime_t cputime, cputime_t cputime_scaled)
 {
-	u64 *cpustat = kstat_this_cpu->cpustat;
+	u64 *cpustat = kcpustat_this_cpu->cpustat;
 	u64 *target_cputime64;
 
 	if ((p->flags & PF_VCPU) && (irq_count() - hardirq_offset == 0)) {
@@ -3978,7 +3980,7 @@ void account_system_time(struct task_struct *p, int hardirq_offset,
  */
 void account_steal_time(cputime_t cputime)
 {
-	u64 *cpustat = kstat_this_cpu->cpustat;
+	u64 *cpustat = kcpustat_this_cpu->cpustat;
 	u64 cputime64 = cputime_to_cputime64(cputime);
 
 	cpustat[STEAL] += cputime64;
@@ -3990,7 +3992,7 @@ void account_steal_time(cputime_t cputime)
  */
 void account_idle_time(cputime_t cputime)
 {
-	u64 *cpustat = kstat_this_cpu->cpustat;
+	u64 *cpustat = kcpustat_this_cpu->cpustat;
 	u64 cputime64 = cputime_to_cputime64(cputime);
 	struct rq *rq = this_rq();
 
@@ -4048,7 +4050,7 @@ static void irqtime_account_process_tick(struct task_struct *p, int user_tick,
 {
 	cputime_t one_jiffy_scaled = cputime_to_scaled(cputime_one_jiffy);
 	u64 tmp = cputime_to_cputime64(cputime_one_jiffy);
-	u64 *cpustat = kstat_this_cpu->cpustat;
+	u64 *cpustat = kcpustat_this_cpu->cpustat;
 
 	if (steal_account_process_tick())
 		return;
@@ -9511,7 +9513,7 @@ static u64 get_idle_time(int cpu)
 
 	if (idle_time == -1ULL) {
 		/* !NO_HZ so we can rely on cpustat.idle */
-		idle = kstat_cpu(cpu).cpustat[IDLE];
+		idle = kcpustat_cpu(cpu).cpustat[IDLE];
 		idle += arch_idle_time(cpu);
 	} else
 		idle = usecs_to_cputime(idle_time);
@@ -9525,7 +9527,7 @@ static u64 get_iowait_time(int cpu)
 
 	if (iowait_time == -1ULL)
 		/* !NO_HZ so we can rely on cpustat.iowait */
-		iowait = kstat_cpu(cpu).cpustat[IOWAIT];
+		iowait = kcpustat_cpu(cpu).cpustat[IOWAIT];
 	else
 		iowait = usecs_to_cputime(iowait_time);
 
@@ -9550,16 +9552,16 @@ int cpu_cgroup_proc_stat(struct seq_file *p)
 	jif = boottime.tv_sec;
 
 	for_each_possible_cpu(i) {
-		user += kstat_cpu(i).cpustat[USER];
-		nice += kstat_cpu(i).cpustat[NICE];
-		system += kstat_cpu(i).cpustat[SYSTEM];
+		user += kcpustat_cpu(i).cpustat[USER];
+		nice += kcpustat_cpu(i).cpustat[NICE];
+		system += kcpustat_cpu(i).cpustat[SYSTEM];
 		idle += get_idle_time(i);
 		iowait += get_iowait_time(i);
-		irq += kstat_cpu(i).cpustat[IRQ];
-		softirq += kstat_cpu(i).cpustat[SOFTIRQ];
-		steal += kstat_cpu(i).cpustat[STEAL];
-		guest += kstat_cpu(i).cpustat[GUEST];
-		guest_nice += kstat_cpu(i).cpustat[GUEST_NICE];
+		irq += kcpustat_cpu(i).cpustat[IRQ];
+		softirq += kcpustat_cpu(i).cpustat[SOFTIRQ];
+		steal += kcpustat_cpu(i).cpustat[STEAL];
+		guest += kcpustat_cpu(i).cpustat[GUEST];
+		guest_nice += kcpustat_cpu(i).cpustat[GUEST_NICE];
 
 		for (j = 0; j < NR_SOFTIRQS; j++) {
 			unsigned int softirq_stat = kstat_softirqs_cpu(j, i);
@@ -9584,16 +9586,16 @@ int cpu_cgroup_proc_stat(struct seq_file *p)
 		(unsigned long long)cputime64_to_clock_t(guest_nice));
 	for_each_online_cpu(i) {
 		/* Copy values here to work around gcc-2.95.3, gcc-2.96 */
-		user = kstat_cpu(i).cpustat[USER];
-		nice = kstat_cpu(i).cpustat[NICE];
-		system = kstat_cpu(i).cpustat[SYSTEM];
+		user = kcpustat_cpu(i).cpustat[USER];
+		nice = kcpustat_cpu(i).cpustat[NICE];
+		system = kcpustat_cpu(i).cpustat[SYSTEM];
 		idle = get_idle_time(i);
 		iowait = get_iowait_time(i);
-		irq = kstat_cpu(i).cpustat[IRQ];
-		softirq = kstat_cpu(i).cpustat[SOFTIRQ];
-		steal = kstat_cpu(i).cpustat[STEAL];
-		guest = kstat_cpu(i).cpustat[GUEST];
-		guest_nice = kstat_cpu(i).cpustat[GUEST_NICE];
+		irq = kcpustat_cpu(i).cpustat[IRQ];
+		softirq = kcpustat_cpu(i).cpustat[SOFTIRQ];
+		steal = kcpustat_cpu(i).cpustat[STEAL];
+		guest = kcpustat_cpu(i).cpustat[GUEST];
+		guest_nice = kcpustat_cpu(i).cpustat[GUEST_NICE];
 		seq_printf(p,
 			"cpu%d %llu %llu %llu %llu %llu %llu %llu %llu %llu "
 			"%llu\n",
-- 
1.7.6.4

