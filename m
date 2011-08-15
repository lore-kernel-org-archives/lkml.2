Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753299Ab1HOP55 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 11:57:57 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:58289 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754829Ab1HOPxX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 11:53:23 -0400
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
Subject: [PATCH 13/32] nohz: Adaptive tick stop and restart on nohz cpuset
Date: Mon, 15 Aug 2011 17:52:10 +0200
Message-Id: <1313423549-27093-14-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1313423549-27093-1-git-send-email-fweisbec@gmail.com>
References: <1313423549-27093-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When a CPU is included in a nohz cpuset, try to switch
it to nohz mode from the timer interrupt if it is the
only non-idle task running.

Then restart the tick if necessary from the wakeup path
if we are enqueuing a second task while the timer is stopped,
so that the scheduler tick is rearmed.

This assumes we are using TTWU_QUEUE sched feature so I need
to handle the off case (or actually not handle it but properly),
because we need the adaptive tick restart and what will come
along in further patches to be done locally and before the new
task ever gets scheduled.

I also need to look at the ARCH_WANT_INTERRUPTS_ON_CTXW case
and the remote wakeups.

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
 include/linux/cpuset.h   |    4 +++
 include/linux/sched.h    |    6 ++++
 include/linux/tick.h     |   12 ++++++++-
 init/Kconfig             |    2 +-
 kernel/sched.c           |   35 +++++++++++++++++++++++++
 kernel/softirq.c         |    4 +-
 kernel/time/tick-sched.c |   63 ++++++++++++++++++++++++++++++++++++++-------
 7 files changed, 112 insertions(+), 14 deletions(-)

diff --git a/include/linux/cpuset.h b/include/linux/cpuset.h
index 62e5d5a..799b9a4 100644
--- a/include/linux/cpuset.h
+++ b/include/linux/cpuset.h
@@ -264,6 +264,10 @@ static inline bool cpuset_adaptive_nohz(void)
 	return false;
 }
 
+extern void cpuset_update_nohz(void);
+#else
+static inline void cpuset_update_nohz(void) { }
+
 #endif /* CONFIG_CPUSETS_NO_HZ */
 
 #endif /* _LINUX_CPUSET_H */
diff --git a/include/linux/sched.h b/include/linux/sched.h
index dbe021a..53a95b5 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -2652,6 +2652,12 @@ static inline void inc_syscw(struct task_struct *tsk)
 #define TASK_SIZE_OF(tsk)	TASK_SIZE
 #endif
 
+#ifdef CONFIG_CPUSETS_NO_HZ
+extern bool cpuset_nohz_can_stop_tick(void);
+#else
+static inline bool cpuset_nohz_can_stop_tick(void) { return false; }
+#endif
+
 #ifdef CONFIG_MM_OWNER
 extern void mm_update_next_owner(struct mm_struct *mm);
 extern void mm_init_owner(struct mm_struct *mm, struct task_struct *p);
diff --git a/include/linux/tick.h b/include/linux/tick.h
index 849a0b2..cc4880e 100644
--- a/include/linux/tick.h
+++ b/include/linux/tick.h
@@ -122,11 +122,21 @@ static inline int tick_oneshot_mode_active(void) { return 0; }
 # ifdef CONFIG_NO_HZ
 extern void tick_nohz_enter_idle(void);
 extern void tick_nohz_exit_idle(void);
+extern void tick_nohz_restart_sched_tick(void);
 extern void tick_nohz_irq_exit(void);
 extern ktime_t tick_nohz_get_sleep_length(void);
 extern u64 get_cpu_idle_time_us(int cpu, u64 *last_update_time);
 extern u64 get_cpu_iowait_time_us(int cpu, u64 *last_update_time);
-# else
+
+#ifdef CONFIG_CPUSETS_NO_HZ
+DECLARE_PER_CPU(int, task_nohz_mode);
+
+extern int tick_nohz_adaptive_mode(void);
+#else /* !CPUSETS_NO_HZ */
+static inline int tick_nohz_adaptive_mode(void) { return 0; }
+#endif /* CPUSETS_NO_HZ */
+
+# else /* !NO_HZ */
 static inline void tick_nohz_enter_idle(void) { }
 static inline void tick_nohz_exit_idle(void) { }
 
diff --git a/init/Kconfig b/init/Kconfig
index 0cb591a..7a144ad 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -626,7 +626,7 @@ config PROC_PID_CPUSET
 
 config CPUSETS_NO_HZ
        bool "Tickless cpusets"
-       depends on CPUSETS && HAVE_CPUSETS_NO_HZ
+       depends on CPUSETS && HAVE_CPUSETS_NO_HZ && NO_HZ && HIGH_RES_TIMERS
        help
          This options let you apply a nohz property to a cpuset such
 	 that the periodic timer tick tries to be avoided when possible on
diff --git a/kernel/sched.c b/kernel/sched.c
index 609a867..0e1aa4e 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -2433,6 +2433,38 @@ static void update_avg(u64 *avg, u64 sample)
 }
 #endif
 
+#ifdef CONFIG_CPUSETS_NO_HZ
+DEFINE_PER_CPU(int, task_nohz_mode);
+
+bool cpuset_nohz_can_stop_tick(void)
+{
+	struct rq *rq;
+
+	rq = this_rq();
+
+	/* More than one running task need preemption */
+	if (rq->nr_running > 1)
+		return false;
+
+	return true;
+}
+
+static void cpuset_nohz_restart_tick(void)
+{
+	__get_cpu_var(task_nohz_mode) = 0;
+	tick_nohz_restart_sched_tick();
+}
+
+void cpuset_update_nohz(void)
+{
+	if (!tick_nohz_adaptive_mode())
+		return;
+
+	if (!cpuset_nohz_can_stop_tick())
+		cpuset_nohz_restart_tick();
+}
+#endif
+
 static void
 ttwu_stat(struct task_struct *p, int cpu, int wake_flags)
 {
@@ -2560,6 +2592,8 @@ static void sched_ttwu_pending(void)
 		ttwu_do_activate(rq, p, 0);
 	}
 
+	cpuset_update_nohz();
+
 	raw_spin_unlock(&rq->lock);
 }
 
@@ -2620,6 +2654,7 @@ static void ttwu_queue(struct task_struct *p, int cpu)
 
 	raw_spin_lock(&rq->lock);
 	ttwu_do_activate(rq, p, 0);
+	cpuset_update_nohz();
 	raw_spin_unlock(&rq->lock);
 }
 
diff --git a/kernel/softirq.c b/kernel/softirq.c
index 67a1401..2dbeeb9 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -297,7 +297,7 @@ void irq_enter(void)
 	int cpu = smp_processor_id();
 
 	rcu_irq_enter();
-	if (idle_cpu(cpu) && !in_interrupt()) {
+	if ((idle_cpu(cpu) || tick_nohz_adaptive_mode()) && !in_interrupt()) {
 		/*
 		 * Prevent raise_softirq from needlessly waking up ksoftirqd
 		 * here, as softirq will be serviced on return from interrupt.
@@ -342,7 +342,7 @@ void irq_exit(void)
 	rcu_irq_exit();
 #ifdef CONFIG_NO_HZ
 	/* Make sure that timer wheel updates are propagated */
-	if (idle_cpu(smp_processor_id()) && !in_interrupt() && !need_resched())
+	if (!in_interrupt())
 		tick_nohz_irq_exit();
 #endif
 	preempt_enable_no_resched();
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index 5f41ef7..fb97cd0 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -499,12 +499,7 @@ static void tick_nohz_restart(struct tick_sched *ts, ktime_t now)
 	}
 }
 
-/**
- * tick_nohz_restart_sched_tick - restart the idle tick from the idle task
- *
- * Restart the idle tick when the CPU is woken up from idle
- */
-static void tick_nohz_restart_sched_tick(ktime_t now, struct tick_sched *ts)
+static void __tick_nohz_restart_sched_tick(ktime_t now, struct tick_sched *ts)
 {
 	int cpu = smp_processor_id();
 
@@ -522,6 +517,31 @@ static void tick_nohz_restart_sched_tick(ktime_t now, struct tick_sched *ts)
 	tick_nohz_restart(ts, now);
 }
 
+/**
+ * tick_nohz_restart_sched_tick - restart the idle tick from the idle task
+ *
+ * Restart the idle tick when the CPU is woken up from idle
+ */
+void tick_nohz_restart_sched_tick(void)
+{
+	struct tick_sched *ts = &__get_cpu_var(tick_cpu_sched);
+	unsigned long flags;
+	ktime_t now;
+
+	local_irq_save(flags);
+
+	if (!ts->tick_stopped) {
+		local_irq_restore(flags);
+		return;
+	}
+
+	now = ktime_get();
+	__tick_nohz_restart_sched_tick(now, ts);
+
+	local_irq_restore(flags);
+}
+
+
 static void tick_nohz_account_idle_ticks(struct tick_sched *ts)
 {
 #ifndef CONFIG_VIRT_CPU_ACCOUNTING
@@ -560,7 +580,7 @@ void tick_nohz_exit_idle(void)
 	if (ts->tick_stopped) {
 		rcu_exit_nohz();
 		select_nohz_load_balancer(0);
-		tick_nohz_restart_sched_tick(now, ts);
+		__tick_nohz_restart_sched_tick(now, ts);
 		tick_nohz_account_idle_ticks(ts);
 	}
 
@@ -570,9 +590,14 @@ void tick_nohz_exit_idle(void)
 void tick_nohz_irq_exit(void)
 {
 	struct tick_sched *ts = &__get_cpu_var(tick_cpu_sched);
+	int cpu = smp_processor_id();
 
-	if (ts->inidle)
-		__tick_nohz_enter_idle(ts, smp_processor_id());
+	if (ts->inidle && !need_resched())
+		__tick_nohz_enter_idle(ts, cpu);
+	else if (tick_nohz_adaptive_mode() && !idle_cpu(cpu)) {
+		if (tick_nohz_can_stop_tick(cpu, ts))
+			tick_nohz_stop_sched_tick(ktime_get(), cpu, ts);
+	}
 }
 
 static int tick_nohz_reprogram(struct tick_sched *ts, ktime_t now)
@@ -732,6 +757,20 @@ void tick_check_idle(int cpu)
 
 #ifdef CONFIG_CPUSETS_NO_HZ
 
+int tick_nohz_adaptive_mode(void)
+{
+	return __get_cpu_var(task_nohz_mode);
+}
+
+static void tick_nohz_cpuset_stop_tick(int user)
+{
+	if (!cpuset_adaptive_nohz() || tick_nohz_adaptive_mode())
+		return;
+
+	if (cpuset_nohz_can_stop_tick())
+		__get_cpu_var(task_nohz_mode) = 1;
+}
+
 /*
  * Take the timer duty if nobody is taking care of it.
  * If a CPU already does and and it's in a nohz cpuset,
@@ -752,6 +791,8 @@ static void tick_do_timer_check_handler(int cpu)
 
 #else
 
+static void tick_nohz_cpuset_stop_tick(int user) { }
+
 static void tick_do_timer_check_handler(int cpu)
 {
 #ifdef CONFIG_NO_HZ
@@ -796,6 +837,7 @@ static enum hrtimer_restart tick_sched_timer(struct hrtimer *timer)
 	 * no valid regs pointer
 	 */
 	if (regs) {
+		int user = user_mode(regs);
 		/*
 		 * When we are idle and the tick is stopped, we have to touch
 		 * the watchdog as we might not schedule for a really long
@@ -809,8 +851,9 @@ static enum hrtimer_restart tick_sched_timer(struct hrtimer *timer)
 			if (idle_cpu(cpu))
 				ts->idle_jiffies++;
 		}
-		update_process_times(user_mode(regs));
+		update_process_times(user);
 		profile_tick(CPU_PROFILING);
+		tick_nohz_cpuset_stop_tick(user);
 	}
 
 	hrtimer_forward(timer, now, tick_period);
-- 
1.7.5.4

