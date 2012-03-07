Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760001Ab2CGTrT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 14:47:19 -0500
Received: from mx1.redhat.com ([209.132.183.28]:9006 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759927Ab2CGTrO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 14:47:14 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 05/29] Disintegrate asm/system.h for ARM
To: paul.gortmaker@windriver.com, hpa@zytor.com
Cc: torvalds@linux-foundation.org, sfr@canb.auug.org.au, mingo@redhat.com,
        arnd@arndb.de, dhowells@redhat.com, tglx@linutronix.de,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Date: Wed, 07 Mar 2012 19:46:53 +0000
Message-ID: <20120307194653.15987.51982.stgit@warthog.procyon.org.uk>
In-Reply-To: <20120307194548.15987.36073.stgit@warthog.procyon.org.uk>
References: <20120307194548.15987.36073.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: David Howells <dhowells@redhat.com>
---

 arch/arm/include/asm/atomic.h      |  289 +++++++++++++++++++
 arch/arm/include/asm/barrier.h     |   64 ++++
 arch/arm/include/asm/bitops.h      |    1 
 arch/arm/include/asm/bug.h         |   30 ++
 arch/arm/include/asm/compiler.h    |   15 +
 arch/arm/include/asm/cr_reg.h      |   85 ++++++
 arch/arm/include/asm/div64.h       |    1 
 arch/arm/include/asm/domain.h      |    2 
 arch/arm/include/asm/exec.h        |    6 
 arch/arm/include/asm/mmu.h         |    7 
 arch/arm/include/asm/switch_to.h   |   16 +
 arch/arm/include/asm/system.h      |  543 ------------------------------------
 arch/arm/include/asm/system_info.h |   27 ++
 arch/arm/include/asm/system_misc.h |   35 ++
 arch/arm/include/asm/uaccess.h     |    1 
 arch/arm/kernel/elf.c              |    1 
 arch/arm/kernel/head.S             |    1 
 arch/arm/kernel/setup.c            |    3 
 arch/arm/kernel/traps.c            |    1 
 arch/arm/mm/alignment.c            |    2 
 arch/arm/mm/fault.c                |    2 
 arch/arm/mm/idmap.c                |    1 
 arch/arm/mm/ioremap.c              |    2 
 arch/arm/mm/mmu.c                  |    2 
 arch/arm/mm/pgd.c                  |    1 
 arch/arm/vfp/vfpmodule.c           |    2 
 26 files changed, 597 insertions(+), 543 deletions(-)
 create mode 100644 arch/arm/include/asm/barrier.h
 create mode 100644 arch/arm/include/asm/compiler.h
 create mode 100644 arch/arm/include/asm/cr_reg.h
 create mode 100644 arch/arm/include/asm/exec.h
 create mode 100644 arch/arm/include/asm/switch_to.h
 delete mode 100644 arch/arm/include/asm/system.h
 create mode 100644 arch/arm/include/asm/system_info.h
 create mode 100644 arch/arm/include/asm/system_misc.h

diff --git a/arch/arm/include/asm/atomic.h b/arch/arm/include/asm/atomic.h
index cadb012..a9830af 100644
--- a/arch/arm/include/asm/atomic.h
+++ b/arch/arm/include/asm/atomic.h
@@ -13,11 +13,300 @@
 
 #include <linux/compiler.h>
 #include <linux/types.h>
+#include <asm/barrier.h>
 
 #define ATOMIC_INIT(i)	{ (i) }
 
 #ifdef __KERNEL__
 
+#if defined(CONFIG_CPU_SA1100) || defined(CONFIG_CPU_SA110)
+/*
+ * On the StrongARM, "swp" is terminally broken since it bypasses the
+ * cache totally.  This means that the cache becomes inconsistent, and,
+ * since we use normal loads/stores as well, this is really bad.
+ * Typically, this causes oopsen in filp_close, but could have other,
+ * more disastrous effects.  There are two work-arounds:
+ *  1. Disable interrupts and emulate the atomic swap
+ *  2. Clean the cache, perform atomic swap, flush the cache
+ *
+ * We choose (1) since its the "easiest" to achieve here and is not
+ * dependent on the processor type.
+ *
+ * NOTE that this solution won't work on an SMP system, so explcitly
+ * forbid it here.
+ */
+#define swp_is_buggy
+#endif
+
+static inline unsigned long __xchg(unsigned long x, volatile void *ptr, int size)
+{
+	extern void __bad_xchg(volatile void *, int);
+	unsigned long ret;
+#ifdef swp_is_buggy
+	unsigned long flags;
+#endif
+#if __LINUX_ARM_ARCH__ >= 6
+	unsigned int tmp;
+#endif
+
+	smp_mb();
+
+	switch (size) {
+#if __LINUX_ARM_ARCH__ >= 6
+	case 1:
+		asm volatile("@	__xchg1\n"
+		"1:	ldrexb	%0, [%3]\n"
+		"	strexb	%1, %2, [%3]\n"
+		"	teq	%1, #0\n"
+		"	bne	1b"
+			: "=&r" (ret), "=&r" (tmp)
+			: "r" (x), "r" (ptr)
+			: "memory", "cc");
+		break;
+	case 4:
+		asm volatile("@	__xchg4\n"
+		"1:	ldrex	%0, [%3]\n"
+		"	strex	%1, %2, [%3]\n"
+		"	teq	%1, #0\n"
+		"	bne	1b"
+			: "=&r" (ret), "=&r" (tmp)
+			: "r" (x), "r" (ptr)
+			: "memory", "cc");
+		break;
+#elif defined(swp_is_buggy)
+#ifdef CONFIG_SMP
+#error SMP is not supported on this platform
+#endif
+	case 1:
+		raw_local_irq_save(flags);
+		ret = *(volatile unsigned char *)ptr;
+		*(volatile unsigned char *)ptr = x;
+		raw_local_irq_restore(flags);
+		break;
+
+	case 4:
+		raw_local_irq_save(flags);
+		ret = *(volatile unsigned long *)ptr;
+		*(volatile unsigned long *)ptr = x;
+		raw_local_irq_restore(flags);
+		break;
+#else
+	case 1:
+		asm volatile("@	__xchg1\n"
+		"	swpb	%0, %1, [%2]"
+			: "=&r" (ret)
+			: "r" (x), "r" (ptr)
+			: "memory", "cc");
+		break;
+	case 4:
+		asm volatile("@	__xchg4\n"
+		"	swp	%0, %1, [%2]"
+			: "=&r" (ret)
+			: "r" (x), "r" (ptr)
+			: "memory", "cc");
+		break;
+#endif
+	default:
+		__bad_xchg(ptr, size), ret = 0;
+		break;
+	}
+	smp_mb();
+
+	return ret;
+}
+
+#define xchg(ptr,x) \
+	((__typeof__(*(ptr)))__xchg((unsigned long)(x),(ptr),sizeof(*(ptr))))
+
+#include <asm-generic/cmpxchg-local.h>
+
+#if __LINUX_ARM_ARCH__ < 6
+/* min ARCH < ARMv6 */
+
+#ifdef CONFIG_SMP
+#error "SMP is not supported on this platform"
+#endif
+
+/*
+ * cmpxchg_local and cmpxchg64_local are atomic wrt current CPU. Always make
+ * them available.
+ */
+#define cmpxchg_local(ptr, o, n)				  	       \
+	((__typeof__(*(ptr)))__cmpxchg_local_generic((ptr), (unsigned long)(o),\
+			(unsigned long)(n), sizeof(*(ptr))))
+#define cmpxchg64_local(ptr, o, n) __cmpxchg64_local_generic((ptr), (o), (n))
+
+#ifndef CONFIG_SMP
+#include <asm-generic/cmpxchg.h>
+#endif
+
+#else	/* min ARCH >= ARMv6 */
+
+extern void __bad_cmpxchg(volatile void *ptr, int size);
+
+/*
+ * cmpxchg only support 32-bits operands on ARMv6.
+ */
+
+static inline unsigned long __cmpxchg(volatile void *ptr, unsigned long old,
+				      unsigned long new, int size)
+{
+	unsigned long oldval, res;
+
+	switch (size) {
+#ifndef CONFIG_CPU_V6	/* min ARCH >= ARMv6K */
+	case 1:
+		do {
+			asm volatile("@ __cmpxchg1\n"
+			"	ldrexb	%1, [%2]\n"
+			"	mov	%0, #0\n"
+			"	teq	%1, %3\n"
+			"	strexbeq %0, %4, [%2]\n"
+				: "=&r" (res), "=&r" (oldval)
+				: "r" (ptr), "Ir" (old), "r" (new)
+				: "memory", "cc");
+		} while (res);
+		break;
+	case 2:
+		do {
+			asm volatile("@ __cmpxchg1\n"
+			"	ldrexh	%1, [%2]\n"
+			"	mov	%0, #0\n"
+			"	teq	%1, %3\n"
+			"	strexheq %0, %4, [%2]\n"
+				: "=&r" (res), "=&r" (oldval)
+				: "r" (ptr), "Ir" (old), "r" (new)
+				: "memory", "cc");
+		} while (res);
+		break;
+#endif
+	case 4:
+		do {
+			asm volatile("@ __cmpxchg4\n"
+			"	ldrex	%1, [%2]\n"
+			"	mov	%0, #0\n"
+			"	teq	%1, %3\n"
+			"	strexeq %0, %4, [%2]\n"
+				: "=&r" (res), "=&r" (oldval)
+				: "r" (ptr), "Ir" (old), "r" (new)
+				: "memory", "cc");
+		} while (res);
+		break;
+	default:
+		__bad_cmpxchg(ptr, size);
+		oldval = 0;
+	}
+
+	return oldval;
+}
+
+static inline unsigned long __cmpxchg_mb(volatile void *ptr, unsigned long old,
+					 unsigned long new, int size)
+{
+	unsigned long ret;
+
+	smp_mb();
+	ret = __cmpxchg(ptr, old, new, size);
+	smp_mb();
+
+	return ret;
+}
+
+#define cmpxchg(ptr,o,n)						\
+	((__typeof__(*(ptr)))__cmpxchg_mb((ptr),			\
+					  (unsigned long)(o),		\
+					  (unsigned long)(n),		\
+					  sizeof(*(ptr))))
+
+static inline unsigned long __cmpxchg_local(volatile void *ptr,
+					    unsigned long old,
+					    unsigned long new, int size)
+{
+	unsigned long ret;
+
+	switch (size) {
+#ifdef CONFIG_CPU_V6	/* min ARCH == ARMv6 */
+	case 1:
+	case 2:
+		ret = __cmpxchg_local_generic(ptr, old, new, size);
+		break;
+#endif
+	default:
+		ret = __cmpxchg(ptr, old, new, size);
+	}
+
+	return ret;
+}
+
+#define cmpxchg_local(ptr,o,n)						\
+	((__typeof__(*(ptr)))__cmpxchg_local((ptr),			\
+				       (unsigned long)(o),		\
+				       (unsigned long)(n),		\
+				       sizeof(*(ptr))))
+
+#ifndef CONFIG_CPU_V6	/* min ARCH >= ARMv6K */
+
+/*
+ * Note : ARMv7-M (currently unsupported by Linux) does not support
+ * ldrexd/strexd. If ARMv7-M is ever supported by the Linux kernel, it should
+ * not be allowed to use __cmpxchg64.
+ */
+static inline unsigned long long __cmpxchg64(volatile void *ptr,
+					     unsigned long long old,
+					     unsigned long long new)
+{
+	register unsigned long long oldval asm("r0");
+	register unsigned long long __old asm("r2") = old;
+	register unsigned long long __new asm("r4") = new;
+	unsigned long res;
+
+	do {
+		asm volatile(
+		"	@ __cmpxchg8\n"
+		"	ldrexd	%1, %H1, [%2]\n"
+		"	mov	%0, #0\n"
+		"	teq	%1, %3\n"
+		"	teqeq	%H1, %H3\n"
+		"	strexdeq %0, %4, %H4, [%2]\n"
+			: "=&r" (res), "=&r" (oldval)
+			: "r" (ptr), "Ir" (__old), "r" (__new)
+			: "memory", "cc");
+	} while (res);
+
+	return oldval;
+}
+
+static inline unsigned long long __cmpxchg64_mb(volatile void *ptr,
+						unsigned long long old,
+						unsigned long long new)
+{
+	unsigned long long ret;
+
+	smp_mb();
+	ret = __cmpxchg64(ptr, old, new);
+	smp_mb();
+
+	return ret;
+}
+
+#define cmpxchg64(ptr,o,n)						\
+	((__typeof__(*(ptr)))__cmpxchg64_mb((ptr),			\
+					    (unsigned long long)(o),	\
+					    (unsigned long long)(n)))
+
+#define cmpxchg64_local(ptr,o,n)					\
+	((__typeof__(*(ptr)))__cmpxchg64((ptr),				\
+					 (unsigned long long)(o),	\
+					 (unsigned long long)(n)))
+
+#else /* min ARCH = ARMv6 */
+
+#define cmpxchg64_local(ptr, o, n) __cmpxchg64_local_generic((ptr), (o), (n))
+
+#endif
+
+#endif	/* __LINUX_ARM_ARCH__ >= 6 */
+
 /*
  * On ARM, ordinary assignment (str instruction) doesn't clear the local
  * strex/ldrex monitor on some implementations. The reason we can use it for
diff --git a/arch/arm/include/asm/barrier.h b/arch/arm/include/asm/barrier.h
new file mode 100644
index 0000000..81b24b6
--- /dev/null
+++ b/arch/arm/include/asm/barrier.h
@@ -0,0 +1,64 @@
+#ifndef __ASM_BARRIER_H
+#define __ASM_BARRIER_H
+
+
+#if __LINUX_ARM_ARCH__ >= 7 ||		\
+	(__LINUX_ARM_ARCH__ == 6 && defined(CONFIG_CPU_32v6K))
+#define sev()	__asm__ __volatile__ ("sev" : : : "memory")
+#define wfe()	__asm__ __volatile__ ("wfe" : : : "memory")
+#define wfi()	__asm__ __volatile__ ("wfi" : : : "memory")
+#endif
+
+#if __LINUX_ARM_ARCH__ >= 7
+#define isb() __asm__ __volatile__ ("isb" : : : "memory")
+#define dsb() __asm__ __volatile__ ("dsb" : : : "memory")
+#define dmb() __asm__ __volatile__ ("dmb" : : : "memory")
+#elif defined(CONFIG_CPU_XSC3) || __LINUX_ARM_ARCH__ == 6
+#define isb() __asm__ __volatile__ ("mcr p15, 0, %0, c7, c5, 4" \
+				    : : "r" (0) : "memory")
+#define dsb() __asm__ __volatile__ ("mcr p15, 0, %0, c7, c10, 4" \
+				    : : "r" (0) : "memory")
+#define dmb() __asm__ __volatile__ ("mcr p15, 0, %0, c7, c10, 5" \
+				    : : "r" (0) : "memory")
+#elif defined(CONFIG_CPU_FA526)
+#define isb() __asm__ __volatile__ ("mcr p15, 0, %0, c7, c5, 4" \
+				    : : "r" (0) : "memory")
+#define dsb() __asm__ __volatile__ ("mcr p15, 0, %0, c7, c10, 4" \
+				    : : "r" (0) : "memory")
+#define dmb() __asm__ __volatile__ ("" : : : "memory")
+#else
+#define isb() __asm__ __volatile__ ("" : : : "memory")
+#define dsb() __asm__ __volatile__ ("mcr p15, 0, %0, c7, c10, 4" \
+				    : : "r" (0) : "memory")
+#define dmb() __asm__ __volatile__ ("" : : : "memory")
+#endif
+
+#ifdef CONFIG_ARCH_HAS_BARRIERS
+#include <mach/barriers.h>
+#elif defined(CONFIG_ARM_DMA_MEM_BUFFERABLE) || defined(CONFIG_SMP)
+#define mb()		do { dsb(); outer_sync(); } while (0)
+#define rmb()		dsb()
+#define wmb()		mb()
+#else
+#include <asm/memory.h>
+#define mb()	do { if (arch_is_coherent()) dmb(); else barrier(); } while (0)
+#define rmb()	do { if (arch_is_coherent()) dmb(); else barrier(); } while (0)
+#define wmb()	do { if (arch_is_coherent()) dmb(); else barrier(); } while (0)
+#endif
+
+#ifndef CONFIG_SMP
+#define smp_mb()	barrier()
+#define smp_rmb()	barrier()
+#define smp_wmb()	barrier()
+#else
+#define smp_mb()	dmb()
+#define smp_rmb()	dmb()
+#define smp_wmb()	dmb()
+#endif
+
+#define read_barrier_depends()		do { } while(0)
+#define smp_read_barrier_depends()	do { } while(0)
+
+#define set_mb(var, value)	do { var = value; smp_mb(); } while (0)
+
+#endif /* __ASM_BARRIER_H */
diff --git a/arch/arm/include/asm/bitops.h b/arch/arm/include/asm/bitops.h
index 2c56593..e691ec9 100644
--- a/arch/arm/include/asm/bitops.h
+++ b/arch/arm/include/asm/bitops.h
@@ -24,6 +24,7 @@
 #endif
 
 #include <linux/compiler.h>
+#include <linux/irqflags.h>
 
 #define smp_mb__before_clear_bit()	smp_mb()
 #define smp_mb__after_clear_bit()	smp_mb()
diff --git a/arch/arm/include/asm/bug.h b/arch/arm/include/asm/bug.h
index fac79dc..7af5c6c 100644
--- a/arch/arm/include/asm/bug.h
+++ b/arch/arm/include/asm/bug.h
@@ -1,6 +1,7 @@
 #ifndef _ASMARM_BUG_H
 #define _ASMARM_BUG_H
 
+#include <linux/linkage.h>
 
 #ifdef CONFIG_BUG
 
@@ -57,4 +58,33 @@ do {								\
 
 #include <asm-generic/bug.h>
 
+struct pt_regs;
+void die(const char *msg, struct pt_regs *regs, int err);
+
+struct siginfo;
+void arm_notify_die(const char *str, struct pt_regs *regs, struct siginfo *info,
+		unsigned long err, unsigned long trap);
+
+#ifdef CONFIG_ARM_LPAE
+#define FAULT_CODE_ALIGNMENT	33
+#define FAULT_CODE_DEBUG	34
+#else
+#define FAULT_CODE_ALIGNMENT	1
+#define FAULT_CODE_DEBUG	2
+#endif
+
+void hook_fault_code(int nr, int (*fn)(unsigned long, unsigned int,
+				       struct pt_regs *),
+		     int sig, int code, const char *name);
+
+void hook_ifault_code(int nr, int (*fn)(unsigned long, unsigned int,
+				       struct pt_regs *),
+		     int sig, int code, const char *name);
+
+extern asmlinkage void c_backtrace(unsigned long fp, int pmode);
+
+struct mm_struct;
+extern void show_pte(struct mm_struct *mm, unsigned long addr);
+extern void __show_regs(struct pt_regs *);
+
 #endif
diff --git a/arch/arm/include/asm/compiler.h b/arch/arm/include/asm/compiler.h
new file mode 100644
index 0000000..8155db2
--- /dev/null
+++ b/arch/arm/include/asm/compiler.h
@@ -0,0 +1,15 @@
+#ifndef __ASM_ARM_COMPILER_H
+#define __ASM_ARM_COMPILER_H
+
+/*
+ * This is used to ensure the compiler did actually allocate the register we
+ * asked it for some inline assembly sequences.  Apparently we can't trust
+ * the compiler from one version to another so a bit of paranoia won't hurt.
+ * This string is meant to be concatenated with the inline asm string and
+ * will cause compilation to stop on mismatch.
+ * (for details, see gcc PR 15089)
+ */
+#define __asmeq(x, y)  ".ifnc " x "," y " ; .err ; .endif\n\t"
+
+
+#endif /* __ASM_ARM_COMPILER_H */
diff --git a/arch/arm/include/asm/cr_reg.h b/arch/arm/include/asm/cr_reg.h
new file mode 100644
index 0000000..df83b5b
--- /dev/null
+++ b/arch/arm/include/asm/cr_reg.h
@@ -0,0 +1,85 @@
+#ifndef __ASM_ARM_CR_REG_H
+#define __ASM_ARM_CR_REG_H
+
+/*
+ * CR1 bits (CP#15 CR1)
+ */
+#define CR_M	(1 << 0)	/* MMU enable				*/
+#define CR_A	(1 << 1)	/* Alignment abort enable		*/
+#define CR_C	(1 << 2)	/* Dcache enable			*/
+#define CR_W	(1 << 3)	/* Write buffer enable			*/
+#define CR_P	(1 << 4)	/* 32-bit exception handler		*/
+#define CR_D	(1 << 5)	/* 32-bit data address range		*/
+#define CR_L	(1 << 6)	/* Implementation defined		*/
+#define CR_B	(1 << 7)	/* Big endian				*/
+#define CR_S	(1 << 8)	/* System MMU protection		*/
+#define CR_R	(1 << 9)	/* ROM MMU protection			*/
+#define CR_F	(1 << 10)	/* Implementation defined		*/
+#define CR_Z	(1 << 11)	/* Implementation defined		*/
+#define CR_I	(1 << 12)	/* Icache enable			*/
+#define CR_V	(1 << 13)	/* Vectors relocated to 0xffff0000	*/
+#define CR_RR	(1 << 14)	/* Round Robin cache replacement	*/
+#define CR_L4	(1 << 15)	/* LDR pc can set T bit			*/
+#define CR_DT	(1 << 16)
+#define CR_IT	(1 << 18)
+#define CR_ST	(1 << 19)
+#define CR_FI	(1 << 21)	/* Fast interrupt (lower latency mode)	*/
+#define CR_U	(1 << 22)	/* Unaligned access operation		*/
+#define CR_XP	(1 << 23)	/* Extended page tables			*/
+#define CR_VE	(1 << 24)	/* Vectored interrupts			*/
+#define CR_EE	(1 << 25)	/* Exception (Big) Endian		*/
+#define CR_TRE	(1 << 28)	/* TEX remap enable			*/
+#define CR_AFE	(1 << 29)	/* Access flag enable			*/
+#define CR_TE	(1 << 30)	/* Thumb exception enable		*/
+
+#ifndef __ASSEMBLY__
+
+extern unsigned long cr_no_alignment;	/* defined in entry-armv.S */
+extern unsigned long cr_alignment;	/* defined in entry-armv.S */
+
+#if __LINUX_ARM_ARCH__ >= 4
+#define vectors_high()	(cr_alignment & CR_V)
+#else
+#define vectors_high()	(0)
+#endif
+
+static inline unsigned int get_cr(void)
+{
+	unsigned int val;
+	asm("mrc p15, 0, %0, c1, c0, 0	@ get CR" : "=r" (val) : : "cc");
+	return val;
+}
+
+static inline void set_cr(unsigned int val)
+{
+	asm volatile("mcr p15, 0, %0, c1, c0, 0	@ set CR"
+	  : : "r" (val) : "cc");
+	isb();
+}
+
+#ifndef CONFIG_SMP
+extern void adjust_cr(unsigned long mask, unsigned long set);
+#endif
+
+#define CPACC_FULL(n)		(3 << (n * 2))
+#define CPACC_SVC(n)		(1 << (n * 2))
+#define CPACC_DISABLE(n)	(0 << (n * 2))
+
+static inline unsigned int get_copro_access(void)
+{
+	unsigned int val;
+	asm("mrc p15, 0, %0, c1, c0, 2 @ get copro access"
+	  : "=r" (val) : : "cc");
+	return val;
+}
+
+static inline void set_copro_access(unsigned int val)
+{
+	asm volatile("mcr p15, 0, %0, c1, c0, 2 @ set copro access"
+	  : : "r" (val) : "cc");
+	isb();
+}
+
+#endif /* !__ASSEMBLY__ */
+
+#endif /* __ASM_ARM_CR_REG_H */
diff --git a/arch/arm/include/asm/div64.h b/arch/arm/include/asm/div64.h
index 3427f44..fe92ccf 100644
--- a/arch/arm/include/asm/div64.h
+++ b/arch/arm/include/asm/div64.h
@@ -2,6 +2,7 @@
 #define __ASM_ARM_DIV64
 
 #include <linux/types.h>
+#include <asm/compiler.h>
 
 /*
  * The semantics of do_div() are:
diff --git a/arch/arm/include/asm/domain.h b/arch/arm/include/asm/domain.h
index b5dc173..489f160 100644
--- a/arch/arm/include/asm/domain.h
+++ b/arch/arm/include/asm/domain.h
@@ -10,6 +10,8 @@
 #ifndef __ASM_PROC_DOMAIN_H
 #define __ASM_PROC_DOMAIN_H
 
+#include <asm/barrier.h>
+
 /*
  * Domain numbers
  *
diff --git a/arch/arm/include/asm/exec.h b/arch/arm/include/asm/exec.h
new file mode 100644
index 0000000..7c4fbef
--- /dev/null
+++ b/arch/arm/include/asm/exec.h
@@ -0,0 +1,6 @@
+#ifndef __ASM_ARM_EXEC_H
+#define __ASM_ARM_EXEC_H
+
+#define arch_align_stack(x) (x)
+
+#endif /* __ASM_ARM_EXEC_H */
diff --git a/arch/arm/include/asm/mmu.h b/arch/arm/include/asm/mmu.h
index 1496565..b8e580a 100644
--- a/arch/arm/include/asm/mmu.h
+++ b/arch/arm/include/asm/mmu.h
@@ -34,4 +34,11 @@ typedef struct {
 
 #endif
 
+/*
+ * switch_mm() may do a full cache flush over the context switch,
+ * so enable interrupts over the context switch to avoid high
+ * latency.
+ */
+#define __ARCH_WANT_INTERRUPTS_ON_CTXSW
+
 #endif
diff --git a/arch/arm/include/asm/switch_to.h b/arch/arm/include/asm/switch_to.h
new file mode 100644
index 0000000..d6573fa
--- /dev/null
+++ b/arch/arm/include/asm/switch_to.h
@@ -0,0 +1,16 @@
+#ifndef __ASM_ARM_SWITCH_TO_H
+#define __ASM_ARM_SWITCH_TO_H
+
+/*
+ * switch_to(prev, next) should switch from task `prev' to `next'
+ * `prev' will never be the same as `next'.  schedule() itself
+ * contains the memory barrier to tell GCC not to cache `current'.
+ */
+extern struct task_struct *__switch_to(struct task_struct *, struct thread_info *, struct thread_info *);
+
+#define switch_to(prev,next,last)					\
+do {									\
+	last = __switch_to(prev,task_thread_info(prev), task_thread_info(next));	\
+} while (0)
+
+#endif /* __ASM_ARM_SWITCH_TO_H */
diff --git a/arch/arm/include/asm/system.h b/arch/arm/include/asm/system.h
deleted file mode 100644
index e4c96cc..0000000
--- a/arch/arm/include/asm/system.h
+++ /dev/null
@@ -1,543 +0,0 @@
-#ifndef __ASM_ARM_SYSTEM_H
-#define __ASM_ARM_SYSTEM_H
-
-#ifdef __KERNEL__
-
-#define CPU_ARCH_UNKNOWN	0
-#define CPU_ARCH_ARMv3		1
-#define CPU_ARCH_ARMv4		2
-#define CPU_ARCH_ARMv4T		3
-#define CPU_ARCH_ARMv5		4
-#define CPU_ARCH_ARMv5T		5
-#define CPU_ARCH_ARMv5TE	6
-#define CPU_ARCH_ARMv5TEJ	7
-#define CPU_ARCH_ARMv6		8
-#define CPU_ARCH_ARMv7		9
-
-/*
- * CR1 bits (CP#15 CR1)
- */
-#define CR_M	(1 << 0)	/* MMU enable				*/
-#define CR_A	(1 << 1)	/* Alignment abort enable		*/
-#define CR_C	(1 << 2)	/* Dcache enable			*/
-#define CR_W	(1 << 3)	/* Write buffer enable			*/
-#define CR_P	(1 << 4)	/* 32-bit exception handler		*/
-#define CR_D	(1 << 5)	/* 32-bit data address range		*/
-#define CR_L	(1 << 6)	/* Implementation defined		*/
-#define CR_B	(1 << 7)	/* Big endian				*/
-#define CR_S	(1 << 8)	/* System MMU protection		*/
-#define CR_R	(1 << 9)	/* ROM MMU protection			*/
-#define CR_F	(1 << 10)	/* Implementation defined		*/
-#define CR_Z	(1 << 11)	/* Implementation defined		*/
-#define CR_I	(1 << 12)	/* Icache enable			*/
-#define CR_V	(1 << 13)	/* Vectors relocated to 0xffff0000	*/
-#define CR_RR	(1 << 14)	/* Round Robin cache replacement	*/
-#define CR_L4	(1 << 15)	/* LDR pc can set T bit			*/
-#define CR_DT	(1 << 16)
-#define CR_IT	(1 << 18)
-#define CR_ST	(1 << 19)
-#define CR_FI	(1 << 21)	/* Fast interrupt (lower latency mode)	*/
-#define CR_U	(1 << 22)	/* Unaligned access operation		*/
-#define CR_XP	(1 << 23)	/* Extended page tables			*/
-#define CR_VE	(1 << 24)	/* Vectored interrupts			*/
-#define CR_EE	(1 << 25)	/* Exception (Big) Endian		*/
-#define CR_TRE	(1 << 28)	/* TEX remap enable			*/
-#define CR_AFE	(1 << 29)	/* Access flag enable			*/
-#define CR_TE	(1 << 30)	/* Thumb exception enable		*/
-
-/*
- * This is used to ensure the compiler did actually allocate the register we
- * asked it for some inline assembly sequences.  Apparently we can't trust
- * the compiler from one version to another so a bit of paranoia won't hurt.
- * This string is meant to be concatenated with the inline asm string and
- * will cause compilation to stop on mismatch.
- * (for details, see gcc PR 15089)
- */
-#define __asmeq(x, y)  ".ifnc " x "," y " ; .err ; .endif\n\t"
-
-#ifndef __ASSEMBLY__
-
-#include <linux/compiler.h>
-#include <linux/linkage.h>
-#include <linux/irqflags.h>
-
-#include <asm/outercache.h>
-
-struct thread_info;
-struct task_struct;
-
-/* information about the system we're running on */
-extern unsigned int system_rev;
-extern unsigned int system_serial_low;
-extern unsigned int system_serial_high;
-extern unsigned int mem_fclk_21285;
-
-struct pt_regs;
-
-void die(const char *msg, struct pt_regs *regs, int err);
-
-struct siginfo;
-void arm_notify_die(const char *str, struct pt_regs *regs, struct siginfo *info,
-		unsigned long err, unsigned long trap);
-
-#ifdef CONFIG_ARM_LPAE
-#define FAULT_CODE_ALIGNMENT	33
-#define FAULT_CODE_DEBUG	34
-#else
-#define FAULT_CODE_ALIGNMENT	1
-#define FAULT_CODE_DEBUG	2
-#endif
-
-void hook_fault_code(int nr, int (*fn)(unsigned long, unsigned int,
-				       struct pt_regs *),
-		     int sig, int code, const char *name);
-
-void hook_ifault_code(int nr, int (*fn)(unsigned long, unsigned int,
-				       struct pt_regs *),
-		     int sig, int code, const char *name);
-
-#define xchg(ptr,x) \
-	((__typeof__(*(ptr)))__xchg((unsigned long)(x),(ptr),sizeof(*(ptr))))
-
-extern asmlinkage void c_backtrace(unsigned long fp, int pmode);
-
-struct mm_struct;
-extern void show_pte(struct mm_struct *mm, unsigned long addr);
-extern void __show_regs(struct pt_regs *);
-
-extern int __pure cpu_architecture(void);
-extern void cpu_init(void);
-
-void soft_restart(unsigned long);
-extern void (*arm_pm_restart)(char str, const char *cmd);
-
-#define UDBG_UNDEFINED	(1 << 0)
-#define UDBG_SYSCALL	(1 << 1)
-#define UDBG_BADABORT	(1 << 2)
-#define UDBG_SEGV	(1 << 3)
-#define UDBG_BUS	(1 << 4)
-
-extern unsigned int user_debug;
-
-#if __LINUX_ARM_ARCH__ >= 4
-#define vectors_high()	(cr_alignment & CR_V)
-#else
-#define vectors_high()	(0)
-#endif
-
-#if __LINUX_ARM_ARCH__ >= 7 ||		\
-	(__LINUX_ARM_ARCH__ == 6 && defined(CONFIG_CPU_32v6K))
-#define sev()	__asm__ __volatile__ ("sev" : : : "memory")
-#define wfe()	__asm__ __volatile__ ("wfe" : : : "memory")
-#define wfi()	__asm__ __volatile__ ("wfi" : : : "memory")
-#endif
-
-#if __LINUX_ARM_ARCH__ >= 7
-#define isb() __asm__ __volatile__ ("isb" : : : "memory")
-#define dsb() __asm__ __volatile__ ("dsb" : : : "memory")
-#define dmb() __asm__ __volatile__ ("dmb" : : : "memory")
-#elif defined(CONFIG_CPU_XSC3) || __LINUX_ARM_ARCH__ == 6
-#define isb() __asm__ __volatile__ ("mcr p15, 0, %0, c7, c5, 4" \
-				    : : "r" (0) : "memory")
-#define dsb() __asm__ __volatile__ ("mcr p15, 0, %0, c7, c10, 4" \
-				    : : "r" (0) : "memory")
-#define dmb() __asm__ __volatile__ ("mcr p15, 0, %0, c7, c10, 5" \
-				    : : "r" (0) : "memory")
-#elif defined(CONFIG_CPU_FA526)
-#define isb() __asm__ __volatile__ ("mcr p15, 0, %0, c7, c5, 4" \
-				    : : "r" (0) : "memory")
-#define dsb() __asm__ __volatile__ ("mcr p15, 0, %0, c7, c10, 4" \
-				    : : "r" (0) : "memory")
-#define dmb() __asm__ __volatile__ ("" : : : "memory")
-#else
-#define isb() __asm__ __volatile__ ("" : : : "memory")
-#define dsb() __asm__ __volatile__ ("mcr p15, 0, %0, c7, c10, 4" \
-				    : : "r" (0) : "memory")
-#define dmb() __asm__ __volatile__ ("" : : : "memory")
-#endif
-
-#ifdef CONFIG_ARCH_HAS_BARRIERS
-#include <mach/barriers.h>
-#elif defined(CONFIG_ARM_DMA_MEM_BUFFERABLE) || defined(CONFIG_SMP)
-#define mb()		do { dsb(); outer_sync(); } while (0)
-#define rmb()		dsb()
-#define wmb()		mb()
-#else
-#include <asm/memory.h>
-#define mb()	do { if (arch_is_coherent()) dmb(); else barrier(); } while (0)
-#define rmb()	do { if (arch_is_coherent()) dmb(); else barrier(); } while (0)
-#define wmb()	do { if (arch_is_coherent()) dmb(); else barrier(); } while (0)
-#endif
-
-#ifndef CONFIG_SMP
-#define smp_mb()	barrier()
-#define smp_rmb()	barrier()
-#define smp_wmb()	barrier()
-#else
-#define smp_mb()	dmb()
-#define smp_rmb()	dmb()
-#define smp_wmb()	dmb()
-#endif
-
-#define read_barrier_depends()		do { } while(0)
-#define smp_read_barrier_depends()	do { } while(0)
-
-#define set_mb(var, value)	do { var = value; smp_mb(); } while (0)
-#define nop() __asm__ __volatile__("mov\tr0,r0\t@ nop\n\t");
-
-extern unsigned long cr_no_alignment;	/* defined in entry-armv.S */
-extern unsigned long cr_alignment;	/* defined in entry-armv.S */
-
-static inline unsigned int get_cr(void)
-{
-	unsigned int val;
-	asm("mrc p15, 0, %0, c1, c0, 0	@ get CR" : "=r" (val) : : "cc");
-	return val;
-}
-
-static inline void set_cr(unsigned int val)
-{
-	asm volatile("mcr p15, 0, %0, c1, c0, 0	@ set CR"
-	  : : "r" (val) : "cc");
-	isb();
-}
-
-#ifndef CONFIG_SMP
-extern void adjust_cr(unsigned long mask, unsigned long set);
-#endif
-
-#define CPACC_FULL(n)		(3 << (n * 2))
-#define CPACC_SVC(n)		(1 << (n * 2))
-#define CPACC_DISABLE(n)	(0 << (n * 2))
-
-static inline unsigned int get_copro_access(void)
-{
-	unsigned int val;
-	asm("mrc p15, 0, %0, c1, c0, 2 @ get copro access"
-	  : "=r" (val) : : "cc");
-	return val;
-}
-
-static inline void set_copro_access(unsigned int val)
-{
-	asm volatile("mcr p15, 0, %0, c1, c0, 2 @ set copro access"
-	  : : "r" (val) : "cc");
-	isb();
-}
-
-/*
- * switch_mm() may do a full cache flush over the context switch,
- * so enable interrupts over the context switch to avoid high
- * latency.
- */
-#define __ARCH_WANT_INTERRUPTS_ON_CTXSW
-
-/*
- * switch_to(prev, next) should switch from task `prev' to `next'
- * `prev' will never be the same as `next'.  schedule() itself
- * contains the memory barrier to tell GCC not to cache `current'.
- */
-extern struct task_struct *__switch_to(struct task_struct *, struct thread_info *, struct thread_info *);
-
-#define switch_to(prev,next,last)					\
-do {									\
-	last = __switch_to(prev,task_thread_info(prev), task_thread_info(next));	\
-} while (0)
-
-#if defined(CONFIG_CPU_SA1100) || defined(CONFIG_CPU_SA110)
-/*
- * On the StrongARM, "swp" is terminally broken since it bypasses the
- * cache totally.  This means that the cache becomes inconsistent, and,
- * since we use normal loads/stores as well, this is really bad.
- * Typically, this causes oopsen in filp_close, but could have other,
- * more disastrous effects.  There are two work-arounds:
- *  1. Disable interrupts and emulate the atomic swap
- *  2. Clean the cache, perform atomic swap, flush the cache
- *
- * We choose (1) since its the "easiest" to achieve here and is not
- * dependent on the processor type.
- *
- * NOTE that this solution won't work on an SMP system, so explcitly
- * forbid it here.
- */
-#define swp_is_buggy
-#endif
-
-static inline unsigned long __xchg(unsigned long x, volatile void *ptr, int size)
-{
-	extern void __bad_xchg(volatile void *, int);
-	unsigned long ret;
-#ifdef swp_is_buggy
-	unsigned long flags;
-#endif
-#if __LINUX_ARM_ARCH__ >= 6
-	unsigned int tmp;
-#endif
-
-	smp_mb();
-
-	switch (size) {
-#if __LINUX_ARM_ARCH__ >= 6
-	case 1:
-		asm volatile("@	__xchg1\n"
-		"1:	ldrexb	%0, [%3]\n"
-		"	strexb	%1, %2, [%3]\n"
-		"	teq	%1, #0\n"
-		"	bne	1b"
-			: "=&r" (ret), "=&r" (tmp)
-			: "r" (x), "r" (ptr)
-			: "memory", "cc");
-		break;
-	case 4:
-		asm volatile("@	__xchg4\n"
-		"1:	ldrex	%0, [%3]\n"
-		"	strex	%1, %2, [%3]\n"
-		"	teq	%1, #0\n"
-		"	bne	1b"
-			: "=&r" (ret), "=&r" (tmp)
-			: "r" (x), "r" (ptr)
-			: "memory", "cc");
-		break;
-#elif defined(swp_is_buggy)
-#ifdef CONFIG_SMP
-#error SMP is not supported on this platform
-#endif
-	case 1:
-		raw_local_irq_save(flags);
-		ret = *(volatile unsigned char *)ptr;
-		*(volatile unsigned char *)ptr = x;
-		raw_local_irq_restore(flags);
-		break;
-
-	case 4:
-		raw_local_irq_save(flags);
-		ret = *(volatile unsigned long *)ptr;
-		*(volatile unsigned long *)ptr = x;
-		raw_local_irq_restore(flags);
-		break;
-#else
-	case 1:
-		asm volatile("@	__xchg1\n"
-		"	swpb	%0, %1, [%2]"
-			: "=&r" (ret)
-			: "r" (x), "r" (ptr)
-			: "memory", "cc");
-		break;
-	case 4:
-		asm volatile("@	__xchg4\n"
-		"	swp	%0, %1, [%2]"
-			: "=&r" (ret)
-			: "r" (x), "r" (ptr)
-			: "memory", "cc");
-		break;
-#endif
-	default:
-		__bad_xchg(ptr, size), ret = 0;
-		break;
-	}
-	smp_mb();
-
-	return ret;
-}
-
-extern void disable_hlt(void);
-extern void enable_hlt(void);
-
-void cpu_idle_wait(void);
-
-#include <asm-generic/cmpxchg-local.h>
-
-#if __LINUX_ARM_ARCH__ < 6
-/* min ARCH < ARMv6 */
-
-#ifdef CONFIG_SMP
-#error "SMP is not supported on this platform"
-#endif
-
-/*
- * cmpxchg_local and cmpxchg64_local are atomic wrt current CPU. Always make
- * them available.
- */
-#define cmpxchg_local(ptr, o, n)				  	       \
-	((__typeof__(*(ptr)))__cmpxchg_local_generic((ptr), (unsigned long)(o),\
-			(unsigned long)(n), sizeof(*(ptr))))
-#define cmpxchg64_local(ptr, o, n) __cmpxchg64_local_generic((ptr), (o), (n))
-
-#ifndef CONFIG_SMP
-#include <asm-generic/cmpxchg.h>
-#endif
-
-#else	/* min ARCH >= ARMv6 */
-
-extern void __bad_cmpxchg(volatile void *ptr, int size);
-
-/*
- * cmpxchg only support 32-bits operands on ARMv6.
- */
-
-static inline unsigned long __cmpxchg(volatile void *ptr, unsigned long old,
-				      unsigned long new, int size)
-{
-	unsigned long oldval, res;
-
-	switch (size) {
-#ifndef CONFIG_CPU_V6	/* min ARCH >= ARMv6K */
-	case 1:
-		do {
-			asm volatile("@ __cmpxchg1\n"
-			"	ldrexb	%1, [%2]\n"
-			"	mov	%0, #0\n"
-			"	teq	%1, %3\n"
-			"	strexbeq %0, %4, [%2]\n"
-				: "=&r" (res), "=&r" (oldval)
-				: "r" (ptr), "Ir" (old), "r" (new)
-				: "memory", "cc");
-		} while (res);
-		break;
-	case 2:
-		do {
-			asm volatile("@ __cmpxchg1\n"
-			"	ldrexh	%1, [%2]\n"
-			"	mov	%0, #0\n"
-			"	teq	%1, %3\n"
-			"	strexheq %0, %4, [%2]\n"
-				: "=&r" (res), "=&r" (oldval)
-				: "r" (ptr), "Ir" (old), "r" (new)
-				: "memory", "cc");
-		} while (res);
-		break;
-#endif
-	case 4:
-		do {
-			asm volatile("@ __cmpxchg4\n"
-			"	ldrex	%1, [%2]\n"
-			"	mov	%0, #0\n"
-			"	teq	%1, %3\n"
-			"	strexeq %0, %4, [%2]\n"
-				: "=&r" (res), "=&r" (oldval)
-				: "r" (ptr), "Ir" (old), "r" (new)
-				: "memory", "cc");
-		} while (res);
-		break;
-	default:
-		__bad_cmpxchg(ptr, size);
-		oldval = 0;
-	}
-
-	return oldval;
-}
-
-static inline unsigned long __cmpxchg_mb(volatile void *ptr, unsigned long old,
-					 unsigned long new, int size)
-{
-	unsigned long ret;
-
-	smp_mb();
-	ret = __cmpxchg(ptr, old, new, size);
-	smp_mb();
-
-	return ret;
-}
-
-#define cmpxchg(ptr,o,n)						\
-	((__typeof__(*(ptr)))__cmpxchg_mb((ptr),			\
-					  (unsigned long)(o),		\
-					  (unsigned long)(n),		\
-					  sizeof(*(ptr))))
-
-static inline unsigned long __cmpxchg_local(volatile void *ptr,
-					    unsigned long old,
-					    unsigned long new, int size)
-{
-	unsigned long ret;
-
-	switch (size) {
-#ifdef CONFIG_CPU_V6	/* min ARCH == ARMv6 */
-	case 1:
-	case 2:
-		ret = __cmpxchg_local_generic(ptr, old, new, size);
-		break;
-#endif
-	default:
-		ret = __cmpxchg(ptr, old, new, size);
-	}
-
-	return ret;
-}
-
-#define cmpxchg_local(ptr,o,n)						\
-	((__typeof__(*(ptr)))__cmpxchg_local((ptr),			\
-				       (unsigned long)(o),		\
-				       (unsigned long)(n),		\
-				       sizeof(*(ptr))))
-
-#ifndef CONFIG_CPU_V6	/* min ARCH >= ARMv6K */
-
-/*
- * Note : ARMv7-M (currently unsupported by Linux) does not support
- * ldrexd/strexd. If ARMv7-M is ever supported by the Linux kernel, it should
- * not be allowed to use __cmpxchg64.
- */
-static inline unsigned long long __cmpxchg64(volatile void *ptr,
-					     unsigned long long old,
-					     unsigned long long new)
-{
-	register unsigned long long oldval asm("r0");
-	register unsigned long long __old asm("r2") = old;
-	register unsigned long long __new asm("r4") = new;
-	unsigned long res;
-
-	do {
-		asm volatile(
-		"	@ __cmpxchg8\n"
-		"	ldrexd	%1, %H1, [%2]\n"
-		"	mov	%0, #0\n"
-		"	teq	%1, %3\n"
-		"	teqeq	%H1, %H3\n"
-		"	strexdeq %0, %4, %H4, [%2]\n"
-			: "=&r" (res), "=&r" (oldval)
-			: "r" (ptr), "Ir" (__old), "r" (__new)
-			: "memory", "cc");
-	} while (res);
-
-	return oldval;
-}
-
-static inline unsigned long long __cmpxchg64_mb(volatile void *ptr,
-						unsigned long long old,
-						unsigned long long new)
-{
-	unsigned long long ret;
-
-	smp_mb();
-	ret = __cmpxchg64(ptr, old, new);
-	smp_mb();
-
-	return ret;
-}
-
-#define cmpxchg64(ptr,o,n)						\
-	((__typeof__(*(ptr)))__cmpxchg64_mb((ptr),			\
-					    (unsigned long long)(o),	\
-					    (unsigned long long)(n)))
-
-#define cmpxchg64_local(ptr,o,n)					\
-	((__typeof__(*(ptr)))__cmpxchg64((ptr),				\
-					 (unsigned long long)(o),	\
-					 (unsigned long long)(n)))
-
-#else /* min ARCH = ARMv6 */
-
-#define cmpxchg64_local(ptr, o, n) __cmpxchg64_local_generic((ptr), (o), (n))
-
-#endif
-
-#endif	/* __LINUX_ARM_ARCH__ >= 6 */
-
-#endif /* __ASSEMBLY__ */
-
-#define arch_align_stack(x) (x)
-
-#endif /* __KERNEL__ */
-
-#endif
diff --git a/arch/arm/include/asm/system_info.h b/arch/arm/include/asm/system_info.h
new file mode 100644
index 0000000..dfd386d
--- /dev/null
+++ b/arch/arm/include/asm/system_info.h
@@ -0,0 +1,27 @@
+#ifndef __ASM_ARM_SYSTEM_INFO_H
+#define __ASM_ARM_SYSTEM_INFO_H
+
+#define CPU_ARCH_UNKNOWN	0
+#define CPU_ARCH_ARMv3		1
+#define CPU_ARCH_ARMv4		2
+#define CPU_ARCH_ARMv4T		3
+#define CPU_ARCH_ARMv5		4
+#define CPU_ARCH_ARMv5T		5
+#define CPU_ARCH_ARMv5TE	6
+#define CPU_ARCH_ARMv5TEJ	7
+#define CPU_ARCH_ARMv6		8
+#define CPU_ARCH_ARMv7		9
+
+#ifndef __ASSEMBLY__
+
+/* information about the system we're running on */
+extern unsigned int system_rev;
+extern unsigned int system_serial_low;
+extern unsigned int system_serial_high;
+extern unsigned int mem_fclk_21285;
+
+extern int __pure cpu_architecture(void);
+
+#endif /* !__ASSEMBLY__ */
+
+#endif /* __ASM_ARM_SYSTEM_INFO_H */
diff --git a/arch/arm/include/asm/system_misc.h b/arch/arm/include/asm/system_misc.h
new file mode 100644
index 0000000..f5cf1e8
--- /dev/null
+++ b/arch/arm/include/asm/system_misc.h
@@ -0,0 +1,35 @@
+#ifndef __ASM_ARM_SYSTEM_MISC_H
+#define __ASM_ARM_SYSTEM_MISC_H
+
+#ifndef __ASSEMBLY__
+
+#include <linux/compiler.h>
+#include <linux/linkage.h>
+#include <linux/irqflags.h>
+
+#include <asm/outercache.h>
+
+extern int __pure cpu_architecture(void);
+extern void cpu_init(void);
+
+void soft_restart(unsigned long);
+extern void (*arm_pm_restart)(char str, const char *cmd);
+
+#define UDBG_UNDEFINED	(1 << 0)
+#define UDBG_SYSCALL	(1 << 1)
+#define UDBG_BADABORT	(1 << 2)
+#define UDBG_SEGV	(1 << 3)
+#define UDBG_BUS	(1 << 4)
+
+extern unsigned int user_debug;
+
+#define nop() __asm__ __volatile__("mov\tr0,r0\t@ nop\n\t");
+
+extern void disable_hlt(void);
+extern void enable_hlt(void);
+
+void cpu_idle_wait(void);
+
+#endif /* !__ASSEMBLY__ */
+
+#endif /* __ASM_ARM_SYSTEM_MISC_H */
diff --git a/arch/arm/include/asm/uaccess.h b/arch/arm/include/asm/uaccess.h
index 41820cf..71f6536 100644
--- a/arch/arm/include/asm/uaccess.h
+++ b/arch/arm/include/asm/uaccess.h
@@ -17,6 +17,7 @@
 #include <asm/memory.h>
 #include <asm/domain.h>
 #include <asm/unified.h>
+#include <asm/compiler.h>
 
 #define VERIFY_READ 0
 #define VERIFY_WRITE 1
diff --git a/arch/arm/kernel/elf.c b/arch/arm/kernel/elf.c
index ddba41d..d0d1e83 100644
--- a/arch/arm/kernel/elf.c
+++ b/arch/arm/kernel/elf.c
@@ -3,6 +3,7 @@
 #include <linux/personality.h>
 #include <linux/binfmts.h>
 #include <linux/elf.h>
+#include <asm/system_info.h>
 
 int elf_check_arch(const struct elf32_hdr *x)
 {
diff --git a/arch/arm/kernel/head.S b/arch/arm/kernel/head.S
index 4559f32..db344db 100644
--- a/arch/arm/kernel/head.S
+++ b/arch/arm/kernel/head.S
@@ -21,6 +21,7 @@
 #include <asm/memory.h>
 #include <asm/thread_info.h>
 #include <asm/pgtable.h>
+#include <asm/cr_reg.h>
 
 #ifdef CONFIG_DEBUG_LL
 #include <mach/debug-macro.S>
diff --git a/arch/arm/kernel/setup.c b/arch/arm/kernel/setup.c
index d481833..e20ed9b 100644
--- a/arch/arm/kernel/setup.c
+++ b/arch/arm/kernel/setup.c
@@ -52,6 +52,9 @@
 #include <asm/traps.h>
 #include <asm/unwind.h>
 #include <asm/memblock.h>
+#include <asm/system_info.h>
+#include <asm/system_misc.h>
+#include <asm/cr_reg.h>
 
 #if defined(CONFIG_DEPRECATED_PARAM_STRUCT)
 #include "compat.h"
diff --git a/arch/arm/kernel/traps.c b/arch/arm/kernel/traps.c
index 11da4dd..cd77743 100644
--- a/arch/arm/kernel/traps.c
+++ b/arch/arm/kernel/traps.c
@@ -33,6 +33,7 @@
 #include <asm/traps.h>
 #include <asm/unwind.h>
 #include <asm/tls.h>
+#include <asm/system_misc.h>
 
 #include "signal.h"
 
diff --git a/arch/arm/mm/alignment.c b/arch/arm/mm/alignment.c
index 193cadf..b524eb2 100644
--- a/arch/arm/mm/alignment.c
+++ b/arch/arm/mm/alignment.c
@@ -23,6 +23,8 @@
 #include <linux/uaccess.h>
 
 #include <asm/unaligned.h>
+#include <asm/cr_reg.h>
+#include <asm/system_info.h>
 
 #include "fault.h"
 
diff --git a/arch/arm/mm/fault.c b/arch/arm/mm/fault.c
index 699522c..2da5df7 100644
--- a/arch/arm/mm/fault.c
+++ b/arch/arm/mm/fault.c
@@ -23,6 +23,8 @@
 #include <asm/exception.h>
 #include <asm/pgtable.h>
 #include <asm/tlbflush.h>
+#include <asm/system_misc.h>
+#include <asm/system_info.h>
 
 #include "fault.h"
 
diff --git a/arch/arm/mm/idmap.c b/arch/arm/mm/idmap.c
index feacf4c..ab88ed4 100644
--- a/arch/arm/mm/idmap.c
+++ b/arch/arm/mm/idmap.c
@@ -5,6 +5,7 @@
 #include <asm/pgalloc.h>
 #include <asm/pgtable.h>
 #include <asm/sections.h>
+#include <asm/system_info.h>
 
 pgd_t *idmap_pgd;
 
diff --git a/arch/arm/mm/ioremap.c b/arch/arm/mm/ioremap.c
index 80632e8..436ebee 100644
--- a/arch/arm/mm/ioremap.c
+++ b/arch/arm/mm/ioremap.c
@@ -32,6 +32,8 @@
 #include <asm/pgalloc.h>
 #include <asm/tlbflush.h>
 #include <asm/sizes.h>
+#include <asm/system_info.h>
+#include <asm/cr_reg.h>
 
 #include <asm/mach/map.h>
 #include "mm.h"
diff --git a/arch/arm/mm/mmu.c b/arch/arm/mm/mmu.c
index 94c5a0c..bd48a73 100644
--- a/arch/arm/mm/mmu.c
+++ b/arch/arm/mm/mmu.c
@@ -26,6 +26,8 @@
 #include <asm/tlb.h>
 #include <asm/highmem.h>
 #include <asm/traps.h>
+#include <asm/cr_reg.h>
+#include <asm/system_info.h>
 
 #include <asm/mach/arch.h>
 #include <asm/mach/map.h>
diff --git a/arch/arm/mm/pgd.c b/arch/arm/mm/pgd.c
index a3e78cc..8121294 100644
--- a/arch/arm/mm/pgd.c
+++ b/arch/arm/mm/pgd.c
@@ -15,6 +15,7 @@
 #include <asm/pgalloc.h>
 #include <asm/page.h>
 #include <asm/tlbflush.h>
+#include <asm/cr_reg.h>
 
 #include "mm.h"
 
diff --git a/arch/arm/vfp/vfpmodule.c b/arch/arm/vfp/vfpmodule.c
index 8f3ccdd..f5cc605 100644
--- a/arch/arm/vfp/vfpmodule.c
+++ b/arch/arm/vfp/vfpmodule.c
@@ -21,6 +21,8 @@
 #include <asm/cputype.h>
 #include <asm/thread_notify.h>
 #include <asm/vfp.h>
+#include <asm/cr_reg.h>
+#include <asm/system_info.h>
 
 #include "vfpinstr.h"
 #include "vfp.h"

