Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755451Ab0I2TWI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 15:22:08 -0400
Received: from smtp-out.google.com ([216.239.44.51]:51304 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755389Ab0I2TWC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 15:22:02 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:
	references:x-system-of-record;
	b=PPNqKeG7kJ1Yka5WQqcP1na7LKbfgqBrtt0AlRpQMVmz+UiNXXe5z1eqk4G+gZlZ8
	vOs8dDBv97912ECg980Yg==
From: Venkatesh Pallipadi <venki@google.com>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: linux-kernel@vger.kernel.org, Paul Turner <pjt@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Venkatesh Pallipadi <venki@google.com>
Subject: [PATCH 3/7] Add IRQ_TIME_ACCOUNTING, finer accounting of irq time -v3
Date: Wed, 29 Sep 2010 12:21:32 -0700
Message-Id: <1285788096-29471-4-git-send-email-venki@google.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1285788096-29471-1-git-send-email-venki@google.com>
References: <1285788096-29471-1-git-send-email-venki@google.com>
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

Note that the kstat_cpu irq times (and hence /proc/stat) are still based on
tick based samples. The reason being that the kstat irq also includes
system time and changing only irq times there to have finer granularity can
result in inconsistency like sum kstat time adding up to more than 100% etc.

This patch just adds the core logic and does not enable this logic yet.

Signed-off-by: Venkatesh Pallipadi <venki@google.com>
---
 include/linux/hardirq.h |    2 +-
 include/linux/sched.h   |   11 +++++++++++
 kernel/sched.c          |   38 ++++++++++++++++++++++++++++++++++++++
 3 files changed, 50 insertions(+), 1 deletions(-)

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
index 126457e..8adf166 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1826,6 +1826,17 @@ extern void sched_clock_idle_sleep_event(void);
 extern void sched_clock_idle_wakeup_event(u64 delta_ns);
 #endif
 
+#ifdef CONFIG_IRQ_TIME_ACCOUNTING
+/*
+ * An i/f to runtime opt-in for irq time accounting based off of sched_clock.
+ * The reason for this explicit opt-in is not to have perf penalty with
+ * slow sched_clocks.
+ */
+extern void enable_sched_clock_irqtime(void);
+#else
+static inline void enable_sched_clock_irqtime(void) {}
+#endif
+
 extern unsigned long long
 task_sched_runtime(struct task_struct *task);
 extern unsigned long long thread_group_sched_runtime(struct task_struct *task);
diff --git a/kernel/sched.c b/kernel/sched.c
index b6e714b..bc2581e 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -1917,6 +1917,44 @@ static void deactivate_task(struct rq *rq, struct task_struct *p, int flags)
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
+	if (hardirq_count())
+		per_cpu(cpu_hardirq_time, cpu) += delta;
+	else if (in_serving_softirq())
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
-- 
1.7.1

