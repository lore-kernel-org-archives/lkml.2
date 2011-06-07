Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932173Ab1FGSKP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 14:10:15 -0400
Received: from smtp.citrix.com ([66.165.176.89]:4308 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932157Ab1FGSKO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 14:10:14 -0400
X-IronPort-AV: E=Sophos;i="4.65,333,1304308800"; 
   d="scan'208";a="14472924"
From: <stefano.stabellini@eu.citrix.com>
To: hpa@zytor.com
CC: hpa@linux.intel.com, konrad.wilk@oracle.com, mingo@elte.hu,
        linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
        Stefano.Stabellini@eu.citrix.com, yinghai@kernel.org,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: [PATCH 1/3] x86: calculate precisely the memory needed by init_memory_mapping
Date: Tue, 7 Jun 2011 19:13:27 +0100
Message-ID: <1307470409-7654-1-git-send-email-stefano.stabellini@eu.citrix.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <alpine.DEB.2.00.1106071849290.12963@kaball-desktop>
References: <alpine.DEB.2.00.1106071849290.12963@kaball-desktop>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>

- take into account the size of the initial pagetable;

- remove the extra PMD_SIZE added when use_pse, because the previously
allocated PMDs are always 2M aligned;

- remove the extra page added on x86_32 for the fixmap because is not
needed: the PMD entry is already allocated and contiguous for the whole
range (a PMD page covers 4G of virtual addresses) and the pte entry is
already allocated by early_ioremap_init.

Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Reviewed-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/x86/mm/init.c |   62 ++++++++++++++++++++++++++++++++++++++-------------
 1 files changed, 46 insertions(+), 16 deletions(-)

diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
index 3032644..0cfe8d4 100644
--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -28,22 +28,52 @@ int direct_gbpages
 #endif
 ;
 
-static void __init find_early_table_space(unsigned long end, int use_pse,
-					  int use_gbpages)
+static void __init find_early_table_space(unsigned long start,
+		unsigned long end, int use_pse, int use_gbpages)
 {
-	unsigned long puds, pmds, ptes, tables, start = 0, good_end = end;
+	unsigned long pmds = 0, ptes = 0, tables = 0, good_end = end,
+				  pud_mapped = 0, pmd_mapped = 0, size = end - start;
 	phys_addr_t base;
 
-	puds = (end + PUD_SIZE - 1) >> PUD_SHIFT;
-	tables = roundup(puds * sizeof(pud_t), PAGE_SIZE);
+	pud_mapped = DIV_ROUND_UP(PFN_PHYS(max_pfn_mapped),
+			(PUD_SIZE * PTRS_PER_PUD));
+	pud_mapped *= (PUD_SIZE * PTRS_PER_PUD);
+	pmd_mapped = DIV_ROUND_UP(PFN_PHYS(max_pfn_mapped),
+			(PMD_SIZE * PTRS_PER_PMD));
+	pmd_mapped *= (PMD_SIZE * PTRS_PER_PMD);
+
+	if (start < PFN_PHYS(max_pfn_mapped)) {
+		if (PFN_PHYS(max_pfn_mapped) < end)
+			size -= PFN_PHYS(max_pfn_mapped) - start;
+		else
+			size = 0;
+	}
+
+#ifndef __PAGETABLE_PUD_FOLDED
+	if (end > pud_mapped) {
+		unsigned long puds;
+		if (start < pud_mapped)
+			puds = (end - pud_mapped + PUD_SIZE - 1) >> PUD_SHIFT;
+		else
+			puds = (end - start + PUD_SIZE - 1) >> PUD_SHIFT;
+		tables += roundup(puds * sizeof(pud_t), PAGE_SIZE);
+	}
+#endif
 
 	if (use_gbpages) {
 		unsigned long extra;
 
 		extra = end - ((end>>PUD_SHIFT) << PUD_SHIFT);
 		pmds = (extra + PMD_SIZE - 1) >> PMD_SHIFT;
-	} else
-		pmds = (end + PMD_SIZE - 1) >> PMD_SHIFT;
+	}
+#ifndef __PAGETABLE_PMD_FOLDED
+	else if (end > pmd_mapped) {
+		if (start < pmd_mapped)
+			pmds = (end - pmd_mapped + PMD_SIZE - 1) >> PMD_SHIFT;
+		else
+			pmds = (end - start + PMD_SIZE - 1) >> PMD_SHIFT;
+	}
+#endif
 
 	tables += roundup(pmds * sizeof(pmd_t), PAGE_SIZE);
 
@@ -51,23 +81,20 @@ static void __init find_early_table_space(unsigned long end, int use_pse,
 		unsigned long extra;
 
 		extra = end - ((end>>PMD_SHIFT) << PMD_SHIFT);
-#ifdef CONFIG_X86_32
-		extra += PMD_SIZE;
-#endif
 		ptes = (extra + PAGE_SIZE - 1) >> PAGE_SHIFT;
 	} else
-		ptes = (end + PAGE_SIZE - 1) >> PAGE_SHIFT;
+		ptes = (size + PAGE_SIZE - 1) >> PAGE_SHIFT;
 
 	tables += roundup(ptes * sizeof(pte_t), PAGE_SIZE);
 
-#ifdef CONFIG_X86_32
-	/* for fixmap */
-	tables += roundup(__end_of_fixed_addresses * sizeof(pte_t), PAGE_SIZE);
+	if (!tables)
+		return;
 
+#ifdef CONFIG_X86_32
 	good_end = max_pfn_mapped << PAGE_SHIFT;
 #endif
 
-	base = memblock_find_in_range(start, good_end, tables, PAGE_SIZE);
+	base = memblock_find_in_range(0x00, good_end, tables, PAGE_SIZE);
 	if (base == MEMBLOCK_ERROR)
 		panic("Cannot find space for the kernel page tables");
 
@@ -261,7 +288,7 @@ unsigned long __init_refok init_memory_mapping(unsigned long start,
 	 * nodes are discovered.
 	 */
 	if (!after_bootmem)
-		find_early_table_space(end, use_pse, use_gbpages);
+		find_early_table_space(start, end, use_pse, use_gbpages);
 
 	for (i = 0; i < nr_range; i++)
 		ret = kernel_physical_mapping_init(mr[i].start, mr[i].end,
@@ -275,6 +302,9 @@ unsigned long __init_refok init_memory_mapping(unsigned long start,
 
 	__flush_tlb_all();
 
+	if (pgt_buf_end != pgt_buf_top)
+		printk(KERN_DEBUG "initial kernel pagetable allocation wasted %lx"
+				" pages\n", pgt_buf_top - pgt_buf_end);
 	/*
 	 * Reserve the kernel pagetable pages we used (pgt_buf_start -
 	 * pgt_buf_end) and free the other ones (pgt_buf_end - pgt_buf_top)
-- 
1.7.2.3

