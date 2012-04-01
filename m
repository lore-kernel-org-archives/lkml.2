Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753711Ab2DAUjV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2012 16:39:21 -0400
Received: from mail.windriver.com ([147.11.1.11]:54151 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753499Ab2DAUjN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2012 16:39:13 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: dhowells@redhat.com
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-next@vger.kernel.org,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Chris Metcalf <cmetcalf@tilera.com>
Subject: [PATCH 10/11] tile: fix multiple build failures from system.h dismantle
Date: Sun,  1 Apr 2012 16:38:46 -0400
Message-Id: <1333312727-11428-11-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.1
In-Reply-To: <1333312727-11428-1-git-send-email-paul.gortmaker@windriver.com>
References: <1333312727-11428-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit bd119c69239322caafdb64517a806037d0d0c70a

    "Disintegrate asm/system.h for Tile"

created the asm/switch_to.h file, but did not add an include
of it to all its users.

Also, commit b4816afa3986704d1404fc48e931da5135820472

        "Move the asm-generic/system.h xchg() implementation to asm-generic/cmpxchg.h"

introduced the concept of asm/cmpxchg.h but the tile arch
never got one.  Fork the cmpxchg content out of the asm/atomic.h
file to create one.

Cc: Chris Metcalf <cmetcalf@tilera.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 arch/tile/include/asm/atomic.h  |   50 +-------------------------
 arch/tile/include/asm/cmpxchg.h |   73 +++++++++++++++++++++++++++++++++++++++
 arch/tile/kernel/process.c      |    1 +
 arch/tile/kernel/stack.c        |    1 +
 4 files changed, 77 insertions(+), 48 deletions(-)
 create mode 100644 arch/tile/include/asm/cmpxchg.h

diff --git a/arch/tile/include/asm/atomic.h b/arch/tile/include/asm/atomic.h
index bb696da..f246142 100644
--- a/arch/tile/include/asm/atomic.h
+++ b/arch/tile/include/asm/atomic.h
@@ -17,6 +17,8 @@
 #ifndef _ASM_TILE_ATOMIC_H
 #define _ASM_TILE_ATOMIC_H
 
+#include <asm/cmpxchg.h>
+
 #ifndef __ASSEMBLY__
 
 #include <linux/compiler.h>
@@ -121,54 +123,6 @@ static inline int atomic_read(const atomic_t *v)
  */
 #define atomic_add_negative(i, v)	(atomic_add_return((i), (v)) < 0)
 
-/* Nonexistent functions intended to cause link errors. */
-extern unsigned long __xchg_called_with_bad_pointer(void);
-extern unsigned long __cmpxchg_called_with_bad_pointer(void);
-
-#define xchg(ptr, x)							\
-	({								\
-		typeof(*(ptr)) __x;					\
-		switch (sizeof(*(ptr))) {				\
-		case 4:							\
-			__x = (typeof(__x))(typeof(__x-__x))atomic_xchg( \
-				(atomic_t *)(ptr),			\
-				(u32)(typeof((x)-(x)))(x));		\
-			break;						\
-		case 8:							\
-			__x = (typeof(__x))(typeof(__x-__x))atomic64_xchg( \
-				(atomic64_t *)(ptr),			\
-				(u64)(typeof((x)-(x)))(x));		\
-			break;						\
-		default:						\
-			__xchg_called_with_bad_pointer();		\
-		}							\
-		__x;							\
-	})
-
-#define cmpxchg(ptr, o, n)						\
-	({								\
-		typeof(*(ptr)) __x;					\
-		switch (sizeof(*(ptr))) {				\
-		case 4:							\
-			__x = (typeof(__x))(typeof(__x-__x))atomic_cmpxchg( \
-				(atomic_t *)(ptr),			\
-				(u32)(typeof((o)-(o)))(o),		\
-				(u32)(typeof((n)-(n)))(n));		\
-			break;						\
-		case 8:							\
-			__x = (typeof(__x))(typeof(__x-__x))atomic64_cmpxchg( \
-				(atomic64_t *)(ptr),			\
-				(u64)(typeof((o)-(o)))(o),		\
-				(u64)(typeof((n)-(n)))(n));		\
-			break;						\
-		default:						\
-			__cmpxchg_called_with_bad_pointer();		\
-		}							\
-		__x;							\
-	})
-
-#define tas(ptr) (xchg((ptr), 1))
-
 #endif /* __ASSEMBLY__ */
 
 #ifndef __tilegx__
diff --git a/arch/tile/include/asm/cmpxchg.h b/arch/tile/include/asm/cmpxchg.h
new file mode 100644
index 0000000..276f067
--- /dev/null
+++ b/arch/tile/include/asm/cmpxchg.h
@@ -0,0 +1,73 @@
+/*
+ * cmpxchg.h -- forked from asm/atomic.h with this copyright:
+ *
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
+#ifndef _ASM_TILE_CMPXCHG_H
+#define _ASM_TILE_CMPXCHG_H
+
+#ifndef __ASSEMBLY__
+
+/* Nonexistent functions intended to cause link errors. */
+extern unsigned long __xchg_called_with_bad_pointer(void);
+extern unsigned long __cmpxchg_called_with_bad_pointer(void);
+
+#define xchg(ptr, x)							\
+	({								\
+		typeof(*(ptr)) __x;					\
+		switch (sizeof(*(ptr))) {				\
+		case 4:							\
+			__x = (typeof(__x))(typeof(__x-__x))atomic_xchg( \
+				(atomic_t *)(ptr),			\
+				(u32)(typeof((x)-(x)))(x));		\
+			break;						\
+		case 8:							\
+			__x = (typeof(__x))(typeof(__x-__x))atomic64_xchg( \
+				(atomic64_t *)(ptr),			\
+				(u64)(typeof((x)-(x)))(x));		\
+			break;						\
+		default:						\
+			__xchg_called_with_bad_pointer();		\
+		}							\
+		__x;							\
+	})
+
+#define cmpxchg(ptr, o, n)						\
+	({								\
+		typeof(*(ptr)) __x;					\
+		switch (sizeof(*(ptr))) {				\
+		case 4:							\
+			__x = (typeof(__x))(typeof(__x-__x))atomic_cmpxchg( \
+				(atomic_t *)(ptr),			\
+				(u32)(typeof((o)-(o)))(o),		\
+				(u32)(typeof((n)-(n)))(n));		\
+			break;						\
+		case 8:							\
+			__x = (typeof(__x))(typeof(__x-__x))atomic64_cmpxchg( \
+				(atomic64_t *)(ptr),			\
+				(u64)(typeof((o)-(o)))(o),		\
+				(u64)(typeof((n)-(n)))(n));		\
+			break;						\
+		default:						\
+			__cmpxchg_called_with_bad_pointer();		\
+		}							\
+		__x;							\
+	})
+
+#define tas(ptr) (xchg((ptr), 1))
+
+#endif /* __ASSEMBLY__ */
+
+#endif /* _ASM_TILE_CMPXCHG_H */
diff --git a/arch/tile/kernel/process.c b/arch/tile/kernel/process.c
index 30caeca..ee01b1c 100644
--- a/arch/tile/kernel/process.c
+++ b/arch/tile/kernel/process.c
@@ -28,6 +28,7 @@
 #include <linux/tracehook.h>
 #include <linux/signal.h>
 #include <asm/stack.h>
+#include <asm/switch_to.h>
 #include <asm/homecache.h>
 #include <asm/syscalls.h>
 #include <asm/traps.h>
diff --git a/arch/tile/kernel/stack.c b/arch/tile/kernel/stack.c
index 37ee4d0..0be6b01 100644
--- a/arch/tile/kernel/stack.c
+++ b/arch/tile/kernel/stack.c
@@ -25,6 +25,7 @@
 #include <asm/page.h>
 #include <asm/tlbflush.h>
 #include <asm/ucontext.h>
+#include <asm/switch_to.h>
 #include <asm/sigframe.h>
 #include <asm/stack.h>
 #include <arch/abi.h>
-- 
1.7.9.1

