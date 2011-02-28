Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757321Ab1CATjc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 14:39:32 -0500
Received: from 206.83.70.71.ptr.us.xo.net ([206.83.70.71]:52544 "EHLO
	king.tilera.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757224Ab1CAThY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 14:37:24 -0500
X-Greylist: delayed 369 seconds by postgrey-1.27 at vger.kernel.org; Tue, 01 Mar 2011 14:37:17 EST
Message-Id: <201103011934.p21JYelW010308@farm-0010.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Mon, 28 Feb 2011 15:48:39 -0500
Subject: [PATCH] arch/tile: enhance existing finv_buffer_remote() routine
To: linux-kernel@vger.kernel.org
In-Reply-To: <201103011931.p21JVtqp010237@farm-0010.internal.tilera.com>
X-OriginalArrivalTime: 01 Mar 2011 19:34:40.0170 (UTC) FILETIME=[B50878A0:01CBD847]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It now takes an additional argument so it can be used to
flush-and-invalidate pages that are cached using hash-for-home
as well those that are cached with coherence point on a single cpu.

This allows it to be used more widely for changing the coherence
point of arbitrary pages when necessary.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/include/asm/cacheflush.h |   55 ++-----------------
 arch/tile/lib/cacheflush.c         |  102 ++++++++++++++++++++++++++++++++++++
 arch/tile/mm/homecache.c           |   36 +++++++++++--
 drivers/net/tile/tilepro.c         |    4 +-
 4 files changed, 141 insertions(+), 56 deletions(-)

diff --git a/arch/tile/include/asm/cacheflush.h b/arch/tile/include/asm/cacheflush.h
index 14a3f85..12fb0fb 100644
--- a/arch/tile/include/asm/cacheflush.h
+++ b/arch/tile/include/asm/cacheflush.h
@@ -138,55 +138,12 @@ static inline void finv_buffer(void *buffer, size_t size)
 }
 
 /*
- * Flush & invalidate a VA range that is homed remotely on a single core,
- * waiting until the memory controller holds the flushed values.
+ * Flush and invalidate a VA range that is homed remotely, waiting
+ * until the memory controller holds the flushed values.  If "hfh" is
+ * true, we will do a more expensive flush involving additional loads
+ * to make sure we have touched all the possible home cpus of a buffer
+ * that is homed with "hash for home".
  */
-static inline void finv_buffer_remote(void *buffer, size_t size)
-{
-	char *p;
-	int i;
-
-	/*
-	 * Flush and invalidate the buffer out of the local L1/L2
-	 * and request the home cache to flush and invalidate as well.
-	 */
-	__finv_buffer(buffer, size);
-
-	/*
-	 * Wait for the home cache to acknowledge that it has processed
-	 * all the flush-and-invalidate requests.  This does not mean
-	 * that the flushed data has reached the memory controller yet,
-	 * but it does mean the home cache is processing the flushes.
-	 */
-	__insn_mf();
-
-	/*
-	 * Issue a load to the last cache line, which can't complete
-	 * until all the previously-issued flushes to the same memory
-	 * controller have also completed.  If we weren't striping
-	 * memory, that one load would be sufficient, but since we may
-	 * be, we also need to back up to the last load issued to
-	 * another memory controller, which would be the point where
-	 * we crossed an 8KB boundary (the granularity of striping
-	 * across memory controllers).  Keep backing up and doing this
-	 * until we are before the beginning of the buffer, or have
-	 * hit all the controllers.
-	 */
-	for (i = 0, p = (char *)buffer + size - 1;
-	     i < (1 << CHIP_LOG_NUM_MSHIMS()) && p >= (char *)buffer;
-	     ++i) {
-		const unsigned long STRIPE_WIDTH = 8192;
-
-		/* Force a load instruction to issue. */
-		*(volatile char *)p;
-
-		/* Jump to end of previous stripe. */
-		p -= STRIPE_WIDTH;
-		p = (char *)((unsigned long)p | (STRIPE_WIDTH - 1));
-	}
-
-	/* Wait for the loads (and thus flushes) to have completed. */
-	__insn_mf();
-}
+void finv_buffer_remote(void *buffer, size_t size, int hfh);
 
 #endif /* _ASM_TILE_CACHEFLUSH_H */
diff --git a/arch/tile/lib/cacheflush.c b/arch/tile/lib/cacheflush.c
index 11b6164..35c1d8c 100644
--- a/arch/tile/lib/cacheflush.c
+++ b/arch/tile/lib/cacheflush.c
@@ -21,3 +21,105 @@ void __flush_icache_range(unsigned long start, unsigned long end)
 {
 	invalidate_icache((const void *)start, end - start, PAGE_SIZE);
 }
+
+
+/* Force a load instruction to issue. */
+static inline void force_load(char *p)
+{
+	*(volatile char *)p;
+}
+
+/*
+ * Flush and invalidate a VA range that is homed remotely on a single
+ * core (if "!hfh") or homed via hash-for-home (if "hfh"), waiting
+ * until the memory controller holds the flushed values.
+ */
+void finv_buffer_remote(void *buffer, size_t size, int hfh)
+{
+	char *p, *base;
+	size_t step_size, load_count;
+	const unsigned long STRIPE_WIDTH = 8192;
+
+	/*
+	 * Flush and invalidate the buffer out of the local L1/L2
+	 * and request the home cache to flush and invalidate as well.
+	 */
+	__finv_buffer(buffer, size);
+
+	/*
+	 * Wait for the home cache to acknowledge that it has processed
+	 * all the flush-and-invalidate requests.  This does not mean
+	 * that the flushed data has reached the memory controller yet,
+	 * but it does mean the home cache is processing the flushes.
+	 */
+	__insn_mf();
+
+	/*
+	 * Issue a load to the last cache line, which can't complete
+	 * until all the previously-issued flushes to the same memory
+	 * controller have also completed.  If we weren't striping
+	 * memory, that one load would be sufficient, but since we may
+	 * be, we also need to back up to the last load issued to
+	 * another memory controller, which would be the point where
+	 * we crossed an 8KB boundary (the granularity of striping
+	 * across memory controllers).  Keep backing up and doing this
+	 * until we are before the beginning of the buffer, or have
+	 * hit all the controllers.
+	 *
+	 * If we are flushing a hash-for-home buffer, it's even worse.
+	 * Each line may be homed on a different tile, and each tile
+	 * may have up to four lines that are on different
+	 * controllers.  So as we walk backwards, we have to touch
+	 * enough cache lines to satisfy these constraints.  In
+	 * practice this ends up being close enough to "load from
+	 * every cache line on a full memory stripe on each
+	 * controller" that we simply do that, to simplify the logic.
+	 *
+	 * FIXME: See bug 9535 for some issues with this code.
+	 */
+	if (hfh) {
+		step_size = L2_CACHE_BYTES;
+		load_count = (STRIPE_WIDTH / L2_CACHE_BYTES) *
+			      (1 << CHIP_LOG_NUM_MSHIMS());
+	} else {
+		step_size = STRIPE_WIDTH;
+		load_count = (1 << CHIP_LOG_NUM_MSHIMS());
+	}
+
+	/* Load the last byte of the buffer. */
+	p = (char *)buffer + size - 1;
+	force_load(p);
+
+	/* Bump down to the end of the previous stripe or cache line. */
+	p -= step_size;
+	p = (char *)((unsigned long)p | (step_size - 1));
+
+	/* Figure out how far back we need to go. */
+	base = p - (step_size * (load_count - 2));
+	if ((long)base < (long)buffer)
+		base = buffer;
+
+	/*
+	 * Fire all the loads we need.  The MAF only has eight entries
+	 * so we can have at most eight outstanding loads, so we
+	 * unroll by that amount.
+	 */
+#pragma unroll 8
+	for (; p >= base; p -= step_size)
+		force_load(p);
+
+	/*
+	 * Repeat, but with inv's instead of loads, to get rid of the
+	 * data we just loaded into our own cache and the old home L3.
+	 * No need to unroll since inv's don't target a register.
+	 */
+	p = (char *)buffer + size - 1;
+	__insn_inv(p);
+	p -= step_size;
+	p = (char *)((unsigned long)p | (step_size - 1));
+	for (; p >= base; p -= step_size)
+		__insn_inv(p);
+
+	/* Wait for the load+inv's (and thus finvs) to have completed. */
+	__insn_mf();
+}
diff --git a/arch/tile/mm/homecache.c b/arch/tile/mm/homecache.c
index d78df3a..f344f4f 100644
--- a/arch/tile/mm/homecache.c
+++ b/arch/tile/mm/homecache.c
@@ -179,23 +179,46 @@ void flush_remote(unsigned long cache_pfn, unsigned long cache_control,
 	panic("Unsafe to continue.");
 }
 
+void flush_remote_page(struct page *page, int order)
+{
+	int i, pages = (1 << order);
+	for (i = 0; i < pages; ++i, ++page) {
+		void *p = kmap_atomic(page);
+		int hfh = 0;
+		int home = page_home(page);
+#if CHIP_HAS_CBOX_HOME_MAP()
+		if (home == PAGE_HOME_HASH)
+			hfh = 1;
+		else
+#endif
+			BUG_ON(home < 0 || home >= NR_CPUS);
+		finv_buffer_remote(p, PAGE_SIZE, hfh);
+		kunmap_atomic(p);
+	}
+}
+
 void homecache_evict(const struct cpumask *mask)
 {
 	flush_remote(0, HV_FLUSH_EVICT_L2, mask, 0, 0, 0, NULL, NULL, 0);
 }
 
-/* Return a mask of the cpus whose caches currently own these pages. */
-static void homecache_mask(struct page *page, int pages,
-			   struct cpumask *home_mask)
+/*
+ * Return a mask of the cpus whose caches currently own these pages.
+ * The return value is whether the pages are all coherently cached
+ * (i.e. none are immutable, incoherent, or uncached).
+ */
+static int homecache_mask(struct page *page, int pages,
+			  struct cpumask *home_mask)
 {
 	int i;
+	int cached_coherently = 1;
 	cpumask_clear(home_mask);
 	for (i = 0; i < pages; ++i) {
 		int home = page_home(&page[i]);
 		if (home == PAGE_HOME_IMMUTABLE ||
 		    home == PAGE_HOME_INCOHERENT) {
 			cpumask_copy(home_mask, cpu_possible_mask);
-			return;
+			return 0;
 		}
 #if CHIP_HAS_CBOX_HOME_MAP()
 		if (home == PAGE_HOME_HASH) {
@@ -203,11 +226,14 @@ static void homecache_mask(struct page *page, int pages,
 			continue;
 		}
 #endif
-		if (home == PAGE_HOME_UNCACHED)
+		if (home == PAGE_HOME_UNCACHED) {
+			cached_coherently = 0;
 			continue;
+		}
 		BUG_ON(home < 0 || home >= NR_CPUS);
 		cpumask_set_cpu(home, home_mask);
 	}
+	return cached_coherently;
 }
 
 /*
diff --git a/drivers/net/tile/tilepro.c b/drivers/net/tile/tilepro.c
index 7cb301d..f901299 100644
--- a/drivers/net/tile/tilepro.c
+++ b/drivers/net/tile/tilepro.c
@@ -1620,7 +1620,7 @@ static unsigned int tile_net_tx_frags(lepp_frag_t *frags,
 	if (b_len != 0) {
 
 		if (!hash_default)
-			finv_buffer_remote(b_data, b_len);
+			finv_buffer_remote(b_data, b_len, 0);
 
 		cpa = __pa(b_data);
 		frags[n].cpa_lo = cpa;
@@ -1643,7 +1643,7 @@ static unsigned int tile_net_tx_frags(lepp_frag_t *frags,
 		if (!hash_default) {
 			void *va = pfn_to_kaddr(pfn) + f->page_offset;
 			BUG_ON(PageHighMem(f->page));
-			finv_buffer_remote(va, f->size);
+			finv_buffer_remote(va, f->size, 0);
 		}
 
 		cpa = ((phys_addr_t)pfn << PAGE_SHIFT) + f->page_offset;
-- 
1.6.5.2

