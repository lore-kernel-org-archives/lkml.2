Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756787Ab2FFPz0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 11:55:26 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40257 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756248Ab2FFPzY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 11:55:24 -0400
Date: Wed, 6 Jun 2012 08:55:10 -0700
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Message-ID: <tip-3p86l9cuaqnxz7uxsojmz5rm@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, rientjes@google.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, rientjes@google.com
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/urgent] sched: Fix domain iteration
Git-Commit-ID: c1174876874dcf8986806e4dad3d7d07af20b439
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 06 Jun 2012 08:55:16 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c1174876874dcf8986806e4dad3d7d07af20b439
Gitweb:     http://git.kernel.org/tip/c1174876874dcf8986806e4dad3d7d07af20b439
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Thu, 31 May 2012 14:47:33 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 6 Jun 2012 16:52:26 +0200

sched: Fix domain iteration

Weird topologies can lead to asymmetric domain setups. This needs
further consideration since these setups are typically non-minimal
too.

For now, make it work by adding an extra mask selecting which CPUs
are allowed to iterate up.

The topology that triggered it is the one from David Rientjes:

	10 20 20 30
	20 10 20 20
	20 20 10 20
	30 20 20 10

resulting in boxes that wouldn't even boot.

Reported-by: David Rientjes <rientjes@google.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/n/tip-3p86l9cuaqnxz7uxsojmz5rm@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 include/linux/sched.h |   11 ++++++++
 kernel/sched/core.c   |   64 ++++++++++++++++++++++++++++++++++++++++++------
 kernel/sched/fair.c   |    5 ++-
 kernel/sched/sched.h  |    2 +
 4 files changed, 72 insertions(+), 10 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 6029d8c..ac321d7 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -876,6 +876,8 @@ struct sched_group_power {
 	 * Number of busy cpus in this group.
 	 */
 	atomic_t nr_busy_cpus;
+
+	unsigned long cpumask[0]; /* iteration mask */
 };
 
 struct sched_group {
@@ -900,6 +902,15 @@ static inline struct cpumask *sched_group_cpus(struct sched_group *sg)
 	return to_cpumask(sg->cpumask);
 }
 
+/*
+ * cpumask masking which cpus in the group are allowed to iterate up the domain
+ * tree.
+ */
+static inline struct cpumask *sched_group_mask(struct sched_group *sg)
+{
+	return to_cpumask(sg->sgp->cpumask);
+}
+
 /**
  * group_first_cpu - Returns the first cpu in the cpumask of a sched_group.
  * @group: The group whose first cpu is to be returned.
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 6546083..781acb9 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -5994,6 +5994,44 @@ struct sched_domain_topology_level {
 	struct sd_data      data;
 };
 
+/*
+ * Build an iteration mask that can exclude certain CPUs from the upwards
+ * domain traversal.
+ *
+ * Asymmetric node setups can result in situations where the domain tree is of
+ * unequal depth, make sure to skip domains that already cover the entire
+ * range.
+ *
+ * In that case build_sched_domains() will have terminated the iteration early
+ * and our sibling sd spans will be empty. Domains should always include the
+ * cpu they're built on, so check that.
+ *
+ */
+static void build_group_mask(struct sched_domain *sd, struct sched_group *sg)
+{
+	const struct cpumask *span = sched_domain_span(sd);
+	struct sd_data *sdd = sd->private;
+	struct sched_domain *sibling;
+	int i;
+
+	for_each_cpu(i, span) {
+		sibling = *per_cpu_ptr(sdd->sd, i);
+		if (!cpumask_test_cpu(i, sched_domain_span(sibling)))
+			continue;
+
+		cpumask_set_cpu(i, sched_group_mask(sg));
+	}
+}
+
+/*
+ * Return the canonical balance cpu for this group, this is the first cpu
+ * of this group that's also in the iteration mask.
+ */
+int group_balance_cpu(struct sched_group *sg)
+{
+	return cpumask_first_and(sched_group_cpus(sg), sched_group_mask(sg));
+}
+
 static int
 build_overlap_sched_groups(struct sched_domain *sd, int cpu)
 {
@@ -6012,6 +6050,12 @@ build_overlap_sched_groups(struct sched_domain *sd, int cpu)
 		if (cpumask_test_cpu(i, covered))
 			continue;
 
+		child = *per_cpu_ptr(sdd->sd, i);
+
+		/* See the comment near build_group_mask(). */
+		if (!cpumask_test_cpu(i, sched_domain_span(child)))
+			continue;
+
 		sg = kzalloc_node(sizeof(struct sched_group) + cpumask_size(),
 				GFP_KERNEL, cpu_to_node(cpu));
 
@@ -6019,8 +6063,6 @@ build_overlap_sched_groups(struct sched_domain *sd, int cpu)
 			goto fail;
 
 		sg_span = sched_group_cpus(sg);
-
-		child = *per_cpu_ptr(sdd->sd, i);
 		if (child->child) {
 			child = child->child;
 			cpumask_copy(sg_span, sched_domain_span(child));
@@ -6030,13 +6072,18 @@ build_overlap_sched_groups(struct sched_domain *sd, int cpu)
 		cpumask_or(covered, covered, sg_span);
 
 		sg->sgp = *per_cpu_ptr(sdd->sgp, i);
-		atomic_inc(&sg->sgp->ref);
+		if (atomic_inc_return(&sg->sgp->ref) == 1)
+			build_group_mask(sd, sg);
+
 
+		/*
+		 * Make sure the first group of this domain contains the
+		 * canonical balance cpu. Otherwise the sched_domain iteration
+		 * breaks. See update_sg_lb_stats().
+		 */
 		if ((!groups && cpumask_test_cpu(cpu, sg_span)) ||
-			       cpumask_first(sg_span) == cpu) {
-			WARN_ON_ONCE(!cpumask_test_cpu(cpu, sg_span));
+		    group_balance_cpu(sg) == cpu)
 			groups = sg;
-		}
 
 		if (!first)
 			first = sg;
@@ -6109,6 +6156,7 @@ build_sched_groups(struct sched_domain *sd, int cpu)
 
 		cpumask_clear(sched_group_cpus(sg));
 		sg->sgp->power = 0;
+		cpumask_setall(sched_group_mask(sg));
 
 		for_each_cpu(j, span) {
 			if (get_group(j, sdd, NULL) != group)
@@ -6150,7 +6198,7 @@ static void init_sched_groups_power(int cpu, struct sched_domain *sd)
 		sg = sg->next;
 	} while (sg != sd->groups);
 
-	if (cpu != group_first_cpu(sg))
+	if (cpu != group_balance_cpu(sg))
 		return;
 
 	update_group_power(sd, cpu);
@@ -6525,7 +6573,7 @@ static int __sdt_alloc(const struct cpumask *cpu_map)
 
 			*per_cpu_ptr(sdd->sg, j) = sg;
 
-			sgp = kzalloc_node(sizeof(struct sched_group_power),
+			sgp = kzalloc_node(sizeof(struct sched_group_power) + cpumask_size(),
 					GFP_KERNEL, cpu_to_node(j));
 			if (!sgp)
 				return -ENOMEM;
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index b2a2d23..54cbaa4 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -3652,7 +3652,7 @@ static inline void update_sg_lb_stats(struct lb_env *env,
 	int i;
 
 	if (local_group)
-		balance_cpu = group_first_cpu(group);
+		balance_cpu = group_balance_cpu(group);
 
 	/* Tally up the load of all CPUs in the group */
 	max_cpu_load = 0;
@@ -3667,7 +3667,8 @@ static inline void update_sg_lb_stats(struct lb_env *env,
 
 		/* Bias balancing toward cpus of our domain */
 		if (local_group) {
-			if (idle_cpu(i) && !first_idle_cpu) {
+			if (idle_cpu(i) && !first_idle_cpu &&
+					cpumask_test_cpu(i, sched_group_mask(group))) {
 				first_idle_cpu = 1;
 				balance_cpu = i;
 			}
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index ba9dccf..6d52cea 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -526,6 +526,8 @@ static inline struct sched_domain *highest_flag_domain(int cpu, int flag)
 DECLARE_PER_CPU(struct sched_domain *, sd_llc);
 DECLARE_PER_CPU(int, sd_llc_id);
 
+extern int group_balance_cpu(struct sched_group *sg);
+
 #endif /* CONFIG_SMP */
 
 #include "stats.h"
