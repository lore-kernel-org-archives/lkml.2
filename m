Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754045Ab2JOQ7t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 12:59:49 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:56604 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753955Ab2JOQ7X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 12:59:23 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 2/3] tick: Consolidate tick handling for high and low res handlers
Date: Mon, 15 Oct 2012 18:59:13 +0200
Message-Id: <1350320354-17214-3-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1350320354-17214-1-git-send-email-fweisbec@gmail.com>
References: <1350320354-17214-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Besides unifying code, this also adds the idle check before
processing idle accounting specifics on the low res handler.
This way we also generalize this part of the nohz code for
!CONFIG_HIGH_RES_TIMERS to prepare for the adaptive tickless
features.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
---
 kernel/time/tick-sched.c |   55 ++++++++++++++++++---------------------------
 1 files changed, 22 insertions(+), 33 deletions(-)

diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index 360674c..68a873a 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -120,6 +120,25 @@ static void tick_sched_do_timer(ktime_t now)
 		tick_do_update_jiffies64(now);
 }
 
+static void tick_sched_handle(struct tick_sched *ts, struct pt_regs *regs)
+{
+	/*
+	 * When we are idle and the tick is stopped, we have to touch
+	 * the watchdog as we might not schedule for a really long
+	 * time. This happens on complete idle SMP systems while
+	 * waiting on the login prompt. We also increment the "start of
+	 * idle" jiffy stamp so the idle accounting adjustment we do
+	 * when we go busy again does not account too much ticks.
+	 */
+	if (ts->tick_stopped) {
+		touch_softlockup_watchdog();
+		if (is_idle_task(current))
+			ts->idle_jiffies++;
+	}
+	update_process_times(user_mode(regs));
+	profile_tick(CPU_PROFILING);
+}
+
 /*
  * NOHZ - aka dynamic tick functionality
  */
@@ -675,22 +694,7 @@ static void tick_nohz_handler(struct clock_event_device *dev)
 	dev->next_event.tv64 = KTIME_MAX;
 
 	tick_sched_do_timer(now);
-
-	/*
-	 * When we are idle and the tick is stopped, we have to touch
-	 * the watchdog as we might not schedule for a really long
-	 * time. This happens on complete idle SMP systems while
-	 * waiting on the login prompt. We also increment the "start
-	 * of idle" jiffy stamp so the idle accounting adjustment we
-	 * do when we go busy again does not account too much ticks.
-	 */
-	if (ts->tick_stopped) {
-		touch_softlockup_watchdog();
-		ts->idle_jiffies++;
-	}
-
-	update_process_times(user_mode(regs));
-	profile_tick(CPU_PROFILING);
+	tick_sched_handle(ts, regs);
 
 	while (tick_nohz_reprogram(ts, now)) {
 		now = ktime_get();
@@ -818,23 +822,8 @@ static enum hrtimer_restart tick_sched_timer(struct hrtimer *timer)
 	 * Do not call, when we are not in irq context and have
 	 * no valid regs pointer
 	 */
-	if (regs) {
-		/*
-		 * When we are idle and the tick is stopped, we have to touch
-		 * the watchdog as we might not schedule for a really long
-		 * time. This happens on complete idle SMP systems while
-		 * waiting on the login prompt. We also increment the "start of
-		 * idle" jiffy stamp so the idle accounting adjustment we do
-		 * when we go busy again does not account too much ticks.
-		 */
-		if (ts->tick_stopped) {
-			touch_softlockup_watchdog();
-			if (is_idle_task(current))
-				ts->idle_jiffies++;
-		}
-		update_process_times(user_mode(regs));
-		profile_tick(CPU_PROFILING);
-	}
+	if (regs)
+		tick_sched_handle(ts, regs);
 
 	hrtimer_forward(timer, now, tick_period);
 
-- 
1.7.5.4

