Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758867Ab0FQBas (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 21:30:48 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:38178 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756640Ab0FQBar (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 21:30:47 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4C197A9E.5040509@jp.fujitsu.com>
Date: Thu, 17 Jun 2010 10:30:06 +0900
From: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org
CC: linux-pci@vger.kernel.org, macro@linux-mips.org,
       kamezawa.hiroyu@jp.fujitsu.com, eike-kernel@sf-tec.de
Subject: [PATCH 1/2] x86: ioremap: fix wrong physical address handling
References: <4C197A49.6020400@jp.fujitsu.com>
In-Reply-To: <4C197A49.6020400@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current x86 ioremap() doesn't handle physical address higher than
32-bit properly in X86_32 PAE mode. When physical address higher than
32-bit is passed to ioremap(), higher 32-bits in physical address is
cleared wrongly. Due to this bug, ioremap() can map wrong address to
linear address space.

In my case, 64-bit MMIO region was assigned to a PCI device (ioat
device) on my system. Because of the ioremap()'s bug, wrong physical
address (instead of MMIO region) was mapped to linear address space.
Because of this, loading ioatdma driver caused unexpected behavior
(kernel panic, kernel hangup, ...).

Signed-off-by: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>

---
 arch/x86/mm/ioremap.c   |   12 +++++-------
 include/linux/io.h      |    4 ++--
 include/linux/vmalloc.h |    2 +-
 lib/ioremap.c           |   10 +++++-----
 mm/vmalloc.c            |    2 +-
 5 files changed, 14 insertions(+), 16 deletions(-)

Index: linux-2.6.34/arch/x86/mm/ioremap.c
===================================================================
--- linux-2.6.34.orig/arch/x86/mm/ioremap.c	2010-06-15 04:43:00.978332015 +0900
+++ linux-2.6.34/arch/x86/mm/ioremap.c	2010-06-15 05:32:59.291693007 +0900
@@ -62,8 +62,8 @@
 static void __iomem *__ioremap_caller(resource_size_t phys_addr,
 		unsigned long size, unsigned long prot_val, void *caller)
 {
-	unsigned long pfn, offset, vaddr;
-	resource_size_t last_addr;
+	unsigned long offset, vaddr;
+	resource_size_t pfn, last_pfn, last_addr;
 	const resource_size_t unaligned_phys_addr = phys_addr;
 	const unsigned long unaligned_size = size;
 	struct vm_struct *area;
@@ -100,10 +100,8 @@
 	/*
 	 * Don't allow anybody to remap normal RAM that we're using..
 	 */
-	for (pfn = phys_addr >> PAGE_SHIFT;
-				(pfn << PAGE_SHIFT) < (last_addr & PAGE_MASK);
-				pfn++) {
-
+	last_pfn = last_addr >> PAGE_SHIFT;
+	for (pfn = phys_addr >> PAGE_SHIFT; pfn < last_pfn; pfn++) {
 		int is_ram = page_is_ram(pfn);
 
 		if (is_ram && pfn_valid(pfn) && !PageReserved(pfn_to_page(pfn)))
@@ -115,7 +113,7 @@
 	 * Mappings have to be page-aligned
 	 */
 	offset = phys_addr & ~PAGE_MASK;
-	phys_addr &= PAGE_MASK;
+	phys_addr = (phys_addr >> PAGE_SHIFT) << PAGE_SHIFT;
 	size = PAGE_ALIGN(last_addr+1) - phys_addr;
 
 	retval = reserve_memtype(phys_addr, (u64)phys_addr + size,
Index: linux-2.6.34/include/linux/vmalloc.h
===================================================================
--- linux-2.6.34.orig/include/linux/vmalloc.h	2010-06-15 04:43:00.970258681 +0900
+++ linux-2.6.34/include/linux/vmalloc.h	2010-06-15 05:32:59.323364960 +0900
@@ -30,7 +30,7 @@
 	unsigned long		flags;
 	struct page		**pages;
 	unsigned int		nr_pages;
-	unsigned long		phys_addr;
+	phys_addr_t		phys_addr;
 	void			*caller;
 };
 
Index: linux-2.6.34/lib/ioremap.c
===================================================================
--- linux-2.6.34.orig/lib/ioremap.c	2010-06-15 04:43:00.970258681 +0900
+++ linux-2.6.34/lib/ioremap.c	2010-06-15 05:32:59.352457435 +0900
@@ -13,10 +13,10 @@
 #include <asm/pgtable.h>
 
 static int ioremap_pte_range(pmd_t *pmd, unsigned long addr,
-		unsigned long end, unsigned long phys_addr, pgprot_t prot)
+		unsigned long end, phys_addr_t phys_addr, pgprot_t prot)
 {
 	pte_t *pte;
-	unsigned long pfn;
+	u64 pfn;
 
 	pfn = phys_addr >> PAGE_SHIFT;
 	pte = pte_alloc_kernel(pmd, addr);
@@ -31,7 +31,7 @@
 }
 
 static inline int ioremap_pmd_range(pud_t *pud, unsigned long addr,
-		unsigned long end, unsigned long phys_addr, pgprot_t prot)
+		unsigned long end, phys_addr_t phys_addr, pgprot_t prot)
 {
 	pmd_t *pmd;
 	unsigned long next;
@@ -49,7 +49,7 @@
 }
 
 static inline int ioremap_pud_range(pgd_t *pgd, unsigned long addr,
-		unsigned long end, unsigned long phys_addr, pgprot_t prot)
+		unsigned long end, phys_addr_t phys_addr, pgprot_t prot)
 {
 	pud_t *pud;
 	unsigned long next;
@@ -67,7 +67,7 @@
 }
 
 int ioremap_page_range(unsigned long addr,
-		       unsigned long end, unsigned long phys_addr, pgprot_t prot)
+		       unsigned long end, phys_addr_t phys_addr, pgprot_t prot)
 {
 	pgd_t *pgd;
 	unsigned long start;
Index: linux-2.6.34/include/linux/io.h
===================================================================
--- linux-2.6.34.orig/include/linux/io.h	2010-06-15 04:43:00.971256515 +0900
+++ linux-2.6.34/include/linux/io.h	2010-06-15 05:32:59.377701457 +0900
@@ -29,10 +29,10 @@
 
 #ifdef CONFIG_MMU
 int ioremap_page_range(unsigned long addr, unsigned long end,
-		       unsigned long phys_addr, pgprot_t prot);
+		       phys_addr_t phys_addr, pgprot_t prot);
 #else
 static inline int ioremap_page_range(unsigned long addr, unsigned long end,
-				     unsigned long phys_addr, pgprot_t prot)
+				     phys_addr_t phys_addr, pgprot_t prot)
 {
 	return 0;
 }
Index: linux-2.6.34/mm/vmalloc.c
===================================================================
--- linux-2.6.34.orig/mm/vmalloc.c	2010-06-15 04:43:00.963255188 +0900
+++ linux-2.6.34/mm/vmalloc.c	2010-06-15 05:32:59.404457295 +0900
@@ -2403,7 +2403,7 @@
 		seq_printf(m, " pages=%d", v->nr_pages);
 
 	if (v->phys_addr)
-		seq_printf(m, " phys=%lx", v->phys_addr);
+		seq_printf(m, " phys=%llx", (unsigned long long)v->phys_addr);
 
 	if (v->flags & VM_IOREMAP)
 		seq_printf(m, " ioremap");


