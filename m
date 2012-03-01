Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757824Ab2CAMRG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 07:17:06 -0500
Received: from terminus.zytor.com ([198.137.202.10]:37477 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756064Ab2CAMRE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 07:17:04 -0500
Date: Thu, 1 Mar 2012 04:15:49 -0800
From: tip-bot for Peter Zijlstra <peterz@infradead.org>
Message-ID: <tip-nuj34q52p6ro7szapuz84i0v@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        peterz@infradead.org, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, tglx@linutronix.de, mingo@elte.hu
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/rt:
  Keep period timer ticking when rt throttling is active
Git-Commit-ID: 42c62a589f1ccbf38a02cb732231f9c2fccc5ab0
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Thu, 01 Mar 2012 04:16:22 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  42c62a589f1ccbf38a02cb732231f9c2fccc5ab0
Gitweb:     http://git.kernel.org/tip/42c62a589f1ccbf38a02cb732231f9c2fccc5ab0
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Tue, 18 Oct 2011 22:03:48 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 1 Mar 2012 10:28:01 +0100

sched/rt: Keep period timer ticking when rt throttling is active

When a runqueue is throttled we cannot disable the period timer
because that timer is the only way to undo the throttling.

We got stale throttling entries when a rq was throttled and then the
global sysctl was disabled, which stopped the timer.

Signed-off-by: Peter Zijlstra <peterz@infradead.org>
[ Added changelog ]
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Link: http://lkml.kernel.org/n/tip-nuj34q52p6ro7szapuz84i0v@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched/rt.c |   13 ++++++++-----
 1 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
index f70206c..6d1eb0b 100644
--- a/kernel/sched/rt.c
+++ b/kernel/sched/rt.c
@@ -778,12 +778,9 @@ static inline int balance_runtime(struct rt_rq *rt_rq)
 
 static int do_sched_rt_period_timer(struct rt_bandwidth *rt_b, int overrun)
 {
-	int i, idle = 1;
+	int i, idle = 1, throttled = 0;
 	const struct cpumask *span;
 
-	if (!rt_bandwidth_enabled() || rt_b->rt_runtime == RUNTIME_INF)
-		return 1;
-
 	span = sched_rt_period_mask();
 	for_each_cpu(i, span) {
 		int enqueue = 0;
@@ -818,12 +815,17 @@ static int do_sched_rt_period_timer(struct rt_bandwidth *rt_b, int overrun)
 			if (!rt_rq_throttled(rt_rq))
 				enqueue = 1;
 		}
+		if (rt_rq->rt_throttled)
+			throttled = 1;
 
 		if (enqueue)
 			sched_rt_rq_enqueue(rt_rq);
 		raw_spin_unlock(&rq->lock);
 	}
 
+	if (!throttled && (!rt_bandwidth_enabled() || rt_b->rt_runtime == RUNTIME_INF))
+		return 1;
+
 	return idle;
 }
 
@@ -884,7 +886,8 @@ static void update_curr_rt(struct rq *rq)
 	if (unlikely((s64)delta_exec < 0))
 		delta_exec = 0;
 
-	schedstat_set(curr->se.statistics.exec_max, max(curr->se.statistics.exec_max, delta_exec));
+	schedstat_set(curr->se.statistics.exec_max,
+		      max(curr->se.statistics.exec_max, delta_exec));
 
 	curr->se.sum_exec_runtime += delta_exec;
 	account_group_exec_runtime(curr, delta_exec);
