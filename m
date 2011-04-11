Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753994Ab1DKOnR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Apr 2011 10:43:17 -0400
Received: from hera.kernel.org ([140.211.167.34]:50416 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753834Ab1DKOnN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Apr 2011 10:43:13 -0400
Date: Mon, 11 Apr 2011 14:42:27 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Message-ID: <tip-d069b916f7b50021d41d6ce498f86da32a7afaec@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        torvalds@linux-foundation.org, a.p.zijlstra@chello.nl, efault@gmx.de,
        npiggin@kernel.dk, akpm@linux-foundation.org, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, torvalds@linux-foundation.org, efault@gmx.de,
        npiggin@kernel.dk, akpm@linux-foundation.org, tglx@linutronix.de,
        mingo@elte.hu
In-Reply-To: <20110407122942.876506131@chello.nl>
References: <20110407122942.876506131@chello.nl>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/domains] sched: Reverse the topology list
Git-Commit-ID: d069b916f7b50021d41d6ce498f86da32a7afaec
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 11 Apr 2011 14:42:27 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d069b916f7b50021d41d6ce498f86da32a7afaec
Gitweb:     http://git.kernel.org/tip/d069b916f7b50021d41d6ce498f86da32a7afaec
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Thu, 7 Apr 2011 14:10:02 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 11 Apr 2011 14:09:29 +0200

sched: Reverse the topology list

In order to get rid of static sched_domain::level assignments, reverse
the topology iteration.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Nick Piggin <npiggin@kernel.dk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Link: http://lkml.kernel.org/r/20110407122942.876506131@chello.nl
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched.c |   34 ++++++++++++++++++++--------------
 1 files changed, 20 insertions(+), 14 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 00d1e37..38bc53b 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -7114,20 +7114,23 @@ static const struct cpumask *cpu_smt_mask(int cpu)
 }
 #endif
 
+/*
+ * Topology list, bottom-up.
+ */
 static struct sched_domain_topology_level default_topology[] = {
-#ifdef CONFIG_NUMA
-	{ sd_init_ALLNODES, cpu_allnodes_mask, },
-	{ sd_init_NODE, cpu_node_mask, },
-#endif
-	{ sd_init_CPU, cpu_cpu_mask, },
-#ifdef CONFIG_SCHED_BOOK
-	{ sd_init_BOOK, cpu_book_mask, },
+#ifdef CONFIG_SCHED_SMT
+	{ sd_init_SIBLING, cpu_smt_mask, },
 #endif
 #ifdef CONFIG_SCHED_MC
 	{ sd_init_MC, cpu_coregroup_mask, },
 #endif
-#ifdef CONFIG_SCHED_SMT
-	{ sd_init_SIBLING, cpu_smt_mask, },
+#ifdef CONFIG_SCHED_BOOK
+	{ sd_init_BOOK, cpu_book_mask, },
+#endif
+	{ sd_init_CPU, cpu_cpu_mask, },
+#ifdef CONFIG_NUMA
+	{ sd_init_NODE, cpu_node_mask, },
+	{ sd_init_ALLNODES, cpu_allnodes_mask, },
 #endif
 	{ NULL, },
 };
@@ -7136,18 +7139,18 @@ static struct sched_domain_topology_level *sched_domain_topology = default_topol
 
 struct sched_domain *build_sched_domain(struct sched_domain_topology_level *tl,
 		struct s_data *d, const struct cpumask *cpu_map,
-		struct sched_domain_attr *attr, struct sched_domain *parent,
+		struct sched_domain_attr *attr, struct sched_domain *child,
 		int cpu)
 {
 	struct sched_domain *sd = tl->init(d, cpu);
 	if (!sd)
-		return parent;
+		return child;
 
 	set_domain_attribute(sd, attr);
 	cpumask_and(sched_domain_span(sd), cpu_map, tl->mask(cpu));
-	sd->parent = parent;
-	if (parent)
-		parent->child = sd;
+	if (child)
+		child->parent = sd;
+	sd->child = child;
 
 	return sd;
 }
@@ -7176,6 +7179,9 @@ static int build_sched_domains(const struct cpumask *cpu_map,
 		for (tl = sched_domain_topology; tl->init; tl++)
 			sd = build_sched_domain(tl, &d, cpu_map, attr, sd, i);
 
+		while (sd->child)
+			sd = sd->child;
+
 		*per_cpu_ptr(d.sd, i) = sd;
 	}
 
