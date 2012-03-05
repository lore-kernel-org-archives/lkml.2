Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755411Ab2CEHIL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 02:08:11 -0500
Received: from ozlabs.org ([203.10.76.45]:33720 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751665Ab2CEHIH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 02:08:07 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Andi Kleen <ak@linux.intel.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: Nick Piggin <npiggin@kernel.dk>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        linux-fsdevel@vger.kernel.org
Subject: [PATCH 3/3] brlocks/lglocks: turn into functions
In-Reply-To: <20120228112422.GC11324@alboin.amr.corp.intel.com>
References: <87ehtf3lqh.fsf@rustcorp.com.au> <20120227155338.7b5110cd.akpm@linux-foundation.org> <20120228112422.GC11324@alboin.amr.corp.intel.com>
User-Agent: Notmuch/0.6.1-1 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Mon, 05 Mar 2012 17:35:28 +1030
Message-ID: <87ipijzfwn.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

lglocks and brlocks are currently generated with some complicated macros
in lglock.h.  But there's no reason to not just use common utility
functions and put all the data into a common data structure.

Since there are at least two users it makes sense to share this code in a
library.  This is also easier maintainable than a macro forest.

This will also make it later possible to dynamically allocate lglocks and
also use them in modules (this would both still need some additional, but
now straightforward, code)

[akpm@linux-foundation.org: checkpatch fixes]
Signed-off-by: Andi Kleen <ak@linux.intel.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au> (split and completed)
---
 fs/file_table.c        |    1 
 fs/internal.h          |    2 
 include/linux/lglock.h |  125 ++++++++++---------------------------------------
 kernel/Makefile        |    2 
 kernel/lglock.c        |   89 ++++++++++++++++++++++++++++++++++
 5 files changed, 117 insertions(+), 102 deletions(-)

diff --git a/fs/file_table.c b/fs/file_table.c
--- a/fs/file_table.c
+++ b/fs/file_table.c
@@ -34,7 +34,6 @@ struct files_stat_struct files_stat = {
 	.max_files = NR_FILE
 };
 
-DECLARE_LGLOCK(files_lglock);
 DEFINE_LGLOCK(files_lglock);
 
 /* SLAB cache for file structures */
diff --git a/fs/internal.h b/fs/internal.h
--- a/fs/internal.h
+++ b/fs/internal.h
@@ -56,7 +56,7 @@ extern int sb_prepare_remount_readonly(s
 
 extern void __init mnt_init(void);
 
-DECLARE_BRLOCK(vfsmount_lock);
+extern struct lglock vfsmount_lock;
 
 
 /*
diff --git a/include/linux/lglock.h b/include/linux/lglock.h
--- a/include/linux/lglock.h
+++ b/include/linux/lglock.h
@@ -23,26 +23,17 @@
 #include <linux/lockdep.h>
 #include <linux/percpu.h>
 #include <linux/cpu.h>
+#include <linux/notifier.h>
 
 /* can make br locks by using local lock for read side, global lock for write */
-#define br_lock_init(name)	name##_lock_init()
-#define br_read_lock(name)	name##_local_lock()
-#define br_read_unlock(name)	name##_local_unlock()
-#define br_write_lock(name)	name##_global_lock()
-#define br_write_unlock(name)	name##_global_unlock()
+#define br_lock_init(name)	lg_lock_init(name, #name)
+#define br_read_lock(name)	lg_local_lock(name)
+#define br_read_unlock(name)	lg_local_unlock(name)
+#define br_write_lock(name)	lg_global_lock(name)
+#define br_write_unlock(name)	lg_global_unlock(name)
 
-#define DECLARE_BRLOCK(name)	DECLARE_LGLOCK(name)
 #define DEFINE_BRLOCK(name)	DEFINE_LGLOCK(name)
 
-
-#define lg_lock_init(name)	name##_lock_init()
-#define lg_local_lock(name)	name##_local_lock()
-#define lg_local_unlock(name)	name##_local_unlock()
-#define lg_local_lock_cpu(name, cpu)	name##_local_lock_cpu(cpu)
-#define lg_local_unlock_cpu(name, cpu)	name##_local_unlock_cpu(cpu)
-#define lg_global_lock(name)	name##_global_lock()
-#define lg_global_unlock(name)	name##_global_unlock()
-
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 #define LOCKDEP_INIT_MAP lockdep_init_map
 
@@ -57,90 +48,26 @@
 #define DEFINE_LGLOCK_LOCKDEP(name)
 #endif
 
-
-#define DECLARE_LGLOCK(name)						\
- extern void name##_lock_init(void);					\
- extern void name##_local_lock(void);					\
- extern void name##_local_unlock(void);					\
- extern void name##_local_lock_cpu(int cpu);				\
- extern void name##_local_unlock_cpu(int cpu);				\
- extern void name##_global_lock(void);					\
- extern void name##_global_unlock(void);				\
+struct lglock {
+	arch_spinlock_t __percpu *lock;
+#ifdef CONFIG_DEBUG_LOCK_ALLOC
+	struct lock_class_key lock_key;
+	struct lockdep_map    lock_dep_map;
+#endif
+};
 
 #define DEFINE_LGLOCK(name)						\
-									\
- DEFINE_SPINLOCK(name##_cpu_lock);					\
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
+	DEFINE_LGLOCK_LOCKDEP(name);					\
+	DEFINE_PER_CPU(arch_spinlock_t, name ## _lock)			\
+	= __ARCH_SPIN_LOCK_UNLOCKED;					\
+	struct lglock name = { .lock = &name ## _lock }
+
+void lg_lock_init(struct lglock *lg, char *name);
+void lg_local_lock(struct lglock *lg);
+void lg_local_unlock(struct lglock *lg);
+void lg_local_lock_cpu(struct lglock *lg, int cpu);
+void lg_local_unlock_cpu(struct lglock *lg, int cpu);
+void lg_global_lock(struct lglock *lg);
+void lg_global_unlock(struct lglock *lg);
+
 #endif
diff --git a/kernel/Makefile b/kernel/Makefile
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -10,7 +10,7 @@ obj-y     = fork.o exec_domain.o panic.o
 	    kthread.o wait.o kfifo.o sys_ni.o posix-cpu-timers.o mutex.o \
 	    hrtimer.o rwsem.o nsproxy.o srcu.o semaphore.o \
 	    notifier.o ksysfs.o cred.o \
-	    async.o range.o groups.o
+	    async.o range.o groups.o lglock.o
 
 ifdef CONFIG_FUNCTION_TRACER
 # Do not trace debug files and internal ftrace files
diff --git a/kernel/lglock.c b/kernel/lglock.c
new file mode 100644
--- /dev/null
+++ b/kernel/lglock.c
@@ -0,0 +1,89 @@
+/* See include/linux/lglock.h for description */
+#include <linux/module.h>
+#include <linux/lglock.h>
+#include <linux/cpu.h>
+#include <linux/string.h>
+
+/*
+ * Note there is no uninit, so lglocks cannot be defined in
+ * modules (but it's fine to use them from there)
+ * Could be added though, just undo lg_lock_init
+ */
+
+void lg_lock_init(struct lglock *lg, char *name)
+{
+	LOCKDEP_INIT_MAP(&lg->lock_dep_map, name, &lg->lock_key, 0);
+}
+EXPORT_SYMBOL(lg_lock_init);
+
+void lg_local_lock(struct lglock *lg)
+{
+	arch_spinlock_t *lock;
+
+	preempt_disable();
+	rwlock_acquire_read(&lg->lock_dep_map, 0, 0, _RET_IP_);
+	lock = this_cpu_ptr(lg->lock);
+	arch_spin_lock(lock);
+}
+EXPORT_SYMBOL(lg_local_lock);
+
+void lg_local_unlock(struct lglock *lg)
+{
+	arch_spinlock_t *lock;
+
+	rwlock_release(&lg->lock_dep_map, 1, _RET_IP_);
+	lock = this_cpu_ptr(lg->lock);
+	arch_spin_unlock(lock);
+	preempt_enable();
+}
+EXPORT_SYMBOL(lg_local_unlock);
+
+void lg_local_lock_cpu(struct lglock *lg, int cpu)
+{
+	arch_spinlock_t *lock;
+
+	preempt_disable();
+	rwlock_acquire_read(&lg->lock_dep_map, 0, 0, _RET_IP_);
+	lock = per_cpu_ptr(lg->lock, cpu);
+	arch_spin_lock(lock);
+}
+EXPORT_SYMBOL(lg_local_lock_cpu);
+
+void lg_local_unlock_cpu(struct lglock *lg, int cpu)
+{
+	arch_spinlock_t *lock;
+
+	rwlock_release(&lg->lock_dep_map, 1, _RET_IP_);
+	lock = per_cpu_ptr(lg->lock, cpu);
+	arch_spin_unlock(lock);
+	preempt_enable();
+}
+EXPORT_SYMBOL(lg_local_unlock_cpu);
+
+void lg_global_lock(struct lglock *lg)
+{
+	int i;
+
+	preempt_disable();
+	rwlock_acquire(&lg->lock_dep_map, 0, 0, _RET_IP_);
+	for_each_possible_cpu(i) {
+		arch_spinlock_t *lock;
+		lock = per_cpu_ptr(lg->lock, i);
+		arch_spin_lock(lock);
+	}
+}
+EXPORT_SYMBOL(lg_global_lock);
+
+void lg_global_unlock(struct lglock *lg)
+{
+	int i;
+
+	rwlock_release(&lg->lock_dep_map, 1, _RET_IP_);
+	for_each_possible_cpu(i) {
+		arch_spinlock_t *lock;
+		lock = per_cpu_ptr(lg->lock, i);
+		arch_spin_unlock(lock);
+	}
+	preempt_enable();
+}
+EXPORT_SYMBOL(lg_global_unlock);
