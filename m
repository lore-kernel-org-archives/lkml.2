Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753346Ab0DMXT3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 19:19:29 -0400
Received: from adelie.canonical.com ([91.189.90.139]:60471 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752731Ab0DMXT2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 19:19:28 -0400
From: Chase Douglas <chase.douglas@canonical.com>
To: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       kernel-team <kernel-team@lists.ubuntu.com>
Subject: [REGRESSION 2.6.30][PATCH v3] sched: update load count only once per cpu in 10 tick update window
Date: Tue, 13 Apr 2010 16:19:11 -0700
Message-Id: <1271200751-18697-1-git-send-email-chase.douglas@canonical.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There's a period of 10 ticks where calc_load_tasks is updated by all the
cpus for the load avg. Usually all the cpus do this during the first
tick. If any cpus go idle, calc_load_tasks is decremented accordingly.
However, if they wake up calc_load_tasks is not incremented. Thus, if
cpus go idle during the 10 tick period, calc_load_tasks may be
decremented to a non-representative value. This issue can lead to
systems having a load avg of exactly 0, even though the real load avg
could theoretically be up to NR_CPUS.

This change defers calc_load_tasks accounting after each cpu updates the
count until after the 10 tick update window.

A few points:

* A global atomic deferral counter, and not per-cpu vars, is needed
  because a cpu may go NOHZ idle and not be able to update the global
  calc_load_tasks variable for subsequent load calculations.
* It is not enough to add calls to account for the load when a cpu is
  awakened:
  - Load avg calculation must be independent of cpu load.
  - If a cpu is awakend by one tasks, but then has more scheduled before
    the end of the update window, only the first task will be accounted.

BugLink: http://bugs.launchpad.net/bugs/513848

Signed-off-by: Chase Douglas <chase.douglas@canonical.com>
Acked-by: Colin King <colin.king@canonical.com>
Acked-by: Andy Whitcroft <apw@canonical.com>
---
 kernel/sched.c |   24 ++++++++++++++++++++++--
 1 files changed, 22 insertions(+), 2 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index abb36b1..be348cd 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -3010,6 +3010,7 @@ unsigned long this_cpu_load(void)
 
 /* Variables and functions for calc_load */
 static atomic_long_t calc_load_tasks;
+static atomic_long_t calc_load_tasks_deferred;
 static unsigned long calc_load_update;
 unsigned long avenrun[3];
 EXPORT_SYMBOL(avenrun);
@@ -3064,7 +3065,7 @@ void calc_global_load(void)
  */
 static void calc_load_account_active(struct rq *this_rq)
 {
-	long nr_active, delta;
+	long nr_active, delta, deferred;
 
 	nr_active = this_rq->nr_running;
 	nr_active += (long) this_rq->nr_uninterruptible;
@@ -3072,6 +3073,25 @@ static void calc_load_account_active(struct rq *this_rq)
 	if (nr_active != this_rq->calc_load_active) {
 		delta = nr_active - this_rq->calc_load_active;
 		this_rq->calc_load_active = nr_active;
+
+		/*
+		 * Update calc_load_tasks only once per cpu in 10 tick update
+		 * window.
+		 */
+		if (unlikely(time_before(jiffies, this_rq->calc_load_update) &&
+			     time_after_eq(jiffies, calc_load_update))) {
+			if (delta)
+				atomic_long_add(delta,
+						&calc_load_tasks_deferred);
+			return;
+		}
+
+		if (atomic_long_read(&calc_load_tasks_deferred)) {
+			deferred = atomic_long_xchg(&calc_load_tasks_deferred,
+						    0);
+			delta += deferred;
+		}
+
 		atomic_long_add(delta, &calc_load_tasks);
 	}
 }
@@ -3106,8 +3126,8 @@ static void update_cpu_load(struct rq *this_rq)
 	}
 
 	if (time_after_eq(jiffies, this_rq->calc_load_update)) {
-		this_rq->calc_load_update += LOAD_FREQ;
 		calc_load_account_active(this_rq);
+		this_rq->calc_load_update += LOAD_FREQ;
 	}
 }
 
-- 
1.6.3.3

