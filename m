Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755025Ab1EKPqY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 11:46:24 -0400
Received: from mga02.intel.com ([134.134.136.20]:29429 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754398Ab1EKPqR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 11:46:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,351,1301900400"; 
   d="scan'208";a="641126612"
Message-Id: <20110511081433.655427440@sli10-conroe.sh.intel.com>
User-Agent: quilt/0.48-1
Date: Wed, 11 May 2011 16:10:14 +0800
From: Shaohua Li <shaohua.li@intel.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, tj@kernel.org, eric.dumazet@gmail.com,
        cl@linux.com, npiggin@kernel.dk, Shaohua Li <shaohua.li@intel.com>
Subject: [patch v2 2/5] lglock: convert it to work with dynamically allocated structure
References: <20110511081012.903869567@sli10-conroe.sh.intel.com>
Content-Disposition: inline; filename=lglock-work-struct.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Converting lglock to work with dynamically allocated structure.
There is no fundamental reason lglock must be static to me. And this can
reduce some code size actually. Next patch will use it in a dynamically
allocated structure.

Signed-off-by: Shaohua Li <shaohua.li@intel.com>
---
 include/linux/lglock.h |  192 ++++++++++++-------------------------------------
 kernel/Makefile        |    2 
 kernel/lglock.c        |  124 +++++++++++++++++++++++++++++++
 3 files changed, 175 insertions(+), 143 deletions(-)

Index: linux/include/linux/lglock.h
===================================================================
--- linux.orig/include/linux/lglock.h	2011-05-10 16:10:55.000000000 +0800
+++ linux/include/linux/lglock.h	2011-05-11 09:42:07.000000000 +0800
@@ -1,7 +1,5 @@
 /*
- * Specialised local-global spinlock. Can only be declared as global variables
- * to avoid overhead and keep things simple (and we don't want to start using
- * these inside dynamically allocated structures).
+ * Specialised local-global spinlock.
  *
  * "local/global locks" (lglocks) can be used to:
  *
@@ -23,150 +21,60 @@
 #include <linux/lockdep.h>
 #include <linux/percpu.h>
 
-/* can make br locks by using local lock for read side, global lock for write */
-#define br_lock_init(name)	name##_lock_init()
-#define br_read_lock(name)	name##_local_lock()
-#define br_read_unlock(name)	name##_local_unlock()
-#define br_write_lock(name)	name##_global_lock_online()
-#define br_write_unlock(name)	name##_global_unlock_online()
-
-#define DECLARE_BRLOCK(name)	DECLARE_LGLOCK(name)
-#define DEFINE_BRLOCK(name)	DEFINE_LGLOCK(name)
-
-
-#define lg_lock_init(name)	name##_lock_init()
-#define lg_local_lock(name)	name##_local_lock()
-#define lg_local_unlock(name)	name##_local_unlock()
-#define lg_local_lock_cpu(name, cpu)	name##_local_lock_cpu(cpu)
-#define lg_local_unlock_cpu(name, cpu)	name##_local_unlock_cpu(cpu)
-#define lg_global_lock(name)	name##_global_lock()
-#define lg_global_unlock(name)	name##_global_unlock()
-#define lg_global_lock_online(name) name##_global_lock_online()
-#define lg_global_unlock_online(name) name##_global_unlock_online()
-
+struct lglock {
+	arch_spinlock_t __percpu *locks;
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
-#define LOCKDEP_INIT_MAP lockdep_init_map
-
-#define DEFINE_LGLOCK_LOCKDEP(name)					\
- struct lock_class_key name##_lock_key;					\
- struct lockdep_map name##_lock_dep_map;				\
- EXPORT_SYMBOL(name##_lock_dep_map)
-
-#else
-#define LOCKDEP_INIT_MAP(a, b, c, d)
-
-#define DEFINE_LGLOCK_LOCKDEP(name)
+	struct lockdep_map lock_dep_map;
 #endif
-
+};
 
 #define DECLARE_LGLOCK(name)						\
- extern void name##_lock_init(void);					\
- extern void name##_local_lock(void);					\
- extern void name##_local_unlock(void);					\
- extern void name##_local_lock_cpu(int cpu);				\
- extern void name##_local_unlock_cpu(int cpu);				\
- extern void name##_global_lock(void);					\
- extern void name##_global_unlock(void);				\
- extern void name##_global_lock_online(void);				\
- extern void name##_global_unlock_online(void);				\
+	extern struct lglock name;
 
 #define DEFINE_LGLOCK(name)						\
 									\
- DEFINE_PER_CPU(arch_spinlock_t, name##_lock);				\
- DEFINE_LGLOCK_LOCKDEP(name);						\
-									\
- void name##_lock_init(void) {						\
-	int i;								\
-	LOCKDEP_INIT_MAP(&name##_lock_dep_map, #name, &name##_lock_key, 0); \
-	for_each_possible_cpu(i) {					\
-		arch_spinlock_t *lock;					\
-		lock = &per_cpu(name##_lock, i);			\
-		*lock = (arch_spinlock_t)__ARCH_SPIN_LOCK_UNLOCKED;	\
-	}								\
- }									\
- EXPORT_SYMBOL(name##_lock_init);					\
-									\
- void name##_local_lock(void) {						\
-	arch_spinlock_t *lock;						\
-	preempt_disable();						\
-	rwlock_acquire_read(&name##_lock_dep_map, 0, 0, _THIS_IP_);	\
-	lock = &__get_cpu_var(name##_lock);				\
-	arch_spin_lock(lock);						\
- }									\
- EXPORT_SYMBOL(name##_local_lock);					\
-									\
- void name##_local_unlock(void) {					\
-	arch_spinlock_t *lock;						\
-	rwlock_release(&name##_lock_dep_map, 1, _THIS_IP_);		\
-	lock = &__get_cpu_var(name##_lock);				\
-	arch_spin_unlock(lock);						\
-	preempt_enable();						\
- }									\
- EXPORT_SYMBOL(name##_local_unlock);					\
-									\
- void name##_local_lock_cpu(int cpu) {					\
-	arch_spinlock_t *lock;						\
-	preempt_disable();						\
-	rwlock_acquire_read(&name##_lock_dep_map, 0, 0, _THIS_IP_);	\
-	lock = &per_cpu(name##_lock, cpu);				\
-	arch_spin_lock(lock);						\
- }									\
- EXPORT_SYMBOL(name##_local_lock_cpu);					\
-									\
- void name##_local_unlock_cpu(int cpu) {				\
-	arch_spinlock_t *lock;						\
-	rwlock_release(&name##_lock_dep_map, 1, _THIS_IP_);		\
-	lock = &per_cpu(name##_lock, cpu);				\
-	arch_spin_unlock(lock);						\
-	preempt_enable();						\
- }									\
- EXPORT_SYMBOL(name##_local_unlock_cpu);				\
-									\
- void name##_global_lock_online(void) {					\
-	int i;								\
-	preempt_disable();						\
-	rwlock_acquire(&name##_lock_dep_map, 0, 0, _RET_IP_);		\
-	for_each_online_cpu(i) {					\
-		arch_spinlock_t *lock;					\
-		lock = &per_cpu(name##_lock, i);			\
-		arch_spin_lock(lock);					\
-	}								\
- }									\
- EXPORT_SYMBOL(name##_global_lock_online);				\
-									\
- void name##_global_unlock_online(void) {				\
-	int i;								\
-	rwlock_release(&name##_lock_dep_map, 1, _RET_IP_);		\
-	for_each_online_cpu(i) {					\
-		arch_spinlock_t *lock;					\
-		lock = &per_cpu(name##_lock, i);			\
-		arch_spin_unlock(lock);					\
-	}								\
-	preempt_enable();						\
- }									\
- EXPORT_SYMBOL(name##_global_unlock_online);				\
-									\
- void name##_global_lock(void) {					\
-	int i;								\
-	preempt_disable();						\
-	rwlock_acquire(&name##_lock_dep_map, 0, 0, _RET_IP_);		\
-	for_each_possible_cpu(i) {					\
-		arch_spinlock_t *lock;					\
-		lock = &per_cpu(name##_lock, i);			\
-		arch_spin_lock(lock);					\
-	}								\
- }									\
- EXPORT_SYMBOL(name##_global_lock);					\
-									\
- void name##_global_unlock(void) {					\
-	int i;								\
-	rwlock_release(&name##_lock_dep_map, 1, _RET_IP_);		\
-	for_each_possible_cpu(i) {					\
-		arch_spinlock_t *lock;					\
-		lock = &per_cpu(name##_lock, i);			\
-		arch_spin_unlock(lock);					\
-	}								\
-	preempt_enable();						\
- }									\
- EXPORT_SYMBOL(name##_global_unlock);
+DEFINE_PER_CPU(arch_spinlock_t, name##_percpulock);			\
+struct lglock name = {							\
+	.locks = &name##_percpulock,					\
+};
+
+extern int lglock_alloc(struct lglock *lglock);
+extern void lglock_free(struct lglock *lglock);
+extern void __lglock_init(struct lglock *lglock, const char *name,
+	struct lock_class_key *key);
+#define lglock_init(lock, name)						\
+({									\
+	static struct lock_class_key key;				\
+	__lglock_init(lock, name, &key);				\
+})
+extern void lglock_local_lock(struct lglock *lglock);
+extern void lglock_local_unlock(struct lglock *lglock);
+extern void lglock_local_lock_cpu(struct lglock *lglock, int cpu);
+extern void lglock_local_unlock_cpu(struct lglock *lglock, int cpu);
+extern void lglock_global_lock_online(struct lglock *lglock);
+extern void lglock_global_unlock_online(struct lglock *lglock);
+extern void lglock_global_lock(struct lglock *lglock);
+extern void lglock_global_unlock(struct lglock *lglock);
+
+/* can make br locks by using local lock for read side, global lock for write */
+#define br_lock_init(name)	lglock_init(&name, #name)
+#define br_read_lock(name)	lglock_local_lock(&name)
+#define br_read_unlock(name)	lglock_local_unlock(&name)
+#define br_write_lock(name)	lglock_global_lock_online(&name)
+#define br_write_unlock(name)	lglock_global_unlock_online(&name)
+
+#define DECLARE_BRLOCK(name)	DECLARE_LGLOCK(name)
+#define DEFINE_BRLOCK(name)	DEFINE_LGLOCK(name)
+
+#define lg_lock_init(name)	lglock_init(&name, #name)
+#define lg_local_lock(name)	lglock_local_lock(&name)
+#define lg_local_unlock(name)	lglock_local_unlock(&name)
+#define lg_local_lock_cpu(name, cpu)	lglock_local_lock_cpu(&name, cpu)
+#define lg_local_unlock_cpu(name, cpu) \
+	lglock_local_unlock_cpu(&name, cpu)
+#define lg_global_lock(name)	lglock_global_lock(&name)
+#define lg_global_unlock(name)	lglock_global_unlock(&name)
+#define lg_global_lock_online(name) lglock_global_lock_online(&name)
+#define lg_global_unlock_online(name) lglock_global_unlock_online(&name)
+
 #endif
Index: linux/kernel/Makefile
===================================================================
--- linux.orig/kernel/Makefile	2011-05-10 16:10:55.000000000 +0800
+++ linux/kernel/Makefile	2011-05-10 16:23:01.000000000 +0800
@@ -10,7 +10,7 @@ obj-y     = sched.o fork.o exec_domain.o
 	    kthread.o wait.o kfifo.o sys_ni.o posix-cpu-timers.o mutex.o \
 	    hrtimer.o rwsem.o nsproxy.o srcu.o semaphore.o \
 	    notifier.o ksysfs.o pm_qos_params.o sched_clock.o cred.o \
-	    async.o range.o jump_label.o
+	    async.o range.o jump_label.o lglock.o
 obj-y += groups.o
 
 ifdef CONFIG_FUNCTION_TRACER
Index: linux/kernel/lglock.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux/kernel/lglock.c	2011-05-11 09:39:46.000000000 +0800
@@ -0,0 +1,124 @@
+#include <linux/lglock.h>
+#include <linux/module.h>
+
+int lglock_alloc(struct lglock *lglock)
+{
+	lglock->locks = alloc_percpu(arch_spinlock_t);
+	if (!lglock->locks)
+		return -ENOMEM;
+	return 0;
+}
+EXPORT_SYMBOL(lglock_alloc);
+
+void lglock_free(struct lglock *lglock)
+{
+	free_percpu(lglock->locks);
+}
+EXPORT_SYMBOL(lglock_free);
+
+void __lglock_init(struct lglock *lglock, const char *name,
+	struct lock_class_key *key)
+{
+	int i;
+#ifdef CONFIG_DEBUG_LOCK_ALLOC
+	lockdep_init_map(&lglock->lock_dep_map, name, key, 0);
+#endif
+	for_each_possible_cpu(i) {
+		arch_spinlock_t *lock;
+		lock = per_cpu_ptr(lglock->locks, i);
+		*lock = (arch_spinlock_t)__ARCH_SPIN_LOCK_UNLOCKED;
+	}
+}
+EXPORT_SYMBOL(__lglock_init);
+
+void lglock_local_lock(struct lglock *lglock)
+{
+	arch_spinlock_t *lock;
+	preempt_disable();
+	rwlock_acquire_read(&lglock->lock_dep_map, 0, 0, _THIS_IP_);
+	lock = __this_cpu_ptr(lglock->locks);
+	arch_spin_lock(lock);
+}
+EXPORT_SYMBOL(lglock_local_lock);
+
+void lglock_local_unlock(struct lglock *lglock)
+{
+	arch_spinlock_t *lock;
+	rwlock_release(&lglock->lock_dep_map, 1, _THIS_IP_);
+	lock = __this_cpu_ptr(lglock->locks);
+	arch_spin_unlock(lock);
+	preempt_enable();
+}
+EXPORT_SYMBOL(lglock_local_unlock);
+
+void lglock_local_lock_cpu(struct lglock *lglock, int cpu)
+{
+	arch_spinlock_t *lock;
+	preempt_disable();
+	rwlock_acquire_read(&lglock->lock_dep_map, 0, 0, _THIS_IP_);
+	lock = per_cpu_ptr(lglock->locks, cpu);
+	arch_spin_lock(lock);
+}
+EXPORT_SYMBOL(lglock_local_lock_cpu);
+
+void lglock_local_unlock_cpu(struct lglock *lglock, int cpu)
+{
+	arch_spinlock_t *lock;
+	rwlock_release(&lglock->lock_dep_map, 1, _THIS_IP_);
+	lock = per_cpu_ptr(lglock->locks, cpu);
+	arch_spin_unlock(lock);
+	preempt_enable();
+}
+EXPORT_SYMBOL(lglock_local_unlock_cpu);
+
+void lglock_global_lock_online(struct lglock *lglock)
+{
+	int i;
+	preempt_disable();
+	rwlock_acquire(&lglock->lock_dep_map, 0, 0, _RET_IP_);
+	for_each_online_cpu(i) {
+		arch_spinlock_t *lock;
+		lock = per_cpu_ptr(lglock->locks, i);
+		arch_spin_lock(lock);
+	}
+}
+EXPORT_SYMBOL(lglock_global_lock_online);
+
+void lglock_global_unlock_online(struct lglock *lglock)
+{
+	int i;
+	rwlock_release(&lglock->lock_dep_map, 1, _RET_IP_);
+	for_each_online_cpu(i) {
+		arch_spinlock_t *lock;
+		lock = per_cpu_ptr(lglock->locks, i);
+		arch_spin_unlock(lock);
+	}
+	preempt_enable();
+}
+EXPORT_SYMBOL(lglock_global_unlock_online);
+
+void lglock_global_lock(struct lglock *lglock)
+{
+	int i;
+	preempt_disable();
+	rwlock_acquire(&lglock->lock_dep_map, 0, 0, _RET_IP_);
+	for_each_possible_cpu(i) {
+		arch_spinlock_t *lock;
+		lock = per_cpu_ptr(lglock->locks, i);
+		arch_spin_lock(lock);
+	}
+}
+EXPORT_SYMBOL(lglock_global_lock);
+
+void lglock_global_unlock(struct lglock *lglock)
+{
+	int i;
+	rwlock_release(&lglock->lock_dep_map, 1, _RET_IP_);
+	for_each_possible_cpu(i) {
+		arch_spinlock_t *lock;
+		lock = per_cpu_ptr(lglock->locks, i);
+		arch_spin_unlock(lock);
+	}
+	preempt_enable();
+}
+EXPORT_SYMBOL(lglock_global_unlock);

