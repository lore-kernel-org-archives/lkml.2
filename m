Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932977Ab0EYAMF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 May 2010 20:12:05 -0400
Received: from smtp-out.google.com ([74.125.121.35]:61841 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932651Ab0EYALy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 May 2010 20:11:54 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:
	references:x-system-of-record;
	b=Swzxa6YaibW9O1S0txjEWU729Wc7FVcccoQ3J+nWNoymgceRzi72ozW9iQ/A8apiD
	QtjmjoLkCiATWW/zzxbSw==
From: Venkatesh Pallipadi <venki@google.com>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Paul Menage <menage@google.com>
Cc: linux-kernel@vger.kernel.org, Paul Turner <pjt@google.com>,
       Venkatesh Pallipadi <venki@google.com>
Subject: [RFC PATCH 2/4] x86: Add IRQ_TIME_ACCOUNTING, finer accounting of irq time to task
Date: Mon, 24 May 2010 17:11:20 -0700
Message-Id: <1274746282-21533-3-git-send-email-venki@google.com>
X-Mailer: git-send-email 1.7.0.1
In-Reply-To: <1274746282-21533-2-git-send-email-venki@google.com>
References: <1274746282-21533-1-git-send-email-venki@google.com>
 <1274746282-21533-2-git-send-email-venki@google.com>
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some archs have support for CONFIG_VIRT_CPU_ACCOUNTING which does
the fine granularity accounting of user, system, hardirq, softirq times.
Adding that option on archs like x86 may be challenging however, given the
state of TSC reliability on various platforms and also the overhead it may
ass in syscall entry exit.

Instead, add an option that only does finer accounting of hardirq softirq,
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
granularity accounting, exec_time and si_time in 10s intervals would be
(appropriate fields of /proc/<pid>/stat)
(loop)  (nc)
505 0   500 359
502 1   501 363
503 0   502 354
504 0   499 359
503 3   500 360

And with finer granularity accounting they would be
(loop)  (nc)
503 9   502 301
502 8   502 303
502 9   501 302
502 8   502 302
503 9   501 302

Signed-off-by: Venkatesh Pallipadi <venki@google.com>
---
 arch/x86/Kconfig        |   11 +++++++++++
 fs/proc/array.c         |   11 +++++++++--
 include/linux/hardirq.h |    4 +++-
 kernel/sched.c          |   35 +++++++++++++++++++++++++++++++++--
 4 files changed, 56 insertions(+), 5 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index a2d3a5f..d34e305 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -364,6 +364,17 @@ endif
 # This is an alphabetically sorted list of 64 bit extended platforms
 # Please maintain the alphabetic order if and when there are additions
 
+config IRQ_TIME_ACCOUNTING
+	bool "Fine granularity task level IRQ time accounting"
+	default n
+	help
+	  Select this option to enable fine granularity task irq time
+	  accounting. This is done by reading a timestamp on each
+	  transitions between softirq and hardirq state, so there is a
+	  small performance impact.
+
+	  If in doubt, say N here.
+
 config X86_VSMP
 	bool "ScaleMP vSMP"
 	select PARAVIRT
diff --git a/fs/proc/array.c b/fs/proc/array.c
index 401a1c0..16b755e 100644
--- a/fs/proc/array.c
+++ b/fs/proc/array.c
@@ -360,6 +360,13 @@ int proc_pid_status(struct seq_file *m, struct pid_namespace *ns,
 	return 0;
 }
 
+#ifdef CONFIG_IRQ_TIME_ACCOUNTING
+/* [hi|si]_time are stored in ns units as cputime may not be fine enough */
+#define IRQTIME_TO_CLOCK_T(x)	nsec_to_clock_t(x)
+#else
+#define IRQTIME_TO_CLOCK_T(x)	cputime64_to_clock_t(x)
+#endif
+
 static int do_task_stat(struct seq_file *m, struct pid_namespace *ns,
 			struct pid *pid, struct task_struct *task, int whole)
 {
@@ -526,8 +533,8 @@ static int do_task_stat(struct seq_file *m, struct pid_namespace *ns,
 		cputime_to_clock_t(gtime),
 		cputime_to_clock_t(cgtime),
 		nsec_to_clock_t(exec_time),
-		(unsigned long long)cputime64_to_clock_t(si_time),
-		(unsigned long long)cputime64_to_clock_t(hi_time));
+		(unsigned long long)IRQTIME_TO_CLOCK_T(si_time),
+		(unsigned long long)IRQTIME_TO_CLOCK_T(hi_time));
 	if (mm)
 		mmput(mm);
 	return 0;
diff --git a/include/linux/hardirq.h b/include/linux/hardirq.h
index d5b3876..bfafd29 100644
--- a/include/linux/hardirq.h
+++ b/include/linux/hardirq.h
@@ -132,10 +132,12 @@ extern void synchronize_irq(unsigned int irq);
 
 struct task_struct;
 
-#ifndef CONFIG_VIRT_CPU_ACCOUNTING
+#if !defined(CONFIG_VIRT_CPU_ACCOUNTING) && !defined(CONFIG_IRQ_TIME_ACCOUNTING)
 static inline void account_system_vtime(struct task_struct *tsk)
 {
 }
+#else
+extern void account_system_vtime(struct task_struct *tsk);
 #endif
 
 #if defined(CONFIG_NO_HZ)
diff --git a/kernel/sched.c b/kernel/sched.c
index b410d5f..e6090ff 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -3228,6 +3228,13 @@ static void account_guest_time(struct task_struct *p, cputime_t cputime,
 	}
 }
 
+#ifdef CONFIG_IRQ_TIME_ACCOUNTING
+/* In this case, we charge the task at irq time for finer accounting */
+#define TASK_IRQ_CHARGE_AT_TICK(x, y)	(x)
+#else
+#define TASK_IRQ_CHARGE_AT_TICK(x, y)	cputime64_add(x, y)
+#endif
+
 /*
  * Account system cpu time to a process.
  * @p: the process that the cpu time gets accounted to
@@ -3255,10 +3262,10 @@ void account_system_time(struct task_struct *p, int hardirq_offset,
 	tmp = cputime_to_cputime64(cputime);
 	if (hardirq_count() - hardirq_offset) {
 		cpustat->irq = cputime64_add(cpustat->irq, tmp);
-		p->hi_time = cputime64_add(p->hi_time, tmp);
+		p->hi_time = TASK_IRQ_CHARGE_AT_TICK(p->hi_time, tmp);
 	} else if (softirq_count()) {
 		cpustat->softirq = cputime64_add(cpustat->softirq, tmp);
-		p->si_time = cputime64_add(p->si_time, tmp);
+		p->si_time = TASK_IRQ_CHARGE_AT_TICK(p->si_time, tmp);
 	} else {
 		cpustat->system = cputime64_add(cpustat->system, tmp);
 	}
@@ -8967,3 +8974,27 @@ void synchronize_sched_expedited(void)
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
1.7.0.1

