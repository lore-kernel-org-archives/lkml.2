Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756287Ab1BJMZT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 07:25:19 -0500
Received: from cantor2.suse.de ([195.135.220.15]:37666 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756232Ab1BJMZK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 07:25:10 -0500
From: stable-bot for Venkatesh Pallipadi <venki@google.com>
Date: Thu, 10 Feb 2011 10:23:27 +0100
Subject: [PATCH 17/28] sched: Add IRQ_TIME_ACCOUNTING, finer accounting of
 irq time
To: stable@kernel.org
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@elte.hu>
Message-ID: <1297340644.5512.17.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit: b52bfee445d315549d41eacf2fa7c156e7d153d5 upstream
Author: Venkatesh Pallipadi <venki@google.com>
AuthorDate: Mon Oct 4 17:03:19 2010 -0700

s390/powerpc/ia64 have support for CONFIG_VIRT_CPU_ACCOUNTING which does
the fine granularity accounting of user, system, hardirq, softirq times.
Adding that option on archs like x86 will be challenging however, given the
state of TSC reliability on various platforms and also the overhead it will
add in syscall entry exit.

Instead, add a lighter variant that only does finer accounting of
hardirq and softirq times, providing precise irq times (instead of timer tick
based samples). This accounting is added with a new config option
CONFIG_IRQ_TIME_ACCOUNTING so that there won't be any overhead for users not
interested in paying the perf penalty.

This accounting is based on sched_clock, with the code being generic.
So, other archs may find it useful as well.

This patch just adds the core logic and does not enable this logic yet.

Signed-off-by: Venkatesh Pallipadi <venki@google.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <1286237003-12406-5-git-send-email-venki@google.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Mike Galbraith <efault@gmx.de>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 include/linux/hardirq.h |    2 +-
 include/linux/sched.h   |   13 ++++++++++++
 kernel/sched.c          |   49 +++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 63 insertions(+), 1 deletions(-)

diff --git a/include/linux/hardirq.h b/include/linux/hardirq.h
index a1c732a..a75d3a0 100644
--- a/include/linux/hardirq.h
+++ b/include/linux/hardirq.h
@@ -137,7 +137,7 @@ extern void synchronize_irq(unsigned int irq);
 
 struct task_struct;
 
-#ifndef CONFIG_VIRT_CPU_ACCOUNTING
+#if !defined(CONFIG_VIRT_CPU_ACCOUNTING) && !defined(CONFIG_IRQ_TIME_ACCOUNTING)
 static inline void account_system_vtime(struct task_struct *tsk)
 {
 }
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 63d5aea..1ca5d04 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1865,6 +1865,19 @@ extern void sched_clock_idle_wakeup_event(u64 delta_ns);
  */
 extern unsigned long long cpu_clock(int cpu);
 
+#ifdef CONFIG_IRQ_TIME_ACCOUNTING
+/*
+ * An i/f to runtime opt-in for irq time accounting based off of sched_clock.
+ * The reason for this explicit opt-in is not to have perf penalty with
+ * slow sched_clocks.
+ */
+extern void enable_sched_clock_irqtime(void);
+extern void disable_sched_clock_irqtime(void);
+#else
+static inline void enable_sched_clock_irqtime(void) {}
+static inline void disable_sched_clock_irqtime(void) {}
+#endif
+
 extern unsigned long long
 task_sched_runtime(struct task_struct *task);
 extern unsigned long long thread_group_sched_runtime(struct task_struct *task);
diff --git a/kernel/sched.c b/kernel/sched.c
index fc18409..fe70827 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -1807,6 +1807,55 @@ static inline void __set_task_cpu(struct task_struct *p, unsigned int cpu)
 #endif
 }
 
+#ifdef CONFIG_IRQ_TIME_ACCOUNTING
+
+static DEFINE_PER_CPU(u64, cpu_hardirq_time);
+static DEFINE_PER_CPU(u64, cpu_softirq_time);
+
+static DEFINE_PER_CPU(u64, irq_start_time);
+static int sched_clock_irqtime;
+
+void enable_sched_clock_irqtime(void)
+{
+	sched_clock_irqtime = 1;
+}
+
+void disable_sched_clock_irqtime(void)
+{
+	sched_clock_irqtime = 0;
+}
+
+void account_system_vtime(struct task_struct *curr)
+{
+	unsigned long flags;
+	int cpu;
+	u64 now, delta;
+
+	if (!sched_clock_irqtime)
+		return;
+
+	local_irq_save(flags);
+
+	now = sched_clock();
+	cpu = smp_processor_id();
+	delta = now - per_cpu(irq_start_time, cpu);
+	per_cpu(irq_start_time, cpu) = now;
+	/*
+	 * We do not account for softirq time from ksoftirqd here.
+	 * We want to continue accounting softirq time to ksoftirqd thread
+	 * in that case, so as not to confuse scheduler with a special task
+	 * that do not consume any time, but still wants to run.
+	 */
+	if (hardirq_count())
+		per_cpu(cpu_hardirq_time, cpu) += delta;
+	else if (in_serving_softirq() && !(curr->flags & PF_KSOFTIRQD))
+		per_cpu(cpu_softirq_time, cpu) += delta;
+
+	local_irq_restore(flags);
+}
+
+#endif
+
 #include "sched_stats.h"
 #include "sched_idletask.c"
 #include "sched_fair.c"
-- 
1.7.4


