Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758215Ab1IIBPg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Sep 2011 21:15:36 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:30784 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932212Ab1IIBLa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Sep 2011 21:11:30 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6463"; a="116679232"
Message-Id: <20110909010916.801809244@codeaurora.org>
User-Agent: quilt/0.48-1
Date: Thu, 08 Sep 2011 20:09:09 -0500
From: Richard Kuo <rkuo@codeaurora.org>
To: linux-arch@vger.kernel.org, linux-hexagon@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [patch v3 22/36] Hexagon: Add locking types and functions
References: <20110909010847.294039464@codeaurora.org>
Content-Disposition: inline; filename=rwsem-spin.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Moved rwsem to asm-generic.  Will submit a subsequent patch for PPC
use it from the new location.

Signed-off-by: Richard Kuo <rkuo@codeaurora.org>

---
 arch/hexagon/include/asm/spinlock.h       |  186 ++++++++++++++++++++++++++++++
 arch/hexagon/include/asm/spinlock_types.h |   42 ++++++
 include/asm-generic/rwsem.h               |  132 +++++++++++++++++++++
 3 files changed, 360 insertions(+)

Index: linux-hexagon-kernel/arch/hexagon/include/asm/spinlock.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-hexagon-kernel/arch/hexagon/include/asm/spinlock.h	2011-09-03 20:14:59.714981363 -0500
@@ -0,0 +1,186 @@
+/*
+ * Spinlock support for the Hexagon architecture
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
+#ifndef _ASM_SPINLOCK_H
+#define _ASM_SPINLOCK_H
+
+#include <asm/irqflags.h>
+
+/*
+ * This file is pulled in for SMP builds.
+ * Really need to check all the barrier stuff for "true" SMP
+ */
+
+/*
+ * Read locks:
+ * - load the lock value
+ * - increment it
+ * - if the lock value is still negative, go back and try again.
+ * - unsuccessful store is unsuccessful.  Go back and try again.  Loser.
+ * - successful store new lock value if positive -> lock acquired
+ */
+static inline void arch_read_lock(arch_rwlock_t *lock)
+{
+	__asm__ __volatile__(
+		"1:	R6 = memw_locked(%0);\n"
+		"	{ P3 = cmp.ge(R6,#0); R6 = add(R6,#1);}\n"
+		"	{ if !P3 jump 1b; }\n"
+		"	memw_locked(%0,P3) = R6;\n"
+		"	{ if !P3 jump 1b; }\n"
+		:
+		: "r" (&lock->lock)
+		: "memory", "r6", "p3"
+	);
+
+}
+
+static inline void arch_read_unlock(arch_rwlock_t *lock)
+{
+	__asm__ __volatile__(
+		"1:	R6 = memw_locked(%0);\n"
+		"	R6 = add(R6,#-1);\n"
+		"	memw_locked(%0,P3) = R6\n"
+		"	if !P3 jump 1b;\n"
+		:
+		: "r" (&lock->lock)
+		: "memory", "r6", "p3"
+	);
+
+}
+
+/*  I think this returns 0 on fail, 1 on success.  */
+static inline int arch_read_trylock(arch_rwlock_t *lock)
+{
+	int temp;
+	__asm__ __volatile__(
+		"	R6 = memw_locked(%1);\n"
+		"	{ %0 = #0; P3 = cmp.ge(R6,#0); R6 = add(R6,#1);}\n"
+		"	{ if !P3 jump 1f; }\n"
+		"	memw_locked(%1,P3) = R6;\n"
+		"	{ %0 = P3 }\n"
+		"1:\n"
+		: "=&r" (temp)
+		: "r" (&lock->lock)
+		: "memory", "r6", "p3"
+	);
+	return temp;
+}
+
+static inline int arch_read_can_lock(arch_rwlock_t *rwlock)
+{
+	return rwlock->lock == 0;
+}
+
+static inline int arch_write_can_lock(arch_rwlock_t *rwlock)
+{
+	return rwlock->lock == 0;
+}
+
+/*  Stuffs a -1 in the lock value?  */
+static inline void arch_write_lock(arch_rwlock_t *lock)
+{
+	__asm__ __volatile__(
+		"1:	R6 = memw_locked(%0)\n"
+		"	{ P3 = cmp.eq(R6,#0);  R6 = #-1;}\n"
+		"	{ if !P3 jump 1b; }\n"
+		"	memw_locked(%0,P3) = R6;\n"
+		"	{ if !P3 jump 1b; }\n"
+		:
+		: "r" (&lock->lock)
+		: "memory", "r6", "p3"
+	);
+}
+
+
+static inline int arch_write_trylock(arch_rwlock_t *lock)
+{
+	int temp;
+	__asm__ __volatile__(
+		"	R6 = memw_locked(%1)\n"
+		"	{ %0 = #0; P3 = cmp.eq(R6,#0);  R6 = #-1;}\n"
+		"	{ if !P3 jump 1f; }\n"
+		"	memw_locked(%1,P3) = R6;\n"
+		"	%0 = P3;\n"
+		"1:\n"
+		: "=&r" (temp)
+		: "r" (&lock->lock)
+		: "memory", "r6", "p3"
+	);
+	return temp;
+
+}
+
+static inline void arch_write_unlock(arch_rwlock_t *lock)
+{
+	smp_mb();
+	lock->lock = 0;
+}
+
+static inline void arch_spin_lock(arch_spinlock_t *lock)
+{
+	__asm__ __volatile__(
+		"1:	R6 = memw_locked(%0);\n"
+		"	P3 = cmp.eq(R6,#0);\n"
+		"	{ if !P3 jump 1b; R6 = #1; }\n"
+		"	memw_locked(%0,P3) = R6;\n"
+		"	{ if !P3 jump 1b; }\n"
+		:
+		: "r" (&lock->lock)
+		: "memory", "r6", "p3"
+	);
+
+}
+
+static inline void arch_spin_unlock(arch_spinlock_t *lock)
+{
+	smp_mb();
+	lock->lock = 0;
+}
+
+static inline unsigned int arch_spin_trylock(arch_spinlock_t *lock)
+{
+	int temp;
+	__asm__ __volatile__(
+		"	R6 = memw_locked(%1);\n"
+		"	P3 = cmp.eq(R6,#0);\n"
+		"	{ if !P3 jump 1f; R6 = #1; %0 = #0; }\n"
+		"	memw_locked(%1,P3) = R6;\n"
+		"	%0 = P3;\n"
+		"1:\n"
+		: "=&r" (temp)
+		: "r" (&lock->lock)
+		: "memory", "r6", "p3"
+	);
+	return temp;
+}
+
+/*
+ * SMP spinlocks are intended to allow only a single CPU at the lock
+ */
+#define arch_spin_lock_flags(lock, flags) arch_spin_lock(lock)
+#define arch_spin_unlock_wait(lock) \
+	do {while (arch_spin_is_locked(lock)) cpu_relax(); } while (0)
+#define arch_spin_is_locked(x) ((x)->lock != 0)
+
+#define arch_read_lock_flags(lock, flags) arch_read_lock(lock)
+#define arch_write_lock_flags(lock, flags) arch_write_lock(lock)
+
+#endif
Index: linux-hexagon-kernel/arch/hexagon/include/asm/spinlock_types.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-hexagon-kernel/arch/hexagon/include/asm/spinlock_types.h	2011-09-03 20:14:59.714981363 -0500
@@ -0,0 +1,42 @@
+/*
+ * Spinlock support for the Hexagon architecture
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
+#ifndef _ASM_SPINLOCK_TYPES_H
+#define _ASM_SPINLOCK_TYPES_H
+
+#include <linux/version.h>
+
+#ifndef __LINUX_SPINLOCK_TYPES_H
+# error "please don't include this file directly"
+#endif
+
+typedef struct {
+	volatile unsigned int lock;
+} arch_spinlock_t;
+
+#define __ARCH_SPIN_LOCK_UNLOCKED	{ 0 }
+
+typedef struct {
+	volatile unsigned int lock;
+} arch_rwlock_t;
+
+#define __ARCH_RW_LOCK_UNLOCKED		{ 0 }
+
+#endif
Index: linux-hexagon-kernel/include/asm-generic/rwsem.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-hexagon-kernel/include/asm-generic/rwsem.h	2011-09-07 13:00:37.190656296 -0500
@@ -0,0 +1,132 @@
+#ifndef _ASM_POWERPC_RWSEM_H
+#define _ASM_POWERPC_RWSEM_H
+
+#ifndef _LINUX_RWSEM_H
+#error "Please don't include <asm/rwsem.h> directly, use <linux/rwsem.h> instead."
+#endif
+
+#ifdef __KERNEL__
+
+/*
+ * R/W semaphores for PPC using the stuff in lib/rwsem.c.
+ * Adapted largely from include/asm-i386/rwsem.h
+ * by Paul Mackerras <paulus@samba.org>.
+ */
+
+/*
+ * the semaphore definition
+ */
+#ifdef CONFIG_PPC64
+# define RWSEM_ACTIVE_MASK		0xffffffffL
+#else
+# define RWSEM_ACTIVE_MASK		0x0000ffffL
+#endif
+
+#define RWSEM_UNLOCKED_VALUE		0x00000000L
+#define RWSEM_ACTIVE_BIAS		0x00000001L
+#define RWSEM_WAITING_BIAS		(-RWSEM_ACTIVE_MASK-1)
+#define RWSEM_ACTIVE_READ_BIAS		RWSEM_ACTIVE_BIAS
+#define RWSEM_ACTIVE_WRITE_BIAS		(RWSEM_WAITING_BIAS + RWSEM_ACTIVE_BIAS)
+
+/*
+ * lock for reading
+ */
+static inline void __down_read(struct rw_semaphore *sem)
+{
+	if (unlikely(atomic_long_inc_return((atomic_long_t *)&sem->count) <= 0))
+		rwsem_down_read_failed(sem);
+}
+
+static inline int __down_read_trylock(struct rw_semaphore *sem)
+{
+	long tmp;
+
+	while ((tmp = sem->count) >= 0) {
+		if (tmp == cmpxchg(&sem->count, tmp,
+				   tmp + RWSEM_ACTIVE_READ_BIAS)) {
+			return 1;
+		}
+	}
+	return 0;
+}
+
+/*
+ * lock for writing
+ */
+static inline void __down_write_nested(struct rw_semaphore *sem, int subclass)
+{
+	long tmp;
+
+	tmp = atomic_long_add_return(RWSEM_ACTIVE_WRITE_BIAS,
+				     (atomic_long_t *)&sem->count);
+	if (unlikely(tmp != RWSEM_ACTIVE_WRITE_BIAS))
+		rwsem_down_write_failed(sem);
+}
+
+static inline void __down_write(struct rw_semaphore *sem)
+{
+	__down_write_nested(sem, 0);
+}
+
+static inline int __down_write_trylock(struct rw_semaphore *sem)
+{
+	long tmp;
+
+	tmp = cmpxchg(&sem->count, RWSEM_UNLOCKED_VALUE,
+		      RWSEM_ACTIVE_WRITE_BIAS);
+	return tmp == RWSEM_UNLOCKED_VALUE;
+}
+
+/*
+ * unlock after reading
+ */
+static inline void __up_read(struct rw_semaphore *sem)
+{
+	long tmp;
+
+	tmp = atomic_long_dec_return((atomic_long_t *)&sem->count);
+	if (unlikely(tmp < -1 && (tmp & RWSEM_ACTIVE_MASK) == 0))
+		rwsem_wake(sem);
+}
+
+/*
+ * unlock after writing
+ */
+static inline void __up_write(struct rw_semaphore *sem)
+{
+	if (unlikely(atomic_long_sub_return(RWSEM_ACTIVE_WRITE_BIAS,
+				 (atomic_long_t *)&sem->count) < 0))
+		rwsem_wake(sem);
+}
+
+/*
+ * implement atomic add functionality
+ */
+static inline void rwsem_atomic_add(long delta, struct rw_semaphore *sem)
+{
+	atomic_long_add(delta, (atomic_long_t *)&sem->count);
+}
+
+/*
+ * downgrade write lock to read lock
+ */
+static inline void __downgrade_write(struct rw_semaphore *sem)
+{
+	long tmp;
+
+	tmp = atomic_long_add_return(-RWSEM_WAITING_BIAS,
+				     (atomic_long_t *)&sem->count);
+	if (tmp < 0)
+		rwsem_downgrade_wake(sem);
+}
+
+/*
+ * implement exchange and add functionality
+ */
+static inline long rwsem_atomic_update(long delta, struct rw_semaphore *sem)
+{
+	return atomic_long_add_return(delta, (atomic_long_t *)&sem->count);
+}
+
+#endif	/* __KERNEL__ */
+#endif	/* _ASM_POWERPC_RWSEM_H */

--

Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

