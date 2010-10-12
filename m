Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752048Ab0JLWrY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Oct 2010 18:47:24 -0400
Received: from hera.kernel.org ([140.211.167.34]:38929 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751253Ab0JLWrW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Oct 2010 18:47:22 -0400
Date: Tue, 12 Oct 2010 22:46:47 GMT
From: tip-bot for Yinghai Lu <yinghai@kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        yinghai@kernel.org, rmk@arm.linux.org.uk, jeremy@goop.org,
        tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        yinghai@kernel.org, rmk@arm.linux.org.uk, jeremy@goop.org,
        tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <4CB4CDFD.4020105@kernel.org>
References: <4CB4CDFD.4020105@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/memblock] memblock, bootmem: Round pfn properly for memory and reserved regions
Message-ID: <tip-c7fc2de0c83dbd2eaf759c5cd0e2b9cf1eb4df3a@git.kernel.org>
Git-Commit-ID: c7fc2de0c83dbd2eaf759c5cd0e2b9cf1eb4df3a
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 12 Oct 2010 22:46:48 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c7fc2de0c83dbd2eaf759c5cd0e2b9cf1eb4df3a
Gitweb:     http://git.kernel.org/tip/c7fc2de0c83dbd2eaf759c5cd0e2b9cf1eb4df3a
Author:     Yinghai Lu <yinghai@kernel.org>
AuthorDate: Tue, 12 Oct 2010 14:07:09 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Tue, 12 Oct 2010 15:37:51 -0700

memblock, bootmem: Round pfn properly for memory and reserved regions

We need to round memory regions correctly -- specifically, we need to
round reserved region in the more expansive direction (lower limit
down, upper limit up) whereas usable memory regions need to be rounded
in the more restrictive direction (lower limit up, upper limit down).

This introduces two set of inlines:

	memblock_region_memory_base_pfn()
	memblock_region_memory_end_pfn()
	memblock_region_reserved_base_pfn()
	memblock_region_reserved_end_pfn()

Although they are antisymmetric (and therefore are technically
duplicates) the use of the different inlines explicitly documents the
programmer's intention.

The lack of proper rounding caused a bug on ARM, which was then found
to also affect other architectures.

Reported-by: Russell King <rmk@arm.linux.org.uk>
Signed-off-by: Yinghai Lu <yinghai@kernel.org>
LKML-Reference: <4CB4CDFD.4020105@kernel.org>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/arm/mm/init.c       |    8 ++++----
 arch/powerpc/mm/mem.c    |   14 +++++++-------
 arch/powerpc/mm/numa.c   |    4 ++--
 arch/sh/mm/init.c        |    4 ++--
 arch/sparc/mm/init_64.c  |    4 ++--
 include/linux/memblock.h |   25 ++++++++++++-------------
 6 files changed, 29 insertions(+), 30 deletions(-)

diff --git a/arch/arm/mm/init.c b/arch/arm/mm/init.c
index d6022d1..63f4417 100644
--- a/arch/arm/mm/init.c
+++ b/arch/arm/mm/init.c
@@ -182,8 +182,8 @@ static void __init arm_bootmem_init(struct meminfo *mi,
 	 * Reserve the memblock reserved regions in bootmem.
 	 */
 	for_each_memblock(reserved, reg) {
-		phys_addr_t start = memblock_region_base_pfn(reg);
-		phys_addr_t end = memblock_region_end_pfn(reg);
+		phys_addr_t start = memblock_region_reserved_base_pfn(reg);
+		phys_addr_t end = memblock_region_reserved_end_pfn(reg);
 		if (start >= start_pfn && end <= end_pfn)
 			reserve_bootmem_node(pgdat, __pfn_to_phys(start),
 					     (end - start) << PAGE_SHIFT,
@@ -251,8 +251,8 @@ static void arm_memory_present(void)
 	struct memblock_region *reg;
 
 	for_each_memblock(memory, reg)
-		memory_present(0, memblock_region_base_pfn(reg),
-			       memblock_region_end_pfn(reg));
+		memory_present(0, memblock_region_memory_base_pfn(reg),
+			       memblock_region_memory_end_pfn(reg));
 }
 #endif
 
diff --git a/arch/powerpc/mm/mem.c b/arch/powerpc/mm/mem.c
index f661f6c..a664996 100644
--- a/arch/powerpc/mm/mem.c
+++ b/arch/powerpc/mm/mem.c
@@ -148,8 +148,8 @@ walk_system_ram_range(unsigned long start_pfn, unsigned long nr_pages,
 	int ret = -1;
 
 	for_each_memblock(memory, reg) {
-		tstart = max(start_pfn, memblock_region_base_pfn(reg));
-		tend = min(end_pfn, memblock_region_end_pfn(reg));
+		tstart = max(start_pfn, memblock_region_memory_base_pfn(reg));
+		tend = min(end_pfn, memblock_region_memory_end_pfn(reg));
 		if (tstart >= tend)
 			continue;
 		ret = (*func)(tstart, tend - tstart, arg);
@@ -195,8 +195,8 @@ void __init do_init_bootmem(void)
 	/* Add active regions with valid PFNs */
 	for_each_memblock(memory, reg) {
 		unsigned long start_pfn, end_pfn;
-		start_pfn = memblock_region_base_pfn(reg);
-		end_pfn = memblock_region_end_pfn(reg);
+		start_pfn = memblock_region_memory_base_pfn(reg);
+		end_pfn = memblock_region_memory_end_pfn(reg);
 		add_active_range(0, start_pfn, end_pfn);
 	}
 
@@ -236,9 +236,9 @@ static int __init mark_nonram_nosave(void)
 
 	for_each_memblock(memory, reg) {
 		if (prev &&
-		    memblock_region_end_pfn(prev) < memblock_region_base_pfn(reg))
-			register_nosave_region(memblock_region_end_pfn(prev),
-					       memblock_region_base_pfn(reg));
+		    memblock_region_memory_end_pfn(prev) < memblock_region_memory_base_pfn(reg))
+			register_nosave_region(memblock_region_memory_end_pfn(prev),
+					       memblock_region_memory_base_pfn(reg));
 		prev = reg;
 	}
 	return 0;
diff --git a/arch/powerpc/mm/numa.c b/arch/powerpc/mm/numa.c
index 066fb44..74505b2 100644
--- a/arch/powerpc/mm/numa.c
+++ b/arch/powerpc/mm/numa.c
@@ -811,8 +811,8 @@ static void __init setup_nonnuma(void)
 	       (top_of_ram - total_ram) >> 20);
 
 	for_each_memblock(memory, reg) {
-		start_pfn = memblock_region_base_pfn(reg);
-		end_pfn = memblock_region_end_pfn(reg);
+		start_pfn = memblock_region_memory_base_pfn(reg);
+		end_pfn = memblock_region_memory_end_pfn(reg);
 
 		fake_numa_create_new_node(end_pfn, &nid);
 		add_active_range(nid, start_pfn, end_pfn);
diff --git a/arch/sh/mm/init.c b/arch/sh/mm/init.c
index b977475..552bea5 100644
--- a/arch/sh/mm/init.c
+++ b/arch/sh/mm/init.c
@@ -244,8 +244,8 @@ static void __init do_init_bootmem(void)
 	/* Add active regions with valid PFNs. */
 	for_each_memblock(memory, reg) {
 		unsigned long start_pfn, end_pfn;
-		start_pfn = memblock_region_base_pfn(reg);
-		end_pfn = memblock_region_end_pfn(reg);
+		start_pfn = memblock_region_memory_base_pfn(reg);
+		end_pfn = memblock_region_memory_end_pfn(reg);
 		__add_active_range(0, start_pfn, end_pfn);
 	}
 
diff --git a/arch/sparc/mm/init_64.c b/arch/sparc/mm/init_64.c
index dc584d2..4c25727 100644
--- a/arch/sparc/mm/init_64.c
+++ b/arch/sparc/mm/init_64.c
@@ -1294,8 +1294,8 @@ static void __init bootmem_init_nonnuma(void)
 		if (!reg->size)
 			continue;
 
-		start_pfn = memblock_region_base_pfn(reg);
-		end_pfn = memblock_region_end_pfn(reg);
+		start_pfn = memblock_region_memory_base_pfn(reg);
+		end_pfn = memblock_region_memory_end_pfn(reg);
 		add_active_range(0, start_pfn, end_pfn);
 	}
 
diff --git a/include/linux/memblock.h b/include/linux/memblock.h
index 5096458..62a10c2 100644
--- a/include/linux/memblock.h
+++ b/include/linux/memblock.h
@@ -111,40 +111,39 @@ extern void memblock_set_current_limit(phys_addr_t limit);
  */
 
 /**
- * memblock_region_base_pfn - Return the lowest pfn intersecting with the region
+ * memblock_region_memory_base_pfn - Return the lowest pfn intersecting with the memory region
  * @reg: memblock_region structure
  */
-static inline unsigned long memblock_region_base_pfn(const struct memblock_region *reg)
+static inline unsigned long memblock_region_memory_base_pfn(const struct memblock_region *reg)
 {
-	return reg->base >> PAGE_SHIFT;
+	return PFN_UP(reg->base);
 }
 
 /**
- * memblock_region_last_pfn - Return the highest pfn intersecting with the region
+ * memblock_region_memory_end_pfn - Return the end_pfn this region
  * @reg: memblock_region structure
  */
-static inline unsigned long memblock_region_last_pfn(const struct memblock_region *reg)
+static inline unsigned long memblock_region_memory_end_pfn(const struct memblock_region *reg)
 {
-	return (reg->base + reg->size - 1) >> PAGE_SHIFT;
+	return PFN_DOWN(reg->base + reg->size);
 }
 
 /**
- * memblock_region_end_pfn - Return the pfn of the first page following the region
- *                      but not intersecting it
+ * memblock_region_reserved_base_pfn - Return the lowest pfn intersecting with the reserved region
  * @reg: memblock_region structure
  */
-static inline unsigned long memblock_region_end_pfn(const struct memblock_region *reg)
+static inline unsigned long memblock_region_reserved_base_pfn(const struct memblock_region *reg)
 {
-	return memblock_region_last_pfn(reg) + 1;
+	return PFN_DOWN(reg->base);
 }
 
 /**
- * memblock_region_pages - Return the number of pages covering a region
+ * memblock_region_reserved_end_pfn - Return the end_pfn this region
  * @reg: memblock_region structure
  */
-static inline unsigned long memblock_region_pages(const struct memblock_region *reg)
+static inline unsigned long memblock_region_reserved_end_pfn(const struct memblock_region *reg)
 {
-	return memblock_region_end_pfn(reg) - memblock_region_end_pfn(reg);
+	return PFN_UP(reg->base + reg->size);
 }
 
 #define for_each_memblock(memblock_type, region)					\
