Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754801Ab0EJFx6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 01:53:58 -0400
Received: from hera.kernel.org ([140.211.167.34]:33833 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754046Ab0EJFx4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 01:53:56 -0400
Date: Mon, 10 May 2010 05:53:27 GMT
From: tip-bot for Arjan van de Ven <arjan@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, arjan@linux.intel.com, riel@redhat.com,
       akpm@linux-foundation.org, tglx@linutronix.de, mingo@elte.hu
Reply-To: riel@redhat.com, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       arjan@linux.intel.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <20100509082403.60072967@infradead.org>
References: <20100509082403.60072967@infradead.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Fold updating of the last_update_time_info into update_ts_time_stats()
Message-ID: <tip-8d63bf949e330588b80d30ca8f0a27a45297a9e9@git.kernel.org>
Git-Commit-ID: 8d63bf949e330588b80d30ca8f0a27a45297a9e9
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 10 May 2010 05:53:27 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8d63bf949e330588b80d30ca8f0a27a45297a9e9
Gitweb:     http://git.kernel.org/tip/8d63bf949e330588b80d30ca8f0a27a45297a9e9
Author:     Arjan van de Ven <arjan@linux.intel.com>
AuthorDate: Sun, 9 May 2010 08:24:03 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 9 May 2010 19:35:26 +0200

sched: Fold updating of the last_update_time_info into update_ts_time_stats()

This patch folds the updating of the last_update_time into the
update_ts_time_stats() function, and updates the callers.

This allows for further cleanups that are done in the next
patch.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Rik van Riel <riel@redhat.com>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: davej@redhat.com
LKML-Reference: <20100509082403.60072967@infradead.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/time/tick-sched.c |   22 +++++++++++-----------
 1 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index f15d18d..e86e1c6 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -153,7 +153,8 @@ static void tick_nohz_update_jiffies(ktime_t now)
 /*
  * Updates the per cpu time idle statistics counters
  */
-static void update_ts_time_stats(struct tick_sched *ts, ktime_t now)
+static void
+update_ts_time_stats(struct tick_sched *ts, ktime_t now, u64 *last_update_time)
 {
 	ktime_t delta;
 
@@ -163,13 +164,19 @@ static void update_ts_time_stats(struct tick_sched *ts, ktime_t now)
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
@@ -181,7 +188,7 @@ static ktime_t tick_nohz_start_idle(struct tick_sched *ts)
 
 	now = ktime_get();
 
-	update_ts_time_stats(ts, now);
+	update_ts_time_stats(ts, now, NULL);
 
 	ts->idle_entrytime = now;
 	ts->idle_active = 1;
@@ -206,18 +213,11 @@ static ktime_t tick_nohz_start_idle(struct tick_sched *ts)
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
