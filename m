Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754387Ab1G1Jnj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 05:43:39 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:44698 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755378Ab1G1Jn1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 05:43:27 -0400
Date: Thu, 28 Jul 2011 11:43:22 +0200
From: Tejun Heo <tj@kernel.org>
To: benh@kernel.crashing.org, yinghai@kernel.org, hpa@zytor.com,
        tony.luck@intel.com, ralf@linux-mips.org, schwidefsky@de.ibm.com,
        liqin.chen@sunplusct.com, lethal@linux-sh.org, davem@davemloft.net,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Cc: mingo@redhat.com
Subject: [PATCH UPDATED 08/23] memblock: Reimplement __memblock_remove()
 using memblock_isolate_range()
Message-ID: <20110728094322.GG2622@htj.dyndns.org>
References: <1311694534-5161-1-git-send-email-tj@kernel.org>
 <1311694534-5161-9-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1311694534-5161-9-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From bf27dffdabf7c4c3cd4be14d14ff9e2ba8ecbc0e Mon Sep 17 00:00:00 2001
From: Tejun Heo <tj@kernel.org>
Date: Thu, 28 Jul 2011 10:57:00 +0200

__memblock_remove()'s open coded region manipulation can be trivially
replaced with memlbock_islate_range().  This increases code sharing
and eases improving region tracking.

This pulls memblock_isolate_range() out of HAVE_MEMBLOCK_NODE_MAP.
Make it use memblock_get_region_node() instead of assuming rgn->nid is
available.

-v2: Fixed build failure on !HAVE_MEMBLOCK_NODE_MAP caused by direct
     rgn->nid access.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Yinghai Lu <yinghai@kernel.org>
---

Updated to fix build breakage on !HAVE_MEMBLOCK_NODE_MAP.  This
doesn't affect patches on top of it.  Updated git branch available.

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git memblock

Commit ID should be 46c66825fc9a398f06f72732ed1a9d4fe89f6805.  If
anyone wants full re-post of the series, please let me know.

Thanks.

 mm/memblock.c |   56 +++++++++-----------------------------------------------
 1 files changed, 9 insertions(+), 47 deletions(-)

diff --git a/mm/memblock.c b/mm/memblock.c
index a64d469..fc6dce2 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -400,7 +400,6 @@ int __init_memblock memblock_add(phys_addr_t base, phys_addr_t size)
 	return memblock_add_region(&memblock.memory, base, size);
 }
 
-#ifdef CONFIG_HAVE_MEMBLOCK_NODE_MAP
 /**
  * memblock_isolate_range - isolate given range into disjoint memblocks
  * @type: memblock type to isolate range for
@@ -449,7 +448,7 @@ static int __init_memblock memblock_isolate_range(struct memblock_type *type,
 			rgn->base = base;
 			rgn->size = rend - rgn->base;
 			memblock_insert_region(type, i, rbase, base - rbase,
-					       rgn->nid);
+					       memblock_get_region_node(rgn));
 		} else if (rend > end) {
 			/*
 			 * @rgn intersects from above.  Split and redo the
@@ -458,7 +457,7 @@ static int __init_memblock memblock_isolate_range(struct memblock_type *type,
 			rgn->base = end;
 			rgn->size = rend - rgn->base;
 			memblock_insert_region(type, i--, rbase, end - rbase,
-					       rgn->nid);
+					       memblock_get_region_node(rgn));
 		} else {
 			/* @rgn is fully contained, record it */
 			if (!*end_rgn)
@@ -469,56 +468,19 @@ static int __init_memblock memblock_isolate_range(struct memblock_type *type,
 
 	return 0;
 }
-#endif
 
 static int __init_memblock __memblock_remove(struct memblock_type *type,
 					     phys_addr_t base, phys_addr_t size)
 {
-	phys_addr_t end = base + size;
-	int i;
-
-	/* Walk through the array for collisions */
-	for (i = 0; i < type->cnt; i++) {
-		struct memblock_region *rgn = &type->regions[i];
-		phys_addr_t rend = rgn->base + rgn->size;
-
-		/* Nothing more to do, exit */
-		if (rgn->base > end || rgn->size == 0)
-			break;
-
-		/* If we fully enclose the block, drop it */
-		if (base <= rgn->base && end >= rend) {
-			memblock_remove_region(type, i--);
-			continue;
-		}
-
-		/* If we are fully enclosed within a block
-		 * then we need to split it and we are done
-		 */
-		if (base > rgn->base && end < rend) {
-			rgn->size = base - rgn->base;
-			if (!memblock_add_region(type, end, rend - end))
-				return 0;
-			/* Failure to split is bad, we at least
-			 * restore the block before erroring
-			 */
-			rgn->size = rend - rgn->base;
-			WARN_ON(1);
-			return -1;
-		}
-
-		/* Check if we need to trim the bottom of a block */
-		if (rgn->base < end && rend > end) {
-			rgn->size -= end - rgn->base;
-			rgn->base = end;
-			break;
-		}
+	int start_rgn, end_rgn;
+	int i, ret;
 
-		/* And check if we need to trim the top of a block */
-		if (base < rend)
-			rgn->size -= rend - base;
+	ret = memblock_isolate_range(type, base, size, &start_rgn, &end_rgn);
+	if (ret)
+		return ret;
 
-	}
+	for (i = end_rgn - 1; i >= start_rgn; i--)
+		memblock_remove_region(type, i);
 	return 0;
 }
 
-- 
1.7.6

