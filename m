Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757976Ab0LTP11 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 10:27:27 -0500
Received: from mail-fx0-f43.google.com ([209.85.161.43]:42508 "EHLO
	mail-fx0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757833Ab0LTPYl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 10:24:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=m8UjUR0i7noCiMbtXjOMFsSbeYPvkpRz6i7y6WHoik96QpiiEScxD6MwvVSINaFu0Y
         uo4E0KqWHo5BjlVA+3GNetiaFOMnaof3X/uOamJxDiZjTjlSUeDqvrPdX7h4VVSCxasy
         CyPQD0YYvrG6fY+T/WzRM3b8FrKR85bNrrirA=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Anton Blanchard <anton@au1.ibm.com>,
        Tim Pepper <lnxninja@linux.vnet.ibm.com>
Subject: [RFC PATCH 04/15] nohz_task: Stop the tick when the nohz task runs alone
Date: Mon, 20 Dec 2010 16:24:11 +0100
Message-Id: <1292858662-5650-5-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <1292858662-5650-1-git-send-email-fweisbec@gmail.com>
References: <1292858662-5650-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Check from the timer interrupt that we are a nohz task running
alone in the CPU and stop the tick if this is the case.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Anton Blanchard <anton@au1.ibm.com>
Cc: Tim Pepper <lnxninja@linux.vnet.ibm.com>
---
 include/linux/sched.h    |    6 ++++++
 include/linux/tick.h     |   11 ++++++++++-
 kernel/sched.c           |   14 ++++++++++++++
 kernel/softirq.c         |    4 ++--
 kernel/time/tick-sched.c |   30 ++++++++++++++++++++++++++++--
 5 files changed, 60 insertions(+), 5 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 2c79e92..858a876 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -2549,6 +2549,12 @@ static inline void inc_syscw(struct task_struct *tsk)
 extern void task_oncpu_function_call(struct task_struct *p,
 				     void (*func) (void *info), void *info);
 
+#ifdef CONFIG_NO_HZ_TASK
+extern int nohz_task_can_stop_tick(void);
+#else
+static inline int nohz_task_can_stop_tick(void) { return 0; }
+#endif
+
 
 #ifdef CONFIG_MM_OWNER
 extern void mm_update_next_owner(struct mm_struct *mm);
diff --git a/include/linux/tick.h b/include/linux/tick.h
index b232ccc..7465a47 100644
--- a/include/linux/tick.h
+++ b/include/linux/tick.h
@@ -7,6 +7,7 @@
 #define _LINUX_TICK_H
 
 #include <linux/clockchips.h>
+#include <linux/percpu-defs.h>
 
 #ifdef CONFIG_GENERIC_CLOCKEVENTS
 
@@ -126,7 +127,15 @@ extern void tick_nohz_restart_sched_tick(void);
 extern ktime_t tick_nohz_get_sleep_length(void);
 extern u64 get_cpu_idle_time_us(int cpu, u64 *last_update_time);
 extern u64 get_cpu_iowait_time_us(int cpu, u64 *last_update_time);
-# else
+
+#ifdef CONFIG_NO_HZ_TASK
+DECLARE_PER_CPU(int, task_nohz_mode);
+extern int tick_nohz_task_mode(void);
+#else
+static inline int tick_nohz_task_mode(void) { return 0; }
+#endif
+
+# else /* !NO_HZ */
 static inline void tick_nohz_stop_sched_tick(int inidle) { }
 static inline void tick_nohz_restart_sched_tick(void) { }
 static inline ktime_t tick_nohz_get_sleep_length(void)
diff --git a/kernel/sched.c b/kernel/sched.c
index 2cd6823..e9cdd7a 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -2443,6 +2443,20 @@ static void update_avg(u64 *avg, u64 sample)
 }
 #endif
 
+#ifdef CONFIG_NO_HZ_TASK
+DEFINE_PER_CPU(int, task_nohz_mode);
+
+int nohz_task_can_stop_tick(void)
+{
+	struct rq *rq = this_rq();
+
+	if (rq->nr_running > 1)
+		return 0;
+
+	return 1;
+}
+#endif
+
 static inline void ttwu_activate(struct task_struct *p, struct rq *rq,
 				 bool is_sync, bool is_migrate, bool is_local,
 				 unsigned long en_flags)
diff --git a/kernel/softirq.c b/kernel/softirq.c
index 18f4be0..e24c456a 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -297,7 +297,7 @@ void irq_enter(void)
 	int cpu = smp_processor_id();
 
 	rcu_irq_enter();
-	if (idle_cpu(cpu) && !in_interrupt()) {
+	if ((idle_cpu(cpu) || tick_nohz_task_mode()) && !in_interrupt()) {
 		/*
 		 * Prevent raise_softirq from needlessly waking up ksoftirqd
 		 * here, as softirq will be serviced on return from interrupt.
@@ -330,7 +330,7 @@ void irq_exit(void)
 	rcu_irq_exit();
 #ifdef CONFIG_NO_HZ
 	/* Make sure that timer wheel updates are propagated */
-	if (idle_cpu(smp_processor_id()) && !in_interrupt() && !need_resched())
+	if ((idle_cpu(smp_processor_id()) || tick_nohz_task_mode()) && !in_interrupt() && !need_resched())
 		tick_nohz_stop_sched_tick(0);
 #endif
 	preempt_enable_no_resched();
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index e706fa8..88011b9 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -274,7 +274,7 @@ void tick_nohz_stop_sched_tick(int inidle)
 	 * updated. Thus, it must not be called in the event we are called from
 	 * irq_exit() with the prior state different than idle.
 	 */
-	if (!inidle && !ts->inidle)
+	if (!inidle && !ts->inidle && !tick_nohz_task_mode())
 		goto end;
 
 	/*
@@ -510,6 +510,11 @@ void tick_nohz_restart_sched_tick(void)
 
 	local_irq_save(flags);
 
+	if (tick_nohz_task_mode()) {
+		local_irq_restore(flags);
+		return;
+	}
+
 	if (ts->idle_active || (ts->inidle && ts->tick_stopped))
 		now = ktime_get();
 
@@ -714,10 +719,29 @@ void tick_check_idle(int cpu)
 	tick_check_nohz(cpu);
 }
 
+#ifdef CONFIG_NO_HZ_TASK
+int tick_nohz_task_mode(void)
+{
+	return __get_cpu_var(task_nohz_mode);
+}
+
+static void tick_nohz_task_stop_tick(void)
+{
+	if (!test_thread_flag(TIF_NOHZ) || __get_cpu_var(task_nohz_mode))
+		return;
+
+	if (nohz_task_can_stop_tick())
+		__get_cpu_var(task_nohz_mode) = 1;
+}
+#else
+static void tick_nohz_task_stop_tick(void) { }
+#endif /* CONFIG_NO_HZ_TASK */
+
 /*
  * High resolution timer specific code
  */
 #ifdef CONFIG_HIGH_RES_TIMERS
+
 /*
  * We rearm the timer until we get disabled by the idle code.
  * Called with interrupts disabled and timer->base->cpu_base->lock held.
@@ -738,7 +762,7 @@ static enum hrtimer_restart tick_sched_timer(struct hrtimer *timer)
 	 * this duty, then the jiffies update is still serialized by
 	 * xtime_lock.
 	 */
-	if (unlikely(tick_do_timer_cpu == TICK_DO_TIMER_NONE))
+	if (unlikely(tick_do_timer_cpu == TICK_DO_TIMER_NONE) && !test_thread_flag(TIF_NOHZ))
 		tick_do_timer_cpu = cpu;
 #endif
 
@@ -767,6 +791,8 @@ static enum hrtimer_restart tick_sched_timer(struct hrtimer *timer)
 		profile_tick(CPU_PROFILING);
 	}
 
+	tick_nohz_task_stop_tick();
+
 	hrtimer_forward(timer, now, tick_period);
 
 	return HRTIMER_RESTART;
-- 
1.7.3.2

