Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752848Ab0FDH2h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jun 2010 03:28:37 -0400
Received: from cantor.suse.de ([195.135.220.2]:44235 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752022Ab0FDH2d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jun 2010 03:28:33 -0400
Message-Id: <20100604072618.400686656@suse.de>
User-Agent: quilt/0.48-4.4
Date: Fri, 04 Jun 2010 16:43:09 +1000
From: Nick Piggin <npiggin@suse.de>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Frank Mayhar <fmayhar@google.com>, John Stultz <johnstul@us.ibm.com>,
       Andi Kleen <ak@linux.intel.com>
Subject: [patch 2/4] lglock: introduce special lglock and brlock spin locks
References: <20100604064307.737085373@suse.de>
Content-Disposition: inline; filename=kernel-introduce-brlock.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduces "local-global" locks (lglocks). These can be used to:

- Provide fast exclusive access to per-CPU data, with exclusive access to
  another CPU's data allowed but possibly subject to contention, and to provide
  very slow exclusive access to all per-CPU data.
- Or to provide very fast and scalable read serialisation, and to provide
  very slow exclusive serialisation of data (not necessarily per-CPU data).

Brlocks are also implemented as a short-hand notation for the latter use
case.

Thanks to Paul for local/global naming convention.

Cc: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org
Cc: Al Viro <viro@ZenIV.linux.org.uk>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Frank Mayhar <fmayhar@google.com>,
Cc: John Stultz <johnstul@us.ibm.com>
Cc: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Nick Piggin <npiggin@suse.de>
---
 include/linux/lglock.h |  165 +++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 165 insertions(+)

Index: linux-2.6/include/linux/lglock.h
===================================================================
--- /dev/null
+++ linux-2.6/include/linux/lglock.h
@@ -0,0 +1,165 @@
+/*
+ * Specialised local-global spinlock. Can only be declared as global variables
+ * to avoid overhead and keep things simple (and we don't want to start using
+ * these inside dynamically allocated structures).
+ *
+ * "local/global locks" (lglocks) can be used to:
+ *
+ * - Provide fast exclusive access to per-CPU data, with exclusive access to
+ *   another CPU's data allowed but possibly subject to contention, and to
+ *   provide very slow exclusive access to all per-CPU data.
+ * - Or to provide very fast and scalable read serialisation, and to provide
+ *   very slow exclusive serialisation of data (not necessarily per-CPU data).
+ *
+ * Brlocks are also implemented as a short-hand notation for the latter use
+ * case.
+ *
+ * Copyright 2009, 2010, Nick Piggin, Novell Inc.
+ */
+#ifndef __LINUX_LGLOCK_H
+#define __LINUX_LGLOCK_H
+
+#include <linux/spinlock.h>
+#include <linux/lockdep.h>
+#include <linux/percpu.h>
+#include <asm/atomic.h>
+
+/* can make br locks by using local lock for read side, global lock for write */
+#define br_lock_init(name)	name##_lock_init()
+#define br_read_lock(name)	name##_local_lock()
+#define br_read_unlock(name)	name##_local_unlock()
+#define br_write_lock(name)	name##_global_lock()
+#define br_write_unlock(name)	name##_global_unlock()
+#define atomic_dec_and_br_write_lock(atomic, name)	name##_atomic_dec_and_global_lock(atomic)
+
+#define DECLARE_BRLOCK(name)	DECLARE_LGLOCK(name)
+#define DEFINE_BRLOCK(name)	DEFINE_LGLOCK(name)
+
+
+#define lg_lock_init(name)	name##_lock_init()
+#define lg_local_lock(name)	name##_local_lock()
+#define lg_local_unlock(name)	name##_local_unlock()
+#define lg_local_lock_cpu(name, cpu)	name##_local_lock_cpu(cpu)
+#define lg_local_unlock_cpu(name, cpu)	name##_local_unlock_cpu(cpu)
+#define lg_global_lock(name)	name##_global_lock()
+#define lg_global_unlock(name)	name##_global_unlock()
+#define atomic_dec_and_lg_global_lock(atomic, name)	name##_atomic_dec_and_global_lock(atomic)
+
+#ifdef CONFIG_DEBUG_LOCK_ALLOC
+#define LOCKDEP_INIT_MAP lockdep_init_map
+
+#define DEFINE_LGLOCK_LOCKDEP(name)					\
+ struct lock_class_key name##_lock_key;					\
+ struct lockdep_map name##_lock_dep_map;				\
+ EXPORT_SYMBOL(name##_lock_dep_map)
+
+#else
+#define LOCKDEP_INIT_MAP(a, b, c, d)
+
+#define DEFINE_LGLOCK_LOCKDEP(name)
+#endif
+
+
+#define DECLARE_LGLOCK(name)						\
+ extern void name##_lock_init(void);					\
+ extern void name##_local_lock(void);					\
+ extern void name##_local_unlock(void);					\
+ extern void name##_local_lock_cpu(int cpu);				\
+ extern void name##_local_unlock_cpu(int cpu);				\
+ extern void name##_global_lock(void);					\
+ extern void name##_global_unlock(void);				\
+ extern int name##_atomic_dec_and_global_lock(atomic_t *a);		\
+
+#define DEFINE_LGLOCK(name)						\
+									\
+ DEFINE_PER_CPU(arch_spinlock_t, name##_lock);				\
+ DEFINE_LGLOCK_LOCKDEP(name);						\
+									\
+ void name##_lock_init(void) {						\
+	int i;								\
+	LOCKDEP_INIT_MAP(&name##_lock_dep_map, #name, &name##_lock_key, 0); \
+	for_each_possible_cpu(i) {					\
+		arch_spinlock_t *lock;					\
+		lock = &per_cpu(name##_lock, i);			\
+		*lock = (arch_spinlock_t)__ARCH_SPIN_LOCK_UNLOCKED;	\
+	}								\
+ }									\
+ EXPORT_SYMBOL(name##_lock_init);					\
+									\
+ void name##_local_lock(void) {						\
+	arch_spinlock_t *lock;						\
+	preempt_disable();						\
+	rwlock_acquire_read(&name##_lock_dep_map, 0, 0, _THIS_IP_);	\
+	lock = &__get_cpu_var(name##_lock);				\
+	arch_spin_lock(lock);						\
+ }									\
+ EXPORT_SYMBOL(name##_local_lock);					\
+									\
+ void name##_local_unlock(void) {					\
+	arch_spinlock_t *lock;						\
+	rwlock_release(&name##_lock_dep_map, 1, _THIS_IP_);		\
+	lock = &__get_cpu_var(name##_lock);				\
+	arch_spin_unlock(lock);						\
+	preempt_enable();						\
+ }									\
+ EXPORT_SYMBOL(name##_local_unlock);					\
+									\
+ void name##_local_lock_cpu(int cpu) {			\
+	arch_spinlock_t *lock;						\
+	preempt_disable();						\
+	rwlock_acquire_read(&name##_lock_dep_map, 0, 0, _THIS_IP_);	\
+	lock = &per_cpu(name##_lock, cpu);				\
+	arch_spin_lock(lock);						\
+ }									\
+ EXPORT_SYMBOL(name##_local_lock_cpu);					\
+									\
+ void name##_local_unlock_cpu(int cpu) {			\
+	arch_spinlock_t *lock;						\
+	rwlock_release(&name##_lock_dep_map, 1, _THIS_IP_);		\
+	lock = &per_cpu(name##_lock, cpu);				\
+	arch_spin_unlock(lock);						\
+	preempt_enable();						\
+ }									\
+ EXPORT_SYMBOL(name##_local_unlock_cpu);				\
+									\
+ void name##_global_lock(void) {					\
+	int i;								\
+	preempt_disable();						\
+	rwlock_acquire(&name##_lock_dep_map, 0, 0, _RET_IP_);		\
+	for_each_online_cpu(i) {					\
+		arch_spinlock_t *lock;					\
+		lock = &per_cpu(name##_lock, i);			\
+		arch_spin_lock(lock);					\
+	}								\
+ }									\
+ EXPORT_SYMBOL(name##_global_lock);					\
+									\
+ void name##_global_unlock(void) {					\
+	int i;								\
+	rwlock_release(&name##_lock_dep_map, 1, _RET_IP_);		\
+	for_each_online_cpu(i) {					\
+		arch_spinlock_t *lock;					\
+		lock = &per_cpu(name##_lock, i);			\
+		arch_spin_unlock(lock);					\
+	}								\
+	preempt_enable();						\
+ }									\
+ EXPORT_SYMBOL(name##_global_unlock);					\
+									\
+ static int name##_atomic_dec_and_global_lock__failed(atomic_t *a) {	\
+	name##_global_lock();						\
+	if (!atomic_dec_and_test(a)) {					\
+		name##_global_unlock();					\
+		return 0;						\
+	}								\
+	return 1;							\
+ }									\
+ 									\
+ int name##_atomic_dec_and_global_lock(atomic_t *a) {			\
+	if (likely(atomic_add_unless(a, -1, 1)))			\
+		return 0;						\
+	return name##_atomic_dec_and_global_lock__failed(a);		\
+ }									\
+ EXPORT_SYMBOL(name##_atomic_dec_and_global_lock);
+
+#endif


