Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753730Ab0JMXCg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Oct 2010 19:02:36 -0400
Received: from claw.goop.org ([74.207.240.146]:41867 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753517Ab0JMXCf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Oct 2010 19:02:35 -0400
Message-ID: <4CB63A80.8060702@goop.org>
Date: Wed, 13 Oct 2010 16:02:24 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc13 Lightning/1.0b3pre Thunderbird/3.1.4
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Yinghai Lu <yinghai@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH 0/4] memblock related fixes for -tip
References: <4CAA4DC1.6000104@kernel.org> <4CB4ABE2.3010300@goop.org> <4CB4CF4D.5020706@kernel.org> <4CB4F11F.4090104@goop.org> <4CB54640.4000003@kernel.org> <4CB5DEE8.2020400@goop.org> <4CB5F86C.9030900@zytor.com> <4CB6107F.4080908@goop.org> <4CB61E95.90702@zytor.com>
In-Reply-To: <4CB61E95.90702@zytor.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 On 10/13/2010 02:03 PM, H. Peter Anvin wrote:
> On 10/13/2010 01:03 PM, Jeremy Fitzhardinge wrote:
>> I'm looking at ways of avoiding the dependency on bottom-up allocation
>> at the moment.  It looks like it's OK if I can assume that the pagetable
>> is being allocated out of pages in the range
>> e820_table_start-e820_table_end (though one hopes those will get renamed
>> to something a bit more meaningful).
>>
>> I should know how its going to turn out later today.
>>
> Thanks, I appreciate it.

This seems to do the trick:

From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Date: Wed, 13 Oct 2010 14:21:55 -0700
Subject: [PATCH] xen: cope with unmapped pages when initializing kernel pagetable

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
 


