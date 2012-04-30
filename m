Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757624Ab2EAABM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2012 20:01:12 -0400
Received: from mail-qc0-f180.google.com ([209.85.216.180]:55516 "EHLO
	mail-qc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757248Ab2EAABL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2012 20:01:11 -0400
X-Greylist: delayed 345 seconds by postgrey-1.27 at vger.kernel.org; Mon, 30 Apr 2012 20:01:11 EDT
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>, linaro-sched-sig@lists.linaro.org
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Alessio Igor Bogani <abogani@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Avi Kivity <avi@redhat.com>,
        Chris Metcalf <cmetcalf@tilera.com>, Christoph Lameter <cl@linux.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Kevin Hilman <khilman@ti.com>, Max Krasnyansky <maxk@qualcomm.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Sven-Thorsten Dietrich <thebigcorporation@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 06/41] nohz: Move next idle expiry time record into idle logic area
Date: Tue,  1 May 2012 01:54:40 +0200
Message-Id: <1335830115-14335-7-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1335830115-14335-1-git-send-email-fweisbec@gmail.com>
References: <1335830115-14335-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The next idle expiry time record and idle sleeps tracking are
statistics that only concern idle.

Since we want the nohz APIs to become usable further idle
context, let's pull up the handling of these statistics to the
callers in idle.

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
 kernel/time/tick-sched.c |   24 ++++++++++++++----------
 1 files changed, 14 insertions(+), 10 deletions(-)

diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index 12ba932..0695e9d 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -271,11 +271,11 @@ u64 get_cpu_iowait_time_us(int cpu, u64 *last_update_time)
 }
 EXPORT_SYMBOL_GPL(get_cpu_iowait_time_us);
 
-static void tick_nohz_stop_sched_tick(struct tick_sched *ts,
-				      ktime_t now, int cpu)
+static ktime_t tick_nohz_stop_sched_tick(struct tick_sched *ts,
+					 ktime_t now, int cpu)
 {
 	unsigned long seq, last_jiffies, next_jiffies, delta_jiffies;
-	ktime_t last_update, expires;
+	ktime_t last_update, expires, ret = { .tv64 = 0 };
 	struct clock_event_device *dev = __get_cpu_var(tick_cpu_device).evtdev;
 	u64 time_delta;
 
@@ -358,6 +358,8 @@ static void tick_nohz_stop_sched_tick(struct tick_sched *ts,
 		if (ts->tick_stopped && ktime_equal(expires, dev->next_event))
 			goto out;
 
+		ret = expires;
+
 		/*
 		 * nohz_stop_sched_tick can be called several times before
 		 * the nohz_restart_sched_tick is called. This happens when
@@ -370,11 +372,6 @@ static void tick_nohz_stop_sched_tick(struct tick_sched *ts,
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
@@ -405,6 +402,8 @@ out:
 	ts->next_jiffies = next_jiffies;
 	ts->last_jiffies = last_jiffies;
 	ts->sleep_length = ktime_sub(dev->next_event, now);
+
+	return ret;
 }
 
 static bool can_stop_idle_tick(int cpu, struct tick_sched *ts)
@@ -443,7 +442,7 @@ static bool can_stop_idle_tick(int cpu, struct tick_sched *ts)
 
 static void __tick_nohz_idle_enter(struct tick_sched *ts)
 {
-	ktime_t now;
+	ktime_t now, expires;
 	int cpu = smp_processor_id();
 
 	now = tick_nohz_start_idle(cpu, ts);
@@ -452,7 +451,12 @@ static void __tick_nohz_idle_enter(struct tick_sched *ts)
 		int was_stopped = ts->tick_stopped;
 
 		ts->idle_calls++;
-		tick_nohz_stop_sched_tick(ts, now, cpu);
+
+		expires = tick_nohz_stop_sched_tick(ts, now, cpu);
+		if (expires.tv64 > 0LL) {
+			ts->idle_sleeps++;
+			ts->idle_expires = expires;
+		}
 
 		if (!was_stopped && ts->tick_stopped) {
 			ts->idle_jiffies = ts->last_jiffies;
-- 
1.7.5.4

