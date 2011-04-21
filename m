Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754349Ab1DUBnl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 21:43:41 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:63641 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751693Ab1DUBnF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 21:43:05 -0400
X-Authority-Analysis: v=1.1 cv=ZtuXOl23UuD1yoJUTgnZ6i6Z5VPlPhPMWCeUNtN8OGA= c=1 sm=0 a=vhdKIqpQuCYA:10 a=7h1XnPi07icA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=z-su29U54D96FsaWaSsA:9 a=PlaQrxj1HY8jdft90PEA:7 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20110421014259.910720381@goodmis.org>
User-Agent: quilt/0.48-1
Date: Wed, 20 Apr 2011 21:41:57 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 4/7] lockdep: Printk nice description for irq inversion bug
References: <20110421014153.126662477@goodmis.org>
Content-Disposition: inline; filename=0004-lockdep-Printk-nice-description-for-irq-inversion-bu.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

The irq inversion and irq dependency bug are only subtly different.
The diffenerence lies where the interrupt occurred.

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
can be held when taking an irq unsafe lock. Lockdep detects the problem
when taking lock A in interrupt context.

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

With the irq_inversion the irq happens before it is established
and lockdep detects the problem with the taking of lock B.

Since the problem with the locking for both of these issues are
in actuality the same, they both should report the same scenario.

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

Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/lockdep.c |   34 +++++++++++++++++++++++++++++-----
 1 files changed, 29 insertions(+), 5 deletions(-)

diff --git a/kernel/lockdep.c b/kernel/lockdep.c
index a0f253b..8646b8c 100644
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
-- 
1.7.2.3


