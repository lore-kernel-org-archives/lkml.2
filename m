Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752843Ab1DKOfl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Apr 2011 10:35:41 -0400
Received: from hera.kernel.org ([140.211.167.34]:54418 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752686Ab1DKOfh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Apr 2011 10:35:37 -0400
Date: Mon, 11 Apr 2011 14:34:53 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Message-ID: <tip-a06dadbec5c5df0bf3a35f33616f67d10ca9ba28@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        torvalds@linux-foundation.org, a.p.zijlstra@chello.nl, efault@gmx.de,
        npiggin@kernel.dk, akpm@linux-foundation.org, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, torvalds@linux-foundation.org, efault@gmx.de,
        npiggin@kernel.dk, akpm@linux-foundation.org, tglx@linutronix.de,
        mingo@elte.hu
In-Reply-To: <20110407122941.925028189@chello.nl>
References: <20110407122941.925028189@chello.nl>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/domains] sched: Simplify build_sched_groups()
Git-Commit-ID: a06dadbec5c5df0bf3a35f33616f67d10ca9ba28
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 11 Apr 2011 14:34:53 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a06dadbec5c5df0bf3a35f33616f67d10ca9ba28
Gitweb:     http://git.kernel.org/tip/a06dadbec5c5df0bf3a35f33616f67d10ca9ba28
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Thu, 7 Apr 2011 14:09:44 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 11 Apr 2011 12:58:17 +0200

sched: Simplify build_sched_groups()

Notice that the mask being computed is the same as the domain span we
just computed. By using the domain_span we can avoid some mask
allocations and computations.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Nick Piggin <npiggin@kernel.dk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Link: http://lkml.kernel.org/r/20110407122941.925028189@chello.nl
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched.c |   52 ++++++++++++++++------------------------------------
 1 files changed, 16 insertions(+), 36 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 50d5fd3..e3818f1 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -6866,9 +6866,6 @@ struct s_data {
 	cpumask_var_t		notcovered;
 #endif
 	cpumask_var_t		nodemask;
-	cpumask_var_t		this_sibling_map;
-	cpumask_var_t		this_core_map;
-	cpumask_var_t		this_book_map;
 	cpumask_var_t		send_covered;
 	cpumask_var_t		tmpmask;
 	struct sched_group	**sched_group_nodes;
@@ -6880,9 +6877,6 @@ enum s_alloc {
 	sa_rootdomain,
 	sa_tmpmask,
 	sa_send_covered,
-	sa_this_book_map,
-	sa_this_core_map,
-	sa_this_sibling_map,
 	sa_nodemask,
 	sa_sched_group_nodes,
 #ifdef CONFIG_NUMA
@@ -7251,12 +7245,6 @@ static void __free_domain_allocs(struct s_data *d, enum s_alloc what,
 		free_cpumask_var(d->tmpmask); /* fall through */
 	case sa_send_covered:
 		free_cpumask_var(d->send_covered); /* fall through */
-	case sa_this_book_map:
-		free_cpumask_var(d->this_book_map); /* fall through */
-	case sa_this_core_map:
-		free_cpumask_var(d->this_core_map); /* fall through */
-	case sa_this_sibling_map:
-		free_cpumask_var(d->this_sibling_map); /* fall through */
 	case sa_nodemask:
 		free_cpumask_var(d->nodemask); /* fall through */
 	case sa_sched_group_nodes:
@@ -7295,14 +7283,8 @@ static enum s_alloc __visit_domain_allocation_hell(struct s_data *d,
 #endif
 	if (!alloc_cpumask_var(&d->nodemask, GFP_KERNEL))
 		return sa_sched_group_nodes;
-	if (!alloc_cpumask_var(&d->this_sibling_map, GFP_KERNEL))
-		return sa_nodemask;
-	if (!alloc_cpumask_var(&d->this_core_map, GFP_KERNEL))
-		return sa_this_sibling_map;
-	if (!alloc_cpumask_var(&d->this_book_map, GFP_KERNEL))
-		return sa_this_core_map;
 	if (!alloc_cpumask_var(&d->send_covered, GFP_KERNEL))
-		return sa_this_book_map;
+		return sa_nodemask;
 	if (!alloc_cpumask_var(&d->tmpmask, GFP_KERNEL))
 		return sa_send_covered;
 	d->rd = alloc_rootdomain();
@@ -7414,39 +7396,40 @@ static struct sched_domain *__build_smt_sched_domain(struct s_data *d,
 static void build_sched_groups(struct s_data *d, enum sched_domain_level l,
 			       const struct cpumask *cpu_map, int cpu)
 {
+	struct sched_domain *sd;
+
 	switch (l) {
 #ifdef CONFIG_SCHED_SMT
 	case SD_LV_SIBLING: /* set up CPU (sibling) groups */
-		cpumask_and(d->this_sibling_map, cpu_map,
-			    topology_thread_cpumask(cpu));
-		if (cpu == cpumask_first(d->this_sibling_map))
-			init_sched_build_groups(d->this_sibling_map, cpu_map,
+		sd = &per_cpu(cpu_domains, cpu).sd;
+		if (cpu == cpumask_first(sched_domain_span(sd)))
+			init_sched_build_groups(sched_domain_span(sd), cpu_map,
 						&cpu_to_cpu_group,
 						d->send_covered, d->tmpmask);
 		break;
 #endif
 #ifdef CONFIG_SCHED_MC
 	case SD_LV_MC: /* set up multi-core groups */
-		cpumask_and(d->this_core_map, cpu_map, cpu_coregroup_mask(cpu));
-		if (cpu == cpumask_first(d->this_core_map))
-			init_sched_build_groups(d->this_core_map, cpu_map,
+		sd = &per_cpu(core_domains, cpu).sd;
+		if (cpu == cpumask_first(sched_domain_span(sd)))
+			init_sched_build_groups(sched_domain_span(sd), cpu_map,
 						&cpu_to_core_group,
 						d->send_covered, d->tmpmask);
 		break;
 #endif
 #ifdef CONFIG_SCHED_BOOK
 	case SD_LV_BOOK: /* set up book groups */
-		cpumask_and(d->this_book_map, cpu_map, cpu_book_mask(cpu));
-		if (cpu == cpumask_first(d->this_book_map))
-			init_sched_build_groups(d->this_book_map, cpu_map,
+		sd = &per_cpu(book_domains, cpu).sd;
+		if (cpu == cpumask_first(sched_domain_span(sd)))
+			init_sched_build_groups(sched_domain_span(sd), cpu_map,
 						&cpu_to_book_group,
 						d->send_covered, d->tmpmask);
 		break;
 #endif
 	case SD_LV_CPU: /* set up physical groups */
-		cpumask_and(d->nodemask, cpumask_of_node(cpu), cpu_map);
-		if (!cpumask_empty(d->nodemask))
-			init_sched_build_groups(d->nodemask, cpu_map,
+		sd = &per_cpu(phys_domains, cpu).sd;
+		if (cpu == cpumask_first(sched_domain_span(sd)))
+			init_sched_build_groups(sched_domain_span(sd), cpu_map,
 						&cpu_to_phys_group,
 						d->send_covered, d->tmpmask);
 		break;
@@ -7502,11 +7485,8 @@ static int __build_sched_domains(const struct cpumask *cpu_map,
 		build_sched_groups(&d, SD_LV_SIBLING, cpu_map, i);
 		build_sched_groups(&d, SD_LV_BOOK, cpu_map, i);
 		build_sched_groups(&d, SD_LV_MC, cpu_map, i);
-	}
-
-	/* Set up physical groups */
-	for (i = 0; i < nr_node_ids; i++)
 		build_sched_groups(&d, SD_LV_CPU, cpu_map, i);
+	}
 
 #ifdef CONFIG_NUMA
 	/* Set up node groups */
