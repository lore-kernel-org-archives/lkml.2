Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753111Ab2FFNIB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 09:08:01 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:33922 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752720Ab2FFNH7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 09:07:59 -0400
Message-ID: <4FCF55E3.3020900@linux.vnet.ibm.com>
Date: Wed, 06 Jun 2012 18:36:43 +0530
From: Prashanth Nageshappa <prashanth@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>, mingo@kernel.org,
        LKML <linux-kernel@vger.kernel.org>, roland@kernel.org,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>, efault@gmx.de,
        Ingo Molnar <mingo@elte.hu>
Subject: [PATCH v2] sched: balance_cpu to consider other cpus in its group
 as target of (pinned) task
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12060613-4242-0000-0000-000001E298B8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>

Current load balance scheme lets one cpu in a sched_group (balance_cpu)
look at other peer sched_groups for imbalance and pull tasks to
itself from a busy cpu. Tasks thus pulled to balance_cpu will later get
picked up by cpus that are in the same sched_group as that of balance_cpu.
This scheme fails to pull tasks that are not allowed to run on
balance_cpu (but are allowed to run on other cpus in its sched_group).

This can affect fairness and in some worst case scenarios cause
starvation, as illustrated below. Consider a two core (2 threads/core)
system running tasks as below:

        Core            Core

        C0 - F0         C2 - F1
        C1 - T1         C3 - idle

F0 & F1 are SCHED_FIFO cpu hogs pinned to C0 & C2 respectively, while T1 is
a SCHED_OTHER task pinned to C1. Another SCHED_OTHER task T2 (which can
run on cpus 1,2) now wakes up and lands on its prev_cpu of C2, which is
now running SCHED_FIFO cpu hog. To prevent starvation, T2 needs to move to C1.
However between C0 & C1, C0 is chosen to balance its core with peer cores and
thus fails to pull T2 towards its core (C0 not being in T2's affinity mask). T2 was
found to starve eternally in this case.

Although the problem is illustrated in presence of rt tasks, this is a
general problem that can manifest in presence of non-rt tasks as well.

Some solutions that were considered to solve this problem were:

- Have the right sibling cpus to do load balance ignoring balance_cpu

- Modify move_tasks to move a pinned tasks to a sibling cpu in the
  same sched_group as env->dst_cpu. This will involve some runqueue
  lock juggling (a third runqueue locks needs to be taken when we
  already have two locks held). Moreover we may be just fine to ignore
  that particular task and meet load balance goals by moving other
  tasks.

- Hint that move_tasks should be called with a different env->dst_cpu

This patch implements the 3rd of the above approach, which seemed least
invasive. Essentially can_migrate_task() records if any task(s) were not moved
as the destination cpu was not in the cpus_allowed mask of the target task(s)
and the new destination cpu that task can be moved to. We reissue a call
to move_tasks with that new destination cpu, provided we failed to meet
load balance goal by moving other tasks from env->src_cpu.

Changes since v1 (https://lkml.org/lkml/2012/6/4/52):

 - updated change log to describe the problem in a more generic sense and
    different soultions considered
 - used cur_ld_moved instead of old_ld_moved
 - modified comments in the code
 - reset env.loop_break before retrying


Signed-off-by: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
Signed-off-by: Prashanth Nageshappa <prashanth@linux.vnet.ibm.com>

----

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 939fd63..21a59fc 100644
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
@@ -3198,7 +3201,26 @@ int can_migrate_task(struct task_struct *p, struct lb_env *env)
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
+
+		/*
+		 * remember if this task can be moved to any other cpus in our
+		 * sched_group so that we can retry load balance and move
+		 * that task to a new_dst_cpu if required.
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
@@ -4440,7 +4462,7 @@ static int load_balance(int this_cpu, struct rq *this_rq,
 			struct sched_domain *sd, enum cpu_idle_type idle,
 			int *balance)
 {
-	int ld_moved, active_balance = 0;
+	int ld_moved, cur_ld_moved, active_balance = 0;
 	struct sched_group *group;
 	struct rq *busiest;
 	unsigned long flags;
@@ -4450,6 +4472,7 @@ static int load_balance(int this_cpu, struct rq *this_rq,
 		.sd		    = sd,
 		.dst_cpu	    = this_cpu,
 		.dst_rq		    = this_rq,
+		.dst_grpmask	    = sched_group_cpus(sd->groups),
 		.idle		    = idle,
 		.loop_break	    = sched_nr_migrate_break,
 		.find_busiest_queue = find_busiest_queue,
@@ -4502,7 +4525,8 @@ more_balance:
 		double_rq_lock(this_rq, busiest);
 		if (!env.loop)
 			update_h_load(env.src_cpu);
-		ld_moved += move_tasks(&env);
+		cur_ld_moved = move_tasks(&env);
+		ld_moved += cur_ld_moved;
 		double_rq_unlock(this_rq, busiest);
 		local_irq_restore(flags);
 
@@ -4514,8 +4538,23 @@ more_balance:
 		/*
 		 * some other cpu did the load balance for us.
 		 */
-		if (ld_moved && this_cpu != smp_processor_id())
-			resched_cpu(this_cpu);
+		if (cur_ld_moved && env.dst_cpu != smp_processor_id())
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
+			env.loop_break = sched_nr_migrate_break;
+			goto more_balance;
+		}
 
 		/* All tasks on this runqueue were pinned by CPU affinity */
 		if (unlikely(env.flags & LBF_ALL_PINNED)) {
@@ -4716,6 +4755,7 @@ static int active_load_balance_cpu_stop(void *data)
 			.sd		= sd,
 			.dst_cpu	= target_cpu,
 			.dst_rq		= target_rq,
+			.dst_grpmask	= NULL,
 			.src_cpu	= busiest_rq->cpu,
 			.src_rq		= busiest_rq,
 			.idle		= CPU_IDLE,

