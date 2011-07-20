Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752392Ab1GTR3k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jul 2011 13:29:40 -0400
Received: from hera.kernel.org ([140.211.167.34]:58040 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751879Ab1GTR3i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jul 2011 13:29:38 -0400
Date: Wed, 20 Jul 2011 17:29:08 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Message-ID: <tip-08bxqw9wis3qti9u5inifh3y@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, anton@samba.org, hpa@zytor.com,
        mingo@redhat.com, torvalds@linux-foundation.org,
        a.p.zijlstra@chello.nl, akpm@linux-foundation.org, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, anton@samba.org,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        a.p.zijlstra@chello.nl, torvalds@linux-foundation.org,
        tglx@linutronix.de, mingo@elte.hu
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/urgent] sched: Allow for overlapping sched_domain spans
Git-Commit-ID: e3589f6c81e4764d32a25d2a2a0afe54fa344f5c
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 20 Jul 2011 17:29:13 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e3589f6c81e4764d32a25d2a2a0afe54fa344f5c
Gitweb:     http://git.kernel.org/tip/e3589f6c81e4764d32a25d2a2a0afe54fa344f5c
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Fri, 15 Jul 2011 10:35:52 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 20 Jul 2011 18:32:41 +0200

sched: Allow for overlapping sched_domain spans

Allow for sched_domain spans that overlap by giving such domains their
own sched_group list instead of sharing the sched_groups amongst
each-other.

This is needed for machines with more than 16 nodes, because
sched_domain_node_span() will generate a node mask from the
16 nearest nodes without regard if these masks have any overlap.

Currently sched_domains have a sched_group that maps to their child
sched_domain span, and since there is no overlap we share the
sched_group between the sched_domains of the various CPUs. If however
there is overlap, we would need to link the sched_group list in
different ways for each cpu, and hence sharing isn't possible.

In order to solve this, allocate private sched_groups for each CPU's
sched_domain but have the sched_groups share a sched_group_power
structure such that we can uniquely track the power.

Reported-and-tested-by: Anton Blanchard <anton@samba.org>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Link: http://lkml.kernel.org/n/tip-08bxqw9wis3qti9u5inifh3y@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/sched.h   |    2 +
 kernel/sched.c          |  157 ++++++++++++++++++++++++++++++++++++++---------
 kernel/sched_features.h |    2 +
 3 files changed, 132 insertions(+), 29 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 2e5b3c8..bde99d5 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -844,6 +844,7 @@ enum cpu_idle_type {
 #define SD_SERIALIZE		0x0400	/* Only a single load balancing instance */
 #define SD_ASYM_PACKING		0x0800  /* Place busy groups earlier in the domain */
 #define SD_PREFER_SIBLING	0x1000	/* Prefer to place tasks in a sibling domain */
+#define SD_OVERLAP		0x2000	/* sched_domains of this level overlap */
 
 enum powersavings_balance_level {
 	POWERSAVINGS_BALANCE_NONE = 0,  /* No power saving load balance */
@@ -894,6 +895,7 @@ static inline int sd_power_saving_flags(void)
 }
 
 struct sched_group_power {
+	atomic_t ref;
 	/*
 	 * CPU power of this group, SCHED_LOAD_SCALE being max power for a
 	 * single CPU.
diff --git a/kernel/sched.c b/kernel/sched.c
index 36c10d2..921adf6 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -6774,10 +6774,36 @@ static struct root_domain *alloc_rootdomain(void)
 	return rd;
 }
 
+static void free_sched_groups(struct sched_group *sg, int free_sgp)
+{
+	struct sched_group *tmp, *first;
+
+	if (!sg)
+		return;
+
+	first = sg;
+	do {
+		tmp = sg->next;
+
+		if (free_sgp && atomic_dec_and_test(&sg->sgp->ref))
+			kfree(sg->sgp);
+
+		kfree(sg);
+		sg = tmp;
+	} while (sg != first);
+}
+
 static void free_sched_domain(struct rcu_head *rcu)
 {
 	struct sched_domain *sd = container_of(rcu, struct sched_domain, rcu);
-	if (atomic_dec_and_test(&sd->groups->ref)) {
+
+	/*
+	 * If its an overlapping domain it has private groups, iterate and
+	 * nuke them all.
+	 */
+	if (sd->flags & SD_OVERLAP) {
+		free_sched_groups(sd->groups, 1);
+	} else if (atomic_dec_and_test(&sd->groups->ref)) {
 		kfree(sd->groups->sgp);
 		kfree(sd->groups);
 	}
@@ -6967,15 +6993,73 @@ struct sched_domain_topology_level;
 typedef struct sched_domain *(*sched_domain_init_f)(struct sched_domain_topology_level *tl, int cpu);
 typedef const struct cpumask *(*sched_domain_mask_f)(int cpu);
 
+#define SDTL_OVERLAP	0x01
+
 struct sched_domain_topology_level {
 	sched_domain_init_f init;
 	sched_domain_mask_f mask;
+	int		    flags;
 	struct sd_data      data;
 };
 
-/*
- * Assumes the sched_domain tree is fully constructed
- */
+static int
+build_overlap_sched_groups(struct sched_domain *sd, int cpu)
+{
+	struct sched_group *first = NULL, *last = NULL, *groups = NULL, *sg;
+	const struct cpumask *span = sched_domain_span(sd);
+	struct cpumask *covered = sched_domains_tmpmask;
+	struct sd_data *sdd = sd->private;
+	struct sched_domain *child;
+	int i;
+
+	cpumask_clear(covered);
+
+	for_each_cpu(i, span) {
+		struct cpumask *sg_span;
+
+		if (cpumask_test_cpu(i, covered))
+			continue;
+
+		sg = kzalloc_node(sizeof(struct sched_group) + cpumask_size(),
+				GFP_KERNEL, cpu_to_node(i));
+
+		if (!sg)
+			goto fail;
+
+		sg_span = sched_group_cpus(sg);
+
+		child = *per_cpu_ptr(sdd->sd, i);
+		if (child->child) {
+			child = child->child;
+			cpumask_copy(sg_span, sched_domain_span(child));
+		} else
+			cpumask_set_cpu(i, sg_span);
+
+		cpumask_or(covered, covered, sg_span);
+
+		sg->sgp = *per_cpu_ptr(sdd->sgp, cpumask_first(sg_span));
+		atomic_inc(&sg->sgp->ref);
+
+		if (cpumask_test_cpu(cpu, sg_span))
+			groups = sg;
+
+		if (!first)
+			first = sg;
+		if (last)
+			last->next = sg;
+		last = sg;
+		last->next = first;
+	}
+	sd->groups = groups;
+
+	return 0;
+
+fail:
+	free_sched_groups(first, 0);
+
+	return -ENOMEM;
+}
+
 static int get_group(int cpu, struct sd_data *sdd, struct sched_group **sg)
 {
 	struct sched_domain *sd = *per_cpu_ptr(sdd->sd, cpu);
@@ -6987,23 +7071,21 @@ static int get_group(int cpu, struct sd_data *sdd, struct sched_group **sg)
 	if (sg) {
 		*sg = *per_cpu_ptr(sdd->sg, cpu);
 		(*sg)->sgp = *per_cpu_ptr(sdd->sgp, cpu);
+		atomic_set(&(*sg)->sgp->ref, 1); /* for claim_allocations */
 	}
 
 	return cpu;
 }
 
 /*
- * build_sched_groups takes the cpumask we wish to span, and a pointer
- * to a function which identifies what group(along with sched group) a CPU
- * belongs to. The return value of group_fn must be a >= 0 and < nr_cpu_ids
- * (due to the fact that we keep track of groups covered with a struct cpumask).
- *
  * build_sched_groups will build a circular linked list of the groups
  * covered by the given span, and will set each group's ->cpumask correctly,
  * and ->cpu_power to 0.
+ *
+ * Assumes the sched_domain tree is fully constructed
  */
-static void
-build_sched_groups(struct sched_domain *sd)
+static int
+build_sched_groups(struct sched_domain *sd, int cpu)
 {
 	struct sched_group *first = NULL, *last = NULL;
 	struct sd_data *sdd = sd->private;
@@ -7011,6 +7093,12 @@ build_sched_groups(struct sched_domain *sd)
 	struct cpumask *covered;
 	int i;
 
+	get_group(cpu, sdd, &sd->groups);
+	atomic_inc(&sd->groups->ref);
+
+	if (cpu != cpumask_first(sched_domain_span(sd)))
+		return 0;
+
 	lockdep_assert_held(&sched_domains_mutex);
 	covered = sched_domains_tmpmask;
 
@@ -7042,6 +7130,8 @@ build_sched_groups(struct sched_domain *sd)
 		last = sg;
 	}
 	last->next = first;
+
+	return 0;
 }
 
 /*
@@ -7056,12 +7146,17 @@ build_sched_groups(struct sched_domain *sd)
  */
 static void init_sched_groups_power(int cpu, struct sched_domain *sd)
 {
-	WARN_ON(!sd || !sd->groups);
+	struct sched_group *sg = sd->groups;
 
-	if (cpu != group_first_cpu(sd->groups))
-		return;
+	WARN_ON(!sd || !sg);
+
+	do {
+		sg->group_weight = cpumask_weight(sched_group_cpus(sg));
+		sg = sg->next;
+	} while (sg != sd->groups);
 
-	sd->groups->group_weight = cpumask_weight(sched_group_cpus(sd->groups));
+	if (cpu != group_first_cpu(sg))
+		return;
 
 	update_group_power(sd, cpu);
 }
@@ -7182,16 +7277,15 @@ static enum s_alloc __visit_domain_allocation_hell(struct s_data *d,
 static void claim_allocations(int cpu, struct sched_domain *sd)
 {
 	struct sd_data *sdd = sd->private;
-	struct sched_group *sg = sd->groups;
 
 	WARN_ON_ONCE(*per_cpu_ptr(sdd->sd, cpu) != sd);
 	*per_cpu_ptr(sdd->sd, cpu) = NULL;
 
-	if (cpu == cpumask_first(sched_group_cpus(sg))) {
-		WARN_ON_ONCE(*per_cpu_ptr(sdd->sg, cpu) != sg);
+	if (atomic_read(&(*per_cpu_ptr(sdd->sg, cpu))->ref))
 		*per_cpu_ptr(sdd->sg, cpu) = NULL;
+
+	if (atomic_read(&(*per_cpu_ptr(sdd->sgp, cpu))->ref))
 		*per_cpu_ptr(sdd->sgp, cpu) = NULL;
-	}
 }
 
 #ifdef CONFIG_SCHED_SMT
@@ -7216,7 +7310,7 @@ static struct sched_domain_topology_level default_topology[] = {
 #endif
 	{ sd_init_CPU, cpu_cpu_mask, },
 #ifdef CONFIG_NUMA
-	{ sd_init_NODE, cpu_node_mask, },
+	{ sd_init_NODE, cpu_node_mask, SDTL_OVERLAP, },
 	{ sd_init_ALLNODES, cpu_allnodes_mask, },
 #endif
 	{ NULL, },
@@ -7284,7 +7378,9 @@ static void __sdt_free(const struct cpumask *cpu_map)
 		struct sd_data *sdd = &tl->data;
 
 		for_each_cpu(j, cpu_map) {
-			kfree(*per_cpu_ptr(sdd->sd, j));
+			struct sched_domain *sd = *per_cpu_ptr(sdd->sd, j);
+			if (sd && (sd->flags & SD_OVERLAP))
+				free_sched_groups(sd->groups, 0);
 			kfree(*per_cpu_ptr(sdd->sg, j));
 			kfree(*per_cpu_ptr(sdd->sgp, j));
 		}
@@ -7336,8 +7432,11 @@ static int build_sched_domains(const struct cpumask *cpu_map,
 		struct sched_domain_topology_level *tl;
 
 		sd = NULL;
-		for (tl = sched_domain_topology; tl->init; tl++)
+		for (tl = sched_domain_topology; tl->init; tl++) {
 			sd = build_sched_domain(tl, &d, cpu_map, attr, sd, i);
+			if (tl->flags & SDTL_OVERLAP || sched_feat(FORCE_SD_OVERLAP))
+				sd->flags |= SD_OVERLAP;
+		}
 
 		while (sd->child)
 			sd = sd->child;
@@ -7349,13 +7448,13 @@ static int build_sched_domains(const struct cpumask *cpu_map,
 	for_each_cpu(i, cpu_map) {
 		for (sd = *per_cpu_ptr(d.sd, i); sd; sd = sd->parent) {
 			sd->span_weight = cpumask_weight(sched_domain_span(sd));
-			get_group(i, sd->private, &sd->groups);
-			atomic_inc(&sd->groups->ref);
-
-			if (i != cpumask_first(sched_domain_span(sd)))
-				continue;
-
-			build_sched_groups(sd);
+			if (sd->flags & SD_OVERLAP) {
+				if (build_overlap_sched_groups(sd, i))
+					goto error;
+			} else {
+				if (build_sched_groups(sd, i))
+					goto error;
+			}
 		}
 	}
 
diff --git a/kernel/sched_features.h b/kernel/sched_features.h
index be40f73..1e7066d 100644
--- a/kernel/sched_features.h
+++ b/kernel/sched_features.h
@@ -70,3 +70,5 @@ SCHED_FEAT(NONIRQ_POWER, 1)
  * using the scheduler IPI. Reduces rq->lock contention/bounces.
  */
 SCHED_FEAT(TTWU_QUEUE, 1)
+
+SCHED_FEAT(FORCE_SD_OVERLAP, 0)
