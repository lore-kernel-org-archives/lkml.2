Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751717Ab1KIBRI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 20:17:08 -0500
Received: from claw.goop.org ([74.207.240.146]:56314 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751281Ab1KIBRG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 20:17:06 -0500
Message-ID: <4EB9D48F.5010201@goop.org>
Date: Tue, 08 Nov 2011 17:17:03 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>
CC: the arch/x86 maintainers <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [GIT PULL] More cleanups for atomic memory operations/spinlocks
X-Enigmail-Version: 1.3.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I forgot to push these for the just-closed merge window, but they're
fine for the next one.  Could you find them a home in tip.git?

Thanks,
    J

The following changes since commit 1ea6b8f48918282bdca0b32a34095504ee65bab5:

  Linux 3.2-rc1 (2011-11-07 16:16:02 -0800)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/jeremy/xen.git upstream/ticketlock-cleanup

Jeremy Fitzhardinge (2):
      x86/cmpxchg: add a locked add() helper
      x86: consolidate xchg and xadd macros

 arch/x86/include/asm/cmpxchg.h  |  140 +++++++++++++++++++-------------------
 arch/x86/include/asm/spinlock.h |   15 +----
 2 files changed, 71 insertions(+), 84 deletions(-)

diff --git a/arch/x86/include/asm/cmpxchg.h b/arch/x86/include/asm/cmpxchg.h
index 5d3acdf..5488e10 100644
--- a/arch/x86/include/asm/cmpxchg.h
+++ b/arch/x86/include/asm/cmpxchg.h
@@ -14,6 +14,8 @@ extern void __cmpxchg_wrong_size(void)
 	__compiletime_error("Bad argument size for cmpxchg");
 extern void __xadd_wrong_size(void)
 	__compiletime_error("Bad argument size for xadd");
+extern void __add_wrong_size(void)
+	__compiletime_error("Bad argument size for add");
 
 /*
  * Constants for operation sizes. On 32-bit, the 64-bit size it set to
@@ -31,60 +33,47 @@ extern void __xadd_wrong_size(void)
 #define	__X86_CASE_Q	-1		/* sizeof will never return -1 */
 #endif
 
+/* 
+ * An exchange-type operation, which takes a value and a pointer, and
+ * returns a the old value.
+ */
+#define __xchg_op(ptr, arg, op, lock)					\
+	({								\
+	        __typeof__ (*(ptr)) __ret = (arg);			\
+		switch (sizeof(*(ptr))) {				\
+		case __X86_CASE_B:					\
+			asm volatile (lock #op "b %b0, %1\n"		\
+				      : "+r" (__ret), "+m" (*(ptr))	\
+				      : : "memory", "cc");		\
+			break;						\
+		case __X86_CASE_W:					\
+			asm volatile (lock #op "w %w0, %1\n"		\
+				      : "+r" (__ret), "+m" (*(ptr))	\
+				      : : "memory", "cc");		\
+			break;						\
+		case __X86_CASE_L:					\
+			asm volatile (lock #op "l %0, %1\n"		\
+				      : "+r" (__ret), "+m" (*(ptr))	\
+				      : : "memory", "cc");		\
+			break;						\
+		case __X86_CASE_Q:					\
+			asm volatile (lock #op "q %q0, %1\n"		\
+				      : "+r" (__ret), "+m" (*(ptr))	\
+				      : : "memory", "cc");		\
+			break;						\
+		default:						\
+			__ ## op ## _wrong_size();			\
+		}							\
+		__ret;							\
+	})
+
 /*
  * Note: no "lock" prefix even on SMP: xchg always implies lock anyway.
  * Since this is generally used to protect other memory information, we
  * use "asm volatile" and "memory" clobbers to prevent gcc from moving
  * information around.
  */
-#define __xchg(x, ptr, size)						\
-({									\
-	__typeof(*(ptr)) __x = (x);					\
-	switch (size) {							\
-	case __X86_CASE_B:						\
-	{								\
-		volatile u8 *__ptr = (volatile u8 *)(ptr);		\
-		asm volatile("xchgb %0,%1"				\
-			     : "=q" (__x), "+m" (*__ptr)		\
-			     : "0" (__x)				\
-			     : "memory");				\
-		break;							\
-	}								\
-	case __X86_CASE_W:						\
-	{								\
-		volatile u16 *__ptr = (volatile u16 *)(ptr);		\
-		asm volatile("xchgw %0,%1"				\
-			     : "=r" (__x), "+m" (*__ptr)		\
-			     : "0" (__x)				\
-			     : "memory");				\
-		break;							\
-	}								\
-	case __X86_CASE_L:						\
-	{								\
-		volatile u32 *__ptr = (volatile u32 *)(ptr);		\
-		asm volatile("xchgl %0,%1"				\
-			     : "=r" (__x), "+m" (*__ptr)		\
-			     : "0" (__x)				\
-			     : "memory");				\
-		break;							\
-	}								\
-	case __X86_CASE_Q:						\
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
+#define xchg(ptr, v)	__xchg_op((ptr), (v), xchg, "")
 
 /*
  * Atomic compare and exchange.  Compare OLD with MEM, if identical,
@@ -165,46 +154,57 @@ extern void __xadd_wrong_size(void)
 	__cmpxchg_local((ptr), (old), (new), sizeof(*ptr))
 #endif
 
-#define __xadd(ptr, inc, lock)						\
+/*
+ * xadd() adds "inc" to "*ptr" and atomically returns the previous
+ * value of "*ptr".
+ *
+ * xadd() is locked when multiple CPUs are online
+ * xadd_sync() is always locked
+ * xadd_local() is never locked
+ */
+#define __xadd(ptr, inc, lock)	__xchg_op((ptr), (inc), xadd, lock)
+#define xadd(ptr, inc)		__xadd((ptr), (inc), LOCK_PREFIX)
+#define xadd_sync(ptr, inc)	__xadd((ptr), (inc), "lock; ")
+#define xadd_local(ptr, inc)	__xadd((ptr), (inc), "")
+
+#define __add(ptr, inc, lock)						\
 	({								\
 	        __typeof__ (*(ptr)) __ret = (inc);			\
 		switch (sizeof(*(ptr))) {				\
 		case __X86_CASE_B:					\
-			asm volatile (lock "xaddb %b0, %1\n"		\
-				      : "+r" (__ret), "+m" (*(ptr))	\
-				      : : "memory", "cc");		\
+			asm volatile (lock "addb %b1, %0\n"		\
+				      : "+m" (*(ptr)) : "ri" (inc)	\
+				      : "memory", "cc");		\
 			break;						\
 		case __X86_CASE_W:					\
-			asm volatile (lock "xaddw %w0, %1\n"		\
-				      : "+r" (__ret), "+m" (*(ptr))	\
-				      : : "memory", "cc");		\
+			asm volatile (lock "addw %w1, %0\n"		\
+				      : "+m" (*(ptr)) : "ri" (inc)	\
+				      : "memory", "cc");		\
 			break;						\
 		case __X86_CASE_L:					\
-			asm volatile (lock "xaddl %0, %1\n"		\
-				      : "+r" (__ret), "+m" (*(ptr))	\
-				      : : "memory", "cc");		\
+			asm volatile (lock "addl %1, %0\n"		\
+				      : "+m" (*(ptr)) : "ri" (inc)	\
+				      : "memory", "cc");		\
 			break;						\
 		case __X86_CASE_Q:					\
-			asm volatile (lock "xaddq %q0, %1\n"		\
-				      : "+r" (__ret), "+m" (*(ptr))	\
-				      : : "memory", "cc");		\
+			asm volatile (lock "addq %1, %0\n"		\
+				      : "+m" (*(ptr)) : "ri" (inc)	\
+				      : "memory", "cc");		\
 			break;						\
 		default:						\
-			__xadd_wrong_size();				\
+			__add_wrong_size();				\
 		}							\
 		__ret;							\
 	})
 
 /*
- * xadd() adds "inc" to "*ptr" and atomically returns the previous
- * value of "*ptr".
+ * add_*() adds "inc" to "*ptr"
  *
- * xadd() is locked when multiple CPUs are online
- * xadd_sync() is always locked
- * xadd_local() is never locked
+ * __add() takes a lock prefix
+ * add_smp() is locked when multiple CPUs are online
+ * add_sync() is always locked
  */
-#define xadd(ptr, inc)		__xadd((ptr), (inc), LOCK_PREFIX)
-#define xadd_sync(ptr, inc)	__xadd((ptr), (inc), "lock; ")
-#define xadd_local(ptr, inc)	__xadd((ptr), (inc), "")
+#define add_smp(ptr, inc)	__add((ptr), (inc), LOCK_PREFIX)
+#define add_sync(ptr, inc)	__add((ptr), (inc), "lock; ")
 
 #endif	/* ASM_X86_CMPXCHG_H */
diff --git a/arch/x86/include/asm/spinlock.h b/arch/x86/include/asm/spinlock.h
index 972c260..a82c2bf 100644
--- a/arch/x86/include/asm/spinlock.h
+++ b/arch/x86/include/asm/spinlock.h
@@ -79,23 +79,10 @@ static __always_inline int __ticket_spin_trylock(arch_spinlock_t *lock)
 	return cmpxchg(&lock->head_tail, old.head_tail, new.head_tail) == old.head_tail;
 }
 
-#if (NR_CPUS < 256)
 static __always_inline void __ticket_spin_unlock(arch_spinlock_t *lock)
 {
-	asm volatile(UNLOCK_LOCK_PREFIX "incb %0"
-		     : "+m" (lock->head_tail)
-		     :
-		     : "memory", "cc");
+	__add(&lock->tickets.head, 1, UNLOCK_LOCK_PREFIX);
 }
-#else
-static __always_inline void __ticket_spin_unlock(arch_spinlock_t *lock)
-{
-	asm volatile(UNLOCK_LOCK_PREFIX "incw %0"
-		     : "+m" (lock->head_tail)
-		     :
-		     : "memory", "cc");
-}
-#endif
 
 static inline int __ticket_spin_is_locked(arch_spinlock_t *lock)
 {


