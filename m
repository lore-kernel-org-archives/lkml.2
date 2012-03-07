Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030357Ab2CGTtj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 14:49:39 -0500
Received: from mx1.redhat.com ([209.132.183.28]:21270 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030250Ab2CGTte (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 14:49:34 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 18/29] Disintegrate asm/system.h for MN10300
To: paul.gortmaker@windriver.com, hpa@zytor.com
Cc: torvalds@linux-foundation.org, sfr@canb.auug.org.au, mingo@redhat.com,
        arnd@arndb.de, dhowells@redhat.com, tglx@linutronix.de,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Date: Wed, 07 Mar 2012 19:49:15 +0000
Message-ID: <20120307194915.15987.59544.stgit@warthog.procyon.org.uk>
In-Reply-To: <20120307194548.15987.36073.stgit@warthog.procyon.org.uk>
References: <20120307194548.15987.36073.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Disintegrate asm/system.h for MN10300.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 arch/mn10300/include/asm/barrier.h   |   35 ++++++++++++
 arch/mn10300/include/asm/exec.h      |   16 +++++
 arch/mn10300/include/asm/switch_to.h |   49 ++++++++++++++++
 arch/mn10300/include/asm/system.h    |  102 ----------------------------------
 arch/mn10300/kernel/smp-low.S        |    1 
 5 files changed, 101 insertions(+), 102 deletions(-)
 create mode 100644 arch/mn10300/include/asm/barrier.h
 create mode 100644 arch/mn10300/include/asm/exec.h
 create mode 100644 arch/mn10300/include/asm/switch_to.h
 delete mode 100644 arch/mn10300/include/asm/system.h

diff --git a/arch/mn10300/include/asm/barrier.h b/arch/mn10300/include/asm/barrier.h
new file mode 100644
index 0000000..9f2e160
--- /dev/null
+++ b/arch/mn10300/include/asm/barrier.h
@@ -0,0 +1,35 @@
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
deleted file mode 100644
index 94b4c5e..0000000
--- a/arch/mn10300/include/asm/system.h
+++ /dev/null
@@ -1,102 +0,0 @@
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
diff --git a/arch/mn10300/kernel/smp-low.S b/arch/mn10300/kernel/smp-low.S
index f1845e9..71f1b2f 100644
--- a/arch/mn10300/kernel/smp-low.S
+++ b/arch/mn10300/kernel/smp-low.S
@@ -15,6 +15,7 @@
 #include <asm/smp.h>
 #include <asm/thread_info.h>
 #include <asm/cpu-regs.h>
+#include <asm/intctl-regs.h>
 #include <proc/smp-regs.h>
 #include <asm/asm-offsets.h>
 #include <asm/frame.inc>

