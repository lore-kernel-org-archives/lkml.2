Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757650Ab1FGSKq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 14:10:46 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:42924 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753238Ab1FGSKp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 14:10:45 -0400
X-IronPort-AV: E=Sophos;i="4.65,333,1304308800"; 
   d="scan'208";a="150606842"
From: <stefano.stabellini@eu.citrix.com>
To: hpa@zytor.com
CC: hpa@linux.intel.com, konrad.wilk@oracle.com, mingo@elte.hu,
        linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
        Stefano.Stabellini@eu.citrix.com, yinghai@kernel.org,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: [PATCH 2/3] Revert "x86,xen: introduce x86_init.mapping.pagetable_reserve"
Date: Tue, 7 Jun 2011 19:13:28 +0100
Message-ID: <1307470409-7654-2-git-send-email-stefano.stabellini@eu.citrix.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <alpine.DEB.2.00.1106071849290.12963@kaball-desktop>
References: <alpine.DEB.2.00.1106071849290.12963@kaball-desktop>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>

This reverts commit 279b706bf800b5967037f492dbe4fc5081ad5d0f.

Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Acked-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/x86/include/asm/pgtable_types.h |    1 -
 arch/x86/include/asm/x86_init.h      |   12 ------------
 arch/x86/kernel/x86_init.c           |    4 ----
 arch/x86/mm/init.c                   |   25 +++----------------------
 arch/x86/xen/mmu.c                   |   15 ---------------
 5 files changed, 3 insertions(+), 54 deletions(-)

diff --git a/arch/x86/include/asm/pgtable_types.h b/arch/x86/include/asm/pgtable_types.h
index d56187c..7db7723 100644
--- a/arch/x86/include/asm/pgtable_types.h
+++ b/arch/x86/include/asm/pgtable_types.h
@@ -299,7 +299,6 @@ int phys_mem_access_prot_allowed(struct file *file, unsigned long pfn,
 /* Install a pte for a particular vaddr in kernel space. */
 void set_pte_vaddr(unsigned long vaddr, pte_t pte);
 
-extern void native_pagetable_reserve(u64 start, u64 end);
 #ifdef CONFIG_X86_32
 extern void native_pagetable_setup_start(pgd_t *base);
 extern void native_pagetable_setup_done(pgd_t *base);
diff --git a/arch/x86/include/asm/x86_init.h b/arch/x86/include/asm/x86_init.h
index d3d8590..643ebf2 100644
--- a/arch/x86/include/asm/x86_init.h
+++ b/arch/x86/include/asm/x86_init.h
@@ -68,17 +68,6 @@ struct x86_init_oem {
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
  * @pagetable_setup_start:	platform specific pre paging_init() call
  * @pagetable_setup_done:	platform specific post paging_init() call
@@ -134,7 +123,6 @@ struct x86_init_ops {
 	struct x86_init_mpparse		mpparse;
 	struct x86_init_irqs		irqs;
 	struct x86_init_oem		oem;
-	struct x86_init_mapping		mapping;
 	struct x86_init_paging		paging;
 	struct x86_init_timers		timers;
 	struct x86_init_iommu		iommu;
diff --git a/arch/x86/kernel/x86_init.c b/arch/x86/kernel/x86_init.c
index 6f164bd..6eee082 100644
--- a/arch/x86/kernel/x86_init.c
+++ b/arch/x86/kernel/x86_init.c
@@ -61,10 +61,6 @@ struct x86_init_ops x86_init __initdata = {
 		.banner			= default_banner,
 	},
 
-	.mapping = {
-		.pagetable_reserve		= native_pagetable_reserve,
-	},
-
 	.paging = {
 		.pagetable_setup_start	= native_pagetable_setup_start,
 		.pagetable_setup_done	= native_pagetable_setup_done,
diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
index 0cfe8d4..15590fd 100644
--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -106,11 +106,6 @@ static void __init find_early_table_space(unsigned long start,
 		end, pgt_buf_start << PAGE_SHIFT, pgt_buf_top << PAGE_SHIFT);
 }
 
-void __init native_pagetable_reserve(u64 start, u64 end)
-{
-	memblock_x86_reserve_range(start, end, "PGTABLE");
-}
-
 struct map_range {
 	unsigned long start;
 	unsigned long end;
@@ -305,24 +300,10 @@ unsigned long __init_refok init_memory_mapping(unsigned long start,
 	if (pgt_buf_end != pgt_buf_top)
 		printk(KERN_DEBUG "initial kernel pagetable allocation wasted %lx"
 				" pages\n", pgt_buf_top - pgt_buf_end);
-	/*
-	 * Reserve the kernel pagetable pages we used (pgt_buf_start -
-	 * pgt_buf_end) and free the other ones (pgt_buf_end - pgt_buf_top)
-	 * so that they can be reused for other purposes.
-	 *
-	 * On native it just means calling memblock_x86_reserve_range, on Xen it
-	 * also means marking RW the pagetable pages that we allocated before
-	 * but that haven't been used.
-	 *
-	 * In fact on xen we mark RO the whole range pgt_buf_start -
-	 * pgt_buf_top, because we have to make sure that when
-	 * init_memory_mapping reaches the pagetable pages area, it maps
-	 * RO all the pagetable pages, including the ones that are beyond
-	 * pgt_buf_end at that time.
-	 */
+
 	if (!after_bootmem && pgt_buf_end > pgt_buf_start)
-		x86_init.mapping.pagetable_reserve(PFN_PHYS(pgt_buf_start),
-				PFN_PHYS(pgt_buf_end));
+		memblock_x86_reserve_range(pgt_buf_start << PAGE_SHIFT,
+				 pgt_buf_end << PAGE_SHIFT, "PGTABLE");
 
 	if (!after_bootmem)
 		early_memtest(start, end);
diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index dc708dc..2004f1e 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -1153,20 +1153,6 @@ static void __init xen_pagetable_setup_start(pgd_t *base)
 {
 }
 
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
 static void xen_post_allocator_init(void);
 
 static void __init xen_pagetable_setup_done(pgd_t *base)
@@ -1997,7 +1983,6 @@ static const struct pv_mmu_ops xen_mmu_ops __initconst = {
 
 void __init xen_init_mmu_ops(void)
 {
-	x86_init.mapping.pagetable_reserve = xen_mapping_pagetable_reserve;
 	x86_init.paging.pagetable_setup_start = xen_pagetable_setup_start;
 	x86_init.paging.pagetable_setup_done = xen_pagetable_setup_done;
 	pv_mmu_ops = xen_mmu_ops;
-- 
1.7.2.3

