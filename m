Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754005Ab0KXMJs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 07:09:48 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:3712 "EHLO SMTP02.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753933Ab0KXMJq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 07:09:46 -0500
X-IronPort-AV: E=Sophos;i="4.59,247,1288584000"; 
   d="scan'208";a="123919007"
From: Ian Campbell <ian.campbell@citrix.com>
To: linux-kernel@vger.kernel.org
Cc: Ian Campbell <ian.campbell@citrix.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>
Subject: [PATCH] xen: x86/32: perform initial startup on initial_page_table
Date: Wed, 24 Nov 2010 12:09:41 +0000
Message-Id: <1290600581-8392-1-git-send-email-ian.campbell@citrix.com>
X-Mailer: git-send-email 1.5.6.5
X-OriginalArrivalTime: 24 Nov 2010 12:09:45.0400 (UTC) FILETIME=[7BA41380:01CB8BD0]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Only make swapper_pg_dir readonly and pinned when generic x86 architecture code
(which also starts on initial_page_table) switches to it.  This helps ensure
that the generic setup paths work on Xen unmodified. In particular
clone_pgd_range writes directly to the destination pgd entries and is used to
initialise swapper_pg_dir so we need to ensure that it remains writeable until
the last possible moment during bring up.

This is complicated slightly by the need to avoid sharing kernel PMD entries
when running under Xen, therefore the Xen implementation must make a copy of
the kernel PMD (which is otherwise referred to by both intial_page_table and
swapper_pg_dir) before switching to swapper_pg_dir.

Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
Reviewed-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Tested-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: H. Peter Anvin <hpa@linux.intel.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
---
 arch/x86/xen/enlighten.c |    2 -
 arch/x86/xen/mmu.c       |   69 +++++++++++++++++++++++++++++++++++++--------
 2 files changed, 56 insertions(+), 15 deletions(-)

diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index 7250bef..02c710b 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -1200,8 +1200,6 @@ asmlinkage void __init xen_start_kernel(void)
 	/* Allocate and initialize top and mid mfn levels for p2m structure */
 	xen_build_mfn_list_list();
 
-	init_mm.pgd = pgd;
-
 	/* keep using Xen gdt for now; no urgent need to change it */
 
 #ifdef CONFIG_X86_32
diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index 790af90..a1feff9 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -2133,44 +2133,83 @@ __init pgd_t *xen_setup_kernel_pagetable(pgd_t *pgd,
 	return pgd;
 }
 #else	/* !CONFIG_X86_64 */
-static RESERVE_BRK_ARRAY(pmd_t, level2_kernel_pgt, PTRS_PER_PMD);
+static RESERVE_BRK_ARRAY(pmd_t, initial_kernel_pmd, PTRS_PER_PMD);
+static RESERVE_BRK_ARRAY(pmd_t, swapper_kernel_pmd, PTRS_PER_PMD);
+
+static __init void xen_write_cr3_init(unsigned long cr3)
+{
+	unsigned long pfn = PFN_DOWN(__pa(swapper_pg_dir));
+
+	BUG_ON(read_cr3() != __pa(initial_page_table));
+	BUG_ON(cr3 != __pa(swapper_pg_dir));
+
+	/*
+	 * We are switching to swapper_pg_dir for the first time (from
+	 * initial_page_table) and therefore need to mark that page
+	 * read-only and then pin it.
+	 *
+	 * Xen disallows sharing of kernel PMDs for PAE
+	 * guests. Therefore we must copy the kernel PMD from
+	 * initial_page_table into a new kernel PMD to be used in
+	 * swapper_pg_dir.
+	 */
+	swapper_kernel_pmd =
+		extend_brk(sizeof(pmd_t) * PTRS_PER_PMD, PAGE_SIZE);
+	memcpy(swapper_kernel_pmd, initial_kernel_pmd,
+	       sizeof(pmd_t) * PTRS_PER_PMD);
+	swapper_pg_dir[KERNEL_PGD_BOUNDARY] =
+		__pgd(__pa(swapper_kernel_pmd) | _PAGE_PRESENT);
+	set_page_prot(swapper_kernel_pmd, PAGE_KERNEL_RO);
+
+	set_page_prot(swapper_pg_dir, PAGE_KERNEL_RO);
+	xen_write_cr3(cr3);
+	pin_pagetable_pfn(MMUEXT_PIN_L3_TABLE, pfn);
+
+	pin_pagetable_pfn(MMUEXT_UNPIN_TABLE,
+			  PFN_DOWN(__pa(initial_page_table)));
+	set_page_prot(initial_page_table, PAGE_KERNEL);
+	set_page_prot(initial_kernel_pmd, PAGE_KERNEL);
+
+	pv_mmu_ops.write_cr3 = &xen_write_cr3;
+}
 
 __init pgd_t *xen_setup_kernel_pagetable(pgd_t *pgd,
 					 unsigned long max_pfn)
 {
 	pmd_t *kernel_pmd;
 
-	level2_kernel_pgt = extend_brk(sizeof(pmd_t) * PTRS_PER_PMD, PAGE_SIZE);
+	initial_kernel_pmd =
+		extend_brk(sizeof(pmd_t) * PTRS_PER_PMD, PAGE_SIZE);
 
 	max_pfn_mapped = PFN_DOWN(__pa(xen_start_info->pt_base) +
 				  xen_start_info->nr_pt_frames * PAGE_SIZE +
 				  512*1024);
 
 	kernel_pmd = m2v(pgd[KERNEL_PGD_BOUNDARY].pgd);
-	memcpy(level2_kernel_pgt, kernel_pmd, sizeof(pmd_t) * PTRS_PER_PMD);
+	memcpy(initial_kernel_pmd, kernel_pmd, sizeof(pmd_t) * PTRS_PER_PMD);
 
-	xen_map_identity_early(level2_kernel_pgt, max_pfn);
+	xen_map_identity_early(initial_kernel_pmd, max_pfn);
 
-	memcpy(swapper_pg_dir, pgd, sizeof(pgd_t) * PTRS_PER_PGD);
-	set_pgd(&swapper_pg_dir[KERNEL_PGD_BOUNDARY],
-			__pgd(__pa(level2_kernel_pgt) | _PAGE_PRESENT));
+	memcpy(initial_page_table, pgd, sizeof(pgd_t) * PTRS_PER_PGD);
+	initial_page_table[KERNEL_PGD_BOUNDARY] =
+		__pgd(__pa(initial_kernel_pmd) | _PAGE_PRESENT);
 
-	set_page_prot(level2_kernel_pgt, PAGE_KERNEL_RO);
-	set_page_prot(swapper_pg_dir, PAGE_KERNEL_RO);
+	set_page_prot(initial_kernel_pmd, PAGE_KERNEL_RO);
+	set_page_prot(initial_page_table, PAGE_KERNEL_RO);
 	set_page_prot(empty_zero_page, PAGE_KERNEL_RO);
 
 	pin_pagetable_pfn(MMUEXT_UNPIN_TABLE, PFN_DOWN(__pa(pgd)));
 
-	xen_write_cr3(__pa(swapper_pg_dir));
-
-	pin_pagetable_pfn(MMUEXT_PIN_L3_TABLE, PFN_DOWN(__pa(swapper_pg_dir)));
+	pin_pagetable_pfn(MMUEXT_PIN_L3_TABLE,
+			  PFN_DOWN(__pa(initial_page_table)));
+	xen_write_cr3(__pa(initial_page_table));
 
 	memblock_x86_reserve_range(__pa(xen_start_info->pt_base),
 		      __pa(xen_start_info->pt_base +
 			   xen_start_info->nr_pt_frames * PAGE_SIZE),
 		      "XEN PAGETABLES");
 
-	return swapper_pg_dir;
+	return initial_page_table;
 }
 #endif	/* CONFIG_X86_64 */
 
@@ -2304,7 +2343,11 @@ static const struct pv_mmu_ops xen_mmu_ops __initdata = {
 	.write_cr2 = xen_write_cr2,
 
 	.read_cr3 = xen_read_cr3,
+#ifdef CONFIG_X86_32
+	.write_cr3 = xen_write_cr3_init,
+#else
 	.write_cr3 = xen_write_cr3,
+#endif
 
 	.flush_tlb_user = xen_flush_tlb,
 	.flush_tlb_kernel = xen_flush_tlb,
-- 
1.5.6.5

