Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753812Ab0JNAbr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Oct 2010 20:31:47 -0400
Received: from hera.kernel.org ([140.211.167.34]:46173 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752063Ab0JNAbq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Oct 2010 20:31:46 -0400
Date: Thu, 14 Oct 2010 00:31:25 GMT
From: tip-bot for Jeremy Fitzhardinge <jeremy@goop.org>
Cc: linux-kernel@vger.kernel.org, jeremy@goop.org, hpa@zytor.com,
        mingo@redhat.com, yinghai@kernel.org, tglx@linutronix.de,
        hpa@linux.intel.com, jeremy.fitzhardinge@citrix.com
Reply-To: mingo@redhat.com, hpa@zytor.com, jeremy@goop.org,
        linux-kernel@vger.kernel.org, yinghai@kernel.org, tglx@linutronix.de,
        hpa@linux.intel.com, jeremy.fitzhardinge@citrix.com
In-Reply-To: <4CB63A80.8060702@goop.org>
References: <4CB63A80.8060702@goop.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/memblock] xen: Cope with unmapped pages when initializing kernel pagetable
Message-ID: <tip-fef5ba797991f9335bcfc295942b684f9bf613a1@git.kernel.org>
Git-Commit-ID: fef5ba797991f9335bcfc295942b684f9bf613a1
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 14 Oct 2010 00:31:26 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  fef5ba797991f9335bcfc295942b684f9bf613a1
Gitweb:     http://git.kernel.org/tip/fef5ba797991f9335bcfc295942b684f9bf613a1
Author:     Jeremy Fitzhardinge <jeremy@goop.org>
AuthorDate: Wed, 13 Oct 2010 16:02:24 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Wed, 13 Oct 2010 16:07:13 -0700

xen: Cope with unmapped pages when initializing kernel pagetable

Xen requires that all pages containing pagetable entries to be mapped
read-only.  If pages used for the initial pagetable are already mapped
then we can change the mapping to RO.  However, if they are initially
unmapped, we need to make sure that when they are later mapped, they
are also mapped RO.

We do this by knowing that the kernel pagetable memory is pre-allocated
in the range e820_table_start - e820_table_end, so any pfn within this
range should be mapped read-only.  However, the pagetable setup code
early_ioremaps the pages to write their entries, so we must make sure
that mappings created in the early_ioremap fixmap area are mapped RW.
(Those mappings are removed before the pages are presented to Xen
as pagetable pages.)

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
LKML-Reference: <4CB63A80.8060702@goop.org>
Cc: Yinghai Lu <yinghai@kernel.org>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/include/asm/io.h |    1 +
 arch/x86/mm/ioremap.c     |    5 +++++
 arch/x86/xen/mmu.c        |   26 ++++++++++++++++++--------
 3 files changed, 24 insertions(+), 8 deletions(-)

diff --git a/arch/x86/include/asm/io.h b/arch/x86/include/asm/io.h
index 30a3e97..66aee6c 100644
--- a/arch/x86/include/asm/io.h
+++ b/arch/x86/include/asm/io.h
@@ -348,6 +348,7 @@ extern void __iomem *early_memremap(resource_size_t phys_addr,
 				    unsigned long size);
 extern void early_iounmap(void __iomem *addr, unsigned long size);
 extern void fixup_early_ioremap(void);
+extern bool is_early_ioremap_ptep(pte_t *ptep);
 
 #define IO_SPACE_LIMIT 0xffff
 
diff --git a/arch/x86/mm/ioremap.c b/arch/x86/mm/ioremap.c
index 3ba6e06..0369843 100644
--- a/arch/x86/mm/ioremap.c
+++ b/arch/x86/mm/ioremap.c
@@ -362,6 +362,11 @@ static inline pte_t * __init early_ioremap_pte(unsigned long addr)
 	return &bm_pte[pte_index(addr)];
 }
 
+bool __init is_early_ioremap_ptep(pte_t *ptep)
+{
+	return ptep >= &bm_pte[0] && ptep < &bm_pte[PAGE_SIZE/sizeof(pte_t)];
+}
+
 static unsigned long slot_virt[FIX_BTMAPS_SLOTS] __initdata;
 
 void __init early_ioremap_init(void)
diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index 4fe04ac..7d55e9e 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -56,6 +56,7 @@
 #include <asm/e820.h>
 #include <asm/linkage.h>
 #include <asm/page.h>
+#include <asm/init.h>
 
 #include <asm/xen/hypercall.h>
 #include <asm/xen/hypervisor.h>
@@ -360,7 +361,8 @@ void make_lowmem_page_readonly(void *vaddr)
 	unsigned int level;
 
 	pte = lookup_address(address, &level);
-	BUG_ON(pte == NULL);
+	if (pte == NULL)
+		return;		/* vaddr missing */
 
 	ptev = pte_wrprotect(*pte);
 
@@ -375,7 +377,8 @@ void make_lowmem_page_readwrite(void *vaddr)
 	unsigned int level;
 
 	pte = lookup_address(address, &level);
-	BUG_ON(pte == NULL);
+	if (pte == NULL)
+		return;		/* vaddr missing */
 
 	ptev = pte_mkwrite(*pte);
 
@@ -1509,13 +1512,25 @@ static void xen_pgd_free(struct mm_struct *mm, pgd_t *pgd)
 #endif
 }
 
-#ifdef CONFIG_X86_32
 static __init pte_t mask_rw_pte(pte_t *ptep, pte_t pte)
 {
+	unsigned long pfn = pte_pfn(pte);
+
+#ifdef CONFIG_X86_32
 	/* If there's an existing pte, then don't allow _PAGE_RW to be set */
 	if (pte_val_ma(*ptep) & _PAGE_PRESENT)
 		pte = __pte_ma(((pte_val_ma(*ptep) & _PAGE_RW) | ~_PAGE_RW) &
 			       pte_val_ma(pte));
+#endif
+
+	/*
+	 * If the new pfn is within the range of the newly allocated
+	 * kernel pagetable, and it isn't being mapped into an
+	 * early_ioremap fixmap slot, make sure it is RO.
+	 */
+	if (!is_early_ioremap_ptep(ptep) &&
+	    pfn >= e820_table_start && pfn < e820_table_end)
+		pte = pte_wrprotect(pte);
 
 	return pte;
 }
@@ -1528,7 +1543,6 @@ static __init void xen_set_pte_init(pte_t *ptep, pte_t pte)
 
 	xen_set_pte(ptep, pte);
 }
-#endif
 
 static void pin_pagetable_pfn(unsigned cmd, unsigned long pfn)
 {
@@ -1973,11 +1987,7 @@ static const struct pv_mmu_ops xen_mmu_ops __initdata = {
 	.alloc_pmd_clone = paravirt_nop,
 	.release_pmd = xen_release_pmd_init,
 
-#ifdef CONFIG_X86_64
-	.set_pte = xen_set_pte,
-#else
 	.set_pte = xen_set_pte_init,
-#endif
 	.set_pte_at = xen_set_pte_at,
 	.set_pmd = xen_set_pmd_hyper,
 
