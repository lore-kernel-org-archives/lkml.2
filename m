Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759259Ab0JZCzK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 22:55:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61445 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759083Ab0JZCzE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 22:55:04 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH 21/43] MN10300: AM34: Add cacheflushing by using the AM34
 purge registers
To: linux-am33-list@redhat.com
From: David Howells <dhowells@redhat.com>
Cc: linux-kernel@vger.kernel.org,
        Akira Takeuchi <takeuchi.akr@jp.panasonic.com>,
        Kiyoshi Owada <owada.kiyoshi@jp.panasonic.com>
Date: Tue, 26 Oct 2010 03:54:53 +0100
Message-ID: <20101026025453.23512.50242.stgit@warthog.procyon.org.uk>
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

The AM34 CPU core provides an automated way of purging the cache rather than
manually iterating over all the tags in the cache.  Make it possible to use
these.

Signed-off-by: Akira Takeuchi <takeuchi.akr@jp.panasonic.com>
Signed-off-by: Kiyoshi Owada <owada.kiyoshi@jp.panasonic.com>
Signed-off-by: David Howells <dhowells@redhat.com>
---

 arch/mn10300/mm/Kconfig.cache        |   13 +
 arch/mn10300/mm/Makefile             |    2 
 arch/mn10300/mm/cache-flush-by-reg.S |  308 +++++++++++++++++++++++++++++
 arch/mn10300/mm/cache-inv-by-reg.S   |  356 ++++++++++++++++++++++++++++++++++
 4 files changed, 678 insertions(+), 1 deletions(-)
 create mode 100644 arch/mn10300/mm/cache-flush-by-reg.S
 create mode 100644 arch/mn10300/mm/cache-inv-by-reg.S


diff --git a/arch/mn10300/mm/Kconfig.cache b/arch/mn10300/mm/Kconfig.cache
index aa6ff07..97adc06 100644
--- a/arch/mn10300/mm/Kconfig.cache
+++ b/arch/mn10300/mm/Kconfig.cache
@@ -37,7 +37,8 @@ config MN10300_CACHE_ENABLED
 
 choice
 	prompt "CPU cache flush/invalidate method"
-	default MN10300_CACHE_MANAGE_BY_TAG
+	default MN10300_CACHE_MANAGE_BY_TAG if !AM34_2
+	default MN10300_CACHE_MANAGE_BY_REG if AM34_2
 	depends on MN10300_CACHE_ENABLED
 	help
 	  This determines the method by which CPU cache flushing and
@@ -46,10 +47,20 @@ choice
 config MN10300_CACHE_MANAGE_BY_TAG
 	bool "Use the cache tag registers directly"
 
+config MN10300_CACHE_MANAGE_BY_REG
+	bool "Flush areas by way of automatic purge registers (AM34 only)"
+	depends on AM34_2
+
 endchoice
 
 config MN10300_CACHE_INV_BY_TAG
 	def_bool y if MN10300_CACHE_MANAGE_BY_TAG && MN10300_CACHE_ENABLED
 
+config MN10300_CACHE_INV_BY_REG
+	def_bool y if MN10300_CACHE_MANAGE_BY_REG && MN10300_CACHE_ENABLED
+
 config MN10300_CACHE_FLUSH_BY_TAG
 	def_bool y if MN10300_CACHE_MANAGE_BY_TAG && MN10300_CACHE_WBACK
+
+config MN10300_CACHE_FLUSH_BY_REG
+	def_bool y if MN10300_CACHE_MANAGE_BY_REG && MN10300_CACHE_WBACK
diff --git a/arch/mn10300/mm/Makefile b/arch/mn10300/mm/Makefile
index dc4b9f0..7b99723 100644
--- a/arch/mn10300/mm/Makefile
+++ b/arch/mn10300/mm/Makefile
@@ -4,7 +4,9 @@
 
 cacheflush-y	:= cache.o
 cacheflush-$(CONFIG_MN10300_CACHE_INV_BY_TAG) += cache-inv-by-tag.o
+cacheflush-$(CONFIG_MN10300_CACHE_INV_BY_REG) += cache-inv-by-reg.o
 cacheflush-$(CONFIG_MN10300_CACHE_FLUSH_BY_TAG) += cache-flush-by-tag.o
+cacheflush-$(CONFIG_MN10300_CACHE_FLUSH_BY_REG) += cache-flush-by-reg.o
 
 cacheflush-$(CONFIG_MN10300_CACHE_DISABLED) := cache-disabled.o
 
diff --git a/arch/mn10300/mm/cache-flush-by-reg.S b/arch/mn10300/mm/cache-flush-by-reg.S
new file mode 100644
index 0000000..1dcae02
--- /dev/null
+++ b/arch/mn10300/mm/cache-flush-by-reg.S
@@ -0,0 +1,308 @@
+/* MN10300 CPU core caching routines, using indirect regs on cache controller
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
+#include <asm/irqflags.h>
+
+	.am33_2
+
+#ifndef CONFIG_SMP
+	.globl mn10300_dcache_flush
+	.globl mn10300_dcache_flush_page
+	.globl mn10300_dcache_flush_range
+	.globl mn10300_dcache_flush_range2
+	.globl mn10300_dcache_flush_inv
+	.globl mn10300_dcache_flush_inv_page
+	.globl mn10300_dcache_flush_inv_range
+	.globl mn10300_dcache_flush_inv_range2
+
+mn10300_dcache_flush		= mn10300_local_dcache_flush
+mn10300_dcache_flush_page	= mn10300_local_dcache_flush_page
+mn10300_dcache_flush_range	= mn10300_local_dcache_flush_range
+mn10300_dcache_flush_range2	= mn10300_local_dcache_flush_range2
+mn10300_dcache_flush_inv	= mn10300_local_dcache_flush_inv
+mn10300_dcache_flush_inv_page	= mn10300_local_dcache_flush_inv_page
+mn10300_dcache_flush_inv_range	= mn10300_local_dcache_flush_inv_range
+mn10300_dcache_flush_inv_range2	= mn10300_local_dcache_flush_inv_range2
+
+#endif /* !CONFIG_SMP */
+
+###############################################################################
+#
+# void mn10300_local_dcache_flush(void)
+# Flush the entire data cache back to RAM
+#
+###############################################################################
+	ALIGN
+	.globl	mn10300_local_dcache_flush
+        .type	mn10300_local_dcache_flush,@function
+mn10300_local_dcache_flush:
+	movhu	(CHCTR),d0
+	btst	CHCTR_DCEN,d0
+	beq	mn10300_local_dcache_flush_end
+
+	mov	DCPGCR,a0
+
+	LOCAL_CLI_SAVE(d1)
+
+	# wait for busy bit of area purge
+	setlb
+	mov	(a0),d0
+	btst	DCPGCR_DCPGBSY,d0
+	lne
+
+	# set mask
+	clr	d0
+	mov	d0,(DCPGMR)
+
+	# area purge
+	#
+	# DCPGCR = DCPGCR_DCP
+	#
+	mov	DCPGCR_DCP,d0
+	mov	d0,(a0)
+
+	# wait for busy bit of area purge
+	setlb
+	mov	(a0),d0
+	btst	DCPGCR_DCPGBSY,d0
+	lne
+
+	LOCAL_IRQ_RESTORE(d1)
+
+mn10300_local_dcache_flush_end:
+	ret	[],0
+	.size	mn10300_local_dcache_flush,.-mn10300_local_dcache_flush
+
+###############################################################################
+#
+# void mn10300_local_dcache_flush_page(unsigned long start)
+# void mn10300_local_dcache_flush_range(unsigned long start, unsigned long end)
+# void mn10300_local_dcache_flush_range2(unsigned long start, unsigned long size)
+# Flush a range of addresses on a page in the dcache
+#
+###############################################################################
+	ALIGN
+	.globl	mn10300_local_dcache_flush_page
+	.globl	mn10300_local_dcache_flush_range
+	.globl	mn10300_local_dcache_flush_range2
+	.type	mn10300_local_dcache_flush_page,@function
+	.type	mn10300_local_dcache_flush_range,@function
+	.type	mn10300_local_dcache_flush_range2,@function
+mn10300_local_dcache_flush_page:
+	and	~(PAGE_SIZE-1),d0
+	mov	PAGE_SIZE,d1
+mn10300_local_dcache_flush_range2:
+	add	d0,d1
+mn10300_local_dcache_flush_range:
+	movm	[d2,d3,a2],(sp)
+
+	movhu	(CHCTR),d2
+	btst	CHCTR_DCEN,d2
+	beq	mn10300_local_dcache_flush_range_end
+
+	# calculate alignsize
+	#
+	# alignsize = L1_CACHE_BYTES;
+	# for (i = (end - start - 1) / L1_CACHE_BYTES ;  i > 0; i >>= 1)
+	#     alignsize <<= 1;
+	# d2 = alignsize;
+	#
+	mov	L1_CACHE_BYTES,d2
+	sub	d0,d1,d3
+	add	-1,d3
+	lsr	L1_CACHE_SHIFT,d3
+	beq	2f
+1:
+	add     d2,d2
+	lsr     1,d3
+	bne     1b
+2:
+	mov	d1,a1		# a1 = end
+
+	LOCAL_CLI_SAVE(d3)
+	mov	DCPGCR,a0
+
+	# wait for busy bit of area purge
+	setlb
+	mov	(a0),d1
+	btst	DCPGCR_DCPGBSY,d1
+	lne
+
+	# determine the mask
+	mov	d2,d1
+	add	-1,d1
+	not	d1		# d1 = mask = ~(alignsize-1)
+	mov	d1,(DCPGMR)
+
+	and	d1,d0,a2	# a2 = mask & start
+
+dcpgloop:
+	# area purge
+	mov	a2,d0
+	or	DCPGCR_DCP,d0
+	mov	d0,(a0)		# DCPGCR = (mask & start) | DCPGCR_DCP
+
+	# wait for busy bit of area purge
+	setlb
+	mov	(a0),d1
+	btst	DCPGCR_DCPGBSY,d1
+	lne
+
+	# check purge of end address
+	add	d2,a2		# a2 += alignsize
+	cmp	a1,a2		# if (a2 < end) goto dcpgloop
+	bns	dcpgloop
+
+	LOCAL_IRQ_RESTORE(d3)
+
+mn10300_local_dcache_flush_range_end:
+	ret	[d2,d3,a2],12
+
+	.size	mn10300_local_dcache_flush_page,.-mn10300_local_dcache_flush_page
+	.size	mn10300_local_dcache_flush_range,.-mn10300_local_dcache_flush_range
+	.size	mn10300_local_dcache_flush_range2,.-mn10300_local_dcache_flush_range2
+
+###############################################################################
+#
+# void mn10300_local_dcache_flush_inv(void)
+# Flush the entire data cache and invalidate all entries
+#
+###############################################################################
+	ALIGN
+	.globl	mn10300_local_dcache_flush_inv
+	.type	mn10300_local_dcache_flush_inv,@function
+mn10300_local_dcache_flush_inv:
+	movhu	(CHCTR),d0
+	btst	CHCTR_DCEN,d0
+	beq	mn10300_local_dcache_flush_inv_end
+
+	mov	DCPGCR,a0
+
+	LOCAL_CLI_SAVE(d1)
+
+	# wait for busy bit of area purge & invalidate
+	setlb
+	mov	(a0),d0
+	btst	DCPGCR_DCPGBSY,d0
+	lne
+
+	# set the mask to cover everything
+	clr	d0
+	mov	d0,(DCPGMR)
+
+	# area purge & invalidate
+	mov	DCPGCR_DCP|DCPGCR_DCI,d0
+	mov	d0,(a0)
+
+	# wait for busy bit of area purge & invalidate
+	setlb
+	mov	(a0),d0
+	btst	DCPGCR_DCPGBSY,d0
+	lne
+
+	LOCAL_IRQ_RESTORE(d1)
+
+mn10300_local_dcache_flush_inv_end:
+	ret	[],0
+	.size	mn10300_local_dcache_flush_inv,.-mn10300_local_dcache_flush_inv
+
+###############################################################################
+#
+# void mn10300_local_dcache_flush_inv_page(unsigned long start)
+# void mn10300_local_dcache_flush_inv_range(unsigned long start, unsigned long end)
+# void mn10300_local_dcache_flush_inv_range2(unsigned long start, unsigned long size)
+# Flush and invalidate a range of addresses on a page in the dcache
+#
+###############################################################################
+	ALIGN
+	.globl	mn10300_local_dcache_flush_inv_page
+	.globl	mn10300_local_dcache_flush_inv_range
+	.globl	mn10300_local_dcache_flush_inv_range2
+	.type	mn10300_local_dcache_flush_inv_page,@function
+	.type	mn10300_local_dcache_flush_inv_range,@function
+	.type	mn10300_local_dcache_flush_inv_range2,@function
+mn10300_local_dcache_flush_inv_page:
+	and	~(PAGE_SIZE-1),d0
+	mov	PAGE_SIZE,d1
+mn10300_local_dcache_flush_inv_range2:
+	add	d0,d1
+mn10300_local_dcache_flush_inv_range:
+	movm	[d2,d3,a2],(sp)
+
+	movhu	(CHCTR),d2
+	btst	CHCTR_DCEN,d2
+	beq	mn10300_local_dcache_flush_inv_range_end
+
+	# calculate alignsize
+	#
+	# alignsize = L1_CACHE_BYTES;
+	# for (i = (end - start - 1) / L1_CACHE_BYTES; i > 0; i >>= 1)
+	#     alignsize <<= 1;
+	# d2 = alignsize
+	#
+	mov	L1_CACHE_BYTES,d2
+	sub	d0,d1,d3
+	add	-1,d3
+	lsr	L1_CACHE_SHIFT,d3
+	beq	2f
+1:
+	add     d2,d2
+	lsr     1,d3
+	bne     1b
+2:
+	mov	d1,a1		# a1 = end
+
+	LOCAL_CLI_SAVE(d3)
+	mov	DCPGCR,a0
+
+	# wait for busy bit of area purge & invalidate
+	setlb
+	mov	(a0),d1
+	btst	DCPGCR_DCPGBSY,d1
+	lne
+
+	# set the mask
+	mov	d2,d1
+	add	-1,d1
+	not	d1		# d1 = mask = ~(alignsize-1)
+	mov	d1,(DCPGMR)
+
+	and	d1,d0,a2	# a2 = mask & start
+
+dcpgivloop:
+	# area purge & invalidate
+	mov	a2,d0
+	or	DCPGCR_DCP|DCPGCR_DCI,d0
+	mov	d0,(a0)		# DCPGCR = (mask & start)|DCPGCR_DCP|DCPGCR_DCI
+
+	# wait for busy bit of area purge & invalidate
+	setlb
+	mov	(a0),d1
+	btst	DCPGCR_DCPGBSY,d1
+	lne
+
+	# check purge & invalidate of end address
+	add	d2,a2		# a2 += alignsize
+	cmp	a1,a2		# if (a2 < end) goto dcpgivloop
+	bns	dcpgivloop
+
+	LOCAL_IRQ_RESTORE(d3)
+
+mn10300_local_dcache_flush_inv_range_end:
+	ret	[d2,d3,a2],12
+	.size	mn10300_local_dcache_flush_inv_page,.-mn10300_local_dcache_flush_inv_page
+	.size	mn10300_local_dcache_flush_inv_range,.-mn10300_local_dcache_flush_inv_range
+	.size	mn10300_local_dcache_flush_inv_range2,.-mn10300_local_dcache_flush_inv_range2
diff --git a/arch/mn10300/mm/cache-inv-by-reg.S b/arch/mn10300/mm/cache-inv-by-reg.S
new file mode 100644
index 0000000..c895086
--- /dev/null
+++ b/arch/mn10300/mm/cache-inv-by-reg.S
@@ -0,0 +1,356 @@
+/* MN10300 CPU cache invalidation routines, using automatic purge registers
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
+#include <asm/irqflags.h>
+#include <asm/cacheflush.h>
+
+#define mn10300_local_dcache_inv_range_intr_interval \
+	+((1 << MN10300_DCACHE_INV_RANGE_INTR_LOG2_INTERVAL) - 1)
+
+#if mn10300_local_dcache_inv_range_intr_interval > 0xff
+#error MN10300_DCACHE_INV_RANGE_INTR_LOG2_INTERVAL must be 8 or less
+#endif
+
+	.am33_2
+
+#ifndef CONFIG_SMP
+	.globl	mn10300_icache_inv
+	.globl	mn10300_icache_inv_page
+	.globl	mn10300_icache_inv_range
+	.globl	mn10300_icache_inv_range2
+	.globl	mn10300_dcache_inv
+	.globl	mn10300_dcache_inv_page
+	.globl	mn10300_dcache_inv_range
+	.globl	mn10300_dcache_inv_range2
+
+mn10300_icache_inv		= mn10300_local_icache_inv
+mn10300_icache_inv_page		= mn10300_local_icache_inv_page
+mn10300_icache_inv_range	= mn10300_local_icache_inv_range
+mn10300_icache_inv_range2	= mn10300_local_icache_inv_range2
+mn10300_dcache_inv		= mn10300_local_dcache_inv
+mn10300_dcache_inv_page		= mn10300_local_dcache_inv_page
+mn10300_dcache_inv_range	= mn10300_local_dcache_inv_range
+mn10300_dcache_inv_range2	= mn10300_local_dcache_inv_range2
+
+#endif /* !CONFIG_SMP */
+
+###############################################################################
+#
+# void mn10300_local_icache_inv(void)
+# Invalidate the entire icache
+#
+###############################################################################
+	ALIGN
+	.globl	mn10300_local_icache_inv
+        .type	mn10300_local_icache_inv,@function
+mn10300_local_icache_inv:
+	mov	CHCTR,a0
+
+	movhu	(a0),d0
+	btst	CHCTR_ICEN,d0
+	beq	mn10300_local_icache_inv_end
+
+	# invalidate
+	or	CHCTR_ICINV,d0
+	movhu	d0,(a0)
+	movhu	(a0),d0
+
+mn10300_local_icache_inv_end:
+	ret	[],0
+	.size	mn10300_local_icache_inv,.-mn10300_local_icache_inv
+
+###############################################################################
+#
+# void mn10300_local_dcache_inv(void)
+# Invalidate the entire dcache
+#
+###############################################################################
+	ALIGN
+	.globl	mn10300_local_dcache_inv
+	.type	mn10300_local_dcache_inv,@function
+mn10300_local_dcache_inv:
+	mov	CHCTR,a0
+
+	movhu	(a0),d0
+	btst	CHCTR_DCEN,d0
+	beq	mn10300_local_dcache_inv_end
+
+	# invalidate
+	or	CHCTR_DCINV,d0
+	movhu	d0,(a0)
+	movhu	(a0),d0
+
+mn10300_local_dcache_inv_end:
+	ret	[],0
+	.size	mn10300_local_dcache_inv,.-mn10300_local_dcache_inv
+
+###############################################################################
+#
+# void mn10300_local_dcache_inv_range(unsigned long start, unsigned long end)
+# void mn10300_local_dcache_inv_range2(unsigned long start, unsigned long size)
+# void mn10300_local_dcache_inv_page(unsigned long start)
+# Invalidate a range of addresses on a page in the dcache
+#
+###############################################################################
+	ALIGN
+	.globl	mn10300_local_dcache_inv_page
+	.globl	mn10300_local_dcache_inv_range
+	.globl	mn10300_local_dcache_inv_range2
+	.type	mn10300_local_dcache_inv_page,@function
+	.type	mn10300_local_dcache_inv_range,@function
+	.type	mn10300_local_dcache_inv_range2,@function
+mn10300_local_dcache_inv_page:
+	and	~(PAGE_SIZE-1),d0
+	mov	PAGE_SIZE,d1
+mn10300_local_dcache_inv_range2:
+	add	d0,d1
+mn10300_local_dcache_inv_range:
+	# If we are in writeback mode we check the start and end alignments,
+	# and if they're not cacheline-aligned, we must flush any bits outside
+	# the range that share cachelines with stuff inside the range
+#ifdef CONFIG_MN10300_CACHE_WBACK
+	btst	~(L1_CACHE_BYTES-1),d0
+	bne	1f
+	btst	~(L1_CACHE_BYTES-1),d1
+	beq	2f
+1:
+	bra	mn10300_local_dcache_flush_inv_range
+2:
+#endif /* CONFIG_MN10300_CACHE_WBACK */
+
+	movm	[d2,d3,a2],(sp)
+
+	mov	CHCTR,a0
+	movhu	(a0),d2
+	btst	CHCTR_DCEN,d2
+	beq	mn10300_local_dcache_inv_range_end
+
+	# round the addresses out to be full cachelines, unless we're in
+	# writeback mode, in which case we would be in flush and invalidate by
+	# now
+#ifndef CONFIG_MN10300_CACHE_WBACK
+	and	L1_CACHE_TAG_ADDRESS|L1_CACHE_TAG_ENTRY,d0	# round start
+								# addr down
+
+	mov	L1_CACHE_BYTES-1,d2
+	add	d2,d1
+	and	L1_CACHE_TAG_ADDRESS|L1_CACHE_TAG_ENTRY,d1	# round end addr up
+#endif /* !CONFIG_MN10300_CACHE_WBACK */
+
+	sub	d0,d1,d2		# calculate the total size
+	mov	d0,a2			# A2 = start address
+	mov	d1,a1			# A1 = end address
+
+	LOCAL_CLI_SAVE(d3)
+
+	mov	DCPGCR,a0		# make sure the purger isn't busy
+	setlb
+	mov	(a0),d0
+	btst	DCPGCR_DCPGBSY,d0
+	lne
+
+	# skip initial address alignment calculation if address is zero
+	mov	d2,d1
+	cmp	0,a2
+	beq	1f
+
+dcivloop:
+	/* calculate alignsize
+	 *
+	 * alignsize = L1_CACHE_BYTES;
+	 * while (! start & alignsize) {
+	 *	alignsize <<=1;
+	 * }
+	 * d1 = alignsize;
+	 */
+	mov	L1_CACHE_BYTES,d1
+	lsr	1,d1
+	setlb
+	add	d1,d1
+	mov	d1,d0
+	and	a2,d0
+	leq
+
+1:
+	/* calculate invsize
+	 *
+	 * if (totalsize > alignsize) {
+	 *	invsize = alignsize;
+	 * } else {
+	 *	invsize = totalsize;
+	 *	tmp = 0x80000000;
+	 *	while (! invsize & tmp) {
+	 *		tmp >>= 1;
+	 *	}
+	 *	invsize = tmp;
+	 * }
+	 * d1 = invsize
+	 */
+	cmp	d2,d1
+	bns	2f
+	mov	d2,d1
+
+	mov	0x80000000,d0		# start from 31bit=1
+	setlb
+	lsr	1,d0
+	mov	d0,e0
+	and	d1,e0
+	leq
+	mov	d0,d1
+
+2:
+	/* set mask
+	 *
+	 * mask = ~(invsize-1);
+	 * DCPGMR = mask;
+	 */
+	mov	d1,d0
+	add	-1,d0
+	not	d0
+	mov	d0,(DCPGMR)
+
+	# invalidate area
+	mov	a2,d0
+	or	DCPGCR_DCI,d0
+	mov	d0,(a0)			# DCPGCR = (mask & start) | DCPGCR_DCI
+
+	setlb				# wait for the purge to complete
+	mov	(a0),d0
+	btst	DCPGCR_DCPGBSY,d0
+	lne
+
+	sub	d1,d2			# decrease size remaining
+	add	d1,a2			# increase next start address
+
+	/* check invalidating of end address
+	 *
+	 * a2 = a2 + invsize
+	 * if (a2 < end) {
+	 *     goto dcivloop;
+	 * } */
+	cmp	a1,a2
+	bns	dcivloop
+
+	LOCAL_IRQ_RESTORE(d3)
+
+mn10300_local_dcache_inv_range_end:
+	ret	[d2,d3,a2],12
+	.size	mn10300_local_dcache_inv_page,.-mn10300_local_dcache_inv_page
+	.size	mn10300_local_dcache_inv_range,.-mn10300_local_dcache_inv_range
+	.size	mn10300_local_dcache_inv_range2,.-mn10300_local_dcache_inv_range2
+
+###############################################################################
+#
+# void mn10300_local_icache_inv_page(unsigned long start)
+# void mn10300_local_icache_inv_range2(unsigned long start, unsigned long size)
+# void mn10300_local_icache_inv_range(unsigned long start, unsigned long end)
+# Invalidate a range of addresses on a page in the icache
+#
+###############################################################################
+	ALIGN
+	.globl	mn10300_local_icache_inv_page
+	.globl	mn10300_local_icache_inv_range
+	.globl	mn10300_local_icache_inv_range2
+	.type	mn10300_local_icache_inv_page,@function
+	.type	mn10300_local_icache_inv_range,@function
+	.type	mn10300_local_icache_inv_range2,@function
+mn10300_local_icache_inv_page:
+	and	~(PAGE_SIZE-1),d0
+	mov	PAGE_SIZE,d1
+mn10300_local_icache_inv_range2:
+	add	d0,d1
+mn10300_local_icache_inv_range:
+	movm	[d2,d3,a2],(sp)
+
+	mov	CHCTR,a0
+	movhu	(a0),d2
+	btst	CHCTR_ICEN,d2
+	beq	mn10300_local_icache_inv_range_reg_end
+
+	/* calculate alignsize
+	 *
+	 * alignsize = L1_CACHE_BYTES;
+	 * for (i = (end - start - 1) / L1_CACHE_BYTES ;  i > 0; i >>= 1) {
+	 *     alignsize <<= 1;
+	 * }
+	 * d2 = alignsize;
+	 */
+	mov	L1_CACHE_BYTES,d2
+	sub	d0,d1,d3
+	add	-1,d3
+	lsr	L1_CACHE_SHIFT,d3
+	beq	2f
+1:
+	add	d2,d2
+	lsr	1,d3
+	bne	1b
+2:
+
+	/* a1 = end */
+	mov	d1,a1
+
+	LOCAL_CLI_SAVE(d3)
+
+	mov	ICIVCR,a0
+	/* wait for busy bit of area invalidation */
+	setlb
+	mov	(a0),d1
+	btst	ICIVCR_ICIVBSY,d1
+	lne
+
+	/* set mask
+	 *
+	 * mask = ~(alignsize-1);
+	 * ICIVMR = mask;
+	 */
+	mov	d2,d1
+	add	-1,d1
+	not	d1
+	mov	d1,(ICIVMR)
+	/* a2 = mask & start */
+	and	d1,d0,a2
+
+icivloop:
+	/* area invalidate
+	 *
+	 * ICIVCR = (mask & start) | ICIVCR_ICI
+	 */
+	mov	a2,d0
+	or	ICIVCR_ICI,d0
+	mov	d0,(a0)
+
+	/* wait for busy bit of area invalidation */
+	setlb
+	mov	(a0),d1
+	btst	ICIVCR_ICIVBSY,d1
+	lne
+
+	/* check invalidating of end address
+	 *
+	 * a2 = a2 + alignsize
+	 * if (a2 < end) {
+	 *     goto icivloop;
+	 * } */
+	add	d2,a2
+	cmp	a1,a2
+	bns	icivloop
+
+	LOCAL_IRQ_RESTORE(d3)
+
+mn10300_local_icache_inv_range_reg_end:
+	ret	[d2,d3,a2],12
+	.size	mn10300_local_icache_inv_page,.-mn10300_local_icache_inv_page
+	.size	mn10300_local_icache_inv_range,.-mn10300_local_icache_inv_range
+	.size	mn10300_local_icache_inv_range2,.-mn10300_local_icache_inv_range2

