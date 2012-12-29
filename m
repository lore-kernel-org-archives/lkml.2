Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753576Ab2L2Qpy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Dec 2012 11:45:54 -0500
Received: from mail-wg0-f48.google.com ([74.125.82.48]:41225 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753410Ab2L2QoD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Dec 2012 11:44:03 -0500
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Alessio Igor Bogani <abogani@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Chris Metcalf <cmetcalf@tilera.com>, Christoph Lameter <cl@linux.com>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 20/27] nohz: Full dynticks mode
Date: Sat, 29 Dec 2012 17:42:59 +0100
Message-Id: <1356799386-4212-21-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1356799386-4212-1-git-send-email-fweisbec@gmail.com>
References: <1356799386-4212-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When a CPU is in full dynticks mode, try to switch
it to nohz mode from the interrupt exit path if it is
running a single non-idle task.

Then restart the tick if necessary if we are enqueuing a
second task while the timer is stopped, so that the scheduler
tick is rearmed.

[TODO: Check remaining things to be done from scheduler_tick()]

[ Included build fix from Geoff Levand ]

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Alessio Igor Bogani <abogani@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Chris Metcalf <cmetcalf@tilera.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Geoff Levand <geoff@infradead.org>
Cc: Gilad Ben Yossef <gilad@benyossef.com>
Cc: Hakan Akkan <hakanakkan@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/sched.h    |    6 +++++
 include/linux/tick.h     |    2 +
 kernel/sched/core.c      |   22 ++++++++++++++++++++-
 kernel/sched/sched.h     |   10 +++++++++
 kernel/softirq.c         |    5 ++-
 kernel/time/tick-sched.c |   47 ++++++++++++++++++++++++++++++++++++++++-----
 6 files changed, 83 insertions(+), 9 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 32860ae..132897d 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -2846,6 +2846,12 @@ static inline void inc_syscw(struct task_struct *tsk)
 #define TASK_SIZE_OF(tsk)	TASK_SIZE
 #endif
 
+#ifdef CONFIG_NO_HZ_FULL
+extern bool sched_can_stop_tick(void);
+#else
+static inline bool sched_can_stop_tick(void) { return false; }
+#endif
+
 #ifdef CONFIG_MM_OWNER
 extern void mm_update_next_owner(struct mm_struct *mm);
 extern void mm_init_owner(struct mm_struct *mm, struct task_struct *p);
diff --git a/include/linux/tick.h b/include/linux/tick.h
index 2d4f6f0..dfb90ea 100644
--- a/include/linux/tick.h
+++ b/include/linux/tick.h
@@ -159,8 +159,10 @@ static inline u64 get_cpu_iowait_time_us(int cpu, u64 *unused) { return -1; }
 
 #ifdef CONFIG_NO_HZ_FULL
 int tick_nohz_full_cpu(int cpu);
+extern void tick_nohz_full_check(void);
 #else
 static inline int tick_nohz_full_cpu(int cpu) { return 0; }
+static inline void tick_nohz_full_check(void) { }
 #endif
 
 
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 3c1a806..7b6156a 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -1238,6 +1238,24 @@ static void update_avg(u64 *avg, u64 sample)
 }
 #endif
 
+#ifdef CONFIG_NO_HZ_FULL
+bool sched_can_stop_tick(void)
+{
+	struct rq *rq;
+
+	rq = this_rq();
+
+	/* Make sure rq->nr_running update is visible after the IPI */
+	smp_rmb();
+
+	/* More than one running task need preemption */
+	if (rq->nr_running > 1)
+		return false;
+
+	return true;
+}
+#endif
+
 static void
 ttwu_stat(struct task_struct *p, int cpu, int wake_flags)
 {
@@ -1380,7 +1398,8 @@ static void sched_ttwu_pending(void)
 
 void scheduler_ipi(void)
 {
-	if (llist_empty(&this_rq()->wake_list) && !got_nohz_idle_kick())
+	if (llist_empty(&this_rq()->wake_list) && !got_nohz_idle_kick()
+	    && !tick_nohz_full_cpu(smp_processor_id()))
 		return;
 
 	/*
@@ -1397,6 +1416,7 @@ void scheduler_ipi(void)
 	 * somewhat pessimize the simple resched case.
 	 */
 	irq_enter();
+	tick_nohz_full_check();
 	sched_ttwu_pending();
 
 	/*
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index f24d91e..63915fe 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -955,6 +955,16 @@ static inline u64 steal_ticks(u64 steal)
 static inline void inc_nr_running(struct rq *rq)
 {
 	rq->nr_running++;
+
+#ifdef CONFIG_NO_HZ_FULL
+	if (rq->nr_running == 2) {
+		if (tick_nohz_full_cpu(rq->cpu)) {
+			/* Order rq->nr_running write against the IPI */
+			smp_wmb();
+			smp_send_reschedule(rq->cpu);
+		}
+	}
+#endif
 }
 
 static inline void dec_nr_running(struct rq *rq)
diff --git a/kernel/softirq.c b/kernel/softirq.c
index f5cc25f..6342078 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -307,7 +307,8 @@ void irq_enter(void)
 	int cpu = smp_processor_id();
 
 	rcu_irq_enter();
-	if (is_idle_task(current) && !in_interrupt()) {
+
+	if ((is_idle_task(current) || tick_nohz_full_cpu(cpu)) && !in_interrupt()) {
 		/*
 		 * Prevent raise_softirq from needlessly waking up ksoftirqd
 		 * here, as softirq will be serviced on return from interrupt.
@@ -349,7 +350,7 @@ void irq_exit(void)
 
 #ifdef CONFIG_NO_HZ
 	/* Make sure that timer wheel updates are propagated */
-	if (idle_cpu(smp_processor_id()) && !in_interrupt() && !need_resched())
+	if (!in_interrupt())
 		tick_nohz_irq_exit();
 #endif
 	rcu_irq_exit();
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index 164db94..9d31b08 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -587,6 +587,24 @@ void tick_nohz_idle_enter(void)
 	local_irq_enable();
 }
 
+static void tick_nohz_full_stop_tick(struct tick_sched *ts)
+{
+#ifdef CONFIG_NO_HZ_FULL
+	int cpu = smp_processor_id();
+
+	if (!tick_nohz_full_cpu(cpu) || is_idle_task(current))
+		return;
+
+	if (!ts->tick_stopped && ts->nohz_mode == NOHZ_MODE_INACTIVE)
+		return;
+
+	if (!sched_can_stop_tick())
+		return;
+
+	tick_nohz_stop_sched_tick(ts, ktime_get(), cpu);
+#endif
+}
+
 /**
  * tick_nohz_irq_exit - update next tick event from interrupt exit
  *
@@ -599,12 +617,15 @@ void tick_nohz_irq_exit(void)
 {
 	struct tick_sched *ts = &__get_cpu_var(tick_cpu_sched);
 
-	if (!ts->inidle)
-		return;
-
-	/* Cancel the timer because CPU already waken up from the C-states*/
-	menu_hrtimer_cancel();
-	__tick_nohz_idle_enter(ts);
+	if (ts->inidle) {
+		if (!need_resched()) {
+			/* Cancel the timer because CPU already waken up from the C-states*/
+			menu_hrtimer_cancel();
+			__tick_nohz_idle_enter(ts);
+		}
+	} else {
+		tick_nohz_full_stop_tick(ts);
+	}
 }
 
 /**
@@ -835,6 +856,20 @@ static inline void tick_check_nohz(int cpu) { }
 
 #endif /* NO_HZ */
 
+#ifdef CONFIG_NO_HZ_FULL
+void tick_nohz_full_check(void)
+{
+	struct tick_sched *ts = &__get_cpu_var(tick_cpu_sched);
+
+	if (tick_nohz_full_cpu(smp_processor_id())) {
+		if (ts->tick_stopped && !is_idle_task(current)) {
+			if (!sched_can_stop_tick())
+				tick_nohz_restart_sched_tick(ts, ktime_get());
+		}
+	}
+}
+#endif /* CONFIG_NO_HZ_FULL */
+
 /*
  * Called from irq_enter to notify about the possible interruption of idle()
  */
-- 
1.7.5.4

