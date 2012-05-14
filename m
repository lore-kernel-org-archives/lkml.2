Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756715Ab2ENNsP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 09:48:15 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56642 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755679Ab2ENNsN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 09:48:13 -0400
Date: Mon, 14 May 2012 06:48:01 -0700
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Message-ID: <tip-9s7dedozxo8kjsb9kqlrukkf@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/fair: Improve the ->group_imb logic
Git-Commit-ID: e44bc5c5d00ee9b56dd87db47ed827d52948b9fa
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 14 May 2012 06:48:06 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e44bc5c5d00ee9b56dd87db47ed827d52948b9fa
Gitweb:     http://git.kernel.org/tip/e44bc5c5d00ee9b56dd87db47ed827d52948b9fa
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Fri, 11 May 2012 00:22:12 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Mon, 14 May 2012 15:05:28 +0200

sched/fair: Improve the ->group_imb logic

Group imbalance is meant to deal with situations where affinity masks
and sched domains don't align well, such as 3 cpus from one group and
6 from another. In this case the domain based balancer will want to
put an equal amount of tasks on each side even though they don't have
equal cpus.

Currently group_imb is set whenever two cpus of a group have a weight
difference of at least one avg task and the heaviest cpu has at least
two tasks. A group with imbalance set will always be picked as busiest
and a balance pass will be forced.

The problem is that even if there are no affinity masks this stuff can
trigger and cause weird balancing decisions, eg. the observed
behaviour was that of 6 cpus, 5 had 2 and 1 had 3 tasks, due to the
difference of 1 avg load (they all had the same weight) and nr_running
being >1 the group_imbalance logic triggered and did the weird thing
of pulling more load instead of trying to move the 1 excess task to
the other domain of 6 cpus that had 5 cpu with 2 tasks and 1 cpu with
1 task.

Curb the group_imbalance stuff by making the nr_running condition
weaker by also tracking the min_nr_running and using the difference in
nr_running over the set instead of the absolute max nr_running.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/n/tip-9s7dedozxo8kjsb9kqlrukkf@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/fair.c |   20 ++++++++++++++------
 1 files changed, 14 insertions(+), 6 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 124e6b6..0b42f44 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -3775,7 +3775,8 @@ static inline void update_sg_lb_stats(struct lb_env *env,
 			int local_group, const struct cpumask *cpus,
 			int *balance, struct sg_lb_stats *sgs)
 {
-	unsigned long load, max_cpu_load, min_cpu_load, max_nr_running;
+	unsigned long nr_running, max_nr_running, min_nr_running;
+	unsigned long load, max_cpu_load, min_cpu_load;
 	unsigned int balance_cpu = -1, first_idle_cpu = 0;
 	unsigned long avg_load_per_task = 0;
 	int i;
@@ -3787,10 +3788,13 @@ static inline void update_sg_lb_stats(struct lb_env *env,
 	max_cpu_load = 0;
 	min_cpu_load = ~0UL;
 	max_nr_running = 0;
+	min_nr_running = ~0UL;
 
 	for_each_cpu_and(i, sched_group_cpus(group), cpus) {
 		struct rq *rq = cpu_rq(i);
 
+		nr_running = rq->nr_running;
+
 		/* Bias balancing toward cpus of our domain */
 		if (local_group) {
 			if (idle_cpu(i) && !first_idle_cpu) {
@@ -3801,16 +3805,19 @@ static inline void update_sg_lb_stats(struct lb_env *env,
 			load = target_load(i, load_idx);
 		} else {
 			load = source_load(i, load_idx);
-			if (load > max_cpu_load) {
+			if (load > max_cpu_load)
 				max_cpu_load = load;
-				max_nr_running = rq->nr_running;
-			}
 			if (min_cpu_load > load)
 				min_cpu_load = load;
+
+			if (nr_running > max_nr_running)
+				max_nr_running = nr_running;
+			if (min_nr_running > nr_running)
+				min_nr_running = nr_running;
 		}
 
 		sgs->group_load += load;
-		sgs->sum_nr_running += rq->nr_running;
+		sgs->sum_nr_running += nr_running;
 		sgs->sum_weighted_load += weighted_cpuload(i);
 		if (idle_cpu(i))
 			sgs->idle_cpus++;
@@ -3848,7 +3855,8 @@ static inline void update_sg_lb_stats(struct lb_env *env,
 	if (sgs->sum_nr_running)
 		avg_load_per_task = sgs->sum_weighted_load / sgs->sum_nr_running;
 
-	if ((max_cpu_load - min_cpu_load) >= avg_load_per_task && max_nr_running > 1)
+	if ((max_cpu_load - min_cpu_load) >= avg_load_per_task &&
+	    (max_nr_running - min_nr_running) > 1)
 		sgs->group_imb = 1;
 
 	sgs->group_capacity = DIV_ROUND_CLOSEST(group->sgp->power,
