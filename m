Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757292Ab1CATkr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 14:40:47 -0500
Received: from 206.83.70.71.ptr.us.xo.net ([206.83.70.71]:52544 "EHLO
	king.tilera.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757122Ab1CAThX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 14:37:23 -0500
X-Greylist: delayed 369 seconds by postgrey-1.27 at vger.kernel.org; Tue, 01 Mar 2011 14:37:17 EST
Message-Id: <201103011934.p21JYdSt010306@farm-0010.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Mon, 28 Feb 2011 15:28:00 -0500
Subject: [PATCH] arch/tile: use extended assembly to inline __mb_incoherent()
To: linux-kernel@vger.kernel.org
In-Reply-To: <201103011931.p21JVtqp010237@farm-0010.internal.tilera.com>
X-OriginalArrivalTime: 01 Mar 2011 19:34:39.0514 (UTC) FILETIME=[B4A45FA0:01CBD847]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This avoids having to maintain an additional separate assembly
file, and of course the inline is slightly more efficient as well.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/include/asm/system.h |   19 ++++++++++++++++++-
 arch/tile/lib/Makefile         |    5 ++---
 arch/tile/lib/exports.c        |    3 ---
 arch/tile/lib/mb_incoherent.S  |   34 ----------------------------------
 4 files changed, 20 insertions(+), 41 deletions(-)
 delete mode 100644 arch/tile/lib/mb_incoherent.S

diff --git a/arch/tile/include/asm/system.h b/arch/tile/include/asm/system.h
index 5388850..23d1842 100644
--- a/arch/tile/include/asm/system.h
+++ b/arch/tile/include/asm/system.h
@@ -90,7 +90,24 @@
 #endif
 
 #if !CHIP_HAS_MF_WAITS_FOR_VICTIMS()
-int __mb_incoherent(void);  /* Helper routine for mb_incoherent(). */
+#include <hv/syscall_public.h>
+/*
+ * Issue an uncacheable load to each memory controller, then
+ * wait until those loads have completed.
+ */
+static inline void __mb_incoherent(void)
+{
+	long clobber_r10;
+	asm volatile("swint2"
+		     : "=R10" (clobber_r10)
+		     : "R10" (HV_SYS_fence_incoherent)
+		     : "r0", "r1", "r2", "r3", "r4",
+		       "r5", "r6", "r7", "r8", "r9",
+		       "r11", "r12", "r13", "r14",
+		       "r15", "r16", "r17", "r18", "r19",
+		       "r20", "r21", "r22", "r23", "r24",
+		       "r25", "r26", "r27", "r28", "r29");
+}
 #endif
 
 /* Fence to guarantee visibility of stores to incoherent memory. */
diff --git a/arch/tile/lib/Makefile b/arch/tile/lib/Makefile
index 93122d5..0c26086 100644
--- a/arch/tile/lib/Makefile
+++ b/arch/tile/lib/Makefile
@@ -2,9 +2,8 @@
 # Makefile for TILE-specific library files..
 #
 
-lib-y = cacheflush.o checksum.o cpumask.o delay.o \
-	mb_incoherent.o uaccess.o memmove.o \
-	memcpy_$(BITS).o memchr_$(BITS).o memset_$(BITS).o \
+lib-y = cacheflush.o checksum.o cpumask.o delay.o uaccess.o \
+	memmove.o memcpy_$(BITS).o memchr_$(BITS).o memset_$(BITS).o \
 	strchr_$(BITS).o strlen_$(BITS).o
 
 ifeq ($(CONFIG_TILEGX),y)
diff --git a/arch/tile/lib/exports.c b/arch/tile/lib/exports.c
index 1509c55..ce5dbf5 100644
--- a/arch/tile/lib/exports.c
+++ b/arch/tile/lib/exports.c
@@ -45,9 +45,6 @@ EXPORT_SYMBOL(__copy_from_user_zeroing);
 EXPORT_SYMBOL(__copy_in_user_inatomic);
 #endif
 
-/* arch/tile/lib/mb_incoherent.S */
-EXPORT_SYMBOL(__mb_incoherent);
-
 /* hypervisor glue */
 #include <hv/hypervisor.h>
 EXPORT_SYMBOL(hv_dev_open);
diff --git a/arch/tile/lib/mb_incoherent.S b/arch/tile/lib/mb_incoherent.S
deleted file mode 100644
index 989ad7b..0000000
--- a/arch/tile/lib/mb_incoherent.S
+++ /dev/null
@@ -1,34 +0,0 @@
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
- *
- * Assembly code for invoking the HV's fence_incoherent syscall.
- */
-
-#include <linux/linkage.h>
-#include <hv/syscall_public.h>
-#include <arch/abi.h>
-#include <arch/chip.h>
-
-#if !CHIP_HAS_MF_WAITS_FOR_VICTIMS()
-
-/*
- * Invoke the hypervisor's fence_incoherent syscall, which guarantees
- * that all victims for cachelines homed on this tile have reached memory.
- */
-STD_ENTRY(__mb_incoherent)
-	moveli TREG_SYSCALL_NR_NAME, HV_SYS_fence_incoherent
-	swint2
-	jrp lr
-	STD_ENDPROC(__mb_incoherent)
-
-#endif
-- 
1.6.5.2

