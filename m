Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753200Ab1DQJ7O (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Apr 2011 05:59:14 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:34136 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752192Ab1DQJ6F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Apr 2011 05:58:05 -0400
Message-Id: <20110417095507.220580277@chello.nl>
User-Agent: quilt/0.48-1
Date: Sun, 17 Apr 2011 11:45:10 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [RFC][PATCH 5/7] lockdep: Rename lock_list::class
References: <20110417094505.865828233@chello.nl>
Content-Disposition: inline; filename=gautham_r_shenoy-lockdep-rename-lock_list-class.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gautham R Shenoy <ego@in.ibm.com>

Rename a variable in locklist to reflect its usage better.

Signed-off-by: Gautham R Shenoy <ego@in.ibm.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 include/linux/lockdep.h |    9 ++++++-
 kernel/lockdep.c        |   56 ++++++++++++++++++++++++------------------------
 kernel/lockdep_proc.c   |    4 +--
 3 files changed, 38 insertions(+), 31 deletions(-)

Index: linux-2.6/include/linux/lockdep.h
===================================================================
--- linux-2.6.orig/include/linux/lockdep.h
+++ linux-2.6/include/linux/lockdep.h
@@ -158,12 +158,19 @@ struct lockdep_map {
 };
 
 /*
+ * lock_list: List of the other locks taken before or after a particular lock.
+ *
+ * @entry -	List head linking this particular entry to the
+ *		lock_after/lock_before list of a particular lock.
+ * @dep_class - lock_class of the lock which is involved in a dependency with
+ *		 the lock to which this entry is linked to.
+ *
  * Every lock has a list of other locks that were taken after it.
  * We only grow the list, never remove from it:
  */
 struct lock_list {
 	struct list_head		entry;
-	struct lock_class		*class;
+	struct lock_class		*dep_class;
 	struct stack_trace		trace;
 	int				distance;
 
Index: linux-2.6/kernel/lockdep.c
===================================================================
--- linux-2.6.orig/kernel/lockdep.c
+++ linux-2.6/kernel/lockdep.c
@@ -829,7 +829,7 @@ static int add_lock_to_list(struct lock_
 	if (!entry)
 		return 0;
 
-	entry->class = this;
+	entry->dep_class = this;
 	entry->distance = distance;
 	entry->trace = *trace;
 	/*
@@ -916,7 +916,7 @@ static inline void mark_lock_accessed(st
 	nr = lock - list_entries;
 	WARN_ON(nr >= nr_list_entries);
 	lock->parent = parent;
-	lock->class->dep_gen_id = lockdep_dependency_gen_id;
+	lock->dep_class->dep_gen_id = lockdep_dependency_gen_id;
 }
 
 static inline unsigned long lock_accessed(struct lock_list *lock)
@@ -925,7 +925,7 @@ static inline unsigned long lock_accesse
 
 	nr = lock - list_entries;
 	WARN_ON(nr >= nr_list_entries);
-	return lock->class->dep_gen_id == lockdep_dependency_gen_id;
+	return lock->dep_class->dep_gen_id == lockdep_dependency_gen_id;
 }
 
 static inline struct lock_list *get_lock_parent(struct lock_list *child)
@@ -963,9 +963,9 @@ static int __bfs(struct lock_list *sourc
 	}
 
 	if (forward)
-		head = &source_entry->class->locks_after;
+		head = &source_entry->dep_class->locks_after;
 	else
-		head = &source_entry->class->locks_before;
+		head = &source_entry->dep_class->locks_before;
 
 	if (list_empty(head))
 		goto exit;
@@ -978,15 +978,15 @@ static int __bfs(struct lock_list *sourc
 
 		__cq_dequeue(cq, (unsigned long *)&lock);
 
-		if (!lock->class) {
+		if (!lock->dep_class) {
 			ret = -2;
 			goto exit;
 		}
 
 		if (forward)
-			head = &lock->class->locks_after;
+			head = &lock->dep_class->locks_after;
 		else
-			head = &lock->class->locks_before;
+			head = &lock->dep_class->locks_before;
 
 		list_for_each_entry(entry, head, entry) {
 			if (!lock_accessed(entry)) {
@@ -1046,7 +1046,7 @@ print_circular_bug_entry(struct lock_lis
 	if (debug_locks_silent)
 		return 0;
 	printk("\n-> #%u", depth);
-	print_lock_name(target->class);
+	print_lock_name(target->dep_class);
 	printk(":\n");
 	print_stack_trace(&target->trace, 6);
 
@@ -1086,7 +1086,7 @@ print_circular_bug_header(struct lock_li
 
 static inline int class_equal(struct lock_list *entry, void *data)
 {
-	return entry->class == data;
+	return entry->dep_class == data;
 }
 
 static noinline int print_circular_bug(struct lock_list *this,
@@ -1155,7 +1155,7 @@ unsigned long lockdep_count_forward_deps
 	struct lock_list this;
 
 	this.parent = NULL;
-	this.class = class;
+	this.dep_class = class;
 
 	local_irq_save(flags);
 	arch_spin_lock(&lockdep_lock);
@@ -1182,7 +1182,7 @@ unsigned long lockdep_count_backward_dep
 	struct lock_list this;
 
 	this.parent = NULL;
-	this.class = class;
+	this.dep_class = class;
 
 	local_irq_save(flags);
 	arch_spin_lock(&lockdep_lock);
@@ -1219,14 +1219,14 @@ check_noncircular(struct lock_list *root
 
 static inline int usage_match(struct lock_list *entry, void *bit)
 {
-	return entry->class->usage_mask & (1 << (enum lock_usage_bit)bit);
+	return entry->dep_class->usage_mask & (1 << (enum lock_usage_bit)bit);
 }
 
 
 
 /*
  * Find a node in the forwards-direction dependency sub-graph starting
- * at @root->class that matches @bit.
+ * at @root->dep_class that matches @bit.
  *
  * Return 0 if such a node exists in the subgraph, and put that node
  * into *@target_entry.
@@ -1249,7 +1249,7 @@ find_usage_forwards(struct lock_list *ro
 
 /*
  * Find a node in the backwards-direction dependency sub-graph starting
- * at @root->class that matches @bit.
+ * at @root->dep_class that matches @bit.
  *
  * Return 0 if such a node exists in the subgraph, and put that node
  * into *@target_entry.
@@ -1308,7 +1308,7 @@ print_shortest_lock_dependencies(struct
 	depth = get_lock_depth(leaf);
 
 	do {
-		print_lock_class_header(entry->class, depth);
+		print_lock_class_header(entry->dep_class, depth);
 		printk("%*s ... acquired at:\n", depth, "");
 		print_stack_trace(&entry->trace, 2);
 		printk("\n");
@@ -1363,17 +1363,17 @@ print_bad_irq_dependency(struct task_str
 
 	printk("\nbut this new dependency connects a %s-irq-safe lock:\n",
 		irqclass);
-	print_lock_name(backwards_entry->class);
+	print_lock_name(backwards_entry->dep_class);
 	printk("\n... which became %s-irq-safe at:\n", irqclass);
 
-	print_stack_trace(backwards_entry->class->usage_traces + bit1, 1);
+	print_stack_trace(backwards_entry->dep_class->usage_traces + bit1, 1);
 
 	printk("\nto a %s-irq-unsafe lock:\n", irqclass);
-	print_lock_name(forwards_entry->class);
+	print_lock_name(forwards_entry->dep_class);
 	printk("\n... which became %s-irq-unsafe at:\n", irqclass);
 	printk("...");
 
-	print_stack_trace(forwards_entry->class->usage_traces + bit2, 1);
+	print_stack_trace(forwards_entry->dep_class->usage_traces + bit2, 1);
 
 	printk("\nother info that might help us debug this:\n\n");
 	lockdep_print_held_locks(curr);
@@ -1408,7 +1408,7 @@ check_usage(struct task_struct *curr, st
 
 	this.parent = NULL;
 
-	this.class = hlock_class(prev);
+	this.dep_class = hlock_class(prev);
 	ret = find_usage_backwards(&this, bit_backwards, &target_entry);
 	if (ret < 0)
 		return print_bfs_bug(ret);
@@ -1416,7 +1416,7 @@ check_usage(struct task_struct *curr, st
 		return ret;
 
 	that.parent = NULL;
-	that.class = hlock_class(next);
+	that.dep_class = hlock_class(next);
 	ret = find_usage_forwards(&that, bit_forwards, &target_entry1);
 	if (ret < 0)
 		return print_bfs_bug(ret);
@@ -1657,7 +1657,7 @@ check_prev_add(struct task_struct *curr,
 	 * We are using global variables to control the recursion, to
 	 * keep the stackframe size of the recursive functions low:
 	 */
-	this.class = hlock_class(next);
+	this.dep_class = hlock_class(next);
 	this.parent = NULL;
 	ret = check_noncircular(&this, hlock_class(prev), &target_entry);
 	if (unlikely(!ret))
@@ -1687,7 +1687,7 @@ check_prev_add(struct task_struct *curr,
 	 *  L2 added to its dependency list, due to the first chain.)
 	 */
 	list_for_each_entry(entry, &hlock_class(prev)->locks_after, entry) {
-		if (entry->class == hlock_class(next)) {
+		if (entry->dep_class == hlock_class(next)) {
 			if (distance == 1)
 				entry->distance = 1;
 			return 2;
@@ -2083,7 +2083,7 @@ print_irq_inversion_bug(struct task_stru
 		printk("but this lock took another, %s-unsafe lock in the past:\n", irqclass);
 	else
 		printk("but this lock was taken by another, %s-safe lock in the past:\n", irqclass);
-	print_lock_name(other->class);
+	print_lock_name(other->dep_class);
 	printk("\n\nand interrupts could create inverse lock ordering between them.\n\n");
 
 	printk("\nother info that might help us debug this:\n");
@@ -2113,7 +2113,7 @@ check_usage_forwards(struct task_struct
 	struct lock_list *uninitialized_var(target_entry);
 
 	root.parent = NULL;
-	root.class = hlock_class(this);
+	root.dep_class = hlock_class(this);
 	ret = find_usage_forwards(&root, bit, &target_entry);
 	if (ret < 0)
 		return print_bfs_bug(ret);
@@ -2137,7 +2137,7 @@ check_usage_backwards(struct task_struct
 	struct lock_list *uninitialized_var(target_entry);
 
 	root.parent = NULL;
-	root.class = hlock_class(this);
+	root.dep_class = hlock_class(this);
 	ret = find_usage_backwards(&root, bit, &target_entry);
 	if (ret < 0)
 		return print_bfs_bug(ret);
@@ -3482,7 +3482,7 @@ static void zap_class(struct lock_class
 	 * involved in:
 	 */
 	for (i = 0; i < nr_list_entries; i++) {
-		if (list_entries[i].class == class)
+		if (list_entries[i].dep_class == class)
 			list_del_rcu(&list_entries[i].entry);
 	}
 	/*
Index: linux-2.6/kernel/lockdep_proc.c
===================================================================
--- linux-2.6.orig/kernel/lockdep_proc.c
+++ linux-2.6/kernel/lockdep_proc.c
@@ -83,8 +83,8 @@ static int l_show(struct seq_file *m, vo
 
 	list_for_each_entry(entry, &class->locks_after, entry) {
 		if (entry->distance == 1) {
-			seq_printf(m, " -> [%p] ", entry->class->key);
-			print_name(m, entry->class);
+			seq_printf(m, " -> [%p] ", entry->dep_class->key);
+			print_name(m, entry->dep_class);
 			seq_puts(m, "\n");
 		}
 	}


