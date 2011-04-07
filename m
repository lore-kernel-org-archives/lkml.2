Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755805Ab1DGMmY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 08:42:24 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:60242 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752424Ab1DGMk4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 08:40:56 -0400
Message-Id: <20110407122942.924926412@chello.nl>
User-Agent: quilt/0.48-1
Date: Thu, 07 Apr 2011 14:10:03 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Anton Blanchard <anton@au1.ibm.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Venkatesh Pallipadi <venki@google.com>, Paul Turner <pjt@google.com>,
        Mike Galbraith <efault@gmx.de>, Thomas Gleixner <tglx@linutronix.de>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 22/23] sched: Move sched domain storage into the topology list
References: <20110407120941.400629539@chello.nl>
Content-Disposition: inline; filename=sched-foo20.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In order to remove the last dependency on the statid domain levels,
move the sd_data storage into the topology structure.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/sched.c |  129 ++++++++++++++++++++++++++++++++++-----------------------
 1 file changed, 77 insertions(+), 52 deletions(-)

Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -6813,7 +6813,6 @@ struct sd_data {
 
 struct s_data {
 	struct sched_domain ** __percpu sd;
-	struct sd_data 		sdd[SD_LV_MAX];
 	struct root_domain	*rd;
 };
 
@@ -6824,12 +6823,15 @@ enum s_alloc {
 	sa_none,
 };
 
-typedef struct sched_domain *(*sched_domain_init_f)(struct s_data *d, int cpu);
+struct sched_domain_topology_level;
+
+typedef struct sched_domain *(*sched_domain_init_f)(struct sched_domain_topology_level *tl, int cpu);
 typedef const struct cpumask *(*sched_domain_mask_f)(int cpu);
 
 struct sched_domain_topology_level {
 	sched_domain_init_f init;
 	sched_domain_mask_f mask;
+	struct sd_data      data;
 };
 
 /*
@@ -6934,15 +6936,16 @@ static void init_sched_groups_power(int 
 # define SD_INIT_NAME(sd, type)		do { } while (0)
 #endif
 
-#define SD_INIT_FUNC(type)						       \
-static noinline struct sched_domain *sd_init_##type(struct s_data *d, int cpu) \
-{									       \
-	struct sched_domain *sd = *per_cpu_ptr(d->sdd[SD_LV_##type].sd, cpu);  \
-	*sd = SD_##type##_INIT;						       \
-	sd->level = SD_LV_##type;					       \
-	SD_INIT_NAME(sd, type);						       \
-	sd->private = &d->sdd[SD_LV_##type];				       \
-	return sd;							       \
+#define SD_INIT_FUNC(type)						\
+static noinline struct sched_domain *					\
+sd_init_##type(struct sched_domain_topology_level *tl, int cpu) 	\
+{									\
+	struct sched_domain *sd = *per_cpu_ptr(tl->data.sd, cpu);	\
+	*sd = SD_##type##_INIT;						\
+	sd->level = SD_LV_##type;					\
+	SD_INIT_NAME(sd, type);						\
+	sd->private = &tl->data;					\
+	return sd;							\
 }
 
 SD_INIT_FUNC(CPU)
@@ -6995,11 +6998,12 @@ static void set_domain_attribute(struct 
 	}
 }
 
+static void __sdt_free(const struct cpumask *cpu_map);
+static int __sdt_alloc(const struct cpumask *cpu_map);
+
 static void __free_domain_allocs(struct s_data *d, enum s_alloc what,
 				 const struct cpumask *cpu_map)
 {
-	int i, j;
-
 	switch (what) {
 	case sa_rootdomain:
 		if (!atomic_read(&d->rd->refcount))
@@ -7007,14 +7011,7 @@ static void __free_domain_allocs(struct 
 	case sa_sd:
 		free_percpu(d->sd); /* fall through */
 	case sa_sd_storage:
-		for (i = 0; i < SD_LV_MAX; i++) {
-			for_each_cpu(j, cpu_map) {
-				kfree(*per_cpu_ptr(d->sdd[i].sd, j));
-				kfree(*per_cpu_ptr(d->sdd[i].sg, j));
-			}
-			free_percpu(d->sdd[i].sd);
-			free_percpu(d->sdd[i].sg);
-		} /* fall through */
+		__sdt_free(cpu_map); /* fall through */
 	case sa_none:
 		break;
 	}
@@ -7023,38 +7020,10 @@ static void __free_domain_allocs(struct 
 static enum s_alloc __visit_domain_allocation_hell(struct s_data *d,
 						   const struct cpumask *cpu_map)
 {
-	int i, j;
-
 	memset(d, 0, sizeof(*d));
 
-	for (i = 0; i < SD_LV_MAX; i++) {
-		d->sdd[i].sd = alloc_percpu(struct sched_domain *);
-		if (!d->sdd[i].sd)
-			return sa_sd_storage;
-
-		d->sdd[i].sg = alloc_percpu(struct sched_group *);
-		if (!d->sdd[i].sg)
-			return sa_sd_storage;
-
-		for_each_cpu(j, cpu_map) {
-			struct sched_domain *sd;
-			struct sched_group *sg;
-
-		       	sd = kzalloc_node(sizeof(struct sched_domain) + cpumask_size(),
-					GFP_KERNEL, cpu_to_node(j));
-			if (!sd)
-				return sa_sd_storage;
-
-			*per_cpu_ptr(d->sdd[i].sd, j) = sd;
-
-			sg = kzalloc_node(sizeof(struct sched_group) + cpumask_size(),
-					GFP_KERNEL, cpu_to_node(j));
-			if (!sg)
-				return sa_sd_storage;
-
-			*per_cpu_ptr(d->sdd[i].sg, j) = sg;
-		}
-	}
+	if (__sdt_alloc(cpu_map))
+		return sa_sd_storage;
 	d->sd = alloc_percpu(struct sched_domain *);
 	if (!d->sd)
 		return sa_sd_storage;
@@ -7113,12 +7082,68 @@ static struct sched_domain_topology_leve
 
 static struct sched_domain_topology_level *sched_domain_topology = default_topology;
 
+static int __sdt_alloc(const struct cpumask *cpu_map)
+{
+	struct sched_domain_topology_level *tl;
+	int j;
+
+	for (tl = sched_domain_topology; tl->init; tl++) {
+		struct sd_data *sdd = &tl->data;
+
+		sdd->sd = alloc_percpu(struct sched_domain *);
+		if (!sdd->sd)
+			return -ENOMEM;
+
+		sdd->sg = alloc_percpu(struct sched_group *);
+		if (!sdd->sg)
+			return -ENOMEM;
+
+		for_each_cpu(j, cpu_map) {
+			struct sched_domain *sd;
+			struct sched_group *sg;
+
+		       	sd = kzalloc_node(sizeof(struct sched_domain) + cpumask_size(),
+					GFP_KERNEL, cpu_to_node(j));
+			if (!sd)
+				return -ENOMEM;
+
+			*per_cpu_ptr(sdd->sd, j) = sd;
+
+			sg = kzalloc_node(sizeof(struct sched_group) + cpumask_size(),
+					GFP_KERNEL, cpu_to_node(j));
+			if (!sg)
+				return -ENOMEM;
+
+			*per_cpu_ptr(sdd->sg, j) = sg;
+		}
+	}
+
+	return 0;
+}
+
+static void __sdt_free(const struct cpumask *cpu_map)
+{
+	struct sched_domain_topology_level *tl;
+	int j;
+
+	for (tl = sched_domain_topology; tl->init; tl++) {
+		struct sd_data *sdd = &tl->data;
+
+		for_each_cpu(j, cpu_map) {
+			kfree(*per_cpu_ptr(sdd->sd, j));
+			kfree(*per_cpu_ptr(sdd->sg, j));
+		}
+		free_percpu(sdd->sd);
+		free_percpu(sdd->sg);
+	}
+}
+
 struct sched_domain *build_sched_domain(struct sched_domain_topology_level *tl,
 		struct s_data *d, const struct cpumask *cpu_map,
 		struct sched_domain_attr *attr, struct sched_domain *child,
 		int cpu)
 {
-	struct sched_domain *sd = tl->init(d, cpu);
+	struct sched_domain *sd = tl->init(tl, cpu);
 	if (!sd)
 		return child;
 


