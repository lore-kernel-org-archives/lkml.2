Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754984Ab2DZL4X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 07:56:23 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52571 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752111Ab2DZL4V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 07:56:21 -0400
Date: Thu, 26 Apr 2012 04:56:04 -0700
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Message-ID: <tip-eb95308ee2a69403909e111837b9068c64cfc349@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, a.p.zijlstra@chello.nl,
        tim.c.chen@linux.intel.com, akpm@linux-foundation.org,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, a.p.zijlstra@chello.nl,
        torvalds@linux-foundation.org, tim.c.chen@linux.intel.com,
        tglx@linutronix.de
In-Reply-To: <1335365763.28150.267.camel@twins>
References: <1335365763.28150.267.camel@twins>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/urgent] sched: Fix more load-balancing fallout
Git-Commit-ID: eb95308ee2a69403909e111837b9068c64cfc349
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Thu, 26 Apr 2012 04:56:10 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  eb95308ee2a69403909e111837b9068c64cfc349
Gitweb:     http://git.kernel.org/tip/eb95308ee2a69403909e111837b9068c64cfc349
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Tue, 17 Apr 2012 13:38:40 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 26 Apr 2012 12:54:52 +0200

sched: Fix more load-balancing fallout

Commits 367456c756a6 ("sched: Ditch per cgroup task lists for
load-balancing") and 5d6523ebd ("sched: Fix load-balance wreckage")
left some more wreckage.

By setting loop_max unconditionally to ->nr_running load-balancing
could take a lot of time on very long runqueues (hackbench!). So keep
the sysctl as max limit of the amount of tasks we'll iterate.

Furthermore, the min load filter for migration completely fails with
cgroups since inequality in per-cpu state can easily lead to such
small loads :/

Furthermore the change to add new tasks to the tail of the queue
instead of the head seems to have some effect.. not quite sure I
understand why.

Combined these fixes solve the huge hackbench regression reported by
Tim when hackbench is ran in a cgroup.

Reported-by: Tim Chen <tim.c.chen@linux.intel.com>
Acked-by: Tim Chen <tim.c.chen@linux.intel.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Link: http://lkml.kernel.org/r/1335365763.28150.267.camel@twins
[ got rid of the CONFIG_PREEMPT tuning and made small readability edits ]
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/fair.c     |   18 ++++++++++--------
 kernel/sched/features.h |    1 +
 2 files changed, 11 insertions(+), 8 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 0d97ebd..e955364 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -784,7 +784,7 @@ account_entity_enqueue(struct cfs_rq *cfs_rq, struct sched_entity *se)
 		update_load_add(&rq_of(cfs_rq)->load, se->load.weight);
 #ifdef CONFIG_SMP
 	if (entity_is_task(se))
-		list_add_tail(&se->group_node, &rq_of(cfs_rq)->cfs_tasks);
+		list_add(&se->group_node, &rq_of(cfs_rq)->cfs_tasks);
 #endif
 	cfs_rq->nr_running++;
 }
@@ -3215,6 +3215,8 @@ static int move_one_task(struct lb_env *env)
 
 static unsigned long task_h_load(struct task_struct *p);
 
+static const unsigned int sched_nr_migrate_break = 32;
+
 /*
  * move_tasks tries to move up to load_move weighted load from busiest to
  * this_rq, as part of a balancing operation within domain "sd".
@@ -3242,7 +3244,7 @@ static int move_tasks(struct lb_env *env)
 
 		/* take a breather every nr_migrate tasks */
 		if (env->loop > env->loop_break) {
-			env->loop_break += sysctl_sched_nr_migrate;
+			env->loop_break += sched_nr_migrate_break;
 			env->flags |= LBF_NEED_BREAK;
 			break;
 		}
@@ -3252,7 +3254,7 @@ static int move_tasks(struct lb_env *env)
 
 		load = task_h_load(p);
 
-		if (load < 16 && !env->sd->nr_balance_failed)
+		if (sched_feat(LB_MIN) && load < 16 && !env->sd->nr_balance_failed)
 			goto next;
 
 		if ((load / 2) > env->load_move)
@@ -4407,7 +4409,7 @@ static int load_balance(int this_cpu, struct rq *this_rq,
 		.dst_cpu	= this_cpu,
 		.dst_rq		= this_rq,
 		.idle		= idle,
-		.loop_break	= sysctl_sched_nr_migrate,
+		.loop_break	= sched_nr_migrate_break,
 	};
 
 	cpumask_copy(cpus, cpu_active_mask);
@@ -4445,10 +4447,10 @@ redo:
 		 * correctly treated as an imbalance.
 		 */
 		env.flags |= LBF_ALL_PINNED;
-		env.load_move = imbalance;
-		env.src_cpu = busiest->cpu;
-		env.src_rq = busiest;
-		env.loop_max = busiest->nr_running;
+		env.load_move	= imbalance;
+		env.src_cpu	= busiest->cpu;
+		env.src_rq	= busiest;
+		env.loop_max	= min_t(unsigned long, sysctl_sched_nr_migrate, busiest->nr_running);
 
 more_balance:
 		local_irq_save(flags);
diff --git a/kernel/sched/features.h b/kernel/sched/features.h
index e61fd73..de00a48 100644
--- a/kernel/sched/features.h
+++ b/kernel/sched/features.h
@@ -68,3 +68,4 @@ SCHED_FEAT(TTWU_QUEUE, true)
 
 SCHED_FEAT(FORCE_SD_OVERLAP, false)
 SCHED_FEAT(RT_RUNTIME_SHARE, true)
+SCHED_FEAT(LB_MIN, false)
