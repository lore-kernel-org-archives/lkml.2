Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030254Ab2HPQQe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 12:16:34 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:21473 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757648Ab2HPQNV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 12:13:21 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 03/11] xen/mmu: The xen_setup_kernel_pagetable doesn't need to return anything.
Date: Thu, 16 Aug 2012 12:03:21 -0400
Message-Id: <1345133009-21941-4-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1345133009-21941-1-git-send-email-konrad.wilk@oracle.com>
References: <1345133009-21941-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We don't need to return the new PGD - as we do not use it.

Acked-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/x86/xen/enlighten.c |    5 +----
 arch/x86/xen/mmu.c       |   10 ++--------
 arch/x86/xen/xen-ops.h   |    2 +-
 3 files changed, 4 insertions(+), 13 deletions(-)

diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index e532eb5..993e2a5 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -1305,7 +1305,6 @@ asmlinkage void __init xen_start_kernel(void)
 {
 	struct physdev_set_iopl set_iopl;
 	int rc;
-	pgd_t *pgd;
 
 	if (!xen_start_info)
 		return;
@@ -1397,8 +1396,6 @@ asmlinkage void __init xen_start_kernel(void)
 	acpi_numa = -1;
 #endif
 
-	pgd = (pgd_t *)xen_start_info->pt_base;
-
 	/* Don't do the full vcpu_info placement stuff until we have a
 	   possible map and a non-dummy shared_info. */
 	per_cpu(xen_vcpu, 0) = &HYPERVISOR_shared_info->vcpu_info[0];
@@ -1407,7 +1404,7 @@ asmlinkage void __init xen_start_kernel(void)
 	early_boot_irqs_disabled = true;
 
 	xen_raw_console_write("mapping kernel into physical memory\n");
-	pgd = xen_setup_kernel_pagetable(pgd, xen_start_info->nr_pages);
+	xen_setup_kernel_pagetable((pgd_t *)xen_start_info->pt_base, xen_start_info->nr_pages);
 
 	xen_reserve_internals();
 	/* Allocate and initialize top and mid mfn levels for p2m structure */
diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index 3a73785..4ac21a4 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -1719,8 +1719,7 @@ static void convert_pfn_mfn(void *v)
  * of the physical mapping once some sort of allocator has been set
  * up.
  */
-pgd_t * __init xen_setup_kernel_pagetable(pgd_t *pgd,
-					 unsigned long max_pfn)
+void __init xen_setup_kernel_pagetable(pgd_t *pgd, unsigned long max_pfn)
 {
 	pud_t *l3;
 	pmd_t *l2;
@@ -1781,8 +1780,6 @@ pgd_t * __init xen_setup_kernel_pagetable(pgd_t *pgd,
 
 	memblock_reserve(__pa(xen_start_info->pt_base),
 			 xen_start_info->nr_pt_frames * PAGE_SIZE);
-
-	return pgd;
 }
 #else	/* !CONFIG_X86_64 */
 static RESERVE_BRK_ARRAY(pmd_t, initial_kernel_pmd, PTRS_PER_PMD);
@@ -1825,8 +1822,7 @@ static void __init xen_write_cr3_init(unsigned long cr3)
 	pv_mmu_ops.write_cr3 = &xen_write_cr3;
 }
 
-pgd_t * __init xen_setup_kernel_pagetable(pgd_t *pgd,
-					 unsigned long max_pfn)
+void __init xen_setup_kernel_pagetable(pgd_t *pgd, unsigned long max_pfn)
 {
 	pmd_t *kernel_pmd;
 
@@ -1858,8 +1854,6 @@ pgd_t * __init xen_setup_kernel_pagetable(pgd_t *pgd,
 
 	memblock_reserve(__pa(xen_start_info->pt_base),
 			 xen_start_info->nr_pt_frames * PAGE_SIZE);
-
-	return initial_page_table;
 }
 #endif	/* CONFIG_X86_64 */
 
diff --git a/arch/x86/xen/xen-ops.h b/arch/x86/xen/xen-ops.h
index 202d4c1..2230f57 100644
--- a/arch/x86/xen/xen-ops.h
+++ b/arch/x86/xen/xen-ops.h
@@ -27,7 +27,7 @@ void xen_setup_mfn_list_list(void);
 void xen_setup_shared_info(void);
 void xen_build_mfn_list_list(void);
 void xen_setup_machphys_mapping(void);
-pgd_t *xen_setup_kernel_pagetable(pgd_t *pgd, unsigned long max_pfn);
+void xen_setup_kernel_pagetable(pgd_t *pgd, unsigned long max_pfn);
 void xen_reserve_top(void);
 extern unsigned long xen_max_p2m_pfn;
 
-- 
1.7.7.6

