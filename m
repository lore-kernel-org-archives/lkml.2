Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030481Ab2CGTve (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 14:51:34 -0500
Received: from mx1.redhat.com ([209.132.183.28]:64576 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030312Ab2CGTv2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 14:51:28 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 28/29] Disintegrate asm/system.h for X86
To: paul.gortmaker@windriver.com, hpa@zytor.com
Cc: torvalds@linux-foundation.org, sfr@canb.auug.org.au, mingo@redhat.com,
        arnd@arndb.de, dhowells@redhat.com, tglx@linutronix.de,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Date: Wed, 07 Mar 2012 19:51:08 +0000
Message-ID: <20120307195108.15987.44723.stgit@warthog.procyon.org.uk>
In-Reply-To: <20120307194548.15987.36073.stgit@warthog.procyon.org.uk>
References: <20120307194548.15987.36073.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Disintegrate asm/system.h for X86.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 arch/x86/include/asm/auxvec.h        |    7 
 arch/x86/include/asm/barrier.h       |  113 +++++++
 arch/x86/include/asm/bug.h           |    4 
 arch/x86/include/asm/cacheflush.h    |    1 
 arch/x86/include/asm/exec.h          |    1 
 arch/x86/include/asm/i387.h          |    1 
 arch/x86/include/asm/processor.h     |   30 ++
 arch/x86/include/asm/segment.h       |   58 ++++
 arch/x86/include/asm/special_insns.h |  199 +++++++++++++
 arch/x86/include/asm/switch_to.h     |  129 ++++++++
 arch/x86/include/asm/system.h        |  523 ----------------------------------
 arch/x86/include/asm/tlbflush.h      |    1 
 arch/x86/kernel/acpi/cstate.c        |    1 
 arch/x86/kernel/paravirt.c           |    1 
 arch/x86/kernel/process_32.c         |    1 
 arch/x86/kernel/process_64.c         |    1 
 arch/x86/kernel/tce_64.c             |    1 
 17 files changed, 547 insertions(+), 525 deletions(-)
 create mode 100644 arch/x86/include/asm/barrier.h
 create mode 100644 arch/x86/include/asm/exec.h
 create mode 100644 arch/x86/include/asm/special_insns.h
 create mode 100644 arch/x86/include/asm/switch_to.h
 delete mode 100644 arch/x86/include/asm/system.h

diff --git a/arch/x86/include/asm/auxvec.h b/arch/x86/include/asm/auxvec.h
index 1316b4c..77203ac 100644
--- a/arch/x86/include/asm/auxvec.h
+++ b/arch/x86/include/asm/auxvec.h
@@ -9,4 +9,11 @@
 #endif
 #define AT_SYSINFO_EHDR		33
 
+/* entries in ARCH_DLINFO: */
+#if defined(CONFIG_IA32_EMULATION) || !defined(CONFIG_X86_64)
+# define AT_VECTOR_SIZE_ARCH 2
+#else /* else it's non-compat x86-64 */
+# define AT_VECTOR_SIZE_ARCH 1
+#endif
+
 #endif /* _ASM_X86_AUXVEC_H */
diff --git a/arch/x86/include/asm/barrier.h b/arch/x86/include/asm/barrier.h
new file mode 100644
index 0000000..dbce41c
--- /dev/null
+++ b/arch/x86/include/asm/barrier.h
@@ -0,0 +1,113 @@
+#ifndef _ASM_X86_BARRIER_H
+#define _ASM_X86_BARRIER_H
+
+/*
+ * Force strict CPU ordering.
+ * And yes, this is required on UP too when we're talking
+ * to devices.
+ */
+
+#ifdef CONFIG_X86_32
+/*
+ * Some non-Intel clones support out of order store. wmb() ceases to be a
+ * nop for these.
+ */
+#define mb() alternative("lock; addl $0,0(%%esp)", "mfence", X86_FEATURE_XMM2)
+#define rmb() alternative("lock; addl $0,0(%%esp)", "lfence", X86_FEATURE_XMM2)
+#define wmb() alternative("lock; addl $0,0(%%esp)", "sfence", X86_FEATURE_XMM)
+#else
+#define mb() 	asm volatile("mfence":::"memory")
+#define rmb()	asm volatile("lfence":::"memory")
+#define wmb()	asm volatile("sfence" ::: "memory")
+#endif
+
+/**
+ * read_barrier_depends - Flush all pending reads that subsequents reads
+ * depend on.
+ *
+ * No data-dependent reads from memory-like regions are ever reordered
+ * over this barrier.  All reads preceding this primitive are guaranteed
+ * to access memory (but not necessarily other CPUs' caches) before any
+ * reads following this primitive that depend on the data return by
+ * any of the preceding reads.  This primitive is much lighter weight than
+ * rmb() on most CPUs, and is never heavier weight than is
+ * rmb().
+ *
+ * These ordering constraints are respected by both the local CPU
+ * and the compiler.
+ *
+ * Ordering is not guaranteed by anything other than these primitives,
+ * not even by data dependencies.  See the documentation for
+ * memory_barrier() for examples and URLs to more information.
+ *
+ * For example, the following code would force ordering (the initial
+ * value of "a" is zero, "b" is one, and "p" is "&a"):
+ *
+ * <programlisting>
+ *	CPU 0				CPU 1
+ *
+ *	b = 2;
+ *	memory_barrier();
+ *	p = &b;				q = p;
+ *					read_barrier_depends();
+ *					d = *q;
+ * </programlisting>
+ *
+ * because the read of "*q" depends on the read of "p" and these
+ * two reads are separated by a read_barrier_depends().  However,
+ * the following code, with the same initial values for "a" and "b":
+ *
+ * <programlisting>
+ *	CPU 0				CPU 1
+ *
+ *	a = 2;
+ *	memory_barrier();
+ *	b = 3;				y = b;
+ *					read_barrier_depends();
+ *					x = a;
+ * </programlisting>
+ *
+ * does not enforce ordering, since there is no data dependency between
+ * the read of "a" and the read of "b".  Therefore, on some CPUs, such
+ * as Alpha, "y" could be set to 3 and "x" to 0.  Use rmb()
+ * in cases like this where there are no data dependencies.
+ **/
+
+#define read_barrier_depends()	do { } while (0)
+
+#ifdef CONFIG_SMP
+#define smp_mb()	mb()
+#ifdef CONFIG_X86_PPRO_FENCE
+# define smp_rmb()	rmb()
+#else
+# define smp_rmb()	barrier()
+#endif
+#ifdef CONFIG_X86_OOSTORE
+# define smp_wmb() 	wmb()
+#else
+# define smp_wmb()	barrier()
+#endif
+#define smp_read_barrier_depends()	read_barrier_depends()
+#define set_mb(var, value) do { (void)xchg(&var, value); } while (0)
+#else
+#define smp_mb()	barrier()
+#define smp_rmb()	barrier()
+#define smp_wmb()	barrier()
+#define smp_read_barrier_depends()	do { } while (0)
+#define set_mb(var, value) do { var = value; barrier(); } while (0)
+#endif
+
+/*
+ * Stop RDTSC speculation. This is needed when you need to use RDTSC
+ * (or get_cycles or vread that possibly accesses the TSC) in a defined
+ * code region.
+ *
+ * (Could use an alternative three way for this if there was one.)
+ */
+static __always_inline void rdtsc_barrier(void)
+{
+	alternative(ASM_NOP3, "mfence", X86_FEATURE_MFENCE_RDTSC);
+	alternative(ASM_NOP3, "lfence", X86_FEATURE_LFENCE_RDTSC);
+}
+
+#endif /* _ASM_X86_BARRIER_H */
diff --git a/arch/x86/include/asm/bug.h b/arch/x86/include/asm/bug.h
index f654d1b..11e1152 100644
--- a/arch/x86/include/asm/bug.h
+++ b/arch/x86/include/asm/bug.h
@@ -36,4 +36,8 @@ do {								\
 #endif /* !CONFIG_BUG */
 
 #include <asm-generic/bug.h>
+
+
+extern void show_regs_common(void);
+
 #endif /* _ASM_X86_BUG_H */
diff --git a/arch/x86/include/asm/cacheflush.h b/arch/x86/include/asm/cacheflush.h
index 4e12668..9863ee3 100644
--- a/arch/x86/include/asm/cacheflush.h
+++ b/arch/x86/include/asm/cacheflush.h
@@ -3,6 +3,7 @@
 
 /* Caches aren't brain-dead on the intel. */
 #include <asm-generic/cacheflush.h>
+#include <asm/special_insns.h>
 
 #ifdef CONFIG_X86_PAT
 /*
diff --git a/arch/x86/include/asm/exec.h b/arch/x86/include/asm/exec.h
new file mode 100644
index 0000000..54c2e1d
--- /dev/null
+++ b/arch/x86/include/asm/exec.h
@@ -0,0 +1 @@
+/* define arch_align_stack() here */
diff --git a/arch/x86/include/asm/i387.h b/arch/x86/include/asm/i387.h
index 2479049..82374df 100644
--- a/arch/x86/include/asm/i387.h
+++ b/arch/x86/include/asm/i387.h
@@ -24,6 +24,7 @@
 #include <asm/user.h>
 #include <asm/uaccess.h>
 #include <asm/xsave.h>
+#include <asm/special_insns.h>
 
 extern unsigned int sig_xstate_size;
 extern void fpu_init(void);
diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index d395527..8322a35 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -20,6 +20,7 @@ struct mm_struct;
 #include <asm/msr.h>
 #include <asm/desc_defs.h>
 #include <asm/nops.h>
+#include <asm/special_insns.h>
 
 #include <linux/personality.h>
 #include <linux/cpumask.h>
@@ -28,6 +29,15 @@ struct mm_struct;
 #include <linux/math64.h>
 #include <linux/init.h>
 #include <linux/err.h>
+#include <linux/irqflags.h>
+
+/*
+ * We handle most unaligned accesses in hardware.  On the other hand
+ * unaligned DMA can be quite expensive on some Nehalem processors.
+ *
+ * Based on this we disable the IP header alignment in network drivers.
+ */
+#define NET_IP_ALIGN	0
 
 #define HBP_NUM 4
 /*
@@ -1020,4 +1030,24 @@ extern bool cpu_has_amd_erratum(const int *);
 #define cpu_has_amd_erratum(x)	(false)
 #endif /* CONFIG_CPU_SUP_AMD */
 
+#ifdef CONFIG_X86_32
+/*
+ * disable hlt during certain critical i/o operations
+ */
+#define HAVE_DISABLE_HLT
+#endif
+
+void disable_hlt(void);
+void enable_hlt(void);
+
+void cpu_idle_wait(void);
+
+extern unsigned long arch_align_stack(unsigned long sp);
+extern void free_init_pages(char *what, unsigned long begin, unsigned long end);
+
+void default_idle(void);
+bool set_pm_idle_to_default(void);
+
+void stop_this_cpu(void *dummy);
+
 #endif /* _ASM_X86_PROCESSOR_H */
diff --git a/arch/x86/include/asm/segment.h b/arch/x86/include/asm/segment.h
index 5e64171..1654662 100644
--- a/arch/x86/include/asm/segment.h
+++ b/arch/x86/include/asm/segment.h
@@ -212,7 +212,61 @@
 #ifdef __KERNEL__
 #ifndef __ASSEMBLY__
 extern const char early_idt_handlers[NUM_EXCEPTION_VECTORS][10];
-#endif
-#endif
+
+/*
+ * Load a segment. Fall back on loading the zero
+ * segment if something goes wrong..
+ */
+#define loadsegment(seg, value)						\
+do {									\
+	unsigned short __val = (value);					\
+									\
+	asm volatile("						\n"	\
+		     "1:	movl %k0,%%" #seg "		\n"	\
+									\
+		     ".section .fixup,\"ax\"			\n"	\
+		     "2:	xorl %k0,%k0			\n"	\
+		     "		jmp 1b				\n"	\
+		     ".previous					\n"	\
+									\
+		     _ASM_EXTABLE(1b, 2b)				\
+									\
+		     : "+r" (__val) : : "memory");			\
+} while (0)
+
+/*
+ * Save a segment register away
+ */
+#define savesegment(seg, value)				\
+	asm("mov %%" #seg ",%0":"=r" (value) : : "memory")
+
+/*
+ * x86_32 user gs accessors.
+ */
+#ifdef CONFIG_X86_32
+#ifdef CONFIG_X86_32_LAZY_GS
+#define get_user_gs(regs)	(u16)({unsigned long v; savesegment(gs, v); v;})
+#define set_user_gs(regs, v)	loadsegment(gs, (unsigned long)(v))
+#define task_user_gs(tsk)	((tsk)->thread.gs)
+#define lazy_save_gs(v)		savesegment(gs, (v))
+#define lazy_load_gs(v)		loadsegment(gs, (v))
+#else	/* X86_32_LAZY_GS */
+#define get_user_gs(regs)	(u16)((regs)->gs)
+#define set_user_gs(regs, v)	do { (regs)->gs = (v); } while (0)
+#define task_user_gs(tsk)	(task_pt_regs(tsk)->gs)
+#define lazy_save_gs(v)		do { } while (0)
+#define lazy_load_gs(v)		do { } while (0)
+#endif	/* X86_32_LAZY_GS */
+#endif	/* X86_32 */
+
+static inline unsigned long get_limit(unsigned long segment)
+{
+	unsigned long __limit;
+	asm("lsll %1,%0" : "=r" (__limit) : "r" (segment));
+	return __limit + 1;
+}
+
+#endif /* !__ASSEMBLY__ */
+#endif /* __KERNEL__ */
 
 #endif /* _ASM_X86_SEGMENT_H */
diff --git a/arch/x86/include/asm/special_insns.h b/arch/x86/include/asm/special_insns.h
new file mode 100644
index 0000000..41fc93a
--- /dev/null
+++ b/arch/x86/include/asm/special_insns.h
@@ -0,0 +1,199 @@
+#ifndef _ASM_X86_SPECIAL_INSNS_H
+#define _ASM_X86_SPECIAL_INSNS_H
+
+
+#ifdef __KERNEL__
+
+static inline void native_clts(void)
+{
+	asm volatile("clts");
+}
+
+/*
+ * Volatile isn't enough to prevent the compiler from reordering the
+ * read/write functions for the control registers and messing everything up.
+ * A memory clobber would solve the problem, but would prevent reordering of
+ * all loads stores around it, which can hurt performance. Solution is to
+ * use a variable and mimic reads and writes to it to enforce serialization
+ */
+static unsigned long __force_order;
+
+static inline unsigned long native_read_cr0(void)
+{
+	unsigned long val;
+	asm volatile("mov %%cr0,%0\n\t" : "=r" (val), "=m" (__force_order));
+	return val;
+}
+
+static inline void native_write_cr0(unsigned long val)
+{
+	asm volatile("mov %0,%%cr0": : "r" (val), "m" (__force_order));
+}
+
+static inline unsigned long native_read_cr2(void)
+{
+	unsigned long val;
+	asm volatile("mov %%cr2,%0\n\t" : "=r" (val), "=m" (__force_order));
+	return val;
+}
+
+static inline void native_write_cr2(unsigned long val)
+{
+	asm volatile("mov %0,%%cr2": : "r" (val), "m" (__force_order));
+}
+
+static inline unsigned long native_read_cr3(void)
+{
+	unsigned long val;
+	asm volatile("mov %%cr3,%0\n\t" : "=r" (val), "=m" (__force_order));
+	return val;
+}
+
+static inline void native_write_cr3(unsigned long val)
+{
+	asm volatile("mov %0,%%cr3": : "r" (val), "m" (__force_order));
+}
+
+static inline unsigned long native_read_cr4(void)
+{
+	unsigned long val;
+	asm volatile("mov %%cr4,%0\n\t" : "=r" (val), "=m" (__force_order));
+	return val;
+}
+
+static inline unsigned long native_read_cr4_safe(void)
+{
+	unsigned long val;
+	/* This could fault if %cr4 does not exist. In x86_64, a cr4 always
+	 * exists, so it will never fail. */
+#ifdef CONFIG_X86_32
+	asm volatile("1: mov %%cr4, %0\n"
+		     "2:\n"
+		     _ASM_EXTABLE(1b, 2b)
+		     : "=r" (val), "=m" (__force_order) : "0" (0));
+#else
+	val = native_read_cr4();
+#endif
+	return val;
+}
+
+static inline void native_write_cr4(unsigned long val)
+{
+	asm volatile("mov %0,%%cr4": : "r" (val), "m" (__force_order));
+}
+
+#ifdef CONFIG_X86_64
+static inline unsigned long native_read_cr8(void)
+{
+	unsigned long cr8;
+	asm volatile("movq %%cr8,%0" : "=r" (cr8));
+	return cr8;
+}
+
+static inline void native_write_cr8(unsigned long val)
+{
+	asm volatile("movq %0,%%cr8" :: "r" (val) : "memory");
+}
+#endif
+
+static inline void native_wbinvd(void)
+{
+	asm volatile("wbinvd": : :"memory");
+}
+
+extern void native_load_gs_index(unsigned);
+
+#ifdef CONFIG_PARAVIRT
+#include <asm/paravirt.h>
+#else
+
+static inline unsigned long read_cr0(void)
+{
+	return native_read_cr0();
+}
+
+static inline void write_cr0(unsigned long x)
+{
+	native_write_cr0(x);
+}
+
+static inline unsigned long read_cr2(void)
+{
+	return native_read_cr2();
+}
+
+static inline void write_cr2(unsigned long x)
+{
+	native_write_cr2(x);
+}
+
+static inline unsigned long read_cr3(void)
+{
+	return native_read_cr3();
+}
+
+static inline void write_cr3(unsigned long x)
+{
+	native_write_cr3(x);
+}
+
+static inline unsigned long read_cr4(void)
+{
+	return native_read_cr4();
+}
+
+static inline unsigned long read_cr4_safe(void)
+{
+	return native_read_cr4_safe();
+}
+
+static inline void write_cr4(unsigned long x)
+{
+	native_write_cr4(x);
+}
+
+static inline void wbinvd(void)
+{
+	native_wbinvd();
+}
+
+#ifdef CONFIG_X86_64
+
+static inline unsigned long read_cr8(void)
+{
+	return native_read_cr8();
+}
+
+static inline void write_cr8(unsigned long x)
+{
+	native_write_cr8(x);
+}
+
+static inline void load_gs_index(unsigned selector)
+{
+	native_load_gs_index(selector);
+}
+
+#endif
+
+/* Clear the 'TS' bit */
+static inline void clts(void)
+{
+	native_clts();
+}
+
+#endif/* CONFIG_PARAVIRT */
+
+#define stts() write_cr0(read_cr0() | X86_CR0_TS)
+
+static inline void clflush(volatile void *__p)
+{
+	asm volatile("clflush %0" : "+m" (*(volatile char __force *)__p));
+}
+
+#define nop() asm volatile ("nop")
+
+
+#endif /* __KERNEL__ */
+
+#endif /* _ASM_X86_SPECIAL_INSNS_H */
diff --git a/arch/x86/include/asm/switch_to.h b/arch/x86/include/asm/switch_to.h
new file mode 100644
index 0000000..4ec45b3
--- /dev/null
+++ b/arch/x86/include/asm/switch_to.h
@@ -0,0 +1,129 @@
+#ifndef _ASM_X86_SWITCH_TO_H
+#define _ASM_X86_SWITCH_TO_H
+
+struct task_struct; /* one of the stranger aspects of C forward declarations */
+struct task_struct *__switch_to(struct task_struct *prev,
+				struct task_struct *next);
+struct tss_struct;
+void __switch_to_xtra(struct task_struct *prev_p, struct task_struct *next_p,
+		      struct tss_struct *tss);
+
+#ifdef CONFIG_X86_32
+
+#ifdef CONFIG_CC_STACKPROTECTOR
+#define __switch_canary							\
+	"movl %P[task_canary](%[next]), %%ebx\n\t"			\
+	"movl %%ebx, "__percpu_arg([stack_canary])"\n\t"
+#define __switch_canary_oparam						\
+	, [stack_canary] "=m" (stack_canary.canary)
+#define __switch_canary_iparam						\
+	, [task_canary] "i" (offsetof(struct task_struct, stack_canary))
+#else	/* CC_STACKPROTECTOR */
+#define __switch_canary
+#define __switch_canary_oparam
+#define __switch_canary_iparam
+#endif	/* CC_STACKPROTECTOR */
+
+/*
+ * Saving eflags is important. It switches not only IOPL between tasks,
+ * it also protects other tasks from NT leaking through sysenter etc.
+ */
+#define switch_to(prev, next, last)					\
+do {									\
+	/*								\
+	 * Context-switching clobbers all registers, so we clobber	\
+	 * them explicitly, via unused output variables.		\
+	 * (EAX and EBP is not listed because EBP is saved/restored	\
+	 * explicitly for wchan access and EAX is the return value of	\
+	 * __switch_to())						\
+	 */								\
+	unsigned long ebx, ecx, edx, esi, edi;				\
+									\
+	asm volatile("pushfl\n\t"		/* save    flags */	\
+		     "pushl %%ebp\n\t"		/* save    EBP   */	\
+		     "movl %%esp,%[prev_sp]\n\t"	/* save    ESP   */ \
+		     "movl %[next_sp],%%esp\n\t"	/* restore ESP   */ \
+		     "movl $1f,%[prev_ip]\n\t"	/* save    EIP   */	\
+		     "pushl %[next_ip]\n\t"	/* restore EIP   */	\
+		     __switch_canary					\
+		     "jmp __switch_to\n"	/* regparm call  */	\
+		     "1:\t"						\
+		     "popl %%ebp\n\t"		/* restore EBP   */	\
+		     "popfl\n"			/* restore flags */	\
+									\
+		     /* output parameters */				\
+		     : [prev_sp] "=m" (prev->thread.sp),		\
+		       [prev_ip] "=m" (prev->thread.ip),		\
+		       "=a" (last),					\
+									\
+		       /* clobbered output registers: */		\
+		       "=b" (ebx), "=c" (ecx), "=d" (edx),		\
+		       "=S" (esi), "=D" (edi)				\
+		       							\
+		       __switch_canary_oparam				\
+									\
+		       /* input parameters: */				\
+		     : [next_sp]  "m" (next->thread.sp),		\
+		       [next_ip]  "m" (next->thread.ip),		\
+		       							\
+		       /* regparm parameters for __switch_to(): */	\
+		       [prev]     "a" (prev),				\
+		       [next]     "d" (next)				\
+									\
+		       __switch_canary_iparam				\
+									\
+		     : /* reloaded segment registers */			\
+			"memory");					\
+} while (0)
+
+#else /* CONFIG_X86_32 */
+
+/* frame pointer must be last for get_wchan */
+#define SAVE_CONTEXT    "pushf ; pushq %%rbp ; movq %%rsi,%%rbp\n\t"
+#define RESTORE_CONTEXT "movq %%rbp,%%rsi ; popq %%rbp ; popf\t"
+
+#define __EXTRA_CLOBBER  \
+	, "rcx", "rbx", "rdx", "r8", "r9", "r10", "r11", \
+	  "r12", "r13", "r14", "r15"
+
+#ifdef CONFIG_CC_STACKPROTECTOR
+#define __switch_canary							  \
+	"movq %P[task_canary](%%rsi),%%r8\n\t"				  \
+	"movq %%r8,"__percpu_arg([gs_canary])"\n\t"
+#define __switch_canary_oparam						  \
+	, [gs_canary] "=m" (irq_stack_union.stack_canary)
+#define __switch_canary_iparam						  \
+	, [task_canary] "i" (offsetof(struct task_struct, stack_canary))
+#else	/* CC_STACKPROTECTOR */
+#define __switch_canary
+#define __switch_canary_oparam
+#define __switch_canary_iparam
+#endif	/* CC_STACKPROTECTOR */
+
+/* Save restore flags to clear handle leaking NT */
+#define switch_to(prev, next, last) \
+	asm volatile(SAVE_CONTEXT					  \
+	     "movq %%rsp,%P[threadrsp](%[prev])\n\t" /* save RSP */	  \
+	     "movq %P[threadrsp](%[next]),%%rsp\n\t" /* restore RSP */	  \
+	     "call __switch_to\n\t"					  \
+	     "movq "__percpu_arg([current_task])",%%rsi\n\t"		  \
+	     __switch_canary						  \
+	     "movq %P[thread_info](%%rsi),%%r8\n\t"			  \
+	     "movq %%rax,%%rdi\n\t" 					  \
+	     "testl  %[_tif_fork],%P[ti_flags](%%r8)\n\t"		  \
+	     "jnz   ret_from_fork\n\t"					  \
+	     RESTORE_CONTEXT						  \
+	     : "=a" (last)					  	  \
+	       __switch_canary_oparam					  \
+	     : [next] "S" (next), [prev] "D" (prev),			  \
+	       [threadrsp] "i" (offsetof(struct task_struct, thread.sp)), \
+	       [ti_flags] "i" (offsetof(struct thread_info, flags)),	  \
+	       [_tif_fork] "i" (_TIF_FORK),			  	  \
+	       [thread_info] "i" (offsetof(struct task_struct, stack)),   \
+	       [current_task] "m" (current_task)			  \
+	       __switch_canary_iparam					  \
+	     : "memory", "cc" __EXTRA_CLOBBER)
+
+#endif /* CONFIG_X86_32 */
+
+#endif /* _ASM_X86_SWITCH_TO_H */
diff --git a/arch/x86/include/asm/system.h b/arch/x86/include/asm/system.h
deleted file mode 100644
index 2d2f01c..0000000
--- a/arch/x86/include/asm/system.h
+++ /dev/null
@@ -1,523 +0,0 @@
-#ifndef _ASM_X86_SYSTEM_H
-#define _ASM_X86_SYSTEM_H
-
-#include <asm/asm.h>
-#include <asm/segment.h>
-#include <asm/cpufeature.h>
-#include <asm/cmpxchg.h>
-#include <asm/nops.h>
-
-#include <linux/kernel.h>
-#include <linux/irqflags.h>
-
-/* entries in ARCH_DLINFO: */
-#if defined(CONFIG_IA32_EMULATION) || !defined(CONFIG_X86_64)
-# define AT_VECTOR_SIZE_ARCH 2
-#else /* else it's non-compat x86-64 */
-# define AT_VECTOR_SIZE_ARCH 1
-#endif
-
-struct task_struct; /* one of the stranger aspects of C forward declarations */
-struct task_struct *__switch_to(struct task_struct *prev,
-				struct task_struct *next);
-struct tss_struct;
-void __switch_to_xtra(struct task_struct *prev_p, struct task_struct *next_p,
-		      struct tss_struct *tss);
-extern void show_regs_common(void);
-
-#ifdef CONFIG_X86_32
-
-#ifdef CONFIG_CC_STACKPROTECTOR
-#define __switch_canary							\
-	"movl %P[task_canary](%[next]), %%ebx\n\t"			\
-	"movl %%ebx, "__percpu_arg([stack_canary])"\n\t"
-#define __switch_canary_oparam						\
-	, [stack_canary] "=m" (stack_canary.canary)
-#define __switch_canary_iparam						\
-	, [task_canary] "i" (offsetof(struct task_struct, stack_canary))
-#else	/* CC_STACKPROTECTOR */
-#define __switch_canary
-#define __switch_canary_oparam
-#define __switch_canary_iparam
-#endif	/* CC_STACKPROTECTOR */
-
-/*
- * Saving eflags is important. It switches not only IOPL between tasks,
- * it also protects other tasks from NT leaking through sysenter etc.
- */
-#define switch_to(prev, next, last)					\
-do {									\
-	/*								\
-	 * Context-switching clobbers all registers, so we clobber	\
-	 * them explicitly, via unused output variables.		\
-	 * (EAX and EBP is not listed because EBP is saved/restored	\
-	 * explicitly for wchan access and EAX is the return value of	\
-	 * __switch_to())						\
-	 */								\
-	unsigned long ebx, ecx, edx, esi, edi;				\
-									\
-	asm volatile("pushfl\n\t"		/* save    flags */	\
-		     "pushl %%ebp\n\t"		/* save    EBP   */	\
-		     "movl %%esp,%[prev_sp]\n\t"	/* save    ESP   */ \
-		     "movl %[next_sp],%%esp\n\t"	/* restore ESP   */ \
-		     "movl $1f,%[prev_ip]\n\t"	/* save    EIP   */	\
-		     "pushl %[next_ip]\n\t"	/* restore EIP   */	\
-		     __switch_canary					\
-		     "jmp __switch_to\n"	/* regparm call  */	\
-		     "1:\t"						\
-		     "popl %%ebp\n\t"		/* restore EBP   */	\
-		     "popfl\n"			/* restore flags */	\
-									\
-		     /* output parameters */				\
-		     : [prev_sp] "=m" (prev->thread.sp),		\
-		       [prev_ip] "=m" (prev->thread.ip),		\
-		       "=a" (last),					\
-									\
-		       /* clobbered output registers: */		\
-		       "=b" (ebx), "=c" (ecx), "=d" (edx),		\
-		       "=S" (esi), "=D" (edi)				\
-		       							\
-		       __switch_canary_oparam				\
-									\
-		       /* input parameters: */				\
-		     : [next_sp]  "m" (next->thread.sp),		\
-		       [next_ip]  "m" (next->thread.ip),		\
-		       							\
-		       /* regparm parameters for __switch_to(): */	\
-		       [prev]     "a" (prev),				\
-		       [next]     "d" (next)				\
-									\
-		       __switch_canary_iparam				\
-									\
-		     : /* reloaded segment registers */			\
-			"memory");					\
-} while (0)
-
-/*
- * disable hlt during certain critical i/o operations
- */
-#define HAVE_DISABLE_HLT
-#else
-
-/* frame pointer must be last for get_wchan */
-#define SAVE_CONTEXT    "pushf ; pushq %%rbp ; movq %%rsi,%%rbp\n\t"
-#define RESTORE_CONTEXT "movq %%rbp,%%rsi ; popq %%rbp ; popf\t"
-
-#define __EXTRA_CLOBBER  \
-	, "rcx", "rbx", "rdx", "r8", "r9", "r10", "r11", \
-	  "r12", "r13", "r14", "r15"
-
-#ifdef CONFIG_CC_STACKPROTECTOR
-#define __switch_canary							  \
-	"movq %P[task_canary](%%rsi),%%r8\n\t"				  \
-	"movq %%r8,"__percpu_arg([gs_canary])"\n\t"
-#define __switch_canary_oparam						  \
-	, [gs_canary] "=m" (irq_stack_union.stack_canary)
-#define __switch_canary_iparam						  \
-	, [task_canary] "i" (offsetof(struct task_struct, stack_canary))
-#else	/* CC_STACKPROTECTOR */
-#define __switch_canary
-#define __switch_canary_oparam
-#define __switch_canary_iparam
-#endif	/* CC_STACKPROTECTOR */
-
-/* Save restore flags to clear handle leaking NT */
-#define switch_to(prev, next, last) \
-	asm volatile(SAVE_CONTEXT					  \
-	     "movq %%rsp,%P[threadrsp](%[prev])\n\t" /* save RSP */	  \
-	     "movq %P[threadrsp](%[next]),%%rsp\n\t" /* restore RSP */	  \
-	     "call __switch_to\n\t"					  \
-	     "movq "__percpu_arg([current_task])",%%rsi\n\t"		  \
-	     __switch_canary						  \
-	     "movq %P[thread_info](%%rsi),%%r8\n\t"			  \
-	     "movq %%rax,%%rdi\n\t" 					  \
-	     "testl  %[_tif_fork],%P[ti_flags](%%r8)\n\t"		  \
-	     "jnz   ret_from_fork\n\t"					  \
-	     RESTORE_CONTEXT						  \
-	     : "=a" (last)					  	  \
-	       __switch_canary_oparam					  \
-	     : [next] "S" (next), [prev] "D" (prev),			  \
-	       [threadrsp] "i" (offsetof(struct task_struct, thread.sp)), \
-	       [ti_flags] "i" (offsetof(struct thread_info, flags)),	  \
-	       [_tif_fork] "i" (_TIF_FORK),			  	  \
-	       [thread_info] "i" (offsetof(struct task_struct, stack)),   \
-	       [current_task] "m" (current_task)			  \
-	       __switch_canary_iparam					  \
-	     : "memory", "cc" __EXTRA_CLOBBER)
-#endif
-
-#ifdef __KERNEL__
-
-extern void native_load_gs_index(unsigned);
-
-/*
- * Load a segment. Fall back on loading the zero
- * segment if something goes wrong..
- */
-#define loadsegment(seg, value)						\
-do {									\
-	unsigned short __val = (value);					\
-									\
-	asm volatile("						\n"	\
-		     "1:	movl %k0,%%" #seg "		\n"	\
-									\
-		     ".section .fixup,\"ax\"			\n"	\
-		     "2:	xorl %k0,%k0			\n"	\
-		     "		jmp 1b				\n"	\
-		     ".previous					\n"	\
-									\
-		     _ASM_EXTABLE(1b, 2b)				\
-									\
-		     : "+r" (__val) : : "memory");			\
-} while (0)
-
-/*
- * Save a segment register away
- */
-#define savesegment(seg, value)				\
-	asm("mov %%" #seg ",%0":"=r" (value) : : "memory")
-
-/*
- * x86_32 user gs accessors.
- */
-#ifdef CONFIG_X86_32
-#ifdef CONFIG_X86_32_LAZY_GS
-#define get_user_gs(regs)	(u16)({unsigned long v; savesegment(gs, v); v;})
-#define set_user_gs(regs, v)	loadsegment(gs, (unsigned long)(v))
-#define task_user_gs(tsk)	((tsk)->thread.gs)
-#define lazy_save_gs(v)		savesegment(gs, (v))
-#define lazy_load_gs(v)		loadsegment(gs, (v))
-#else	/* X86_32_LAZY_GS */
-#define get_user_gs(regs)	(u16)((regs)->gs)
-#define set_user_gs(regs, v)	do { (regs)->gs = (v); } while (0)
-#define task_user_gs(tsk)	(task_pt_regs(tsk)->gs)
-#define lazy_save_gs(v)		do { } while (0)
-#define lazy_load_gs(v)		do { } while (0)
-#endif	/* X86_32_LAZY_GS */
-#endif	/* X86_32 */
-
-static inline unsigned long get_limit(unsigned long segment)
-{
-	unsigned long __limit;
-	asm("lsll %1,%0" : "=r" (__limit) : "r" (segment));
-	return __limit + 1;
-}
-
-static inline void native_clts(void)
-{
-	asm volatile("clts");
-}
-
-/*
- * Volatile isn't enough to prevent the compiler from reordering the
- * read/write functions for the control registers and messing everything up.
- * A memory clobber would solve the problem, but would prevent reordering of
- * all loads stores around it, which can hurt performance. Solution is to
- * use a variable and mimic reads and writes to it to enforce serialization
- */
-static unsigned long __force_order;
-
-static inline unsigned long native_read_cr0(void)
-{
-	unsigned long val;
-	asm volatile("mov %%cr0,%0\n\t" : "=r" (val), "=m" (__force_order));
-	return val;
-}
-
-static inline void native_write_cr0(unsigned long val)
-{
-	asm volatile("mov %0,%%cr0": : "r" (val), "m" (__force_order));
-}
-
-static inline unsigned long native_read_cr2(void)
-{
-	unsigned long val;
-	asm volatile("mov %%cr2,%0\n\t" : "=r" (val), "=m" (__force_order));
-	return val;
-}
-
-static inline void native_write_cr2(unsigned long val)
-{
-	asm volatile("mov %0,%%cr2": : "r" (val), "m" (__force_order));
-}
-
-static inline unsigned long native_read_cr3(void)
-{
-	unsigned long val;
-	asm volatile("mov %%cr3,%0\n\t" : "=r" (val), "=m" (__force_order));
-	return val;
-}
-
-static inline void native_write_cr3(unsigned long val)
-{
-	asm volatile("mov %0,%%cr3": : "r" (val), "m" (__force_order));
-}
-
-static inline unsigned long native_read_cr4(void)
-{
-	unsigned long val;
-	asm volatile("mov %%cr4,%0\n\t" : "=r" (val), "=m" (__force_order));
-	return val;
-}
-
-static inline unsigned long native_read_cr4_safe(void)
-{
-	unsigned long val;
-	/* This could fault if %cr4 does not exist. In x86_64, a cr4 always
-	 * exists, so it will never fail. */
-#ifdef CONFIG_X86_32
-	asm volatile("1: mov %%cr4, %0\n"
-		     "2:\n"
-		     _ASM_EXTABLE(1b, 2b)
-		     : "=r" (val), "=m" (__force_order) : "0" (0));
-#else
-	val = native_read_cr4();
-#endif
-	return val;
-}
-
-static inline void native_write_cr4(unsigned long val)
-{
-	asm volatile("mov %0,%%cr4": : "r" (val), "m" (__force_order));
-}
-
-#ifdef CONFIG_X86_64
-static inline unsigned long native_read_cr8(void)
-{
-	unsigned long cr8;
-	asm volatile("movq %%cr8,%0" : "=r" (cr8));
-	return cr8;
-}
-
-static inline void native_write_cr8(unsigned long val)
-{
-	asm volatile("movq %0,%%cr8" :: "r" (val) : "memory");
-}
-#endif
-
-static inline void native_wbinvd(void)
-{
-	asm volatile("wbinvd": : :"memory");
-}
-
-#ifdef CONFIG_PARAVIRT
-#include <asm/paravirt.h>
-#else
-
-static inline unsigned long read_cr0(void)
-{
-	return native_read_cr0();
-}
-
-static inline void write_cr0(unsigned long x)
-{
-	native_write_cr0(x);
-}
-
-static inline unsigned long read_cr2(void)
-{
-	return native_read_cr2();
-}
-
-static inline void write_cr2(unsigned long x)
-{
-	native_write_cr2(x);
-}
-
-static inline unsigned long read_cr3(void)
-{
-	return native_read_cr3();
-}
-
-static inline void write_cr3(unsigned long x)
-{
-	native_write_cr3(x);
-}
-
-static inline unsigned long read_cr4(void)
-{
-	return native_read_cr4();
-}
-
-static inline unsigned long read_cr4_safe(void)
-{
-	return native_read_cr4_safe();
-}
-
-static inline void write_cr4(unsigned long x)
-{
-	native_write_cr4(x);
-}
-
-static inline void wbinvd(void)
-{
-	native_wbinvd();
-}
-
-#ifdef CONFIG_X86_64
-
-static inline unsigned long read_cr8(void)
-{
-	return native_read_cr8();
-}
-
-static inline void write_cr8(unsigned long x)
-{
-	native_write_cr8(x);
-}
-
-static inline void load_gs_index(unsigned selector)
-{
-	native_load_gs_index(selector);
-}
-
-#endif
-
-/* Clear the 'TS' bit */
-static inline void clts(void)
-{
-	native_clts();
-}
-
-#endif/* CONFIG_PARAVIRT */
-
-#define stts() write_cr0(read_cr0() | X86_CR0_TS)
-
-#endif /* __KERNEL__ */
-
-static inline void clflush(volatile void *__p)
-{
-	asm volatile("clflush %0" : "+m" (*(volatile char __force *)__p));
-}
-
-#define nop() asm volatile ("nop")
-
-void disable_hlt(void);
-void enable_hlt(void);
-
-void cpu_idle_wait(void);
-
-extern unsigned long arch_align_stack(unsigned long sp);
-extern void free_init_pages(char *what, unsigned long begin, unsigned long end);
-
-void default_idle(void);
-bool set_pm_idle_to_default(void);
-
-void stop_this_cpu(void *dummy);
-
-/*
- * Force strict CPU ordering.
- * And yes, this is required on UP too when we're talking
- * to devices.
- */
-#ifdef CONFIG_X86_32
-/*
- * Some non-Intel clones support out of order store. wmb() ceases to be a
- * nop for these.
- */
-#define mb() alternative("lock; addl $0,0(%%esp)", "mfence", X86_FEATURE_XMM2)
-#define rmb() alternative("lock; addl $0,0(%%esp)", "lfence", X86_FEATURE_XMM2)
-#define wmb() alternative("lock; addl $0,0(%%esp)", "sfence", X86_FEATURE_XMM)
-#else
-#define mb() 	asm volatile("mfence":::"memory")
-#define rmb()	asm volatile("lfence":::"memory")
-#define wmb()	asm volatile("sfence" ::: "memory")
-#endif
-
-/**
- * read_barrier_depends - Flush all pending reads that subsequents reads
- * depend on.
- *
- * No data-dependent reads from memory-like regions are ever reordered
- * over this barrier.  All reads preceding this primitive are guaranteed
- * to access memory (but not necessarily other CPUs' caches) before any
- * reads following this primitive that depend on the data return by
- * any of the preceding reads.  This primitive is much lighter weight than
- * rmb() on most CPUs, and is never heavier weight than is
- * rmb().
- *
- * These ordering constraints are respected by both the local CPU
- * and the compiler.
- *
- * Ordering is not guaranteed by anything other than these primitives,
- * not even by data dependencies.  See the documentation for
- * memory_barrier() for examples and URLs to more information.
- *
- * For example, the following code would force ordering (the initial
- * value of "a" is zero, "b" is one, and "p" is "&a"):
- *
- * <programlisting>
- *	CPU 0				CPU 1
- *
- *	b = 2;
- *	memory_barrier();
- *	p = &b;				q = p;
- *					read_barrier_depends();
- *					d = *q;
- * </programlisting>
- *
- * because the read of "*q" depends on the read of "p" and these
- * two reads are separated by a read_barrier_depends().  However,
- * the following code, with the same initial values for "a" and "b":
- *
- * <programlisting>
- *	CPU 0				CPU 1
- *
- *	a = 2;
- *	memory_barrier();
- *	b = 3;				y = b;
- *					read_barrier_depends();
- *					x = a;
- * </programlisting>
- *
- * does not enforce ordering, since there is no data dependency between
- * the read of "a" and the read of "b".  Therefore, on some CPUs, such
- * as Alpha, "y" could be set to 3 and "x" to 0.  Use rmb()
- * in cases like this where there are no data dependencies.
- **/
-
-#define read_barrier_depends()	do { } while (0)
-
-#ifdef CONFIG_SMP
-#define smp_mb()	mb()
-#ifdef CONFIG_X86_PPRO_FENCE
-# define smp_rmb()	rmb()
-#else
-# define smp_rmb()	barrier()
-#endif
-#ifdef CONFIG_X86_OOSTORE
-# define smp_wmb() 	wmb()
-#else
-# define smp_wmb()	barrier()
-#endif
-#define smp_read_barrier_depends()	read_barrier_depends()
-#define set_mb(var, value) do { (void)xchg(&var, value); } while (0)
-#else
-#define smp_mb()	barrier()
-#define smp_rmb()	barrier()
-#define smp_wmb()	barrier()
-#define smp_read_barrier_depends()	do { } while (0)
-#define set_mb(var, value) do { var = value; barrier(); } while (0)
-#endif
-
-/*
- * Stop RDTSC speculation. This is needed when you need to use RDTSC
- * (or get_cycles or vread that possibly accesses the TSC) in a defined
- * code region.
- *
- * (Could use an alternative three way for this if there was one.)
- */
-static __always_inline void rdtsc_barrier(void)
-{
-	alternative(ASM_NOP3, "mfence", X86_FEATURE_MFENCE_RDTSC);
-	alternative(ASM_NOP3, "lfence", X86_FEATURE_LFENCE_RDTSC);
-}
-
-/*
- * We handle most unaligned accesses in hardware.  On the other hand
- * unaligned DMA can be quite expensive on some Nehalem processors.
- *
- * Based on this we disable the IP header alignment in network drivers.
- */
-#define NET_IP_ALIGN	0
-#endif /* _ASM_X86_SYSTEM_H */
diff --git a/arch/x86/include/asm/tlbflush.h b/arch/x86/include/asm/tlbflush.h
index 02a4c04..c0e108e 100644
--- a/arch/x86/include/asm/tlbflush.h
+++ b/arch/x86/include/asm/tlbflush.h
@@ -5,6 +5,7 @@
 #include <linux/sched.h>
 
 #include <asm/processor.h>
+#include <asm/special_insns.h>
 
 #ifdef CONFIG_PARAVIRT
 #include <asm/paravirt.h>
diff --git a/arch/x86/kernel/acpi/cstate.c b/arch/x86/kernel/acpi/cstate.c
index f50e7fb..d2b7f27 100644
--- a/arch/x86/kernel/acpi/cstate.c
+++ b/arch/x86/kernel/acpi/cstate.c
@@ -14,6 +14,7 @@
 #include <acpi/processor.h>
 #include <asm/acpi.h>
 #include <asm/mwait.h>
+#include <asm/special_insns.h>
 
 /*
  * Initialize bm_flags based on the CPU cache properties
diff --git a/arch/x86/kernel/paravirt.c b/arch/x86/kernel/paravirt.c
index d90272e..4ae36d9 100644
--- a/arch/x86/kernel/paravirt.c
+++ b/arch/x86/kernel/paravirt.c
@@ -37,6 +37,7 @@
 #include <asm/apic.h>
 #include <asm/tlbflush.h>
 #include <asm/timer.h>
+#include <asm/special_insns.h>
 
 /* nop stub */
 void _paravirt_nop(void)
diff --git a/arch/x86/kernel/process_32.c b/arch/x86/kernel/process_32.c
index 82ad568..c8a5244 100644
--- a/arch/x86/kernel/process_32.c
+++ b/arch/x86/kernel/process_32.c
@@ -57,6 +57,7 @@
 #include <asm/syscalls.h>
 #include <asm/debugreg.h>
 #include <asm/nmi.h>
+#include <asm/switch_to.h>
 
 asmlinkage void ret_from_fork(void) __asm__("ret_from_fork");
 
diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index ea5d771..2466f98 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -51,6 +51,7 @@
 #include <asm/syscalls.h>
 #include <asm/debugreg.h>
 #include <asm/nmi.h>
+#include <asm/switch_to.h>
 
 asmlinkage extern void ret_from_fork(void);
 
diff --git a/arch/x86/kernel/tce_64.c b/arch/x86/kernel/tce_64.c
index 9e540fe..ab40954 100644
--- a/arch/x86/kernel/tce_64.c
+++ b/arch/x86/kernel/tce_64.c
@@ -34,6 +34,7 @@
 #include <asm/tce.h>
 #include <asm/calgary.h>
 #include <asm/proto.h>
+#include <asm/cacheflush.h>
 
 /* flush a tce at 'tceaddr' to main memory */
 static inline void flush_tce(void* tceaddr)

