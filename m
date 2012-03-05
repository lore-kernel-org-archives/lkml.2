Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755172Ab2CEHIJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 02:08:09 -0500
Received: from ozlabs.org ([203.10.76.45]:48469 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751643Ab2CEHIH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 02:08:07 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Andi Kleen <ak@linux.intel.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: Nick Piggin <npiggin@kernel.dk>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        linux-fsdevel@vger.kernel.org
Subject: [PATCH 1/3] lglock: remove online variants of lock
In-Reply-To: <20120228112422.GC11324@alboin.amr.corp.intel.com>
References: <87ehtf3lqh.fsf@rustcorp.com.au> <20120227155338.7b5110cd.akpm@linux-foundation.org> <20120228112422.GC11324@alboin.amr.corp.intel.com>
User-Agent: Notmuch/0.6.1-1 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Mon, 05 Mar 2012 17:33:41 +1030
Message-ID: <87obsbzfzm.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Optimizing the slow paths adds a lot of complexity.  If you need to
grab every lock often, you have other problems.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 include/linux/lglock.h |   58 +------------------------------------------------
 1 file changed, 2 insertions(+), 56 deletions(-)

diff --git a/include/linux/lglock.h b/include/linux/lglock.h
--- a/include/linux/lglock.h
+++ b/include/linux/lglock.h
@@ -28,8 +28,8 @@
 #define br_lock_init(name)	name##_lock_init()
 #define br_read_lock(name)	name##_local_lock()
 #define br_read_unlock(name)	name##_local_unlock()
-#define br_write_lock(name)	name##_global_lock_online()
-#define br_write_unlock(name)	name##_global_unlock_online()
+#define br_write_lock(name)	name##_global_lock()
+#define br_write_unlock(name)	name##_global_unlock()
 
 #define DECLARE_BRLOCK(name)	DECLARE_LGLOCK(name)
 #define DEFINE_BRLOCK(name)	DEFINE_LGLOCK(name)
@@ -42,8 +42,6 @@
 #define lg_local_unlock_cpu(name, cpu)	name##_local_unlock_cpu(cpu)
 #define lg_global_lock(name)	name##_global_lock()
 #define lg_global_unlock(name)	name##_global_unlock()
-#define lg_global_lock_online(name) name##_global_lock_online()
-#define lg_global_unlock_online(name) name##_global_unlock_online()
 
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 #define LOCKDEP_INIT_MAP lockdep_init_map
@@ -68,36 +66,13 @@
  extern void name##_local_unlock_cpu(int cpu);				\
  extern void name##_global_lock(void);					\
  extern void name##_global_unlock(void);				\
- extern void name##_global_lock_online(void);				\
- extern void name##_global_unlock_online(void);				\
 
 #define DEFINE_LGLOCK(name)						\
 									\
  DEFINE_SPINLOCK(name##_cpu_lock);					\
- cpumask_t name##_cpus __read_mostly;					\
  DEFINE_PER_CPU(arch_spinlock_t, name##_lock);				\
  DEFINE_LGLOCK_LOCKDEP(name);						\
 									\
- static int								\
- name##_lg_cpu_callback(struct notifier_block *nb,			\
-				unsigned long action, void *hcpu)	\
- {									\
-	switch (action & ~CPU_TASKS_FROZEN) {				\
-	case CPU_UP_PREPARE:						\
-		spin_lock(&name##_cpu_lock);				\
-		cpu_set((unsigned long)hcpu, name##_cpus);		\
-		spin_unlock(&name##_cpu_lock);				\
-		break;							\
-	case CPU_UP_CANCELED: case CPU_DEAD:				\
-		spin_lock(&name##_cpu_lock);				\
-		cpu_clear((unsigned long)hcpu, name##_cpus);		\
-		spin_unlock(&name##_cpu_lock);				\
-	}								\
-	return NOTIFY_OK;						\
- }									\
- static struct notifier_block name##_lg_cpu_notifier = {		\
-	.notifier_call = name##_lg_cpu_callback,			\
- };									\
  void name##_lock_init(void) {						\
 	int i;								\
 	LOCKDEP_INIT_MAP(&name##_lock_dep_map, #name, &name##_lock_key, 0); \
@@ -106,11 +81,6 @@
 		lock = &per_cpu(name##_lock, i);			\
 		*lock = (arch_spinlock_t)__ARCH_SPIN_LOCK_UNLOCKED;	\
 	}								\
-	register_hotcpu_notifier(&name##_lg_cpu_notifier);		\
-	get_online_cpus();						\
-	for_each_online_cpu(i)						\
-		cpu_set(i, name##_cpus);				\
-	put_online_cpus();						\
  }									\
  EXPORT_SYMBOL(name##_lock_init);					\
 									\
@@ -150,30 +120,6 @@
  }									\
  EXPORT_SYMBOL(name##_local_unlock_cpu);				\
 									\
- void name##_global_lock_online(void) {					\
-	int i;								\
-	spin_lock(&name##_cpu_lock);					\
-	rwlock_acquire(&name##_lock_dep_map, 0, 0, _RET_IP_);		\
-	for_each_cpu(i, &name##_cpus) {					\
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
-	for_each_cpu(i, &name##_cpus) {					\
-		arch_spinlock_t *lock;					\
-		lock = &per_cpu(name##_lock, i);			\
-		arch_spin_unlock(lock);					\
-	}								\
-	spin_unlock(&name##_cpu_lock);					\
- }									\
- EXPORT_SYMBOL(name##_global_unlock_online);				\
-									\
  void name##_global_lock(void) {					\
 	int i;								\
 	preempt_disable();						\
