Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757371Ab0DOH33 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 03:29:29 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:58168 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757348Ab0DOH3Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 03:29:25 -0400
Subject: Re: [RFC][PATCH 09/11] sched: first draft of deadline inheritance.
From: Peter Zijlstra <peterz@infradead.org>
To: Raistlin <raistlin@linux.it>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>,
       Chris Friesen <cfriesen@nortel.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Darren Hart <darren@dvhart.com>, Henrik Austad <henrik@austad.us>,
       Johan Eker <johan.eker@ericsson.com>, "p.faure" <p.faure@akatech.ch>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Claudio Scordino <claudio@evidence.eu.com>,
       michael trimarchi <trimarchi@retis.sssup.it>,
       Fabio Checconi <fabio@gandalf.sssup.it>,
       Tommaso Cucinotta <t.cucinotta@sssup.it>,
       Juri Lelli <juri.lelli@gmail.com>,
       Nicola Manica <nicola.manica@gmail.com>,
       Luca Abeni <luca.abeni@unitn.it>
In-Reply-To: <1271233500.32749.10.camel@laptop>
References: <1267383976.13676.79.camel@Palantir>
	 <1267385165.13676.99.camel@Palantir>  <1271233500.32749.10.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 14 Apr 2010 11:45:46 +0200
Message-ID: <1271238346.32749.11.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-04-14 at 10:25 +0200, Peter Zijlstra wrote:
> I think it would be relatively straight forward to modify the existing
> PI chain code to work using an RB-tree instead of the plist stuff.
> 
Something like the below (totally untested)

---
 include/linux/init_task.h |   10 ++++
 include/linux/rtmutex.h   |   13 +----
 include/linux/sched.h     |    3 +-
 kernel/fork.c             |    3 +-
 kernel/rtmutex-debug.c    |    8 +--
 kernel/rtmutex.c          |  121 +++++++++++++++++++++++++++++++++++---------
 kernel/rtmutex_common.h   |   21 ++++----
 kernel/sched.c            |    4 --
 8 files changed, 125 insertions(+), 58 deletions(-)

diff --git a/include/linux/init_task.h b/include/linux/init_task.h
index b1ed1cd..2ee9259 100644
--- a/include/linux/init_task.h
+++ b/include/linux/init_task.h
@@ -10,6 +10,7 @@
 #include <linux/pid_namespace.h>
 #include <linux/user_namespace.h>
 #include <linux/securebits.h>
+#include <linux/rbtree.h>
 #include <net/net_namespace.h>
 
 extern struct files_struct init_files;
@@ -103,6 +104,14 @@ extern struct cred init_cred;
 # define INIT_PERF_EVENTS(tsk)
 #endif
 
+#ifdef CONFIG_RT_MUTEXES
+# define INIT_RT_MUTEXES						\
+	.pi_waiters = RB_ROOT,						\
+	.pi_waiters_leftmost = NULL,
+#else
+# define INIT_RT_MUTEXES
+#endif
+
 /*
  *  INIT_TASK is used to set up the first task table, touch at
  * your own risk!. Base=0, limit=0x1fffff (=2MB)
@@ -172,6 +181,7 @@ extern struct cred init_cred;
 	INIT_FTRACE_GRAPH						\
 	INIT_TRACE_RECURSION						\
 	INIT_TASK_RCU_PREEMPT(tsk)					\
+	INIT_RT_MUTEXES							\
 }
 
 
diff --git a/include/linux/rtmutex.h b/include/linux/rtmutex.h
index 8d522ff..8a68b29 100644
--- a/include/linux/rtmutex.h
+++ b/include/linux/rtmutex.h
@@ -13,7 +13,7 @@
 #define __LINUX_RT_MUTEX_H
 
 #include <linux/linkage.h>
-#include <linux/plist.h>
+#include <linux/rbtree.h>
 #include <linux/spinlock_types.h>
 
 extern int max_lock_depth; /* for sysctl */
@@ -27,7 +27,8 @@ extern int max_lock_depth; /* for sysctl */
  */
 struct rt_mutex {
 	raw_spinlock_t		wait_lock;
-	struct plist_head	wait_list;
+	struct rb_root		waiters;
+	struct rb_node		*waiters_leftmost;
 	struct task_struct	*owner;
 #ifdef CONFIG_DEBUG_RT_MUTEXES
 	int			save_state;
@@ -98,12 +99,4 @@ extern int rt_mutex_trylock(struct rt_mutex *lock);
 
 extern void rt_mutex_unlock(struct rt_mutex *lock);
 
-#ifdef CONFIG_RT_MUTEXES
-# define INIT_RT_MUTEXES(tsk)						\
-	.pi_waiters	= PLIST_HEAD_INIT(tsk.pi_waiters, tsk.pi_lock),	\
-	INIT_RT_MUTEX_DEBUG(tsk)
-#else
-# define INIT_RT_MUTEXES(tsk)
-#endif
-
 #endif
diff --git a/include/linux/sched.h b/include/linux/sched.h
index c46b6e5..d4bf0c2 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1364,7 +1364,8 @@ struct task_struct {
 
 #ifdef CONFIG_RT_MUTEXES
 	/* PI waiters blocked on a rt_mutex held by this task */
-	struct plist_head pi_waiters;
+	struct rb_root pi_waiters;
+	struct rb_node *pi_waiters_leftmost;
 	/* Deadlock detection and priority inheritance handling */
 	struct rt_mutex_waiter *pi_blocked_on;
 #endif
diff --git a/kernel/fork.c b/kernel/fork.c
index 5d3592d..23e037f 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -918,7 +918,8 @@ static void rt_mutex_init_task(struct task_struct *p)
 {
 	raw_spin_lock_init(&p->pi_lock);
 #ifdef CONFIG_RT_MUTEXES
-	plist_head_init_raw(&p->pi_waiters, &p->pi_lock);
+	p->pi_waiters = RB_ROOT;
+	p->pi_waiters_leftmost = NULL;
 	p->pi_blocked_on = NULL;
 #endif
 }
diff --git a/kernel/rtmutex-debug.c b/kernel/rtmutex-debug.c
index ddabb54..7cc8376 100644
--- a/kernel/rtmutex-debug.c
+++ b/kernel/rtmutex-debug.c
@@ -23,7 +23,7 @@
 #include <linux/kallsyms.h>
 #include <linux/syscalls.h>
 #include <linux/interrupt.h>
-#include <linux/plist.h>
+#include <linux/rbtree.h>
 #include <linux/fs.h>
 #include <linux/debug_locks.h>
 
@@ -111,7 +111,7 @@ static void printk_lock(struct rt_mutex *lock, int print_owner)
 
 void rt_mutex_debug_task_free(struct task_struct *task)
 {
-	WARN_ON(!plist_head_empty(&task->pi_waiters));
+	WARN_ON(!RB_EMPTY_ROOT(&task->pi_waiters));
 	WARN_ON(task->pi_blocked_on);
 }
 
@@ -205,16 +205,12 @@ void debug_rt_mutex_proxy_unlock(struct rt_mutex *lock)
 void debug_rt_mutex_init_waiter(struct rt_mutex_waiter *waiter)
 {
 	memset(waiter, 0x11, sizeof(*waiter));
-	plist_node_init(&waiter->list_entry, MAX_PRIO);
-	plist_node_init(&waiter->pi_list_entry, MAX_PRIO);
 	waiter->deadlock_task_pid = NULL;
 }
 
 void debug_rt_mutex_free_waiter(struct rt_mutex_waiter *waiter)
 {
 	put_pid(waiter->deadlock_task_pid);
-	TRACE_WARN_ON(!plist_node_empty(&waiter->list_entry));
-	TRACE_WARN_ON(!plist_node_empty(&waiter->pi_list_entry));
 	TRACE_WARN_ON(waiter->task);
 	memset(waiter, 0x22, sizeof(*waiter));
 }
diff --git a/kernel/rtmutex.c b/kernel/rtmutex.c
index a960481..765b407 100644
--- a/kernel/rtmutex.c
+++ b/kernel/rtmutex.c
@@ -97,6 +97,82 @@ static inline void mark_rt_mutex_waiters(struct rt_mutex *lock)
 }
 #endif
 
+static inline int
+rt_mutex_waiter_less(struct rt_mutex_waiter *left, struct rt_mutex_waiter *right)
+{
+	return left->task->prio < right->task->prio;
+}
+
+static void
+rt_mutex_enqueue(struct rt_mutex *lock, struct rt_mutex_waiter *waiter)
+{
+	struct rb_node **link = &lock->waiters.rb_node;
+	struct rb_node *parent = NULL;
+	struct rt_mutex_waiter *entry;
+	int leftmost = 1;
+
+	while (*link) {
+		parent = *link;
+		entry = rb_entry(parent, struct rt_mutex_waiter, tree_entry);
+		if (rt_mutex_waiter_less(waiter, entry)) {
+			link = &parent->rb_left;
+		} else {
+			link = &parent->rb_right;
+			leftmost = 0;
+		}
+	}
+
+	if (leftmost)
+		lock->waiters_leftmost = &waiter->tree_entry;
+
+	rb_link_node(&waiter->tree_entry, parent, link);
+	rb_insert_color(&waiter->tree_entry, &lock->waiters);
+}
+
+static void
+rt_mutex_dequeue(struct rt_mutex *lock, struct rt_mutex_waiter *waiter)
+{
+	if (lock->waiter_leftmost == &waiter->tree_entry)
+		lock->waiter_leftmost = rb_next(&waiter->tree_entry);
+
+	rb_erase(&waiter->tree_entry, lock->waiters);
+}
+
+static void 
+rt_mutex_enqueue_pi(struct task_struct *task, struct rt_mutex_waiter *waiter)
+{
+	struct rb_node **link = &task->pi_waiters.rb_node;
+	struct rb_node *parent = NULL;
+	struct rt_mutex_waiter *entry;
+	int leftmost = 1;
+
+	while (*link) {
+		parent = *link;
+		entry = rb_entry(parent, struct rt_mutex_waiter, pi_tree_entry);
+		if (rt_mutex_waiter_less(waiter, entry)) {
+			link = &parent->rb_left;
+		} else {
+			link = &parent->rb_right;
+			leftmost = 0;
+		}
+	}
+
+	if (leftmost)
+		task->pi_waiters_leftmost = &waiter->pi_tree_entry;
+
+	rb_link_node(&waiter->pi_tree_entry, parent, link);
+	rb_insert_color(&waiter->pi_tree_entry, &task->pi_waiters);
+}
+
+static void
+rt_mutex_dequeue_pi(struct task_struct *task, struct rt_mutex_waiter *waiter)
+{
+	if (lock->waiter_leftmost == &waiter->pi_tree_entry)
+		lock->waiter_leftmost = rb_next(&waiter->pi_tree_entry);
+
+	rb_erase(&waiter->pi_tree_entry, task->pi_waiters);
+}
+
 /*
  * Calculate task priority from the waiter list priority
  *
@@ -248,9 +324,8 @@ static int rt_mutex_adjust_prio_chain(struct task_struct *task,
 	top_waiter = rt_mutex_top_waiter(lock);
 
 	/* Requeue the waiter */
-	plist_del(&waiter->list_entry, &lock->wait_list);
-	waiter->list_entry.prio = task->prio;
-	plist_add(&waiter->list_entry, &lock->wait_list);
+	rt_mutex_dequeue(lock, waiter);
+	rt_mutex_enqueue(lock, waiter);
 
 	/* Release the task */
 	raw_spin_unlock_irqrestore(&task->pi_lock, flags);
@@ -263,17 +338,15 @@ static int rt_mutex_adjust_prio_chain(struct task_struct *task,
 
 	if (waiter == rt_mutex_top_waiter(lock)) {
 		/* Boost the owner */
-		plist_del(&top_waiter->pi_list_entry, &task->pi_waiters);
-		waiter->pi_list_entry.prio = waiter->list_entry.prio;
-		plist_add(&waiter->pi_list_entry, &task->pi_waiters);
+		rt_mutex_dequeue_pi(task, top_waiter);
+		rt_mutex_enqueue_pi(task, waiter);
 		__rt_mutex_adjust_prio(task);
 
 	} else if (top_waiter == waiter) {
 		/* Deboost the owner */
-		plist_del(&waiter->pi_list_entry, &task->pi_waiters);
+		rt_mutex_dequeue_pi(task, waiter);
 		waiter = rt_mutex_top_waiter(lock);
-		waiter->pi_list_entry.prio = waiter->list_entry.prio;
-		plist_add(&waiter->pi_list_entry, &task->pi_waiters);
+		rt_mutex_enqueue_pi(task, waiter);
 		__rt_mutex_adjust_prio(task);
 	}
 
@@ -331,7 +404,7 @@ static inline int try_to_steal_lock(struct rt_mutex *lock,
 
 	/* No chain handling, pending owner is not blocked on anything: */
 	next = rt_mutex_top_waiter(lock);
-	plist_del(&next->pi_list_entry, &pendowner->pi_waiters);
+	rt_mutex_dequeue_pi(pendowner, next);
 	__rt_mutex_adjust_prio(pendowner);
 	raw_spin_unlock_irqrestore(&pendowner->pi_lock, flags);
 
@@ -351,7 +424,7 @@ static inline int try_to_steal_lock(struct rt_mutex *lock,
 	 */
 	if (likely(next->task != task)) {
 		raw_spin_lock_irqsave(&task->pi_lock, flags);
-		plist_add(&next->pi_list_entry, &task->pi_waiters);
+		rt_mutex_enqueue_pi(task, next);
 		__rt_mutex_adjust_prio(task);
 		raw_spin_unlock_irqrestore(&task->pi_lock, flags);
 	}
@@ -424,13 +497,11 @@ static int task_blocks_on_rt_mutex(struct rt_mutex *lock,
 	__rt_mutex_adjust_prio(task);
 	waiter->task = task;
 	waiter->lock = lock;
-	plist_node_init(&waiter->list_entry, task->prio);
-	plist_node_init(&waiter->pi_list_entry, task->prio);
 
 	/* Get the top priority waiter on the lock */
 	if (rt_mutex_has_waiters(lock))
 		top_waiter = rt_mutex_top_waiter(lock);
-	plist_add(&waiter->list_entry, &lock->wait_list);
+	rt_mutex_enqueue(lock, waiter);
 
 	task->pi_blocked_on = waiter;
 
@@ -438,10 +509,11 @@ static int task_blocks_on_rt_mutex(struct rt_mutex *lock,
 
 	if (waiter == rt_mutex_top_waiter(lock)) {
 		raw_spin_lock_irqsave(&owner->pi_lock, flags);
-		plist_del(&top_waiter->pi_list_entry, &owner->pi_waiters);
-		plist_add(&waiter->pi_list_entry, &owner->pi_waiters);
 
+		rt_mutex_dequeue_pi(owner, top_waiter);
+		rt_mutex_enqueue_pi(owner, waiter);
 		__rt_mutex_adjust_prio(owner);
+
 		if (owner->pi_blocked_on)
 			chain_walk = 1;
 		raw_spin_unlock_irqrestore(&owner->pi_lock, flags);
@@ -486,7 +558,7 @@ static void wakeup_next_waiter(struct rt_mutex *lock)
 	raw_spin_lock_irqsave(&current->pi_lock, flags);
 
 	waiter = rt_mutex_top_waiter(lock);
-	plist_del(&waiter->list_entry, &lock->wait_list);
+	rt_mutex_dequeue(lock, waiter);
 
 	/*
 	 * Remove it from current->pi_waiters. We do not adjust a
@@ -494,7 +566,7 @@ static void wakeup_next_waiter(struct rt_mutex *lock)
 	 * boosted mode and go back to normal after releasing
 	 * lock->wait_lock.
 	 */
-	plist_del(&waiter->pi_list_entry, &current->pi_waiters);
+	rt_mutex_dequeue_pi(current, waiter);
 	pendowner = waiter->task;
 	waiter->task = NULL;
 
@@ -521,7 +593,7 @@ static void wakeup_next_waiter(struct rt_mutex *lock)
 		struct rt_mutex_waiter *next;
 
 		next = rt_mutex_top_waiter(lock);
-		plist_add(&next->pi_list_entry, &pendowner->pi_waiters);
+		rt_mutex_enqueue_pi(pendowner, next);
 	}
 	raw_spin_unlock_irqrestore(&pendowner->pi_lock, flags);
 
@@ -542,7 +614,7 @@ static void remove_waiter(struct rt_mutex *lock,
 	int chain_walk = 0;
 
 	raw_spin_lock_irqsave(&current->pi_lock, flags);
-	plist_del(&waiter->list_entry, &lock->wait_list);
+	rt_mutex_dequeue(lock, waiter);
 	waiter->task = NULL;
 	current->pi_blocked_on = NULL;
 	raw_spin_unlock_irqrestore(&current->pi_lock, flags);
@@ -551,13 +623,13 @@ static void remove_waiter(struct rt_mutex *lock,
 
 		raw_spin_lock_irqsave(&owner->pi_lock, flags);
 
-		plist_del(&waiter->pi_list_entry, &owner->pi_waiters);
+		rt_mutex_dequeue_po(owner, waiter);
 
 		if (rt_mutex_has_waiters(lock)) {
 			struct rt_mutex_waiter *next;
 
 			next = rt_mutex_top_waiter(lock);
-			plist_add(&next->pi_list_entry, &owner->pi_waiters);
+			rt_mutex_enqueue_pi(owner, next);
 		}
 		__rt_mutex_adjust_prio(owner);
 
@@ -567,8 +639,6 @@ static void remove_waiter(struct rt_mutex *lock,
 		raw_spin_unlock_irqrestore(&owner->pi_lock, flags);
 	}
 
-	WARN_ON(!plist_node_empty(&waiter->pi_list_entry));
-
 	if (!chain_walk)
 		return;
 
@@ -971,7 +1041,8 @@ void __rt_mutex_init(struct rt_mutex *lock, const char *name)
 {
 	lock->owner = NULL;
 	raw_spin_lock_init(&lock->wait_lock);
-	plist_head_init_raw(&lock->wait_list, &lock->wait_lock);
+	lock->waiters = RB_ROOT;
+	lock->waiters_leftmost = NULL;
 
 	debug_rt_mutex_init(lock, name);
 }
diff --git a/kernel/rtmutex_common.h b/kernel/rtmutex_common.h
index 97a2f81..b522322 100644
--- a/kernel/rtmutex_common.h
+++ b/kernel/rtmutex_common.h
@@ -40,13 +40,13 @@ extern void schedule_rt_mutex_test(struct rt_mutex *lock);
  * This is the control structure for tasks blocked on a rt_mutex,
  * which is allocated on the kernel stack on of the blocked task.
  *
- * @list_entry:		pi node to enqueue into the mutex waiters list
- * @pi_list_entry:	pi node to enqueue into the mutex owner waiters list
+ * @tree_entry:		pi node to enqueue into the mutex waiters tree
+ * @pi_tree_entry:	pi node to enqueue into the mutex owner waiters tree
  * @task:		task reference to the blocked task
  */
 struct rt_mutex_waiter {
-	struct plist_node	list_entry;
-	struct plist_node	pi_list_entry;
+	struct rb_node		tree_entry;
+	struct rb_node		pi_tree_entry;
 	struct task_struct	*task;
 	struct rt_mutex		*lock;
 #ifdef CONFIG_DEBUG_RT_MUTEXES
@@ -57,11 +57,11 @@ struct rt_mutex_waiter {
 };
 
 /*
- * Various helpers to access the waiters-plist:
+ * Various helpers to access the waiters-tree:
  */
 static inline int rt_mutex_has_waiters(struct rt_mutex *lock)
 {
-	return !plist_head_empty(&lock->wait_list);
+	return !RB_EMPTY_ROOT(&lock->waiters);
 }
 
 static inline struct rt_mutex_waiter *
@@ -69,8 +69,7 @@ rt_mutex_top_waiter(struct rt_mutex *lock)
 {
 	struct rt_mutex_waiter *w;
 
-	w = plist_first_entry(&lock->wait_list, struct rt_mutex_waiter,
-			       list_entry);
+	w = rb_entry(lock->waiters_leftmost, struct rt_mutex_waiter, tree_entry);
 	BUG_ON(w->lock != lock);
 
 	return w;
@@ -78,14 +77,14 @@ rt_mutex_top_waiter(struct rt_mutex *lock)
 
 static inline int task_has_pi_waiters(struct task_struct *p)
 {
-	return !plist_head_empty(&p->pi_waiters);
+	return !RB_EMPTY_ROOT(&p->pi_waiters);
 }
 
 static inline struct rt_mutex_waiter *
 task_top_pi_waiter(struct task_struct *p)
 {
-	return plist_first_entry(&p->pi_waiters, struct rt_mutex_waiter,
-				  pi_list_entry);
+	return rb_entry(p->pi_waiters_leftmost, struct rt_mutex_waiter,
+			pi_tree_entry);
 }
 
 /*
diff --git a/kernel/sched.c b/kernel/sched.c
index 3acf694..40b9bc5 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -7677,10 +7677,6 @@ void __init sched_init(void)
 	open_softirq(SCHED_SOFTIRQ, run_rebalance_domains);
 #endif
 
-#ifdef CONFIG_RT_MUTEXES
-	plist_head_init_raw(&init_task.pi_waiters, &init_task.pi_lock);
-#endif
-
 	/*
 	 * The boot idle thread does lazy MMU switching as well:
 	 */


