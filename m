Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753329Ab1DKOiE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Apr 2011 10:38:04 -0400
Received: from hera.kernel.org ([140.211.167.34]:54510 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752471Ab1DKOiB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Apr 2011 10:38:01 -0400
Date: Mon, 11 Apr 2011 14:37:05 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Message-ID: <tip-a9c9a9b6bff27ac9c746344a9c1a19bf3327002c@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        torvalds@linux-foundation.org, a.p.zijlstra@chello.nl, efault@gmx.de,
        npiggin@kernel.dk, akpm@linux-foundation.org, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, torvalds@linux-foundation.org, efault@gmx.de,
        npiggin@kernel.dk, akpm@linux-foundation.org, tglx@linutronix.de,
        mingo@elte.hu
In-Reply-To: <20110407122942.187335414@chello.nl>
References: <20110407122942.187335414@chello.nl>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/domains] sched: Simplify sched_groups_power initialization
Git-Commit-ID: a9c9a9b6bff27ac9c746344a9c1a19bf3327002c
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 11 Apr 2011 14:37:05 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a9c9a9b6bff27ac9c746344a9c1a19bf3327002c
Gitweb:     http://git.kernel.org/tip/a9c9a9b6bff27ac9c746344a9c1a19bf3327002c
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Thu, 7 Apr 2011 14:09:49 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 11 Apr 2011 12:58:19 +0200

sched: Simplify sched_groups_power initialization

Again, instead of relying on knowing the possible domains and their
order, simply rely on the sched_domain tree and whatever domains are
present in there to initialize the sched_group cpu_power.

Note: we need to iterate the CPU mask backwards because of the
cpumask_first() condition for iterating up the tree. By iterating the
mask backwards we ensure all groups of a domain are set-up before
starting on the parent groups that rely on its children to be
completely done.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Nick Piggin <npiggin@kernel.dk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Link: http://lkml.kernel.org/r/20110407122942.187335414@chello.nl
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched.c |   39 +++++----------------------------------
 1 files changed, 5 insertions(+), 34 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index d6992bf..1cca59e 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -7334,43 +7334,14 @@ static int __build_sched_domains(const struct cpumask *cpu_map,
 	}
 
 	/* Calculate CPU power for physical packages and nodes */
-#ifdef CONFIG_SCHED_SMT
-	for_each_cpu(i, cpu_map) {
-		sd = &per_cpu(cpu_domains, i).sd;
-		init_sched_groups_power(i, sd);
-	}
-#endif
-#ifdef CONFIG_SCHED_MC
-	for_each_cpu(i, cpu_map) {
-		sd = &per_cpu(core_domains, i).sd;
-		init_sched_groups_power(i, sd);
-	}
-#endif
-#ifdef CONFIG_SCHED_BOOK
-	for_each_cpu(i, cpu_map) {
-		sd = &per_cpu(book_domains, i).sd;
-		init_sched_groups_power(i, sd);
-	}
-#endif
-
-	for_each_cpu(i, cpu_map) {
-		sd = &per_cpu(phys_domains, i).sd;
-		init_sched_groups_power(i, sd);
-	}
-
-#ifdef CONFIG_NUMA
-	for_each_cpu(i, cpu_map) {
-		sd = &per_cpu(node_domains, i).sd;
-		init_sched_groups_power(i, sd);
-	}
+	for (i = nr_cpumask_bits-1; i >= 0; i--) {
+		if (!cpumask_test_cpu(i, cpu_map))
+			continue;
 
-	if (d.sd_allnodes) {
-		for_each_cpu(i, cpu_map) {
-			sd = &per_cpu(allnodes_domains, i).sd;
+		sd = *per_cpu_ptr(d.sd, i);
+		for (; sd; sd = sd->parent)
 			init_sched_groups_power(i, sd);
-		}
 	}
-#endif
 
 	/* Attach the domains */
 	for_each_cpu(i, cpu_map) {
