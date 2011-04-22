Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754091Ab1DVMUO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Apr 2011 08:20:14 -0400
Received: from hera.kernel.org ([140.211.167.34]:57001 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752993Ab1DVMUJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Apr 2011 08:20:09 -0400
Date: Fri, 22 Apr 2011 12:19:37 GMT
From: tip-bot for Steven Rostedt <srostedt@redhat.com>
Message-ID: <tip-3003eba313dd0e0502dd71548c36fe7c19801ce5@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        torvalds@linux-foundation.org, a.p.zijlstra@chello.nl,
        fweisbec@gmail.com, akpm@linux-foundation.org, rostedt@goodmis.org,
        srostedt@redhat.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, torvalds@linux-foundation.org,
        fweisbec@gmail.com, akpm@linux-foundation.org, rostedt@goodmis.org,
        srostedt@redhat.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20110421014259.132728798@goodmis.org>
References: <20110421014259.132728798@goodmis.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/locking] lockdep: Print a nicer description for irq lock inversions
Git-Commit-ID: 3003eba313dd0e0502dd71548c36fe7c19801ce5
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 22 Apr 2011 12:19:38 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3003eba313dd0e0502dd71548c36fe7c19801ce5
Gitweb:     http://git.kernel.org/tip/3003eba313dd0e0502dd71548c36fe7c19801ce5
Author:     Steven Rostedt <srostedt@redhat.com>
AuthorDate: Wed, 20 Apr 2011 21:41:54 -0400
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 22 Apr 2011 11:06:57 +0200

lockdep: Print a nicer description for irq lock inversions

Locking order inversion due to interrupts is a subtle problem.

When an irq lockiinversion discovered by lockdep it currently
reports something like:

[ INFO: HARDIRQ-safe -> HARDIRQ-unsafe lock order detected ]

... and then prints out the locks that are involved, as back traces.

Judging by lkml feedback developers were routinely confused by what
a HARDIRQ->safe to unsafe issue is all about, and sometimes even
blew it off as a bug in lockdep.

It is not obvious when lockdep prints this message about a lock that
is never taken in interrupt context.

After explaining the problems that lockdep is reporting, I
decided to add a description of the problem in visual form. Now
the following is shown:

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
    lock(&rq->lock);

 *** DEADLOCK ***

 ---

The above is the case when the unsafe lock is taken while
holding a lock taken in irq context. But when a lock is taken
that also grabs a unsafe lock, the call chain is shown:

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
    lock(&rq->lock);

 *** DEADLOCK ***

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Link: http://lkml.kernel.org/r/20110421014259.132728798@goodmis.org
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/lockdep.c |   70 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 70 insertions(+), 0 deletions(-)

diff --git a/kernel/lockdep.c b/kernel/lockdep.c
index 53a6895..7b2ffee 100644
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
+	if (!name)
+		name = __get_key_name(class->key, str);
+
+	return printk("%s", name);
+}
+
 static void print_lock_name(struct lock_class *class)
 {
 	char str[KSYM_NAME_LEN], usage[LOCK_USAGE_CHARS];
@@ -1325,6 +1337,62 @@ print_shortest_lock_dependencies(struct lock_list *leaf,
 	return;
 }
 
+static void
+print_irq_lock_scenario(struct lock_list *safe_entry,
+			struct lock_list *unsafe_entry,
+			struct held_lock *prev,
+			struct held_lock *next)
+{
+	struct lock_class *safe_class = safe_entry->class;
+	struct lock_class *unsafe_class = unsafe_entry->class;
+	struct lock_class *middle_class = hlock_class(prev);
+
+	if (middle_class == safe_class)
+		middle_class = hlock_class(next);
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
+	printk(");\n");
+	printk("\n *** DEADLOCK ***\n\n");
+}
+
 static int
 print_bad_irq_dependency(struct task_struct *curr,
 			 struct lock_list *prev_root,
@@ -1376,6 +1444,8 @@ print_bad_irq_dependency(struct task_struct *curr,
 	print_stack_trace(forwards_entry->class->usage_traces + bit2, 1);
 
 	printk("\nother info that might help us debug this:\n\n");
+	print_irq_lock_scenario(backwards_entry, forwards_entry, prev, next);
+
 	lockdep_print_held_locks(curr);
 
 	printk("\nthe dependencies between %s-irq-safe lock", irqclass);
