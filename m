Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753884Ab0EIPYZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 May 2010 11:24:25 -0400
Received: from casper.infradead.org ([85.118.1.10]:40365 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753431Ab0EIPYT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 May 2010 11:24:19 -0400
Date: Sun, 9 May 2010 08:22:45 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, davej@redhat.com
Subject: [PATCH v2  2/8] sched: Introduce a function to update the idle
 statistics
Message-ID: <20100509082245.163e67ed@infradead.org>
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

Currently, two places update the idle statistics (and more to
come later in this series).

This patch creates a helper function for updating these statistics.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Rik van Riel <riel@redhat.com>

---

 kernel/time/tick-sched.c |   29 +++++++++++++++++++----------
 1 file changed, 19 insertions(+), 10 deletions(-)

diff -puN kernel/time/tick-sched.c~sched-introduce-a-function-to-update-the-idle-statistics kernel/time/tick-sched.c
--- a/kernel/time/tick-sched.c~sched-introduce-a-function-to-update-the-idle-statistics
+++ a/kernel/time/tick-sched.c
@@ -150,14 +150,25 @@ static void tick_nohz_update_jiffies(kti
 	touch_softlockup_watchdog();
 }
 
-static void tick_nohz_stop_idle(int cpu, ktime_t now)
+/*
+ * Updates the per cpu time idle statistics counters
+ */
+static void update_ts_time_stats(struct tick_sched *ts, ktime_t now)
 {
-	struct tick_sched *ts = &per_cpu(tick_cpu_sched, cpu);
 	ktime_t delta;
 
-	delta = ktime_sub(now, ts->idle_entrytime);
 	ts->idle_lastupdate = now;
-	ts->idle_sleeptime = ktime_add(ts->idle_sleeptime, delta);
+	if (ts->idle_active) {
+		delta = ktime_sub(now, ts->idle_entrytime);
+		ts->idle_sleeptime = ktime_add(ts->idle_sleeptime, delta);
+	}
+}
+
+static void tick_nohz_stop_idle(int cpu, ktime_t now)
+{
+	struct tick_sched *ts = &per_cpu(tick_cpu_sched, cpu);
+
+	update_ts_time_stats(ts, now);
 	ts->idle_active = 0;
 
 	sched_clock_idle_wakeup_event(0);
@@ -165,14 +176,12 @@ static void tick_nohz_stop_idle(int cpu,
 
 static ktime_t tick_nohz_start_idle(struct tick_sched *ts)
 {
-	ktime_t now, delta;
+	ktime_t now;
 
 	now = ktime_get();
-	if (ts->idle_active) {
-		delta = ktime_sub(now, ts->idle_entrytime);
-		ts->idle_lastupdate = now;
-		ts->idle_sleeptime = ktime_add(ts->idle_sleeptime, delta);
-	}
+
+	update_ts_time_stats(ts, now);
+
 	ts->idle_entrytime = now;
 	ts->idle_active = 1;
 	sched_clock_idle_sleep_event();
_
