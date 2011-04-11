Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753889Ab1DKOkc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Apr 2011 10:40:32 -0400
Received: from hera.kernel.org ([140.211.167.34]:50296 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752773Ab1DKOk1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Apr 2011 10:40:27 -0400
Date: Mon, 11 Apr 2011 14:39:30 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Message-ID: <tip-bf28b253266ebd73c331dde24d64606afde32ceb@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        torvalds@linux-foundation.org, a.p.zijlstra@chello.nl, efault@gmx.de,
        npiggin@kernel.dk, akpm@linux-foundation.org, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, torvalds@linux-foundation.org, efault@gmx.de,
        npiggin@kernel.dk, akpm@linux-foundation.org, tglx@linutronix.de,
        mingo@elte.hu
In-Reply-To: <20110407122942.505608966@chello.nl>
References: <20110407122942.505608966@chello.nl>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/domains] sched: Remove nodemask allocation
Git-Commit-ID: bf28b253266ebd73c331dde24d64606afde32ceb
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 11 Apr 2011 14:39:31 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  bf28b253266ebd73c331dde24d64606afde32ceb
Gitweb:     http://git.kernel.org/tip/bf28b253266ebd73c331dde24d64606afde32ceb
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Thu, 7 Apr 2011 14:09:55 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 11 Apr 2011 12:58:22 +0200

sched: Remove nodemask allocation

There's only one nodemask user left so remove it with a direct
computation and save some memory and reduce some code-flow
complexity.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Nick Piggin <npiggin@kernel.dk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Link: http://lkml.kernel.org/r/20110407122942.505608966@chello.nl
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched.c |   14 +++-----------
 1 files changed, 3 insertions(+), 11 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index d395fe5..f4d3a62 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -6838,7 +6838,6 @@ struct sd_data {
 };
 
 struct s_data {
-	cpumask_var_t		nodemask;
 	cpumask_var_t		send_covered;
 	struct sched_domain ** __percpu sd;
 	struct sd_data 		sdd[SD_LV_MAX];
@@ -6850,7 +6849,6 @@ enum s_alloc {
 	sa_sd,
 	sa_sd_storage,
 	sa_send_covered,
-	sa_nodemask,
 	sa_none,
 };
 
@@ -7035,8 +7033,6 @@ static void __free_domain_allocs(struct s_data *d, enum s_alloc what,
 		} /* fall through */
 	case sa_send_covered:
 		free_cpumask_var(d->send_covered); /* fall through */
-	case sa_nodemask:
-		free_cpumask_var(d->nodemask); /* fall through */
 	case sa_none:
 		break;
 	}
@@ -7049,10 +7045,8 @@ static enum s_alloc __visit_domain_allocation_hell(struct s_data *d,
 
 	memset(d, 0, sizeof(*d));
 
-	if (!alloc_cpumask_var(&d->nodemask, GFP_KERNEL))
-		return sa_none;
 	if (!alloc_cpumask_var(&d->send_covered, GFP_KERNEL))
-		return sa_nodemask;
+		return sa_none;
 	for (i = 0; i < SD_LV_MAX; i++) {
 		d->sdd[i].sd = alloc_percpu(struct sched_domain *);
 		if (!d->sdd[i].sd)
@@ -7149,7 +7143,8 @@ static struct sched_domain *__build_cpu_sched_domain(struct s_data *d,
 	struct sched_domain *sd;
 	sd = sd_init_CPU(d, i);
 	set_domain_attribute(sd, attr);
-	cpumask_copy(sched_domain_span(sd), d->nodemask);
+	cpumask_and(sched_domain_span(sd),
+			cpumask_of_node(cpu_to_node(i)), cpu_map);
 	sd->parent = parent;
 	if (parent)
 		parent->child = sd;
@@ -7219,9 +7214,6 @@ static int build_sched_domains(const struct cpumask *cpu_map,
 
 	/* Set up domains for cpus specified by the cpu_map. */
 	for_each_cpu(i, cpu_map) {
-		cpumask_and(d.nodemask, cpumask_of_node(cpu_to_node(i)),
-			    cpu_map);
-
 		sd = NULL;
 		sd = __build_allnodes_sched_domain(&d, cpu_map, attr, sd, i);
 		sd = __build_node_sched_domain(&d, cpu_map, attr, sd, i);
