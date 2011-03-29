Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753279Ab1C2ROK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 13:14:10 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:38133 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751635Ab1C2ROJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 13:14:09 -0400
X-Authority-Analysis: v=1.1 cv=ZtuXOl23UuD1yoJUTgnZ6i6Z5VPlPhPMWCeUNtN8OGA= c=1 sm=0 a=5sUF0BzJmhYA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=3e0vvKDXR4-HhYoyZOsA:9 a=EH2UUSZobN5mJm-4Qy0A:7 a=uCAxkAtdzaBzov6I4obqdFy1m98A:4 a=PUjeQqilurYA:10 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: [RFC][PATCH] lockdep: Print a nice description of an irq locking
 issue
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Tue, 29 Mar 2011 13:14:05 -0400
Message-ID: <1301418845.14261.284.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After having to explain lockdep interrupt locking inversions a few
times, I decided to have lockdep spit out the scenario that it is
complaining about.

-- Steve


The following patch is in:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git

    branch: tip/lockdep/devel


Steven Rostedt (1):
      lockdep: Print a nice description of an irq locking issue

----
 kernel/lockdep.c |   66 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 66 insertions(+), 0 deletions(-)
---------------------------
commit 3429984fca737d0028c57d8d5c6a6b94ac3e90de
Author: Steven Rostedt <srostedt@redhat.com>
Date:   Tue Mar 29 12:55:14 2011 -0400

    lockdep: Print a nice description of an irq locking issue
    
    Locking order inversion due to interrupts is a subtle problem.
    When a locking inversion due to interrupts is discovered by lockdep,
    it currently reports something like this:
    
    [ INFO: HARDIRQ-safe -> HARDIRQ-unsafe lock order detected ]
    
    And then writes the locks that are involved as well as back traces.
    But several developers are confused by what a HARDIRQ->safe to unsafe
    issue is all about, and sometimes even blow it off as a bug in lockdep.
    As it is not obvious when lockdep describes this about a lock that
    is never taken in interrupt context.
    
    After explaining the problems that lockdep is reporting, I decided
    to add a description of the problem in visual form. Now the following
    is shown:
    
     ---
    other info that might help us debug this:
    
     Possible interrupt unsafe locking scenario:
    
           CPU0                    CPU1
           ----                    ----
      lock(lockA);
                                   local_irq_disable();
                                   lock(&rq->lock);
                                   lock(lockA);
      <Interrupt>
        lock(&rq->lock)
    
     *** DEADLOCK ***
    
     ---
    
    The above is the case when the unsafe lock is taken while holding
    a lock taken in irq context. But when a lock is taken that also
    grabs a unsafe lock, the call chain is shown:
    
     ---
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
        lock(&rq->lock)
    
     *** DEADLOCK ***
    
     ---
    
    Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

diff --git a/kernel/lockdep.c b/kernel/lockdep.c
index 0d2058d..cc5fb5b 100644
--- a/kernel/lockdep.c
+++ b/kernel/lockdep.c
@@ -490,6 +490,18 @@ void get_usage_chars(struct lock_class *class, char usage[LOCK_USAGE_CHARS])
 	usage[i] = '\0';
 }
 
+static int __print_lock_name(struct lock_class *class)
+{
+	char str[KSYM_NAME_LEN];
+	const char *name;
+
+	name = class->name;
+	if (!name) {
+		name = __get_key_name(class->key, str);
+	}
+	return printk("%s", name);
+}
+
 static void print_lock_name(struct lock_class *class)
 {
 	char str[KSYM_NAME_LEN], usage[LOCK_USAGE_CHARS];
@@ -1325,6 +1337,58 @@ print_shortest_lock_dependencies(struct lock_list *leaf,
 	return;
 }
 
+static void
+print_irq_lock_scenario(struct lock_list *backwards_entry,
+			struct lock_list *forwards_entry,
+			struct held_lock *next)
+{
+	struct lock_class *safe_class = backwards_entry->class;
+	struct lock_class *unsafe_class = forwards_entry->class;
+	struct lock_class *middle_class = hlock_class(next);
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
+	if (middle_class != unsafe_class) {
+		printk("Chain exists of:\n  ");
+		__print_lock_name(safe_class);
+		printk(" --> ");
+		__print_lock_name(middle_class);
+		printk(" --> ");
+		__print_lock_name(unsafe_class);
+		printk("\n\n");
+	}
+
+	printk(" Possible interrupt unsafe locking scenario:\n\n");
+	printk("       CPU0                    CPU1\n");
+	printk("       ----                    ----\n");
+	printk("  lock(");
+	__print_lock_name(unsafe_class);
+	printk(");\n");
+	printk("                               local_irq_disable();\n");
+	printk("                               lock(");
+	__print_lock_name(safe_class);
+	printk(");\n");
+	printk("                               lock(");
+	__print_lock_name(middle_class);
+	printk(");\n");
+	printk("  <Interrupt>\n");
+	printk("    lock(");
+	__print_lock_name(safe_class);
+	printk(")\n");
+	printk("\n *** DEADLOCK ***\n\n");
+}
+
 static int
 print_bad_irq_dependency(struct task_struct *curr,
 			 struct lock_list *prev_root,
@@ -1376,6 +1440,8 @@ print_bad_irq_dependency(struct task_struct *curr,
 	print_stack_trace(forwards_entry->class->usage_traces + bit2, 1);
 
 	printk("\nother info that might help us debug this:\n\n");
+	print_irq_lock_scenario(backwards_entry, forwards_entry, next);
+
 	lockdep_print_held_locks(curr);
 
 	printk("\nthe dependencies between %s-irq-safe lock", irqclass);


