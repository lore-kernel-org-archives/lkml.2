Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752296Ab1GLIrg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 04:47:36 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:42686 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752069Ab1GLIqv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 04:46:51 -0400
From: Tejun Heo <tj@kernel.org>
To: mingo@redhat.com, hpa@zytor.com, tglx@linutronix.de,
        benh@kernel.crashing.org, yinghai@kernel.org, davem@davemloft.net
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org, x86@kernel.org,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 7/8] memblock: Separate out memblock_find_in_range_node()
Date: Tue, 12 Jul 2011 10:46:34 +0200
Message-Id: <1310460395-30913-8-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <1310460395-30913-1-git-send-email-tj@kernel.org>
References: <1310460395-30913-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Node affine memblock allocation logic is currently implemented across
memblock_alloc_nid() and memblock_alloc_nid_region().  This
reorganizes it such that it resembles that of non-NUMA allocation API.

Area finding is collected and moved into new exported function
memblock_find_in_range_node() which is symmetrical to non-NUMA
counterpart - it handles @start/@end and understands ANYWHERE and
ACCESSIBLE.  memblock_alloc_nid() now simply calls
memblock_find_in_range_node() and reserves the returned area.

This makes memblock_alloc[_try]_nid() observe ACCESSIBLE limit on node
affine allocations too (again, this doesn't make any difference for
the current sole user - sparc64).

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
---
 include/linux/memblock.h |    4 +++
 mm/memblock.c            |   57 +++++++++++++++++++++++++--------------------
 2 files changed, 36 insertions(+), 25 deletions(-)

diff --git a/include/linux/memblock.h b/include/linux/memblock.h
index 329ffb2..7400d02 100644
--- a/include/linux/memblock.h
+++ b/include/linux/memblock.h
@@ -61,6 +61,10 @@ extern long memblock_reserve(phys_addr_t base, phys_addr_t size);
 /* The numa aware allocator is only available if
  * CONFIG_ARCH_POPULATES_NODE_MAP is set
  */
+extern phys_addr_t memblock_find_in_range_node(phys_addr_t start,
+					       phys_addr_t end,
+					       phys_addr_t size,
+					       phys_addr_t align, int nid);
 extern phys_addr_t memblock_alloc_nid(phys_addr_t size, phys_addr_t align,
 					int nid);
 extern phys_addr_t memblock_alloc_try_nid(phys_addr_t size, phys_addr_t align,
diff --git a/mm/memblock.c b/mm/memblock.c
index 447cf64..a8edb42 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -521,49 +521,56 @@ static phys_addr_t __init memblock_nid_range_rev(phys_addr_t start,
 	return start;
 }
 
-static phys_addr_t __init memblock_alloc_nid_region(struct memblock_region *mp,
+phys_addr_t __init memblock_find_in_range_node(phys_addr_t start,
+					       phys_addr_t end,
 					       phys_addr_t size,
 					       phys_addr_t align, int nid)
 {
-	phys_addr_t start, end;
+	struct memblock_type *mem = &memblock.memory;
+	int i;
 
-	start = mp->base;
-	end = start + mp->size;
+	BUG_ON(0 == size);
 
-	while (start < end) {
-		phys_addr_t this_start;
-		int this_nid;
+	/* Pump up max_addr */
+	if (end == MEMBLOCK_ALLOC_ACCESSIBLE)
+		end = memblock.current_limit;
 
-		this_start = memblock_nid_range_rev(start, end, &this_nid);
-		if (this_nid == nid) {
-			phys_addr_t ret = memblock_find_region(this_start, end, size, align);
-			if (ret &&
-			    !memblock_add_region(&memblock.reserved, ret, size))
-				return ret;
+	for (i = mem->cnt - 1; i >= 0; i--) {
+		struct memblock_region *r = &mem->regions[i];
+		phys_addr_t base = max(start, r->base);
+		phys_addr_t top = min(end, r->base + r->size);
+
+		while (base < top) {
+			phys_addr_t tbase, ret;
+			int tnid;
+
+			tbase = memblock_nid_range_rev(base, top, &tnid);
+			if (nid == MAX_NUMNODES || tnid == nid) {
+				ret = memblock_find_region(tbase, top, size, align);
+				if (ret)
+					return ret;
+			}
+			top = tbase;
 		}
-		end = this_start;
 	}
+
 	return 0;
 }
 
 phys_addr_t __init memblock_alloc_nid(phys_addr_t size, phys_addr_t align, int nid)
 {
-	struct memblock_type *mem = &memblock.memory;
-	int i;
-
-	BUG_ON(0 == size);
+	phys_addr_t found;
 
-	/* We align the size to limit fragmentation. Without this, a lot of
+	/*
+	 * We align the size to limit fragmentation. Without this, a lot of
 	 * small allocs quickly eat up the whole reserve array on sparc
 	 */
 	size = round_up(size, align);
 
-	for (i = mem->cnt - 1; i >= 0; i--) {
-		phys_addr_t ret = memblock_alloc_nid_region(&mem->regions[i],
-					       size, align, nid);
-		if (ret)
-			return ret;
-	}
+	found = memblock_find_in_range_node(0, MEMBLOCK_ALLOC_ACCESSIBLE,
+					    size, align, nid);
+	if (found && !memblock_add_region(&memblock.reserved, found, size))
+		return found;
 
 	return 0;
 }
-- 
1.7.6

