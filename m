Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752897Ab0HZSOa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 14:14:30 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:42289 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752096Ab0HZSOX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 14:14:23 -0400
Message-Id: <20100826181339.888097101@efficios.com>
User-Agent: quilt/0.48-1
Date: Thu, 26 Aug 2010 14:09:10 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Tony Lindgren <tony@atomide.com>, Mike Galbraith <efault@gmx.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [RFC PATCH 02/11] sched: debug spread check account for nr_running
References: <20100826180908.648103531@efficios.com>
Content-Disposition: inline; filename=sched-fair-check-spread-with-running.patch
X-Poly-FromMTA: (test.casi.polymtl.ca [132.207.72.60]) at Thu, 26 Aug 2010 18:13:40 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Extracted from a "sched-misc-bits.patch" patch from
Peter Zijlstra <a.p.zijlstra@chello.nl>.

This patch also moves the check_spread test where nr_running is always non-zero.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/sched_fair.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

Index: linux-2.6-lttng.git/kernel/sched_fair.c
===================================================================
--- linux-2.6-lttng.git.orig/kernel/sched_fair.c
+++ linux-2.6-lttng.git/kernel/sched_fair.c
@@ -715,7 +715,7 @@ static void check_spread(struct cfs_rq *
 	if (d < 0)
 		d = -d;
 
-	if (d > 3*sysctl_sched_latency)
+	if (d > 3*cfs_rq->nr_running*sysctl_sched_latency)
 		schedstat_inc(cfs_rq, nr_spread_over);
 #endif
 }
@@ -803,6 +803,7 @@ dequeue_entity(struct cfs_rq *cfs_rq, st
 	 * Update run-time statistics of the 'current'.
 	 */
 	update_curr(cfs_rq);
+	check_spread(cfs_rq, se);
 
 	update_stats_dequeue(cfs_rq, se);
 	if (flags & DEQUEUE_SLEEP) {
@@ -932,11 +933,9 @@ static void put_prev_entity(struct cfs_r
 	 * If still on the runqueue then deactivate_task()
 	 * was not called and update_curr() has to be done:
 	 */
-	if (prev->on_rq)
-		update_curr(cfs_rq);
-
-	check_spread(cfs_rq, prev);
 	if (prev->on_rq) {
+		update_curr(cfs_rq);
+		check_spread(cfs_rq, prev);
 		update_stats_wait_start(cfs_rq, prev);
 		/* Put 'current' back into the tree. */
 		__enqueue_entity(cfs_rq, prev);

