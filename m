Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754823Ab1HOPxT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 11:53:19 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:51689 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754797Ab1HOPxO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 11:53:14 -0400
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
Subject: [PATCH 10/32] nohz: Move next idle expiring time record into idle logic area
Date: Mon, 15 Aug 2011 17:52:07 +0200
Message-Id: <1313423549-27093-11-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1313423549-27093-1-git-send-email-fweisbec@gmail.com>
References: <1313423549-27093-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move next idle expiry time record and idle sleeps tracking into
idle entry functions as they are not generic nohz stats.

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
 kernel/time/tick-sched.c |   21 ++++++++++++---------
 1 files changed, 12 insertions(+), 9 deletions(-)

diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index 2794150..f5e12da 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -249,10 +249,10 @@ EXPORT_SYMBOL_GPL(get_cpu_iowait_time_us);
  * Called either from the idle loop or from irq_exit() when an idle period was
  * just interrupted by an interrupt which did not cause a reschedule.
  */
-static void tick_nohz_stop_sched_tick(ktime_t now, int cpu, struct tick_sched *ts)
+static ktime_t tick_nohz_stop_sched_tick(ktime_t now, int cpu, struct tick_sched *ts)
 {
 	unsigned long seq, last_jiffies, next_jiffies, delta_jiffies;
-	ktime_t last_update, expires;
+	ktime_t last_update, expires, ret = { .tv64 = 0 };
 	struct clock_event_device *dev = __get_cpu_var(tick_cpu_device).evtdev;
 	u64 time_delta;
 
@@ -338,6 +338,8 @@ static void tick_nohz_stop_sched_tick(ktime_t now, int cpu, struct tick_sched *t
 		if (ts->tick_stopped && ktime_equal(expires, dev->next_event))
 			goto out;
 
+		ret = expires;
+
 		/*
 		 * nohz_stop_sched_tick can be called several times before
 		 * the nohz_restart_sched_tick is called. This happens when
@@ -350,11 +352,6 @@ static void tick_nohz_stop_sched_tick(ktime_t now, int cpu, struct tick_sched *t
 			ts->tick_stopped = 1;
 		}
 
-		ts->idle_sleeps++;
-
-		/* Mark expires */
-		ts->idle_expires = expires;
-
 		/*
 		 * If the expiration time == KTIME_MAX, then
 		 * in this case we simply stop the tick timer.
@@ -386,6 +383,8 @@ out:
 	ts->next_jiffies = next_jiffies;
 	ts->last_jiffies = last_jiffies;
 	ts->sleep_length = ktime_sub(dev->next_event, now);
+
+	return ret;
 }
 
 static bool tick_nohz_can_stop_tick(int cpu, struct tick_sched *ts)
@@ -424,7 +423,7 @@ static bool tick_nohz_can_stop_tick(int cpu, struct tick_sched *ts)
 
 static void __tick_nohz_enter_idle(struct tick_sched *ts, int cpu)
 {
-	ktime_t now;
+	ktime_t now, expires;
 
 	now = tick_nohz_start_idle(cpu, ts);
 
@@ -432,7 +431,11 @@ static void __tick_nohz_enter_idle(struct tick_sched *ts, int cpu)
 		int was_stopped = ts->tick_stopped;
 
 		ts->idle_calls++;
-		tick_nohz_stop_sched_tick(now, cpu, ts);
+		expires = tick_nohz_stop_sched_tick(now, cpu, ts);
+		if (expires.tv64 > 0LL) {
+			ts->idle_sleeps++;
+			ts->idle_expires = expires;
+		}
 
 		if (!was_stopped && ts->tick_stopped) {
 			ts->idle_jiffies = ts->last_jiffies;
-- 
1.7.5.4

