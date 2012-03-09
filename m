Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030218Ab2CIToX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 14:44:23 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:23714 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030202Ab2CIToU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 14:44:20 -0500
X-Authority-Analysis: v=2.0 cv=Wf+OmjdX c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=msNg5mo5BqwA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=wn49sLJ94mFynMGKJwgA:9 a=FeCKyY9VOcSO7sqHXPsA:7 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1331322256.25686.599.camel@gandalf.stny.rr.com>
Subject: [PATCH RT][RFC] spin_trylock: Add "_rt" version that gives the lock
 a priority
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>, RT <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Clark Williams <clark@redhat.com>
Date: Fri, 09 Mar 2012 14:44:16 -0500
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is just an RFC patch. I got it working and tested a bit with
CONFIG_PREEMPT_RT_FULL. It probably breaks non PREEMPT_RT_FULL configs
and it can be broken into 2 or 3 patches. But as this is just an RFC, I
wanted to post it before doing more work on it.

I had to move the MAX_RT_PRIO and friends out of sched.h and into a new
file called sched_prio.h to avoid macro include hell.

Here's the gist of it:

rtmutex locks now have a plist_node attribute that works like the
rt_waiter's pi_list_entry. A lock can be added to a task's "prio_locks"
which is a plist_head (like pi_waiters). The adjustment of a tasks
priority is determined by its normal_prio, the top waiter of the
prio_locks and the top waiter of the pi_waiters. 

When a spin_trylock_rt() fails to grab the lock, it sets the lock's
lock_entry.prio to its priority, (if it has a greater priority) and adds
the lock to the owner's prio_locks list, and adjusts the owner's
priority. It also sets the "has_waiters" bit of the lock->owner field to
force the owner into the slow path.

When the owner releases the lock, it also removes the lock from its list
and resets the priority of the lock to the default value.

I added a cpu_relax_rt() that does the yield() if the task is in a
TASK_RUNNING state. I probably should put a WARN_ON(!TASK_RUNNING). I
kept the cpu_chill() for the places that wait for a bit to change and
not on a lock.

We probably want the WARN_ON(!TASK_RUNNING) test in cpu_chill() as well,
because the msleep() will change the state of the task.

This is a RFC patch, let me know what you think, and if you have better
ideas, lets hear them :-)

-- Steve

Not-yet-Signed-off-by: Steven Rostedt <rostedt@goodmis.org>


---
 fs/autofs4/expire.c         |    4 -
 fs/dcache.c                 |   14 ++--
 include/linux/delay.h       |    8 ++
 include/linux/rtmutex.h     |    8 ++
 include/linux/sched.h       |   29 +---------
 include/linux/sched_prio.h  |   30 ++++++++++
 include/linux/seqlock.h     |    5 +
 include/linux/spinlock.h    |    2 
 include/linux/spinlock_rt.h |   11 ++-
 kernel/fork.c               |    1 
 kernel/rtmutex.c            |  127 ++++++++++++++++++++++++++++++++++++++++----
 kernel/sched.c              |    1 
 12 files changed, 191 insertions(+), 49 deletions(-)

diff --git a/fs/autofs4/expire.c b/fs/autofs4/expire.c
index f4abda3..f60d80b 100644
--- a/fs/autofs4/expire.c
+++ b/fs/autofs4/expire.c
@@ -168,9 +168,9 @@ again:
 			}
 
 			parent = p->d_parent;
-			if (!seq_spin_trylock(&parent->d_lock)) {
+			if (!seq_spin_trylock_rt(&parent->d_lock)) {
 				seq_spin_unlock(&p->d_lock);
-				cpu_chill();
+				cpu_relax_rt();
 				goto relock;
 			}
 			seq_spin_unlock(&p->d_lock);
diff --git a/fs/dcache.c b/fs/dcache.c
index 09a7f00..60c2197 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -408,17 +408,17 @@ static inline struct dentry *dentry_kill(struct dentry *dentry, int ref)
 	struct dentry *parent;
 
 	inode = dentry->d_inode;
-	if (inode && !spin_trylock(&inode->i_lock)) {
+	if (inode && !spin_trylock_rt(&inode->i_lock)) {
 relock:
 		seq_spin_unlock(&dentry->d_lock);
-		cpu_chill();
+		cpu_relax_rt();
 		return dentry; /* try again with same dentry */
 	}
 	if (IS_ROOT(dentry))
 		parent = NULL;
 	else
 		parent = dentry->d_parent;
-	if (parent && !seq_spin_trylock(&parent->d_lock)) {
+	if (parent && !seq_spin_trylock_rt(&parent->d_lock)) {
 		if (inode)
 			spin_unlock(&inode->i_lock);
 		goto relock;
@@ -795,9 +795,9 @@ relock:
 				struct dentry, d_lru);
 		BUG_ON(dentry->d_sb != sb);
 
-		if (!seq_spin_trylock(&dentry->d_lock)) {
+		if (!seq_spin_trylock_rt(&dentry->d_lock)) {
 			spin_unlock(&dcache_lru_lock);
-			cpu_chill();
+			cpu_relax_rt();
 			goto relock;
 		}
 
@@ -1973,9 +1973,9 @@ again:
 	inode = dentry->d_inode;
 	isdir = S_ISDIR(inode->i_mode);
 	if (dentry->d_count == 1) {
-		if (inode && !spin_trylock(&inode->i_lock)) {
+		if (inode && !spin_trylock_rt(&inode->i_lock)) {
 			seq_spin_unlock(&dentry->d_lock);
-			cpu_chill();
+			cpu_relax_rt();
 			goto again;
 		}
 		dentry->d_flags &= ~DCACHE_CANT_MOUNT;
diff --git a/include/linux/delay.h b/include/linux/delay.h
index e23a7c0..68cf743 100644
--- a/include/linux/delay.h
+++ b/include/linux/delay.h
@@ -53,8 +53,16 @@ static inline void ssleep(unsigned int seconds)
 }
 
 #ifdef CONFIG_PREEMPT_RT_FULL
+# define cpu_relax_rt()						\
+	do {							\
+		if (likely(current->state == TASK_RUNNING))	\
+			yield();				\
+		else						\
+			cpu_relax();				\
+	} while (0)
 # define cpu_chill()	msleep(1)
 #else
+# define cpu_relax_rt()	cpu_relax()
 # define cpu_chill()	cpu_relax()
 #endif
 
diff --git a/include/linux/rtmutex.h b/include/linux/rtmutex.h
index 5ebd0bb..ddd081c 100644
--- a/include/linux/rtmutex.h
+++ b/include/linux/rtmutex.h
@@ -14,6 +14,7 @@
 
 #include <linux/linkage.h>
 #include <linux/plist.h>
+#include <linux/sched_prio.h>
 #include <linux/spinlock_types_raw.h>
 
 extern int max_lock_depth; /* for sysctl */
@@ -28,6 +29,7 @@ extern int max_lock_depth; /* for sysctl */
 struct rt_mutex {
 	raw_spinlock_t		wait_lock;
 	struct plist_head	wait_list;
+	struct plist_node	lock_entry;
 	struct task_struct	*owner;
 	int			save_state;
 #ifdef CONFIG_DEBUG_RT_MUTEXES
@@ -77,9 +79,12 @@ struct hrtimer_sleeper;
 # define rt_mutex_debug_task_free(t)			do { } while (0)
 #endif
 
+#define LOCK_PRIO_DEFAULT		MAX_RT_PRIO
+
 #define __RT_MUTEX_INITIALIZER_PLAIN(mutexname) \
 	.wait_lock = __RAW_SPIN_LOCK_UNLOCKED(mutexname.wait_lock) \
 	, .wait_list = PLIST_HEAD_INIT(mutexname.wait_list) \
+	, .lock_entry = PLIST_NODE_INIT(mutexname.lock_entry, LOCK_PRIO_DEFAULT) \
 	, .owner = NULL \
 	__DEBUG_RT_MUTEX_INITIALIZER(mutexname)
 
@@ -121,8 +126,9 @@ extern int rt_mutex_trylock(struct rt_mutex *lock);
 extern void rt_mutex_unlock(struct rt_mutex *lock);
 
 #ifdef CONFIG_RT_MUTEXES
-# define INIT_RT_MUTEXES(tsk)						\
+# define INIT_RT_MUTEXES(tsk)					\
 	.pi_waiters	= PLIST_HEAD_INIT(tsk.pi_waiters),	\
+	.prio_locks	= PLIST_HEAD_INIT(tsk.prio_locks),	\
 	INIT_RT_MUTEX_DEBUG(tsk)
 #else
 # define INIT_RT_MUTEXES(tsk)
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 1f6b11a..6dc66cf 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -62,6 +62,7 @@ struct sched_param {
 #include <linux/errno.h>
 #include <linux/nodemask.h>
 #include <linux/mm_types.h>
+#include <linux/sched_prio.h>
 
 #include <asm/kmap_types.h>
 #include <asm/system.h>
@@ -1440,6 +1441,8 @@ struct task_struct {
 #ifdef CONFIG_RT_MUTEXES
 	/* PI waiters blocked on a rt_mutex held by this task */
 	struct plist_head pi_waiters;
+	/* Locks held that have prioirty */
+	struct plist_head prio_locks;
 	/* Deadlock detection and priority inheritance handling */
 	struct rt_mutex_waiter *pi_blocked_on;
 #endif
@@ -1621,32 +1624,6 @@ static inline bool pagefault_disabled(void)
 	return in_atomic() || cur_pf_disabled();
 }
 
-/*
- * Priority of a process goes from 0..MAX_PRIO-1, valid RT
- * priority is 0..MAX_RT_PRIO-1, and SCHED_NORMAL/SCHED_BATCH
- * tasks are in the range MAX_RT_PRIO..MAX_PRIO-1. Priority
- * values are inverted: lower p->prio value means higher priority.
- *
- * The MAX_USER_RT_PRIO value allows the actual maximum
- * RT priority to be separate from the value exported to
- * user-space.  This allows kernel threads to set their
- * priority to a value higher than any user task. Note:
- * MAX_RT_PRIO must not be smaller than MAX_USER_RT_PRIO.
- */
-
-#define MAX_USER_RT_PRIO	100
-#define MAX_RT_PRIO		MAX_USER_RT_PRIO
-
-#define MAX_PRIO		(MAX_RT_PRIO + 40)
-#define DEFAULT_PRIO		(MAX_RT_PRIO + 20)
-
-static inline int rt_prio(int prio)
-{
-	if (unlikely(prio < MAX_RT_PRIO))
-		return 1;
-	return 0;
-}
-
 static inline int rt_task(struct task_struct *p)
 {
 	return rt_prio(p->prio);
diff --git a/include/linux/sched_prio.h b/include/linux/sched_prio.h
new file mode 100644
index 0000000..2087706
--- /dev/null
+++ b/include/linux/sched_prio.h
@@ -0,0 +1,30 @@
+#ifndef _LINUX_SCHED_PRIO_H
+#define _LINUX_SCHED_PRIO_H
+
+/*
+ * Priority of a process goes from 0..MAX_PRIO-1, valid RT
+ * priority is 0..MAX_RT_PRIO-1, and SCHED_NORMAL/SCHED_BATCH
+ * tasks are in the range MAX_RT_PRIO..MAX_PRIO-1. Priority
+ * values are inverted: lower p->prio value means higher priority.
+ *
+ * The MAX_USER_RT_PRIO value allows the actual maximum
+ * RT priority to be separate from the value exported to
+ * user-space.  This allows kernel threads to set their
+ * priority to a value higher than any user task. Note:
+ * MAX_RT_PRIO must not be smaller than MAX_USER_RT_PRIO.
+ */
+
+#define MAX_USER_RT_PRIO	100
+#define MAX_RT_PRIO		MAX_USER_RT_PRIO
+
+#define MAX_PRIO		(MAX_RT_PRIO + 40)
+#define DEFAULT_PRIO		(MAX_RT_PRIO + 20)
+
+static inline int rt_prio(int prio)
+{
+	if (unlikely(prio < MAX_RT_PRIO))
+		return 1;
+	return 0;
+}
+
+#endif
diff --git a/include/linux/seqlock.h b/include/linux/seqlock.h
index 29ffd4f..b02028f 100644
--- a/include/linux/seqlock.h
+++ b/include/linux/seqlock.h
@@ -297,6 +297,11 @@ static inline int seq_spin_trylock(seqlock_t *sl)
 	return spin_trylock(&sl->lock);
 }
 
+static inline int seq_spin_trylock_rt(seqlock_t *sl)
+{
+	return spin_trylock_rt(&sl->lock);
+}
+
 static inline void seq_spin_unlock(seqlock_t *sl)
 {
 	spin_unlock(&sl->lock);
diff --git a/include/linux/spinlock.h b/include/linux/spinlock.h
index 5fe7e40..2ff9963 100644
--- a/include/linux/spinlock.h
+++ b/include/linux/spinlock.h
@@ -303,6 +303,8 @@ static inline int spin_trylock(spinlock_t *lock)
 	return raw_spin_trylock(&lock->rlock);
 }
 
+#define spin_trylock_rt(lock)		spin_trylock(lock)
+
 #define spin_lock_nested(lock, subclass)			\
 do {								\
 	raw_spin_lock_nested(spinlock_check(lock), subclass);	\
diff --git a/include/linux/spinlock_rt.h b/include/linux/spinlock_rt.h
index 3b555b4..10fd55d 100644
--- a/include/linux/spinlock_rt.h
+++ b/include/linux/spinlock_rt.h
@@ -23,7 +23,7 @@ extern void __lockfunc rt_spin_unlock(spinlock_t *lock);
 extern void __lockfunc rt_spin_unlock_wait(spinlock_t *lock);
 extern int __lockfunc rt_spin_trylock_irqsave(spinlock_t *lock, unsigned long *flags);
 extern int __lockfunc rt_spin_trylock_bh(spinlock_t *lock);
-extern int __lockfunc rt_spin_trylock(spinlock_t *lock);
+extern int __lockfunc rt_spin_trylock(spinlock_t *lock, int pi);
 extern int atomic_dec_and_spin_lock(atomic_t *atomic, spinlock_t *lock);
 
 /*
@@ -51,18 +51,21 @@ extern void __lockfunc __rt_spin_unlock(struct rt_mutex *lock);
 
 #define spin_lock_irq(lock)		spin_lock(lock)
 
-#define spin_do_trylock(lock)		__cond_lock(lock, rt_spin_trylock(lock))
+#define spin_do_trylock(lock, pi)	__cond_lock(lock, rt_spin_trylock(lock, pi))
 
-#define spin_trylock(lock)			\
+#define __spin_trylock(lock, pi)		\
 ({						\
 	int __locked;				\
 	migrate_disable();			\
-	__locked = spin_do_trylock(lock);	\
+	__locked = spin_do_trylock(lock, pi);	\
 	if (!__locked)				\
 		migrate_enable();		\
 	__locked;				\
 })
 
+#define spin_trylock(lock)		__spin_trylock(lock, 0)
+#define spin_trylock_rt(lock)		__spin_trylock(lock, 1)
+
 #ifdef CONFIG_LOCKDEP
 # define spin_lock_nested(lock, subclass)		\
 	do {						\
diff --git a/kernel/fork.c b/kernel/fork.c
index a5fed83..55fccaf 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1034,6 +1034,7 @@ static void rt_mutex_init_task(struct task_struct *p)
 	raw_spin_lock_init(&p->pi_lock);
 #ifdef CONFIG_RT_MUTEXES
 	plist_head_init(&p->pi_waiters);
+	plist_head_init(&p->prio_locks);
 	p->pi_blocked_on = NULL;
 #endif
 }
diff --git a/kernel/rtmutex.c b/kernel/rtmutex.c
index b525158..ff9138d 100644
--- a/kernel/rtmutex.c
+++ b/kernel/rtmutex.c
@@ -69,7 +69,8 @@ static inline void clear_rt_mutex_waiters(struct rt_mutex *lock)
 
 static void fixup_rt_mutex_waiters(struct rt_mutex *lock)
 {
-	if (!rt_mutex_has_waiters(lock))
+	if (!rt_mutex_has_waiters(lock) &&
+	    likely(lock->lock_entry.prio == LOCK_PRIO_DEFAULT))
 		clear_rt_mutex_waiters(lock);
 }
 
@@ -79,6 +80,18 @@ static int rt_mutex_real_waiter(struct rt_mutex_waiter *waiter)
 		waiter != PI_REQUEUE_INPROGRESS;
 }
 
+static inline int task_has_pi_locks(struct task_struct *p)
+{
+	return !plist_head_empty(&p->prio_locks);
+}
+
+static inline struct rt_mutex *
+task_top_pi_lock(struct task_struct *p)
+{
+	return plist_first_entry(&p->prio_locks, struct rt_mutex,
+				  lock_entry);
+}
+
 /*
  * We can speed up the acquire/release, if the architecture
  * supports cmpxchg and if there's no debugging state to be set up
@@ -104,8 +117,10 @@ static inline void mark_rt_mutex_waiters(struct rt_mutex *lock)
 
 static inline void init_lists(struct rt_mutex *lock)
 {
-	if (unlikely(!lock->wait_list.node_list.prev))
+	if (unlikely(!lock->wait_list.node_list.prev)) {
 		plist_head_init(&lock->wait_list);
+		plist_node_init(&lock->lock_entry, LOCK_PRIO_DEFAULT);
+	}
 }
 
 /*
@@ -116,11 +131,15 @@ static inline void init_lists(struct rt_mutex *lock)
  */
 int rt_mutex_getprio(struct task_struct *task)
 {
+	int ret = task->normal_prio;
+
+	if (unlikely(task_has_pi_locks(task)))
+		ret = min(task_top_pi_lock(task)->lock_entry.prio, ret);
+
 	if (likely(!task_has_pi_waiters(task)))
-		return task->normal_prio;
+		return ret;
 
-	return min(task_top_pi_waiter(task)->pi_list_entry.prio,
-		   task->normal_prio);
+	return min(task_top_pi_waiter(task)->pi_list_entry.prio, ret);
 }
 
 /*
@@ -786,6 +805,21 @@ static void  noinline __sched rt_spin_lock_slowlock(struct rt_mutex *lock)
 	debug_rt_mutex_free_waiter(&waiter);
 }
 
+static void reset_prio_lock(struct task_struct *owner, struct rt_mutex *lock)
+{
+	if (likely(plist_node_empty(&lock->lock_entry)))
+		return;
+
+	raw_spin_lock_irq(&owner->pi_lock);
+
+	plist_del(&lock->lock_entry, &owner->prio_locks);
+	lock->lock_entry.prio = LOCK_PRIO_DEFAULT;
+
+	__rt_mutex_adjust_prio(owner);
+
+	raw_spin_unlock_irq(&owner->pi_lock);
+}
+
 /*
  * Slow path to release a rt_mutex spin_lock style
  */
@@ -797,6 +831,8 @@ static void  noinline __sched rt_spin_lock_slowunlock(struct rt_mutex *lock)
 
 	rt_mutex_deadlock_account_unlock(current);
 
+	reset_prio_lock(current, lock);
+
 	if (!rt_mutex_has_waiters(lock)) {
 		lock->owner = NULL;
 		raw_spin_unlock(&lock->wait_lock);
@@ -859,9 +895,16 @@ void __lockfunc rt_spin_unlock_wait(spinlock_t *lock)
 }
 EXPORT_SYMBOL(rt_spin_unlock_wait);
 
-int __lockfunc rt_spin_trylock(spinlock_t *lock)
+static int rt_mutex_trylock_pi(struct rt_mutex *lock);
+
+int __lockfunc rt_spin_trylock(spinlock_t *lock, int pi)
 {
-	int ret = rt_mutex_trylock(&lock->lock);
+	int ret;
+
+	if (pi)
+		ret = rt_mutex_trylock_pi(&lock->lock);
+	else
+		ret = rt_mutex_trylock(&lock->lock);
 
 	if (ret)
 		spin_acquire(&lock->dep_map, 0, 1, _RET_IP_);
@@ -1044,11 +1087,52 @@ rt_mutex_slowlock(struct rt_mutex *lock, int state,
 	return ret;
 }
 
+static void
+set_lock_prio(struct rt_mutex *lock, struct task_struct *tsk)
+{
+	struct task_struct *owner;
+	int prio;
+
+	/*
+	 * Take a snapshot of the task's prio, we don't
+	 * hold any locks and it may change. If it goes up
+	 * it will update the priority of the lock in it's next
+	 * iteration of the spin_trylock() loop. If it goes down,
+	 * heh, the owner will reset the priority after it
+	 * releases the lock. No worry about priority leakage.
+	 */
+	prio = ACCESS_ONCE(tsk->prio);
+
+	if (lock->lock_entry.prio <= prio)
+		return;
+
+	owner = rt_mutex_owner(lock);
+
+	raw_spin_lock_irq(&owner->pi_lock);
+
+	plist_del(&lock->lock_entry, &owner->prio_locks);
+	lock->lock_entry.prio = prio;
+	plist_add(&lock->lock_entry, &owner->prio_locks);
+
+	__rt_mutex_adjust_prio(owner);
+
+	raw_spin_unlock_irq(&owner->pi_lock);
+
+	/* Don't let the owner disappear */
+	get_task_struct(owner);
+	raw_spin_unlock(&lock->wait_lock);
+
+	rt_mutex_adjust_prio_chain(owner, 0, lock, NULL, NULL);
+	
+	raw_spin_lock(&lock->wait_lock);
+	put_task_struct(owner);
+}
+
 /*
  * Slow path try-lock function:
  */
 static inline int
-rt_mutex_slowtrylock(struct rt_mutex *lock)
+__rt_mutex_slowtrylock(struct rt_mutex *lock, int pi)
 {
 	int ret = 0;
 
@@ -1061,8 +1145,15 @@ rt_mutex_slowtrylock(struct rt_mutex *lock)
 		/*
 		 * try_to_take_rt_mutex() sets the lock waiters
 		 * bit unconditionally. Clean this up.
+		 * Unless we fail to take the lock, and pi is set.
+		 * Then we want to give the owner the priority of
+		 * this lock, and keep the "waiters" bit set to
+		 * force the owner into the slow path on unlock.
 		 */
-		fixup_rt_mutex_waiters(lock);
+		if (ret || !pi)
+			fixup_rt_mutex_waiters(lock);
+		else
+			set_lock_prio(lock, current);
 	}
 
 	raw_spin_unlock(&lock->wait_lock);
@@ -1070,6 +1161,18 @@ rt_mutex_slowtrylock(struct rt_mutex *lock)
 	return ret;
 }
 
+static inline int
+rt_mutex_slowtrylock(struct rt_mutex *lock)
+{
+	return __rt_mutex_slowtrylock(lock, 0);
+}
+
+static inline int
+rt_mutex_slowtrylock_pi(struct rt_mutex *lock)
+{
+	return __rt_mutex_slowtrylock(lock, 1);
+}
+
 /*
  * Slow path to release a rt-mutex:
  */
@@ -1245,6 +1348,11 @@ int __sched rt_mutex_trylock(struct rt_mutex *lock)
 }
 EXPORT_SYMBOL_GPL(rt_mutex_trylock);
 
+static int rt_mutex_trylock_pi(struct rt_mutex *lock)
+{
+	return rt_mutex_fasttrylock(lock, rt_mutex_slowtrylock_pi);
+}
+
 /**
  * rt_mutex_unlock - unlock a rt_mutex
  *
@@ -1287,6 +1395,7 @@ void __rt_mutex_init(struct rt_mutex *lock, const char *name)
 {
 	lock->owner = NULL;
 	plist_head_init(&lock->wait_list);
+	plist_node_init(&lock->lock_entry, LOCK_PRIO_DEFAULT);
 
 	debug_rt_mutex_init(lock, name);
 }
diff --git a/kernel/sched.c b/kernel/sched.c
index 1cc706d..24e8d26 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -8531,6 +8531,7 @@ void __init sched_init(void)
 
 #ifdef CONFIG_RT_MUTEXES
 	plist_head_init(&init_task.pi_waiters);
+	plist_head_init(&init_task.prio_locks);
 #endif
 
 	/*


