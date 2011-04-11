Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753649Ab1DKOlc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Apr 2011 10:41:32 -0400
Received: from hera.kernel.org ([140.211.167.34]:50347 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752503Ab1DKOla (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Apr 2011 10:41:30 -0400
Date: Mon, 11 Apr 2011 14:41:11 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Message-ID: <tip-d3081f52f29da1ba6c27685519a9222b39eac763@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        torvalds@linux-foundation.org, a.p.zijlstra@chello.nl, efault@gmx.de,
        npiggin@kernel.dk, akpm@linux-foundation.org, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, torvalds@linux-foundation.org, efault@gmx.de,
        npiggin@kernel.dk, akpm@linux-foundation.org, tglx@linutronix.de,
        mingo@elte.hu
In-Reply-To: <20110407122942.717702108@chello.nl>
References: <20110407122942.717702108@chello.nl>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/domains] sched: Create proper cpu_$DOM_mask() functions
Git-Commit-ID: d3081f52f29da1ba6c27685519a9222b39eac763
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 11 Apr 2011 14:41:11 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d3081f52f29da1ba6c27685519a9222b39eac763
Gitweb:     http://git.kernel.org/tip/d3081f52f29da1ba6c27685519a9222b39eac763
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Thu, 7 Apr 2011 14:09:59 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 11 Apr 2011 14:09:24 +0200

sched: Create proper cpu_$DOM_mask() functions

In order to unify the sched domain creation more, create proper
cpu_$DOM_mask() functions for those domains that didn't already have
one.

Use the sched_domains_tmpmask for the weird NUMA domain span.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Nick Piggin <npiggin@kernel.dk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Link: http://lkml.kernel.org/r/20110407122942.717702108@chello.nl
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched.c |   22 +++++++++++++++++-----
 1 files changed, 17 insertions(+), 5 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 35fc995..3ae1e02 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -6807,8 +6807,22 @@ static void sched_domain_node_span(int node, struct cpumask *span)
 		cpumask_or(span, span, cpumask_of_node(next_node));
 	}
 }
+
+static const struct cpumask *cpu_node_mask(int cpu)
+{
+	lockdep_assert_held(&sched_domains_mutex);
+
+	sched_domain_node_span(cpu_to_node(cpu), sched_domains_tmpmask);
+
+	return sched_domains_tmpmask;
+}
 #endif /* CONFIG_NUMA */
 
+static const struct cpumask *cpu_cpu_mask(int cpu)
+{
+	return cpumask_of_node(cpu_to_node(cpu));
+}
+
 int sched_smt_power_savings = 0, sched_mc_power_savings = 0;
 
 struct sd_data {
@@ -7088,7 +7102,7 @@ static struct sched_domain *__build_allnodes_sched_domain(struct s_data *d,
 #ifdef CONFIG_NUMA
 	sd = sd_init_ALLNODES(d, i);
 	set_domain_attribute(sd, attr);
-	cpumask_copy(sched_domain_span(sd), cpu_map);
+	cpumask_and(sched_domain_span(sd), cpu_map, cpu_possible_mask);
 	sd->parent = parent;
 	if (parent)
 		parent->child = sd;
@@ -7104,8 +7118,7 @@ static struct sched_domain *__build_node_sched_domain(struct s_data *d,
 #ifdef CONFIG_NUMA
 	sd = sd_init_NODE(d, i);
 	set_domain_attribute(sd, attr);
-	sched_domain_node_span(cpu_to_node(i), sched_domain_span(sd));
-	cpumask_and(sched_domain_span(sd), sched_domain_span(sd), cpu_map);
+	cpumask_and(sched_domain_span(sd), cpu_map, cpu_node_mask(i));
 	sd->parent = parent;
 	if (parent)
 		parent->child = sd;
@@ -7120,8 +7133,7 @@ static struct sched_domain *__build_cpu_sched_domain(struct s_data *d,
 	struct sched_domain *sd;
 	sd = sd_init_CPU(d, i);
 	set_domain_attribute(sd, attr);
-	cpumask_and(sched_domain_span(sd),
-			cpumask_of_node(cpu_to_node(i)), cpu_map);
+	cpumask_and(sched_domain_span(sd), cpu_map, cpu_cpu_mask(i));
 	sd->parent = parent;
 	if (parent)
 		parent->child = sd;
