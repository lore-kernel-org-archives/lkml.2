Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754751Ab1HOPxG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 11:53:06 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:51689 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754615Ab1HOPxC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 11:53:02 -0400
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
Subject: [PATCH 06/32] nohz: Move idle ticks stats tracking out of nohz handlers
Date: Mon, 15 Aug 2011 17:52:03 +0200
Message-Id: <1313423549-27093-7-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1313423549-27093-1-git-send-email-fweisbec@gmail.com>
References: <1313423549-27093-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Idle ticks time tracking is merged into nohz stop/restart
handlers. Pull it out into idle entry/exit handlers instead,
so that nohz APIs is more idle independant.

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
 kernel/time/tick-sched.c |   34 +++++++++++++++++++---------------
 1 files changed, 19 insertions(+), 15 deletions(-)

diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index 8937d4a..21b187c 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -384,7 +384,6 @@ static void tick_nohz_stop_sched_tick(ktime_t now)
 
 			ts->idle_tick = hrtimer_get_expires(&ts->sched_timer);
 			ts->tick_stopped = 1;
-			ts->idle_jiffies = last_jiffies;
 		}
 
 		ts->idle_sleeps++;
@@ -433,8 +432,10 @@ static void __tick_nohz_enter_idle(struct tick_sched *ts, int cpu)
 	now = tick_nohz_start_idle(cpu, ts);
 	tick_nohz_stop_sched_tick(now);
 
-	if (!was_stopped && ts->tick_stopped)
+	if (!was_stopped && ts->tick_stopped) {
+		ts->idle_jiffies = ts->last_jiffies;
 		rcu_enter_nohz();
+	}
 }
 
 void tick_nohz_enter_idle(void)
@@ -498,16 +499,26 @@ static void tick_nohz_restart(struct tick_sched *ts, ktime_t now)
 static void tick_nohz_restart_sched_tick(ktime_t now, struct tick_sched *ts)
 {
 	int cpu = smp_processor_id();
-#ifndef CONFIG_VIRT_CPU_ACCOUNTING
-	unsigned long ticks;
-#endif
 
 	/* Update jiffies first */
 	select_nohz_load_balancer(0);
 	tick_do_update_jiffies64(now);
 	cpumask_clear_cpu(cpu, nohz_cpu_mask);
 
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
@@ -520,15 +531,6 @@ static void tick_nohz_restart_sched_tick(ktime_t now, struct tick_sched *ts)
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
 
 void tick_nohz_exit_idle(void)
@@ -551,6 +553,7 @@ void tick_nohz_exit_idle(void)
 	if (ts->tick_stopped) {
 		rcu_exit_nohz();
 		tick_nohz_restart_sched_tick(now, ts);
+		tick_nohz_account_idle_ticks(ts);
 	}
 
 	local_irq_enable();
@@ -766,7 +769,8 @@ static enum hrtimer_restart tick_sched_timer(struct hrtimer *timer)
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

