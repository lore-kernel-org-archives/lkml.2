Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752190Ab2LTSe5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 13:34:57 -0500
Received: from mail-wg0-f42.google.com ([74.125.82.42]:48596 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751744Ab2LTSeM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 13:34:12 -0500
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Alessio Igor Bogani <abogani@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Avi Kivity <avi@redhat.com>,
        Chris Metcalf <cmetcalf@tilera.com>, Christoph Lameter <cl@linux.com>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 19/24] nohz: Move nohz load balancer selection into idle logic
Date: Thu, 20 Dec 2012 19:33:06 +0100
Message-Id: <1356028391-14427-20-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1356028391-14427-1-git-send-email-fweisbec@gmail.com>
References: <1356028391-14427-1-git-send-email-fweisbec@gmail.com>
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
Cc: Geoff Levand <geoff@infradead.org>
Cc: Gilad Ben Yossef <gilad@benyossef.com>
Cc: Hakan Akkan <hakanakkan@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
[ added movement of calc_load_exit_idle() ]
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/time/tick-sched.c |   11 ++++++-----
 1 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index 73f339b..1b607bce 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -442,9 +442,6 @@ static ktime_t tick_nohz_stop_sched_tick(struct tick_sched *ts,
 		 * the scheduler tick in nohz_restart_sched_tick.
 		 */
 		if (!ts->tick_stopped) {
-			nohz_balance_enter_idle(cpu);
-			calc_load_enter_idle();
-
 			ts->last_tick = hrtimer_get_expires(&ts->sched_timer);
 			ts->tick_stopped = 1;
 		}
@@ -540,8 +537,11 @@ static void __tick_nohz_idle_enter(struct tick_sched *ts)
 			ts->idle_expires = expires;
 		}
 
-		if (!was_stopped && ts->tick_stopped)
+		if (!was_stopped && ts->tick_stopped) {
 			ts->idle_jiffies = ts->last_jiffies;
+			nohz_balance_enter_idle(cpu);
+			calc_load_enter_idle();
+		}
 	}
 }
 
@@ -649,7 +649,6 @@ static void tick_nohz_restart_sched_tick(struct tick_sched *ts, ktime_t now)
 	tick_do_update_jiffies64(now);
 	update_cpu_load_nohz();
 
-	calc_load_exit_idle();
 	touch_softlockup_watchdog();
 	/*
 	 * Cancel the scheduled timer and restore the tick
@@ -709,6 +708,8 @@ void tick_nohz_idle_exit(void)
 		tick_nohz_stop_idle(cpu, now);
 
 	if (ts->tick_stopped) {
+		nohz_balance_enter_idle(cpu);
+		calc_load_exit_idle();
 		tick_nohz_restart_sched_tick(ts, now);
 		tick_nohz_account_idle_ticks(ts);
 	}
-- 
1.7.5.4

