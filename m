Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756663Ab2ENNpn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 09:45:43 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56602 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754881Ab2ENNpl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 09:45:41 -0400
Date: Mon, 14 May 2012 06:45:29 -0700
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Message-ID: <tip-rpuhs5s56aiv1aw7khv9zkw6@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/fair:
  Revert sched-domain iteration breakage
Git-Commit-ID: 04f733b4afac5dc93ae9b0a8703c60b87def491e
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 14 May 2012 06:45:35 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  04f733b4afac5dc93ae9b0a8703c60b87def491e
Gitweb:     http://git.kernel.org/tip/04f733b4afac5dc93ae9b0a8703c60b87def491e
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Fri, 11 May 2012 00:12:02 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Mon, 14 May 2012 15:05:26 +0200

sched/fair: Revert sched-domain iteration breakage

Patches c22402a2f ("sched/fair: Let minimally loaded cpu balance the
group") and 0ce90475 ("sched/fair: Add some serialization to the
sched_domain load-balance walk") are horribly broken so revert them.

The problem is that while it sounds good to have the minimally loaded
cpu do the pulling of more load, the way we walk the domains there is
absolutely no guarantee this cpu will actually get to the domain. In
fact its very likely it wont. Therefore the higher up the tree we get,
the less likely it is we'll balance at all.

The first of mask always walks up, while sucky in that it accumulates
load on the first cpu and needs extra passes to spread it out at least
guarantees a cpu gets up that far and load-balancing happens at all.

Since its now always the first and idle cpus should always be able to
balance so they get a task as fast as possible we can also do away
with the added serialization.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/n/tip-rpuhs5s56aiv1aw7khv9zkw6@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 include/linux/sched.h |    1 -
 kernel/sched/core.c   |    2 --
 kernel/sched/fair.c   |   19 +++++++------------
 3 files changed, 7 insertions(+), 15 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 3cbfb55..4a559bf 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -927,7 +927,6 @@ struct sched_group_power {
 struct sched_group {
 	struct sched_group *next;	/* Must be a circular list */
 	atomic_t ref;
-	int balance_cpu;
 
 	unsigned int group_weight;
 	struct sched_group_power *sgp;
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 0738036..24922b7 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -5976,7 +5976,6 @@ build_overlap_sched_groups(struct sched_domain *sd, int cpu)
 
 		sg->sgp = *per_cpu_ptr(sdd->sgp, cpumask_first(sg_span));
 		atomic_inc(&sg->sgp->ref);
-		sg->balance_cpu = -1;
 
 		if (cpumask_test_cpu(cpu, sg_span))
 			groups = sg;
@@ -6052,7 +6051,6 @@ build_sched_groups(struct sched_domain *sd, int cpu)
 
 		cpumask_clear(sched_group_cpus(sg));
 		sg->sgp->power = 0;
-		sg->balance_cpu = -1;
 
 		for_each_cpu(j, span) {
 			if (get_group(j, sdd, NULL) != group)
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 9bd3366..a259a61 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -3776,8 +3776,7 @@ static inline void update_sg_lb_stats(struct lb_env *env,
 			int *balance, struct sg_lb_stats *sgs)
 {
 	unsigned long load, max_cpu_load, min_cpu_load, max_nr_running;
-	unsigned int balance_cpu = -1;
-	unsigned long balance_load = ~0UL;
+	unsigned int balance_cpu = -1, first_idle_cpu = 0;
 	unsigned long avg_load_per_task = 0;
 	int i;
 
@@ -3794,11 +3793,12 @@ static inline void update_sg_lb_stats(struct lb_env *env,
 
 		/* Bias balancing toward cpus of our domain */
 		if (local_group) {
-			load = target_load(i, load_idx);
-			if (load < balance_load || idle_cpu(i)) {
-				balance_load = load;
+			if (idle_cpu(i) && !first_idle_cpu) {
+				first_idle_cpu = 1;
 				balance_cpu = i;
 			}
+
+			load = target_load(i, load_idx);
 		} else {
 			load = source_load(i, load_idx);
 			if (load > max_cpu_load) {
@@ -3824,8 +3824,7 @@ static inline void update_sg_lb_stats(struct lb_env *env,
 	 */
 	if (local_group) {
 		if (env->idle != CPU_NEWLY_IDLE) {
-			if (balance_cpu != env->dst_cpu ||
-			    cmpxchg(&group->balance_cpu, -1, balance_cpu) != -1) {
+			if (balance_cpu != env->dst_cpu) {
 				*balance = 0;
 				return;
 			}
@@ -4919,7 +4918,7 @@ static void rebalance_domains(int cpu, enum cpu_idle_type idle)
 	int balance = 1;
 	struct rq *rq = cpu_rq(cpu);
 	unsigned long interval;
-	struct sched_domain *sd, *last = NULL;
+	struct sched_domain *sd;
 	/* Earliest time when we have to do rebalance again */
 	unsigned long next_balance = jiffies + 60*HZ;
 	int update_next_balance = 0;
@@ -4929,7 +4928,6 @@ static void rebalance_domains(int cpu, enum cpu_idle_type idle)
 
 	rcu_read_lock();
 	for_each_domain(cpu, sd) {
-		last = sd;
 		if (!(sd->flags & SD_LOAD_BALANCE))
 			continue;
 
@@ -4974,9 +4972,6 @@ out:
 		if (!balance)
 			break;
 	}
-	for (sd = last; sd; sd = sd->child)
-		(void)cmpxchg(&sd->groups->balance_cpu, cpu, -1);
-
 	rcu_read_unlock();
 
 	/*
