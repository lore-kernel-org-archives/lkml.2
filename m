Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756148Ab2B0Xos (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 18:44:48 -0500
Received: from ozlabs.org ([203.10.76.45]:40978 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755917Ab2B0Xop (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 18:44:45 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: "Nick Piggin" <npiggin@kernel.dk>
Cc: <linux-kernel@vger.kernel.org> (linux-kernel)
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andi Kleen <ak@linux.intel.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        linux-fsdevel@vger.kernel.org
Subject: [PATCH] cpumask: fix lg_lock/br_lock.
User-Agent: Notmuch/0.6.1-1 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Tue, 28 Feb 2012 09:52:30 +1030
Message-ID: <87ehtf3lqh.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use a cpumask_var_t instead of cpumask_t.  We're doing plenty of
allocations here anyway, so it's not really an issue, and it sets a
good example.

(cpumask_t is obsolescent, as are the cpus_* functions).

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 fs/file_table.c        |    2 +-
 fs/namespace.c         |    4 +++-
 include/linux/lglock.h |   23 +++++++++++++----------
 3 files changed, 17 insertions(+), 12 deletions(-)

diff --git a/fs/file_table.c b/fs/file_table.c
--- a/fs/file_table.c
+++ b/fs/file_table.c
@@ -526,6 +526,6 @@ void __init files_init(unsigned long mem
 	n = (mempages * (PAGE_SIZE / 1024)) / 10;
 	files_stat.max_files = max_t(unsigned long, n, NR_FILE);
 	files_defer_init();
-	lg_lock_init(files_lglock);
+	lg_lock_init(files_lglock, GFP_KERNEL);
 	percpu_counter_init(&nr_files, 0);
 } 
diff --git a/fs/namespace.c b/fs/namespace.c
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -2576,7 +2576,9 @@ void __init mnt_init(void)
 	for (u = 0; u < HASH_SIZE; u++)
 		INIT_LIST_HEAD(&mount_hashtable[u]);
 
-	br_lock_init(vfsmount_lock);
+	err = br_lock_init(vfsmount_lock, GFP_KERNEL);
+	if (err)
+		panic("Failed to init vfsmount_lock: %d\n", err);
 
 	err = sysfs_init();
 	if (err)
diff --git a/include/linux/lglock.h b/include/linux/lglock.h
--- a/include/linux/lglock.h
+++ b/include/linux/lglock.h
@@ -25,7 +25,7 @@
 #include <linux/cpu.h>
 
 /* can make br locks by using local lock for read side, global lock for write */
-#define br_lock_init(name)	name##_lock_init()
+#define br_lock_init(name, gfp)	name##_lock_init(gfp)
 #define br_read_lock(name)	name##_local_lock()
 #define br_read_unlock(name)	name##_local_unlock()
 #define br_write_lock(name)	name##_global_lock_online()
@@ -35,7 +35,7 @@
 #define DEFINE_BRLOCK(name)	DEFINE_LGLOCK(name)
 
 
-#define lg_lock_init(name)	name##_lock_init()
+#define lg_lock_init(name, gfp)	name##_lock_init(gfp)
 #define lg_local_lock(name)	name##_local_lock()
 #define lg_local_unlock(name)	name##_local_unlock()
 #define lg_local_lock_cpu(name, cpu)	name##_local_lock_cpu(cpu)
@@ -61,7 +61,7 @@
 
 
 #define DECLARE_LGLOCK(name)						\
- extern void name##_lock_init(void);					\
+ extern int name##_lock_init(gfp_t gfp);				\
  extern void name##_local_lock(void);					\
  extern void name##_local_unlock(void);					\
  extern void name##_local_lock_cpu(int cpu);				\
@@ -74,7 +74,7 @@
 #define DEFINE_LGLOCK(name)						\
 									\
  DEFINE_SPINLOCK(name##_cpu_lock);					\
- cpumask_t name##_cpus __read_mostly;					\
+ cpumask_var_t name##_cpus __read_mostly;				\
  DEFINE_PER_CPU(arch_spinlock_t, name##_lock);				\
  DEFINE_LGLOCK_LOCKDEP(name);						\
 									\
@@ -85,12 +85,12 @@
 	switch (action & ~CPU_TASKS_FROZEN) {				\
 	case CPU_UP_PREPARE:						\
 		spin_lock(&name##_cpu_lock);				\
-		cpu_set((unsigned long)hcpu, name##_cpus);		\
+		cpumask_set_cpu((unsigned long)hcpu, name##_cpus);		\
 		spin_unlock(&name##_cpu_lock);				\
 		break;							\
 	case CPU_UP_CANCELED: case CPU_DEAD:				\
 		spin_lock(&name##_cpu_lock);				\
-		cpu_clear((unsigned long)hcpu, name##_cpus);		\
+		cpumask_clear_cpu((unsigned long)hcpu, name##_cpus);		\
 		spin_unlock(&name##_cpu_lock);				\
 	}								\
 	return NOTIFY_OK;						\
@@ -98,7 +98,7 @@
  static struct notifier_block name##_lg_cpu_notifier = {		\
 	.notifier_call = name##_lg_cpu_callback,			\
  };									\
- void name##_lock_init(void) {						\
+ int name##_lock_init(gfp_t gfp) {						\
 	int i;								\
 	LOCKDEP_INIT_MAP(&name##_lock_dep_map, #name, &name##_lock_key, 0); \
 	for_each_possible_cpu(i) {					\
@@ -107,10 +107,13 @@
 		*lock = (arch_spinlock_t)__ARCH_SPIN_LOCK_UNLOCKED;	\
 	}								\
 	register_hotcpu_notifier(&name##_lg_cpu_notifier);		\
+	if (!alloc_cpumask_var(&name##_cpus, gfp))			\
+		return -ENOMEM;						\
 	get_online_cpus();						\
 	for_each_online_cpu(i)						\
-		cpu_set(i, name##_cpus);				\
+		cpumask_set_cpu(i, name##_cpus);			\
 	put_online_cpus();						\
+	return 0;							\
  }									\
  EXPORT_SYMBOL(name##_lock_init);					\
 									\
@@ -154,7 +157,7 @@
 	int i;								\
 	spin_lock(&name##_cpu_lock);					\
 	rwlock_acquire(&name##_lock_dep_map, 0, 0, _RET_IP_);		\
-	for_each_cpu(i, &name##_cpus) {					\
+	for_each_cpu(i, name##_cpus) {					\
 		arch_spinlock_t *lock;					\
 		lock = &per_cpu(name##_lock, i);			\
 		arch_spin_lock(lock);					\
@@ -165,7 +168,7 @@
  void name##_global_unlock_online(void) {				\
 	int i;								\
 	rwlock_release(&name##_lock_dep_map, 1, _RET_IP_);		\
-	for_each_cpu(i, &name##_cpus) {					\
+	for_each_cpu(i, name##_cpus) {					\
 		arch_spinlock_t *lock;					\
 		lock = &per_cpu(name##_lock, i);			\
 		arch_spin_unlock(lock);					\
