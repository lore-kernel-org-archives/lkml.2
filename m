Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757762Ab0FRDXi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 23:23:38 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:35358 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753055Ab0FRDXg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 23:23:36 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4C1AE680.7090408@jp.fujitsu.com>
Date: Fri, 18 Jun 2010 12:22:40 +0900
From: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: hpa@zytor.com, tglx@linutronix.de, mingo@redhat.com,
       linux-kernel@vger.kernel.org
CC: matthew@wil.cx, macro@linux-mips.org, kamezawa.hiroyu@jp.fujitsu.com,
       eike-kernel@sf-tec.de, jeremy@goop.org, linux-pci@vger.kernel.org
Subject: [PATCH 1/2] x86: ioremap: fix wrong physical address handling
References: <4C1AE64C.6040609@jp.fujitsu.com>
In-Reply-To: <4C1AE64C.6040609@jp.fujitsu.com>
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
--- linux-2.6.34.orig/arch/x86/mm/ioremap.c
+++ linux-2.6.34/arch/x86/mm/ioremap.c
@@ -62,8 +62,8 @@ int ioremap_change_attr(unsigned long va
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
@@ -100,10 +100,8 @@ static void __iomem *__ioremap_caller(re
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
@@ -115,7 +113,7 @@ static void __iomem *__ioremap_caller(re
 	 * Mappings have to be page-aligned
 	 */
 	offset = phys_addr & ~PAGE_MASK;
-	phys_addr &= PAGE_MASK;
+	phys_addr &= PHYSICAL_PAGE_MASK;
 	size = PAGE_ALIGN(last_addr+1) - phys_addr;
 
 	retval = reserve_memtype(phys_addr, (u64)phys_addr + size,
Index: linux-2.6.34/include/linux/vmalloc.h
===================================================================
--- linux-2.6.34.orig/include/linux/vmalloc.h
+++ linux-2.6.34/include/linux/vmalloc.h
@@ -30,7 +30,7 @@ struct vm_struct {
 	unsigned long		flags;
 	struct page		**pages;
 	unsigned int		nr_pages;
-	unsigned long		phys_addr;
+	phys_addr_t		phys_addr;
 	void			*caller;
 };
 
Index: linux-2.6.34/lib/ioremap.c
===================================================================
--- linux-2.6.34.orig/lib/ioremap.c
+++ linux-2.6.34/lib/ioremap.c
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
@@ -31,7 +31,7 @@ static int ioremap_pte_range(pmd_t *pmd,
 }
 
 static inline int ioremap_pmd_range(pud_t *pud, unsigned long addr,
-		unsigned long end, unsigned long phys_addr, pgprot_t prot)
+		unsigned long end, phys_addr_t phys_addr, pgprot_t prot)
 {
 	pmd_t *pmd;
 	unsigned long next;
@@ -49,7 +49,7 @@ static inline int ioremap_pmd_range(pud_
 }
 
 static inline int ioremap_pud_range(pgd_t *pgd, unsigned long addr,
-		unsigned long end, unsigned long phys_addr, pgprot_t prot)
+		unsigned long end, phys_addr_t phys_addr, pgprot_t prot)
 {
 	pud_t *pud;
 	unsigned long next;
@@ -67,7 +67,7 @@ static inline int ioremap_pud_range(pgd_
 }
 
 int ioremap_page_range(unsigned long addr,
-		       unsigned long end, unsigned long phys_addr, pgprot_t prot)
+		       unsigned long end, phys_addr_t phys_addr, pgprot_t prot)
 {
 	pgd_t *pgd;
 	unsigned long start;
Index: linux-2.6.34/include/linux/io.h
===================================================================
--- linux-2.6.34.orig/include/linux/io.h
+++ linux-2.6.34/include/linux/io.h
@@ -29,10 +29,10 @@ void __iowrite64_copy(void __iomem *to, 
 
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
--- linux-2.6.34.orig/mm/vmalloc.c
+++ linux-2.6.34/mm/vmalloc.c
@@ -2403,7 +2403,7 @@ static int s_show(struct seq_file *m, vo
 		seq_printf(m, " pages=%d", v->nr_pages);
 
 	if (v->phys_addr)
-		seq_printf(m, " phys=%lx", v->phys_addr);
+		seq_printf(m, " phys=%llx", (unsigned long long)v->phys_addr);
 
 	if (v->flags & VM_IOREMAP)
 		seq_printf(m, " ioremap");

