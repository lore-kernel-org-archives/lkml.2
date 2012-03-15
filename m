Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161592Ab2COU5c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 16:57:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36141 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161544Ab2COU51 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 16:57:27 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 13/38] Disintegrate asm/system.h for Hexagon [ver #3]
To: paul.gortmaker@windriver.com
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org, arnd@arndb.de,
        David Howells <dhowells@redhat.com>, Richard Kuo <rkuo@codeaurora.org>,
        linux-hexagon@vger.kernel.org
Date: Thu, 15 Mar 2012 20:57:17 +0000
Message-ID: <20120315205717.28759.91092.stgit@warthog.procyon.org.uk>
In-Reply-To: <20120315205514.28759.58969.stgit@warthog.procyon.org.uk>
References: <20120315205514.28759.58969.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Disintegrate asm/system.h for Hexagon.  Not compiled.

Signed-off-by: David Howells <dhowells@redhat.com>
Acked-by: Richard Kuo <rkuo@codeaurora.org>
cc: linux-hexagon@vger.kernel.org
---

 arch/hexagon/include/asm/atomic.h    |    1 
 arch/hexagon/include/asm/barrier.h   |   41 +++++++++++
 arch/hexagon/include/asm/bitops.h    |    1 
 arch/hexagon/include/asm/cmpxchg.h   |   90 +++++++++++++++++++++++
 arch/hexagon/include/asm/exec.h      |   28 +++++++
 arch/hexagon/include/asm/switch_to.h |   34 +++++++++
 arch/hexagon/include/asm/system.h    |  131 +---------------------------------
 arch/hexagon/kernel/ptrace.c         |    1 
 arch/hexagon/kernel/smp.c            |    1 
 arch/hexagon/kernel/vm_events.c      |    1 
 10 files changed, 199 insertions(+), 130 deletions(-)
 create mode 100644 arch/hexagon/include/asm/barrier.h
 create mode 100644 arch/hexagon/include/asm/cmpxchg.h
 create mode 100644 arch/hexagon/include/asm/exec.h
 create mode 100644 arch/hexagon/include/asm/switch_to.h

diff --git a/arch/hexagon/include/asm/atomic.h b/arch/hexagon/include/asm/atomic.h
index e220f90..3e25804 100644
--- a/arch/hexagon/include/asm/atomic.h
+++ b/arch/hexagon/include/asm/atomic.h
@@ -23,6 +23,7 @@
 #define _ASM_ATOMIC_H
 
 #include <linux/types.h>
+#include <asm/cmpxchg.h>
 
 #define ATOMIC_INIT(i)		{ (i) }
 #define atomic_set(v, i)	((v)->counter = (i))
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
diff --git a/arch/hexagon/include/asm/bitops.h b/arch/hexagon/include/asm/bitops.h
index d23461e..4caa649 100644
--- a/arch/hexagon/include/asm/bitops.h
+++ b/arch/hexagon/include/asm/bitops.h
@@ -24,7 +24,6 @@
 
 #include <linux/compiler.h>
 #include <asm/byteorder.h>
-#include <asm/system.h>
 #include <asm/atomic.h>
 
 #ifdef __KERNEL__
diff --git a/arch/hexagon/include/asm/cmpxchg.h b/arch/hexagon/include/asm/cmpxchg.h
new file mode 100644
index 0000000..c5f9527
--- /dev/null
+++ b/arch/hexagon/include/asm/cmpxchg.h
@@ -0,0 +1,90 @@
+/*
+ * xchg/cmpxchg operations for the Hexagon architecture
+ *
+ * Copyright (c) 2010-2011, Code Aurora Forum. All rights reserved.
+ *
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
+#ifndef _ASM_CMPXCHG_H
+#define _ASM_CMPXCHG_H
+
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
+#endif /* _ASM_CMPXCHG_H */
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
index 323ed1d..a7f4057 100644
--- a/arch/hexagon/include/asm/system.h
+++ b/arch/hexagon/include/asm/system.h
@@ -1,126 +1,5 @@
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
+/* FILE TO BE DELETED. DO NOT ADD STUFF HERE! */
+#include <asm/barrier.h>
+#include <asm/cmpxchg.h>
+#include <asm/exec.h>
+#include <asm/switch_to.h>
diff --git a/arch/hexagon/kernel/ptrace.c b/arch/hexagon/kernel/ptrace.c
index bea3f08..32342de 100644
--- a/arch/hexagon/kernel/ptrace.c
+++ b/arch/hexagon/kernel/ptrace.c
@@ -29,7 +29,6 @@
 #include <linux/regset.h>
 #include <linux/user.h>
 
-#include <asm/system.h>
 #include <asm/user.h>
 
 static int genregs_get(struct task_struct *target,
diff --git a/arch/hexagon/kernel/smp.c b/arch/hexagon/kernel/smp.c
index c871a2c..96ceec6 100644
--- a/arch/hexagon/kernel/smp.c
+++ b/arch/hexagon/kernel/smp.c
@@ -29,7 +29,6 @@
 #include <linux/smp.h>
 #include <linux/spinlock.h>
 
-#include <asm/system.h>  /*  xchg  */
 #include <asm/time.h>    /*  timer_interrupt  */
 #include <asm/hexagon_vm.h>
 
diff --git a/arch/hexagon/kernel/vm_events.c b/arch/hexagon/kernel/vm_events.c
index 986a081..591fc1b 100644
--- a/arch/hexagon/kernel/vm_events.c
+++ b/arch/hexagon/kernel/vm_events.c
@@ -22,7 +22,6 @@
 #include <asm/registers.h>
 #include <linux/irq.h>
 #include <linux/hardirq.h>
-#include <asm/system.h>
 
 /*
  * show_regs - print pt_regs structure

