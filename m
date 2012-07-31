Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754721Ab2GaOwk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 10:52:40 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:37989 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753959Ab2GaOwh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 10:52:37 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
        jbeulich@suse.com, stefano.stabellini@eu.citrix.com
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 1/6] xen/mmu: use copy_page instead of memcpy.
Date: Tue, 31 Jul 2012 10:43:19 -0400
Message-Id: <1343745804-28028-2-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1343745804-28028-1-git-send-email-konrad.wilk@oracle.com>
References: <1343745804-28028-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After all, this is what it is there for.

Acked-by: Jan Beulich <jbeulich@suse.com>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/x86/xen/mmu.c |   13 ++++++-------
 1 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index 6ba6100..7247e5a 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -1754,14 +1754,14 @@ void __init xen_setup_kernel_pagetable(pgd_t *pgd, unsigned long max_pfn)
 	 * it will be also modified in the __ka space! (But if you just
 	 * modify the PMD table to point to other PTE's or none, then you
 	 * are OK - which is what cleanup_highmap does) */
-	memcpy(level2_ident_pgt, l2, sizeof(pmd_t) * PTRS_PER_PMD);
+	copy_page(level2_ident_pgt, l2);
 	/* Graft it onto L4[511][511] */
-	memcpy(level2_kernel_pgt, l2, sizeof(pmd_t) * PTRS_PER_PMD);
+	copy_page(level2_kernel_pgt, l2);
 
 	/* Get [511][510] and graft that in level2_fixmap_pgt */
 	l3 = m2v(pgd[pgd_index(__START_KERNEL_map + PMD_SIZE)].pgd);
 	l2 = m2v(l3[pud_index(__START_KERNEL_map + PMD_SIZE)].pud);
-	memcpy(level2_fixmap_pgt, l2, sizeof(pmd_t) * PTRS_PER_PMD);
+	copy_page(level2_fixmap_pgt, l2);
 	/* Note that we don't do anything with level1_fixmap_pgt which
 	 * we don't need. */
 
@@ -1821,8 +1821,7 @@ static void __init xen_write_cr3_init(unsigned long cr3)
 	 */
 	swapper_kernel_pmd =
 		extend_brk(sizeof(pmd_t) * PTRS_PER_PMD, PAGE_SIZE);
-	memcpy(swapper_kernel_pmd, initial_kernel_pmd,
-	       sizeof(pmd_t) * PTRS_PER_PMD);
+	copy_page(swapper_kernel_pmd, initial_kernel_pmd);
 	swapper_pg_dir[KERNEL_PGD_BOUNDARY] =
 		__pgd(__pa(swapper_kernel_pmd) | _PAGE_PRESENT);
 	set_page_prot(swapper_kernel_pmd, PAGE_KERNEL_RO);
@@ -1851,11 +1850,11 @@ void __init xen_setup_kernel_pagetable(pgd_t *pgd, unsigned long max_pfn)
 				  512*1024);
 
 	kernel_pmd = m2v(pgd[KERNEL_PGD_BOUNDARY].pgd);
-	memcpy(initial_kernel_pmd, kernel_pmd, sizeof(pmd_t) * PTRS_PER_PMD);
+	copy_page(initial_kernel_pmd, kernel_pmd);
 
 	xen_map_identity_early(initial_kernel_pmd, max_pfn);
 
-	memcpy(initial_page_table, pgd, sizeof(pgd_t) * PTRS_PER_PGD);
+	copy_page(initial_page_table, pgd);
 	initial_page_table[KERNEL_PGD_BOUNDARY] =
 		__pgd(__pa(initial_kernel_pmd) | _PAGE_PRESENT);
 
-- 
1.7.7.6

