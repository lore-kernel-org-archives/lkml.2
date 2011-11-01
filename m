Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932325Ab1KAVUU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Nov 2011 17:20:20 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:7150 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755889Ab1KAVUP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Nov 2011 17:20:15 -0400
From: Glauber Costa <glommer@parallels.com>
To: linux-kernel@vger.kernel.org
Cc: paul@paulmenage.org, lizf@cn.fujitsu.com, daniel.lezcano@free.fr,
        a.p.zijlstra@chello.nl, jbottomley@parallels.com, pjt@google.com,
        fweisbec@gmail.com, Glauber Costa <glommer@parallels.com>
Subject: [PATCH v2 02/14] Change cpustat fields to an array.
Date: Tue,  1 Nov 2011 19:19:08 -0200
Message-Id: <1320182360-20043-3-git-send-email-glommer@parallels.com>
X-Mailer: git-send-email 1.7.6.4
In-Reply-To: <1320182360-20043-1-git-send-email-glommer@parallels.com>
References: <1320182360-20043-1-git-send-email-glommer@parallels.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This will give us a bit more flexibility to deal with the
fields in this structure. This is a preparation patch for
later patches in this series.

Signed-off-by: Glauber Costa <glommer@parallels.com>
---
 arch/s390/appldata/appldata_os.c       |   16 ++++----
 arch/x86/include/asm/i387.h            |    2 +-
 drivers/cpufreq/cpufreq_conservative.c |   23 +++++-----
 drivers/cpufreq/cpufreq_ondemand.c     |   23 +++++-----
 drivers/macintosh/rack-meter.c         |    6 +-
 fs/proc/stat.c                         |   63 +++++++++++++---------------
 fs/proc/uptime.c                       |    2 +-
 include/linux/kernel_stat.h            |   30 +++++++------
 kernel/sched.c                         |   71 ++++++++++++++++----------------
 9 files changed, 116 insertions(+), 120 deletions(-)

diff --git a/arch/s390/appldata/appldata_os.c b/arch/s390/appldata/appldata_os.c
index 92f1cb7..3d6b672 100644
--- a/arch/s390/appldata/appldata_os.c
+++ b/arch/s390/appldata/appldata_os.c
@@ -115,21 +115,21 @@ static void appldata_get_os_data(void *data)
 	j = 0;
 	for_each_online_cpu(i) {
 		os_data->os_cpu[j].per_cpu_user =
-			cputime_to_jiffies(kstat_cpu(i).cpustat.user);
+			cputime_to_jiffies(kstat_cpu(i).cpustat[USER]);
 		os_data->os_cpu[j].per_cpu_nice =
-			cputime_to_jiffies(kstat_cpu(i).cpustat.nice);
+			cputime_to_jiffies(kstat_cpu(i).cpustat[NICE]);
 		os_data->os_cpu[j].per_cpu_system =
-			cputime_to_jiffies(kstat_cpu(i).cpustat.system);
+			cputime_to_jiffies(kstat_cpu(i).cpustat[SYSTEM]);
 		os_data->os_cpu[j].per_cpu_idle =
-			cputime_to_jiffies(kstat_cpu(i).cpustat.idle);
+			cputime_to_jiffies(kstat_cpu(i).cpustat[IDLE]);
 		os_data->os_cpu[j].per_cpu_irq =
-			cputime_to_jiffies(kstat_cpu(i).cpustat.irq);
+			cputime_to_jiffies(kstat_cpu(i).cpustat[IRQ]);
 		os_data->os_cpu[j].per_cpu_softirq =
-			cputime_to_jiffies(kstat_cpu(i).cpustat.softirq);
+			cputime_to_jiffies(kstat_cpu(i).cpustat[SOFTIRQ]);
 		os_data->os_cpu[j].per_cpu_iowait =
-			cputime_to_jiffies(kstat_cpu(i).cpustat.iowait);
+			cputime_to_jiffies(kstat_cpu(i).cpustat[IOWAIT]);
 		os_data->os_cpu[j].per_cpu_steal =
-			cputime_to_jiffies(kstat_cpu(i).cpustat.steal);
+			cputime_to_jiffies(kstat_cpu(i).cpustat[STEAL]);
 		os_data->os_cpu[j].cpu_id = i;
 		j++;
 	}
diff --git a/arch/x86/include/asm/i387.h b/arch/x86/include/asm/i387.h
index c9e09ea..56fa4d7 100644
--- a/arch/x86/include/asm/i387.h
+++ b/arch/x86/include/asm/i387.h
@@ -218,7 +218,7 @@ static inline void fpu_fxsave(struct fpu *fpu)
 #ifdef CONFIG_SMP
 #define safe_address (__per_cpu_offset[0])
 #else
-#define safe_address (kstat_cpu(0).cpustat.user)
+#define safe_address (kstat_cpu(0).cpustat[USER])
 #endif
 
 /*
diff --git a/drivers/cpufreq/cpufreq_conservative.c b/drivers/cpufreq/cpufreq_conservative.c
index c97b468..2ab538f 100644
--- a/drivers/cpufreq/cpufreq_conservative.c
+++ b/drivers/cpufreq/cpufreq_conservative.c
@@ -103,13 +103,13 @@ static inline cputime64_t get_cpu_idle_time_jiffy(unsigned int cpu,
 	cputime64_t busy_time;
 
 	cur_wall_time = jiffies64_to_cputime64(get_jiffies_64());
-	busy_time = cputime64_add(kstat_cpu(cpu).cpustat.user,
-			kstat_cpu(cpu).cpustat.system);
+	busy_time = cputime64_add(kstat_cpu(cpu).cpustat[USER],
+			kstat_cpu(cpu).cpustat[SYSTEM]);
 
-	busy_time = cputime64_add(busy_time, kstat_cpu(cpu).cpustat.irq);
-	busy_time = cputime64_add(busy_time, kstat_cpu(cpu).cpustat.softirq);
-	busy_time = cputime64_add(busy_time, kstat_cpu(cpu).cpustat.steal);
-	busy_time = cputime64_add(busy_time, kstat_cpu(cpu).cpustat.nice);
+	busy_time = cputime64_add(busy_time, kstat_cpu(cpu).cpustat[IRQ]);
+	busy_time = cputime64_add(busy_time, kstat_cpu(cpu).cpustat[SOFTIRQ]);
+	busy_time = cputime64_add(busy_time, kstat_cpu(cpu).cpustat[STEAL]);
+	busy_time = cputime64_add(busy_time, kstat_cpu(cpu).cpustat[NICE]);
 
 	idle_time = cputime64_sub(cur_wall_time, busy_time);
 	if (wall)
@@ -272,7 +272,7 @@ static ssize_t store_ignore_nice_load(struct kobject *a, struct attribute *b,
 		dbs_info->prev_cpu_idle = get_cpu_idle_time(j,
 						&dbs_info->prev_cpu_wall);
 		if (dbs_tuners_ins.ignore_nice)
-			dbs_info->prev_cpu_nice = kstat_cpu(j).cpustat.nice;
+			dbs_info->prev_cpu_nice = kstat_cpu(j).cpustat[NICE];
 	}
 	return count;
 }
@@ -365,7 +365,7 @@ static void dbs_check_cpu(struct cpu_dbs_info_s *this_dbs_info)
 			cputime64_t cur_nice;
 			unsigned long cur_nice_jiffies;
 
-			cur_nice = cputime64_sub(kstat_cpu(j).cpustat.nice,
+			cur_nice = cputime64_sub(kstat_cpu(j).cpustat[NICE],
 					 j_dbs_info->prev_cpu_nice);
 			/*
 			 * Assumption: nice time between sampling periods will
@@ -374,7 +374,7 @@ static void dbs_check_cpu(struct cpu_dbs_info_s *this_dbs_info)
 			cur_nice_jiffies = (unsigned long)
 					cputime64_to_jiffies64(cur_nice);
 
-			j_dbs_info->prev_cpu_nice = kstat_cpu(j).cpustat.nice;
+			j_dbs_info->prev_cpu_nice = kstat_cpu(j).cpustat[NICE];
 			idle_time += jiffies_to_usecs(cur_nice_jiffies);
 		}
 
@@ -501,10 +501,9 @@ static int cpufreq_governor_dbs(struct cpufreq_policy *policy,
 
 			j_dbs_info->prev_cpu_idle = get_cpu_idle_time(j,
 						&j_dbs_info->prev_cpu_wall);
-			if (dbs_tuners_ins.ignore_nice) {
+			if (dbs_tuners_ins.ignore_nice)
 				j_dbs_info->prev_cpu_nice =
-						kstat_cpu(j).cpustat.nice;
-			}
+						kstat_cpu(j).cpustat[NICE];
 		}
 		this_dbs_info->down_skip = 0;
 		this_dbs_info->requested_freq = policy->cur;
diff --git a/drivers/cpufreq/cpufreq_ondemand.c b/drivers/cpufreq/cpufreq_ondemand.c
index fa8af4e..45d8e17 100644
--- a/drivers/cpufreq/cpufreq_ondemand.c
+++ b/drivers/cpufreq/cpufreq_ondemand.c
@@ -127,13 +127,13 @@ static inline cputime64_t get_cpu_idle_time_jiffy(unsigned int cpu,
 	cputime64_t busy_time;
 
 	cur_wall_time = jiffies64_to_cputime64(get_jiffies_64());
-	busy_time = cputime64_add(kstat_cpu(cpu).cpustat.user,
-			kstat_cpu(cpu).cpustat.system);
+	busy_time = cputime64_add(kstat_cpu(cpu).cpustat[USER],
+			kstat_cpu(cpu).cpustat[SYSTEM]);
 
-	busy_time = cputime64_add(busy_time, kstat_cpu(cpu).cpustat.irq);
-	busy_time = cputime64_add(busy_time, kstat_cpu(cpu).cpustat.softirq);
-	busy_time = cputime64_add(busy_time, kstat_cpu(cpu).cpustat.steal);
-	busy_time = cputime64_add(busy_time, kstat_cpu(cpu).cpustat.nice);
+	busy_time = cputime64_add(busy_time, kstat_cpu(cpu).cpustat[IRQ]);
+	busy_time = cputime64_add(busy_time, kstat_cpu(cpu).cpustat[SOFTIRQ]);
+	busy_time = cputime64_add(busy_time, kstat_cpu(cpu).cpustat[STEAL]);
+	busy_time = cputime64_add(busy_time, kstat_cpu(cpu).cpustat[NICE]);
 
 	idle_time = cputime64_sub(cur_wall_time, busy_time);
 	if (wall)
@@ -345,7 +345,7 @@ static ssize_t store_ignore_nice_load(struct kobject *a, struct attribute *b,
 		dbs_info->prev_cpu_idle = get_cpu_idle_time(j,
 						&dbs_info->prev_cpu_wall);
 		if (dbs_tuners_ins.ignore_nice)
-			dbs_info->prev_cpu_nice = kstat_cpu(j).cpustat.nice;
+			dbs_info->prev_cpu_nice = kstat_cpu(j).cpustat[NICE];
 
 	}
 	return count;
@@ -458,7 +458,7 @@ static void dbs_check_cpu(struct cpu_dbs_info_s *this_dbs_info)
 			cputime64_t cur_nice;
 			unsigned long cur_nice_jiffies;
 
-			cur_nice = cputime64_sub(kstat_cpu(j).cpustat.nice,
+			cur_nice = cputime64_sub(kstat_cpu(j).cpustat[NICE],
 					 j_dbs_info->prev_cpu_nice);
 			/*
 			 * Assumption: nice time between sampling periods will
@@ -467,7 +467,7 @@ static void dbs_check_cpu(struct cpu_dbs_info_s *this_dbs_info)
 			cur_nice_jiffies = (unsigned long)
 					cputime64_to_jiffies64(cur_nice);
 
-			j_dbs_info->prev_cpu_nice = kstat_cpu(j).cpustat.nice;
+			j_dbs_info->prev_cpu_nice = kstat_cpu(j).cpustat[NICE];
 			idle_time += jiffies_to_usecs(cur_nice_jiffies);
 		}
 
@@ -646,10 +646,9 @@ static int cpufreq_governor_dbs(struct cpufreq_policy *policy,
 
 			j_dbs_info->prev_cpu_idle = get_cpu_idle_time(j,
 						&j_dbs_info->prev_cpu_wall);
-			if (dbs_tuners_ins.ignore_nice) {
+			if (dbs_tuners_ins.ignore_nice)
 				j_dbs_info->prev_cpu_nice =
-						kstat_cpu(j).cpustat.nice;
-			}
+						kstat_cpu(j).cpustat[NICE];
 		}
 		this_dbs_info->cpu = cpu;
 		this_dbs_info->rate_mult = 1;
diff --git a/drivers/macintosh/rack-meter.c b/drivers/macintosh/rack-meter.c
index 2637c13..c80e49a 100644
--- a/drivers/macintosh/rack-meter.c
+++ b/drivers/macintosh/rack-meter.c
@@ -83,11 +83,11 @@ static inline cputime64_t get_cpu_idle_time(unsigned int cpu)
 {
 	cputime64_t retval;
 
-	retval = cputime64_add(kstat_cpu(cpu).cpustat.idle,
-			kstat_cpu(cpu).cpustat.iowait);
+	retval = cputime64_add(kstat_cpu(cpu).cpustat[IDLE],
+			kstat_cpu(cpu).cpustat[IOWAIT]);
 
 	if (rackmeter_ignore_nice)
-		retval = cputime64_add(retval, kstat_cpu(cpu).cpustat.nice);
+		retval = cputime64_add(retval, kstat_cpu(cpu).cpustat[NICE]);
 
 	return retval;
 }
diff --git a/fs/proc/stat.c b/fs/proc/stat.c
index 42b274d..b7b74ad 100644
--- a/fs/proc/stat.c
+++ b/fs/proc/stat.c
@@ -22,29 +22,27 @@
 #define arch_idle_time(cpu) 0
 #endif
 
-static cputime64_t get_idle_time(int cpu)
+static u64 get_idle_time(int cpu)
 {
-	u64 idle_time = get_cpu_idle_time_us(cpu, NULL);
-	cputime64_t idle;
+	u64 idle, idle_time = get_cpu_idle_time_us(cpu, NULL);
 
 	if (idle_time == -1ULL) {
 		/* !NO_HZ so we can rely on cpustat.idle */
-		idle = kstat_cpu(cpu).cpustat.idle;
-		idle = cputime64_add(idle, arch_idle_time(cpu));
+		idle = kstat_cpu(cpu).cpustat[IDLE];
+		idle += arch_idle_time(cpu);
 	} else
 		idle = usecs_to_cputime(idle_time);
 
 	return idle;
 }
 
-static cputime64_t get_iowait_time(int cpu)
+static u64 get_iowait_time(int cpu)
 {
-	u64 iowait_time = get_cpu_iowait_time_us(cpu, NULL);
-	cputime64_t iowait;
+	u64 iowait, iowait_time = get_cpu_iowait_time_us(cpu, NULL);
 
 	if (iowait_time == -1ULL)
 		/* !NO_HZ so we can rely on cpustat.iowait */
-		iowait = kstat_cpu(cpu).cpustat.iowait;
+		iowait = kstat_cpu(cpu).cpustat[IOWAIT];
 	else
 		iowait = usecs_to_cputime(iowait_time);
 
@@ -55,33 +53,30 @@ static int show_stat(struct seq_file *p, void *v)
 {
 	int i, j;
 	unsigned long jif;
-	cputime64_t user, nice, system, idle, iowait, irq, softirq, steal;
-	cputime64_t guest, guest_nice;
+	u64 user, nice, system, idle, iowait, irq, softirq, steal;
+	u64 guest, guest_nice;
 	u64 sum = 0;
 	u64 sum_softirq = 0;
 	unsigned int per_softirq_sums[NR_SOFTIRQS] = {0};
 	struct timespec boottime;
 
 	user = nice = system = idle = iowait =
-		irq = softirq = steal = cputime64_zero;
-	guest = guest_nice = cputime64_zero;
+		irq = softirq = steal = 0;
+	guest = guest_nice = 0;
 	getboottime(&boottime);
 	jif = boottime.tv_sec;
 
 	for_each_possible_cpu(i) {
-		user = cputime64_add(user, kstat_cpu(i).cpustat.user);
-		nice = cputime64_add(nice, kstat_cpu(i).cpustat.nice);
-		system = cputime64_add(system, kstat_cpu(i).cpustat.system);
-		idle = cputime64_add(idle, get_idle_time(i));
-		iowait = cputime64_add(iowait, get_iowait_time(i));
-		irq = cputime64_add(irq, kstat_cpu(i).cpustat.irq);
-		softirq = cputime64_add(softirq, kstat_cpu(i).cpustat.softirq);
-		steal = cputime64_add(steal, kstat_cpu(i).cpustat.steal);
-		guest = cputime64_add(guest, kstat_cpu(i).cpustat.guest);
-		guest_nice = cputime64_add(guest_nice,
-			kstat_cpu(i).cpustat.guest_nice);
-		sum += kstat_cpu_irqs_sum(i);
-		sum += arch_irq_stat_cpu(i);
+		user += kstat_cpu(i).cpustat[USER];
+		nice += kstat_cpu(i).cpustat[NICE];
+		system += kstat_cpu(i).cpustat[SYSTEM];
+		idle += get_idle_time(i);
+		iowait += get_iowait_time(i);
+		irq += kstat_cpu(i).cpustat[IRQ];
+		softirq += kstat_cpu(i).cpustat[SOFTIRQ];
+		steal += kstat_cpu(i).cpustat[STEAL];
+		guest += kstat_cpu(i).cpustat[GUEST];
+		guest_nice += kstat_cpu(i).cpustat[GUEST_NICE];
 
 		for (j = 0; j < NR_SOFTIRQS; j++) {
 			unsigned int softirq_stat = kstat_softirqs_cpu(j, i);
@@ -106,16 +101,16 @@ static int show_stat(struct seq_file *p, void *v)
 		(unsigned long long)cputime64_to_clock_t(guest_nice));
 	for_each_online_cpu(i) {
 		/* Copy values here to work around gcc-2.95.3, gcc-2.96 */
-		user = kstat_cpu(i).cpustat.user;
-		nice = kstat_cpu(i).cpustat.nice;
-		system = kstat_cpu(i).cpustat.system;
+		user = kstat_cpu(i).cpustat[USER];
+		nice = kstat_cpu(i).cpustat[NICE];
+		system = kstat_cpu(i).cpustat[SYSTEM];
 		idle = get_idle_time(i);
 		iowait = get_iowait_time(i);
-		irq = kstat_cpu(i).cpustat.irq;
-		softirq = kstat_cpu(i).cpustat.softirq;
-		steal = kstat_cpu(i).cpustat.steal;
-		guest = kstat_cpu(i).cpustat.guest;
-		guest_nice = kstat_cpu(i).cpustat.guest_nice;
+		irq = kstat_cpu(i).cpustat[IRQ];
+		softirq = kstat_cpu(i).cpustat[SOFTIRQ];
+		steal = kstat_cpu(i).cpustat[STEAL];
+		guest = kstat_cpu(i).cpustat[GUEST];
+		guest_nice = kstat_cpu(i).cpustat[GUEST_NICE];
 		seq_printf(p,
 			"cpu%d %llu %llu %llu %llu %llu %llu %llu %llu %llu "
 			"%llu\n",
diff --git a/fs/proc/uptime.c b/fs/proc/uptime.c
index 766b1d4..b0e053d 100644
--- a/fs/proc/uptime.c
+++ b/fs/proc/uptime.c
@@ -15,7 +15,7 @@ static int uptime_proc_show(struct seq_file *m, void *v)
 	cputime_t idletime = cputime_zero;
 
 	for_each_possible_cpu(i)
-		idletime = cputime64_add(idletime, kstat_cpu(i).cpustat.idle);
+		idletime = cputime64_add(idletime, kstat_cpu(i).cpustat[IDLE]);
 
 	do_posix_clock_monotonic_gettime(&uptime);
 	monotonic_to_bootbased(&uptime);
diff --git a/include/linux/kernel_stat.h b/include/linux/kernel_stat.h
index 0cce2db..7bfd0fe 100644
--- a/include/linux/kernel_stat.h
+++ b/include/linux/kernel_stat.h
@@ -6,6 +6,7 @@
 #include <linux/percpu.h>
 #include <linux/cpumask.h>
 #include <linux/interrupt.h>
+#include <linux/sched.h>
 #include <asm/irq.h>
 #include <asm/cputime.h>
 
@@ -15,21 +16,22 @@
  * used by rstatd/perfmeter
  */
 
-struct cpu_usage_stat {
-	cputime64_t user;
-	cputime64_t nice;
-	cputime64_t system;
-	cputime64_t softirq;
-	cputime64_t irq;
-	cputime64_t idle;
-	cputime64_t iowait;
-	cputime64_t steal;
-	cputime64_t guest;
-	cputime64_t guest_nice;
+enum cpu_usage_stat {
+	USER,
+	NICE,
+	SYSTEM,
+	SOFTIRQ,
+	IRQ,
+	IDLE,
+	IOWAIT,
+	STEAL,
+	GUEST,
+	GUEST_NICE,
+	NR_STATS,
 };
 
 struct kernel_stat {
-	struct cpu_usage_stat	cpustat;
+	u64 cpustat[NR_STATS];
 #ifndef CONFIG_GENERIC_HARDIRQS
        unsigned int irqs[NR_IRQS];
 #endif
@@ -39,9 +41,9 @@ struct kernel_stat {
 
 DECLARE_PER_CPU(struct kernel_stat, kstat);
 
-#define kstat_cpu(cpu)	per_cpu(kstat, cpu)
 /* Must have preemption disabled for this to be meaningful. */
-#define kstat_this_cpu	__get_cpu_var(kstat)
+#define kstat_this_cpu (&__get_cpu_var(kstat))
+#define kstat_cpu(cpu) per_cpu(kstat, cpu)
 
 extern unsigned long long nr_context_switches(void);
 
diff --git a/kernel/sched.c b/kernel/sched.c
index e327665..e78e1aa 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -2158,14 +2158,14 @@ static void update_rq_clock_task(struct rq *rq, s64 delta)
 #ifdef CONFIG_IRQ_TIME_ACCOUNTING
 static int irqtime_account_hi_update(void)
 {
-	struct cpu_usage_stat *cpustat = &kstat_this_cpu.cpustat;
+	u64 *cpustat = kstat_this_cpu->cpustat;
 	unsigned long flags;
 	u64 latest_ns;
 	int ret = 0;
 
 	local_irq_save(flags);
 	latest_ns = this_cpu_read(cpu_hardirq_time);
-	if (cputime64_gt(nsecs_to_cputime64(latest_ns), cpustat->irq))
+	if (cputime64_gt(nsecs_to_cputime64(latest_ns), cpustat[IRQ]))
 		ret = 1;
 	local_irq_restore(flags);
 	return ret;
@@ -2173,14 +2173,14 @@ static int irqtime_account_hi_update(void)
 
 static int irqtime_account_si_update(void)
 {
-	struct cpu_usage_stat *cpustat = &kstat_this_cpu.cpustat;
+	u64 *cpustat = kstat_this_cpu->cpustat;
 	unsigned long flags;
 	u64 latest_ns;
 	int ret = 0;
 
 	local_irq_save(flags);
 	latest_ns = this_cpu_read(cpu_softirq_time);
-	if (cputime64_gt(nsecs_to_cputime64(latest_ns), cpustat->softirq))
+	if (cputime64_gt(nsecs_to_cputime64(latest_ns), cpustat[SOFTIRQ]))
 		ret = 1;
 	local_irq_restore(flags);
 	return ret;
@@ -3866,8 +3866,8 @@ unsigned long long task_sched_runtime(struct task_struct *p)
 void account_user_time(struct task_struct *p, cputime_t cputime,
 		       cputime_t cputime_scaled)
 {
-	struct cpu_usage_stat *cpustat = &kstat_this_cpu.cpustat;
-	cputime64_t tmp;
+	u64 *cpustat = kstat_this_cpu->cpustat;
+	u64 tmp;
 
 	/* Add user time to process. */
 	p->utime = cputime_add(p->utime, cputime);
@@ -3876,10 +3876,11 @@ void account_user_time(struct task_struct *p, cputime_t cputime,
 
 	/* Add user time to cpustat. */
 	tmp = cputime_to_cputime64(cputime);
+
 	if (TASK_NICE(p) > 0)
-		cpustat->nice = cputime64_add(cpustat->nice, tmp);
+		cpustat[NICE] += tmp;
 	else
-		cpustat->user = cputime64_add(cpustat->user, tmp);
+		cpustat[USER] += tmp;
 
 	cpuacct_update_stats(p, CPUACCT_STAT_USER, cputime);
 	/* Account for user time used */
@@ -3895,8 +3896,8 @@ void account_user_time(struct task_struct *p, cputime_t cputime,
 static void account_guest_time(struct task_struct *p, cputime_t cputime,
 			       cputime_t cputime_scaled)
 {
-	cputime64_t tmp;
-	struct cpu_usage_stat *cpustat = &kstat_this_cpu.cpustat;
+	u64 tmp;
+	u64 *cpustat = kstat_this_cpu->cpustat;
 
 	tmp = cputime_to_cputime64(cputime);
 
@@ -3908,11 +3909,11 @@ static void account_guest_time(struct task_struct *p, cputime_t cputime,
 
 	/* Add guest time to cpustat. */
 	if (TASK_NICE(p) > 0) {
-		cpustat->nice = cputime64_add(cpustat->nice, tmp);
-		cpustat->guest_nice = cputime64_add(cpustat->guest_nice, tmp);
+		cpustat[NICE] += tmp;
+		cpustat[GUEST_NICE] += tmp;
 	} else {
-		cpustat->user = cputime64_add(cpustat->user, tmp);
-		cpustat->guest = cputime64_add(cpustat->guest, tmp);
+		cpustat[USER] += tmp;
+		cpustat[GUEST] += tmp;
 	}
 }
 
@@ -3925,9 +3926,9 @@ static void account_guest_time(struct task_struct *p, cputime_t cputime,
  */
 static inline
 void __account_system_time(struct task_struct *p, cputime_t cputime,
-			cputime_t cputime_scaled, cputime64_t *target_cputime64)
+			cputime_t cputime_scaled, u64 *target_cputime64)
 {
-	cputime64_t tmp = cputime_to_cputime64(cputime);
+	u64 tmp = cputime_to_cputime64(cputime);
 
 	/* Add system time to process. */
 	p->stime = cputime_add(p->stime, cputime);
@@ -3935,7 +3936,7 @@ void __account_system_time(struct task_struct *p, cputime_t cputime,
 	account_group_system_time(p, cputime);
 
 	/* Add system time to cpustat. */
-	*target_cputime64 = cputime64_add(*target_cputime64, tmp);
+	*target_cputime64 += tmp;
 	cpuacct_update_stats(p, CPUACCT_STAT_SYSTEM, cputime);
 
 	/* Account for system time used */
@@ -3952,8 +3953,8 @@ void __account_system_time(struct task_struct *p, cputime_t cputime,
 void account_system_time(struct task_struct *p, int hardirq_offset,
 			 cputime_t cputime, cputime_t cputime_scaled)
 {
-	struct cpu_usage_stat *cpustat = &kstat_this_cpu.cpustat;
-	cputime64_t *target_cputime64;
+	u64 *cpustat = kstat_this_cpu->cpustat;
+	u64 *target_cputime64;
 
 	if ((p->flags & PF_VCPU) && (irq_count() - hardirq_offset == 0)) {
 		account_guest_time(p, cputime, cputime_scaled);
@@ -3961,11 +3962,11 @@ void account_system_time(struct task_struct *p, int hardirq_offset,
 	}
 
 	if (hardirq_count() - hardirq_offset)
-		target_cputime64 = &cpustat->irq;
+		target_cputime64 = &cpustat[IRQ];
 	else if (in_serving_softirq())
-		target_cputime64 = &cpustat->softirq;
+		target_cputime64 = &cpustat[SOFTIRQ];
 	else
-		target_cputime64 = &cpustat->system;
+		target_cputime64 = &cpustat[SYSTEM];
 
 	__account_system_time(p, cputime, cputime_scaled, target_cputime64);
 }
@@ -3976,10 +3977,10 @@ void account_system_time(struct task_struct *p, int hardirq_offset,
  */
 void account_steal_time(cputime_t cputime)
 {
-	struct cpu_usage_stat *cpustat = &kstat_this_cpu.cpustat;
-	cputime64_t cputime64 = cputime_to_cputime64(cputime);
+	u64 *cpustat = kstat_this_cpu->cpustat;
+	u64 cputime64 = cputime_to_cputime64(cputime);
 
-	cpustat->steal = cputime64_add(cpustat->steal, cputime64);
+	cpustat[STEAL] += cputime64;
 }
 
 /*
@@ -3988,14 +3989,14 @@ void account_steal_time(cputime_t cputime)
  */
 void account_idle_time(cputime_t cputime)
 {
-	struct cpu_usage_stat *cpustat = &kstat_this_cpu.cpustat;
-	cputime64_t cputime64 = cputime_to_cputime64(cputime);
+	u64 *cpustat = kstat_this_cpu->cpustat;
+	u64 cputime64 = cputime_to_cputime64(cputime);
 	struct rq *rq = this_rq();
 
 	if (atomic_read(&rq->nr_iowait) > 0)
-		cpustat->iowait = cputime64_add(cpustat->iowait, cputime64);
+		cpustat[IOWAIT] += cputime64;
 	else
-		cpustat->idle = cputime64_add(cpustat->idle, cputime64);
+		cpustat[IDLE] += cputime64;
 }
 
 static __always_inline bool steal_account_process_tick(void)
@@ -4045,16 +4046,16 @@ static void irqtime_account_process_tick(struct task_struct *p, int user_tick,
 						struct rq *rq)
 {
 	cputime_t one_jiffy_scaled = cputime_to_scaled(cputime_one_jiffy);
-	cputime64_t tmp = cputime_to_cputime64(cputime_one_jiffy);
-	struct cpu_usage_stat *cpustat = &kstat_this_cpu.cpustat;
+	u64 tmp = cputime_to_cputime64(cputime_one_jiffy);
+	u64 *cpustat = kstat_this_cpu->cpustat;
 
 	if (steal_account_process_tick())
 		return;
 
 	if (irqtime_account_hi_update()) {
-		cpustat->irq = cputime64_add(cpustat->irq, tmp);
+		cpustat[IRQ] += tmp;
 	} else if (irqtime_account_si_update()) {
-		cpustat->softirq = cputime64_add(cpustat->softirq, tmp);
+		cpustat[SOFTIRQ] += tmp;
 	} else if (this_cpu_ksoftirqd() == p) {
 		/*
 		 * ksoftirqd time do not get accounted in cpu_softirq_time.
@@ -4062,7 +4063,7 @@ static void irqtime_account_process_tick(struct task_struct *p, int user_tick,
 		 * Also, p->stime needs to be updated for ksoftirqd.
 		 */
 		__account_system_time(p, cputime_one_jiffy, one_jiffy_scaled,
-					&cpustat->softirq);
+					&cpustat[SOFTIRQ]);
 	} else if (user_tick) {
 		account_user_time(p, cputime_one_jiffy, one_jiffy_scaled);
 	} else if (p == rq->idle) {
@@ -4071,7 +4072,7 @@ static void irqtime_account_process_tick(struct task_struct *p, int user_tick,
 		account_guest_time(p, cputime_one_jiffy, one_jiffy_scaled);
 	} else {
 		__account_system_time(p, cputime_one_jiffy, one_jiffy_scaled,
-					&cpustat->system);
+					&cpustat[SYSTEM]);
 	}
 }
 
-- 
1.7.6.4

