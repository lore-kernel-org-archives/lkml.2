Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756222Ab1C3VxE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 17:53:04 -0400
Received: from mga02.intel.com ([134.134.136.20]:51403 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933352Ab1C3VHL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 17:07:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,270,1299484800"; 
   d="scan'208";a="621236878"
From: Andi Kleen <andi@firstfloor.org>
References: <20110330203.501921634@firstfloor.org>
In-Reply-To: <20110330203.501921634@firstfloor.org>
To: srostedt@redhat.com, rostedt@goodmis.org, a.p.zijlstra@chello.nl,
        ak@linux.intel.com, ghaskins@novell.com, mingo@elte.hu, efault@gmx.de,
        gregkh@suse.de, linux-kernel@vger.kernel.org, stable@kernel.org,
        tim.bird@am.sony.com
Subject: [PATCH] [91/275] sched: Give CPU bound RT tasks preference
Message-Id: <20110330210529.7CCF93E1A05@tassilo.jf.intel.com>
Date: Wed, 30 Mar 2011 14:05:29 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From:: Steven Rostedt <srostedt@redhat.com>

Commit: b3bc211cfe7d5fe94b310480d78e00bea96fbf2a upstream

If a high priority task is waking up on a CPU that is running a
lower priority task that is bound to a CPU, see if we can move the
high RT task to another CPU first. Note, if all other CPUs are
running higher priority tasks than the CPU bounded current task,
then it will be preempted regardless.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
Cc: Gregory Haskins <ghaskins@novell.com>
LKML-Reference: <20100921024138.888922071@goodmis.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Mike Galbraith <efault@gmx.de>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 kernel/sched_rt.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

Index: linux-2.6.35.y/kernel/sched_rt.c
===================================================================
--- linux-2.6.35.y.orig/kernel/sched_rt.c	2011-03-29 23:03:00.009299932 -0700
+++ linux-2.6.35.y/kernel/sched_rt.c	2011-03-29 23:54:59.868470542 -0700
@@ -971,7 +971,8 @@
 	 * For equal prio tasks, we just let the scheduler sort it out.
 	 */
 	if (unlikely(rt_task(rq->curr)) &&
-	    rq->curr->prio < p->prio &&
+	    (rq->curr->rt.nr_cpus_allowed < 2 ||
+	     rq->curr->prio < p->prio) &&
 	    (p->rt.nr_cpus_allowed > 1)) {
 		int cpu = find_lowest_rq(p);
 
@@ -1491,9 +1492,10 @@
 	if (!task_running(rq, p) &&
 	    !test_tsk_need_resched(rq->curr) &&
 	    has_pushable_tasks(rq) &&
+	    p->rt.nr_cpus_allowed > 1 &&
 	    rt_task(rq->curr) &&
-	    rq->curr->prio < p->prio &&
-	    p->rt.nr_cpus_allowed > 1)
+	    (rq->curr->rt.nr_cpus_allowed < 2 ||
+	     rq->curr->prio < p->prio))
 		push_rt_tasks(rq);
 }
 
