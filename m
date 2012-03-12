Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964784Ab2CLXhn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 19:37:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28072 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932234Ab2CLXhi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 19:37:38 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 08/35] Disintegrate asm/system.h for FRV [ver #2]
To: paul.gortmaker@windriver.com, hpa@zytor.com
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, arnd@arndb.de,
        David Howells <dhowells@redhat.com>
Date: Mon, 12 Mar 2012 23:37:28 +0000
Message-ID: <20120312233728.13888.42284.stgit@warthog.procyon.org.uk>
In-Reply-To: <20120312233602.13888.27659.stgit@warthog.procyon.org.uk>
References: <20120312233602.13888.27659.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Disintegrate asm/system.h for FRV.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 arch/frv/include/asm/atomic.h    |   57 -------------
 arch/frv/include/asm/barrier.h   |   29 ++++++
 arch/frv/include/asm/bug.h       |    2 
 arch/frv/include/asm/cmpxchg.h   |  172 ++++++++++++++++++++++++++++++++++++++
 arch/frv/include/asm/exec.h      |   17 ++++
 arch/frv/include/asm/switch_to.h |   35 ++++++++
 arch/frv/include/asm/system.h    |  162 +-----------------------------------
 arch/frv/kernel/debug-stub.c     |    1 
 arch/frv/kernel/gdb-io.c         |    1 
 arch/frv/kernel/gdb-stub.c       |    1 
 arch/frv/kernel/irq-mb93091.c    |    1 
 arch/frv/kernel/irq-mb93093.c    |    1 
 arch/frv/kernel/irq-mb93493.c    |    1 
 arch/frv/kernel/irq.c            |    1 
 arch/frv/kernel/process.c        |    1 
 arch/frv/kernel/ptrace.c         |    1 
 arch/frv/kernel/traps.c          |    1 
 arch/frv/mm/fault.c              |    1 
 arch/frv/mm/init.c               |    1 
 arch/frv/mm/kmap.c               |    1 
 20 files changed, 261 insertions(+), 226 deletions(-)
 create mode 100644 arch/frv/include/asm/barrier.h
 create mode 100644 arch/frv/include/asm/cmpxchg.h
 create mode 100644 arch/frv/include/asm/exec.h
 create mode 100644 arch/frv/include/asm/switch_to.h

diff --git a/arch/frv/include/asm/atomic.h b/arch/frv/include/asm/atomic.h
index 0d8a7d6..b86329d 100644
--- a/arch/frv/include/asm/atomic.h
+++ b/arch/frv/include/asm/atomic.h
@@ -16,7 +16,7 @@
 
 #include <linux/types.h>
 #include <asm/spr-regs.h>
-#include <asm/system.h>
+#include <asm/cmpxchg.h>
 
 #ifdef CONFIG_SMP
 #error not SMP safe
@@ -181,61 +181,6 @@ static inline void atomic64_dec(atomic64_t *v)
 #define atomic64_dec_and_test(v)	(atomic64_dec_return((v)) == 0)
 #define atomic64_inc_and_test(v)	(atomic64_inc_return((v)) == 0)
 
-/*****************************************************************************/
-/*
- * exchange value with memory
- */
-extern uint64_t __xchg_64(uint64_t i, volatile void *v);
-
-#ifndef CONFIG_FRV_OUTOFLINE_ATOMIC_OPS
-
-#define xchg(ptr, x)								\
-({										\
-	__typeof__(ptr) __xg_ptr = (ptr);					\
-	__typeof__(*(ptr)) __xg_orig;						\
-										\
-	switch (sizeof(__xg_orig)) {						\
-	case 4:									\
-		asm volatile(							\
-			"swap%I0 %M0,%1"					\
-			: "+m"(*__xg_ptr), "=r"(__xg_orig)			\
-			: "1"(x)						\
-			: "memory"						\
-			);							\
-		break;								\
-										\
-	default:								\
-		__xg_orig = (__typeof__(__xg_orig))0;				\
-		asm volatile("break");						\
-		break;								\
-	}									\
-										\
-	__xg_orig;								\
-})
-
-#else
-
-extern uint32_t __xchg_32(uint32_t i, volatile void *v);
-
-#define xchg(ptr, x)										\
-({												\
-	__typeof__(ptr) __xg_ptr = (ptr);							\
-	__typeof__(*(ptr)) __xg_orig;								\
-												\
-	switch (sizeof(__xg_orig)) {								\
-	case 4: __xg_orig = (__typeof__(*(ptr))) __xchg_32((uint32_t) x, __xg_ptr);	break;	\
-	default:										\
-		__xg_orig = (__typeof__(__xg_orig))0;									\
-		asm volatile("break");								\
-		break;										\
-	}											\
-	__xg_orig;										\
-})
-
-#endif
-
-#define tas(ptr) (xchg((ptr), 1))
-
 #define atomic_cmpxchg(v, old, new)	(cmpxchg(&(v)->counter, old, new))
 #define atomic_xchg(v, new)		(xchg(&(v)->counter, new))
 #define atomic64_cmpxchg(v, old, new)	(__cmpxchg_64(old, new, &(v)->counter))
diff --git a/arch/frv/include/asm/barrier.h b/arch/frv/include/asm/barrier.h
new file mode 100644
index 0000000..06776ad
--- /dev/null
+++ b/arch/frv/include/asm/barrier.h
@@ -0,0 +1,29 @@
+/* FR-V CPU memory barrier definitions
+ *
+ * Copyright (C) 2003 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ */
+
+#ifndef _ASM_BARRIER_H
+#define _ASM_BARRIER_H
+
+#define nop()			asm volatile ("nop"::)
+
+#define mb()			asm volatile ("membar" : : :"memory")
+#define rmb()			asm volatile ("membar" : : :"memory")
+#define wmb()			asm volatile ("membar" : : :"memory")
+#define read_barrier_depends()	do { } while (0)
+
+#define smp_mb()			barrier()
+#define smp_rmb()			barrier()
+#define smp_wmb()			barrier()
+#define smp_read_barrier_depends()	do {} while(0)
+#define set_mb(var, value) \
+	do { var = (value); barrier(); } while (0)
+
+#endif /* _ASM_BARRIER_H */
diff --git a/arch/frv/include/asm/bug.h b/arch/frv/include/asm/bug.h
index 2e05450..dd01bcf 100644
--- a/arch/frv/include/asm/bug.h
+++ b/arch/frv/include/asm/bug.h
@@ -51,4 +51,6 @@ do {						\
 
 #include <asm-generic/bug.h>
 
+extern void die_if_kernel(const char *, ...) __attribute__((format(printf, 1, 2)));
+
 #endif
diff --git a/arch/frv/include/asm/cmpxchg.h b/arch/frv/include/asm/cmpxchg.h
new file mode 100644
index 0000000..5b04dd0
--- /dev/null
+++ b/arch/frv/include/asm/cmpxchg.h
@@ -0,0 +1,172 @@
+/* xchg and cmpxchg operation emulation for FR-V
+ *
+ * For an explanation of how atomic ops work in this arch, see:
+ *   Documentation/frv/atomic-ops.txt
+ *
+ * Copyright (C) 2004 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ */
+#ifndef _ASM_CMPXCHG_H
+#define _ASM_CMPXCHG_H
+
+#include <linux/types.h>
+
+/*****************************************************************************/
+/*
+ * exchange value with memory
+ */
+extern uint64_t __xchg_64(uint64_t i, volatile void *v);
+
+#ifndef CONFIG_FRV_OUTOFLINE_ATOMIC_OPS
+
+#define xchg(ptr, x)								\
+({										\
+	__typeof__(ptr) __xg_ptr = (ptr);					\
+	__typeof__(*(ptr)) __xg_orig;						\
+										\
+	switch (sizeof(__xg_orig)) {						\
+	case 4:									\
+		asm volatile(							\
+			"swap%I0 %M0,%1"					\
+			: "+m"(*__xg_ptr), "=r"(__xg_orig)			\
+			: "1"(x)						\
+			: "memory"						\
+			);							\
+		break;								\
+										\
+	default:								\
+		__xg_orig = (__typeof__(__xg_orig))0;				\
+		asm volatile("break");						\
+		break;								\
+	}									\
+										\
+	__xg_orig;								\
+})
+
+#else
+
+extern uint32_t __xchg_32(uint32_t i, volatile void *v);
+
+#define xchg(ptr, x)										\
+({												\
+	__typeof__(ptr) __xg_ptr = (ptr);							\
+	__typeof__(*(ptr)) __xg_orig;								\
+												\
+	switch (sizeof(__xg_orig)) {								\
+	case 4: __xg_orig = (__typeof__(*(ptr))) __xchg_32((uint32_t) x, __xg_ptr);	break;	\
+	default:										\
+		__xg_orig = (__typeof__(__xg_orig))0;									\
+		asm volatile("break");								\
+		break;										\
+	}											\
+	__xg_orig;										\
+})
+
+#endif
+
+#define tas(ptr) (xchg((ptr), 1))
+
+/*****************************************************************************/
+/*
+ * compare and conditionally exchange value with memory
+ * - if (*ptr == test) then orig = *ptr; *ptr = test;
+ * - if (*ptr != test) then orig = *ptr;
+ */
+extern uint64_t __cmpxchg_64(uint64_t test, uint64_t new, volatile uint64_t *v);
+
+#ifndef CONFIG_FRV_OUTOFLINE_ATOMIC_OPS
+
+#define cmpxchg(ptr, test, new)							\
+({										\
+	__typeof__(ptr) __xg_ptr = (ptr);					\
+	__typeof__(*(ptr)) __xg_orig, __xg_tmp;					\
+	__typeof__(*(ptr)) __xg_test = (test);					\
+	__typeof__(*(ptr)) __xg_new = (new);					\
+										\
+	switch (sizeof(__xg_orig)) {						\
+	case 4:									\
+		asm volatile(							\
+			"0:						\n"	\
+			"	orcc		gr0,gr0,gr0,icc3	\n"	\
+			"	ckeq		icc3,cc7		\n"	\
+			"	ld.p		%M0,%1			\n"	\
+			"	orcr		cc7,cc7,cc3		\n"	\
+			"	sub%I4cc	%1,%4,%2,icc0		\n"	\
+			"	bne		icc0,#0,1f		\n"	\
+			"	cst.p		%3,%M0		,cc3,#1	\n"	\
+			"	corcc		gr29,gr29,gr0	,cc3,#1	\n"	\
+			"	beq		icc3,#0,0b		\n"	\
+			"1:						\n"	\
+			: "+U"(*__xg_ptr), "=&r"(__xg_orig), "=&r"(__xg_tmp)	\
+			: "r"(__xg_new), "NPr"(__xg_test)			\
+			: "memory", "cc7", "cc3", "icc3", "icc0"		\
+			);							\
+		break;								\
+										\
+	default:								\
+		__xg_orig = (__typeof__(__xg_orig))0;				\
+		asm volatile("break");						\
+		break;								\
+	}									\
+										\
+	__xg_orig;								\
+})
+
+#else
+
+extern uint32_t __cmpxchg_32(uint32_t *v, uint32_t test, uint32_t new);
+
+#define cmpxchg(ptr, test, new)							\
+({										\
+	__typeof__(ptr) __xg_ptr = (ptr);					\
+	__typeof__(*(ptr)) __xg_orig;						\
+	__typeof__(*(ptr)) __xg_test = (test);					\
+	__typeof__(*(ptr)) __xg_new = (new);					\
+										\
+	switch (sizeof(__xg_orig)) {						\
+	case 4: __xg_orig = (__force __typeof__(*ptr))				\
+			__cmpxchg_32((__force uint32_t *)__xg_ptr,		\
+					 (__force uint32_t)__xg_test,		\
+					 (__force uint32_t)__xg_new); break;	\
+	default:								\
+		__xg_orig = (__typeof__(__xg_orig))0;				\
+		asm volatile("break");						\
+		break;								\
+	}									\
+										\
+	__xg_orig;								\
+})
+
+#endif
+
+#include <asm-generic/cmpxchg-local.h>
+
+static inline unsigned long __cmpxchg_local(volatile void *ptr,
+				      unsigned long old,
+				      unsigned long new, int size)
+{
+	switch (size) {
+	case 4:
+		return cmpxchg((unsigned long *)ptr, old, new);
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
+#define cmpxchg_local(ptr, o, n)				  	\
+	((__typeof__(*(ptr)))__cmpxchg_local((ptr), (unsigned long)(o),	\
+			(unsigned long)(n), sizeof(*(ptr))))
+#define cmpxchg64_local(ptr, o, n) __cmpxchg64_local_generic((ptr), (o), (n))
+
+#endif /* _ASM_CMPXCHG_H */
diff --git a/arch/frv/include/asm/exec.h b/arch/frv/include/asm/exec.h
new file mode 100644
index 0000000..65c9130
--- /dev/null
+++ b/arch/frv/include/asm/exec.h
@@ -0,0 +1,17 @@
+/* FR-V CPU executable handling
+ *
+ * Copyright (C) 2003 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ */
+
+#ifndef _ASM_EXEC_H
+#define _ASM_EXEC_H
+
+#define arch_align_stack(x) (x)
+
+#endif /* _ASM_EXEC_H */
diff --git a/arch/frv/include/asm/switch_to.h b/arch/frv/include/asm/switch_to.h
new file mode 100644
index 0000000..2cf0f6a
--- /dev/null
+++ b/arch/frv/include/asm/switch_to.h
@@ -0,0 +1,35 @@
+/* FR-V CPU basic task switching
+ *
+ * Copyright (C) 2003 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ */
+
+#ifndef _ASM_SWITCH_TO_H
+#define _ASM_SWITCH_TO_H
+
+#include <linux/thread_info.h>
+
+/*
+ * switch_to(prev, next) should switch from task `prev' to `next'
+ * `prev' will never be the same as `next'.
+ * The `mb' is to tell GCC not to cache `current' across this call.
+ */
+extern asmlinkage
+struct task_struct *__switch_to(struct thread_struct *prev_thread,
+				struct thread_struct *next_thread,
+				struct task_struct *prev);
+
+#define switch_to(prev, next, last)					\
+do {									\
+	(prev)->thread.sched_lr =					\
+		(unsigned long) __builtin_return_address(0);		\
+	(last) = __switch_to(&(prev)->thread, &(next)->thread, (prev));	\
+	mb();								\
+} while(0)
+
+#endif /* _ASM_SWITCH_TO_H */
diff --git a/arch/frv/include/asm/system.h b/arch/frv/include/asm/system.h
index 6c10fd2..5c707a2 100644
--- a/arch/frv/include/asm/system.h
+++ b/arch/frv/include/asm/system.h
@@ -1,158 +1,6 @@
-/* system.h: FR-V CPU control definitions
- *
- * Copyright (C) 2003 Red Hat, Inc. All Rights Reserved.
- * Written by David Howells (dhowells@redhat.com)
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License
- * as published by the Free Software Foundation; either version
- * 2 of the License, or (at your option) any later version.
- */
-
-#ifndef _ASM_SYSTEM_H
-#define _ASM_SYSTEM_H
-
-#include <linux/types.h>
-#include <linux/linkage.h>
-#include <linux/kernel.h>
-
-struct thread_struct;
-
-/*
- * switch_to(prev, next) should switch from task `prev' to `next'
- * `prev' will never be the same as `next'.
- * The `mb' is to tell GCC not to cache `current' across this call.
- */
-extern asmlinkage
-struct task_struct *__switch_to(struct thread_struct *prev_thread,
-				struct thread_struct *next_thread,
-				struct task_struct *prev);
-
-#define switch_to(prev, next, last)					\
-do {									\
-	(prev)->thread.sched_lr =					\
-		(unsigned long) __builtin_return_address(0);		\
-	(last) = __switch_to(&(prev)->thread, &(next)->thread, (prev));	\
-	mb();								\
-} while(0)
-
-/*
- * Force strict CPU ordering.
- */
-#define nop()			asm volatile ("nop"::)
-#define mb()			asm volatile ("membar" : : :"memory")
-#define rmb()			asm volatile ("membar" : : :"memory")
-#define wmb()			asm volatile ("membar" : : :"memory")
-#define read_barrier_depends()	do { } while (0)
-
-#define smp_mb()			barrier()
-#define smp_rmb()			barrier()
-#define smp_wmb()			barrier()
-#define smp_read_barrier_depends()	do {} while(0)
-#define set_mb(var, value) \
-	do { var = (value); barrier(); } while (0)
-
-extern void die_if_kernel(const char *, ...) __attribute__((format(printf, 1, 2)));
+/* FILE TO BE DELETED. DO NOT ADD STUFF HERE! */
+#include <asm/barrier.h>
+#include <asm/cmpxchg.h>
+#include <asm/exec.h>
+#include <asm/switch_to.h>
 extern void free_initmem(void);
-
-#define arch_align_stack(x) (x)
-
-/*****************************************************************************/
-/*
- * compare and conditionally exchange value with memory
- * - if (*ptr == test) then orig = *ptr; *ptr = test;
- * - if (*ptr != test) then orig = *ptr;
- */
-extern uint64_t __cmpxchg_64(uint64_t test, uint64_t new, volatile uint64_t *v);
-
-#ifndef CONFIG_FRV_OUTOFLINE_ATOMIC_OPS
-
-#define cmpxchg(ptr, test, new)							\
-({										\
-	__typeof__(ptr) __xg_ptr = (ptr);					\
-	__typeof__(*(ptr)) __xg_orig, __xg_tmp;					\
-	__typeof__(*(ptr)) __xg_test = (test);					\
-	__typeof__(*(ptr)) __xg_new = (new);					\
-										\
-	switch (sizeof(__xg_orig)) {						\
-	case 4:									\
-		asm volatile(							\
-			"0:						\n"	\
-			"	orcc		gr0,gr0,gr0,icc3	\n"	\
-			"	ckeq		icc3,cc7		\n"	\
-			"	ld.p		%M0,%1			\n"	\
-			"	orcr		cc7,cc7,cc3		\n"	\
-			"	sub%I4cc	%1,%4,%2,icc0		\n"	\
-			"	bne		icc0,#0,1f		\n"	\
-			"	cst.p		%3,%M0		,cc3,#1	\n"	\
-			"	corcc		gr29,gr29,gr0	,cc3,#1	\n"	\
-			"	beq		icc3,#0,0b		\n"	\
-			"1:						\n"	\
-			: "+U"(*__xg_ptr), "=&r"(__xg_orig), "=&r"(__xg_tmp)	\
-			: "r"(__xg_new), "NPr"(__xg_test)			\
-			: "memory", "cc7", "cc3", "icc3", "icc0"		\
-			);							\
-		break;								\
-										\
-	default:								\
-		__xg_orig = (__typeof__(__xg_orig))0;				\
-		asm volatile("break");						\
-		break;								\
-	}									\
-										\
-	__xg_orig;								\
-})
-
-#else
-
-extern uint32_t __cmpxchg_32(uint32_t *v, uint32_t test, uint32_t new);
-
-#define cmpxchg(ptr, test, new)							\
-({										\
-	__typeof__(ptr) __xg_ptr = (ptr);					\
-	__typeof__(*(ptr)) __xg_orig;						\
-	__typeof__(*(ptr)) __xg_test = (test);					\
-	__typeof__(*(ptr)) __xg_new = (new);					\
-										\
-	switch (sizeof(__xg_orig)) {						\
-	case 4: __xg_orig = (__force __typeof__(*ptr))				\
-			__cmpxchg_32((__force uint32_t *)__xg_ptr,		\
-					 (__force uint32_t)__xg_test,		\
-					 (__force uint32_t)__xg_new); break;	\
-	default:								\
-		__xg_orig = (__typeof__(__xg_orig))0;				\
-		asm volatile("break");						\
-		break;								\
-	}									\
-										\
-	__xg_orig;								\
-})
-
-#endif
-
-#include <asm-generic/cmpxchg-local.h>
-
-static inline unsigned long __cmpxchg_local(volatile void *ptr,
-				      unsigned long old,
-				      unsigned long new, int size)
-{
-	switch (size) {
-	case 4:
-		return cmpxchg((unsigned long *)ptr, old, new);
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
-#define cmpxchg_local(ptr, o, n)				  	\
-	((__typeof__(*(ptr)))__cmpxchg_local((ptr), (unsigned long)(o),	\
-			(unsigned long)(n), sizeof(*(ptr))))
-#define cmpxchg64_local(ptr, o, n) __cmpxchg64_local_generic((ptr), (o), (n))
-
-#endif /* _ASM_SYSTEM_H */
diff --git a/arch/frv/kernel/debug-stub.c b/arch/frv/kernel/debug-stub.c
index 2845139..a0228f7 100644
--- a/arch/frv/kernel/debug-stub.c
+++ b/arch/frv/kernel/debug-stub.c
@@ -17,7 +17,6 @@
 #include <linux/serial_reg.h>
 #include <linux/start_kernel.h>
 
-#include <asm/system.h>
 #include <asm/serial-regs.h>
 #include <asm/timer-regs.h>
 #include <asm/irc-regs.h>
diff --git a/arch/frv/kernel/gdb-io.c b/arch/frv/kernel/gdb-io.c
index 2ca641d..0707d35 100644
--- a/arch/frv/kernel/gdb-io.c
+++ b/arch/frv/kernel/gdb-io.c
@@ -19,7 +19,6 @@
 #include <linux/serial_reg.h>
 
 #include <asm/pgtable.h>
-#include <asm/system.h>
 #include <asm/irc-regs.h>
 #include <asm/timer-regs.h>
 #include <asm/gdb-stub.h>
diff --git a/arch/frv/kernel/gdb-stub.c b/arch/frv/kernel/gdb-stub.c
index a6d5381..bbe78b0 100644
--- a/arch/frv/kernel/gdb-stub.c
+++ b/arch/frv/kernel/gdb-stub.c
@@ -126,7 +126,6 @@
 
 #include <asm/asm-offsets.h>
 #include <asm/pgtable.h>
-#include <asm/system.h>
 #include <asm/gdb-stub.h>
 
 #define LEDS(x) do { /* *(u32*)0xe1200004 = ~(x); mb(); */ } while(0)
diff --git a/arch/frv/kernel/irq-mb93091.c b/arch/frv/kernel/irq-mb93091.c
index 9afc2ea..2cc327a 100644
--- a/arch/frv/kernel/irq-mb93091.c
+++ b/arch/frv/kernel/irq-mb93091.c
@@ -20,7 +20,6 @@
 #include <linux/bitops.h>
 
 #include <asm/io.h>
-#include <asm/system.h>
 #include <asm/delay.h>
 #include <asm/irq.h>
 #include <asm/irc-regs.h>
diff --git a/arch/frv/kernel/irq-mb93093.c b/arch/frv/kernel/irq-mb93093.c
index 4d4ad09..95e4eb4 100644
--- a/arch/frv/kernel/irq-mb93093.c
+++ b/arch/frv/kernel/irq-mb93093.c
@@ -20,7 +20,6 @@
 #include <linux/bitops.h>
 
 #include <asm/io.h>
-#include <asm/system.h>
 #include <asm/delay.h>
 #include <asm/irq.h>
 #include <asm/irc-regs.h>
diff --git a/arch/frv/kernel/irq-mb93493.c b/arch/frv/kernel/irq-mb93493.c
index 4d034c7..ba648da 100644
--- a/arch/frv/kernel/irq-mb93493.c
+++ b/arch/frv/kernel/irq-mb93493.c
@@ -20,7 +20,6 @@
 #include <linux/bitops.h>
 
 #include <asm/io.h>
-#include <asm/system.h>
 #include <asm/delay.h>
 #include <asm/irq.h>
 #include <asm/irc-regs.h>
diff --git a/arch/frv/kernel/irq.c b/arch/frv/kernel/irq.c
index 3facbc2..2239346 100644
--- a/arch/frv/kernel/irq.c
+++ b/arch/frv/kernel/irq.c
@@ -28,7 +28,6 @@
 #include <linux/atomic.h>
 #include <asm/io.h>
 #include <asm/smp.h>
-#include <asm/system.h>
 #include <asm/uaccess.h>
 #include <asm/pgalloc.h>
 #include <asm/delay.h>
diff --git a/arch/frv/kernel/process.c b/arch/frv/kernel/process.c
index 3901df1..8b6df6f 100644
--- a/arch/frv/kernel/process.c
+++ b/arch/frv/kernel/process.c
@@ -28,7 +28,6 @@
 
 #include <asm/asm-offsets.h>
 #include <asm/uaccess.h>
-#include <asm/system.h>
 #include <asm/setup.h>
 #include <asm/pgtable.h>
 #include <asm/tlb.h>
diff --git a/arch/frv/kernel/ptrace.c b/arch/frv/kernel/ptrace.c
index 9d68f7f..3987ff8 100644
--- a/arch/frv/kernel/ptrace.c
+++ b/arch/frv/kernel/ptrace.c
@@ -26,7 +26,6 @@
 #include <asm/uaccess.h>
 #include <asm/page.h>
 #include <asm/pgtable.h>
-#include <asm/system.h>
 #include <asm/processor.h>
 #include <asm/unistd.h>
 
diff --git a/arch/frv/kernel/traps.c b/arch/frv/kernel/traps.c
index 1d2dfe6..5cfd142 100644
--- a/arch/frv/kernel/traps.c
+++ b/arch/frv/kernel/traps.c
@@ -23,7 +23,6 @@
 #include <asm/asm-offsets.h>
 #include <asm/setup.h>
 #include <asm/fpu.h>
-#include <asm/system.h>
 #include <asm/uaccess.h>
 #include <asm/pgtable.h>
 #include <asm/siginfo.h>
diff --git a/arch/frv/mm/fault.c b/arch/frv/mm/fault.c
index a325d57..331c1e2 100644
--- a/arch/frv/mm/fault.c
+++ b/arch/frv/mm/fault.c
@@ -20,7 +20,6 @@
 #include <linux/ptrace.h>
 #include <linux/hardirq.h>
 
-#include <asm/system.h>
 #include <asm/pgtable.h>
 #include <asm/uaccess.h>
 #include <asm/gdb-stub.h>
diff --git a/arch/frv/mm/init.c b/arch/frv/mm/init.c
index fbe5f0d..a19effc 100644
--- a/arch/frv/mm/init.c
+++ b/arch/frv/mm/init.c
@@ -33,7 +33,6 @@
 #include <asm/segment.h>
 #include <asm/page.h>
 #include <asm/pgtable.h>
-#include <asm/system.h>
 #include <asm/mmu_context.h>
 #include <asm/virtconvert.h>
 #include <asm/sections.h>
diff --git a/arch/frv/mm/kmap.c b/arch/frv/mm/kmap.c
index fb78be3..e9217e6 100644
--- a/arch/frv/mm/kmap.c
+++ b/arch/frv/mm/kmap.c
@@ -21,7 +21,6 @@
 #include <asm/page.h>
 #include <asm/pgalloc.h>
 #include <asm/io.h>
-#include <asm/system.h>
 
 #undef DEBUG
 

