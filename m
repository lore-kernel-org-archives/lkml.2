Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754706Ab1CJX6y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 18:58:54 -0500
Received: from kroah.org ([198.145.64.141]:46926 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754649Ab1CJX5d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 18:57:33 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Thu Mar 10 15:55:38 2011
Message-Id: <20110310235538.528076100@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 10 Mar 2011 15:54:31 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Bharata B Rao <bharata@linux.vnet.ibm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>
Subject: [patch 25/29] sched: Fix sched rt group scheduling when hierachy is enabled
In-Reply-To: <20110310235548.GA10103@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Balbir Singh <balbir@linux.vnet.ibm.com>

commit 0c3b9168017cbad2c4af3dd65ec93fe646eeaa62 upstream.

The current sched rt code is broken when it comes to hierarchical
scheduling, this patch fixes two problems

1. It adds redundant enqueuing (harmless) when it finds a queue
   has tasks enqueued, but it has no run time and it is not
   throttled.

2. The most important change is in sched_rt_rq_enqueue/dequeue.
   The code just picks the rt_rq belonging to the current cpu
   on which the period timer runs, the patch fixes it, so that
   the correct rt_se is enqueued/dequeued.

Tested with a simple hierarchy

/c/d, c and d assigned similar runtimes of 50,000 and a while
1 loop runs within "d". Both c and d get throttled, without
the patch, the task just stops running and never runs (depends
on where the sched_rt b/w timer runs). With the patch, the
task is throttled and runs as expected.

[ bharata, suggestions on how to pick the rt_se belong to the
  rt_rq and correct cpu ]

Signed-off-by: Balbir Singh <balbir@linux.vnet.ibm.com>
Acked-by: Bharata B Rao <bharata@linux.vnet.ibm.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <20110303113435.GA2868@balbir.in.ibm.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/sched_rt.c |   14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -199,11 +199,12 @@ static void dequeue_rt_entity(struct sch
 
 static void sched_rt_rq_enqueue(struct rt_rq *rt_rq)
 {
-	int this_cpu = smp_processor_id();
 	struct task_struct *curr = rq_of_rt_rq(rt_rq)->curr;
 	struct sched_rt_entity *rt_se;
 
-	rt_se = rt_rq->tg->rt_se[this_cpu];
+	int cpu = cpu_of(rq_of_rt_rq(rt_rq));
+
+	rt_se = rt_rq->tg->rt_se[cpu];
 
 	if (rt_rq->rt_nr_running) {
 		if (rt_se && !on_rt_rq(rt_se))
@@ -215,10 +216,10 @@ static void sched_rt_rq_enqueue(struct r
 
 static void sched_rt_rq_dequeue(struct rt_rq *rt_rq)
 {
-	int this_cpu = smp_processor_id();
 	struct sched_rt_entity *rt_se;
+	int cpu = cpu_of(rq_of_rt_rq(rt_rq));
 
-	rt_se = rt_rq->tg->rt_se[this_cpu];
+	rt_se = rt_rq->tg->rt_se[cpu];
 
 	if (rt_se && on_rt_rq(rt_se))
 		dequeue_rt_entity(rt_se);
@@ -546,8 +547,11 @@ static int do_sched_rt_period_timer(stru
 			if (rt_rq->rt_time || rt_rq->rt_nr_running)
 				idle = 0;
 			raw_spin_unlock(&rt_rq->rt_runtime_lock);
-		} else if (rt_rq->rt_nr_running)
+		} else if (rt_rq->rt_nr_running) {
 			idle = 0;
+			if (!rt_rq_throttled(rt_rq))
+				enqueue = 1;
+		}
 
 		if (enqueue)
 			sched_rt_rq_enqueue(rt_rq);


