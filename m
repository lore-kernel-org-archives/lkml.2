Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753869Ab1DKOj7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Apr 2011 10:39:59 -0400
Received: from hera.kernel.org ([140.211.167.34]:50240 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753222Ab1DKOj5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Apr 2011 10:39:57 -0400
Date: Mon, 11 Apr 2011 14:39:06 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Message-ID: <tip-3bd65a80affb9768b91f03c56dba46ee79525f9b@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        torvalds@linux-foundation.org, a.p.zijlstra@chello.nl, efault@gmx.de,
        npiggin@kernel.dk, akpm@linux-foundation.org, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, torvalds@linux-foundation.org, efault@gmx.de,
        npiggin@kernel.dk, akpm@linux-foundation.org, tglx@linutronix.de,
        mingo@elte.hu
In-Reply-To: <20110407122942.455464579@chello.nl>
References: <20110407122942.455464579@chello.nl>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/domains] sched: Simplify NODE/ALLNODES domain creation
Git-Commit-ID: 3bd65a80affb9768b91f03c56dba46ee79525f9b
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 11 Apr 2011 14:39:07 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3bd65a80affb9768b91f03c56dba46ee79525f9b
Gitweb:     http://git.kernel.org/tip/3bd65a80affb9768b91f03c56dba46ee79525f9b
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Thu, 7 Apr 2011 14:09:54 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 11 Apr 2011 12:58:21 +0200

sched: Simplify NODE/ALLNODES domain creation

Don't treat ALLNODES/NODE different for difference's sake. Simply
always create the ALLNODES domain and let the sd_degenerate() checks
kill it when its redundant. This simplifies the code flow.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Nick Piggin <npiggin@kernel.dk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Link: http://lkml.kernel.org/r/20110407122942.455464579@chello.nl
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched.c |   40 ++++++++++++++++++++++------------------
 1 files changed, 22 insertions(+), 18 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 72c194c..d395fe5 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -6838,9 +6838,6 @@ struct sd_data {
 };
 
 struct s_data {
-#ifdef CONFIG_NUMA
-	int			sd_allnodes;
-#endif
 	cpumask_var_t		nodemask;
 	cpumask_var_t		send_covered;
 	struct sched_domain ** __percpu sd;
@@ -7112,30 +7109,35 @@ static void claim_allocations(int cpu, struct sched_domain *sd)
 	}
 }
 
-static struct sched_domain *__build_numa_sched_domains(struct s_data *d,
-	const struct cpumask *cpu_map, struct sched_domain_attr *attr, int i)
+static struct sched_domain *__build_allnodes_sched_domain(struct s_data *d,
+	const struct cpumask *cpu_map, struct sched_domain_attr *attr,
+	struct sched_domain *parent, int i)
 {
 	struct sched_domain *sd = NULL;
 #ifdef CONFIG_NUMA
-	struct sched_domain *parent;
-
-	d->sd_allnodes = 0;
-	if (cpumask_weight(cpu_map) >
-	    SD_NODES_PER_DOMAIN * cpumask_weight(d->nodemask)) {
-		sd = sd_init_ALLNODES(d, i);
-		set_domain_attribute(sd, attr);
-		cpumask_copy(sched_domain_span(sd), cpu_map);
-		d->sd_allnodes = 1;
-	}
-	parent = sd;
+	sd = sd_init_ALLNODES(d, i);
+	set_domain_attribute(sd, attr);
+	cpumask_copy(sched_domain_span(sd), cpu_map);
+	sd->parent = parent;
+	if (parent)
+		parent->child = sd;
+#endif
+	return sd;
+}
 
+static struct sched_domain *__build_node_sched_domain(struct s_data *d,
+	const struct cpumask *cpu_map, struct sched_domain_attr *attr,
+	struct sched_domain *parent, int i)
+{
+	struct sched_domain *sd = NULL;
+#ifdef CONFIG_NUMA
 	sd = sd_init_NODE(d, i);
 	set_domain_attribute(sd, attr);
 	sched_domain_node_span(cpu_to_node(i), sched_domain_span(sd));
+	cpumask_and(sched_domain_span(sd), sched_domain_span(sd), cpu_map);
 	sd->parent = parent;
 	if (parent)
 		parent->child = sd;
-	cpumask_and(sched_domain_span(sd), sched_domain_span(sd), cpu_map);
 #endif
 	return sd;
 }
@@ -7220,7 +7222,9 @@ static int build_sched_domains(const struct cpumask *cpu_map,
 		cpumask_and(d.nodemask, cpumask_of_node(cpu_to_node(i)),
 			    cpu_map);
 
-		sd = __build_numa_sched_domains(&d, cpu_map, attr, i);
+		sd = NULL;
+		sd = __build_allnodes_sched_domain(&d, cpu_map, attr, sd, i);
+		sd = __build_node_sched_domain(&d, cpu_map, attr, sd, i);
 		sd = __build_cpu_sched_domain(&d, cpu_map, attr, sd, i);
 		sd = __build_book_sched_domain(&d, cpu_map, attr, sd, i);
 		sd = __build_mc_sched_domain(&d, cpu_map, attr, sd, i);
