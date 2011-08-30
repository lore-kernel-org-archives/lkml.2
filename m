Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752618Ab1H3FY0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 01:24:26 -0400
Received: from hera.kernel.org ([140.211.167.34]:48845 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751180Ab1H3FYY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 01:24:24 -0400
Date: Tue, 30 Aug 2011 05:23:53 GMT
From: tip-bot for Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Message-ID: <tip-e9826380d83d1bda3ee5663bf3fa4667a6fbe60a@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        tglx@linutronix.de, hpa@linux.intel.com,
        jeremy.fitzhardinge@citrix.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, hpa@linux.intel.com,
        jeremy.fitzhardinge@citrix.com
In-Reply-To: <4E5BCC40.3030501@goop.org>
References: <4E5BCC40.3030501@goop.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/spinlocks] x86, cmpxchg: Unify cmpxchg into cmpxchg.h
Git-Commit-ID: e9826380d83d1bda3ee5663bf3fa4667a6fbe60a
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (hera.kernel.org [127.0.0.1]); Tue, 30 Aug 2011 05:24:15 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e9826380d83d1bda3ee5663bf3fa4667a6fbe60a
Gitweb:     http://git.kernel.org/tip/e9826380d83d1bda3ee5663bf3fa4667a6fbe60a
Author:     Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
AuthorDate: Thu, 18 Aug 2011 11:48:06 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Mon, 29 Aug 2011 13:42:10 -0700

x86, cmpxchg: Unify cmpxchg into cmpxchg.h

Everything that's actually common between 32 and 64-bit is moved into
cmpxchg.h.

xchg/cmpxchg will fail with a link error if they're passed an
unsupported size (which includes 64-bit args on 32-bit systems).

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Link: http://lkml.kernel.org/r/4E5BCC40.3030501@goop.org
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/include/asm/cmpxchg.h    |  155 +++++++++++++++++++++++++++++++++++++
 arch/x86/include/asm/cmpxchg_32.h |  113 ---------------------------
 arch/x86/include/asm/cmpxchg_64.h |  131 -------------------------------
 3 files changed, 155 insertions(+), 244 deletions(-)

diff --git a/arch/x86/include/asm/cmpxchg.h b/arch/x86/include/asm/cmpxchg.h
index a460fa0..efe3ec7 100644
--- a/arch/x86/include/asm/cmpxchg.h
+++ b/arch/x86/include/asm/cmpxchg.h
@@ -1,5 +1,160 @@
+#ifndef ASM_X86_CMPXCHG_H
+#define ASM_X86_CMPXCHG_H
+
+#include <asm/alternative.h> /* Provides LOCK_PREFIX */
+
+/* Non-existant functions to indicate usage errors at link time. */
+extern void __xchg_wrong_size(void);
+extern void __cmpxchg_wrong_size(void);
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
+	case __X86_CASE_B:						\
+	{								\
+		volatile u8 *__ptr = (volatile u8 *)(ptr);		\
+		asm volatile("xchgb %0,%1"				\
+			     : "=q" (__x), "+m" (*__ptr)		\
+			     : "0" (__x)				\
+			     : "memory");				\
+		break;							\
+	}								\
+	case __X86_CASE_W:						\
+	{								\
+		volatile u16 *__ptr = (volatile u16 *)(ptr);		\
+		asm volatile("xchgw %0,%1"				\
+			     : "=r" (__x), "+m" (*__ptr)		\
+			     : "0" (__x)				\
+			     : "memory");				\
+		break;							\
+	}								\
+	case __X86_CASE_L:						\
+	{								\
+		volatile u32 *__ptr = (volatile u32 *)(ptr);		\
+		asm volatile("xchgl %0,%1"				\
+			     : "=r" (__x), "+m" (*__ptr)		\
+			     : "0" (__x)				\
+			     : "memory");				\
+		break;							\
+	}								\
+	case __X86_CASE_Q:						\
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
+	case __X86_CASE_B:						\
+	{								\
+		volatile u8 *__ptr = (volatile u8 *)(ptr);		\
+		asm volatile(lock "cmpxchgb %2,%1"			\
+			     : "=a" (__ret), "+m" (*__ptr)		\
+			     : "q" (__new), "0" (__old)			\
+			     : "memory");				\
+		break;							\
+	}								\
+	case __X86_CASE_W:						\
+	{								\
+		volatile u16 *__ptr = (volatile u16 *)(ptr);		\
+		asm volatile(lock "cmpxchgw %2,%1"			\
+			     : "=a" (__ret), "+m" (*__ptr)		\
+			     : "r" (__new), "0" (__old)			\
+			     : "memory");				\
+		break;							\
+	}								\
+	case __X86_CASE_L:						\
+	{								\
+		volatile u32 *__ptr = (volatile u32 *)(ptr);		\
+		asm volatile(lock "cmpxchgl %2,%1"			\
+			     : "=a" (__ret), "+m" (*__ptr)		\
+			     : "r" (__new), "0" (__old)			\
+			     : "memory");				\
+		break;							\
+	}								\
+	case __X86_CASE_Q:						\
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
 # include "cmpxchg_64.h"
 #endif
+
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
+#endif	/* ASM_X86_CMPXCHG_H */
diff --git a/arch/x86/include/asm/cmpxchg_32.h b/arch/x86/include/asm/cmpxchg_32.h
index 59d8e36..fbebb07 100644
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
index 5bfa560..285da02 100644
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
