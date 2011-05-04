Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755019Ab1EDTQQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 15:16:16 -0400
Received: from relay.parallels.com ([195.214.232.42]:55014 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751515Ab1EDTQP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 15:16:15 -0400
From: Vladimir Davydov <vdavydov@parallels.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>
CC: <linux-kernel@vger.kernel.org>, Vladimir Davydov <vdavydov@parallels.com>
Subject: [PATCH] sched: fix erroneous sysct_sched_nr_migrate logic
Date: Wed, 4 May 2011 23:15:48 +0400
Message-ID: <1304536548-3052-1-git-send-email-vdavydov@parallels.com>
X-Mailer: git-send-email 1.7.0.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

During load balance, the scheduler must not iterate more than
sysctl_sched_nr_migrate (32 by default) tasks, but at present this limit is held
only for tasks in a task group. That means if there is the only task group in
the system, the scheduler never iterates more than 32 tasks in a single balance
run, but if there are N task groups, it can iterate up to N * 32 tasks. This
patch makes the limit system-wide as it should be.
---
 kernel/sched_fair.c |   35 +++++++++++++++++------------------
 1 files changed, 17 insertions(+), 18 deletions(-)

diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 37f2262..a8fe580 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -2142,9 +2142,9 @@ static unsigned long
 balance_tasks(struct rq *this_rq, int this_cpu, struct rq *busiest,
 	      unsigned long max_load_move, struct sched_domain *sd,
 	      enum cpu_idle_type idle, int *all_pinned,
-	      struct cfs_rq *busiest_cfs_rq)
+	      unsigned int *loops_left, struct cfs_rq *busiest_cfs_rq)
 {
-	int loops = 0, pulled = 0;
+	int pulled = 0;
 	long rem_load_move = max_load_move;
 	struct task_struct *p, *n;
 
@@ -2152,8 +2152,9 @@ balance_tasks(struct rq *this_rq, int this_cpu, struct rq *busiest,
 		goto out;
 
 	list_for_each_entry_safe(p, n, &busiest_cfs_rq->tasks, se.group_node) {
-		if (loops++ > sysctl_sched_nr_migrate)
+		if (!*loops_left)
 			break;
+		--*loops_left;
 
 		if ((p->se.load.weight >> 1) > rem_load_move ||
 		    !can_migrate_task(p, busiest, this_cpu, sd, idle,
@@ -2170,8 +2171,10 @@ balance_tasks(struct rq *this_rq, int this_cpu, struct rq *busiest,
 		 * kernels will stop after the first task is pulled to minimize
 		 * the critical section.
 		 */
-		if (idle == CPU_NEWLY_IDLE)
+		if (idle == CPU_NEWLY_IDLE) {
+			*loops_left = 0;
 			break;
+		}
 #endif
 
 		/*
@@ -2239,7 +2242,7 @@ static unsigned long
 load_balance_fair(struct rq *this_rq, int this_cpu, struct rq *busiest,
 		  unsigned long max_load_move,
 		  struct sched_domain *sd, enum cpu_idle_type idle,
-		  int *all_pinned)
+		  int *all_pinned, unsigned int *loops_left)
 {
 	long rem_load_move = max_load_move;
 	int busiest_cpu = cpu_of(busiest);
@@ -2264,9 +2267,12 @@ load_balance_fair(struct rq *this_rq, int this_cpu, struct rq *busiest,
 		rem_load = div_u64(rem_load, busiest_h_load + 1);
 
 		moved_load = balance_tasks(this_rq, this_cpu, busiest,
-				rem_load, sd, idle, all_pinned,
+				rem_load, sd, idle, all_pinned, loops_left,
 				busiest_cfs_rq);
 
+		if (!*loops_left)
+			break;
+
 		if (!moved_load)
 			continue;
 
@@ -2290,11 +2296,11 @@ static unsigned long
 load_balance_fair(struct rq *this_rq, int this_cpu, struct rq *busiest,
 		  unsigned long max_load_move,
 		  struct sched_domain *sd, enum cpu_idle_type idle,
-		  int *all_pinned)
+		  int *all_pinned, unsigned int *loops_left)
 {
 	return balance_tasks(this_rq, this_cpu, busiest,
 			max_load_move, sd, idle, all_pinned,
-			&busiest->cfs);
+			loops_left, &busiest->cfs);
 }
 #endif
 
@@ -2311,28 +2317,21 @@ static int move_tasks(struct rq *this_rq, int this_cpu, struct rq *busiest,
 		      int *all_pinned)
 {
 	unsigned long total_load_moved = 0, load_moved;
+	unsigned int loops_left = sysctl_sched_nr_migrate;
 
 	do {
 		load_moved = load_balance_fair(this_rq, this_cpu, busiest,
 				max_load_move - total_load_moved,
-				sd, idle, all_pinned);
+				sd, idle, all_pinned, &loops_left);
 
 		total_load_moved += load_moved;
 
 #ifdef CONFIG_PREEMPT
-		/*
-		 * NEWIDLE balancing is a source of latency, so preemptible
-		 * kernels will stop after the first task is pulled to minimize
-		 * the critical section.
-		 */
-		if (idle == CPU_NEWLY_IDLE && this_rq->nr_running)
-			break;
-
 		if (raw_spin_is_contended(&this_rq->lock) ||
 				raw_spin_is_contended(&busiest->lock))
 			break;
 #endif
-	} while (load_moved && max_load_move > total_load_moved);
+	} while (load_moved && max_load_move > total_load_moved && loops_left);
 
 	return total_load_moved > 0;
 }
-- 
1.7.0.4

