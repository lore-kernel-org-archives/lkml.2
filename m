Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030421Ab2CGTuX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 14:50:23 -0500
Received: from mx1.redhat.com ([209.132.183.28]:25182 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030293Ab2CGTuQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 14:50:16 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 21/29] Disintegrate asm/system.h for PowerPC
To: paul.gortmaker@windriver.com, hpa@zytor.com
Cc: torvalds@linux-foundation.org, sfr@canb.auug.org.au, mingo@redhat.com,
        arnd@arndb.de, dhowells@redhat.com, tglx@linutronix.de,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Date: Wed, 07 Mar 2012 19:49:49 +0000
Message-ID: <20120307194948.15987.95344.stgit@warthog.procyon.org.uk>
In-Reply-To: <20120307194548.15987.36073.stgit@warthog.procyon.org.uk>
References: <20120307194548.15987.36073.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Disintegrate asm/system.h for PowerPC.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 arch/powerpc/include/asm/atomic.h            |  299 ++++++++++++++
 arch/powerpc/include/asm/auxvec.h            |    2 
 arch/powerpc/include/asm/barrier.h           |   68 +++
 arch/powerpc/include/asm/bug.h               |   11 +
 arch/powerpc/include/asm/cache.h             |   16 +
 arch/powerpc/include/asm/debug.h             |   56 +++
 arch/powerpc/include/asm/exec.h              |    9 
 arch/powerpc/include/asm/hw_breakpoint.h     |    1 
 arch/powerpc/include/asm/irq.h               |    1 
 arch/powerpc/include/asm/processor.h         |   30 +
 arch/powerpc/include/asm/reg_booke.h         |    5 
 arch/powerpc/include/asm/rtas.h              |    2 
 arch/powerpc/include/asm/setup.h             |   24 +
 arch/powerpc/include/asm/switch_to.h         |   65 +++
 arch/powerpc/include/asm/system.h            |  554 --------------------------
 arch/powerpc/kernel/align.c                  |    1 
 arch/powerpc/kernel/cputable.c               |    1 
 arch/powerpc/kernel/crash.c                  |    1 
 arch/powerpc/kernel/ppc_ksyms.c              |    1 
 arch/powerpc/kernel/process.c                |    2 
 arch/powerpc/kernel/ptrace.c                 |    1 
 arch/powerpc/kernel/ptrace32.c               |    1 
 arch/powerpc/kernel/signal.c                 |    1 
 arch/powerpc/kernel/signal_32.c              |    1 
 arch/powerpc/kernel/signal_64.c              |    1 
 arch/powerpc/kernel/smp.c                    |    1 
 arch/powerpc/kernel/swsusp.c                 |    1 
 arch/powerpc/kernel/sys_ppc32.c              |    1 
 arch/powerpc/kernel/traps.c                  |    2 
 arch/powerpc/kvm/book3s_hv.c                 |    1 
 arch/powerpc/lib/alloc.c                     |    1 
 arch/powerpc/lib/copyuser_power7_vmx.c       |    1 
 arch/powerpc/mm/fault.c                      |    1 
 arch/powerpc/mm/numa.c                       |    1 
 arch/powerpc/mm/pgtable_32.c                 |    1 
 arch/powerpc/platforms/pasemi/setup.c        |    1 
 arch/powerpc/platforms/powermac/bootx_init.c |    1 
 arch/powerpc/platforms/powermac/cpufreq_32.c |    1 
 arch/powerpc/platforms/ps3/mm.c              |    1 
 arch/powerpc/platforms/pseries/dtl.c         |    1 
 arch/powerpc/sysdev/msi_bitmap.c             |    1 
 arch/powerpc/xmon/xmon.c                     |    1 
 42 files changed, 617 insertions(+), 555 deletions(-)
 create mode 100644 arch/powerpc/include/asm/barrier.h
 create mode 100644 arch/powerpc/include/asm/debug.h
 create mode 100644 arch/powerpc/include/asm/exec.h
 create mode 100644 arch/powerpc/include/asm/switch_to.h
 delete mode 100644 arch/powerpc/include/asm/system.h

diff --git a/arch/powerpc/include/asm/atomic.h b/arch/powerpc/include/asm/atomic.h
index 357a3ef..81dbffa 100644
--- a/arch/powerpc/include/asm/atomic.h
+++ b/arch/powerpc/include/asm/atomic.h
@@ -470,5 +470,304 @@ static __inline__ int atomic64_add_unless(atomic64_t *v, long a, long u)
 
 #endif /* __powerpc64__ */
 
+/*
+ * Atomic exchange
+ *
+ * Changes the memory location '*ptr' to be val and returns
+ * the previous value stored there.
+ */
+static __always_inline unsigned long
+__xchg_u32(volatile void *p, unsigned long val)
+{
+	unsigned long prev;
+
+	__asm__ __volatile__(
+	PPC_RELEASE_BARRIER
+"1:	lwarx	%0,0,%2 \n"
+	PPC405_ERR77(0,%2)
+"	stwcx.	%3,0,%2 \n\
+	bne-	1b"
+	PPC_ACQUIRE_BARRIER
+	: "=&r" (prev), "+m" (*(volatile unsigned int *)p)
+	: "r" (p), "r" (val)
+	: "cc", "memory");
+
+	return prev;
+}
+
+/*
+ * Atomic exchange
+ *
+ * Changes the memory location '*ptr' to be val and returns
+ * the previous value stored there.
+ */
+static __always_inline unsigned long
+__xchg_u32_local(volatile void *p, unsigned long val)
+{
+	unsigned long prev;
+
+	__asm__ __volatile__(
+"1:	lwarx	%0,0,%2 \n"
+	PPC405_ERR77(0,%2)
+"	stwcx.	%3,0,%2 \n\
+	bne-	1b"
+	: "=&r" (prev), "+m" (*(volatile unsigned int *)p)
+	: "r" (p), "r" (val)
+	: "cc", "memory");
+
+	return prev;
+}
+
+#ifdef CONFIG_PPC64
+static __always_inline unsigned long
+__xchg_u64(volatile void *p, unsigned long val)
+{
+	unsigned long prev;
+
+	__asm__ __volatile__(
+	PPC_RELEASE_BARRIER
+"1:	ldarx	%0,0,%2 \n"
+	PPC405_ERR77(0,%2)
+"	stdcx.	%3,0,%2 \n\
+	bne-	1b"
+	PPC_ACQUIRE_BARRIER
+	: "=&r" (prev), "+m" (*(volatile unsigned long *)p)
+	: "r" (p), "r" (val)
+	: "cc", "memory");
+
+	return prev;
+}
+
+static __always_inline unsigned long
+__xchg_u64_local(volatile void *p, unsigned long val)
+{
+	unsigned long prev;
+
+	__asm__ __volatile__(
+"1:	ldarx	%0,0,%2 \n"
+	PPC405_ERR77(0,%2)
+"	stdcx.	%3,0,%2 \n\
+	bne-	1b"
+	: "=&r" (prev), "+m" (*(volatile unsigned long *)p)
+	: "r" (p), "r" (val)
+	: "cc", "memory");
+
+	return prev;
+}
+#endif
+
+/*
+ * This function doesn't exist, so you'll get a linker error
+ * if something tries to do an invalid xchg().
+ */
+extern void __xchg_called_with_bad_pointer(void);
+
+static __always_inline unsigned long
+__xchg(volatile void *ptr, unsigned long x, unsigned int size)
+{
+	switch (size) {
+	case 4:
+		return __xchg_u32(ptr, x);
+#ifdef CONFIG_PPC64
+	case 8:
+		return __xchg_u64(ptr, x);
+#endif
+	}
+	__xchg_called_with_bad_pointer();
+	return x;
+}
+
+static __always_inline unsigned long
+__xchg_local(volatile void *ptr, unsigned long x, unsigned int size)
+{
+	switch (size) {
+	case 4:
+		return __xchg_u32_local(ptr, x);
+#ifdef CONFIG_PPC64
+	case 8:
+		return __xchg_u64_local(ptr, x);
+#endif
+	}
+	__xchg_called_with_bad_pointer();
+	return x;
+}
+#define xchg(ptr,x)							     \
+  ({									     \
+     __typeof__(*(ptr)) _x_ = (x);					     \
+     (__typeof__(*(ptr))) __xchg((ptr), (unsigned long)_x_, sizeof(*(ptr))); \
+  })
+
+#define xchg_local(ptr,x)						     \
+  ({									     \
+     __typeof__(*(ptr)) _x_ = (x);					     \
+     (__typeof__(*(ptr))) __xchg_local((ptr),				     \
+     		(unsigned long)_x_, sizeof(*(ptr))); 			     \
+  })
+
+/*
+ * Compare and exchange - if *p == old, set it to new,
+ * and return the old value of *p.
+ */
+#define __HAVE_ARCH_CMPXCHG	1
+
+static __always_inline unsigned long
+__cmpxchg_u32(volatile unsigned int *p, unsigned long old, unsigned long new)
+{
+	unsigned int prev;
+
+	__asm__ __volatile__ (
+	PPC_RELEASE_BARRIER
+"1:	lwarx	%0,0,%2		# __cmpxchg_u32\n\
+	cmpw	0,%0,%3\n\
+	bne-	2f\n"
+	PPC405_ERR77(0,%2)
+"	stwcx.	%4,0,%2\n\
+	bne-	1b"
+	PPC_ACQUIRE_BARRIER
+	"\n\
+2:"
+	: "=&r" (prev), "+m" (*p)
+	: "r" (p), "r" (old), "r" (new)
+	: "cc", "memory");
+
+	return prev;
+}
+
+static __always_inline unsigned long
+__cmpxchg_u32_local(volatile unsigned int *p, unsigned long old,
+			unsigned long new)
+{
+	unsigned int prev;
+
+	__asm__ __volatile__ (
+"1:	lwarx	%0,0,%2		# __cmpxchg_u32\n\
+	cmpw	0,%0,%3\n\
+	bne-	2f\n"
+	PPC405_ERR77(0,%2)
+"	stwcx.	%4,0,%2\n\
+	bne-	1b"
+	"\n\
+2:"
+	: "=&r" (prev), "+m" (*p)
+	: "r" (p), "r" (old), "r" (new)
+	: "cc", "memory");
+
+	return prev;
+}
+
+#ifdef CONFIG_PPC64
+static __always_inline unsigned long
+__cmpxchg_u64(volatile unsigned long *p, unsigned long old, unsigned long new)
+{
+	unsigned long prev;
+
+	__asm__ __volatile__ (
+	PPC_RELEASE_BARRIER
+"1:	ldarx	%0,0,%2		# __cmpxchg_u64\n\
+	cmpd	0,%0,%3\n\
+	bne-	2f\n\
+	stdcx.	%4,0,%2\n\
+	bne-	1b"
+	PPC_ACQUIRE_BARRIER
+	"\n\
+2:"
+	: "=&r" (prev), "+m" (*p)
+	: "r" (p), "r" (old), "r" (new)
+	: "cc", "memory");
+
+	return prev;
+}
+
+static __always_inline unsigned long
+__cmpxchg_u64_local(volatile unsigned long *p, unsigned long old,
+			unsigned long new)
+{
+	unsigned long prev;
+
+	__asm__ __volatile__ (
+"1:	ldarx	%0,0,%2		# __cmpxchg_u64\n\
+	cmpd	0,%0,%3\n\
+	bne-	2f\n\
+	stdcx.	%4,0,%2\n\
+	bne-	1b"
+	"\n\
+2:"
+	: "=&r" (prev), "+m" (*p)
+	: "r" (p), "r" (old), "r" (new)
+	: "cc", "memory");
+
+	return prev;
+}
+#endif
+
+/* This function doesn't exist, so you'll get a linker error
+   if something tries to do an invalid cmpxchg().  */
+extern void __cmpxchg_called_with_bad_pointer(void);
+
+static __always_inline unsigned long
+__cmpxchg(volatile void *ptr, unsigned long old, unsigned long new,
+	  unsigned int size)
+{
+	switch (size) {
+	case 4:
+		return __cmpxchg_u32(ptr, old, new);
+#ifdef CONFIG_PPC64
+	case 8:
+		return __cmpxchg_u64(ptr, old, new);
+#endif
+	}
+	__cmpxchg_called_with_bad_pointer();
+	return old;
+}
+
+static __always_inline unsigned long
+__cmpxchg_local(volatile void *ptr, unsigned long old, unsigned long new,
+	  unsigned int size)
+{
+	switch (size) {
+	case 4:
+		return __cmpxchg_u32_local(ptr, old, new);
+#ifdef CONFIG_PPC64
+	case 8:
+		return __cmpxchg_u64_local(ptr, old, new);
+#endif
+	}
+	__cmpxchg_called_with_bad_pointer();
+	return old;
+}
+
+#define cmpxchg(ptr, o, n)						 \
+  ({									 \
+     __typeof__(*(ptr)) _o_ = (o);					 \
+     __typeof__(*(ptr)) _n_ = (n);					 \
+     (__typeof__(*(ptr))) __cmpxchg((ptr), (unsigned long)_o_,		 \
+				    (unsigned long)_n_, sizeof(*(ptr))); \
+  })
+
+
+#define cmpxchg_local(ptr, o, n)					 \
+  ({									 \
+     __typeof__(*(ptr)) _o_ = (o);					 \
+     __typeof__(*(ptr)) _n_ = (n);					 \
+     (__typeof__(*(ptr))) __cmpxchg_local((ptr), (unsigned long)_o_,	 \
+				    (unsigned long)_n_, sizeof(*(ptr))); \
+  })
+
+#ifdef CONFIG_PPC64
+#define cmpxchg64(ptr, o, n)						\
+  ({									\
+	BUILD_BUG_ON(sizeof(*(ptr)) != 8);				\
+	cmpxchg((ptr), (o), (n));					\
+  })
+#define cmpxchg64_local(ptr, o, n)					\
+  ({									\
+	BUILD_BUG_ON(sizeof(*(ptr)) != 8);				\
+	cmpxchg_local((ptr), (o), (n));					\
+  })
+#else
+#include <asm-generic/cmpxchg-local.h>
+#define cmpxchg64_local(ptr, o, n) __cmpxchg64_local_generic((ptr), (o), (n))
+#endif
+
 #endif /* __KERNEL__ */
 #endif /* _ASM_POWERPC_ATOMIC_H_ */
diff --git a/arch/powerpc/include/asm/auxvec.h b/arch/powerpc/include/asm/auxvec.h
index 19a099b..ce17d2c 100644
--- a/arch/powerpc/include/asm/auxvec.h
+++ b/arch/powerpc/include/asm/auxvec.h
@@ -16,4 +16,6 @@
  */
 #define AT_SYSINFO_EHDR		33
 
+#define AT_VECTOR_SIZE_ARCH 6 /* entries in ARCH_DLINFO */
+
 #endif
diff --git a/arch/powerpc/include/asm/barrier.h b/arch/powerpc/include/asm/barrier.h
new file mode 100644
index 0000000..ae78225
--- /dev/null
+++ b/arch/powerpc/include/asm/barrier.h
@@ -0,0 +1,68 @@
+/*
+ * Copyright (C) 1999 Cort Dougan <cort@cs.nmt.edu>
+ */
+#ifndef _ASM_POWERPC_BARRIER_H
+#define _ASM_POWERPC_BARRIER_H
+
+/*
+ * Memory barrier.
+ * The sync instruction guarantees that all memory accesses initiated
+ * by this processor have been performed (with respect to all other
+ * mechanisms that access memory).  The eieio instruction is a barrier
+ * providing an ordering (separately) for (a) cacheable stores and (b)
+ * loads and stores to non-cacheable memory (e.g. I/O devices).
+ *
+ * mb() prevents loads and stores being reordered across this point.
+ * rmb() prevents loads being reordered across this point.
+ * wmb() prevents stores being reordered across this point.
+ * read_barrier_depends() prevents data-dependent loads being reordered
+ *	across this point (nop on PPC).
+ *
+ * *mb() variants without smp_ prefix must order all types of memory
+ * operations with one another. sync is the only instruction sufficient
+ * to do this.
+ *
+ * For the smp_ barriers, ordering is for cacheable memory operations
+ * only. We have to use the sync instruction for smp_mb(), since lwsync
+ * doesn't order loads with respect to previous stores.  Lwsync can be
+ * used for smp_rmb() and smp_wmb().
+ *
+ * However, on CPUs that don't support lwsync, lwsync actually maps to a
+ * heavy-weight sync, so smp_wmb() can be a lighter-weight eieio.
+ */
+#define mb()   __asm__ __volatile__ ("sync" : : : "memory")
+#define rmb()  __asm__ __volatile__ ("sync" : : : "memory")
+#define wmb()  __asm__ __volatile__ ("sync" : : : "memory")
+#define read_barrier_depends()  do { } while(0)
+
+#define set_mb(var, value)	do { var = value; mb(); } while (0)
+
+#ifdef CONFIG_SMP
+
+#ifdef __SUBARCH_HAS_LWSYNC
+#    define SMPWMB      LWSYNC
+#else
+#    define SMPWMB      eieio
+#endif
+
+#define smp_mb()	mb()
+#define smp_rmb()	__asm__ __volatile__ (stringify_in_c(LWSYNC) : : :"memory")
+#define smp_wmb()	__asm__ __volatile__ (stringify_in_c(SMPWMB) : : :"memory")
+#define smp_read_barrier_depends()	read_barrier_depends()
+#else
+#define smp_mb()	barrier()
+#define smp_rmb()	barrier()
+#define smp_wmb()	barrier()
+#define smp_read_barrier_depends()	do { } while(0)
+#endif /* CONFIG_SMP */
+
+/*
+ * This is a barrier which prevents following instructions from being
+ * started until the value of the argument x is known.  For example, if
+ * x is a variable loaded from memory, this prevents following
+ * instructions from being executed until the load has been performed.
+ */
+#define data_barrier(x)	\
+	asm volatile("twi 0,%0,0; isync" : : "r" (x) : "memory");
+
+#endif /* _ASM_POWERPC_BARRIER_H */
diff --git a/arch/powerpc/include/asm/bug.h b/arch/powerpc/include/asm/bug.h
index 065c590..3eb53d7 100644
--- a/arch/powerpc/include/asm/bug.h
+++ b/arch/powerpc/include/asm/bug.h
@@ -126,5 +126,16 @@
 
 #include <asm-generic/bug.h>
 
+#ifndef __ASSEMBLY__
+
+struct pt_regs;
+extern int do_page_fault(struct pt_regs *, unsigned long, unsigned long);
+extern void bad_page_fault(struct pt_regs *, unsigned long, int);
+extern void _exception(int, struct pt_regs *, int, unsigned long);
+extern void die(const char *, struct pt_regs *, long);
+extern void print_backtrace(unsigned long *);
+
+#endif /* !__ASSEMBLY__ */
+
 #endif /* __KERNEL__ */
 #endif /* _ASM_POWERPC_BUG_H */
diff --git a/arch/powerpc/include/asm/cache.h b/arch/powerpc/include/asm/cache.h
index 4b50941..9e495c9 100644
--- a/arch/powerpc/include/asm/cache.h
+++ b/arch/powerpc/include/asm/cache.h
@@ -42,8 +42,24 @@ extern struct ppc64_caches ppc64_caches;
 #endif /* __powerpc64__ && ! __ASSEMBLY__ */
 
 #if !defined(__ASSEMBLY__)
+
 #define __read_mostly __attribute__((__section__(".data..read_mostly")))
+
+#ifdef CONFIG_6xx
+extern long _get_L2CR(void);
+extern long _get_L3CR(void);
+extern void _set_L2CR(unsigned long);
+extern void _set_L3CR(unsigned long);
+#else
+#define _get_L2CR()	0L
+#define _get_L3CR()	0L
+#define _set_L2CR(val)	do { } while(0)
+#define _set_L3CR(val)	do { } while(0)
 #endif
 
+extern void cacheable_memzero(void *p, unsigned int nb);
+extern void *cacheable_memcpy(void *, const void *, unsigned int);
+
+#endif /* !__ASSEMBLY__ */
 #endif /* __KERNEL__ */
 #endif /* _ASM_POWERPC_CACHE_H */
diff --git a/arch/powerpc/include/asm/debug.h b/arch/powerpc/include/asm/debug.h
new file mode 100644
index 0000000..716d2f0
--- /dev/null
+++ b/arch/powerpc/include/asm/debug.h
@@ -0,0 +1,56 @@
+/*
+ * Copyright (C) 1999 Cort Dougan <cort@cs.nmt.edu>
+ */
+#ifndef _ASM_POWERPC_DEBUG_H
+#define _ASM_POWERPC_DEBUG_H
+
+struct pt_regs;
+
+extern struct dentry *powerpc_debugfs_root;
+
+#if defined(CONFIG_DEBUGGER) || defined(CONFIG_KEXEC)
+
+extern int (*__debugger)(struct pt_regs *regs);
+extern int (*__debugger_ipi)(struct pt_regs *regs);
+extern int (*__debugger_bpt)(struct pt_regs *regs);
+extern int (*__debugger_sstep)(struct pt_regs *regs);
+extern int (*__debugger_iabr_match)(struct pt_regs *regs);
+extern int (*__debugger_dabr_match)(struct pt_regs *regs);
+extern int (*__debugger_fault_handler)(struct pt_regs *regs);
+
+#define DEBUGGER_BOILERPLATE(__NAME) \
+static inline int __NAME(struct pt_regs *regs) \
+{ \
+	if (unlikely(__ ## __NAME)) \
+		return __ ## __NAME(regs); \
+	return 0; \
+}
+
+DEBUGGER_BOILERPLATE(debugger)
+DEBUGGER_BOILERPLATE(debugger_ipi)
+DEBUGGER_BOILERPLATE(debugger_bpt)
+DEBUGGER_BOILERPLATE(debugger_sstep)
+DEBUGGER_BOILERPLATE(debugger_iabr_match)
+DEBUGGER_BOILERPLATE(debugger_dabr_match)
+DEBUGGER_BOILERPLATE(debugger_fault_handler)
+
+#else
+static inline int debugger(struct pt_regs *regs) { return 0; }
+static inline int debugger_ipi(struct pt_regs *regs) { return 0; }
+static inline int debugger_bpt(struct pt_regs *regs) { return 0; }
+static inline int debugger_sstep(struct pt_regs *regs) { return 0; }
+static inline int debugger_iabr_match(struct pt_regs *regs) { return 0; }
+static inline int debugger_dabr_match(struct pt_regs *regs) { return 0; }
+static inline int debugger_fault_handler(struct pt_regs *regs) { return 0; }
+#endif
+
+extern int set_dabr(unsigned long dabr);
+#ifdef CONFIG_PPC_ADV_DEBUG_REGS
+extern void do_send_trap(struct pt_regs *regs, unsigned long address,
+			 unsigned long error_code, int signal_code, int brkpt);
+#else
+extern void do_dabr(struct pt_regs *regs, unsigned long address,
+		    unsigned long error_code);
+#endif
+
+#endif /* _ASM_POWERPC_DEBUG_H */
diff --git a/arch/powerpc/include/asm/exec.h b/arch/powerpc/include/asm/exec.h
new file mode 100644
index 0000000..8196e9c
--- /dev/null
+++ b/arch/powerpc/include/asm/exec.h
@@ -0,0 +1,9 @@
+/*
+ * Copyright (C) 1999 Cort Dougan <cort@cs.nmt.edu>
+ */
+#ifndef _ASM_POWERPC_EXEC_H
+#define _ASM_POWERPC_EXEC_H
+
+extern unsigned long arch_align_stack(unsigned long sp);
+
+#endif /* _ASM_POWERPC_EXEC_H */
diff --git a/arch/powerpc/include/asm/hw_breakpoint.h b/arch/powerpc/include/asm/hw_breakpoint.h
index bc4f7ef..be04330 100644
--- a/arch/powerpc/include/asm/hw_breakpoint.h
+++ b/arch/powerpc/include/asm/hw_breakpoint.h
@@ -35,6 +35,7 @@ struct arch_hw_breakpoint {
 
 #include <linux/kdebug.h>
 #include <asm/reg.h>
+#include <asm/debug.h>
 
 struct perf_event;
 struct pmu;
diff --git a/arch/powerpc/include/asm/irq.h b/arch/powerpc/include/asm/irq.h
index c0e1bc3..034c5ca 100644
--- a/arch/powerpc/include/asm/irq.h
+++ b/arch/powerpc/include/asm/irq.h
@@ -68,6 +68,7 @@ typedef unsigned long irq_hw_number_t;
  */
 struct irq_host;
 struct radix_tree_root;
+struct device_node;
 
 /* Functions below are provided by the host and called whenever a new mapping
  * is created or an old mapping is disposed. The host can then proceed to
diff --git a/arch/powerpc/include/asm/processor.h b/arch/powerpc/include/asm/processor.h
index b585bff..8e2d037 100644
--- a/arch/powerpc/include/asm/processor.h
+++ b/arch/powerpc/include/asm/processor.h
@@ -385,6 +385,36 @@ static inline unsigned long get_clean_sp(struct pt_regs *regs, int is_32)
 extern unsigned long cpuidle_disable;
 enum idle_boot_override {IDLE_NO_OVERRIDE = 0, IDLE_POWERSAVE_OFF};
 
+extern int powersave_nap;	/* set if nap mode can be used in idle loop */
+void cpu_idle_wait(void);
+
+#ifdef CONFIG_PSERIES_IDLE
+extern void update_smt_snooze_delay(int snooze);
+extern int pseries_notify_cpuidle_add_cpu(int cpu);
+#else
+static inline void update_smt_snooze_delay(int snooze) {}
+static inline int pseries_notify_cpuidle_add_cpu(int cpu) { return 0; }
+#endif
+
+extern void flush_instruction_cache(void);
+extern void hard_reset_now(void);
+extern void poweroff_now(void);
+extern int fix_alignment(struct pt_regs *);
+extern void cvt_fd(float *from, double *to);
+extern void cvt_df(double *from, float *to);
+extern void _nmask_and_or_msr(unsigned long nmask, unsigned long or_val);
+
+#ifdef CONFIG_PPC64
+/*
+ * We handle most unaligned accesses in hardware. On the other hand 
+ * unaligned DMA can be very expensive on some ppc64 IO chips (it does
+ * powers of 2 writes until it reaches sufficient alignment).
+ *
+ * Based on this we disable the IP header alignment in network drivers.
+ */
+#define NET_IP_ALIGN	0
+#endif
+
 #endif /* __KERNEL__ */
 #endif /* __ASSEMBLY__ */
 #endif /* _ASM_POWERPC_PROCESSOR_H */
diff --git a/arch/powerpc/include/asm/reg_booke.h b/arch/powerpc/include/asm/reg_booke.h
index 500fe1d..0e94450 100644
--- a/arch/powerpc/include/asm/reg_booke.h
+++ b/arch/powerpc/include/asm/reg_booke.h
@@ -15,6 +15,11 @@
 #ifndef __ASM_POWERPC_REG_BOOKE_H__
 #define __ASM_POWERPC_REG_BOOKE_H__
 
+#ifdef CONFIG_BOOKE_WDT
+extern u32 booke_wdt_enabled;
+extern u32 booke_wdt_period;
+#endif /* CONFIG_BOOKE_WDT */
+
 /* Machine State Register (MSR) Fields */
 #define MSR_GS		(1<<28) /* Guest state */
 #define MSR_UCLE	(1<<26)	/* User-mode cache lock enable */
diff --git a/arch/powerpc/include/asm/rtas.h b/arch/powerpc/include/asm/rtas.h
index 01c143b..9d6c37a 100644
--- a/arch/powerpc/include/asm/rtas.h
+++ b/arch/powerpc/include/asm/rtas.h
@@ -325,5 +325,7 @@ static inline int page_is_rtas_user_buf(unsigned long pfn)
 static inline int page_is_rtas_user_buf(unsigned long pfn) { return 0;}
 #endif
 
+extern int call_rtas(const char *, int, int, unsigned long *, ...);
+
 #endif /* __KERNEL__ */
 #endif /* _POWERPC_RTAS_H */
diff --git a/arch/powerpc/include/asm/setup.h b/arch/powerpc/include/asm/setup.h
index 186e0fb..d084ce1 100644
--- a/arch/powerpc/include/asm/setup.h
+++ b/arch/powerpc/include/asm/setup.h
@@ -5,6 +5,28 @@
 
 #ifndef __ASSEMBLY__
 extern void ppc_printk_progress(char *s, unsigned short hex);
-#endif
+
+extern unsigned int rtas_data;
+extern int mem_init_done;	/* set on boot once kmalloc can be called */
+extern int init_bootmem_done;	/* set once bootmem is available */
+extern phys_addr_t memory_limit;
+extern unsigned long klimit;
+extern void *zalloc_maybe_bootmem(size_t size, gfp_t mask);
+
+extern void via_cuda_init(void);
+extern void read_rtc_time(void);
+extern void pmac_find_display(void);
+
+struct device_node;
+extern void note_scsi_host(struct device_node *, void *);
+
+/* Used in very early kernel initialization. */
+extern unsigned long reloc_offset(void);
+extern unsigned long add_reloc_offset(unsigned long);
+extern void reloc_got2(unsigned long);
+
+#define PTRRELOC(x)	((typeof(x)) add_reloc_offset((unsigned long)(x)))
+
+#endif /* !__ASSEMBLY__ */
 
 #endif	/* _ASM_POWERPC_SETUP_H */
diff --git a/arch/powerpc/include/asm/switch_to.h b/arch/powerpc/include/asm/switch_to.h
new file mode 100644
index 0000000..caf82d0
--- /dev/null
+++ b/arch/powerpc/include/asm/switch_to.h
@@ -0,0 +1,65 @@
+/*
+ * Copyright (C) 1999 Cort Dougan <cort@cs.nmt.edu>
+ */
+#ifndef _ASM_POWERPC_SWITCH_TO_H
+#define _ASM_POWERPC_SWITCH_TO_H
+
+struct thread_struct;
+struct task_struct;
+struct pt_regs;
+
+extern struct task_struct *__switch_to(struct task_struct *,
+	struct task_struct *);
+#define switch_to(prev, next, last)	((last) = __switch_to((prev), (next)))
+
+struct thread_struct;
+extern struct task_struct *_switch(struct thread_struct *prev,
+				   struct thread_struct *next);
+
+extern void giveup_fpu(struct task_struct *);
+extern void disable_kernel_fp(void);
+extern void enable_kernel_fp(void);
+extern void flush_fp_to_thread(struct task_struct *);
+extern void enable_kernel_altivec(void);
+extern void giveup_altivec(struct task_struct *);
+extern void load_up_altivec(struct task_struct *);
+extern int emulate_altivec(struct pt_regs *);
+extern void __giveup_vsx(struct task_struct *);
+extern void giveup_vsx(struct task_struct *);
+extern void enable_kernel_spe(void);
+extern void giveup_spe(struct task_struct *);
+extern void load_up_spe(struct task_struct *);
+
+#ifndef CONFIG_SMP
+extern void discard_lazy_cpu_state(void);
+#else
+static inline void discard_lazy_cpu_state(void)
+{
+}
+#endif
+
+#ifdef CONFIG_ALTIVEC
+extern void flush_altivec_to_thread(struct task_struct *);
+#else
+static inline void flush_altivec_to_thread(struct task_struct *t)
+{
+}
+#endif
+
+#ifdef CONFIG_VSX
+extern void flush_vsx_to_thread(struct task_struct *);
+#else
+static inline void flush_vsx_to_thread(struct task_struct *t)
+{
+}
+#endif
+
+#ifdef CONFIG_SPE
+extern void flush_spe_to_thread(struct task_struct *);
+#else
+static inline void flush_spe_to_thread(struct task_struct *t)
+{
+}
+#endif
+
+#endif /* _ASM_POWERPC_SWITCH_TO_H */
diff --git a/arch/powerpc/include/asm/system.h b/arch/powerpc/include/asm/system.h
deleted file mode 100644
index c377457..0000000
--- a/arch/powerpc/include/asm/system.h
+++ /dev/null
@@ -1,554 +0,0 @@
-/*
- * Copyright (C) 1999 Cort Dougan <cort@cs.nmt.edu>
- */
-#ifndef _ASM_POWERPC_SYSTEM_H
-#define _ASM_POWERPC_SYSTEM_H
-
-#include <linux/kernel.h>
-#include <linux/irqflags.h>
-
-#include <asm/hw_irq.h>
-
-/*
- * Memory barrier.
- * The sync instruction guarantees that all memory accesses initiated
- * by this processor have been performed (with respect to all other
- * mechanisms that access memory).  The eieio instruction is a barrier
- * providing an ordering (separately) for (a) cacheable stores and (b)
- * loads and stores to non-cacheable memory (e.g. I/O devices).
- *
- * mb() prevents loads and stores being reordered across this point.
- * rmb() prevents loads being reordered across this point.
- * wmb() prevents stores being reordered across this point.
- * read_barrier_depends() prevents data-dependent loads being reordered
- *	across this point (nop on PPC).
- *
- * *mb() variants without smp_ prefix must order all types of memory
- * operations with one another. sync is the only instruction sufficient
- * to do this.
- *
- * For the smp_ barriers, ordering is for cacheable memory operations
- * only. We have to use the sync instruction for smp_mb(), since lwsync
- * doesn't order loads with respect to previous stores.  Lwsync can be
- * used for smp_rmb() and smp_wmb().
- *
- * However, on CPUs that don't support lwsync, lwsync actually maps to a
- * heavy-weight sync, so smp_wmb() can be a lighter-weight eieio.
- */
-#define mb()   __asm__ __volatile__ ("sync" : : : "memory")
-#define rmb()  __asm__ __volatile__ ("sync" : : : "memory")
-#define wmb()  __asm__ __volatile__ ("sync" : : : "memory")
-#define read_barrier_depends()  do { } while(0)
-
-#define set_mb(var, value)	do { var = value; mb(); } while (0)
-
-#ifdef __KERNEL__
-#define AT_VECTOR_SIZE_ARCH 6 /* entries in ARCH_DLINFO */
-#ifdef CONFIG_SMP
-
-#ifdef __SUBARCH_HAS_LWSYNC
-#    define SMPWMB      LWSYNC
-#else
-#    define SMPWMB      eieio
-#endif
-
-#define smp_mb()	mb()
-#define smp_rmb()	__asm__ __volatile__ (stringify_in_c(LWSYNC) : : :"memory")
-#define smp_wmb()	__asm__ __volatile__ (stringify_in_c(SMPWMB) : : :"memory")
-#define smp_read_barrier_depends()	read_barrier_depends()
-#else
-#define smp_mb()	barrier()
-#define smp_rmb()	barrier()
-#define smp_wmb()	barrier()
-#define smp_read_barrier_depends()	do { } while(0)
-#endif /* CONFIG_SMP */
-
-/*
- * This is a barrier which prevents following instructions from being
- * started until the value of the argument x is known.  For example, if
- * x is a variable loaded from memory, this prevents following
- * instructions from being executed until the load has been performed.
- */
-#define data_barrier(x)	\
-	asm volatile("twi 0,%0,0; isync" : : "r" (x) : "memory");
-
-struct task_struct;
-struct pt_regs;
-
-#if defined(CONFIG_DEBUGGER) || defined(CONFIG_KEXEC)
-
-extern int (*__debugger)(struct pt_regs *regs);
-extern int (*__debugger_ipi)(struct pt_regs *regs);
-extern int (*__debugger_bpt)(struct pt_regs *regs);
-extern int (*__debugger_sstep)(struct pt_regs *regs);
-extern int (*__debugger_iabr_match)(struct pt_regs *regs);
-extern int (*__debugger_dabr_match)(struct pt_regs *regs);
-extern int (*__debugger_fault_handler)(struct pt_regs *regs);
-
-#define DEBUGGER_BOILERPLATE(__NAME) \
-static inline int __NAME(struct pt_regs *regs) \
-{ \
-	if (unlikely(__ ## __NAME)) \
-		return __ ## __NAME(regs); \
-	return 0; \
-}
-
-DEBUGGER_BOILERPLATE(debugger)
-DEBUGGER_BOILERPLATE(debugger_ipi)
-DEBUGGER_BOILERPLATE(debugger_bpt)
-DEBUGGER_BOILERPLATE(debugger_sstep)
-DEBUGGER_BOILERPLATE(debugger_iabr_match)
-DEBUGGER_BOILERPLATE(debugger_dabr_match)
-DEBUGGER_BOILERPLATE(debugger_fault_handler)
-
-#else
-static inline int debugger(struct pt_regs *regs) { return 0; }
-static inline int debugger_ipi(struct pt_regs *regs) { return 0; }
-static inline int debugger_bpt(struct pt_regs *regs) { return 0; }
-static inline int debugger_sstep(struct pt_regs *regs) { return 0; }
-static inline int debugger_iabr_match(struct pt_regs *regs) { return 0; }
-static inline int debugger_dabr_match(struct pt_regs *regs) { return 0; }
-static inline int debugger_fault_handler(struct pt_regs *regs) { return 0; }
-#endif
-
-extern int set_dabr(unsigned long dabr);
-#ifdef CONFIG_PPC_ADV_DEBUG_REGS
-extern void do_send_trap(struct pt_regs *regs, unsigned long address,
-			 unsigned long error_code, int signal_code, int brkpt);
-#else
-extern void do_dabr(struct pt_regs *regs, unsigned long address,
-		    unsigned long error_code);
-#endif
-extern void print_backtrace(unsigned long *);
-extern void flush_instruction_cache(void);
-extern void hard_reset_now(void);
-extern void poweroff_now(void);
-
-#ifdef CONFIG_6xx
-extern long _get_L2CR(void);
-extern long _get_L3CR(void);
-extern void _set_L2CR(unsigned long);
-extern void _set_L3CR(unsigned long);
-#else
-#define _get_L2CR()	0L
-#define _get_L3CR()	0L
-#define _set_L2CR(val)	do { } while(0)
-#define _set_L3CR(val)	do { } while(0)
-#endif
-
-extern void via_cuda_init(void);
-extern void read_rtc_time(void);
-extern void pmac_find_display(void);
-extern void giveup_fpu(struct task_struct *);
-extern void disable_kernel_fp(void);
-extern void enable_kernel_fp(void);
-extern void flush_fp_to_thread(struct task_struct *);
-extern void enable_kernel_altivec(void);
-extern void giveup_altivec(struct task_struct *);
-extern void load_up_altivec(struct task_struct *);
-extern int emulate_altivec(struct pt_regs *);
-extern void __giveup_vsx(struct task_struct *);
-extern void giveup_vsx(struct task_struct *);
-extern void enable_kernel_spe(void);
-extern void giveup_spe(struct task_struct *);
-extern void load_up_spe(struct task_struct *);
-extern int fix_alignment(struct pt_regs *);
-extern void cvt_fd(float *from, double *to);
-extern void cvt_df(double *from, float *to);
-
-#ifndef CONFIG_SMP
-extern void discard_lazy_cpu_state(void);
-#else
-static inline void discard_lazy_cpu_state(void)
-{
-}
-#endif
-
-#ifdef CONFIG_ALTIVEC
-extern void flush_altivec_to_thread(struct task_struct *);
-#else
-static inline void flush_altivec_to_thread(struct task_struct *t)
-{
-}
-#endif
-
-#ifdef CONFIG_VSX
-extern void flush_vsx_to_thread(struct task_struct *);
-#else
-static inline void flush_vsx_to_thread(struct task_struct *t)
-{
-}
-#endif
-
-#ifdef CONFIG_SPE
-extern void flush_spe_to_thread(struct task_struct *);
-#else
-static inline void flush_spe_to_thread(struct task_struct *t)
-{
-}
-#endif
-
-extern int call_rtas(const char *, int, int, unsigned long *, ...);
-extern void cacheable_memzero(void *p, unsigned int nb);
-extern void *cacheable_memcpy(void *, const void *, unsigned int);
-extern int do_page_fault(struct pt_regs *, unsigned long, unsigned long);
-extern void bad_page_fault(struct pt_regs *, unsigned long, int);
-extern void _exception(int, struct pt_regs *, int, unsigned long);
-extern void die(const char *, struct pt_regs *, long);
-extern void _nmask_and_or_msr(unsigned long nmask, unsigned long or_val);
-
-#ifdef CONFIG_BOOKE_WDT
-extern u32 booke_wdt_enabled;
-extern u32 booke_wdt_period;
-#endif /* CONFIG_BOOKE_WDT */
-
-struct device_node;
-extern void note_scsi_host(struct device_node *, void *);
-
-extern struct task_struct *__switch_to(struct task_struct *,
-	struct task_struct *);
-#define switch_to(prev, next, last)	((last) = __switch_to((prev), (next)))
-
-struct thread_struct;
-extern struct task_struct *_switch(struct thread_struct *prev,
-				   struct thread_struct *next);
-
-extern unsigned int rtas_data;
-extern int mem_init_done;	/* set on boot once kmalloc can be called */
-extern int init_bootmem_done;	/* set once bootmem is available */
-extern phys_addr_t memory_limit;
-extern unsigned long klimit;
-extern void *zalloc_maybe_bootmem(size_t size, gfp_t mask);
-
-extern int powersave_nap;	/* set if nap mode can be used in idle loop */
-void cpu_idle_wait(void);
-
-#ifdef CONFIG_PSERIES_IDLE
-extern void update_smt_snooze_delay(int snooze);
-extern int pseries_notify_cpuidle_add_cpu(int cpu);
-#else
-static inline void update_smt_snooze_delay(int snooze) {}
-static inline int pseries_notify_cpuidle_add_cpu(int cpu) { return 0; }
-#endif
-
-/*
- * Atomic exchange
- *
- * Changes the memory location '*ptr' to be val and returns
- * the previous value stored there.
- */
-static __always_inline unsigned long
-__xchg_u32(volatile void *p, unsigned long val)
-{
-	unsigned long prev;
-
-	__asm__ __volatile__(
-	PPC_RELEASE_BARRIER
-"1:	lwarx	%0,0,%2 \n"
-	PPC405_ERR77(0,%2)
-"	stwcx.	%3,0,%2 \n\
-	bne-	1b"
-	PPC_ACQUIRE_BARRIER
-	: "=&r" (prev), "+m" (*(volatile unsigned int *)p)
-	: "r" (p), "r" (val)
-	: "cc", "memory");
-
-	return prev;
-}
-
-/*
- * Atomic exchange
- *
- * Changes the memory location '*ptr' to be val and returns
- * the previous value stored there.
- */
-static __always_inline unsigned long
-__xchg_u32_local(volatile void *p, unsigned long val)
-{
-	unsigned long prev;
-
-	__asm__ __volatile__(
-"1:	lwarx	%0,0,%2 \n"
-	PPC405_ERR77(0,%2)
-"	stwcx.	%3,0,%2 \n\
-	bne-	1b"
-	: "=&r" (prev), "+m" (*(volatile unsigned int *)p)
-	: "r" (p), "r" (val)
-	: "cc", "memory");
-
-	return prev;
-}
-
-#ifdef CONFIG_PPC64
-static __always_inline unsigned long
-__xchg_u64(volatile void *p, unsigned long val)
-{
-	unsigned long prev;
-
-	__asm__ __volatile__(
-	PPC_RELEASE_BARRIER
-"1:	ldarx	%0,0,%2 \n"
-	PPC405_ERR77(0,%2)
-"	stdcx.	%3,0,%2 \n\
-	bne-	1b"
-	PPC_ACQUIRE_BARRIER
-	: "=&r" (prev), "+m" (*(volatile unsigned long *)p)
-	: "r" (p), "r" (val)
-	: "cc", "memory");
-
-	return prev;
-}
-
-static __always_inline unsigned long
-__xchg_u64_local(volatile void *p, unsigned long val)
-{
-	unsigned long prev;
-
-	__asm__ __volatile__(
-"1:	ldarx	%0,0,%2 \n"
-	PPC405_ERR77(0,%2)
-"	stdcx.	%3,0,%2 \n\
-	bne-	1b"
-	: "=&r" (prev), "+m" (*(volatile unsigned long *)p)
-	: "r" (p), "r" (val)
-	: "cc", "memory");
-
-	return prev;
-}
-#endif
-
-/*
- * This function doesn't exist, so you'll get a linker error
- * if something tries to do an invalid xchg().
- */
-extern void __xchg_called_with_bad_pointer(void);
-
-static __always_inline unsigned long
-__xchg(volatile void *ptr, unsigned long x, unsigned int size)
-{
-	switch (size) {
-	case 4:
-		return __xchg_u32(ptr, x);
-#ifdef CONFIG_PPC64
-	case 8:
-		return __xchg_u64(ptr, x);
-#endif
-	}
-	__xchg_called_with_bad_pointer();
-	return x;
-}
-
-static __always_inline unsigned long
-__xchg_local(volatile void *ptr, unsigned long x, unsigned int size)
-{
-	switch (size) {
-	case 4:
-		return __xchg_u32_local(ptr, x);
-#ifdef CONFIG_PPC64
-	case 8:
-		return __xchg_u64_local(ptr, x);
-#endif
-	}
-	__xchg_called_with_bad_pointer();
-	return x;
-}
-#define xchg(ptr,x)							     \
-  ({									     \
-     __typeof__(*(ptr)) _x_ = (x);					     \
-     (__typeof__(*(ptr))) __xchg((ptr), (unsigned long)_x_, sizeof(*(ptr))); \
-  })
-
-#define xchg_local(ptr,x)						     \
-  ({									     \
-     __typeof__(*(ptr)) _x_ = (x);					     \
-     (__typeof__(*(ptr))) __xchg_local((ptr),				     \
-     		(unsigned long)_x_, sizeof(*(ptr))); 			     \
-  })
-
-/*
- * Compare and exchange - if *p == old, set it to new,
- * and return the old value of *p.
- */
-#define __HAVE_ARCH_CMPXCHG	1
-
-static __always_inline unsigned long
-__cmpxchg_u32(volatile unsigned int *p, unsigned long old, unsigned long new)
-{
-	unsigned int prev;
-
-	__asm__ __volatile__ (
-	PPC_RELEASE_BARRIER
-"1:	lwarx	%0,0,%2		# __cmpxchg_u32\n\
-	cmpw	0,%0,%3\n\
-	bne-	2f\n"
-	PPC405_ERR77(0,%2)
-"	stwcx.	%4,0,%2\n\
-	bne-	1b"
-	PPC_ACQUIRE_BARRIER
-	"\n\
-2:"
-	: "=&r" (prev), "+m" (*p)
-	: "r" (p), "r" (old), "r" (new)
-	: "cc", "memory");
-
-	return prev;
-}
-
-static __always_inline unsigned long
-__cmpxchg_u32_local(volatile unsigned int *p, unsigned long old,
-			unsigned long new)
-{
-	unsigned int prev;
-
-	__asm__ __volatile__ (
-"1:	lwarx	%0,0,%2		# __cmpxchg_u32\n\
-	cmpw	0,%0,%3\n\
-	bne-	2f\n"
-	PPC405_ERR77(0,%2)
-"	stwcx.	%4,0,%2\n\
-	bne-	1b"
-	"\n\
-2:"
-	: "=&r" (prev), "+m" (*p)
-	: "r" (p), "r" (old), "r" (new)
-	: "cc", "memory");
-
-	return prev;
-}
-
-#ifdef CONFIG_PPC64
-static __always_inline unsigned long
-__cmpxchg_u64(volatile unsigned long *p, unsigned long old, unsigned long new)
-{
-	unsigned long prev;
-
-	__asm__ __volatile__ (
-	PPC_RELEASE_BARRIER
-"1:	ldarx	%0,0,%2		# __cmpxchg_u64\n\
-	cmpd	0,%0,%3\n\
-	bne-	2f\n\
-	stdcx.	%4,0,%2\n\
-	bne-	1b"
-	PPC_ACQUIRE_BARRIER
-	"\n\
-2:"
-	: "=&r" (prev), "+m" (*p)
-	: "r" (p), "r" (old), "r" (new)
-	: "cc", "memory");
-
-	return prev;
-}
-
-static __always_inline unsigned long
-__cmpxchg_u64_local(volatile unsigned long *p, unsigned long old,
-			unsigned long new)
-{
-	unsigned long prev;
-
-	__asm__ __volatile__ (
-"1:	ldarx	%0,0,%2		# __cmpxchg_u64\n\
-	cmpd	0,%0,%3\n\
-	bne-	2f\n\
-	stdcx.	%4,0,%2\n\
-	bne-	1b"
-	"\n\
-2:"
-	: "=&r" (prev), "+m" (*p)
-	: "r" (p), "r" (old), "r" (new)
-	: "cc", "memory");
-
-	return prev;
-}
-#endif
-
-/* This function doesn't exist, so you'll get a linker error
-   if something tries to do an invalid cmpxchg().  */
-extern void __cmpxchg_called_with_bad_pointer(void);
-
-static __always_inline unsigned long
-__cmpxchg(volatile void *ptr, unsigned long old, unsigned long new,
-	  unsigned int size)
-{
-	switch (size) {
-	case 4:
-		return __cmpxchg_u32(ptr, old, new);
-#ifdef CONFIG_PPC64
-	case 8:
-		return __cmpxchg_u64(ptr, old, new);
-#endif
-	}
-	__cmpxchg_called_with_bad_pointer();
-	return old;
-}
-
-static __always_inline unsigned long
-__cmpxchg_local(volatile void *ptr, unsigned long old, unsigned long new,
-	  unsigned int size)
-{
-	switch (size) {
-	case 4:
-		return __cmpxchg_u32_local(ptr, old, new);
-#ifdef CONFIG_PPC64
-	case 8:
-		return __cmpxchg_u64_local(ptr, old, new);
-#endif
-	}
-	__cmpxchg_called_with_bad_pointer();
-	return old;
-}
-
-#define cmpxchg(ptr, o, n)						 \
-  ({									 \
-     __typeof__(*(ptr)) _o_ = (o);					 \
-     __typeof__(*(ptr)) _n_ = (n);					 \
-     (__typeof__(*(ptr))) __cmpxchg((ptr), (unsigned long)_o_,		 \
-				    (unsigned long)_n_, sizeof(*(ptr))); \
-  })
-
-
-#define cmpxchg_local(ptr, o, n)					 \
-  ({									 \
-     __typeof__(*(ptr)) _o_ = (o);					 \
-     __typeof__(*(ptr)) _n_ = (n);					 \
-     (__typeof__(*(ptr))) __cmpxchg_local((ptr), (unsigned long)_o_,	 \
-				    (unsigned long)_n_, sizeof(*(ptr))); \
-  })
-
-#ifdef CONFIG_PPC64
-/*
- * We handle most unaligned accesses in hardware. On the other hand 
- * unaligned DMA can be very expensive on some ppc64 IO chips (it does
- * powers of 2 writes until it reaches sufficient alignment).
- *
- * Based on this we disable the IP header alignment in network drivers.
- */
-#define NET_IP_ALIGN	0
-
-#define cmpxchg64(ptr, o, n)						\
-  ({									\
-	BUILD_BUG_ON(sizeof(*(ptr)) != 8);				\
-	cmpxchg((ptr), (o), (n));					\
-  })
-#define cmpxchg64_local(ptr, o, n)					\
-  ({									\
-	BUILD_BUG_ON(sizeof(*(ptr)) != 8);				\
-	cmpxchg_local((ptr), (o), (n));					\
-  })
-#else
-#include <asm-generic/cmpxchg-local.h>
-#define cmpxchg64_local(ptr, o, n) __cmpxchg64_local_generic((ptr), (o), (n))
-#endif
-
-extern unsigned long arch_align_stack(unsigned long sp);
-
-/* Used in very early kernel initialization. */
-extern unsigned long reloc_offset(void);
-extern unsigned long add_reloc_offset(unsigned long);
-extern void reloc_got2(unsigned long);
-
-#define PTRRELOC(x)	((typeof(x)) add_reloc_offset((unsigned long)(x)))
-
-extern struct dentry *powerpc_debugfs_root;
-
-#endif /* __KERNEL__ */
-#endif /* _ASM_POWERPC_SYSTEM_H */
diff --git a/arch/powerpc/kernel/align.c b/arch/powerpc/kernel/align.c
index 5aad9aa..ee5b690 100644
--- a/arch/powerpc/kernel/align.c
+++ b/arch/powerpc/kernel/align.c
@@ -24,6 +24,7 @@
 #include <asm/cache.h>
 #include <asm/cputable.h>
 #include <asm/emulated_ops.h>
+#include <asm/switch_to.h>
 
 struct aligninfo {
 	unsigned char len;
diff --git a/arch/powerpc/kernel/cputable.c b/arch/powerpc/kernel/cputable.c
index 81db9e2..ff381f4 100644
--- a/arch/powerpc/kernel/cputable.c
+++ b/arch/powerpc/kernel/cputable.c
@@ -20,6 +20,7 @@
 #include <asm/cputable.h>
 #include <asm/prom.h>		/* for PTRRELOC on ARCH=ppc */
 #include <asm/mmu.h>
+#include <asm/setup.h>
 
 struct cpu_spec* cur_cpu_spec = NULL;
 EXPORT_SYMBOL(cur_cpu_spec);
diff --git a/arch/powerpc/kernel/crash.c b/arch/powerpc/kernel/crash.c
index b6b6fba..fdcd8f5 100644
--- a/arch/powerpc/kernel/crash.c
+++ b/arch/powerpc/kernel/crash.c
@@ -28,6 +28,7 @@
 #include <asm/prom.h>
 #include <asm/smp.h>
 #include <asm/setjmp.h>
+#include <asm/debug.h>
 
 /*
  * The primary CPU waits a while for all secondary CPUs to enter. This is to
diff --git a/arch/powerpc/kernel/ppc_ksyms.c b/arch/powerpc/kernel/ppc_ksyms.c
index 298eb9d..786a270 100644
--- a/arch/powerpc/kernel/ppc_ksyms.c
+++ b/arch/powerpc/kernel/ppc_ksyms.c
@@ -42,6 +42,7 @@
 #include <asm/signal.h>
 #include <asm/dcr.h>
 #include <asm/ftrace.h>
+#include <asm/switch_to.h>
 
 #ifdef CONFIG_PPC32
 extern void transfer_to_handler(void);
diff --git a/arch/powerpc/kernel/process.c b/arch/powerpc/kernel/process.c
index d76021d..bb67db0 100644
--- a/arch/powerpc/kernel/process.c
+++ b/arch/powerpc/kernel/process.c
@@ -48,6 +48,8 @@
 #include <asm/machdep.h>
 #include <asm/time.h>
 #include <asm/syscalls.h>
+#include <asm/switch_to.h>
+#include <asm/debug.h>
 #ifdef CONFIG_PPC64
 #include <asm/firmware.h>
 #endif
diff --git a/arch/powerpc/kernel/ptrace.c b/arch/powerpc/kernel/ptrace.c
index 4b9f5a3..8d8e028 100644
--- a/arch/powerpc/kernel/ptrace.c
+++ b/arch/powerpc/kernel/ptrace.c
@@ -36,6 +36,7 @@
 #include <asm/uaccess.h>
 #include <asm/page.h>
 #include <asm/pgtable.h>
+#include <asm/switch_to.h>
 
 #define CREATE_TRACE_POINTS
 #include <trace/events/syscalls.h>
diff --git a/arch/powerpc/kernel/ptrace32.c b/arch/powerpc/kernel/ptrace32.c
index 24352e2..469349d 100644
--- a/arch/powerpc/kernel/ptrace32.c
+++ b/arch/powerpc/kernel/ptrace32.c
@@ -32,6 +32,7 @@
 #include <asm/uaccess.h>
 #include <asm/page.h>
 #include <asm/pgtable.h>
+#include <asm/switch_to.h>
 
 /*
  * does not yet catch signals sent when the child dies.
diff --git a/arch/powerpc/kernel/signal.c b/arch/powerpc/kernel/signal.c
index ac6e437..d9e9ca9 100644
--- a/arch/powerpc/kernel/signal.c
+++ b/arch/powerpc/kernel/signal.c
@@ -15,6 +15,7 @@
 #include <asm/hw_breakpoint.h>
 #include <asm/uaccess.h>
 #include <asm/unistd.h>
+#include <asm/debug.h>
 
 #include "signal.h"
 
diff --git a/arch/powerpc/kernel/signal_32.c b/arch/powerpc/kernel/signal_32.c
index 836a5a1..6d10f8c 100644
--- a/arch/powerpc/kernel/signal_32.c
+++ b/arch/powerpc/kernel/signal_32.c
@@ -43,6 +43,7 @@
 #include <asm/syscalls.h>
 #include <asm/sigcontext.h>
 #include <asm/vdso.h>
+#include <asm/switch_to.h>
 #ifdef CONFIG_PPC64
 #include "ppc32.h"
 #include <asm/unistd.h>
diff --git a/arch/powerpc/kernel/signal_64.c b/arch/powerpc/kernel/signal_64.c
index a50b5ec..2692efd 100644
--- a/arch/powerpc/kernel/signal_64.c
+++ b/arch/powerpc/kernel/signal_64.c
@@ -33,6 +33,7 @@
 #include <asm/cacheflush.h>
 #include <asm/syscalls.h>
 #include <asm/vdso.h>
+#include <asm/switch_to.h>
 
 #include "signal.h"
 
diff --git a/arch/powerpc/kernel/smp.c b/arch/powerpc/kernel/smp.c
index c7d33c5..d9f9441 100644
--- a/arch/powerpc/kernel/smp.c
+++ b/arch/powerpc/kernel/smp.c
@@ -48,6 +48,7 @@
 #ifdef CONFIG_PPC64
 #include <asm/paca.h>
 #endif
+#include <asm/debug.h>
 
 #ifdef DEBUG
 #include <asm/udbg.h>
diff --git a/arch/powerpc/kernel/swsusp.c b/arch/powerpc/kernel/swsusp.c
index 3d4c59a..eae33e1 100644
--- a/arch/powerpc/kernel/swsusp.c
+++ b/arch/powerpc/kernel/swsusp.c
@@ -12,6 +12,7 @@
 #include <linux/sched.h>
 #include <asm/current.h>
 #include <asm/mmu_context.h>
+#include <asm/switch_to.h>
 
 void save_processor_state(void)
 {
diff --git a/arch/powerpc/kernel/sys_ppc32.c b/arch/powerpc/kernel/sys_ppc32.c
index 4e5bf1e..81c5706 100644
--- a/arch/powerpc/kernel/sys_ppc32.c
+++ b/arch/powerpc/kernel/sys_ppc32.c
@@ -50,6 +50,7 @@
 #include <asm/mmu_context.h>
 #include <asm/ppc-pci.h>
 #include <asm/syscalls.h>
+#include <asm/switch_to.h>
 
 
 asmlinkage long ppc32_select(u32 n, compat_ulong_t __user *inp,
diff --git a/arch/powerpc/kernel/traps.c b/arch/powerpc/kernel/traps.c
index cffc683..db1ede7 100644
--- a/arch/powerpc/kernel/traps.c
+++ b/arch/powerpc/kernel/traps.c
@@ -56,6 +56,8 @@
 #include <asm/kexec.h>
 #include <asm/ppc-opcode.h>
 #include <asm/rio.h>
+#include <asm/switch_to.h>
+#include <asm/debug.h>
 
 #if defined(CONFIG_DEBUGGER) || defined(CONFIG_KEXEC)
 int (*__debugger)(struct pt_regs *regs) __read_mostly;
diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index 336983d..6efde9c 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -45,6 +45,7 @@
 #include <asm/cputhreads.h>
 #include <asm/page.h>
 #include <asm/hvcall.h>
+#include <asm/switch_to.h>
 #include <linux/gfp.h>
 #include <linux/sched.h>
 #include <linux/vmalloc.h>
diff --git a/arch/powerpc/lib/alloc.c b/arch/powerpc/lib/alloc.c
index d8d7806..da22c84 100644
--- a/arch/powerpc/lib/alloc.c
+++ b/arch/powerpc/lib/alloc.c
@@ -3,6 +3,7 @@
 #include <linux/slab.h>
 #include <linux/bootmem.h>
 #include <linux/string.h>
+#include <asm/setup.h>
 
 
 void * __init_refok zalloc_maybe_bootmem(size_t size, gfp_t mask)
diff --git a/arch/powerpc/lib/copyuser_power7_vmx.c b/arch/powerpc/lib/copyuser_power7_vmx.c
index 6e1efad..bf2654f 100644
--- a/arch/powerpc/lib/copyuser_power7_vmx.c
+++ b/arch/powerpc/lib/copyuser_power7_vmx.c
@@ -20,6 +20,7 @@
  */
 #include <linux/uaccess.h>
 #include <linux/hardirq.h>
+#include <asm/switch_to.h>
 
 int enter_vmx_copy(void)
 {
diff --git a/arch/powerpc/mm/fault.c b/arch/powerpc/mm/fault.c
index b402733..253e6f5 100644
--- a/arch/powerpc/mm/fault.c
+++ b/arch/powerpc/mm/fault.c
@@ -41,6 +41,7 @@
 #include <asm/uaccess.h>
 #include <asm/tlbflush.h>
 #include <asm/siginfo.h>
+#include <asm/debug.h>
 #include <mm/mmu_decl.h>
 
 #include "icswx.h"
diff --git a/arch/powerpc/mm/numa.c b/arch/powerpc/mm/numa.c
index 69bad1a..b6edbb3 100644
--- a/arch/powerpc/mm/numa.c
+++ b/arch/powerpc/mm/numa.c
@@ -28,6 +28,7 @@
 #include <asm/firmware.h>
 #include <asm/paca.h>
 #include <asm/hvcall.h>
+#include <asm/setup.h>
 
 static int numa_enabled = 1;
 
diff --git a/arch/powerpc/mm/pgtable_32.c b/arch/powerpc/mm/pgtable_32.c
index 51f8795..e9c513a 100644
--- a/arch/powerpc/mm/pgtable_32.c
+++ b/arch/powerpc/mm/pgtable_32.c
@@ -33,6 +33,7 @@
 #include <asm/pgalloc.h>
 #include <asm/fixmap.h>
 #include <asm/io.h>
+#include <asm/setup.h>
 
 #include "mmu_decl.h"
 
diff --git a/arch/powerpc/platforms/pasemi/setup.c b/arch/powerpc/platforms/pasemi/setup.c
index 35fa6d2..dd981728 100644
--- a/arch/powerpc/platforms/pasemi/setup.c
+++ b/arch/powerpc/platforms/pasemi/setup.c
@@ -38,6 +38,7 @@
 #include <asm/smp.h>
 #include <asm/time.h>
 #include <asm/mmu.h>
+#include <asm/debug.h>
 
 #include <pcmcia/ss.h>
 #include <pcmcia/cistpl.h>
diff --git a/arch/powerpc/platforms/powermac/bootx_init.c b/arch/powerpc/platforms/powermac/bootx_init.c
index 84d7fd9..3e91ef5 100644
--- a/arch/powerpc/platforms/powermac/bootx_init.c
+++ b/arch/powerpc/platforms/powermac/bootx_init.c
@@ -19,6 +19,7 @@
 #include <asm/bootx.h>
 #include <asm/btext.h>
 #include <asm/io.h>
+#include <asm/setup.h>
 
 #undef DEBUG
 #define SET_BOOT_BAT
diff --git a/arch/powerpc/platforms/powermac/cpufreq_32.c b/arch/powerpc/platforms/powermac/cpufreq_32.c
index 4d34687..6417119 100644
--- a/arch/powerpc/platforms/powermac/cpufreq_32.c
+++ b/arch/powerpc/platforms/powermac/cpufreq_32.c
@@ -35,6 +35,7 @@
 #include <asm/time.h>
 #include <asm/mpic.h>
 #include <asm/keylargo.h>
+#include <asm/switch_to.h>
 
 /* WARNING !!! This will cause calibrate_delay() to be called,
  * but this is an __init function ! So you MUST go edit
diff --git a/arch/powerpc/platforms/ps3/mm.c b/arch/powerpc/platforms/ps3/mm.c
index 8bd6ba5..de2aea4 100644
--- a/arch/powerpc/platforms/ps3/mm.c
+++ b/arch/powerpc/platforms/ps3/mm.c
@@ -29,6 +29,7 @@
 #include <asm/prom.h>
 #include <asm/udbg.h>
 #include <asm/lv1call.h>
+#include <asm/setup.h>
 
 #include "platform.h"
 
diff --git a/arch/powerpc/platforms/pseries/dtl.c b/arch/powerpc/platforms/pseries/dtl.c
index 0ef143d..a764854 100644
--- a/arch/powerpc/platforms/pseries/dtl.c
+++ b/arch/powerpc/platforms/pseries/dtl.c
@@ -28,6 +28,7 @@
 #include <asm/uaccess.h>
 #include <asm/firmware.h>
 #include <asm/lppaca.h>
+#include <asm/debug.h>
 
 #include "plpar_wrappers.h"
 
diff --git a/arch/powerpc/sysdev/msi_bitmap.c b/arch/powerpc/sysdev/msi_bitmap.c
index 5287e95..0968b66 100644
--- a/arch/powerpc/sysdev/msi_bitmap.c
+++ b/arch/powerpc/sysdev/msi_bitmap.c
@@ -12,6 +12,7 @@
 #include <linux/kernel.h>
 #include <linux/bitmap.h>
 #include <asm/msi_bitmap.h>
+#include <asm/setup.h>
 
 int msi_bitmap_alloc_hwirqs(struct msi_bitmap *bmp, int num)
 {
diff --git a/arch/powerpc/xmon/xmon.c b/arch/powerpc/xmon/xmon.c
index cb95eea..d240f0c 100644
--- a/arch/powerpc/xmon/xmon.c
+++ b/arch/powerpc/xmon/xmon.c
@@ -42,6 +42,7 @@
 #include <asm/firmware.h>
 #include <asm/setjmp.h>
 #include <asm/reg.h>
+#include <asm/debug.h>
 
 #ifdef CONFIG_PPC64
 #include <asm/hvcall.h>

