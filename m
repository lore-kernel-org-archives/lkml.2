Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753169Ab1LULnI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 06:43:08 -0500
Received: from terminus.zytor.com ([198.137.202.10]:33970 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752427Ab1LULnF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 06:43:05 -0500
Date: Wed, 21 Dec 2011 03:42:41 -0800
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Message-ID: <tip-tsceb6w61q0gakmsccix6xxi@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Fix load-balance lock-breaking
Git-Commit-ID: a195f004e9496b4d99f471bb96e0a0c1af080909
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 21 Dec 2011 03:42:47 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a195f004e9496b4d99f471bb96e0a0c1af080909
Gitweb:     http://git.kernel.org/tip/a195f004e9496b4d99f471bb96e0a0c1af080909
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Thu, 22 Sep 2011 15:30:18 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 21 Dec 2011 10:34:47 +0100

sched: Fix load-balance lock-breaking

The current lock break relies on contention on the rq locks, something
which might never come because we've got IRQs disabled. Or will be
very likely because on anything with more than 2 cpus a synchronized
load-balance pass will very likely cause contention on the rq locks.

Also the sched_nr_migrate thing fails when it gets trapped the loops
of either the cgroup muck in load_balance_fair() or the move_tasks()
load condition.

Instead, use the new lb_flags field to propagate break/abort
conditions for all these loops and create a new loop outside the irq
disabled on the break being required.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/n/tip-tsceb6w61q0gakmsccix6xxi@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched/fair.c |   32 +++++++++++++++++++++++++-------
 1 files changed, 25 insertions(+), 7 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index be47ce6..cea2fa8 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -3132,6 +3132,8 @@ task_hot(struct task_struct *p, u64 now, struct sched_domain *sd)
 }
 
 #define LBF_ALL_PINNED	0x01
+#define LBF_NEED_BREAK	0x02
+#define LBF_ABORT	0x04
 
 /*
  * can_migrate_task - may task p from runqueue rq be migrated to this_cpu?
@@ -3237,8 +3239,10 @@ balance_tasks(struct rq *this_rq, int this_cpu, struct rq *busiest,
 		goto out;
 
 	list_for_each_entry_safe(p, n, &busiest_cfs_rq->tasks, se.group_node) {
-		if (loops++ > sysctl_sched_nr_migrate)
+		if (loops++ > sysctl_sched_nr_migrate) {
+			*lb_flags |= LBF_NEED_BREAK;
 			break;
+		}
 
 		if ((p->se.load.weight >> 1) > rem_load_move ||
 		    !can_migrate_task(p, busiest, this_cpu, sd, idle,
@@ -3255,8 +3259,10 @@ balance_tasks(struct rq *this_rq, int this_cpu, struct rq *busiest,
 		 * kernels will stop after the first task is pulled to minimize
 		 * the critical section.
 		 */
-		if (idle == CPU_NEWLY_IDLE)
+		if (idle == CPU_NEWLY_IDLE) {
+			*lb_flags |= LBF_ABORT;
 			break;
+		}
 #endif
 
 		/*
@@ -3374,6 +3380,9 @@ load_balance_fair(struct rq *this_rq, int this_cpu, struct rq *busiest,
 		unsigned long busiest_weight = busiest_cfs_rq->load.weight;
 		u64 rem_load, moved_load;
 
+		if (*lb_flags & (LBF_NEED_BREAK|LBF_ABORT))
+			break;
+
 		/*
 		 * empty group or part of a throttled hierarchy
 		 */
@@ -3440,18 +3449,19 @@ static int move_tasks(struct rq *this_rq, int this_cpu, struct rq *busiest,
 
 		total_load_moved += load_moved;
 
+		if (*lb_flags & (LBF_NEED_BREAK|LBF_ABORT))
+			break;
+
 #ifdef CONFIG_PREEMPT
 		/*
 		 * NEWIDLE balancing is a source of latency, so preemptible
 		 * kernels will stop after the first task is pulled to minimize
 		 * the critical section.
 		 */
-		if (idle == CPU_NEWLY_IDLE && this_rq->nr_running)
-			break;
-
-		if (raw_spin_is_contended(&this_rq->lock) ||
-				raw_spin_is_contended(&busiest->lock))
+		if (idle == CPU_NEWLY_IDLE && this_rq->nr_running) {
+			*lb_flags |= LBF_ABORT;
 			break;
+		}
 #endif
 	} while (load_moved && max_load_move > total_load_moved);
 
@@ -4496,6 +4506,14 @@ redo:
 		if (ld_moved && this_cpu != smp_processor_id())
 			resched_cpu(this_cpu);
 
+		if (lb_flags & LBF_ABORT)
+			goto out_balanced;
+
+		if (lb_flags & LBF_NEED_BREAK) {
+			lb_flags &= ~LBF_NEED_BREAK;
+			goto redo;
+		}
+
 		/* All tasks on this runqueue were pinned by CPU affinity */
 		if (unlikely(lb_flags & LBF_ALL_PINNED)) {
 			cpumask_clear_cpu(cpu_of(busiest), cpus);
