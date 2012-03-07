Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760075Ab2CGTsI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 14:48:08 -0500
Received: from mx1.redhat.com ([209.132.183.28]:11252 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760005Ab2CGTsF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 14:48:05 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 10/29] Disintegrate asm/system.h for FRV
To: paul.gortmaker@windriver.com, hpa@zytor.com
Cc: torvalds@linux-foundation.org, sfr@canb.auug.org.au, mingo@redhat.com,
        arnd@arndb.de, dhowells@redhat.com, tglx@linutronix.de,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Date: Wed, 07 Mar 2012 19:47:46 +0000
Message-ID: <20120307194746.15987.20262.stgit@warthog.procyon.org.uk>
In-Reply-To: <20120307194548.15987.36073.stgit@warthog.procyon.org.uk>
References: <20120307194548.15987.36073.stgit@warthog.procyon.org.uk>
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

 arch/frv/include/asm/atomic.h        |   98 +++++++++++++++++++++
 arch/frv/include/asm/barrier.h       |   27 ++++++
 arch/frv/include/asm/bug.h           |    2 
 arch/frv/include/asm/exec.h          |   17 ++++
 arch/frv/include/asm/special_insns.h |   17 ++++
 arch/frv/include/asm/switch_to.h     |   35 ++++++++
 arch/frv/include/asm/system.h        |  157 ----------------------------------
 7 files changed, 196 insertions(+), 157 deletions(-)
 create mode 100644 arch/frv/include/asm/barrier.h
 create mode 100644 arch/frv/include/asm/exec.h
 create mode 100644 arch/frv/include/asm/special_insns.h
 create mode 100644 arch/frv/include/asm/switch_to.h
 delete mode 100644 arch/frv/include/asm/system.h

diff --git a/arch/frv/include/asm/atomic.h b/arch/frv/include/asm/atomic.h
index 9491575..90b47f4 100644
--- a/arch/frv/include/asm/atomic.h
+++ b/arch/frv/include/asm/atomic.h
@@ -235,6 +235,104 @@ extern uint32_t __xchg_32(uint32_t i, volatile void *v);
 
 #define tas(ptr) (xchg((ptr), 1))
 
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
 #define atomic_cmpxchg(v, old, new)	(cmpxchg(&(v)->counter, old, new))
 #define atomic_xchg(v, new)		(xchg(&(v)->counter, new))
 #define atomic64_cmpxchg(v, old, new)	(__cmpxchg_64(old, new, &(v)->counter))
diff --git a/arch/frv/include/asm/barrier.h b/arch/frv/include/asm/barrier.h
new file mode 100644
index 0000000..7f8c20e
--- /dev/null
+++ b/arch/frv/include/asm/barrier.h
@@ -0,0 +1,27 @@
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
diff --git a/arch/frv/include/asm/special_insns.h b/arch/frv/include/asm/special_insns.h
new file mode 100644
index 0000000..20a198d
--- /dev/null
+++ b/arch/frv/include/asm/special_insns.h
@@ -0,0 +1,17 @@
+/* FR-V CPU special instructions
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
+#ifndef _ASM_SPECIAL_INSNS_H
+#define _ASM_SPECIAL_INSNS_H
+
+#define nop()			asm volatile ("nop"::)
+
+#endif /* _ASM_SPECIAL_INSNS_H */
diff --git a/arch/frv/include/asm/switch_to.h b/arch/frv/include/asm/switch_to.h
new file mode 100644
index 0000000..49f8b09
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
+struct thread_struct;
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
deleted file mode 100644
index 769e66f..0000000
--- a/arch/frv/include/asm/system.h
+++ /dev/null
@@ -1,157 +0,0 @@
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

