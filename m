Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753665Ab1GNDjo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jul 2011 23:39:44 -0400
Received: from hera.kernel.org ([140.211.167.34]:58761 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753273Ab1GNDjm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jul 2011 23:39:42 -0400
Date: Thu, 14 Jul 2011 03:39:34 GMT
From: tip-bot for Tejun Heo <tj@kernel.org>
Message-ID: <tip-1f5026a7e21e409c2b9dd54f6dfb9446511fb7c5@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        benh@kernel.crashing.org, yinghai@kernel.org, tj@kernel.org,
        tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        yinghai@kernel.org, benh@kernel.crashing.org, tj@kernel.org,
        tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1310457490-3356-6-git-send-email-tj@kernel.org>
References: <1310457490-3356-6-git-send-email-tj@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/memblock] memblock: Kill MEMBLOCK_ERROR
Git-Commit-ID: 1f5026a7e21e409c2b9dd54f6dfb9446511fb7c5
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 14 Jul 2011 03:39:35 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1f5026a7e21e409c2b9dd54f6dfb9446511fb7c5
Gitweb:     http://git.kernel.org/tip/1f5026a7e21e409c2b9dd54f6dfb9446511fb7c5
Author:     Tejun Heo <tj@kernel.org>
AuthorDate: Tue, 12 Jul 2011 09:58:09 +0200
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Wed, 13 Jul 2011 16:36:01 -0700

memblock: Kill MEMBLOCK_ERROR

25818f0f28 (memblock: Make MEMBLOCK_ERROR be 0) thankfully made
MEMBLOCK_ERROR 0 and there already are codes which expect error return
to be 0.  There's no point in keeping MEMBLOCK_ERROR around.  End its
misery.

Signed-off-by: Tejun Heo <tj@kernel.org>
Link: http://lkml.kernel.org/r/1310457490-3356-6-git-send-email-tj@kernel.org
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/kernel/aperture_64.c |    2 +-
 arch/x86/kernel/check.c       |    2 +-
 arch/x86/kernel/e820.c        |    2 +-
 arch/x86/kernel/setup.c       |    4 ++--
 arch/x86/kernel/trampoline.c  |    2 +-
 arch/x86/mm/init.c            |    2 +-
 arch/x86/mm/memblock.c        |    6 +++---
 arch/x86/mm/numa.c            |    6 +++---
 arch/x86/mm/numa_32.c         |    4 ++--
 arch/x86/mm/numa_emulation.c  |    2 +-
 include/linux/memblock.h      |    4 +---
 kernel/printk.c               |    2 +-
 mm/memblock.c                 |   21 ++++++++++-----------
 mm/nobootmem.c                |    2 +-
 mm/page_alloc.c               |    4 ++--
 15 files changed, 31 insertions(+), 34 deletions(-)

diff --git a/arch/x86/kernel/aperture_64.c b/arch/x86/kernel/aperture_64.c
index 3d2661c..5636308 100644
--- a/arch/x86/kernel/aperture_64.c
+++ b/arch/x86/kernel/aperture_64.c
@@ -88,7 +88,7 @@ static u32 __init allocate_aperture(void)
 	 */
 	addr = memblock_find_in_range(GART_MIN_ADDR, GART_MAX_ADDR,
 				      aper_size, aper_size);
-	if (addr == MEMBLOCK_ERROR || addr + aper_size > GART_MAX_ADDR) {
+	if (!addr || addr + aper_size > GART_MAX_ADDR) {
 		printk(KERN_ERR
 			"Cannot allocate aperture memory hole (%lx,%uK)\n",
 				addr, aper_size>>10);
diff --git a/arch/x86/kernel/check.c b/arch/x86/kernel/check.c
index 452932d..95680fc 100644
--- a/arch/x86/kernel/check.c
+++ b/arch/x86/kernel/check.c
@@ -86,7 +86,7 @@ void __init setup_bios_corruption_check(void)
 		u64 size;
 		addr = memblock_x86_find_in_range_size(addr, &size, PAGE_SIZE);
 
-		if (addr == MEMBLOCK_ERROR)
+		if (!addr)
 			break;
 
 		if (addr >= corruption_check_size)
diff --git a/arch/x86/kernel/e820.c b/arch/x86/kernel/e820.c
index 3e2ef84..0f9ff58 100644
--- a/arch/x86/kernel/e820.c
+++ b/arch/x86/kernel/e820.c
@@ -745,7 +745,7 @@ u64 __init early_reserve_e820(u64 startt, u64 sizet, u64 align)
 
 	for (start = startt; ; start += size) {
 		start = memblock_x86_find_in_range_size(start, &size, align);
-		if (start == MEMBLOCK_ERROR)
+		if (!start)
 			return 0;
 		if (size >= sizet)
 			break;
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index afaf384..31ffe20 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -331,7 +331,7 @@ static void __init relocate_initrd(void)
 	ramdisk_here = memblock_find_in_range(0, end_of_lowmem, area_size,
 					 PAGE_SIZE);
 
-	if (ramdisk_here == MEMBLOCK_ERROR)
+	if (!ramdisk_here)
 		panic("Cannot find place for new RAMDISK of size %lld\n",
 			 ramdisk_size);
 
@@ -554,7 +554,7 @@ static void __init reserve_crashkernel(void)
 		crash_base = memblock_find_in_range(alignment,
 			       CRASH_KERNEL_ADDR_MAX, crash_size, alignment);
 
-		if (crash_base == MEMBLOCK_ERROR) {
+		if (!crash_base) {
 			pr_info("crashkernel reservation failed - No suitable area found.\n");
 			return;
 		}
diff --git a/arch/x86/kernel/trampoline.c b/arch/x86/kernel/trampoline.c
index a91ae77..a1f13dd 100644
--- a/arch/x86/kernel/trampoline.c
+++ b/arch/x86/kernel/trampoline.c
@@ -14,7 +14,7 @@ void __init setup_trampolines(void)
 
 	/* Has to be in very low memory so we can execute real-mode AP code. */
 	mem = memblock_find_in_range(0, 1<<20, size, PAGE_SIZE);
-	if (mem == MEMBLOCK_ERROR)
+	if (!mem)
 		panic("Cannot allocate trampoline\n");
 
 	x86_trampoline_base = __va(mem);
diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
index 3032644..13cf05a 100644
--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -68,7 +68,7 @@ static void __init find_early_table_space(unsigned long end, int use_pse,
 #endif
 
 	base = memblock_find_in_range(start, good_end, tables, PAGE_SIZE);
-	if (base == MEMBLOCK_ERROR)
+	if (!base)
 		panic("Cannot find space for the kernel page tables");
 
 	pgt_buf_start = base >> PAGE_SHIFT;
diff --git a/arch/x86/mm/memblock.c b/arch/x86/mm/memblock.c
index 992da5e..e126117 100644
--- a/arch/x86/mm/memblock.c
+++ b/arch/x86/mm/memblock.c
@@ -66,7 +66,7 @@ u64 __init memblock_x86_find_in_range_size(u64 start, u64 *sizep, u64 align)
 			return addr;
 	}
 
-	return MEMBLOCK_ERROR;
+	return 0;
 }
 
 static __init struct range *find_range_array(int count)
@@ -78,7 +78,7 @@ static __init struct range *find_range_array(int count)
 	end = memblock.current_limit;
 
 	mem = memblock_find_in_range(0, end, size, sizeof(struct range));
-	if (mem == MEMBLOCK_ERROR)
+	if (!mem)
 		panic("can not find more space for range array");
 
 	/*
@@ -274,7 +274,7 @@ u64 __init memblock_x86_find_in_range_node(int nid, u64 start, u64 end, u64 size
 {
 	u64 addr;
 	addr = find_memory_core_early(nid, size, align, start, end);
-	if (addr != MEMBLOCK_ERROR)
+	if (addr)
 		return addr;
 
 	/* Fallback, should already have start end within node range */
diff --git a/arch/x86/mm/numa.c b/arch/x86/mm/numa.c
index fbeaaf4..fa1015d 100644
--- a/arch/x86/mm/numa.c
+++ b/arch/x86/mm/numa.c
@@ -226,10 +226,10 @@ static void __init setup_node_data(int nid, u64 start, u64 end)
 	} else {
 		nd_pa = memblock_x86_find_in_range_node(nid, nd_low, nd_high,
 						nd_size, SMP_CACHE_BYTES);
-		if (nd_pa == MEMBLOCK_ERROR)
+		if (!nd_pa)
 			nd_pa = memblock_find_in_range(nd_low, nd_high,
 						nd_size, SMP_CACHE_BYTES);
-		if (nd_pa == MEMBLOCK_ERROR) {
+		if (!nd_pa) {
 			pr_err("Cannot find %zu bytes in node %d\n",
 			       nd_size, nid);
 			return;
@@ -395,7 +395,7 @@ static int __init numa_alloc_distance(void)
 
 	phys = memblock_find_in_range(0, PFN_PHYS(max_pfn_mapped),
 				      size, PAGE_SIZE);
-	if (phys == MEMBLOCK_ERROR) {
+	if (!phys) {
 		pr_warning("NUMA: Warning: can't allocate distance table!\n");
 		/* don't retry until explicitly reset */
 		numa_distance = (void *)1LU;
diff --git a/arch/x86/mm/numa_32.c b/arch/x86/mm/numa_32.c
index 3adebe7..58878b5 100644
--- a/arch/x86/mm/numa_32.c
+++ b/arch/x86/mm/numa_32.c
@@ -199,7 +199,7 @@ void __init init_alloc_remap(int nid, u64 start, u64 end)
 
 	/* allocate node memory and the lowmem remap area */
 	node_pa = memblock_find_in_range(start, end, size, LARGE_PAGE_BYTES);
-	if (node_pa == MEMBLOCK_ERROR) {
+	if (!node_pa) {
 		pr_warning("remap_alloc: failed to allocate %lu bytes for node %d\n",
 			   size, nid);
 		return;
@@ -209,7 +209,7 @@ void __init init_alloc_remap(int nid, u64 start, u64 end)
 	remap_pa = memblock_find_in_range(min_low_pfn << PAGE_SHIFT,
 					  max_low_pfn << PAGE_SHIFT,
 					  size, LARGE_PAGE_BYTES);
-	if (remap_pa == MEMBLOCK_ERROR) {
+	if (!remap_pa) {
 		pr_warning("remap_alloc: failed to allocate %lu bytes remap area for node %d\n",
 			   size, nid);
 		memblock_x86_free_range(node_pa, node_pa + size);
diff --git a/arch/x86/mm/numa_emulation.c b/arch/x86/mm/numa_emulation.c
index d0ed086..e3d471c 100644
--- a/arch/x86/mm/numa_emulation.c
+++ b/arch/x86/mm/numa_emulation.c
@@ -351,7 +351,7 @@ void __init numa_emulation(struct numa_meminfo *numa_meminfo, int numa_dist_cnt)
 
 		phys = memblock_find_in_range(0, PFN_PHYS(max_pfn_mapped),
 					      phys_size, PAGE_SIZE);
-		if (phys == MEMBLOCK_ERROR) {
+		if (!phys) {
 			pr_warning("NUMA: Warning: can't allocate copy of distance table, disabling emulation\n");
 			goto no_emu;
 		}
diff --git a/include/linux/memblock.h b/include/linux/memblock.h
index 7525e38..d235ec5 100644
--- a/include/linux/memblock.h
+++ b/include/linux/memblock.h
@@ -2,8 +2,6 @@
 #define _LINUX_MEMBLOCK_H
 #ifdef __KERNEL__
 
-#define MEMBLOCK_ERROR	0
-
 #ifdef CONFIG_HAVE_MEMBLOCK
 /*
  * Logical memory blocks.
@@ -164,7 +162,7 @@ static inline unsigned long memblock_region_reserved_end_pfn(const struct memblo
 #else
 static inline phys_addr_t memblock_alloc(phys_addr_t size, phys_addr_t align)
 {
-	return MEMBLOCK_ERROR;
+	return 0;
 }
 
 #endif /* CONFIG_HAVE_MEMBLOCK */
diff --git a/kernel/printk.c b/kernel/printk.c
index 3518539..b1d5a61 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -199,7 +199,7 @@ void __init setup_log_buf(int early)
 		unsigned long mem;
 
 		mem = memblock_alloc(new_log_buf_len, PAGE_SIZE);
-		if (mem == MEMBLOCK_ERROR)
+		if (!mem)
 			return;
 		new_log_buf = __va(mem);
 	} else {
diff --git a/mm/memblock.c b/mm/memblock.c
index 9882a88..1969936 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -74,7 +74,7 @@ static phys_addr_t __init_memblock memblock_find_region(phys_addr_t start, phys_
 
 	/* In case, huge size is requested */
 	if (end < size)
-		return MEMBLOCK_ERROR;
+		return 0;
 
 	base = round_down(end - size, align);
 
@@ -94,7 +94,7 @@ static phys_addr_t __init_memblock memblock_find_region(phys_addr_t start, phys_
 		base = round_down(res_base - size, align);
 	}
 
-	return MEMBLOCK_ERROR;
+	return 0;
 }
 
 static phys_addr_t __init_memblock memblock_find_base(phys_addr_t size,
@@ -126,10 +126,10 @@ static phys_addr_t __init_memblock memblock_find_base(phys_addr_t size,
 		if (bottom >= top)
 			continue;
 		found = memblock_find_region(bottom, top, size, align);
-		if (found != MEMBLOCK_ERROR)
+		if (found)
 			return found;
 	}
-	return MEMBLOCK_ERROR;
+	return 0;
 }
 
 /*
@@ -214,10 +214,10 @@ static int __init_memblock memblock_double_array(struct memblock_type *type)
 	 */
 	if (use_slab) {
 		new_array = kmalloc(new_size, GFP_KERNEL);
-		addr = new_array == NULL ? MEMBLOCK_ERROR : __pa(new_array);
+		addr = new_array ? __pa(new_array) : 0;
 	} else
 		addr = memblock_find_base(new_size, sizeof(phys_addr_t), 0, MEMBLOCK_ALLOC_ACCESSIBLE);
-	if (addr == MEMBLOCK_ERROR) {
+	if (!addr) {
 		pr_err("memblock: Failed to double %s array from %ld to %ld entries !\n",
 		       memblock_type_name(type), type->max, type->max * 2);
 		return -1;
@@ -478,8 +478,7 @@ phys_addr_t __init __memblock_alloc_base(phys_addr_t size, phys_addr_t align, ph
 	size = round_up(size, align);
 
 	found = memblock_find_base(size, align, 0, max_addr);
-	if (found != MEMBLOCK_ERROR &&
-	    !memblock_add_region(&memblock.reserved, found, size))
+	if (found && !memblock_add_region(&memblock.reserved, found, size))
 		return found;
 
 	return 0;
@@ -559,14 +558,14 @@ static phys_addr_t __init memblock_alloc_nid_region(struct memblock_region *mp,
 		this_end = memblock_nid_range(start, end, &this_nid);
 		if (this_nid == nid) {
 			phys_addr_t ret = memblock_find_region(start, this_end, size, align);
-			if (ret != MEMBLOCK_ERROR &&
+			if (ret &&
 			    !memblock_add_region(&memblock.reserved, ret, size))
 				return ret;
 		}
 		start = this_end;
 	}
 
-	return MEMBLOCK_ERROR;
+	return 0;
 }
 
 phys_addr_t __init memblock_alloc_nid(phys_addr_t size, phys_addr_t align, int nid)
@@ -588,7 +587,7 @@ phys_addr_t __init memblock_alloc_nid(phys_addr_t size, phys_addr_t align, int n
 	for (i = 0; i < mem->cnt; i++) {
 		phys_addr_t ret = memblock_alloc_nid_region(&mem->regions[i],
 					       size, align, nid);
-		if (ret != MEMBLOCK_ERROR)
+		if (ret)
 			return ret;
 	}
 
diff --git a/mm/nobootmem.c b/mm/nobootmem.c
index 6e93dc7..5b0eb06 100644
--- a/mm/nobootmem.c
+++ b/mm/nobootmem.c
@@ -43,7 +43,7 @@ static void * __init __alloc_memory_core_early(int nid, u64 size, u64 align,
 
 	addr = find_memory_core_early(nid, size, align, goal, limit);
 
-	if (addr == MEMBLOCK_ERROR)
+	if (!addr)
 		return NULL;
 
 	ptr = phys_to_virt(addr);
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index b6da6ed..c7f0e5b 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -3878,13 +3878,13 @@ u64 __init find_memory_core_early(int nid, u64 size, u64 align,
 
 		addr = memblock_find_in_range(final_start, final_end, size, align);
 
-		if (addr == MEMBLOCK_ERROR)
+		if (!addr)
 			continue;
 
 		return addr;
 	}
 
-	return MEMBLOCK_ERROR;
+	return 0;
 }
 #endif
 
