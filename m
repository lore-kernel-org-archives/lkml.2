Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934462Ab0HEUlM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 16:41:12 -0400
Received: from hera.kernel.org ([140.211.167.34]:52108 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932794Ab0HEUlG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 16:41:06 -0400
Date: Thu, 5 Aug 2010 20:37:59 GMT
Message-Id: <201008052037.o75KbxSS022005@hera.kernel.org>
From: "H. Peter Anvin" <hpa@linux.intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [GIT PULL] x86/asm for 2.6.36
Cc: <stable@kernel.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Avi Kivity <avi@redhat.com>, Brian Gerst <brgerst@gmail.com>,
        Glauber Costa <glommer@redhat.com>, Greg KH <gregkh@suse.de>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Jeff Dike <jdike@addtoit.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Pekka Enberg <penberg@cs.helsinki.fi>,
        Peter Palfrader <peter@palfrader.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Zachary Amsden <zamsden@redhat.com>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 05 Aug 2010 20:38:00 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

The following changes since commit cdd854bc42b5e6c79bbbc40c6600d995ffe6e747:

  Merge branch 'next' of git://git.kernel.org/pub/scm/linux/kernel/git/benh/powerpc (2010-08-05 09:03:46 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-asm-for-linus

Brian Gerst (5):
      x86: Remove redundant K6 MSRs
      x86: Use symbolic MSR names
      x86-64: Simplify loading initial_gs
      x86-64, asm: Directly access per-cpu IST
      x86-32, asm: Directly access per-cpu GDT

H. Peter Anvin (7):
      x86: Add memory modify constraints to xchg() and cmpxchg()
      Merge remote branch 'origin/x86/urgent' into x86/asm
      x86, asm: Clean up and simplify set_64bit()
      x86, asm: Clean up and simplify <asm/cmpxchg.h>
      x86, asm: Move cmpxchg emulation code to arch/x86/lib
      x86, asm: Merge cmpxchg_486_u64() and cmpxchg8b_emu()
      um, x86: Cast to (u64 *) inside set_64bit()

 arch/um/include/asm/pgtable-3level.h   |    4 +-
 arch/x86/include/asm/cmpxchg_32.h      |  198 ++++++++++++++-----------------
 arch/x86/include/asm/cmpxchg_64.h      |   83 +++++++++-----
 arch/x86/include/asm/msr-index.h       |    2 -
 arch/x86/kernel/acpi/realmode/wakeup.S |    2 +-
 arch/x86/kernel/cpu/Makefile           |    2 +-
 arch/x86/kernel/entry_32.S             |   11 +-
 arch/x86/kernel/entry_64.S             |    6 +-
 arch/x86/kernel/head_64.S              |    5 +-
 arch/x86/kernel/verify_cpu_64.S        |    3 +-
 arch/x86/kvm/svm.c                     |    6 +-
 arch/x86/kvm/vmx.c                     |    8 +-
 arch/x86/kvm/x86.c                     |    2 +-
 arch/x86/lib/Makefile                  |    1 +
 arch/x86/{kernel/cpu => lib}/cmpxchg.c |   18 ---
 15 files changed, 166 insertions(+), 185 deletions(-)
 rename arch/x86/{kernel/cpu => lib}/cmpxchg.c (75%)

diff --git a/arch/um/include/asm/pgtable-3level.h b/arch/um/include/asm/pgtable-3level.h
index 084de4a..0032f92 100644
--- a/arch/um/include/asm/pgtable-3level.h
+++ b/arch/um/include/asm/pgtable-3level.h
@@ -60,7 +60,7 @@
 	set_pud(pud, __pud(_PAGE_TABLE + __pa(pmd)))
 
 #ifdef CONFIG_64BIT
-#define set_pud(pudptr, pudval) set_64bit((phys_t *) (pudptr), pud_val(pudval))
+#define set_pud(pudptr, pudval) set_64bit((u64 *) (pudptr), pud_val(pudval))
 #else
 #define set_pud(pudptr, pudval) (*(pudptr) = (pudval))
 #endif
@@ -73,7 +73,7 @@ static inline int pgd_newpage(pgd_t pgd)
 static inline void pgd_mkuptodate(pgd_t pgd) { pgd_val(pgd) &= ~_PAGE_NEWPAGE; }
 
 #ifdef CONFIG_64BIT
-#define set_pmd(pmdptr, pmdval) set_64bit((phys_t *) (pmdptr), pmd_val(pmdval))
+#define set_pmd(pmdptr, pmdval) set_64bit((u64 *) (pmdptr), pmd_val(pmdval))
 #else
 #define set_pmd(pmdptr, pmdval) (*(pmdptr) = (pmdval))
 #endif
diff --git a/arch/x86/include/asm/cmpxchg_32.h b/arch/x86/include/asm/cmpxchg_32.h
index 8859e12..284a6e8 100644
--- a/arch/x86/include/asm/cmpxchg_32.h
+++ b/arch/x86/include/asm/cmpxchg_32.h
@@ -11,38 +11,42 @@
 extern void __xchg_wrong_size(void);
 
 /*
- * Note: no "lock" prefix even on SMP: xchg always implies lock anyway
- * Note 2: xchg has side effect, so that attribute volatile is necessary,
- *	  but generally the primitive is invalid, *ptr is output argument. --ANK
+ * Note: no "lock" prefix even on SMP: xchg always implies lock anyway.
+ * Since this is generally used to protect other memory information, we
+ * use "asm volatile" and "memory" clobbers to prevent gcc from moving
+ * information around.
  */
-
-struct __xchg_dummy {
-	unsigned long a[100];
-};
-#define __xg(x) ((struct __xchg_dummy *)(x))
-
 #define __xchg(x, ptr, size)						\
 ({									\
 	__typeof(*(ptr)) __x = (x);					\
 	switch (size) {							\
 	case 1:								\
-		asm volatile("xchgb %b0,%1"				\
-			     : "=q" (__x)				\
-			     : "m" (*__xg(ptr)), "0" (__x)		\
+	{								\
+		volatile u8 *__ptr = (volatile u8 *)(ptr);		\
+		asm volatile("xchgb %0,%1"				\
+			     : "=q" (__x), "+m" (*__ptr)		\
+			     : "0" (__x)				\
 			     : "memory");				\
 		break;							\
+	}								\
 	case 2:								\
-		asm volatile("xchgw %w0,%1"				\
-			     : "=r" (__x)				\
-			     : "m" (*__xg(ptr)), "0" (__x)		\
+	{								\
+		volatile u16 *__ptr = (volatile u16 *)(ptr);		\
+		asm volatile("xchgw %0,%1"				\
+			     : "=r" (__x), "+m" (*__ptr)		\
+			     : "0" (__x)				\
 			     : "memory");				\
 		break;							\
+	}								\
 	case 4:								\
+	{								\
+		volatile u32 *__ptr = (volatile u32 *)(ptr);		\
 		asm volatile("xchgl %0,%1"				\
-			     : "=r" (__x)				\
-			     : "m" (*__xg(ptr)), "0" (__x)		\
+			     : "=r" (__x), "+m" (*__ptr)		\
+			     : "0" (__x)				\
 			     : "memory");				\
 		break;							\
+	}								\
 	default:							\
 		__xchg_wrong_size();					\
 	}								\
@@ -53,60 +57,33 @@ struct __xchg_dummy {
 	__xchg((v), (ptr), sizeof(*ptr))
 
 /*
- * The semantics of XCHGCMP8B are a bit strange, this is why
- * there is a loop and the loading of %%eax and %%edx has to
- * be inside. This inlines well in most cases, the cached
- * cost is around ~38 cycles. (in the future we might want
- * to do an SIMD/3DNOW!/MMX/FPU 64-bit store here, but that
- * might have an implicit FPU-save as a cost, so it's not
- * clear which path to go.)
+ * CMPXCHG8B only writes to the target if we had the previous
+ * value in registers, otherwise it acts as a read and gives us the
+ * "new previous" value.  That is why there is a loop.  Preloading
+ * EDX:EAX is a performance optimization: in the common case it means
+ * we need only one locked operation.
  *
- * cmpxchg8b must be used with the lock prefix here to allow
- * the instruction to be executed atomically, see page 3-102
- * of the instruction set reference 24319102.pdf. We need
- * the reader side to see the coherent 64bit value.
+ * A SIMD/3DNOW!/MMX/FPU 64-bit store here would require at the very
+ * least an FPU save and/or %cr0.ts manipulation.
+ *
+ * cmpxchg8b must be used with the lock prefix here to allow the
+ * instruction to be executed atomically.  We need to have the reader
+ * side to see the coherent 64bit value.
  */
-static inline void __set_64bit(unsigned long long *ptr,
-			       unsigned int low, unsigned int high)
+static inline void set_64bit(volatile u64 *ptr, u64 value)
 {
+	u32 low  = value;
+	u32 high = value >> 32;
+	u64 prev = *ptr;
+
 	asm volatile("\n1:\t"
-		     "movl (%0), %%eax\n\t"
-		     "movl 4(%0), %%edx\n\t"
-		     LOCK_PREFIX "cmpxchg8b (%0)\n\t"
+		     LOCK_PREFIX "cmpxchg8b %0\n\t"
 		     "jnz 1b"
-		     : /* no outputs */
-		     : "D"(ptr),
-		       "b"(low),
-		       "c"(high)
-		     : "ax", "dx", "memory");
-}
-
-static inline void __set_64bit_constant(unsigned long long *ptr,
-					unsigned long long value)
-{
-	__set_64bit(ptr, (unsigned int)value, (unsigned int)(value >> 32));
-}
-
-#define ll_low(x)	*(((unsigned int *)&(x)) + 0)
-#define ll_high(x)	*(((unsigned int *)&(x)) + 1)
-
-static inline void __set_64bit_var(unsigned long long *ptr,
-				   unsigned long long value)
-{
-	__set_64bit(ptr, ll_low(value), ll_high(value));
+		     : "=m" (*ptr), "+A" (prev)
+		     : "b" (low), "c" (high)
+		     : "memory");
 }
 
-#define set_64bit(ptr, value)			\
-	(__builtin_constant_p((value))		\
-	 ? __set_64bit_constant((ptr), (value))	\
-	 : __set_64bit_var((ptr), (value)))
-
-#define _set_64bit(ptr, value)						\
-	(__builtin_constant_p(value)					\
-	 ? __set_64bit(ptr, (unsigned int)(value),			\
-		       (unsigned int)((value) >> 32))			\
-	 : __set_64bit(ptr, ll_low((value)), ll_high((value))))
-
 extern void __cmpxchg_wrong_size(void);
 
 /*
@@ -121,23 +98,32 @@ extern void __cmpxchg_wrong_size(void);
 	__typeof__(*(ptr)) __new = (new);				\
 	switch (size) {							\
 	case 1:								\
-		asm volatile(lock "cmpxchgb %b1,%2"			\
-			     : "=a"(__ret)				\
-			     : "q"(__new), "m"(*__xg(ptr)), "0"(__old)	\
+	{								\
+		volatile u8 *__ptr = (volatile u8 *)(ptr);		\
+		asm volatile(lock "cmpxchgb %2,%1"			\
+			     : "=a" (__ret), "+m" (*__ptr)		\
+			     : "q" (__new), "0" (__old)			\
 			     : "memory");				\
 		break;							\
+	}								\
 	case 2:								\
-		asm volatile(lock "cmpxchgw %w1,%2"			\
-			     : "=a"(__ret)				\
-			     : "r"(__new), "m"(*__xg(ptr)), "0"(__old)	\
+	{								\
+		volatile u16 *__ptr = (volatile u16 *)(ptr);		\
+		asm volatile(lock "cmpxchgw %2,%1"			\
+			     : "=a" (__ret), "+m" (*__ptr)		\
+			     : "r" (__new), "0" (__old)			\
 			     : "memory");				\
 		break;							\
+	}								\
 	case 4:								\
-		asm volatile(lock "cmpxchgl %1,%2"			\
-			     : "=a"(__ret)				\
-			     : "r"(__new), "m"(*__xg(ptr)), "0"(__old)	\
+	{								\
+		volatile u32 *__ptr = (volatile u32 *)(ptr);		\
+		asm volatile(lock "cmpxchgl %2,%1"			\
+			     : "=a" (__ret), "+m" (*__ptr)		\
+			     : "r" (__new), "0" (__old)			\
 			     : "memory");				\
 		break;							\
+	}								\
 	default:							\
 		__cmpxchg_wrong_size();					\
 	}								\
@@ -175,32 +161,28 @@ extern void __cmpxchg_wrong_size(void);
 					       (unsigned long long)(n)))
 #endif
 
-static inline unsigned long long __cmpxchg64(volatile void *ptr,
-					     unsigned long long old,
-					     unsigned long long new)
+static inline u64 __cmpxchg64(volatile u64 *ptr, u64 old, u64 new)
 {
-	unsigned long long prev;
-	asm volatile(LOCK_PREFIX "cmpxchg8b %3"
-		     : "=A"(prev)
-		     : "b"((unsigned long)new),
-		       "c"((unsigned long)(new >> 32)),
-		       "m"(*__xg(ptr)),
-		       "0"(old)
+	u64 prev;
+	asm volatile(LOCK_PREFIX "cmpxchg8b %1"
+		     : "=A" (prev),
+		       "+m" (*ptr)
+		     : "b" ((u32)new),
+		       "c" ((u32)(new >> 32)),
+		       "0" (old)
 		     : "memory");
 	return prev;
 }
 
-static inline unsigned long long __cmpxchg64_local(volatile void *ptr,
-						   unsigned long long old,
-						   unsigned long long new)
+static inline u64 __cmpxchg64_local(volatile u64 *ptr, u64 old, u64 new)
 {
-	unsigned long long prev;
-	asm volatile("cmpxchg8b %3"
-		     : "=A"(prev)
-		     : "b"((unsigned long)new),
-		       "c"((unsigned long)(new >> 32)),
-		       "m"(*__xg(ptr)),
-		       "0"(old)
+	u64 prev;
+	asm volatile("cmpxchg8b %1"
+		     : "=A" (prev),
+		       "+m" (*ptr)
+		     : "b" ((u32)new),
+		       "c" ((u32)(new >> 32)),
+		       "0" (old)
 		     : "memory");
 	return prev;
 }
@@ -264,8 +246,6 @@ static inline unsigned long cmpxchg_386(volatile void *ptr, unsigned long old,
  * to simulate the cmpxchg8b on the 80386 and 80486 CPU.
  */
 
-extern unsigned long long cmpxchg_486_u64(volatile void *, u64, u64);
-
 #define cmpxchg64(ptr, o, n)					\
 ({								\
 	__typeof__(*(ptr)) __ret;				\
@@ -283,20 +263,20 @@ extern unsigned long long cmpxchg_486_u64(volatile void *, u64, u64);
 	__ret; })
 
 
-
-#define cmpxchg64_local(ptr, o, n)					\
-({									\
-	__typeof__(*(ptr)) __ret;					\
-	if (likely(boot_cpu_data.x86 > 4))				\
-		__ret = (__typeof__(*(ptr)))__cmpxchg64_local((ptr),	\
-				(unsigned long long)(o),		\
-				(unsigned long long)(n));		\
-	else								\
-		__ret = (__typeof__(*(ptr)))cmpxchg_486_u64((ptr),	\
-				(unsigned long long)(o),		\
-				(unsigned long long)(n));		\
-	__ret;								\
-})
+#define cmpxchg64_local(ptr, o, n)				\
+({								\
+	__typeof__(*(ptr)) __ret;				\
+	__typeof__(*(ptr)) __old = (o);				\
+	__typeof__(*(ptr)) __new = (n);				\
+	alternative_io("call cmpxchg8b_emu",			\
+		       "cmpxchg8b (%%esi)" ,			\
+		       X86_FEATURE_CX8,				\
+		       "=A" (__ret),				\
+		       "S" ((ptr)), "0" (__old),		\
+		       "b" ((unsigned int)__new),		\
+		       "c" ((unsigned int)(__new>>32))		\
+		       : "memory");				\
+	__ret; })
 
 #endif
 
diff --git a/arch/x86/include/asm/cmpxchg_64.h b/arch/x86/include/asm/cmpxchg_64.h
index 485ae41..423ae58 100644
--- a/arch/x86/include/asm/cmpxchg_64.h
+++ b/arch/x86/include/asm/cmpxchg_64.h
@@ -3,51 +3,60 @@
 
 #include <asm/alternative.h> /* Provides LOCK_PREFIX */
 
-#define __xg(x) ((volatile long *)(x))
-
-static inline void set_64bit(volatile unsigned long *ptr, unsigned long val)
+static inline void set_64bit(volatile u64 *ptr, u64 val)
 {
 	*ptr = val;
 }
 
-#define _set_64bit set_64bit
-
 extern void __xchg_wrong_size(void);
 extern void __cmpxchg_wrong_size(void);
 
 /*
- * Note: no "lock" prefix even on SMP: xchg always implies lock anyway
- * Note 2: xchg has side effect, so that attribute volatile is necessary,
- *	  but generally the primitive is invalid, *ptr is output argument. --ANK
+ * Note: no "lock" prefix even on SMP: xchg always implies lock anyway.
+ * Since this is generally used to protect other memory information, we
+ * use "asm volatile" and "memory" clobbers to prevent gcc from moving
+ * information around.
  */
 #define __xchg(x, ptr, size)						\
 ({									\
 	__typeof(*(ptr)) __x = (x);					\
 	switch (size) {							\
 	case 1:								\
-		asm volatile("xchgb %b0,%1"				\
-			     : "=q" (__x)				\
-			     : "m" (*__xg(ptr)), "0" (__x)		\
+	{								\
+		volatile u8 *__ptr = (volatile u8 *)(ptr);		\
+		asm volatile("xchgb %0,%1"				\
+			     : "=q" (__x), "+m" (*__ptr)		\
+			     : "0" (__x)				\
 			     : "memory");				\
 		break;							\
+	}								\
 	case 2:								\
-		asm volatile("xchgw %w0,%1"				\
-			     : "=r" (__x)				\
-			     : "m" (*__xg(ptr)), "0" (__x)		\
+	{								\
+		volatile u16 *__ptr = (volatile u16 *)(ptr);		\
+		asm volatile("xchgw %0,%1"				\
+			     : "=r" (__x), "+m" (*__ptr)		\
+			     : "0" (__x)				\
 			     : "memory");				\
 		break;							\
+	}								\
 	case 4:								\
-		asm volatile("xchgl %k0,%1"				\
-			     : "=r" (__x)				\
-			     : "m" (*__xg(ptr)), "0" (__x)		\
+	{								\
+		volatile u32 *__ptr = (volatile u32 *)(ptr);		\
+		asm volatile("xchgl %0,%1"				\
+			     : "=r" (__x), "+m" (*__ptr)		\
+			     : "0" (__x)				\
 			     : "memory");				\
 		break;							\
+	}								\
 	case 8:								\
+	{								\
+		volatile u64 *__ptr = (volatile u64 *)(ptr);		\
 		asm volatile("xchgq %0,%1"				\
-			     : "=r" (__x)				\
-			     : "m" (*__xg(ptr)), "0" (__x)		\
+			     : "=r" (__x), "+m" (*__ptr)		\
+			     : "0" (__x)				\
 			     : "memory");				\
 		break;							\
+	}								\
 	default:							\
 		__xchg_wrong_size();					\
 	}								\
@@ -71,29 +80,41 @@ extern void __cmpxchg_wrong_size(void);
 	__typeof__(*(ptr)) __new = (new);				\
 	switch (size) {							\
 	case 1:								\
-		asm volatile(lock "cmpxchgb %b1,%2"			\
-			     : "=a"(__ret)				\
-			     : "q"(__new), "m"(*__xg(ptr)), "0"(__old)	\
+	{								\
+		volatile u8 *__ptr = (volatile u8 *)(ptr);		\
+		asm volatile(lock "cmpxchgb %2,%1"			\
+			     : "=a" (__ret), "+m" (*__ptr)		\
+			     : "q" (__new), "0" (__old)			\
 			     : "memory");				\
 		break;							\
+	}								\
 	case 2:								\
-		asm volatile(lock "cmpxchgw %w1,%2"			\
-			     : "=a"(__ret)				\
-			     : "r"(__new), "m"(*__xg(ptr)), "0"(__old)	\
+	{								\
+		volatile u16 *__ptr = (volatile u16 *)(ptr);		\
+		asm volatile(lock "cmpxchgw %2,%1"			\
+			     : "=a" (__ret), "+m" (*__ptr)		\
+			     : "r" (__new), "0" (__old)			\
 			     : "memory");				\
 		break;							\
+	}								\
 	case 4:								\
-		asm volatile(lock "cmpxchgl %k1,%2"			\
-			     : "=a"(__ret)				\
-			     : "r"(__new), "m"(*__xg(ptr)), "0"(__old)	\
+	{								\
+		volatile u32 *__ptr = (volatile u32 *)(ptr);		\
+		asm volatile(lock "cmpxchgl %2,%1"			\
+			     : "=a" (__ret), "+m" (*__ptr)		\
+			     : "r" (__new), "0" (__old)			\
 			     : "memory");				\
 		break;							\
+	}								\
 	case 8:								\
-		asm volatile(lock "cmpxchgq %1,%2"			\
-			     : "=a"(__ret)				\
-			     : "r"(__new), "m"(*__xg(ptr)), "0"(__old)	\
+	{								\
+		volatile u64 *__ptr = (volatile u64 *)(ptr);		\
+		asm volatile(lock "cmpxchgq %2,%1"			\
+			     : "=a" (__ret), "+m" (*__ptr)		\
+			     : "r" (__new), "0" (__old)			\
 			     : "memory");				\
 		break;							\
+	}								\
 	default:							\
 		__cmpxchg_wrong_size();					\
 	}								\
diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index 509a421..b27d160 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -161,8 +161,6 @@
 #define MSR_K7_FID_VID_STATUS		0xc0010042
 
 /* K6 MSRs */
-#define MSR_K6_EFER			0xc0000080
-#define MSR_K6_STAR			0xc0000081
 #define MSR_K6_WHCR			0xc0000082
 #define MSR_K6_UWCCR			0xc0000085
 #define MSR_K6_EPMR			0xc0000086
diff --git a/arch/x86/kernel/acpi/realmode/wakeup.S b/arch/x86/kernel/acpi/realmode/wakeup.S
index 580b4e2..28595d6 100644
--- a/arch/x86/kernel/acpi/realmode/wakeup.S
+++ b/arch/x86/kernel/acpi/realmode/wakeup.S
@@ -104,7 +104,7 @@ _start:
 	movl	%eax, %ecx
 	orl	%edx, %ecx
 	jz	1f
-	movl	$0xc0000080, %ecx
+	movl	$MSR_EFER, %ecx
 	wrmsr
 1:
 
diff --git a/arch/x86/kernel/cpu/Makefile b/arch/x86/kernel/cpu/Makefile
index 3a785da..c47c439 100644
--- a/arch/x86/kernel/cpu/Makefile
+++ b/arch/x86/kernel/cpu/Makefile
@@ -16,7 +16,7 @@ obj-y			:= intel_cacheinfo.o addon_cpuid_features.o
 obj-y			+= proc.o capflags.o powerflags.o common.o
 obj-y			+= vmware.o hypervisor.o sched.o mshyperv.o
 
-obj-$(CONFIG_X86_32)	+= bugs.o cmpxchg.o
+obj-$(CONFIG_X86_32)	+= bugs.o
 obj-$(CONFIG_X86_64)	+= bugs_64.o
 
 obj-$(CONFIG_CPU_SUP_INTEL)		+= intel.o
diff --git a/arch/x86/kernel/cpu/cmpxchg.c b/arch/x86/kernel/cpu/cmpxchg.c
deleted file mode 100644
index 2056ccf..0000000
--- a/arch/x86/kernel/cpu/cmpxchg.c
+++ /dev/null
@@ -1,72 +0,0 @@
-/*
- * cmpxchg*() fallbacks for CPU not supporting these instructions
- */
-
-#include <linux/kernel.h>
-#include <linux/smp.h>
-#include <linux/module.h>
-
-#ifndef CONFIG_X86_CMPXCHG
-unsigned long cmpxchg_386_u8(volatile void *ptr, u8 old, u8 new)
-{
-	u8 prev;
-	unsigned long flags;
-
-	/* Poor man's cmpxchg for 386. Unsuitable for SMP */
-	local_irq_save(flags);
-	prev = *(u8 *)ptr;
-	if (prev == old)
-		*(u8 *)ptr = new;
-	local_irq_restore(flags);
-	return prev;
-}
-EXPORT_SYMBOL(cmpxchg_386_u8);
-
-unsigned long cmpxchg_386_u16(volatile void *ptr, u16 old, u16 new)
-{
-	u16 prev;
-	unsigned long flags;
-
-	/* Poor man's cmpxchg for 386. Unsuitable for SMP */
-	local_irq_save(flags);
-	prev = *(u16 *)ptr;
-	if (prev == old)
-		*(u16 *)ptr = new;
-	local_irq_restore(flags);
-	return prev;
-}
-EXPORT_SYMBOL(cmpxchg_386_u16);
-
-unsigned long cmpxchg_386_u32(volatile void *ptr, u32 old, u32 new)
-{
-	u32 prev;
-	unsigned long flags;
-
-	/* Poor man's cmpxchg for 386. Unsuitable for SMP */
-	local_irq_save(flags);
-	prev = *(u32 *)ptr;
-	if (prev == old)
-		*(u32 *)ptr = new;
-	local_irq_restore(flags);
-	return prev;
-}
-EXPORT_SYMBOL(cmpxchg_386_u32);
-#endif
-
-#ifndef CONFIG_X86_CMPXCHG64
-unsigned long long cmpxchg_486_u64(volatile void *ptr, u64 old, u64 new)
-{
-	u64 prev;
-	unsigned long flags;
-
-	/* Poor man's cmpxchg8b for 386 and 486. Unsuitable for SMP */
-	local_irq_save(flags);
-	prev = *(u64 *)ptr;
-	if (prev == old)
-		*(u64 *)ptr = new;
-	local_irq_restore(flags);
-	return prev;
-}
-EXPORT_SYMBOL(cmpxchg_486_u64);
-#endif
-
diff --git a/arch/x86/kernel/entry_32.S b/arch/x86/kernel/entry_32.S
index cd49141..233c582 100644
--- a/arch/x86/kernel/entry_32.S
+++ b/arch/x86/kernel/entry_32.S
@@ -611,14 +611,14 @@ ldt_ss:
  * compensating for the offset by changing to the ESPFIX segment with
  * a base address that matches for the difference.
  */
+#define GDT_ESPFIX_SS PER_CPU_VAR(gdt_page) + (GDT_ENTRY_ESPFIX_SS * 8)
 	mov %esp, %edx			/* load kernel esp */
 	mov PT_OLDESP(%esp), %eax	/* load userspace esp */
 	mov %dx, %ax			/* eax: new kernel esp */
 	sub %eax, %edx			/* offset (low word is 0) */
-	PER_CPU(gdt_page, %ebx)
 	shr $16, %edx
-	mov %dl, GDT_ENTRY_ESPFIX_SS * 8 + 4(%ebx) /* bits 16..23 */
-	mov %dh, GDT_ENTRY_ESPFIX_SS * 8 + 7(%ebx) /* bits 24..31 */
+	mov %dl, GDT_ESPFIX_SS + 4 /* bits 16..23 */
+	mov %dh, GDT_ESPFIX_SS + 7 /* bits 24..31 */
 	pushl $__ESPFIX_SS
 	CFI_ADJUST_CFA_OFFSET 4
 	push %eax			/* new kernel esp */
@@ -791,9 +791,8 @@ ptregs_clone:
  * normal stack and adjusts ESP with the matching offset.
  */
 	/* fixup the stack */
-	PER_CPU(gdt_page, %ebx)
-	mov GDT_ENTRY_ESPFIX_SS * 8 + 4(%ebx), %al /* bits 16..23 */
-	mov GDT_ENTRY_ESPFIX_SS * 8 + 7(%ebx), %ah /* bits 24..31 */
+	mov GDT_ESPFIX_SS + 4, %al /* bits 16..23 */
+	mov GDT_ESPFIX_SS + 7, %ah /* bits 24..31 */
 	shl $16, %eax
 	addl %esp, %eax			/* the adjusted stack pointer */
 	pushl $__KERNEL_DS
diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index 4db7c4d..59af275 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -1065,6 +1065,7 @@ ENTRY(\sym)
 END(\sym)
 .endm
 
+#define INIT_TSS_IST(x) PER_CPU_VAR(init_tss) + (TSS_ist + ((x) - 1) * 8)
 .macro paranoidzeroentry_ist sym do_sym ist
 ENTRY(\sym)
 	INTR_FRAME
@@ -1076,10 +1077,9 @@ ENTRY(\sym)
 	TRACE_IRQS_OFF
 	movq %rsp,%rdi		/* pt_regs pointer */
 	xorl %esi,%esi		/* no error code */
-	PER_CPU(init_tss, %r12)
-	subq $EXCEPTION_STKSZ, TSS_ist + (\ist - 1) * 8(%r12)
+	subq $EXCEPTION_STKSZ, INIT_TSS_IST(\ist)
 	call \do_sym
-	addq $EXCEPTION_STKSZ, TSS_ist + (\ist - 1) * 8(%r12)
+	addq $EXCEPTION_STKSZ, INIT_TSS_IST(\ist)
 	jmp paranoid_exit	/* %ebx: no swapgs flag */
 	CFI_ENDPROC
 END(\sym)
diff --git a/arch/x86/kernel/head_64.S b/arch/x86/kernel/head_64.S
index 3d1e6f1..239046b 100644
--- a/arch/x86/kernel/head_64.S
+++ b/arch/x86/kernel/head_64.S
@@ -234,9 +234,8 @@ ENTRY(secondary_startup_64)
 	 * init data section till per cpu areas are set up.
 	 */
 	movl	$MSR_GS_BASE,%ecx
-	movq	initial_gs(%rip),%rax
-	movq    %rax,%rdx
-	shrq	$32,%rdx
+	movl	initial_gs(%rip),%eax
+	movl	initial_gs+4(%rip),%edx
 	wrmsr	
 
 	/* esi is pointer to real mode structure with interesting info.
diff --git a/arch/x86/kernel/verify_cpu_64.S b/arch/x86/kernel/verify_cpu_64.S
index 45b6f8a..56a8c2a 100644
--- a/arch/x86/kernel/verify_cpu_64.S
+++ b/arch/x86/kernel/verify_cpu_64.S
@@ -31,6 +31,7 @@
  */
 
 #include <asm/cpufeature.h>
+#include <asm/msr-index.h>
 
 verify_cpu:
 	pushfl				# Save caller passed flags
@@ -88,7 +89,7 @@ verify_cpu_sse_test:
 	je	verify_cpu_sse_ok
 	test	%di,%di
 	jz	verify_cpu_no_longmode	# only try to force SSE on AMD
-	movl	$0xc0010015,%ecx	# HWCR
+	movl	$MSR_K7_HWCR,%ecx
 	rdmsr
 	btr	$15,%eax		# enable SSE
 	wrmsr
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 56c9b6b..2636ea8 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -131,7 +131,7 @@ static struct svm_direct_access_msrs {
 	u32 index;   /* Index of the MSR */
 	bool always; /* True if intercept is always on */
 } direct_access_msrs[] = {
-	{ .index = MSR_K6_STAR,				.always = true  },
+	{ .index = MSR_STAR,				.always = true  },
 	{ .index = MSR_IA32_SYSENTER_CS,		.always = true  },
 #ifdef CONFIG_X86_64
 	{ .index = MSR_GS_BASE,				.always = true  },
@@ -2433,7 +2433,7 @@ static int svm_get_msr(struct kvm_vcpu *vcpu, unsigned ecx, u64 *data)
 		*data = tsc_offset + native_read_tsc();
 		break;
 	}
-	case MSR_K6_STAR:
+	case MSR_STAR:
 		*data = svm->vmcb->save.star;
 		break;
 #ifdef CONFIG_X86_64
@@ -2557,7 +2557,7 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, unsigned ecx, u64 data)
 
 		break;
 	}
-	case MSR_K6_STAR:
+	case MSR_STAR:
 		svm->vmcb->save.star = data;
 		break;
 #ifdef CONFIG_X86_64
diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 27a0222..49b25ee 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -240,14 +240,14 @@ static u64 host_efer;
 static void ept_save_pdptrs(struct kvm_vcpu *vcpu);
 
 /*
- * Keep MSR_K6_STAR at the end, as setup_msrs() will try to optimize it
+ * Keep MSR_STAR at the end, as setup_msrs() will try to optimize it
  * away by decrementing the array size.
  */
 static const u32 vmx_msr_index[] = {
 #ifdef CONFIG_X86_64
 	MSR_SYSCALL_MASK, MSR_LSTAR, MSR_CSTAR,
 #endif
-	MSR_EFER, MSR_TSC_AUX, MSR_K6_STAR,
+	MSR_EFER, MSR_TSC_AUX, MSR_STAR,
 };
 #define NR_VMX_MSR ARRAY_SIZE(vmx_msr_index)
 
@@ -1117,10 +1117,10 @@ static void setup_msrs(struct vcpu_vmx *vmx)
 		if (index >= 0 && vmx->rdtscp_enabled)
 			move_msr_up(vmx, index, save_nmsrs++);
 		/*
-		 * MSR_K6_STAR is only needed on long mode guests, and only
+		 * MSR_STAR is only needed on long mode guests, and only
 		 * if efer.sce is enabled.
 		 */
-		index = __find_msr_index(vmx, MSR_K6_STAR);
+		index = __find_msr_index(vmx, MSR_STAR);
 		if ((index >= 0) && (vmx->vcpu.arch.efer & EFER_SCE))
 			move_msr_up(vmx, index, save_nmsrs++);
 	}
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 97aab03..25f1907 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -733,7 +733,7 @@ static u32 msrs_to_save[] = {
 	HV_X64_MSR_GUEST_OS_ID, HV_X64_MSR_HYPERCALL,
 	HV_X64_MSR_APIC_ASSIST_PAGE,
 	MSR_IA32_SYSENTER_CS, MSR_IA32_SYSENTER_ESP, MSR_IA32_SYSENTER_EIP,
-	MSR_K6_STAR,
+	MSR_STAR,
 #ifdef CONFIG_X86_64
 	MSR_CSTAR, MSR_KERNEL_GS_BASE, MSR_SYSCALL_MASK, MSR_LSTAR,
 #endif
diff --git a/arch/x86/lib/Makefile b/arch/x86/lib/Makefile
index f871e04..e10cf07 100644
--- a/arch/x86/lib/Makefile
+++ b/arch/x86/lib/Makefile
@@ -30,6 +30,7 @@ ifeq ($(CONFIG_X86_32),y)
         lib-y += checksum_32.o
         lib-y += strstr_32.o
         lib-y += semaphore_32.o string_32.o
+        lib-y += cmpxchg.o
 ifneq ($(CONFIG_X86_CMPXCHG64),y)
         lib-y += cmpxchg8b_emu.o atomic64_386_32.o
 endif
diff --git a/arch/x86/lib/cmpxchg.c b/arch/x86/lib/cmpxchg.c
new file mode 100644
index 0000000..5d619f6
--- /dev/null
+++ b/arch/x86/lib/cmpxchg.c
@@ -0,0 +1,54 @@
+/*
+ * cmpxchg*() fallbacks for CPU not supporting these instructions
+ */
+
+#include <linux/kernel.h>
+#include <linux/smp.h>
+#include <linux/module.h>
+
+#ifndef CONFIG_X86_CMPXCHG
+unsigned long cmpxchg_386_u8(volatile void *ptr, u8 old, u8 new)
+{
+	u8 prev;
+	unsigned long flags;
+
+	/* Poor man's cmpxchg for 386. Unsuitable for SMP */
+	local_irq_save(flags);
+	prev = *(u8 *)ptr;
+	if (prev == old)
+		*(u8 *)ptr = new;
+	local_irq_restore(flags);
+	return prev;
+}
+EXPORT_SYMBOL(cmpxchg_386_u8);
+
+unsigned long cmpxchg_386_u16(volatile void *ptr, u16 old, u16 new)
+{
+	u16 prev;
+	unsigned long flags;
+
+	/* Poor man's cmpxchg for 386. Unsuitable for SMP */
+	local_irq_save(flags);
+	prev = *(u16 *)ptr;
+	if (prev == old)
+		*(u16 *)ptr = new;
+	local_irq_restore(flags);
+	return prev;
+}
+EXPORT_SYMBOL(cmpxchg_386_u16);
+
+unsigned long cmpxchg_386_u32(volatile void *ptr, u32 old, u32 new)
+{
+	u32 prev;
+	unsigned long flags;
+
+	/* Poor man's cmpxchg for 386. Unsuitable for SMP */
+	local_irq_save(flags);
+	prev = *(u32 *)ptr;
+	if (prev == old)
+		*(u32 *)ptr = new;
+	local_irq_restore(flags);
+	return prev;
+}
+EXPORT_SYMBOL(cmpxchg_386_u32);
+#endif
