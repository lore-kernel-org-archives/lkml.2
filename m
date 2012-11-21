Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754734Ab2KUKXM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 05:23:12 -0500
Received: from cantor2.suse.de ([195.135.220.15]:44112 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754713Ab2KUKXJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 05:23:09 -0500
From: Mel Gorman <mgorman@suse.de>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrea Arcangeli <aarcange@redhat.com>, Ingo Molnar <mingo@kernel.org>
Cc: Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Hugh Dickins <hughd@google.com>, Thomas Gleixner <tglx@linutronix.de>,
        Paul Turner <pjt@google.com>,
        Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
        Alex Shi <lkml.alex@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        Mel Gorman <mgorman@suse.de>
Subject: [PATCH 44/46] sched: numa: Consider only one CPU per node for CPU-follows-memory
Date: Wed, 21 Nov 2012 10:21:50 +0000
Message-Id: <1353493312-8069-45-git-send-email-mgorman@suse.de>
X-Mailer: git-send-email 1.7.9.2
In-Reply-To: <1353493312-8069-1-git-send-email-mgorman@suse.de>
References: <1353493312-8069-1-git-send-email-mgorman@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The implementation of CPU follows memory was intended to reflect
the considerations made by autonuma on the basis that it had the
best performance figures at the time of writing. However, a major
criticism was the use of kernel threads and the impact of the
cost of the load balancer paths. As a consequence, the cpu follows
memory algorithm moved to the task_numa_work() path where it would
be incurred directly by the process. Unfortunately, it's still very
heavy, it's just much easier to measure now.

This patch attempts to reduce the cost of the path. Only one CPU
per node is considered for tasks to swap. If there is a task running
on that CPU, the calculations will determine if the system would be
better overall if the tasks were swapped. If the CPU is idle, it
will be checked if running on that node would be better than running
on the current node.

Signed-off-by: Mel Gorman <mgorman@suse.de>
---
 kernel/sched/fair.c |   21 +++++++++++++++++++--
 1 file changed, 19 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 495eed8..2c9300f 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -899,9 +899,18 @@ static void task_numa_find_placement(struct task_struct *p)
 			long this_weight, other_weight, p_weight;
 			long other_diff, this_diff;
 
-			if (!cpu_online(cpu) || idle_cpu(cpu))
+			if (!cpu_online(cpu))
 				continue;
 
+			/* Idle CPU, consider running this task on that node */
+ 			if (idle_cpu(cpu)) {
+				this_weight = balancenuma_task_weight(p, nid);
+				other_weight = 0;
+				other_task = NULL;
+				p_weight = p_task_weight;
+				goto compare_other;
+			}
+
 			/* Racy check if a task is running on the other rq */
 			rq = cpu_rq(cpu);
 			other_mm = rq->curr->mm;
@@ -947,6 +956,7 @@ static void task_numa_find_placement(struct task_struct *p)
 
 			raw_spin_unlock_irq(&rq->lock);
 
+compare_other:
 			/*
 			 * other_diff: How much does the current task perfer to
 			 * run on the remote node thn the task that is
@@ -975,13 +985,20 @@ static void task_numa_find_placement(struct task_struct *p)
 					selected_task = other_task;
 				}
 			}
+
+			/*
+			 * Examine just one task per node. Examing all tasks
+			 * disrupts the system excessively
+			 */
+			break;
 		}
 	}
 
 	/* Swap the task on the selected target node */
 	if (selected_nid != -1 && selected_nid != this_nid) {
 		sched_setnode(p, selected_nid);
-		sched_setnode(selected_task, this_nid);
+		if (selected_task)
+			sched_setnode(selected_task, this_nid);
 	}
 }
 
-- 
1.7.9.2

