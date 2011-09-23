Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752720Ab1IWWXc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Sep 2011 18:23:32 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:9480 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752567Ab1IWWXb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Sep 2011 18:23:31 -0400
From: Glauber Costa <glommer@parallels.com>
To: linux-kernel@vger.kernel.org
Cc: paul@paulmenage.org, lizf@cn.fujitsu.com, daniel.lezcano@free.fr,
        a.p.zijlstra@chello.nl, jbottomley@parallels.com,
        Glauber Costa <glommer@parallels.com>
Subject: [RFD 1/9] Change cpustat fields to an array.
Date: Fri, 23 Sep 2011 19:20:24 -0300
Message-Id: <1316816432-9237-2-git-send-email-glommer@parallels.com>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <1316816432-9237-1-git-send-email-glommer@parallels.com>
References: <1316816432-9237-1-git-send-email-glommer@parallels.com>
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
 fs/proc/stat.c              |   40 ++++++++++++------------
 fs/proc/uptime.c            |    2 +-
 include/linux/kernel_stat.h |   46 +++++++++++++++++-----------
 kernel/sched.c              |   68 ++++++++++++++++++++++++-------------------
 4 files changed, 87 insertions(+), 69 deletions(-)

diff --git a/fs/proc/stat.c b/fs/proc/stat.c
index 9758b65..ec708c7 100644
--- a/fs/proc/stat.c
+++ b/fs/proc/stat.c
@@ -39,18 +39,18 @@ static int show_stat(struct seq_file *p, void *v)
 	jif = boottime.tv_sec;
 
 	for_each_possible_cpu(i) {
-		user = cputime64_add(user, kstat_cpu(i).cpustat.user);
-		nice = cputime64_add(nice, kstat_cpu(i).cpustat.nice);
-		system = cputime64_add(system, kstat_cpu(i).cpustat.system);
-		idle = cputime64_add(idle, kstat_cpu(i).cpustat.idle);
+		user = cputime64_add(user, kstat_cpu(i).cpustat[USER]);
+		nice = cputime64_add(nice, kstat_cpu(i).cpustat[NICE]);
+		system = cputime64_add(system, kstat_cpu(i).cpustat[SYSTEM]);
+		idle = cputime64_add(idle, kstat_cpu(i).cpustat[IDLE]);
 		idle = cputime64_add(idle, arch_idle_time(i));
-		iowait = cputime64_add(iowait, kstat_cpu(i).cpustat.iowait);
-		irq = cputime64_add(irq, kstat_cpu(i).cpustat.irq);
-		softirq = cputime64_add(softirq, kstat_cpu(i).cpustat.softirq);
-		steal = cputime64_add(steal, kstat_cpu(i).cpustat.steal);
-		guest = cputime64_add(guest, kstat_cpu(i).cpustat.guest);
+		iowait = cputime64_add(iowait, kstat_cpu(i).cpustat[IOWAIT]);
+		irq = cputime64_add(irq, kstat_cpu(i).cpustat[IRQ]);
+		softirq = cputime64_add(softirq, kstat_cpu(i).cpustat[SOFTIRQ]);
+		steal = cputime64_add(steal, kstat_cpu(i).cpustat[STEAL]);
+		guest = cputime64_add(guest, kstat_cpu(i).cpustat[GUEST]);
 		guest_nice = cputime64_add(guest_nice,
-			kstat_cpu(i).cpustat.guest_nice);
+			kstat_cpu(i).cpustat[GUEST_NICE]);
 		sum += kstat_cpu_irqs_sum(i);
 		sum += arch_irq_stat_cpu(i);
 
@@ -78,17 +78,17 @@ static int show_stat(struct seq_file *p, void *v)
 	for_each_online_cpu(i) {
 
 		/* Copy values here to work around gcc-2.95.3, gcc-2.96 */
-		user = kstat_cpu(i).cpustat.user;
-		nice = kstat_cpu(i).cpustat.nice;
-		system = kstat_cpu(i).cpustat.system;
-		idle = kstat_cpu(i).cpustat.idle;
+		user = kstat_cpu(i).cpustat[USER];
+		nice = kstat_cpu(i).cpustat[NICE];
+		system = kstat_cpu(i).cpustat[SYSTEM];
+		idle = kstat_cpu(i).cpustat[IDLE];
 		idle = cputime64_add(idle, arch_idle_time(i));
-		iowait = kstat_cpu(i).cpustat.iowait;
-		irq = kstat_cpu(i).cpustat.irq;
-		softirq = kstat_cpu(i).cpustat.softirq;
-		steal = kstat_cpu(i).cpustat.steal;
-		guest = kstat_cpu(i).cpustat.guest;
-		guest_nice = kstat_cpu(i).cpustat.guest_nice;
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
index 0cce2db..93f64f3 100644
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
+	cputime64_t cpustat[NR_STATS];
 #ifndef CONFIG_GENERIC_HARDIRQS
        unsigned int irqs[NR_IRQS];
 #endif
@@ -39,9 +41,17 @@ struct kernel_stat {
 
 DECLARE_PER_CPU(struct kernel_stat, kstat);
 
-#define kstat_cpu(cpu)	per_cpu(kstat, cpu)
+struct kernel_stat *task_group_kstat(struct task_struct *p);
+
+#ifdef CONFIG_CGROUP_SCHED
+#define kstat_cpu(cpu) (*per_cpu_ptr(task_group_kstat(current), cpu))
+
 /* Must have preemption disabled for this to be meaningful. */
-#define kstat_this_cpu	__get_cpu_var(kstat)
+#define kstat_this_cpu	this_cpu_ptr(task_group_kstat(current))
+#else
+#define kstat_cpu(cpu) per_cpu(kstat, cpu)
+#define kstat_this_cpu (&__get_cpu_var(kstat))
+#endif
 
 extern unsigned long long nr_context_switches(void);
 
@@ -52,8 +62,8 @@ struct irq_desc;
 static inline void kstat_incr_irqs_this_cpu(unsigned int irq,
 					    struct irq_desc *desc)
 {
-	__this_cpu_inc(kstat.irqs[irq]);
-	__this_cpu_inc(kstat.irqs_sum);
+	kstat_this_cpu->irqs[irq]++;
+	kstat_this_cpu->irqs_sum++;
 }
 
 static inline unsigned int kstat_irqs_cpu(unsigned int irq, int cpu)
@@ -67,14 +77,14 @@ extern unsigned int kstat_irqs_cpu(unsigned int irq, int cpu);
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
index 3ed4107..2f6bab4 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -278,6 +278,7 @@ struct task_group {
 #ifdef CONFIG_SCHED_AUTOGROUP
 	struct autogroup *autogroup;
 #endif
+	struct kernel_stat __percpu *cpustat;
 };
 
 /* task_group_lock serializes the addition/removal of task groups */
@@ -623,6 +624,9 @@ static inline struct task_group *task_group(struct task_struct *p)
 	struct task_group *tg;
 	struct cgroup_subsys_state *css;
 
+	if (!p->mm)
+		return &root_task_group;
+
 	css = task_subsys_state_check(p, cpu_cgroup_subsys_id,
 			lockdep_is_held(&p->pi_lock) ||
 			lockdep_is_held(&task_rq(p)->lock));
@@ -631,6 +635,12 @@ static inline struct task_group *task_group(struct task_struct *p)
 	return autogroup_task_group(p, tg);
 }
 
+struct kernel_stat *task_group_kstat(struct task_struct *p)
+{
+	struct task_group *tg = task_group(p);
+
+	return tg->cpustat;
+}
 /* Change a task's cfs_rq and parent entity if it moves across CPUs/groups */
 static inline void set_task_rq(struct task_struct *p, unsigned int cpu)
 {
@@ -653,6 +663,8 @@ static inline struct task_group *task_group(struct task_struct *p)
 	return NULL;
 }
 
+DEFINE_PER_CPU(struct kernel_stat, kstat);
+EXPORT_PER_CPU_SYMBOL(kstat);
 #endif /* CONFIG_CGROUP_SCHED */
 
 static void update_rq_clock_task(struct rq *rq, s64 delta);
@@ -2004,14 +2016,14 @@ static void update_rq_clock_task(struct rq *rq, s64 delta)
 #ifdef CONFIG_IRQ_TIME_ACCOUNTING
 static int irqtime_account_hi_update(void)
 {
-	struct cpu_usage_stat *cpustat = &kstat_this_cpu.cpustat;
+	cputime64_t *cpustat = kstat_this_cpu->cpustat;
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
@@ -2019,14 +2031,14 @@ static int irqtime_account_hi_update(void)
 
 static int irqtime_account_si_update(void)
 {
-	struct cpu_usage_stat *cpustat = &kstat_this_cpu.cpustat;
+	cputime64_t *cpustat = kstat_this_cpu->cpustat;
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
@@ -3669,10 +3681,6 @@ unlock:
 
 #endif
 
-DEFINE_PER_CPU(struct kernel_stat, kstat);
-
-EXPORT_PER_CPU_SYMBOL(kstat);
-
 /*
  * Return any ns on the sched_clock that have not yet been accounted in
  * @p in case that task is currently running.
@@ -3757,7 +3765,7 @@ unsigned long long thread_group_sched_runtime(struct task_struct *p)
 void account_user_time(struct task_struct *p, cputime_t cputime,
 		       cputime_t cputime_scaled)
 {
-	struct cpu_usage_stat *cpustat = &kstat_this_cpu.cpustat;
+	cputime64_t *cpustat = kstat_this_cpu->cpustat;
 	cputime64_t tmp;
 
 	/* Add user time to process. */
@@ -3768,9 +3776,9 @@ void account_user_time(struct task_struct *p, cputime_t cputime,
 	/* Add user time to cpustat. */
 	tmp = cputime_to_cputime64(cputime);
 	if (TASK_NICE(p) > 0)
-		cpustat->nice = cputime64_add(cpustat->nice, tmp);
+		cpustat[NICE] = cputime64_add(cpustat[NICE], tmp);
 	else
-		cpustat->user = cputime64_add(cpustat->user, tmp);
+		cpustat[USER] = cputime64_add(cpustat[USER], tmp);
 
 	cpuacct_update_stats(p, CPUACCT_STAT_USER, cputime);
 	/* Account for user time used */
@@ -3787,7 +3795,7 @@ static void account_guest_time(struct task_struct *p, cputime_t cputime,
 			       cputime_t cputime_scaled)
 {
 	cputime64_t tmp;
-	struct cpu_usage_stat *cpustat = &kstat_this_cpu.cpustat;
+	cputime64_t *cpustat = kstat_this_cpu->cpustat;
 
 	tmp = cputime_to_cputime64(cputime);
 
@@ -3799,11 +3807,11 @@ static void account_guest_time(struct task_struct *p, cputime_t cputime,
 
 	/* Add guest time to cpustat. */
 	if (TASK_NICE(p) > 0) {
-		cpustat->nice = cputime64_add(cpustat->nice, tmp);
-		cpustat->guest_nice = cputime64_add(cpustat->guest_nice, tmp);
+		cpustat[NICE] = cputime64_add(cpustat[NICE], tmp);
+		cpustat[GUEST_NICE] = cputime64_add(cpustat[GUEST_NICE], tmp);
 	} else {
-		cpustat->user = cputime64_add(cpustat->user, tmp);
-		cpustat->guest = cputime64_add(cpustat->guest, tmp);
+		cpustat[USER] = cputime64_add(cpustat[USER], tmp);
+		cpustat[GUEST] = cputime64_add(cpustat[GUEST], tmp);
 	}
 }
 
@@ -3843,7 +3851,7 @@ void __account_system_time(struct task_struct *p, cputime_t cputime,
 void account_system_time(struct task_struct *p, int hardirq_offset,
 			 cputime_t cputime, cputime_t cputime_scaled)
 {
-	struct cpu_usage_stat *cpustat = &kstat_this_cpu.cpustat;
+	cputime64_t *cpustat = kstat_this_cpu->cpustat;
 	cputime64_t *target_cputime64;
 
 	if ((p->flags & PF_VCPU) && (irq_count() - hardirq_offset == 0)) {
@@ -3852,11 +3860,11 @@ void account_system_time(struct task_struct *p, int hardirq_offset,
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
@@ -3867,10 +3875,10 @@ void account_system_time(struct task_struct *p, int hardirq_offset,
  */
 void account_steal_time(cputime_t cputime)
 {
-	struct cpu_usage_stat *cpustat = &kstat_this_cpu.cpustat;
+	cputime64_t *cpustat = kstat_this_cpu->cpustat;
 	cputime64_t cputime64 = cputime_to_cputime64(cputime);
 
-	cpustat->steal = cputime64_add(cpustat->steal, cputime64);
+	cpustat[STEAL] = cputime64_add(cpustat[STEAL], cputime64);
 }
 
 /*
@@ -3879,14 +3887,14 @@ void account_steal_time(cputime_t cputime)
  */
 void account_idle_time(cputime_t cputime)
 {
-	struct cpu_usage_stat *cpustat = &kstat_this_cpu.cpustat;
+	cputime64_t *cpustat = kstat_this_cpu->cpustat;
 	cputime64_t cputime64 = cputime_to_cputime64(cputime);
 	struct rq *rq = this_rq();
 
 	if (atomic_read(&rq->nr_iowait) > 0)
-		cpustat->iowait = cputime64_add(cpustat->iowait, cputime64);
+		cpustat[IOWAIT] = cputime64_add(cpustat[IOWAIT], cputime64);
 	else
-		cpustat->idle = cputime64_add(cpustat->idle, cputime64);
+		cpustat[IDLE] = cputime64_add(cpustat[IDLE], cputime64);
 }
 
 static __always_inline bool steal_account_process_tick(void)
@@ -3937,15 +3945,15 @@ static void irqtime_account_process_tick(struct task_struct *p, int user_tick,
 {
 	cputime_t one_jiffy_scaled = cputime_to_scaled(cputime_one_jiffy);
 	cputime64_t tmp = cputime_to_cputime64(cputime_one_jiffy);
-	struct cpu_usage_stat *cpustat = &kstat_this_cpu.cpustat;
+	cputime64_t *cpustat = kstat_this_cpu->cpustat;
 
 	if (steal_account_process_tick())
 		return;
 
 	if (irqtime_account_hi_update()) {
-		cpustat->irq = cputime64_add(cpustat->irq, tmp);
+		cpustat[IRQ] = cputime64_add(cpustat[IRQ], tmp);
 	} else if (irqtime_account_si_update()) {
-		cpustat->softirq = cputime64_add(cpustat->softirq, tmp);
+		cpustat[SOFTIRQ] = cputime64_add(cpustat[SOFTIRQ], tmp);
 	} else if (this_cpu_ksoftirqd() == p) {
 		/*
 		 * ksoftirqd time do not get accounted in cpu_softirq_time.
@@ -3953,7 +3961,7 @@ static void irqtime_account_process_tick(struct task_struct *p, int user_tick,
 		 * Also, p->stime needs to be updated for ksoftirqd.
 		 */
 		__account_system_time(p, cputime_one_jiffy, one_jiffy_scaled,
-					&cpustat->softirq);
+					&cpustat[SOFTIRQ]);
 	} else if (user_tick) {
 		account_user_time(p, cputime_one_jiffy, one_jiffy_scaled);
 	} else if (p == rq->idle) {
@@ -3962,7 +3970,7 @@ static void irqtime_account_process_tick(struct task_struct *p, int user_tick,
 		account_guest_time(p, cputime_one_jiffy, one_jiffy_scaled);
 	} else {
 		__account_system_time(p, cputime_one_jiffy, one_jiffy_scaled,
-					&cpustat->system);
+					&cpustat[SYSTEM]);
 	}
 }
 
-- 
1.7.6

