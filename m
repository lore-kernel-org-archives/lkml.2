Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932520Ab1GNVgR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jul 2011 17:36:17 -0400
Received: from hera.kernel.org ([140.211.167.34]:59851 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932232Ab1GNVgP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jul 2011 17:36:15 -0400
Date: Thu, 14 Jul 2011 21:36:09 GMT
From: tip-bot for Tejun Heo <tj@kernel.org>
Message-ID: <tip-6b5d41a1b97f5529284f16170211b87fd60264c0@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        benh@kernel.crashing.org, yinghai@kernel.org, tj@kernel.org,
        tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        yinghai@kernel.org, benh@kernel.crashing.org, tj@kernel.org,
        tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1310462166-31469-11-git-send-email-tj@kernel.org>
References: <1310462166-31469-11-git-send-email-tj@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/memblock] memblock, x86: Reimplement memblock_find_dma_reserve() using iterators
Git-Commit-ID: 6b5d41a1b97f5529284f16170211b87fd60264c0
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 14 Jul 2011 21:36:09 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6b5d41a1b97f5529284f16170211b87fd60264c0
Gitweb:     http://git.kernel.org/tip/6b5d41a1b97f5529284f16170211b87fd60264c0
Author:     Tejun Heo <tj@kernel.org>
AuthorDate: Tue, 12 Jul 2011 11:16:03 +0200
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Thu, 14 Jul 2011 11:47:50 -0700

memblock, x86: Reimplement memblock_find_dma_reserve() using iterators

memblock_find_dma_reserve() wants to find out how much memory is
reserved under MAX_DMA_PFN.  memblock_x86_memory_[free_]in_range() are
used to find out the amounts of all available and free memory in the
area, which are then subtracted to find out the amount of reservation.

memblock_x86_memblock_[free_]in_range() are implemented using
__memblock_x86_memory_in_range() which builds ranges from memblock and
then count them, which is rather unnecessarily complex.

This patch open codes the counting logic directly in
memblock_find_dma_reserve() using memblock iterators and removes now
unused __memblock_x86_memory_in_range() and find_range_array().

Signed-off-by: Tejun Heo <tj@kernel.org>
Link: http://lkml.kernel.org/r/1310462166-31469-11-git-send-email-tj@kernel.org
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/include/asm/memblock.h |    2 -
 arch/x86/kernel/e820.c          |   25 +++++++++--
 arch/x86/mm/memblock.c          |   87 ---------------------------------------
 3 files changed, 20 insertions(+), 94 deletions(-)

diff --git a/arch/x86/include/asm/memblock.h b/arch/x86/include/asm/memblock.h
index bc9e44b..a0cc7d6 100644
--- a/arch/x86/include/asm/memblock.h
+++ b/arch/x86/include/asm/memblock.h
@@ -7,7 +7,5 @@ void memblock_x86_reserve_range(u64 start, u64 end, char *name);
 void memblock_x86_free_range(u64 start, u64 end);
 
 u64 memblock_x86_hole_size(u64 start, u64 end);
-u64 memblock_x86_free_memory_in_range(u64 addr, u64 limit);
-u64 memblock_x86_memory_in_range(u64 addr, u64 limit);
 
 #endif
diff --git a/arch/x86/kernel/e820.c b/arch/x86/kernel/e820.c
index b99d940..84475f1 100644
--- a/arch/x86/kernel/e820.c
+++ b/arch/x86/kernel/e820.c
@@ -1093,15 +1093,30 @@ void __init memblock_x86_fill(void)
 void __init memblock_find_dma_reserve(void)
 {
 #ifdef CONFIG_X86_64
-	u64 free_size_pfn;
-	u64 mem_size_pfn;
+	u64 nr_pages = 0, nr_free_pages = 0;
+	unsigned long start_pfn, end_pfn;
+	phys_addr_t start, end;
+	int i;
+	u64 u;
+
 	/*
 	 * need to find out used area below MAX_DMA_PFN
 	 * need to use memblock to get free size in [0, MAX_DMA_PFN]
 	 * at first, and assume boot_mem will not take below MAX_DMA_PFN
 	 */
-	mem_size_pfn = memblock_x86_memory_in_range(0, MAX_DMA_PFN << PAGE_SHIFT) >> PAGE_SHIFT;
-	free_size_pfn = memblock_x86_free_memory_in_range(0, MAX_DMA_PFN << PAGE_SHIFT) >> PAGE_SHIFT;
-	set_dma_reserve(mem_size_pfn - free_size_pfn);
+	for_each_mem_pfn_range(i, MAX_NUMNODES, &start_pfn, &end_pfn, NULL) {
+		start_pfn = min_t(unsigned long, start_pfn, MAX_DMA_PFN);
+		end_pfn = min_t(unsigned long, end_pfn, MAX_DMA_PFN);
+		nr_pages += end_pfn - start_pfn;
+	}
+
+	for_each_free_mem_range(u, MAX_NUMNODES, &start, &end, NULL) {
+		start_pfn = min_t(unsigned long, PFN_UP(start), MAX_DMA_PFN);
+		end_pfn = min_t(unsigned long, PFN_DOWN(end), MAX_DMA_PFN);
+		if (start_pfn < end_pfn)
+			nr_free_pages += end_pfn - start_pfn;
+	}
+
+	set_dma_reserve(nr_pages - nr_free_pages);
 #endif
 }
diff --git a/arch/x86/mm/memblock.c b/arch/x86/mm/memblock.c
index 4107c1a..a9d0972 100644
--- a/arch/x86/mm/memblock.c
+++ b/arch/x86/mm/memblock.c
@@ -7,93 +7,6 @@
 #include <linux/mm.h>
 #include <linux/range.h>
 
-static __init struct range *find_range_array(int count)
-{
-	u64 end, size, mem;
-	struct range *range;
-
-	size = sizeof(struct range) * count;
-	end = memblock.current_limit;
-
-	mem = memblock_find_in_range(0, end, size, sizeof(struct range));
-	if (!mem)
-		panic("can not find more space for range array");
-
-	/*
-	 * This range is tempoaray, so don't reserve it, it will not be
-	 * overlapped because We will not alloccate new buffer before
-	 * We discard this one
-	 */
-	range = __va(mem);
-	memset(range, 0, size);
-
-	return range;
-}
-
-static u64 __init __memblock_x86_memory_in_range(u64 addr, u64 limit, bool get_free)
-{
-	int i, count;
-	struct range *range;
-	int nr_range;
-	u64 final_start, final_end;
-	u64 free_size;
-	struct memblock_region *r;
-
-	count = (memblock.reserved.cnt + memblock.memory.cnt) * 2;
-
-	range = find_range_array(count);
-	nr_range = 0;
-
-	addr = PFN_UP(addr);
-	limit = PFN_DOWN(limit);
-
-	for_each_memblock(memory, r) {
-		final_start = PFN_UP(r->base);
-		final_end = PFN_DOWN(r->base + r->size);
-		if (final_start >= final_end)
-			continue;
-		if (final_start >= limit || final_end <= addr)
-			continue;
-
-		nr_range = add_range(range, count, nr_range, final_start, final_end);
-	}
-	subtract_range(range, count, 0, addr);
-	subtract_range(range, count, limit, -1ULL);
-
-	/* Subtract memblock.reserved.region in range ? */
-	if (!get_free)
-		goto sort_and_count_them;
-	for_each_memblock(reserved, r) {
-		final_start = PFN_DOWN(r->base);
-		final_end = PFN_UP(r->base + r->size);
-		if (final_start >= final_end)
-			continue;
-		if (final_start >= limit || final_end <= addr)
-			continue;
-
-		subtract_range(range, count, final_start, final_end);
-	}
-
-sort_and_count_them:
-	nr_range = clean_sort_range(range, count);
-
-	free_size = 0;
-	for (i = 0; i < nr_range; i++)
-		free_size += range[i].end - range[i].start;
-
-	return free_size << PAGE_SHIFT;
-}
-
-u64 __init memblock_x86_free_memory_in_range(u64 addr, u64 limit)
-{
-	return __memblock_x86_memory_in_range(addr, limit, true);
-}
-
-u64 __init memblock_x86_memory_in_range(u64 addr, u64 limit)
-{
-	return __memblock_x86_memory_in_range(addr, limit, false);
-}
-
 void __init memblock_x86_reserve_range(u64 start, u64 end, char *name)
 {
 	if (start == end)
