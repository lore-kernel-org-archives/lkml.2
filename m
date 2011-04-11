Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753061Ab1DKOhb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Apr 2011 10:37:31 -0400
Received: from hera.kernel.org ([140.211.167.34]:54492 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752261Ab1DKOh3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Apr 2011 10:37:29 -0400
Date: Mon, 11 Apr 2011 14:36:37 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Message-ID: <tip-21d42ccfd6c6c11f96c2acfd32a85cfc33514d3a@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        torvalds@linux-foundation.org, a.p.zijlstra@chello.nl, efault@gmx.de,
        npiggin@kernel.dk, akpm@linux-foundation.org, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, torvalds@linux-foundation.org, efault@gmx.de,
        npiggin@kernel.dk, akpm@linux-foundation.org, tglx@linutronix.de,
        mingo@elte.hu
In-Reply-To: <20110407122942.134511046@chello.nl>
References: <20110407122942.134511046@chello.nl>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/domains] sched: Simplify finding the lowest sched_domain
Git-Commit-ID: 21d42ccfd6c6c11f96c2acfd32a85cfc33514d3a
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 11 Apr 2011 14:36:37 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  21d42ccfd6c6c11f96c2acfd32a85cfc33514d3a
Gitweb:     http://git.kernel.org/tip/21d42ccfd6c6c11f96c2acfd32a85cfc33514d3a
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Thu, 7 Apr 2011 14:09:48 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 11 Apr 2011 12:58:19 +0200

sched: Simplify finding the lowest sched_domain

Instead of relying on knowing the build order and various CONFIG_
flags simply remember the bottom most sched_domain when we created the
domain hierarchy.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Nick Piggin <npiggin@kernel.dk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Link: http://lkml.kernel.org/r/20110407122942.134511046@chello.nl
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched.c |   23 +++++++++++++----------
 1 files changed, 13 insertions(+), 10 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index e66d24a..d6992bf 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -6865,11 +6865,13 @@ struct s_data {
 	cpumask_var_t		nodemask;
 	cpumask_var_t		send_covered;
 	cpumask_var_t		tmpmask;
+	struct sched_domain ** __percpu sd;
 	struct root_domain	*rd;
 };
 
 enum s_alloc {
 	sa_rootdomain,
+	sa_sd,
 	sa_tmpmask,
 	sa_send_covered,
 	sa_nodemask,
@@ -7104,6 +7106,8 @@ static void __free_domain_allocs(struct s_data *d, enum s_alloc what,
 	switch (what) {
 	case sa_rootdomain:
 		free_rootdomain(d->rd); /* fall through */
+	case sa_sd:
+		free_percpu(d->sd); /* fall through */
 	case sa_tmpmask:
 		free_cpumask_var(d->tmpmask); /* fall through */
 	case sa_send_covered:
@@ -7124,10 +7128,15 @@ static enum s_alloc __visit_domain_allocation_hell(struct s_data *d,
 		return sa_nodemask;
 	if (!alloc_cpumask_var(&d->tmpmask, GFP_KERNEL))
 		return sa_send_covered;
+	d->sd = alloc_percpu(struct sched_domain *);
+	if (!d->sd) {
+		printk(KERN_WARNING "Cannot alloc per-cpu pointers\n");
+		return sa_tmpmask;
+	}
 	d->rd = alloc_rootdomain();
 	if (!d->rd) {
 		printk(KERN_WARNING "Cannot alloc root domain\n");
-		return sa_tmpmask;
+		return sa_sd;
 	}
 	return sa_rootdomain;
 }
@@ -7316,6 +7325,8 @@ static int __build_sched_domains(const struct cpumask *cpu_map,
 		sd = __build_mc_sched_domain(&d, cpu_map, attr, sd, i);
 		sd = __build_smt_sched_domain(&d, cpu_map, attr, sd, i);
 
+		*per_cpu_ptr(d.sd, i) = sd;
+
 		for (tmp = sd; tmp; tmp = tmp->parent) {
 			tmp->span_weight = cpumask_weight(sched_domain_span(tmp));
 			build_sched_groups(&d, tmp, cpu_map, i);
@@ -7363,15 +7374,7 @@ static int __build_sched_domains(const struct cpumask *cpu_map,
 
 	/* Attach the domains */
 	for_each_cpu(i, cpu_map) {
-#ifdef CONFIG_SCHED_SMT
-		sd = &per_cpu(cpu_domains, i).sd;
-#elif defined(CONFIG_SCHED_MC)
-		sd = &per_cpu(core_domains, i).sd;
-#elif defined(CONFIG_SCHED_BOOK)
-		sd = &per_cpu(book_domains, i).sd;
-#else
-		sd = &per_cpu(phys_domains, i).sd;
-#endif
+		sd = *per_cpu_ptr(d.sd, i);
 		cpu_attach_domain(sd, d.rd, i);
 	}
 
