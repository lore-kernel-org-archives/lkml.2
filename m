Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752676Ab1DQJ6y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Apr 2011 05:58:54 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:34132 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752291Ab1DQJ6F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Apr 2011 05:58:05 -0400
Message-Id: <20110417095507.318610186@chello.nl>
User-Agent: quilt/0.48-1
Date: Sun, 17 Apr 2011 11:45:11 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [RFC][PATCH 6/7] lockdep: Maintain rw_state entries in locklist
References: <20110417094505.865828233@chello.nl>
Content-Disposition: inline; filename=gautham_r_shenoy-lockdep-maintain_rw_state_entries_in.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gautham R Shenoy <ego@in.ibm.com>

The dependencies are currently maintained using a structure named
locklist. For a dependency A --> B, it saves B's lock_class in an
entry that would be linked to A's locks_after list.

However, in order to make use of the split chains introduced in the
previous patch, we need to enhance this infrastructure to save the
read/write states of A and B for each dependency such that we might
distinguish between the read and write chains.

Signed-off-by: Gautham R Shenoy <ego@in.ibm.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 include/linux/lockdep.h |    6 ++++++
 kernel/lockdep.c        |   23 +++++++++++++++++------
 2 files changed, 23 insertions(+), 6 deletions(-)

Index: linux-2.6/include/linux/lockdep.h
===================================================================
--- linux-2.6.orig/include/linux/lockdep.h
+++ linux-2.6/include/linux/lockdep.h
@@ -164,6 +164,10 @@ struct lockdep_map {
  *		lock_after/lock_before list of a particular lock.
  * @dep_class - lock_class of the lock which is involved in a dependency with
  *		 the lock to which this entry is linked to.
+ * @this_lock_rw_state - The read/write state of the lock to which this
+ *			 dependency entry belongs to.
+ * @dep_lock_rw_state - The read/write state of the lock with the lock class
+ *			dep_class in this particular dependecy involvement.
  *
  * Every lock has a list of other locks that were taken after it.
  * We only grow the list, never remove from it:
@@ -173,6 +177,8 @@ struct lock_list {
 	struct lock_class		*dep_class;
 	struct stack_trace		trace;
 	int				distance;
+	unsigned int			this_lock_rw_state:3;
+	unsigned int			dep_lock_rw_state:3;
 
 	/*
 	 * The parent field is used to implement breadth-first search, and the
Index: linux-2.6/kernel/lockdep.c
===================================================================
--- linux-2.6.orig/kernel/lockdep.c
+++ linux-2.6/kernel/lockdep.c
@@ -816,11 +816,13 @@ static struct lock_list *alloc_list_entr
 /*
  * Add a new dependency to the head of the list:
  */
-static int add_lock_to_list(struct lock_class *class, struct lock_class *this,
+static int add_lock_to_list(struct held_lock *this_hlock,
+			    struct held_lock *dep_hlock,
 			    struct list_head *head, unsigned long ip,
 			    int distance, struct stack_trace *trace)
 {
 	struct lock_list *entry;
+	struct lock_class *dep_class = hlock_class(dep_hlock);
 	/*
 	 * Lock not present yet - get a new dependency struct and
 	 * add it to the list:
@@ -829,9 +831,11 @@ static int add_lock_to_list(struct lock_
 	if (!entry)
 		return 0;
 
-	entry->dep_class = this;
+	entry->dep_class = dep_class;
 	entry->distance = distance;
 	entry->trace = *trace;
+	entry->this_lock_rw_state = this_hlock->rw_state;
+	entry->dep_lock_rw_state = dep_hlock->rw_state;
 	/*
 	 * Since we never remove from the dependency list, the list can
 	 * be walked lockless by other CPUs, it's only allocation
@@ -1690,6 +1694,8 @@ check_prev_add(struct task_struct *curr,
 		if (entry->dep_class == hlock_class(next)) {
 			if (distance == 1)
 				entry->distance = 1;
+			entry->this_lock_rw_state |= prev->rw_state;
+			entry->dep_lock_rw_state |= next->rw_state;
 			return 2;
 		}
 	}
@@ -1697,19 +1703,24 @@ check_prev_add(struct task_struct *curr,
 	if (!trylock_loop && !save_trace(&trace))
 		return 0;
 
+	list_for_each_entry(entry, &hlock_class(next)->locks_before, entry) {
+		if (entry->dep_class == hlock_class(prev)) {
+			entry->this_lock_rw_state |= next->rw_state;
+			entry->dep_lock_rw_state |= prev->rw_state;
+		}
+	}
+
 	/*
 	 * Ok, all validations passed, add the new lock
 	 * to the previous lock's dependency list:
 	 */
-	ret = add_lock_to_list(hlock_class(prev), hlock_class(next),
-			       &hlock_class(prev)->locks_after,
+	ret = add_lock_to_list(prev, next, &hlock_class(prev)->locks_after,
 			       next->acquire_ip, distance, &trace);
 
 	if (!ret)
 		return 0;
 
-	ret = add_lock_to_list(hlock_class(next), hlock_class(prev),
-			       &hlock_class(next)->locks_before,
+	ret = add_lock_to_list(next, prev, &hlock_class(next)->locks_before,
 			       next->acquire_ip, distance, &trace);
 	if (!ret)
 		return 0;


