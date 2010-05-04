Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755524Ab0EDG6E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 02:58:04 -0400
Received: from mail.windriver.com ([147.11.1.11]:54123 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753223Ab0EDG57 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 02:57:59 -0400
Date: Tue, 4 May 2010 14:57:11 +0800
From: Yong Zhang <yong.zhang@windriver.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: John Kacur <jkacur@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       linux-rt-users <linux-rt-users@vger.kernel.org>,
       Sven-Thorsten Dietrich <thebigcorporation@gmail.com>,
       Clark Williams <williams@redhat.com>,
       "Luis Claudio R. Goncalves" <lgoncalv@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Gregory Haskins <ghaskins@novell.com>,
       "David S. Miller" <davem@davemloft.net>,
       Yong Zhang <yong.zhang0@gmail.com>
Subject: [PATCH V2] lockdep: reduce stack_trace usage
Message-ID: <20100504065711.GC10784@windriver.com>
Reply-To: Yong Zhang <yong.zhang@windriver.com>
References: <alpine.LFD.2.00.1004222208310.3155@localhost>
 <20100423025850.GA21328@windriver.com>
 <alpine.LFD.2.00.1004230907050.4151@localhost>
 <1272009915.1646.25.camel@laptop>
 <w2v520f0cf11004230131i743c596emfd0e5b8870330a8b@mail.gmail.com>
 <20100423134044.GA2777@zhy-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20100423134044.GA2777@zhy-desktop>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 04 May 2010 06:57:13.0632 (UTC) FILETIME=[06725A00:01CAEB57]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 04395389820e89c0bd4bb57b939ec1882e0bb5da Mon Sep 17 00:00:00 2001
From: Yong Zhang <yong.zhang@windriver.com>
Date: Tue, 4 May 2010 14:16:48 +0800
Subject: [PATCH] lockdep: Reduce stack_trace usage

When calling check_prevs_add(), if all validations passed
add_lock_to_list() will add new lock to dependency tree and
alloc stack_trace for each list_entry. But at this time,
we are always on the same stack, so stack_trace for each
list_entry has the same value. This is redundant and eats up
lots of memory which could lead to warning on low
MAX_STACK_TRACE_ENTRIES.
Using one copy of stack_trace instead.

V2: As suggested by Peter Zijlstra, move save_trace() from
    check_prevs_add() to check_prev_add().
    Add tracking for trylock dependence which is also redundant.

Signed-off-by: Yong Zhang <yong.zhang0@windriver.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: David S. Miller <davem@davemloft.net>
---
 kernel/lockdep.c |   22 ++++++++++++++--------
 1 files changed, 14 insertions(+), 8 deletions(-)

diff --git a/kernel/lockdep.c b/kernel/lockdep.c
index 2594e1c..56e0ff9 100644
--- a/kernel/lockdep.c
+++ b/kernel/lockdep.c
@@ -818,7 +818,8 @@ static struct lock_list *alloc_list_entry(void)
  * Add a new dependency to the head of the list:
  */
 static int add_lock_to_list(struct lock_class *class, struct lock_class *this,
-			    struct list_head *head, unsigned long ip, int distance)
+			    struct list_head *head, unsigned long ip,
+			    int distance, struct stack_trace *trace)
 {
 	struct lock_list *entry;
 	/*
@@ -829,11 +830,9 @@ static int add_lock_to_list(struct lock_class *class, struct lock_class *this,
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
@@ -1635,12 +1634,13 @@ check_deadlock(struct task_struct *curr, struct held_lock *next,
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
+	static struct stack_trace trace;
 
 	/*
 	 * Prove that the new <prev> -> <next> dependency would not
@@ -1688,20 +1688,23 @@ check_prev_add(struct task_struct *curr, struct held_lock *prev,
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
 
@@ -1731,6 +1734,7 @@ static int
 check_prevs_add(struct task_struct *curr, struct held_lock *next)
 {
 	int depth = curr->lockdep_depth;
+	int trylock_loop = 0;
 	struct held_lock *hlock;
 
 	/*
@@ -1756,7 +1760,8 @@ check_prevs_add(struct task_struct *curr, struct held_lock *next)
 		 * added:
 		 */
 		if (hlock->read != 2) {
-			if (!check_prev_add(curr, hlock, next, distance))
+			if (!check_prev_add(curr, hlock, next,
+						distance, trylock_loop))
 				return 0;
 			/*
 			 * Stop after the first non-trylock entry,
@@ -1779,6 +1784,7 @@ check_prevs_add(struct task_struct *curr, struct held_lock *next)
 		if (curr->held_locks[depth].irq_context !=
 				curr->held_locks[depth-1].irq_context)
 			break;
+		trylock_loop = 1;
 	}
 	return 1;
 out_bug:
-- 
1.6.3.3

