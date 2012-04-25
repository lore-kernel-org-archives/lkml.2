Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757373Ab2DYRnc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 13:43:32 -0400
Received: from merlin.infradead.org ([205.233.59.134]:39105 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757203Ab2DYRna convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 13:43:30 -0400
Message-ID: <1335375798.28150.271.camel@twins>
Subject: Re: load balancing regression since commit 367456c7
From: Peter Zijlstra <peterz@infradead.org>
To: Tim Chen <tim.c.chen@linux.intel.com>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>, Alex Shi <alex.shi@intel.com>,
        Ying <ying.huang@intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Date: Wed, 25 Apr 2012 19:43:18 +0200
In-Reply-To: <1335375537.3796.55.camel@schen9-DESK>
References: <1334106376.19157.89.camel@schen9-DESK>
	 <1334664553.28150.87.camel@twins>  <1334681054.3796.28.camel@schen9-DESK>
	 <1334930421.2463.60.camel@laptop>  <1334940042.3796.48.camel@schen9-DESK>
	 <1334940837.2463.70.camel@laptop>  <1334942012.3796.50.camel@schen9-DESK>
	 <1334943202.2463.71.camel@laptop>  <1335365763.28150.267.camel@twins>
	 <1335375537.3796.55.camel@schen9-DESK>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Gargh.. lost the change to kernel/sched/features.h, now included.

Sorry for that.

---
Subject: sched: Fix more load-balance fallout
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Tue Apr 17 13:38:40 CEST 2012

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
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1335365763.28150.267.camel@twins
---
 kernel/sched/fair.c     |   19 ++++++++++++++-----
 kernel/sched/features.h |    1 +
 2 files changed, 15 insertions(+), 5 deletions(-)

--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -784,7 +784,7 @@ account_entity_enqueue(struct cfs_rq *cf
 		update_load_add(&rq_of(cfs_rq)->load, se->load.weight);
 #ifdef CONFIG_SMP
 	if (entity_is_task(se))
-		list_add_tail(&se->group_node, &rq_of(cfs_rq)->cfs_tasks);
+		list_add(&se->group_node, &rq_of(cfs_rq)->cfs_tasks);
 #endif
 	cfs_rq->nr_running++;
 }
@@ -3215,6 +3215,14 @@ static int move_one_task(struct lb_env *
 
 static unsigned long task_h_load(struct task_struct *p);
 
+static const unsigned int sched_nr_migrate_break =
+#ifdef CONFIG_PREEMPT
+	8
+#else
+	32
+#endif
+	;
+
 /*
  * move_tasks tries to move up to load_move weighted load from busiest to
  * this_rq, as part of a balancing operation within domain "sd".
@@ -3242,7 +3250,7 @@ static int move_tasks(struct lb_env *env
 
 		/* take a breather every nr_migrate tasks */
 		if (env->loop > env->loop_break) {
-			env->loop_break += sysctl_sched_nr_migrate;
+			env->loop_break += sched_nr_migrate_break;
 			env->flags |= LBF_NEED_BREAK;
 			break;
 		}
@@ -3252,7 +3260,7 @@ static int move_tasks(struct lb_env *env
 
 		load = task_h_load(p);
 
-		if (load < 16 && !env->sd->nr_balance_failed)
+		if (sched_feat(LB_MIN) && load < 16 && !env->sd->nr_balance_failed)
 			goto next;
 
 		if ((load / 2) > env->load_move)
@@ -4407,7 +4415,7 @@ static int load_balance(int this_cpu, st
 		.dst_cpu	= this_cpu,
 		.dst_rq		= this_rq,
 		.idle		= idle,
-		.loop_break	= sysctl_sched_nr_migrate,
+		.loop_break	= sched_nr_migrate_break,
 	};
 
 	cpumask_copy(cpus, cpu_active_mask);
@@ -4448,7 +4456,8 @@ static int load_balance(int this_cpu, st
 		env.load_move = imbalance;
 		env.src_cpu = busiest->cpu;
 		env.src_rq = busiest;
-		env.loop_max = busiest->nr_running;
+		env.loop_max = min_t(unsigned long,
+				sysctl_sched_nr_migrate, busiest->nr_running);
 
 more_balance:
 		local_irq_save(flags);
--- a/kernel/sched/features.h
+++ b/kernel/sched/features.h
@@ -68,3 +68,4 @@ SCHED_FEAT(TTWU_QUEUE, true)
 
 SCHED_FEAT(FORCE_SD_OVERLAP, false)
 SCHED_FEAT(RT_RUNTIME_SHARE, true)
+SCHED_FEAT(LB_MIN, false)

