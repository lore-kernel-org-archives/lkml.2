Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753460Ab1HOP64 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 11:58:56 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:38331 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754098Ab1HOPxF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 11:53:05 -0400
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
Subject: [PATCH 07/32] nohz: Rename ts->idle_tick to ts->last_tick
Date: Mon, 15 Aug 2011 17:52:04 +0200
Message-Id: <1313423549-27093-8-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1313423549-27093-1-git-send-email-fweisbec@gmail.com>
References: <1313423549-27093-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that idle and nohz logic are getting split, idle_tick becomes
a misnomer when it takes a field name to save the last tick before
switching to nohz.

Call it last_tick instead. This changes a bit the timer list
stat export so we need to increase its version.

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
 include/linux/tick.h     |    8 ++++----
 kernel/time/tick-sched.c |    4 ++--
 kernel/time/timer_list.c |    4 ++--
 3 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/include/linux/tick.h b/include/linux/tick.h
index 04f6418..849a0b2 100644
--- a/include/linux/tick.h
+++ b/include/linux/tick.h
@@ -30,10 +30,10 @@ enum tick_nohz_mode {
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
@@ -50,7 +50,7 @@ struct tick_sched {
 	struct hrtimer			sched_timer;
 	unsigned long			check_clocks;
 	enum tick_nohz_mode		nohz_mode;
-	ktime_t				idle_tick;
+	ktime_t				last_tick;
 	int				inidle;
 	int				tick_stopped;
 	unsigned long			idle_jiffies;
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index 21b187c..bca1519 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -382,7 +382,7 @@ static void tick_nohz_stop_sched_tick(ktime_t now)
 		if (!ts->tick_stopped) {
 			select_nohz_load_balancer(1);
 
-			ts->idle_tick = hrtimer_get_expires(&ts->sched_timer);
+			ts->last_tick = hrtimer_get_expires(&ts->sched_timer);
 			ts->tick_stopped = 1;
 		}
 
@@ -468,7 +468,7 @@ ktime_t tick_nohz_get_sleep_length(void)
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

