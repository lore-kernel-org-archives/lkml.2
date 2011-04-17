Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753287Ab1DQJ7S (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Apr 2011 05:59:18 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:34137 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752429Ab1DQJ6H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Apr 2011 05:58:07 -0400
Message-Id: <20110417095507.026186002@chello.nl>
User-Agent: quilt/0.48-1
Date: Sun, 17 Apr 2011 11:45:08 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [RFC][PATCH 3/7] lockdep: Annotate read/write states
References: <20110417094505.865828233@chello.nl>
Content-Disposition: inline; filename=gautham_r_shenoy-lockdep-annotate_read_write_states.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gautham R Shenoy <ego@in.ibm.com>

Currently we do not save the recursive read dependencies in the dependency
chain. As a result, a deadlock caused by the following chains are not spotted,
since we never have the chain 1 in our dependency list:

 1: Rlock(A) --> lock(B)
 2: lock(B)  --> Wlock(A), where A is a recursive read lock.

Before adding the Recursive Read locks to the dependency chains, we need to
distinguish them from the normal read locks since the conflicting states for
these two are quite different.

Currently the read/write status of a lock while it's acquired is denoted by a
monotonically increasing variable where:

 0 - WRITE
 1 - READ
 2 - RECURSIVE READ

In this patch, we propose to modify this distinction from a monotonically
increasing variable to a bit mask where:

 0x1 - WRITE
 0x2 - READ
 0x4 - RECURSIVE READ

This helps us to define the conflicting states for each lock with ease:
Thereby, the conflicting states for a given states are defined as follows:

 Conflicting_states(WRITE):             RECURSIVE_READ | READ | WRITE
 Conflicting_states(READ):                               READ | WRITE
 Conflicting_states(RECURSIVE_READ):                            WRITE

Also, we use one more bit in the bitmask to distinguish the first recursive
read in the current chain from the others, since it is sufficient to add only
this dependency to the dependency list.

Signed-off-by: Gautham R Shenoy <ego@in.ibm.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 include/linux/lockdep.h |  107 ++++++++++++++++++++++++++++++++++++------------
 kernel/lockdep.c        |   46 ++++++++++----------
 2 files changed, 105 insertions(+), 48 deletions(-)

Index: tip/include/linux/lockdep.h
===================================================================
--- tip.orig/include/linux/lockdep.h
+++ tip/include/linux/lockdep.h
@@ -233,10 +233,11 @@ struct held_lock {
 	unsigned int irq_context:2; /* bit 0 - soft, bit 1 - hard */
 	unsigned int trylock:1;						/* 16 bits */
 
-	unsigned int read:2;        /* see lock_acquire() comment */
+	unsigned int rw_state:4;        /* see lock states comment */
 	unsigned int check:2;       /* see lock_acquire() comment */
 	unsigned int hardirqs_off:1;
-	unsigned int references:11;					/* 32 bits */
+
+	unsigned short references;
 };
 
 /*
@@ -286,6 +287,15 @@ extern void lockdep_init_map(struct lock
 
 #define lockdep_set_novalidate_class(lock) \
 	lockdep_set_class(lock, &__lockdep_no_validate__)
+
+/* lock_state bits */
+#define _W_		0
+#define _R_		(_W_ + 1)
+#define _RR_		(_W_ + 2)
+#define _FIRST_RR_	(_W_ + 3)
+
+#define get_lock_state(lock_bit)	(1 << lock_bit)
+
 /*
  * Compare locking classes
  */
@@ -298,13 +308,40 @@ static inline int lockdep_match_key(stru
 }
 
 /*
- * Acquire a lock.
+ * lock states:
+ *
+ * A given lock can have one of the following states:
+ * - STATE_WRITE: Exclusive Write.
+ * - STATE_READ: Non-recursive read.
+ * - STATE_RECURSIVE_READ: Recursive Read.
  *
- * Values for "read":
+ * These states are represented as bitmasks
+ */
+#define STATE_WRITE		get_lock_state(_W_)
+#define STATE_READ		get_lock_state(_R_)
+#define STATE_RECURSIVE_READ	get_lock_state(_RR_)
+
+/* Helpers to check the current lock's state */
+#define is_simple_read(state)	(state & STATE_READ)
+#define is_rec_read(state)	(state & STATE_RECURSIVE_READ)
+#define is_read(state)		(is_simple_read(state) | is_rec_read(state))
+#define is_write(state)		(state & STATE_WRITE)
+
+/*
+ * When maintaining dependency chains for locks acquired with
+ * STATE_RECURSIVE_READ state, we add a particular instance of the lock to the
+ * dependency chain only if it's the first recursive read instance in the
+ * current dependency chain. We don't add recurring instances of the lock
+ * to the dependency chains.
+ */
+#define STATE_FIRST_RECURSIVE_READ	get_lock_state(_FIRST_RR_)
+#define is_first_rec_read(state)	(state & STATE_FIRST_RECURSIVE_READ)
+
+/*
+ * Acquire a lock.
  *
- *   0: exclusive (write) acquire
- *   1: read-acquire (no recursion allowed)
- *   2: read-acquire with same-instance recursion allowed
+ * Values for "rw_state":
+ *	See comment for lock states:
  *
  * Values for check:
  *
@@ -313,7 +350,7 @@ static inline int lockdep_match_key(stru
  *   2: full validation
  */
 extern void lock_acquire(struct lockdep_map *lock, unsigned int subclass,
-			 int trylock, int read, int check,
+			 int trylock, int rw_state, int check,
 			 struct lockdep_map *nest_lock, unsigned long ip);
 
 extern void lock_release(struct lockdep_map *lock, int nested,
@@ -457,11 +494,15 @@ static inline void print_irqtrace_events
 
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 # ifdef CONFIG_PROVE_LOCKING
-#  define spin_acquire(l, s, t, i)		lock_acquire(l, s, t, 0, 2, NULL, i)
-#  define spin_acquire_nest(l, s, t, n, i)	lock_acquire(l, s, t, 0, 2, n, i)
+#  define spin_acquire(l, s, t, i)		\
+		lock_acquire(l, s, t, STATE_WRITE, 2, NULL, i)
+#  define spin_acquire_nest(l, s, t, n, i)	\
+		lock_acquire(l, s, t, STATE_WRITE, 2, n, i)
 # else
-#  define spin_acquire(l, s, t, i)		lock_acquire(l, s, t, 0, 1, NULL, i)
-#  define spin_acquire_nest(l, s, t, n, i)	lock_acquire(l, s, t, 0, 1, NULL, i)
+#  define spin_acquire(l, s, t, i)		\
+		lock_acquire(l, s, t, STATE_WRITE, 1, NULL, i)
+#  define spin_acquire_nest(l, s, t, n, i)	\
+		lock_acquire(l, s, t, STATE_WRITE, 1, NULL, i)
 # endif
 # define spin_release(l, n, i)			lock_release(l, n, i)
 #else
@@ -471,11 +512,15 @@ static inline void print_irqtrace_events
 
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 # ifdef CONFIG_PROVE_LOCKING
-#  define rwlock_acquire(l, s, t, i)		lock_acquire(l, s, t, 0, 2, NULL, i)
-#  define rwlock_acquire_read(l, s, t, i)	lock_acquire(l, s, t, 2, 2, NULL, i)
+#  define rwlock_acquire(l, s, t, i)		\
+		lock_acquire(l, s, t, STATE_WRITE, 2, NULL, i)
+#  define rwlock_acquire_read(l, s, t, i)	\
+		lock_acquire(l, s, t, STATE_RECURSIVE_READ, 2, NULL, i)
 # else
-#  define rwlock_acquire(l, s, t, i)		lock_acquire(l, s, t, 0, 1, NULL, i)
-#  define rwlock_acquire_read(l, s, t, i)	lock_acquire(l, s, t, 2, 1, NULL, i)
+#  define rwlock_acquire(l, s, t, i)		\
+		lock_acquire(l, s, t, STATE_WRITE, 1, NULL, i)
+#  define rwlock_acquire_read(l, s, t, i)	\
+		lock_acquire(l, s, t, STATE_RECURSIVE_READ, 1, NULL, i)
 # endif
 # define rwlock_release(l, n, i)		lock_release(l, n, i)
 #else
@@ -486,9 +531,11 @@ static inline void print_irqtrace_events
 
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 # ifdef CONFIG_PROVE_LOCKING
-#  define mutex_acquire(l, s, t, i)		lock_acquire(l, s, t, 0, 2, NULL, i)
+#  define mutex_acquire(l, s, t, i)		\
+		lock_acquire(l, s, t, STATE_WRITE, 2, NULL, i)
 # else
-#  define mutex_acquire(l, s, t, i)		lock_acquire(l, s, t, 0, 1, NULL, i)
+#  define mutex_acquire(l, s, t, i)		\
+		lock_acquire(l, s, t, STATE_WRITE, 1, NULL, i)
 # endif
 # define mutex_release(l, n, i)			lock_release(l, n, i)
 #else
@@ -498,11 +545,15 @@ static inline void print_irqtrace_events
 
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 # ifdef CONFIG_PROVE_LOCKING
-#  define rwsem_acquire(l, s, t, i)		lock_acquire(l, s, t, 0, 2, NULL, i)
-#  define rwsem_acquire_read(l, s, t, i)	lock_acquire(l, s, t, 1, 2, NULL, i)
+#  define rwsem_acquire(l, s, t, i)		\
+		lock_acquire(l, s, t, STATE_WRITE, 2, NULL, i)
+#  define rwsem_acquire_read(l, s, t, i)	\
+		lock_acquire(l, s, t, STATE_READ, 2, NULL, i)
 # else
-#  define rwsem_acquire(l, s, t, i)		lock_acquire(l, s, t, 0, 1, NULL, i)
-#  define rwsem_acquire_read(l, s, t, i)	lock_acquire(l, s, t, 1, 1, NULL, i)
+#  define rwsem_acquire(l, s, t, i)		\
+		lock_acquire(l, s, t, STATE_WRITE, 1, NULL, i)
+#  define rwsem_acquire_read(l, s, t, i)	\
+		lock_acquire(l, s, t, STATE_READ, 1, NULL, i)
 # endif
 # define rwsem_release(l, n, i)			lock_release(l, n, i)
 #else
@@ -513,11 +564,13 @@ static inline void print_irqtrace_events
 
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 # ifdef CONFIG_PROVE_LOCKING
-#  define lock_map_acquire(l)		lock_acquire(l, 0, 0, 0, 2, NULL, _THIS_IP_)
 #  define lock_map_acquire_read(l)	lock_acquire(l, 0, 0, 2, 2, NULL, _THIS_IP_)
+#  define lock_map_acquire(l)		\
+		lock_acquire(l, 0, 0, STATE_WRITE, 2, NULL, _THIS_IP_)
 # else
-#  define lock_map_acquire(l)		lock_acquire(l, 0, 0, 0, 1, NULL, _THIS_IP_)
 #  define lock_map_acquire_read(l)	lock_acquire(l, 0, 0, 2, 1, NULL, _THIS_IP_)
+#  define lock_map_acquire(l)		\
+		lock_acquire(l, 0, 0, STATE_WRITE, 1, NULL, _THIS_IP_)
 # endif
 # define lock_map_release(l)			lock_release(l, 1, _THIS_IP_)
 #else
@@ -530,13 +583,15 @@ static inline void print_irqtrace_events
 # define might_lock(lock) 						\
 do {									\
 	typecheck(struct lockdep_map *, &(lock)->dep_map);		\
-	lock_acquire(&(lock)->dep_map, 0, 0, 0, 2, NULL, _THIS_IP_);	\
+	lock_acquire(&(lock)->dep_map, 0, 0, STATE_WRITE,		\
+						2, NULL, _THIS_IP_);	\
 	lock_release(&(lock)->dep_map, 0, _THIS_IP_);			\
 } while (0)
 # define might_lock_read(lock) 						\
 do {									\
 	typecheck(struct lockdep_map *, &(lock)->dep_map);		\
-	lock_acquire(&(lock)->dep_map, 0, 0, 1, 2, NULL, _THIS_IP_);	\
+	lock_acquire(&(lock)->dep_map, 0, 0, STATE_READ,		\
+						2, NULL, _THIS_IP_);	\
 	lock_release(&(lock)->dep_map, 0, _THIS_IP_);			\
 } while (0)
 #else
Index: tip/kernel/lockdep.c
===================================================================
--- tip.orig/kernel/lockdep.c
+++ tip/kernel/lockdep.c
@@ -256,7 +256,7 @@ static void lock_release_holdtime(struct
 	holdtime = lockstat_clock() - hlock->holdtime_stamp;
 
 	stats = get_lock_stats(hlock_class(hlock));
-	if (hlock->read)
+	if (is_read(hlock->rw_state))
 		lock_time_inc(&stats->read_holdtime, holdtime);
 	else
 		lock_time_inc(&stats->write_holdtime, holdtime);
@@ -1575,7 +1575,7 @@ print_deadlock_bug(struct task_struct *c
  */
 static int
 check_deadlock(struct task_struct *curr, struct held_lock *next,
-	       struct lockdep_map *next_instance, int read)
+	       struct lockdep_map *next_instance, int rw_state)
 {
 	struct held_lock *prev;
 	struct held_lock *nest = NULL;
@@ -1594,7 +1594,7 @@ check_deadlock(struct task_struct *curr,
 		 * Allow read-after-read recursion of the same
 		 * lock class (i.e. read_lock(lock)+read_lock(lock)):
 		 */
-		if ((read == 2) && prev->read)
+		if (is_rec_read(rw_state) && is_read(prev->rw_state))
 			return 2;
 
 		/*
@@ -1676,7 +1676,7 @@ check_prev_add(struct task_struct *curr,
 	 * write-lock never takes any other locks, then the reads are
 	 * equivalent to a NOP.
 	 */
-	if (next->read == 2)
+	if (is_rec_read(next->rw_state))
 		return 1;
 	/*
 	 * Is the <prev> -> <next> dependency already present?
@@ -1765,7 +1765,7 @@ check_prevs_add(struct task_struct *curr
 		 * Only non-recursive-read entries get new dependencies
 		 * added:
 		 */
-		if (hlock->read != 2) {
+		if (!is_rec_read(hlock->rw_state)) {
 			if (!check_prev_add(curr, hlock, next,
 						distance, trylock_loop))
 				return 0;
@@ -1935,7 +1935,7 @@ static int validate_chain(struct task_st
 		 * any of these scenarios could lead to a deadlock. If
 		 * All validations
 		 */
-		int ret = check_deadlock(curr, hlock, lock, hlock->read);
+		int ret = check_deadlock(curr, hlock, lock, hlock->rw_state);
 
 		if (!ret)
 			return 0;
@@ -2273,7 +2273,7 @@ mark_held_locks(struct task_struct *curr
 		hlock = curr->held_locks + i;
 
 		usage_bit = 2 + (mark << 2); /* ENABLED */
-		if (hlock->read)
+		if (hlock->rw_state)
 			usage_bit += 1; /* READ */
 
 		BUG_ON(usage_bit >= LOCK_USAGE_STATES);
@@ -2486,7 +2486,7 @@ static int mark_irqflags(struct task_str
 	 * mark the lock as used in these contexts:
 	 */
 	if (!hlock->trylock) {
-		if (hlock->read) {
+		if (is_read(hlock->rw_state)) {
 			if (curr->hardirq_context)
 				if (!mark_lock(curr, hlock,
 						LOCK_USED_IN_HARDIRQ_READ))
@@ -2505,7 +2505,7 @@ static int mark_irqflags(struct task_str
 		}
 	}
 	if (!hlock->hardirqs_off) {
-		if (hlock->read) {
+		if (is_read(hlock->rw_state)) {
 			if (!mark_lock(curr, hlock,
 					LOCK_ENABLED_HARDIRQ_READ))
 				return 0;
@@ -2531,7 +2531,7 @@ static int mark_irqflags(struct task_str
 	 * allocation).
 	 */
 	if (!hlock->trylock && (curr->lockdep_reclaim_gfp & __GFP_FS)) {
-		if (hlock->read) {
+		if (is_read(hlock->rw_state)) {
 			if (!mark_lock(curr, hlock, LOCK_USED_IN_RECLAIM_FS_READ))
 					return 0;
 		} else {
@@ -2712,9 +2712,9 @@ struct lock_class_key __lockdep_no_valid
  * We maintain the dependency maps and validate the locking attempt:
  */
 static int __lock_acquire(struct lockdep_map *lock, unsigned int subclass,
-			  int trylock, int read, int check, int hardirqs_off,
-			  struct lockdep_map *nest_lock, unsigned long ip,
-			  int references)
+			  int trylock, int rw_state, int check,
+			  int hardirqs_off, struct lockdep_map *nest_lock,
+			  unsigned long ip, int references)
 {
 	struct task_struct *curr = current;
 	struct lock_class *class = NULL;
@@ -2786,7 +2786,7 @@ static int __lock_acquire(struct lockdep
 	hlock->instance = lock;
 	hlock->nest_lock = nest_lock;
 	hlock->trylock = trylock;
-	hlock->read = read;
+	hlock->rw_state = rw_state;
 	hlock->check = check;
 	hlock->hardirqs_off = !!hardirqs_off;
 	hlock->references = references;
@@ -2963,7 +2963,7 @@ found_it:
 		hlock = curr->held_locks + i;
 		if (!__lock_acquire(hlock->instance,
 			hlock_class(hlock)->subclass, hlock->trylock,
-				hlock->read, hlock->check, hlock->hardirqs_off,
+				hlock->rw_state, hlock->check, hlock->hardirqs_off,
 				hlock->nest_lock, hlock->acquire_ip,
 				hlock->references))
 			return 0;
@@ -3039,7 +3039,7 @@ found_it:
 		hlock = curr->held_locks + i;
 		if (!__lock_acquire(hlock->instance,
 			hlock_class(hlock)->subclass, hlock->trylock,
-				hlock->read, hlock->check, hlock->hardirqs_off,
+				hlock->rw_state, hlock->check, hlock->hardirqs_off,
 				hlock->nest_lock, hlock->acquire_ip,
 				hlock->references))
 			return 0;
@@ -3192,7 +3192,7 @@ EXPORT_SYMBOL_GPL(lock_set_class);
  * and also avoid lockdep recursion:
  */
 void lock_acquire(struct lockdep_map *lock, unsigned int subclass,
-			  int trylock, int read, int check,
+			  int trylock, int rw_state, int check,
 			  struct lockdep_map *nest_lock, unsigned long ip)
 {
 	unsigned long flags;
@@ -3204,8 +3204,8 @@ void lock_acquire(struct lockdep_map *lo
 	check_flags(flags);
 
 	current->lockdep_recursion = 1;
-	trace_lock_acquire(lock, subclass, trylock, read, check, nest_lock, ip);
-	__lock_acquire(lock, subclass, trylock, read, check,
+	trace_lock_acquire(lock, subclass, trylock, rw_state, check, nest_lock, ip);
+	__lock_acquire(lock, subclass, trylock, rw_state, check,
 		       irqs_disabled_flags(flags), nest_lock, ip, 0);
 	current->lockdep_recursion = 0;
 	raw_local_irq_restore(flags);
@@ -3332,7 +3332,8 @@ found_it:
 	if (contending_point < LOCKSTAT_POINTS)
 		stats->contending_point[contending_point]++;
 	if (lock->cpu != smp_processor_id())
-		stats->bounces[bounce_contended + !!hlock->read]++;
+		stats->bounces[bounce_contended +
+				!!is_read(hlock->rw_state)]++;
 	put_lock_stats(stats);
 }
 
@@ -3380,13 +3381,14 @@ found_it:
 
 	stats = get_lock_stats(hlock_class(hlock));
 	if (waittime) {
-		if (hlock->read)
+		if (is_read(hlock->rw_state))
 			lock_time_inc(&stats->read_waittime, waittime);
 		else
 			lock_time_inc(&stats->write_waittime, waittime);
 	}
 	if (lock->cpu != cpu)
-		stats->bounces[bounce_acquired + !!hlock->read]++;
+		stats->bounces[bounce_acquired +
+				!!is_read(hlock->rw_state)]++;
 	put_lock_stats(stats);
 
 	lock->cpu = cpu;


