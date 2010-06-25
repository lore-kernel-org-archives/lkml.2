Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756462Ab0FYVLM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jun 2010 17:11:12 -0400
Received: from king.tilera.com ([72.1.168.226]:44209 "EHLO king.tilera.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756042Ab0FYVLC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jun 2010 17:11:02 -0400
Message-Id: <201006252110.o5PLArkc010773@farm-0002.internal.tilera.com>
To: linux-kernel@vger.kernel.org
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Fri, 25 Jun 2010 17:03:27 -0400
Subject: [PATCH] arch/tile: Split the icache flush code off to a generic <arch> header.
X-OriginalArrivalTime: 25 Jun 2010 21:10:53.0876 (UTC) FILETIME=[E5925740:01CB14AA]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This code is used in other places in our system than in Linux, so
to share it we now implement it as an inline function in our low-level
<arch> headers, and instantiate it in one file in Linux's arch/tile/lib.
The file is now cacheflush.c and is C code rather than the strangely-named
and assembler-implemented __invalidate_icache.S.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/include/arch/icache.h     |   94 +++++++++++++++++++++++++++++++
 arch/tile/include/asm/cacheflush.h  |    9 +--
 arch/tile/lib/Makefile              |    2 +-
 arch/tile/lib/__invalidate_icache.S |  106 -----------------------------------
 arch/tile/lib/cacheflush.c          |   23 ++++++++
 5 files changed, 120 insertions(+), 114 deletions(-)
 create mode 100644 arch/tile/include/arch/icache.h
 delete mode 100644 arch/tile/lib/__invalidate_icache.S
 create mode 100644 arch/tile/lib/cacheflush.c

diff --git a/arch/tile/include/arch/icache.h b/arch/tile/include/arch/icache.h
new file mode 100644
index 0000000..5c87c90
--- /dev/null
+++ b/arch/tile/include/arch/icache.h
@@ -0,0 +1,94 @@
+/*
+ * Copyright 2010 Tilera Corporation. All Rights Reserved.
+ *
+ *   This program is free software; you can redistribute it and/or
+ *   modify it under the terms of the GNU General Public License
+ *   as published by the Free Software Foundation, version 2.
+ *
+ *   This program is distributed in the hope that it will be useful, but
+ *   WITHOUT ANY WARRANTY; without even the implied warranty of
+ *   MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
+ *   NON INFRINGEMENT.  See the GNU General Public License for
+ *   more details.
+ *
+ */
+
+/**
+ * @file
+ *
+ * Support for invalidating bytes in the instruction
+ */
+
+#ifndef __ARCH_ICACHE_H__
+#define __ARCH_ICACHE_H__
+
+#include <arch/chip.h>
+
+
+/**
+ * Invalidate the instruction cache for the given range of memory.
+ *
+ * @param addr The start of memory to be invalidated.
+ * @param size The number of bytes to be invalidated.
+ * @param page_size The system's page size, typically the PAGE_SIZE constant
+ * in sys/page.h.  This value must be a power of two no larger
+ * than the page containing the code to be invalidated. If the value
+ * is smaller than the actual page size, this function will still
+ * work, but may run slower than necessary.
+ */
+static __inline void
+invalidate_icache(const void* addr, unsigned long size,
+                  unsigned long page_size)
+{
+  const unsigned long cache_way_size =
+    CHIP_L1I_CACHE_SIZE() / CHIP_L1I_ASSOC();
+  unsigned long max_useful_size;
+  const char* start, *end;
+  long num_passes;
+
+  if (__builtin_expect(size == 0, 0))
+    return;
+
+#ifdef __tilegx__
+  /* Limit the number of bytes visited to avoid redundant iterations. */
+  max_useful_size = (page_size < cache_way_size) ? page_size : cache_way_size;
+
+  /* No PA aliasing is possible, so one pass always suffices. */
+  num_passes = 1;
+#else
+  /* Limit the number of bytes visited to avoid redundant iterations. */
+  max_useful_size = cache_way_size;
+
+  /*
+   * Compute how many passes we need (we'll treat 0 as if it were 1).
+   * This works because we know the page size is a power of two.
+   */
+  num_passes = cache_way_size >> __builtin_ctzl(page_size);
+#endif
+
+  if (__builtin_expect(size > max_useful_size, 0))
+    size = max_useful_size;
+
+  /* Locate the first and last bytes to be invalidated. */
+  start = (const char *)((unsigned long)addr & -CHIP_L1I_LINE_SIZE());
+  end = (const char*)addr + size - 1;
+
+  __insn_mf();
+
+  do
+  {
+    const char* p;
+
+    for (p = start; p <= end; p += CHIP_L1I_LINE_SIZE())
+      __insn_icoh(p);
+
+    start += page_size;
+    end += page_size;
+  }
+  while (--num_passes > 0);
+
+  __insn_drain();
+}
+
+
+#endif /* __ARCH_ICACHE_H__ */
diff --git a/arch/tile/include/asm/cacheflush.h b/arch/tile/include/asm/cacheflush.h
index 7e2096a..c5741da 100644
--- a/arch/tile/include/asm/cacheflush.h
+++ b/arch/tile/include/asm/cacheflush.h
@@ -21,6 +21,7 @@
 #include <linux/mm.h>
 #include <linux/cache.h>
 #include <asm/system.h>
+#include <arch/icache.h>
 
 /* Caches are physically-indexed and so don't need special treatment */
 #define flush_cache_all()			do { } while (0)
@@ -37,14 +38,8 @@
 #define flush_icache_page(vma, pg)		do { } while (0)
 #define flush_icache_user_range(vma, pg, adr, len)	do { } while (0)
 
-/* See "arch/tile/lib/__invalidate_icache.S". */
-extern void __invalidate_icache(unsigned long start, unsigned long size);
-
 /* Flush the icache just on this cpu */
-static inline void __flush_icache_range(unsigned long start, unsigned long end)
-{
-	__invalidate_icache(start, end - start);
-}
+extern void __flush_icache_range(unsigned long start, unsigned long end);
 
 /* Flush the entire icache on this cpu. */
 #define __flush_icache() __flush_icache_range(0, CHIP_L1I_CACHE_SIZE())
diff --git a/arch/tile/lib/Makefile b/arch/tile/lib/Makefile
index ea9c209..438af38 100644
--- a/arch/tile/lib/Makefile
+++ b/arch/tile/lib/Makefile
@@ -2,7 +2,7 @@
 # Makefile for TILE-specific library files..
 #
 
-lib-y = checksum.o cpumask.o delay.o __invalidate_icache.o \
+lib-y = cacheflush.o checksum.o cpumask.o delay.o \
 	mb_incoherent.o uaccess.o \
 	memcpy_$(BITS).o memchr_$(BITS).o memmove_$(BITS).o memset_$(BITS).o \
 	strchr_$(BITS).o strlen_$(BITS).o
diff --git a/arch/tile/lib/__invalidate_icache.S b/arch/tile/lib/__invalidate_icache.S
deleted file mode 100644
index 92e7050..0000000
--- a/arch/tile/lib/__invalidate_icache.S
+++ /dev/null
@@ -1,106 +0,0 @@
-/*
- * Copyright 2010 Tilera Corporation. All Rights Reserved.
- *
- *   This program is free software; you can redistribute it and/or
- *   modify it under the terms of the GNU General Public License
- *   as published by the Free Software Foundation, version 2.
- *
- *   This program is distributed in the hope that it will be useful, but
- *   WITHOUT ANY WARRANTY; without even the implied warranty of
- *   MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
- *   NON INFRINGEMENT.  See the GNU General Public License for
- *   more details.
- * A routine for synchronizing the instruction and data caches.
- * Useful for self-modifying code.
- *
- * r0 holds the buffer address
- * r1 holds the size in bytes
- */
-
-#include <arch/chip.h>
-#include <feedback.h>
-
-#if defined(__NEWLIB__) || defined(__BME__)
-#include <sys/page.h>
-#else
-#include <asm/page.h>
-#endif
-
-#ifdef __tilegx__
-/* Share code among Tile family chips but adjust opcodes appropriately. */
-#define slt cmpltu
-#define bbst blbst
-#define bnezt bnzt
-#endif
-
-#if defined(__tilegx__) && __SIZEOF_POINTER__ == 4
-/* Force 32-bit ops so pointers wrap around appropriately. */
-#define ADD_PTR addx
-#define ADDI_PTR addxi
-#else
-#define ADD_PTR add
-#define ADDI_PTR addi
-#endif
-
-        .section .text.__invalidate_icache, "ax"
-        .global __invalidate_icache
-        .type __invalidate_icache,@function
-        .hidden __invalidate_icache
-        .align 8
-__invalidate_icache:
-        FEEDBACK_ENTER(__invalidate_icache)
-        {
-         ADD_PTR r1, r0, r1       /* end of buffer */
-         blez r1, .Lexit      /* skip out if size <= 0 */
-        }
-        {
-         ADDI_PTR r1, r1, -1      /* point to last byte to flush */
-         andi r0, r0, -CHIP_L1I_LINE_SIZE()  /* align to cache-line size */
-        }
-        {
-         andi r1, r1, -CHIP_L1I_LINE_SIZE()  /* last cache line to flush */
-         mf
-        }
-#if CHIP_L1I_CACHE_SIZE() > PAGE_SIZE
-        {
-         moveli r4, CHIP_L1I_CACHE_SIZE() / PAGE_SIZE  /* loop counter */
-         move r2, r0          /* remember starting address */
-        }
-#endif
-        drain
-	{
-         slt r3, r0, r1       /* set up loop invariant */
-#if CHIP_L1I_CACHE_SIZE() > PAGE_SIZE
-	 moveli r6, PAGE_SIZE
-#endif
-	}
-.Lentry:
-        {
-         icoh r0
-         ADDI_PTR r0, r0, CHIP_L1I_LINE_SIZE()   /* advance buffer */
-        }
-        {
-         slt r3, r0, r1       /* check if buffer < buffer + size */
-         bbst r3, .Lentry     /* loop if buffer < buffer + size */
-        }
-#if CHIP_L1I_CACHE_SIZE() > PAGE_SIZE
-        {
-         ADD_PTR r2, r2, r6
-         ADD_PTR r1, r1, r6
-        }
-	{
-         move r0, r2
-         addi r4, r4, -1
-	}
-	{
-         slt r3, r0, r1        /* set up loop invariant */
-         bnezt r4, .Lentry
-	}
-#endif
-        drain
-.Lexit:
-        jrp lr
-
-.Lend___invalidate_icache:
-        .size __invalidate_icache, \
-		.Lend___invalidate_icache - __invalidate_icache
diff --git a/arch/tile/lib/cacheflush.c b/arch/tile/lib/cacheflush.c
new file mode 100644
index 0000000..11b6164
--- /dev/null
+++ b/arch/tile/lib/cacheflush.c
@@ -0,0 +1,23 @@
+/*
+ * Copyright 2010 Tilera Corporation. All Rights Reserved.
+ *
+ *   This program is free software; you can redistribute it and/or
+ *   modify it under the terms of the GNU General Public License
+ *   as published by the Free Software Foundation, version 2.
+ *
+ *   This program is distributed in the hope that it will be useful, but
+ *   WITHOUT ANY WARRANTY; without even the implied warranty of
+ *   MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
+ *   NON INFRINGEMENT.  See the GNU General Public License for
+ *   more details.
+ */
+
+#include <asm/page.h>
+#include <asm/cacheflush.h>
+#include <arch/icache.h>
+
+
+void __flush_icache_range(unsigned long start, unsigned long end)
+{
+	invalidate_icache((const void *)start, end - start, PAGE_SIZE);
+}
-- 
1.6.5.2

