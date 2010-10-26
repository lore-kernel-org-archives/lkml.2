Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932809Ab0JZCz7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 22:55:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3338 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932676Ab0JZCz4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 22:55:56 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH 31/43] MN10300: Implement atomic ops using atomic ops unit
To: linux-am33-list@redhat.com
From: David Howells <dhowells@redhat.com>
Cc: linux-kernel@vger.kernel.org, Mark Salter <msalter@redhat.com>
Date: Tue, 26 Oct 2010 03:55:47 +0100
Message-ID: <20101026025547.23512.43422.stgit@warthog.procyon.org.uk>
In-Reply-To: <20101026025301.23512.24525.stgit@warthog.procyon.org.uk>
References: <20101026025301.23512.24525.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.15-97-g9680-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mark Salter <msalter@redhat.com>

Implement atomic ops using the atomic ops unit available in the AM34 CPU.  This
allows the equivalent of the LL/SC instructions to be found on other CPUs.

Signed-off-by: Mark Salter <msalter@redhat.com>
Signed-off-by: David Howells <dhowells@redhat.com>
---

 arch/mn10300/include/asm/atomic.h |  350 +++++++++++++++++++++++++++++++++++++
 arch/mn10300/include/asm/system.h |   48 -----
 2 files changed, 351 insertions(+), 47 deletions(-)


diff --git a/arch/mn10300/include/asm/atomic.h b/arch/mn10300/include/asm/atomic.h
index f0cc1f8..92d2f92 100644
--- a/arch/mn10300/include/asm/atomic.h
+++ b/arch/mn10300/include/asm/atomic.h
@@ -1 +1,351 @@
+/* MN10300 Atomic counter operations
+ *
+ * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+#ifndef _ASM_ATOMIC_H
+#define _ASM_ATOMIC_H
+
+#include <asm/irqflags.h>
+
+#ifndef __ASSEMBLY__
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
+#define atomic_xchg(ptr, v)		(xchg(&(ptr)->counter, (v)))
+#define atomic_cmpxchg(v, old, new)	(cmpxchg(&((v)->counter), (old), (new)))
+
+#endif /* !__ASSEMBLY__ */
+
+#ifndef CONFIG_SMP
 #include <asm-generic/atomic.h>
+#else
+
+/*
+ * Atomic operations that C can't guarantee us.  Useful for
+ * resource counting etc..
+ */
+
+#define ATOMIC_INIT(i)	{ (i) }
+
+#ifdef __KERNEL__
+
+/**
+ * atomic_read - read atomic variable
+ * @v: pointer of type atomic_t
+ *
+ * Atomically reads the value of @v.  Note that the guaranteed
+ * useful range of an atomic_t is only 24 bits.
+ */
+#define atomic_read(v)	((v)->counter)
+
+/**
+ * atomic_set - set atomic variable
+ * @v: pointer of type atomic_t
+ * @i: required value
+ *
+ * Atomically sets the value of @v to @i.  Note that the guaranteed
+ * useful range of an atomic_t is only 24 bits.
+ */
+#define atomic_set(v, i) (((v)->counter) = (i))
+
+/**
+ * atomic_add_return - add integer to atomic variable
+ * @i: integer value to add
+ * @v: pointer of type atomic_t
+ *
+ * Atomically adds @i to @v and returns the result
+ * Note that the guaranteed useful range of an atomic_t is only 24 bits.
+ */
+static inline int atomic_add_return(int i, atomic_t *v)
+{
+	int retval;
+#ifdef CONFIG_SMP
+	int status;
+
+	asm volatile(
+		"1:	mov	%4,(_AAR,%3)	\n"
+		"	mov	(_ADR,%3),%1	\n"
+		"	add	%5,%1		\n"
+		"	mov	%1,(_ADR,%3)	\n"
+		"	mov	(_ADR,%3),%0	\n"	/* flush */
+		"	mov	(_ASR,%3),%0	\n"
+		"	or	%0,%0		\n"
+		"	bne	1b		\n"
+		: "=&r"(status), "=&r"(retval), "=m"(v->counter)
+		: "a"(ATOMIC_OPS_BASE_ADDR), "r"(&v->counter), "r"(i)
+		: "memory", "cc");
+
+#else
+	unsigned long flags;
+
+	flags = arch_local_cli_save();
+	retval = v->counter;
+	retval += i;
+	v->counter = retval;
+	arch_local_irq_restore(flags);
+#endif
+	return retval;
+}
+
+/**
+ * atomic_sub_return - subtract integer from atomic variable
+ * @i: integer value to subtract
+ * @v: pointer of type atomic_t
+ *
+ * Atomically subtracts @i from @v and returns the result
+ * Note that the guaranteed useful range of an atomic_t is only 24 bits.
+ */
+static inline int atomic_sub_return(int i, atomic_t *v)
+{
+	int retval;
+#ifdef CONFIG_SMP
+	int status;
+
+	asm volatile(
+		"1:	mov	%4,(_AAR,%3)	\n"
+		"	mov	(_ADR,%3),%1	\n"
+		"	sub	%5,%1		\n"
+		"	mov	%1,(_ADR,%3)	\n"
+		"	mov	(_ADR,%3),%0	\n"	/* flush */
+		"	mov	(_ASR,%3),%0	\n"
+		"	or	%0,%0		\n"
+		"	bne	1b		\n"
+		: "=&r"(status), "=&r"(retval), "=m"(v->counter)
+		: "a"(ATOMIC_OPS_BASE_ADDR), "r"(&v->counter), "r"(i)
+		: "memory", "cc");
+
+#else
+	unsigned long flags;
+	flags = arch_local_cli_save();
+	retval = v->counter;
+	retval -= i;
+	v->counter = retval;
+	arch_local_irq_restore(flags);
+#endif
+	return retval;
+}
+
+static inline int atomic_add_negative(int i, atomic_t *v)
+{
+	return atomic_add_return(i, v) < 0;
+}
+
+static inline void atomic_add(int i, atomic_t *v)
+{
+	atomic_add_return(i, v);
+}
+
+static inline void atomic_sub(int i, atomic_t *v)
+{
+	atomic_sub_return(i, v);
+}
+
+static inline void atomic_inc(atomic_t *v)
+{
+	atomic_add_return(1, v);
+}
+
+static inline void atomic_dec(atomic_t *v)
+{
+	atomic_sub_return(1, v);
+}
+
+#define atomic_dec_return(v)		atomic_sub_return(1, (v))
+#define atomic_inc_return(v)		atomic_add_return(1, (v))
+
+#define atomic_sub_and_test(i, v)	(atomic_sub_return((i), (v)) == 0)
+#define atomic_dec_and_test(v)		(atomic_sub_return(1, (v)) == 0)
+#define atomic_inc_and_test(v)		(atomic_add_return(1, (v)) == 0)
+
+#define atomic_add_unless(v, a, u)				\
+({								\
+	int c, old;						\
+	c = atomic_read(v);					\
+	while (c != (u) && (old = atomic_cmpxchg((v), c, c + (a))) != c) \
+		c = old;					\
+	c != (u);						\
+})
+
+#define atomic_inc_not_zero(v) atomic_add_unless((v), 1, 0)
+
+/**
+ * atomic_clear_mask - Atomically clear bits in memory
+ * @mask: Mask of the bits to be cleared
+ * @v: pointer to word in memory
+ *
+ * Atomically clears the bits set in mask from the memory word specified.
+ */
+static inline void atomic_clear_mask(unsigned long mask, unsigned long *addr)
+{
+#ifdef CONFIG_SMP
+	int status;
+
+	asm volatile(
+		"1:	mov	%3,(_AAR,%2)	\n"
+		"	mov	(_ADR,%2),%0	\n"
+		"	and	%4,%0		\n"
+		"	mov	%0,(_ADR,%2)	\n"
+		"	mov	(_ADR,%2),%0	\n"	/* flush */
+		"	mov	(_ASR,%2),%0	\n"
+		"	or	%0,%0		\n"
+		"	bne	1b		\n"
+		: "=&r"(status), "=m"(*addr)
+		: "a"(ATOMIC_OPS_BASE_ADDR), "r"(addr), "r"(~mask)
+		: "memory", "cc");
+#else
+	unsigned long flags;
+
+	mask = ~mask;
+	flags = arch_local_cli_save();
+	*addr &= mask;
+	arch_local_irq_restore(flags);
+#endif
+}
+
+/**
+ * atomic_set_mask - Atomically set bits in memory
+ * @mask: Mask of the bits to be set
+ * @v: pointer to word in memory
+ *
+ * Atomically sets the bits set in mask from the memory word specified.
+ */
+static inline void atomic_set_mask(unsigned long mask, unsigned long *addr)
+{
+#ifdef CONFIG_SMP
+	int status;
+
+	asm volatile(
+		"1:	mov	%3,(_AAR,%2)	\n"
+		"	mov	(_ADR,%2),%0	\n"
+		"	or	%4,%0		\n"
+		"	mov	%0,(_ADR,%2)	\n"
+		"	mov	(_ADR,%2),%0	\n"	/* flush */
+		"	mov	(_ASR,%2),%0	\n"
+		"	or	%0,%0		\n"
+		"	bne	1b		\n"
+		: "=&r"(status), "=m"(*addr)
+		: "a"(ATOMIC_OPS_BASE_ADDR), "r"(addr), "r"(mask)
+		: "memory", "cc");
+#else
+	unsigned long flags;
+
+	flags = arch_local_cli_save();
+	*addr |= mask;
+	arch_local_irq_restore(flags);
+#endif
+}
+
+/* Atomic operations are already serializing on MN10300??? */
+#define smp_mb__before_atomic_dec()	barrier()
+#define smp_mb__after_atomic_dec()	barrier()
+#define smp_mb__before_atomic_inc()	barrier()
+#define smp_mb__after_atomic_inc()	barrier()
+
+#include <asm-generic/atomic-long.h>
+
+#endif /* __KERNEL__ */
+#endif /* CONFIG_SMP */
+#endif /* _ASM_ATOMIC_H */
diff --git a/arch/mn10300/include/asm/system.h b/arch/mn10300/include/asm/system.h
index 3c272a1..7de90bc 100644
--- a/arch/mn10300/include/asm/system.h
+++ b/arch/mn10300/include/asm/system.h
@@ -18,6 +18,7 @@
 
 #include <linux/kernel.h>
 #include <linux/irqflags.h>
+#include <asm/atomic.h>
 
 #if !defined(CONFIG_LAZY_SAVE_FPU)
 struct fpu_state_struct;
@@ -96,52 +97,5 @@ do {									\
 #define read_barrier_depends()		do {} while (0)
 #define smp_read_barrier_depends()	do {} while (0)
 
-/*****************************************************************************/
-/*
- * MN10300 doesn't actually have an exchange instruction
- */
-#ifndef __ASSEMBLY__
-
-struct __xchg_dummy { unsigned long a[100]; };
-#define __xg(x) ((struct __xchg_dummy *)(x))
-
-static inline
-unsigned long __xchg(volatile unsigned long *m, unsigned long val)
-{
-	unsigned long retval;
-	unsigned long flags;
-
-	local_irq_save(flags);
-	retval = *m;
-	*m = val;
-	local_irq_restore(flags);
-	return retval;
-}
-
-#define xchg(ptr, v)						\
-	((__typeof__(*(ptr))) __xchg((unsigned long *)(ptr),	\
-				     (unsigned long)(v)))
-
-static inline unsigned long __cmpxchg(volatile unsigned long *m,
-				      unsigned long old, unsigned long new)
-{
-	unsigned long retval;
-	unsigned long flags;
-
-	local_irq_save(flags);
-	retval = *m;
-	if (retval == old)
-		*m = new;
-	local_irq_restore(flags);
-	return retval;
-}
-
-#define cmpxchg(ptr, o, n)					\
-	((__typeof__(*(ptr))) __cmpxchg((unsigned long *)(ptr), \
-					(unsigned long)(o),	\
-					(unsigned long)(n)))
-
-#endif /* !__ASSEMBLY__ */
-
 #endif /* __KERNEL__ */
 #endif /* _ASM_SYSTEM_H */

