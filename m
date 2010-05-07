Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757893Ab0EGSlZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 14:41:25 -0400
Received: from hera.kernel.org ([140.211.167.34]:46392 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757774Ab0EGSlV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 14:41:21 -0400
Date: Fri, 7 May 2010 18:40:59 GMT
From: tip-bot for Yong Zhang <yong.zhang@windriver.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, davem@davemloft.net, yong.zhang@windriver.com,
       tglx@linutronix.de, yong.zhang0@windriver.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, davem@davemloft.net, yong.zhang@windriver.com,
       tglx@linutronix.de, yong.zhang0@windriver.com, mingo@elte.hu
In-Reply-To: <20100504065711.GC10784@windriver.com>
References: <20100504065711.GC10784@windriver.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/locking] lockdep: Reduce stack_trace usage
Message-ID: <tip-4726f2a617ebd868a4fdeb5679613b897e5f1676@git.kernel.org>
Git-Commit-ID: 4726f2a617ebd868a4fdeb5679613b897e5f1676
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 07 May 2010 18:41:02 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4726f2a617ebd868a4fdeb5679613b897e5f1676
Gitweb:     http://git.kernel.org/tip/4726f2a617ebd868a4fdeb5679613b897e5f1676
Author:     Yong Zhang <yong.zhang@windriver.com>
AuthorDate: Tue, 4 May 2010 14:16:48 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 7 May 2010 11:27:26 +0200

lockdep: Reduce stack_trace usage

When calling check_prevs_add(), if all validations passed
add_lock_to_list() will add new lock to dependency tree and
alloc stack_trace for each list_entry.

But at this time, we are always on the same stack, so stack_trace
for each list_entry has the same value. This is redundant and eats
up lots of memory which could lead to warning on low
MAX_STACK_TRACE_ENTRIES.

Use one copy of stack_trace instead.

V2: As suggested by Peter Zijlstra, move save_trace() from
    check_prevs_add() to check_prev_add().
    Add tracking for trylock dependence which is also redundant.

Signed-off-by: Yong Zhang <yong.zhang0@windriver.com>
Cc: David S. Miller <davem@davemloft.net>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <20100504065711.GC10784@windriver.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/lockdep.c |   29 +++++++++++++++++++++--------
 1 files changed, 21 insertions(+), 8 deletions(-)

diff --git a/kernel/lockdep.c b/kernel/lockdep.c
index 9cf7985..5108080 100644
--- a/kernel/lockdep.c
+++ b/kernel/lockdep.c
@@ -805,7 +805,8 @@ static struct lock_list *alloc_list_entry(void)
  * Add a new dependency to the head of the list:
  */
 static int add_lock_to_list(struct lock_class *class, struct lock_class *this,
-			    struct list_head *head, unsigned long ip, int distance)
+			    struct list_head *head, unsigned long ip,
+			    int distance, struct stack_trace *trace)
 {
 	struct lock_list *entry;
 	/*
@@ -816,11 +817,9 @@ static int add_lock_to_list(struct lock_class *class, struct lock_class *this,
 	if (!entry)
 		return 0;
 
-	if (!save_trace(&entry->trace))
-		return 0;
-
 	entry->class = this;
 	entry->distance = distance;
+	entry->trace = *trace;
 	/*
 	 * Since we never remove from the dependency list, the list can
 	 * be walked lockless by other CPUs, it's only allocation
@@ -1622,12 +1621,20 @@ check_deadlock(struct task_struct *curr, struct held_lock *next,
  */
 static int
 check_prev_add(struct task_struct *curr, struct held_lock *prev,
-	       struct held_lock *next, int distance)
+	       struct held_lock *next, int distance, int trylock_loop)
 {
 	struct lock_list *entry;
 	int ret;
 	struct lock_list this;
 	struct lock_list *uninitialized_var(target_entry);
+	/*
+	 * Static variable, serialized by the graph_lock().
+	 *
+	 * We use this static variable to save the stack trace in case
+	 * we call into this function multiple times due to encountering
+	 * trylocks in the held lock stack.
+	 */
+	static struct stack_trace trace;
 
 	/*
 	 * Prove that the new <prev> -> <next> dependency would not
@@ -1675,20 +1682,23 @@ check_prev_add(struct task_struct *curr, struct held_lock *prev,
 		}
 	}
 
+	if (!trylock_loop && !save_trace(&trace))
+		return 0;
+
 	/*
 	 * Ok, all validations passed, add the new lock
 	 * to the previous lock's dependency list:
 	 */
 	ret = add_lock_to_list(hlock_class(prev), hlock_class(next),
 			       &hlock_class(prev)->locks_after,
-			       next->acquire_ip, distance);
+			       next->acquire_ip, distance, &trace);
 
 	if (!ret)
 		return 0;
 
 	ret = add_lock_to_list(hlock_class(next), hlock_class(prev),
 			       &hlock_class(next)->locks_before,
-			       next->acquire_ip, distance);
+			       next->acquire_ip, distance, &trace);
 	if (!ret)
 		return 0;
 
@@ -1718,6 +1728,7 @@ static int
 check_prevs_add(struct task_struct *curr, struct held_lock *next)
 {
 	int depth = curr->lockdep_depth;
+	int trylock_loop = 0;
 	struct held_lock *hlock;
 
 	/*
@@ -1743,7 +1754,8 @@ check_prevs_add(struct task_struct *curr, struct held_lock *next)
 		 * added:
 		 */
 		if (hlock->read != 2) {
-			if (!check_prev_add(curr, hlock, next, distance))
+			if (!check_prev_add(curr, hlock, next,
+						distance, trylock_loop))
 				return 0;
 			/*
 			 * Stop after the first non-trylock entry,
@@ -1766,6 +1778,7 @@ check_prevs_add(struct task_struct *curr, struct held_lock *next)
 		if (curr->held_locks[depth].irq_context !=
 				curr->held_locks[depth-1].irq_context)
 			break;
+		trylock_loop = 1;
 	}
 	return 1;
 out_bug:
