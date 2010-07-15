Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934673Ab0GOUS0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jul 2010 16:18:26 -0400
Received: from filtteri6.pp.htv.fi ([213.243.153.189]:41405 "EHLO
	filtteri6.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934645Ab0GOUSZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jul 2010 16:18:25 -0400
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, Pekka Enberg <penberg@cs.helsinki.fi>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH] sched: No need for bootmem special cases
Date: Thu, 15 Jul 2010 23:18:22 +0300
Message-Id: <1279225102-2572-1-git-send-email-penberg@cs.helsinki.fi>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As of commit dcce284 ("mm: Extend gfp masking to the page allocator") and
commit 7e85ee0 ("slab,slub: don't enable interrupts during early boot"), the
slab allocator makes sure we don't attempt to sleep during boot.

Therefore, remove bootmem special cases from the scheduler and use plain
GFP_KERNEL instead.

Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 kernel/sched.c        |   19 +++++++------------
 kernel/sched_cpupri.c |    8 ++------
 kernel/sched_cpupri.h |    2 +-
 3 files changed, 10 insertions(+), 19 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index f52a880..35d151d 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -6064,23 +6064,18 @@ static void rq_attach_root(struct rq *rq, struct root_domain *rd)
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
 
@@ -6096,7 +6091,7 @@ out:
 
 static void init_defrootdomain(void)
 {
-	init_rootdomain(&def_root_domain, true);
+	init_rootdomain(&def_root_domain);
 
 	atomic_set(&def_root_domain.refcount, 1);
 }
@@ -6109,7 +6104,7 @@ static struct root_domain *alloc_rootdomain(void)
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
-- 
1.6.3.3

