Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754804Ab1HOPxN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 11:53:13 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:51689 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754774Ab1HOPxL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 11:53:11 -0400
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
Subject: [PATCH 09/32] nohz: Move ts->idle_calls into strict idle logic
Date: Mon, 15 Aug 2011 17:52:06 +0200
Message-Id: <1313423549-27093-10-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1313423549-27093-1-git-send-email-fweisbec@gmail.com>
References: <1313423549-27093-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Split the nohz switch in two parts, a first that checks if we can
really stop the tick, and another that actually stop it. This
way we can pull out idle_calls stat incrementation into strict
idle logic.

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
 kernel/time/tick-sched.c |   87 ++++++++++++++++++++++++---------------------
 1 files changed, 46 insertions(+), 41 deletions(-)

diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index de1b629..2794150 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -249,48 +249,14 @@ EXPORT_SYMBOL_GPL(get_cpu_iowait_time_us);
  * Called either from the idle loop or from irq_exit() when an idle period was
  * just interrupted by an interrupt which did not cause a reschedule.
  */
-static void tick_nohz_stop_sched_tick(ktime_t now)
+static void tick_nohz_stop_sched_tick(ktime_t now, int cpu, struct tick_sched *ts)
 {
 	unsigned long seq, last_jiffies, next_jiffies, delta_jiffies;
-	struct tick_sched *ts;
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
 
-	if (unlikely(ts->nohz_mode == NOHZ_MODE_INACTIVE))
-		return;
-
-	if (need_resched())
-		return;
-
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
@@ -422,18 +388,57 @@ out:
 	ts->sleep_length = ktime_sub(dev->next_event, now);
 }
 
+static bool tick_nohz_can_stop_tick(int cpu, struct tick_sched *ts)
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
 static void __tick_nohz_enter_idle(struct tick_sched *ts, int cpu)
 {
 	ktime_t now;
-	int was_stopped = ts->tick_stopped;
 
 	now = tick_nohz_start_idle(cpu, ts);
-	tick_nohz_stop_sched_tick(now);
 
-	if (!was_stopped && ts->tick_stopped) {
-		ts->idle_jiffies = ts->last_jiffies;
-		select_nohz_load_balancer(1);
-		rcu_enter_nohz();
+	if (tick_nohz_can_stop_tick(cpu, ts)) {
+		int was_stopped = ts->tick_stopped;
+
+		ts->idle_calls++;
+		tick_nohz_stop_sched_tick(now, cpu, ts);
+
+		if (!was_stopped && ts->tick_stopped) {
+			ts->idle_jiffies = ts->last_jiffies;
+			select_nohz_load_balancer(1);
+			rcu_enter_nohz();
+		}
 	}
 }
 
-- 
1.7.5.4

