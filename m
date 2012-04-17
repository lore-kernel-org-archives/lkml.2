Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755778Ab2DQLnq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 07:43:46 -0400
Received: from merlin.infradead.org ([205.233.59.134]:53047 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754551Ab2DQLnp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 07:43:45 -0400
Message-ID: <1334663013.28150.83.camel@twins>
Subject: Re: load balancing regression since commit 367456c7
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Tim Chen <tim.c.chen@linux.intel.com>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>, Alex Shi <alex.shi@intel.com>,
        Huang@programming.kicks-ass.net, Ying <ying.huang@intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Date: Tue, 17 Apr 2012 13:43:33 +0200
In-Reply-To: <1334106376.19157.89.camel@schen9-DESK>
References: <1334106376.19157.89.camel@schen9-DESK>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-04-10 at 18:06 -0700, Tim Chen wrote:
> Peter,
> 
> We noticed in a hackbench test (./hackbench 100 process 2000)
> on a Sandy bridge 2 socket server, there has been a slow down
> by a factor of 4 since commit 367456c7 was applied
> (sched: Ditch per cgroup task lists for load-balancing).
> 
> The commit 5d6523e (sched: Fix load-balance wreckage) did
> not fix the regression.
> 
> In the profile, there is heavy spin lock contention in the load_balance path of 3.4-rc2
> where it was less than .003% of cpu before commit 367456c7.

I can't actually reproduce but does the below help? 

If not, can you shoot your .config over?

---
 kernel/sched/fair.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 0d97ebd..e1da5c6 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -3215,6 +3215,8 @@ static int move_one_task(struct lb_env *env)
 
 static unsigned long task_h_load(struct task_struct *p);
 
+static const unsigned int sched_nr_migrate_break = IS_ENABLED(CONFIG_PREEMPT) ? 8 : 32;
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
@@ -4407,7 +4409,8 @@ static int load_balance(int this_cpu, struct rq *this_rq,
 		.dst_cpu	= this_cpu,
 		.dst_rq		= this_rq,
 		.idle		= idle,
-		.loop_break	= sysctl_sched_nr_migrate,
+		.loop_break	= sched_nr_migrate_break,
+		.loop_max	= sysctl_sched_nr_migrate,
 	};
 
 	cpumask_copy(cpus, cpu_active_mask);
@@ -4448,7 +4451,6 @@ static int load_balance(int this_cpu, struct rq *this_rq,
 		env.load_move = imbalance;
 		env.src_cpu = busiest->cpu;
 		env.src_rq = busiest;
-		env.loop_max = busiest->nr_running;
 
 more_balance:
 		local_irq_save(flags);


