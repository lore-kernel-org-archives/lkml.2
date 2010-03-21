Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753657Ab0CUWpk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Mar 2010 18:45:40 -0400
Received: from adelie.canonical.com ([91.189.90.139]:51464 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753387Ab0CUWpe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Mar 2010 18:45:34 -0400
From: Chase Douglas <chase.douglas@canonical.com>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 1/1] sched: defer idle accounting till after load update period
Date: Sun, 21 Mar 2010 18:45:24 -0400
Message-Id: <1269211524-29332-2-git-send-email-chase.douglas@canonical.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1269211524-29332-1-git-send-email-chase.douglas@canonical.com>
References: <1269211524-29332-1-git-send-email-chase.douglas@canonical.com>
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
count until after the 10 tick period.

BugLink: http://bugs.launchpad.net/bugs/513848

Signed-off-by: Chase Douglas <chase.douglas@canonical.com>
---
 kernel/sched.c |   16 ++++++++++++++--
 1 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 9ab3cd7..c0aedac 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -3064,7 +3064,8 @@ void calc_global_load(void)
  */
 static void calc_load_account_active(struct rq *this_rq)
 {
-	long nr_active, delta;
+	static atomic_long_t deferred;
+	long nr_active, delta, deferred_delta;
 
 	nr_active = this_rq->nr_running;
 	nr_active += (long) this_rq->nr_uninterruptible;
@@ -3072,6 +3073,17 @@ static void calc_load_account_active(struct rq *this_rq)
 	if (nr_active != this_rq->calc_load_active) {
 		delta = nr_active - this_rq->calc_load_active;
 		this_rq->calc_load_active = nr_active;
+
+		/* Need to defer idle accounting during load update period: */
+		if (unlikely(time_before(jiffies, this_rq->calc_load_update) &&
+			     time_after_eq(jiffies, calc_load_update))) {
+			atomic_long_add(delta, &deferred);
+			return;
+		}
+
+		deferred_delta = atomic_long_xchg(&deferred, 0);
+		delta += deferred_delta;
+
 		atomic_long_add(delta, &calc_load_tasks);
 	}
 }
@@ -3106,8 +3118,8 @@ static void update_cpu_load(struct rq *this_rq)
 	}
 
 	if (time_after_eq(jiffies, this_rq->calc_load_update)) {
-		this_rq->calc_load_update += LOAD_FREQ;
 		calc_load_account_active(this_rq);
+		this_rq->calc_load_update += LOAD_FREQ;
 	}
 }
 
-- 
1.6.3.3

