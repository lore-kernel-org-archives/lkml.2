Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757688Ab0JRT0Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 15:26:16 -0400
Received: from hera.kernel.org ([140.211.167.34]:58803 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756493Ab0JRT0N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 15:26:13 -0400
Date: Mon, 18 Oct 2010 19:25:41 GMT
From: tip-bot for Venkatesh Pallipadi <venki@google.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu,
        venki@google.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, venki@google.com,
        mingo@elte.hu
In-Reply-To: <1286237003-12406-5-git-send-email-venki@google.com>
References: <1286237003-12406-5-git-send-email-venki@google.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Add IRQ_TIME_ACCOUNTING, finer accounting of irq time
Message-ID: <tip-b52bfee445d315549d41eacf2fa7c156e7d153d5@git.kernel.org>
Git-Commit-ID: b52bfee445d315549d41eacf2fa7c156e7d153d5
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 18 Oct 2010 19:25:42 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b52bfee445d315549d41eacf2fa7c156e7d153d5
Gitweb:     http://git.kernel.org/tip/b52bfee445d315549d41eacf2fa7c156e7d153d5
Author:     Venkatesh Pallipadi <venki@google.com>
AuthorDate: Mon, 4 Oct 2010 17:03:19 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 18 Oct 2010 20:52:24 +0200

sched: Add IRQ_TIME_ACCOUNTING, finer accounting of irq time

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
---
 include/linux/hardirq.h |    2 +-
 include/linux/sched.h   |   13 ++++++++++++
 kernel/sched.c          |   49 +++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 63 insertions(+), 1 deletions(-)

diff --git a/include/linux/hardirq.h b/include/linux/hardirq.h
index 41367c5..ff43e92 100644
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
index aca0ce6..2cca9a9 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1826,6 +1826,19 @@ extern void sched_clock_idle_sleep_event(void);
 extern void sched_clock_idle_wakeup_event(u64 delta_ns);
 #endif
 
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
index 089be8a..9b302e3 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -1908,6 +1908,55 @@ static void deactivate_task(struct rq *rq, struct task_struct *p, int flags)
 	dec_nr_running(rq);
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
 #include "sched_idletask.c"
 #include "sched_fair.c"
 #include "sched_rt.c"
