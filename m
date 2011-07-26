Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753602Ab1GZPgq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 11:36:46 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:52428 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753583Ab1GZPfy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 11:35:54 -0400
From: Tejun Heo <tj@kernel.org>
To: benh@kernel.crashing.org, yinghai@kernel.org, hpa@zytor.com,
        tony.luck@intel.com, ralf@linux-mips.org, schwidefsky@de.ibm.com,
        liqin.chen@sunplusct.com, lethal@linux-sh.org, davem@davemloft.net,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Cc: mingo@redhat.com, Tejun Heo <tj@kernel.org>
Subject: [PATCH 08/23] memblock: Reimplement __memblock_remove() using memblock_isolate_range()
Date: Tue, 26 Jul 2011 17:35:19 +0200
Message-Id: <1311694534-5161-9-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <1311694534-5161-1-git-send-email-tj@kernel.org>
References: <1311694534-5161-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__memblock_remove()'s open coded region manipulation can be trivially
replaced with memlbock_islate_range().  This increases code sharing
and eases improving region tracking.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Yinghai Lu <yinghai@kernel.org>
---
 mm/memblock.c |   52 +++++++---------------------------------------------
 1 files changed, 7 insertions(+), 45 deletions(-)

diff --git a/mm/memblock.c b/mm/memblock.c
index a64d469..8b38cd9 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -400,7 +400,6 @@ int __init_memblock memblock_add(phys_addr_t base, phys_addr_t size)
 	return memblock_add_region(&memblock.memory, base, size);
 }
 
-#ifdef CONFIG_HAVE_MEMBLOCK_NODE_MAP
 /**
  * memblock_isolate_range - isolate given range into disjoint memblocks
  * @type: memblock type to isolate range for
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

