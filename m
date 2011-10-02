Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754153Ab1JBTWv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Oct 2011 15:22:51 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:45971 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754163Ab1JBTW0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Oct 2011 15:22:26 -0400
From: Glauber Costa <glommer@parallels.com>
To: linux-kernel@vger.kernel.org
Cc: paul@paulmenage.org, lizf@cn.fujitsu.com, daniel.lezcano@free.fr,
        a.p.zijlstra@chello.nl, jbottomley@parallels.com,
        Glauber Costa <glommer@parallels.com>
Subject: [PATCH 02/10] Change cpustat fields to an array.
Date: Sun,  2 Oct 2011 23:21:19 +0400
Message-Id: <1317583287-18300-3-git-send-email-glommer@parallels.com>
X-Mailer: git-send-email 1.7.6.2
In-Reply-To: <1317583287-18300-1-git-send-email-glommer@parallels.com>
References: <1317583287-18300-1-git-send-email-glommer@parallels.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This will give us a bit more flexibility to deal with the
fields in this structure. This is a preparation patch for
later patches in this series.

I tried to keep the acessor macros unchanged, so we don't need
to patch all users.. At some point I gave up on kstat_this_cpu.
But to be fair, this one is not used outside of sched.c, so is
not a big deal.

Signed-off-by: Glauber Costa <glommer@parallels.com>
---
 fs/proc/stat.c              |   53 ++++++++++++++++----------------
 fs/proc/uptime.c            |    2 +-
 include/linux/kernel_stat.h |   38 ++++++++++++-----------
 kernel/sched.c              |   71 ++++++++++++++++++++++---------------------
 4 files changed, 83 insertions(+), 81 deletions(-)

diff --git a/fs/proc/stat.c b/fs/proc/stat.c
index 9758b65..e8e2b39 100644
--- a/fs/proc/stat.c
+++ b/fs/proc/stat.c
@@ -25,32 +25,31 @@ static int show_stat(struct seq_file *p, void *v)
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
-		idle = cputime64_add(idle, kstat_cpu(i).cpustat.idle);
-		idle = cputime64_add(idle, arch_idle_time(i));
-		iowait = cputime64_add(iowait, kstat_cpu(i).cpustat.iowait);
-		irq = cputime64_add(irq, kstat_cpu(i).cpustat.irq);
-		softirq = cputime64_add(softirq, kstat_cpu(i).cpustat.softirq);
-		steal = cputime64_add(steal, kstat_cpu(i).cpustat.steal);
-		guest = cputime64_add(guest, kstat_cpu(i).cpustat.guest);
-		guest_nice = cputime64_add(guest_nice,
-			kstat_cpu(i).cpustat.guest_nice);
+		user += kstat_cpu(i).cpustat[USER];
+		nice += kstat_cpu(i).cpustat[NICE];
+		system += kstat_cpu(i).cpustat[SYSTEM];
+		idle += kstat_cpu(i).cpustat[IDLE];
+		idle += arch_idle_time(i);
+		iowait += kstat_cpu(i).cpustat[IOWAIT];
+		irq += kstat_cpu(i).cpustat[IRQ];
+		softirq += kstat_cpu(i).cpustat[SOFTIRQ];
+		steal += kstat_cpu(i).cpustat[STEAL];
+		guest += kstat_cpu(i).cpustat[GUEST];
+		guest_nice += kstat_cpu(i).cpustat[GUEST_NICE];
 		sum += kstat_cpu_irqs_sum(i);
 		sum += arch_irq_stat_cpu(i);
 
@@ -78,17 +77,17 @@ static int show_stat(struct seq_file *p, void *v)
 	for_each_online_cpu(i) {
 
 		/* Copy values here to work around gcc-2.95.3, gcc-2.96 */
-		user = kstat_cpu(i).cpustat.user;
-		nice = kstat_cpu(i).cpustat.nice;
-		system = kstat_cpu(i).cpustat.system;
-		idle = kstat_cpu(i).cpustat.idle;
-		idle = cputime64_add(idle, arch_idle_time(i));
-		iowait = kstat_cpu(i).cpustat.iowait;
-		irq = kstat_cpu(i).cpustat.irq;
-		softirq = kstat_cpu(i).cpustat.softirq;
-		steal = kstat_cpu(i).cpustat.steal;
-		guest = kstat_cpu(i).cpustat.guest;
-		guest_nice = kstat_cpu(i).cpustat.guest_nice;
+		user = kstat_cpu(i).cpustat[USER];
+		nice = kstat_cpu(i).cpustat[NICE];
+		system = kstat_cpu(i).cpustat[SYSTEM];
+		idle = kstat_cpu(i).cpustat[IDLE];
+		idle += arch_idle_time(i);
+		iowait = kstat_cpu(i).cpustat[IOWAIT];
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
index 0cce2db..897eabf 100644
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
 
@@ -52,8 +54,8 @@ struct irq_desc;
 static inline void kstat_incr_irqs_this_cpu(unsigned int irq,
 					    struct irq_desc *desc)
 {
-	__this_cpu_inc(kstat.irqs[irq]);
-	__this_cpu_inc(kstat.irqs_sum);
+	kstat_this_cpu->irqs[irq]++;
+	kstat_this_cpu->irqs_sum++;
 }
 
 static inline unsigned int kstat_irqs_cpu(unsigned int irq, int cpu)
@@ -67,14 +69,14 @@ extern unsigned int kstat_irqs_cpu(unsigned int irq, int cpu);
 #define kstat_incr_irqs_this_cpu(irqno, DESC)		\
 do {							\
 	__this_cpu_inc(*(DESC)->kstat_irqs);		\
-	__this_cpu_inc(kstat.irqs_sum);			\
+	kstat_this_cpu->irqs_sum++;			\
 } while (0)
 
 #endif
 
 static inline void kstat_incr_softirqs_this_cpu(unsigned int irq)
 {
-	__this_cpu_inc(kstat.softirqs[irq]);
+	kstat_this_cpu->softirqs[irq]++;
 }
 
 static inline unsigned int kstat_softirqs_cpu(unsigned int irq, int cpu)
diff --git a/kernel/sched.c b/kernel/sched.c
index 3ed4107..8f0fa05 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -2004,14 +2004,14 @@ static void update_rq_clock_task(struct rq *rq, s64 delta)
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
@@ -2019,14 +2019,14 @@ static int irqtime_account_hi_update(void)
 
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
@@ -3757,8 +3757,8 @@ unsigned long long thread_group_sched_runtime(struct task_struct *p)
 void account_user_time(struct task_struct *p, cputime_t cputime,
 		       cputime_t cputime_scaled)
 {
-	struct cpu_usage_stat *cpustat = &kstat_this_cpu.cpustat;
-	cputime64_t tmp;
+	u64 *cpustat = kstat_this_cpu->cpustat;
+	u64 tmp;
 
 	/* Add user time to process. */
 	p->utime = cputime_add(p->utime, cputime);
@@ -3767,10 +3767,11 @@ void account_user_time(struct task_struct *p, cputime_t cputime,
 
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
@@ -3786,8 +3787,8 @@ void account_user_time(struct task_struct *p, cputime_t cputime,
 static void account_guest_time(struct task_struct *p, cputime_t cputime,
 			       cputime_t cputime_scaled)
 {
-	cputime64_t tmp;
-	struct cpu_usage_stat *cpustat = &kstat_this_cpu.cpustat;
+	u64 tmp;
+	u64 *cpustat = kstat_this_cpu->cpustat;
 
 	tmp = cputime_to_cputime64(cputime);
 
@@ -3799,11 +3800,11 @@ static void account_guest_time(struct task_struct *p, cputime_t cputime,
 
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
 
@@ -3816,9 +3817,9 @@ static void account_guest_time(struct task_struct *p, cputime_t cputime,
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
@@ -3826,7 +3827,7 @@ void __account_system_time(struct task_struct *p, cputime_t cputime,
 	account_group_system_time(p, cputime);
 
 	/* Add system time to cpustat. */
-	*target_cputime64 = cputime64_add(*target_cputime64, tmp);
+	*target_cputime64 += tmp;
 	cpuacct_update_stats(p, CPUACCT_STAT_SYSTEM, cputime);
 
 	/* Account for system time used */
@@ -3843,8 +3844,8 @@ void __account_system_time(struct task_struct *p, cputime_t cputime,
 void account_system_time(struct task_struct *p, int hardirq_offset,
 			 cputime_t cputime, cputime_t cputime_scaled)
 {
-	struct cpu_usage_stat *cpustat = &kstat_this_cpu.cpustat;
-	cputime64_t *target_cputime64;
+	u64 *cpustat = kstat_this_cpu->cpustat;
+	u64 *target_cputime64;
 
 	if ((p->flags & PF_VCPU) && (irq_count() - hardirq_offset == 0)) {
 		account_guest_time(p, cputime, cputime_scaled);
@@ -3852,11 +3853,11 @@ void account_system_time(struct task_struct *p, int hardirq_offset,
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
@@ -3867,10 +3868,10 @@ void account_system_time(struct task_struct *p, int hardirq_offset,
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
@@ -3879,14 +3880,14 @@ void account_steal_time(cputime_t cputime)
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
@@ -3936,16 +3937,16 @@ static void irqtime_account_process_tick(struct task_struct *p, int user_tick,
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
@@ -3953,7 +3954,7 @@ static void irqtime_account_process_tick(struct task_struct *p, int user_tick,
 		 * Also, p->stime needs to be updated for ksoftirqd.
 		 */
 		__account_system_time(p, cputime_one_jiffy, one_jiffy_scaled,
-					&cpustat->softirq);
+					&cpustat[SOFTIRQ]);
 	} else if (user_tick) {
 		account_user_time(p, cputime_one_jiffy, one_jiffy_scaled);
 	} else if (p == rq->idle) {
@@ -3962,7 +3963,7 @@ static void irqtime_account_process_tick(struct task_struct *p, int user_tick,
 		account_guest_time(p, cputime_one_jiffy, one_jiffy_scaled);
 	} else {
 		__account_system_time(p, cputime_one_jiffy, one_jiffy_scaled,
-					&cpustat->system);
+					&cpustat[SYSTEM]);
 	}
 }
 
-- 
1.7.6

