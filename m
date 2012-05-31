Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754901Ab2EaWEe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 18:04:34 -0400
Received: from merlin.infradead.org ([205.233.59.134]:53528 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754495Ab2EaWEK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 18:04:10 -0400
Message-ID: <1338501826.28384.133.camel@twins>
Subject: Re: [tip:sched/numa] sched/numa: Introduce sys_numa_{t,m}bind()
From: Peter Zijlstra <peterz@infradead.org>
To: David Rientjes <rientjes@google.com>
Cc: Ingo Molnar <mingo@kernel.org>, hpa@zytor.com,
        linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>, pjt@google.com,
        cl@linux.com, riel@redhat.com, bharata.rao@gmail.com,
        Andrew Morton <akpm@linux-foundation.org>, Lee.Schermerhorn@hp.com,
        aarcange@redhat.com, danms@us.ibm.com, suresh.b.siddha@intel.com,
        tglx@linutronix.de, linux-tip-commits@vger.kernel.org
Date: Fri, 01 Jun 2012 00:03:46 +0200
In-Reply-To: <1337934953.9783.162.camel@laptop>
References: <tip-nf7brf1b88w0ojwuf689xeet@git.kernel.org>
	 <alpine.DEB.2.00.1205191922250.24674@chino.kir.corp.google.com>
	 <20120521084046.GB31407@gmail.com>
	 <alpine.DEB.2.00.1205211914100.13682@chino.kir.corp.google.com>
	 <alpine.DEB.2.00.1205211932350.13682@chino.kir.corp.google.com>
	 <1337688268.9698.29.camel@twins>  <1337698830.9698.37.camel@twins>
	 <1337788843.9783.14.camel@laptop>
	 <alpine.DEB.2.00.1205231757140.28167@chino.kir.corp.google.com>
	 <1337934953.9783.162.camel@laptop>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-05-25 at 10:35 +0200, Peter Zijlstra wrote:
> What does the node distance table on that thing look like?

The below makes it boot and I think even balance right. But I'm not
happy with the patch as I think it can be done simpler. The resulting
domain setup isn't minimal either. 



---
Subject: 
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Thu May 31 14:47:33 CEST 2012


Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 include/linux/sched.h |   11 ++++++++
 kernel/sched/core.c   |   64 +++++++++++++++++++++++++++++++++++++++++++-------
 kernel/sched/fair.c   |    5 ++-
 kernel/sched/sched.h  |    2 +
 4 files changed, 72 insertions(+), 10 deletions(-)

--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -878,6 +878,8 @@ struct sched_group_power {
 	 * Number of busy cpus in this group.
 	 */
 	atomic_t nr_busy_cpus;
+
+	unsigned long cpumask[0]; /* iteration mask */
 };
 
 struct sched_group {
@@ -902,6 +904,15 @@ static inline struct cpumask *sched_grou
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
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -6008,6 +6008,44 @@ struct sched_domain_topology_level {
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
@@ -6026,6 +6064,12 @@ build_overlap_sched_groups(struct sched_
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
 
@@ -6033,8 +6077,6 @@ build_overlap_sched_groups(struct sched_
 			goto fail;
 
 		sg_span = sched_group_cpus(sg);
-
-		child = *per_cpu_ptr(sdd->sd, i);
 		if (child->child) {
 			child = child->child;
 			cpumask_copy(sg_span, sched_domain_span(child));
@@ -6044,13 +6086,18 @@ build_overlap_sched_groups(struct sched_
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
@@ -6123,6 +6170,7 @@ build_sched_groups(struct sched_domain *
 
 		cpumask_clear(sched_group_cpus(sg));
 		sg->sgp->power = 0;
+		cpumask_setall(sched_group_mask(sg));
 
 		for_each_cpu(j, span) {
 			if (get_group(j, sdd, NULL) != group)
@@ -6164,7 +6212,7 @@ static void init_sched_groups_power(int
 		sg = sg->next;
 	} while (sg != sd->groups);
 
-	if (cpu != group_first_cpu(sg))
+	if (cpu != group_balance_cpu(sg))
 		return;
 
 	update_group_power(sd, cpu);
@@ -6572,7 +6620,7 @@ static int __sdt_alloc(const struct cpum
 
 			*per_cpu_ptr(sdd->sg, j) = sg;
 
-			sgp = kzalloc_node(sizeof(struct sched_group_power),
+			sgp = kzalloc_node(sizeof(struct sched_group_power) + cpumask_size(),
 					GFP_KERNEL, cpu_to_node(j));
 			if (!sgp)
 				return -ENOMEM;
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -3846,7 +3846,7 @@ static inline void update_sg_lb_stats(st
 	int i;
 
 	if (local_group)
-		balance_cpu = group_first_cpu(group);
+		balance_cpu = group_balance_cpu(group);
 
 	/* Tally up the load of all CPUs in the group */
 	max_cpu_load = 0;
@@ -3861,7 +3861,8 @@ static inline void update_sg_lb_stats(st
 
 		/* Bias balancing toward cpus of our domain */
 		if (local_group) {
-			if (idle_cpu(i) && !first_idle_cpu) {
+			if (idle_cpu(i) && !first_idle_cpu &&
+					cpumask_test_cpu(i, sched_group_mask(group))) {
 				first_idle_cpu = 1;
 				balance_cpu = i;
 			}
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -542,6 +542,8 @@ DECLARE_PER_CPU(struct sched_domain *, s
 DECLARE_PER_CPU(int, sd_llc_id);
 DECLARE_PER_CPU(struct sched_domain *, sd_node);
 
+extern int group_balance_cpu(struct sched_group *sg);
+
 #endif /* CONFIG_SMP */
 
 #include "stats.h"

