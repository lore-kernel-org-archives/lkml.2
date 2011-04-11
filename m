Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753879Ab1DKOlI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Apr 2011 10:41:08 -0400
Received: from hera.kernel.org ([140.211.167.34]:50333 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752727Ab1DKOlE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Apr 2011 10:41:04 -0400
Date: Mon, 11 Apr 2011 14:40:48 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Message-ID: <tip-4cb988395da6e16627a8be69729e50cd72ebb23e@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        torvalds@linux-foundation.org, a.p.zijlstra@chello.nl, efault@gmx.de,
        npiggin@kernel.dk, akpm@linux-foundation.org, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, torvalds@linux-foundation.org, efault@gmx.de,
        npiggin@kernel.dk, akpm@linux-foundation.org, tglx@linutronix.de,
        mingo@elte.hu
In-Reply-To: <20110407122942.664347467@chello.nl>
References: <20110407122942.664347467@chello.nl>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/domains] sched: Avoid allocations in sched_domain_debug()
Git-Commit-ID: 4cb988395da6e16627a8be69729e50cd72ebb23e
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 11 Apr 2011 14:40:48 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4cb988395da6e16627a8be69729e50cd72ebb23e
Gitweb:     http://git.kernel.org/tip/4cb988395da6e16627a8be69729e50cd72ebb23e
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Thu, 7 Apr 2011 14:09:58 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 11 Apr 2011 14:05:00 +0200

sched: Avoid allocations in sched_domain_debug()

Since we're all serialized by sched_domains_mutex we can use
sched_domains_tmpmask and avoid having to do allocations. This means
we can use sched_domains_debug() for cpu_attach_domain() again.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Nick Piggin <npiggin@kernel.dk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Link: http://lkml.kernel.org/r/20110407122942.664347467@chello.nl
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched.c |   17 +++++------------
 1 files changed, 5 insertions(+), 12 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index fd73e91..35fc995 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -6395,6 +6395,8 @@ early_initcall(migration_init);
 
 #ifdef CONFIG_SMP
 
+static cpumask_var_t sched_domains_tmpmask; /* sched_domains_mutex */
+
 #ifdef CONFIG_SCHED_DEBUG
 
 static __read_mostly int sched_domain_debug_enabled;
@@ -6490,7 +6492,6 @@ static int sched_domain_debug_one(struct sched_domain *sd, int cpu, int level,
 
 static void sched_domain_debug(struct sched_domain *sd, int cpu)
 {
-	cpumask_var_t groupmask;
 	int level = 0;
 
 	if (!sched_domain_debug_enabled)
@@ -6503,20 +6504,14 @@ static void sched_domain_debug(struct sched_domain *sd, int cpu)
 
 	printk(KERN_DEBUG "CPU%d attaching sched-domain:\n", cpu);
 
-	if (!alloc_cpumask_var(&groupmask, GFP_KERNEL)) {
-		printk(KERN_DEBUG "Cannot load-balance (out of memory)\n");
-		return;
-	}
-
 	for (;;) {
-		if (sched_domain_debug_one(sd, cpu, level, groupmask))
+		if (sched_domain_debug_one(sd, cpu, level, sched_domains_tmpmask))
 			break;
 		level++;
 		sd = sd->parent;
 		if (!sd)
 			break;
 	}
-	free_cpumask_var(groupmask);
 }
 #else /* !CONFIG_SCHED_DEBUG */
 # define sched_domain_debug(sd, cpu) do { } while (0)
@@ -6721,7 +6716,7 @@ cpu_attach_domain(struct sched_domain *sd, struct root_domain *rd, int cpu)
 			sd->child = NULL;
 	}
 
-	/* sched_domain_debug(sd, cpu); */
+	sched_domain_debug(sd, cpu);
 
 	rq_attach_root(rq, rd);
 	tmp = rq->sd;
@@ -6851,8 +6846,6 @@ static int get_group(int cpu, struct sd_data *sdd, struct sched_group **sg)
 	return cpu;
 }
 
-static cpumask_var_t sched_domains_tmpmask; /* sched_domains_mutex */
-
 /*
  * build_sched_groups takes the cpumask we wish to span, and a pointer
  * to a function which identifies what group(along with sched group) a CPU
@@ -7896,8 +7889,8 @@ void __init sched_init(void)
 
 	/* Allocate the nohz_cpu_mask if CONFIG_CPUMASK_OFFSTACK */
 	zalloc_cpumask_var(&nohz_cpu_mask, GFP_NOWAIT);
-	zalloc_cpumask_var(&sched_domains_tmpmask, GFP_NOWAIT);
 #ifdef CONFIG_SMP
+	zalloc_cpumask_var(&sched_domains_tmpmask, GFP_NOWAIT);
 #ifdef CONFIG_NO_HZ
 	zalloc_cpumask_var(&nohz.idle_cpus_mask, GFP_NOWAIT);
 	alloc_cpumask_var(&nohz.grp_idle_mask, GFP_NOWAIT);
