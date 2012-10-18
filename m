Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932478Ab2JRUz3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 16:55:29 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:42649 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756463Ab2JRUvN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 16:51:13 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Jacob Shin <jacob.shin@amd.com>,
        Tejun Heo <tj@kernel.org>
Cc: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 11/19] x86, mm, xen: Remove mapping_pagatable_reserve
Date: Thu, 18 Oct 2012 13:50:22 -0700
Message-Id: <1350593430-24470-15-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1350593430-24470-1-git-send-email-yinghai@kernel.org>
References: <1350593430-24470-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

page table area are pre-mapped now, and mark_page_ro is used to make it RO
for xen.

mapping_pagetable_reserve is not used anymore, so remove it.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/include/asm/pgtable_types.h |    1 -
 arch/x86/include/asm/x86_init.h      |   12 ------------
 arch/x86/kernel/x86_init.c           |    4 ----
 arch/x86/mm/init.c                   |    4 ----
 arch/x86/xen/mmu.c                   |   28 ----------------------------
 5 files changed, 0 insertions(+), 49 deletions(-)

diff --git a/arch/x86/include/asm/pgtable_types.h b/arch/x86/include/asm/pgtable_types.h
index ec8a1fc..79738f2 100644
--- a/arch/x86/include/asm/pgtable_types.h
+++ b/arch/x86/include/asm/pgtable_types.h
@@ -301,7 +301,6 @@ int phys_mem_access_prot_allowed(struct file *file, unsigned long pfn,
 /* Install a pte for a particular vaddr in kernel space. */
 void set_pte_vaddr(unsigned long vaddr, pte_t pte);
 
-extern void native_pagetable_reserve(u64 start, u64 end);
 #ifdef CONFIG_X86_32
 extern void native_pagetable_init(void);
 #else
diff --git a/arch/x86/include/asm/x86_init.h b/arch/x86/include/asm/x86_init.h
index 5769349..3b2ce8f 100644
--- a/arch/x86/include/asm/x86_init.h
+++ b/arch/x86/include/asm/x86_init.h
@@ -69,17 +69,6 @@ struct x86_init_oem {
 };
 
 /**
- * struct x86_init_mapping - platform specific initial kernel pagetable setup
- * @pagetable_reserve:	reserve a range of addresses for kernel pagetable usage
- *
- * For more details on the purpose of this hook, look in
- * init_memory_mapping and the commit that added it.
- */
-struct x86_init_mapping {
-	void (*pagetable_reserve)(u64 start, u64 end);
-};
-
-/**
  * struct x86_init_paging - platform specific paging functions
  * @pagetable_init:	platform specific paging initialization call to setup
  *			the kernel pagetables and prepare accessors functions.
@@ -136,7 +125,6 @@ struct x86_init_ops {
 	struct x86_init_mpparse		mpparse;
 	struct x86_init_irqs		irqs;
 	struct x86_init_oem		oem;
-	struct x86_init_mapping		mapping;
 	struct x86_init_paging		paging;
 	struct x86_init_timers		timers;
 	struct x86_init_iommu		iommu;
diff --git a/arch/x86/kernel/x86_init.c b/arch/x86/kernel/x86_init.c
index 7a3d075..50cf83e 100644
--- a/arch/x86/kernel/x86_init.c
+++ b/arch/x86/kernel/x86_init.c
@@ -62,10 +62,6 @@ struct x86_init_ops x86_init __initdata = {
 		.banner			= default_banner,
 	},
 
-	.mapping = {
-		.pagetable_reserve		= native_pagetable_reserve,
-	},
-
 	.paging = {
 		.pagetable_init		= native_pagetable_init,
 	},
diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
index 2257727..dd09d20 100644
--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -112,10 +112,6 @@ static void __init probe_page_size_mask(void)
 		__supported_pte_mask |= _PAGE_GLOBAL;
 	}
 }
-void __init native_pagetable_reserve(u64 start, u64 end)
-{
-	memblock_reserve(start, end - start);
-}
 
 #ifdef CONFIG_X86_32
 #define NR_RANGE_MR 3
diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index 6226c99..efc5260 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -1178,20 +1178,6 @@ static void xen_exit_mmap(struct mm_struct *mm)
 
 static void xen_post_allocator_init(void);
 
-static __init void xen_mapping_pagetable_reserve(u64 start, u64 end)
-{
-	/* reserve the range used */
-	native_pagetable_reserve(start, end);
-
-	/* set as RW the rest */
-	printk(KERN_DEBUG "xen: setting RW the range %llx - %llx\n", end,
-			PFN_PHYS(pgt_buf_top));
-	while (end < PFN_PHYS(pgt_buf_top)) {
-		make_lowmem_page_readwrite(__va(end));
-		end += PAGE_SIZE;
-	}
-}
-
 #ifdef CONFIG_X86_64
 static void __init xen_cleanhighmap(unsigned long vaddr,
 				    unsigned long vaddr_end)
@@ -1484,19 +1470,6 @@ static pte_t __init mask_rw_pte(pte_t *ptep, pte_t pte)
 #else /* CONFIG_X86_64 */
 static pte_t __init mask_rw_pte(pte_t *ptep, pte_t pte)
 {
-	unsigned long pfn = pte_pfn(pte);
-
-	/*
-	 * If the new pfn is within the range of the newly allocated
-	 * kernel pagetable, and it isn't being mapped into an
-	 * early_ioremap fixmap slot as a freshly allocated page, make sure
-	 * it is RO.
-	 */
-	if (((!is_early_ioremap_ptep(ptep) &&
-			pfn >= pgt_buf_start && pfn < pgt_buf_top)) ||
-			(is_early_ioremap_ptep(ptep) && pfn != (pgt_buf_end - 1)))
-		pte = pte_wrprotect(pte);
-
 	return pte;
 }
 #endif /* CONFIG_X86_64 */
@@ -2178,7 +2151,6 @@ static const struct pv_mmu_ops xen_mmu_ops __initconst = {
 
 void __init xen_init_mmu_ops(void)
 {
-	x86_init.mapping.pagetable_reserve = xen_mapping_pagetable_reserve;
 	x86_init.paging.pagetable_init = xen_pagetable_init;
 	pv_mmu_ops = xen_mmu_ops;
 
-- 
1.7.7

