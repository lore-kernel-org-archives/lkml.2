Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161723Ab2COU7c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 16:59:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48168 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161663Ab2COU61 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 16:58:27 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 19/38] Disintegrate asm/system.h for MN10300 [ver #3]
To: paul.gortmaker@windriver.com
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org, arnd@arndb.de,
        David Howells <dhowells@redhat.com>, linux-am33-list@redhat.com
Date: Thu, 15 Mar 2012 20:58:13 +0000
Message-ID: <20120315205813.28759.30080.stgit@warthog.procyon.org.uk>
In-Reply-To: <20120315205514.28759.58969.stgit@warthog.procyon.org.uk>
References: <20120315205514.28759.58969.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Disintegrate asm/system.h for MN10300.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: linux-am33-list@redhat.com
---

 arch/mn10300/include/asm/atomic.h       |  109 +----------------------------
 arch/mn10300/include/asm/barrier.h      |   37 ++++++++++
 arch/mn10300/include/asm/cmpxchg.h      |  115 +++++++++++++++++++++++++++++++
 arch/mn10300/include/asm/dma.h          |    1 
 arch/mn10300/include/asm/exec.h         |   16 ++++
 arch/mn10300/include/asm/switch_to.h    |   49 +++++++++++++
 arch/mn10300/include/asm/system.h       |  107 +----------------------------
 arch/mn10300/kernel/entry.S             |    1 
 arch/mn10300/kernel/fpu.c               |    1 
 arch/mn10300/kernel/gdb-io-serial.c     |    1 
 arch/mn10300/kernel/gdb-io-ttysm.c      |    1 
 arch/mn10300/kernel/gdb-stub.c          |    1 
 arch/mn10300/kernel/mn10300-serial.c    |    1 
 arch/mn10300/kernel/mn10300-watchdog.c  |    1 
 arch/mn10300/kernel/process.c           |    1 
 arch/mn10300/kernel/ptrace.c            |    1 
 arch/mn10300/kernel/setup.c             |    1 
 arch/mn10300/kernel/smp-low.S           |    2 -
 arch/mn10300/kernel/smp.c               |    1 
 arch/mn10300/kernel/traps.c             |    1 
 arch/mn10300/lib/bitops.c               |    1 
 arch/mn10300/mm/fault.c                 |    1 
 arch/mn10300/mm/init.c                  |    1 
 arch/mn10300/mm/misalignment.c          |    1 
 arch/mn10300/mm/pgtable.c               |    1 
 arch/mn10300/mm/tlb-smp.c               |    1 
 arch/mn10300/proc-mn2ws0050/proc-init.c |    1 
 27 files changed, 226 insertions(+), 229 deletions(-)
 create mode 100644 arch/mn10300/include/asm/barrier.h
 create mode 100644 arch/mn10300/include/asm/cmpxchg.h
 create mode 100644 arch/mn10300/include/asm/exec.h
 create mode 100644 arch/mn10300/include/asm/switch_to.h

diff --git a/arch/mn10300/include/asm/atomic.h b/arch/mn10300/include/asm/atomic.h
index b9a8f84..975e184 100644
--- a/arch/mn10300/include/asm/atomic.h
+++ b/arch/mn10300/include/asm/atomic.h
@@ -12,112 +12,7 @@
 #define _ASM_ATOMIC_H
 
 #include <asm/irqflags.h>
-
-#ifndef __ASSEMBLY__
-
-#ifdef CONFIG_SMP
-#ifdef CONFIG_MN10300_HAS_ATOMIC_OPS_UNIT
-static inline
-unsigned long __xchg(volatile unsigned long *m, unsigned long val)
-{
-	unsigned long status;
-	unsigned long oldval;
-
-	asm volatile(
-		"1:	mov	%4,(_AAR,%3)	\n"
-		"	mov	(_ADR,%3),%1	\n"
-		"	mov	%5,(_ADR,%3)	\n"
-		"	mov	(_ADR,%3),%0	\n"	/* flush */
-		"	mov	(_ASR,%3),%0	\n"
-		"	or	%0,%0		\n"
-		"	bne	1b		\n"
-		: "=&r"(status), "=&r"(oldval), "=m"(*m)
-		: "a"(ATOMIC_OPS_BASE_ADDR), "r"(m), "r"(val)
-		: "memory", "cc");
-
-	return oldval;
-}
-
-static inline unsigned long __cmpxchg(volatile unsigned long *m,
-				      unsigned long old, unsigned long new)
-{
-	unsigned long status;
-	unsigned long oldval;
-
-	asm volatile(
-		"1:	mov	%4,(_AAR,%3)	\n"
-		"	mov	(_ADR,%3),%1	\n"
-		"	cmp	%5,%1		\n"
-		"	bne	2f		\n"
-		"	mov	%6,(_ADR,%3)	\n"
-		"2:	mov	(_ADR,%3),%0	\n"	/* flush */
-		"	mov	(_ASR,%3),%0	\n"
-		"	or	%0,%0		\n"
-		"	bne	1b		\n"
-		: "=&r"(status), "=&r"(oldval), "=m"(*m)
-		: "a"(ATOMIC_OPS_BASE_ADDR), "r"(m),
-		  "r"(old), "r"(new)
-		: "memory", "cc");
-
-	return oldval;
-}
-#else  /* CONFIG_MN10300_HAS_ATOMIC_OPS_UNIT */
-#error "No SMP atomic operation support!"
-#endif /* CONFIG_MN10300_HAS_ATOMIC_OPS_UNIT */
-
-#else  /* CONFIG_SMP */
-
-/*
- * Emulate xchg for non-SMP MN10300
- */
-struct __xchg_dummy { unsigned long a[100]; };
-#define __xg(x) ((struct __xchg_dummy *)(x))
-
-static inline
-unsigned long __xchg(volatile unsigned long *m, unsigned long val)
-{
-	unsigned long oldval;
-	unsigned long flags;
-
-	flags = arch_local_cli_save();
-	oldval = *m;
-	*m = val;
-	arch_local_irq_restore(flags);
-	return oldval;
-}
-
-/*
- * Emulate cmpxchg for non-SMP MN10300
- */
-static inline unsigned long __cmpxchg(volatile unsigned long *m,
-				      unsigned long old, unsigned long new)
-{
-	unsigned long oldval;
-	unsigned long flags;
-
-	flags = arch_local_cli_save();
-	oldval = *m;
-	if (oldval == old)
-		*m = new;
-	arch_local_irq_restore(flags);
-	return oldval;
-}
-
-#endif /* CONFIG_SMP */
-
-#define xchg(ptr, v)						\
-	((__typeof__(*(ptr))) __xchg((unsigned long *)(ptr),	\
-				     (unsigned long)(v)))
-
-#define cmpxchg(ptr, o, n)					\
-	((__typeof__(*(ptr))) __cmpxchg((unsigned long *)(ptr), \
-					(unsigned long)(o),	\
-					(unsigned long)(n)))
-
-#define atomic_xchg(ptr, v)		(xchg(&(ptr)->counter, (v)))
-#define atomic_cmpxchg(v, old, new)	(cmpxchg(&((v)->counter), (old), (new)))
-
-#endif /* !__ASSEMBLY__ */
+#include <asm/cmpxchg.h>
 
 #ifndef CONFIG_SMP
 #include <asm-generic/atomic.h>
@@ -269,6 +164,8 @@ static inline void atomic_dec(atomic_t *v)
 	c;							\
 })
 
+#define atomic_xchg(ptr, v)		(xchg(&(ptr)->counter, (v)))
+#define atomic_cmpxchg(v, old, new)	(cmpxchg(&((v)->counter), (old), (new)))
 
 /**
  * atomic_clear_mask - Atomically clear bits in memory
diff --git a/arch/mn10300/include/asm/barrier.h b/arch/mn10300/include/asm/barrier.h
new file mode 100644
index 0000000..2bd97a5
--- /dev/null
+++ b/arch/mn10300/include/asm/barrier.h
@@ -0,0 +1,37 @@
+/* MN10300 memory barrier definitions
+ *
+ * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+#ifndef _ASM_BARRIER_H
+#define _ASM_BARRIER_H
+
+#define nop()	asm volatile ("nop")
+
+#define mb()	asm volatile ("": : :"memory")
+#define rmb()	mb()
+#define wmb()	asm volatile ("": : :"memory")
+
+#ifdef CONFIG_SMP
+#define smp_mb()	mb()
+#define smp_rmb()	rmb()
+#define smp_wmb()	wmb()
+#define set_mb(var, value)  do { xchg(&var, value); } while (0)
+#else  /* CONFIG_SMP */
+#define smp_mb()	barrier()
+#define smp_rmb()	barrier()
+#define smp_wmb()	barrier()
+#define set_mb(var, value)  do { var = value;  mb(); } while (0)
+#endif /* CONFIG_SMP */
+
+#define set_wmb(var, value) do { var = value; wmb(); } while (0)
+
+#define read_barrier_depends()		do {} while (0)
+#define smp_read_barrier_depends()	do {} while (0)
+
+#endif /* _ASM_BARRIER_H */
diff --git a/arch/mn10300/include/asm/cmpxchg.h b/arch/mn10300/include/asm/cmpxchg.h
new file mode 100644
index 0000000..97a4aaf
--- /dev/null
+++ b/arch/mn10300/include/asm/cmpxchg.h
@@ -0,0 +1,115 @@
+/* MN10300 Atomic xchg/cmpxchg operations
+ *
+ * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+#ifndef _ASM_CMPXCHG_H
+#define _ASM_CMPXCHG_H
+
+#include <asm/irqflags.h>
+
+#ifdef CONFIG_SMP
+#ifdef CONFIG_MN10300_HAS_ATOMIC_OPS_UNIT
+static inline
+unsigned long __xchg(volatile unsigned long *m, unsigned long val)
+{
+	unsigned long status;
+	unsigned long oldval;
+
+	asm volatile(
+		"1:	mov	%4,(_AAR,%3)	\n"
+		"	mov	(_ADR,%3),%1	\n"
+		"	mov	%5,(_ADR,%3)	\n"
+		"	mov	(_ADR,%3),%0	\n"	/* flush */
+		"	mov	(_ASR,%3),%0	\n"
+		"	or	%0,%0		\n"
+		"	bne	1b		\n"
+		: "=&r"(status), "=&r"(oldval), "=m"(*m)
+		: "a"(ATOMIC_OPS_BASE_ADDR), "r"(m), "r"(val)
+		: "memory", "cc");
+
+	return oldval;
+}
+
+static inline unsigned long __cmpxchg(volatile unsigned long *m,
+				      unsigned long old, unsigned long new)
+{
+	unsigned long status;
+	unsigned long oldval;
+
+	asm volatile(
+		"1:	mov	%4,(_AAR,%3)	\n"
+		"	mov	(_ADR,%3),%1	\n"
+		"	cmp	%5,%1		\n"
+		"	bne	2f		\n"
+		"	mov	%6,(_ADR,%3)	\n"
+		"2:	mov	(_ADR,%3),%0	\n"	/* flush */
+		"	mov	(_ASR,%3),%0	\n"
+		"	or	%0,%0		\n"
+		"	bne	1b		\n"
+		: "=&r"(status), "=&r"(oldval), "=m"(*m)
+		: "a"(ATOMIC_OPS_BASE_ADDR), "r"(m),
+		  "r"(old), "r"(new)
+		: "memory", "cc");
+
+	return oldval;
+}
+#else  /* CONFIG_MN10300_HAS_ATOMIC_OPS_UNIT */
+#error "No SMP atomic operation support!"
+#endif /* CONFIG_MN10300_HAS_ATOMIC_OPS_UNIT */
+
+#else  /* CONFIG_SMP */
+
+/*
+ * Emulate xchg for non-SMP MN10300
+ */
+struct __xchg_dummy { unsigned long a[100]; };
+#define __xg(x) ((struct __xchg_dummy *)(x))
+
+static inline
+unsigned long __xchg(volatile unsigned long *m, unsigned long val)
+{
+	unsigned long oldval;
+	unsigned long flags;
+
+	flags = arch_local_cli_save();
+	oldval = *m;
+	*m = val;
+	arch_local_irq_restore(flags);
+	return oldval;
+}
+
+/*
+ * Emulate cmpxchg for non-SMP MN10300
+ */
+static inline unsigned long __cmpxchg(volatile unsigned long *m,
+				      unsigned long old, unsigned long new)
+{
+	unsigned long oldval;
+	unsigned long flags;
+
+	flags = arch_local_cli_save();
+	oldval = *m;
+	if (oldval == old)
+		*m = new;
+	arch_local_irq_restore(flags);
+	return oldval;
+}
+
+#endif /* CONFIG_SMP */
+
+#define xchg(ptr, v)						\
+	((__typeof__(*(ptr))) __xchg((unsigned long *)(ptr),	\
+				     (unsigned long)(v)))
+
+#define cmpxchg(ptr, o, n)					\
+	((__typeof__(*(ptr))) __cmpxchg((unsigned long *)(ptr), \
+					(unsigned long)(o),	\
+					(unsigned long)(n)))
+
+#endif /* _ASM_CMPXCHG_H */
diff --git a/arch/mn10300/include/asm/dma.h b/arch/mn10300/include/asm/dma.h
index 098df2e..10b77d4 100644
--- a/arch/mn10300/include/asm/dma.h
+++ b/arch/mn10300/include/asm/dma.h
@@ -11,7 +11,6 @@
 #ifndef _ASM_DMA_H
 #define _ASM_DMA_H
 
-#include <asm/system.h>
 #include <linux/spinlock.h>
 #include <asm/io.h>
 #include <linux/delay.h>
diff --git a/arch/mn10300/include/asm/exec.h b/arch/mn10300/include/asm/exec.h
new file mode 100644
index 0000000..c74e367
--- /dev/null
+++ b/arch/mn10300/include/asm/exec.h
@@ -0,0 +1,16 @@
+/* MN10300 process execution definitions
+ *
+ * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+#ifndef _ASM_EXEC_H
+#define _ASM_EXEC_H
+
+#define arch_align_stack(x) (x)
+
+#endif /* _ASM_EXEC_H */
diff --git a/arch/mn10300/include/asm/switch_to.h b/arch/mn10300/include/asm/switch_to.h
new file mode 100644
index 0000000..393d311
--- /dev/null
+++ b/arch/mn10300/include/asm/switch_to.h
@@ -0,0 +1,49 @@
+/* MN10300 task switching definitions
+ *
+ * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+#ifndef _ASM_SWITCH_TO_H
+#define _ASM_SWITCH_TO_H
+
+#include <asm/barrier.h>
+
+struct task_struct;
+struct thread_struct;
+
+#if !defined(CONFIG_LAZY_SAVE_FPU)
+struct fpu_state_struct;
+extern asmlinkage void fpu_save(struct fpu_state_struct *);
+#define switch_fpu(prev, next)						\
+	do {								\
+		if ((prev)->thread.fpu_flags & THREAD_HAS_FPU) {	\
+			(prev)->thread.fpu_flags &= ~THREAD_HAS_FPU;	\
+			(prev)->thread.uregs->epsw &= ~EPSW_FE;		\
+			fpu_save(&(prev)->thread.fpu_state);		\
+		}							\
+	} while (0)
+#else
+#define switch_fpu(prev, next) do {} while (0)
+#endif
+
+/* context switching is now performed out-of-line in switch_to.S */
+extern asmlinkage
+struct task_struct *__switch_to(struct thread_struct *prev,
+				struct thread_struct *next,
+				struct task_struct *prev_task);
+
+#define switch_to(prev, next, last)					\
+do {									\
+	switch_fpu(prev, next);						\
+	current->thread.wchan = (u_long) __builtin_return_address(0);	\
+	(last) = __switch_to(&(prev)->thread, &(next)->thread, (prev));	\
+	mb();								\
+	current->thread.wchan = 0;					\
+} while (0)
+
+#endif /* _ASM_SWITCH_TO_H */
diff --git a/arch/mn10300/include/asm/system.h b/arch/mn10300/include/asm/system.h
index 94b4c5e..a7f4057 100644
--- a/arch/mn10300/include/asm/system.h
+++ b/arch/mn10300/include/asm/system.h
@@ -1,102 +1,5 @@
-/* MN10300 System definitions
- *
- * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
- * Written by David Howells (dhowells@redhat.com)
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public Licence
- * as published by the Free Software Foundation; either version
- * 2 of the Licence, or (at your option) any later version.
- */
-#ifndef _ASM_SYSTEM_H
-#define _ASM_SYSTEM_H
-
-#include <asm/cpu-regs.h>
-#include <asm/intctl-regs.h>
-
-#ifdef __KERNEL__
-#ifndef __ASSEMBLY__
-
-#include <linux/kernel.h>
-#include <linux/irqflags.h>
-#include <linux/atomic.h>
-
-#if !defined(CONFIG_LAZY_SAVE_FPU)
-struct fpu_state_struct;
-extern asmlinkage void fpu_save(struct fpu_state_struct *);
-#define switch_fpu(prev, next)						\
-	do {								\
-		if ((prev)->thread.fpu_flags & THREAD_HAS_FPU) {	\
-			(prev)->thread.fpu_flags &= ~THREAD_HAS_FPU;	\
-			(prev)->thread.uregs->epsw &= ~EPSW_FE;		\
-			fpu_save(&(prev)->thread.fpu_state);		\
-		}							\
-	} while (0)
-#else
-#define switch_fpu(prev, next) do {} while (0)
-#endif
-
-struct task_struct;
-struct thread_struct;
-
-extern asmlinkage
-struct task_struct *__switch_to(struct thread_struct *prev,
-				struct thread_struct *next,
-				struct task_struct *prev_task);
-
-/* context switching is now performed out-of-line in switch_to.S */
-#define switch_to(prev, next, last)					\
-do {									\
-	switch_fpu(prev, next);						\
-	current->thread.wchan = (u_long) __builtin_return_address(0);	\
-	(last) = __switch_to(&(prev)->thread, &(next)->thread, (prev));	\
-	mb();								\
-	current->thread.wchan = 0;					\
-} while (0)
-
-#define arch_align_stack(x) (x)
-
-#define nop() asm volatile ("nop")
-
-/*
- * Force strict CPU ordering.
- * And yes, this is required on UP too when we're talking
- * to devices.
- *
- * For now, "wmb()" doesn't actually do anything, as all
- * Intel CPU's follow what Intel calls a *Processor Order*,
- * in which all writes are seen in the program order even
- * outside the CPU.
- *
- * I expect future Intel CPU's to have a weaker ordering,
- * but I'd also expect them to finally get their act together
- * and add some real memory barriers if so.
- *
- * Some non intel clones support out of order store. wmb() ceases to be a
- * nop for these.
- */
-
-#define mb()	asm volatile ("": : :"memory")
-#define rmb()	mb()
-#define wmb()	asm volatile ("": : :"memory")
-
-#ifdef CONFIG_SMP
-#define smp_mb()	mb()
-#define smp_rmb()	rmb()
-#define smp_wmb()	wmb()
-#define set_mb(var, value)  do { xchg(&var, value); } while (0)
-#else  /* CONFIG_SMP */
-#define smp_mb()	barrier()
-#define smp_rmb()	barrier()
-#define smp_wmb()	barrier()
-#define set_mb(var, value)  do { var = value;  mb(); } while (0)
-#endif /* CONFIG_SMP */
-
-#define set_wmb(var, value) do { var = value; wmb(); } while (0)
-
-#define read_barrier_depends()		do {} while (0)
-#define smp_read_barrier_depends()	do {} while (0)
-
-#endif /* !__ASSEMBLY__ */
-#endif /* __KERNEL__ */
-#endif /* _ASM_SYSTEM_H */
+/* FILE TO BE DELETED. DO NOT ADD STUFF HERE! */
+#include <asm/barrier.h>
+#include <asm/cmpxchg.h>
+#include <asm/exec.h>
+#include <asm/switch_to.h>
diff --git a/arch/mn10300/kernel/entry.S b/arch/mn10300/kernel/entry.S
index 3e3620d..8e11f9f 100644
--- a/arch/mn10300/kernel/entry.S
+++ b/arch/mn10300/kernel/entry.S
@@ -15,7 +15,6 @@
 #include <linux/sys.h>
 #include <linux/linkage.h>
 #include <asm/smp.h>
-#include <asm/system.h>
 #include <asm/irqflags.h>
 #include <asm/thread_info.h>
 #include <asm/intctl-regs.h>
diff --git a/arch/mn10300/kernel/fpu.c b/arch/mn10300/kernel/fpu.c
index bb5fa7d..064fa19 100644
--- a/arch/mn10300/kernel/fpu.c
+++ b/arch/mn10300/kernel/fpu.c
@@ -12,7 +12,6 @@
 #include <asm/fpu.h>
 #include <asm/elf.h>
 #include <asm/exceptions.h>
-#include <asm/system.h>
 
 #ifdef CONFIG_LAZY_SAVE_FPU
 struct task_struct *fpu_state_owner;
diff --git a/arch/mn10300/kernel/gdb-io-serial.c b/arch/mn10300/kernel/gdb-io-serial.c
index f28dc99..df51242 100644
--- a/arch/mn10300/kernel/gdb-io-serial.c
+++ b/arch/mn10300/kernel/gdb-io-serial.c
@@ -18,7 +18,6 @@
 #include <linux/nmi.h>
 
 #include <asm/pgtable.h>
-#include <asm/system.h>
 #include <asm/gdb-stub.h>
 #include <asm/exceptions.h>
 #include <asm/serial-regs.h>
diff --git a/arch/mn10300/kernel/gdb-io-ttysm.c b/arch/mn10300/kernel/gdb-io-ttysm.c
index c859cac..caae8ca 100644
--- a/arch/mn10300/kernel/gdb-io-ttysm.c
+++ b/arch/mn10300/kernel/gdb-io-ttysm.c
@@ -17,7 +17,6 @@
 #include <linux/init.h>
 #include <linux/tty.h>
 #include <asm/pgtable.h>
-#include <asm/system.h>
 #include <asm/gdb-stub.h>
 #include <asm/exceptions.h>
 #include <unit/clock.h>
diff --git a/arch/mn10300/kernel/gdb-stub.c b/arch/mn10300/kernel/gdb-stub.c
index 522eb8a..a128c57 100644
--- a/arch/mn10300/kernel/gdb-stub.c
+++ b/arch/mn10300/kernel/gdb-stub.c
@@ -130,7 +130,6 @@
 #include <linux/bug.h>
 
 #include <asm/pgtable.h>
-#include <asm/system.h>
 #include <asm/gdb-stub.h>
 #include <asm/exceptions.h>
 #include <asm/debugger.h>
diff --git a/arch/mn10300/kernel/mn10300-serial.c b/arch/mn10300/kernel/mn10300-serial.c
index 94901c5..339cef4 100644
--- a/arch/mn10300/kernel/mn10300-serial.c
+++ b/arch/mn10300/kernel/mn10300-serial.c
@@ -36,7 +36,6 @@ static const char serial_revdate[] = "2007-11-06";
 #include <linux/console.h>
 #include <linux/sysrq.h>
 
-#include <asm/system.h>
 #include <asm/io.h>
 #include <asm/irq.h>
 #include <asm/bitops.h>
diff --git a/arch/mn10300/kernel/mn10300-watchdog.c b/arch/mn10300/kernel/mn10300-watchdog.c
index a45f0c7..db64a71 100644
--- a/arch/mn10300/kernel/mn10300-watchdog.c
+++ b/arch/mn10300/kernel/mn10300-watchdog.c
@@ -18,7 +18,6 @@
 #include <linux/kernel_stat.h>
 #include <linux/nmi.h>
 #include <asm/processor.h>
-#include <asm/system.h>
 #include <linux/atomic.h>
 #include <asm/intctl-regs.h>
 #include <asm/rtc-regs.h>
diff --git a/arch/mn10300/kernel/process.c b/arch/mn10300/kernel/process.c
index 28eec31..906cd47 100644
--- a/arch/mn10300/kernel/process.c
+++ b/arch/mn10300/kernel/process.c
@@ -27,7 +27,6 @@
 #include <linux/slab.h>
 #include <asm/uaccess.h>
 #include <asm/pgtable.h>
-#include <asm/system.h>
 #include <asm/io.h>
 #include <asm/processor.h>
 #include <asm/mmu_context.h>
diff --git a/arch/mn10300/kernel/ptrace.c b/arch/mn10300/kernel/ptrace.c
index 5c0b07e..5bd5851 100644
--- a/arch/mn10300/kernel/ptrace.c
+++ b/arch/mn10300/kernel/ptrace.c
@@ -21,7 +21,6 @@
 #include <linux/tracehook.h>
 #include <asm/uaccess.h>
 #include <asm/pgtable.h>
-#include <asm/system.h>
 #include <asm/processor.h>
 #include <asm/cacheflush.h>
 #include <asm/fpu.h>
diff --git a/arch/mn10300/kernel/setup.c b/arch/mn10300/kernel/setup.c
index 9e7a320..33c3bd1 100644
--- a/arch/mn10300/kernel/setup.c
+++ b/arch/mn10300/kernel/setup.c
@@ -26,7 +26,6 @@
 #include <asm/processor.h>
 #include <linux/console.h>
 #include <asm/uaccess.h>
-#include <asm/system.h>
 #include <asm/setup.h>
 #include <asm/io.h>
 #include <asm/smp.h>
diff --git a/arch/mn10300/kernel/smp-low.S b/arch/mn10300/kernel/smp-low.S
index 72938ce..71f1b2f 100644
--- a/arch/mn10300/kernel/smp-low.S
+++ b/arch/mn10300/kernel/smp-low.S
@@ -13,9 +13,9 @@
 #include <linux/sys.h>
 #include <linux/linkage.h>
 #include <asm/smp.h>
-#include <asm/system.h>
 #include <asm/thread_info.h>
 #include <asm/cpu-regs.h>
+#include <asm/intctl-regs.h>
 #include <proc/smp-regs.h>
 #include <asm/asm-offsets.h>
 #include <asm/frame.inc>
diff --git a/arch/mn10300/kernel/smp.c b/arch/mn10300/kernel/smp.c
index 9242e9f..910dddf 100644
--- a/arch/mn10300/kernel/smp.c
+++ b/arch/mn10300/kernel/smp.c
@@ -25,7 +25,6 @@
 #include <linux/profile.h>
 #include <linux/smp.h>
 #include <asm/tlbflush.h>
-#include <asm/system.h>
 #include <asm/bitops.h>
 #include <asm/processor.h>
 #include <asm/bug.h>
diff --git a/arch/mn10300/kernel/traps.c b/arch/mn10300/kernel/traps.c
index 9220a75..94a9c6d 100644
--- a/arch/mn10300/kernel/traps.c
+++ b/arch/mn10300/kernel/traps.c
@@ -27,7 +27,6 @@
 #include <linux/bug.h>
 #include <linux/irq.h>
 #include <asm/processor.h>
-#include <asm/system.h>
 #include <linux/uaccess.h>
 #include <asm/io.h>
 #include <linux/atomic.h>
diff --git a/arch/mn10300/lib/bitops.c b/arch/mn10300/lib/bitops.c
index a66c6cd..37309cd 100644
--- a/arch/mn10300/lib/bitops.c
+++ b/arch/mn10300/lib/bitops.c
@@ -10,7 +10,6 @@
  */
 #include <linux/module.h>
 #include <asm/bitops.h>
-#include <asm/system.h>
 
 /*
  * try flipping a bit using BSET and BCLR
diff --git a/arch/mn10300/mm/fault.c b/arch/mn10300/mm/fault.c
index 0945409..90f346f 100644
--- a/arch/mn10300/mm/fault.c
+++ b/arch/mn10300/mm/fault.c
@@ -24,7 +24,6 @@
 #include <linux/init.h>
 #include <linux/vt_kern.h>		/* For unblank_screen() */
 
-#include <asm/system.h>
 #include <asm/uaccess.h>
 #include <asm/pgalloc.h>
 #include <asm/hardirq.h>
diff --git a/arch/mn10300/mm/init.c b/arch/mn10300/mm/init.c
index 1380182..e57e5bc 100644
--- a/arch/mn10300/mm/init.c
+++ b/arch/mn10300/mm/init.c
@@ -29,7 +29,6 @@
 #include <linux/gfp.h>
 
 #include <asm/processor.h>
-#include <asm/system.h>
 #include <asm/uaccess.h>
 #include <asm/pgtable.h>
 #include <asm/pgalloc.h>
diff --git a/arch/mn10300/mm/misalignment.c b/arch/mn10300/mm/misalignment.c
index f9bb8cb..b9920b1 100644
--- a/arch/mn10300/mm/misalignment.c
+++ b/arch/mn10300/mm/misalignment.c
@@ -23,7 +23,6 @@
 #include <linux/interrupt.h>
 #include <linux/pci.h>
 #include <asm/processor.h>
-#include <asm/system.h>
 #include <asm/uaccess.h>
 #include <asm/io.h>
 #include <linux/atomic.h>
diff --git a/arch/mn10300/mm/pgtable.c b/arch/mn10300/mm/pgtable.c
index 450f7ba..4ebf117 100644
--- a/arch/mn10300/mm/pgtable.c
+++ b/arch/mn10300/mm/pgtable.c
@@ -21,7 +21,6 @@
 #include <linux/spinlock.h>
 #include <linux/quicklist.h>
 
-#include <asm/system.h>
 #include <asm/pgtable.h>
 #include <asm/pgalloc.h>
 #include <asm/tlb.h>
diff --git a/arch/mn10300/mm/tlb-smp.c b/arch/mn10300/mm/tlb-smp.c
index 9a77749..3e57faf 100644
--- a/arch/mn10300/mm/tlb-smp.c
+++ b/arch/mn10300/mm/tlb-smp.c
@@ -24,7 +24,6 @@
 #include <linux/profile.h>
 #include <linux/smp.h>
 #include <asm/tlbflush.h>
-#include <asm/system.h>
 #include <asm/bitops.h>
 #include <asm/processor.h>
 #include <asm/bug.h>
diff --git a/arch/mn10300/proc-mn2ws0050/proc-init.c b/arch/mn10300/proc-mn2ws0050/proc-init.c
index fe6e249..ee6d03d 100644
--- a/arch/mn10300/proc-mn2ws0050/proc-init.c
+++ b/arch/mn10300/proc-mn2ws0050/proc-init.c
@@ -15,7 +15,6 @@
 #include <linux/interrupt.h>
 
 #include <asm/processor.h>
-#include <asm/system.h>
 #include <asm/uaccess.h>
 #include <asm/io.h>
 #include <linux/atomic.h>

