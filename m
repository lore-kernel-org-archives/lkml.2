Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755543Ab2FDF5b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 01:57:31 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:60336 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752906Ab2FDF53 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 01:57:29 -0400
Message-ID: <4FCC4E3B.4090209@linux.vnet.ibm.com>
Date: Mon, 04 Jun 2012 11:27:15 +0530
From: Prashanth Nageshappa <prashanth@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>, mingo@kernel.org,
        LKML <linux-kernel@vger.kernel.org>, roland@kernel.org,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>, efault@gmx.de,
        Ingo Molnar <mingo@elte.hu>
Subject: [PATCH] sched: balance_cpu to consider other cpus in its group as
 target of (pinned) task migration
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12060405-5518-0000-0000-000004E40CF1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Based on the description in
http://marc.info/?l=linux-kernel&m=133108682113018&w=2 , I was able to recreate
a problem where in a SCHED_OTHER thread never gets runtime, even though there is
one allowed CPU where it can run and make progress.

On a dual socket box (4 cores per socket, 2 threads per core) with following
config:
0 8	1 9	4 12	5 13
2 10	3 11	6 14	7 15
|__________|    |__________|
 socket 1        socket 2

If we have following 4 tasks (2 SCHED_FIFO and 2 SCHED_OTHER) started in the
following order:
1> SCHED_FIFO cpu hogging task bound to cpu 1
2> SCHED_OTHER cpu hogging task bound to cpus 3 & 9 - running on cpu 3
   sleeps and wakes up after all other tasks are started
3> SCHED_FIFO cpu hogging task bound to cpu 3
4> SCHED_OTHER cpu hogging task bound to cpu 9

Once all the 4 tasks are started, we observe that 2nd task is starved of CPU
after waking up. When it wakes up, it wakes up on its prev_cpu (3) where
a FIFO task is now hogging the cpu. To prevent starvation, 2nd task
needs to be pulled to cpu 9. However, between cpus 1, 9, cpu1 is the chosen
cpu that attempts pulling tasks towards its core. When it tries pulling
2nd tasks towards its core, it is unable to do so as cpu1 is not in 2nd
task's cpus_allowed mask. Ideally cpu1 should note that the task can be
moved to its sibling and trigger that movement.

In this patch, we try to identify if load balancing goal was not achieved
completely because of destination cpu not being in cpus_allowed mask of target
task(s) and retry load balancing to try and move tasks to other cpus in the
same sched_group as that of destination cpu.

Tested on tip commit cca44889.

Signed-off-by: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
Signed-off-by: Prashanth Nageshappa <prashanth@linux.vnet.ibm.com>

----

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index de49ed5..da275d8 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -3098,6 +3098,7 @@ static unsigned long __read_mostly max_load_balance_interval = HZ/10;
 
 #define LBF_ALL_PINNED	0x01
 #define LBF_NEED_BREAK	0x02
+#define LBF_NEW_DST_CPU	0x04
 
 struct lb_env {
 	struct sched_domain	*sd;
@@ -3108,6 +3109,8 @@ struct lb_env {
 	int			dst_cpu;
 	struct rq		*dst_rq;
 
+	struct cpumask		*dst_grpmask;
+	int			new_dst_cpu;
 	enum cpu_idle_type	idle;
 	long			imbalance;
 	unsigned int		flags;
@@ -3198,7 +3201,25 @@ int can_migrate_task(struct task_struct *p, struct lb_env *env)
 	 * 3) are cache-hot on their current CPU.
 	 */
 	if (!cpumask_test_cpu(env->dst_cpu, tsk_cpus_allowed(p))) {
-		schedstat_inc(p, se.statistics.nr_failed_migrations_affine);
+		int new_dst_cpu;
+
+		if (!env->dst_grpmask) {
+			schedstat_inc(p, se.statistics.nr_failed_migrations_affine);
+			return 0;
+		}
+		/*
+		 * check if cpus_allowed has any cpus in the same sched_group
+		 * as that of dst_cpu and set LBF_NEW_DST_CPU and new_dst_cpu
+		 * accordingly
+		 */
+		new_dst_cpu = cpumask_first_and(env->dst_grpmask,
+						tsk_cpus_allowed(p));
+		if (new_dst_cpu >= nr_cpu_ids) {
+			schedstat_inc(p, se.statistics.nr_failed_migrations_affine);
+		} else {
+			env->flags |= LBF_NEW_DST_CPU;
+			env->new_dst_cpu = new_dst_cpu;
+		}
 		return 0;
 	}
 	env->flags &= ~LBF_ALL_PINNED;
@@ -4418,7 +4439,7 @@ static int load_balance(int this_cpu, struct rq *this_rq,
 			struct sched_domain *sd, enum cpu_idle_type idle,
 			int *balance)
 {
-	int ld_moved, active_balance = 0;
+	int ld_moved, old_ld_moved, active_balance = 0;
 	struct sched_group *group;
 	struct rq *busiest;
 	unsigned long flags;
@@ -4428,6 +4449,7 @@ static int load_balance(int this_cpu, struct rq *this_rq,
 		.sd		    = sd,
 		.dst_cpu	    = this_cpu,
 		.dst_rq		    = this_rq,
+		.dst_grpmask	    = sched_group_cpus(sd->groups),
 		.idle		    = idle,
 		.loop_break	    = sched_nr_migrate_break,
 		.find_busiest_queue = find_busiest_queue,
@@ -4461,6 +4483,7 @@ redo:
 	schedstat_add(sd, lb_imbalance[idle], env.imbalance);
 
 	ld_moved = 0;
+	old_ld_moved = 0;
 	if (busiest->nr_running > 1) {
 		/*
 		 * Attempt to move tasks. If find_busiest_group has found
@@ -4488,12 +4511,27 @@ more_balance:
 			env.flags &= ~LBF_NEED_BREAK;
 			goto more_balance;
 		}
-
 		/*
 		 * some other cpu did the load balance for us.
 		 */
-		if (ld_moved && this_cpu != smp_processor_id())
-			resched_cpu(this_cpu);
+		if ((ld_moved != old_ld_moved) &&
+			(env.dst_cpu != smp_processor_id()))
+			resched_cpu(env.dst_cpu);
+
+		if ((env.flags & LBF_NEW_DST_CPU) && (env.imbalance > 0)) {
+			/*
+			 * we could not balance completely as some tasks
+			 * were not allowed to move to the dst_cpu, so try
+			 * again with new_dst_cpu.
+			 */
+			this_rq = cpu_rq(env.new_dst_cpu);
+			env.dst_rq = this_rq;
+			env.dst_cpu = env.new_dst_cpu;
+			env.flags &= ~LBF_NEW_DST_CPU;
+			env.loop = 0;
+			old_ld_moved = ld_moved;
+			goto more_balance;
+		}
 
 		/* All tasks on this runqueue were pinned by CPU affinity */
 		if (unlikely(env.flags & LBF_ALL_PINNED)) {
@@ -4694,6 +4732,7 @@ static int active_load_balance_cpu_stop(void *data)
 			.sd		= sd,
 			.dst_cpu	= target_cpu,
 			.dst_rq		= target_rq,
+			.dst_grpmask	= NULL,
 			.src_cpu	= busiest_rq->cpu,
 			.src_rq		= busiest_rq,
 			.idle		= CPU_IDLE,

