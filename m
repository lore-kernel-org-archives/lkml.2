Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933470Ab1JZPxI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Oct 2011 11:53:08 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:37791 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933042Ab1JZPxG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Oct 2011 11:53:06 -0400
Date: Wed, 26 Oct 2011 17:51:12 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [GIT PULL] x86/spinlock changes for v3.2
Message-ID: <20111026155112.GA4391@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=AWL,BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
	0.0 AWL                    AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-spinlocks-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-spinlocks-for-linus

 Thanks,

	Ingo

------------------>
Jeremy Fitzhardinge (12):
      x86, cmpxchg: <linux/alternative.h> has LOCK_PREFIX
      x86, cmpxchg: Move 32-bit __cmpxchg_wrong_size to match 64 bit.
      x86, cmpxchg: Move 64-bit set64_bit() to match 32-bit
      x86, cmpxchg: Unify cmpxchg into cmpxchg.h
      x86: Add xadd helper macro
      x86: Use xadd helper more widely
      x86, ticketlock: Clean up types and accessors
      x86, ticketlock: Convert spin loop to C
      x86, ticketlock: Convert __ticket_spin_lock to use xadd()
      x86, ticketlock: Make __ticket_spin_trylock common
      x86, cmpxchg: Use __compiletime_error() to make usage messages a bit nicer
      x86, ticketlock: remove obsolete comment


 arch/x86/include/asm/atomic.h         |    8 +-
 arch/x86/include/asm/atomic64_64.h    |    6 +-
 arch/x86/include/asm/cmpxchg.h        |  205 +++++++++++++++++++++++++++++++++
 arch/x86/include/asm/cmpxchg_32.h     |  114 ------------------
 arch/x86/include/asm/cmpxchg_64.h     |  131 ---------------------
 arch/x86/include/asm/rwsem.h          |    8 +-
 arch/x86/include/asm/spinlock.h       |  114 +++++--------------
 arch/x86/include/asm/spinlock_types.h |   22 +++-
 arch/x86/include/asm/uv/uv_bau.h      |    6 +-
 9 files changed, 257 insertions(+), 357 deletions(-)

diff --git a/arch/x86/include/asm/atomic.h b/arch/x86/include/asm/atomic.h
index 10572e3..58cb6d4 100644
--- a/arch/x86/include/asm/atomic.h
+++ b/arch/x86/include/asm/atomic.h
@@ -172,18 +172,14 @@ static inline int atomic_add_negative(int i, atomic_t *v)
  */
 static inline int atomic_add_return(int i, atomic_t *v)
 {
-	int __i;
 #ifdef CONFIG_M386
+	int __i;
 	unsigned long flags;
 	if (unlikely(boot_cpu_data.x86 <= 3))
 		goto no_xadd;
 #endif
 	/* Modern 486+ processor */
-	__i = i;
-	asm volatile(LOCK_PREFIX "xaddl %0, %1"
-		     : "+r" (i), "+m" (v->counter)
-		     : : "memory");
-	return i + __i;
+	return i + xadd(&v->counter, i);
 
 #ifdef CONFIG_M386
 no_xadd: /* Legacy 386 processor */
diff --git a/arch/x86/include/asm/atomic64_64.h b/arch/x86/include/asm/atomic64_64.h
index 017594d..0e1cbfc 100644
--- a/arch/x86/include/asm/atomic64_64.h
+++ b/arch/x86/include/asm/atomic64_64.h
@@ -170,11 +170,7 @@ static inline int atomic64_add_negative(long i, atomic64_t *v)
  */
 static inline long atomic64_add_return(long i, atomic64_t *v)
 {
-	long __i = i;
-	asm volatile(LOCK_PREFIX "xaddq %0, %1;"
-		     : "+r" (i), "+m" (v->counter)
-		     : : "memory");
-	return i + __i;
+	return i + xadd(&v->counter, i);
 }
 
 static inline long atomic64_sub_return(long i, atomic64_t *v)
diff --git a/arch/x86/include/asm/cmpxchg.h b/arch/x86/include/asm/cmpxchg.h
index a460fa0..5d3acdf 100644
--- a/arch/x86/include/asm/cmpxchg.h
+++ b/arch/x86/include/asm/cmpxchg.h
@@ -1,5 +1,210 @@
+#ifndef ASM_X86_CMPXCHG_H
+#define ASM_X86_CMPXCHG_H
+
+#include <linux/compiler.h>
+#include <asm/alternative.h> /* Provides LOCK_PREFIX */
+
+/*
+ * Non-existant functions to indicate usage errors at link time
+ * (or compile-time if the compiler implements __compiletime_error().
+ */
+extern void __xchg_wrong_size(void)
+	__compiletime_error("Bad argument size for xchg");
+extern void __cmpxchg_wrong_size(void)
+	__compiletime_error("Bad argument size for cmpxchg");
+extern void __xadd_wrong_size(void)
+	__compiletime_error("Bad argument size for xadd");
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
+#define __xadd(ptr, inc, lock)						\
+	({								\
+	        __typeof__ (*(ptr)) __ret = (inc);			\
+		switch (sizeof(*(ptr))) {				\
+		case __X86_CASE_B:					\
+			asm volatile (lock "xaddb %b0, %1\n"		\
+				      : "+r" (__ret), "+m" (*(ptr))	\
+				      : : "memory", "cc");		\
+			break;						\
+		case __X86_CASE_W:					\
+			asm volatile (lock "xaddw %w0, %1\n"		\
+				      : "+r" (__ret), "+m" (*(ptr))	\
+				      : : "memory", "cc");		\
+			break;						\
+		case __X86_CASE_L:					\
+			asm volatile (lock "xaddl %0, %1\n"		\
+				      : "+r" (__ret), "+m" (*(ptr))	\
+				      : : "memory", "cc");		\
+			break;						\
+		case __X86_CASE_Q:					\
+			asm volatile (lock "xaddq %q0, %1\n"		\
+				      : "+r" (__ret), "+m" (*(ptr))	\
+				      : : "memory", "cc");		\
+			break;						\
+		default:						\
+			__xadd_wrong_size();				\
+		}							\
+		__ret;							\
+	})
+
+/*
+ * xadd() adds "inc" to "*ptr" and atomically returns the previous
+ * value of "*ptr".
+ *
+ * xadd() is locked when multiple CPUs are online
+ * xadd_sync() is always locked
+ * xadd_local() is never locked
+ */
+#define xadd(ptr, inc)		__xadd((ptr), (inc), LOCK_PREFIX)
+#define xadd_sync(ptr, inc)	__xadd((ptr), (inc), "lock; ")
+#define xadd_local(ptr, inc)	__xadd((ptr), (inc), "")
+
+#endif	/* ASM_X86_CMPXCHG_H */
diff --git a/arch/x86/include/asm/cmpxchg_32.h b/arch/x86/include/asm/cmpxchg_32.h
index 3deb725..fbebb07 100644
--- a/arch/x86/include/asm/cmpxchg_32.h
+++ b/arch/x86/include/asm/cmpxchg_32.h
@@ -1,61 +1,11 @@
 #ifndef _ASM_X86_CMPXCHG_32_H
 #define _ASM_X86_CMPXCHG_32_H
 
-#include <linux/bitops.h> /* for LOCK_PREFIX */
-
 /*
  * Note: if you use set64_bit(), __cmpxchg64(), or their variants, you
  *       you need to test for the feature in boot_cpu_data.
  */
 
-extern void __xchg_wrong_size(void);
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
@@ -84,72 +34,8 @@ static inline void set_64bit(volatile u64 *ptr, u64 value)
 		     : "memory");
 }
 
-extern void __cmpxchg_wrong_size(void);
-
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
index 7cf5c0a..285da02 100644
--- a/arch/x86/include/asm/cmpxchg_64.h
+++ b/arch/x86/include/asm/cmpxchg_64.h
@@ -1,144 +1,13 @@
 #ifndef _ASM_X86_CMPXCHG_64_H
 #define _ASM_X86_CMPXCHG_64_H
 
-#include <asm/alternative.h> /* Provides LOCK_PREFIX */
-
 static inline void set_64bit(volatile u64 *ptr, u64 val)
 {
 	*ptr = val;
 }
 
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
diff --git a/arch/x86/include/asm/rwsem.h b/arch/x86/include/asm/rwsem.h
index df4cd32..2dbe4a7 100644
--- a/arch/x86/include/asm/rwsem.h
+++ b/arch/x86/include/asm/rwsem.h
@@ -204,13 +204,7 @@ static inline void rwsem_atomic_add(long delta, struct rw_semaphore *sem)
  */
 static inline long rwsem_atomic_update(long delta, struct rw_semaphore *sem)
 {
-	long tmp = delta;
-
-	asm volatile(LOCK_PREFIX "xadd %0,%1"
-		     : "+r" (tmp), "+m" (sem->count)
-		     : : "memory");
-
-	return tmp + delta;
+	return delta + xadd(&sem->count, delta);
 }
 
 #endif /* __KERNEL__ */
diff --git a/arch/x86/include/asm/spinlock.h b/arch/x86/include/asm/spinlock.h
index ee67edf..972c260 100644
--- a/arch/x86/include/asm/spinlock.h
+++ b/arch/x86/include/asm/spinlock.h
@@ -49,109 +49,49 @@
  * issues and should be optimal for the uncontended case. Note the tail must be
  * in the high part, because a wide xadd increment of the low part would carry
  * up and contaminate the high part.
- *
- * With fewer than 2^8 possible CPUs, we can use x86's partial registers to
- * save some instructions and make the code more elegant. There really isn't
- * much between them in performance though, especially as locks are out of line.
  */
-#if (NR_CPUS < 256)
-#define TICKET_SHIFT 8
-
 static __always_inline void __ticket_spin_lock(arch_spinlock_t *lock)
 {
-	short inc = 0x0100;
-
-	asm volatile (
-		LOCK_PREFIX "xaddw %w0, %1\n"
-		"1:\t"
-		"cmpb %h0, %b0\n\t"
-		"je 2f\n\t"
-		"rep ; nop\n\t"
-		"movb %1, %b0\n\t"
-		/* don't need lfence here, because loads are in-order */
-		"jmp 1b\n"
-		"2:"
-		: "+Q" (inc), "+m" (lock->slock)
-		:
-		: "memory", "cc");
+	register struct __raw_tickets inc = { .tail = 1 };
+
+	inc = xadd(&lock->tickets, inc);
+
+	for (;;) {
+		if (inc.head == inc.tail)
+			break;
+		cpu_relax();
+		inc.head = ACCESS_ONCE(lock->tickets.head);
+	}
+	barrier();		/* make sure nothing creeps before the lock is taken */
 }
 
 static __always_inline int __ticket_spin_trylock(arch_spinlock_t *lock)
 {
-	int tmp, new;
-
-	asm volatile("movzwl %2, %0\n\t"
-		     "cmpb %h0,%b0\n\t"
-		     "leal 0x100(%" REG_PTR_MODE "0), %1\n\t"
-		     "jne 1f\n\t"
-		     LOCK_PREFIX "cmpxchgw %w1,%2\n\t"
-		     "1:"
-		     "sete %b1\n\t"
-		     "movzbl %b1,%0\n\t"
-		     : "=&a" (tmp), "=&q" (new), "+m" (lock->slock)
-		     :
-		     : "memory", "cc");
+	arch_spinlock_t old, new;
+
+	old.tickets = ACCESS_ONCE(lock->tickets);
+	if (old.tickets.head != old.tickets.tail)
+		return 0;
+
+	new.head_tail = old.head_tail + (1 << TICKET_SHIFT);
 
-	return tmp;
+	/* cmpxchg is a full barrier, so nothing can move before it */
+	return cmpxchg(&lock->head_tail, old.head_tail, new.head_tail) == old.head_tail;
 }
 
+#if (NR_CPUS < 256)
 static __always_inline void __ticket_spin_unlock(arch_spinlock_t *lock)
 {
 	asm volatile(UNLOCK_LOCK_PREFIX "incb %0"
-		     : "+m" (lock->slock)
+		     : "+m" (lock->head_tail)
 		     :
 		     : "memory", "cc");
 }
 #else
-#define TICKET_SHIFT 16
-
-static __always_inline void __ticket_spin_lock(arch_spinlock_t *lock)
-{
-	int inc = 0x00010000;
-	int tmp;
-
-	asm volatile(LOCK_PREFIX "xaddl %0, %1\n"
-		     "movzwl %w0, %2\n\t"
-		     "shrl $16, %0\n\t"
-		     "1:\t"
-		     "cmpl %0, %2\n\t"
-		     "je 2f\n\t"
-		     "rep ; nop\n\t"
-		     "movzwl %1, %2\n\t"
-		     /* don't need lfence here, because loads are in-order */
-		     "jmp 1b\n"
-		     "2:"
-		     : "+r" (inc), "+m" (lock->slock), "=&r" (tmp)
-		     :
-		     : "memory", "cc");
-}
-
-static __always_inline int __ticket_spin_trylock(arch_spinlock_t *lock)
-{
-	int tmp;
-	int new;
-
-	asm volatile("movl %2,%0\n\t"
-		     "movl %0,%1\n\t"
-		     "roll $16, %0\n\t"
-		     "cmpl %0,%1\n\t"
-		     "leal 0x00010000(%" REG_PTR_MODE "0), %1\n\t"
-		     "jne 1f\n\t"
-		     LOCK_PREFIX "cmpxchgl %1,%2\n\t"
-		     "1:"
-		     "sete %b1\n\t"
-		     "movzbl %b1,%0\n\t"
-		     : "=&a" (tmp), "=&q" (new), "+m" (lock->slock)
-		     :
-		     : "memory", "cc");
-
-	return tmp;
-}
-
 static __always_inline void __ticket_spin_unlock(arch_spinlock_t *lock)
 {
 	asm volatile(UNLOCK_LOCK_PREFIX "incw %0"
-		     : "+m" (lock->slock)
+		     : "+m" (lock->head_tail)
 		     :
 		     : "memory", "cc");
 }
@@ -159,16 +99,16 @@ static __always_inline void __ticket_spin_unlock(arch_spinlock_t *lock)
 
 static inline int __ticket_spin_is_locked(arch_spinlock_t *lock)
 {
-	int tmp = ACCESS_ONCE(lock->slock);
+	struct __raw_tickets tmp = ACCESS_ONCE(lock->tickets);
 
-	return !!(((tmp >> TICKET_SHIFT) ^ tmp) & ((1 << TICKET_SHIFT) - 1));
+	return !!(tmp.tail ^ tmp.head);
 }
 
 static inline int __ticket_spin_is_contended(arch_spinlock_t *lock)
 {
-	int tmp = ACCESS_ONCE(lock->slock);
+	struct __raw_tickets tmp = ACCESS_ONCE(lock->tickets);
 
-	return (((tmp >> TICKET_SHIFT) - tmp) & ((1 << TICKET_SHIFT) - 1)) > 1;
+	return ((tmp.tail - tmp.head) & TICKET_MASK) > 1;
 }
 
 #ifndef CONFIG_PARAVIRT_SPINLOCKS
diff --git a/arch/x86/include/asm/spinlock_types.h b/arch/x86/include/asm/spinlock_types.h
index 7c7a486..8ebd5df 100644
--- a/arch/x86/include/asm/spinlock_types.h
+++ b/arch/x86/include/asm/spinlock_types.h
@@ -5,11 +5,29 @@
 # error "please don't include this file directly"
 #endif
 
+#include <linux/types.h>
+
+#if (CONFIG_NR_CPUS < 256)
+typedef u8  __ticket_t;
+typedef u16 __ticketpair_t;
+#else
+typedef u16 __ticket_t;
+typedef u32 __ticketpair_t;
+#endif
+
+#define TICKET_SHIFT	(sizeof(__ticket_t) * 8)
+#define TICKET_MASK	((__ticket_t)((1 << TICKET_SHIFT) - 1))
+
 typedef struct arch_spinlock {
-	unsigned int slock;
+	union {
+		__ticketpair_t head_tail;
+		struct __raw_tickets {
+			__ticket_t head, tail;
+		} tickets;
+	};
 } arch_spinlock_t;
 
-#define __ARCH_SPIN_LOCK_UNLOCKED	{ 0 }
+#define __ARCH_SPIN_LOCK_UNLOCKED	{ { 0 } }
 
 #include <asm/rwlock.h>
 
diff --git a/arch/x86/include/asm/uv/uv_bau.h b/arch/x86/include/asm/uv/uv_bau.h
index 37d3698..c568ccc 100644
--- a/arch/x86/include/asm/uv/uv_bau.h
+++ b/arch/x86/include/asm/uv/uv_bau.h
@@ -656,11 +656,7 @@ static inline int atomic_read_short(const struct atomic_short *v)
  */
 static inline int atom_asr(short i, struct atomic_short *v)
 {
-	short __i = i;
-	asm volatile(LOCK_PREFIX "xaddw %0, %1"
-			: "+r" (i), "+m" (v->counter)
-			: : "memory");
-	return i + __i;
+	return i + xadd(&v->counter, i);
 }
 
 /*
