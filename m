Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759275Ab0JZCzT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 22:55:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50144 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752052Ab0JZCzP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 22:55:15 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH 23/43] MN10300: Cache: Implement SMP global cache flushing
To: linux-am33-list@redhat.com
From: David Howells <dhowells@redhat.com>
Cc: linux-kernel@vger.kernel.org,
        Akira Takeuchi <takeuchi.akr@jp.panasonic.com>,
        Kiyoshi Owada <owada.kiyoshi@jp.panasonic.com>
Date: Tue, 26 Oct 2010 03:55:04 +0100
Message-ID: <20101026025504.23512.64839.stgit@warthog.procyon.org.uk>
In-Reply-To: <20101026025301.23512.24525.stgit@warthog.procyon.org.uk>
References: <20101026025301.23512.24525.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.15-97-g9680-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Akira Takeuchi <takeuchi.akr@jp.panasonic.com>

Implement SMP global cache flushing for MN10300.  This will be used by the AM34
which is SMP capable.

Signed-off-by: Akira Takeuchi <takeuchi.akr@jp.panasonic.com>
Signed-off-by: Kiyoshi Owada <owada.kiyoshi@jp.panasonic.com>
Signed-off-by: David Howells <dhowells@redhat.com>
---

 arch/mn10300/mm/Kconfig.cache        |    1 
 arch/mn10300/mm/Makefile             |    3 +
 arch/mn10300/mm/cache-flush-icache.c |   36 ++++++--
 arch/mn10300/mm/cache-inv-icache.c   |   22 +++--
 arch/mn10300/mm/cache-smp-flush.c    |  156 ++++++++++++++++++++++++++++++++++
 arch/mn10300/mm/cache-smp-inv.c      |  153 +++++++++++++++++++++++++++++++++
 arch/mn10300/mm/cache-smp.c          |  105 +++++++++++++++++++++++
 arch/mn10300/mm/cache-smp.h          |   69 +++++++++++++++
 arch/mn10300/mm/cache.c              |    5 +
 9 files changed, 535 insertions(+), 15 deletions(-)
 create mode 100644 arch/mn10300/mm/cache-smp-flush.c
 create mode 100644 arch/mn10300/mm/cache-smp-inv.c
 create mode 100644 arch/mn10300/mm/cache-smp.c
 create mode 100644 arch/mn10300/mm/cache-smp.h


diff --git a/arch/mn10300/mm/Kconfig.cache b/arch/mn10300/mm/Kconfig.cache
index 653254a..c4fd923 100644
--- a/arch/mn10300/mm/Kconfig.cache
+++ b/arch/mn10300/mm/Kconfig.cache
@@ -60,6 +60,7 @@ choice
 
 config MN10300_CACHE_MANAGE_BY_TAG
 	bool "Use the cache tag registers directly"
+	depends on !(SMP && MN10300_CACHE_WTHRU)
 
 config MN10300_CACHE_MANAGE_BY_REG
 	bool "Flush areas by way of automatic purge registers (AM34 only)"
diff --git a/arch/mn10300/mm/Makefile b/arch/mn10300/mm/Makefile
index 56c5af8..184745f 100644
--- a/arch/mn10300/mm/Makefile
+++ b/arch/mn10300/mm/Makefile
@@ -2,7 +2,10 @@
 # Makefile for the MN10300-specific memory management code
 #
 
+cache-smp-wback-$(CONFIG_MN10300_CACHE_WBACK) := cache-smp-flush.o
+
 cacheflush-y	:= cache.o
+cacheflush-$(CONFIG_SMP) += cache-smp.o cache-smp-inv.o $(cache-smp-wback-y)
 cacheflush-$(CONFIG_MN10300_CACHE_INV_ICACHE) += cache-inv-icache.o
 cacheflush-$(CONFIG_MN10300_CACHE_FLUSH_ICACHE) += cache-flush-icache.o
 cacheflush-$(CONFIG_MN10300_CACHE_INV_BY_TAG) += cache-inv-by-tag.o
diff --git a/arch/mn10300/mm/cache-flush-icache.c b/arch/mn10300/mm/cache-flush-icache.c
index 0e471e1..fdb1a9d 100644
--- a/arch/mn10300/mm/cache-flush-icache.c
+++ b/arch/mn10300/mm/cache-flush-icache.c
@@ -11,6 +11,9 @@
 #include <linux/module.h>
 #include <linux/mm.h>
 #include <asm/cacheflush.h>
+#include <asm/smp.h>
+#include "cache-smp.h"
+
 /**
  * flush_icache_page - Flush a page from the dcache and invalidate the icache
  * @vma: The VMA the page is part of.
@@ -22,9 +25,15 @@
 void flush_icache_page(struct vm_area_struct *vma, struct page *page)
 {
 	unsigned long start = page_to_phys(page);
+	unsigned long flags;
+
+	flags = smp_lock_cache();
+
+	mn10300_local_dcache_flush_page(start);
+	mn10300_local_icache_inv_page(start);
 
-	mn10300_dcache_flush_page(start);
-	mn10300_icache_inv_page(start);
+	smp_cache_call(SMP_IDCACHE_INV_FLUSH_RANGE, start, start + PAGE_SIZE);
+	smp_unlock_cache(flags);
 }
 EXPORT_SYMBOL(flush_icache_page);
 
@@ -82,8 +91,9 @@ static void flush_icache_page_range(unsigned long start, unsigned long end)
 
 	/* flush the dcache and invalidate the icache coverage on that
 	 * region */
-	mn10300_dcache_flush_range2(addr + off, size);
-	mn10300_icache_inv_range2(addr + off, size);
+	mn10300_local_dcache_flush_range2(addr + off, size);
+	mn10300_local_icache_inv_range2(addr + off, size);
+	smp_cache_call(SMP_IDCACHE_INV_FLUSH_RANGE, start, end);
 }
 
 /**
@@ -98,28 +108,32 @@ static void flush_icache_page_range(unsigned long start, unsigned long end)
 void flush_icache_range(unsigned long start, unsigned long end)
 {
 	unsigned long start_page, end_page;
+	unsigned long flags;
+
+	flags = smp_lock_cache();
 
 	if (end > 0x80000000UL) {
 		/* addresses above 0xa0000000 do not go through the cache */
 		if (end > 0xa0000000UL) {
 			end = 0xa0000000UL;
 			if (start >= end)
-				return;
+				goto done;
 		}
 
 		/* kernel addresses between 0x80000000 and 0x9fffffff do not
 		 * require page tables, so we just map such addresses
 		 * directly */
 		start_page = (start >= 0x80000000UL) ? start : 0x80000000UL;
-		mn10300_dcache_flush_range(start_page, end);
-		mn10300_icache_inv_range(start_page, end);
+		mn10300_local_dcache_flush_range(start_page, end);
+		mn10300_local_icache_inv_range(start_page, end);
+		smp_cache_call(SMP_IDCACHE_INV_FLUSH_RANGE, start_page, end);
 		if (start_page == start)
-			return;
+			goto done;
 		end = start_page;
 	}
 
 	start_page = start & PAGE_MASK;
-	end_page = end & PAGE_MASK;
+	end_page = (end - 1) & PAGE_MASK;
 
 	if (start_page == end_page) {
 		/* the first and last bytes are on the same page */
@@ -132,6 +146,10 @@ void flush_icache_range(unsigned long start, unsigned long end)
 		/* more than 2 pages; just flush the entire cache */
 		mn10300_dcache_flush();
 		mn10300_icache_inv();
+		smp_cache_call(SMP_IDCACHE_INV_FLUSH, 0, 0);
 	}
+
+done:
+	smp_unlock_cache(flags);
 }
 EXPORT_SYMBOL(flush_icache_range);
diff --git a/arch/mn10300/mm/cache-inv-icache.c b/arch/mn10300/mm/cache-inv-icache.c
index 4a3f7af..a8933a6 100644
--- a/arch/mn10300/mm/cache-inv-icache.c
+++ b/arch/mn10300/mm/cache-inv-icache.c
@@ -12,6 +12,8 @@
 #include <linux/module.h>
 #include <linux/mm.h>
 #include <asm/cacheflush.h>
+#include <asm/smp.h>
+#include "cache-smp.h"
 
 /**
  * flush_icache_page_range - Flush dcache and invalidate icache for part of a
@@ -66,7 +68,8 @@ static void flush_icache_page_range(unsigned long start, unsigned long end)
 	addr = page_to_phys(page);
 
 	/* invalidate the icache coverage on that region */
-	mn10300_icache_inv_range2(addr + off, size);
+	mn10300_local_icache_inv_range2(addr + off, size);
+	smp_cache_call(SMP_ICACHE_INV_FLUSH_RANGE, start, end);
 }
 
 /**
@@ -81,28 +84,31 @@ static void flush_icache_page_range(unsigned long start, unsigned long end)
 void flush_icache_range(unsigned long start, unsigned long end)
 {
 	unsigned long start_page, end_page;
+	unsigned long flags;
+
+	flags = smp_lock_cache();
 
 	if (end > 0x80000000UL) {
 		/* addresses above 0xa0000000 do not go through the cache */
 		if (end > 0xa0000000UL) {
 			end = 0xa0000000UL;
 			if (start >= end)
-				return;
+				goto done;
 		}
 
 		/* kernel addresses between 0x80000000 and 0x9fffffff do not
 		 * require page tables, so we just map such addresses
 		 * directly */
 		start_page = (start >= 0x80000000UL) ? start : 0x80000000UL;
-		mn10300_dcache_flush_range(start_page, end);
 		mn10300_icache_inv_range(start_page, end);
+		smp_cache_call(SMP_ICACHE_INV_FLUSH_RANGE, start, end);
 		if (start_page == start)
-			return;
+			goto done;
 		end = start_page;
 	}
 
 	start_page = start & PAGE_MASK;
-	end_page = end & PAGE_MASK;
+	end_page = (end - 1) & PAGE_MASK;
 
 	if (start_page == end_page) {
 		/* the first and last bytes are on the same page */
@@ -113,7 +119,11 @@ void flush_icache_range(unsigned long start, unsigned long end)
 		flush_icache_page_range(end_page, end);
 	} else {
 		/* more than 2 pages; just flush the entire cache */
-		mn10300_icache_inv();
+		mn10300_local_icache_inv();
+		smp_cache_call(SMP_ICACHE_INV, 0, 0);
 	}
+
+done:
+	smp_unlock_cache(flags);
 }
 EXPORT_SYMBOL(flush_icache_range);
diff --git a/arch/mn10300/mm/cache-smp-flush.c b/arch/mn10300/mm/cache-smp-flush.c
new file mode 100644
index 0000000..fd51af5
--- /dev/null
+++ b/arch/mn10300/mm/cache-smp-flush.c
@@ -0,0 +1,156 @@
+/* Functions for global dcache flush when writeback caching in SMP
+ *
+ * Copyright (C) 2010 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+#include <linux/mm.h>
+#include <asm/cacheflush.h>
+#include "cache-smp.h"
+
+/**
+ * mn10300_dcache_flush - Globally flush data cache
+ *
+ * Flush the data cache on all CPUs.
+ */
+void mn10300_dcache_flush(void)
+{
+	unsigned long flags;
+
+	flags = smp_lock_cache();
+	mn10300_local_dcache_flush();
+	smp_cache_call(SMP_DCACHE_FLUSH, 0, 0);
+	smp_unlock_cache(flags);
+}
+
+/**
+ * mn10300_dcache_flush_page - Globally flush a page of data cache
+ * @start: The address of the page of memory to be flushed.
+ *
+ * Flush a range of addresses in the data cache on all CPUs covering
+ * the page that includes the given address.
+ */
+void mn10300_dcache_flush_page(unsigned long start)
+{
+	unsigned long flags;
+
+	start &= ~(PAGE_SIZE-1);
+
+	flags = smp_lock_cache();
+	mn10300_local_dcache_flush_page(start);
+	smp_cache_call(SMP_DCACHE_FLUSH_RANGE, start, start + PAGE_SIZE);
+	smp_unlock_cache(flags);
+}
+
+/**
+ * mn10300_dcache_flush_range - Globally flush range of data cache
+ * @start: The start address of the region to be flushed.
+ * @end: The end address of the region to be flushed.
+ *
+ * Flush a range of addresses in the data cache on all CPUs, between start and
+ * end-1 inclusive.
+ */
+void mn10300_dcache_flush_range(unsigned long start, unsigned long end)
+{
+	unsigned long flags;
+
+	flags = smp_lock_cache();
+	mn10300_local_dcache_flush_range(start, end);
+	smp_cache_call(SMP_DCACHE_FLUSH_RANGE, start, end);
+	smp_unlock_cache(flags);
+}
+
+/**
+ * mn10300_dcache_flush_range2 - Globally flush range of data cache
+ * @start: The start address of the region to be flushed.
+ * @size: The size of the region to be flushed.
+ *
+ * Flush a range of addresses in the data cache on all CPUs, between start and
+ * start+size-1 inclusive.
+ */
+void mn10300_dcache_flush_range2(unsigned long start, unsigned long size)
+{
+	unsigned long flags;
+
+	flags = smp_lock_cache();
+	mn10300_local_dcache_flush_range2(start, size);
+	smp_cache_call(SMP_DCACHE_FLUSH_RANGE, start, start + size);
+	smp_unlock_cache(flags);
+}
+
+/**
+ * mn10300_dcache_flush_inv - Globally flush and invalidate data cache
+ *
+ * Flush and invalidate the data cache on all CPUs.
+ */
+void mn10300_dcache_flush_inv(void)
+{
+	unsigned long flags;
+
+	flags = smp_lock_cache();
+	mn10300_local_dcache_flush_inv();
+	smp_cache_call(SMP_DCACHE_FLUSH_INV, 0, 0);
+	smp_unlock_cache(flags);
+}
+
+/**
+ * mn10300_dcache_flush_inv_page - Globally flush and invalidate a page of data
+ *	cache
+ * @start: The address of the page of memory to be flushed and invalidated.
+ *
+ * Flush and invalidate a range of addresses in the data cache on all CPUs
+ * covering the page that includes the given address.
+ */
+void mn10300_dcache_flush_inv_page(unsigned long start)
+{
+	unsigned long flags;
+
+	start &= ~(PAGE_SIZE-1);
+
+	flags = smp_lock_cache();
+	mn10300_local_dcache_flush_inv_page(start);
+	smp_cache_call(SMP_DCACHE_FLUSH_INV_RANGE, start, start + PAGE_SIZE);
+	smp_unlock_cache(flags);
+}
+
+/**
+ * mn10300_dcache_flush_inv_range - Globally flush and invalidate range of data
+ *	cache
+ * @start: The start address of the region to be flushed and invalidated.
+ * @end: The end address of the region to be flushed and invalidated.
+ *
+ * Flush and invalidate a range of addresses in the data cache on all CPUs,
+ * between start and end-1 inclusive.
+ */
+void mn10300_dcache_flush_inv_range(unsigned long start, unsigned long end)
+{
+	unsigned long flags;
+
+	flags = smp_lock_cache();
+	mn10300_local_dcache_flush_inv_range(start, end);
+	smp_cache_call(SMP_DCACHE_FLUSH_INV_RANGE, start, end);
+	smp_unlock_cache(flags);
+}
+
+/**
+ * mn10300_dcache_flush_inv_range2 - Globally flush and invalidate range of data
+ *	cache
+ * @start: The start address of the region to be flushed and invalidated.
+ * @size: The size of the region to be flushed and invalidated.
+ *
+ * Flush and invalidate a range of addresses in the data cache on all CPUs,
+ * between start and start+size-1 inclusive.
+ */
+void mn10300_dcache_flush_inv_range2(unsigned long start, unsigned long size)
+{
+	unsigned long flags;
+
+	flags = smp_lock_cache();
+	mn10300_local_dcache_flush_inv_range2(start, size);
+	smp_cache_call(SMP_DCACHE_FLUSH_INV_RANGE, start, start + size);
+	smp_unlock_cache(flags);
+}
diff --git a/arch/mn10300/mm/cache-smp-inv.c b/arch/mn10300/mm/cache-smp-inv.c
new file mode 100644
index 0000000..ff17873
--- /dev/null
+++ b/arch/mn10300/mm/cache-smp-inv.c
@@ -0,0 +1,153 @@
+/* Functions for global i/dcache invalidation when caching in SMP
+ *
+ * Copyright (C) 2010 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+#include <linux/mm.h>
+#include <asm/cacheflush.h>
+#include "cache-smp.h"
+
+/**
+ * mn10300_icache_inv - Globally invalidate instruction cache
+ *
+ * Invalidate the instruction cache on all CPUs.
+ */
+void mn10300_icache_inv(void)
+{
+	unsigned long flags;
+
+	flags = smp_lock_cache();
+	mn10300_local_icache_inv();
+	smp_cache_call(SMP_ICACHE_INV, 0, 0);
+	smp_unlock_cache(flags);
+}
+
+/**
+ * mn10300_icache_inv_page - Globally invalidate a page of instruction cache
+ * @start: The address of the page of memory to be invalidated.
+ *
+ * Invalidate a range of addresses in the instruction cache on all CPUs
+ * covering the page that includes the given address.
+ */
+void mn10300_icache_inv_page(unsigned long start)
+{
+	unsigned long flags;
+
+	start &= ~(PAGE_SIZE-1);
+
+	flags = smp_lock_cache();
+	mn10300_local_icache_inv_page(start);
+	smp_cache_call(SMP_ICACHE_INV_RANGE, start, start + PAGE_SIZE);
+	smp_unlock_cache(flags);
+}
+
+/**
+ * mn10300_icache_inv_range - Globally invalidate range of instruction cache
+ * @start: The start address of the region to be invalidated.
+ * @end: The end address of the region to be invalidated.
+ *
+ * Invalidate a range of addresses in the instruction cache on all CPUs,
+ * between start and end-1 inclusive.
+ */
+void mn10300_icache_inv_range(unsigned long start, unsigned long end)
+{
+	unsigned long flags;
+
+	flags = smp_lock_cache();
+	mn10300_local_icache_inv_range(start, end);
+	smp_cache_call(SMP_ICACHE_INV_RANGE, start, end);
+	smp_unlock_cache(flags);
+}
+
+/**
+ * mn10300_icache_inv_range2 - Globally invalidate range of instruction cache
+ * @start: The start address of the region to be invalidated.
+ * @size: The size of the region to be invalidated.
+ *
+ * Invalidate a range of addresses in the instruction cache on all CPUs,
+ * between start and start+size-1 inclusive.
+ */
+void mn10300_icache_inv_range2(unsigned long start, unsigned long size)
+{
+	unsigned long flags;
+
+	flags = smp_lock_cache();
+	mn10300_local_icache_inv_range2(start, size);
+	smp_cache_call(SMP_ICACHE_INV_RANGE, start, start + size);
+	smp_unlock_cache(flags);
+}
+
+/**
+ * mn10300_dcache_inv - Globally invalidate data cache
+ *
+ * Invalidate the data cache on all CPUs.
+ */
+void mn10300_dcache_inv(void)
+{
+	unsigned long flags;
+
+	flags = smp_lock_cache();
+	mn10300_local_dcache_inv();
+	smp_cache_call(SMP_DCACHE_INV, 0, 0);
+	smp_unlock_cache(flags);
+}
+
+/**
+ * mn10300_dcache_inv_page - Globally invalidate a page of data cache
+ * @start: The address of the page of memory to be invalidated.
+ *
+ * Invalidate a range of addresses in the data cache on all CPUs covering the
+ * page that includes the given address.
+ */
+void mn10300_dcache_inv_page(unsigned long start)
+{
+	unsigned long flags;
+
+	start &= ~(PAGE_SIZE-1);
+
+	flags = smp_lock_cache();
+	mn10300_local_dcache_inv_page(start);
+	smp_cache_call(SMP_DCACHE_INV_RANGE, start, start + PAGE_SIZE);
+	smp_unlock_cache(flags);
+}
+
+/**
+ * mn10300_dcache_inv_range - Globally invalidate range of data cache
+ * @start: The start address of the region to be invalidated.
+ * @end: The end address of the region to be invalidated.
+ *
+ * Invalidate a range of addresses in the data cache on all CPUs, between start
+ * and end-1 inclusive.
+ */
+void mn10300_dcache_inv_range(unsigned long start, unsigned long end)
+{
+	unsigned long flags;
+
+	flags = smp_lock_cache();
+	mn10300_local_dcache_inv_range(start, end);
+	smp_cache_call(SMP_DCACHE_INV_RANGE, start, end);
+	smp_unlock_cache(flags);
+}
+
+/**
+ * mn10300_dcache_inv_range2 - Globally invalidate range of data cache
+ * @start: The start address of the region to be invalidated.
+ * @size: The size of the region to be invalidated.
+ *
+ * Invalidate a range of addresses in the data cache on all CPUs, between start
+ * and start+size-1 inclusive.
+ */
+void mn10300_dcache_inv_range2(unsigned long start, unsigned long size)
+{
+	unsigned long flags;
+
+	flags = smp_lock_cache();
+	mn10300_local_dcache_inv_range2(start, size);
+	smp_cache_call(SMP_DCACHE_INV_RANGE, start, start + size);
+	smp_unlock_cache(flags);
+}
diff --git a/arch/mn10300/mm/cache-smp.c b/arch/mn10300/mm/cache-smp.c
new file mode 100644
index 0000000..4a6e9a4
--- /dev/null
+++ b/arch/mn10300/mm/cache-smp.c
@@ -0,0 +1,105 @@
+/* SMP global caching code
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
+#include <linux/mman.h>
+#include <linux/threads.h>
+#include <linux/interrupt.h>
+#include <asm/page.h>
+#include <asm/pgtable.h>
+#include <asm/processor.h>
+#include <asm/cacheflush.h>
+#include <asm/io.h>
+#include <asm/uaccess.h>
+#include <asm/smp.h>
+#include "cache-smp.h"
+
+DEFINE_SPINLOCK(smp_cache_lock);
+static unsigned long smp_cache_mask;
+static unsigned long smp_cache_start;
+static unsigned long smp_cache_end;
+static cpumask_t smp_cache_ipi_map;		/* Bitmask of cache IPI done CPUs */
+
+/**
+ * smp_cache_interrupt - Handle IPI request to flush caches.
+ *
+ * Handle a request delivered by IPI to flush the current CPU's
+ * caches.  The parameters are stored in smp_cache_*.
+ */
+void smp_cache_interrupt(void)
+{
+	unsigned long opr_mask = smp_cache_mask;
+
+	switch ((enum smp_dcache_ops)(opr_mask & SMP_DCACHE_OP_MASK)) {
+	case SMP_DCACHE_NOP:
+		break;
+	case SMP_DCACHE_INV:
+		mn10300_local_dcache_inv();
+		break;
+	case SMP_DCACHE_INV_RANGE:
+		mn10300_local_dcache_inv_range(smp_cache_start, smp_cache_end);
+		break;
+	case SMP_DCACHE_FLUSH:
+		mn10300_local_dcache_flush();
+		break;
+	case SMP_DCACHE_FLUSH_RANGE:
+		mn10300_local_dcache_flush_range(smp_cache_start,
+						 smp_cache_end);
+		break;
+	case SMP_DCACHE_FLUSH_INV:
+		mn10300_local_dcache_flush_inv();
+		break;
+	case SMP_DCACHE_FLUSH_INV_RANGE:
+		mn10300_local_dcache_flush_inv_range(smp_cache_start,
+						     smp_cache_end);
+		break;
+	}
+
+	switch ((enum smp_icache_ops)(opr_mask & SMP_ICACHE_OP_MASK)) {
+	case SMP_ICACHE_NOP:
+		break;
+	case SMP_ICACHE_INV:
+		mn10300_local_icache_inv();
+		break;
+	case SMP_ICACHE_INV_RANGE:
+		mn10300_local_icache_inv_range(smp_cache_start, smp_cache_end);
+		break;
+	}
+
+	cpu_clear(smp_processor_id(), smp_cache_ipi_map);
+}
+
+/**
+ * smp_cache_call - Issue an IPI to request the other CPUs flush caches
+ * @opr_mask: Cache operation flags
+ * @start: Start address of request
+ * @end: End address of request
+ *
+ * Send cache flush IPI to other CPUs.  This invokes smp_cache_interrupt()
+ * above on those other CPUs and then waits for them to finish.
+ *
+ * The caller must hold smp_cache_lock.
+ */
+void smp_cache_call(unsigned long opr_mask,
+		    unsigned long start, unsigned long end)
+{
+	smp_cache_mask = opr_mask;
+	smp_cache_start = start;
+	smp_cache_end = end;
+	smp_cache_ipi_map = cpu_online_map;
+	cpu_clear(smp_processor_id(), smp_cache_ipi_map);
+
+	send_IPI_allbutself(FLUSH_CACHE_IPI);
+
+	while (!cpus_empty(smp_cache_ipi_map))
+		/* nothing. lockup detection does not belong here */
+		mb();
+}
diff --git a/arch/mn10300/mm/cache-smp.h b/arch/mn10300/mm/cache-smp.h
new file mode 100644
index 0000000..cb52892
--- /dev/null
+++ b/arch/mn10300/mm/cache-smp.h
@@ -0,0 +1,69 @@
+/* SMP caching definitions
+ *
+ * Copyright (C) 2010 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+
+
+/*
+ * Operation requests for smp_cache_call().
+ *
+ * One of smp_icache_ops and one of smp_dcache_ops can be OR'd together.
+ */
+enum smp_icache_ops {
+	SMP_ICACHE_NOP			= 0x0000,
+	SMP_ICACHE_INV			= 0x0001,
+	SMP_ICACHE_INV_RANGE		= 0x0002,
+};
+#define SMP_ICACHE_OP_MASK		0x0003
+
+enum smp_dcache_ops {
+	SMP_DCACHE_NOP			= 0x0000,
+	SMP_DCACHE_INV			= 0x0004,
+	SMP_DCACHE_INV_RANGE		= 0x0008,
+	SMP_DCACHE_FLUSH		= 0x000c,
+	SMP_DCACHE_FLUSH_RANGE		= 0x0010,
+	SMP_DCACHE_FLUSH_INV		= 0x0014,
+	SMP_DCACHE_FLUSH_INV_RANGE	= 0x0018,
+};
+#define SMP_DCACHE_OP_MASK		0x001c
+
+#define	SMP_IDCACHE_INV_FLUSH		(SMP_ICACHE_INV | SMP_DCACHE_FLUSH)
+#define SMP_IDCACHE_INV_FLUSH_RANGE	(SMP_ICACHE_INV_RANGE | SMP_DCACHE_FLUSH_RANGE)
+
+/*
+ * cache-smp.c
+ */
+#ifdef CONFIG_SMP
+extern spinlock_t smp_cache_lock;
+
+extern void smp_cache_call(unsigned long opr_mask,
+			   unsigned long addr, unsigned long end);
+
+static inline unsigned long smp_lock_cache(void)
+	__acquires(&smp_cache_lock)
+{
+	unsigned long flags;
+	spin_lock_irqsave(&smp_cache_lock, flags);
+	return flags;
+}
+
+static inline void smp_unlock_cache(unsigned long flags)
+	__releases(&smp_cache_lock)
+{
+	spin_unlock_irqrestore(&smp_cache_lock, flags);
+}
+
+#else
+static inline unsigned long smp_lock_cache(void) { return 0; }
+static inline void smp_unlock_cache(unsigned long flags) {}
+static inline void smp_cache_call(unsigned long opr_mask,
+				  unsigned long addr, unsigned long end)
+{
+}
+#endif /* CONFIG_SMP */
diff --git a/arch/mn10300/mm/cache.c b/arch/mn10300/mm/cache.c
index bc35826..0a1f0aa 100644
--- a/arch/mn10300/mm/cache.c
+++ b/arch/mn10300/mm/cache.c
@@ -18,8 +18,13 @@
 #include <asm/cacheflush.h>
 #include <asm/io.h>
 #include <asm/uaccess.h>
+#include <asm/smp.h>
+#include "cache-smp.h"
 
 EXPORT_SYMBOL(mn10300_icache_inv);
+EXPORT_SYMBOL(mn10300_icache_inv_range);
+EXPORT_SYMBOL(mn10300_icache_inv_range2);
+EXPORT_SYMBOL(mn10300_icache_inv_page);
 EXPORT_SYMBOL(mn10300_dcache_inv);
 EXPORT_SYMBOL(mn10300_dcache_inv_range);
 EXPORT_SYMBOL(mn10300_dcache_inv_range2);

