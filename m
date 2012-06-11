Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752081Ab2FKQxp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 12:53:45 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:59588 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751843Ab2FKQxm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 12:53:42 -0400
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
Subject: [PATCH 2/5] nohz: Make nohz API agnostic against idle ticks cputime accounting
Date: Mon, 11 Jun 2012 18:53:19 +0200
Message-Id: <1339433602-26836-3-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1339433602-26836-1-git-send-email-fweisbec@gmail.com>
References: <1339433602-26836-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When the timer tick fires, it accounts the new jiffy as either part
of system, user or idle time. This is how we record the cputime
statistics.

But when the tick is stopped from the idle task, we still need
to record the number of jiffies spent tickless until we restart
the tick and fall back to traditional tick-based cputime accounting.

To do this, we take a snapshot of jiffies when the tick is stopped
and compute the difference against the new value of jiffies when
the tick is restarted. Then we account this whole difference to
the idle cputime.

However we are preparing to be able to stop the tick from other places
than idle. So this idle time accounting needs to be performed from
the callers of nohz APIs, not from the nohz APIs themselves because
we now want them to be agnostic against places that stop/restart tick.

Therefore, we pull the tickless idle time accounting out of generic
nohz helpers up to idle entry/exit callers.

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
 kernel/time/tick-sched.c |   37 ++++++++++++++++++++++---------------
 1 files changed, 22 insertions(+), 15 deletions(-)

diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index 6321a20..e9966f7 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -402,7 +402,6 @@ static void tick_nohz_stop_sched_tick(struct tick_sched *ts, ktime_t now)
 
 			ts->idle_tick = hrtimer_get_expires(&ts->sched_timer);
 			ts->tick_stopped = 1;
-			ts->idle_jiffies = last_jiffies;
 		}
 
 		ts->idle_sleeps++;
@@ -445,9 +444,13 @@ out:
 static void __tick_nohz_idle_enter(struct tick_sched *ts)
 {
 	ktime_t now;
+	int was_stopped = ts->tick_stopped;
 
 	now = tick_nohz_start_idle(smp_processor_id(), ts);
 	tick_nohz_stop_sched_tick(ts, now);
+
+	if (!was_stopped && ts->tick_stopped)
+		ts->idle_jiffies = ts->last_jiffies;
 }
 
 /**
@@ -548,15 +551,25 @@ static void tick_nohz_restart(struct tick_sched *ts, ktime_t now)
 
 static void tick_nohz_restart_sched_tick(struct tick_sched *ts, ktime_t now)
 {
-#ifndef CONFIG_VIRT_CPU_ACCOUNTING
-	unsigned long ticks;
-#endif
 	/* Update jiffies first */
 	select_nohz_load_balancer(0);
 	tick_do_update_jiffies64(now);
 	update_cpu_load_nohz();
 
+	touch_softlockup_watchdog();
+	/*
+	 * Cancel the scheduled timer and restore the tick
+	 */
+	ts->tick_stopped  = 0;
+	ts->idle_exittime = now;
+
+	tick_nohz_restart(ts, now);
+}
+
+static void tick_nohz_account_idle_ticks(struct tick_sched *ts)
+{
 #ifndef CONFIG_VIRT_CPU_ACCOUNTING
+	unsigned long ticks;
 	/*
 	 * We stopped the tick in idle. Update process times would miss the
 	 * time we slept as update_process_times does only a 1 tick
@@ -569,15 +582,6 @@ static void tick_nohz_restart_sched_tick(struct tick_sched *ts, ktime_t now)
 	if (ticks && ticks < LONG_MAX)
 		account_idle_ticks(ticks);
 #endif
-
-	touch_softlockup_watchdog();
-	/*
-	 * Cancel the scheduled timer and restore the tick
-	 */
-	ts->tick_stopped  = 0;
-	ts->idle_exittime = now;
-
-	tick_nohz_restart(ts, now);
 }
 
 /**
@@ -606,8 +610,10 @@ void tick_nohz_idle_exit(void)
 	if (ts->idle_active)
 		tick_nohz_stop_idle(cpu, now);
 
-	if (ts->tick_stopped)
+	if (ts->tick_stopped) {
 		tick_nohz_restart_sched_tick(ts, now);
+		tick_nohz_account_idle_ticks(ts);
+	}
 
 	local_irq_enable();
 }
@@ -812,7 +818,8 @@ static enum hrtimer_restart tick_sched_timer(struct hrtimer *timer)
 		 */
 		if (ts->tick_stopped) {
 			touch_softlockup_watchdog();
-			ts->idle_jiffies++;
+			if (idle_cpu(cpu))
+				ts->idle_jiffies++;
 		}
 		update_process_times(user_mode(regs));
 		profile_tick(CPU_PROFILING);
-- 
1.7.5.4

