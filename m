Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753459Ab0HZSPw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 14:15:52 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:55259 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753148Ab0HZSOt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 14:14:49 -0400
Message-Id: <20100826181340.580313949@efficios.com>
User-Agent: quilt/0.48-1
Date: Thu, 26 Aug 2010 14:09:13 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Tony Lindgren <tony@atomide.com>, Mike Galbraith <efault@gmx.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [RFC PATCH 05/11] sched buddy enable buddy logic starting at 2 running threads
References: <20100826180908.648103531@efficios.com>
Content-Disposition: inline; filename=sched-buddy-enable-at-2.patch
X-Poly-FromMTA: (test.casi.polymtl.ca [132.207.72.60]) at Thu, 26 Aug 2010 18:13:40 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Extracted from a "sched-misc-bits.patch" patch from
Peter Zijlstra <a.p.zijlstra@chello.nl>.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/sched_fair.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

Index: linux-2.6-lttng.git/kernel/sched_fair.c
===================================================================
--- linux-2.6-lttng.git.orig/kernel/sched_fair.c
+++ linux-2.6-lttng.git/kernel/sched_fair.c
@@ -1647,7 +1647,11 @@ static void check_preempt_wakeup(struct 
 	struct task_struct *curr = rq->curr;
 	struct sched_entity *se = &curr->se, *pse = &p->se;
 	struct cfs_rq *cfs_rq = task_cfs_rq(curr);
-	int scale = cfs_rq->nr_running >= sched_nr_latency;
+	/*
+	 * The buddy logic doesn't work well when there's not actually enough
+	 * tasks for there to be buddies.
+	 */
+	int buddies = (cfs_rq->nr_running >= 2);
 
 	if (unlikely(rt_prio(p->prio)))
 		goto preempt;
@@ -1658,7 +1662,7 @@ static void check_preempt_wakeup(struct 
 	if (unlikely(se == pse))
 		return;
 
-	if (sched_feat(NEXT_BUDDY) && scale && !(wake_flags & WF_FORK))
+	if (sched_feat(NEXT_BUDDY) && buddies && !(wake_flags & WF_FORK))
 		set_next_buddy(pse);
 
 	/*
@@ -1704,7 +1708,7 @@ preempt:
 	if (unlikely(!se->on_rq || curr == rq->idle))
 		return;
 
-	if (sched_feat(LAST_BUDDY) && scale && entity_is_task(se))
+	if (sched_feat(LAST_BUDDY) && buddies && entity_is_task(se))
 		set_last_buddy(se);
 }
 

