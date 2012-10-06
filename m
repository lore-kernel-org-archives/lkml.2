Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753309Ab2JFHpN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Oct 2012 03:45:13 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:36679 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752895Ab2JFHpI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Oct 2012 03:45:08 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Jacob Shin <jacob.shin@amd.com>,
        Tejun Heo <tj@kernel.org>
Cc: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 1/3] x86: get early page table from BRK
Date: Sat,  6 Oct 2012 00:44:27 -0700
Message-Id: <1349509469-11475-2-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1349509469-11475-1-git-send-email-yinghai@kernel.org>
References: <CAE9FiQV_xVsHN_+6ui_Vgnn6tk8UBOEKL+0XnoEN9VLw3gcOXA@mail.gmail.com>
 <1349509469-11475-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

set pgt_buf early from BRK, and use it to map page table at first.

also use the left at first, then use new extend one.

-v2: extra xen call back for that new range.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/include/asm/init.h    |    4 ++++
 arch/x86/include/asm/pgtable.h |    1 +
 arch/x86/kernel/setup.c        |    2 ++
 arch/x86/mm/init.c             |   25 +++++++++++++++++++++++++
 arch/x86/mm/init_32.c          |    8 ++++++--
 arch/x86/mm/init_64.c          |    8 ++++++--
 6 files changed, 44 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/init.h b/arch/x86/include/asm/init.h
index 4f13998..2f32eea 100644
--- a/arch/x86/include/asm/init.h
+++ b/arch/x86/include/asm/init.h
@@ -16,4 +16,8 @@ extern unsigned long __initdata pgt_buf_start;
 extern unsigned long __meminitdata pgt_buf_end;
 extern unsigned long __meminitdata pgt_buf_top;
 
+extern unsigned long __initdata early_pgt_buf_start;
+extern unsigned long __meminitdata early_pgt_buf_end;
+extern unsigned long __meminitdata early_pgt_buf_top;
+
 #endif /* _ASM_X86_INIT_32_H */
diff --git a/arch/x86/include/asm/pgtable.h b/arch/x86/include/asm/pgtable.h
index 52d40a1..25fa5bb 100644
--- a/arch/x86/include/asm/pgtable.h
+++ b/arch/x86/include/asm/pgtable.h
@@ -599,6 +599,7 @@ static inline int pgd_none(pgd_t pgd)
 
 extern int direct_gbpages;
 void init_mem_mapping(void);
+void early_alloc_pgt_buf(void);
 
 /* local pte updates need not use xchg for locking */
 static inline pte_t native_local_ptep_get_and_clear(pte_t *ptep)
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 4989f80..7eb6855 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -896,6 +896,8 @@ void __init setup_arch(char **cmdline_p)
 
 	reserve_ibft_region();
 
+	early_alloc_pgt_buf();
+
 	/*
 	 * Need to conclude brk, before memblock_x86_fill()
 	 *  it could use memblock_find_in_range, could overlap with
diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
index cf662ba..c32eed1 100644
--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -21,6 +21,10 @@ unsigned long __initdata pgt_buf_start;
 unsigned long __meminitdata pgt_buf_end;
 unsigned long __meminitdata pgt_buf_top;
 
+unsigned long __initdata early_pgt_buf_start;
+unsigned long __meminitdata early_pgt_buf_end;
+unsigned long __meminitdata early_pgt_buf_top;
+
 int after_bootmem;
 
 int direct_gbpages
@@ -291,6 +295,11 @@ static void __init find_early_table_space(unsigned long start,
 	if (!base)
 		panic("Cannot find space for the kernel page tables");
 
+	init_memory_mapping(base, base + tables);
+	printk(KERN_DEBUG "kernel direct mapping tables from %#llx to %#llx @ [mem %#010lx-%#010lx]\n",
+		base, base + tables - 1, early_pgt_buf_start << PAGE_SHIFT,
+		(early_pgt_buf_end << PAGE_SHIFT) - 1);
+
 	pgt_buf_start = base >> PAGE_SHIFT;
 	pgt_buf_end = pgt_buf_start;
 	pgt_buf_top = pgt_buf_start + (tables >> PAGE_SHIFT);
@@ -430,6 +439,8 @@ void __init init_mem_mapping(void)
 		x86_init.mapping.pagetable_reserve(PFN_PHYS(pgt_buf_start),
 				PFN_PHYS(pgt_buf_end));
 	}
+	x86_init.mapping.pagetable_reserve(PFN_PHYS(early_pgt_buf_start),
+					PFN_PHYS(early_pgt_buf_end));
 
 	/* stop the wrong using */
 	pgt_buf_top = 0;
@@ -437,6 +448,20 @@ void __init init_mem_mapping(void)
 	early_memtest(0, max_pfn_mapped << PAGE_SHIFT);
 }
 
+RESERVE_BRK(early_pgt_alloc, 16384);
+
+void  __init early_alloc_pgt_buf(void)
+{
+	unsigned long tables = 16384;
+	phys_addr_t base;
+
+	base = __pa(extend_brk(tables, PAGE_SIZE));
+
+	early_pgt_buf_start = base >> PAGE_SHIFT;
+	early_pgt_buf_end = early_pgt_buf_start;
+	early_pgt_buf_top = early_pgt_buf_start + (tables >> PAGE_SHIFT);
+}
+
 /*
  * devmem_is_allowed() checks to see if /dev/mem access to a certain address
  * is valid. The argument is a physical page number.
diff --git a/arch/x86/mm/init_32.c b/arch/x86/mm/init_32.c
index 11a5800..92c0f12 100644
--- a/arch/x86/mm/init_32.c
+++ b/arch/x86/mm/init_32.c
@@ -61,10 +61,14 @@ bool __read_mostly __vmalloc_start_set = false;
 
 static __init void *alloc_low_page(void)
 {
-	unsigned long pfn = pgt_buf_end++;
+	unsigned long pfn;
 	void *adr;
 
-	if (pfn >= pgt_buf_top)
+	if (early_pgt_buf_end < early_pgt_buf_top)
+		pfn = early_pgt_buf_end++;
+	else if (pgt_buf_end < pgt_buf_top)
+		pfn = pgt_buf_end++;
+	else
 		panic("alloc_low_page: ran out of memory");
 
 	adr = __va(pfn * PAGE_SIZE);
diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index ab558eb..5375cf0 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -316,7 +316,7 @@ void __init cleanup_highmap(void)
 
 static __ref void *alloc_low_page(unsigned long *phys)
 {
-	unsigned long pfn = pgt_buf_end++;
+	unsigned long pfn;
 	void *adr;
 
 	if (after_bootmem) {
@@ -326,7 +326,11 @@ static __ref void *alloc_low_page(unsigned long *phys)
 		return adr;
 	}
 
-	if (pfn >= pgt_buf_top)
+	if (early_pgt_buf_end < early_pgt_buf_top)
+		pfn = early_pgt_buf_end++;
+	else if (pgt_buf_end < pgt_buf_top)
+		pfn = pgt_buf_end++;
+	else
 		panic("alloc_low_page: ran out of memory");
 
 	adr = early_memremap(pfn * PAGE_SIZE, PAGE_SIZE);
-- 
1.7.7

