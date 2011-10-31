Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934858Ab1KAAUu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Oct 2011 20:20:50 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:60395 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934825Ab1KAASM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Oct 2011 20:18:12 -0400
Message-Id: <093448$3uejt0@wolverine01.qualcomm.com>
X-IronPort-AV: E=McAfee;i="5400,1158,6516"; a="132599712"
From: Richard Kuo <rkuo@codeaurora.org>
Date: Mon, 31 Oct 2011 18:50:51 -0500
Subject: [PATCH v5 25/36] Hexagon: Implement basic cache-flush support
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Richard Kuo <rkuo@codeaurora.org>
Acked-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/hexagon/include/asm/cache.h      |   34 +++++++++
 arch/hexagon/include/asm/cacheflush.h |   99 +++++++++++++++++++++++++
 arch/hexagon/mm/cache.c               |  128 +++++++++++++++++++++++++++++++++
 3 files changed, 261 insertions(+), 0 deletions(-)
 create mode 100644 arch/hexagon/include/asm/cache.h
 create mode 100644 arch/hexagon/include/asm/cacheflush.h
 create mode 100644 arch/hexagon/mm/cache.c

diff --git a/arch/hexagon/include/asm/cache.h b/arch/hexagon/include/asm/cache.h
new file mode 100644
index 0000000..0f01de2
--- /dev/null
+++ b/arch/hexagon/include/asm/cache.h
@@ -0,0 +1,34 @@
+/*
+ * Cache definitions for the Hexagon architecture
+ *
+ * Copyright (c) 2010-2011, Code Aurora Forum. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
+ * 02110-1301, USA.
+ */
+
+#ifndef __ASM_CACHE_H
+#define __ASM_CACHE_H
+
+/* Bytes per L1 cache line */
+#define L1_CACHE_SHIFT		(5)
+#define L1_CACHE_BYTES		(1 << L1_CACHE_SHIFT)
+
+#define __cacheline_aligned	__aligned(L1_CACHE_BYTES)
+#define ____cacheline_aligned	__aligned(L1_CACHE_BYTES)
+
+/* See http://kerneltrap.org/node/15100  */
+#define __read_mostly
+
+#endif
diff --git a/arch/hexagon/include/asm/cacheflush.h b/arch/hexagon/include/asm/cacheflush.h
new file mode 100644
index 0000000..6865c1b
--- /dev/null
+++ b/arch/hexagon/include/asm/cacheflush.h
@@ -0,0 +1,99 @@
+/*
+ * Cache flush operations for the Hexagon architecture
+ *
+ * Copyright (c) 2010-2011, Code Aurora Forum. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
+ * 02110-1301, USA.
+ */
+
+#ifndef _ASM_CACHEFLUSH_H
+#define _ASM_CACHEFLUSH_H
+
+#include <linux/cache.h>
+#include <linux/mm.h>
+#include <asm/string.h>
+#include <asm-generic/cacheflush.h>
+
+/* Cache flushing:
+ *
+ *  - flush_cache_all() flushes entire cache
+ *  - flush_cache_mm(mm) flushes the specified mm context's cache lines
+ *  - flush_cache_page(mm, vmaddr, pfn) flushes a single page
+ *  - flush_cache_range(vma, start, end) flushes a range of pages
+ *  - flush_icache_range(start, end) flush a range of instructions
+ *  - flush_dcache_page(pg) flushes(wback&invalidates) a page for dcache
+ *  - flush_icache_page(vma, pg) flushes(invalidates) a page for icache
+ *
+ *  Need to doublecheck which one is really needed for ptrace stuff to work.
+ */
+#define LINESIZE	32
+#define LINEBITS	5
+
+/*
+ * Flush Dcache range through current map.
+ */
+extern void flush_dcache_range(unsigned long start, unsigned long end);
+
+/*
+ * Flush Icache range through current map.
+ */
+#undef flush_icache_range
+extern void flush_icache_range(unsigned long start, unsigned long end);
+
+/*
+ * Memory-management related flushes are there to ensure in non-physically
+ * indexed cache schemes that stale lines belonging to a given ASID aren't
+ * in the cache to confuse things.  The prototype Hexagon Virtual Machine
+ * only uses a single ASID for all user-mode maps, which should
+ * mean that they aren't necessary.  A brute-force, flush-everything
+ * implementation, with the name xxxxx_hexagon() is present in
+ * arch/hexagon/mm/cache.c, but let's not wire it up until we know
+ * it is needed.
+ */
+extern void flush_cache_all_hexagon(void);
+
+/*
+ * This may or may not ever have to be non-null, depending on the
+ * virtual machine MMU.  For a native kernel, it's definitiely  a no-op
+ *
+ * This is also the place where deferred cache coherency stuff seems
+ * to happen, classically...  but instead we do it like ia64 and
+ * clean the cache when the PTE is set.
+ *
+ */
+static inline void update_mmu_cache(struct vm_area_struct *vma,
+					unsigned long address, pte_t *ptep)
+{
+	/*  generic_ptrace_pokedata doesn't wind up here, does it?  */
+}
+
+#undef copy_to_user_page
+static inline void copy_to_user_page(struct vm_area_struct *vma,
+					     struct page *page,
+					     unsigned long vaddr,
+					     void *dst, void *src, int len)
+{
+	memcpy(dst, src, len);
+	if (vma->vm_flags & VM_EXEC) {
+		flush_icache_range((unsigned long) dst,
+		(unsigned long) dst + len);
+	}
+}
+
+
+extern void hexagon_inv_dcache_range(unsigned long start, unsigned long end);
+extern void hexagon_clean_dcache_range(unsigned long start, unsigned long end);
+
+#endif
diff --git a/arch/hexagon/mm/cache.c b/arch/hexagon/mm/cache.c
new file mode 100644
index 0000000..c5cf6ee
--- /dev/null
+++ b/arch/hexagon/mm/cache.c
@@ -0,0 +1,128 @@
+/*
+ * Cache management functions for Hexagon
+ *
+ * Copyright (c) 2010-2011, Code Aurora Forum. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
+ * 02110-1301, USA.
+ */
+
+#include <linux/mm.h>
+#include <asm/cacheflush.h>
+#include <asm/hexagon_vm.h>
+
+#define spanlines(start, end) \
+	(((end - (start & ~(LINESIZE - 1))) >> LINEBITS) + 1)
+
+void flush_dcache_range(unsigned long start, unsigned long end)
+{
+	unsigned long lines = spanlines(start, end-1);
+	unsigned long i, flags;
+
+	start &= ~(LINESIZE - 1);
+
+	local_irq_save(flags);
+
+	for (i = 0; i < lines; i++) {
+		__asm__ __volatile__ (
+		"	dccleaninva(%0);	"
+		:
+		: "r" (start)
+		);
+		start += LINESIZE;
+	}
+	local_irq_restore(flags);
+}
+
+void flush_icache_range(unsigned long start, unsigned long end)
+{
+	unsigned long lines = spanlines(start, end-1);
+	unsigned long i, flags;
+
+	start &= ~(LINESIZE - 1);
+
+	local_irq_save(flags);
+
+	for (i = 0; i < lines; i++) {
+		__asm__ __volatile__ (
+			"	dccleana(%0); "
+			"	icinva(%0);	"
+			:
+			: "r" (start)
+		);
+		start += LINESIZE;
+	}
+	__asm__ __volatile__ (
+		"isync"
+	);
+	local_irq_restore(flags);
+}
+
+void hexagon_clean_dcache_range(unsigned long start, unsigned long end)
+{
+	unsigned long lines = spanlines(start, end-1);
+	unsigned long i, flags;
+
+	start &= ~(LINESIZE - 1);
+
+	local_irq_save(flags);
+
+	for (i = 0; i < lines; i++) {
+		__asm__ __volatile__ (
+		"	dccleana(%0);	"
+		:
+		: "r" (start)
+		);
+		start += LINESIZE;
+	}
+	local_irq_restore(flags);
+}
+
+void hexagon_inv_dcache_range(unsigned long start, unsigned long end)
+{
+	unsigned long lines = spanlines(start, end-1);
+	unsigned long i, flags;
+
+	start &= ~(LINESIZE - 1);
+
+	local_irq_save(flags);
+
+	for (i = 0; i < lines; i++) {
+		__asm__ __volatile__ (
+		"	dcinva(%0);	"
+		:
+		: "r" (start)
+		);
+		start += LINESIZE;
+	}
+	local_irq_restore(flags);
+}
+
+
+
+
+/*
+ * This is just really brutal and shouldn't be used anyways,
+ * especially on V2.  Left here just in case.
+ */
+void flush_cache_all_hexagon(void)
+{
+	unsigned long flags;
+	local_irq_save(flags);
+	__vmcache_ickill();
+	__vmcache_dckill();
+	__vmcache_l2kill();
+	local_irq_restore(flags);
+	mb();
+}
-- 
1.7.1


--

Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
