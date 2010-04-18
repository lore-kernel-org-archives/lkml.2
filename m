Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757544Ab0DRTCW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Apr 2010 15:02:22 -0400
Received: from casper.infradead.org ([85.118.1.10]:44616 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753040Ab0DRTCQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Apr 2010 15:02:16 -0400
Date: Sun, 18 Apr 2010 12:01:22 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: Arjan van de Ven <arjan@infradead.org>, akpm@linux-foundation.org,
       mingo@elte.hu, peterz@infradead.org, tglx@linutronix.de,
       davej@redhat.com, cpufreq@vger.kernel.org
Subject: [PATCH 2/7] sched: introduce a function to update the idle
 statistics
Message-ID: <20100418120122.2f577bd8@infradead.org>
In-Reply-To: <20100418115949.7b743898@infradead.org>
References: <20100418115949.7b743898@infradead.org>
Organization: Intel
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.16.6; i586-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 166b7526ccfea8b44626b6023ff5b0a8eb869bb3 Mon Sep 17 00:00:00 2001
From: Arjan van de Ven <arjan@linux.intel.com>
Date: Sun, 18 Apr 2010 10:33:02 -0700
Subject: [PATCH 2/7] sched: introduce a function to update the idle statistics

Currently, two places update the idle statistics (and more to
come later in this series).

This patch creates a helper function for updating these statistics.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
---
 kernel/time/tick-sched.c |   29 +++++++++++++++++++----------
 1 files changed, 19 insertions(+), 10 deletions(-)

diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index 54dc155..ca2211d 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -150,14 +150,25 @@ static void tick_nohz_update_jiffies(ktime_t now)
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
@@ -165,14 +176,12 @@ static void tick_nohz_stop_idle(int cpu, ktime_t now)
 
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
-- 
1.6.2.5

