Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754011Ab1DKOno (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Apr 2011 10:43:44 -0400
Received: from hera.kernel.org ([140.211.167.34]:50431 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752155Ab1DKOnn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Apr 2011 10:43:43 -0400
Date: Mon, 11 Apr 2011 14:42:50 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Message-ID: <tip-54ab4ff4316eb329d2c1acc110fbc623d2966931@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        torvalds@linux-foundation.org, a.p.zijlstra@chello.nl, efault@gmx.de,
        npiggin@kernel.dk, akpm@linux-foundation.org, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, torvalds@linux-foundation.org, efault@gmx.de,
        npiggin@kernel.dk, akpm@linux-foundation.org, tglx@linutronix.de,
        mingo@elte.hu
In-Reply-To: <20110407122942.924926412@chello.nl>
References: <20110407122942.924926412@chello.nl>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/domains] sched: Move sched domain storage into the topology list
Git-Commit-ID: 54ab4ff4316eb329d2c1acc110fbc623d2966931
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 11 Apr 2011 14:42:51 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  54ab4ff4316eb329d2c1acc110fbc623d2966931
Gitweb:     http://git.kernel.org/tip/54ab4ff4316eb329d2c1acc110fbc623d2966931
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Thu, 7 Apr 2011 14:10:03 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 11 Apr 2011 14:09:31 +0200

sched: Move sched domain storage into the topology list

In order to remove the last dependency on the statid domain levels,
move the sd_data storage into the topology structure.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Nick Piggin <npiggin@kernel.dk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Link: http://lkml.kernel.org/r/20110407122942.924926412@chello.nl
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched.c |  129 +++++++++++++++++++++++++++++++++----------------------
 1 files changed, 77 insertions(+), 52 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 38bc53b..3231e19 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -6837,7 +6837,6 @@ struct sd_data {
 
 struct s_data {
 	struct sched_domain ** __percpu sd;
-	struct sd_data 		sdd[SD_LV_MAX];
 	struct root_domain	*rd;
 };
 
@@ -6848,12 +6847,15 @@ enum s_alloc {
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
@@ -6958,15 +6960,16 @@ static void init_sched_groups_power(int cpu, struct sched_domain *sd)
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
@@ -7019,11 +7022,12 @@ static void set_domain_attribute(struct sched_domain *sd,
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
@@ -7031,14 +7035,7 @@ static void __free_domain_allocs(struct s_data *d, enum s_alloc what,
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
@@ -7047,38 +7044,10 @@ static void __free_domain_allocs(struct s_data *d, enum s_alloc what,
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
@@ -7137,12 +7106,68 @@ static struct sched_domain_topology_level default_topology[] = {
 
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
 
