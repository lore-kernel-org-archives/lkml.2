Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030992Ab2CUOGa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 10:06:30 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:61813 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030839Ab2CUN7H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 09:59:07 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>, linaro-sched-sig@lists.linaro.org
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Alessio Igor Bogani <abogani@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Avi Kivity <avi@redhat.com>,
        Chris Metcalf <cmetcalf@tilera.com>, Christoph Lameter <cl@linux.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>, Ingo Molnar <mingo@kernel.org>,
        Max Krasnyansky <maxk@qualcomm.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Sven-Thorsten Dietrich <thebigcorporation@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Zen Lin <zen@openhuawei.org>
Subject: [PATCH 04/32] nohz: Move nohz load balancer selection into idle logic
Date: Wed, 21 Mar 2012 14:58:10 +0100
Message-Id: <1332338318-5958-6-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1332338318-5958-1-git-send-email-fweisbec@gmail.com>
References: <1332338318-5958-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ ** BUGGY PATCH: I need to put more thinking into this ** ]

We want the nohz load balancer to be an idle CPU, thus
move that selection to strict dyntick idle logic.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Alessio Igor Bogani <abogani@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Avi Kivity <avi@redhat.com>
Cc: Chris Metcalf <cmetcalf@tilera.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: Geoff Levand <geoff@infradead.org>
Cc: Gilad Ben Yossef <gilad@benyossef.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Max Krasnyansky <maxk@qualcomm.com>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephen Hemminger <shemminger@vyatta.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Sven-Thorsten Dietrich <thebigcorporation@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Zen Lin <zen@openhuawei.org>
---
 kernel/time/tick-sched.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index fc9f687..b79dea2 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -398,8 +398,6 @@ static void tick_nohz_stop_sched_tick(struct tick_sched *ts, ktime_t now)
 		 * the scheduler tick in nohz_restart_sched_tick.
 		 */
 		if (!ts->tick_stopped) {
-			select_nohz_load_balancer(1);
-
 			ts->last_tick = hrtimer_get_expires(&ts->sched_timer);
 			ts->tick_stopped = 1;
 		}
@@ -449,8 +447,10 @@ static void __tick_nohz_idle_enter(struct tick_sched *ts)
 	now = tick_nohz_start_idle(smp_processor_id(), ts);
 	tick_nohz_stop_sched_tick(ts, now);
 
-	if (!was_stopped && ts->tick_stopped)
+	if (!was_stopped && ts->tick_stopped) {
 		ts->idle_jiffies = ts->last_jiffies;
+		select_nohz_load_balancer(1);
+	}
 }
 
 /**
@@ -552,7 +552,6 @@ static void tick_nohz_restart(struct tick_sched *ts, ktime_t now)
 static void tick_nohz_restart_sched_tick(struct tick_sched *ts, ktime_t now)
 {
 	/* Update jiffies first */
-	select_nohz_load_balancer(0);
 	tick_do_update_jiffies64(now);
 
 	touch_softlockup_watchdog();
@@ -610,6 +609,7 @@ void tick_nohz_idle_exit(void)
 		tick_nohz_stop_idle(cpu, now);
 
 	if (ts->tick_stopped) {
+		select_nohz_load_balancer(0);
 		tick_nohz_restart_sched_tick(ts, now);
 		tick_nohz_account_idle_ticks(ts);
 	}
-- 
1.7.5.4

