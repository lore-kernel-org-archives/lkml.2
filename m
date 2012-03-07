Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030666Ab2CGTvm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 14:51:42 -0500
Received: from mx1.redhat.com ([209.132.183.28]:30424 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030623Ab2CGTvh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 14:51:37 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 29/29] Disintegrate asm/system.h for Xtensa
To: paul.gortmaker@windriver.com, hpa@zytor.com
Cc: torvalds@linux-foundation.org, sfr@canb.auug.org.au, mingo@redhat.com,
        arnd@arndb.de, dhowells@redhat.com, tglx@linutronix.de,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Date: Wed, 07 Mar 2012 19:51:20 +0000
Message-ID: <20120307195120.15987.78411.stgit@warthog.procyon.org.uk>
In-Reply-To: <20120307194548.15987.36073.stgit@warthog.procyon.org.uk>
References: <20120307194548.15987.36073.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Disintegrate asm/system.h for Xtensa.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 arch/xtensa/include/asm/atomic.h    |  111 +++++++++++++++++++++
 arch/xtensa/include/asm/barrier.h   |   29 ++++++
 arch/xtensa/include/asm/exec.h      |   14 +++
 arch/xtensa/include/asm/setup.h     |    2 
 arch/xtensa/include/asm/switch_to.h |   22 ++++
 arch/xtensa/include/asm/system.h    |  184 -----------------------------------
 arch/xtensa/kernel/traps.c          |   19 ++++
 7 files changed, 197 insertions(+), 184 deletions(-)
 create mode 100644 arch/xtensa/include/asm/barrier.h
 create mode 100644 arch/xtensa/include/asm/exec.h
 create mode 100644 arch/xtensa/include/asm/switch_to.h
 delete mode 100644 arch/xtensa/include/asm/system.h

diff --git a/arch/xtensa/include/asm/atomic.h b/arch/xtensa/include/asm/atomic.h
index 6f2e4da..f6cfe9a 100644
--- a/arch/xtensa/include/asm/atomic.h
+++ b/arch/xtensa/include/asm/atomic.h
@@ -220,6 +220,117 @@ static inline int atomic_sub_return(int i, atomic_t * v)
  */
 #define atomic_add_negative(i,v) (atomic_add_return((i),(v)) < 0)
 
+/*
+ * cmpxchg
+ */
+
+static inline unsigned long
+__cmpxchg_u32(volatile int *p, int old, int new)
+{
+  __asm__ __volatile__("rsil    a15, "__stringify(LOCKLEVEL)"\n\t"
+		       "l32i    %0, %1, 0              \n\t"
+		       "bne	%0, %2, 1f             \n\t"
+		       "s32i    %3, %1, 0              \n\t"
+		       "1:                             \n\t"
+		       "wsr     a15, "__stringify(PS)" \n\t"
+		       "rsync                          \n\t"
+		       : "=&a" (old)
+		       : "a" (p), "a" (old), "r" (new)
+		       : "a15", "memory");
+  return old;
+}
+/* This function doesn't exist, so you'll get a linker error
+ * if something tries to do an invalid cmpxchg(). */
+
+extern void __cmpxchg_called_with_bad_pointer(void);
+
+static __inline__ unsigned long
+__cmpxchg(volatile void *ptr, unsigned long old, unsigned long new, int size)
+{
+	switch (size) {
+	case 4:  return __cmpxchg_u32(ptr, old, new);
+	default: __cmpxchg_called_with_bad_pointer();
+		 return old;
+	}
+}
+
+#define cmpxchg(ptr,o,n)						      \
+	({ __typeof__(*(ptr)) _o_ = (o);				      \
+	   __typeof__(*(ptr)) _n_ = (n);				      \
+	   (__typeof__(*(ptr))) __cmpxchg((ptr), (unsigned long)_o_,	      \
+	   			        (unsigned long)_n_, sizeof (*(ptr))); \
+	})
+
+#include <asm-generic/cmpxchg-local.h>
+
+static inline unsigned long __cmpxchg_local(volatile void *ptr,
+				      unsigned long old,
+				      unsigned long new, int size)
+{
+	switch (size) {
+	case 4:
+		return __cmpxchg_u32(ptr, old, new);
+	default:
+		return __cmpxchg_local_generic(ptr, old, new, size);
+	}
+
+	return old;
+}
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
+/*
+ * xchg_u32
+ *
+ * Note that a15 is used here because the register allocation
+ * done by the compiler is not guaranteed and a window overflow
+ * may not occur between the rsil and wsr instructions. By using
+ * a15 in the rsil, the machine is guaranteed to be in a state
+ * where no register reference will cause an overflow.
+ */
+
+static inline unsigned long xchg_u32(volatile int * m, unsigned long val)
+{
+  unsigned long tmp;
+  __asm__ __volatile__("rsil    a15, "__stringify(LOCKLEVEL)"\n\t"
+		       "l32i    %0, %1, 0              \n\t"
+		       "s32i    %2, %1, 0              \n\t"
+		       "wsr     a15, "__stringify(PS)" \n\t"
+		       "rsync                          \n\t"
+		       : "=&a" (tmp)
+		       : "a" (m), "a" (val)
+		       : "a15", "memory");
+  return tmp;
+}
+
+#define xchg(ptr,x) ((__typeof__(*(ptr)))__xchg((unsigned long)(x),(ptr),sizeof(*(ptr))))
+
+/*
+ * This only works if the compiler isn't horribly bad at optimizing.
+ * gcc-2.5.8 reportedly can't handle this, but I define that one to
+ * be dead anyway.
+ */
+
+extern void __xchg_called_with_bad_pointer(void);
+
+static __inline__ unsigned long
+__xchg(unsigned long x, volatile void * ptr, int size)
+{
+	switch (size) {
+		case 4:
+			return xchg_u32(ptr, x);
+	}
+	__xchg_called_with_bad_pointer();
+	return x;
+}
+
 #define atomic_cmpxchg(v, o, n) ((int)cmpxchg(&((v)->counter), (o), (n)))
 #define atomic_xchg(v, new) (xchg(&((v)->counter), new))
 
diff --git a/arch/xtensa/include/asm/barrier.h b/arch/xtensa/include/asm/barrier.h
new file mode 100644
index 0000000..55707a8
--- /dev/null
+++ b/arch/xtensa/include/asm/barrier.h
@@ -0,0 +1,29 @@
+/*
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License.  See the file "COPYING" in the main directory of this archive
+ * for more details.
+ *
+ * Copyright (C) 2001 - 2005 Tensilica Inc.
+ */
+
+#ifndef _XTENSA_SYSTEM_H
+#define _XTENSA_SYSTEM_H
+
+#define smp_read_barrier_depends() do { } while(0)
+#define read_barrier_depends() do { } while(0)
+
+#define mb()  barrier()
+#define rmb() mb()
+#define wmb() mb()
+
+#ifdef CONFIG_SMP
+#error smp_* not defined
+#else
+#define smp_mb()	barrier()
+#define smp_rmb()	barrier()
+#define smp_wmb()	barrier()
+#endif
+
+#define set_mb(var, value)	do { var = value; mb(); } while (0)
+
+#endif /* _XTENSA_SYSTEM_H */
diff --git a/arch/xtensa/include/asm/exec.h b/arch/xtensa/include/asm/exec.h
new file mode 100644
index 0000000..af949e2
--- /dev/null
+++ b/arch/xtensa/include/asm/exec.h
@@ -0,0 +1,14 @@
+/*
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License.  See the file "COPYING" in the main directory of this archive
+ * for more details.
+ *
+ * Copyright (C) 2001 - 2005 Tensilica Inc.
+ */
+
+#ifndef _XTENSA_EXEC_H
+#define _XTENSA_EXEC_H
+
+#define arch_align_stack(x) (x)
+
+#endif /* _XTENSA_EXEC_H */
diff --git a/arch/xtensa/include/asm/setup.h b/arch/xtensa/include/asm/setup.h
index e363652..9fa8ad9 100644
--- a/arch/xtensa/include/asm/setup.h
+++ b/arch/xtensa/include/asm/setup.h
@@ -13,4 +13,6 @@
 
 #define COMMAND_LINE_SIZE	256
 
+extern void set_except_vector(int n, void *addr);
+
 #endif
diff --git a/arch/xtensa/include/asm/switch_to.h b/arch/xtensa/include/asm/switch_to.h
new file mode 100644
index 0000000..6b73bf0
--- /dev/null
+++ b/arch/xtensa/include/asm/switch_to.h
@@ -0,0 +1,22 @@
+/*
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License.  See the file "COPYING" in the main directory of this archive
+ * for more details.
+ *
+ * Copyright (C) 2001 - 2005 Tensilica Inc.
+ */
+
+#ifndef _XTENSA_SWITCH_TO_H
+#define _XTENSA_SWITCH_TO_H
+
+/* * switch_to(n) should switch tasks to task nr n, first
+ * checking that n isn't the current task, in which case it does nothing.
+ */
+extern void *_switch_to(void *last, void *next);
+
+#define switch_to(prev,next,last)		\
+do {						\
+	(last) = _switch_to(prev, next);	\
+} while(0)
+
+#endif /* _XTENSA_SWITCH_TO_H */
diff --git a/arch/xtensa/include/asm/system.h b/arch/xtensa/include/asm/system.h
deleted file mode 100644
index 1e7e09a..0000000
--- a/arch/xtensa/include/asm/system.h
+++ /dev/null
@@ -1,184 +0,0 @@
-/*
- * include/asm-xtensa/system.h
- *
- * This file is subject to the terms and conditions of the GNU General Public
- * License.  See the file "COPYING" in the main directory of this archive
- * for more details.
- *
- * Copyright (C) 2001 - 2005 Tensilica Inc.
- */
-
-#ifndef _XTENSA_SYSTEM_H
-#define _XTENSA_SYSTEM_H
-
-#include <linux/stringify.h>
-#include <linux/irqflags.h>
-
-#include <asm/processor.h>
-
-#define smp_read_barrier_depends() do { } while(0)
-#define read_barrier_depends() do { } while(0)
-
-#define mb()  barrier()
-#define rmb() mb()
-#define wmb() mb()
-
-#ifdef CONFIG_SMP
-#error smp_* not defined
-#else
-#define smp_mb()	barrier()
-#define smp_rmb()	barrier()
-#define smp_wmb()	barrier()
-#endif
-
-#define set_mb(var, value)	do { var = value; mb(); } while (0)
-
-#if !defined (__ASSEMBLY__)
-
-/* * switch_to(n) should switch tasks to task nr n, first
- * checking that n isn't the current task, in which case it does nothing.
- */
-extern void *_switch_to(void *last, void *next);
-
-#endif	/* __ASSEMBLY__ */
-
-#define switch_to(prev,next,last)		\
-do {						\
-	(last) = _switch_to(prev, next);	\
-} while(0)
-
-/*
- * cmpxchg
- */
-
-static inline unsigned long
-__cmpxchg_u32(volatile int *p, int old, int new)
-{
-  __asm__ __volatile__("rsil    a15, "__stringify(LOCKLEVEL)"\n\t"
-		       "l32i    %0, %1, 0              \n\t"
-		       "bne	%0, %2, 1f             \n\t"
-		       "s32i    %3, %1, 0              \n\t"
-		       "1:                             \n\t"
-		       "wsr     a15, "__stringify(PS)" \n\t"
-		       "rsync                          \n\t"
-		       : "=&a" (old)
-		       : "a" (p), "a" (old), "r" (new)
-		       : "a15", "memory");
-  return old;
-}
-/* This function doesn't exist, so you'll get a linker error
- * if something tries to do an invalid cmpxchg(). */
-
-extern void __cmpxchg_called_with_bad_pointer(void);
-
-static __inline__ unsigned long
-__cmpxchg(volatile void *ptr, unsigned long old, unsigned long new, int size)
-{
-	switch (size) {
-	case 4:  return __cmpxchg_u32(ptr, old, new);
-	default: __cmpxchg_called_with_bad_pointer();
-		 return old;
-	}
-}
-
-#define cmpxchg(ptr,o,n)						      \
-	({ __typeof__(*(ptr)) _o_ = (o);				      \
-	   __typeof__(*(ptr)) _n_ = (n);				      \
-	   (__typeof__(*(ptr))) __cmpxchg((ptr), (unsigned long)_o_,	      \
-	   			        (unsigned long)_n_, sizeof (*(ptr))); \
-	})
-
-#include <asm-generic/cmpxchg-local.h>
-
-static inline unsigned long __cmpxchg_local(volatile void *ptr,
-				      unsigned long old,
-				      unsigned long new, int size)
-{
-	switch (size) {
-	case 4:
-		return __cmpxchg_u32(ptr, old, new);
-	default:
-		return __cmpxchg_local_generic(ptr, old, new, size);
-	}
-
-	return old;
-}
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
-/*
- * xchg_u32
- *
- * Note that a15 is used here because the register allocation
- * done by the compiler is not guaranteed and a window overflow
- * may not occur between the rsil and wsr instructions. By using
- * a15 in the rsil, the machine is guaranteed to be in a state
- * where no register reference will cause an overflow.
- */
-
-static inline unsigned long xchg_u32(volatile int * m, unsigned long val)
-{
-  unsigned long tmp;
-  __asm__ __volatile__("rsil    a15, "__stringify(LOCKLEVEL)"\n\t"
-		       "l32i    %0, %1, 0              \n\t"
-		       "s32i    %2, %1, 0              \n\t"
-		       "wsr     a15, "__stringify(PS)" \n\t"
-		       "rsync                          \n\t"
-		       : "=&a" (tmp)
-		       : "a" (m), "a" (val)
-		       : "a15", "memory");
-  return tmp;
-}
-
-#define xchg(ptr,x) ((__typeof__(*(ptr)))__xchg((unsigned long)(x),(ptr),sizeof(*(ptr))))
-
-/*
- * This only works if the compiler isn't horribly bad at optimizing.
- * gcc-2.5.8 reportedly can't handle this, but I define that one to
- * be dead anyway.
- */
-
-extern void __xchg_called_with_bad_pointer(void);
-
-static __inline__ unsigned long
-__xchg(unsigned long x, volatile void * ptr, int size)
-{
-	switch (size) {
-		case 4:
-			return xchg_u32(ptr, x);
-	}
-	__xchg_called_with_bad_pointer();
-	return x;
-}
-
-extern void set_except_vector(int n, void *addr);
-
-static inline void spill_registers(void)
-{
-	unsigned int a0, ps;
-
-	__asm__ __volatile__ (
-		"movi	a14," __stringify (PS_EXCM_BIT) " | 1\n\t"
-		"mov	a12, a0\n\t"
-		"rsr	a13," __stringify(SAR) "\n\t"
-		"xsr	a14," __stringify(PS) "\n\t"
-		"movi	a0, _spill_registers\n\t"
-		"rsync\n\t"
-		"callx0 a0\n\t"
-		"mov	a0, a12\n\t"
-		"wsr	a13," __stringify(SAR) "\n\t"
-		"wsr	a14," __stringify(PS) "\n\t"
-		:: "a" (&a0), "a" (&ps)
-		: "a2", "a3", "a4", "a7", "a11", "a12", "a13", "a14", "a15", "memory");
-}
-
-#define arch_align_stack(x) (x)
-
-#endif	/* _XTENSA_SYSTEM_H */
diff --git a/arch/xtensa/kernel/traps.c b/arch/xtensa/kernel/traps.c
index e64efac..bc1e14c 100644
--- a/arch/xtensa/kernel/traps.c
+++ b/arch/xtensa/kernel/traps.c
@@ -381,6 +381,25 @@ static __always_inline unsigned long *stack_pointer(struct task_struct *task)
 	return sp;
 }
 
+static inline void spill_registers(void)
+{
+	unsigned int a0, ps;
+
+	__asm__ __volatile__ (
+		"movi	a14," __stringify (PS_EXCM_BIT) " | 1\n\t"
+		"mov	a12, a0\n\t"
+		"rsr	a13," __stringify(SAR) "\n\t"
+		"xsr	a14," __stringify(PS) "\n\t"
+		"movi	a0, _spill_registers\n\t"
+		"rsync\n\t"
+		"callx0 a0\n\t"
+		"mov	a0, a12\n\t"
+		"wsr	a13," __stringify(SAR) "\n\t"
+		"wsr	a14," __stringify(PS) "\n\t"
+		:: "a" (&a0), "a" (&ps)
+		: "a2", "a3", "a4", "a7", "a11", "a12", "a13", "a14", "a15", "memory");
+}
+
 void show_trace(struct task_struct *task, unsigned long *sp)
 {
 	unsigned long a0, a1, pc;

