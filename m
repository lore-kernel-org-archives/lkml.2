Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753157Ab1LULm2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 06:42:28 -0500
Received: from terminus.zytor.com ([198.137.202.10]:33963 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752427Ab1LULmZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 06:42:25 -0500
Date: Wed, 21 Dec 2011 03:41:55 -0800
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Message-ID: <tip-33kevm71m924ok1gpxd720v3@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched:
  Replace all_pinned with a generic flags field
Git-Commit-ID: 5b54b56be5b540a9cb12682c4d0df5454c098a38
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 21 Dec 2011 03:42:01 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5b54b56be5b540a9cb12682c4d0df5454c098a38
Gitweb:     http://git.kernel.org/tip/5b54b56be5b540a9cb12682c4d0df5454c098a38
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Thu, 22 Sep 2011 15:23:13 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 21 Dec 2011 10:34:45 +0100

sched: Replace all_pinned with a generic flags field

Replace the all_pinned argument with a flags field so that we can add
some extra controls throughout that entire call chain.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/n/tip-33kevm71m924ok1gpxd720v3@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched/fair.c |   35 +++++++++++++++++++----------------
 1 files changed, 19 insertions(+), 16 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 2237ffe..be47ce6 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -3131,13 +3131,15 @@ task_hot(struct task_struct *p, u64 now, struct sched_domain *sd)
 	return delta < (s64)sysctl_sched_migration_cost;
 }
 
+#define LBF_ALL_PINNED	0x01
+
 /*
  * can_migrate_task - may task p from runqueue rq be migrated to this_cpu?
  */
 static
 int can_migrate_task(struct task_struct *p, struct rq *rq, int this_cpu,
 		     struct sched_domain *sd, enum cpu_idle_type idle,
-		     int *all_pinned)
+		     int *lb_flags)
 {
 	int tsk_cache_hot = 0;
 	/*
@@ -3150,7 +3152,7 @@ int can_migrate_task(struct task_struct *p, struct rq *rq, int this_cpu,
 		schedstat_inc(p, se.statistics.nr_failed_migrations_affine);
 		return 0;
 	}
-	*all_pinned = 0;
+	*lb_flags &= ~LBF_ALL_PINNED;
 
 	if (task_running(rq, p)) {
 		schedstat_inc(p, se.statistics.nr_failed_migrations_running);
@@ -3224,7 +3226,7 @@ move_one_task(struct rq *this_rq, int this_cpu, struct rq *busiest,
 static unsigned long
 balance_tasks(struct rq *this_rq, int this_cpu, struct rq *busiest,
 	      unsigned long max_load_move, struct sched_domain *sd,
-	      enum cpu_idle_type idle, int *all_pinned,
+	      enum cpu_idle_type idle, int *lb_flags,
 	      struct cfs_rq *busiest_cfs_rq)
 {
 	int loops = 0, pulled = 0;
@@ -3240,7 +3242,7 @@ balance_tasks(struct rq *this_rq, int this_cpu, struct rq *busiest,
 
 		if ((p->se.load.weight >> 1) > rem_load_move ||
 		    !can_migrate_task(p, busiest, this_cpu, sd, idle,
-				      all_pinned))
+				      lb_flags))
 			continue;
 
 		pull_task(busiest, p, this_rq, this_cpu);
@@ -3359,7 +3361,7 @@ static unsigned long
 load_balance_fair(struct rq *this_rq, int this_cpu, struct rq *busiest,
 		  unsigned long max_load_move,
 		  struct sched_domain *sd, enum cpu_idle_type idle,
-		  int *all_pinned)
+		  int *lb_flags)
 {
 	long rem_load_move = max_load_move;
 	struct cfs_rq *busiest_cfs_rq;
@@ -3383,7 +3385,7 @@ load_balance_fair(struct rq *this_rq, int this_cpu, struct rq *busiest,
 		rem_load = div_u64(rem_load, busiest_h_load + 1);
 
 		moved_load = balance_tasks(this_rq, this_cpu, busiest,
-				rem_load, sd, idle, all_pinned,
+				rem_load, sd, idle, lb_flags,
 				busiest_cfs_rq);
 
 		if (!moved_load)
@@ -3409,10 +3411,10 @@ static unsigned long
 load_balance_fair(struct rq *this_rq, int this_cpu, struct rq *busiest,
 		  unsigned long max_load_move,
 		  struct sched_domain *sd, enum cpu_idle_type idle,
-		  int *all_pinned)
+		  int *lb_flags)
 {
 	return balance_tasks(this_rq, this_cpu, busiest,
-			max_load_move, sd, idle, all_pinned,
+			max_load_move, sd, idle, lb_flags,
 			&busiest->cfs);
 }
 #endif
@@ -3427,14 +3429,14 @@ load_balance_fair(struct rq *this_rq, int this_cpu, struct rq *busiest,
 static int move_tasks(struct rq *this_rq, int this_cpu, struct rq *busiest,
 		      unsigned long max_load_move,
 		      struct sched_domain *sd, enum cpu_idle_type idle,
-		      int *all_pinned)
+		      int *lb_flags)
 {
 	unsigned long total_load_moved = 0, load_moved;
 
 	do {
 		load_moved = load_balance_fair(this_rq, this_cpu, busiest,
 				max_load_move - total_load_moved,
-				sd, idle, all_pinned);
+				sd, idle, lb_flags);
 
 		total_load_moved += load_moved;
 
@@ -4439,7 +4441,7 @@ static int load_balance(int this_cpu, struct rq *this_rq,
 			struct sched_domain *sd, enum cpu_idle_type idle,
 			int *balance)
 {
-	int ld_moved, all_pinned = 0, active_balance = 0;
+	int ld_moved, lb_flags = 0, active_balance = 0;
 	struct sched_group *group;
 	unsigned long imbalance;
 	struct rq *busiest;
@@ -4480,11 +4482,11 @@ redo:
 		 * still unbalanced. ld_moved simply stays zero, so it is
 		 * correctly treated as an imbalance.
 		 */
-		all_pinned = 1;
+		lb_flags |= LBF_ALL_PINNED;
 		local_irq_save(flags);
 		double_rq_lock(this_rq, busiest);
 		ld_moved = move_tasks(this_rq, this_cpu, busiest,
-				      imbalance, sd, idle, &all_pinned);
+				      imbalance, sd, idle, &lb_flags);
 		double_rq_unlock(this_rq, busiest);
 		local_irq_restore(flags);
 
@@ -4495,7 +4497,7 @@ redo:
 			resched_cpu(this_cpu);
 
 		/* All tasks on this runqueue were pinned by CPU affinity */
-		if (unlikely(all_pinned)) {
+		if (unlikely(lb_flags & LBF_ALL_PINNED)) {
 			cpumask_clear_cpu(cpu_of(busiest), cpus);
 			if (!cpumask_empty(cpus))
 				goto redo;
@@ -4525,7 +4527,7 @@ redo:
 					tsk_cpus_allowed(busiest->curr))) {
 				raw_spin_unlock_irqrestore(&busiest->lock,
 							    flags);
-				all_pinned = 1;
+				lb_flags |= LBF_ALL_PINNED;
 				goto out_one_pinned;
 			}
 
@@ -4578,7 +4580,8 @@ out_balanced:
 
 out_one_pinned:
 	/* tune up the balancing interval */
-	if ((all_pinned && sd->balance_interval < MAX_PINNED_INTERVAL) ||
+	if (((lb_flags & LBF_ALL_PINNED) &&
+			sd->balance_interval < MAX_PINNED_INTERVAL) ||
 			(sd->balance_interval < sd->max_interval))
 		sd->balance_interval *= 2;
 
