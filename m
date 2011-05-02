Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754807Ab1EBXLG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 19:11:06 -0400
Received: from 206.83.70.73.ptr.us.xo.net ([206.83.70.73]:54332 "EHLO
	king.tilera.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758140Ab1EBXJf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 19:09:35 -0400
X-Greylist: delayed 911 seconds by postgrey-1.27 at vger.kernel.org; Mon, 02 May 2011 19:09:25 EDT
Message-Id: <201105022254.p42MsRTL030359@farm-0023.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Mon, 2 May 2011 16:21:12 -0400
Subject: [PATCH] arch/tile: kernel-related cleanups from removing static page size
To: linux-kernel@vger.kernel.org
X-OriginalArrivalTime: 02 May 2011 22:54:27.0377 (UTC) FILETIME=[E3939A10:01CC091B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

User space code has been able to discover the static page size
by including a special <hv/pagesize.h> file.  In the current release,
that file is now gone, and <asm/page.h> doesn't rely on it.  The
getpagesize() API is now the only way for userspace to get the page size.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/include/arch/icache.h   |   11 +++++------
 arch/tile/include/asm/page.h      |   10 ++--------
 arch/tile/include/hv/hypervisor.h |   12 ++++++++++--
 arch/tile/include/hv/pagesize.h   |   32 --------------------------------
 4 files changed, 17 insertions(+), 48 deletions(-)
 delete mode 100644 arch/tile/include/hv/pagesize.h

diff --git a/arch/tile/include/arch/icache.h b/arch/tile/include/arch/icache.h
index 5c87c90..762eafa 100644
--- a/arch/tile/include/arch/icache.h
+++ b/arch/tile/include/arch/icache.h
@@ -16,7 +16,7 @@
 /**
  * @file
  *
- * Support for invalidating bytes in the instruction
+ * Support for invalidating bytes in the instruction cache.
  */
 
 #ifndef __ARCH_ICACHE_H__
@@ -30,11 +30,10 @@
  *
  * @param addr The start of memory to be invalidated.
  * @param size The number of bytes to be invalidated.
- * @param page_size The system's page size, typically the PAGE_SIZE constant
- * in sys/page.h.  This value must be a power of two no larger
- * than the page containing the code to be invalidated. If the value
- * is smaller than the actual page size, this function will still
- * work, but may run slower than necessary.
+ * @param page_size The system's page size, e.g. getpagesize() in userspace.
+ * This value must be a power of two no larger than the page containing
+ * the code to be invalidated. If the value is smaller than the actual page
+ * size, this function will still work, but may run slower than necessary.
  */
 static __inline void
 invalidate_icache(const void* addr, unsigned long size,
diff --git a/arch/tile/include/asm/page.h b/arch/tile/include/asm/page.h
index 7105629..db93518 100644
--- a/arch/tile/include/asm/page.h
+++ b/arch/tile/include/asm/page.h
@@ -16,7 +16,8 @@
 #define _ASM_TILE_PAGE_H
 
 #include <linux/const.h>
-#include <hv/pagesize.h>
+#include <hv/hypervisor.h>
+#include <arch/chip.h>
 
 /* PAGE_SHIFT and HPAGE_SHIFT determine the page sizes. */
 #define PAGE_SHIFT	HV_LOG2_PAGE_SIZE_SMALL
@@ -28,8 +29,6 @@
 #define PAGE_MASK	(~(PAGE_SIZE - 1))
 #define HPAGE_MASK	(~(HPAGE_SIZE - 1))
 
-#ifdef __KERNEL__
-
 /*
  * If the Kconfig doesn't specify, set a maximum zone order that
  * is enough so that we can create huge pages from small pages given
@@ -39,9 +38,6 @@
 #define CONFIG_FORCE_MAX_ZONEORDER (HPAGE_SHIFT - PAGE_SHIFT + 1)
 #endif
 
-#include <hv/hypervisor.h>
-#include <arch/chip.h>
-
 #ifndef __ASSEMBLY__
 
 #include <linux/types.h>
@@ -337,6 +333,4 @@ extern pte_t *virt_to_pte(struct mm_struct *mm, unsigned long addr);
 
 #include <asm-generic/memory_model.h>
 
-#endif /* __KERNEL__ */
-
 #endif /* _ASM_TILE_PAGE_H */
diff --git a/arch/tile/include/hv/hypervisor.h b/arch/tile/include/hv/hypervisor.h
index ee41bca..72ec1e9 100644
--- a/arch/tile/include/hv/hypervisor.h
+++ b/arch/tile/include/hv/hypervisor.h
@@ -22,8 +22,6 @@
 
 #include <arch/chip.h>
 
-#include <hv/pagesize.h>
-
 /* Linux builds want unsigned long constants, but assembler wants numbers */
 #ifdef __ASSEMBLER__
 /** One, for assembler */
@@ -44,11 +42,21 @@
  */
 #define HV_L1_SPAN (__HV_SIZE_ONE << HV_LOG2_L1_SPAN)
 
+/** The log2 of the size of small pages, in bytes. This value should
+ * be verified at runtime by calling hv_sysconf(HV_SYSCONF_PAGE_SIZE_SMALL).
+ */
+#define HV_LOG2_PAGE_SIZE_SMALL 16
+
 /** The size of small pages, in bytes. This value should be verified
  * at runtime by calling hv_sysconf(HV_SYSCONF_PAGE_SIZE_SMALL).
  */
 #define HV_PAGE_SIZE_SMALL (__HV_SIZE_ONE << HV_LOG2_PAGE_SIZE_SMALL)
 
+/** The log2 of the size of large pages, in bytes. This value should be
+ * verified at runtime by calling hv_sysconf(HV_SYSCONF_PAGE_SIZE_LARGE).
+ */
+#define HV_LOG2_PAGE_SIZE_LARGE 24
+
 /** The size of large pages, in bytes. This value should be verified
  * at runtime by calling hv_sysconf(HV_SYSCONF_PAGE_SIZE_LARGE).
  */
diff --git a/arch/tile/include/hv/pagesize.h b/arch/tile/include/hv/pagesize.h
deleted file mode 100644
index 58bed11..0000000
--- a/arch/tile/include/hv/pagesize.h
+++ /dev/null
@@ -1,32 +0,0 @@
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
- */
-
-/**
- * @file pagesize.h
- */
-
-#ifndef _HV_PAGESIZE_H
-#define _HV_PAGESIZE_H
-
-/** The log2 of the size of small pages, in bytes. This value should
- * be verified at runtime by calling hv_sysconf(HV_SYSCONF_PAGE_SIZE_SMALL).
- */
-#define HV_LOG2_PAGE_SIZE_SMALL 16
-
-/** The log2 of the size of large pages, in bytes. This value should be
- * verified at runtime by calling hv_sysconf(HV_SYSCONF_PAGE_SIZE_LARGE).
- */
-#define HV_LOG2_PAGE_SIZE_LARGE 24
-
-#endif /* _HV_PAGESIZE_H */
-- 
1.6.5.2

