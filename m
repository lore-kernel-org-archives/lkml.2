Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756003Ab0KXRk6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 12:40:58 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:60902 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751869Ab0KXRk4 (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Wed, 24 Nov 2010 12:40:56 -0500
Date: Wed, 24 Nov 2010 12:39:48 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: weiyi.huang@gmail.com, ian.campbell@citrix.com, bp@alien8.de,
        pa@linux.intel.com, jeremy@goop.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] 2.6.37-rc3 regression and a bug-fix for Xen subsystem.
Message-ID: <20101124173948.GA13253@dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Linus,

Please pull the following git tree:

git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen.git for-linus

which has changes since git commit e53beacd23d9cb47590da6a7a7f6d417b941a994:

 Linus Torvalds (1):
    Linux 2.6.37-rc2

The tree has two patches: one of them is innocuous removal of
a #include, while the other fixes a regression. Right after the merge window
opened for 2.6.37, 32-bit PAE Xen PV guests were not able to boot. Ian Campbell
came up with a nice fix that had been posted way back in October but we
completely forgot about the fix until about a week ago.

Huang Weiyi (1):
      xen: remove duplicated #include

Ian Campbell (1):
      xen: x86/32: perform initial startup on initial_page_table

 arch/x86/xen/enlighten.c |    2 -
 arch/x86/xen/mmu.c       |   69 +++++++++++++++++++++++++++++++++++++--------
 arch/x86/xen/setup.c     |    1 -
 3 files changed, 56 insertions(+), 16 deletions(-)

And the two patchs together:

diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index 235c0f4..ff82909 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -1191,8 +1191,6 @@ asmlinkage void __init xen_start_kernel(void)
 	/* Allocate and initialize top and mid mfn levels for p2m structure */
 	xen_build_mfn_list_list();
 
-	init_mm.pgd = pgd;
-
 	/* keep using Xen gdt for now; no urgent need to change it */
 
 #ifdef CONFIG_X86_32
diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index 21ed8d7..c9cf23e 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -2119,44 +2119,83 @@ __init pgd_t *xen_setup_kernel_pagetable(pgd_t *pgd,
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
 
@@ -2290,7 +2329,11 @@ static const struct pv_mmu_ops xen_mmu_ops __initdata = {
 	.write_cr2 = xen_write_cr2,
 
 	.read_cr3 = xen_read_cr3,
+#ifdef CONFIG_X86_32
+	.write_cr3 = xen_write_cr3_init,
+#else
 	.write_cr3 = xen_write_cr3,
+#endif
 
 	.flush_tlb_user = xen_flush_tlb,
 	.flush_tlb_kernel = xen_flush_tlb,
diff --git a/arch/x86/xen/setup.c b/arch/x86/xen/setup.c
index 769c4b0..d392486 100644
--- a/arch/x86/xen/setup.c
+++ b/arch/x86/xen/setup.c
@@ -23,7 +23,6 @@
 #include <xen/interface/callback.h>
 #include <xen/interface/memory.h>
 #include <xen/interface/physdev.h>
-#include <xen/interface/memory.h>
 #include <xen/features.h>
 
 #include "xen-ops.h"
