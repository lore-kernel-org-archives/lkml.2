Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753267Ab1DKOig (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Apr 2011 10:38:36 -0400
Received: from hera.kernel.org ([140.211.167.34]:54533 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752308Ab1DKOie (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Apr 2011 10:38:34 -0400
Date: Mon, 11 Apr 2011 14:37:28 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Message-ID: <tip-dce840a08702bd13a9a186e07e63d1ef82256b5e@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        torvalds@linux-foundation.org, a.p.zijlstra@chello.nl, efault@gmx.de,
        npiggin@kernel.dk, akpm@linux-foundation.org, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, torvalds@linux-foundation.org, efault@gmx.de,
        npiggin@kernel.dk, akpm@linux-foundation.org, tglx@linutronix.de,
        mingo@elte.hu
In-Reply-To: <20110407122942.245307941@chello.nl>
References: <20110407122942.245307941@chello.nl>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/domains] sched: Dynamically allocate sched_domain/sched_group data-structures
Git-Commit-ID: dce840a08702bd13a9a186e07e63d1ef82256b5e
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 11 Apr 2011 14:37:30 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  dce840a08702bd13a9a186e07e63d1ef82256b5e
Gitweb:     http://git.kernel.org/tip/dce840a08702bd13a9a186e07e63d1ef82256b5e
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Thu, 7 Apr 2011 14:09:50 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 11 Apr 2011 12:58:19 +0200

sched: Dynamically allocate sched_domain/sched_group data-structures

Instead of relying on static allocations for the sched_domain and
sched_group trees, dynamically allocate and RCU free them.

Allocating this dynamically also allows for some build_sched_groups()
simplification since we can now (like with other simplifications) rely
on the sched_domain tree instead of hard-coded knowledge.

One tricky to note is that detach_destroy_domains() needs to hold
rcu_read_lock() over the entire tear-down, per-cpu is not sufficient
since that can lead to partial sched_group existance (could possibly
be solved by doing the tear-down backwards but this is much more
robust).

A concequence of the above is that we can no longer print the
sched_domain debug stuff from cpu_attach_domain() since that might now
run with preemption disabled (due to classic RCU etc.) and
sched_domain_debug() does some GFP_KERNEL allocations.

Another thing to note is that we now fully rely on normal RCU and not
RCU-sched, this is because with the new and exiting RCU flavours we
grew over the years BH doesn't necessarily hold off RCU-sched grace
periods (-rt is known to break this). This would in fact already cause
us grief since we do sched_domain/sched_group iterations from softirq
context.

This patch is somewhat larger than I would like it to be, but I didn't
find any means of shrinking/splitting this.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Nick Piggin <npiggin@kernel.dk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Link: http://lkml.kernel.org/r/20110407122942.245307941@chello.nl
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/sched.h |    5 +
 kernel/sched.c        |  479 +++++++++++++++++++------------------------------
 kernel/sched_fair.c   |   30 +++-
 3 files changed, 218 insertions(+), 296 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 4ec2c02..020b79d 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -868,6 +868,7 @@ static inline int sd_power_saving_flags(void)
 
 struct sched_group {
 	struct sched_group *next;	/* Must be a circular list */
+	atomic_t ref;
 
 	/*
 	 * CPU power of this group, SCHED_LOAD_SCALE being max power for a
@@ -973,6 +974,10 @@ struct sched_domain {
 #ifdef CONFIG_SCHED_DEBUG
 	char *name;
 #endif
+	union {
+		void *private;		/* used during construction */
+		struct rcu_head rcu;	/* used during destruction */
+	};
 
 	unsigned int span_weight;
 	/*
diff --git a/kernel/sched.c b/kernel/sched.c
index 1cca59e..6520484 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -417,6 +417,7 @@ struct rt_rq {
  */
 struct root_domain {
 	atomic_t refcount;
+	struct rcu_head rcu;
 	cpumask_var_t span;
 	cpumask_var_t online;
 
@@ -571,7 +572,7 @@ static inline int cpu_of(struct rq *rq)
 
 #define rcu_dereference_check_sched_domain(p) \
 	rcu_dereference_check((p), \
-			      rcu_read_lock_sched_held() || \
+			      rcu_read_lock_held() || \
 			      lockdep_is_held(&sched_domains_mutex))
 
 /*
@@ -6572,12 +6573,11 @@ sd_parent_degenerate(struct sched_domain *sd, struct sched_domain *parent)
 	return 1;
 }
 
-static void free_rootdomain(struct root_domain *rd)
+static void free_rootdomain(struct rcu_head *rcu)
 {
-	synchronize_sched();
+	struct root_domain *rd = container_of(rcu, struct root_domain, rcu);
 
 	cpupri_cleanup(&rd->cpupri);
-
 	free_cpumask_var(rd->rto_mask);
 	free_cpumask_var(rd->online);
 	free_cpumask_var(rd->span);
@@ -6618,7 +6618,7 @@ static void rq_attach_root(struct rq *rq, struct root_domain *rd)
 	raw_spin_unlock_irqrestore(&rq->lock, flags);
 
 	if (old_rd)
-		free_rootdomain(old_rd);
+		call_rcu_sched(&old_rd->rcu, free_rootdomain);
 }
 
 static int init_rootdomain(struct root_domain *rd)
@@ -6669,6 +6669,25 @@ static struct root_domain *alloc_rootdomain(void)
 	return rd;
 }
 
+static void free_sched_domain(struct rcu_head *rcu)
+{
+	struct sched_domain *sd = container_of(rcu, struct sched_domain, rcu);
+	if (atomic_dec_and_test(&sd->groups->ref))
+		kfree(sd->groups);
+	kfree(sd);
+}
+
+static void destroy_sched_domain(struct sched_domain *sd, int cpu)
+{
+	call_rcu(&sd->rcu, free_sched_domain);
+}
+
+static void destroy_sched_domains(struct sched_domain *sd, int cpu)
+{
+	for (; sd; sd = sd->parent)
+		destroy_sched_domain(sd, cpu);
+}
+
 /*
  * Attach the domain 'sd' to 'cpu' as its base domain. Callers must
  * hold the hotplug lock.
@@ -6689,20 +6708,25 @@ cpu_attach_domain(struct sched_domain *sd, struct root_domain *rd, int cpu)
 			tmp->parent = parent->parent;
 			if (parent->parent)
 				parent->parent->child = tmp;
+			destroy_sched_domain(parent, cpu);
 		} else
 			tmp = tmp->parent;
 	}
 
 	if (sd && sd_degenerate(sd)) {
+		tmp = sd;
 		sd = sd->parent;
+		destroy_sched_domain(tmp, cpu);
 		if (sd)
 			sd->child = NULL;
 	}
 
-	sched_domain_debug(sd, cpu);
+	/* sched_domain_debug(sd, cpu); */
 
 	rq_attach_root(rq, rd);
+	tmp = rq->sd;
 	rcu_assign_pointer(rq->sd, sd);
+	destroy_sched_domains(tmp, cpu);
 }
 
 /* cpus with isolated domains */
@@ -6718,56 +6742,6 @@ static int __init isolated_cpu_setup(char *str)
 
 __setup("isolcpus=", isolated_cpu_setup);
 
-/*
- * init_sched_build_groups takes the cpumask we wish to span, and a pointer
- * to a function which identifies what group(along with sched group) a CPU
- * belongs to. The return value of group_fn must be a >= 0 and < nr_cpu_ids
- * (due to the fact that we keep track of groups covered with a struct cpumask).
- *
- * init_sched_build_groups will build a circular linked list of the groups
- * covered by the given span, and will set each group's ->cpumask correctly,
- * and ->cpu_power to 0.
- */
-static void
-init_sched_build_groups(const struct cpumask *span,
-			const struct cpumask *cpu_map,
-			int (*group_fn)(int cpu, const struct cpumask *cpu_map,
-					struct sched_group **sg,
-					struct cpumask *tmpmask),
-			struct cpumask *covered, struct cpumask *tmpmask)
-{
-	struct sched_group *first = NULL, *last = NULL;
-	int i;
-
-	cpumask_clear(covered);
-
-	for_each_cpu(i, span) {
-		struct sched_group *sg;
-		int group = group_fn(i, cpu_map, &sg, tmpmask);
-		int j;
-
-		if (cpumask_test_cpu(i, covered))
-			continue;
-
-		cpumask_clear(sched_group_cpus(sg));
-		sg->cpu_power = 0;
-
-		for_each_cpu(j, span) {
-			if (group_fn(j, cpu_map, NULL, tmpmask) != group)
-				continue;
-
-			cpumask_set_cpu(j, covered);
-			cpumask_set_cpu(j, sched_group_cpus(sg));
-		}
-		if (!first)
-			first = sg;
-		if (last)
-			last->next = sg;
-		last = sg;
-	}
-	last->next = first;
-}
-
 #define SD_NODES_PER_DOMAIN 16
 
 #ifdef CONFIG_NUMA
@@ -6858,154 +6832,96 @@ struct static_sched_domain {
 	DECLARE_BITMAP(span, CONFIG_NR_CPUS);
 };
 
+struct sd_data {
+	struct sched_domain **__percpu sd;
+	struct sched_group **__percpu sg;
+};
+
 struct s_data {
 #ifdef CONFIG_NUMA
 	int			sd_allnodes;
 #endif
 	cpumask_var_t		nodemask;
 	cpumask_var_t		send_covered;
-	cpumask_var_t		tmpmask;
 	struct sched_domain ** __percpu sd;
+	struct sd_data 		sdd[SD_LV_MAX];
 	struct root_domain	*rd;
 };
 
 enum s_alloc {
 	sa_rootdomain,
 	sa_sd,
-	sa_tmpmask,
+	sa_sd_storage,
 	sa_send_covered,
 	sa_nodemask,
 	sa_none,
 };
 
 /*
- * SMT sched-domains:
+ * Assumes the sched_domain tree is fully constructed
  */
-#ifdef CONFIG_SCHED_SMT
-static DEFINE_PER_CPU(struct static_sched_domain, cpu_domains);
-static DEFINE_PER_CPU(struct static_sched_group, sched_groups);
-
-static int
-cpu_to_cpu_group(int cpu, const struct cpumask *cpu_map,
-		 struct sched_group **sg, struct cpumask *unused)
+static int get_group(int cpu, struct sd_data *sdd, struct sched_group **sg)
 {
-	if (sg)
-		*sg = &per_cpu(sched_groups, cpu).sg;
-	return cpu;
-}
-#endif /* CONFIG_SCHED_SMT */
+	struct sched_domain *sd = *per_cpu_ptr(sdd->sd, cpu);
+	struct sched_domain *child = sd->child;
 
-/*
- * multi-core sched-domains:
- */
-#ifdef CONFIG_SCHED_MC
-static DEFINE_PER_CPU(struct static_sched_domain, core_domains);
-static DEFINE_PER_CPU(struct static_sched_group, sched_group_core);
+	if (child)
+		cpu = cpumask_first(sched_domain_span(child));
 
-static int
-cpu_to_core_group(int cpu, const struct cpumask *cpu_map,
-		  struct sched_group **sg, struct cpumask *mask)
-{
-	int group;
-#ifdef CONFIG_SCHED_SMT
-	cpumask_and(mask, topology_thread_cpumask(cpu), cpu_map);
-	group = cpumask_first(mask);
-#else
-	group = cpu;
-#endif
 	if (sg)
-		*sg = &per_cpu(sched_group_core, group).sg;
-	return group;
+		*sg = *per_cpu_ptr(sdd->sg, cpu);
+
+	return cpu;
 }
-#endif /* CONFIG_SCHED_MC */
 
 /*
- * book sched-domains:
+ * build_sched_groups takes the cpumask we wish to span, and a pointer
+ * to a function which identifies what group(along with sched group) a CPU
+ * belongs to. The return value of group_fn must be a >= 0 and < nr_cpu_ids
+ * (due to the fact that we keep track of groups covered with a struct cpumask).
+ *
+ * build_sched_groups will build a circular linked list of the groups
+ * covered by the given span, and will set each group's ->cpumask correctly,
+ * and ->cpu_power to 0.
  */
-#ifdef CONFIG_SCHED_BOOK
-static DEFINE_PER_CPU(struct static_sched_domain, book_domains);
-static DEFINE_PER_CPU(struct static_sched_group, sched_group_book);
-
-static int
-cpu_to_book_group(int cpu, const struct cpumask *cpu_map,
-		  struct sched_group **sg, struct cpumask *mask)
-{
-	int group = cpu;
-#ifdef CONFIG_SCHED_MC
-	cpumask_and(mask, cpu_coregroup_mask(cpu), cpu_map);
-	group = cpumask_first(mask);
-#elif defined(CONFIG_SCHED_SMT)
-	cpumask_and(mask, topology_thread_cpumask(cpu), cpu_map);
-	group = cpumask_first(mask);
-#endif
-	if (sg)
-		*sg = &per_cpu(sched_group_book, group).sg;
-	return group;
-}
-#endif /* CONFIG_SCHED_BOOK */
-
-static DEFINE_PER_CPU(struct static_sched_domain, phys_domains);
-static DEFINE_PER_CPU(struct static_sched_group, sched_group_phys);
-
-static int
-cpu_to_phys_group(int cpu, const struct cpumask *cpu_map,
-		  struct sched_group **sg, struct cpumask *mask)
+static void
+build_sched_groups(struct sched_domain *sd, struct cpumask *covered)
 {
-	int group;
-#ifdef CONFIG_SCHED_BOOK
-	cpumask_and(mask, cpu_book_mask(cpu), cpu_map);
-	group = cpumask_first(mask);
-#elif defined(CONFIG_SCHED_MC)
-	cpumask_and(mask, cpu_coregroup_mask(cpu), cpu_map);
-	group = cpumask_first(mask);
-#elif defined(CONFIG_SCHED_SMT)
-	cpumask_and(mask, topology_thread_cpumask(cpu), cpu_map);
-	group = cpumask_first(mask);
-#else
-	group = cpu;
-#endif
-	if (sg)
-		*sg = &per_cpu(sched_group_phys, group).sg;
-	return group;
-}
-
-#ifdef CONFIG_NUMA
-static DEFINE_PER_CPU(struct static_sched_domain, node_domains);
-static DEFINE_PER_CPU(struct static_sched_group, sched_group_node);
+	struct sched_group *first = NULL, *last = NULL;
+	struct sd_data *sdd = sd->private;
+	const struct cpumask *span = sched_domain_span(sd);
+	int i;
 
-static int cpu_to_node_group(int cpu, const struct cpumask *cpu_map,
-				 struct sched_group **sg,
-				 struct cpumask *nodemask)
-{
-	int group;
+	cpumask_clear(covered);
 
-	cpumask_and(nodemask, cpumask_of_node(cpu_to_node(cpu)), cpu_map);
-	group = cpumask_first(nodemask);
+	for_each_cpu(i, span) {
+		struct sched_group *sg;
+		int group = get_group(i, sdd, &sg);
+		int j;
 
-	if (sg)
-		*sg = &per_cpu(sched_group_node, group).sg;
-	return group;
-}
+		if (cpumask_test_cpu(i, covered))
+			continue;
 
-static DEFINE_PER_CPU(struct static_sched_domain, allnodes_domains);
-static DEFINE_PER_CPU(struct static_sched_group, sched_group_allnodes);
+		cpumask_clear(sched_group_cpus(sg));
+		sg->cpu_power = 0;
 
-static int cpu_to_allnodes_group(int cpu, const struct cpumask *cpu_map,
-				 struct sched_group **sg,
-				 struct cpumask *nodemask)
-{
-	int group;
+		for_each_cpu(j, span) {
+			if (get_group(j, sdd, NULL) != group)
+				continue;
 
-	cpumask_and(nodemask, cpumask_of_node(cpu_to_node(cpu)), cpu_map);
-	group = cpumask_first(nodemask);
+			cpumask_set_cpu(j, covered);
+			cpumask_set_cpu(j, sched_group_cpus(sg));
+		}
 
-	if (sg)
-		*sg = &per_cpu(sched_group_allnodes, group).sg;
-	return group;
+		if (!first)
+			first = sg;
+		if (last)
+			last->next = sg;
+		last = sg;
+	}
+	last->next = first;
 }
 
-#endif /* CONFIG_NUMA */
-
 /*
  * Initialize sched groups cpu_power.
  *
@@ -7039,15 +6955,15 @@ static void init_sched_groups_power(int cpu, struct sched_domain *sd)
 # define SD_INIT_NAME(sd, type)		do { } while (0)
 #endif
 
-#define	SD_INIT(sd, type)	sd_init_##type(sd)
-
-#define SD_INIT_FUNC(type)	\
-static noinline void sd_init_##type(struct sched_domain *sd)	\
-{								\
-	memset(sd, 0, sizeof(*sd));				\
-	*sd = SD_##type##_INIT;					\
-	sd->level = SD_LV_##type;				\
-	SD_INIT_NAME(sd, type);					\
+#define SD_INIT_FUNC(type)						       \
+static noinline struct sched_domain *sd_init_##type(struct s_data *d, int cpu) \
+{									       \
+	struct sched_domain *sd = *per_cpu_ptr(d->sdd[SD_LV_##type].sd, cpu);  \
+	*sd = SD_##type##_INIT;						       \
+	sd->level = SD_LV_##type;					       \
+	SD_INIT_NAME(sd, type);						       \
+	sd->private = &d->sdd[SD_LV_##type];				       \
+	return sd;							       \
 }
 
 SD_INIT_FUNC(CPU)
@@ -7103,13 +7019,22 @@ static void set_domain_attribute(struct sched_domain *sd,
 static void __free_domain_allocs(struct s_data *d, enum s_alloc what,
 				 const struct cpumask *cpu_map)
 {
+	int i, j;
+
 	switch (what) {
 	case sa_rootdomain:
-		free_rootdomain(d->rd); /* fall through */
+		free_rootdomain(&d->rd->rcu); /* fall through */
 	case sa_sd:
 		free_percpu(d->sd); /* fall through */
-	case sa_tmpmask:
-		free_cpumask_var(d->tmpmask); /* fall through */
+	case sa_sd_storage:
+		for (i = 0; i < SD_LV_MAX; i++) {
+			for_each_cpu(j, cpu_map) {
+				kfree(*per_cpu_ptr(d->sdd[i].sd, j));
+				kfree(*per_cpu_ptr(d->sdd[i].sg, j));
+			}
+			free_percpu(d->sdd[i].sd);
+			free_percpu(d->sdd[i].sg);
+		} /* fall through */
 	case sa_send_covered:
 		free_cpumask_var(d->send_covered); /* fall through */
 	case sa_nodemask:
@@ -7122,25 +7047,70 @@ static void __free_domain_allocs(struct s_data *d, enum s_alloc what,
 static enum s_alloc __visit_domain_allocation_hell(struct s_data *d,
 						   const struct cpumask *cpu_map)
 {
+	int i, j;
+
+	memset(d, 0, sizeof(*d));
+
 	if (!alloc_cpumask_var(&d->nodemask, GFP_KERNEL))
 		return sa_none;
 	if (!alloc_cpumask_var(&d->send_covered, GFP_KERNEL))
 		return sa_nodemask;
-	if (!alloc_cpumask_var(&d->tmpmask, GFP_KERNEL))
-		return sa_send_covered;
-	d->sd = alloc_percpu(struct sched_domain *);
-	if (!d->sd) {
-		printk(KERN_WARNING "Cannot alloc per-cpu pointers\n");
-		return sa_tmpmask;
+	for (i = 0; i < SD_LV_MAX; i++) {
+		d->sdd[i].sd = alloc_percpu(struct sched_domain *);
+		if (!d->sdd[i].sd)
+			return sa_sd_storage;
+
+		d->sdd[i].sg = alloc_percpu(struct sched_group *);
+		if (!d->sdd[i].sg)
+			return sa_sd_storage;
+
+		for_each_cpu(j, cpu_map) {
+			struct sched_domain *sd;
+			struct sched_group *sg;
+
+		       	sd = kzalloc_node(sizeof(struct sched_domain) + cpumask_size(),
+					GFP_KERNEL, cpu_to_node(j));
+			if (!sd)
+				return sa_sd_storage;
+
+			*per_cpu_ptr(d->sdd[i].sd, j) = sd;
+
+			sg = kzalloc_node(sizeof(struct sched_group) + cpumask_size(),
+					GFP_KERNEL, cpu_to_node(j));
+			if (!sg)
+				return sa_sd_storage;
+
+			*per_cpu_ptr(d->sdd[i].sg, j) = sg;
+		}
 	}
+	d->sd = alloc_percpu(struct sched_domain *);
+	if (!d->sd)
+		return sa_sd_storage;
 	d->rd = alloc_rootdomain();
-	if (!d->rd) {
-		printk(KERN_WARNING "Cannot alloc root domain\n");
+	if (!d->rd)
 		return sa_sd;
-	}
 	return sa_rootdomain;
 }
 
+/*
+ * NULL the sd_data elements we've used to build the sched_domain and
+ * sched_group structure so that the subsequent __free_domain_allocs()
+ * will not free the data we're using.
+ */
+static void claim_allocations(int cpu, struct sched_domain *sd)
+{
+	struct sd_data *sdd = sd->private;
+	struct sched_group *sg = sd->groups;
+
+	WARN_ON_ONCE(*per_cpu_ptr(sdd->sd, cpu) != sd);
+	*per_cpu_ptr(sdd->sd, cpu) = NULL;
+
+	if (cpu == cpumask_first(sched_group_cpus(sg))) {
+		WARN_ON_ONCE(*per_cpu_ptr(sdd->sg, cpu) != sg);
+		*per_cpu_ptr(sdd->sg, cpu) = NULL;
+	}
+}
+
 static struct sched_domain *__build_numa_sched_domains(struct s_data *d,
 	const struct cpumask *cpu_map, struct sched_domain_attr *attr, int i)
 {
@@ -7151,24 +7121,20 @@ static struct sched_domain *__build_numa_sched_domains(struct s_data *d,
 	d->sd_allnodes = 0;
 	if (cpumask_weight(cpu_map) >
 	    SD_NODES_PER_DOMAIN * cpumask_weight(d->nodemask)) {
-		sd = &per_cpu(allnodes_domains, i).sd;
-		SD_INIT(sd, ALLNODES);
+		sd = sd_init_ALLNODES(d, i);
 		set_domain_attribute(sd, attr);
 		cpumask_copy(sched_domain_span(sd), cpu_map);
-		cpu_to_allnodes_group(i, cpu_map, &sd->groups, d->tmpmask);
 		d->sd_allnodes = 1;
 	}
 	parent = sd;
 
-	sd = &per_cpu(node_domains, i).sd;
-	SD_INIT(sd, NODE);
+	sd = sd_init_NODE(d, i);
 	set_domain_attribute(sd, attr);
 	sched_domain_node_span(cpu_to_node(i), sched_domain_span(sd));
 	sd->parent = parent;
 	if (parent)
 		parent->child = sd;
 	cpumask_and(sched_domain_span(sd), sched_domain_span(sd), cpu_map);
-	cpu_to_node_group(i, cpu_map, &sd->groups, d->tmpmask);
 #endif
 	return sd;
 }
@@ -7178,14 +7144,12 @@ static struct sched_domain *__build_cpu_sched_domain(struct s_data *d,
 	struct sched_domain *parent, int i)
 {
 	struct sched_domain *sd;
-	sd = &per_cpu(phys_domains, i).sd;
-	SD_INIT(sd, CPU);
+	sd = sd_init_CPU(d, i);
 	set_domain_attribute(sd, attr);
 	cpumask_copy(sched_domain_span(sd), d->nodemask);
 	sd->parent = parent;
 	if (parent)
 		parent->child = sd;
-	cpu_to_phys_group(i, cpu_map, &sd->groups, d->tmpmask);
 	return sd;
 }
 
@@ -7195,13 +7159,11 @@ static struct sched_domain *__build_book_sched_domain(struct s_data *d,
 {
 	struct sched_domain *sd = parent;
 #ifdef CONFIG_SCHED_BOOK
-	sd = &per_cpu(book_domains, i).sd;
-	SD_INIT(sd, BOOK);
+	sd = sd_init_BOOK(d, i);
 	set_domain_attribute(sd, attr);
 	cpumask_and(sched_domain_span(sd), cpu_map, cpu_book_mask(i));
 	sd->parent = parent;
 	parent->child = sd;
-	cpu_to_book_group(i, cpu_map, &sd->groups, d->tmpmask);
 #endif
 	return sd;
 }
@@ -7212,13 +7174,11 @@ static struct sched_domain *__build_mc_sched_domain(struct s_data *d,
 {
 	struct sched_domain *sd = parent;
 #ifdef CONFIG_SCHED_MC
-	sd = &per_cpu(core_domains, i).sd;
-	SD_INIT(sd, MC);
+	sd = sd_init_MC(d, i);
 	set_domain_attribute(sd, attr);
 	cpumask_and(sched_domain_span(sd), cpu_map, cpu_coregroup_mask(i));
 	sd->parent = parent;
 	parent->child = sd;
-	cpu_to_core_group(i, cpu_map, &sd->groups, d->tmpmask);
 #endif
 	return sd;
 }
@@ -7229,92 +7189,32 @@ static struct sched_domain *__build_smt_sched_domain(struct s_data *d,
 {
 	struct sched_domain *sd = parent;
 #ifdef CONFIG_SCHED_SMT
-	sd = &per_cpu(cpu_domains, i).sd;
-	SD_INIT(sd, SIBLING);
+	sd = sd_init_SIBLING(d, i);
 	set_domain_attribute(sd, attr);
 	cpumask_and(sched_domain_span(sd), cpu_map, topology_thread_cpumask(i));
 	sd->parent = parent;
 	parent->child = sd;
-	cpu_to_cpu_group(i, cpu_map, &sd->groups, d->tmpmask);
 #endif
 	return sd;
 }
 
-static void build_sched_groups(struct s_data *d, struct sched_domain *sd,
-			       const struct cpumask *cpu_map, int cpu)
-{
-	switch (sd->level) {
-#ifdef CONFIG_SCHED_SMT
-	case SD_LV_SIBLING: /* set up CPU (sibling) groups */
-		if (cpu == cpumask_first(sched_domain_span(sd)))
-			init_sched_build_groups(sched_domain_span(sd), cpu_map,
-						&cpu_to_cpu_group,
-						d->send_covered, d->tmpmask);
-		break;
-#endif
-#ifdef CONFIG_SCHED_MC
-	case SD_LV_MC: /* set up multi-core groups */
-		if (cpu == cpumask_first(sched_domain_span(sd)))
-			init_sched_build_groups(sched_domain_span(sd), cpu_map,
-						&cpu_to_core_group,
-						d->send_covered, d->tmpmask);
-		break;
-#endif
-#ifdef CONFIG_SCHED_BOOK
-	case SD_LV_BOOK: /* set up book groups */
-		if (cpu == cpumask_first(sched_domain_span(sd)))
-			init_sched_build_groups(sched_domain_span(sd), cpu_map,
-						&cpu_to_book_group,
-						d->send_covered, d->tmpmask);
-		break;
-#endif
-	case SD_LV_CPU: /* set up physical groups */
-		if (cpu == cpumask_first(sched_domain_span(sd)))
-			init_sched_build_groups(sched_domain_span(sd), cpu_map,
-						&cpu_to_phys_group,
-						d->send_covered, d->tmpmask);
-		break;
-#ifdef CONFIG_NUMA
-	case SD_LV_NODE:
-		if (cpu == cpumask_first(sched_domain_span(sd)))
-			init_sched_build_groups(sched_domain_span(sd), cpu_map,
-						&cpu_to_node_group,
-						d->send_covered, d->tmpmask);
-
-	case SD_LV_ALLNODES:
-		if (cpu == cpumask_first(cpu_map))
-			init_sched_build_groups(cpu_map, cpu_map,
-					&cpu_to_allnodes_group,
-					d->send_covered, d->tmpmask);
-		break;
-#endif
-	default:
-		break;
-	}
-}
-
 /*
  * Build sched domains for a given set of cpus and attach the sched domains
  * to the individual cpus
  */
-static int __build_sched_domains(const struct cpumask *cpu_map,
-				 struct sched_domain_attr *attr)
+static int build_sched_domains(const struct cpumask *cpu_map,
+			       struct sched_domain_attr *attr)
 {
 	enum s_alloc alloc_state = sa_none;
+	struct sched_domain *sd;
 	struct s_data d;
-	struct sched_domain *sd, *tmp;
 	int i;
-#ifdef CONFIG_NUMA
-	d.sd_allnodes = 0;
-#endif
 
 	alloc_state = __visit_domain_allocation_hell(&d, cpu_map);
 	if (alloc_state != sa_rootdomain)
 		goto error;
 
-	/*
-	 * Set up domains for cpus specified by the cpu_map.
-	 */
+	/* Set up domains for cpus specified by the cpu_map. */
 	for_each_cpu(i, cpu_map) {
 		cpumask_and(d.nodemask, cpumask_of_node(cpu_to_node(i)),
 			    cpu_map);
@@ -7326,10 +7226,19 @@ static int __build_sched_domains(const struct cpumask *cpu_map,
 		sd = __build_smt_sched_domain(&d, cpu_map, attr, sd, i);
 
 		*per_cpu_ptr(d.sd, i) = sd;
+	}
+
+	/* Build the groups for the domains */
+	for_each_cpu(i, cpu_map) {
+		for (sd = *per_cpu_ptr(d.sd, i); sd; sd = sd->parent) {
+			sd->span_weight = cpumask_weight(sched_domain_span(sd));
+			get_group(i, sd->private, &sd->groups);
+			atomic_inc(&sd->groups->ref);
 
-		for (tmp = sd; tmp; tmp = tmp->parent) {
-			tmp->span_weight = cpumask_weight(sched_domain_span(tmp));
-			build_sched_groups(&d, tmp, cpu_map, i);
+			if (i != cpumask_first(sched_domain_span(sd)))
+				continue;
+
+			build_sched_groups(sd, d.send_covered);
 		}
 	}
 
@@ -7338,18 +7247,21 @@ static int __build_sched_domains(const struct cpumask *cpu_map,
 		if (!cpumask_test_cpu(i, cpu_map))
 			continue;
 
-		sd = *per_cpu_ptr(d.sd, i);
-		for (; sd; sd = sd->parent)
+		for (sd = *per_cpu_ptr(d.sd, i); sd; sd = sd->parent) {
+			claim_allocations(i, sd);
 			init_sched_groups_power(i, sd);
+		}
 	}
 
 	/* Attach the domains */
+	rcu_read_lock();
 	for_each_cpu(i, cpu_map) {
 		sd = *per_cpu_ptr(d.sd, i);
 		cpu_attach_domain(sd, d.rd, i);
 	}
+	rcu_read_unlock();
 
-	__free_domain_allocs(&d, sa_tmpmask, cpu_map);
+	__free_domain_allocs(&d, sa_sd, cpu_map);
 	return 0;
 
 error:
@@ -7357,11 +7269,6 @@ error:
 	return -ENOMEM;
 }
 
-static int build_sched_domains(const struct cpumask *cpu_map)
-{
-	return __build_sched_domains(cpu_map, NULL);
-}
-
 static cpumask_var_t *doms_cur;	/* current sched domains */
 static int ndoms_cur;		/* number of sched domains in 'doms_cur' */
 static struct sched_domain_attr *dattr_cur;
@@ -7425,31 +7332,24 @@ static int init_sched_domains(const struct cpumask *cpu_map)
 		doms_cur = &fallback_doms;
 	cpumask_andnot(doms_cur[0], cpu_map, cpu_isolated_map);
 	dattr_cur = NULL;
-	err = build_sched_domains(doms_cur[0]);
+	err = build_sched_domains(doms_cur[0], NULL);
 	register_sched_domain_sysctl();
 
 	return err;
 }
 
-static void destroy_sched_domains(const struct cpumask *cpu_map,
-				       struct cpumask *tmpmask)
-{
-}
-
 /*
  * Detach sched domains from a group of cpus specified in cpu_map
  * These cpus will now be attached to the NULL domain
  */
 static void detach_destroy_domains(const struct cpumask *cpu_map)
 {
-	/* Save because hotplug lock held. */
-	static DECLARE_BITMAP(tmpmask, CONFIG_NR_CPUS);
 	int i;
 
+	rcu_read_lock();
 	for_each_cpu(i, cpu_map)
 		cpu_attach_domain(NULL, &def_root_domain, i);
-	synchronize_sched();
-	destroy_sched_domains(cpu_map, to_cpumask(tmpmask));
+	rcu_read_unlock();
 }
 
 /* handle null as "default" */
@@ -7538,8 +7438,7 @@ match1:
 				goto match2;
 		}
 		/* no match - add a new doms_new */
-		__build_sched_domains(doms_new[i],
-					dattr_new ? dattr_new + i : NULL);
+		build_sched_domains(doms_new[i], dattr_new ? dattr_new + i : NULL);
 match2:
 		;
 	}
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 4ee50f0..4a8ac7c 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -1622,6 +1622,7 @@ static int select_idle_sibling(struct task_struct *p, int target)
 	/*
 	 * Otherwise, iterate the domains and find an elegible idle cpu.
 	 */
+	rcu_read_lock();
 	for_each_domain(target, sd) {
 		if (!(sd->flags & SD_SHARE_PKG_RESOURCES))
 			break;
@@ -1641,6 +1642,7 @@ static int select_idle_sibling(struct task_struct *p, int target)
 		    cpumask_test_cpu(prev_cpu, sched_domain_span(sd)))
 			break;
 	}
+	rcu_read_unlock();
 
 	return target;
 }
@@ -1673,6 +1675,7 @@ select_task_rq_fair(struct rq *rq, struct task_struct *p, int sd_flag, int wake_
 		new_cpu = prev_cpu;
 	}
 
+	rcu_read_lock();
 	for_each_domain(cpu, tmp) {
 		if (!(tmp->flags & SD_LOAD_BALANCE))
 			continue;
@@ -1723,9 +1726,10 @@ select_task_rq_fair(struct rq *rq, struct task_struct *p, int sd_flag, int wake_
 
 	if (affine_sd) {
 		if (cpu == prev_cpu || wake_affine(affine_sd, p, sync))
-			return select_idle_sibling(p, cpu);
-		else
-			return select_idle_sibling(p, prev_cpu);
+			prev_cpu = cpu;
+
+		new_cpu = select_idle_sibling(p, prev_cpu);
+		goto unlock;
 	}
 
 	while (sd) {
@@ -1766,6 +1770,8 @@ select_task_rq_fair(struct rq *rq, struct task_struct *p, int sd_flag, int wake_
 		}
 		/* while loop will break here if sd == NULL */
 	}
+unlock:
+	rcu_read_unlock();
 
 	return new_cpu;
 }
@@ -3462,6 +3468,7 @@ static void idle_balance(int this_cpu, struct rq *this_rq)
 	raw_spin_unlock(&this_rq->lock);
 
 	update_shares(this_cpu);
+	rcu_read_lock();
 	for_each_domain(this_cpu, sd) {
 		unsigned long interval;
 		int balance = 1;
@@ -3483,6 +3490,7 @@ static void idle_balance(int this_cpu, struct rq *this_rq)
 			break;
 		}
 	}
+	rcu_read_unlock();
 
 	raw_spin_lock(&this_rq->lock);
 
@@ -3531,6 +3539,7 @@ static int active_load_balance_cpu_stop(void *data)
 	double_lock_balance(busiest_rq, target_rq);
 
 	/* Search for an sd spanning us and the target CPU. */
+	rcu_read_lock();
 	for_each_domain(target_cpu, sd) {
 		if ((sd->flags & SD_LOAD_BALANCE) &&
 		    cpumask_test_cpu(busiest_cpu, sched_domain_span(sd)))
@@ -3546,6 +3555,7 @@ static int active_load_balance_cpu_stop(void *data)
 		else
 			schedstat_inc(sd, alb_failed);
 	}
+	rcu_read_unlock();
 	double_unlock_balance(busiest_rq, target_rq);
 out_unlock:
 	busiest_rq->active_balance = 0;
@@ -3672,6 +3682,7 @@ static int find_new_ilb(int cpu)
 {
 	struct sched_domain *sd;
 	struct sched_group *ilb_group;
+	int ilb = nr_cpu_ids;
 
 	/*
 	 * Have idle load balancer selection from semi-idle packages only
@@ -3687,20 +3698,25 @@ static int find_new_ilb(int cpu)
 	if (cpumask_weight(nohz.idle_cpus_mask) < 2)
 		goto out_done;
 
+	rcu_read_lock();
 	for_each_flag_domain(cpu, sd, SD_POWERSAVINGS_BALANCE) {
 		ilb_group = sd->groups;
 
 		do {
-			if (is_semi_idle_group(ilb_group))
-				return cpumask_first(nohz.grp_idle_mask);
+			if (is_semi_idle_group(ilb_group)) {
+				ilb = cpumask_first(nohz.grp_idle_mask);
+				goto unlock;
+			}
 
 			ilb_group = ilb_group->next;
 
 		} while (ilb_group != sd->groups);
 	}
+unlock:
+	rcu_read_unlock();
 
 out_done:
-	return nr_cpu_ids;
+	return ilb;
 }
 #else /*  (CONFIG_SCHED_MC || CONFIG_SCHED_SMT) */
 static inline int find_new_ilb(int call_cpu)
@@ -3845,6 +3861,7 @@ static void rebalance_domains(int cpu, enum cpu_idle_type idle)
 
 	update_shares(cpu);
 
+	rcu_read_lock();
 	for_each_domain(cpu, sd) {
 		if (!(sd->flags & SD_LOAD_BALANCE))
 			continue;
@@ -3890,6 +3907,7 @@ out:
 		if (!balance)
 			break;
 	}
+	rcu_read_unlock();
 
 	/*
 	 * next_balance will be updated only when there is a need.
