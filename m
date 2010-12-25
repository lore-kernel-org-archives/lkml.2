Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753229Ab0LYA1T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Dec 2010 19:27:19 -0500
Received: from smtp-out.google.com ([74.125.121.67]:34725 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753028Ab0LYA1S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Dec 2010 19:27:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=hXW+xIolTD+Lv8ZkU60JJkRSMJ+NdHi3T5VUbnqDDCuTQ2tZ7dM5c3OCYnmK7zhNAG
         sKZ7OsOfZIeOQRPsn80w==
From: Venkatesh Pallipadi <venki@google.com>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Ranjit Manomohan <ranjitm@google.com>,
        Venkatesh Pallipadi <venki@google.com>
Subject: [PATCH] sched: Buggy comparison in check_preempt_tick
Date: Fri, 24 Dec 2010 16:26:53 -0800
Message-Id: <1293236813-31550-1-git-send-email-venki@google.com>
X-Mailer: git-send-email 1.7.3.1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A preempt comparison line in check_preempt_tick has two bugs.
* It compares signed and unsigned quantities, which breaks when signed
  quantity happens to be negative
* It compares runtime and vruntime, which breaks when there are niced tasks

The bug was initially found by linsched[1]. Change here fixes both
the problems.

On x86-64, the signed unsigned compare results in tasks running _longer_
than their expected time slice as a false resched_task() gets signalled after
4 ticks (on tick after preceding sysctl_sched_min_granularity check) and
currently running task gets picked again and runs for another ideal_slice
interval.

With 2 busy loops on a single CPU and trace_printks inside this buggy check
triggering resched task and in pick_next_task shows this:

 [001]   510.524336: pick_next_task_fair: loop (5939)
 [001]   510.536326: pick_next_task_fair: loop (5883)
 [001]   510.540319: task_tick_fair: delta -4897059, ideal_runtime 11994146
 [001]   510.540321: pick_next_task_fair: loop (5883)
 [001]   510.544306: task_tick_fair: delta -906540, ideal_runtime 11994146
 [001]   510.544309: pick_next_task_fair: loop (5883)
 [001]   510.556306: pick_next_task_fair: loop (5939)
 [001]   510.560301: task_tick_fair: delta -7105824, ideal_runtime 11994146
 [001]   510.560304: pick_next_task_fair: loop (5939)
 [001]   510.564298: task_tick_fair: delta -3105461, ideal_runtime 11994146
 [001]   510.564300: pick_next_task_fair: loop (5939)
 [001]   510.576288: pick_next_task_fair: loop (5883)
 [001]   510.580282: task_tick_fair: delta -4897210, ideal_runtime 11994146
 [001]   510.580285: pick_next_task_fair: loop (5883)
 [001]   510.584278: task_tick_fair: delta -897348, ideal_runtime 11994146
 [001]   510.584281: pick_next_task_fair: loop (5883)
 [001]   510.596269: pick_next_task_fair: loop (5939)

That is 20 ms slice for each task, with some redundant resched_tasks and
with the fix it is expected ~12ms slices (on 16 cpu system).

[1] - http://lwn.net/Articles/409680/

Signed-off-by: Venkatesh Pallipadi <venki@google.com>
---
 kernel/sched_fair.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 00ebd76..fc5ffbd 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -871,8 +871,10 @@ check_preempt_tick(struct cfs_rq *cfs_rq, struct sched_entity *curr)
 	if (cfs_rq->nr_running > 1) {
 		struct sched_entity *se = __pick_next_entity(cfs_rq);
 		s64 delta = curr->vruntime - se->vruntime;
+		unsigned long ideal_vruntime;
 
-		if (delta > ideal_runtime)
+		ideal_vruntime = calc_delta_fair(ideal_runtime, curr);
+		if (delta > (s64)ideal_vruntime)
 			resched_task(rq_of(cfs_rq)->curr);
 	}
 }
-- 
1.7.3.1

