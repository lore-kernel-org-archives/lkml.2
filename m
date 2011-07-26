Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754002Ab1GZPkl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 11:40:41 -0400
Received: from mail-ey0-f171.google.com ([209.85.215.171]:56152 "EHLO
	mail-ey0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753423Ab1GZPgB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 11:36:01 -0400
From: Tejun Heo <tj@kernel.org>
To: benh@kernel.crashing.org, yinghai@kernel.org, hpa@zytor.com,
        tony.luck@intel.com, ralf@linux-mips.org, schwidefsky@de.ibm.com,
        liqin.chen@sunplusct.com, lethal@linux-sh.org, davem@davemloft.net,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Cc: mingo@redhat.com, Tejun Heo <tj@kernel.org>
Subject: [PATCH 12/23] memblock: Track total size of regions automatically
Date: Tue, 26 Jul 2011 17:35:23 +0200
Message-Id: <1311694534-5161-13-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <1311694534-5161-1-git-send-email-tj@kernel.org>
References: <1311694534-5161-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Total size of memory regions was calculated by memblock_analyze()
requiring explicitly calling the function between operations which can
change memory regions and possible users of total size, which is
cumbersome and fragile.

This patch makes each memblock_type track total size automatically
with minor modifications to memblock manipulation functions and remove
requirements on calling memblock_analyze().  [__]memblock_dump_all()
now also dumps the total size of reserved regions.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Yinghai Lu <yinghai@kernel.org>
---
 include/linux/memblock.h |    2 +-
 mm/memblock.c            |   27 +++++++++++++--------------
 2 files changed, 14 insertions(+), 15 deletions(-)

diff --git a/include/linux/memblock.h b/include/linux/memblock.h
index cd54a1d..3d3c8ce 100644
--- a/include/linux/memblock.h
+++ b/include/linux/memblock.h
@@ -30,12 +30,12 @@ struct memblock_region {
 struct memblock_type {
 	unsigned long cnt;	/* number of regions */
 	unsigned long max;	/* size of the allocated array */
+	phys_addr_t total_size;	/* size of all regions */
 	struct memblock_region *regions;
 };
 
 struct memblock {
 	phys_addr_t current_limit;
-	phys_addr_t memory_size;	/* Updated by memblock_analyze() */
 	struct memblock_type memory;
 	struct memblock_type reserved;
 };
diff --git a/mm/memblock.c b/mm/memblock.c
index d8582f7..051bc4e 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -179,12 +179,14 @@ int __init_memblock memblock_reserve_reserved_regions(void)
 
 static void __init_memblock memblock_remove_region(struct memblock_type *type, unsigned long r)
 {
+	type->total_size -= type->regions[r].size;
 	memmove(&type->regions[r], &type->regions[r + 1],
 		(type->cnt - (r + 1)) * sizeof(type->regions[r]));
 	type->cnt--;
 
 	/* Special case for empty arrays */
 	if (type->cnt == 0) {
+		WARN_ON(type->total_size != 0);
 		type->cnt = 1;
 		type->regions[0].base = 0;
 		type->regions[0].size = 0;
@@ -314,6 +316,7 @@ static void __init_memblock memblock_insert_region(struct memblock_type *type,
 	rgn->size = size;
 	memblock_set_region_node(rgn, nid);
 	type->cnt++;
+	type->total_size += size;
 }
 
 /**
@@ -340,10 +343,11 @@ static int __init_memblock memblock_add_region(struct memblock_type *type,
 
 	/* special case for empty array */
 	if (type->regions[0].size == 0) {
-		WARN_ON(type->cnt != 1);
+		WARN_ON(type->cnt != 1 || type->total_size);
 		type->regions[0].base = base;
 		type->regions[0].size = size;
 		memblock_set_region_node(&type->regions[0], MAX_NUMNODES);
+		type->total_size = size;
 		return 0;
 	}
 repeat:
@@ -453,7 +457,8 @@ static int __init_memblock memblock_isolate_range(struct memblock_type *type,
 			 * to process the next region - the new top half.
 			 */
 			rgn->base = base;
-			rgn->size = rend - rgn->base;
+			rgn->size -= base - rbase;
+			type->total_size -= base - rbase;
 			memblock_insert_region(type, i, rbase, base - rbase,
 					       rgn->nid);
 		} else if (rend > end) {
@@ -462,7 +467,8 @@ static int __init_memblock memblock_isolate_range(struct memblock_type *type,
 			 * current region - the new bottom half.
 			 */
 			rgn->base = end;
-			rgn->size = rend - rgn->base;
+			rgn->size -= end - rbase;
+			type->total_size -= end - rbase;
 			memblock_insert_region(type, i--, rbase, end - rbase,
 					       rgn->nid);
 		} else {
@@ -784,10 +790,9 @@ phys_addr_t __init memblock_alloc_try_nid(phys_addr_t size, phys_addr_t align, i
  * Remaining API functions
  */
 
-/* You must call memblock_analyze() before this. */
 phys_addr_t __init memblock_phys_mem_size(void)
 {
-	return memblock.memory_size;
+	return memblock.memory.total_size;
 }
 
 phys_addr_t __init_memblock memblock_end_of_DRAM(void)
@@ -797,7 +802,6 @@ phys_addr_t __init_memblock memblock_end_of_DRAM(void)
 	return (memblock.memory.regions[idx].base + memblock.memory.regions[idx].size);
 }
 
-/* You must call memblock_analyze() after this. */
 void __init memblock_enforce_memory_limit(phys_addr_t limit)
 {
 	unsigned long i;
@@ -900,7 +904,9 @@ static void __init_memblock memblock_dump(struct memblock_type *type, char *name
 void __init_memblock __memblock_dump_all(void)
 {
 	pr_info("MEMBLOCK configuration:\n");
-	pr_info(" memory size = 0x%llx\n", (unsigned long long)memblock.memory_size);
+	pr_info(" memory size = %#llx reserved size = %#llx\n",
+		(unsigned long long)memblock.memory.total_size,
+		(unsigned long long)memblock.reserved.total_size);
 
 	memblock_dump(&memblock.memory, "memory");
 	memblock_dump(&memblock.reserved, "reserved");
@@ -908,13 +914,6 @@ void __init_memblock __memblock_dump_all(void)
 
 void __init memblock_analyze(void)
 {
-	int i;
-
-	memblock.memory_size = 0;
-
-	for (i = 0; i < memblock.memory.cnt; i++)
-		memblock.memory_size += memblock.memory.regions[i].size;
-
 	/* We allow resizing from there */
 	memblock_can_resize = 1;
 }
-- 
1.7.6

