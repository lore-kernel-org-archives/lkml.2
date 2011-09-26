Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753315Ab1IZKTa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Sep 2011 06:19:30 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:64340 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752282Ab1IZKT1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Sep 2011 06:19:27 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>
Subject: [PATCH 2/7] rcu: Fix early call to rcu_enter_nohz() on tick stopping
Date: Mon, 26 Sep 2011 12:19:07 +0200
Message-Id: <1317032352-25571-3-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1317032352-25571-1-git-send-email-fweisbec@gmail.com>
References: <1317032352-25571-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In tick_nohz_stop_sched_tick(), we enter RCU extended quiescent
state right before reprogramming the next timer.

However when we reprogram it, we may raise the hrtimer softirq,
thus entering the scheduler to wake up the softirq thread and
iterate over the scheduler domains under RCU when we search the dest
CPU for the task.

We need to be outside an RCU extended quiescent state to achieve
this otherwise it's an illegal use of RCU:

	WARNING: at include/linux/rcupdate.h:248 select_task_rq_fair+0xc9b/0xcd0()
	Hardware name: AMD690VM-FMH
	Modules linked in:
	Pid: 0, comm: swapper Tainted: G        W   3.0.0+ #56
	Call Trace:
	[<ffffffff8105cc3f>] warn_slowpath_common+0x7f/0xc0
	[<ffffffff8105cc9a>] warn_slowpath_null+0x1a/0x20
	[<ffffffff8105239b>] select_task_rq_fair+0xc9b/0xcd0
	[<ffffffff812f2b64>] ? do_raw_spin_lock+0x54/0x160
	[<ffffffff81058ee3>] try_to_wake_up+0xd3/0x300
	[<ffffffff81090758>] ? ktime_get+0x68/0xf0
	[<ffffffff81059165>] wake_up_process+0x15/0x20
	[<ffffffff81065135>] raise_softirq_irqoff+0x65/0x110
	[<ffffffff8108a2d5>] __hrtimer_start_range_ns+0x415/0x5a0
	[<ffffffff8108a478>] hrtimer_start+0x18/0x20
	[<ffffffff810980e0>] tick_nohz_stop_sched_tick+0x2b0/0x3c0
	[<ffffffff8100a9c1>] cpu_idle+0x81/0x120
	[<ffffffff817e720f>] rest_init+0xef/0x170
	[<ffffffff817e7172>] ? rest_init+0x52/0x170
	[<ffffffff81ed6cb7>] start_kernel+0x3cb/0x3d6
	[<ffffffff81ed6346>] x86_64_start_reservations+0x131/0x135
	[<ffffffff81ed644d>] x86_64_start_kernel+0x103/0x112

Fix this by calling rcu_enter_nohz() only once everything is done
to stop the tick.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
---
 kernel/time/tick-sched.c |   27 ++++++++++++++++++---------
 1 files changed, 18 insertions(+), 9 deletions(-)

diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index eb98e55..9416700 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -246,19 +246,13 @@ u64 get_cpu_iowait_time_us(int cpu, u64 *last_update_time)
 }
 EXPORT_SYMBOL_GPL(get_cpu_iowait_time_us);
 
-/**
- * tick_nohz_stop_sched_tick - stop the idle tick from the idle task
- *
- * When the next event is more than a tick into the future, stop the idle tick
- * Called either from the idle loop or from irq_exit() when an idle period was
- * just interrupted by an interrupt which did not cause a reschedule.
- */
-void tick_nohz_stop_sched_tick(int inidle)
+static bool __tick_nohz_stop_sched_tick(int inidle)
 {
 	unsigned long seq, last_jiffies, next_jiffies, delta_jiffies, flags;
 	struct tick_sched *ts;
 	ktime_t last_update, expires, now;
 	struct clock_event_device *dev = __get_cpu_var(tick_cpu_device).evtdev;
+	bool stopped = false;
 	u64 time_delta;
 	int cpu;
 
@@ -405,7 +399,7 @@ void tick_nohz_stop_sched_tick(int inidle)
 			ts->idle_tick = hrtimer_get_expires(&ts->sched_timer);
 			ts->tick_stopped = 1;
 			ts->idle_jiffies = last_jiffies;
-			rcu_enter_nohz();
+			stopped = true;
 		}
 
 		ts->idle_sleeps++;
@@ -445,6 +439,21 @@ out:
 	ts->sleep_length = ktime_sub(dev->next_event, now);
 end:
 	local_irq_restore(flags);
+
+	return stopped;
+}
+
+/**
+ * tick_nohz_stop_sched_tick - stop the idle tick from the idle task
+ *
+ * When the next event is more than a tick into the future, stop the idle tick
+ * Called either from the idle loop or from irq_exit() when an idle period was
+ * just interrupted by an interrupt which did not cause a reschedule.
+ */
+void tick_nohz_stop_sched_tick(int inidle)
+{
+	if (__tick_nohz_stop_sched_tick(inidle))
+		rcu_enter_nohz();
 }
 
 /**
-- 
1.7.5.4

