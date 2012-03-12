Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964892Ab2CLXlj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 19:41:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34311 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964965Ab2CLXle (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 19:41:34 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 31/35] Disintegrate asm/system.h for Xtensa [ver #2]
To: paul.gortmaker@windriver.com, hpa@zytor.com
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, arnd@arndb.de,
        David Howells <dhowells@redhat.com>, Chris Zankel <chris@zankel.net>
Date: Mon, 12 Mar 2012 23:41:21 +0000
Message-ID: <20120312234121.13888.82919.stgit@warthog.procyon.org.uk>
In-Reply-To: <20120312233602.13888.27659.stgit@warthog.procyon.org.uk>
References: <20120312233602.13888.27659.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Disintegrate asm/system.h for Xtensa.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Chris Zankel <chris@zankel.net>
---

 arch/xtensa/include/asm/atomic.h    |    2 
 arch/xtensa/include/asm/barrier.h   |   29 +++++
 arch/xtensa/include/asm/bitops.h    |    1 
 arch/xtensa/include/asm/cmpxchg.h   |  131 ++++++++++++++++++++++++
 arch/xtensa/include/asm/exec.h      |   14 +++
 arch/xtensa/include/asm/setup.h     |    2 
 arch/xtensa/include/asm/switch_to.h |   22 ++++
 arch/xtensa/include/asm/system.h    |  189 +----------------------------------
 arch/xtensa/include/asm/uaccess.h   |    2 
 arch/xtensa/kernel/process.c        |    1 
 arch/xtensa/kernel/ptrace.c         |    1 
 arch/xtensa/kernel/setup.c          |    1 
 arch/xtensa/kernel/traps.c          |   19 ++++
 arch/xtensa/mm/fault.c              |    1 
 arch/xtensa/mm/tlb.c                |    1 
 15 files changed, 225 insertions(+), 191 deletions(-)
 create mode 100644 arch/xtensa/include/asm/barrier.h
 create mode 100644 arch/xtensa/include/asm/cmpxchg.h
 create mode 100644 arch/xtensa/include/asm/exec.h
 create mode 100644 arch/xtensa/include/asm/switch_to.h

diff --git a/arch/xtensa/include/asm/atomic.h b/arch/xtensa/include/asm/atomic.h
index 23592ef..b409893 100644
--- a/arch/xtensa/include/asm/atomic.h
+++ b/arch/xtensa/include/asm/atomic.h
@@ -18,7 +18,7 @@
 
 #ifdef __KERNEL__
 #include <asm/processor.h>
-#include <asm/system.h>
+#include <asm/cmpxchg.h>
 
 #define ATOMIC_INIT(i)	{ (i) }
 
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
diff --git a/arch/xtensa/include/asm/bitops.h b/arch/xtensa/include/asm/bitops.h
index 40aa7fe..5270197 100644
--- a/arch/xtensa/include/asm/bitops.h
+++ b/arch/xtensa/include/asm/bitops.h
@@ -21,7 +21,6 @@
 
 #include <asm/processor.h>
 #include <asm/byteorder.h>
-#include <asm/system.h>
 
 #ifdef CONFIG_SMP
 # error SMP not supported on this architecture
diff --git a/arch/xtensa/include/asm/cmpxchg.h b/arch/xtensa/include/asm/cmpxchg.h
new file mode 100644
index 0000000..e321490
--- /dev/null
+++ b/arch/xtensa/include/asm/cmpxchg.h
@@ -0,0 +1,131 @@
+/*
+ * Atomic xchg and cmpxchg operations.
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License.  See the file "COPYING" in the main directory of this archive
+ * for more details.
+ *
+ * Copyright (C) 2001 - 2005 Tensilica Inc.
+ */
+
+#ifndef _XTENSA_CMPXCHG_H
+#define _XTENSA_CMPXCHG_H
+
+#ifndef __ASSEMBLY__
+
+#include <linux/stringify.h>
+
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
+#endif /* __ASSEMBLY__ */
+
+#endif /* _XTENSA_CMPXCHG_H */
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
index 1e7e09a..a7f4057 100644
--- a/arch/xtensa/include/asm/system.h
+++ b/arch/xtensa/include/asm/system.h
@@ -1,184 +1,5 @@
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
+/* FILE TO BE DELETED. DO NOT ADD STUFF HERE! */
+#include <asm/barrier.h>
+#include <asm/cmpxchg.h>
+#include <asm/exec.h>
+#include <asm/switch_to.h>
diff --git a/arch/xtensa/include/asm/uaccess.h b/arch/xtensa/include/asm/uaccess.h
index 3fa526f..6e4bb3b 100644
--- a/arch/xtensa/include/asm/uaccess.h
+++ b/arch/xtensa/include/asm/uaccess.h
@@ -17,7 +17,9 @@
 #define _XTENSA_UACCESS_H
 
 #include <linux/errno.h>
+#ifndef __ASSEMBLY__
 #include <linux/prefetch.h>
+#endif
 #include <asm/types.h>
 
 #define VERIFY_READ    0
diff --git a/arch/xtensa/kernel/process.c b/arch/xtensa/kernel/process.c
index 47041e7..c00c72c 100644
--- a/arch/xtensa/kernel/process.c
+++ b/arch/xtensa/kernel/process.c
@@ -34,7 +34,6 @@
 
 #include <asm/pgtable.h>
 #include <asm/uaccess.h>
-#include <asm/system.h>
 #include <asm/io.h>
 #include <asm/processor.h>
 #include <asm/platform.h>
diff --git a/arch/xtensa/kernel/ptrace.c b/arch/xtensa/kernel/ptrace.c
index 2dff698..33eea4c 100644
--- a/arch/xtensa/kernel/ptrace.c
+++ b/arch/xtensa/kernel/ptrace.c
@@ -24,7 +24,6 @@
 
 #include <asm/pgtable.h>
 #include <asm/page.h>
-#include <asm/system.h>
 #include <asm/uaccess.h>
 #include <asm/ptrace.h>
 #include <asm/elf.h>
diff --git a/arch/xtensa/kernel/setup.c b/arch/xtensa/kernel/setup.c
index 1e5a034..17e746f 100644
--- a/arch/xtensa/kernel/setup.c
+++ b/arch/xtensa/kernel/setup.c
@@ -34,7 +34,6 @@
 # include <linux/seq_file.h>
 #endif
 
-#include <asm/system.h>
 #include <asm/bootparam.h>
 #include <asm/pgtable.h>
 #include <asm/processor.h>
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
diff --git a/arch/xtensa/mm/fault.c b/arch/xtensa/mm/fault.c
index e367e30..b17885a 100644
--- a/arch/xtensa/mm/fault.c
+++ b/arch/xtensa/mm/fault.c
@@ -19,7 +19,6 @@
 #include <asm/cacheflush.h>
 #include <asm/hardirq.h>
 #include <asm/uaccess.h>
-#include <asm/system.h>
 #include <asm/pgalloc.h>
 
 unsigned long asid_cache = ASID_USER_FIRST;
diff --git a/arch/xtensa/mm/tlb.c b/arch/xtensa/mm/tlb.c
index 239461d..e2700b2 100644
--- a/arch/xtensa/mm/tlb.c
+++ b/arch/xtensa/mm/tlb.c
@@ -18,7 +18,6 @@
 #include <asm/processor.h>
 #include <asm/mmu_context.h>
 #include <asm/tlbflush.h>
-#include <asm/system.h>
 #include <asm/cacheflush.h>
 
 

