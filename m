Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754404Ab1DUBny (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 21:43:54 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:63641 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752533Ab1DUBnE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 21:43:04 -0400
X-Authority-Analysis: v=1.1 cv=ZtuXOl23UuD1yoJUTgnZ6i6Z5VPlPhPMWCeUNtN8OGA= c=1 sm=0 a=vhdKIqpQuCYA:10 a=iKYZGZOP-K4A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=JneOFEaHyrGEK7axOc0A:9 a=ZOvx8THDl3A8O_X6SWIA:7 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20110421014259.380621789@goodmis.org>
User-Agent: quilt/0.48-1
Date: Wed, 20 Apr 2011 21:41:55 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 2/7] lockdep: Print a nice description of normal deadlocks
References: <20110421014153.126662477@goodmis.org>
Content-Disposition: inline; filename=0002-lockdep-Print-a-nice-description-of-normal-deadlocks.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

The lockdep output can be pretty cryptic, having a nice output
can save a lot of head scratching. When a normal deadlock scenario
is detected by lockdep (lock A -> lock B and there exists a place
where lock B -> lock A) we get the following output:

other info that might help us debug this:

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(lockB);
                               lock(lockA);
                               lock(lockB);
  lock(lockA);

 *** DEADLOCK ***

On cases where there's a deeper chair, it shows the partial chain
that can cause the issue:

Chain exists of:
  lockC --> lockA --> lockB

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(lockB);
                               lock(lockA);
                               lock(lockB);
  lock(lockC);

 *** DEADLOCK ***

Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/lockdep.c |   55 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 55 insertions(+), 0 deletions(-)

diff --git a/kernel/lockdep.c b/kernel/lockdep.c
index bb77c030..1039008 100644
--- a/kernel/lockdep.c
+++ b/kernel/lockdep.c
@@ -1065,6 +1065,56 @@ print_circular_bug_entry(struct lock_list *target, int depth)
 	return 0;
 }
 
+static void
+print_circular_lock_scenario(struct held_lock *src,
+			     struct held_lock *tgt,
+			     struct lock_list *prt)
+{
+	struct lock_class *source = hlock_class(src);
+	struct lock_class *target = hlock_class(tgt);
+	struct lock_class *parent = prt->class;
+
+	/*
+	 * A direct locking problem where unsafe_class lock is taken
+	 * directly by safe_class lock, then all we need to show
+	 * is the deadlock scenario, as it is obvious that the
+	 * unsafe lock is taken under the safe lock.
+	 *
+	 * But if there is a chain instead, where the safe lock takes
+	 * an intermediate lock (middle_class) where this lock is
+	 * not the same as the safe lock, then the lock chain is
+	 * used to describe the problem. Otherwise we would need
+	 * to show a different CPU case for each link in the chain
+	 * from the safe_class lock to the unsafe_class lock.
+	 */
+	if (parent != source) {
+		printk("Chain exists of:\n  ");
+		__print_lock_name(source);
+		printk(" --> ");
+		__print_lock_name(parent);
+		printk(" --> ");
+		__print_lock_name(target);
+		printk("\n\n");
+	}
+
+	printk(" Possible unsafe locking scenario:\n\n");
+	printk("       CPU0                    CPU1\n");
+	printk("       ----                    ----\n");
+	printk("  lock(");
+	__print_lock_name(target);
+	printk(");\n");
+	printk("                               lock(");
+	__print_lock_name(parent);
+	printk(");\n");
+	printk("                               lock(");
+	__print_lock_name(target);
+	printk(");\n");
+	printk("  lock(");
+	__print_lock_name(source);
+	printk(");\n");
+	printk("\n *** DEADLOCK ***\n\n");
+}
+
 /*
  * When a circular dependency is detected, print the
  * header first:
@@ -1108,6 +1158,7 @@ static noinline int print_circular_bug(struct lock_list *this,
 {
 	struct task_struct *curr = current;
 	struct lock_list *parent;
+	struct lock_list *first_parent;
 	int depth;
 
 	if (!debug_locks_off_graph_unlock() || debug_locks_silent)
@@ -1121,6 +1172,7 @@ static noinline int print_circular_bug(struct lock_list *this,
 	print_circular_bug_header(target, depth, check_src, check_tgt);
 
 	parent = get_lock_parent(target);
+	first_parent = parent;
 
 	while (parent) {
 		print_circular_bug_entry(parent, --depth);
@@ -1128,6 +1180,9 @@ static noinline int print_circular_bug(struct lock_list *this,
 	}
 
 	printk("\nother info that might help us debug this:\n\n");
+	print_circular_lock_scenario(check_src, check_tgt,
+				     first_parent);
+
 	lockdep_print_held_locks(curr);
 
 	printk("\nstack backtrace:\n");
-- 
1.7.2.3


