Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753377Ab1HXRyG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 13:54:06 -0400
Received: from claw.goop.org ([74.207.240.146]:52894 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752865Ab1HXRxX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 13:53:23 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        the arch/x86 maintainers <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nick Piggin <npiggin@kernel.dk>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 16/18] x86: report xchg/cmpxchg/xadd usage errors consistently
Date: Wed, 24 Aug 2011 10:53:10 -0700
Message-Id: <1dabde8c20c8014327abb8d2e6b1b2fdb1c2d19c.1314207974.git.jeremy.fitzhardinge@citrix.com>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <cover.1314207974.git.jeremy.fitzhardinge@citrix.com>
References: <cover.1314207974.git.jeremy.fitzhardinge@citrix.com>
In-Reply-To: <cover.1314207974.git.jeremy.fitzhardinge@citrix.com>
References: <cover.1314207974.git.jeremy.fitzhardinge@citrix.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

Make sure that passing a variable of an unusable size causes a consistent
link-time failure.  Previously, using a 64-bit value on a 32-bit system
would cause an assember error, which isn't easy to correlate with a line
of code.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/include/asm/cmpxchg.h |   44 +++++++++++++++++++++++++++++----------
 1 files changed, 32 insertions(+), 12 deletions(-)

diff --git a/arch/x86/include/asm/cmpxchg.h b/arch/x86/include/asm/cmpxchg.h
index 57d6706..c99ce79 100644
--- a/arch/x86/include/asm/cmpxchg.h
+++ b/arch/x86/include/asm/cmpxchg.h
@@ -3,8 +3,26 @@
 
 #include <asm/alternative.h> /* Provides LOCK_PREFIX */
 
+/* Non-existant functions to indicate usage errors at link time. */
 extern void __xchg_wrong_size(void);
 extern void __cmpxchg_wrong_size(void);
+extern void __xadd_wrong_size(void);
+
+/*
+ * Constants for operation sizes. On 32-bit, the 64-bit size it set to
+ * -1 because sizeof will never return -1, thereby making those switch
+ * case statements guaranteeed dead code which the compiler will
+ * eliminate, and allowing the "missing symbol in the default case" to
+ * indicate a usage error.
+ */
+#define __X86_CASE_B	1
+#define __X86_CASE_W	2
+#define __X86_CASE_L	4
+#ifdef CONFIG_64BIT
+#define __X86_CASE_Q	8
+#else
+#define	__X86_CASE_Q	-1		/* sizeof will never return -1 */
+#endif
 
 /*
  * Note: no "lock" prefix even on SMP: xchg always implies lock anyway.
@@ -16,7 +34,7 @@ extern void __cmpxchg_wrong_size(void);
 ({									\
 	__typeof(*(ptr)) __x = (x);					\
 	switch (size) {							\
-	case 1:								\
+	case __X86_CASE_B:						\
 	{								\
 		volatile u8 *__ptr = (volatile u8 *)(ptr);		\
 		asm volatile("xchgb %0,%1"				\
@@ -25,7 +43,7 @@ extern void __cmpxchg_wrong_size(void);
 			     : "memory");				\
 		break;							\
 	}								\
-	case 2:								\
+	case __X86_CASE_W:						\
 	{								\
 		volatile u16 *__ptr = (volatile u16 *)(ptr);		\
 		asm volatile("xchgw %0,%1"				\
@@ -34,7 +52,7 @@ extern void __cmpxchg_wrong_size(void);
 			     : "memory");				\
 		break;							\
 	}								\
-	case 4:								\
+	case __X86_CASE_L:						\
 	{								\
 		volatile u32 *__ptr = (volatile u32 *)(ptr);		\
 		asm volatile("xchgl %0,%1"				\
@@ -43,7 +61,7 @@ extern void __cmpxchg_wrong_size(void);
 			     : "memory");				\
 		break;							\
 	}								\
-	case 8:								\
+	case __X86_CASE_Q:						\
 	{								\
 		volatile u64 *__ptr = (volatile u64 *)(ptr);		\
 		asm volatile("xchgq %0,%1"				\
@@ -72,7 +90,7 @@ extern void __cmpxchg_wrong_size(void);
 	__typeof__(*(ptr)) __old = (old);				\
 	__typeof__(*(ptr)) __new = (new);				\
 	switch (size) {							\
-	case 1:								\
+	case __X86_CASE_B:						\
 	{								\
 		volatile u8 *__ptr = (volatile u8 *)(ptr);		\
 		asm volatile(lock "cmpxchgb %2,%1; " compare		\
@@ -81,7 +99,7 @@ extern void __cmpxchg_wrong_size(void);
 			     : "memory");				\
 		break;							\
 	}								\
-	case 2:								\
+	case __X86_CASE_W:						\
 	{								\
 		volatile u16 *__ptr = (volatile u16 *)(ptr);		\
 		asm volatile(lock "cmpxchgw %2,%1; " compare		\
@@ -90,7 +108,7 @@ extern void __cmpxchg_wrong_size(void);
 			     : "memory");				\
 		break;							\
 	}								\
-	case 4:								\
+	case __X86_CASE_L:						\
 	{								\
 		volatile u32 *__ptr = (volatile u32 *)(ptr);		\
 		asm volatile(lock "cmpxchgl %2,%1; " compare		\
@@ -99,7 +117,7 @@ extern void __cmpxchg_wrong_size(void);
 			     : "memory");				\
 		break;							\
 	}								\
-	case 8:								\
+	case __X86_CASE_Q:						\
 	{								\
 		volatile u64 *__ptr = (volatile u64 *)(ptr);		\
 		asm volatile(lock "cmpxchgq %2,%1; " compare		\
@@ -178,26 +196,28 @@ extern void __cmpxchg_wrong_size(void);
 #define xadd(ptr, inc)							\
 	do {								\
 		switch (sizeof(*(ptr))) {				\
-		case 1:							\
+		case __X86_CASE_B:					\
 			asm volatile (LOCK_PREFIX "xaddb %b0, %1\n"	\
 				      : "+r" (inc), "+m" (*(ptr))	\
 				      : : "memory", "cc");		\
 			break;						\
-		case 2:							\
+		case __X86_CASE_W:					\
 			asm volatile (LOCK_PREFIX "xaddw %w0, %1\n"	\
 				      : "+r" (inc), "+m" (*(ptr))	\
 				      : : "memory", "cc");		\
 			break;						\
-		case 4:							\
+		case __X86_CASE_L:					\
 			asm volatile (LOCK_PREFIX "xaddl %0, %1\n"	\
 				      : "+r" (inc), "+m" (*(ptr))	\
 				      : : "memory", "cc");		\
 			break;						\
-		case 8:							\
+		case __X86_CASE_Q:					\
 			asm volatile (LOCK_PREFIX "xaddq %q0, %1\n"	\
 				      : "+r" (inc), "+m" (*(ptr))	\
 				      : : "memory", "cc");		\
 			break;						\
+		default:						\
+			__xadd_wrong_size();				\
 		}							\
 	} while(0)
 
-- 
1.7.6

