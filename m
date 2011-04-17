Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752529Ab1DQJ6I (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Apr 2011 05:58:08 -0400
Received: from casper.infradead.org ([85.118.1.10]:51527 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751755Ab1DQJ6C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Apr 2011 05:58:02 -0400
Message-Id: <20110417095507.412301573@chello.nl>
User-Agent: quilt/0.48-1
Date: Sun, 17 Apr 2011 11:45:12 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [RFC][PATCH 7/7] lockdep: Consider the rw_state of lock while validating the chain
References: <20110417094505.865828233@chello.nl>
Content-Disposition: inline; filename=gautham_r_shenoy-lockdep-consider_the_rw_state_of_lock_while.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gautham R Shenoy <ego@in.ibm.com>

Currently, while validating a particular dependency chain, we check if by
following the the locks_after list of current lock A, we can reach one of the
previous locks in the current chain.

i.e, if current chain is : A --> B --> C, then starting from C -->
locks_after, can we reach B.

However, if there are dependency chains:

	C--> D --> Rlock(E)

	Rlock(E) --> A,

where E is a Recursive Read lock, this chain cannot cause a deadlock because
of the recursive nature of E.

However, if the dependency chain was:

	Wlock(E) --> A,

it could have caused a deadlock.

We solve this problem by defining conflicting states of each lock where:

	Conflict(WRITE)		  =  WRITE, READ, RECURSIVE_READ
	Conflict(READ)		  =  WRITE, READ
	Conflict(RECURSIVE_READ)  =  WRITE

Thus, while traversing the locks_after chain of a particular lock A, we traverse
through only those entries in the chain where the state of the lock A in the
entry conflicts with the state of the lock A with which we started the
traversal.

Signed-off-by: Gautham R Shenoy <ego@in.ibm.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/lockdep.c |   43 ++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 40 insertions(+), 3 deletions(-)

Index: linux-2.6/kernel/lockdep.c
===================================================================
--- linux-2.6.orig/kernel/lockdep.c
+++ linux-2.6/kernel/lockdep.c
@@ -949,6 +949,26 @@ static inline int get_lock_depth(struct
 	return depth;
 }
 
+/*
+ * Conflicting states:
+ * - A Recursive read conflicts only with a write.
+ * - A Non-recursive read can conflict with a non-recursive read and write.
+ * - A Write conflicts with Write, simple read and recursive read.
+ */
+
+#define get_rec_read_conflict(state)		\
+	((((is_write(state)) << (_RR_ - _W_))) & STATE_RECURSIVE_READ)
+
+#define get_simple_read_conflict(state)		\
+	(((((is_write(state)) << (_R_ - _W_))) | (is_simple_read(state))) \
+							& STATE_READ)
+#define get_write_conflict(state)	STATE_WRITE
+
+#define get_lock_conflict_states(state)		\
+	(get_rec_read_conflict(state) |	\
+	get_simple_read_conflict(state) |	\
+	get_write_conflict(state))
+
 static int __bfs(struct lock_list *source_entry,
 		 void *data,
 		 int (*match)(struct lock_list *entry, void *data),
@@ -958,6 +978,7 @@ static int __bfs(struct lock_list *sourc
 	struct lock_list *entry;
 	struct list_head *head;
 	struct circular_queue *cq = &lock_cq;
+	unsigned int conflict;
 	int ret = 1;
 
 	if (match(source_entry, data)) {
@@ -992,9 +1013,13 @@ static int __bfs(struct lock_list *sourc
 		else
 			head = &lock->dep_class->locks_before;
 
+		conflict = get_lock_conflict_states(lock->dep_lock_rw_state);
+
 		list_for_each_entry(entry, head, entry) {
 			if (!lock_accessed(entry)) {
 				unsigned int cq_depth;
+				if (!(entry->this_lock_rw_state & conflict))
+					continue;
 				mark_lock_accessed(entry, lock);
 				if (match(entry, data)) {
 					*target_entry = entry;
@@ -1411,8 +1436,9 @@ check_usage(struct task_struct *curr, st
 	struct lock_list *uninitialized_var(target_entry1);
 
 	this.parent = NULL;
-
 	this.dep_class = hlock_class(prev);
+	this.this_lock_rw_state = next->rw_state;
+	this.dep_lock_rw_state = prev->rw_state;
 	ret = find_usage_backwards(&this, bit_backwards, &target_entry);
 	if (ret < 0)
 		return print_bfs_bug(ret);
@@ -1421,6 +1447,8 @@ check_usage(struct task_struct *curr, st
 
 	that.parent = NULL;
 	that.dep_class = hlock_class(next);
+	that.this_lock_rw_state = prev->rw_state;
+	that.dep_lock_rw_state = next->rw_state;
 	ret = find_usage_forwards(&that, bit_forwards, &target_entry1);
 	if (ret < 0)
 		return print_bfs_bug(ret);
@@ -1663,6 +1691,8 @@ check_prev_add(struct task_struct *curr,
 	 */
 	this.dep_class = hlock_class(next);
 	this.parent = NULL;
+	this.this_lock_rw_state = prev->rw_state;
+	this.dep_lock_rw_state = next->rw_state;
 	ret = check_noncircular(&this, hlock_class(prev), &target_entry);
 	if (unlikely(!ret))
 		return print_circular_bug(&this, target_entry, next, prev);
@@ -1776,7 +1806,8 @@ check_prevs_add(struct task_struct *curr
 		 * Only non-recursive-read entries get new dependencies
 		 * added:
 		 */
-		if (!is_rec_read(hlock->rw_state)) {
+		if (!is_rec_read(hlock->rw_state) ||
+				is_first_rec_read(hlock->rw_state)) {
 			if (!check_prev_add(curr, hlock, next,
 						distance, trylock_loop))
 				return 0;
@@ -1950,9 +1981,15 @@ static int validate_chain(struct task_st
 
 		if (!ret)
 			return 0;
+
+		if (ret != 2 && is_rec_read(hlock->rw_state))
+			hlock->rw_state |= STATE_FIRST_RECURSIVE_READ;
+
+
 		/*
 		 * Add dependency only if this lock is not the head
-		 * of the chain, and if it's not a secondary read-lock:
+		 * of the chain, and if it's not the first instance of
+		 * the recursive read-lock:
 		 */
 		if (!chain_head && ret != 2)
 			if (!check_prevs_add(curr, hlock))


