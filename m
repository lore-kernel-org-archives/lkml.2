Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030257Ab2HPQOT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 12:14:19 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:32116 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757660Ab2HPQNV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 12:13:21 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 06/11] xen/mmu: For 64-bit do not call xen_map_identity_early
Date: Thu, 16 Aug 2012 12:03:24 -0400
Message-Id: <1345133009-21941-7-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1345133009-21941-1-git-send-email-konrad.wilk@oracle.com>
References: <1345133009-21941-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

B/c we do not need it. During the startup the Xen provides
us with all the memory mapped that we need to function.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/x86/xen/mmu.c |   11 +++++------
 1 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index 7247e5a..a59070b 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -84,6 +84,7 @@
  */
 DEFINE_SPINLOCK(xen_reservation_lock);
 
+#ifdef CONFIG_X86_32
 /*
  * Identity map, in addition to plain kernel map.  This needs to be
  * large enough to allocate page table pages to allocate the rest.
@@ -91,7 +92,7 @@ DEFINE_SPINLOCK(xen_reservation_lock);
  */
 #define LEVEL1_IDENT_ENTRIES	(PTRS_PER_PTE * 4)
 static RESERVE_BRK_ARRAY(pte_t, level1_ident_pgt, LEVEL1_IDENT_ENTRIES);
-
+#endif
 #ifdef CONFIG_X86_64
 /* l3 pud for userspace vsyscall mapping */
 static pud_t level3_user_vsyscall[PTRS_PER_PUD] __page_aligned_bss;
@@ -1628,7 +1629,7 @@ static void set_page_prot(void *addr, pgprot_t prot)
 	if (HYPERVISOR_update_va_mapping((unsigned long)addr, pte, 0))
 		BUG();
 }
-
+#ifdef CONFIG_X86_32
 static void __init xen_map_identity_early(pmd_t *pmd, unsigned long max_pfn)
 {
 	unsigned pmdidx, pteidx;
@@ -1679,7 +1680,7 @@ static void __init xen_map_identity_early(pmd_t *pmd, unsigned long max_pfn)
 
 	set_page_prot(pmd, PAGE_KERNEL_RO);
 }
-
+#endif
 void __init xen_setup_machphys_mapping(void)
 {
 	struct xen_machphys_mapping mapping;
@@ -1765,14 +1766,12 @@ void __init xen_setup_kernel_pagetable(pgd_t *pgd, unsigned long max_pfn)
 	/* Note that we don't do anything with level1_fixmap_pgt which
 	 * we don't need. */
 
-	/* Set up identity map */
-	xen_map_identity_early(level2_ident_pgt, max_pfn);
-
 	/* Make pagetable pieces RO */
 	set_page_prot(init_level4_pgt, PAGE_KERNEL_RO);
 	set_page_prot(level3_ident_pgt, PAGE_KERNEL_RO);
 	set_page_prot(level3_kernel_pgt, PAGE_KERNEL_RO);
 	set_page_prot(level3_user_vsyscall, PAGE_KERNEL_RO);
+	set_page_prot(level2_ident_pgt, PAGE_KERNEL_RO);
 	set_page_prot(level2_kernel_pgt, PAGE_KERNEL_RO);
 	set_page_prot(level2_fixmap_pgt, PAGE_KERNEL_RO);
 
-- 
1.7.7.6

