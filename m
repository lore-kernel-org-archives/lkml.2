Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755963Ab0EQVVu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 17:21:50 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:55151 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751996Ab0EQVVt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 17:21:49 -0400
Date: Mon, 17 May 2010 23:21:38 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
       Borislav Petkov <petkovbb@googlemail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] core/hweight changes for v2.6.35
Message-ID: <20100517212138.GA21629@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0028]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest core-hweight-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git core-hweight-for-linus

 Thanks,

	Ingo

------------------>
Borislav Petkov (2):
      x86: Add optimized popcnt variants
      arch, hweight: Fix compilation errors

Peter Zijlstra (1):
      bitops: Optimize hweight() by making use of compile-time evaluation


 arch/alpha/include/asm/bitops.h            |   18 +++++----
 arch/ia64/include/asm/bitops.h             |   11 +++--
 arch/sparc/include/asm/bitops_64.h         |   11 +++--
 arch/x86/Kconfig                           |    5 ++
 arch/x86/include/asm/alternative.h         |    9 +++-
 arch/x86/include/asm/arch_hweight.h        |   59 ++++++++++++++++++++++++++++
 arch/x86/include/asm/bitops.h              |    4 +-
 include/asm-generic/bitops/arch_hweight.h  |   25 ++++++++++++
 include/asm-generic/bitops/const_hweight.h |   42 ++++++++++++++++++++
 include/asm-generic/bitops/hweight.h       |    8 +---
 include/linux/bitops.h                     |   30 ++------------
 lib/Makefile                               |    3 +
 lib/hweight.c                              |   19 +++++----
 scripts/Makefile.lib                       |    4 ++
 14 files changed, 186 insertions(+), 62 deletions(-)
 create mode 100644 arch/x86/include/asm/arch_hweight.h
 create mode 100644 include/asm-generic/bitops/arch_hweight.h
 create mode 100644 include/asm-generic/bitops/const_hweight.h

diff --git a/arch/alpha/include/asm/bitops.h b/arch/alpha/include/asm/bitops.h
index 15f3ae2..296da1d 100644
--- a/arch/alpha/include/asm/bitops.h
+++ b/arch/alpha/include/asm/bitops.h
@@ -405,29 +405,31 @@ static inline int fls(int x)
 
 #if defined(CONFIG_ALPHA_EV6) && defined(CONFIG_ALPHA_EV67)
 /* Whee.  EV67 can calculate it directly.  */
-static inline unsigned long hweight64(unsigned long w)
+static inline unsigned long __arch_hweight64(unsigned long w)
 {
 	return __kernel_ctpop(w);
 }
 
-static inline unsigned int hweight32(unsigned int w)
+static inline unsigned int __arch_weight32(unsigned int w)
 {
-	return hweight64(w);
+	return __arch_hweight64(w);
 }
 
-static inline unsigned int hweight16(unsigned int w)
+static inline unsigned int __arch_hweight16(unsigned int w)
 {
-	return hweight64(w & 0xffff);
+	return __arch_hweight64(w & 0xffff);
 }
 
-static inline unsigned int hweight8(unsigned int w)
+static inline unsigned int __arch_hweight8(unsigned int w)
 {
-	return hweight64(w & 0xff);
+	return __arch_hweight64(w & 0xff);
 }
 #else
-#include <asm-generic/bitops/hweight.h>
+#include <asm-generic/bitops/arch_hweight.h>
 #endif
 
+#include <asm-generic/bitops/const_hweight.h>
+
 #endif /* __KERNEL__ */
 
 #include <asm-generic/bitops/find.h>
diff --git a/arch/ia64/include/asm/bitops.h b/arch/ia64/include/asm/bitops.h
index 6ebc229..9da3df6 100644
--- a/arch/ia64/include/asm/bitops.h
+++ b/arch/ia64/include/asm/bitops.h
@@ -437,17 +437,18 @@ __fls (unsigned long x)
  * hweightN: returns the hamming weight (i.e. the number
  * of bits set) of a N-bit word
  */
-static __inline__ unsigned long
-hweight64 (unsigned long x)
+static __inline__ unsigned long __arch_hweight64(unsigned long x)
 {
 	unsigned long result;
 	result = ia64_popcnt(x);
 	return result;
 }
 
-#define hweight32(x)	(unsigned int) hweight64((x) & 0xfffffffful)
-#define hweight16(x)	(unsigned int) hweight64((x) & 0xfffful)
-#define hweight8(x)	(unsigned int) hweight64((x) & 0xfful)
+#define __arch_hweight32(x) ((unsigned int) __arch_hweight64((x) & 0xfffffffful))
+#define __arch_hweight16(x) ((unsigned int) __arch_hweight64((x) & 0xfffful))
+#define __arch_hweight8(x)  ((unsigned int) __arch_hweight64((x) & 0xfful))
+
+#include <asm-generic/bitops/const_hweight.h>
 
 #endif /* __KERNEL__ */
 
diff --git a/arch/sparc/include/asm/bitops_64.h b/arch/sparc/include/asm/bitops_64.h
index e72ac9c..766121a 100644
--- a/arch/sparc/include/asm/bitops_64.h
+++ b/arch/sparc/include/asm/bitops_64.h
@@ -44,7 +44,7 @@ extern void change_bit(unsigned long nr, volatile unsigned long *addr);
 
 #ifdef ULTRA_HAS_POPULATION_COUNT
 
-static inline unsigned int hweight64(unsigned long w)
+static inline unsigned int __arch_hweight64(unsigned long w)
 {
 	unsigned int res;
 
@@ -52,7 +52,7 @@ static inline unsigned int hweight64(unsigned long w)
 	return res;
 }
 
-static inline unsigned int hweight32(unsigned int w)
+static inline unsigned int __arch_hweight32(unsigned int w)
 {
 	unsigned int res;
 
@@ -60,7 +60,7 @@ static inline unsigned int hweight32(unsigned int w)
 	return res;
 }
 
-static inline unsigned int hweight16(unsigned int w)
+static inline unsigned int __arch_hweight16(unsigned int w)
 {
 	unsigned int res;
 
@@ -68,7 +68,7 @@ static inline unsigned int hweight16(unsigned int w)
 	return res;
 }
 
-static inline unsigned int hweight8(unsigned int w)
+static inline unsigned int __arch_hweight8(unsigned int w)
 {
 	unsigned int res;
 
@@ -78,9 +78,10 @@ static inline unsigned int hweight8(unsigned int w)
 
 #else
 
-#include <asm-generic/bitops/hweight.h>
+#include <asm-generic/bitops/arch_hweight.h>
 
 #endif
+#include <asm-generic/bitops/const_hweight.h>
 #include <asm-generic/bitops/lock.h>
 #endif /* __KERNEL__ */
 
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 0eacb1f..89d8c54 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -238,6 +238,11 @@ config X86_32_LAZY_GS
 	def_bool y
 	depends on X86_32 && !CC_STACKPROTECTOR
 
+config ARCH_HWEIGHT_CFLAGS
+	string
+	default "-fcall-saved-ecx -fcall-saved-edx" if X86_32
+	default "-fcall-saved-rdi -fcall-saved-rsi -fcall-saved-rdx -fcall-saved-rcx -fcall-saved-r8 -fcall-saved-r9 -fcall-saved-r10 -fcall-saved-r11" if X86_64
+
 config KTIME_SCALAR
 	def_bool X86_32
 source "init/Kconfig"
diff --git a/arch/x86/include/asm/alternative.h b/arch/x86/include/asm/alternative.h
index b09ec55..67dae51 100644
--- a/arch/x86/include/asm/alternative.h
+++ b/arch/x86/include/asm/alternative.h
@@ -39,9 +39,6 @@
 #define LOCK_PREFIX ""
 #endif
 
-/* This must be included *after* the definition of LOCK_PREFIX */
-#include <asm/cpufeature.h>
-
 struct alt_instr {
 	u8 *instr;		/* original instruction */
 	u8 *replacement;
@@ -96,6 +93,12 @@ static inline int alternatives_text_reserved(void *start, void *end)
       ".previous"
 
 /*
+ * This must be included *after* the definition of ALTERNATIVE due to
+ * <asm/arch_hweight.h>
+ */
+#include <asm/cpufeature.h>
+
+/*
  * Alternative instructions for different CPU types or capabilities.
  *
  * This allows to use optimized instructions even on generic binary
diff --git a/arch/x86/include/asm/arch_hweight.h b/arch/x86/include/asm/arch_hweight.h
new file mode 100644
index 0000000..d1fc3c2
--- /dev/null
+++ b/arch/x86/include/asm/arch_hweight.h
@@ -0,0 +1,59 @@
+#ifndef _ASM_X86_HWEIGHT_H
+#define _ASM_X86_HWEIGHT_H
+
+#ifdef CONFIG_64BIT
+/* popcnt %rdi, %rax */
+#define POPCNT ".byte 0xf3,0x48,0x0f,0xb8,0xc7"
+#define REG_IN "D"
+#define REG_OUT "a"
+#else
+/* popcnt %eax, %eax */
+#define POPCNT ".byte 0xf3,0x0f,0xb8,0xc0"
+#define REG_IN "a"
+#define REG_OUT "a"
+#endif
+
+/*
+ * __sw_hweightXX are called from within the alternatives below
+ * and callee-clobbered registers need to be taken care of. See
+ * ARCH_HWEIGHT_CFLAGS in <arch/x86/Kconfig> for the respective
+ * compiler switches.
+ */
+static inline unsigned int __arch_hweight32(unsigned int w)
+{
+	unsigned int res = 0;
+
+	asm (ALTERNATIVE("call __sw_hweight32", POPCNT, X86_FEATURE_POPCNT)
+		     : "="REG_OUT (res)
+		     : REG_IN (w));
+
+	return res;
+}
+
+static inline unsigned int __arch_hweight16(unsigned int w)
+{
+	return __arch_hweight32(w & 0xffff);
+}
+
+static inline unsigned int __arch_hweight8(unsigned int w)
+{
+	return __arch_hweight32(w & 0xff);
+}
+
+static inline unsigned long __arch_hweight64(__u64 w)
+{
+	unsigned long res = 0;
+
+#ifdef CONFIG_X86_32
+	return  __arch_hweight32((u32)w) +
+		__arch_hweight32((u32)(w >> 32));
+#else
+	asm (ALTERNATIVE("call __sw_hweight64", POPCNT, X86_FEATURE_POPCNT)
+		     : "="REG_OUT (res)
+		     : REG_IN (w));
+#endif /* CONFIG_X86_32 */
+
+	return res;
+}
+
+#endif
diff --git a/arch/x86/include/asm/bitops.h b/arch/x86/include/asm/bitops.h
index 02b47a6..545776e 100644
--- a/arch/x86/include/asm/bitops.h
+++ b/arch/x86/include/asm/bitops.h
@@ -444,7 +444,9 @@ static inline int fls(int x)
 
 #define ARCH_HAS_FAST_MULTIPLIER 1
 
-#include <asm-generic/bitops/hweight.h>
+#include <asm/arch_hweight.h>
+
+#include <asm-generic/bitops/const_hweight.h>
 
 #endif /* __KERNEL__ */
 
diff --git a/include/asm-generic/bitops/arch_hweight.h b/include/asm-generic/bitops/arch_hweight.h
new file mode 100644
index 0000000..6a211f4
--- /dev/null
+++ b/include/asm-generic/bitops/arch_hweight.h
@@ -0,0 +1,25 @@
+#ifndef _ASM_GENERIC_BITOPS_ARCH_HWEIGHT_H_
+#define _ASM_GENERIC_BITOPS_ARCH_HWEIGHT_H_
+
+#include <asm/types.h>
+
+static inline unsigned int __arch_hweight32(unsigned int w)
+{
+	return __sw_hweight32(w);
+}
+
+static inline unsigned int __arch_hweight16(unsigned int w)
+{
+	return __sw_hweight16(w);
+}
+
+static inline unsigned int __arch_hweight8(unsigned int w)
+{
+	return __sw_hweight8(w);
+}
+
+static inline unsigned long __arch_hweight64(__u64 w)
+{
+	return __sw_hweight64(w);
+}
+#endif /* _ASM_GENERIC_BITOPS_HWEIGHT_H_ */
diff --git a/include/asm-generic/bitops/const_hweight.h b/include/asm-generic/bitops/const_hweight.h
new file mode 100644
index 0000000..fa2a50b
--- /dev/null
+++ b/include/asm-generic/bitops/const_hweight.h
@@ -0,0 +1,42 @@
+#ifndef _ASM_GENERIC_BITOPS_CONST_HWEIGHT_H_
+#define _ASM_GENERIC_BITOPS_CONST_HWEIGHT_H_
+
+/*
+ * Compile time versions of __arch_hweightN()
+ */
+#define __const_hweight8(w)		\
+      (	(!!((w) & (1ULL << 0))) +	\
+	(!!((w) & (1ULL << 1))) +	\
+	(!!((w) & (1ULL << 2))) +	\
+	(!!((w) & (1ULL << 3))) +	\
+	(!!((w) & (1ULL << 4))) +	\
+	(!!((w) & (1ULL << 5))) +	\
+	(!!((w) & (1ULL << 6))) +	\
+	(!!((w) & (1ULL << 7)))	)
+
+#define __const_hweight16(w) (__const_hweight8(w)  + __const_hweight8((w)  >> 8 ))
+#define __const_hweight32(w) (__const_hweight16(w) + __const_hweight16((w) >> 16))
+#define __const_hweight64(w) (__const_hweight32(w) + __const_hweight32((w) >> 32))
+
+/*
+ * Generic interface.
+ */
+#define hweight8(w)  (__builtin_constant_p(w) ? __const_hweight8(w)  : __arch_hweight8(w))
+#define hweight16(w) (__builtin_constant_p(w) ? __const_hweight16(w) : __arch_hweight16(w))
+#define hweight32(w) (__builtin_constant_p(w) ? __const_hweight32(w) : __arch_hweight32(w))
+#define hweight64(w) (__builtin_constant_p(w) ? __const_hweight64(w) : __arch_hweight64(w))
+
+/*
+ * Interface for known constant arguments
+ */
+#define HWEIGHT8(w)  (BUILD_BUG_ON_ZERO(!__builtin_constant_p(w)) + __const_hweight8(w))
+#define HWEIGHT16(w) (BUILD_BUG_ON_ZERO(!__builtin_constant_p(w)) + __const_hweight16(w))
+#define HWEIGHT32(w) (BUILD_BUG_ON_ZERO(!__builtin_constant_p(w)) + __const_hweight32(w))
+#define HWEIGHT64(w) (BUILD_BUG_ON_ZERO(!__builtin_constant_p(w)) + __const_hweight64(w))
+
+/*
+ * Type invariant interface to the compile time constant hweight functions.
+ */
+#define HWEIGHT(w)   HWEIGHT64((u64)w)
+
+#endif /* _ASM_GENERIC_BITOPS_CONST_HWEIGHT_H_ */
diff --git a/include/asm-generic/bitops/hweight.h b/include/asm-generic/bitops/hweight.h
index fbbc383..a94d651 100644
--- a/include/asm-generic/bitops/hweight.h
+++ b/include/asm-generic/bitops/hweight.h
@@ -1,11 +1,7 @@
 #ifndef _ASM_GENERIC_BITOPS_HWEIGHT_H_
 #define _ASM_GENERIC_BITOPS_HWEIGHT_H_
 
-#include <asm/types.h>
-
-extern unsigned int hweight32(unsigned int w);
-extern unsigned int hweight16(unsigned int w);
-extern unsigned int hweight8(unsigned int w);
-extern unsigned long hweight64(__u64 w);
+#include <asm-generic/bitops/arch_hweight.h>
+#include <asm-generic/bitops/const_hweight.h>
 
 #endif /* _ASM_GENERIC_BITOPS_HWEIGHT_H_ */
diff --git a/include/linux/bitops.h b/include/linux/bitops.h
index b793898..26caa60 100644
--- a/include/linux/bitops.h
+++ b/include/linux/bitops.h
@@ -10,6 +10,11 @@
 #define BITS_TO_LONGS(nr)	DIV_ROUND_UP(nr, BITS_PER_BYTE * sizeof(long))
 #endif
 
+extern unsigned int __sw_hweight8(unsigned int w);
+extern unsigned int __sw_hweight16(unsigned int w);
+extern unsigned int __sw_hweight32(unsigned int w);
+extern unsigned long __sw_hweight64(__u64 w);
+
 /*
  * Include this here because some architectures need generic_ffs/fls in
  * scope
@@ -47,31 +52,6 @@ static inline unsigned long hweight_long(unsigned long w)
 	return sizeof(w) == 4 ? hweight32(w) : hweight64(w);
 }
 
-/*
- * Clearly slow versions of the hweightN() functions, their benefit is
- * of course compile time evaluation of constant arguments.
- */
-#define HWEIGHT8(w)					\
-      (	BUILD_BUG_ON_ZERO(!__builtin_constant_p(w)) +	\
-	(!!((w) & (1ULL << 0))) +			\
-	(!!((w) & (1ULL << 1))) +			\
-	(!!((w) & (1ULL << 2))) +			\
-	(!!((w) & (1ULL << 3))) +			\
-	(!!((w) & (1ULL << 4))) +			\
-	(!!((w) & (1ULL << 5))) +			\
-	(!!((w) & (1ULL << 6))) +			\
-	(!!((w) & (1ULL << 7)))	)
-
-#define HWEIGHT16(w) (HWEIGHT8(w)  + HWEIGHT8((w) >> 8))
-#define HWEIGHT32(w) (HWEIGHT16(w) + HWEIGHT16((w) >> 16))
-#define HWEIGHT64(w) (HWEIGHT32(w) + HWEIGHT32((w) >> 32))
-
-/*
- * Type invariant version that simply casts things to the
- * largest type.
- */
-#define HWEIGHT(w)   HWEIGHT64((u64)(w))
-
 /**
  * rol32 - rotate a 32-bit value left
  * @word: value to rotate
diff --git a/lib/Makefile b/lib/Makefile
index 2e152ae..abe63a8 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -39,7 +39,10 @@ lib-$(CONFIG_RWSEM_XCHGADD_ALGORITHM) += rwsem.o
 lib-$(CONFIG_GENERIC_FIND_FIRST_BIT) += find_next_bit.o
 lib-$(CONFIG_GENERIC_FIND_NEXT_BIT) += find_next_bit.o
 obj-$(CONFIG_GENERIC_FIND_LAST_BIT) += find_last_bit.o
+
+CFLAGS_hweight.o = $(subst $(quote),,$(CONFIG_ARCH_HWEIGHT_CFLAGS))
 obj-$(CONFIG_GENERIC_HWEIGHT) += hweight.o
+
 obj-$(CONFIG_LOCK_KERNEL) += kernel_lock.o
 obj-$(CONFIG_BTREE) += btree.o
 obj-$(CONFIG_DEBUG_PREEMPT) += smp_processor_id.o
diff --git a/lib/hweight.c b/lib/hweight.c
index 63ee4eb..3c79d50 100644
--- a/lib/hweight.c
+++ b/lib/hweight.c
@@ -9,7 +9,7 @@
  * The Hamming Weight of a number is the total number of bits set in it.
  */
 
-unsigned int hweight32(unsigned int w)
+unsigned int __sw_hweight32(unsigned int w)
 {
 #ifdef ARCH_HAS_FAST_MULTIPLIER
 	w -= (w >> 1) & 0x55555555;
@@ -24,29 +24,30 @@ unsigned int hweight32(unsigned int w)
 	return (res + (res >> 16)) & 0x000000FF;
 #endif
 }
-EXPORT_SYMBOL(hweight32);
+EXPORT_SYMBOL(__sw_hweight32);
 
-unsigned int hweight16(unsigned int w)
+unsigned int __sw_hweight16(unsigned int w)
 {
 	unsigned int res = w - ((w >> 1) & 0x5555);
 	res = (res & 0x3333) + ((res >> 2) & 0x3333);
 	res = (res + (res >> 4)) & 0x0F0F;
 	return (res + (res >> 8)) & 0x00FF;
 }
-EXPORT_SYMBOL(hweight16);
+EXPORT_SYMBOL(__sw_hweight16);
 
-unsigned int hweight8(unsigned int w)
+unsigned int __sw_hweight8(unsigned int w)
 {
 	unsigned int res = w - ((w >> 1) & 0x55);
 	res = (res & 0x33) + ((res >> 2) & 0x33);
 	return (res + (res >> 4)) & 0x0F;
 }
-EXPORT_SYMBOL(hweight8);
+EXPORT_SYMBOL(__sw_hweight8);
 
-unsigned long hweight64(__u64 w)
+unsigned long __sw_hweight64(__u64 w)
 {
 #if BITS_PER_LONG == 32
-	return hweight32((unsigned int)(w >> 32)) + hweight32((unsigned int)w);
+	return __sw_hweight32((unsigned int)(w >> 32)) +
+	       __sw_hweight32((unsigned int)w);
 #elif BITS_PER_LONG == 64
 #ifdef ARCH_HAS_FAST_MULTIPLIER
 	w -= (w >> 1) & 0x5555555555555555ul;
@@ -63,4 +64,4 @@ unsigned long hweight64(__u64 w)
 #endif
 #endif
 }
-EXPORT_SYMBOL(hweight64);
+EXPORT_SYMBOL(__sw_hweight64);
diff --git a/scripts/Makefile.lib b/scripts/Makefile.lib
index f9bdf26..cbcd654 100644
--- a/scripts/Makefile.lib
+++ b/scripts/Makefile.lib
@@ -245,3 +245,7 @@ quiet_cmd_lzo = LZO    $@
 cmd_lzo = (cat $(filter-out FORCE,$^) | \
 	lzop -9 && $(call size_append, $(filter-out FORCE,$^))) > $@ || \
 	(rm -f $@ ; false)
+
+# misc stuff
+# ---------------------------------------------------------------------------
+quote:="
