Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753558Ab1DKOm0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Apr 2011 10:42:26 -0400
Received: from hera.kernel.org ([140.211.167.34]:50384 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751803Ab1DKOmY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Apr 2011 10:42:24 -0400
Date: Mon, 11 Apr 2011 14:42:00 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Message-ID: <tip-2c402dc3bb502e9dd74fce72c14d293fcef4719d@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        torvalds@linux-foundation.org, a.p.zijlstra@chello.nl, efault@gmx.de,
        npiggin@kernel.dk, akpm@linux-foundation.org, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, torvalds@linux-foundation.org, efault@gmx.de,
        npiggin@kernel.dk, akpm@linux-foundation.org, tglx@linutronix.de,
        mingo@elte.hu
In-Reply-To: <20110407122942.826347257@chello.nl>
References: <20110407122942.826347257@chello.nl>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/domains] sched: Unify the sched_domain build functions
Git-Commit-ID: 2c402dc3bb502e9dd74fce72c14d293fcef4719d
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 11 Apr 2011 14:42:00 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2c402dc3bb502e9dd74fce72c14d293fcef4719d
Gitweb:     http://git.kernel.org/tip/2c402dc3bb502e9dd74fce72c14d293fcef4719d
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Thu, 7 Apr 2011 14:10:01 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 11 Apr 2011 14:09:27 +0200

sched: Unify the sched_domain build functions

Since all the __build_$DOM_sched_domain() functions do pretty much the
same thing, unify them.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Nick Piggin <npiggin@kernel.dk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Link: http://lkml.kernel.org/r/20110407122942.826347257@chello.nl
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched.c |  133 ++++++++++++++++---------------------------------------
 1 files changed, 39 insertions(+), 94 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index f0e1821..00d1e37 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -6816,6 +6816,11 @@ static const struct cpumask *cpu_node_mask(int cpu)
 
 	return sched_domains_tmpmask;
 }
+
+static const struct cpumask *cpu_allnodes_mask(int cpu)
+{
+	return cpu_possible_mask;
+}
 #endif /* CONFIG_NUMA */
 
 static const struct cpumask *cpu_cpu_mask(int cpu)
@@ -6843,14 +6848,12 @@ enum s_alloc {
 	sa_none,
 };
 
-typedef struct sched_domain *(*sched_domain_build_f)(struct s_data *d,
-		const struct cpumask *cpu_map, struct sched_domain_attr *attr,
-		struct sched_domain *parent, int cpu);
-
+typedef struct sched_domain *(*sched_domain_init_f)(struct s_data *d, int cpu);
 typedef const struct cpumask *(*sched_domain_mask_f)(int cpu);
 
 struct sched_domain_topology_level {
-	sched_domain_build_f build;
+	sched_domain_init_f init;
+	sched_domain_mask_f mask;
 };
 
 /*
@@ -7104,109 +7107,51 @@ static void claim_allocations(int cpu, struct sched_domain *sd)
 	}
 }
 
-static struct sched_domain *__build_allnodes_sched_domain(struct s_data *d,
-	const struct cpumask *cpu_map, struct sched_domain_attr *attr,
-	struct sched_domain *parent, int i)
+#ifdef CONFIG_SCHED_SMT
+static const struct cpumask *cpu_smt_mask(int cpu)
 {
-	struct sched_domain *sd = NULL;
-#ifdef CONFIG_NUMA
-	sd = sd_init_ALLNODES(d, i);
-	set_domain_attribute(sd, attr);
-	cpumask_and(sched_domain_span(sd), cpu_map, cpu_possible_mask);
-	sd->parent = parent;
-	if (parent)
-		parent->child = sd;
-#endif
-	return sd;
+	return topology_thread_cpumask(cpu);
 }
+#endif
 
-static struct sched_domain *__build_node_sched_domain(struct s_data *d,
-	const struct cpumask *cpu_map, struct sched_domain_attr *attr,
-	struct sched_domain *parent, int i)
-{
-	struct sched_domain *sd = NULL;
+static struct sched_domain_topology_level default_topology[] = {
 #ifdef CONFIG_NUMA
-	sd = sd_init_NODE(d, i);
-	set_domain_attribute(sd, attr);
-	cpumask_and(sched_domain_span(sd), cpu_map, cpu_node_mask(i));
-	sd->parent = parent;
-	if (parent)
-		parent->child = sd;
+	{ sd_init_ALLNODES, cpu_allnodes_mask, },
+	{ sd_init_NODE, cpu_node_mask, },
 #endif
-	return sd;
-}
-
-static struct sched_domain *__build_cpu_sched_domain(struct s_data *d,
-	const struct cpumask *cpu_map, struct sched_domain_attr *attr,
-	struct sched_domain *parent, int i)
-{
-	struct sched_domain *sd;
-	sd = sd_init_CPU(d, i);
-	set_domain_attribute(sd, attr);
-	cpumask_and(sched_domain_span(sd), cpu_map, cpu_cpu_mask(i));
-	sd->parent = parent;
-	if (parent)
-		parent->child = sd;
-	return sd;
-}
-
-static struct sched_domain *__build_book_sched_domain(struct s_data *d,
-	const struct cpumask *cpu_map, struct sched_domain_attr *attr,
-	struct sched_domain *parent, int i)
-{
-	struct sched_domain *sd = parent;
+	{ sd_init_CPU, cpu_cpu_mask, },
 #ifdef CONFIG_SCHED_BOOK
-	sd = sd_init_BOOK(d, i);
-	set_domain_attribute(sd, attr);
-	cpumask_and(sched_domain_span(sd), cpu_map, cpu_book_mask(i));
-	sd->parent = parent;
-	parent->child = sd;
+	{ sd_init_BOOK, cpu_book_mask, },
 #endif
-	return sd;
-}
-
-static struct sched_domain *__build_mc_sched_domain(struct s_data *d,
-	const struct cpumask *cpu_map, struct sched_domain_attr *attr,
-	struct sched_domain *parent, int i)
-{
-	struct sched_domain *sd = parent;
 #ifdef CONFIG_SCHED_MC
-	sd = sd_init_MC(d, i);
-	set_domain_attribute(sd, attr);
-	cpumask_and(sched_domain_span(sd), cpu_map, cpu_coregroup_mask(i));
-	sd->parent = parent;
-	parent->child = sd;
+	{ sd_init_MC, cpu_coregroup_mask, },
 #endif
-	return sd;
-}
-
-static struct sched_domain *__build_smt_sched_domain(struct s_data *d,
-	const struct cpumask *cpu_map, struct sched_domain_attr *attr,
-	struct sched_domain *parent, int i)
-{
-	struct sched_domain *sd = parent;
 #ifdef CONFIG_SCHED_SMT
-	sd = sd_init_SIBLING(d, i);
-	set_domain_attribute(sd, attr);
-	cpumask_and(sched_domain_span(sd), cpu_map, topology_thread_cpumask(i));
-	sd->parent = parent;
-	parent->child = sd;
+	{ sd_init_SIBLING, cpu_smt_mask, },
 #endif
-	return sd;
-}
-
-static struct sched_domain_topology_level default_topology[] = {
-	{ __build_allnodes_sched_domain, },
-	{ __build_node_sched_domain, },
-	{ __build_cpu_sched_domain, },
-	{ __build_book_sched_domain, },
-	{ __build_mc_sched_domain, },
-	{ __build_smt_sched_domain, },
 	{ NULL, },
 };
 
 static struct sched_domain_topology_level *sched_domain_topology = default_topology;
 
+struct sched_domain *build_sched_domain(struct sched_domain_topology_level *tl,
+		struct s_data *d, const struct cpumask *cpu_map,
+		struct sched_domain_attr *attr, struct sched_domain *parent,
+		int cpu)
+{
+	struct sched_domain *sd = tl->init(d, cpu);
+	if (!sd)
+		return parent;
+
+	set_domain_attribute(sd, attr);
+	cpumask_and(sched_domain_span(sd), cpu_map, tl->mask(cpu));
+	sd->parent = parent;
+	if (parent)
+		parent->child = sd;
+
+	return sd;
+}
+
 /*
  * Build sched domains for a given set of cpus and attach the sched domains
  * to the individual cpus
@@ -7228,8 +7173,8 @@ static int build_sched_domains(const struct cpumask *cpu_map,
 		struct sched_domain_topology_level *tl;
 
 		sd = NULL;
-		for (tl = sched_domain_topology; tl->build; tl++)
-			sd = tl->build(&d, cpu_map, attr, sd, i);
+		for (tl = sched_domain_topology; tl->init; tl++)
+			sd = build_sched_domain(tl, &d, cpu_map, attr, sd, i);
 
 		*per_cpu_ptr(d.sd, i) = sd;
 	}
