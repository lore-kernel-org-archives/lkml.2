Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752676Ab1DKOfS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Apr 2011 10:35:18 -0400
Received: from hera.kernel.org ([140.211.167.34]:54407 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752493Ab1DKOfQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Apr 2011 10:35:16 -0400
Date: Mon, 11 Apr 2011 14:34:26 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Message-ID: <tip-d274cb30f4a08045492d3f0c47cdf1a25668b1f5@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        torvalds@linux-foundation.org, a.p.zijlstra@chello.nl, efault@gmx.de,
        npiggin@kernel.dk, akpm@linux-foundation.org, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, torvalds@linux-foundation.org, efault@gmx.de,
        npiggin@kernel.dk, akpm@linux-foundation.org, tglx@linutronix.de,
        mingo@elte.hu
In-Reply-To: <20110407122941.875856012@chello.nl>
References: <20110407122941.875856012@chello.nl>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/domains] sched: Simplify ->cpu_power initialization
Git-Commit-ID: d274cb30f4a08045492d3f0c47cdf1a25668b1f5
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 11 Apr 2011 14:34:26 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d274cb30f4a08045492d3f0c47cdf1a25668b1f5
Gitweb:     http://git.kernel.org/tip/d274cb30f4a08045492d3f0c47cdf1a25668b1f5
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Thu, 7 Apr 2011 14:09:43 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 11 Apr 2011 12:58:16 +0200

sched: Simplify ->cpu_power initialization

The code in update_group_power() does what init_sched_groups_power()
does and more, so remove the special init_ code and call the generic
code instead.

Also move the sd->span_weight initialization because
update_group_power() needs it.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Nick Piggin <npiggin@kernel.dk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Link: http://lkml.kernel.org/r/20110407122941.875856012@chello.nl
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched.c |   44 +++++---------------------------------------
 1 files changed, 5 insertions(+), 39 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index d3e183c..50d5fd3 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -6679,9 +6679,6 @@ cpu_attach_domain(struct sched_domain *sd, struct root_domain *rd, int cpu)
 	struct rq *rq = cpu_rq(cpu);
 	struct sched_domain *tmp;
 
-	for (tmp = sd; tmp; tmp = tmp->parent)
-		tmp->span_weight = cpumask_weight(sched_domain_span(tmp));
-
 	/* Remove the sched domains which do not contribute to scheduling. */
 	for (tmp = sd; tmp; ) {
 		struct sched_domain *parent = tmp->parent;
@@ -7159,11 +7156,6 @@ static void free_sched_groups(const struct cpumask *cpu_map,
  */
 static void init_sched_groups_power(int cpu, struct sched_domain *sd)
 {
-	struct sched_domain *child;
-	struct sched_group *group;
-	long power;
-	int weight;
-
 	WARN_ON(!sd || !sd->groups);
 
 	if (cpu != group_first_cpu(sd->groups))
@@ -7171,36 +7163,7 @@ static void init_sched_groups_power(int cpu, struct sched_domain *sd)
 
 	sd->groups->group_weight = cpumask_weight(sched_group_cpus(sd->groups));
 
-	child = sd->child;
-
-	sd->groups->cpu_power = 0;
-
-	if (!child) {
-		power = SCHED_LOAD_SCALE;
-		weight = cpumask_weight(sched_domain_span(sd));
-		/*
-		 * SMT siblings share the power of a single core.
-		 * Usually multiple threads get a better yield out of
-		 * that one core than a single thread would have,
-		 * reflect that in sd->smt_gain.
-		 */
-		if ((sd->flags & SD_SHARE_CPUPOWER) && weight > 1) {
-			power *= sd->smt_gain;
-			power /= weight;
-			power >>= SCHED_LOAD_SHIFT;
-		}
-		sd->groups->cpu_power += power;
-		return;
-	}
-
-	/*
-	 * Add cpu_power of each child group to this groups cpu_power.
-	 */
-	group = child->groups;
-	do {
-		sd->groups->cpu_power += group->cpu_power;
-		group = group->next;
-	} while (group != child->groups);
+	update_group_power(sd, cpu);
 }
 
 /*
@@ -7507,7 +7470,7 @@ static int __build_sched_domains(const struct cpumask *cpu_map,
 {
 	enum s_alloc alloc_state = sa_none;
 	struct s_data d;
-	struct sched_domain *sd;
+	struct sched_domain *sd, *tmp;
 	int i;
 #ifdef CONFIG_NUMA
 	d.sd_allnodes = 0;
@@ -7530,6 +7493,9 @@ static int __build_sched_domains(const struct cpumask *cpu_map,
 		sd = __build_book_sched_domain(&d, cpu_map, attr, sd, i);
 		sd = __build_mc_sched_domain(&d, cpu_map, attr, sd, i);
 		sd = __build_smt_sched_domain(&d, cpu_map, attr, sd, i);
+
+		for (tmp = sd; tmp; tmp = tmp->parent)
+			tmp->span_weight = cpumask_weight(sched_domain_span(tmp));
 	}
 
 	for_each_cpu(i, cpu_map) {
