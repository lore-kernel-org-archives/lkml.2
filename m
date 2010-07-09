Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752491Ab0GITTO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jul 2010 15:19:14 -0400
Received: from hera.kernel.org ([140.211.167.34]:57758 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750870Ab0GITTM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jul 2010 15:19:12 -0400
Date: Fri, 9 Jul 2010 19:18:41 GMT
From: tip-bot for Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       kaneshige.kenji@jp.fujitsu.com, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, kaneshige.kenji@jp.fujitsu.com, hpa@linux.intel.com
In-Reply-To: <4C1AE680.7090408@jp.fujitsu.com>
References: <4C1AE680.7090408@jp.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mm] x86, ioremap: Fix incorrect physical address handling in PAE mode
Message-ID: <tip-ffa71f33a820d1ab3f2fc5723819ac60fb76080b@git.kernel.org>
Git-Commit-ID: ffa71f33a820d1ab3f2fc5723819ac60fb76080b
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 09 Jul 2010 19:18:42 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ffa71f33a820d1ab3f2fc5723819ac60fb76080b
Gitweb:     http://git.kernel.org/tip/ffa71f33a820d1ab3f2fc5723819ac60fb76080b
Author:     Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
AuthorDate: Fri, 18 Jun 2010 12:22:40 +0900
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Fri, 9 Jul 2010 11:42:03 -0700

x86, ioremap: Fix incorrect physical address handling in PAE mode

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
LKML-Reference: <4C1AE680.7090408@jp.fujitsu.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/mm/ioremap.c   |   12 +++++-------
 include/linux/io.h      |    4 ++--
 include/linux/vmalloc.h |    2 +-
 lib/ioremap.c           |   10 +++++-----
 mm/vmalloc.c            |    2 +-
 5 files changed, 14 insertions(+), 16 deletions(-)

diff --git a/arch/x86/mm/ioremap.c b/arch/x86/mm/ioremap.c
index 12e4d2d..754cb4c 100644
--- a/arch/x86/mm/ioremap.c
+++ b/arch/x86/mm/ioremap.c
@@ -62,8 +62,8 @@ int ioremap_change_attr(unsigned long vaddr, unsigned long size,
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
@@ -100,10 +100,8 @@ static void __iomem *__ioremap_caller(resource_size_t phys_addr,
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
@@ -115,7 +113,7 @@ static void __iomem *__ioremap_caller(resource_size_t phys_addr,
 	 * Mappings have to be page-aligned
 	 */
 	offset = phys_addr & ~PAGE_MASK;
-	phys_addr &= PAGE_MASK;
+	phys_addr &= PHYSICAL_PAGE_MASK;
 	size = PAGE_ALIGN(last_addr+1) - phys_addr;
 
 	retval = reserve_memtype(phys_addr, (u64)phys_addr + size,
diff --git a/include/linux/io.h b/include/linux/io.h
index 6c7f0ba..7fd2d21 100644
--- a/include/linux/io.h
+++ b/include/linux/io.h
@@ -29,10 +29,10 @@ void __iowrite64_copy(void __iomem *to, const void *from, size_t count);
 
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
diff --git a/include/linux/vmalloc.h b/include/linux/vmalloc.h
index 227c2a5..de05e96 100644
--- a/include/linux/vmalloc.h
+++ b/include/linux/vmalloc.h
@@ -30,7 +30,7 @@ struct vm_struct {
 	unsigned long		flags;
 	struct page		**pages;
 	unsigned int		nr_pages;
-	unsigned long		phys_addr;
+	phys_addr_t		phys_addr;
 	void			*caller;
 };
 
diff --git a/lib/ioremap.c b/lib/ioremap.c
index 14c6078..5730ecd 100644
--- a/lib/ioremap.c
+++ b/lib/ioremap.c
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
@@ -31,7 +31,7 @@ static int ioremap_pte_range(pmd_t *pmd, unsigned long addr,
 }
 
 static inline int ioremap_pmd_range(pud_t *pud, unsigned long addr,
-		unsigned long end, unsigned long phys_addr, pgprot_t prot)
+		unsigned long end, phys_addr_t phys_addr, pgprot_t prot)
 {
 	pmd_t *pmd;
 	unsigned long next;
@@ -49,7 +49,7 @@ static inline int ioremap_pmd_range(pud_t *pud, unsigned long addr,
 }
 
 static inline int ioremap_pud_range(pgd_t *pgd, unsigned long addr,
-		unsigned long end, unsigned long phys_addr, pgprot_t prot)
+		unsigned long end, phys_addr_t phys_addr, pgprot_t prot)
 {
 	pud_t *pud;
 	unsigned long next;
@@ -67,7 +67,7 @@ static inline int ioremap_pud_range(pgd_t *pgd, unsigned long addr,
 }
 
 int ioremap_page_range(unsigned long addr,
-		       unsigned long end, unsigned long phys_addr, pgprot_t prot)
+		       unsigned long end, phys_addr_t phys_addr, pgprot_t prot)
 {
 	pgd_t *pgd;
 	unsigned long start;
diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index ae00746..b7e314b 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -2403,7 +2403,7 @@ static int s_show(struct seq_file *m, void *p)
 		seq_printf(m, " pages=%d", v->nr_pages);
 
 	if (v->phys_addr)
-		seq_printf(m, " phys=%lx", v->phys_addr);
+		seq_printf(m, " phys=%llx", (unsigned long long)v->phys_addr);
 
 	if (v->flags & VM_IOREMAP)
 		seq_printf(m, " ioremap");
