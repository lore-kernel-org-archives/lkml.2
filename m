Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757249Ab1DHAYa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 20:24:30 -0400
Received: from smtp-out.google.com ([216.239.44.51]:24572 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755609Ab1DHAY3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 20:24:29 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=to:subject:cc:message-id:date:from:x-system-of-record;
	b=nIrZkJodXuqDdlcCFnu6qthaIJ8vmBAVQuvNn3H+sDVkLVaZDHQBG7fDdZRROpxnL
	v2z5ZMaOMSZ4V60batNuA==
To: a.p.zijlstra@chello.nl, mingo@elte.hu
Subject: Subject: [PATCH] sched: fixed erroneous all_pinned logic.
Cc: linux-kernel@vger.kernel.org
Message-Id: <20110408002420.3F3A912217F@elm.corp.google.com>
Date: Thu,  7 Apr 2011 17:24:20 -0700 (PDT)
From: kenchen@google.com (Ken Chen)
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The scheduler load balancer has specific code to deal with cases of
unbalanced system due to lots of unmovable tasks (for example because
of hard CPU affinity). In those situation, it exclude the busiest CPU
that has pinned tasks for load balance consideration such that it can
perform second 2nd load balance pass on the rest of the system.  This
all works as designed if there is only one cgroup in the system.

However, when we have multiple cgroups, this logic has false positive
and triggers multiple load balance passes despite there are actually
no pinned tasks at all.

The reason it has false positive is that the all pinned logic is deep
in the lowest function of can_migrate_task() and is too low level.
load_balance_fair() iterate each task group and calls balance_tasks()
to migrate target load.  Along the way, balance_tasks() will also set
a all_pinned variable.  Given that task-groups are iterated, this
all_pinned variable is essentially the status of last group in the
scanning process.  Task group can have number of reasons that no load
being migrated, none due to cpu affinity.  However, this status bit
is being propagated back up to the higher level load_balance(), which
incorrectly think that no tasks were moved.  It kick off the all pinned
logic and start multiple passes attempt to move load onto puller CPU.

Moved the all_pinned logic up at the iterator level.  This ensures
that the logic is aggregated over all task-groups, not just the last
one in the list.  The core change is in the move_tasks() function:

+       if (total_load_moved)
+               *all_pinned = 0;

The rest of the patch are code churn that removes parameter passing
in the lower level functions.

Signed-off-by: Ken Chen <kenchen@google.com>
---
 kernel/sched_fair.c |   37 +++++++++++++++----------------------
 1 files changed, 15 insertions(+), 22 deletions(-)

diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index c46568a..2e224e0 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -2016,8 +2016,7 @@ static void pull_task(
  */
 static
 int can_migrate_task(struct task_struct *p, struct rq *rq, int this_cpu,
-		     struct sched_domain *sd, enum cpu_idle_type idle,
-		     int *all_pinned)
+		     struct sched_domain *sd, enum cpu_idle_type idle)
 {
 	int tsk_cache_hot = 0;
 	/*
@@ -2030,7 +2029,6 @@ int can_migrate_task(
 		schedstat_inc(p, se.statistics.nr_failed_migrations_affine);
 		return 0;
 	}
-	*all_pinned = 0;
 
 	if (task_running(rq, p)) {
 		schedstat_inc(p, se.statistics.nr_failed_migrations_running);
@@ -2075,13 +2073,11 @@ move_one_task(
 {
 	struct task_struct *p, *n;
 	struct cfs_rq *cfs_rq;
-	int pinned = 0;
 
 	for_each_leaf_cfs_rq(busiest, cfs_rq) {
 		list_for_each_entry_safe(p, n, &cfs_rq->tasks, se.group_node) {
 
-			if (!can_migrate_task(p, busiest, this_cpu,
-						sd, idle, &pinned))
+			if (!can_migrate_task(p, busiest, this_cpu, sd, idle))
 				continue;
 
 			pull_task(busiest, p, this_rq, this_cpu);
@@ -2101,24 +2097,22 @@ move_one_task(
 static unsigned long
 balance_tasks(struct rq *this_rq, int this_cpu, struct rq *busiest,
 	      unsigned long max_load_move, struct sched_domain *sd,
-	      enum cpu_idle_type idle, int *all_pinned,
-	      int *this_best_prio, struct cfs_rq *busiest_cfs_rq)
+	      enum cpu_idle_type idle, int *this_best_prio,
+	      struct cfs_rq *busiest_cfs_rq)
 {
-	int loops = 0, pulled = 0, pinned = 0;
+	int loops = 0, pulled = 0;
 	long rem_load_move = max_load_move;
 	struct task_struct *p, *n;
 
 	if (max_load_move == 0)
 		goto out;
 
-	pinned = 1;
-
 	list_for_each_entry_safe(p, n, &busiest_cfs_rq->tasks, se.group_node) {
 		if (loops++ > sysctl_sched_nr_migrate)
 			break;
 
 		if ((p->se.load.weight >> 1) > rem_load_move ||
-		    !can_migrate_task(p, busiest, this_cpu, sd, idle, &pinned))
+		    !can_migrate_task(p, busiest, this_cpu, sd, idle))
 			continue;
 
 		pull_task(busiest, p, this_rq, this_cpu);
@@ -2153,9 +2147,6 @@ out:
 	 */
 	schedstat_add(sd, lb_gained[idle], pulled);
 
-	if (all_pinned)
-		*all_pinned = pinned;
-
 	return max_load_move - rem_load_move;
 }
 
@@ -2206,7 +2197,7 @@ static unsigned long
 load_balance_fair(struct rq *this_rq, int this_cpu, struct rq *busiest,
 		  unsigned long max_load_move,
 		  struct sched_domain *sd, enum cpu_idle_type idle,
-		  int *all_pinned, int *this_best_prio)
+		  int *this_best_prio)
 {
 	long rem_load_move = max_load_move;
 	int busiest_cpu = cpu_of(busiest);
@@ -2231,7 +2222,7 @@ load_balance_fair(
 		rem_load = div_u64(rem_load, busiest_h_load + 1);
 
 		moved_load = balance_tasks(this_rq, this_cpu, busiest,
-				rem_load, sd, idle, all_pinned, this_best_prio,
+				rem_load, sd, idle, this_best_prio,
 				busiest_cfs_rq);
 
 		if (!moved_load)
@@ -2257,11 +2248,10 @@ static unsigned long
 load_balance_fair(struct rq *this_rq, int this_cpu, struct rq *busiest,
 		  unsigned long max_load_move,
 		  struct sched_domain *sd, enum cpu_idle_type idle,
-		  int *all_pinned, int *this_best_prio)
+		  int *this_best_prio)
 {
 	return balance_tasks(this_rq, this_cpu, busiest,
-			max_load_move, sd, idle, all_pinned,
-			this_best_prio, &busiest->cfs);
+			max_load_move, sd, idle, this_best_prio, &busiest->cfs);
 }
 #endif
 
@@ -2283,7 +2273,7 @@ static int move_tasks(
 	do {
 		load_moved = load_balance_fair(this_rq, this_cpu, busiest,
 				max_load_move - total_load_moved,
-				sd, idle, all_pinned, &this_best_prio);
+				sd, idle, &this_best_prio);
 
 		total_load_moved += load_moved;
 
@@ -2302,6 +2292,9 @@ static int move_tasks(
 #endif
 	} while (load_moved && max_load_move > total_load_moved);
 
+	if (total_load_moved)
+		*all_pinned = 0;
+
 	return total_load_moved > 0;
 }
 
@@ -3300,7 +3293,7 @@ static int load_balance(
 			struct sched_domain *sd, enum cpu_idle_type idle,
 			int *balance)
 {
-	int ld_moved, all_pinned = 0, active_balance = 0;
+	int ld_moved, all_pinned = 1, active_balance = 0;
 	struct sched_group *group;
 	unsigned long imbalance;
 	struct rq *busiest;
-- 
1.7.3.1

