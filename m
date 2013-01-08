Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753217Ab3AHCMQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 21:12:16 -0500
Received: from mail-wg0-f44.google.com ([74.125.82.44]:61003 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755935Ab3AHCJl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 21:09:41 -0500
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Alessio Igor Bogani <abogani@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Chris Metcalf <cmetcalf@tilera.com>, Christoph Lameter <cl@linux.com>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Li Zhong <zhong@linux.vnet.ibm.com>,
        Namhyung Kim <namhyung.kim@lge.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 25/33] nohz: Add some tracing
Date: Tue,  8 Jan 2013 03:08:25 +0100
Message-Id: <1357610913-1080-26-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1357610913-1080-1-git-send-email-fweisbec@gmail.com>
References: <1357610913-1080-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Not for merge, just for debugging.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Alessio Igor Bogani <abogani@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Chris Metcalf <cmetcalf@tilera.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Geoff Levand <geoff@infradead.org>
Cc: Gilad Ben Yossef <gilad@benyossef.com>
Cc: Hakan Akkan <hakanakkan@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Li Zhong <zhong@linux.vnet.ibm.com>
Cc: Namhyung Kim <namhyung.kim@lge.com>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/time/tick-sched.c |   27 ++++++++++++++++++++++-----
 1 files changed, 22 insertions(+), 5 deletions(-)

diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index 5543a4d..1cd93a9 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -142,6 +142,7 @@ static void tick_sched_handle(struct tick_sched *ts, struct pt_regs *regs)
 			ts->idle_jiffies++;
 	}
 #endif
+	trace_printk("tick\n");
 	update_process_times(user_mode(regs));
 	profile_tick(CPU_PROFILING);
 }
@@ -591,17 +592,30 @@ void tick_nohz_idle_enter(void)
 #ifdef CONFIG_NO_HZ_FULL
 static bool can_stop_full_tick(int cpu)
 {
-	if (!sched_can_stop_tick())
+	if (!sched_can_stop_tick()) {
+		trace_printk("Can't stop: sched\n");
 		return false;
+	}
 
-	if (!rcu_is_nocb_cpu(cpu))
+	if (!rcu_is_nocb_cpu(cpu)) {
+		trace_printk("Can't stop: not RCU nocb\n");
 		return false;
+	}
 
-	if (rcu_pending(cpu))
+	/*
+	 * Keep the tick if we are asked to report a quiescent state.
+	 * This must be further optimized (avoid checks for local callbacks,
+	 * ignore RCU in userspace, etc...
+	 */
+	if (rcu_pending(cpu)) {
+		trace_printk("Can't stop: RCU pending\n");
 		return false;
+	}
 
-	if (posix_cpu_timers_running(current))
+	if (posix_cpu_timers_running(current)) {
+		trace_printk("Can't stop: posix CPU timers running\n");
 		return false;
+	}
 
 	return true;
 }
@@ -615,12 +629,15 @@ static void tick_nohz_full_stop_tick(struct tick_sched *ts)
 	if (!tick_nohz_full_cpu(cpu) || is_idle_task(current))
 		return;
 
-	if (!ts->tick_stopped && ts->nohz_mode == NOHZ_MODE_INACTIVE)
+	if (!ts->tick_stopped && ts->nohz_mode == NOHZ_MODE_INACTIVE) {
+		trace_printk("Can't stop: NOHZ_MODE_INACTIVE\n");
 		return;
+	}
 
 	if (!can_stop_full_tick(cpu))
 		return;
 
+	trace_printk("Stop tick\n");
 	tick_nohz_stop_sched_tick(ts, ktime_get(), cpu);
 #endif
 }
-- 
1.7.5.4

