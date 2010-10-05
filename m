Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932706Ab0JEJ0y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 05:26:54 -0400
Received: from ns.dcl.info.waseda.ac.jp ([133.9.216.194]:64580 "EHLO
	ns.dcl.info.waseda.ac.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932508Ab0JEJ0v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 05:26:51 -0400
From: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
To: Ingo Molnar <mingo@redhat.com>
Cc: linux-kernel@vger.kernel.org, mitake@dcl.info.waseda.ac.jp,
        h.mitake@gmail.com, Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [RFC PATCH 2/2] lockdep: caching subclasses
Date: Tue,  5 Oct 2010 18:01:51 +0900
Message-Id: <1286269311-28336-2-git-send-email-mitake@dcl.info.waseda.ac.jp>
X-Mailer: git-send-email 1.6.5.2
In-Reply-To: <1286269311-28336-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
References: <1286269311-28336-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current lockdep_map only caches one class with subclass == 0,
and looks up hash table of classes when subclass != 0.

It seems that this has no problem because the case of
subclass != 0 is rare. But locks of struct rq are
acquired with subclass == 1 when task migration is executed.
Task migration is high frequent event, so I modified lockdep
to cache subclasses.

I measured the score of perf bench sched messaging.
This patch has slightly but certain (order of milli seconds
or 10 milli seconds) effect when lots of tasks are running.
I'll show the result in the tail of this description.

NR_LOCKDEP_CACHING_CLASSES specifies how many classes can be
cached in the instances of lockdep_map.
I discussed with Peter Zijlstra in LinuxCon Japan about
this approach and he taught me that caching every subclasses(8)
is cleary waste of memory. So number of cached classes
should be configurable.

I think that this patch has a little effect for making lockdep
as a production feature, I'd like to hear your comments.

Thanks,

=== Score comparison of benchmarks ===
# "min" means best score, and "max" means worst score

for i in `seq 1 10`; do ./perf bench -f simple sched messaging; done

before: min: 0.565000, max: 0.583000, avg: 0.572500
after:  min: 0.559000, max: 0.568000, avg: 0.563300

# with more processes
for i in `seq 1 10`; do ./perf bench -f simple sched messaging -g 40; done

before: min: 2.274000, max: 2.298000, avg: 2.286300
after:  min: 2.242000, max: 2.270000, avg: 2.259700

Signed-off-by: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
---
 include/linux/lockdep.h |   13 ++++++++++++-
 kernel/lockdep.c        |   25 ++++++++++++++++++-------
 2 files changed, 30 insertions(+), 8 deletions(-)

diff --git a/include/linux/lockdep.h b/include/linux/lockdep.h
index 06aed83..2186a64 100644
--- a/include/linux/lockdep.h
+++ b/include/linux/lockdep.h
@@ -32,6 +32,17 @@ extern int lock_stat;
 #define MAX_LOCKDEP_SUBCLASSES		8UL
 
 /*
+ * NR_LOCKDEP_CACHING_CLASSES ... Number of classes
+ * cached in the instance of lockdep_map
+ *
+ * Currently main class (subclass == 0) and signle depth subclass
+ * are cached in lockdep_map. This optimization is mainly targeting
+ * on rq->lock. double_rq_lock() acquires this highly competitive with
+ * single depth.
+ */
+#define NR_LOCKDEP_CACHING_CLASSES	2
+
+/*
  * Lock-classes are keyed via unique addresses, by embedding the
  * lockclass-key into the kernel (or module) .data section. (For
  * static locks we use the lock address itself as the key.)
@@ -138,7 +149,7 @@ void clear_lock_stats(struct lock_class *class);
  */
 struct lockdep_map {
 	struct lock_class_key		*key;
-	struct lock_class		*class_cache;
+	struct lock_class		*class_cache[NR_LOCKDEP_CACHING_CLASSES];
 	const char			*name;
 #ifdef CONFIG_LOCK_STAT
 	int				cpu;
diff --git a/kernel/lockdep.c b/kernel/lockdep.c
index c4c13ae..a41b38f 100644
--- a/kernel/lockdep.c
+++ b/kernel/lockdep.c
@@ -789,7 +789,9 @@ out_unlock_set:
 	raw_local_irq_restore(flags);
 
 	if (!subclass || force)
-		lock->class_cache = class;
+		lock->class_cache[0] = class;
+	else if (subclass < NR_LOCKDEP_CACHING_CLASSES)
+		lock->class_cache[subclass] = class;
 
 	if (DEBUG_LOCKS_WARN_ON(class->subclass != subclass))
 		return NULL;
@@ -2694,7 +2696,11 @@ static int mark_lock(struct task_struct *curr, struct held_lock *this,
 void lockdep_init_map(struct lockdep_map *lock, const char *name,
 		      struct lock_class_key *key, int subclass)
 {
-	lock->class_cache = NULL;
+	int i;
+
+	for (i = 0; i < NR_LOCKDEP_CACHING_CLASSES; i++)
+		lock->class_cache[i] = NULL;
+
 #ifdef CONFIG_LOCK_STAT
 	lock->cpu = raw_smp_processor_id();
 #endif
@@ -2765,10 +2771,10 @@ static int __lock_acquire(struct lockdep_map *lock, unsigned int subclass,
 	if (lock->key == &__lockdep_no_validate__)
 		check = 1;
 
-	if (!subclass)
-		class = lock->class_cache;
+	if (subclass < NR_LOCKDEP_CACHING_CLASSES)
+		class = lock->class_cache[subclass];
 	/*
-	 * Not cached yet or subclass?
+	 * Not cached?
 	 */
 	if (unlikely(!class)) {
 		class = register_lock_class(lock, subclass, 0);
@@ -2933,7 +2939,7 @@ static int match_held_lock(struct held_lock *hlock, struct lockdep_map *lock)
 		return 1;
 
 	if (hlock->references) {
-		struct lock_class *class = lock->class_cache;
+		struct lock_class *class = lock->class_cache[0];
 
 		if (!class)
 			class = look_up_lock_class(lock, 0);
@@ -3574,7 +3580,12 @@ void lockdep_reset_lock(struct lockdep_map *lock)
 		if (list_empty(head))
 			continue;
 		list_for_each_entry_safe(class, next, head, hash_entry) {
-			if (unlikely(class == lock->class_cache)) {
+			int match = 0;
+
+			for (j = 0; j < NR_LOCKDEP_CACHING_CLASSES; j++)
+				match |= class == lock->class_cache[j];
+
+			if (unlikely(match)) {
 				if (debug_locks_off_graph_unlock())
 					WARN_ON(1);
 				goto out_restore;
-- 
1.6.5.2

