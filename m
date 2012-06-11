Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752301Ab2FKQxs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 12:53:48 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:59588 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752124Ab2FKQxq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 12:53:46 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Alessio Igor Bogani <abogani@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Avi Kivity <avi@redhat.com>,
        Chris Metcalf <cmetcalf@tilera.com>, Christoph Lameter <cl@linux.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>, Kevin Hilman <khilman@ti.com>,
        Max Krasnyansky <maxk@qualcomm.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Sven-Thorsten Dietrich <thebigcorporation@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 3/5] nohz: Rename ts->idle_tick to ts->last_tick
Date: Mon, 11 Jun 2012 18:53:20 +0200
Message-Id: <1339433602-26836-4-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1339433602-26836-1-git-send-email-fweisbec@gmail.com>
References: <1339433602-26836-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that idle and nohz logics are going to be independant each others,
ts->idle_tick becomes too much a biased name to describe the field that
saves the last scheduled tick on top of which we re-calculate the next
tick to schedule when the timer is restarted.

We want to reuse this even to stop the tick outside idle cases. So let's
rename it to some more generic name: ts->last_tick.

This changes a bit the timer list stat export so we need to increase its
version.

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
 include/linux/tick.h     |    8 ++++----
 kernel/time/tick-sched.c |    4 ++--
 kernel/time/timer_list.c |    4 ++--
 3 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/include/linux/tick.h b/include/linux/tick.h
index ab8be90..f37fceb 100644
--- a/include/linux/tick.h
+++ b/include/linux/tick.h
@@ -31,10 +31,10 @@ enum tick_nohz_mode {
  * struct tick_sched - sched tick emulation and no idle tick control/stats
  * @sched_timer:	hrtimer to schedule the periodic tick in high
  *			resolution mode
- * @idle_tick:		Store the last idle tick expiry time when the tick
- *			timer is modified for idle sleeps. This is necessary
+ * @last_tick:		Store the last tick expiry time when the tick
+ *			timer is modified for nohz sleeps. This is necessary
  *			to resume the tick timer operation in the timeline
- *			when the CPU returns from idle
+ *			when the CPU returns from nohz sleep.
  * @tick_stopped:	Indicator that the idle tick has been stopped
  * @idle_jiffies:	jiffies at the entry to idle for idle time accounting
  * @idle_calls:		Total number of idle calls
@@ -51,7 +51,7 @@ struct tick_sched {
 	struct hrtimer			sched_timer;
 	unsigned long			check_clocks;
 	enum tick_nohz_mode		nohz_mode;
-	ktime_t				idle_tick;
+	ktime_t				last_tick;
 	int				inidle;
 	int				tick_stopped;
 	unsigned long			idle_jiffies;
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index e9966f7..69ab8d9 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -400,7 +400,7 @@ static void tick_nohz_stop_sched_tick(struct tick_sched *ts, ktime_t now)
 		if (!ts->tick_stopped) {
 			select_nohz_load_balancer(1);
 
-			ts->idle_tick = hrtimer_get_expires(&ts->sched_timer);
+			ts->last_tick = hrtimer_get_expires(&ts->sched_timer);
 			ts->tick_stopped = 1;
 		}
 
@@ -526,7 +526,7 @@ ktime_t tick_nohz_get_sleep_length(void)
 static void tick_nohz_restart(struct tick_sched *ts, ktime_t now)
 {
 	hrtimer_cancel(&ts->sched_timer);
-	hrtimer_set_expires(&ts->sched_timer, ts->idle_tick);
+	hrtimer_set_expires(&ts->sched_timer, ts->last_tick);
 
 	while (1) {
 		/* Forward the time to expire in the future */
diff --git a/kernel/time/timer_list.c b/kernel/time/timer_list.c
index 3258455..af5a7e9 100644
--- a/kernel/time/timer_list.c
+++ b/kernel/time/timer_list.c
@@ -167,7 +167,7 @@ static void print_cpu(struct seq_file *m, int cpu, u64 now)
 	{
 		struct tick_sched *ts = tick_get_tick_sched(cpu);
 		P(nohz_mode);
-		P_ns(idle_tick);
+		P_ns(last_tick);
 		P(tick_stopped);
 		P(idle_jiffies);
 		P(idle_calls);
@@ -259,7 +259,7 @@ static int timer_list_show(struct seq_file *m, void *v)
 	u64 now = ktime_to_ns(ktime_get());
 	int cpu;
 
-	SEQ_printf(m, "Timer List Version: v0.6\n");
+	SEQ_printf(m, "Timer List Version: v0.7\n");
 	SEQ_printf(m, "HRTIMER_MAX_CLOCK_BASES: %d\n", HRTIMER_MAX_CLOCK_BASES);
 	SEQ_printf(m, "now at %Ld nsecs\n", (unsigned long long)now);
 
-- 
1.7.5.4

