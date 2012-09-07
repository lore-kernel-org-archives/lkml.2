Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755007Ab2IGQeZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 12:34:25 -0400
Received: from service87.mimecast.com ([91.220.42.44]:34367 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752151Ab2IGQ1y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 12:27:54 -0400
From: Catalin Marinas <catalin.marinas@arm.com>
To: linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH v3 12/31] arm64: Atomic operations
Date: Fri,  7 Sep 2012 17:26:47 +0100
Message-Id: <1347035226-18649-13-git-send-email-catalin.marinas@arm.com>
X-Mailer: git-send-email 1.7.9.111.gf3fb0
In-Reply-To: <1347035226-18649-1-git-send-email-catalin.marinas@arm.com>
References: <1347035226-18649-1-git-send-email-catalin.marinas@arm.com>
X-OriginalArrivalTime: 07 Sep 2012 16:27:52.0222 (UTC) FILETIME=[BA4053E0:01CD8D15]
X-MC-Unique: 112090717275207001
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id q87GYUCo008443

This patch introduces the atomic, mutex and futex operations. Many
atomic operations use the load-acquire and store-release operations
which imply barriers, avoiding the need for explicit DMB.

Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Acked-by: Tony Lindgren <tony@atomide.com>
---
 arch/arm64/include/asm/atomic.h |  305 +++++++++++++++++++++++++++++++++++++++
 arch/arm64/include/asm/futex.h  |  136 +++++++++++++++++
 2 files changed, 441 insertions(+), 0 deletions(-)
 create mode 100644 arch/arm64/include/asm/atomic.h
 create mode 100644 arch/arm64/include/asm/futex.h

diff --git a/arch/arm64/include/asm/atomic.h b/arch/arm64/include/asm/atomic.h
new file mode 100644
index 0000000..407717b
--- /dev/null
+++ b/arch/arm64/include/asm/atomic.h
@@ -0,0 +1,305 @@
+/*
+ * Based on arch/arm/include/asm/atomic.h
+ *
+ * Copyright (C) 1996 Russell King.
+ * Copyright (C) 2002 Deep Blue Solutions Ltd.
+ * Copyright (C) 2012 ARM Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+#ifndef __ASM_ATOMIC_H
+#define __ASM_ATOMIC_H
+
+#include <linux/compiler.h>
+#include <linux/types.h>
+
+#include <asm/barrier.h>
+#include <asm/cmpxchg.h>
+
+#define ATOMIC_INIT(i)	{ (i) }
+
+#ifdef __KERNEL__
+
+/*
+ * On ARM, ordinary assignment (str instruction) doesn't clear the local
+ * strex/ldrex monitor on some implementations. The reason we can use it for
+ * atomic_set() is the clrex or dummy strex done on every exception return.
+ */
+#define atomic_read(v)	(*(volatile int *)&(v)->counter)
+#define atomic_set(v,i)	(((v)->counter) = (i))
+
+/*
+ * AArch64 UP and SMP safe atomic ops.  We use load exclusive and
+ * store exclusive to ensure that these are atomic.  We may loop
+ * to ensure that the update happens.
+ */
+static inline void atomic_add(int i, atomic_t *v)
+{
+	unsigned long tmp;
+	int result;
+
+	asm volatile("// atomic_add\n"
+"1:	ldxr	%w0, [%3]\n"
+"	add	%w0, %w0, %w4\n"
+"	stxr	%w1, %w0, [%3]\n"
+"	cbnz	%w1, 1b"
+	: "=&r" (result), "=&r" (tmp), "+o" (v->counter)
+	: "r" (&v->counter), "Ir" (i)
+	: "cc");
+}
+
+static inline int atomic_add_return(int i, atomic_t *v)
+{
+	unsigned long tmp;
+	int result;
+
+	asm volatile("// atomic_add_return\n"
+"1:	ldaxr	%w0, [%3]\n"
+"	add	%w0, %w0, %w4\n"
+"	stlxr	%w1, %w0, [%3]\n"
+"	cbnz	%w1, 1b"
+	: "=&r" (result), "=&r" (tmp), "+o" (v->counter)
+	: "r" (&v->counter), "Ir" (i)
+	: "cc");
+
+	return result;
+}
+
+static inline void atomic_sub(int i, atomic_t *v)
+{
+	unsigned long tmp;
+	int result;
+
+	asm volatile("// atomic_sub\n"
+"1:	ldxr	%w0, [%3]\n"
+"	sub	%w0, %w0, %w4\n"
+"	stxr	%w1, %w0, [%3]\n"
+"	cbnz	%w1, 1b"
+	: "=&r" (result), "=&r" (tmp), "+o" (v->counter)
+	: "r" (&v->counter), "Ir" (i)
+	: "cc");
+}
+
+static inline int atomic_sub_return(int i, atomic_t *v)
+{
+	unsigned long tmp;
+	int result;
+
+	asm volatile("// atomic_sub_return\n"
+"1:	ldaxr	%w0, [%3]\n"
+"	sub	%w0, %w0, %w4\n"
+"	stlxr	%w1, %w0, [%3]\n"
+"	cbnz	%w1, 1b"
+	: "=&r" (result), "=&r" (tmp), "+o" (v->counter)
+	: "r" (&v->counter), "Ir" (i)
+	: "cc");
+
+	return result;
+}
+
+static inline int atomic_cmpxchg(atomic_t *ptr, int old, int new)
+{
+	unsigned long tmp;
+	int oldval;
+
+	asm volatile("// atomic_cmpxchg\n"
+"1:	ldaxr	%w1, [%3]\n"
+"	cmp	%w1, %w4\n"
+"	b.ne	2f\n"
+"	stlxr	%w0, %w5, [%3]\n"
+"	cbnz	%w0, 1b\n"
+"2:"
+	: "=&r" (tmp), "=&r" (oldval), "+o" (ptr->counter)
+	: "r" (&ptr->counter), "Ir" (old), "r" (new)
+	: "cc");
+
+	return oldval;
+}
+
+static inline void atomic_clear_mask(unsigned long mask, unsigned long *addr)
+{
+	unsigned long tmp, tmp2;
+
+	asm volatile("// atomic_clear_mask\n"
+"1:	ldxr	%0, [%3]\n"
+"	bic	%0, %0, %4\n"
+"	stxr	%w1, %0, [%3]\n"
+"	cbnz	%w1, 1b"
+	: "=&r" (tmp), "=&r" (tmp2), "+o" (*addr)
+	: "r" (addr), "Ir" (mask)
+	: "cc");
+}
+
+#define atomic_xchg(v, new) (xchg(&((v)->counter), new))
+
+static inline int __atomic_add_unless(atomic_t *v, int a, int u)
+{
+	int c, old;
+
+	c = atomic_read(v);
+	while (c != u && (old = atomic_cmpxchg((v), c, c + a)) != c)
+		c = old;
+	return c;
+}
+
+#define atomic_inc(v)		atomic_add(1, v)
+#define atomic_dec(v)		atomic_sub(1, v)
+
+#define atomic_inc_and_test(v)	(atomic_add_return(1, v) == 0)
+#define atomic_dec_and_test(v)	(atomic_sub_return(1, v) == 0)
+#define atomic_inc_return(v)    (atomic_add_return(1, v))
+#define atomic_dec_return(v)    (atomic_sub_return(1, v))
+#define atomic_sub_and_test(i, v) (atomic_sub_return(i, v) == 0)
+
+#define atomic_add_negative(i,v) (atomic_add_return(i, v) < 0)
+
+#define smp_mb__before_atomic_dec()	smp_mb()
+#define smp_mb__after_atomic_dec()	smp_mb()
+#define smp_mb__before_atomic_inc()	smp_mb()
+#define smp_mb__after_atomic_inc()	smp_mb()
+
+/*
+ * 64-bit atomic operations.
+ */
+#define ATOMIC64_INIT(i) { (i) }
+
+#define atomic64_read(v)	(*(volatile long long *)&(v)->counter)
+#define atomic64_set(v,i)	(((v)->counter) = (i))
+
+static inline void atomic64_add(u64 i, atomic64_t *v)
+{
+	long result;
+	unsigned long tmp;
+
+	asm volatile("// atomic64_add\n"
+"1:	ldxr	%0, [%3]\n"
+"	add	%0, %0, %4\n"
+"	stxr	%w1, %0, [%3]\n"
+"	cbnz	%w1, 1b"
+	: "=&r" (result), "=&r" (tmp), "+o" (v->counter)
+	: "r" (&v->counter), "Ir" (i)
+	: "cc");
+}
+
+static inline long atomic64_add_return(long i, atomic64_t *v)
+{
+	long result;
+	unsigned long tmp;
+
+	asm volatile("// atomic64_add_return\n"
+"1:	ldaxr	%0, [%3]\n"
+"	add	%0, %0, %4\n"
+"	stlxr	%w1, %0, [%3]\n"
+"	cbnz	%w1, 1b"
+	: "=&r" (result), "=&r" (tmp), "+o" (v->counter)
+	: "r" (&v->counter), "Ir" (i)
+	: "cc");
+
+	return result;
+}
+
+static inline void atomic64_sub(u64 i, atomic64_t *v)
+{
+	long result;
+	unsigned long tmp;
+
+	asm volatile("// atomic64_sub\n"
+"1:	ldxr	%0, [%3]\n"
+"	sub	%0, %0, %4\n"
+"	stxr	%w1, %0, [%3]\n"
+"	cbnz	%w1, 1b"
+	: "=&r" (result), "=&r" (tmp), "+o" (v->counter)
+	: "r" (&v->counter), "Ir" (i)
+	: "cc");
+}
+
+static inline long atomic64_sub_return(long i, atomic64_t *v)
+{
+	long result;
+	unsigned long tmp;
+
+	asm volatile("// atomic64_sub_return\n"
+"1:	ldaxr	%0, [%3]\n"
+"	sub	%0, %0, %4\n"
+"	stlxr	%w1, %0, [%3]\n"
+"	cbnz	%w1, 1b"
+	: "=&r" (result), "=&r" (tmp), "+o" (v->counter)
+	: "r" (&v->counter), "Ir" (i)
+	: "cc");
+
+	return result;
+}
+
+static inline long atomic64_cmpxchg(atomic64_t *ptr, long old, long new)
+{
+	long oldval;
+	unsigned long res;
+
+	asm volatile("// atomic64_cmpxchg\n"
+"1:	ldaxr	%1, [%3]\n"
+"	cmp	%1, %4\n"
+"	b.ne	2f\n"
+"	stlxr	%w0, %5, [%3]\n"
+"	cbnz	%w0, 1b\n"
+"2:"
+	: "=&r" (res), "=&r" (oldval), "+o" (ptr->counter)
+	: "r" (&ptr->counter), "Ir" (old), "r" (new)
+	: "cc");
+
+	return oldval;
+}
+
+#define atomic64_xchg(v, new) (xchg(&((v)->counter), new))
+
+static inline long atomic64_dec_if_positive(atomic64_t *v)
+{
+	long result;
+	unsigned long tmp;
+
+	asm volatile("// atomic64_dec_if_positive\n"
+"1:	ldaxr	%0, [%3]\n"
+"	subs	%0, %0, #1\n"
+"	b.mi	2f\n"
+"	stlxr	%w1, %0, [%3]\n"
+"	cbnz	%w1, 1b\n"
+"2:"
+	: "=&r" (result), "=&r" (tmp), "+o" (v->counter)
+	: "r" (&v->counter)
+	: "cc");
+
+	return result;
+}
+
+static inline int atomic64_add_unless(atomic64_t *v, long a, long u)
+{
+	long c, old;
+
+	c = atomic64_read(v);
+	while (c != u && (old = atomic64_cmpxchg((v), c, c + a)) != c)
+		c = old;
+
+	return c != u;
+}
+
+#define atomic64_add_negative(a, v)	(atomic64_add_return((a), (v)) < 0)
+#define atomic64_inc(v)			atomic64_add(1LL, (v))
+#define atomic64_inc_return(v)		atomic64_add_return(1LL, (v))
+#define atomic64_inc_and_test(v)	(atomic64_inc_return(v) == 0)
+#define atomic64_sub_and_test(a, v)	(atomic64_sub_return((a), (v)) == 0)
+#define atomic64_dec(v)			atomic64_sub(1LL, (v))
+#define atomic64_dec_return(v)		atomic64_sub_return(1LL, (v))
+#define atomic64_dec_and_test(v)	(atomic64_dec_return((v)) == 0)
+#define atomic64_inc_not_zero(v)	atomic64_add_unless((v), 1LL, 0LL)
+
+#endif
+#endif
diff --git a/arch/arm64/include/asm/futex.h b/arch/arm64/include/asm/futex.h
new file mode 100644
index 0000000..3468ae8
--- /dev/null
+++ b/arch/arm64/include/asm/futex.h
@@ -0,0 +1,136 @@
+/*
+ * Copyright (C) 2012 ARM Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+#ifndef __ASM_FUTEX_H
+#define __ASM_FUTEX_H
+
+#ifdef __KERNEL__
+
+#include <linux/futex.h>
+#include <linux/uaccess.h>
+#include <asm/errno.h>
+
+#define __futex_atomic_op(insn, ret, oldval, uaddr, tmp, oparg)		\
+	asm volatile(							\
+"1:	ldaxr	%w1, %2\n"						\
+	insn "\n"							\
+"2:	stlxr	%w3, %w0, %2\n"						\
+"	cbnz	%w3, 1b\n"						\
+"3:\n"									\
+"	.pushsection .fixup,\"ax\"\n"					\
+"4:	mov	%w0, %w5\n"						\
+"	b	3b\n"							\
+"	.popsection\n"							\
+"	.pushsection __ex_table,\"a\"\n"				\
+"	.align	3\n"							\
+"	.quad	1b, 4b, 2b, 4b\n"					\
+"	.popsection\n"							\
+	: "=&r" (ret), "=&r" (oldval), "+Q" (*uaddr), "=&r" (tmp)	\
+	: "r" (oparg), "Ir" (-EFAULT)					\
+	: "cc")
+
+static inline int
+futex_atomic_op_inuser (int encoded_op, u32 __user *uaddr)
+{
+	int op = (encoded_op >> 28) & 7;
+	int cmp = (encoded_op >> 24) & 15;
+	int oparg = (encoded_op << 8) >> 20;
+	int cmparg = (encoded_op << 20) >> 20;
+	int oldval = 0, ret, tmp;
+
+	if (encoded_op & (FUTEX_OP_OPARG_SHIFT << 28))
+		oparg = 1 << oparg;
+
+	if (!access_ok(VERIFY_WRITE, uaddr, sizeof(u32)))
+		return -EFAULT;
+
+	pagefault_disable();	/* implies preempt_disable() */
+
+	switch (op) {
+	case FUTEX_OP_SET:
+		__futex_atomic_op("mov	%w0, %w4",
+				  ret, oldval, uaddr, tmp, oparg);
+		break;
+	case FUTEX_OP_ADD:
+		__futex_atomic_op("add	%w0, %w1, %w4",
+				  ret, oldval, uaddr, tmp, oparg);
+		break;
+	case FUTEX_OP_OR:
+		__futex_atomic_op("orr	%w0, %w1, %w4",
+				  ret, oldval, uaddr, tmp, oparg);
+		break;
+	case FUTEX_OP_ANDN:
+		__futex_atomic_op("and	%w0, %w1, %w4",
+				  ret, oldval, uaddr, tmp, ~oparg);
+		break;
+	case FUTEX_OP_XOR:
+		__futex_atomic_op("eor	%w0, %w1, %w4",
+				  ret, oldval, uaddr, tmp, oparg);
+		break;
+	default:
+		ret = -ENOSYS;
+	}
+
+	pagefault_enable();	/* subsumes preempt_enable() */
+
+	if (!ret) {
+		switch (cmp) {
+		case FUTEX_OP_CMP_EQ: ret = (oldval == cmparg); break;
+		case FUTEX_OP_CMP_NE: ret = (oldval != cmparg); break;
+		case FUTEX_OP_CMP_LT: ret = (oldval < cmparg); break;
+		case FUTEX_OP_CMP_GE: ret = (oldval >= cmparg); break;
+		case FUTEX_OP_CMP_LE: ret = (oldval <= cmparg); break;
+		case FUTEX_OP_CMP_GT: ret = (oldval > cmparg); break;
+		default: ret = -ENOSYS;
+		}
+	}
+	return ret;
+}
+
+static inline int
+futex_atomic_cmpxchg_inatomic(u32 *uval, u32 __user *uaddr,
+			      u32 oldval, u32 newval)
+{
+	int ret = 0;
+	u32 val, tmp;
+
+	if (!access_ok(VERIFY_WRITE, uaddr, sizeof(u32)))
+		return -EFAULT;
+
+	asm volatile("// futex_atomic_cmpxchg_inatomic\n"
+"1:	ldaxr	%w1, %2\n"
+"	sub	%w3, %w1, %w4\n"
+"	cbnz	%w3, 3f\n"
+"2:	stlxr	%w3, %w5, %2\n"
+"	cbnz	%w3, 1b\n"
+"3:\n"
+"	.pushsection .fixup,\"ax\"\n"
+"4:	mov	%w0, %w6\n"
+"	b	3b\n"
+"	.popsection\n"
+"	.pushsection __ex_table,\"a\"\n"
+"	.align	3\n"
+"	.quad	1b, 4b, 2b, 4b\n"
+"	.popsection\n"
+	: "+r" (ret), "=&r" (val), "+Q" (*uaddr), "=&r" (tmp)
+	: "r" (oldval), "r" (newval), "Ir" (-EFAULT)
+	: "cc", "memory");
+
+	*uval = val;
+	return ret;
+}
+
+#endif /* __KERNEL__ */
+#endif /* __ASM_FUTEX_H */

