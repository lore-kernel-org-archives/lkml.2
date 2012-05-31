Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757729Ab2EaCD0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 22:03:26 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:39119 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757599Ab2EaCDY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 22:03:24 -0400
From: David Mackey <tdmackey@twitter.com>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Cc: Andi Kleen <ak@linux.intel.com>, penberg@kernel.org, cl@linux.com,
        David Mackey <tdmackey@twitter.com>
Subject: [PATCH v4] slab/mempolicy: always use local policy from interrupt context
Date: Wed, 30 May 2012 22:02:29 -0400
Message-Id: <1338429749-5780-1-git-send-email-tdmackey@twitter.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1336431315-29736-1-git-send-email-andi@firstfloor.org>
References: <1336431315-29736-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

slab_node() could access current->mempolicy from interrupt context.
However there's a race condition during exit where the mempolicy
is first freed and then the pointer zeroed.

Using this from interrupts seems bogus anyways. The interrupt
will interrupt a random process and therefore get a random
mempolicy. Many times, this will be idle's, which noone can change.

Just disable this here and always use local for slab
from interrupts. I also cleaned up the callers of slab_node a bit
which always passed the same argument.

I believe the original mempolicy code did that in fact,
so it's likely a regression.

v2: send version with correct logic
v3: simplify. fix typo.
Reported-by: Arun Sharma <asharma@fb.com>
Cc: penberg@kernel.org
Cc: cl@linux.com
Signed-off-by: Andi Kleen <ak@linux.intel.com>
[tdmackey@twitter.com: Rework patch logic and avoid dereference of current 
task if in interrupt context.]
Signed-off-by: David Mackey <tdmackey@twitter.com>
---
 include/linux/mempolicy.h |    2 +-
 mm/mempolicy.c            |    4 +++-
 mm/slab.c                 |    4 ++--
 mm/slub.c                 |    2 +-
 4 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/include/linux/mempolicy.h b/include/linux/mempolicy.h
index 4aa4273..95b738c 100644
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
index f15c1b2..65801a0 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -1602,8 +1602,10 @@ static unsigned interleave_nodes(struct mempolicy *policy)
  * task can change it's policy.  The system default policy requires no
  * such protection.
  */
-unsigned slab_node(struct mempolicy *policy)
+unsigned slab_node(void)
 {
+	struct mempolicy *policy = in_interrupt() ? NULL : current->mempolicy;
+	
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
index 80848cd..b4f23ad 100644
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

