Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755102Ab1HOPyJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 11:54:09 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:51689 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755078Ab1HOPyF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 11:54:05 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Anton Blanchard <anton@au1.ibm.com>, Avi Kivity <avi@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, Lai Jiangshan <laijs@cn.fujitsu.com>,
        "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Menage <menage@google.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tim Pepper <lnxninja@linux.vnet.ibm.com>
Subject: [PATCH 25/32] nohz/cpuset: New API to flush cputimes on nohz cpusets
Date: Mon, 15 Aug 2011 17:52:22 +0200
Message-Id: <1313423549-27093-26-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1313423549-27093-1-git-send-email-fweisbec@gmail.com>
References: <1313423549-27093-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Provide a new API that sends an IPI to every CPUs included
in nohz cpusets in order to flush their cputimes. It's going
to be useful for those that want to see accurate cputimes
on a nohz cpuset.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Anton Blanchard <anton@au1.ibm.com>
Cc: Avi Kivity <avi@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Paul E . McKenney <paulmck@linux.vnet.ibm.com>
Cc: Paul Menage <menage@google.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephen Hemminger <shemminger@vyatta.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Tim Pepper <lnxninja@linux.vnet.ibm.com>
---
 include/linux/cpuset.h   |    2 ++
 include/linux/tick.h     |    2 +-
 kernel/cpuset.c          |   34 +++++++++++++++++++++++++++++++++-
 kernel/sched.c           |    2 +-
 kernel/time/tick-sched.c |    4 ++--
 5 files changed, 39 insertions(+), 5 deletions(-)

diff --git a/include/linux/cpuset.h b/include/linux/cpuset.h
index 7f9d78d..569da83 100644
--- a/include/linux/cpuset.h
+++ b/include/linux/cpuset.h
@@ -265,9 +265,11 @@ static inline bool cpuset_adaptive_nohz(void)
 }
 
 extern void cpuset_update_nohz(void);
+extern void cpuset_nohz_flush_cputimes(void);
 extern void cpuset_exit_nohz_interrupt(void *unused);
 #else
 static inline void cpuset_update_nohz(void) { }
+static inline void cpuset_nohz_flush_cputimes(void) { }
 
 #endif /* CONFIG_CPUSETS_NO_HZ */
 
diff --git a/include/linux/tick.h b/include/linux/tick.h
index 3ad649f..9d0270e 100644
--- a/include/linux/tick.h
+++ b/include/linux/tick.h
@@ -145,7 +145,7 @@ extern void tick_nohz_enter_exception(struct pt_regs *regs);
 extern void tick_nohz_exit_exception(struct pt_regs *regs);
 extern int tick_nohz_adaptive_mode(void);
 extern bool tick_nohz_account_tick(void);
-extern void tick_nohz_flush_current_times(void);
+extern void tick_nohz_flush_current_times(bool restart_tick);
 #else /* !CPUSETS_NO_HZ */
 static inline void tick_nohz_enter_kernel(void) { }
 static inline void tick_nohz_exit_kernel(void) { }
diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index ee3b0d0..61c3f96 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -59,6 +59,7 @@
 #include <linux/mutex.h>
 #include <linux/workqueue.h>
 #include <linux/cgroup.h>
+#include <linux/tick.h>
 
 /*
  * Workqueue for cpuset related tasks.
@@ -1199,6 +1200,23 @@ static void cpuset_change_flag(struct task_struct *tsk,
 
 DEFINE_PER_CPU(int, cpu_adaptive_nohz_ref);
 
+static cpumask_t nohz_cpuset_mask;
+
+static void flush_cputime_interrupt(void *unused)
+{
+	tick_nohz_flush_current_times(false);
+}
+
+void cpuset_nohz_flush_cputimes(void)
+{
+	preempt_disable();
+	smp_call_function_many(&nohz_cpuset_mask, flush_cputime_interrupt,
+			       NULL, true);
+	preempt_enable();
+	/* Make the utime/stime updates visible */
+	smp_mb();
+}
+
 static void cpu_exit_nohz(int cpu)
 {
 	preempt_disable();
@@ -1223,7 +1241,15 @@ static void update_nohz_cpus(struct cpuset *old_cs, struct cpuset *cs)
 
 		val = per_cpu(cpu_adaptive_nohz_ref, cpu);
 
-		if (!val) {
+		if (val == 1) {
+			cpumask_set_cpu(cpu, &nohz_cpuset_mask);
+			/*
+			 * The mask update needs to be visible right away
+			 * so that this CPU is part of the cputime IPI
+			 * update right now.
+			 */
+			 smp_mb();
+		} else if (!val) {
 			/*
 			 * The update to cpu_adaptive_nohz_ref must be
 			 * visible right away. So that once we restart the tick
@@ -1232,6 +1258,12 @@ static void update_nohz_cpus(struct cpuset *old_cs, struct cpuset *cs)
 			 */
 			smp_mb();
 			cpu_exit_nohz(cpu);
+			/*
+			 * Now that the tick has been restarted and cputimes
+			 * flushed, we don't need anymore to be part of the
+			 * cputime flush IPI.
+			 */
+			cpumask_clear_cpu(cpu, &nohz_cpuset_mask);
 		}
 	}
 }
diff --git a/kernel/sched.c b/kernel/sched.c
index c49c1b1..2bcd456 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -2500,7 +2500,7 @@ bool cpuset_nohz_can_stop_tick(void)
 
 static void cpuset_nohz_restart_tick(void)
 {
-	tick_nohz_flush_current_times();
+	tick_nohz_flush_current_times(true);
 	__get_cpu_var(task_nohz_mode) = 0;
 	tick_nohz_restart_sched_tick();
 	clear_thread_flag(TIF_NOHZ);
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index d8f01b8..9a2ba5b 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -908,13 +908,13 @@ bool tick_nohz_account_tick(void)
 	return true;
 }
 
-void tick_nohz_flush_current_times(void)
+void tick_nohz_flush_current_times(bool restart_tick)
 {
 	struct tick_sched *ts = &__get_cpu_var(tick_cpu_sched);
 	unsigned long delta_jiffies;
 	struct pt_regs *regs;
 
-	if (tick_nohz_account_tick())
+	if (tick_nohz_account_tick() && restart_tick)
 		ts->saved_jiffies_whence = JIFFIES_SAVED_NONE;
 }
 #else
-- 
1.7.5.4

