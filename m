Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753878Ab2FSMNm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 08:13:42 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:60005 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751933Ab2FSMNk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 08:13:40 -0400
Message-ID: <4FE06CDB.2060605@linux.vnet.ibm.com>
Date: Tue, 19 Jun 2012 17:43:15 +0530
From: Prashanth Nageshappa <prashanth@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>, mingo@kernel.org,
        LKML <linux-kernel@vger.kernel.org>, roland@kernel.org,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>, efault@gmx.de,
        Ingo Molnar <mingo@elte.hu>
Subject: [PATCH v3] sched: balance_cpu to consider other cpus in its group
 as target of (pinned) task
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12061912-7408-0000-0000-000005FC63F0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>

Current load balance scheme requires only one cpu in a sched_group (balance_cpu)
to look at other peer sched_groups for imbalance and pull tasks towards
itself from a busy cpu. Tasks thus pulled by balance_cpu could later get
picked up by cpus that are in the same sched_group as that of balance_cpu.

This scheme however fails to pull tasks that are not allowed to run on
balance_cpu (but are allowed to run on other cpus in its sched_group).
That can affect fairness and in some worst case scenarios cause starvation.

Consider a two core (2 threads/core) system running tasks as below:

          Core0            Core1
         /     \          /     \
	C0     C1	 C2     C3
        |      |         |      |
        v      v         v      v
	F0     T1        F1     [idle]
			 T2

F0 = SCHED_FIFO task (pinned to C0)
F1 = SCHED_FIFO task (pinned to C2)
T1 = SCHED_OTHER task (pinned to C1)
T2 = SCHED_OTHER task (pinned to C1 and C2)

F1 could become a cpu hog, which will starve T2 unless C1 pulls it. Between C0
and C1 however, C0 is required to look for imbalance between cores, which will
fail to pull T2 towards Core0. T2 will starve eternally in this case. The same
scenario can arise in presence of non-rt tasks as well (say we replace F1 with
high irq load or with a very high priority SCHED_OTHER task that can't move out
of C2).

We tackle this problem by having balance_cpu move pinned tasks to one of its
sibling cpus (where they can run). We first check if load balance goal can be
met by ignoring pinned tasks, failing which we retry move_tasks() with a new
env->dst_cpu.

This patch modifies load balance semantics on who can move load towards a given
cpu in a given sched_domain. Before this patch, a given_cpu or a ilb_cpu acting
on behalf of an idle given_cpu is responsible for moving load to given_cpu.
With this patch applied, balance_cpu can in addition decide on moving some load
to a given_cpu. There is a remote possibility that excess load could get moved
as a result of this (balance_cpu and given_cpu/ilb_cpu deciding *independently*
and at *same* time to move some load to a given_cpu). However we should see
less of such conflicting decisions in practice and moreover subsequent load
balance cycles should correct the excess load moved to given_cpu.


Changes since v2 (https://lkml.org/lkml/2012/6/6/252):
 - updated change log to make it more consise
 - modified comments in the code
 - modified code to remember only one new_dst_cpu per attempt
 - modified code to limit the number of load balance attempts to number of
    cpus in the sched_group

Changes since v1 (https://lkml.org/lkml/2012/6/4/52):

 - updated change log to describe the problem in a more generic sense and
    different soultions considered
 - used cur_ld_moved instead of old_ld_moved
 - modified comments in the code
 - reset env.loop_break before retrying

Signed-off-by: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
Signed-off-by: Prashanth Nageshappa <prashanth@linux.vnet.ibm.com>

---

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 939fd63..cff3659 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -3098,6 +3098,7 @@ static unsigned long __read_mostly max_load_balance_interval = HZ/10;
 
 #define LBF_ALL_PINNED	0x01
 #define LBF_NEED_BREAK	0x02
+#define LBF_SOME_PINNED 0x04
 
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
@@ -3198,9 +3201,31 @@ int can_migrate_task(struct task_struct *p, struct lb_env *env)
 	 * 3) are cache-hot on their current CPU.
 	 */
 	if (!cpumask_test_cpu(env->dst_cpu, tsk_cpus_allowed(p))) {
+		int new_dst_cpu;
+
 		schedstat_inc(p, se.statistics.nr_failed_migrations_affine);
+
+		/*
+		 * Remember if this task can be migrated to any other cpu in
+		 * our sched_group. We may want to revisit it if we couldn't
+		 * meet load balance goals by pulling other tasks on src_cpu.
+		 *
+		 * Also avoid computing new_dst_cpu if we have already computed
+		 * one in current iteration.
+		 */
+		if (!env->dst_grpmask || (env->flags & LBF_SOME_PINNED))
+			return 0;
+
+		new_dst_cpu = cpumask_first_and(env->dst_grpmask,
+						tsk_cpus_allowed(p));
+		if (new_dst_cpu < nr_cpu_ids) {
+			env->flags |= LBF_SOME_PINNED;
+			env->new_dst_cpu = new_dst_cpu;
+		}
 		return 0;
 	}
+
+	/* Record that we found atleast one task that could run on dst_cpu */
 	env->flags &= ~LBF_ALL_PINNED;
 
 	if (task_running(env->src_rq, p)) {
@@ -4440,7 +4465,8 @@ static int load_balance(int this_cpu, struct rq *this_rq,
 			struct sched_domain *sd, enum cpu_idle_type idle,
 			int *balance)
 {
-	int ld_moved, active_balance = 0;
+	int ld_moved, cur_ld_moved, active_balance = 0;
+	int lb_iterations, max_lb_iterations;
 	struct sched_group *group;
 	struct rq *busiest;
 	unsigned long flags;
@@ -4450,12 +4476,14 @@ static int load_balance(int this_cpu, struct rq *this_rq,
 		.sd		    = sd,
 		.dst_cpu	    = this_cpu,
 		.dst_rq		    = this_rq,
+		.dst_grpmask	    = sched_group_cpus(sd->groups),
 		.idle		    = idle,
 		.loop_break	    = sched_nr_migrate_break,
 		.find_busiest_queue = find_busiest_queue,
 	};
 
 	cpumask_copy(cpus, cpu_active_mask);
+	max_lb_iterations = cpumask_weight(env.dst_grpmask);
 
 	schedstat_inc(sd, lb_count[idle]);
 
@@ -4483,6 +4511,7 @@ redo:
 	schedstat_add(sd, lb_imbalance[idle], env.imbalance);
 
 	ld_moved = 0;
+	lb_iterations = 1;
 	if (busiest->nr_running > 1) {
 		/*
 		 * Attempt to move tasks. If find_busiest_group has found
@@ -4502,7 +4531,13 @@ more_balance:
 		double_rq_lock(this_rq, busiest);
 		if (!env.loop)
 			update_h_load(env.src_cpu);
-		ld_moved += move_tasks(&env);
+
+		/*
+		 * cur_ld_moved = load moved in current iteration
+		 * ld_moved = cumulative load moved across iterations
+		 */
+		cur_ld_moved = move_tasks(&env);
+		ld_moved += cur_ld_moved;
 		double_rq_unlock(this_rq, busiest);
 		local_irq_restore(flags);
 
@@ -4514,8 +4549,42 @@ more_balance:
 		/*
 		 * some other cpu did the load balance for us.
 		 */
-		if (ld_moved && this_cpu != smp_processor_id())
-			resched_cpu(this_cpu);
+		if (cur_ld_moved && env.dst_cpu != smp_processor_id())
+			resched_cpu(env.dst_cpu);
+
+		/*
+		 * Revisit (pinned) tasks on src_cpu that couldn't be moved to
+		 * us and move them to an alternate dst_cpu in our sched_group
+		 * where they can run. The upper limit on how many times we
+		 * iterate on same src_cpu is dependent on number of cpus in our
+		 * sched_group.
+		 *
+		 * This changes load balance semantics a bit on who can move
+		 * load to a given_cpu. In addition to the given_cpu itself
+		 * (or a ilb_cpu acting on its behalf where given_cpu is
+		 * nohz-idle), we now have balance_cpu in a position to move
+		 * load to given_cpu. In rare situations, this may cause
+		 * conflicts (balance_cpu and given_cpu/ilb_cpu deciding
+		 * _independently_ and at _same_ time to move some load to
+		 * given_cpu) causing exceess load to be moved to given_cpu.
+		 * This however should not happen so much in practice and
+		 * moreover subsequent load balance cycles should correct the
+		 * excess load moved.
+		 */
+		if ((env.flags & LBF_SOME_PINNED) && env.imbalance > 0 &&
+				lb_iterations++ < max_lb_iterations) {
+			this_rq = cpu_rq(env.new_dst_cpu);
+			env.dst_rq = this_rq;
+			env.dst_cpu = env.new_dst_cpu;
+			env.flags &= ~LBF_SOME_PINNED;
+			env.loop = 0;
+			env.loop_break = sched_nr_migrate_break;
+			/*
+			 * Go back to "more_balance" rather than "redo" since we
+			 * need to continue with same src_cpu.
+			 */
+			goto more_balance;
+		}
 
 		/* All tasks on this runqueue were pinned by CPU affinity */
 		if (unlikely(env.flags & LBF_ALL_PINNED)) {

