Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754174Ab2KGJsc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 04:48:32 -0500
Received: from vaxjo.synopsys.com ([198.182.60.75]:52591 "EHLO
	vaxjo.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754125Ab2KGJs1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 04:48:27 -0500
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
To: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de, arnd@arndb.de,
        Vineet Gupta <Vineet.Gupta1@synopsys.com>
Subject: [RFC PATCH v1 09/31] ARC: spinlock/rwlock/mutex primitives
Date: Wed,  7 Nov 2012 10:47:32 +0100
Message-Id: <1352281674-2186-10-git-send-email-vgupta@synopsys.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1352281674-2186-1-git-send-email-vgupta@synopsys.com>
References: <1352281674-2186-1-git-send-email-vgupta@synopsys.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
---
 arch/arc/include/asm/mutex.h          |    9 ++
 arch/arc/include/asm/spinlock.h       |  144 +++++++++++++++++++++++++++++++++
 arch/arc/include/asm/spinlock_types.h |   35 ++++++++
 3 files changed, 188 insertions(+), 0 deletions(-)
 create mode 100644 arch/arc/include/asm/mutex.h
 create mode 100644 arch/arc/include/asm/spinlock.h
 create mode 100644 arch/arc/include/asm/spinlock_types.h

diff --git a/arch/arc/include/asm/mutex.h b/arch/arc/include/asm/mutex.h
new file mode 100644
index 0000000..3be5e64
--- /dev/null
+++ b/arch/arc/include/asm/mutex.h
@@ -0,0 +1,9 @@
+/*
+ * Copyright (C) 2004, 2007-2010, 2011-2012 Synopsys, Inc. (www.synopsys.com)
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <asm-generic/mutex-xchg.h>
diff --git a/arch/arc/include/asm/spinlock.h b/arch/arc/include/asm/spinlock.h
new file mode 100644
index 0000000..f158197
--- /dev/null
+++ b/arch/arc/include/asm/spinlock.h
@@ -0,0 +1,144 @@
+/*
+ * Copyright (C) 2004, 2007-2010, 2011-2012 Synopsys, Inc. (www.synopsys.com)
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef __ASM_SPINLOCK_H
+#define __ASM_SPINLOCK_H
+
+#include <asm/spinlock_types.h>
+#include <asm/processor.h>
+#include <asm/barrier.h>
+
+#define arch_spin_is_locked(x)	((x)->slock != __ARCH_SPIN_LOCK_UNLOCKED__)
+#define arch_spin_lock_flags(lock, flags)	arch_spin_lock(lock)
+#define arch_spin_unlock_wait(x) \
+	do { while (arch_spin_is_locked(x)) cpu_relax(); } while (0)
+
+static inline void arch_spin_lock(arch_spinlock_t *lock)
+{
+	unsigned int tmp = __ARCH_SPIN_LOCK_LOCKED__;
+
+	__asm__ __volatile__(
+	"1:	ex  %0, [%1]		\n"
+	"	breq  %0, %2, 1b	\n"
+	: "+&r" (tmp)
+	: "r"(&(lock->slock)), "ir"(__ARCH_SPIN_LOCK_LOCKED__)
+	: "memory");
+}
+
+static inline int arch_spin_trylock(arch_spinlock_t *lock)
+{
+	unsigned int tmp = __ARCH_SPIN_LOCK_LOCKED__;
+
+	__asm__ __volatile__(
+	"1:	ex  %0, [%1]		\n"
+	: "+r" (tmp)
+	: "r"(&(lock->slock))
+	: "memory");
+
+	return (tmp == __ARCH_SPIN_LOCK_UNLOCKED__);
+}
+
+static inline void arch_spin_unlock(arch_spinlock_t *lock)
+{
+	lock->slock = __ARCH_SPIN_LOCK_UNLOCKED__;
+	smp_mb();
+}
+
+/*
+ * Read-write spinlocks, allowing multiple readers but only one writer.
+ *
+ * The spinlock itself is contained in @counter and access to it is
+ * serialized with @lock_mutex.
+ *
+ * Unfair locking as Writers could be starved indefinitely by Reader(s)
+ */
+
+/* Would read_trylock() succeed? */
+#define arch_read_can_lock(x)	((x)->counter > 0)
+
+/* Would write_trylock() succeed? */
+#define arch_write_can_lock(x)	((x)->counter == __ARCH_RW_LOCK_UNLOCKED__)
+
+/* 1 - lock taken successfully */
+static inline int arch_read_trylock(arch_rwlock_t *rw)
+{
+	int ret = 0;
+
+	arch_spin_lock(&(rw->lock_mutex));
+
+	/*
+	 * zero means writer holds the lock exclusively, deny Reader.
+	 * Otherwise grant lock to first/subseq reader
+	 */
+	if (rw->counter > 0) {
+		rw->counter--;
+		ret = 1;
+	}
+
+	arch_spin_unlock(&(rw->lock_mutex));
+
+	smp_mb();
+	return ret;
+}
+
+/* 1 - lock taken successfully */
+static inline int arch_write_trylock(arch_rwlock_t *rw)
+{
+	int ret = 0;
+
+	arch_spin_lock(&(rw->lock_mutex));
+
+	/*
+	 * If reader(s) hold lock (lock < __ARCH_RW_LOCK_UNLOCKED__),
+	 * deny writer. Otherwise if unlocked grant to writer
+	 * Hence the claim that Linux rwlocks are unfair to writers.
+	 * (can be starved for an indefinite time by readers).
+	 */
+	if (rw->counter == __ARCH_RW_LOCK_UNLOCKED__) {
+		rw->counter = 0;
+		ret = 1;
+	}
+	arch_spin_unlock(&(rw->lock_mutex));
+
+	return ret;
+}
+
+static inline void arch_read_lock(arch_rwlock_t *rw)
+{
+	while (!arch_read_trylock(rw))
+		cpu_relax();
+}
+
+static inline void arch_write_lock(arch_rwlock_t *rw)
+{
+	while (!arch_write_trylock(rw))
+		cpu_relax();
+}
+
+static inline void arch_read_unlock(arch_rwlock_t *rw)
+{
+	arch_spin_lock(&(rw->lock_mutex));
+	rw->counter++;
+	arch_spin_unlock(&(rw->lock_mutex));
+}
+
+static inline void arch_write_unlock(arch_rwlock_t *rw)
+{
+	arch_spin_lock(&(rw->lock_mutex));
+	rw->counter = __ARCH_RW_LOCK_UNLOCKED__;
+	arch_spin_unlock(&(rw->lock_mutex));
+}
+
+#define arch_read_lock_flags(lock, flags)	arch_read_lock(lock)
+#define arch_write_lock_flags(lock, flags)	arch_write_lock(lock)
+
+#define arch_spin_relax(lock)	cpu_relax()
+#define arch_read_relax(lock)	cpu_relax()
+#define arch_write_relax(lock)	cpu_relax()
+
+#endif /* __ASM_SPINLOCK_H */
diff --git a/arch/arc/include/asm/spinlock_types.h b/arch/arc/include/asm/spinlock_types.h
new file mode 100644
index 0000000..8276bfd
--- /dev/null
+++ b/arch/arc/include/asm/spinlock_types.h
@@ -0,0 +1,35 @@
+/*
+ * Copyright (C) 2004, 2007-2010, 2011-2012 Synopsys, Inc. (www.synopsys.com)
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef __ASM_SPINLOCK_TYPES_H
+#define __ASM_SPINLOCK_TYPES_H
+
+typedef struct {
+	volatile unsigned int slock;
+} arch_spinlock_t;
+
+#define __ARCH_SPIN_LOCK_UNLOCKED__	0
+#define __ARCH_SPIN_LOCK_LOCKED__	1
+
+#define __ARCH_SPIN_LOCK_UNLOCKED	{ __ARCH_SPIN_LOCK_UNLOCKED__ }
+#define __ARCH_SPIN_LOCK_LOCKED		{ __ARCH_SPIN_LOCK_LOCKED__ }
+
+/*
+ * Unlocked:     0x01_00_00_00
+ * Read lock(s): 0x00_FF_00_00 to say 0x01
+ * Write lock:   0x0, but only possible if prior value "unlocked" 0x0100_0000
+ */
+typedef struct {
+	volatile unsigned int	counter;
+	arch_spinlock_t		lock_mutex;
+} arch_rwlock_t;
+
+#define __ARCH_RW_LOCK_UNLOCKED__	0x01000000
+#define __ARCH_RW_LOCK_UNLOCKED		{ .counter = __ARCH_RW_LOCK_UNLOCKED__ }
+
+#endif
-- 
1.7.4.1

