Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755198Ab1DVMVU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Apr 2011 08:21:20 -0400
Received: from hera.kernel.org ([140.211.167.34]:57058 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752993Ab1DVMVR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Apr 2011 08:21:17 -0400
Date: Fri, 22 Apr 2011 12:20:55 GMT
From: tip-bot for Steven Rostedt <srostedt@redhat.com>
Message-ID: <tip-dad3d7435e1d8c254d6877dc06852dc00c5da812@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        torvalds@linux-foundation.org, a.p.zijlstra@chello.nl,
        fweisbec@gmail.com, akpm@linux-foundation.org, rostedt@goodmis.org,
        srostedt@redhat.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, torvalds@linux-foundation.org,
        fweisbec@gmail.com, akpm@linux-foundation.org, rostedt@goodmis.org,
        srostedt@redhat.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20110421014259.910720381@goodmis.org>
References: <20110421014259.910720381@goodmis.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/locking] lockdep: Print a nicer description for irq inversion bugs
Git-Commit-ID: dad3d7435e1d8c254d6877dc06852dc00c5da812
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 22 Apr 2011 12:20:55 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  dad3d7435e1d8c254d6877dc06852dc00c5da812
Gitweb:     http://git.kernel.org/tip/dad3d7435e1d8c254d6877dc06852dc00c5da812
Author:     Steven Rostedt <srostedt@redhat.com>
AuthorDate: Wed, 20 Apr 2011 21:41:57 -0400
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 22 Apr 2011 11:06:58 +0200

lockdep: Print a nicer description for irq inversion bugs

Irq inversion and irq dependency bugs are only subtly
different. The diffenerence lies where the interrupt occurred.

For irq dependency:

	irq_disable
	lock(A)
	lock(B)
	unlock(B)
	unlock(A)
	irq_enable

	lock(B)
	unlock(B)

 	<interrupt>
	  lock(A)

The interrupt comes in after it has been established that lock A
can be held when taking an irq unsafe lock. Lockdep detects the
problem when taking lock A in interrupt context.

With the irq_inversion the irq happens before it is established
and lockdep detects the problem with the taking of lock B:

 	<interrupt>
	  lock(A)

	irq_disable
	lock(A)
	lock(B)
	unlock(B)
	unlock(A)
	irq_enable

	lock(B)
	unlock(B)

Since the problem with the locking logic for both of these issues
is in actuality the same, they both should report the same scenario.
This patch implements that and prints this:

other info that might help us debug this:

Chain exists of:
  &rq->lock --> lockA --> lockC

 Possible interrupt unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(lockC);
                               local_irq_disable();
                               lock(&rq->lock);
                               lock(lockA);
  <Interrupt>
    lock(&rq->lock);

 *** DEADLOCK ***

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Link: http://lkml.kernel.org/r/20110421014259.910720381@goodmis.org
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/lockdep.c |   34 +++++++++++++++++++++++++++++-----
 1 files changed, 29 insertions(+), 5 deletions(-)

diff --git a/kernel/lockdep.c b/kernel/lockdep.c
index c4cc5d1..0b497dd 100644
--- a/kernel/lockdep.c
+++ b/kernel/lockdep.c
@@ -1395,15 +1395,15 @@ print_shortest_lock_dependencies(struct lock_list *leaf,
 static void
 print_irq_lock_scenario(struct lock_list *safe_entry,
 			struct lock_list *unsafe_entry,
-			struct held_lock *prev,
-			struct held_lock *next)
+			struct lock_class *prev_class,
+			struct lock_class *next_class)
 {
 	struct lock_class *safe_class = safe_entry->class;
 	struct lock_class *unsafe_class = unsafe_entry->class;
-	struct lock_class *middle_class = hlock_class(prev);
+	struct lock_class *middle_class = prev_class;
 
 	if (middle_class == safe_class)
-		middle_class = hlock_class(next);
+		middle_class = next_class;
 
 	/*
 	 * A direct locking problem where unsafe_class lock is taken
@@ -1499,7 +1499,8 @@ print_bad_irq_dependency(struct task_struct *curr,
 	print_stack_trace(forwards_entry->class->usage_traces + bit2, 1);
 
 	printk("\nother info that might help us debug this:\n\n");
-	print_irq_lock_scenario(backwards_entry, forwards_entry, prev, next);
+	print_irq_lock_scenario(backwards_entry, forwards_entry,
+				hlock_class(prev), hlock_class(next));
 
 	lockdep_print_held_locks(curr);
 
@@ -2219,6 +2220,10 @@ print_irq_inversion_bug(struct task_struct *curr,
 			struct held_lock *this, int forwards,
 			const char *irqclass)
 {
+	struct lock_list *entry = other;
+	struct lock_list *middle = NULL;
+	int depth;
+
 	if (!debug_locks_off_graph_unlock() || debug_locks_silent)
 		return 0;
 
@@ -2237,6 +2242,25 @@ print_irq_inversion_bug(struct task_struct *curr,
 	printk("\n\nand interrupts could create inverse lock ordering between them.\n\n");
 
 	printk("\nother info that might help us debug this:\n");
+
+	/* Find a middle lock (if one exists) */
+	depth = get_lock_depth(other);
+	do {
+		if (depth == 0 && (entry != root)) {
+			printk("lockdep:%s bad path found in chain graph\n", __func__);
+			break;
+		}
+		middle = entry;
+		entry = get_lock_parent(entry);
+		depth--;
+	} while (entry && entry != root && (depth >= 0));
+	if (forwards)
+		print_irq_lock_scenario(root, other,
+			middle ? middle->class : root->class, other->class);
+	else
+		print_irq_lock_scenario(other, root,
+			middle ? middle->class : other->class, root->class);
+
 	lockdep_print_held_locks(curr);
 
 	printk("\nthe shortest dependencies between 2nd lock and 1st lock:\n");
