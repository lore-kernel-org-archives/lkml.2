Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932588Ab0JZC7v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 22:59:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18369 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759009Ab0JZCzI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 22:55:08 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH 22/43] MN10300: Allow some cacheflushes to be avoided if
 cache snooping is available
To: linux-am33-list@redhat.com
From: David Howells <dhowells@redhat.com>
Cc: linux-kernel@vger.kernel.org
Date: Tue, 26 Oct 2010 03:54:59 +0100
Message-ID: <20101026025459.23512.34396.stgit@warthog.procyon.org.uk>
In-Reply-To: <20101026025301.23512.24525.stgit@warthog.procyon.org.uk>
References: <20101026025301.23512.24525.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.15-97-g9680-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The AM34 core is able to do cache snooping, and so can skip some of the cache
flushing.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 arch/mn10300/Kconfig                  |    1 
 arch/mn10300/include/asm/cacheflush.h |   16 ++--
 arch/mn10300/kernel/kprobes.c         |    4 +
 arch/mn10300/kernel/traps.c           |    2 
 arch/mn10300/mm/Kconfig.cache         |   34 ++++++++
 arch/mn10300/mm/Makefile              |    2 
 arch/mn10300/mm/cache-flush-icache.c  |  137 +++++++++++++++++++++++++++++++++
 arch/mn10300/mm/cache-inv-icache.c    |  119 +++++++++++++++++++++++++++++
 arch/mn10300/mm/cache.c               |   90 ----------------------
 9 files changed, 309 insertions(+), 96 deletions(-)
 create mode 100644 arch/mn10300/mm/cache-flush-icache.c
 create mode 100644 arch/mn10300/mm/cache-inv-icache.c


diff --git a/arch/mn10300/Kconfig b/arch/mn10300/Kconfig
index 069e34d..21e2a53 100644
--- a/arch/mn10300/Kconfig
+++ b/arch/mn10300/Kconfig
@@ -18,6 +18,7 @@ config AM33_3
 config AM34_2
 	def_bool n
 	select MN10300_HAS_ATOMIC_OPS_UNIT
+	select MN10300_HAS_CACHE_SNOOP
 
 config MMU
 	def_bool y
diff --git a/arch/mn10300/include/asm/cacheflush.h b/arch/mn10300/include/asm/cacheflush.h
index 748143f..faed902 100644
--- a/arch/mn10300/include/asm/cacheflush.h
+++ b/arch/mn10300/include/asm/cacheflush.h
@@ -131,18 +131,22 @@ extern void mn10300_dcache_flush_inv_range2(unsigned long start, unsigned long s
 /*
  * Physically-indexed cache management
  */
-#ifdef CONFIG_MN10300_CACHE_ENABLED
-
+#if defined(CONFIG_MN10300_CACHE_FLUSH_ICACHE)
+extern void flush_icache_page(struct vm_area_struct *vma, struct page *page);
+extern void flush_icache_range(unsigned long start, unsigned long end);
+#elif defined(CONFIG_MN10300_CACHE_INV_ICACHE)
+static inline void flush_icache_page(struct vm_area_struct *vma,
+				     struct page *page)
+{
+	mn10300_icache_inv_page(page_to_phys(page));
+}
 extern void flush_icache_range(unsigned long start, unsigned long end);
-extern void flush_icache_page(struct vm_area_struct *vma, struct page *pg);
-
 #else
-
 #define flush_icache_range(start, end)		do {} while (0)
 #define flush_icache_page(vma, pg)		do {} while (0)
-
 #endif
 
+
 #define flush_icache_user_range(vma, pg, adr, len) \
 	flush_icache_range(adr, adr + len)
 
diff --git a/arch/mn10300/kernel/kprobes.c b/arch/mn10300/kernel/kprobes.c
index 67e6389..0311a7f 100644
--- a/arch/mn10300/kernel/kprobes.c
+++ b/arch/mn10300/kernel/kprobes.c
@@ -377,8 +377,10 @@ void __kprobes arch_arm_kprobe(struct kprobe *p)
 
 void __kprobes arch_disarm_kprobe(struct kprobe *p)
 {
+#ifndef CONFIG_MN10300_CACHE_SNOOP
 	mn10300_dcache_flush();
 	mn10300_icache_inv();
+#endif
 }
 
 void arch_remove_kprobe(struct kprobe *p)
@@ -390,8 +392,10 @@ void __kprobes disarm_kprobe(struct kprobe *p, struct pt_regs *regs)
 {
 	*p->addr = p->opcode;
 	regs->pc = (unsigned long) p->addr;
+#ifndef CONFIG_MN10300_CACHE_SNOOP
 	mn10300_dcache_flush();
 	mn10300_icache_inv();
+#endif
 }
 
 static inline
diff --git a/arch/mn10300/kernel/traps.c b/arch/mn10300/kernel/traps.c
index a64604b..c7257a1 100644
--- a/arch/mn10300/kernel/traps.c
+++ b/arch/mn10300/kernel/traps.c
@@ -533,8 +533,10 @@ void __init set_intr_stub(enum exception_code code, void *handler)
 	vector[6] = 0xcb;
 	vector[7] = 0xcb;
 
+#ifndef CONFIG_MN10300_CACHE_SNOOP
 	mn10300_dcache_flush_inv();
 	mn10300_icache_inv();
+#endif
 }
 
 /*
diff --git a/arch/mn10300/mm/Kconfig.cache b/arch/mn10300/mm/Kconfig.cache
index 97adc06..653254a 100644
--- a/arch/mn10300/mm/Kconfig.cache
+++ b/arch/mn10300/mm/Kconfig.cache
@@ -22,12 +22,26 @@ choice
 
 config MN10300_CACHE_WBACK
 	bool "Write-Back"
+	help
+	  The dcache operates in delayed write-back mode.  It must be manually
+	  flushed if writes are made that subsequently need to be executed or
+	  to be DMA'd by a device.
 
 config MN10300_CACHE_WTHRU
 	bool "Write-Through"
+	help
+	  The dcache operates in immediate write-through mode.  Writes are
+	  committed to RAM immediately in addition to being stored in the
+	  cache.  This means that the written data is immediately available for
+	  execution or DMA.
+
+	  This is not available for use with an SMP kernel if cache flushing
+	  and invalidation by automatic purge register is not selected.
 
 config MN10300_CACHE_DISABLED
 	bool "Disabled"
+	help
+	  The icache and dcache are disabled.
 
 endchoice
 
@@ -64,3 +78,23 @@ config MN10300_CACHE_FLUSH_BY_TAG
 
 config MN10300_CACHE_FLUSH_BY_REG
 	def_bool y if MN10300_CACHE_MANAGE_BY_REG && MN10300_CACHE_WBACK
+
+
+config MN10300_HAS_CACHE_SNOOP
+	def_bool n
+
+config MN10300_CACHE_SNOOP
+	bool "Use CPU Cache Snooping"
+	depends on MN10300_CACHE_ENABLED && MN10300_HAS_CACHE_SNOOP
+	default y
+
+config MN10300_CACHE_FLUSH_ICACHE
+	def_bool y if MN10300_CACHE_WBACK && !MN10300_CACHE_SNOOP
+	help
+	  Set if we need the dcache flushing before the icache is invalidated.
+
+config MN10300_CACHE_INV_ICACHE
+	def_bool y if MN10300_CACHE_WTHRU && !MN10300_CACHE_SNOOP
+	help
+	  Set if we need the icache to be invalidated, even if the dcache is in
+	  write-through mode and doesn't need flushing.
diff --git a/arch/mn10300/mm/Makefile b/arch/mn10300/mm/Makefile
index 7b99723..56c5af8 100644
--- a/arch/mn10300/mm/Makefile
+++ b/arch/mn10300/mm/Makefile
@@ -3,6 +3,8 @@
 #
 
 cacheflush-y	:= cache.o
+cacheflush-$(CONFIG_MN10300_CACHE_INV_ICACHE) += cache-inv-icache.o
+cacheflush-$(CONFIG_MN10300_CACHE_FLUSH_ICACHE) += cache-flush-icache.o
 cacheflush-$(CONFIG_MN10300_CACHE_INV_BY_TAG) += cache-inv-by-tag.o
 cacheflush-$(CONFIG_MN10300_CACHE_INV_BY_REG) += cache-inv-by-reg.o
 cacheflush-$(CONFIG_MN10300_CACHE_FLUSH_BY_TAG) += cache-flush-by-tag.o
diff --git a/arch/mn10300/mm/cache-flush-icache.c b/arch/mn10300/mm/cache-flush-icache.c
new file mode 100644
index 0000000..0e471e1
--- /dev/null
+++ b/arch/mn10300/mm/cache-flush-icache.c
@@ -0,0 +1,137 @@
+/* Flush dcache and invalidate icache when the dcache is in writeback mode
+ *
+ * Copyright (C) 2010 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+#include <linux/module.h>
+#include <linux/mm.h>
+#include <asm/cacheflush.h>
+/**
+ * flush_icache_page - Flush a page from the dcache and invalidate the icache
+ * @vma: The VMA the page is part of.
+ * @page: The page to be flushed.
+ *
+ * Write a page back from the dcache and invalidate the icache so that we can
+ * run code from it that we've just written into it
+ */
+void flush_icache_page(struct vm_area_struct *vma, struct page *page)
+{
+	unsigned long start = page_to_phys(page);
+
+	mn10300_dcache_flush_page(start);
+	mn10300_icache_inv_page(start);
+}
+EXPORT_SYMBOL(flush_icache_page);
+
+/**
+ * flush_icache_page_range - Flush dcache and invalidate icache for part of a
+ *				single page
+ * @start: The starting virtual address of the page part.
+ * @end: The ending virtual address of the page part.
+ *
+ * Flush the dcache and invalidate the icache for part of a single page, as
+ * determined by the virtual addresses given.  The page must be in the paged
+ * area.
+ */
+static void flush_icache_page_range(unsigned long start, unsigned long end)
+{
+	unsigned long addr, size, off;
+	struct page *page;
+	pgd_t *pgd;
+	pud_t *pud;
+	pmd_t *pmd;
+	pte_t *ppte, pte;
+
+	/* work out how much of the page to flush */
+	off = start & ~PAGE_MASK;
+	size = end - start;
+
+	/* get the physical address the page is mapped to from the page
+	 * tables */
+	pgd = pgd_offset(current->mm, start);
+	if (!pgd || !pgd_val(*pgd))
+		return;
+
+	pud = pud_offset(pgd, start);
+	if (!pud || !pud_val(*pud))
+		return;
+
+	pmd = pmd_offset(pud, start);
+	if (!pmd || !pmd_val(*pmd))
+		return;
+
+	ppte = pte_offset_map(pmd, start);
+	if (!ppte)
+		return;
+	pte = *ppte;
+	pte_unmap(ppte);
+
+	if (pte_none(pte))
+		return;
+
+	page = pte_page(pte);
+	if (!page)
+		return;
+
+	addr = page_to_phys(page);
+
+	/* flush the dcache and invalidate the icache coverage on that
+	 * region */
+	mn10300_dcache_flush_range2(addr + off, size);
+	mn10300_icache_inv_range2(addr + off, size);
+}
+
+/**
+ * flush_icache_range - Globally flush dcache and invalidate icache for region
+ * @start: The starting virtual address of the region.
+ * @end: The ending virtual address of the region.
+ *
+ * This is used by the kernel to globally flush some code it has just written
+ * from the dcache back to RAM and then to globally invalidate the icache over
+ * that region so that that code can be run on all CPUs in the system.
+ */
+void flush_icache_range(unsigned long start, unsigned long end)
+{
+	unsigned long start_page, end_page;
+
+	if (end > 0x80000000UL) {
+		/* addresses above 0xa0000000 do not go through the cache */
+		if (end > 0xa0000000UL) {
+			end = 0xa0000000UL;
+			if (start >= end)
+				return;
+		}
+
+		/* kernel addresses between 0x80000000 and 0x9fffffff do not
+		 * require page tables, so we just map such addresses
+		 * directly */
+		start_page = (start >= 0x80000000UL) ? start : 0x80000000UL;
+		mn10300_dcache_flush_range(start_page, end);
+		mn10300_icache_inv_range(start_page, end);
+		if (start_page == start)
+			return;
+		end = start_page;
+	}
+
+	start_page = start & PAGE_MASK;
+	end_page = end & PAGE_MASK;
+
+	if (start_page == end_page) {
+		/* the first and last bytes are on the same page */
+		flush_icache_page_range(start, end);
+	} else if (start_page + 1 == end_page) {
+		/* split over two virtually contiguous pages */
+		flush_icache_page_range(start, end_page);
+		flush_icache_page_range(end_page, end);
+	} else {
+		/* more than 2 pages; just flush the entire cache */
+		mn10300_dcache_flush();
+		mn10300_icache_inv();
+	}
+}
+EXPORT_SYMBOL(flush_icache_range);
diff --git a/arch/mn10300/mm/cache-inv-icache.c b/arch/mn10300/mm/cache-inv-icache.c
new file mode 100644
index 0000000..4a3f7af
--- /dev/null
+++ b/arch/mn10300/mm/cache-inv-icache.c
@@ -0,0 +1,119 @@
+/* Invalidate icache when dcache doesn't need invalidation as it's in
+ * write-through mode
+ *
+ * Copyright (C) 2010 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+#include <linux/module.h>
+#include <linux/mm.h>
+#include <asm/cacheflush.h>
+
+/**
+ * flush_icache_page_range - Flush dcache and invalidate icache for part of a
+ *				single page
+ * @start: The starting virtual address of the page part.
+ * @end: The ending virtual address of the page part.
+ *
+ * Invalidate the icache for part of a single page, as determined by the
+ * virtual addresses given.  The page must be in the paged area.  The dcache is
+ * not flushed as the cache must be in write-through mode to get here.
+ */
+static void flush_icache_page_range(unsigned long start, unsigned long end)
+{
+	unsigned long addr, size, off;
+	struct page *page;
+	pgd_t *pgd;
+	pud_t *pud;
+	pmd_t *pmd;
+	pte_t *ppte, pte;
+
+	/* work out how much of the page to flush */
+	off = start & ~PAGE_MASK;
+	size = end - start;
+
+	/* get the physical address the page is mapped to from the page
+	 * tables */
+	pgd = pgd_offset(current->mm, start);
+	if (!pgd || !pgd_val(*pgd))
+		return;
+
+	pud = pud_offset(pgd, start);
+	if (!pud || !pud_val(*pud))
+		return;
+
+	pmd = pmd_offset(pud, start);
+	if (!pmd || !pmd_val(*pmd))
+		return;
+
+	ppte = pte_offset_map(pmd, start);
+	if (!ppte)
+		return;
+	pte = *ppte;
+	pte_unmap(ppte);
+
+	if (pte_none(pte))
+		return;
+
+	page = pte_page(pte);
+	if (!page)
+		return;
+
+	addr = page_to_phys(page);
+
+	/* invalidate the icache coverage on that region */
+	mn10300_icache_inv_range2(addr + off, size);
+}
+
+/**
+ * flush_icache_range - Globally flush dcache and invalidate icache for region
+ * @start: The starting virtual address of the region.
+ * @end: The ending virtual address of the region.
+ *
+ * This is used by the kernel to globally flush some code it has just written
+ * from the dcache back to RAM and then to globally invalidate the icache over
+ * that region so that that code can be run on all CPUs in the system.
+ */
+void flush_icache_range(unsigned long start, unsigned long end)
+{
+	unsigned long start_page, end_page;
+
+	if (end > 0x80000000UL) {
+		/* addresses above 0xa0000000 do not go through the cache */
+		if (end > 0xa0000000UL) {
+			end = 0xa0000000UL;
+			if (start >= end)
+				return;
+		}
+
+		/* kernel addresses between 0x80000000 and 0x9fffffff do not
+		 * require page tables, so we just map such addresses
+		 * directly */
+		start_page = (start >= 0x80000000UL) ? start : 0x80000000UL;
+		mn10300_dcache_flush_range(start_page, end);
+		mn10300_icache_inv_range(start_page, end);
+		if (start_page == start)
+			return;
+		end = start_page;
+	}
+
+	start_page = start & PAGE_MASK;
+	end_page = end & PAGE_MASK;
+
+	if (start_page == end_page) {
+		/* the first and last bytes are on the same page */
+		flush_icache_page_range(start, end);
+	} else if (start_page + 1 == end_page) {
+		/* split over two virtually contiguous pages */
+		flush_icache_page_range(start, end_page);
+		flush_icache_page_range(end_page, end);
+	} else {
+		/* more than 2 pages; just flush the entire cache */
+		mn10300_icache_inv();
+	}
+}
+EXPORT_SYMBOL(flush_icache_range);
diff --git a/arch/mn10300/mm/cache.c b/arch/mn10300/mm/cache.c
index 9261217..bc35826 100644
--- a/arch/mn10300/mm/cache.c
+++ b/arch/mn10300/mm/cache.c
@@ -37,96 +37,6 @@ EXPORT_SYMBOL(mn10300_dcache_flush_page);
 #endif
 
 /*
- * write a page back from the dcache and invalidate the icache so that we can
- * run code from it that we've just written into it
- */
-void flush_icache_page(struct vm_area_struct *vma, struct page *page)
-{
-	mn10300_dcache_flush_page(page_to_phys(page));
-	mn10300_icache_inv();
-}
-EXPORT_SYMBOL(flush_icache_page);
-
-/*
- * write some code we've just written back from the dcache and invalidate the
- * icache so that we can run that code
- */
-void flush_icache_range(unsigned long start, unsigned long end)
-{
-#ifdef CONFIG_MN10300_CACHE_WBACK
-	unsigned long addr, size, base, off;
-	struct page *page;
-	pgd_t *pgd;
-	pud_t *pud;
-	pmd_t *pmd;
-	pte_t *ppte, pte;
-
-	if (end > 0x80000000UL) {
-		/* addresses above 0xa0000000 do not go through the cache */
-		if (end > 0xa0000000UL) {
-			end = 0xa0000000UL;
-			if (start >= end)
-				return;
-		}
-
-		/* kernel addresses between 0x80000000 and 0x9fffffff do not
-		 * require page tables, so we just map such addresses directly */
-		base = (start >= 0x80000000UL) ? start : 0x80000000UL;
-		mn10300_dcache_flush_range(base, end);
-		if (base == start)
-			goto invalidate;
-		end = base;
-	}
-
-	for (; start < end; start += size) {
-		/* work out how much of the page to flush */
-		off = start & (PAGE_SIZE - 1);
-
-		size = end - start;
-		if (size > PAGE_SIZE - off)
-			size = PAGE_SIZE - off;
-
-		/* get the physical address the page is mapped to from the page
-		 * tables */
-		pgd = pgd_offset(current->mm, start);
-		if (!pgd || !pgd_val(*pgd))
-			continue;
-
-		pud = pud_offset(pgd, start);
-		if (!pud || !pud_val(*pud))
-			continue;
-
-		pmd = pmd_offset(pud, start);
-		if (!pmd || !pmd_val(*pmd))
-			continue;
-
-		ppte = pte_offset_map(pmd, start);
-		if (!ppte)
-			continue;
-		pte = *ppte;
-		pte_unmap(ppte);
-
-		if (pte_none(pte))
-			continue;
-
-		page = pte_page(pte);
-		if (!page)
-			continue;
-
-		addr = page_to_phys(page);
-
-		/* flush the dcache and invalidate the icache coverage on that
-		 * region */
-		mn10300_dcache_flush_range2(addr + off, size);
-	}
-#endif
-
-invalidate:
-	mn10300_icache_inv();
-}
-EXPORT_SYMBOL(flush_icache_range);
-
-/*
  * allow userspace to flush the instruction cache
  */
 asmlinkage long sys_cacheflush(unsigned long start, unsigned long end)

