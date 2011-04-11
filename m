Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753200Ab1DKOhI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Apr 2011 10:37:08 -0400
Received: from hera.kernel.org ([140.211.167.34]:54479 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752045Ab1DKOhG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Apr 2011 10:37:06 -0400
Date: Mon, 11 Apr 2011 14:36:09 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Message-ID: <tip-1cf51902546d60b8a7a6aba2dd557bd4ba8840ea@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        torvalds@linux-foundation.org, a.p.zijlstra@chello.nl, efault@gmx.de,
        npiggin@kernel.dk, akpm@linux-foundation.org, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, torvalds@linux-foundation.org, efault@gmx.de,
        npiggin@kernel.dk, akpm@linux-foundation.org, tglx@linutronix.de,
        mingo@elte.hu
In-Reply-To: <20110407122942.077862519@chello.nl>
References: <20110407122942.077862519@chello.nl>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/domains] sched: Simplify sched_group creation
Git-Commit-ID: 1cf51902546d60b8a7a6aba2dd557bd4ba8840ea
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 11 Apr 2011 14:36:09 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1cf51902546d60b8a7a6aba2dd557bd4ba8840ea
Gitweb:     http://git.kernel.org/tip/1cf51902546d60b8a7a6aba2dd557bd4ba8840ea
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Thu, 7 Apr 2011 14:09:47 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 11 Apr 2011 12:58:18 +0200

sched: Simplify sched_group creation

Instead of calling build_sched_groups() for each possible sched_domain
we might have created, note that we can simply iterate the
sched_domain tree and call it for each sched_domain present.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Nick Piggin <npiggin@kernel.dk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Link: http://lkml.kernel.org/r/20110407122942.077862519@chello.nl
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched.c |   24 +++++-------------------
 1 files changed, 5 insertions(+), 19 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index fa10cf7..e66d24a 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -7231,15 +7231,12 @@ static struct sched_domain *__build_smt_sched_domain(struct s_data *d,
 	return sd;
 }
 
-static void build_sched_groups(struct s_data *d, enum sched_domain_level l,
+static void build_sched_groups(struct s_data *d, struct sched_domain *sd,
 			       const struct cpumask *cpu_map, int cpu)
 {
-	struct sched_domain *sd;
-
-	switch (l) {
+	switch (sd->level) {
 #ifdef CONFIG_SCHED_SMT
 	case SD_LV_SIBLING: /* set up CPU (sibling) groups */
-		sd = &per_cpu(cpu_domains, cpu).sd;
 		if (cpu == cpumask_first(sched_domain_span(sd)))
 			init_sched_build_groups(sched_domain_span(sd), cpu_map,
 						&cpu_to_cpu_group,
@@ -7248,7 +7245,6 @@ static void build_sched_groups(struct s_data *d, enum sched_domain_level l,
 #endif
 #ifdef CONFIG_SCHED_MC
 	case SD_LV_MC: /* set up multi-core groups */
-		sd = &per_cpu(core_domains, cpu).sd;
 		if (cpu == cpumask_first(sched_domain_span(sd)))
 			init_sched_build_groups(sched_domain_span(sd), cpu_map,
 						&cpu_to_core_group,
@@ -7257,7 +7253,6 @@ static void build_sched_groups(struct s_data *d, enum sched_domain_level l,
 #endif
 #ifdef CONFIG_SCHED_BOOK
 	case SD_LV_BOOK: /* set up book groups */
-		sd = &per_cpu(book_domains, cpu).sd;
 		if (cpu == cpumask_first(sched_domain_span(sd)))
 			init_sched_build_groups(sched_domain_span(sd), cpu_map,
 						&cpu_to_book_group,
@@ -7265,7 +7260,6 @@ static void build_sched_groups(struct s_data *d, enum sched_domain_level l,
 		break;
 #endif
 	case SD_LV_CPU: /* set up physical groups */
-		sd = &per_cpu(phys_domains, cpu).sd;
 		if (cpu == cpumask_first(sched_domain_span(sd)))
 			init_sched_build_groups(sched_domain_span(sd), cpu_map,
 						&cpu_to_phys_group,
@@ -7273,7 +7267,6 @@ static void build_sched_groups(struct s_data *d, enum sched_domain_level l,
 		break;
 #ifdef CONFIG_NUMA
 	case SD_LV_NODE:
-		sd = &per_cpu(node_domains, cpu).sd;
 		if (cpu == cpumask_first(sched_domain_span(sd)))
 			init_sched_build_groups(sched_domain_span(sd), cpu_map,
 						&cpu_to_node_group,
@@ -7323,17 +7316,10 @@ static int __build_sched_domains(const struct cpumask *cpu_map,
 		sd = __build_mc_sched_domain(&d, cpu_map, attr, sd, i);
 		sd = __build_smt_sched_domain(&d, cpu_map, attr, sd, i);
 
-		for (tmp = sd; tmp; tmp = tmp->parent)
+		for (tmp = sd; tmp; tmp = tmp->parent) {
 			tmp->span_weight = cpumask_weight(sched_domain_span(tmp));
-	}
-
-	for_each_cpu(i, cpu_map) {
-		build_sched_groups(&d, SD_LV_SIBLING, cpu_map, i);
-		build_sched_groups(&d, SD_LV_BOOK, cpu_map, i);
-		build_sched_groups(&d, SD_LV_MC, cpu_map, i);
-		build_sched_groups(&d, SD_LV_CPU, cpu_map, i);
-		build_sched_groups(&d, SD_LV_NODE, cpu_map, i);
-		build_sched_groups(&d, SD_LV_ALLNODES, cpu_map, i);
+			build_sched_groups(&d, tmp, cpu_map, i);
+		}
 	}
 
 	/* Calculate CPU power for physical packages and nodes */
