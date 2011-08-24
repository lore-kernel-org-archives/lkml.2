Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754484Ab1HXViU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 17:38:20 -0400
Received: from claw.goop.org ([74.207.240.146]:53487 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754177Ab1HXVhY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 17:37:24 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        the arch/x86 maintainers <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nick Piggin <npiggin@kernel.dk>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 06/12] x86: add cmpxchg_flag() variant
Date: Wed, 24 Aug 2011 14:37:03 -0700
Message-Id: <1a4d6bbbf4be64142a81eea0f63626e0224fd66a.1314221624.git.jeremy.fitzhardinge@citrix.com>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <cover.1314207974.git.jeremy.fitzhardinge@citrix.com>
References: <cover.1314207974.git.jeremy.fitzhardinge@citrix.com>
In-Reply-To: <e1c8d3bcee83cc5ad00bdf8900a99add7abb1cb9.1314221624.git.jeremy.fitzhardinge@citrix.com>
References: <e1c8d3bcee83cc5ad00bdf8900a99add7abb1cb9.1314221624.git.jeremy.fitzhardinge@citrix.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

Most callers of cmpxchg() direcly compare RETURN with OLD to see if it was
successful.  This results in unnecessary conditional comparisons
and conditionals since the cmpxchg instruction directly sets the flags
to indicate success/failure.

Add cmpxchg_flag() variants which return a boolean flag directly indicating
success.  Unfortunately an asm() statement can't directly export status
status flags, but sete isn't too bad.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/include/asm/cmpxchg.h    |   48 +++++++++++++++++++++++++++++++-----
 arch/x86/include/asm/cmpxchg_32.h |   14 ++++++++++
 2 files changed, 55 insertions(+), 7 deletions(-)

diff --git a/arch/x86/include/asm/cmpxchg.h b/arch/x86/include/asm/cmpxchg.h
index 0d0d9cd..6013247 100644
--- a/arch/x86/include/asm/cmpxchg.h
+++ b/arch/x86/include/asm/cmpxchg.h
@@ -82,18 +82,18 @@ extern void __xadd_wrong_size(void);
 /*
  * Atomic compare and exchange.  Compare OLD with MEM, if identical,
  * store NEW in MEM.  Return the initial value in MEM.  Success is
- * indicated by comparing RETURN with OLD.
+ * determined by "compare"
  */
-#define __raw_cmpxchg(ptr, old, new, size, lock)			\
+#define __raw_cmpxchg_cmp(ptr, old, new, size, lock, rettype, compare)	\
 ({									\
-	__typeof__(*(ptr)) __ret;					\
+	rettype __ret;							\
 	__typeof__(*(ptr)) __old = (old);				\
 	__typeof__(*(ptr)) __new = (new);				\
 	switch (size) {							\
 	case __X86_CASE_B:						\
 	{								\
 		volatile u8 *__ptr = (volatile u8 *)(ptr);		\
-		asm volatile(lock "cmpxchgb %2,%1"			\
+		asm volatile(lock "cmpxchgb %2,%1; " compare		\
 			     : "=a" (__ret), "+m" (*__ptr)		\
 			     : "q" (__new), "0" (__old)			\
 			     : "memory");				\
@@ -102,7 +102,7 @@ extern void __xadd_wrong_size(void);
 	case __X86_CASE_W:						\
 	{								\
 		volatile u16 *__ptr = (volatile u16 *)(ptr);		\
-		asm volatile(lock "cmpxchgw %2,%1"			\
+		asm volatile(lock "cmpxchgw %2,%1; " compare		\
 			     : "=a" (__ret), "+m" (*__ptr)		\
 			     : "r" (__new), "0" (__old)			\
 			     : "memory");				\
@@ -111,7 +111,7 @@ extern void __xadd_wrong_size(void);
 	case __X86_CASE_L:						\
 	{								\
 		volatile u32 *__ptr = (volatile u32 *)(ptr);		\
-		asm volatile(lock "cmpxchgl %2,%1"			\
+		asm volatile(lock "cmpxchgl %2,%1; " compare		\
 			     : "=a" (__ret), "+m" (*__ptr)		\
 			     : "r" (__new), "0" (__old)			\
 			     : "memory");				\
@@ -120,7 +120,7 @@ extern void __xadd_wrong_size(void);
 	case __X86_CASE_Q:						\
 	{								\
 		volatile u64 *__ptr = (volatile u64 *)(ptr);		\
-		asm volatile(lock "cmpxchgq %2,%1"			\
+		asm volatile(lock "cmpxchgq %2,%1; " compare		\
 			     : "=a" (__ret), "+m" (*__ptr)		\
 			     : "r" (__new), "0" (__old)			\
 			     : "memory");				\
@@ -132,15 +132,40 @@ extern void __xadd_wrong_size(void);
 	__ret;								\
 })
 
+/*
+ * Atomic compare and exchange.  Compare OLD with MEM, if identical,
+ * store NEW in MEM.  Return the initial value in MEM.  Success is
+ * indicated by comparing RETURN with OLD.
+ */
+#define __raw_cmpxchg(ptr, old, new, size, lock)			\
+	__raw_cmpxchg_cmp(ptr, old, new, size, lock, __typeof__(*(ptr)), "")
+
+/*
+ * Atomic compare and exchange.  Compare OLD with MEM, if identical,
+ * store NEW in MEM.  Return the initial value in MEM.  Success is
+ * indicated by a true return.
+ */
+#define __raw_cmpxchg_flag(ptr, old, new, size, lock)			\
+	__raw_cmpxchg_cmp(ptr, old, new, size, lock, unsigned char, "sete %0")
+
 #define __cmpxchg(ptr, old, new, size)					\
 	__raw_cmpxchg((ptr), (old), (new), (size), LOCK_PREFIX)
 
+#define __cmpxchg_flag(ptr, old, new, size)				\
+	__raw_cmpxchg_flag((ptr), (old), (new), (size), LOCK_PREFIX)
+
 #define __sync_cmpxchg(ptr, old, new, size)				\
 	__raw_cmpxchg((ptr), (old), (new), (size), "lock; ")
 
+#define __sync_cmpxchg_flag(ptr, old, new, size)			\
+	__raw_cmpxchg_flag((ptr), (old), (new), (size), "lock; ")
+
 #define __cmpxchg_local(ptr, old, new, size)				\
 	__raw_cmpxchg((ptr), (old), (new), (size), "")
 
+#define __cmpxchg_local_flag(ptr, old, new, size)		\
+	__raw_cmpxchg_flag((ptr), (old), (new), (size), "")
+
 #ifdef CONFIG_X86_32
 # include "cmpxchg_32.h"
 #else
@@ -151,11 +176,20 @@ extern void __xadd_wrong_size(void);
 #define cmpxchg(ptr, old, new)						\
 	__cmpxchg((ptr), (old), (new), sizeof(*ptr))
 
+#define cmpxchg_flag(ptr, old, new)					\
+	__cmpxchg_flag((ptr), (old), (new), sizeof(*ptr))
+
 #define sync_cmpxchg(ptr, old, new)					\
 	__sync_cmpxchg((ptr), (old), (new), sizeof(*ptr))
 
+#define sync_cmpxchg_flag(ptr, old, new)				\
+	__sync_cmpxchg_flag((ptr), (old), (new), sizeof(*ptr))
+
 #define cmpxchg_local(ptr, old, new)					\
 	__cmpxchg_local((ptr), (old), (new), sizeof(*ptr))
+
+#define cmpxchg_local_flag(ptr, old, new)				\
+	__cmpxchg_local_flag((ptr), (old), (new), sizeof(*ptr))
 #endif
 
 #define __xadd(ptr, inc, lock)						\
diff --git a/arch/x86/include/asm/cmpxchg_32.h b/arch/x86/include/asm/cmpxchg_32.h
index 3b573f6..0797bc6 100644
--- a/arch/x86/include/asm/cmpxchg_32.h
+++ b/arch/x86/include/asm/cmpxchg_32.h
@@ -111,6 +111,13 @@ static inline unsigned long cmpxchg_386(volatile void *ptr, unsigned long old,
 				sizeof(*(ptr)));			\
 	__ret;								\
 })
+
+#define cmpxchg_flag(ptr, o, n)			\
+({						\
+	__typeof__(*(ptr)) __orig = (o);	\
+	cmpxchg((ptr), __orig, (n)) == __orig;	\
+})
+
 #define cmpxchg_local(ptr, o, n)					\
 ({									\
 	__typeof__(*(ptr)) __ret;					\
@@ -124,6 +131,13 @@ static inline unsigned long cmpxchg_386(volatile void *ptr, unsigned long old,
 				sizeof(*(ptr)));			\
 	__ret;								\
 })
+
+#define cmpxchg_local_flag(ptr, o, n)			\
+({							\
+	__typeof__(*(ptr)) __orig = (o);		\
+	cmpxchg_local((ptr), __orig, (n)) == __orig;	\
+})
+
 #endif
 
 #ifndef CONFIG_X86_CMPXCHG64
-- 
1.7.6

