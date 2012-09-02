Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756009Ab2IBHtK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2012 03:49:10 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:37778 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755963Ab2IBHrk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2012 03:47:40 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Jacob Shin <jacob.shin@amd.com>,
        Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH -v2 13/13] x86, 64bit: Map first 1M ram early before memblock_x86_fill()
Date: Sun,  2 Sep 2012 00:46:59 -0700
Message-Id: <1346572019-15806-14-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1346572019-15806-1-git-send-email-yinghai@kernel.org>
References: <1346572019-15806-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This one intend to fix bugs:
when efi booting have too many memmap entries, will need to double memblock
memory array or reserved array.

For 64bit, We have low kernel mapping, and high kernel mapping.
high kernel mapping is done early in head_64.S.
low kernel mapping is done in init_memory_mapping.

Now we have max_pfn_mapped actually is for high mapping, so later we
need to get buff for the doubling memblock, but we can not use it.
as __va will return virtual address with low kernel mapping.

The patch will try to map first 1M range, and find early page table space
from BRK.

Also add max_pfn_high_mapped to track high mapped range.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/include/asm/page_types.h |    1 +
 arch/x86/include/asm/pgtable.h    |    1 +
 arch/x86/kernel/head64.c          |    2 +-
 arch/x86/kernel/setup.c           |    2 ++
 arch/x86/mm/init.c                |   37 +++++++++++++++++++++++++++++++++++--
 arch/x86/mm/init_64.c             |    7 ++++++-
 6 files changed, 46 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/page_types.h b/arch/x86/include/asm/page_types.h
index 54c9787..1903736 100644
--- a/arch/x86/include/asm/page_types.h
+++ b/arch/x86/include/asm/page_types.h
@@ -45,6 +45,7 @@ extern int devmem_is_allowed(unsigned long pagenr);
 
 extern unsigned long max_low_pfn_mapped;
 extern unsigned long max_pfn_mapped;
+extern unsigned long max_pfn_high_mapped;
 
 static inline phys_addr_t get_max_mapped(void)
 {
diff --git a/arch/x86/include/asm/pgtable.h b/arch/x86/include/asm/pgtable.h
index ae2cabb..c67a684 100644
--- a/arch/x86/include/asm/pgtable.h
+++ b/arch/x86/include/asm/pgtable.h
@@ -598,6 +598,7 @@ static inline int pgd_none(pgd_t pgd)
 
 extern int direct_gbpages;
 void init_mem_mapping(void);
+void early_init_mem_mapping(void);
 
 /* local pte updates need not use xchg for locking */
 static inline pte_t native_local_ptep_get_and_clear(pte_t *ptep)
diff --git a/arch/x86/kernel/head64.c b/arch/x86/kernel/head64.c
index 037df57..b11bde0 100644
--- a/arch/x86/kernel/head64.c
+++ b/arch/x86/kernel/head64.c
@@ -76,7 +76,7 @@ void __init x86_64_start_kernel(char * real_mode_data)
 	/* Make NULL pointers segfault */
 	zap_identity_mappings();
 
-	max_pfn_mapped = KERNEL_IMAGE_SIZE >> PAGE_SHIFT;
+	max_pfn_high_mapped = KERNEL_IMAGE_SIZE >> PAGE_SHIFT;
 
 	for (i = 0; i < NUM_EXCEPTION_VECTORS; i++) {
 #ifdef CONFIG_EARLY_PRINTK
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 2eb91b7..b942036 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -896,6 +896,8 @@ void __init setup_arch(char **cmdline_p)
 
 	reserve_ibft_region();
 
+	early_init_mem_mapping();
+
 	/*
 	 * Need to conclude brk, before memblock_x86_fill()
 	 *  it could use memblock_find_in_range, could overlap with
diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
index 343d925..c96b731 100644
--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -377,8 +377,6 @@ void __init init_mem_mapping(void)
 {
 	unsigned long tables = 0, good_end, end;
 
-	probe_page_size_mask();
-
 	/*
 	 * Find space for the kernel direct mapping tables.
 	 *
@@ -437,6 +435,41 @@ void __init init_mem_mapping(void)
 	early_memtest(0, max_pfn_mapped << PAGE_SHIFT);
 }
 
+RESERVE_BRK(early_pgt_alloc, 65536);
+
+void  __init early_init_mem_mapping(void)
+{
+	unsigned long tables;
+	phys_addr_t base;
+	unsigned long start = 0, end = ISA_END_ADDRESS;
+
+	probe_page_size_mask();
+
+	if (max_pfn_mapped)
+		return;
+
+	tables = calculate_table_space_size(start, end);
+	base = __pa(extend_brk(tables, PAGE_SIZE));
+
+	pgt_buf_start = base >> PAGE_SHIFT;
+	pgt_buf_end = pgt_buf_start;
+	pgt_buf_top = pgt_buf_start + (tables >> PAGE_SHIFT);
+
+	printk(KERN_DEBUG "kernel direct mapping tables up to %#lx @ [mem %#010lx-%#010lx] prealloc\n",
+		end - 1, pgt_buf_start << PAGE_SHIFT,
+		(pgt_buf_top << PAGE_SHIFT) - 1);
+
+	init_memory_mapping(start, end);
+
+	printk(KERN_DEBUG "kernel direct mapping tables up to %#lx @ [mem %#010lx-%#010lx] final\n",
+		end - 1, pgt_buf_start << PAGE_SHIFT,
+		(pgt_buf_end << PAGE_SHIFT) - 1);
+	/* return not used brk */
+	_brk_end -= (pgt_buf_top - pgt_buf_end) << PAGE_SHIFT;
+
+	pgt_buf_top = 0;
+}
+
 /*
  * devmem_is_allowed() checks to see if /dev/mem access to a certain address
  * is valid. The argument is a physical page number.
diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index ab558eb..832ac89 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -286,6 +286,7 @@ void __init init_extra_mapping_uc(unsigned long phys, unsigned long size)
 	__init_extra_mapping(phys, size, PAGE_KERNEL_LARGE_NOCACHE);
 }
 
+unsigned long max_pfn_high_mapped;
 /*
  * The head.S code sets up the kernel high mapping:
  *
@@ -302,7 +303,8 @@ void __init init_extra_mapping_uc(unsigned long phys, unsigned long size)
 void __init cleanup_highmap(void)
 {
 	unsigned long vaddr = __START_KERNEL_map;
-	unsigned long vaddr_end = __START_KERNEL_map + (max_pfn_mapped << PAGE_SHIFT);
+	unsigned long vaddr_end = __START_KERNEL_map +
+				 (max_pfn_high_mapped << PAGE_SHIFT);
 	unsigned long end = roundup((unsigned long)_brk_end, PMD_SIZE) - 1;
 	pmd_t *pmd = level2_kernel_pgt;
 
@@ -312,6 +314,9 @@ void __init cleanup_highmap(void)
 		if (vaddr < (unsigned long) _text || vaddr > end)
 			set_pmd(pmd, __pmd(0));
 	}
+	max_pfn_high_mapped = __pa(end) >> PAGE_SHIFT;
+
+	pr_info("max_pfn_high_mapped: %lx\n", max_pfn_high_mapped);
 }
 
 static __ref void *alloc_low_page(unsigned long *phys)
-- 
1.7.7

