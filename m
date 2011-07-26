Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753825Ab1GZPgw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 11:36:52 -0400
Received: from mail-ey0-f171.google.com ([209.85.215.171]:56152 "EHLO
	mail-ey0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753569Ab1GZPfx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 11:35:53 -0400
From: Tejun Heo <tj@kernel.org>
To: benh@kernel.crashing.org, yinghai@kernel.org, hpa@zytor.com,
        tony.luck@intel.com, ralf@linux-mips.org, schwidefsky@de.ibm.com,
        liqin.chen@sunplusct.com, lethal@linux-sh.org, davem@davemloft.net,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Cc: mingo@redhat.com, Tejun Heo <tj@kernel.org>
Subject: [PATCH 07/23] memblock: Separate out memblock_isolate_range() from memblock_set_node()
Date: Tue, 26 Jul 2011 17:35:18 +0200
Message-Id: <1311694534-5161-8-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <1311694534-5161-1-git-send-email-tj@kernel.org>
References: <1311694534-5161-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

memblock_set_node() operates in three steps - break regions crossing
boundaries, set nid and merge back regions.  This patch separates the
first part into a separate function - memblock_isolate_range(), which
breaks regions crossing range boundaries and returns range index range
for regions properly contained in the specified memory range.

This doesn't introduce any behavior change and will be used to further
unify region handling.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Yinghai Lu <yinghai@kernel.org>
---
 mm/memblock.c |  117 ++++++++++++++++++++++++++++++++++++++-------------------
 1 files changed, 78 insertions(+), 39 deletions(-)

diff --git a/mm/memblock.c b/mm/memblock.c
index aac713c..a64d469 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -400,6 +400,77 @@ int __init_memblock memblock_add(phys_addr_t base, phys_addr_t size)
 	return memblock_add_region(&memblock.memory, base, size);
 }
 
+#ifdef CONFIG_HAVE_MEMBLOCK_NODE_MAP
+/**
+ * memblock_isolate_range - isolate given range into disjoint memblocks
+ * @type: memblock type to isolate range for
+ * @base: base of range to isolate
+ * @size: size of range to isolate
+ * @start_rgn: out parameter for the start of isolated region
+ * @end_rgn: out parameter for the end of isolated region
+ *
+ * Walk @type and ensure that regions don't cross the boundaries defined by
+ * [@base,@base+@size).  Crossing regions are split at the boundaries,
+ * which may create at most two more regions.  The index of the first
+ * region inside the range is returned in *@start_rgn and end in *@end_rgn.
+ *
+ * RETURNS:
+ * 0 on success, -errno on failure.
+ */
+static int __init_memblock memblock_isolate_range(struct memblock_type *type,
+					phys_addr_t base, phys_addr_t size,
+					int *start_rgn, int *end_rgn)
+{
+	phys_addr_t end = base + size;
+	int i;
+
+	*start_rgn = *end_rgn = 0;
+
+	/* we'll create at most two more regions */
+	while (type->cnt + 2 > type->max)
+		if (memblock_double_array(type) < 0)
+			return -ENOMEM;
+
+	for (i = 0; i < type->cnt; i++) {
+		struct memblock_region *rgn = &type->regions[i];
+		phys_addr_t rbase = rgn->base;
+		phys_addr_t rend = rbase + rgn->size;
+
+		if (rbase >= end)
+			break;
+		if (rend <= base)
+			continue;
+
+		if (rbase < base) {
+			/*
+			 * @rgn intersects from below.  Split and continue
+			 * to process the next region - the new top half.
+			 */
+			rgn->base = base;
+			rgn->size = rend - rgn->base;
+			memblock_insert_region(type, i, rbase, base - rbase,
+					       rgn->nid);
+		} else if (rend > end) {
+			/*
+			 * @rgn intersects from above.  Split and redo the
+			 * current region - the new bottom half.
+			 */
+			rgn->base = end;
+			rgn->size = rend - rgn->base;
+			memblock_insert_region(type, i--, rbase, end - rbase,
+					       rgn->nid);
+		} else {
+			/* @rgn is fully contained, record it */
+			if (!*end_rgn)
+				*start_rgn = i;
+			*end_rgn = i + 1;
+		}
+	}
+
+	return 0;
+}
+#endif
+
 static int __init_memblock __memblock_remove(struct memblock_type *type,
 					     phys_addr_t base, phys_addr_t size)
 {
@@ -603,47 +674,15 @@ int __init_memblock memblock_set_node(phys_addr_t base, phys_addr_t size,
 				      int nid)
 {
 	struct memblock_type *type = &memblock.memory;
-	phys_addr_t end = base + size;
-	int i;
+	int start_rgn, end_rgn;
+	int i, ret;
 
-	/* we'll create at most two more regions */
-	while (type->cnt + 2 > type->max)
-		if (memblock_double_array(type) < 0)
-			return -ENOMEM;
+	ret = memblock_isolate_range(type, base, size, &start_rgn, &end_rgn);
+	if (ret)
+		return ret;
 
-	for (i = 0; i < type->cnt; i++) {
-		struct memblock_region *rgn = &type->regions[i];
-		phys_addr_t rbase = rgn->base;
-		phys_addr_t rend = rbase + rgn->size;
-
-		if (rbase >= end)
-			break;
-		if (rend <= base)
-			continue;
-
-		if (rbase < base) {
-			/*
-			 * @rgn intersects from below.  Split and continue
-			 * to process the next region - the new top half.
-			 */
-			rgn->base = base;
-			rgn->size = rend - rgn->base;
-			memblock_insert_region(type, i, rbase, base - rbase,
-					       rgn->nid);
-		} else if (rend > end) {
-			/*
-			 * @rgn intersects from above.  Split and redo the
-			 * current region - the new bottom half.
-			 */
-			rgn->base = end;
-			rgn->size = rend - rgn->base;
-			memblock_insert_region(type, i--, rbase, end - rbase,
-					       rgn->nid);
-		} else {
-			/* @rgn is fully contained, set ->nid */
-			rgn->nid = nid;
-		}
-	}
+	for (i = start_rgn; i < end_rgn; i++)
+		type->regions[i].nid = nid;
 
 	memblock_merge_regions(type);
 	return 0;
-- 
1.7.6

