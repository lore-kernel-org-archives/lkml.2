Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759171Ab0JZCzB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 22:55:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48341 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759083Ab0JZCy7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 22:54:59 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH 20/43] MN10300: SMP: Differentiate local cache flushing
To: linux-am33-list@redhat.com
From: David Howells <dhowells@redhat.com>
Cc: linux-kernel@vger.kernel.org,
        Akira Takeuchi <takeuchi.akr@jp.panasonic.com>,
        Kiyoshi Owada <owada.kiyoshi@jp.panasonic.com>
Date: Tue, 26 Oct 2010 03:54:48 +0100
Message-ID: <20101026025448.23512.94942.stgit@warthog.procyon.org.uk>
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

Differentiate local cache flushing from global cache flushing so that they can
be done differently on SMP systems.

Rename the cache functions from:

	mn10300_[id]cache_*()

to:

	mn10300_[id]_localcache_*()

and on a UP system, assign the global labels to the local labels.

Signed-off-by: Akira Takeuchi <takeuchi.akr@jp.panasonic.com>
Signed-off-by: Kiyoshi Owada <owada.kiyoshi@jp.panasonic.com>
Signed-off-by: David Howells <dhowells@redhat.com>
---

 arch/mn10300/include/asm/cacheflush.h            |   50 ++++++
 arch/mn10300/mm/cache-flush-by-tag.S             |  143 +++++++++++-----
 arch/mn10300/mm/cache-inv-by-tag.S               |  199 ++++++++++++++--------
 arch/mn10300/proc-mn103e010/include/proc/cache.h |    9 +
 4 files changed, 289 insertions(+), 112 deletions(-)


diff --git a/arch/mn10300/include/asm/cacheflush.h b/arch/mn10300/include/asm/cacheflush.h
index a9f4168..748143f 100644
--- a/arch/mn10300/include/asm/cacheflush.h
+++ b/arch/mn10300/include/asm/cacheflush.h
@@ -20,12 +20,31 @@
  * Primitive routines
  */
 #ifdef CONFIG_MN10300_CACHE_ENABLED
+extern void mn10300_local_icache_inv(void);
+extern void mn10300_local_icache_inv_page(unsigned long start);
+extern void mn10300_local_icache_inv_range(unsigned long start, unsigned long end);
+extern void mn10300_local_icache_inv_range2(unsigned long start, unsigned long size);
+extern void mn10300_local_dcache_inv(void);
+extern void mn10300_local_dcache_inv_page(unsigned long start);
+extern void mn10300_local_dcache_inv_range(unsigned long start, unsigned long end);
+extern void mn10300_local_dcache_inv_range2(unsigned long start, unsigned long size);
 extern void mn10300_icache_inv(void);
+extern void mn10300_icache_inv_page(unsigned long start);
+extern void mn10300_icache_inv_range(unsigned long start, unsigned long end);
+extern void mn10300_icache_inv_range2(unsigned long start, unsigned long size);
 extern void mn10300_dcache_inv(void);
 extern void mn10300_dcache_inv_page(unsigned long start);
 extern void mn10300_dcache_inv_range(unsigned long start, unsigned long end);
 extern void mn10300_dcache_inv_range2(unsigned long start, unsigned long size);
 #ifdef CONFIG_MN10300_CACHE_WBACK
+extern void mn10300_local_dcache_flush(void);
+extern void mn10300_local_dcache_flush_page(unsigned long start);
+extern void mn10300_local_dcache_flush_range(unsigned long start, unsigned long end);
+extern void mn10300_local_dcache_flush_range2(unsigned long start, unsigned long size);
+extern void mn10300_local_dcache_flush_inv(void);
+extern void mn10300_local_dcache_flush_inv_page(unsigned long start);
+extern void mn10300_local_dcache_flush_inv_range(unsigned long start, unsigned long end);
+extern void mn10300_local_dcache_flush_inv_range2(unsigned long start, unsigned long size);
 extern void mn10300_dcache_flush(void);
 extern void mn10300_dcache_flush_page(unsigned long start);
 extern void mn10300_dcache_flush_range(unsigned long start, unsigned long end);
@@ -35,6 +54,18 @@ extern void mn10300_dcache_flush_inv_page(unsigned long start);
 extern void mn10300_dcache_flush_inv_range(unsigned long start, unsigned long end);
 extern void mn10300_dcache_flush_inv_range2(unsigned long start, unsigned long size);
 #else
+#define mn10300_local_dcache_flush()			do {} while (0)
+#define mn10300_local_dcache_flush_page(start)		do {} while (0)
+#define mn10300_local_dcache_flush_range(start, end)	do {} while (0)
+#define mn10300_local_dcache_flush_range2(start, size)	do {} while (0)
+#define mn10300_local_dcache_flush_inv() \
+		mn10300_local_dcache_inv()
+#define mn10300_local_dcache_flush_inv_page(start) \
+		mn10300_local_dcache_inv_page(start)
+#define mn10300_local_dcache_flush_inv_range(start, end) \
+		mn10300_local_dcache_inv_range(start, end)
+#define mn10300_local_dcache_flush_inv_range2(start, size) \
+		mn10300_local_dcache_inv_range2(start, size)
 #define mn10300_dcache_flush()				do {} while (0)
 #define mn10300_dcache_flush_page(start)		do {} while (0)
 #define mn10300_dcache_flush_range(start, end)		do {} while (0)
@@ -48,7 +79,26 @@ extern void mn10300_dcache_flush_inv_range2(unsigned long start, unsigned long s
 	mn10300_dcache_inv_range2((start), (size))
 #endif /* CONFIG_MN10300_CACHE_WBACK */
 #else
+#define mn10300_local_icache_inv()			do {} while (0)
+#define mn10300_local_icache_inv_page(start)		do {} while (0)
+#define mn10300_local_icache_inv_range(start, end)	do {} while (0)
+#define mn10300_local_icache_inv_range2(start, size)	do {} while (0)
+#define mn10300_local_dcache_inv()			do {} while (0)
+#define mn10300_local_dcache_inv_page(start)		do {} while (0)
+#define mn10300_local_dcache_inv_range(start, end)	do {} while (0)
+#define mn10300_local_dcache_inv_range2(start, size)	do {} while (0)
+#define mn10300_local_dcache_flush()			do {} while (0)
+#define mn10300_local_dcache_flush_inv_page(start)	do {} while (0)
+#define mn10300_local_dcache_flush_inv()		do {} while (0)
+#define mn10300_local_dcache_flush_inv_range(start, end)do {} while (0)
+#define mn10300_local_dcache_flush_inv_range2(start, size) do {} while (0)
+#define mn10300_local_dcache_flush_page(start)		do {} while (0)
+#define mn10300_local_dcache_flush_range(start, end)	do {} while (0)
+#define mn10300_local_dcache_flush_range2(start, size)	do {} while (0)
 #define mn10300_icache_inv()				do {} while (0)
+#define mn10300_icache_inv_page(start)			do {} while (0)
+#define mn10300_icache_inv_range(start, end)		do {} while (0)
+#define mn10300_icache_inv_range2(start, size)		do {} while (0)
 #define mn10300_dcache_inv()				do {} while (0)
 #define mn10300_dcache_inv_page(start)			do {} while (0)
 #define mn10300_dcache_inv_range(start, end)		do {} while (0)
diff --git a/arch/mn10300/mm/cache-flush-by-tag.S b/arch/mn10300/mm/cache-flush-by-tag.S
index 8fe90e4..5cd6a27 100644
--- a/arch/mn10300/mm/cache-flush-by-tag.S
+++ b/arch/mn10300/mm/cache-flush-by-tag.S
@@ -1,4 +1,4 @@
-/* MN10300 CPU core caching routines
+/* MN10300 CPU core caching routines, using direct tag flushing
  *
  * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
  * Written by David Howells (dhowells@redhat.com)
@@ -14,8 +14,11 @@
 #include <asm/smp.h>
 #include <asm/page.h>
 #include <asm/cache.h>
+#include <asm/irqflags.h>
 
 	.am33_2
+
+#ifndef CONFIG_SMP
 	.globl mn10300_dcache_flush
 	.globl mn10300_dcache_flush_page
 	.globl mn10300_dcache_flush_range
@@ -25,17 +28,30 @@
 	.globl mn10300_dcache_flush_inv_range
 	.globl mn10300_dcache_flush_inv_range2
 
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
 ###############################################################################
 #
-# void mn10300_dcache_flush(void)
+# void mn10300_local_dcache_flush(void)
 # Flush the entire data cache back to RAM
 #
 ###############################################################################
 	ALIGN
-mn10300_dcache_flush:
+	.globl	mn10300_local_dcache_flush
+        .type	mn10300_local_dcache_flush,@function
+mn10300_local_dcache_flush:
 	movhu	(CHCTR),d0
 	btst	CHCTR_DCEN,d0
-	beq	mn10300_dcache_flush_end
+	beq	mn10300_local_dcache_flush_end
 
 	# read the addresses tagged in the cache's tag RAM and attempt to flush
 	# those addresses specifically
@@ -44,41 +60,56 @@ mn10300_dcache_flush:
 	mov	DCACHE_PURGE(0,0),a1		# dcache purge request address
 	mov	L1_CACHE_NWAYS*L1_CACHE_NENTRIES,d1  # total number of entries
 
-mn10300_dcache_flush_loop:
+mn10300_local_dcache_flush_loop:
 	mov	(a0),d0
 	and	L1_CACHE_TAG_ADDRESS|L1_CACHE_TAG_ENTRY,d0
 	or	L1_CACHE_TAG_VALID,d0		# retain valid entries in the
 						# cache
 	mov	d0,(a1)				# conditional purge
 
-mn10300_dcache_flush_skip:
 	add	L1_CACHE_BYTES,a0
 	add	L1_CACHE_BYTES,a1
 	add	-1,d1
-	bne	mn10300_dcache_flush_loop
+	bne	mn10300_local_dcache_flush_loop
 
-mn10300_dcache_flush_end:
+mn10300_local_dcache_flush_end:
 	ret	[],0
+	.size	mn10300_local_dcache_flush,.-mn10300_local_dcache_flush
 
 ###############################################################################
 #
-# void mn10300_dcache_flush_page(unsigned long start)
-# void mn10300_dcache_flush_range(unsigned long start, unsigned long end)
-# void mn10300_dcache_flush_range2(unsigned long start, unsigned long size)
+# void mn10300_local_dcache_flush_page(unsigned long start)
+# void mn10300_local_dcache_flush_range(unsigned long start, unsigned long end)
+# void mn10300_local_dcache_flush_range2(unsigned long start, unsigned long size)
 # Flush a range of addresses on a page in the dcache
 #
 ###############################################################################
 	ALIGN
-mn10300_dcache_flush_page:
+	.globl	mn10300_local_dcache_flush_page
+	.globl	mn10300_local_dcache_flush_range
+	.globl	mn10300_local_dcache_flush_range2
+	.type	mn10300_local_dcache_flush_page,@function
+	.type	mn10300_local_dcache_flush_range,@function
+	.type	mn10300_local_dcache_flush_range2,@function
+mn10300_local_dcache_flush_page:
+	and	~(PAGE_SIZE-1),d0
 	mov	PAGE_SIZE,d1
-mn10300_dcache_flush_range2:
+mn10300_local_dcache_flush_range2:
 	add	d0,d1
-mn10300_dcache_flush_range:
-	movm	[d2,d3],(sp)
+mn10300_local_dcache_flush_range:
+	movm	[d2],(sp)
 
 	movhu	(CHCTR),d2
 	btst	CHCTR_DCEN,d2
-	beq	mn10300_dcache_flush_range_end
+	beq	mn10300_local_dcache_flush_range_end
+
+	sub	d0,d1,a0
+	cmp	MN10300_DCACHE_FLUSH_BORDER,a0
+	ble	1f
+
+	movm	(sp),[d2]
+	bra	mn10300_local_dcache_flush
+1:
 
 	# round start addr down
 	and	L1_CACHE_TAG_ADDRESS|L1_CACHE_TAG_ENTRY,d0
@@ -101,7 +132,7 @@ mn10300_dcache_flush_range:
 	or	L1_CACHE_TAG_VALID,a1		# retain valid entries in the
 						# cache
 
-mn10300_dcache_flush_range_loop:
+mn10300_local_dcache_flush_range_loop:
 	mov	a1,(L1_CACHE_WAYDISP*0,a0)	# conditionally purge this line
 						# all ways
 
@@ -109,55 +140,80 @@ mn10300_dcache_flush_range_loop:
 	add	L1_CACHE_BYTES,a1
 	and	~L1_CACHE_WAYDISP,a0		# make sure way stay on way 0
 	add	-1,d1
-	bne	mn10300_dcache_flush_range_loop
+	bne	mn10300_local_dcache_flush_range_loop
+
+mn10300_local_dcache_flush_range_end:
+	ret	[d2],4
 
-mn10300_dcache_flush_range_end:
-	ret	[d2,d3],8
+	.size	mn10300_local_dcache_flush_page,.-mn10300_local_dcache_flush_page
+	.size	mn10300_local_dcache_flush_range,.-mn10300_local_dcache_flush_range
+	.size	mn10300_local_dcache_flush_range2,.-mn10300_local_dcache_flush_range2
 
 ###############################################################################
 #
-# void mn10300_dcache_flush_inv(void)
+# void mn10300_local_dcache_flush_inv(void)
 # Flush the entire data cache and invalidate all entries
 #
 ###############################################################################
 	ALIGN
-mn10300_dcache_flush_inv:
+	.globl	mn10300_local_dcache_flush_inv
+	.type	mn10300_local_dcache_flush_inv,@function
+mn10300_local_dcache_flush_inv:
 	movhu	(CHCTR),d0
 	btst	CHCTR_DCEN,d0
-	beq	mn10300_dcache_flush_inv_end
+	beq	mn10300_local_dcache_flush_inv_end
 
-	# hit each line in the dcache with an unconditional purge
-	mov	DCACHE_PURGE(0,0),a1		# dcache purge request address
-	mov	L1_CACHE_NWAYS*L1_CACHE_NENTRIES,d1  # total number of entries
+	mov	L1_CACHE_NENTRIES,d1
+	clr	a1
 
-mn10300_dcache_flush_inv_loop:
-	mov	(a1),d0				# unconditional purge
+mn10300_local_dcache_flush_inv_loop:
+	mov	(DCACHE_PURGE_WAY0(0),a1),d0	# unconditional purge
+	mov	(DCACHE_PURGE_WAY1(0),a1),d0	# unconditional purge
+	mov	(DCACHE_PURGE_WAY2(0),a1),d0	# unconditional purge
+	mov	(DCACHE_PURGE_WAY3(0),a1),d0	# unconditional purge
 
 	add	L1_CACHE_BYTES,a1
 	add	-1,d1
-	bne	mn10300_dcache_flush_inv_loop
+	bne	mn10300_local_dcache_flush_inv_loop
 
-mn10300_dcache_flush_inv_end:
+mn10300_local_dcache_flush_inv_end:
 	ret	[],0
+	.size	mn10300_local_dcache_flush_inv,.-mn10300_local_dcache_flush_inv
 
 ###############################################################################
 #
-# void mn10300_dcache_flush_inv_page(unsigned long start)
-# void mn10300_dcache_flush_inv_range(unsigned long start, unsigned long end)
-# void mn10300_dcache_flush_inv_range2(unsigned long start, unsigned long size)
+# void mn10300_local_dcache_flush_inv_page(unsigned long start)
+# void mn10300_local_dcache_flush_inv_range(unsigned long start, unsigned long end)
+# void mn10300_local_dcache_flush_inv_range2(unsigned long start, unsigned long size)
 # Flush and invalidate a range of addresses on a page in the dcache
 #
 ###############################################################################
 	ALIGN
-mn10300_dcache_flush_inv_page:
+	.globl	mn10300_local_dcache_flush_inv_page
+	.globl	mn10300_local_dcache_flush_inv_range
+	.globl	mn10300_local_dcache_flush_inv_range2
+	.type	mn10300_local_dcache_flush_inv_page,@function
+	.type	mn10300_local_dcache_flush_inv_range,@function
+	.type	mn10300_local_dcache_flush_inv_range2,@function
+mn10300_local_dcache_flush_inv_page:
+	and	~(PAGE_SIZE-1),d0
 	mov	PAGE_SIZE,d1
-mn10300_dcache_flush_inv_range2:
+mn10300_local_dcache_flush_inv_range2:
 	add	d0,d1
-mn10300_dcache_flush_inv_range:
-	movm	[d2,d3],(sp)
+mn10300_local_dcache_flush_inv_range:
+	movm	[d2],(sp)
+
 	movhu	(CHCTR),d2
 	btst	CHCTR_DCEN,d2
-	beq	mn10300_dcache_flush_inv_range_end
+	beq	mn10300_local_dcache_flush_inv_range_end
+
+	sub	d0,d1,a0
+	cmp	MN10300_DCACHE_FLUSH_INV_BORDER,a0
+	ble	1f
+
+	movm	(sp),[d2]
+	bra	mn10300_local_dcache_flush_inv
+1:
 
 	and	L1_CACHE_TAG_ADDRESS|L1_CACHE_TAG_ENTRY,d0	# round start
 								# addr down
@@ -178,7 +234,7 @@ mn10300_dcache_flush_inv_range:
 	lsr	L1_CACHE_SHIFT,d1		# total number of entries to
 						# examine
 
-mn10300_dcache_flush_inv_range_loop:
+mn10300_local_dcache_flush_inv_range_loop:
 	mov	a1,(L1_CACHE_WAYDISP*0,a0)	# conditionally purge this line
 						# in all ways
 
@@ -186,7 +242,10 @@ mn10300_dcache_flush_inv_range_loop:
 	add	L1_CACHE_BYTES,a1
 	and	~L1_CACHE_WAYDISP,a0		# make sure way stay on way 0
 	add	-1,d1
-	bne	mn10300_dcache_flush_inv_range_loop
+	bne	mn10300_local_dcache_flush_inv_range_loop
 
-mn10300_dcache_flush_inv_range_end:
-	ret	[d2,d3],8
+mn10300_local_dcache_flush_inv_range_end:
+	ret	[d2],4
+	.size	mn10300_local_dcache_flush_inv_page,.-mn10300_local_dcache_flush_inv_page
+	.size	mn10300_local_dcache_flush_inv_range,.-mn10300_local_dcache_flush_inv_range
+	.size	mn10300_local_dcache_flush_inv_range2,.-mn10300_local_dcache_flush_inv_range2
diff --git a/arch/mn10300/mm/cache-inv-by-tag.S b/arch/mn10300/mm/cache-inv-by-tag.S
index e839d0a..e9713b4 100644
--- a/arch/mn10300/mm/cache-inv-by-tag.S
+++ b/arch/mn10300/mm/cache-inv-by-tag.S
@@ -13,40 +13,65 @@
 #include <asm/smp.h>
 #include <asm/page.h>
 #include <asm/cache.h>
+#include <asm/irqflags.h>
+#include <asm/cacheflush.h>
 
-#define mn10300_dcache_inv_range_intr_interval \
+#define mn10300_local_dcache_inv_range_intr_interval \
 	+((1 << MN10300_DCACHE_INV_RANGE_INTR_LOG2_INTERVAL) - 1)
 
-#if mn10300_dcache_inv_range_intr_interval > 0xff
+#if mn10300_local_dcache_inv_range_intr_interval > 0xff
 #error MN10300_DCACHE_INV_RANGE_INTR_LOG2_INTERVAL must be 8 or less
 #endif
 
 	.am33_2
 
-	.globl mn10300_icache_inv
-	.globl mn10300_dcache_inv
-	.globl mn10300_dcache_inv_range
-	.globl mn10300_dcache_inv_range2
-	.globl mn10300_dcache_inv_page
+	.globl	mn10300_local_icache_inv_page
+	.globl	mn10300_local_icache_inv_range
+	.globl	mn10300_local_icache_inv_range2
+
+mn10300_local_icache_inv_page	= mn10300_local_icache_inv
+mn10300_local_icache_inv_range	= mn10300_local_icache_inv
+mn10300_local_icache_inv_range2	= mn10300_local_icache_inv
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
 
 ###############################################################################
 #
-# void mn10300_icache_inv(void)
+# void mn10300_local_icache_inv(void)
 # Invalidate the entire icache
 #
 ###############################################################################
 	ALIGN
-mn10300_icache_inv:
+	.globl	mn10300_local_icache_inv
+        .type	mn10300_local_icache_inv,@function
+mn10300_local_icache_inv:
 	mov	CHCTR,a0
 
 	movhu	(a0),d0
 	btst	CHCTR_ICEN,d0
-	beq	mn10300_icache_inv_end
+	beq	mn10300_local_icache_inv_end
 
-	mov	epsw,d1
-	and	~EPSW_IE,epsw
-	nop
-	nop
+#if defined(CONFIG_AM33_2) || defined(CONFIG_AM33_3)
+	LOCAL_CLI_SAVE(d1)
 
 	# disable the icache
 	and	~CHCTR_ICEN,d0
@@ -75,29 +100,36 @@ mn10300_icache_inv:
 	movhu	d0,(a0)
 	movhu	(a0),d0
 
-	mov	d1,epsw
+	LOCAL_IRQ_RESTORE(d1)
+#else /* CONFIG_AM33_2 || CONFIG_AM33_3 */
+	# invalidate
+	or	CHCTR_ICINV,d0
+	movhu	d0,(a0)
+	movhu	(a0),d0
+#endif /* CONFIG_AM33_2 || CONFIG_AM33_3 */
 
-mn10300_icache_inv_end:
+mn10300_local_icache_inv_end:
 	ret	[],0
+	.size	mn10300_local_icache_inv,.-mn10300_local_icache_inv
 
 ###############################################################################
 #
-# void mn10300_dcache_inv(void)
+# void mn10300_local_dcache_inv(void)
 # Invalidate the entire dcache
 #
 ###############################################################################
 	ALIGN
-mn10300_dcache_inv:
+	.globl	mn10300_local_dcache_inv
+	.type	mn10300_local_dcache_inv,@function
+mn10300_local_dcache_inv:
 	mov	CHCTR,a0
 
 	movhu	(a0),d0
 	btst	CHCTR_DCEN,d0
-	beq	mn10300_dcache_inv_end
+	beq	mn10300_local_dcache_inv_end
 
-	mov	epsw,d1
-	and	~EPSW_IE,epsw
-	nop
-	nop
+#if defined(CONFIG_AM33_2) || defined(CONFIG_AM33_3)
+	LOCAL_CLI_SAVE(d1)
 
 	# disable the dcache
 	and	~CHCTR_DCEN,d0
@@ -126,40 +158,69 @@ mn10300_dcache_inv:
 	movhu	d0,(a0)
 	movhu	(a0),d0
 
-	mov	d1,epsw
+	LOCAL_IRQ_RESTORE(d1)
+#else /* CONFIG_AM33_2 || CONFIG_AM33_3 */
+	# invalidate
+	or	CHCTR_DCINV,d0
+	movhu	d0,(a0)
+	movhu	(a0),d0
+#endif /* CONFIG_AM33_2 || CONFIG_AM33_3 */
 
-mn10300_dcache_inv_end:
+mn10300_local_dcache_inv_end:
 	ret	[],0
+	.size	mn10300_local_dcache_inv,.-mn10300_local_dcache_inv
 
 ###############################################################################
 #
-# void mn10300_dcache_inv_range(unsigned start, unsigned end)
-# void mn10300_dcache_inv_range2(unsigned start, unsigned size)
-# void mn10300_dcache_inv_page(unsigned start)
+# void mn10300_local_dcache_inv_range(unsigned long start, unsigned long end)
+# void mn10300_local_dcache_inv_range2(unsigned long start, unsigned long size)
+# void mn10300_local_dcache_inv_page(unsigned long start)
 # Invalidate a range of addresses on a page in the dcache
 #
 ###############################################################################
 	ALIGN
-mn10300_dcache_inv_page:
+	.globl	mn10300_local_dcache_inv_page
+	.globl	mn10300_local_dcache_inv_range
+	.globl	mn10300_local_dcache_inv_range2
+	.type	mn10300_local_dcache_inv_page,@function
+	.type	mn10300_local_dcache_inv_range,@function
+	.type	mn10300_local_dcache_inv_range2,@function
+mn10300_local_dcache_inv_page:
+	and	~(PAGE_SIZE-1),d0
 	mov	PAGE_SIZE,d1
-mn10300_dcache_inv_range2:
+mn10300_local_dcache_inv_range2:
 	add	d0,d1
-mn10300_dcache_inv_range:
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
 	movm	[d2,d3,a2],(sp)
-	mov	CHCTR,a2
 
+	mov	CHCTR,a2
 	movhu	(a2),d2
 	btst	CHCTR_DCEN,d2
-	beq	mn10300_dcache_inv_range_end
+	beq	mn10300_local_dcache_inv_range_end
 
+#ifndef CONFIG_MN10300_CACHE_WBACK
 	and	L1_CACHE_TAG_ADDRESS|L1_CACHE_TAG_ENTRY,d0	# round start
 								# addr down
-	mov	d0,a1
 
-	add	L1_CACHE_BYTES,d1			# round end addr up
+	add	L1_CACHE_BYTES,d1		# round end addr up
 	and	L1_CACHE_TAG_ADDRESS|L1_CACHE_TAG_ENTRY,d1
+#endif /* !CONFIG_MN10300_CACHE_WBACK */
+	mov	d0,a1
 
-	clr	d2				# we're going to clear tag ram
+	clr	d2				# we're going to clear tag RAM
 						# entries
 
 	# read the tags from the tag RAM, and if they indicate a valid dirty
@@ -176,14 +237,8 @@ mn10300_dcache_inv_range:
 
 	and	~(L1_CACHE_DISPARITY-1),a1	# determine comparator base
 
-mn10300_dcache_inv_range_outer_loop:
-	# disable interrupts
-	mov	epsw,d3
-	and	~EPSW_IE,epsw
-	nop					# note that reading CHCTR and
-						# AND'ing D0 occupy two delay
-						# slots after disabling
-						# interrupts
+mn10300_local_dcache_inv_range_outer_loop:
+	LOCAL_CLI_SAVE(d3)
 
 	# disable the dcache
 	movhu	(a2),d0
@@ -196,63 +251,63 @@ mn10300_dcache_inv_range_outer_loop:
 	btst	CHCTR_DCBUSY,d0
 	lne
 
-mn10300_dcache_inv_range_loop:
+mn10300_local_dcache_inv_range_loop:
 
 	# process the way 0 slot
 	mov	(L1_CACHE_WAYDISP*0,a0),d0	# read the tag in the way 0 slot
 	btst	L1_CACHE_TAG_VALID,d0
-	beq	mn10300_dcache_inv_range_skip_0	# jump if this cacheline is not
-						# valid
+	beq	mn10300_local_dcache_inv_range_skip_0	# jump if this cacheline
+						# is not valid
 
 	xor	a1,d0
 	lsr	12,d0
-	bne	mn10300_dcache_inv_range_skip_0	# jump if not this cacheline
+	bne	mn10300_local_dcache_inv_range_skip_0	# jump if not this cacheline
 
-	mov	d2,(a0)				# kill the tag
+	mov	d2,(L1_CACHE_WAYDISP*0,a0)	# kill the tag
 
-mn10300_dcache_inv_range_skip_0:
+mn10300_local_dcache_inv_range_skip_0:
 
 	# process the way 1 slot
 	mov	(L1_CACHE_WAYDISP*1,a0),d0	# read the tag in the way 1 slot
 	btst	L1_CACHE_TAG_VALID,d0
-	beq	mn10300_dcache_inv_range_skip_1	# jump if this cacheline is not
-						# valid
+	beq	mn10300_local_dcache_inv_range_skip_1	# jump if this cacheline
+						# is not valid
 
 	xor	a1,d0
 	lsr	12,d0
-	bne	mn10300_dcache_inv_range_skip_1	# jump if not this cacheline
+	bne	mn10300_local_dcache_inv_range_skip_1	# jump if not this cacheline
 
-	mov	d2,(a0)				# kill the tag
+	mov	d2,(L1_CACHE_WAYDISP*1,a0)	# kill the tag
 
-mn10300_dcache_inv_range_skip_1:
+mn10300_local_dcache_inv_range_skip_1:
 
 	# process the way 2 slot
 	mov	(L1_CACHE_WAYDISP*2,a0),d0	# read the tag in the way 2 slot
 	btst	L1_CACHE_TAG_VALID,d0
-	beq	mn10300_dcache_inv_range_skip_2	# jump if this cacheline is not
-						# valid
+	beq	mn10300_local_dcache_inv_range_skip_2	# jump if this cacheline
+						# is not valid
 
 	xor	a1,d0
 	lsr	12,d0
-	bne	mn10300_dcache_inv_range_skip_2	# jump if not this cacheline
+	bne	mn10300_local_dcache_inv_range_skip_2	# jump if not this cacheline
 
-	mov	d2,(a0)				# kill the tag
+	mov	d2,(L1_CACHE_WAYDISP*2,a0)	# kill the tag
 
-mn10300_dcache_inv_range_skip_2:
+mn10300_local_dcache_inv_range_skip_2:
 
 	# process the way 3 slot
 	mov	(L1_CACHE_WAYDISP*3,a0),d0	# read the tag in the way 3 slot
 	btst	L1_CACHE_TAG_VALID,d0
-	beq	mn10300_dcache_inv_range_skip_3	# jump if this cacheline is not
-						# valid
+	beq	mn10300_local_dcache_inv_range_skip_3	# jump if this cacheline
+						# is not valid
 
 	xor	a1,d0
 	lsr	12,d0
-	bne	mn10300_dcache_inv_range_skip_3	# jump if not this cacheline
+	bne	mn10300_local_dcache_inv_range_skip_3	# jump if not this cacheline
 
-	mov	d2,(a0)				# kill the tag
+	mov	d2,(L1_CACHE_WAYDISP*3,a0)	# kill the tag
 
-mn10300_dcache_inv_range_skip_3:
+mn10300_local_dcache_inv_range_skip_3:
 
 	# approx every N steps we re-enable the cache and see if there are any
 	# interrupts to be processed
@@ -260,9 +315,10 @@ mn10300_dcache_inv_range_skip_3:
 	# (the bottom nibble of the count is zero in both cases)
 	add	L1_CACHE_BYTES,a0
 	add	L1_CACHE_BYTES,a1
+	and	~L1_CACHE_WAYDISP,a0
 	add	-1,d1
-	btst	mn10300_dcache_inv_range_intr_interval,d1
-	bne	mn10300_dcache_inv_range_loop
+	btst	mn10300_local_dcache_inv_range_intr_interval,d1
+	bne	mn10300_local_dcache_inv_range_loop
 
 	# wait for the cache to finish what it's doing
 	setlb
@@ -279,11 +335,14 @@ mn10300_dcache_inv_range_skip_3:
 	# - we don't bother with delay NOPs as we'll have enough instructions
 	#   before we disable interrupts again to give the interrupts a chance
 	#   to happen
-	mov	d3,epsw
+	LOCAL_IRQ_RESTORE(d3)
 
 	# go around again if the counter hasn't yet reached zero
 	add	0,d1
-	bne	mn10300_dcache_inv_range_outer_loop
+	bne	mn10300_local_dcache_inv_range_outer_loop
 
-mn10300_dcache_inv_range_end:
+mn10300_local_dcache_inv_range_end:
 	ret	[d2,d3,a2],12
+	.size	mn10300_local_dcache_inv_page,.-mn10300_local_dcache_inv_page
+	.size	mn10300_local_dcache_inv_range,.-mn10300_local_dcache_inv_range
+	.size	mn10300_local_dcache_inv_range2,.-mn10300_local_dcache_inv_range2
diff --git a/arch/mn10300/proc-mn103e010/include/proc/cache.h b/arch/mn10300/proc-mn103e010/include/proc/cache.h
index bdc1f9a..c152800 100644
--- a/arch/mn10300/proc-mn103e010/include/proc/cache.h
+++ b/arch/mn10300/proc-mn103e010/include/proc/cache.h
@@ -30,4 +30,13 @@
  */
 #define MN10300_DCACHE_INV_RANGE_INTR_LOG2_INTERVAL	4
 
+/*
+ * The size of range at which it becomes more economical to just flush the
+ * whole cache rather than trying to flush the specified range.
+ */
+#define MN10300_DCACHE_FLUSH_BORDER	\
+	+(L1_CACHE_NWAYS * L1_CACHE_NENTRIES * L1_CACHE_BYTES)
+#define MN10300_DCACHE_FLUSH_INV_BORDER	\
+	+(L1_CACHE_NWAYS * L1_CACHE_NENTRIES * L1_CACHE_BYTES)
+
 #endif /* _ASM_PROC_CACHE_H */

