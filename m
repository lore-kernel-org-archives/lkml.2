Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754151Ab0GAHHn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 03:07:43 -0400
Received: from casper.infradead.org ([85.118.1.10]:34983 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754020Ab0GAHHl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 03:07:41 -0400
Subject: [PATCH] sched: Cure nr_iowait_cpu() users
From: Peter Zijlstra <peterz@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
       Arjan van de Ven <arjan@infradead.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Maxim Levitsky <maximlevitsky@gmail.com>,
       Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
       Jiri Slaby <jslaby@suse.cz>, linux-pm@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>
In-Reply-To: <20100630125853.245e6b99.akpm@linux-foundation.org>
References: <20100614140941.GA3581@swordfish.minsk.epam.com>
	 <20100614073853.6fa2f91f@infradead.org>
	 <20100614145439.GA3448@swordfish.minsk.epam.com>
	 <20100614080154.7d6a71fc@infradead.org>
	 <20100614151735.GB3448@swordfish.minsk.epam.com>
	 <20100614204021.52c50cdc@infradead.org> <20100615061927.GA3312@swordfish>
	 <20100615072435.5a47d850@infradead.org>
	 <20100615145029.GB3967@swordfish.minsk.epam.com>
	 <20100615080808.6286448b@infradead.org> <20100617062950.GA3979@swordfish>
	 <1277476773.32034.639.camel@twins>
	 <20100630125853.245e6b99.akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 01 Jul 2010 09:07:17 +0200
Message-ID: <1277968037.1868.120.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With 0224cf4c5e (sched: Intoduce get_cpu_iowait_time_us()) Arjan broke
things by not making sure preemption was indeed disabled by the callers
of nr_iowait_cpu() which took the iowait value of the current cpu.

This resulted in a heap of preempt warnings. Cure this by making
nr_iowait_cpu() take a cpu number and fix up the callers to pass in the
right number.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
Confirmed to work..

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
index a61c08c..1f25798 100644
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
index 71e3dc8..d3c0262 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -2946,9 +2946,9 @@ unsigned long nr_iowait(void)
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
index e0707ea..17525ca 100644
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

