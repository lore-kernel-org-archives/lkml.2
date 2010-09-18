Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756400Ab0IRTCs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Sep 2010 15:02:48 -0400
Received: from kroah.org ([198.145.64.141]:51703 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754632Ab0IRTCK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Sep 2010 15:02:10 -0400
X-Mailbox-Line: From gregkh@clark.site Sat Sep 18 12:00:00 2010
Message-Id: <20100918190000.518403525@clark.site>
User-Agent: quilt/0.48-11.2
Date: Sat, 18 Sep 2010 11:58:54 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Greg KH <greg@kroah.com>, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>, Mike Galbraith <efault@gmx.de>
Subject: [090/123] sched: Implement head queueing for sched_rt
References: <20100918185724.290702750@clark.site>
Content-Disposition: inline; filename=sched-implement-head-queueing-for-sched_rt.patch
In-Reply-To: <20100918190024.GA14388@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

commit 37dad3fce97f01e5149d69de0833d8452c0e862e upstream

The ability of enqueueing a task to the head of a SCHED_FIFO priority
list is required to fix some violations of POSIX scheduling policy.

Implement the functionality in sched_rt.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Peter Zijlstra <peterz@infradead.org>
Tested-by: Carsten Emde <cbe@osadl.org>
Tested-by: Mathias Weber <mathias.weber.mw1@roche.com>
LKML-Reference: <20100120171629.772169931@linutronix.de>
Signed-off-by: Mike Galbraith <efault@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 kernel/sched_rt.c |   19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -194,7 +194,7 @@ static inline struct rt_rq *group_rt_rq(
 	return rt_se->my_q;
 }
 
-static void enqueue_rt_entity(struct sched_rt_entity *rt_se);
+static void enqueue_rt_entity(struct sched_rt_entity *rt_se, bool head);
 static void dequeue_rt_entity(struct sched_rt_entity *rt_se);
 
 static void sched_rt_rq_enqueue(struct rt_rq *rt_rq)
@@ -204,7 +204,7 @@ static void sched_rt_rq_enqueue(struct r
 
 	if (rt_rq->rt_nr_running) {
 		if (rt_se && !on_rt_rq(rt_se))
-			enqueue_rt_entity(rt_se);
+			enqueue_rt_entity(rt_se, false);
 		if (rt_rq->highest_prio.curr < curr->prio)
 			resched_task(curr);
 	}
@@ -803,7 +803,7 @@ void dec_rt_tasks(struct sched_rt_entity
 	dec_rt_group(rt_se, rt_rq);
 }
 
-static void __enqueue_rt_entity(struct sched_rt_entity *rt_se)
+static void __enqueue_rt_entity(struct sched_rt_entity *rt_se, bool head)
 {
 	struct rt_rq *rt_rq = rt_rq_of_se(rt_se);
 	struct rt_prio_array *array = &rt_rq->active;
@@ -819,7 +819,10 @@ static void __enqueue_rt_entity(struct s
 	if (group_rq && (rt_rq_throttled(group_rq) || !group_rq->rt_nr_running))
 		return;
 
-	list_add_tail(&rt_se->run_list, queue);
+	if (head)
+		list_add(&rt_se->run_list, queue);
+	else
+		list_add_tail(&rt_se->run_list, queue);
 	__set_bit(rt_se_prio(rt_se), array->bitmap);
 
 	inc_rt_tasks(rt_se, rt_rq);
@@ -856,11 +859,11 @@ static void dequeue_rt_stack(struct sche
 	}
 }
 
-static void enqueue_rt_entity(struct sched_rt_entity *rt_se)
+static void enqueue_rt_entity(struct sched_rt_entity *rt_se, bool head)
 {
 	dequeue_rt_stack(rt_se);
 	for_each_sched_rt_entity(rt_se)
-		__enqueue_rt_entity(rt_se);
+		__enqueue_rt_entity(rt_se, head);
 }
 
 static void dequeue_rt_entity(struct sched_rt_entity *rt_se)
@@ -871,7 +874,7 @@ static void dequeue_rt_entity(struct sch
 		struct rt_rq *rt_rq = group_rt_rq(rt_se);
 
 		if (rt_rq && rt_rq->rt_nr_running)
-			__enqueue_rt_entity(rt_se);
+			__enqueue_rt_entity(rt_se, false);
 	}
 }
 
@@ -886,7 +889,7 @@ enqueue_task_rt(struct rq *rq, struct ta
 	if (wakeup)
 		rt_se->timeout = 0;
 
-	enqueue_rt_entity(rt_se);
+	enqueue_rt_entity(rt_se, head);
 
 	if (!task_current(rq, p) && p->rt.nr_cpus_allowed > 1)
 		enqueue_pushable_task(rq, p);


