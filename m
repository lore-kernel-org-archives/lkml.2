Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030569Ab2CGTvZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 14:51:25 -0500
Received: from mx1.redhat.com ([209.132.183.28]:39892 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030312Ab2CGTvQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 14:51:16 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 27/29] Disintegrate asm/system.h for Unicore32
To: paul.gortmaker@windriver.com, hpa@zytor.com
Cc: torvalds@linux-foundation.org, sfr@canb.auug.org.au, mingo@redhat.com,
        arnd@arndb.de, dhowells@redhat.com, tglx@linutronix.de,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Date: Wed, 07 Mar 2012 19:50:57 +0000
Message-ID: <20120307195057.15987.64928.stgit@warthog.procyon.org.uk>
In-Reply-To: <20120307194548.15987.36073.stgit@warthog.procyon.org.uk>
References: <20120307194548.15987.36073.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Disintegrate asm/system.h for Unicore32.  Not Compiled.  No asm/atomic.h or
asm/bug.h found prior to patch.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 arch/unicore32/include/asm/atomic.h    |   58 ++++++++++++
 arch/unicore32/include/asm/barrier.h   |   28 ++++++
 arch/unicore32/include/asm/bug.h       |   32 ++++++
 arch/unicore32/include/asm/cr.h        |   49 ++++++++++
 arch/unicore32/include/asm/exec.h      |   15 +++
 arch/unicore32/include/asm/pgtable.h   |    3 +
 arch/unicore32/include/asm/setup.h     |   16 +++
 arch/unicore32/include/asm/switch_to.h |   30 ++++++
 arch/unicore32/include/asm/system.h    |  161 --------------------------------
 9 files changed, 231 insertions(+), 161 deletions(-)
 create mode 100644 arch/unicore32/include/asm/atomic.h
 create mode 100644 arch/unicore32/include/asm/barrier.h
 create mode 100644 arch/unicore32/include/asm/bug.h
 create mode 100644 arch/unicore32/include/asm/cr.h
 create mode 100644 arch/unicore32/include/asm/exec.h
 create mode 100644 arch/unicore32/include/asm/setup.h
 create mode 100644 arch/unicore32/include/asm/switch_to.h
 delete mode 100644 arch/unicore32/include/asm/system.h

diff --git a/arch/unicore32/include/asm/atomic.h b/arch/unicore32/include/asm/atomic.h
new file mode 100644
index 0000000..a08d05b
--- /dev/null
+++ b/arch/unicore32/include/asm/atomic.h
@@ -0,0 +1,58 @@
+/*
+ * Atomics for PKUnity SoC and UniCore ISA
+ *
+ * Copyright (C) 2001-2010 GUAN Xue-tao
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+#ifndef __UNICORE_ATOMIC_H__
+#define __UNICORE_ATOMIC_H__
+
+static inline unsigned long
+__xchg(unsigned long x, volatile void *ptr, int size)
+{
+	unsigned long ret;
+
+	switch (size) {
+	case 1:
+		asm volatile("@	__xchg1\n"
+		"	swapb	%0, %1, [%2]"
+			: "=&r" (ret)
+			: "r" (x), "r" (ptr)
+			: "memory", "cc");
+		break;
+	case 4:
+		asm volatile("@	__xchg4\n"
+		"	swapw	%0, %1, [%2]"
+			: "=&r" (ret)
+			: "r" (x), "r" (ptr)
+			: "memory", "cc");
+		break;
+	default:
+		panic("xchg: bad data size: ptr 0x%p, size %d\n",
+			ptr, size);
+	}
+
+	return ret;
+}
+
+#define xchg(ptr, x) \
+	((__typeof__(*(ptr)))__xchg((unsigned long)(x), (ptr), sizeof(*(ptr))))
+
+#include <asm-generic/cmpxchg-local.h>
+
+/*
+ * cmpxchg_local and cmpxchg64_local are atomic wrt current CPU. Always make
+ * them available.
+ */
+#define cmpxchg_local(ptr, o, n)					\
+		((__typeof__(*(ptr)))__cmpxchg_local_generic((ptr),	\
+		(unsigned long)(o), (unsigned long)(n), sizeof(*(ptr))))
+#define cmpxchg64_local(ptr, o, n)					\
+		__cmpxchg64_local_generic((ptr), (o), (n))
+
+#include <asm-generic/cmpxchg.h>
+
+#endif /* __UNICORE_ATOMIC_H__ */
diff --git a/arch/unicore32/include/asm/barrier.h b/arch/unicore32/include/asm/barrier.h
new file mode 100644
index 0000000..b7e5f82
--- /dev/null
+++ b/arch/unicore32/include/asm/barrier.h
@@ -0,0 +1,28 @@
+/*
+ * Memory barrier implementations for PKUnity SoC and UniCore ISA
+ *
+ * Copyright (C) 2001-2010 GUAN Xue-tao
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+#ifndef __UNICORE_BARRIER_H__
+#define __UNICORE_BARRIER_H__
+
+#define isb() __asm__ __volatile__ ("" : : : "memory")
+#define dsb() __asm__ __volatile__ ("" : : : "memory")
+#define dmb() __asm__ __volatile__ ("" : : : "memory")
+
+#define mb()		barrier()
+#define rmb()		barrier()
+#define wmb()		barrier()
+#define smp_mb()	barrier()
+#define smp_rmb()	barrier()
+#define smp_wmb()	barrier()
+#define read_barrier_depends()		do { } while (0)
+#define smp_read_barrier_depends()	do { } while (0)
+
+#define set_mb(var, value)	do { var = value; smp_mb(); } while (0)
+
+#endif /* __UNICORE_BARRIER_H__ */
diff --git a/arch/unicore32/include/asm/bug.h b/arch/unicore32/include/asm/bug.h
new file mode 100644
index 0000000..160366d
--- /dev/null
+++ b/arch/unicore32/include/asm/bug.h
@@ -0,0 +1,32 @@
+/*
+ * Bug handling for PKUnity SoC and UniCore ISA
+ *
+ * Copyright (C) 2001-2010 GUAN Xue-tao
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+#ifndef __UNICORE_BUG_H__
+#define __UNICORE_BUG_H__
+
+#include <linux/linkage.h>
+
+struct pt_regs;
+struct siginfo;
+
+void die(const char *msg, struct pt_regs *regs, int err);
+
+void uc32_notify_die(const char *str, struct pt_regs *regs,
+		struct siginfo *info, unsigned long err, unsigned long trap);
+
+void hook_fault_code(int nr, int (*fn)(unsigned long, unsigned int,
+				       struct pt_regs *),
+		     int sig, int code, const char *name);
+
+extern asmlinkage void __backtrace(void);
+extern asmlinkage void c_backtrace(unsigned long fp, int pmode);
+
+extern void __show_regs(struct pt_regs *);
+
+#endif /* __UNICORE_BUG_H__ */
diff --git a/arch/unicore32/include/asm/cr.h b/arch/unicore32/include/asm/cr.h
new file mode 100644
index 0000000..96510a1
--- /dev/null
+++ b/arch/unicore32/include/asm/cr.h
@@ -0,0 +1,49 @@
+/*
+ * CR registed bits for PKUnity SoC and UniCore ISA
+ *
+ * Copyright (C) 2001-2010 GUAN Xue-tao
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+#ifndef __UNICORE_CR_H__
+#define __UNICORE_CR_H__
+
+/*
+ * CR1 bits (CP#0 CR1)
+ */
+#define CR_M	(1 << 0)	/* MMU enable				*/
+#define CR_A	(1 << 1)	/* Alignment abort enable		*/
+#define CR_D	(1 << 2)	/* Dcache enable			*/
+#define CR_I	(1 << 3)	/* Icache enable			*/
+#define CR_B	(1 << 4)	/* Dcache write mechanism: write back	*/
+#define CR_T	(1 << 5)	/* Burst enable				*/
+#define CR_V	(1 << 13)	/* Vectors relocated to 0xffff0000	*/
+
+#ifndef __ASSEMBLY__
+
+#define vectors_high()	(cr_alignment & CR_V)
+
+extern unsigned long cr_no_alignment;	/* defined in entry-unicore.S */
+extern unsigned long cr_alignment;	/* defined in entry-unicore.S */
+
+static inline unsigned int get_cr(void)
+{
+	unsigned int val;
+	asm("movc %0, p0.c1, #0" : "=r" (val) : : "cc");
+	return val;
+}
+
+static inline void set_cr(unsigned int val)
+{
+	asm volatile("movc p0.c1, %0, #0	@set CR"
+	  : : "r" (val) : "cc");
+	isb();
+}
+
+extern void adjust_cr(unsigned long mask, unsigned long set);
+
+#endif /* __ASSEMBLY__ */
+
+#endif /* __UNICORE_CR_H__ */
diff --git a/arch/unicore32/include/asm/exec.h b/arch/unicore32/include/asm/exec.h
new file mode 100644
index 0000000..ae707b3
--- /dev/null
+++ b/arch/unicore32/include/asm/exec.h
@@ -0,0 +1,15 @@
+/*
+ * Process execution bits for PKUnity SoC and UniCore ISA
+ *
+ * Copyright (C) 2001-2010 GUAN Xue-tao
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+#ifndef __UNICORE_EXEC_H__
+#define __UNICORE_EXEC_H__
+
+#define arch_align_stack(x) (x)
+
+#endif /* __UNICORE_EXEC_H__ */
diff --git a/arch/unicore32/include/asm/pgtable.h b/arch/unicore32/include/asm/pgtable.h
index 68b2f29..71b5520 100644
--- a/arch/unicore32/include/asm/pgtable.h
+++ b/arch/unicore32/include/asm/pgtable.h
@@ -312,6 +312,9 @@ extern pgd_t swapper_pg_dir[PTRS_PER_PGD];
 
 #define pgtable_cache_init() do { } while (0)
 
+struct mm_struct;
+extern void show_pte(struct mm_struct *mm, unsigned long addr);
+
 #endif /* !__ASSEMBLY__ */
 
 #endif /* __UNICORE_PGTABLE_H__ */
diff --git a/arch/unicore32/include/asm/setup.h b/arch/unicore32/include/asm/setup.h
new file mode 100644
index 0000000..c69c969
--- /dev/null
+++ b/arch/unicore32/include/asm/setup.h
@@ -0,0 +1,16 @@
+/*
+ * Setup code for PKUnity SoC and UniCore ISA
+ *
+ * Copyright (C) 2001-2010 GUAN Xue-tao
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+#ifndef __UNICORE_SETUP_H__
+#define __UNICORE_SETUP_H__
+
+extern int cpu_architecture(void);
+extern void cpu_init(void);
+
+#endif /* __UNICORE_SETUP_H__ */
diff --git a/arch/unicore32/include/asm/switch_to.h b/arch/unicore32/include/asm/switch_to.h
new file mode 100644
index 0000000..db7a40c
--- /dev/null
+++ b/arch/unicore32/include/asm/switch_to.h
@@ -0,0 +1,30 @@
+/*
+ * Task switching for PKUnity SoC and UniCore ISA
+ *
+ * Copyright (C) 2001-2010 GUAN Xue-tao
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+#ifndef __UNICORE_SWITCH_TO_H__
+#define __UNICORE_SWITCH_TO_H__
+
+struct task_struct;
+struct thread_info;
+
+/*
+ * switch_to(prev, next) should switch from task `prev' to `next'
+ * `prev' will never be the same as `next'.  schedule() itself
+ * contains the memory barrier to tell GCC not to cache `current'.
+ */
+extern struct task_struct *__switch_to(struct task_struct *,
+		struct thread_info *, struct thread_info *);
+
+#define switch_to(prev, next, last)					\
+do {									\
+	last = __switch_to(prev,					\
+		task_thread_info(prev), task_thread_info(next));	\
+} while (0)
+
+#endif /* __UNICORE_SWITCH_TO_H__ */
diff --git a/arch/unicore32/include/asm/system.h b/arch/unicore32/include/asm/system.h
deleted file mode 100644
index 246b71c..0000000
--- a/arch/unicore32/include/asm/system.h
+++ /dev/null
@@ -1,161 +0,0 @@
-/*
- * linux/arch/unicore32/include/asm/system.h
- *
- * Code specific to PKUnity SoC and UniCore ISA
- *
- * Copyright (C) 2001-2010 GUAN Xue-tao
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- */
-#ifndef __UNICORE_SYSTEM_H__
-#define __UNICORE_SYSTEM_H__
-
-#ifdef __KERNEL__
-
-/*
- * CR1 bits (CP#0 CR1)
- */
-#define CR_M	(1 << 0)	/* MMU enable				*/
-#define CR_A	(1 << 1)	/* Alignment abort enable		*/
-#define CR_D	(1 << 2)	/* Dcache enable			*/
-#define CR_I	(1 << 3)	/* Icache enable			*/
-#define CR_B	(1 << 4)	/* Dcache write mechanism: write back	*/
-#define CR_T	(1 << 5)	/* Burst enable				*/
-#define CR_V	(1 << 13)	/* Vectors relocated to 0xffff0000	*/
-
-#ifndef __ASSEMBLY__
-
-#include <linux/linkage.h>
-#include <linux/irqflags.h>
-
-struct thread_info;
-struct task_struct;
-
-struct pt_regs;
-
-void die(const char *msg, struct pt_regs *regs, int err);
-
-struct siginfo;
-void uc32_notify_die(const char *str, struct pt_regs *regs,
-		struct siginfo *info, unsigned long err, unsigned long trap);
-
-void hook_fault_code(int nr, int (*fn)(unsigned long, unsigned int,
-				       struct pt_regs *),
-		     int sig, int code, const char *name);
-
-#define xchg(ptr, x) \
-	((__typeof__(*(ptr)))__xchg((unsigned long)(x), (ptr), sizeof(*(ptr))))
-
-extern asmlinkage void __backtrace(void);
-extern asmlinkage void c_backtrace(unsigned long fp, int pmode);
-
-struct mm_struct;
-extern void show_pte(struct mm_struct *mm, unsigned long addr);
-extern void __show_regs(struct pt_regs *);
-
-extern int cpu_architecture(void);
-extern void cpu_init(void);
-
-#define vectors_high()	(cr_alignment & CR_V)
-
-#define isb() __asm__ __volatile__ ("" : : : "memory")
-#define dsb() __asm__ __volatile__ ("" : : : "memory")
-#define dmb() __asm__ __volatile__ ("" : : : "memory")
-
-#define mb()		barrier()
-#define rmb()		barrier()
-#define wmb()		barrier()
-#define smp_mb()	barrier()
-#define smp_rmb()	barrier()
-#define smp_wmb()	barrier()
-#define read_barrier_depends()		do { } while (0)
-#define smp_read_barrier_depends()	do { } while (0)
-
-#define set_mb(var, value)	do { var = value; smp_mb(); } while (0)
-#define nop() __asm__ __volatile__("mov\tr0,r0\t@ nop\n\t");
-
-extern unsigned long cr_no_alignment;	/* defined in entry-unicore.S */
-extern unsigned long cr_alignment;	/* defined in entry-unicore.S */
-
-static inline unsigned int get_cr(void)
-{
-	unsigned int val;
-	asm("movc %0, p0.c1, #0" : "=r" (val) : : "cc");
-	return val;
-}
-
-static inline void set_cr(unsigned int val)
-{
-	asm volatile("movc p0.c1, %0, #0	@set CR"
-	  : : "r" (val) : "cc");
-	isb();
-}
-
-extern void adjust_cr(unsigned long mask, unsigned long set);
-
-/*
- * switch_to(prev, next) should switch from task `prev' to `next'
- * `prev' will never be the same as `next'.  schedule() itself
- * contains the memory barrier to tell GCC not to cache `current'.
- */
-extern struct task_struct *__switch_to(struct task_struct *,
-		struct thread_info *, struct thread_info *);
-extern void panic(const char *fmt, ...);
-
-#define switch_to(prev, next, last)					\
-do {									\
-	last = __switch_to(prev,					\
-		task_thread_info(prev), task_thread_info(next));	\
-} while (0)
-
-static inline unsigned long
-__xchg(unsigned long x, volatile void *ptr, int size)
-{
-	unsigned long ret;
-
-	switch (size) {
-	case 1:
-		asm volatile("@	__xchg1\n"
-		"	swapb	%0, %1, [%2]"
-			: "=&r" (ret)
-			: "r" (x), "r" (ptr)
-			: "memory", "cc");
-		break;
-	case 4:
-		asm volatile("@	__xchg4\n"
-		"	swapw	%0, %1, [%2]"
-			: "=&r" (ret)
-			: "r" (x), "r" (ptr)
-			: "memory", "cc");
-		break;
-	default:
-		panic("xchg: bad data size: ptr 0x%p, size %d\n",
-			ptr, size);
-	}
-
-	return ret;
-}
-
-#include <asm-generic/cmpxchg-local.h>
-
-/*
- * cmpxchg_local and cmpxchg64_local are atomic wrt current CPU. Always make
- * them available.
- */
-#define cmpxchg_local(ptr, o, n)					\
-		((__typeof__(*(ptr)))__cmpxchg_local_generic((ptr),	\
-		(unsigned long)(o), (unsigned long)(n), sizeof(*(ptr))))
-#define cmpxchg64_local(ptr, o, n)					\
-		__cmpxchg64_local_generic((ptr), (o), (n))
-
-#include <asm-generic/cmpxchg.h>
-
-#endif /* __ASSEMBLY__ */
-
-#define arch_align_stack(x) (x)
-
-#endif /* __KERNEL__ */
-
-#endif

