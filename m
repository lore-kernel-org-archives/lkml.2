Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753230Ab2LKLKj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 06:10:39 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:48747 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752988Ab2LKLKd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 06:10:33 -0500
Date: Tue, 11 Dec 2012 12:10:26 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [RFC GIT PULL] "Nuke 386-DX/SX support" changes for v3.8
Message-ID: <20121211111026.GA26507@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please consider pulling the latest x86-nuke386-for-linus git 
tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-nuke386-for-linus

   HEAD: 11af32b69ef7ee64c7d8848cad71a6f3749d9e37 x86, 386 removal: Document Nx586 as a 386 and thus unsupported

This tree removes ancient-386-CPUs support and thus zaps quite a 
bit of complexity:

   24 files changed, 56 insertions(+), 425 deletions(-)

... which complexity has plagued us with extra work whenever we 
wanted to change SMP primitives, for years.

Unfortunately there's a nostalgic cost: your old original 386 
DX33 system from early 1991 won't be able to boot modern Linux 
kernels anymore. Sniff.

 Thanks,

	Ingo

------------------>
H. Peter Anvin (9):
      x86, 386 removal: Remove CONFIG_M386 from Kconfig
      x86, 386 removal: Remove CONFIG_CMPXCHG
      x86, 386 removal: Remove CONFIG_XADD
      x86, 386 removal: Remove CONFIG_BSWAP
      x86, 386 removal: Remove CONFIG_INVLPG
      x86, 386 removal: Remove CONFIG_X86_WP_WORKS_OK
      x86, 386 removal: Remove CONFIG_X86_POPAD_OK
      x86, cleanups: Simplify sync_core() in the case of no CPUID
      x86, 386 removal: Document Nx586 as a 386 and thus unsupported


 arch/x86/Kconfig                  | 11 ++----
 arch/x86/Kconfig.cpu              | 73 +++++++++++----------------------------
 arch/x86/Makefile_32.cpu          |  1 -
 arch/x86/include/asm/atomic.h     | 16 ---------
 arch/x86/include/asm/cmpxchg_32.h | 55 -----------------------------
 arch/x86/include/asm/cpufeature.h |  6 ----
 arch/x86/include/asm/futex.h      | 12 -------
 arch/x86/include/asm/local.h      | 18 +---------
 arch/x86/include/asm/module.h     |  2 --
 arch/x86/include/asm/percpu.h     |  3 --
 arch/x86/include/asm/processor.h  | 33 ++++++++++++------
 arch/x86/include/asm/swab.h       | 29 ++--------------
 arch/x86/include/asm/tlbflush.h   |  3 --
 arch/x86/include/asm/uaccess.h    | 42 ----------------------
 arch/x86/kernel/cpu/amd.c         |  3 --
 arch/x86/kernel/cpu/bugs.c        | 41 ++--------------------
 arch/x86/kernel/cpu/intel.c       |  4 ---
 arch/x86/lib/Makefile             |  1 -
 arch/x86/lib/cmpxchg.c            | 54 -----------------------------
 arch/x86/lib/usercopy_32.c        | 57 ------------------------------
 arch/x86/mm/init_32.c             |  5 +--
 arch/x86/mm/tlb.c                 |  8 ++---
 arch/x86/um/Kconfig               |  2 +-
 arch/x86/xen/Kconfig              |  2 +-
 24 files changed, 56 insertions(+), 425 deletions(-)
 delete mode 100644 arch/x86/lib/cmpxchg.c

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 46c3bff..631b298 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -69,8 +69,8 @@ config X86
 	select HAVE_PERF_USER_STACK_DUMP
 	select HAVE_DEBUG_KMEMLEAK
 	select ANON_INODES
-	select HAVE_ALIGNED_STRUCT_PAGE if SLUB && !M386
-	select HAVE_CMPXCHG_LOCAL if !M386
+	select HAVE_ALIGNED_STRUCT_PAGE if SLUB
+	select HAVE_CMPXCHG_LOCAL
 	select HAVE_CMPXCHG_DOUBLE
 	select HAVE_ARCH_KMEMCHECK
 	select HAVE_USER_RETURN_NOTIFIER
@@ -171,13 +171,8 @@ config ARCH_MAY_HAVE_PC_FDC
 	def_bool y
 	depends on ISA_DMA_API
 
-config RWSEM_GENERIC_SPINLOCK
-	def_bool y
-	depends on !X86_XADD
-
 config RWSEM_XCHGADD_ALGORITHM
 	def_bool y
-	depends on X86_XADD
 
 config GENERIC_CALIBRATE_DELAY
 	def_bool y
@@ -1100,7 +1095,7 @@ config HIGHMEM4G
 
 config HIGHMEM64G
 	bool "64GB"
-	depends on !M386 && !M486
+	depends on !M486
 	select X86_PAE
 	---help---
 	  Select this if you have a 32-bit processor and more than 4
diff --git a/arch/x86/Kconfig.cpu b/arch/x86/Kconfig.cpu
index f3b86d0..c026cca 100644
--- a/arch/x86/Kconfig.cpu
+++ b/arch/x86/Kconfig.cpu
@@ -4,23 +4,24 @@ choice
 	default M686 if X86_32
 	default GENERIC_CPU if X86_64
 
-config M386
-	bool "386"
-	depends on X86_32 && !UML
+config M486
+	bool "486"
+	depends on X86_32
 	---help---
-	  This is the processor type of your CPU. This information is used for
-	  optimizing purposes. In order to compile a kernel that can run on
-	  all x86 CPU types (albeit not optimally fast), you can specify
-	  "386" here.
+	  This is the processor type of your CPU. This information is
+	  used for optimizing purposes. In order to compile a kernel
+	  that can run on all supported x86 CPU types (albeit not
+	  optimally fast), you can specify "486" here.
+
+	  Note that the 386 is no longer supported, this includes
+	  AMD/Cyrix/Intel 386DX/DXL/SL/SLC/SX, Cyrix/TI 486DLC/DLC2,
+	  UMC 486SX-S and the NexGen Nx586.
 
 	  The kernel will not necessarily run on earlier architectures than
 	  the one you have chosen, e.g. a Pentium optimized kernel will run on
 	  a PPro, but not necessarily on a i486.
 
 	  Here are the settings recommended for greatest speed:
-	  - "386" for the AMD/Cyrix/Intel 386DX/DXL/SL/SLC/SX, Cyrix/TI
-	  486DLC/DLC2, and UMC 486SX-S.  Only "386" kernels will run on a 386
-	  class machine.
 	  - "486" for the AMD/Cyrix/IBM/Intel 486DX/DX2/DX4 or
 	  SL/SLC/SLC2/SLC3/SX/SX2 and UMC U5D or U5S.
 	  - "586" for generic Pentium CPUs lacking the TSC
@@ -43,16 +44,7 @@ config M386
 	  - "VIA C3-2" for VIA C3-2 "Nehemiah" (model 9 and above).
 	  - "VIA C7" for VIA C7.
 
-	  If you don't know what to do, choose "386".
-
-config M486
-	bool "486"
-	depends on X86_32
-	---help---
-	  Select this for a 486 series processor, either Intel or one of the
-	  compatible processors from AMD, Cyrix, IBM, or Intel.  Includes DX,
-	  DX2, and DX4 variants; also SL/SLC/SLC2/SLC3/SX/SX2 and UMC U5D or
-	  U5S.
+	  If you don't know what to do, choose "486".
 
 config M586
 	bool "586/K5/5x86/6x86/6x86MX"
@@ -305,24 +297,16 @@ config X86_INTERNODE_CACHE_SHIFT
 	default "12" if X86_VSMP
 	default X86_L1_CACHE_SHIFT
 
-config X86_CMPXCHG
-	def_bool y
-	depends on X86_64 || (X86_32 && !M386)
-
 config X86_L1_CACHE_SHIFT
 	int
 	default "7" if MPENTIUM4 || MPSC
 	default "6" if MK7 || MK8 || MPENTIUMM || MCORE2 || MATOM || MVIAC7 || X86_GENERIC || GENERIC_CPU
-	default "4" if MELAN || M486 || M386 || MGEODEGX1
+	default "4" if MELAN || M486 || MGEODEGX1
 	default "5" if MWINCHIP3D || MWINCHIPC6 || MCRUSOE || MEFFICEON || MCYRIXIII || MK6 || MPENTIUMIII || MPENTIUMII || M686 || M586MMX || M586TSC || M586 || MVIAC3_2 || MGEODE_LX
 
-config X86_XADD
-	def_bool y
-	depends on !M386
-
 config X86_PPRO_FENCE
 	bool "PentiumPro memory ordering errata workaround"
-	depends on M686 || M586MMX || M586TSC || M586 || M486 || M386 || MGEODEGX1
+	depends on M686 || M586MMX || M586TSC || M586 || M486 || MGEODEGX1
 	---help---
 	  Old PentiumPro multiprocessor systems had errata that could cause
 	  memory operations to violate the x86 ordering standard in rare cases.
@@ -335,27 +319,11 @@ config X86_PPRO_FENCE
 
 config X86_F00F_BUG
 	def_bool y
-	depends on M586MMX || M586TSC || M586 || M486 || M386
+	depends on M586MMX || M586TSC || M586 || M486
 
 config X86_INVD_BUG
 	def_bool y
-	depends on M486 || M386
-
-config X86_WP_WORKS_OK
-	def_bool y
-	depends on !M386
-
-config X86_INVLPG
-	def_bool y
-	depends on X86_32 && !M386
-
-config X86_BSWAP
-	def_bool y
-	depends on X86_32 && !M386
-
-config X86_POPAD_OK
-	def_bool y
-	depends on X86_32 && !M386
+	depends on M486
 
 config X86_ALIGNMENT_16
 	def_bool y
@@ -412,12 +380,11 @@ config X86_MINIMUM_CPU_FAMILY
 	default "64" if X86_64
 	default "6" if X86_32 && X86_P6_NOP
 	default "5" if X86_32 && X86_CMPXCHG64
-	default "4" if X86_32 && (X86_XADD || X86_CMPXCHG || X86_BSWAP || X86_WP_WORKS_OK)
-	default "3"
+	default "4"
 
 config X86_DEBUGCTLMSR
 	def_bool y
-	depends on !(MK6 || MWINCHIPC6 || MWINCHIP3D || MCYRIXIII || M586MMX || M586TSC || M586 || M486 || M386) && !UML
+	depends on !(MK6 || MWINCHIPC6 || MWINCHIP3D || MCYRIXIII || M586MMX || M586TSC || M586 || M486) && !UML
 
 menuconfig PROCESSOR_SELECT
 	bool "Supported processor vendors" if EXPERT
@@ -441,7 +408,7 @@ config CPU_SUP_INTEL
 config CPU_SUP_CYRIX_32
 	default y
 	bool "Support Cyrix processors" if PROCESSOR_SELECT
-	depends on M386 || M486 || M586 || M586TSC || M586MMX || (EXPERT && !64BIT)
+	depends on M486 || M586 || M586TSC || M586MMX || (EXPERT && !64BIT)
 	---help---
 	  This enables detection, tunings and quirks for Cyrix processors
 
@@ -495,7 +462,7 @@ config CPU_SUP_TRANSMETA_32
 config CPU_SUP_UMC_32
 	default y
 	bool "Support UMC processors" if PROCESSOR_SELECT
-	depends on M386 || M486 || (EXPERT && !64BIT)
+	depends on M486 || (EXPERT && !64BIT)
 	---help---
 	  This enables detection, tunings and quirks for UMC processors
 
diff --git a/arch/x86/Makefile_32.cpu b/arch/x86/Makefile_32.cpu
index 86cee7b..6647ed4 100644
--- a/arch/x86/Makefile_32.cpu
+++ b/arch/x86/Makefile_32.cpu
@@ -10,7 +10,6 @@ tune		= $(call cc-option,-mcpu=$(1),$(2))
 endif
 
 align := $(cc-option-align)
-cflags-$(CONFIG_M386)		+= -march=i386
 cflags-$(CONFIG_M486)		+= -march=i486
 cflags-$(CONFIG_M586)		+= -march=i586
 cflags-$(CONFIG_M586TSC)	+= -march=i586
diff --git a/arch/x86/include/asm/atomic.h b/arch/x86/include/asm/atomic.h
index b6c3b82..722aa3b 100644
--- a/arch/x86/include/asm/atomic.h
+++ b/arch/x86/include/asm/atomic.h
@@ -172,23 +172,7 @@ static inline int atomic_add_negative(int i, atomic_t *v)
  */
 static inline int atomic_add_return(int i, atomic_t *v)
 {
-#ifdef CONFIG_M386
-	int __i;
-	unsigned long flags;
-	if (unlikely(boot_cpu_data.x86 <= 3))
-		goto no_xadd;
-#endif
-	/* Modern 486+ processor */
 	return i + xadd(&v->counter, i);
-
-#ifdef CONFIG_M386
-no_xadd: /* Legacy 386 processor */
-	raw_local_irq_save(flags);
-	__i = atomic_read(v);
-	atomic_set(v, i + __i);
-	raw_local_irq_restore(flags);
-	return i + __i;
-#endif
 }
 
 /**
diff --git a/arch/x86/include/asm/cmpxchg_32.h b/arch/x86/include/asm/cmpxchg_32.h
index 53f4b21..f8bf2ee 100644
--- a/arch/x86/include/asm/cmpxchg_32.h
+++ b/arch/x86/include/asm/cmpxchg_32.h
@@ -34,9 +34,7 @@ static inline void set_64bit(volatile u64 *ptr, u64 value)
 		     : "memory");
 }
 
-#ifdef CONFIG_X86_CMPXCHG
 #define __HAVE_ARCH_CMPXCHG 1
-#endif
 
 #ifdef CONFIG_X86_CMPXCHG64
 #define cmpxchg64(ptr, o, n)						\
@@ -73,59 +71,6 @@ static inline u64 __cmpxchg64_local(volatile u64 *ptr, u64 old, u64 new)
 	return prev;
 }
 
-#ifndef CONFIG_X86_CMPXCHG
-/*
- * Building a kernel capable running on 80386. It may be necessary to
- * simulate the cmpxchg on the 80386 CPU. For that purpose we define
- * a function for each of the sizes we support.
- */
-
-extern unsigned long cmpxchg_386_u8(volatile void *, u8, u8);
-extern unsigned long cmpxchg_386_u16(volatile void *, u16, u16);
-extern unsigned long cmpxchg_386_u32(volatile void *, u32, u32);
-
-static inline unsigned long cmpxchg_386(volatile void *ptr, unsigned long old,
-					unsigned long new, int size)
-{
-	switch (size) {
-	case 1:
-		return cmpxchg_386_u8(ptr, old, new);
-	case 2:
-		return cmpxchg_386_u16(ptr, old, new);
-	case 4:
-		return cmpxchg_386_u32(ptr, old, new);
-	}
-	return old;
-}
-
-#define cmpxchg(ptr, o, n)						\
-({									\
-	__typeof__(*(ptr)) __ret;					\
-	if (likely(boot_cpu_data.x86 > 3))				\
-		__ret = (__typeof__(*(ptr)))__cmpxchg((ptr),		\
-				(unsigned long)(o), (unsigned long)(n),	\
-				sizeof(*(ptr)));			\
-	else								\
-		__ret = (__typeof__(*(ptr)))cmpxchg_386((ptr),		\
-				(unsigned long)(o), (unsigned long)(n),	\
-				sizeof(*(ptr)));			\
-	__ret;								\
-})
-#define cmpxchg_local(ptr, o, n)					\
-({									\
-	__typeof__(*(ptr)) __ret;					\
-	if (likely(boot_cpu_data.x86 > 3))				\
-		__ret = (__typeof__(*(ptr)))__cmpxchg_local((ptr),	\
-				(unsigned long)(o), (unsigned long)(n),	\
-				sizeof(*(ptr)));			\
-	else								\
-		__ret = (__typeof__(*(ptr)))cmpxchg_386((ptr),		\
-				(unsigned long)(o), (unsigned long)(n),	\
-				sizeof(*(ptr)));			\
-	__ret;								\
-})
-#endif
-
 #ifndef CONFIG_X86_CMPXCHG64
 /*
  * Building a kernel capable running on 80386 and 80486. It may be necessary
diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufeature.h
index 8c297aa..ff8dd62 100644
--- a/arch/x86/include/asm/cpufeature.h
+++ b/arch/x86/include/asm/cpufeature.h
@@ -312,12 +312,6 @@ extern const char * const x86_power_flags[32];
 #define cpu_has_cx16		boot_cpu_has(X86_FEATURE_CX16)
 #define cpu_has_eager_fpu	boot_cpu_has(X86_FEATURE_EAGER_FPU)
 
-#if defined(CONFIG_X86_INVLPG) || defined(CONFIG_X86_64)
-# define cpu_has_invlpg		1
-#else
-# define cpu_has_invlpg		(boot_cpu_data.x86 > 3)
-#endif
-
 #ifdef CONFIG_X86_64
 
 #undef  cpu_has_vme
diff --git a/arch/x86/include/asm/futex.h b/arch/x86/include/asm/futex.h
index f373046..be27ba1 100644
--- a/arch/x86/include/asm/futex.h
+++ b/arch/x86/include/asm/futex.h
@@ -55,12 +55,6 @@ static inline int futex_atomic_op_inuser(int encoded_op, u32 __user *uaddr)
 	if (!access_ok(VERIFY_WRITE, uaddr, sizeof(u32)))
 		return -EFAULT;
 
-#if defined(CONFIG_X86_32) && !defined(CONFIG_X86_BSWAP)
-	/* Real i386 machines can only support FUTEX_OP_SET */
-	if (op != FUTEX_OP_SET && boot_cpu_data.x86 == 3)
-		return -ENOSYS;
-#endif
-
 	pagefault_disable();
 
 	switch (op) {
@@ -118,12 +112,6 @@ static inline int futex_atomic_cmpxchg_inatomic(u32 *uval, u32 __user *uaddr,
 {
 	int ret = 0;
 
-#if defined(CONFIG_X86_32) && !defined(CONFIG_X86_BSWAP)
-	/* Real i386 machines have no cmpxchg instruction */
-	if (boot_cpu_data.x86 == 3)
-		return -ENOSYS;
-#endif
-
 	if (!access_ok(VERIFY_WRITE, uaddr, sizeof(u32)))
 		return -EFAULT;
 
diff --git a/arch/x86/include/asm/local.h b/arch/x86/include/asm/local.h
index c8bed0d..2d89e39 100644
--- a/arch/x86/include/asm/local.h
+++ b/arch/x86/include/asm/local.h
@@ -124,27 +124,11 @@ static inline int local_add_negative(long i, local_t *l)
  */
 static inline long local_add_return(long i, local_t *l)
 {
-	long __i;
-#ifdef CONFIG_M386
-	unsigned long flags;
-	if (unlikely(boot_cpu_data.x86 <= 3))
-		goto no_xadd;
-#endif
-	/* Modern 486+ processor */
-	__i = i;
+	long __i = i;
 	asm volatile(_ASM_XADD "%0, %1;"
 		     : "+r" (i), "+m" (l->a.counter)
 		     : : "memory");
 	return i + __i;
-
-#ifdef CONFIG_M386
-no_xadd: /* Legacy 386 processor */
-	local_irq_save(flags);
-	__i = local_read(l);
-	local_set(l, i + __i);
-	local_irq_restore(flags);
-	return i + __i;
-#endif
 }
 
 static inline long local_sub_return(long i, local_t *l)
diff --git a/arch/x86/include/asm/module.h b/arch/x86/include/asm/module.h
index 9eae775..e3b7819 100644
--- a/arch/x86/include/asm/module.h
+++ b/arch/x86/include/asm/module.h
@@ -5,8 +5,6 @@
 
 #ifdef CONFIG_X86_64
 /* X86_64 does not define MODULE_PROC_FAMILY */
-#elif defined CONFIG_M386
-#define MODULE_PROC_FAMILY "386 "
 #elif defined CONFIG_M486
 #define MODULE_PROC_FAMILY "486 "
 #elif defined CONFIG_M586
diff --git a/arch/x86/include/asm/percpu.h b/arch/x86/include/asm/percpu.h
index 1104afa..0da5200 100644
--- a/arch/x86/include/asm/percpu.h
+++ b/arch/x86/include/asm/percpu.h
@@ -406,7 +406,6 @@ do {									\
 #define this_cpu_xchg_2(pcp, nval)	percpu_xchg_op(pcp, nval)
 #define this_cpu_xchg_4(pcp, nval)	percpu_xchg_op(pcp, nval)
 
-#ifndef CONFIG_M386
 #define __this_cpu_add_return_1(pcp, val) percpu_add_return_op(pcp, val)
 #define __this_cpu_add_return_2(pcp, val) percpu_add_return_op(pcp, val)
 #define __this_cpu_add_return_4(pcp, val) percpu_add_return_op(pcp, val)
@@ -421,8 +420,6 @@ do {									\
 #define this_cpu_cmpxchg_2(pcp, oval, nval)	percpu_cmpxchg_op(pcp, oval, nval)
 #define this_cpu_cmpxchg_4(pcp, oval, nval)	percpu_cmpxchg_op(pcp, oval, nval)
 
-#endif /* !CONFIG_M386 */
-
 #ifdef CONFIG_X86_CMPXCHG64
 #define percpu_cmpxchg8b_double(pcp1, pcp2, o1, o2, n1, n2)		\
 ({									\
diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index ad1fc85..b0d3e73 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -672,18 +672,29 @@ static inline void sync_core(void)
 {
 	int tmp;
 
-#if defined(CONFIG_M386) || defined(CONFIG_M486)
-	if (boot_cpu_data.x86 < 5)
-		/* There is no speculative execution.
-		 * jmp is a barrier to prefetching. */
-		asm volatile("jmp 1f\n1:\n" ::: "memory");
-	else
+#ifdef CONFIG_M486
+	/*
+	 * Do a CPUID if available, otherwise do a jump.  The jump
+	 * can conveniently enough be the jump around CPUID.
+	 */
+	asm volatile("cmpl %2,%1\n\t"
+		     "jl 1f\n\t"
+		     "cpuid\n"
+		     "1:"
+		     : "=a" (tmp)
+		     : "rm" (boot_cpu_data.cpuid_level), "ri" (0), "0" (1)
+		     : "ebx", "ecx", "edx", "memory");
+#else
+	/*
+	 * CPUID is a barrier to speculative execution.
+	 * Prefetched instructions are automatically
+	 * invalidated when modified.
+	 */
+	asm volatile("cpuid"
+		     : "=a" (tmp)
+		     : "0" (1)
+		     : "ebx", "ecx", "edx", "memory");
 #endif
-		/* cpuid is a barrier to speculative execution.
-		 * Prefetched instructions are automatically
-		 * invalidated when modified. */
-		asm volatile("cpuid" : "=a" (tmp) : "0" (1)
-			     : "ebx", "ecx", "edx", "memory");
 }
 
 static inline void __monitor(const void *eax, unsigned long ecx,
diff --git a/arch/x86/include/asm/swab.h b/arch/x86/include/asm/swab.h
index 557cd9f..7f235c7 100644
--- a/arch/x86/include/asm/swab.h
+++ b/arch/x86/include/asm/swab.h
@@ -6,22 +6,7 @@
 
 static inline __attribute_const__ __u32 __arch_swab32(__u32 val)
 {
-#ifdef __i386__
-# ifdef CONFIG_X86_BSWAP
-	asm("bswap %0" : "=r" (val) : "0" (val));
-# else
-	asm("xchgb %b0,%h0\n\t"	/* swap lower bytes	*/
-	    "rorl $16,%0\n\t"	/* swap words		*/
-	    "xchgb %b0,%h0"	/* swap higher bytes	*/
-	    : "=q" (val)
-	    : "0" (val));
-# endif
-
-#else /* __i386__ */
-	asm("bswapl %0"
-	    : "=r" (val)
-	    : "0" (val));
-#endif
+	asm("bswapl %0" : "=r" (val) : "0" (val));
 	return val;
 }
 #define __arch_swab32 __arch_swab32
@@ -37,22 +22,12 @@ static inline __attribute_const__ __u64 __arch_swab64(__u64 val)
 		__u64 u;
 	} v;
 	v.u = val;
-# ifdef CONFIG_X86_BSWAP
 	asm("bswapl %0 ; bswapl %1 ; xchgl %0,%1"
 	    : "=r" (v.s.a), "=r" (v.s.b)
 	    : "0" (v.s.a), "1" (v.s.b));
-# else
-	v.s.a = __arch_swab32(v.s.a);
-	v.s.b = __arch_swab32(v.s.b);
-	asm("xchgl %0,%1"
-	    : "=r" (v.s.a), "=r" (v.s.b)
-	    : "0" (v.s.a), "1" (v.s.b));
-# endif
 	return v.u;
 #else /* __i386__ */
-	asm("bswapq %0"
-	    : "=r" (val)
-	    : "0" (val));
+	asm("bswapq %0" : "=r" (val) : "0" (val));
 	return val;
 #endif
 }
diff --git a/arch/x86/include/asm/tlbflush.h b/arch/x86/include/asm/tlbflush.h
index 74a4433..0fee48e 100644
--- a/arch/x86/include/asm/tlbflush.h
+++ b/arch/x86/include/asm/tlbflush.h
@@ -56,10 +56,7 @@ static inline void __flush_tlb_all(void)
 
 static inline void __flush_tlb_one(unsigned long addr)
 {
-	if (cpu_has_invlpg)
 		__flush_tlb_single(addr);
-	else
-		__flush_tlb();
 }
 
 #define TLB_FLUSH_ALL	-1UL
diff --git a/arch/x86/include/asm/uaccess.h b/arch/x86/include/asm/uaccess.h
index 7ccf8d1..1709801 100644
--- a/arch/x86/include/asm/uaccess.h
+++ b/arch/x86/include/asm/uaccess.h
@@ -237,8 +237,6 @@ extern void __put_user_2(void);
 extern void __put_user_4(void);
 extern void __put_user_8(void);
 
-#ifdef CONFIG_X86_WP_WORKS_OK
-
 /**
  * put_user: - Write a simple value into user space.
  * @x:   Value to copy to user space.
@@ -326,29 +324,6 @@ do {									\
 	}								\
 } while (0)
 
-#else
-
-#define __put_user_size(x, ptr, size, retval, errret)			\
-do {									\
-	__typeof__(*(ptr))__pus_tmp = x;				\
-	retval = 0;							\
-									\
-	if (unlikely(__copy_to_user_ll(ptr, &__pus_tmp, size) != 0))	\
-		retval = errret;					\
-} while (0)
-
-#define put_user(x, ptr)					\
-({								\
-	int __ret_pu;						\
-	__typeof__(*(ptr))__pus_tmp = x;			\
-	__ret_pu = 0;						\
-	if (unlikely(__copy_to_user_ll(ptr, &__pus_tmp,		\
-				       sizeof(*(ptr))) != 0))	\
-		__ret_pu = -EFAULT;				\
-	__ret_pu;						\
-})
-#endif
-
 #ifdef CONFIG_X86_32
 #define __get_user_asm_u64(x, ptr, retval, errret)	(x) = __get_user_bad()
 #define __get_user_asm_ex_u64(x, ptr)			(x) = __get_user_bad()
@@ -543,29 +518,12 @@ struct __large_struct { unsigned long buf[100]; };
 	(x) = (__force __typeof__(*(ptr)))__gue_val;			\
 } while (0)
 
-#ifdef CONFIG_X86_WP_WORKS_OK
-
 #define put_user_try		uaccess_try
 #define put_user_catch(err)	uaccess_catch(err)
 
 #define put_user_ex(x, ptr)						\
 	__put_user_size_ex((__typeof__(*(ptr)))(x), (ptr), sizeof(*(ptr)))
 
-#else /* !CONFIG_X86_WP_WORKS_OK */
-
-#define put_user_try		do {		\
-	int __uaccess_err = 0;
-
-#define put_user_catch(err)			\
-	(err) |= __uaccess_err;			\
-} while (0)
-
-#define put_user_ex(x, ptr)	do {		\
-	__uaccess_err |= __put_user(x, ptr);	\
-} while (0)
-
-#endif /* CONFIG_X86_WP_WORKS_OK */
-
 extern unsigned long
 copy_from_user_nmi(void *to, const void __user *from, unsigned long n);
 extern __must_check long
diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index 1b7d165..a025d8c 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -753,9 +753,6 @@ static unsigned int __cpuinit amd_size_cache(struct cpuinfo_x86 *c,
 
 static void __cpuinit cpu_set_tlb_flushall_shift(struct cpuinfo_x86 *c)
 {
-	if (!cpu_has_invlpg)
-		return;
-
 	tlb_flushall_shift = 5;
 
 	if (c->x86 <= 0x11)
diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
index d0e910d..92dfec9 100644
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -107,53 +107,17 @@ static void __init check_hlt(void)
 }
 
 /*
- *	Most 386 processors have a bug where a POPAD can lock the
- *	machine even from user space.
- */
-
-static void __init check_popad(void)
-{
-#ifndef CONFIG_X86_POPAD_OK
-	int res, inp = (int) &res;
-
-	pr_info("Checking for popad bug... ");
-	__asm__ __volatile__(
-	  "movl $12345678,%%eax; movl $0,%%edi; pusha; popa; movl (%%edx,%%edi),%%ecx "
-	  : "=&a" (res)
-	  : "d" (inp)
-	  : "ecx", "edi");
-	/*
-	 * If this fails, it means that any user program may lock the
-	 * CPU hard. Too bad.
-	 */
-	if (res != 12345678)
-		pr_cont("Buggy\n");
-	else
-		pr_cont("OK\n");
-#endif
-}
-
-/*
  * Check whether we are able to run this kernel safely on SMP.
  *
- * - In order to run on a i386, we need to be compiled for i386
- *   (for due to lack of "invlpg" and working WP on a i386)
+ * - i386 is no longer supported.
  * - In order to run on anything without a TSC, we need to be
  *   compiled for a i486.
  */
 
 static void __init check_config(void)
 {
-/*
- * We'd better not be a i386 if we're configured to use some
- * i486+ only features! (WP works in supervisor mode and the
- * new "invlpg" and "bswap" instructions)
- */
-#if defined(CONFIG_X86_WP_WORKS_OK) || defined(CONFIG_X86_INVLPG) || \
-	defined(CONFIG_X86_BSWAP)
-	if (boot_cpu_data.x86 == 3)
+	if (boot_cpu_data.x86 < 4)
 		panic("Kernel requires i486+ for 'invlpg' and other features");
-#endif
 }
 
 
@@ -166,7 +130,6 @@ void __init check_bugs(void)
 #endif
 	check_config();
 	check_hlt();
-	check_popad();
 	init_utsname()->machine[1] =
 		'0' + (boot_cpu_data.x86 > 6 ? 6 : boot_cpu_data.x86);
 	alternative_instructions();
diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
index 198e019..fcaabd0 100644
--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -612,10 +612,6 @@ static void __cpuinit intel_tlb_lookup(const unsigned char desc)
 
 static void __cpuinit intel_tlb_flushall_shift_set(struct cpuinfo_x86 *c)
 {
-	if (!cpu_has_invlpg) {
-		tlb_flushall_shift = -1;
-		return;
-	}
 	switch ((c->x86 << 8) + c->x86_model) {
 	case 0x60f: /* original 65 nm celeron/pentium/core2/xeon, "Merom"/"Conroe" */
 	case 0x616: /* single-core 65 nm celeron/core2solo "Merom-L"/"Conroe-L" */
diff --git a/arch/x86/lib/Makefile b/arch/x86/lib/Makefile
index b00f678..96b2c66 100644
--- a/arch/x86/lib/Makefile
+++ b/arch/x86/lib/Makefile
@@ -32,7 +32,6 @@ ifeq ($(CONFIG_X86_32),y)
         lib-y += checksum_32.o
         lib-y += strstr_32.o
         lib-y += string_32.o
-        lib-y += cmpxchg.o
 ifneq ($(CONFIG_X86_CMPXCHG64),y)
         lib-y += cmpxchg8b_emu.o atomic64_386_32.o
 endif
diff --git a/arch/x86/lib/cmpxchg.c b/arch/x86/lib/cmpxchg.c
deleted file mode 100644
index 5d619f6..0000000
--- a/arch/x86/lib/cmpxchg.c
+++ /dev/null
@@ -1,54 +0,0 @@
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
diff --git a/arch/x86/lib/usercopy_32.c b/arch/x86/lib/usercopy_32.c
index 98f6d6b6..f0312d7 100644
--- a/arch/x86/lib/usercopy_32.c
+++ b/arch/x86/lib/usercopy_32.c
@@ -570,63 +570,6 @@ do {									\
 unsigned long __copy_to_user_ll(void __user *to, const void *from,
 				unsigned long n)
 {
-#ifndef CONFIG_X86_WP_WORKS_OK
-	if (unlikely(boot_cpu_data.wp_works_ok == 0) &&
-			((unsigned long)to) < TASK_SIZE) {
-		/*
-		 * When we are in an atomic section (see
-		 * mm/filemap.c:file_read_actor), return the full
-		 * length to take the slow path.
-		 */
-		if (in_atomic())
-			return n;
-
-		/*
-		 * CPU does not honor the WP bit when writing
-		 * from supervisory mode, and due to preemption or SMP,
-		 * the page tables can change at any time.
-		 * Do it manually.	Manfred <manfred@colorfullife.com>
-		 */
-		while (n) {
-			unsigned long offset = ((unsigned long)to)%PAGE_SIZE;
-			unsigned long len = PAGE_SIZE - offset;
-			int retval;
-			struct page *pg;
-			void *maddr;
-
-			if (len > n)
-				len = n;
-
-survive:
-			down_read(&current->mm->mmap_sem);
-			retval = get_user_pages(current, current->mm,
-					(unsigned long)to, 1, 1, 0, &pg, NULL);
-
-			if (retval == -ENOMEM && is_global_init(current)) {
-				up_read(&current->mm->mmap_sem);
-				congestion_wait(BLK_RW_ASYNC, HZ/50);
-				goto survive;
-			}
-
-			if (retval != 1) {
-				up_read(&current->mm->mmap_sem);
-				break;
-			}
-
-			maddr = kmap_atomic(pg);
-			memcpy(maddr + offset, from, len);
-			kunmap_atomic(maddr);
-			set_page_dirty_lock(pg);
-			put_page(pg);
-			up_read(&current->mm->mmap_sem);
-
-			from += len;
-			to += len;
-			n -= len;
-		}
-		return n;
-	}
-#endif
 	stac();
 	if (movsl_is_ok(to, from, n))
 		__copy_user(to, from, n);
diff --git a/arch/x86/mm/init_32.c b/arch/x86/mm/init_32.c
index 11a5800..745d66b 100644
--- a/arch/x86/mm/init_32.c
+++ b/arch/x86/mm/init_32.c
@@ -715,10 +715,7 @@ static void __init test_wp_bit(void)
 
 	if (!boot_cpu_data.wp_works_ok) {
 		printk(KERN_CONT "No.\n");
-#ifdef CONFIG_X86_WP_WORKS_OK
-		panic(
-  "This kernel doesn't support CPU's with broken WP. Recompile it for a 386!");
-#endif
+		panic("Linux doesn't support CPUs with broken WP.");
 	} else {
 		printk(KERN_CONT "Ok.\n");
 	}
diff --git a/arch/x86/mm/tlb.c b/arch/x86/mm/tlb.c
index 60f926c..13a6b29 100644
--- a/arch/x86/mm/tlb.c
+++ b/arch/x86/mm/tlb.c
@@ -104,7 +104,7 @@ static void flush_tlb_func(void *info)
 		return;
 
 	if (this_cpu_read(cpu_tlbstate.state) == TLBSTATE_OK) {
-		if (f->flush_end == TLB_FLUSH_ALL || !cpu_has_invlpg)
+		if (f->flush_end == TLB_FLUSH_ALL)
 			local_flush_tlb();
 		else if (!f->flush_end)
 			__flush_tlb_single(f->flush_start);
@@ -337,10 +337,8 @@ static const struct file_operations fops_tlbflush = {
 
 static int __cpuinit create_tlb_flushall_shift(void)
 {
-	if (cpu_has_invlpg) {
-		debugfs_create_file("tlb_flushall_shift", S_IRUSR | S_IWUSR,
-			arch_debugfs_dir, NULL, &fops_tlbflush);
-	}
+	debugfs_create_file("tlb_flushall_shift", S_IRUSR | S_IWUSR,
+			    arch_debugfs_dir, NULL, &fops_tlbflush);
 	return 0;
 }
 late_initcall(create_tlb_flushall_shift);
diff --git a/arch/x86/um/Kconfig b/arch/x86/um/Kconfig
index 0761175..b0c30da 100644
--- a/arch/x86/um/Kconfig
+++ b/arch/x86/um/Kconfig
@@ -31,7 +31,7 @@ config X86_64
 	select MODULES_USE_ELF_RELA
 
 config RWSEM_XCHGADD_ALGORITHM
-	def_bool X86_XADD && 64BIT
+	def_bool 64BIT
 
 config RWSEM_GENERIC_SPINLOCK
 	def_bool !RWSEM_XCHGADD_ALGORITHM
diff --git a/arch/x86/xen/Kconfig b/arch/x86/xen/Kconfig
index fdce49c..9a6775c 100644
--- a/arch/x86/xen/Kconfig
+++ b/arch/x86/xen/Kconfig
@@ -7,7 +7,7 @@ config XEN
 	select PARAVIRT
 	select PARAVIRT_CLOCK
 	depends on X86_64 || (X86_32 && X86_PAE && !X86_VISWS)
-	depends on X86_CMPXCHG && X86_TSC
+	depends on X86_TSC
 	help
 	  This is the Linux Xen port.  Enabling this will allow the
 	  kernel to boot in a paravirtualized environment under the
