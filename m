Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759494Ab1CDLtg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 06:49:36 -0500
Received: from hera.kernel.org ([140.211.167.34]:42087 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752113Ab1CDLte (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 06:49:34 -0500
Date: Fri, 4 Mar 2011 11:49:02 GMT
From: tip-bot for Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, balbir@linux.vnet.ibm.com, hpa@zytor.com,
        mingo@redhat.com, bharata@linux.vnet.ibm.com, a.p.zijlstra@chello.nl,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, balbir@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org, bharata@linux.vnet.ibm.com,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20110303113435.GA2868@balbir.in.ibm.com>
References: <20110303113435.GA2868@balbir.in.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Fix sched rt group scheduling when hierachy is enabled
Message-ID: <tip-0c3b9168017cbad2c4af3dd65ec93fe646eeaa62@git.kernel.org>
Git-Commit-ID: 0c3b9168017cbad2c4af3dd65ec93fe646eeaa62
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 04 Mar 2011 11:49:03 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0c3b9168017cbad2c4af3dd65ec93fe646eeaa62
Gitweb:     http://git.kernel.org/tip/0c3b9168017cbad2c4af3dd65ec93fe646eeaa62
Author:     Balbir Singh <balbir@linux.vnet.ibm.com>
AuthorDate: Thu, 3 Mar 2011 17:04:35 +0530
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 4 Mar 2011 11:03:18 +0100

sched: Fix sched rt group scheduling when hierachy is enabled

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
Cc: stable@kernel.org
LKML-Reference: <20110303113435.GA2868@balbir.in.ibm.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
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
