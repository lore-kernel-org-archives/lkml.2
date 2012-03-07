Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760104Ab2CGTsc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 14:48:32 -0500
Received: from mx1.redhat.com ([209.132.183.28]:40655 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760005Ab2CGTs2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 14:48:28 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 12/29] Disintegrate asm/system.h for Hexagon
To: paul.gortmaker@windriver.com, hpa@zytor.com
Cc: torvalds@linux-foundation.org, sfr@canb.auug.org.au, mingo@redhat.com,
        arnd@arndb.de, dhowells@redhat.com, tglx@linutronix.de,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Date: Wed, 07 Mar 2012 19:48:07 +0000
Message-ID: <20120307194807.15987.69116.stgit@warthog.procyon.org.uk>
In-Reply-To: <20120307194548.15987.36073.stgit@warthog.procyon.org.uk>
References: <20120307194548.15987.36073.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Disintegrate asm/system.h for Hexagon.  Not compiled.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 arch/hexagon/include/asm/atomic.h    |   79 +++++++++++++++++++--
 arch/hexagon/include/asm/barrier.h   |   41 +++++++++++
 arch/hexagon/include/asm/exec.h      |   28 ++++++++
 arch/hexagon/include/asm/switch_to.h |   34 +++++++++
 arch/hexagon/include/asm/system.h    |  126 ----------------------------------
 5 files changed, 175 insertions(+), 133 deletions(-)
 create mode 100644 arch/hexagon/include/asm/barrier.h
 create mode 100644 arch/hexagon/include/asm/exec.h
 create mode 100644 arch/hexagon/include/asm/switch_to.h
 delete mode 100644 arch/hexagon/include/asm/system.h

diff --git a/arch/hexagon/include/asm/atomic.h b/arch/hexagon/include/asm/atomic.h
index e220f90..d4b9c26 100644
--- a/arch/hexagon/include/asm/atomic.h
+++ b/arch/hexagon/include/asm/atomic.h
@@ -35,13 +35,6 @@
  */
 #define atomic_read(v)		((v)->counter)
 
-/**
- * atomic_xchg - atomic
- * @v: pointer to memory to change
- * @new: new value (technically passed in a register -- see xchg)
- */
-#define atomic_xchg(v, new)	(xchg(&((v)->counter), (new)))
-
 
 /**
  * atomic_cmpxchg - atomic compare-and-exchange values
@@ -161,4 +154,76 @@ static inline int __atomic_add_unless(atomic_t *v, int a, int u)
 #define atomic_inc_return(v) (atomic_add_return(1, v))
 #define atomic_dec_return(v) (atomic_sub_return(1, v))
 
+/*
+ * __xchg - atomically exchange a register and a memory location
+ * @x: value to swap
+ * @ptr: pointer to memory
+ * @size:  size of the value
+ *
+ * Only 4 bytes supported currently.
+ *
+ * Note:  there was an errata for V2 about .new's and memw_locked.
+ *
+ */
+static inline unsigned long __xchg(unsigned long x, volatile void *ptr,
+				   int size)
+{
+	unsigned long retval;
+
+	/*  Can't seem to use printk or panic here, so just stop  */
+	if (size != 4) do { asm volatile("brkpt;\n"); } while (1);
+
+	__asm__ __volatile__ (
+	"1:	%0 = memw_locked(%1);\n"    /*  load into retval */
+	"	memw_locked(%1,P0) = %2;\n" /*  store into memory */
+	"	if !P0 jump 1b;\n"
+	: "=&r" (retval)
+	: "r" (ptr), "r" (x)
+	: "memory", "p0"
+	);
+	return retval;
+}
+
+/*
+ * Atomically swap the contents of a register with memory.  Should be atomic
+ * between multiple CPU's and within interrupts on the same CPU.
+ */
+#define xchg(ptr, v) ((__typeof__(*(ptr)))__xchg((unsigned long)(v), (ptr), \
+	sizeof(*(ptr))))
+
+/**
+ * atomic_xchg - atomic
+ * @v: pointer to memory to change
+ * @new: new value (technically passed in a register -- see xchg)
+ */
+#define atomic_xchg(v, new)	(xchg(&((v)->counter), (new)))
+
+/*
+ *  see rt-mutex-design.txt; cmpxchg supposedly checks if *ptr == A and swaps.
+ *  looks just like atomic_cmpxchg on our arch currently with a bunch of
+ *  variable casting.
+ */
+#define __HAVE_ARCH_CMPXCHG 1
+
+#define cmpxchg(ptr, old, new)					\
+({								\
+	__typeof__(ptr) __ptr = (ptr);				\
+	__typeof__(*(ptr)) __old = (old);			\
+	__typeof__(*(ptr)) __new = (new);			\
+	__typeof__(*(ptr)) __oldval = 0;			\
+								\
+	asm volatile(						\
+		"1:	%0 = memw_locked(%1);\n"		\
+		"	{ P0 = cmp.eq(%0,%2);\n"		\
+		"	  if (!P0.new) jump:nt 2f; }\n"		\
+		"	memw_locked(%1,p0) = %3;\n"		\
+		"	if (!P0) jump 1b;\n"			\
+		"2:\n"						\
+		: "=&r" (__oldval)				\
+		: "r" (__ptr), "r" (__old), "r" (__new)		\
+		: "memory", "p0"				\
+	);							\
+	__oldval;						\
+})
+
 #endif
diff --git a/arch/hexagon/include/asm/barrier.h b/arch/hexagon/include/asm/barrier.h
new file mode 100644
index 0000000..a4ed6e2
--- /dev/null
+++ b/arch/hexagon/include/asm/barrier.h
@@ -0,0 +1,41 @@
+/*
+ * Memory barrier definitions for the Hexagon architecture
+ *
+ * Copyright (c) 2010-2011, Code Aurora Forum. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
+ * 02110-1301, USA.
+ */
+
+#ifndef _ASM_BARRIER_H
+#define _ASM_BARRIER_H
+
+#define rmb()				barrier()
+#define read_barrier_depends()		barrier()
+#define wmb()				barrier()
+#define mb()				barrier()
+#define smp_rmb()			barrier()
+#define smp_read_barrier_depends()	barrier()
+#define smp_wmb()			barrier()
+#define smp_mb()			barrier()
+#define smp_mb__before_atomic_dec()	barrier()
+#define smp_mb__after_atomic_dec()	barrier()
+#define smp_mb__before_atomic_inc()	barrier()
+#define smp_mb__after_atomic_inc()	barrier()
+
+/*  Set a value and use a memory barrier.  Used by the scheduler somewhere.  */
+#define set_mb(var, value) \
+	do { var = value; mb(); } while (0)
+
+#endif /* _ASM_BARRIER_H */
diff --git a/arch/hexagon/include/asm/exec.h b/arch/hexagon/include/asm/exec.h
new file mode 100644
index 0000000..350e6d4
--- /dev/null
+++ b/arch/hexagon/include/asm/exec.h
@@ -0,0 +1,28 @@
+/*
+ * Process execution related definitions for the Hexagon architecture
+ *
+ * Copyright (c) 2010-2011, Code Aurora Forum. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
+ * 02110-1301, USA.
+ */
+
+#ifndef _ASM_EXEC_H
+#define _ASM_EXEC_H
+
+/*  Should probably shoot for an 8-byte aligned stack pointer  */
+#define STACK_MASK (~7)
+#define arch_align_stack(x) (x & STACK_MASK)
+
+#endif /* _ASM_EXEC_H */
diff --git a/arch/hexagon/include/asm/switch_to.h b/arch/hexagon/include/asm/switch_to.h
new file mode 100644
index 0000000..28ca0df
--- /dev/null
+++ b/arch/hexagon/include/asm/switch_to.h
@@ -0,0 +1,34 @@
+/*
+ * Task switching definitions for the Hexagon architecture
+ *
+ * Copyright (c) 2010-2011, Code Aurora Forum. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
+ * 02110-1301, USA.
+ */
+
+#ifndef _ASM_SWITCH_TO_H
+#define _ASM_SWITCH_TO_H
+
+struct thread_struct;
+
+extern struct task_struct *__switch_to(struct task_struct *,
+	struct task_struct *,
+	struct task_struct *);
+
+#define switch_to(p, n, r) do {\
+	r = __switch_to((p), (n), (r));\
+} while (0)
+
+#endif /* _ASM_SWITCH_TO_H */
diff --git a/arch/hexagon/include/asm/system.h b/arch/hexagon/include/asm/system.h
deleted file mode 100644
index 323ed1d..0000000
--- a/arch/hexagon/include/asm/system.h
+++ /dev/null
@@ -1,126 +0,0 @@
-/*
- * System level definitions for the Hexagon architecture
- *
- * Copyright (c) 2010-2011, Code Aurora Forum. All rights reserved.
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 and
- * only version 2 as published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
- * 02110-1301, USA.
- */
-
-#ifndef _ASM_SYSTEM_H
-#define _ASM_SYSTEM_H
-
-#include <linux/linkage.h>
-#include <linux/irqflags.h>
-#include <asm/atomic.h>
-#include <asm/hexagon_vm.h>
-
-struct thread_struct;
-
-extern struct task_struct *__switch_to(struct task_struct *,
-	struct task_struct *,
-	struct task_struct *);
-
-#define switch_to(p, n, r) do {\
-	r = __switch_to((p), (n), (r));\
-} while (0)
-
-
-#define rmb()				barrier()
-#define read_barrier_depends()		barrier()
-#define wmb()				barrier()
-#define mb()				barrier()
-#define smp_rmb()			barrier()
-#define smp_read_barrier_depends()	barrier()
-#define smp_wmb()			barrier()
-#define smp_mb()			barrier()
-#define smp_mb__before_atomic_dec()	barrier()
-#define smp_mb__after_atomic_dec()	barrier()
-#define smp_mb__before_atomic_inc()	barrier()
-#define smp_mb__after_atomic_inc()	barrier()
-
-/*
- * __xchg - atomically exchange a register and a memory location
- * @x: value to swap
- * @ptr: pointer to memory
- * @size:  size of the value
- *
- * Only 4 bytes supported currently.
- *
- * Note:  there was an errata for V2 about .new's and memw_locked.
- *
- */
-static inline unsigned long __xchg(unsigned long x, volatile void *ptr,
-				   int size)
-{
-	unsigned long retval;
-
-	/*  Can't seem to use printk or panic here, so just stop  */
-	if (size != 4) do { asm volatile("brkpt;\n"); } while (1);
-
-	__asm__ __volatile__ (
-	"1:	%0 = memw_locked(%1);\n"    /*  load into retval */
-	"	memw_locked(%1,P0) = %2;\n" /*  store into memory */
-	"	if !P0 jump 1b;\n"
-	: "=&r" (retval)
-	: "r" (ptr), "r" (x)
-	: "memory", "p0"
-	);
-	return retval;
-}
-
-/*
- * Atomically swap the contents of a register with memory.  Should be atomic
- * between multiple CPU's and within interrupts on the same CPU.
- */
-#define xchg(ptr, v) ((__typeof__(*(ptr)))__xchg((unsigned long)(v), (ptr), \
-	sizeof(*(ptr))))
-
-/*  Set a value and use a memory barrier.  Used by the scheduler somewhere.  */
-#define set_mb(var, value) \
-	do { var = value; mb(); } while (0)
-
-/*
- *  see rt-mutex-design.txt; cmpxchg supposedly checks if *ptr == A and swaps.
- *  looks just like atomic_cmpxchg on our arch currently with a bunch of
- *  variable casting.
- */
-#define __HAVE_ARCH_CMPXCHG 1
-
-#define cmpxchg(ptr, old, new)					\
-({								\
-	__typeof__(ptr) __ptr = (ptr);				\
-	__typeof__(*(ptr)) __old = (old);			\
-	__typeof__(*(ptr)) __new = (new);			\
-	__typeof__(*(ptr)) __oldval = 0;			\
-								\
-	asm volatile(						\
-		"1:	%0 = memw_locked(%1);\n"		\
-		"	{ P0 = cmp.eq(%0,%2);\n"		\
-		"	  if (!P0.new) jump:nt 2f; }\n"		\
-		"	memw_locked(%1,p0) = %3;\n"		\
-		"	if (!P0) jump 1b;\n"			\
-		"2:\n"						\
-		: "=&r" (__oldval)				\
-		: "r" (__ptr), "r" (__old), "r" (__new)		\
-		: "memory", "p0"				\
-	);							\
-	__oldval;						\
-})
-
-/*  Should probably shoot for an 8-byte aligned stack pointer  */
-#define STACK_MASK (~7)
-#define arch_align_stack(x) (x & STACK_MASK)
-
-#endif

