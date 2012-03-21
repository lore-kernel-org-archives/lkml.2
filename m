Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030905Ab2CUN7N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 09:59:13 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:61813 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030533Ab2CUN7J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 09:59:09 -0400
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
Subject: [PATCH 05/32] nohz: Move ts->idle_calls incrementation into strict idle logic
Date: Wed, 21 Mar 2012 14:58:11 +0100
Message-Id: <1332338318-5958-7-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1332338318-5958-1-git-send-email-fweisbec@gmail.com>
References: <1332338318-5958-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since we want to prepare for making the nohz API to work further
the idle case, we need to pull ts->idle_calls incrementation up to
the callers in idle.

To perform this, we split tick_nohz_stop_sched_tick() switch in two
parts, a first that checks if we can really stop the tick for idle,
and another that actually stops it. Then from the callers in idle,
we check if we can stop the tick and only then we increment idle_calls
and finally relay to the nohz API that doesn't care about these details
anymore.

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
 kernel/time/tick-sched.c |   88 +++++++++++++++++++++++++---------------------
 1 files changed, 48 insertions(+), 40 deletions(-)

diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index b79dea2..12ba932 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -271,47 +271,15 @@ u64 get_cpu_iowait_time_us(int cpu, u64 *last_update_time)
 }
 EXPORT_SYMBOL_GPL(get_cpu_iowait_time_us);
 
-static void tick_nohz_stop_sched_tick(struct tick_sched *ts, ktime_t now)
+static void tick_nohz_stop_sched_tick(struct tick_sched *ts,
+				      ktime_t now, int cpu)
 {
 	unsigned long seq, last_jiffies, next_jiffies, delta_jiffies;
 	ktime_t last_update, expires;
 	struct clock_event_device *dev = __get_cpu_var(tick_cpu_device).evtdev;
 	u64 time_delta;
-	int cpu;
-
-	cpu = smp_processor_id();
-	ts = &per_cpu(tick_cpu_sched, cpu);
-
-	/*
-	 * If this cpu is offline and it is the one which updates
-	 * jiffies, then give up the assignment and let it be taken by
-	 * the cpu which runs the tick timer next. If we don't drop
-	 * this here the jiffies might be stale and do_timer() never
-	 * invoked.
-	 */
-	if (unlikely(!cpu_online(cpu))) {
-		if (cpu == tick_do_timer_cpu)
-			tick_do_timer_cpu = TICK_DO_TIMER_NONE;
-	}
-
-	if (unlikely(ts->nohz_mode == NOHZ_MODE_INACTIVE))
-		return;
-
-	if (need_resched())
-		return;
 
-	if (unlikely(local_softirq_pending() && cpu_online(cpu))) {
-		static int ratelimit;
-
-		if (ratelimit < 10) {
-			printk(KERN_ERR "NOHZ: local_softirq_pending %02x\n",
-			       (unsigned int) local_softirq_pending());
-			ratelimit++;
-		}
-		return;
-	}
 
-	ts->idle_calls++;
 	/* Read jiffies and the time when jiffies were updated last */
 	do {
 		seq = read_seqbegin(&xtime_lock);
@@ -439,17 +407,57 @@ out:
 	ts->sleep_length = ktime_sub(dev->next_event, now);
 }
 
+static bool can_stop_idle_tick(int cpu, struct tick_sched *ts)
+{
+	/*
+	 * If this cpu is offline and it is the one which updates
+	 * jiffies, then give up the assignment and let it be taken by
+	 * the cpu which runs the tick timer next. If we don't drop
+	 * this here the jiffies might be stale and do_timer() never
+	 * invoked.
+	 */
+	if (unlikely(!cpu_online(cpu))) {
+		if (cpu == tick_do_timer_cpu)
+			tick_do_timer_cpu = TICK_DO_TIMER_NONE;
+	}
+
+	if (unlikely(ts->nohz_mode == NOHZ_MODE_INACTIVE))
+		return false;
+
+	if (need_resched())
+		return false;
+
+	if (unlikely(local_softirq_pending() && cpu_online(cpu))) {
+		static int ratelimit;
+
+		if (ratelimit < 10) {
+			printk(KERN_ERR "NOHZ: local_softirq_pending %02x\n",
+			       (unsigned int) local_softirq_pending());
+			ratelimit++;
+		}
+		return false;
+	}
+
+	return true;
+}
+
 static void __tick_nohz_idle_enter(struct tick_sched *ts)
 {
 	ktime_t now;
-	int was_stopped = ts->tick_stopped;
+	int cpu = smp_processor_id();
 
-	now = tick_nohz_start_idle(smp_processor_id(), ts);
-	tick_nohz_stop_sched_tick(ts, now);
+	now = tick_nohz_start_idle(cpu, ts);
 
-	if (!was_stopped && ts->tick_stopped) {
-		ts->idle_jiffies = ts->last_jiffies;
-		select_nohz_load_balancer(1);
+	if (can_stop_idle_tick(cpu, ts)) {
+		int was_stopped = ts->tick_stopped;
+
+		ts->idle_calls++;
+		tick_nohz_stop_sched_tick(ts, now, cpu);
+
+		if (!was_stopped && ts->tick_stopped) {
+			ts->idle_jiffies = ts->last_jiffies;
+			select_nohz_load_balancer(1);
+		}
 	}
 }
 
-- 
1.7.5.4

