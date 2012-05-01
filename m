Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757382Ab2EAS3U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 14:29:20 -0400
Received: from casper.infradead.org ([85.118.1.10]:37667 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754259Ab2EAS2j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 14:28:39 -0400
Message-Id: <20120501182610.803671590@chello.nl>
User-Agent: quilt/0.48-1
Date: Tue, 01 May 2012 20:14:32 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: mingo@kernel.org, pjt@google.com, vatsa@in.ibm.com,
        suresh.b.siddha@intel.com, efault@gmx.de
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [RFC][PATCH 2/5] sched, fair: Add some serialization to the sched_domain load-balance walk
References: <20120501181430.007891123@chello.nl>
Content-Disposition: inline; filename=sched-balance-serialize.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since the sched_domain walk is completely unserialized (!SD_SERIALIZE)
it is possible that multiple cpus in the group get elected to do the
next level. Avoid this by adding some serialization.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 include/linux/sched.h |    1 +
 kernel/sched/core.c   |    2 ++
 kernel/sched/fair.c   |    9 +++++++--
 3 files changed, 10 insertions(+), 2 deletions(-)

--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -927,6 +927,7 @@ struct sched_group_power {
 struct sched_group {
 	struct sched_group *next;	/* Must be a circular list */
 	atomic_t ref;
+	int balance_cpu;
 
 	unsigned int group_weight;
 	struct sched_group_power *sgp;
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -6057,6 +6057,7 @@ build_overlap_sched_groups(struct sched_
 
 		sg->sgp = *per_cpu_ptr(sdd->sgp, cpumask_first(sg_span));
 		atomic_inc(&sg->sgp->ref);
+		sg->balance_cpu = -1;
 
 		if (cpumask_test_cpu(cpu, sg_span))
 			groups = sg;
@@ -6132,6 +6133,7 @@ build_sched_groups(struct sched_domain *
 
 		cpumask_clear(sched_group_cpus(sg));
 		sg->sgp->power = 0;
+		sg->balance_cpu = -1;
 
 		for_each_cpu(j, span) {
 			if (get_group(j, sdd, NULL) != group)
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -3831,7 +3831,8 @@ static inline void update_sg_lb_stats(st
 	 */
 	if (local_group) {
 		if (idle != CPU_NEWLY_IDLE) {
-			if (balance_cpu != this_cpu) {
+			if (balance_cpu != this_cpu ||
+			    cmpxchg(&group->balance_cpu, -1, balance_cpu) != -1) {
 				*balance = 0;
 				return;
 			}
@@ -4933,7 +4934,7 @@ static void rebalance_domains(int cpu, e
 	int balance = 1;
 	struct rq *rq = cpu_rq(cpu);
 	unsigned long interval;
-	struct sched_domain *sd;
+	struct sched_domain *sd, *last = NULL;
 	/* Earliest time when we have to do rebalance again */
 	unsigned long next_balance = jiffies + 60*HZ;
 	int update_next_balance = 0;
@@ -4943,6 +4944,7 @@ static void rebalance_domains(int cpu, e
 
 	rcu_read_lock();
 	for_each_domain(cpu, sd) {
+		last = sd;
 		if (!(sd->flags & SD_LOAD_BALANCE))
 			continue;
 
@@ -4987,6 +4989,9 @@ static void rebalance_domains(int cpu, e
 		if (!balance)
 			break;
 	}
+	for (sd = last; sd; sd = sd->child)
+		(void)cmpxchg(&sd->groups->balance_cpu, cpu, -1);
+
 	rcu_read_unlock();
 
 	/*


