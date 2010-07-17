Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759916Ab0GQLNl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jul 2010 07:13:41 -0400
Received: from hera.kernel.org ([140.211.167.34]:41464 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754078Ab0GQLNj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jul 2010 07:13:39 -0400
Date: Sat, 17 Jul 2010 11:12:57 GMT
From: tip-bot for Pekka Enberg <penberg@cs.helsinki.fi>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, penberg@cs.helsinki.fi, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        penberg@cs.helsinki.fi, a.p.zijlstra@chello.nl, tglx@linutronix.de,
        mingo@elte.hu
In-Reply-To: <1279225102-2572-1-git-send-email-penberg@cs.helsinki.fi>
References: <1279225102-2572-1-git-send-email-penberg@cs.helsinki.fi>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: No need for bootmem special cases
Message-ID: <tip-68c38fc3cb4e5a60f502ee9c45f3dfe70e5165ad@git.kernel.org>
Git-Commit-ID: 68c38fc3cb4e5a60f502ee9c45f3dfe70e5165ad
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sat, 17 Jul 2010 11:12:59 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  68c38fc3cb4e5a60f502ee9c45f3dfe70e5165ad
Gitweb:     http://git.kernel.org/tip/68c38fc3cb4e5a60f502ee9c45f3dfe70e5165ad
Author:     Pekka Enberg <penberg@cs.helsinki.fi>
AuthorDate: Thu, 15 Jul 2010 23:18:22 +0300
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sat, 17 Jul 2010 12:06:22 +0200

sched: No need for bootmem special cases

As of commit dcce284 ("mm: Extend gfp masking to the page
allocator") and commit 7e85ee0 ("slab,slub: don't enable
interrupts during early boot"), the slab allocator makes
sure we don't attempt to sleep during boot.

Therefore, remove bootmem special cases from the scheduler
and use plain GFP_KERNEL instead.

Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <1279225102-2572-1-git-send-email-penberg@cs.helsinki.fi>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched.c        |   19 +++++++------------
 kernel/sched_cpupri.c |    8 ++------
 kernel/sched_cpupri.h |    2 +-
 3 files changed, 10 insertions(+), 19 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 9064e7d..7b443ee 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -6248,23 +6248,18 @@ static void rq_attach_root(struct rq *rq, struct root_domain *rd)
 		free_rootdomain(old_rd);
 }
 
-static int init_rootdomain(struct root_domain *rd, bool bootmem)
+static int init_rootdomain(struct root_domain *rd)
 {
-	gfp_t gfp = GFP_KERNEL;
-
 	memset(rd, 0, sizeof(*rd));
 
-	if (bootmem)
-		gfp = GFP_NOWAIT;
-
-	if (!alloc_cpumask_var(&rd->span, gfp))
+	if (!alloc_cpumask_var(&rd->span, GFP_KERNEL))
 		goto out;
-	if (!alloc_cpumask_var(&rd->online, gfp))
+	if (!alloc_cpumask_var(&rd->online, GFP_KERNEL))
 		goto free_span;
-	if (!alloc_cpumask_var(&rd->rto_mask, gfp))
+	if (!alloc_cpumask_var(&rd->rto_mask, GFP_KERNEL))
 		goto free_online;
 
-	if (cpupri_init(&rd->cpupri, bootmem) != 0)
+	if (cpupri_init(&rd->cpupri) != 0)
 		goto free_rto_mask;
 	return 0;
 
@@ -6280,7 +6275,7 @@ out:
 
 static void init_defrootdomain(void)
 {
-	init_rootdomain(&def_root_domain, true);
+	init_rootdomain(&def_root_domain);
 
 	atomic_set(&def_root_domain.refcount, 1);
 }
@@ -6293,7 +6288,7 @@ static struct root_domain *alloc_rootdomain(void)
 	if (!rd)
 		return NULL;
 
-	if (init_rootdomain(rd, false) != 0) {
+	if (init_rootdomain(rd) != 0) {
 		kfree(rd);
 		return NULL;
 	}
diff --git a/kernel/sched_cpupri.c b/kernel/sched_cpupri.c
index e6871cb..2722dc1 100644
--- a/kernel/sched_cpupri.c
+++ b/kernel/sched_cpupri.c
@@ -166,14 +166,10 @@ void cpupri_set(struct cpupri *cp, int cpu, int newpri)
  *
  * Returns: -ENOMEM if memory fails.
  */
-int cpupri_init(struct cpupri *cp, bool bootmem)
+int cpupri_init(struct cpupri *cp)
 {
-	gfp_t gfp = GFP_KERNEL;
 	int i;
 
-	if (bootmem)
-		gfp = GFP_NOWAIT;
-
 	memset(cp, 0, sizeof(*cp));
 
 	for (i = 0; i < CPUPRI_NR_PRIORITIES; i++) {
@@ -181,7 +177,7 @@ int cpupri_init(struct cpupri *cp, bool bootmem)
 
 		raw_spin_lock_init(&vec->lock);
 		vec->count = 0;
-		if (!zalloc_cpumask_var(&vec->mask, gfp))
+		if (!zalloc_cpumask_var(&vec->mask, GFP_KERNEL))
 			goto cleanup;
 	}
 
diff --git a/kernel/sched_cpupri.h b/kernel/sched_cpupri.h
index 7cb5bb6..9fc7d38 100644
--- a/kernel/sched_cpupri.h
+++ b/kernel/sched_cpupri.h
@@ -27,7 +27,7 @@ struct cpupri {
 int  cpupri_find(struct cpupri *cp,
 		 struct task_struct *p, struct cpumask *lowest_mask);
 void cpupri_set(struct cpupri *cp, int cpu, int pri);
-int cpupri_init(struct cpupri *cp, bool bootmem);
+int cpupri_init(struct cpupri *cp);
 void cpupri_cleanup(struct cpupri *cp);
 #else
 #define cpupri_set(cp, cpu, pri) do { } while (0)
