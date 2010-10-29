Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755418Ab0J2GmT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Oct 2010 02:42:19 -0400
Received: from rt-pi1-ru-sssup.pi1.garr.net ([193.206.136.46]:25840 "EHLO
	sssup.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752888Ab0J2GmM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Oct 2010 02:42:12 -0400
Subject: [RFC][PATCH 19/22] rtmutex: turn the plist into an rb-tree
From: Raistlin <raistlin@linux.it>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Chris Friesen <cfriesen@nortel.com>, oleg@redhat.com,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Darren Hart <darren@dvhart.com>, Johan Eker <johan.eker@ericsson.com>,
        "p.faure" <p.faure@akatech.ch>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Claudio Scordino <claudio@evidence.eu.com>,
        michael trimarchi <trimarchi@retis.sssup.it>,
        Fabio Checconi <fabio@gandalf.sssup.it>,
        Tommaso Cucinotta <cucinotta@sssup.it>,
        Juri Lelli <juri.lelli@gmail.com>,
        Nicola Manica <nicola.manica@disi.unitn.it>,
        Luca Abeni <luca.abeni@unitn.it>, Dhaval Giani <dhaval@retis.sssup.it>,
        Harald Gustafsson <hgu1972@gmail.com>,
        paulmck <paulmck@linux.vnet.ibm.com>
In-Reply-To: <1288333128.8661.137.camel@Palantir>
References: <1288333128.8661.137.camel@Palantir>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-6sEDqU0t2Vuytgs5LwBQ"
Date: Fri, 29 Oct 2010 08:42:01 +0200
Message-ID: <1288334521.8661.160.camel@Palantir>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-6sEDqU0t2Vuytgs5LwBQ
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable


Turn the pi-chains from plist to rb-tree, in the rt_mutex code,
and provide a proper comparison function for -deadline and
-priority tasks.

This is done mainly because:
 - classical prio field of the plist is just an int, which might
   not be enough for representing a deadline;
 - manipulating such a list would become O(nr_deadline_tasks),
   which might be to much, as the number of -deadline task increses.

Therefore, an rb-tree is used, and tasks are queued in it according
to the following logic:
 - among two -priority (i.e., SCHED_BATCH/OTHER/RR/FIFO) tasks, the
   one with the higher (lower, actually!) prio wins;
 - among a -priority and a -deadline task, the latter always wins;
 - among two -deadline tasks, the one with the earliest deadline
   wins.

Queueing and dequeueing functions are chenged accordingly, for both
the list of a task's pi-waiters and the list of tasks blocked on
a pi-lock.

Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Dario Faggioli <raistlin@linux.it>
---
 include/linux/init_task.h |   10 +++
 include/linux/rtmutex.h   |   13 +---
 include/linux/sched.h     |    4 +-
 kernel/fork.c             |    3 +-
 kernel/rtmutex-debug.c    |    8 +--
 kernel/rtmutex.c          |  135 +++++++++++++++++++++++++++++++++++------=
----
 kernel/rtmutex_common.h   |   22 ++++----
 kernel/sched.c            |    4 -
 8 files changed, 137 insertions(+), 62 deletions(-)

diff --git a/include/linux/init_task.h b/include/linux/init_task.h
index 1f8c06c..f4f7567 100644
--- a/include/linux/init_task.h
+++ b/include/linux/init_task.h
@@ -10,6 +10,7 @@
 #include <linux/pid_namespace.h>
 #include <linux/user_namespace.h>
 #include <linux/securebits.h>
+#include <linux/rbtree.h>
 #include <net/net_namespace.h>
=20
 extern struct files_struct init_files;
@@ -110,6 +111,14 @@ extern struct cred init_cred;
 # define INIT_PERF_EVENTS(tsk)
 #endif
=20
+#ifdef CONFIG_RT_MUTEXES
+# define INIT_RT_MUTEXES						\
+	.pi_waiters =3D RB_ROOT,						\
+	.pi_waiters_leftmost =3D NULL,
+#else
+# define INIT_RT_MUTEXES
+#endif
+
 /*
  *  INIT_TASK is used to set up the first task table, touch at
  * your own risk!. Base=3D0, limit=3D0x1fffff (=3D2MB)
@@ -178,6 +187,7 @@ extern struct cred init_cred;
 	INIT_FTRACE_GRAPH						\
 	INIT_TRACE_RECURSION						\
 	INIT_TASK_RCU_PREEMPT(tsk)					\
+	INIT_RT_MUTEXES							\
 }
=20
=20
diff --git a/include/linux/rtmutex.h b/include/linux/rtmutex.h
index 8d522ff..bd7cd02 100644
--- a/include/linux/rtmutex.h
+++ b/include/linux/rtmutex.h
@@ -13,7 +13,7 @@
 #define __LINUX_RT_MUTEX_H
=20
 #include <linux/linkage.h>
-#include <linux/plist.h>
+#include <linux/rbtree.h>
 #include <linux/spinlock_types.h>
=20
 extern int max_lock_depth; /* for sysctl */
@@ -27,7 +27,8 @@ extern int max_lock_depth; /* for sysctl */
  */
 struct rt_mutex {
 	raw_spinlock_t		wait_lock;
-	struct plist_head	wait_list;
+	struct rb_root          waiters;
+	struct rb_node          *waiters_leftmost;
 	struct task_struct	*owner;
 #ifdef CONFIG_DEBUG_RT_MUTEXES
 	int			save_state;
@@ -98,12 +99,4 @@ extern int rt_mutex_trylock(struct rt_mutex *lock);
=20
 extern void rt_mutex_unlock(struct rt_mutex *lock);
=20
-#ifdef CONFIG_RT_MUTEXES
-# define INIT_RT_MUTEXES(tsk)						\
-	.pi_waiters	=3D PLIST_HEAD_INIT(tsk.pi_waiters, tsk.pi_lock),	\
-	INIT_RT_MUTEX_DEBUG(tsk)
-#else
-# define INIT_RT_MUTEXES(tsk)
-#endif
-
 #endif
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 8806c1f..c3d1f17b 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -56,6 +56,7 @@ struct sched_param {
 #include <linux/types.h>
 #include <linux/timex.h>
 #include <linux/jiffies.h>
+#include <linux/plist.h>
 #include <linux/rbtree.h>
 #include <linux/thread_info.h>
 #include <linux/cpumask.h>
@@ -1530,7 +1531,8 @@ struct task_struct {
=20
 #ifdef CONFIG_RT_MUTEXES
 	/* PI waiters blocked on a rt_mutex held by this task */
-	struct plist_head pi_waiters;
+	struct rb_root pi_waiters;
+	struct rb_node *pi_waiters_leftmost;
 	/* Deadlock detection and priority inheritance handling */
 	struct rt_mutex_waiter *pi_blocked_on;
 #endif
diff --git a/kernel/fork.c b/kernel/fork.c
index 3b159c5..aceb248 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -935,7 +935,8 @@ static void rt_mutex_init_task(struct task_struct *p)
 {
 	raw_spin_lock_init(&p->pi_lock);
 #ifdef CONFIG_RT_MUTEXES
-	plist_head_init_raw(&p->pi_waiters, &p->pi_lock);
+	p->pi_waiters =3D RB_ROOT;
+	p->pi_waiters_leftmost =3D NULL;
 	p->pi_blocked_on =3D NULL;
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
=20
@@ -111,7 +111,7 @@ static void printk_lock(struct rt_mutex *lock, int prin=
t_owner)
=20
 void rt_mutex_debug_task_free(struct task_struct *task)
 {
-	WARN_ON(!plist_head_empty(&task->pi_waiters));
+	WARN_ON(!RB_EMPTY_ROOT(&task->pi_waiters));
 	WARN_ON(task->pi_blocked_on);
 }
=20
@@ -205,16 +205,12 @@ void debug_rt_mutex_proxy_unlock(struct rt_mutex *loc=
k)
 void debug_rt_mutex_init_waiter(struct rt_mutex_waiter *waiter)
 {
 	memset(waiter, 0x11, sizeof(*waiter));
-	plist_node_init(&waiter->list_entry, MAX_PRIO);
-	plist_node_init(&waiter->pi_list_entry, MAX_PRIO);
 	waiter->deadlock_task_pid =3D NULL;
 }
=20
 void debug_rt_mutex_free_waiter(struct rt_mutex_waiter *waiter)
 {
 	put_pid(waiter->deadlock_task_pid);
-	TRACE_WARN_ON(!plist_node_empty(&waiter->list_entry));
-	TRACE_WARN_ON(!plist_node_empty(&waiter->pi_list_entry));
 	TRACE_WARN_ON(waiter->task);
 	memset(waiter, 0x22, sizeof(*waiter));
 }
diff --git a/kernel/rtmutex.c b/kernel/rtmutex.c
index a960481..2e9c0dc 100644
--- a/kernel/rtmutex.c
+++ b/kernel/rtmutex.c
@@ -97,6 +97,90 @@ static inline void mark_rt_mutex_waiters(struct rt_mutex=
 *lock)
 }
 #endif
=20
+static inline int
+rt_mutex_waiter_less(struct rt_mutex_waiter *left,
+		     struct rt_mutex_waiter *right)
+{
+	if (left->task->prio < right->task->prio)
+		return 1;
+
+	/*
+	 * If both tasks are dl_task(), we check their deadlines.
+	 */
+	if (dl_prio(left->task->prio) && dl_prio(right->task->prio))
+		return left->task->dl.deadline < right->task->dl.deadline;
+}
+
+static void
+rt_mutex_enqueue(struct rt_mutex *lock, struct rt_mutex_waiter *waiter)
+{
+	struct rb_node **link =3D &lock->waiters.rb_node;
+	struct rb_node *parent =3D NULL;
+	struct rt_mutex_waiter *entry;
+	int leftmost =3D 1;
+
+	while (*link) {
+		parent =3D *link;
+		entry =3D rb_entry(parent, struct rt_mutex_waiter, tree_entry);
+		if (rt_mutex_waiter_less(waiter, entry)) {
+			link =3D &parent->rb_left;
+		} else {
+			link =3D &parent->rb_right;
+			leftmost =3D 0;
+		}
+	}
+
+	if (leftmost)
+		lock->waiters_leftmost =3D &waiter->tree_entry;
+
+	rb_link_node(&waiter->tree_entry, parent, link);
+	rb_insert_color(&waiter->tree_entry, &lock->waiters);
+}
+
+static void
+rt_mutex_dequeue(struct rt_mutex *lock, struct rt_mutex_waiter *waiter)
+{
+	if (lock->waiters_leftmost =3D=3D &waiter->tree_entry)
+		lock->waiters_leftmost =3D rb_next(&waiter->tree_entry);
+
+	rb_erase(&waiter->tree_entry, &lock->waiters);
+}
+
+static void
+rt_mutex_enqueue_pi(struct task_struct *task, struct rt_mutex_waiter *wait=
er)
+{
+	struct rb_node **link =3D &task->pi_waiters.rb_node;
+	struct rb_node *parent =3D NULL;
+	struct rt_mutex_waiter *entry;
+	int leftmost =3D 1;
+
+	while (*link) {
+		parent =3D *link;
+		entry =3D rb_entry(parent, struct rt_mutex_waiter, pi_tree_entry);
+		if (rt_mutex_waiter_less(waiter, entry)) {
+			link =3D &parent->rb_left;
+		} else {
+			link =3D &parent->rb_right;
+			leftmost =3D 0;
+		}
+	}
+
+	if (leftmost)
+		task->pi_waiters_leftmost =3D &waiter->pi_tree_entry;
+
+	rb_link_node(&waiter->pi_tree_entry, parent, link);
+	rb_insert_color(&waiter->pi_tree_entry, &task->pi_waiters);
+}
+
+static void
+rt_mutex_dequeue_pi(struct task_struct *task, struct rt_mutex_waiter *wait=
er)
+{
+	if (task->pi_waiters_leftmost =3D=3D &waiter->pi_tree_entry)
+		task->pi_waiters_leftmost =3D rb_next(&waiter->pi_tree_entry);
+
+	rb_erase(&waiter->pi_tree_entry, &task->pi_waiters);
+}
+
 /*
  * Calculate task priority from the waiter list priority
  *
@@ -108,7 +192,7 @@ int rt_mutex_getprio(struct task_struct *task)
 	if (likely(!task_has_pi_waiters(task)))
 		return task->normal_prio;
=20
-	return min(task_top_pi_waiter(task)->pi_list_entry.prio,
+	return min(task_top_pi_waiter(task)->task->prio,
 		   task->normal_prio);
 }
=20
@@ -227,7 +311,7 @@ static int rt_mutex_adjust_prio_chain(struct task_struc=
t *task,
 	 * When deadlock detection is off then we check, if further
 	 * priority adjustment is necessary.
 	 */
-	if (!detect_deadlock && waiter->list_entry.prio =3D=3D task->prio)
+	if (!detect_deadlock && waiter->task->prio =3D=3D task->prio)
 		goto out_unlock_pi;
=20
 	lock =3D waiter->lock;
@@ -248,9 +332,8 @@ static int rt_mutex_adjust_prio_chain(struct task_struc=
t *task,
 	top_waiter =3D rt_mutex_top_waiter(lock);
=20
 	/* Requeue the waiter */
-	plist_del(&waiter->list_entry, &lock->wait_list);
-	waiter->list_entry.prio =3D task->prio;
-	plist_add(&waiter->list_entry, &lock->wait_list);
+	rt_mutex_dequeue(lock, waiter);
+	rt_mutex_enqueue(lock, waiter);
=20
 	/* Release the task */
 	raw_spin_unlock_irqrestore(&task->pi_lock, flags);
@@ -263,17 +346,15 @@ static int rt_mutex_adjust_prio_chain(struct task_str=
uct *task,
=20
 	if (waiter =3D=3D rt_mutex_top_waiter(lock)) {
 		/* Boost the owner */
-		plist_del(&top_waiter->pi_list_entry, &task->pi_waiters);
-		waiter->pi_list_entry.prio =3D waiter->list_entry.prio;
-		plist_add(&waiter->pi_list_entry, &task->pi_waiters);
+		rt_mutex_dequeue_pi(task, top_waiter);
+		rt_mutex_enqueue_pi(task, waiter);
 		__rt_mutex_adjust_prio(task);
=20
 	} else if (top_waiter =3D=3D waiter) {
 		/* Deboost the owner */
-		plist_del(&waiter->pi_list_entry, &task->pi_waiters);
+		rt_mutex_dequeue_pi(task, waiter);
 		waiter =3D rt_mutex_top_waiter(lock);
-		waiter->pi_list_entry.prio =3D waiter->list_entry.prio;
-		plist_add(&waiter->pi_list_entry, &task->pi_waiters);
+		rt_mutex_enqueue_pi(task, waiter);
 		__rt_mutex_adjust_prio(task);
 	}
=20
@@ -331,7 +412,7 @@ static inline int try_to_steal_lock(struct rt_mutex *lo=
ck,
=20
 	/* No chain handling, pending owner is not blocked on anything: */
 	next =3D rt_mutex_top_waiter(lock);
-	plist_del(&next->pi_list_entry, &pendowner->pi_waiters);
+	rt_mutex_dequeue_pi(pendowner, next);
 	__rt_mutex_adjust_prio(pendowner);
 	raw_spin_unlock_irqrestore(&pendowner->pi_lock, flags);
=20
@@ -351,7 +432,7 @@ static inline int try_to_steal_lock(struct rt_mutex *lo=
ck,
 	 */
 	if (likely(next->task !=3D task)) {
 		raw_spin_lock_irqsave(&task->pi_lock, flags);
-		plist_add(&next->pi_list_entry, &task->pi_waiters);
+		rt_mutex_enqueue_pi(task, next);
 		__rt_mutex_adjust_prio(task);
 		raw_spin_unlock_irqrestore(&task->pi_lock, flags);
 	}
@@ -424,13 +505,11 @@ static int task_blocks_on_rt_mutex(struct rt_mutex *l=
ock,
 	__rt_mutex_adjust_prio(task);
 	waiter->task =3D task;
 	waiter->lock =3D lock;
-	plist_node_init(&waiter->list_entry, task->prio);
-	plist_node_init(&waiter->pi_list_entry, task->prio);
=20
 	/* Get the top priority waiter on the lock */
 	if (rt_mutex_has_waiters(lock))
 		top_waiter =3D rt_mutex_top_waiter(lock);
-	plist_add(&waiter->list_entry, &lock->wait_list);
+	rt_mutex_enqueue(lock, waiter);
=20
 	task->pi_blocked_on =3D waiter;
=20
@@ -438,9 +517,8 @@ static int task_blocks_on_rt_mutex(struct rt_mutex *loc=
k,
=20
 	if (waiter =3D=3D rt_mutex_top_waiter(lock)) {
 		raw_spin_lock_irqsave(&owner->pi_lock, flags);
-		plist_del(&top_waiter->pi_list_entry, &owner->pi_waiters);
-		plist_add(&waiter->pi_list_entry, &owner->pi_waiters);
-
+		rt_mutex_dequeue_pi(owner, top_waiter);
+		rt_mutex_enqueue_pi(owner, waiter);
 		__rt_mutex_adjust_prio(owner);
 		if (owner->pi_blocked_on)
 			chain_walk =3D 1;
@@ -486,7 +564,7 @@ static void wakeup_next_waiter(struct rt_mutex *lock)
 	raw_spin_lock_irqsave(&current->pi_lock, flags);
=20
 	waiter =3D rt_mutex_top_waiter(lock);
-	plist_del(&waiter->list_entry, &lock->wait_list);
+	rt_mutex_dequeue(lock, waiter);
=20
 	/*
 	 * Remove it from current->pi_waiters. We do not adjust a
@@ -494,7 +572,7 @@ static void wakeup_next_waiter(struct rt_mutex *lock)
 	 * boosted mode and go back to normal after releasing
 	 * lock->wait_lock.
 	 */
-	plist_del(&waiter->pi_list_entry, &current->pi_waiters);
+	rt_mutex_dequeue_pi(current, waiter);
 	pendowner =3D waiter->task;
 	waiter->task =3D NULL;
=20
@@ -521,7 +599,7 @@ static void wakeup_next_waiter(struct rt_mutex *lock)
 		struct rt_mutex_waiter *next;
=20
 		next =3D rt_mutex_top_waiter(lock);
-		plist_add(&next->pi_list_entry, &pendowner->pi_waiters);
+		rt_mutex_enqueue_pi(pendowner, next);
 	}
 	raw_spin_unlock_irqrestore(&pendowner->pi_lock, flags);
=20
@@ -542,7 +620,7 @@ static void remove_waiter(struct rt_mutex *lock,
 	int chain_walk =3D 0;
=20
 	raw_spin_lock_irqsave(&current->pi_lock, flags);
-	plist_del(&waiter->list_entry, &lock->wait_list);
+	rt_mutex_dequeue(lock, waiter);
 	waiter->task =3D NULL;
 	current->pi_blocked_on =3D NULL;
 	raw_spin_unlock_irqrestore(&current->pi_lock, flags);
@@ -551,13 +629,13 @@ static void remove_waiter(struct rt_mutex *lock,
=20
 		raw_spin_lock_irqsave(&owner->pi_lock, flags);
=20
-		plist_del(&waiter->pi_list_entry, &owner->pi_waiters);
+		rt_mutex_dequeue_pi(owner, waiter);
=20
 		if (rt_mutex_has_waiters(lock)) {
 			struct rt_mutex_waiter *next;
=20
 			next =3D rt_mutex_top_waiter(lock);
-			plist_add(&next->pi_list_entry, &owner->pi_waiters);
+			rt_mutex_enqueue_pi(owner, next);
 		}
 		__rt_mutex_adjust_prio(owner);
=20
@@ -567,8 +645,6 @@ static void remove_waiter(struct rt_mutex *lock,
 		raw_spin_unlock_irqrestore(&owner->pi_lock, flags);
 	}
=20
-	WARN_ON(!plist_node_empty(&waiter->pi_list_entry));
-
 	if (!chain_walk)
 		return;
=20
@@ -595,7 +671,7 @@ void rt_mutex_adjust_pi(struct task_struct *task)
 	raw_spin_lock_irqsave(&task->pi_lock, flags);
=20
 	waiter =3D task->pi_blocked_on;
-	if (!waiter || waiter->list_entry.prio =3D=3D task->prio) {
+	if (!waiter || waiter->task->prio =3D=3D task->prio) {
 		raw_spin_unlock_irqrestore(&task->pi_lock, flags);
 		return;
 	}
@@ -971,7 +1047,8 @@ void __rt_mutex_init(struct rt_mutex *lock, const char=
 *name)
 {
 	lock->owner =3D NULL;
 	raw_spin_lock_init(&lock->wait_lock);
-	plist_head_init_raw(&lock->wait_list, &lock->wait_lock);
+	lock->waiters =3D RB_ROOT;
+	lock->waiters_leftmost =3D NULL;
=20
 	debug_rt_mutex_init(lock, name);
 }
diff --git a/kernel/rtmutex_common.h b/kernel/rtmutex_common.h
index 97a2f81..84b9eea 100644
--- a/kernel/rtmutex_common.h
+++ b/kernel/rtmutex_common.h
@@ -40,13 +40,13 @@ extern void schedule_rt_mutex_test(struct rt_mutex *loc=
k);
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
+	struct rb_node          tree_entry;
+	struct rb_node          pi_tree_entry;
 	struct task_struct	*task;
 	struct rt_mutex		*lock;
 #ifdef CONFIG_DEBUG_RT_MUTEXES
@@ -57,11 +57,11 @@ struct rt_mutex_waiter {
 };
=20
 /*
- * Various helpers to access the waiters-plist:
+ * Various helpers to access the waiters-tree:
  */
 static inline int rt_mutex_has_waiters(struct rt_mutex *lock)
 {
-	return !plist_head_empty(&lock->wait_list);
+	return !RB_EMPTY_ROOT(&lock->waiters);
 }
=20
 static inline struct rt_mutex_waiter *
@@ -69,8 +69,8 @@ rt_mutex_top_waiter(struct rt_mutex *lock)
 {
 	struct rt_mutex_waiter *w;
=20
-	w =3D plist_first_entry(&lock->wait_list, struct rt_mutex_waiter,
-			       list_entry);
+	w =3D rb_entry(lock->waiters_leftmost, struct rt_mutex_waiter,
+		     tree_entry);
 	BUG_ON(w->lock !=3D lock);
=20
 	return w;
@@ -78,14 +78,14 @@ rt_mutex_top_waiter(struct rt_mutex *lock)
=20
 static inline int task_has_pi_waiters(struct task_struct *p)
 {
-	return !plist_head_empty(&p->pi_waiters);
+	return !RB_EMPTY_ROOT(&p->pi_waiters);
 }
=20
 static inline struct rt_mutex_waiter *
 task_top_pi_waiter(struct task_struct *p)
 {
-	return plist_first_entry(&p->pi_waiters, struct rt_mutex_waiter,
-				  pi_list_entry);
+	return rb_entry(p->pi_waiters_leftmost, struct rt_mutex_waiter,
+			pi_tree_entry);
 }
=20
 /*
diff --git a/kernel/sched.c b/kernel/sched.c
index 4d291e3..853473a 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -8504,10 +8504,6 @@ void __init sched_init(void)
 	open_softirq(SCHED_SOFTIRQ, run_rebalance_domains);
 #endif
=20
-#ifdef CONFIG_RT_MUTEXES
-	plist_head_init_raw(&init_task.pi_waiters, &init_task.pi_lock);
-#endif
-
 	/*
 	 * The boot idle thread does lazy MMU switching as well:
 	 */
--=20
1.7.2.3


--=20
<<This happens because I choose it to happen!>> (Raistlin Majere)
----------------------------------------------------------------------
Dario Faggioli, ReTiS Lab, Scuola Superiore Sant'Anna, Pisa  (Italy)

http://blog.linux.it/raistlin / raistlin@ekiga.net /
dario.faggioli@jabber.org

--=-6sEDqU0t2Vuytgs5LwBQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAkzKbLkACgkQk4XaBE3IOsT5UwCcCfIB48YRYGgiaC6PL1mJRzeK
qIIAoIkOb1BgoouNahGYd9gv19PtkK/G
=cyXm
-----END PGP SIGNATURE-----

--=-6sEDqU0t2Vuytgs5LwBQ--

