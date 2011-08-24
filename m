Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753481Ab1HXRzs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 13:55:48 -0400
Received: from claw.goop.org ([74.207.240.146]:52878 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753211Ab1HXRxV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 13:53:21 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        the arch/x86 maintainers <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nick Piggin <npiggin@kernel.dk>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 12/18] x86/cmpxchg: unify cmpxchg into cmpxchg.h
Date: Wed, 24 Aug 2011 10:53:06 -0700
Message-Id: <5e3b917225ba6f736d2e148f008a67600248436e.1314207974.git.jeremy.fitzhardinge@citrix.com>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <cover.1314207974.git.jeremy.fitzhardinge@citrix.com>
References: <cover.1314207974.git.jeremy.fitzhardinge@citrix.com>
In-Reply-To: <cover.1314207974.git.jeremy.fitzhardinge@citrix.com>
References: <cover.1314207974.git.jeremy.fitzhardinge@citrix.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

Everything that's actually common between 32 and 64-bit is moved into
cmpxchg.h.

The common variants are derived from the 64-bit versions, so they
will emit 64-bit instructions if given 64-bit arguments, which will
be bad instructions on a 32-bit target.  Don't do that.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/include/asm/cmpxchg.h    |  133 +++++++++++++++++++++++++++++++++++++
 arch/x86/include/asm/cmpxchg_32.h |  113 -------------------------------
 arch/x86/include/asm/cmpxchg_64.h |  131 ------------------------------------
 3 files changed, 133 insertions(+), 244 deletions(-)

diff --git a/arch/x86/include/asm/cmpxchg.h b/arch/x86/include/asm/cmpxchg.h
index b771cdb..76375ba 100644
--- a/arch/x86/include/asm/cmpxchg.h
+++ b/arch/x86/include/asm/cmpxchg.h
@@ -1,6 +1,128 @@
 #ifndef ASM_X86_CMPXCHG_H
 #define ASM_X86_CMPXCHG_H
 
+#include <asm/alternative.h> /* Provides LOCK_PREFIX */
+
+extern void __xchg_wrong_size(void);
+extern void __cmpxchg_wrong_size(void);
+
+/*
+ * Note: no "lock" prefix even on SMP: xchg always implies lock anyway.
+ * Since this is generally used to protect other memory information, we
+ * use "asm volatile" and "memory" clobbers to prevent gcc from moving
+ * information around.
+ */
+#define __xchg(x, ptr, size)						\
+({									\
+	__typeof(*(ptr)) __x = (x);					\
+	switch (size) {							\
+	case 1:								\
+	{								\
+		volatile u8 *__ptr = (volatile u8 *)(ptr);		\
+		asm volatile("xchgb %0,%1"				\
+			     : "=q" (__x), "+m" (*__ptr)		\
+			     : "0" (__x)				\
+			     : "memory");				\
+		break;							\
+	}								\
+	case 2:								\
+	{								\
+		volatile u16 *__ptr = (volatile u16 *)(ptr);		\
+		asm volatile("xchgw %0,%1"				\
+			     : "=r" (__x), "+m" (*__ptr)		\
+			     : "0" (__x)				\
+			     : "memory");				\
+		break;							\
+	}								\
+	case 4:								\
+	{								\
+		volatile u32 *__ptr = (volatile u32 *)(ptr);		\
+		asm volatile("xchgl %0,%1"				\
+			     : "=r" (__x), "+m" (*__ptr)		\
+			     : "0" (__x)				\
+			     : "memory");				\
+		break;							\
+	}								\
+	case 8:								\
+	{								\
+		volatile u64 *__ptr = (volatile u64 *)(ptr);		\
+		asm volatile("xchgq %0,%1"				\
+			     : "=r" (__x), "+m" (*__ptr)		\
+			     : "0" (__x)				\
+			     : "memory");				\
+		break;							\
+	}								\
+	default:							\
+		__xchg_wrong_size();					\
+	}								\
+	__x;								\
+})
+
+#define xchg(ptr, v)							\
+	__xchg((v), (ptr), sizeof(*ptr))
+
+/*
+ * Atomic compare and exchange.  Compare OLD with MEM, if identical,
+ * store NEW in MEM.  Return the initial value in MEM.  Success is
+ * indicated by comparing RETURN with OLD.
+ */
+#define __raw_cmpxchg(ptr, old, new, size, lock)			\
+({									\
+	__typeof__(*(ptr)) __ret;					\
+	__typeof__(*(ptr)) __old = (old);				\
+	__typeof__(*(ptr)) __new = (new);				\
+	switch (size) {							\
+	case 1:								\
+	{								\
+		volatile u8 *__ptr = (volatile u8 *)(ptr);		\
+		asm volatile(lock "cmpxchgb %2,%1"			\
+			     : "=a" (__ret), "+m" (*__ptr)		\
+			     : "q" (__new), "0" (__old)			\
+			     : "memory");				\
+		break;							\
+	}								\
+	case 2:								\
+	{								\
+		volatile u16 *__ptr = (volatile u16 *)(ptr);		\
+		asm volatile(lock "cmpxchgw %2,%1"			\
+			     : "=a" (__ret), "+m" (*__ptr)		\
+			     : "r" (__new), "0" (__old)			\
+			     : "memory");				\
+		break;							\
+	}								\
+	case 4:								\
+	{								\
+		volatile u32 *__ptr = (volatile u32 *)(ptr);		\
+		asm volatile(lock "cmpxchgl %2,%1"			\
+			     : "=a" (__ret), "+m" (*__ptr)		\
+			     : "r" (__new), "0" (__old)			\
+			     : "memory");				\
+		break;							\
+	}								\
+	case 8:								\
+	{								\
+		volatile u64 *__ptr = (volatile u64 *)(ptr);		\
+		asm volatile(lock "cmpxchgq %2,%1"			\
+			     : "=a" (__ret), "+m" (*__ptr)		\
+			     : "r" (__new), "0" (__old)			\
+			     : "memory");				\
+		break;							\
+	}								\
+	default:							\
+		__cmpxchg_wrong_size();					\
+	}								\
+	__ret;								\
+})
+
+#define __cmpxchg(ptr, old, new, size)					\
+	__raw_cmpxchg((ptr), (old), (new), (size), LOCK_PREFIX)
+
+#define __sync_cmpxchg(ptr, old, new, size)				\
+	__raw_cmpxchg((ptr), (old), (new), (size), "lock; ")
+
+#define __cmpxchg_local(ptr, old, new, size)				\
+	__raw_cmpxchg((ptr), (old), (new), (size), "")
+
 #ifdef CONFIG_X86_32
 # include "cmpxchg_32.h"
 #else
@@ -8,6 +130,17 @@
 #endif
 
 
+#ifdef __HAVE_ARCH_CMPXCHG
+#define cmpxchg(ptr, old, new)						\
+	__cmpxchg((ptr), (old), (new), sizeof(*ptr))
+
+#define sync_cmpxchg(ptr, old, new)					\
+	__sync_cmpxchg((ptr), (old), (new), sizeof(*ptr))
+
+#define cmpxchg_local(ptr, old, new)					\
+	__cmpxchg_local((ptr), (old), (new), sizeof(*ptr))
+#endif
+
 #define xadd(ptr, inc)							\
 	do {								\
 		switch (sizeof(*(ptr))) {				\
diff --git a/arch/x86/include/asm/cmpxchg_32.h b/arch/x86/include/asm/cmpxchg_32.h
index 0ef9b82..3b573f6 100644
--- a/arch/x86/include/asm/cmpxchg_32.h
+++ b/arch/x86/include/asm/cmpxchg_32.h
@@ -1,62 +1,11 @@
 #ifndef _ASM_X86_CMPXCHG_32_H
 #define _ASM_X86_CMPXCHG_32_H
 
-#include <asm/alternative.h> /* Provides LOCK_PREFIX */
-
 /*
  * Note: if you use set64_bit(), __cmpxchg64(), or their variants, you
  *       you need to test for the feature in boot_cpu_data.
  */
 
-extern void __xchg_wrong_size(void);
-extern void __cmpxchg_wrong_size(void);
-
-/*
- * Note: no "lock" prefix even on SMP: xchg always implies lock anyway.
- * Since this is generally used to protect other memory information, we
- * use "asm volatile" and "memory" clobbers to prevent gcc from moving
- * information around.
- */
-#define __xchg(x, ptr, size)						\
-({									\
-	__typeof(*(ptr)) __x = (x);					\
-	switch (size) {							\
-	case 1:								\
-	{								\
-		volatile u8 *__ptr = (volatile u8 *)(ptr);		\
-		asm volatile("xchgb %0,%1"				\
-			     : "=q" (__x), "+m" (*__ptr)		\
-			     : "0" (__x)				\
-			     : "memory");				\
-		break;							\
-	}								\
-	case 2:								\
-	{								\
-		volatile u16 *__ptr = (volatile u16 *)(ptr);		\
-		asm volatile("xchgw %0,%1"				\
-			     : "=r" (__x), "+m" (*__ptr)		\
-			     : "0" (__x)				\
-			     : "memory");				\
-		break;							\
-	}								\
-	case 4:								\
-	{								\
-		volatile u32 *__ptr = (volatile u32 *)(ptr);		\
-		asm volatile("xchgl %0,%1"				\
-			     : "=r" (__x), "+m" (*__ptr)		\
-			     : "0" (__x)				\
-			     : "memory");				\
-		break;							\
-	}								\
-	default:							\
-		__xchg_wrong_size();					\
-	}								\
-	__x;								\
-})
-
-#define xchg(ptr, v)							\
-	__xchg((v), (ptr), sizeof(*ptr))
-
 /*
  * CMPXCHG8B only writes to the target if we had the previous
  * value in registers, otherwise it acts as a read and gives us the
@@ -85,70 +34,8 @@ static inline void set_64bit(volatile u64 *ptr, u64 value)
 		     : "memory");
 }
 
-/*
- * Atomic compare and exchange.  Compare OLD with MEM, if identical,
- * store NEW in MEM.  Return the initial value in MEM.  Success is
- * indicated by comparing RETURN with OLD.
- */
-#define __raw_cmpxchg(ptr, old, new, size, lock)			\
-({									\
-	__typeof__(*(ptr)) __ret;					\
-	__typeof__(*(ptr)) __old = (old);				\
-	__typeof__(*(ptr)) __new = (new);				\
-	switch (size) {							\
-	case 1:								\
-	{								\
-		volatile u8 *__ptr = (volatile u8 *)(ptr);		\
-		asm volatile(lock "cmpxchgb %2,%1"			\
-			     : "=a" (__ret), "+m" (*__ptr)		\
-			     : "q" (__new), "0" (__old)			\
-			     : "memory");				\
-		break;							\
-	}								\
-	case 2:								\
-	{								\
-		volatile u16 *__ptr = (volatile u16 *)(ptr);		\
-		asm volatile(lock "cmpxchgw %2,%1"			\
-			     : "=a" (__ret), "+m" (*__ptr)		\
-			     : "r" (__new), "0" (__old)			\
-			     : "memory");				\
-		break;							\
-	}								\
-	case 4:								\
-	{								\
-		volatile u32 *__ptr = (volatile u32 *)(ptr);		\
-		asm volatile(lock "cmpxchgl %2,%1"			\
-			     : "=a" (__ret), "+m" (*__ptr)		\
-			     : "r" (__new), "0" (__old)			\
-			     : "memory");				\
-		break;							\
-	}								\
-	default:							\
-		__cmpxchg_wrong_size();					\
-	}								\
-	__ret;								\
-})
-
-#define __cmpxchg(ptr, old, new, size)					\
-	__raw_cmpxchg((ptr), (old), (new), (size), LOCK_PREFIX)
-
-#define __sync_cmpxchg(ptr, old, new, size)				\
-	__raw_cmpxchg((ptr), (old), (new), (size), "lock; ")
-
-#define __cmpxchg_local(ptr, old, new, size)				\
-	__raw_cmpxchg((ptr), (old), (new), (size), "")
-
 #ifdef CONFIG_X86_CMPXCHG
 #define __HAVE_ARCH_CMPXCHG 1
-
-#define cmpxchg(ptr, old, new)						\
-	__cmpxchg((ptr), (old), (new), sizeof(*ptr))
-
-#define sync_cmpxchg(ptr, old, new)					\
-	__sync_cmpxchg((ptr), (old), (new), sizeof(*ptr))
-
-#define cmpxchg_local(ptr, old, new)					\
-	__cmpxchg_local((ptr), (old), (new), sizeof(*ptr))
 #endif
 
 #ifdef CONFIG_X86_CMPXCHG64
diff --git a/arch/x86/include/asm/cmpxchg_64.h b/arch/x86/include/asm/cmpxchg_64.h
index aeaa610..9d6c147 100644
--- a/arch/x86/include/asm/cmpxchg_64.h
+++ b/arch/x86/include/asm/cmpxchg_64.h
@@ -1,66 +1,6 @@
 #ifndef _ASM_X86_CMPXCHG_64_H
 #define _ASM_X86_CMPXCHG_64_H
 
-#include <asm/alternative.h> /* Provides LOCK_PREFIX */
-
-extern void __xchg_wrong_size(void);
-extern void __cmpxchg_wrong_size(void);
-
-/*
- * Note: no "lock" prefix even on SMP: xchg always implies lock anyway.
- * Since this is generally used to protect other memory information, we
- * use "asm volatile" and "memory" clobbers to prevent gcc from moving
- * information around.
- */
-#define __xchg(x, ptr, size)						\
-({									\
-	__typeof(*(ptr)) __x = (x);					\
-	switch (size) {							\
-	case 1:								\
-	{								\
-		volatile u8 *__ptr = (volatile u8 *)(ptr);		\
-		asm volatile("xchgb %0,%1"				\
-			     : "=q" (__x), "+m" (*__ptr)		\
-			     : "0" (__x)				\
-			     : "memory");				\
-		break;							\
-	}								\
-	case 2:								\
-	{								\
-		volatile u16 *__ptr = (volatile u16 *)(ptr);		\
-		asm volatile("xchgw %0,%1"				\
-			     : "=r" (__x), "+m" (*__ptr)		\
-			     : "0" (__x)				\
-			     : "memory");				\
-		break;							\
-	}								\
-	case 4:								\
-	{								\
-		volatile u32 *__ptr = (volatile u32 *)(ptr);		\
-		asm volatile("xchgl %0,%1"				\
-			     : "=r" (__x), "+m" (*__ptr)		\
-			     : "0" (__x)				\
-			     : "memory");				\
-		break;							\
-	}								\
-	case 8:								\
-	{								\
-		volatile u64 *__ptr = (volatile u64 *)(ptr);		\
-		asm volatile("xchgq %0,%1"				\
-			     : "=r" (__x), "+m" (*__ptr)		\
-			     : "0" (__x)				\
-			     : "memory");				\
-		break;							\
-	}								\
-	default:							\
-		__xchg_wrong_size();					\
-	}								\
-	__x;								\
-})
-
-#define xchg(ptr, v)							\
-	__xchg((v), (ptr), sizeof(*ptr))
-
 static inline void set_64bit(volatile u64 *ptr, u64 val)
 {
 	*ptr = val;
@@ -68,77 +8,6 @@ static inline void set_64bit(volatile u64 *ptr, u64 val)
 
 #define __HAVE_ARCH_CMPXCHG 1
 
-/*
- * Atomic compare and exchange.  Compare OLD with MEM, if identical,
- * store NEW in MEM.  Return the initial value in MEM.  Success is
- * indicated by comparing RETURN with OLD.
- */
-#define __raw_cmpxchg(ptr, old, new, size, lock)			\
-({									\
-	__typeof__(*(ptr)) __ret;					\
-	__typeof__(*(ptr)) __old = (old);				\
-	__typeof__(*(ptr)) __new = (new);				\
-	switch (size) {							\
-	case 1:								\
-	{								\
-		volatile u8 *__ptr = (volatile u8 *)(ptr);		\
-		asm volatile(lock "cmpxchgb %2,%1"			\
-			     : "=a" (__ret), "+m" (*__ptr)		\
-			     : "q" (__new), "0" (__old)			\
-			     : "memory");				\
-		break;							\
-	}								\
-	case 2:								\
-	{								\
-		volatile u16 *__ptr = (volatile u16 *)(ptr);		\
-		asm volatile(lock "cmpxchgw %2,%1"			\
-			     : "=a" (__ret), "+m" (*__ptr)		\
-			     : "r" (__new), "0" (__old)			\
-			     : "memory");				\
-		break;							\
-	}								\
-	case 4:								\
-	{								\
-		volatile u32 *__ptr = (volatile u32 *)(ptr);		\
-		asm volatile(lock "cmpxchgl %2,%1"			\
-			     : "=a" (__ret), "+m" (*__ptr)		\
-			     : "r" (__new), "0" (__old)			\
-			     : "memory");				\
-		break;							\
-	}								\
-	case 8:								\
-	{								\
-		volatile u64 *__ptr = (volatile u64 *)(ptr);		\
-		asm volatile(lock "cmpxchgq %2,%1"			\
-			     : "=a" (__ret), "+m" (*__ptr)		\
-			     : "r" (__new), "0" (__old)			\
-			     : "memory");				\
-		break;							\
-	}								\
-	default:							\
-		__cmpxchg_wrong_size();					\
-	}								\
-	__ret;								\
-})
-
-#define __cmpxchg(ptr, old, new, size)					\
-	__raw_cmpxchg((ptr), (old), (new), (size), LOCK_PREFIX)
-
-#define __sync_cmpxchg(ptr, old, new, size)				\
-	__raw_cmpxchg((ptr), (old), (new), (size), "lock; ")
-
-#define __cmpxchg_local(ptr, old, new, size)				\
-	__raw_cmpxchg((ptr), (old), (new), (size), "")
-
-#define cmpxchg(ptr, old, new)						\
-	__cmpxchg((ptr), (old), (new), sizeof(*ptr))
-
-#define sync_cmpxchg(ptr, old, new)					\
-	__sync_cmpxchg((ptr), (old), (new), sizeof(*ptr))
-
-#define cmpxchg_local(ptr, old, new)					\
-	__cmpxchg_local((ptr), (old), (new), sizeof(*ptr))
-
 #define cmpxchg64(ptr, o, n)						\
 ({									\
 	BUILD_BUG_ON(sizeof(*(ptr)) != 8);				\
-- 
1.7.6

