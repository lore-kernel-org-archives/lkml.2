Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754214Ab1GBMTz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jul 2011 08:19:55 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:55657 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753904Ab1GBMTx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jul 2011 08:19:53 -0400
Date: Sat, 2 Jul 2011 13:19:28 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 00/18] ARM: Add support for the Large Physical
	Address Extensions
Message-ID: <20110702121928.GG21898@n2100.arm.linux.org.uk>
References: <1306273164-18217-1-git-send-email-catalin.marinas@arm.com> <20110701162419.GA3990@1n450.cable.virginmedia.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110701162419.GA3990@1n450.cable.virginmedia.net>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 01, 2011 at 05:24:19PM +0100, Catalin Marinas wrote:
> Hi Russell,
> 
> On Tue, May 24, 2011 at 10:39:06PM +0100, Catalin Marinas wrote:
> > Catalin Marinas (14):
> >   ARM: LPAE: Use long long printk format for displaying the pud

Ok.

> >   ARM: LPAE: Use unsigned long for __phys_to_virt and __virt_to_phys

I don't like this; these macros are supposed to take unsigned long
arguments (the hint is in their non-__ versions and __[vp]a, which
contain the explicit casts.)  I'd much rather have their callers
reduced in number, especially as this is a macro which platform classes
may (and do) define.

There are five places which use __phys_to_virt and one place which uses
__virt_to_phys.

Of the __virt_to_phys, this takes a u32 argument anyway, so that won't
cause any concerns.

Of the __phys_to_virt, the L2 cache handing files can use a void * for
vaddr and use the standard phys_to_virt().  That leaves three in the core
arch code, which can be dealt with by local casting.

> >   ARM: LPAE: Use PMD_(SHIFT|SIZE|MASK) instead of PGDIR_*

This one I think is fine, except the dependency on what we do about the
dma coherent code...  Also, see the patch below which is something I've
been thinking about to avoid the multiple-walking of the page table tree.
However, can we guarantee what the L1 page table in LPAE will contain?

> >   ARM: LPAE: Factor out 2-level page table definitions into separate
> >     files
> >   ARM: LPAE: Add (pte|pmd|pgd|pgprot)val_t type definitions as u32

I'm unconvinced that this is the right solution to add all these val_t
types, especially as u32.  It also creates some nonsense like assigning
pmdval_t values to pgprotval_t, and misses converting some other stuff
too.

> >   ARM: LPAE: Use a mask for physical addresses in page table entries
> [...]
> > Will Deacon (4):
> >   ARM: LPAE: add ISBs around MMU enabling code

I still don't like this one - and I do think there's a solution without
having to resort to isb there.  This also affects the cpu resume code
too.

> >   ARM: LPAE: Use generic dma_addr_t type definition

This is already the case since:
  commit 8547727756a7322b99aa313ce50fe15d8f858872
  Author: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
  Date:   Wed Mar 23 16:43:28 2011 -0700

    remove dma64_addr_t

> Since the core LPAE patches haven't got a proper review yet, would you
> please consider merging some of the LPAE preparation patches during the
> upcoming window? Above is a list that I think it's relatively trivial
> (or we can have an even smaller set of patches, any progress would be
> good).
> 
> Thanks.
> 
> -- 
> Catalin

diff --git a/arch/arm/mm/mmu.c b/arch/arm/mm/mmu.c
index 6e7f67f..1892c3d 100644
--- a/arch/arm/mm/mmu.c
+++ b/arch/arm/mm/mmu.c
@@ -862,6 +862,29 @@ static void __init sanity_check_meminfo(void)
 	meminfo.nr_banks = j;
 }
 
+static inline void pmd_clear_range(pgd_t *pgd, unsigned long addr, unsigned long end)
+{
+	pmd_t *pmd;
+
+	pmd = pmd_offset(pgd, addr);
+	do {
+		addr = pmd_addr_end(addr, end);
+		pmd_clear(pmd);
+	} while (pmd++, addr != end);
+}
+
+static void pgd_clear_range(unsigned long addr, unsigned long end)
+{
+	unsigned long next;
+	pgd_t *pgd;
+
+	pgd = pgd_offset_k(addr);
+	do {
+		next = pgd_addr_end(addr, end);
+		pmd_clear_range(pgd, addr, next);
+	} while (pgd++, addr = next, addr != end);
+}
+
 static inline void prepare_page_table(void)
 {
 	unsigned long addr;
@@ -870,15 +893,15 @@ static inline void prepare_page_table(void)
 	/*
 	 * Clear out all the mappings below the kernel image.
 	 */
-	for (addr = 0; addr < MODULES_VADDR; addr += PGDIR_SIZE)
-		pmd_clear(pmd_off_k(addr));
+	pgd_clear_range(0, MODULES_VADDR);
 
 #ifdef CONFIG_XIP_KERNEL
 	/* The XIP kernel is mapped in the module area -- skip over it */
 	addr = ((unsigned long)_etext + PGDIR_SIZE - 1) & PGDIR_MASK;
+#else
+	addr = MODULES_VADDR;
 #endif
-	for ( ; addr < PAGE_OFFSET; addr += PGDIR_SIZE)
-		pmd_clear(pmd_off_k(addr));
+	pgd_clear_range(addr, PAGE_OFFSET);
 
 	/*
 	 * Find the end of the first block of lowmem.
@@ -891,9 +914,7 @@ static inline void prepare_page_table(void)
 	 * Clear out all the kernel space mappings, except for the first
 	 * memory bank, up to the end of the vmalloc region.
 	 */
-	for (addr = __phys_to_virt(end);
-	     addr < VMALLOC_END; addr += PGDIR_SIZE)
-		pmd_clear(pmd_off_k(addr));
+	pgd_clear_range(__phys_to_virt(end), VMALLOC_END);
 }
 
 /*
