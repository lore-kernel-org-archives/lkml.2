Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933397Ab1ERSHV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 14:07:21 -0400
Received: from 206.83.70.73.ptr.us.xo.net ([206.83.70.73]:26559 "EHLO
	king.tilera.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933132Ab1ERSHM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 14:07:12 -0400
Message-Id: <201105181807.p4II7AAd015220@farm-0002.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Mon, 16 May 2011 13:59:39 -0400
Subject: [PATCH] arch/tile: use better definitions of xchg() and cmpxchg()
To: linux-kernel@vger.kernel.org
X-OriginalArrivalTime: 18 May 2011 18:07:10.0665 (UTC) FILETIME=[684E1390:01CC1586]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These definitions use a ({}) construct to avoid some cases where
we were getting warnings about unused return values.  We also
promote the definition to the common <asm/atomic.h>, since it applies
to both the 32- and 64-bit atomics.

In addition, define __HAVE_ARCH_CMPXCHG for TILE-Gx since it has
efficient direct atomic instructions.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/include/asm/atomic.h    |   49 +++++++++++++++++++++++++++++++-----
 arch/tile/include/asm/atomic_32.h |   10 -------
 arch/tile/include/asm/atomic_64.h |   19 ++------------
 3 files changed, 45 insertions(+), 33 deletions(-)

diff --git a/arch/tile/include/asm/atomic.h b/arch/tile/include/asm/atomic.h
index 75a1602..739cfe0 100644
--- a/arch/tile/include/asm/atomic.h
+++ b/arch/tile/include/asm/atomic.h
@@ -130,17 +130,52 @@ static inline int atomic_read(const atomic_t *v)
  */
 #define atomic_inc_not_zero(v)		atomic_add_unless((v), 1, 0)
 
-
-/*
- * We define xchg() and cmpxchg() in the included headers.
- * Note that we do not define __HAVE_ARCH_CMPXCHG, since that would imply
- * that cmpxchg() is an efficient operation, which is not particularly true.
- */
-
 /* Nonexistent functions intended to cause link errors. */
 extern unsigned long __xchg_called_with_bad_pointer(void);
 extern unsigned long __cmpxchg_called_with_bad_pointer(void);
 
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
 #define tas(ptr) (xchg((ptr), 1))
 
 #endif /* __ASSEMBLY__ */
diff --git a/arch/tile/include/asm/atomic_32.h b/arch/tile/include/asm/atomic_32.h
index ed359ae..92a8bee 100644
--- a/arch/tile/include/asm/atomic_32.h
+++ b/arch/tile/include/asm/atomic_32.h
@@ -110,16 +110,6 @@ static inline void atomic_set(atomic_t *v, int n)
 	_atomic_xchg(v, n);
 }
 
-#define xchg(ptr, x) ((typeof(*(ptr))) \
-  ((sizeof(*(ptr)) == sizeof(atomic_t)) ? \
-   atomic_xchg((atomic_t *)(ptr), (long)(x)) : \
-   __xchg_called_with_bad_pointer()))
-
-#define cmpxchg(ptr, o, n) ((typeof(*(ptr))) \
-  ((sizeof(*(ptr)) == sizeof(atomic_t)) ? \
-   atomic_cmpxchg((atomic_t *)(ptr), (long)(o), (long)(n)) : \
-   __cmpxchg_called_with_bad_pointer()))
-
 /* A 64bit atomic type */
 
 typedef struct {
diff --git a/arch/tile/include/asm/atomic_64.h b/arch/tile/include/asm/atomic_64.h
index 3217052..ff885dc 100644
--- a/arch/tile/include/asm/atomic_64.h
+++ b/arch/tile/include/asm/atomic_64.h
@@ -148,21 +148,8 @@ static inline long atomic64_add_unless(atomic64_t *v, long a, long u)
 #define smp_mb__before_atomic_inc()	smp_mb()
 #define smp_mb__after_atomic_inc()	smp_mb()
 
-#define xchg(ptr, x)							\
-	((typeof(*(ptr)))						\
-	 ((sizeof(*(ptr)) == sizeof(atomic_t)) ?			\
-	  atomic_xchg((atomic_t *)(ptr), (long)(x)) :			\
-	  (sizeof(*(ptr)) == sizeof(atomic_long_t)) ?			\
-	  atomic_long_xchg((atomic_long_t *)(ptr), (long)(x)) :		\
-	  __xchg_called_with_bad_pointer()))
-
-#define cmpxchg(ptr, o, n)						\
-	((typeof(*(ptr)))						\
-	 ((sizeof(*(ptr)) == sizeof(atomic_t)) ?			\
-	  atomic_cmpxchg((atomic_t *)(ptr), (long)(o), (long)(n)) :	\
-	  (sizeof(*(ptr)) == sizeof(atomic_long_t)) ?			\
-	  atomic_long_cmpxchg((atomic_long_t *)(ptr), (long)(o), (long)(n)) : \
-	  __cmpxchg_called_with_bad_pointer()))
+/* Define this to indicate that cmpxchg is an efficient operation. */
+#define __HAVE_ARCH_CMPXCHG
 
 #endif /* !__ASSEMBLY__ */
 
-- 
1.6.5.2

