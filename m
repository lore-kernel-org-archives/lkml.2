Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759016Ab0JZCyt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 22:54:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58358 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758821Ab0JZCyq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 22:54:46 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH 18/43] MN10300: AM34: The current cacheflush routines
 operate by controlling tag regs
To: linux-am33-list@redhat.com
From: David Howells <dhowells@redhat.com>
Cc: linux-kernel@vger.kernel.org
Date: Tue, 26 Oct 2010 03:54:37 +0100
Message-ID: <20101026025437.23512.25359.stgit@warthog.procyon.org.uk>
In-Reply-To: <20101026025301.23512.24525.stgit@warthog.procyon.org.uk>
References: <20101026025301.23512.24525.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.15-97-g9680-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current cache flush and invalidate routines operate by controlling the
cache tag registers.  Rename the files and add config items to select them.

This makes it easier to support the use of other cache flush methods instead,
such as the use of AM34's area purge registers, if available.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 arch/mn10300/mm/Kconfig.cache         |   20 ++
 arch/mn10300/mm/Makefile              |    5 -
 arch/mn10300/mm/cache-flush-by-tag.S  |  192 ++++++++++++++++++++++
 arch/mn10300/mm/cache-flush-mn10300.S |  192 ----------------------
 arch/mn10300/mm/cache-inv-by-tag.S    |  289 +++++++++++++++++++++++++++++++++
 arch/mn10300/mm/cache-mn10300.S       |  289 ---------------------------------
 6 files changed, 504 insertions(+), 483 deletions(-)
 create mode 100644 arch/mn10300/mm/cache-flush-by-tag.S
 delete mode 100644 arch/mn10300/mm/cache-flush-mn10300.S
 create mode 100644 arch/mn10300/mm/cache-inv-by-tag.S
 delete mode 100644 arch/mn10300/mm/cache-mn10300.S


diff --git a/arch/mn10300/mm/Kconfig.cache b/arch/mn10300/mm/Kconfig.cache
index 56a88dd..aa6ff07 100644
--- a/arch/mn10300/mm/Kconfig.cache
+++ b/arch/mn10300/mm/Kconfig.cache
@@ -33,3 +33,23 @@ endchoice
 
 config MN10300_CACHE_ENABLED
 	def_bool y if !MN10300_CACHE_DISABLED
+
+
+choice
+	prompt "CPU cache flush/invalidate method"
+	default MN10300_CACHE_MANAGE_BY_TAG
+	depends on MN10300_CACHE_ENABLED
+	help
+	  This determines the method by which CPU cache flushing and
+	  invalidation is performed.
+
+config MN10300_CACHE_MANAGE_BY_TAG
+	bool "Use the cache tag registers directly"
+
+endchoice
+
+config MN10300_CACHE_INV_BY_TAG
+	def_bool y if MN10300_CACHE_MANAGE_BY_TAG && MN10300_CACHE_ENABLED
+
+config MN10300_CACHE_FLUSH_BY_TAG
+	def_bool y if MN10300_CACHE_MANAGE_BY_TAG && MN10300_CACHE_WBACK
diff --git a/arch/mn10300/mm/Makefile b/arch/mn10300/mm/Makefile
index 1557277..dc4b9f0 100644
--- a/arch/mn10300/mm/Makefile
+++ b/arch/mn10300/mm/Makefile
@@ -2,8 +2,9 @@
 # Makefile for the MN10300-specific memory management code
 #
 
-cacheflush-y	:= cache.o cache-mn10300.o
-cacheflush-$(CONFIG_MN10300_CACHE_WBACK) += cache-flush-mn10300.o
+cacheflush-y	:= cache.o
+cacheflush-$(CONFIG_MN10300_CACHE_INV_BY_TAG) += cache-inv-by-tag.o
+cacheflush-$(CONFIG_MN10300_CACHE_FLUSH_BY_TAG) += cache-flush-by-tag.o
 
 cacheflush-$(CONFIG_MN10300_CACHE_DISABLED) := cache-disabled.o
 
diff --git a/arch/mn10300/mm/cache-flush-by-tag.S b/arch/mn10300/mm/cache-flush-by-tag.S
new file mode 100644
index 0000000..c8ed1cb
--- /dev/null
+++ b/arch/mn10300/mm/cache-flush-by-tag.S
@@ -0,0 +1,192 @@
+/* MN10300 CPU core caching routines
+ *
+ * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+
+#include <linux/sys.h>
+#include <linux/linkage.h>
+#include <asm/smp.h>
+#include <asm/page.h>
+#include <asm/cache.h>
+
+	.am33_2
+	.globl mn10300_dcache_flush
+	.globl mn10300_dcache_flush_page
+	.globl mn10300_dcache_flush_range
+	.globl mn10300_dcache_flush_range2
+	.globl mn10300_dcache_flush_inv
+	.globl mn10300_dcache_flush_inv_page
+	.globl mn10300_dcache_flush_inv_range
+	.globl mn10300_dcache_flush_inv_range2
+
+###############################################################################
+#
+# void mn10300_dcache_flush(void)
+# Flush the entire data cache back to RAM
+#
+###############################################################################
+	ALIGN
+mn10300_dcache_flush:
+	movhu	(CHCTR),d0
+	btst	CHCTR_DCEN,d0
+	beq	mn10300_dcache_flush_end
+
+	# read the addresses tagged in the cache's tag RAM and attempt to flush
+	# those addresses specifically
+	# - we rely on the hardware to filter out invalid tag entry addresses
+	mov	DCACHE_TAG(0,0),a0		# dcache tag RAM access address
+	mov	DCACHE_PURGE(0,0),a1		# dcache purge request address
+	mov	L1_CACHE_NWAYS*L1_CACHE_NENTRIES,d1  # total number of entries
+
+mn10300_dcache_flush_loop:
+	mov	(a0),d0
+	and	L1_CACHE_TAG_ADDRESS|L1_CACHE_TAG_ENTRY,d0
+	or	L1_CACHE_TAG_VALID,d0		# retain valid entries in the
+						# cache
+	mov	d0,(a1)				# conditional purge
+
+mn10300_dcache_flush_skip:
+	add	L1_CACHE_BYTES,a0
+	add	L1_CACHE_BYTES,a1
+	add	-1,d1
+	bne	mn10300_dcache_flush_loop
+
+mn10300_dcache_flush_end:
+	ret	[],0
+
+###############################################################################
+#
+# void mn10300_dcache_flush_page(unsigned start)
+# void mn10300_dcache_flush_range(unsigned start, unsigned end)
+# void mn10300_dcache_flush_range2(unsigned start, unsigned size)
+# Flush a range of addresses on a page in the dcache
+#
+###############################################################################
+	ALIGN
+mn10300_dcache_flush_page:
+	mov	PAGE_SIZE,d1
+mn10300_dcache_flush_range2:
+	add	d0,d1
+mn10300_dcache_flush_range:
+	movm	[d2,d3],(sp)
+
+	movhu	(CHCTR),d2
+	btst	CHCTR_DCEN,d2
+	beq	mn10300_dcache_flush_range_end
+
+	# round start addr down
+	and	L1_CACHE_TAG_ADDRESS|L1_CACHE_TAG_ENTRY,d0
+	mov	d0,a1
+
+	add	L1_CACHE_BYTES,d1			# round end addr up
+	and	L1_CACHE_TAG_ADDRESS|L1_CACHE_TAG_ENTRY,d1
+
+	# write a request to flush all instances of an address from the cache
+	mov	DCACHE_PURGE(0,0),a0
+	mov	a1,d0
+	and	L1_CACHE_TAG_ENTRY,d0
+	add	d0,a0				# starting dcache purge control
+						# reg address
+
+	sub	a1,d1
+	lsr	L1_CACHE_SHIFT,d1		# total number of entries to
+						# examine
+
+	or	L1_CACHE_TAG_VALID,a1		# retain valid entries in the
+						# cache
+
+mn10300_dcache_flush_range_loop:
+	mov	a1,(L1_CACHE_WAYDISP*0,a0)	# conditionally purge this line
+						# all ways
+
+	add	L1_CACHE_BYTES,a0
+	add	L1_CACHE_BYTES,a1
+	and	~L1_CACHE_WAYDISP,a0		# make sure way stay on way 0
+	add	-1,d1
+	bne	mn10300_dcache_flush_range_loop
+
+mn10300_dcache_flush_range_end:
+	ret	[d2,d3],8
+
+###############################################################################
+#
+# void mn10300_dcache_flush_inv(void)
+# Flush the entire data cache and invalidate all entries
+#
+###############################################################################
+	ALIGN
+mn10300_dcache_flush_inv:
+	movhu	(CHCTR),d0
+	btst	CHCTR_DCEN,d0
+	beq	mn10300_dcache_flush_inv_end
+
+	# hit each line in the dcache with an unconditional purge
+	mov	DCACHE_PURGE(0,0),a1		# dcache purge request address
+	mov	L1_CACHE_NWAYS*L1_CACHE_NENTRIES,d1  # total number of entries
+
+mn10300_dcache_flush_inv_loop:
+	mov	(a1),d0				# unconditional purge
+
+	add	L1_CACHE_BYTES,a1
+	add	-1,d1
+	bne	mn10300_dcache_flush_inv_loop
+
+mn10300_dcache_flush_inv_end:
+	ret	[],0
+
+###############################################################################
+#
+# void mn10300_dcache_flush_inv_page(unsigned start)
+# void mn10300_dcache_flush_inv_range(unsigned start, unsigned end)
+# void mn10300_dcache_flush_inv_range2(unsigned start, unsigned size)
+# Flush and invalidate a range of addresses on a page in the dcache
+#
+###############################################################################
+	ALIGN
+mn10300_dcache_flush_inv_page:
+	mov	PAGE_SIZE,d1
+mn10300_dcache_flush_inv_range2:
+	add	d0,d1
+mn10300_dcache_flush_inv_range:
+	movm	[d2,d3],(sp)
+	movhu	(CHCTR),d2
+	btst	CHCTR_DCEN,d2
+	beq	mn10300_dcache_flush_inv_range_end
+
+	and	L1_CACHE_TAG_ADDRESS|L1_CACHE_TAG_ENTRY,d0	# round start
+								# addr down
+	mov	d0,a1
+
+	add	L1_CACHE_BYTES,d1			# round end addr up
+	and	L1_CACHE_TAG_ADDRESS|L1_CACHE_TAG_ENTRY,d1
+
+	# write a request to flush and invalidate all instances of an address
+	# from the cache
+	mov	DCACHE_PURGE(0,0),a0
+	mov	a1,d0
+	and	L1_CACHE_TAG_ENTRY,d0
+	add	d0,a0				# starting dcache purge control
+						# reg address
+
+	sub	a1,d1
+	lsr	L1_CACHE_SHIFT,d1		# total number of entries to
+						# examine
+
+mn10300_dcache_flush_inv_range_loop:
+	mov	a1,(L1_CACHE_WAYDISP*0,a0)	# conditionally purge this line
+						# in all ways
+
+	add	L1_CACHE_BYTES,a0
+	add	L1_CACHE_BYTES,a1
+	and	~L1_CACHE_WAYDISP,a0		# make sure way stay on way 0
+	add	-1,d1
+	bne	mn10300_dcache_flush_inv_range_loop
+
+mn10300_dcache_flush_inv_range_end:
+	ret	[d2,d3],8
diff --git a/arch/mn10300/mm/cache-flush-mn10300.S b/arch/mn10300/mm/cache-flush-mn10300.S
deleted file mode 100644
index c8ed1cb..0000000
--- a/arch/mn10300/mm/cache-flush-mn10300.S
+++ /dev/null
@@ -1,192 +0,0 @@
-/* MN10300 CPU core caching routines
- *
- * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
- * Written by David Howells (dhowells@redhat.com)
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public Licence
- * as published by the Free Software Foundation; either version
- * 2 of the Licence, or (at your option) any later version.
- */
-
-#include <linux/sys.h>
-#include <linux/linkage.h>
-#include <asm/smp.h>
-#include <asm/page.h>
-#include <asm/cache.h>
-
-	.am33_2
-	.globl mn10300_dcache_flush
-	.globl mn10300_dcache_flush_page
-	.globl mn10300_dcache_flush_range
-	.globl mn10300_dcache_flush_range2
-	.globl mn10300_dcache_flush_inv
-	.globl mn10300_dcache_flush_inv_page
-	.globl mn10300_dcache_flush_inv_range
-	.globl mn10300_dcache_flush_inv_range2
-
-###############################################################################
-#
-# void mn10300_dcache_flush(void)
-# Flush the entire data cache back to RAM
-#
-###############################################################################
-	ALIGN
-mn10300_dcache_flush:
-	movhu	(CHCTR),d0
-	btst	CHCTR_DCEN,d0
-	beq	mn10300_dcache_flush_end
-
-	# read the addresses tagged in the cache's tag RAM and attempt to flush
-	# those addresses specifically
-	# - we rely on the hardware to filter out invalid tag entry addresses
-	mov	DCACHE_TAG(0,0),a0		# dcache tag RAM access address
-	mov	DCACHE_PURGE(0,0),a1		# dcache purge request address
-	mov	L1_CACHE_NWAYS*L1_CACHE_NENTRIES,d1  # total number of entries
-
-mn10300_dcache_flush_loop:
-	mov	(a0),d0
-	and	L1_CACHE_TAG_ADDRESS|L1_CACHE_TAG_ENTRY,d0
-	or	L1_CACHE_TAG_VALID,d0		# retain valid entries in the
-						# cache
-	mov	d0,(a1)				# conditional purge
-
-mn10300_dcache_flush_skip:
-	add	L1_CACHE_BYTES,a0
-	add	L1_CACHE_BYTES,a1
-	add	-1,d1
-	bne	mn10300_dcache_flush_loop
-
-mn10300_dcache_flush_end:
-	ret	[],0
-
-###############################################################################
-#
-# void mn10300_dcache_flush_page(unsigned start)
-# void mn10300_dcache_flush_range(unsigned start, unsigned end)
-# void mn10300_dcache_flush_range2(unsigned start, unsigned size)
-# Flush a range of addresses on a page in the dcache
-#
-###############################################################################
-	ALIGN
-mn10300_dcache_flush_page:
-	mov	PAGE_SIZE,d1
-mn10300_dcache_flush_range2:
-	add	d0,d1
-mn10300_dcache_flush_range:
-	movm	[d2,d3],(sp)
-
-	movhu	(CHCTR),d2
-	btst	CHCTR_DCEN,d2
-	beq	mn10300_dcache_flush_range_end
-
-	# round start addr down
-	and	L1_CACHE_TAG_ADDRESS|L1_CACHE_TAG_ENTRY,d0
-	mov	d0,a1
-
-	add	L1_CACHE_BYTES,d1			# round end addr up
-	and	L1_CACHE_TAG_ADDRESS|L1_CACHE_TAG_ENTRY,d1
-
-	# write a request to flush all instances of an address from the cache
-	mov	DCACHE_PURGE(0,0),a0
-	mov	a1,d0
-	and	L1_CACHE_TAG_ENTRY,d0
-	add	d0,a0				# starting dcache purge control
-						# reg address
-
-	sub	a1,d1
-	lsr	L1_CACHE_SHIFT,d1		# total number of entries to
-						# examine
-
-	or	L1_CACHE_TAG_VALID,a1		# retain valid entries in the
-						# cache
-
-mn10300_dcache_flush_range_loop:
-	mov	a1,(L1_CACHE_WAYDISP*0,a0)	# conditionally purge this line
-						# all ways
-
-	add	L1_CACHE_BYTES,a0
-	add	L1_CACHE_BYTES,a1
-	and	~L1_CACHE_WAYDISP,a0		# make sure way stay on way 0
-	add	-1,d1
-	bne	mn10300_dcache_flush_range_loop
-
-mn10300_dcache_flush_range_end:
-	ret	[d2,d3],8
-
-###############################################################################
-#
-# void mn10300_dcache_flush_inv(void)
-# Flush the entire data cache and invalidate all entries
-#
-###############################################################################
-	ALIGN
-mn10300_dcache_flush_inv:
-	movhu	(CHCTR),d0
-	btst	CHCTR_DCEN,d0
-	beq	mn10300_dcache_flush_inv_end
-
-	# hit each line in the dcache with an unconditional purge
-	mov	DCACHE_PURGE(0,0),a1		# dcache purge request address
-	mov	L1_CACHE_NWAYS*L1_CACHE_NENTRIES,d1  # total number of entries
-
-mn10300_dcache_flush_inv_loop:
-	mov	(a1),d0				# unconditional purge
-
-	add	L1_CACHE_BYTES,a1
-	add	-1,d1
-	bne	mn10300_dcache_flush_inv_loop
-
-mn10300_dcache_flush_inv_end:
-	ret	[],0
-
-###############################################################################
-#
-# void mn10300_dcache_flush_inv_page(unsigned start)
-# void mn10300_dcache_flush_inv_range(unsigned start, unsigned end)
-# void mn10300_dcache_flush_inv_range2(unsigned start, unsigned size)
-# Flush and invalidate a range of addresses on a page in the dcache
-#
-###############################################################################
-	ALIGN
-mn10300_dcache_flush_inv_page:
-	mov	PAGE_SIZE,d1
-mn10300_dcache_flush_inv_range2:
-	add	d0,d1
-mn10300_dcache_flush_inv_range:
-	movm	[d2,d3],(sp)
-	movhu	(CHCTR),d2
-	btst	CHCTR_DCEN,d2
-	beq	mn10300_dcache_flush_inv_range_end
-
-	and	L1_CACHE_TAG_ADDRESS|L1_CACHE_TAG_ENTRY,d0	# round start
-								# addr down
-	mov	d0,a1
-
-	add	L1_CACHE_BYTES,d1			# round end addr up
-	and	L1_CACHE_TAG_ADDRESS|L1_CACHE_TAG_ENTRY,d1
-
-	# write a request to flush and invalidate all instances of an address
-	# from the cache
-	mov	DCACHE_PURGE(0,0),a0
-	mov	a1,d0
-	and	L1_CACHE_TAG_ENTRY,d0
-	add	d0,a0				# starting dcache purge control
-						# reg address
-
-	sub	a1,d1
-	lsr	L1_CACHE_SHIFT,d1		# total number of entries to
-						# examine
-
-mn10300_dcache_flush_inv_range_loop:
-	mov	a1,(L1_CACHE_WAYDISP*0,a0)	# conditionally purge this line
-						# in all ways
-
-	add	L1_CACHE_BYTES,a0
-	add	L1_CACHE_BYTES,a1
-	and	~L1_CACHE_WAYDISP,a0		# make sure way stay on way 0
-	add	-1,d1
-	bne	mn10300_dcache_flush_inv_range_loop
-
-mn10300_dcache_flush_inv_range_end:
-	ret	[d2,d3],8
diff --git a/arch/mn10300/mm/cache-inv-by-tag.S b/arch/mn10300/mm/cache-inv-by-tag.S
new file mode 100644
index 0000000..e839d0a
--- /dev/null
+++ b/arch/mn10300/mm/cache-inv-by-tag.S
@@ -0,0 +1,289 @@
+/* MN10300 CPU core caching routines
+ *
+ * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+#include <linux/sys.h>
+#include <linux/linkage.h>
+#include <asm/smp.h>
+#include <asm/page.h>
+#include <asm/cache.h>
+
+#define mn10300_dcache_inv_range_intr_interval \
+	+((1 << MN10300_DCACHE_INV_RANGE_INTR_LOG2_INTERVAL) - 1)
+
+#if mn10300_dcache_inv_range_intr_interval > 0xff
+#error MN10300_DCACHE_INV_RANGE_INTR_LOG2_INTERVAL must be 8 or less
+#endif
+
+	.am33_2
+
+	.globl mn10300_icache_inv
+	.globl mn10300_dcache_inv
+	.globl mn10300_dcache_inv_range
+	.globl mn10300_dcache_inv_range2
+	.globl mn10300_dcache_inv_page
+
+###############################################################################
+#
+# void mn10300_icache_inv(void)
+# Invalidate the entire icache
+#
+###############################################################################
+	ALIGN
+mn10300_icache_inv:
+	mov	CHCTR,a0
+
+	movhu	(a0),d0
+	btst	CHCTR_ICEN,d0
+	beq	mn10300_icache_inv_end
+
+	mov	epsw,d1
+	and	~EPSW_IE,epsw
+	nop
+	nop
+
+	# disable the icache
+	and	~CHCTR_ICEN,d0
+	movhu	d0,(a0)
+
+	# and wait for it to calm down
+	setlb
+	movhu	(a0),d0
+	btst	CHCTR_ICBUSY,d0
+	lne
+
+	# invalidate
+	or	CHCTR_ICINV,d0
+	movhu	d0,(a0)
+
+	# wait for the cache to finish
+	mov	CHCTR,a0
+	setlb
+	movhu	(a0),d0
+	btst	CHCTR_ICBUSY,d0
+	lne
+
+	# and reenable it
+	and	~CHCTR_ICINV,d0
+	or	CHCTR_ICEN,d0
+	movhu	d0,(a0)
+	movhu	(a0),d0
+
+	mov	d1,epsw
+
+mn10300_icache_inv_end:
+	ret	[],0
+
+###############################################################################
+#
+# void mn10300_dcache_inv(void)
+# Invalidate the entire dcache
+#
+###############################################################################
+	ALIGN
+mn10300_dcache_inv:
+	mov	CHCTR,a0
+
+	movhu	(a0),d0
+	btst	CHCTR_DCEN,d0
+	beq	mn10300_dcache_inv_end
+
+	mov	epsw,d1
+	and	~EPSW_IE,epsw
+	nop
+	nop
+
+	# disable the dcache
+	and	~CHCTR_DCEN,d0
+	movhu	d0,(a0)
+
+	# and wait for it to calm down
+	setlb
+	movhu	(a0),d0
+	btst	CHCTR_DCBUSY,d0
+	lne
+
+	# invalidate
+	or	CHCTR_DCINV,d0
+	movhu	d0,(a0)
+
+	# wait for the cache to finish
+	mov	CHCTR,a0
+	setlb
+	movhu	(a0),d0
+	btst	CHCTR_DCBUSY,d0
+	lne
+
+	# and reenable it
+	and	~CHCTR_DCINV,d0
+	or	CHCTR_DCEN,d0
+	movhu	d0,(a0)
+	movhu	(a0),d0
+
+	mov	d1,epsw
+
+mn10300_dcache_inv_end:
+	ret	[],0
+
+###############################################################################
+#
+# void mn10300_dcache_inv_range(unsigned start, unsigned end)
+# void mn10300_dcache_inv_range2(unsigned start, unsigned size)
+# void mn10300_dcache_inv_page(unsigned start)
+# Invalidate a range of addresses on a page in the dcache
+#
+###############################################################################
+	ALIGN
+mn10300_dcache_inv_page:
+	mov	PAGE_SIZE,d1
+mn10300_dcache_inv_range2:
+	add	d0,d1
+mn10300_dcache_inv_range:
+	movm	[d2,d3,a2],(sp)
+	mov	CHCTR,a2
+
+	movhu	(a2),d2
+	btst	CHCTR_DCEN,d2
+	beq	mn10300_dcache_inv_range_end
+
+	and	L1_CACHE_TAG_ADDRESS|L1_CACHE_TAG_ENTRY,d0	# round start
+								# addr down
+	mov	d0,a1
+
+	add	L1_CACHE_BYTES,d1			# round end addr up
+	and	L1_CACHE_TAG_ADDRESS|L1_CACHE_TAG_ENTRY,d1
+
+	clr	d2				# we're going to clear tag ram
+						# entries
+
+	# read the tags from the tag RAM, and if they indicate a valid dirty
+	# cache line then invalidate that line
+	mov	DCACHE_TAG(0,0),a0
+	mov	a1,d0
+	and	L1_CACHE_TAG_ENTRY,d0
+	add	d0,a0				# starting dcache tag RAM
+						# access address
+
+	sub	a1,d1
+	lsr	L1_CACHE_SHIFT,d1		# total number of entries to
+						# examine
+
+	and	~(L1_CACHE_DISPARITY-1),a1	# determine comparator base
+
+mn10300_dcache_inv_range_outer_loop:
+	# disable interrupts
+	mov	epsw,d3
+	and	~EPSW_IE,epsw
+	nop					# note that reading CHCTR and
+						# AND'ing D0 occupy two delay
+						# slots after disabling
+						# interrupts
+
+	# disable the dcache
+	movhu	(a2),d0
+	and	~CHCTR_DCEN,d0
+	movhu	d0,(a2)
+
+	# and wait for it to calm down
+	setlb
+	movhu	(a2),d0
+	btst	CHCTR_DCBUSY,d0
+	lne
+
+mn10300_dcache_inv_range_loop:
+
+	# process the way 0 slot
+	mov	(L1_CACHE_WAYDISP*0,a0),d0	# read the tag in the way 0 slot
+	btst	L1_CACHE_TAG_VALID,d0
+	beq	mn10300_dcache_inv_range_skip_0	# jump if this cacheline is not
+						# valid
+
+	xor	a1,d0
+	lsr	12,d0
+	bne	mn10300_dcache_inv_range_skip_0	# jump if not this cacheline
+
+	mov	d2,(a0)				# kill the tag
+
+mn10300_dcache_inv_range_skip_0:
+
+	# process the way 1 slot
+	mov	(L1_CACHE_WAYDISP*1,a0),d0	# read the tag in the way 1 slot
+	btst	L1_CACHE_TAG_VALID,d0
+	beq	mn10300_dcache_inv_range_skip_1	# jump if this cacheline is not
+						# valid
+
+	xor	a1,d0
+	lsr	12,d0
+	bne	mn10300_dcache_inv_range_skip_1	# jump if not this cacheline
+
+	mov	d2,(a0)				# kill the tag
+
+mn10300_dcache_inv_range_skip_1:
+
+	# process the way 2 slot
+	mov	(L1_CACHE_WAYDISP*2,a0),d0	# read the tag in the way 2 slot
+	btst	L1_CACHE_TAG_VALID,d0
+	beq	mn10300_dcache_inv_range_skip_2	# jump if this cacheline is not
+						# valid
+
+	xor	a1,d0
+	lsr	12,d0
+	bne	mn10300_dcache_inv_range_skip_2	# jump if not this cacheline
+
+	mov	d2,(a0)				# kill the tag
+
+mn10300_dcache_inv_range_skip_2:
+
+	# process the way 3 slot
+	mov	(L1_CACHE_WAYDISP*3,a0),d0	# read the tag in the way 3 slot
+	btst	L1_CACHE_TAG_VALID,d0
+	beq	mn10300_dcache_inv_range_skip_3	# jump if this cacheline is not
+						# valid
+
+	xor	a1,d0
+	lsr	12,d0
+	bne	mn10300_dcache_inv_range_skip_3	# jump if not this cacheline
+
+	mov	d2,(a0)				# kill the tag
+
+mn10300_dcache_inv_range_skip_3:
+
+	# approx every N steps we re-enable the cache and see if there are any
+	# interrupts to be processed
+	# we also break out if we've reached the end of the loop
+	# (the bottom nibble of the count is zero in both cases)
+	add	L1_CACHE_BYTES,a0
+	add	L1_CACHE_BYTES,a1
+	add	-1,d1
+	btst	mn10300_dcache_inv_range_intr_interval,d1
+	bne	mn10300_dcache_inv_range_loop
+
+	# wait for the cache to finish what it's doing
+	setlb
+	movhu	(a2),d0
+	btst	CHCTR_DCBUSY,d0
+	lne
+
+	# and reenable it
+	or	CHCTR_DCEN,d0
+	movhu	d0,(a2)
+	movhu	(a2),d0
+
+	# re-enable interrupts
+	# - we don't bother with delay NOPs as we'll have enough instructions
+	#   before we disable interrupts again to give the interrupts a chance
+	#   to happen
+	mov	d3,epsw
+
+	# go around again if the counter hasn't yet reached zero
+	add	0,d1
+	bne	mn10300_dcache_inv_range_outer_loop
+
+mn10300_dcache_inv_range_end:
+	ret	[d2,d3,a2],12
diff --git a/arch/mn10300/mm/cache-mn10300.S b/arch/mn10300/mm/cache-mn10300.S
deleted file mode 100644
index e839d0a..0000000
--- a/arch/mn10300/mm/cache-mn10300.S
+++ /dev/null
@@ -1,289 +0,0 @@
-/* MN10300 CPU core caching routines
- *
- * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
- * Written by David Howells (dhowells@redhat.com)
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public Licence
- * as published by the Free Software Foundation; either version
- * 2 of the Licence, or (at your option) any later version.
- */
-#include <linux/sys.h>
-#include <linux/linkage.h>
-#include <asm/smp.h>
-#include <asm/page.h>
-#include <asm/cache.h>
-
-#define mn10300_dcache_inv_range_intr_interval \
-	+((1 << MN10300_DCACHE_INV_RANGE_INTR_LOG2_INTERVAL) - 1)
-
-#if mn10300_dcache_inv_range_intr_interval > 0xff
-#error MN10300_DCACHE_INV_RANGE_INTR_LOG2_INTERVAL must be 8 or less
-#endif
-
-	.am33_2
-
-	.globl mn10300_icache_inv
-	.globl mn10300_dcache_inv
-	.globl mn10300_dcache_inv_range
-	.globl mn10300_dcache_inv_range2
-	.globl mn10300_dcache_inv_page
-
-###############################################################################
-#
-# void mn10300_icache_inv(void)
-# Invalidate the entire icache
-#
-###############################################################################
-	ALIGN
-mn10300_icache_inv:
-	mov	CHCTR,a0
-
-	movhu	(a0),d0
-	btst	CHCTR_ICEN,d0
-	beq	mn10300_icache_inv_end
-
-	mov	epsw,d1
-	and	~EPSW_IE,epsw
-	nop
-	nop
-
-	# disable the icache
-	and	~CHCTR_ICEN,d0
-	movhu	d0,(a0)
-
-	# and wait for it to calm down
-	setlb
-	movhu	(a0),d0
-	btst	CHCTR_ICBUSY,d0
-	lne
-
-	# invalidate
-	or	CHCTR_ICINV,d0
-	movhu	d0,(a0)
-
-	# wait for the cache to finish
-	mov	CHCTR,a0
-	setlb
-	movhu	(a0),d0
-	btst	CHCTR_ICBUSY,d0
-	lne
-
-	# and reenable it
-	and	~CHCTR_ICINV,d0
-	or	CHCTR_ICEN,d0
-	movhu	d0,(a0)
-	movhu	(a0),d0
-
-	mov	d1,epsw
-
-mn10300_icache_inv_end:
-	ret	[],0
-
-###############################################################################
-#
-# void mn10300_dcache_inv(void)
-# Invalidate the entire dcache
-#
-###############################################################################
-	ALIGN
-mn10300_dcache_inv:
-	mov	CHCTR,a0
-
-	movhu	(a0),d0
-	btst	CHCTR_DCEN,d0
-	beq	mn10300_dcache_inv_end
-
-	mov	epsw,d1
-	and	~EPSW_IE,epsw
-	nop
-	nop
-
-	# disable the dcache
-	and	~CHCTR_DCEN,d0
-	movhu	d0,(a0)
-
-	# and wait for it to calm down
-	setlb
-	movhu	(a0),d0
-	btst	CHCTR_DCBUSY,d0
-	lne
-
-	# invalidate
-	or	CHCTR_DCINV,d0
-	movhu	d0,(a0)
-
-	# wait for the cache to finish
-	mov	CHCTR,a0
-	setlb
-	movhu	(a0),d0
-	btst	CHCTR_DCBUSY,d0
-	lne
-
-	# and reenable it
-	and	~CHCTR_DCINV,d0
-	or	CHCTR_DCEN,d0
-	movhu	d0,(a0)
-	movhu	(a0),d0
-
-	mov	d1,epsw
-
-mn10300_dcache_inv_end:
-	ret	[],0
-
-###############################################################################
-#
-# void mn10300_dcache_inv_range(unsigned start, unsigned end)
-# void mn10300_dcache_inv_range2(unsigned start, unsigned size)
-# void mn10300_dcache_inv_page(unsigned start)
-# Invalidate a range of addresses on a page in the dcache
-#
-###############################################################################
-	ALIGN
-mn10300_dcache_inv_page:
-	mov	PAGE_SIZE,d1
-mn10300_dcache_inv_range2:
-	add	d0,d1
-mn10300_dcache_inv_range:
-	movm	[d2,d3,a2],(sp)
-	mov	CHCTR,a2
-
-	movhu	(a2),d2
-	btst	CHCTR_DCEN,d2
-	beq	mn10300_dcache_inv_range_end
-
-	and	L1_CACHE_TAG_ADDRESS|L1_CACHE_TAG_ENTRY,d0	# round start
-								# addr down
-	mov	d0,a1
-
-	add	L1_CACHE_BYTES,d1			# round end addr up
-	and	L1_CACHE_TAG_ADDRESS|L1_CACHE_TAG_ENTRY,d1
-
-	clr	d2				# we're going to clear tag ram
-						# entries
-
-	# read the tags from the tag RAM, and if they indicate a valid dirty
-	# cache line then invalidate that line
-	mov	DCACHE_TAG(0,0),a0
-	mov	a1,d0
-	and	L1_CACHE_TAG_ENTRY,d0
-	add	d0,a0				# starting dcache tag RAM
-						# access address
-
-	sub	a1,d1
-	lsr	L1_CACHE_SHIFT,d1		# total number of entries to
-						# examine
-
-	and	~(L1_CACHE_DISPARITY-1),a1	# determine comparator base
-
-mn10300_dcache_inv_range_outer_loop:
-	# disable interrupts
-	mov	epsw,d3
-	and	~EPSW_IE,epsw
-	nop					# note that reading CHCTR and
-						# AND'ing D0 occupy two delay
-						# slots after disabling
-						# interrupts
-
-	# disable the dcache
-	movhu	(a2),d0
-	and	~CHCTR_DCEN,d0
-	movhu	d0,(a2)
-
-	# and wait for it to calm down
-	setlb
-	movhu	(a2),d0
-	btst	CHCTR_DCBUSY,d0
-	lne
-
-mn10300_dcache_inv_range_loop:
-
-	# process the way 0 slot
-	mov	(L1_CACHE_WAYDISP*0,a0),d0	# read the tag in the way 0 slot
-	btst	L1_CACHE_TAG_VALID,d0
-	beq	mn10300_dcache_inv_range_skip_0	# jump if this cacheline is not
-						# valid
-
-	xor	a1,d0
-	lsr	12,d0
-	bne	mn10300_dcache_inv_range_skip_0	# jump if not this cacheline
-
-	mov	d2,(a0)				# kill the tag
-
-mn10300_dcache_inv_range_skip_0:
-
-	# process the way 1 slot
-	mov	(L1_CACHE_WAYDISP*1,a0),d0	# read the tag in the way 1 slot
-	btst	L1_CACHE_TAG_VALID,d0
-	beq	mn10300_dcache_inv_range_skip_1	# jump if this cacheline is not
-						# valid
-
-	xor	a1,d0
-	lsr	12,d0
-	bne	mn10300_dcache_inv_range_skip_1	# jump if not this cacheline
-
-	mov	d2,(a0)				# kill the tag
-
-mn10300_dcache_inv_range_skip_1:
-
-	# process the way 2 slot
-	mov	(L1_CACHE_WAYDISP*2,a0),d0	# read the tag in the way 2 slot
-	btst	L1_CACHE_TAG_VALID,d0
-	beq	mn10300_dcache_inv_range_skip_2	# jump if this cacheline is not
-						# valid
-
-	xor	a1,d0
-	lsr	12,d0
-	bne	mn10300_dcache_inv_range_skip_2	# jump if not this cacheline
-
-	mov	d2,(a0)				# kill the tag
-
-mn10300_dcache_inv_range_skip_2:
-
-	# process the way 3 slot
-	mov	(L1_CACHE_WAYDISP*3,a0),d0	# read the tag in the way 3 slot
-	btst	L1_CACHE_TAG_VALID,d0
-	beq	mn10300_dcache_inv_range_skip_3	# jump if this cacheline is not
-						# valid
-
-	xor	a1,d0
-	lsr	12,d0
-	bne	mn10300_dcache_inv_range_skip_3	# jump if not this cacheline
-
-	mov	d2,(a0)				# kill the tag
-
-mn10300_dcache_inv_range_skip_3:
-
-	# approx every N steps we re-enable the cache and see if there are any
-	# interrupts to be processed
-	# we also break out if we've reached the end of the loop
-	# (the bottom nibble of the count is zero in both cases)
-	add	L1_CACHE_BYTES,a0
-	add	L1_CACHE_BYTES,a1
-	add	-1,d1
-	btst	mn10300_dcache_inv_range_intr_interval,d1
-	bne	mn10300_dcache_inv_range_loop
-
-	# wait for the cache to finish what it's doing
-	setlb
-	movhu	(a2),d0
-	btst	CHCTR_DCBUSY,d0
-	lne
-
-	# and reenable it
-	or	CHCTR_DCEN,d0
-	movhu	d0,(a2)
-	movhu	(a2),d0
-
-	# re-enable interrupts
-	# - we don't bother with delay NOPs as we'll have enough instructions
-	#   before we disable interrupts again to give the interrupts a chance
-	#   to happen
-	mov	d3,epsw
-
-	# go around again if the counter hasn't yet reached zero
-	add	0,d1
-	bne	mn10300_dcache_inv_range_outer_loop
-
-mn10300_dcache_inv_range_end:
-	ret	[d2,d3,a2],12

