Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753603Ab1GUSuD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 14:50:03 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:65394 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753543Ab1GUStw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 14:49:52 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 2/2] nohz: Drop ts->idle_active
Date: Thu, 21 Jul 2011 20:49:37 +0200
Message-Id: <1311274177-23891-2-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1311274177-23891-1-git-send-email-fweisbec@gmail.com>
References: <1311274177-23891-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ts->idle_active is used to know if we want to account the idle sleep
time. But ts->inidle is enough to check that.

So drop that field and use inidle instead. This simplifies the code.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 include/linux/tick.h     |    1 -
 kernel/time/tick-sched.c |   14 ++++++--------
 2 files changed, 6 insertions(+), 9 deletions(-)

diff --git a/include/linux/tick.h b/include/linux/tick.h
index b232ccc..532e650 100644
--- a/include/linux/tick.h
+++ b/include/linux/tick.h
@@ -56,7 +56,6 @@ struct tick_sched {
 	unsigned long			idle_jiffies;
 	unsigned long			idle_calls;
 	unsigned long			idle_sleeps;
-	int				idle_active;
 	ktime_t				idle_entrytime;
 	ktime_t				idle_waketime;
 	ktime_t				idle_exittime;
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index 58e1a96..c4d7113 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -157,7 +157,7 @@ update_ts_time_stats(int cpu, struct tick_sched *ts, ktime_t now, u64 *last_upda
 {
 	ktime_t delta;
 
-	if (ts->idle_active) {
+	if (ts->inidle) {
 		delta = ktime_sub(now, ts->idle_entrytime);
 		ts->idle_sleeptime = ktime_add(ts->idle_sleeptime, delta);
 		if (nr_iowait_cpu(cpu) > 0)
@@ -175,7 +175,6 @@ static void tick_nohz_stop_idle(int cpu, ktime_t now)
 	struct tick_sched *ts = &per_cpu(tick_cpu_sched, cpu);
 
 	update_ts_time_stats(cpu, ts, now, NULL);
-	ts->idle_active = 0;
 
 	sched_clock_idle_wakeup_event(0);
 }
@@ -186,7 +185,6 @@ static ktime_t tick_nohz_start_idle(int cpu, struct tick_sched *ts)
 
 	now = ktime_get();
 	ts->idle_entrytime = now;
-	ts->idle_active = 1;
 	sched_clock_idle_sleep_event();
 	return now;
 }
@@ -502,11 +500,11 @@ void tick_nohz_restart_sched_tick(void)
 	ktime_t now;
 
 	local_irq_disable();
-	if (ts->idle_active || (ts->inidle && ts->tick_stopped))
-		now = ktime_get();
 
-	if (ts->idle_active)
+	if (ts->inidle) {
+		now = ktime_get();
 		tick_nohz_stop_idle(cpu, now);
+	}
 
 	if (!ts->inidle || !ts->tick_stopped) {
 		ts->inidle = 0;
@@ -677,10 +675,10 @@ static inline void tick_check_nohz(int cpu)
 	struct tick_sched *ts = &per_cpu(tick_cpu_sched, cpu);
 	ktime_t now;
 
-	if (!ts->idle_active && !ts->tick_stopped)
+	if (!ts->inidle && !ts->tick_stopped)
 		return;
 	now = ktime_get();
-	if (ts->idle_active)
+	if (ts->inidle)
 		tick_nohz_stop_idle(cpu, now);
 	if (ts->tick_stopped) {
 		tick_nohz_update_jiffies(now);
-- 
1.7.5.4

