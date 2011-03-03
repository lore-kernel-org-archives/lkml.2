Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757962Ab1CCLen (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 06:34:43 -0500
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:57387 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751919Ab1CCLel (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 06:34:41 -0500
Date: Thu, 3 Mar 2011 17:04:35 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <pzijlstr@redhat.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Bharata B Rao <bharata.rao@in.ibm.com>
Subject: [BUGFIX][PATCH] Fix sched rt group scheduling when hierachy is
 enabled
Message-ID: <20110303113435.GA2868@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix hierarchical scheduling in sched rt group

From: Balbir Singh <balbir@linux.vnet.ibm.com>

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

[bharata, suggestions on how to pick the rt_se belong to the rt_rq
and correct cpu]

Signed-off-by: Balbir Singh <balbir@linux.vnet.ibm.com>
Signed-off-by: Bharata B Rao <bharata@linux.vnet.ibm.com>
---
 kernel/sched_rt.c |   14 +++++++++-----
 1 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
index ad62677..01f75a5 100644
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -210,11 +210,12 @@ static void dequeue_rt_entity(struct sched_rt_entity *rt_se);
 
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
@@ -226,10 +227,10 @@ static void sched_rt_rq_enqueue(struct rt_rq *rt_rq)
 
 static void sched_rt_rq_dequeue(struct rt_rq *rt_rq)
 {
-	int this_cpu = smp_processor_id();
 	struct sched_rt_entity *rt_se;
+	int cpu = cpu_of(rq_of_rt_rq(rt_rq));
 
-	rt_se = rt_rq->tg->rt_se[this_cpu];
+	rt_se = rt_rq->tg->rt_se[cpu];
 
 	if (rt_se && on_rt_rq(rt_se))
 		dequeue_rt_entity(rt_se);
@@ -565,8 +566,11 @@ static int do_sched_rt_period_timer(struct rt_bandwidth *rt_b, int overrun)
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

-- 
	Three Cheers,
	Balbir
