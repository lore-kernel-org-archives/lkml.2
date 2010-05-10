Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754528Ab0EJFxZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 01:53:25 -0400
Received: from hera.kernel.org ([140.211.167.34]:33801 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752059Ab0EJFxV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 01:53:21 -0400
Date: Mon, 10 May 2010 05:52:51 GMT
From: tip-bot for Arjan van de Ven <arjan@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, arjan@linux.intel.com, riel@redhat.com,
       akpm@linux-foundation.org, tglx@linutronix.de, mingo@elte.hu
Reply-To: riel@redhat.com, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       arjan@linux.intel.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <20100509082245.163e67ed@infradead.org>
References: <20100509082245.163e67ed@infradead.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Introduce a function to update the idle statistics
Message-ID: <tip-595aac488b546c7185be7e29c8ae165a588b2a9f@git.kernel.org>
Git-Commit-ID: 595aac488b546c7185be7e29c8ae165a588b2a9f
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 10 May 2010 05:52:51 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  595aac488b546c7185be7e29c8ae165a588b2a9f
Gitweb:     http://git.kernel.org/tip/595aac488b546c7185be7e29c8ae165a588b2a9f
Author:     Arjan van de Ven <arjan@linux.intel.com>
AuthorDate: Sun, 9 May 2010 08:22:45 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 9 May 2010 19:35:25 +0200

sched: Introduce a function to update the idle statistics

Currently, two places update the idle statistics (and more to
come later in this series).

This patch creates a helper function for updating these
statistics.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Rik van Riel <riel@redhat.com>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: davej@redhat.com
LKML-Reference: <20100509082245.163e67ed@infradead.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/time/tick-sched.c |   29 +++++++++++++++++++----------
 1 files changed, 19 insertions(+), 10 deletions(-)

diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index 358822e..59d8762 100644
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
