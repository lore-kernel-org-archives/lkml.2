Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757150Ab2DMXAV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 19:00:21 -0400
Received: from mga09.intel.com ([134.134.136.24]:61596 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755015Ab2DMXAT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 19:00:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="129287452"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: Andi Kleen <ak@linux.intel.com>, penberg@kernel.org
Subject: [PATCH] slab/mempolicy: always use local policy from interrupt context
Date: Fri, 13 Apr 2012 16:00:10 -0700
Message-Id: <1334358010-17019-1-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

slab_node() could access current->mempolicy from interrupt context.
However there's a race condition during exit where the mempolicy
is first freed and then the pointer zeroed.

Using this from interrupts seems bogus anyways. The interrupt
will interrupt a random process and therefore get a random
mempolicy. Many times idle's which noone can change.

Just disable this here and always use local for slab
from interrupts. I also cleaned up the callers of slab_node a bit
which always passed the same argument.

I believe the original mempolicy code did that in fact,
so it's likely a regression.

Reported-by: Arun Sharma <asharma@fb.com>
Cc: penberg@kernel.org
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 include/linux/mempolicy.h |    2 +-
 mm/mempolicy.c            |    3 ++-
 mm/slab.c                 |    4 ++--
 mm/slub.c                 |    2 +-
 4 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/include/linux/mempolicy.h b/include/linux/mempolicy.h
index 7c727a9..7106786 100644
--- a/include/linux/mempolicy.h
+++ b/include/linux/mempolicy.h
@@ -215,7 +215,7 @@ extern struct zonelist *huge_zonelist(struct vm_area_struct *vma,
 extern bool init_nodemask_of_mempolicy(nodemask_t *mask);
 extern bool mempolicy_nodemask_intersects(struct task_struct *tsk,
 				const nodemask_t *mask);
-extern unsigned slab_node(struct mempolicy *policy);
+extern unsigned slab_node(void);
 
 extern enum zone_type policy_zone;
 
diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index cfb6c86..d0a9de0 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -1586,8 +1586,9 @@ static unsigned interleave_nodes(struct mempolicy *policy)
  * task can change it's policy.  The system default policy requires no
  * such protection.
  */
-unsigned slab_node(struct mempolicy *policy)
+unsigned slab_node(void)
 {
+	struct mempolicy *policy = in_interrupt() ? current->policy : NULL;
 	if (!policy || policy->flags & MPOL_F_LOCAL)
 		return numa_node_id();
 
diff --git a/mm/slab.c b/mm/slab.c
index e901a36..af3b405 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -3336,7 +3336,7 @@ static void *alternate_node_alloc(struct kmem_cache *cachep, gfp_t flags)
 	if (cpuset_do_slab_mem_spread() && (cachep->flags & SLAB_MEM_SPREAD))
 		nid_alloc = cpuset_slab_spread_node();
 	else if (current->mempolicy)
-		nid_alloc = slab_node(current->mempolicy);
+		nid_alloc = slab_node();
 	if (nid_alloc != nid_here)
 		return ____cache_alloc_node(cachep, flags, nid_alloc);
 	return NULL;
@@ -3368,7 +3368,7 @@ static void *fallback_alloc(struct kmem_cache *cache, gfp_t flags)
 
 retry_cpuset:
 	cpuset_mems_cookie = get_mems_allowed();
-	zonelist = node_zonelist(slab_node(current->mempolicy), flags);
+	zonelist = node_zonelist(slab_node(), flags);
 
 retry:
 	/*
diff --git a/mm/slub.c b/mm/slub.c
index ffe13fd..ef936f3 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -1614,7 +1614,7 @@ static struct page *get_any_partial(struct kmem_cache *s, gfp_t flags,
 
 	do {
 		cpuset_mems_cookie = get_mems_allowed();
-		zonelist = node_zonelist(slab_node(current->mempolicy), flags);
+		zonelist = node_zonelist(slab_node(), flags);
 		for_each_zone_zonelist(zone, z, zonelist, high_zoneidx) {
 			struct kmem_cache_node *n;
 
-- 
1.7.7.6

