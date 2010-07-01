Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754263Ab0GAIrS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 04:47:18 -0400
Received: from hera.kernel.org ([140.211.167.34]:54469 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751963Ab0GAIrQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 04:47:16 -0400
Date: Thu, 1 Jul 2010 08:45:37 GMT
From: tip-bot for Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, peterz@infradead.org,
       sergey.senozhatsky@gmail.com, maximlevitsky@gmail.com, jslaby@suse.cz,
       pavel@ucw.cz, arjan@infradead.org, tglx@linutronix.de, rjw@sisk.pl,
       mingo@elte.hu, len.brown@intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, peterz@infradead.org,
       sergey.senozhatsky@gmail.com, maximlevitsky@gmail.com, jslaby@suse.cz,
       pavel@ucw.cz, arjan@infradead.org, tglx@linutronix.de, rjw@sisk.pl,
       len.brown@intel.com, mingo@elte.hu
In-Reply-To: <1277968037.1868.120.camel@laptop>
References: <1277968037.1868.120.camel@laptop>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/urgent] sched: Cure nr_iowait_cpu() users
Message-ID: <tip-8c215bd3890c347dfb6a2db4779755f8b9c298a9@git.kernel.org>
Git-Commit-ID: 8c215bd3890c347dfb6a2db4779755f8b9c298a9
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 01 Jul 2010 08:45:58 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8c215bd3890c347dfb6a2db4779755f8b9c298a9
Gitweb:     http://git.kernel.org/tip/8c215bd3890c347dfb6a2db4779755f8b9c298a9
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Thu, 1 Jul 2010 09:07:17 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 1 Jul 2010 09:39:48 +0200

sched: Cure nr_iowait_cpu() users

Commit 0224cf4c5e (sched: Intoduce get_cpu_iowait_time_us())
broke things by not making sure preemption was indeed disabled
by the callers of nr_iowait_cpu() which took the iowait value of
the current cpu.

This resulted in a heap of preempt warnings. Cure this by making
nr_iowait_cpu() take a cpu number and fix up the callers to pass
in the right number.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arjan van de Ven <arjan@infradead.org>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Rafael J. Wysocki <rjw@sisk.pl>
Cc: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: Len Brown <len.brown@intel.com>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: Jiri Slaby <jslaby@suse.cz>
Cc: linux-pm@lists.linux-foundation.org
LKML-Reference: <1277968037.1868.120.camel@laptop>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 drivers/cpuidle/governors/menu.c |    4 ++--
 include/linux/sched.h            |    2 +-
 kernel/sched.c                   |    4 ++--
 kernel/time/tick-sched.c         |   16 ++++++++--------
 4 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/cpuidle/governors/menu.c b/drivers/cpuidle/governors/menu.c
index 52ff8aa..1b12870 100644
--- a/drivers/cpuidle/governors/menu.c
+++ b/drivers/cpuidle/governors/menu.c
@@ -143,7 +143,7 @@ static inline int which_bucket(unsigned int duration)
 	 * This allows us to calculate
 	 * E(duration)|iowait
 	 */
-	if (nr_iowait_cpu())
+	if (nr_iowait_cpu(smp_processor_id()))
 		bucket = BUCKETS/2;
 
 	if (duration < 10)
@@ -175,7 +175,7 @@ static inline int performance_multiplier(void)
 	mult += 2 * get_loadavg();
 
 	/* for IO wait tasks (per cpu!) we add 5x each */
-	mult += 10 * nr_iowait_cpu();
+	mult += 10 * nr_iowait_cpu(smp_processor_id());
 
 	return mult;
 }
diff --git a/include/linux/sched.h b/include/linux/sched.h
index f118809..747fcae 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -139,7 +139,7 @@ extern int nr_processes(void);
 extern unsigned long nr_running(void);
 extern unsigned long nr_uninterruptible(void);
 extern unsigned long nr_iowait(void);
-extern unsigned long nr_iowait_cpu(void);
+extern unsigned long nr_iowait_cpu(int cpu);
 extern unsigned long this_cpu_load(void);
 
 
diff --git a/kernel/sched.c b/kernel/sched.c
index a24d6d5..f87abe3 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -2864,9 +2864,9 @@ unsigned long nr_iowait(void)
 	return sum;
 }
 
-unsigned long nr_iowait_cpu(void)
+unsigned long nr_iowait_cpu(int cpu)
 {
-	struct rq *this = this_rq();
+	struct rq *this = cpu_rq(cpu);
 	return atomic_read(&this->nr_iowait);
 }
 
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index 1d7b9bc..1a6f828 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -154,14 +154,14 @@ static void tick_nohz_update_jiffies(ktime_t now)
  * Updates the per cpu time idle statistics counters
  */
 static void
-update_ts_time_stats(struct tick_sched *ts, ktime_t now, u64 *last_update_time)
+update_ts_time_stats(int cpu, struct tick_sched *ts, ktime_t now, u64 *last_update_time)
 {
 	ktime_t delta;
 
 	if (ts->idle_active) {
 		delta = ktime_sub(now, ts->idle_entrytime);
 		ts->idle_sleeptime = ktime_add(ts->idle_sleeptime, delta);
-		if (nr_iowait_cpu() > 0)
+		if (nr_iowait_cpu(cpu) > 0)
 			ts->iowait_sleeptime = ktime_add(ts->iowait_sleeptime, delta);
 		ts->idle_entrytime = now;
 	}
@@ -175,19 +175,19 @@ static void tick_nohz_stop_idle(int cpu, ktime_t now)
 {
 	struct tick_sched *ts = &per_cpu(tick_cpu_sched, cpu);
 
-	update_ts_time_stats(ts, now, NULL);
+	update_ts_time_stats(cpu, ts, now, NULL);
 	ts->idle_active = 0;
 
 	sched_clock_idle_wakeup_event(0);
 }
 
-static ktime_t tick_nohz_start_idle(struct tick_sched *ts)
+static ktime_t tick_nohz_start_idle(int cpu, struct tick_sched *ts)
 {
 	ktime_t now;
 
 	now = ktime_get();
 
-	update_ts_time_stats(ts, now, NULL);
+	update_ts_time_stats(cpu, ts, now, NULL);
 
 	ts->idle_entrytime = now;
 	ts->idle_active = 1;
@@ -216,7 +216,7 @@ u64 get_cpu_idle_time_us(int cpu, u64 *last_update_time)
 	if (!tick_nohz_enabled)
 		return -1;
 
-	update_ts_time_stats(ts, ktime_get(), last_update_time);
+	update_ts_time_stats(cpu, ts, ktime_get(), last_update_time);
 
 	return ktime_to_us(ts->idle_sleeptime);
 }
@@ -242,7 +242,7 @@ u64 get_cpu_iowait_time_us(int cpu, u64 *last_update_time)
 	if (!tick_nohz_enabled)
 		return -1;
 
-	update_ts_time_stats(ts, ktime_get(), last_update_time);
+	update_ts_time_stats(cpu, ts, ktime_get(), last_update_time);
 
 	return ktime_to_us(ts->iowait_sleeptime);
 }
@@ -284,7 +284,7 @@ void tick_nohz_stop_sched_tick(int inidle)
 	 */
 	ts->inidle = 1;
 
-	now = tick_nohz_start_idle(ts);
+	now = tick_nohz_start_idle(cpu, ts);
 
 	/*
 	 * If this cpu is offline and it is the one which updates
