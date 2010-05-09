Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754073Ab0EIPYc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 May 2010 11:24:32 -0400
Received: from casper.infradead.org ([85.118.1.10]:40374 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753665Ab0EIPYW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 May 2010 11:24:22 -0400
Date: Sun, 9 May 2010 08:24:03 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, davej@redhat.com
Subject: [PATCH v2  4/8] sched: Fold updating of the last_update_time_info
 into update_ts_time_stats()
Message-ID: <20100509082403.60072967@infradead.org>
In-Reply-To: <20100509082126.4a080d46@infradead.org>
References: <20100509082126.4a080d46@infradead.org>
Organization: Intel
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.16.6; i586-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arjan van de Ven <arjan@linux.intel.com>

This patch folds the updating of the last_update_time into the
update_ts_time_stats() function, and updates the callers.

This allows for further cleanups that are done in the next patch.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Rik van Riel <riel@redhat.com>
---

 kernel/time/tick-sched.c |   22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff -puN kernel/time/tick-sched.c~sched-fold-updating-of-the-last-update-time-into-update_ts_time_stats kernel/time/tick-sched.c
--- a/kernel/time/tick-sched.c~sched-fold-updating-of-the-last-update-time-into-update_ts_time_stats
+++ a/kernel/time/tick-sched.c
@@ -153,7 +153,8 @@ static void tick_nohz_update_jiffies(kti
 /*
  * Updates the per cpu time idle statistics counters
  */
-static void update_ts_time_stats(struct tick_sched *ts, ktime_t now)
+static void
+update_ts_time_stats(struct tick_sched *ts, ktime_t now, u64 *last_update_time)
 {
 	ktime_t delta;
 
@@ -163,13 +164,19 @@ static void update_ts_time_stats(struct 
 		ts->idle_sleeptime = ktime_add(ts->idle_sleeptime, delta);
 		ts->idle_entrytime = now;
 	}
+
+	if (ts->idle_active && last_update_time)
+		*last_update_time = ktime_to_us(ts->idle_lastupdate);
+	else
+		*last_update_time = ktime_to_us(now);
+
 }
 
 static void tick_nohz_stop_idle(int cpu, ktime_t now)
 {
 	struct tick_sched *ts = &per_cpu(tick_cpu_sched, cpu);
 
-	update_ts_time_stats(ts, now);
+	update_ts_time_stats(ts, now, NULL);
 	ts->idle_active = 0;
 
 	sched_clock_idle_wakeup_event(0);
@@ -181,7 +188,7 @@ static ktime_t tick_nohz_start_idle(stru
 
 	now = ktime_get();
 
-	update_ts_time_stats(ts, now);
+	update_ts_time_stats(ts, now, NULL);
 
 	ts->idle_entrytime = now;
 	ts->idle_active = 1;
@@ -206,18 +213,11 @@ static ktime_t tick_nohz_start_idle(stru
 u64 get_cpu_idle_time_us(int cpu, u64 *last_update_time)
 {
 	struct tick_sched *ts = &per_cpu(tick_cpu_sched, cpu);
-	ktime_t now;
 
 	if (!tick_nohz_enabled)
 		return -1;
 
-	now = ktime_get();
-	update_ts_time_stats(ts, now);
-
-	if (ts->idle_active)
-		*last_update_time = ktime_to_us(ts->idle_lastupdate);
-	else
-		*last_update_time = ktime_to_us(now);
+	update_ts_time_stats(ts, ktime_get(), last_update_time);
 
 	return ktime_to_us(ts->idle_sleeptime);
 }
_
