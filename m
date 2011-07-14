Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932486Ab1GNVgp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jul 2011 17:36:45 -0400
Received: from hera.kernel.org ([140.211.167.34]:59866 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932232Ab1GNVgn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jul 2011 17:36:43 -0400
Date: Thu, 14 Jul 2011 21:36:36 GMT
From: tip-bot for Tejun Heo <tj@kernel.org>
Message-ID: <tip-474b881bf4ee86aba55d46a4fdf293de32cba91b@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        benh@kernel.crashing.org, yinghai@kernel.org, tj@kernel.org,
        tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        yinghai@kernel.org, benh@kernel.crashing.org, tj@kernel.org,
        tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1310462166-31469-12-git-send-email-tj@kernel.org>
References: <1310462166-31469-12-git-send-email-tj@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/memblock] x86: Use absent_pages_in_range() instead of memblock_x86_hole_size()
Git-Commit-ID: 474b881bf4ee86aba55d46a4fdf293de32cba91b
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 14 Jul 2011 21:36:37 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  474b881bf4ee86aba55d46a4fdf293de32cba91b
Gitweb:     http://git.kernel.org/tip/474b881bf4ee86aba55d46a4fdf293de32cba91b
Author:     Tejun Heo <tj@kernel.org>
AuthorDate: Tue, 12 Jul 2011 11:16:04 +0200
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Thu, 14 Jul 2011 11:47:51 -0700

x86: Use absent_pages_in_range() instead of memblock_x86_hole_size()

memblock_x86_hole_size() calculates the total size of holes in a given
range according to memblock and is used by numa emulation code and
numa_meminfo_cover_memory().

Since conversion to MEMBLOCK_NODE_MAP, absent_pages_in_range() also
uses memblock and gives the same result.  This patch replaces
memblock_x86_hole_size() uses with absent_pages_in_range().  After the
conversion the x86 function doesn't have any user left and is killed.

Signed-off-by: Tejun Heo <tj@kernel.org>
Link: http://lkml.kernel.org/r/1310462166-31469-12-git-send-email-tj@kernel.org
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/include/asm/memblock.h |    2 -
 arch/x86/mm/memblock.c          |   52 ---------------------------------------
 arch/x86/mm/numa.c              |    4 +-
 arch/x86/mm/numa_emulation.c    |   30 +++++++++++++---------
 4 files changed, 20 insertions(+), 68 deletions(-)

diff --git a/arch/x86/include/asm/memblock.h b/arch/x86/include/asm/memblock.h
index a0cc7d6..17a882e 100644
--- a/arch/x86/include/asm/memblock.h
+++ b/arch/x86/include/asm/memblock.h
@@ -6,6 +6,4 @@
 void memblock_x86_reserve_range(u64 start, u64 end, char *name);
 void memblock_x86_free_range(u64 start, u64 end);
 
-u64 memblock_x86_hole_size(u64 start, u64 end);
-
 #endif
diff --git a/arch/x86/mm/memblock.c b/arch/x86/mm/memblock.c
index a9d0972..7325c5d 100644
--- a/arch/x86/mm/memblock.c
+++ b/arch/x86/mm/memblock.c
@@ -32,55 +32,3 @@ void __init memblock_x86_free_range(u64 start, u64 end)
 
 	memblock_free(start, end - start);
 }
-
-/*
- * Finds an active region in the address range from start_pfn to last_pfn and
- * returns its range in ei_startpfn and ei_endpfn for the memblock entry.
- */
-static int __init memblock_x86_find_active_region(const struct memblock_region *ei,
-				  unsigned long start_pfn,
-				  unsigned long last_pfn,
-				  unsigned long *ei_startpfn,
-				  unsigned long *ei_endpfn)
-{
-	u64 align = PAGE_SIZE;
-
-	*ei_startpfn = round_up(ei->base, align) >> PAGE_SHIFT;
-	*ei_endpfn = round_down(ei->base + ei->size, align) >> PAGE_SHIFT;
-
-	/* Skip map entries smaller than a page */
-	if (*ei_startpfn >= *ei_endpfn)
-		return 0;
-
-	/* Skip if map is outside the node */
-	if (*ei_endpfn <= start_pfn || *ei_startpfn >= last_pfn)
-		return 0;
-
-	/* Check for overlaps */
-	if (*ei_startpfn < start_pfn)
-		*ei_startpfn = start_pfn;
-	if (*ei_endpfn > last_pfn)
-		*ei_endpfn = last_pfn;
-
-	return 1;
-}
-
-/*
- * Find the hole size (in bytes) in the memory range.
- * @start: starting address of the memory range to scan
- * @end: ending address of the memory range to scan
- */
-u64 __init memblock_x86_hole_size(u64 start, u64 end)
-{
-	unsigned long start_pfn = start >> PAGE_SHIFT;
-	unsigned long last_pfn = end >> PAGE_SHIFT;
-	unsigned long ei_startpfn, ei_endpfn, ram = 0;
-	struct memblock_region *r;
-
-	for_each_memblock(memory, r)
-		if (memblock_x86_find_active_region(r, start_pfn, last_pfn,
-					   &ei_startpfn, &ei_endpfn))
-			ram += ei_endpfn - ei_startpfn;
-
-	return end - start - ((u64)ram << PAGE_SHIFT);
-}
diff --git a/arch/x86/mm/numa.c b/arch/x86/mm/numa.c
index f4a40bd..88e5627 100644
--- a/arch/x86/mm/numa.c
+++ b/arch/x86/mm/numa.c
@@ -475,8 +475,8 @@ static bool __init numa_meminfo_cover_memory(const struct numa_meminfo *mi)
 			numaram = 0;
 	}
 
-	e820ram = max_pfn - (memblock_x86_hole_size(0,
-					PFN_PHYS(max_pfn)) >> PAGE_SHIFT);
+	e820ram = max_pfn - absent_pages_in_range(0, max_pfn);
+
 	/* We seem to lose 3 pages somewhere. Allow 1M of slack. */
 	if ((s64)(e820ram - numaram) >= (1 << (20 - PAGE_SHIFT))) {
 		printk(KERN_ERR "NUMA: nodes only cover %LuMB of your %LuMB e820 RAM. Not used.\n",
diff --git a/arch/x86/mm/numa_emulation.c b/arch/x86/mm/numa_emulation.c
index e3d471c..971fe70 100644
--- a/arch/x86/mm/numa_emulation.c
+++ b/arch/x86/mm/numa_emulation.c
@@ -28,6 +28,16 @@ static int __init emu_find_memblk_by_nid(int nid, const struct numa_meminfo *mi)
 	return -ENOENT;
 }
 
+static u64 mem_hole_size(u64 start, u64 end)
+{
+	unsigned long start_pfn = PFN_UP(start);
+	unsigned long end_pfn = PFN_DOWN(end);
+
+	if (start_pfn < end_pfn)
+		return PFN_PHYS(absent_pages_in_range(start_pfn, end_pfn));
+	return 0;
+}
+
 /*
  * Sets up nid to range from @start to @end.  The return value is -errno if
  * something went wrong, 0 otherwise.
@@ -89,7 +99,7 @@ static int __init split_nodes_interleave(struct numa_meminfo *ei,
 	 * Calculate target node size.  x86_32 freaks on __udivdi3() so do
 	 * the division in ulong number of pages and convert back.
 	 */
-	size = max_addr - addr - memblock_x86_hole_size(addr, max_addr);
+	size = max_addr - addr - mem_hole_size(addr, max_addr);
 	size = PFN_PHYS((unsigned long)(size >> PAGE_SHIFT) / nr_nodes);
 
 	/*
@@ -135,8 +145,7 @@ static int __init split_nodes_interleave(struct numa_meminfo *ei,
 			 * Continue to add memory to this fake node if its
 			 * non-reserved memory is less than the per-node size.
 			 */
-			while (end - start -
-			       memblock_x86_hole_size(start, end) < size) {
+			while (end - start - mem_hole_size(start, end) < size) {
 				end += FAKE_NODE_MIN_SIZE;
 				if (end > limit) {
 					end = limit;
@@ -150,7 +159,7 @@ static int __init split_nodes_interleave(struct numa_meminfo *ei,
 			 * this one must extend to the boundary.
 			 */
 			if (end < dma32_end && dma32_end - end -
-			    memblock_x86_hole_size(end, dma32_end) < FAKE_NODE_MIN_SIZE)
+			    mem_hole_size(end, dma32_end) < FAKE_NODE_MIN_SIZE)
 				end = dma32_end;
 
 			/*
@@ -158,8 +167,7 @@ static int __init split_nodes_interleave(struct numa_meminfo *ei,
 			 * next node, this one must extend to the end of the
 			 * physical node.
 			 */
-			if (limit - end -
-			    memblock_x86_hole_size(end, limit) < size)
+			if (limit - end - mem_hole_size(end, limit) < size)
 				end = limit;
 
 			ret = emu_setup_memblk(ei, pi, nid++ % nr_nodes,
@@ -180,7 +188,7 @@ static u64 __init find_end_of_node(u64 start, u64 max_addr, u64 size)
 {
 	u64 end = start + size;
 
-	while (end - start - memblock_x86_hole_size(start, end) < size) {
+	while (end - start - mem_hole_size(start, end) < size) {
 		end += FAKE_NODE_MIN_SIZE;
 		if (end > max_addr) {
 			end = max_addr;
@@ -211,8 +219,7 @@ static int __init split_nodes_size_interleave(struct numa_meminfo *ei,
 	 * creates a uniform distribution of node sizes across the entire
 	 * machine (but not necessarily over physical nodes).
 	 */
-	min_size = (max_addr - addr - memblock_x86_hole_size(addr, max_addr)) /
-						MAX_NUMNODES;
+	min_size = (max_addr - addr - mem_hole_size(addr, max_addr)) / MAX_NUMNODES;
 	min_size = max(min_size, FAKE_NODE_MIN_SIZE);
 	if ((min_size & FAKE_NODE_MIN_HASH_MASK) < min_size)
 		min_size = (min_size + FAKE_NODE_MIN_SIZE) &
@@ -252,7 +259,7 @@ static int __init split_nodes_size_interleave(struct numa_meminfo *ei,
 			 * this one must extend to the boundary.
 			 */
 			if (end < dma32_end && dma32_end - end -
-			    memblock_x86_hole_size(end, dma32_end) < FAKE_NODE_MIN_SIZE)
+			    mem_hole_size(end, dma32_end) < FAKE_NODE_MIN_SIZE)
 				end = dma32_end;
 
 			/*
@@ -260,8 +267,7 @@ static int __init split_nodes_size_interleave(struct numa_meminfo *ei,
 			 * next node, this one must extend to the end of the
 			 * physical node.
 			 */
-			if (limit - end -
-			    memblock_x86_hole_size(end, limit) < size)
+			if (limit - end - mem_hole_size(end, limit) < size)
 				end = limit;
 
 			ret = emu_setup_memblk(ei, pi, nid++ % MAX_NUMNODES,
