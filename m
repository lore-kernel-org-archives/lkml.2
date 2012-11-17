Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754068Ab2KQFXe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Nov 2012 00:23:34 -0500
Received: from mail-vb0-f46.google.com ([209.85.212.46]:52942 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751071Ab2KQFXd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Nov 2012 00:23:33 -0500
MIME-Version: 1.0
Date: Sat, 17 Nov 2012 13:23:32 +0800
Message-ID: <CAJd=RBASBZQj+s_M3uUgPn5v+LL-6Rmst1vR1T4eTj29Z5EgVw@mail.gmail.com>
Subject: [PATCH 5/5] balancenuma: no task swap in finding placement
From: Hillf Danton <dhillf@gmail.com>
To: Mel Gorman <mgorman@suse.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Hillf Danton <dhillf@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Node is selected on behalf of given task, but no reason to punish
the currently running tasks on other nodes. That punishment maybe benifit,
who knows. Better if they are treated not in random way.

Signed-off-by: Hillf Danton <dhillf@gmail.com>
---

--- a/kernel/sched/fair.c	Sat Nov 17 12:29:08 2012
+++ b/kernel/sched/fair.c	Sat Nov 17 12:34:52 2012
@@ -872,7 +872,7 @@ static inline unsigned long balancenuma_

 /*
  * Examines all other nodes examining remote tasks to see if there would
- * be fewer remote numa faults if tasks swapped home nodes
+ * be fewer remote numa faults
  */
 static void task_numa_find_placement(struct task_struct *p)
 {
@@ -933,13 +933,6 @@ static void task_numa_find_placement(str
 				continue;
 			}

-			/* Ensure the other task can be swapped */
-			if (!cpumask_test_cpu(this_cpu,
-					      tsk_cpus_allowed(other_task))) {
-				raw_spin_unlock_irq(&rq->lock);
-				continue;
-			}
-
 			/*
 			 * Read the fault statistics. If the remote task is a
 			 * thread in the process then use the task statistics.
@@ -973,8 +966,7 @@ compare_other:
 			this_diff = this_weight - p_weight;

 			/*
-			 * Would swapping the tasks reduce the overall
-			 * cross-node NUMA faults?
+			 * Would nid reduce the overall cross-node NUMA faults?
 			 */
 			if (other_diff > 0 && this_diff > 0) {
 				long weight_diff = other_diff + this_diff;
@@ -995,11 +987,8 @@ compare_other:
 		}
 	}

-	/* Swap the task on the selected target node */
 	if (selected_nid != -1) {
 		sched_setnode(p, selected_nid);
-		if (selected_task)
-			sched_setnode(selected_task, this_nid);
 	}
 }

--
