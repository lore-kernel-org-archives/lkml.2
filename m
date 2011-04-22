Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755175Ab1DVMU0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Apr 2011 08:20:26 -0400
Received: from hera.kernel.org ([140.211.167.34]:57023 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753446Ab1DVMUV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Apr 2011 08:20:21 -0400
Date: Fri, 22 Apr 2011 12:20:00 GMT
From: tip-bot for Steven Rostedt <srostedt@redhat.com>
Message-ID: <tip-f4185812aa046ecb97e8817e10148cacdd7a6baa@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        torvalds@linux-foundation.org, a.p.zijlstra@chello.nl,
        fweisbec@gmail.com, akpm@linux-foundation.org, rostedt@goodmis.org,
        srostedt@redhat.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, torvalds@linux-foundation.org,
        fweisbec@gmail.com, akpm@linux-foundation.org, rostedt@goodmis.org,
        srostedt@redhat.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20110421014259.380621789@goodmis.org>
References: <20110421014259.380621789@goodmis.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/locking] lockdep: Print a nicer description for normal deadlocks
Git-Commit-ID: f4185812aa046ecb97e8817e10148cacdd7a6baa
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 22 Apr 2011 12:20:01 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f4185812aa046ecb97e8817e10148cacdd7a6baa
Gitweb:     http://git.kernel.org/tip/f4185812aa046ecb97e8817e10148cacdd7a6baa
Author:     Steven Rostedt <srostedt@redhat.com>
AuthorDate: Wed, 20 Apr 2011 21:41:55 -0400
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 22 Apr 2011 11:06:57 +0200

lockdep: Print a nicer description for normal deadlocks

The lockdep output can be pretty cryptic, having nicer output
can save a lot of head scratching. When a normal deadlock
scenario is detected by lockdep (lock A -> lock B and there
exists a place where lock B -> lock A) we now get the following
new output:

other info that might help us debug this:

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(lockB);
                               lock(lockA);
                               lock(lockB);
  lock(lockA);

 *** DEADLOCK ***

On cases where there's a deeper chair, it shows the partial
chain that can cause the issue:

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

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Link: http://lkml.kernel.org/r/20110421014259.380621789@goodmis.org
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/lockdep.c |   55 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 55 insertions(+), 0 deletions(-)

diff --git a/kernel/lockdep.c b/kernel/lockdep.c
index 7b2ffee..73cebd7 100644
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
