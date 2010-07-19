Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760887Ab0GSX5s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jul 2010 19:57:48 -0400
Received: from smtp-out.google.com ([74.125.121.35]:15187 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758031Ab0GSX5q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jul 2010 19:57:46 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:
	references:x-system-of-record;
	b=ywPCYkaM1UbTWr+Ccuwe+C8IT98MS5/fBwpw7lrBsVESZXaTdUrRky2gVuU1FbmO1
	u78vlFaBtu6p0JfYaiWyA==
From: Venkatesh Pallipadi <venki@google.com>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Venkatesh Pallipadi <venki@google.com>, Paul Menage <menage@google.com>,
        linux-kernel@vger.kernel.org, Paul Turner <pjt@google.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Paul Mackerras <paulus@samba.org>, Tony Luck <tony.luck@intel.com>
Subject: [PATCH 2/4] x86: Add IRQ_TIME_ACCOUNTING, finer accounting of irq time to task
Date: Mon, 19 Jul 2010 16:57:13 -0700
Message-Id: <1279583835-22854-3-git-send-email-venki@google.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1279583835-22854-1-git-send-email-venki@google.com>
References: <1279583835-22854-1-git-send-email-venki@google.com>
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

s390/powerpc/ia64 have support for CONFIG_VIRT_CPU_ACCOUNTING which does
the fine granularity accounting of user, system, hardirq, softirq times.
Adding that option on archs like x86 may be challenging however, given the
state of TSC reliability on various platforms and also the overhead it may
add in syscall entry exit.

Instead, add an option that only does finer accounting of hardirq-softirq,
providing precise irq times (instead of timer ticks based samples). This
accounting is added with a new config option CONFIG_IRQ_TIME_ACCOUNTING
so that there wont be any overhead for users not interested in paying the
perf penalty. And this accounting is based on sched_clock, so other archs
may find it useful as well.

Note that the kstat_cpu irq times are still based on tick based samples
and only the task irq times report this new finer granularity irq time.
The reason being that the kstat irq also includes system time and
changing only irq time to have finer granularity can result in inconsistency
like sum kstat time adding up to more than 100% etc.

Continuing with the example from previous patch, without finer
granularity accounting, exec_time and si_time in 10s intervals were
(appropriate fields of /proc/<pid>/stat)
(loop)  (nc)
505 0   500 359
502 1   501 363
503 0   502 354
504 0   499 359
503 3   500 360

And with finer granularity accounting they were
(loop)  (nc)
503 9   502 301
502 8   502 303
502 9   501 302
502 8   502 302
503 9   501 302

Signed-off-by: Venkatesh Pallipadi <venki@google.com>
---
 arch/ia64/include/asm/system.h    |    4 --
 arch/powerpc/include/asm/system.h |    4 --
 arch/s390/include/asm/system.h    |    1 -
 arch/x86/Kconfig                  |   11 +++++++
 arch/x86/kernel/tsc.c             |    2 +
 fs/proc/array.c                   |    4 +-
 include/linux/hardirq.h           |   15 +++++++++-
 include/linux/sched.h             |   13 ++++++++
 kernel/sched.c                    |   59 +++++++++++++++++++++++++++++++++++-
 9 files changed, 99 insertions(+), 14 deletions(-)

diff --git a/arch/ia64/include/asm/system.h b/arch/ia64/include/asm/system.h
index 9f342a5..dd028f2 100644
--- a/arch/ia64/include/asm/system.h
+++ b/arch/ia64/include/asm/system.h
@@ -272,10 +272,6 @@ void cpu_idle_wait(void);
 
 void default_idle(void);
 
-#ifdef CONFIG_VIRT_CPU_ACCOUNTING
-extern void account_system_vtime(struct task_struct *);
-#endif
-
 #endif /* __KERNEL__ */
 
 #endif /* __ASSEMBLY__ */
diff --git a/arch/powerpc/include/asm/system.h b/arch/powerpc/include/asm/system.h
index a6297c6..880fb57 100644
--- a/arch/powerpc/include/asm/system.h
+++ b/arch/powerpc/include/asm/system.h
@@ -545,10 +545,6 @@ extern void reloc_got2(unsigned long);
 
 #define PTRRELOC(x)	((typeof(x)) add_reloc_offset((unsigned long)(x)))
 
-#ifdef CONFIG_VIRT_CPU_ACCOUNTING
-extern void account_system_vtime(struct task_struct *);
-#endif
-
 extern struct dentry *powerpc_debugfs_root;
 
 #endif /* __KERNEL__ */
diff --git a/arch/s390/include/asm/system.h b/arch/s390/include/asm/system.h
index cef6621..38ddd8a 100644
--- a/arch/s390/include/asm/system.h
+++ b/arch/s390/include/asm/system.h
@@ -97,7 +97,6 @@ static inline void restore_access_regs(unsigned int *acrs)
 
 extern void account_vtime(struct task_struct *, struct task_struct *);
 extern void account_tick_vtime(struct task_struct *);
-extern void account_system_vtime(struct task_struct *);
 
 #ifdef CONFIG_PFAULT
 extern void pfault_irq_init(void);
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index dcb0593..ae6705d 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -367,6 +367,17 @@ endif
 # This is an alphabetically sorted list of 64 bit extended platforms
 # Please maintain the alphabetic order if and when there are additions
 
+config IRQ_TIME_ACCOUNTING
+	bool "Fine granularity task level IRQ time accounting"
+	default n
+	help
+	  Select this option to enable fine granularity task irq time
+	  accounting. This is done by reading a timestamp on each
+	  transitions between softirq and hardirq state, so there can be a
+	  small performance impact.
+
+	  If in doubt, say N here.
+
 config X86_VSMP
 	bool "ScaleMP vSMP"
 	select PARAVIRT
diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
index 9faf91a..5b5a213 100644
--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -952,6 +952,8 @@ void __init tsc_init(void)
 	/* now allow native_sched_clock() to use rdtsc */
 	tsc_disabled = 0;
 
+	enable_sched_clock_irqtime();
+
 	lpj = ((u64)tsc_khz * 1000);
 	do_div(lpj, HZ);
 	lpj_fine = lpj;
diff --git a/fs/proc/array.c b/fs/proc/array.c
index 4555cfb..8316c96 100644
--- a/fs/proc/array.c
+++ b/fs/proc/array.c
@@ -526,8 +526,8 @@ static int do_task_stat(struct seq_file *m, struct pid_namespace *ns,
 		cputime_to_clock_t(gtime),
 		cputime_to_clock_t(cgtime),
 		(unsigned long long)nsec_to_clock_t(exec_time),
-		(unsigned long long)cputime64_to_clock_t(hi_time),
-		(unsigned long long)cputime64_to_clock_t(si_time));
+		(unsigned long long)irqtime_to_clock_t(hi_time),
+		(unsigned long long)irqtime_to_clock_t(si_time));
 	if (mm)
 		mmput(mm);
 	return 0;
diff --git a/include/linux/hardirq.h b/include/linux/hardirq.h
index d5b3876..a342de5 100644
--- a/include/linux/hardirq.h
+++ b/include/linux/hardirq.h
@@ -132,10 +132,23 @@ extern void synchronize_irq(unsigned int irq);
 
 struct task_struct;
 
-#ifndef CONFIG_VIRT_CPU_ACCOUNTING
+#if !defined(CONFIG_VIRT_CPU_ACCOUNTING) && !defined(CONFIG_IRQ_TIME_ACCOUNTING)
 static inline void account_system_vtime(struct task_struct *tsk)
 {
 }
+#else
+extern void account_system_vtime(struct task_struct *tsk);
+#endif
+
+#ifdef CONFIG_VIRT_CPU_ACCOUNTING
+/*
+ * task irqtime is kept track in cputime64_t units when VIRT_CPU_ACCOUNTING
+ * is enabled and ns units when it is disabled. Since jiffies is not
+ * fine enough to keep track of irqtime with IRQ_TIME_ACCOUNTING.
+ */
+#define irqtime_to_clock_t(irqtime)	cputime64_to_clock_t(irqtime)
+#else
+#define irqtime_to_clock_t(irqtime)	nsec_to_clock_t(irqtime)
 #endif
 
 #if defined(CONFIG_NO_HZ)
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 3ba8cb9..37798c3 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1794,6 +1794,19 @@ static inline int set_cpus_allowed(struct task_struct *p, cpumask_t new_mask)
 #endif
 
 /*
+ * With CONFIG_IRQ_TIME_ACCOUNTING, archs can call this if they have a
+ * 'fast' sched_clock() and they want to account irqtime based off of
+ * sched_clock()
+ */
+#ifndef CONFIG_IRQ_TIME_ACCOUNTING
+static inline void enable_sched_clock_irqtime(void)
+{
+}
+#else
+extern void enable_sched_clock_irqtime(void);
+#endif
+
+/*
  * Architectures can set this to 1 if they have specified
  * CONFIG_HAVE_UNSTABLE_SCHED_CLOCK in their arch Kconfig,
  * but then during bootup it turns out that sched_clock()
diff --git a/kernel/sched.c b/kernel/sched.c
index 3c246cb..f167fbb 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -3207,6 +3207,34 @@ static void account_guest_time(struct task_struct *p, cputime_t cputime,
 	}
 }
 
+#ifdef CONFIG_IRQ_TIME_ACCOUNTING
+static int sched_clock_irqtime;
+void enable_sched_clock_irqtime(void)
+{
+	sched_clock_irqtime = 1;
+}
+#else
+#define sched_clock_irqtime 0
+#endif
+
+#if defined(CONFIG_VIRT_CPU_ACCOUNTING)
+static void account_task_irqtime(cputime64_t *task_irqtime, cputime64_t irqtime)
+{
+	*task_irqtime = cputime64_add(*task_irqtime, irqtime);
+}
+#else
+/*
+ * Called at tick when we are in si/hi.
+ * We handle !sched_clock_irqtime case here as when sched_clock_irqtime is set,
+ * this accounting is done in account_system_vtime() below.
+ */
+static void account_task_irqtime(cputime64_t *task_irqtime, cputime64_t irqtime)
+{
+	if (!sched_clock_irqtime)
+		*task_irqtime = cputime64_add(*task_irqtime, TICK_NSEC);
+}
+#endif
+
 /*
  * Account system cpu time to a process.
  * @p: the process that the cpu time gets accounted to
@@ -3234,10 +3262,10 @@ void account_system_time(struct task_struct *p, int hardirq_offset,
 	tmp = cputime_to_cputime64(cputime);
 	if (hardirq_count() - hardirq_offset) {
 		cpustat->irq = cputime64_add(cpustat->irq, tmp);
-		p->hi_time = cputime64_add(p->hi_time, tmp);
+		account_task_irqtime(&p->hi_time, tmp);
 	} else if (softirq_count()) {
 		cpustat->softirq = cputime64_add(cpustat->softirq, tmp);
-		p->si_time = cputime64_add(p->si_time, tmp);
+		account_task_irqtime(&p->si_time, tmp);
 	} else {
 		cpustat->system = cputime64_add(cpustat->system, tmp);
 	}
@@ -8967,3 +8995,30 @@ void synchronize_sched_expedited(void)
 EXPORT_SYMBOL_GPL(synchronize_sched_expedited);
 
 #endif /* #else #ifndef CONFIG_SMP */
+
+#ifdef CONFIG_IRQ_TIME_ACCOUNTING
+
+static DEFINE_PER_CPU(u64, irq_start_time);
+
+void account_system_vtime(struct task_struct *tsk)
+{
+	unsigned long flags;
+	int cpu;
+	u64 now;
+
+	if (!sched_clock_irqtime)
+		return;
+
+	local_irq_save(flags);
+	cpu = task_cpu(tsk);
+	now = sched_clock_cpu(cpu);
+	if (hardirq_count())
+		tsk->hi_time += now - per_cpu(irq_start_time, cpu);
+	else if (softirq_count())
+		tsk->si_time += now - per_cpu(irq_start_time, cpu);
+
+	per_cpu(irq_start_time, cpu) = now;
+	local_irq_restore(flags);
+}
+
+#endif
-- 
1.7.1

