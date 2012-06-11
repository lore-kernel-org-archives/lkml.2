Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751902Ab2FKQxm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 12:53:42 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:37854 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751688Ab2FKQxh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 12:53:37 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Alessio Igor Bogani <abogani@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Avi Kivity <avi@redhat.com>,
        Chris Metcalf <cmetcalf@tilera.com>, Christoph Lameter <cl@linux.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>, Kevin Hilman <khilman@ti.com>,
        Max Krasnyansky <maxk@qualcomm.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Sven-Thorsten Dietrich <thebigcorporation@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 1/5] nohz: Separate idle sleeping time accounting from nohz logic
Date: Mon, 11 Jun 2012 18:53:18 +0200
Message-Id: <1339433602-26836-2-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1339433602-26836-1-git-send-email-fweisbec@gmail.com>
References: <1339433602-26836-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As we plan to be able to stop the tick outside the idle task, we
need to prepare for separating nohz logic from idle. As a start,
this pulls the idle sleeping time accounting out of the tick
stop/restart API to the callers on idle entry/exit.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Alessio Igor Bogani <abogani@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Avi Kivity <avi@redhat.com>
Cc: Chris Metcalf <cmetcalf@tilera.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: Geoff Levand <geoff@infradead.org>
Cc: Gilad Ben Yossef <gilad@benyossef.com>
Cc: Hakan Akkan <hakanakkan@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Kevin Hilman <khilman@ti.com>
Cc: Max Krasnyansky <maxk@qualcomm.com>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephen Hemminger <shemminger@vyatta.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Sven-Thorsten Dietrich <thebigcorporation@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/time/tick-sched.c |   78 +++++++++++++++++++++++++--------------------
 1 files changed, 43 insertions(+), 35 deletions(-)

diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index da70c6d..6321a20 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -271,10 +271,10 @@ u64 get_cpu_iowait_time_us(int cpu, u64 *last_update_time)
 }
 EXPORT_SYMBOL_GPL(get_cpu_iowait_time_us);
 
-static void tick_nohz_stop_sched_tick(struct tick_sched *ts)
+static void tick_nohz_stop_sched_tick(struct tick_sched *ts, ktime_t now)
 {
 	unsigned long seq, last_jiffies, next_jiffies, delta_jiffies;
-	ktime_t last_update, expires, now;
+	ktime_t last_update, expires;
 	struct clock_event_device *dev = __get_cpu_var(tick_cpu_device).evtdev;
 	u64 time_delta;
 	int cpu;
@@ -282,8 +282,6 @@ static void tick_nohz_stop_sched_tick(struct tick_sched *ts)
 	cpu = smp_processor_id();
 	ts = &per_cpu(tick_cpu_sched, cpu);
 
-	now = tick_nohz_start_idle(cpu, ts);
-
 	/*
 	 * If this cpu is offline and it is the one which updates
 	 * jiffies, then give up the assignment and let it be taken by
@@ -444,6 +442,14 @@ out:
 	ts->sleep_length = ktime_sub(dev->next_event, now);
 }
 
+static void __tick_nohz_idle_enter(struct tick_sched *ts)
+{
+	ktime_t now;
+
+	now = tick_nohz_start_idle(smp_processor_id(), ts);
+	tick_nohz_stop_sched_tick(ts, now);
+}
+
 /**
  * tick_nohz_idle_enter - stop the idle tick from the idle task
  *
@@ -479,7 +485,7 @@ void tick_nohz_idle_enter(void)
 	 * update of the idle time accounting in tick_nohz_start_idle().
 	 */
 	ts->inidle = 1;
-	tick_nohz_stop_sched_tick(ts);
+	__tick_nohz_idle_enter(ts);
 
 	local_irq_enable();
 }
@@ -499,7 +505,7 @@ void tick_nohz_irq_exit(void)
 	if (!ts->inidle)
 		return;
 
-	tick_nohz_stop_sched_tick(ts);
+	__tick_nohz_idle_enter(ts);
 }
 
 /**
@@ -540,39 +546,11 @@ static void tick_nohz_restart(struct tick_sched *ts, ktime_t now)
 	}
 }
 
-/**
- * tick_nohz_idle_exit - restart the idle tick from the idle task
- *
- * Restart the idle tick when the CPU is woken up from idle
- * This also exit the RCU extended quiescent state. The CPU
- * can use RCU again after this function is called.
- */
-void tick_nohz_idle_exit(void)
+static void tick_nohz_restart_sched_tick(struct tick_sched *ts, ktime_t now)
 {
-	int cpu = smp_processor_id();
-	struct tick_sched *ts = &per_cpu(tick_cpu_sched, cpu);
 #ifndef CONFIG_VIRT_CPU_ACCOUNTING
 	unsigned long ticks;
 #endif
-	ktime_t now;
-
-	local_irq_disable();
-
-	WARN_ON_ONCE(!ts->inidle);
-
-	ts->inidle = 0;
-
-	if (ts->idle_active || ts->tick_stopped)
-		now = ktime_get();
-
-	if (ts->idle_active)
-		tick_nohz_stop_idle(cpu, now);
-
-	if (!ts->tick_stopped) {
-		local_irq_enable();
-		return;
-	}
-
 	/* Update jiffies first */
 	select_nohz_load_balancer(0);
 	tick_do_update_jiffies64(now);
@@ -600,6 +578,36 @@ void tick_nohz_idle_exit(void)
 	ts->idle_exittime = now;
 
 	tick_nohz_restart(ts, now);
+}
+
+/**
+ * tick_nohz_idle_exit - restart the idle tick from the idle task
+ *
+ * Restart the idle tick when the CPU is woken up from idle
+ * This also exit the RCU extended quiescent state. The CPU
+ * can use RCU again after this function is called.
+ */
+void tick_nohz_idle_exit(void)
+
+{
+	int cpu = smp_processor_id();
+	struct tick_sched *ts = &per_cpu(tick_cpu_sched, cpu);
+	ktime_t now;
+
+	local_irq_disable();
+
+	WARN_ON_ONCE(!ts->inidle);
+
+	ts->inidle = 0;
+
+	if (ts->idle_active || ts->tick_stopped)
+		now = ktime_get();
+
+	if (ts->idle_active)
+		tick_nohz_stop_idle(cpu, now);
+
+	if (ts->tick_stopped)
+		tick_nohz_restart_sched_tick(ts, now);
 
 	local_irq_enable();
 }
-- 
1.7.5.4

