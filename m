Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753941Ab0HXAF7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 20:05:59 -0400
Received: from smtp-outbound-1.vmware.com ([65.115.85.69]:23068 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753461Ab0HXAF5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 20:05:57 -0400
Subject: [PATCH] x86, vmware: Remove alloc_pmd_clone hook.
From: Alok Kataria <akataria@vmware.com>
Reply-To: akataria@vmware.com
To: "H. Peter Anvin" <hpa@zytor.com>,
        the arch/x86 maintainers <x86@kernel.org>
Cc: Jeremy Fitzhardinge <jeremy@xensource.com>,
        Chris Wright <chrisw@sous-sol.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Organization: VMware INC.
Date: Mon, 23 Aug 2010 17:05:57 -0700
Message-Id: <1282608357.19396.36.camel@ank32.eng.vmware.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-8.el5_2.3) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patch on top of tip/x86/vmware

VMI was the only user of the alloc_pmd_clone hook, given that VMI
is now removed we can also remove this hook.

Signed-off-by: Alok N Kataria <akataria@vmware.com>
Cc: Jeremy Fitzhardinge <jeremy@xensource.com>

Index: linux-tip-master/arch/x86/include/asm/paravirt.h
===================================================================
--- linux-tip-master.orig/arch/x86/include/asm/paravirt.h	2010-08-23 11:36:03.000000000 -0700
+++ linux-tip-master/arch/x86/include/asm/paravirt.h	2010-08-23 16:34:26.000000000 -0700
@@ -416,11 +416,6 @@ static inline void paravirt_alloc_pmd(st
 	PVOP_VCALL2(pv_mmu_ops.alloc_pmd, mm, pfn);
 }
 
-static inline void paravirt_alloc_pmd_clone(unsigned long pfn, unsigned long clonepfn,
-					    unsigned long start, unsigned long count)
-{
-	PVOP_VCALL4(pv_mmu_ops.alloc_pmd_clone, pfn, clonepfn, start, count);
-}
 static inline void paravirt_release_pmd(unsigned long pfn)
 {
 	PVOP_VCALL1(pv_mmu_ops.release_pmd, pfn);
Index: linux-tip-master/arch/x86/include/asm/paravirt_types.h
===================================================================
--- linux-tip-master.orig/arch/x86/include/asm/paravirt_types.h	2010-08-23 11:36:03.000000000 -0700
+++ linux-tip-master/arch/x86/include/asm/paravirt_types.h	2010-08-23 16:34:39.000000000 -0700
@@ -255,7 +255,6 @@ struct pv_mmu_ops {
 	 */
 	void (*alloc_pte)(struct mm_struct *mm, unsigned long pfn);
 	void (*alloc_pmd)(struct mm_struct *mm, unsigned long pfn);
-	void (*alloc_pmd_clone)(unsigned long pfn, unsigned long clonepfn, unsigned long start, unsigned long count);
 	void (*alloc_pud)(struct mm_struct *mm, unsigned long pfn);
 	void (*release_pte)(unsigned long pfn);
 	void (*release_pmd)(unsigned long pfn);
Index: linux-tip-master/arch/x86/kernel/paravirt.c
===================================================================
--- linux-tip-master.orig/arch/x86/kernel/paravirt.c	2010-08-23 11:36:03.000000000 -0700
+++ linux-tip-master/arch/x86/kernel/paravirt.c	2010-08-23 16:34:45.000000000 -0700
@@ -413,7 +413,6 @@ struct pv_mmu_ops pv_mmu_ops = {
 
 	.alloc_pte = paravirt_nop,
 	.alloc_pmd = paravirt_nop,
-	.alloc_pmd_clone = paravirt_nop,
 	.alloc_pud = paravirt_nop,
 	.release_pte = paravirt_nop,
 	.release_pmd = paravirt_nop,
Index: linux-tip-master/arch/x86/xen/mmu.c
===================================================================
--- linux-tip-master.orig/arch/x86/xen/mmu.c	2010-08-23 16:29:20.000000000 -0700
+++ linux-tip-master/arch/x86/xen/mmu.c	2010-08-23 16:35:16.000000000 -0700
@@ -1969,7 +1969,6 @@ static const struct pv_mmu_ops xen_mmu_o
 	.alloc_pte = xen_alloc_pte_init,
 	.release_pte = xen_release_pte_init,
 	.alloc_pmd = xen_alloc_pmd_init,
-	.alloc_pmd_clone = paravirt_nop,
 	.release_pmd = xen_release_pmd_init,
 
 #ifdef CONFIG_X86_64
Index: linux-tip-master/arch/x86/mm/pgtable.c
===================================================================
--- linux-tip-master.orig/arch/x86/mm/pgtable.c	2010-08-23 11:36:03.000000000 -0700
+++ linux-tip-master/arch/x86/mm/pgtable.c	2010-08-23 16:38:48.000000000 -0700
@@ -98,10 +98,6 @@ static void pgd_ctor(pgd_t *pgd)
 		clone_pgd_range(pgd + KERNEL_PGD_BOUNDARY,
 				swapper_pg_dir + KERNEL_PGD_BOUNDARY,
 				KERNEL_PGD_PTRS);
-		paravirt_alloc_pmd_clone(__pa(pgd) >> PAGE_SHIFT,
-					 __pa(swapper_pg_dir) >> PAGE_SHIFT,
-					 KERNEL_PGD_BOUNDARY,
-					 KERNEL_PGD_PTRS);
 	}
 
 	/* list required to sync kernel mapping updates */


