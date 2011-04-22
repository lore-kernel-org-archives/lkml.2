Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753923Ab1DVMUx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Apr 2011 08:20:53 -0400
Received: from hera.kernel.org ([140.211.167.34]:57038 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753446Ab1DVMUv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Apr 2011 08:20:51 -0400
Date: Fri, 22 Apr 2011 12:20:29 GMT
From: tip-bot for Steven Rostedt <srostedt@redhat.com>
Message-ID: <tip-48702ecf308e53f176c1f6fdc193d622ded54ac0@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        torvalds@linux-foundation.org, a.p.zijlstra@chello.nl,
        fweisbec@gmail.com, akpm@linux-foundation.org, rostedt@goodmis.org,
        srostedt@redhat.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, torvalds@linux-foundation.org,
        fweisbec@gmail.com, akpm@linux-foundation.org, rostedt@goodmis.org,
        srostedt@redhat.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20110421014259.643930104@goodmis.org>
References: <20110421014259.643930104@goodmis.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/locking] lockdep: Print a nicer description for simple deadlocks
Git-Commit-ID: 48702ecf308e53f176c1f6fdc193d622ded54ac0
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 22 Apr 2011 12:20:29 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  48702ecf308e53f176c1f6fdc193d622ded54ac0
Gitweb:     http://git.kernel.org/tip/48702ecf308e53f176c1f6fdc193d622ded54ac0
Author:     Steven Rostedt <srostedt@redhat.com>
AuthorDate: Wed, 20 Apr 2011 21:41:56 -0400
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 22 Apr 2011 11:06:58 +0200

lockdep: Print a nicer description for simple deadlocks

Lockdep output can be pretty cryptic, having nicer output
can save a lot of head scratching. When a simple deadlock
scenario is detected by lockdep (lock A -> lock A) we now
get the following new output:

other info that might help us debug this:
 Possible unsafe locking scenario:

       CPU0
       ----
  lock(&(lock)->rlock);
  lock(&(lock)->rlock);

 *** DEADLOCK ***

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Link: http://lkml.kernel.org/r/20110421014259.643930104@goodmis.org
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/lockdep.c |   21 +++++++++++++++++++++
 1 files changed, 21 insertions(+), 0 deletions(-)

diff --git a/kernel/lockdep.c b/kernel/lockdep.c
index 73cebd7..c4cc5d1 100644
--- a/kernel/lockdep.c
+++ b/kernel/lockdep.c
@@ -1664,6 +1664,26 @@ static inline void inc_chains(void)
 
 #endif
 
+static void
+print_deadlock_scenario(struct held_lock *nxt,
+			     struct held_lock *prv)
+{
+	struct lock_class *next = hlock_class(nxt);
+	struct lock_class *prev = hlock_class(prv);
+
+	printk(" Possible unsafe locking scenario:\n\n");
+	printk("       CPU0\n");
+	printk("       ----\n");
+	printk("  lock(");
+	__print_lock_name(prev);
+	printk(");\n");
+	printk("  lock(");
+	__print_lock_name(next);
+	printk(");\n");
+	printk("\n *** DEADLOCK ***\n\n");
+	printk(" May be due to missing lock nesting notation\n\n");
+}
+
 static int
 print_deadlock_bug(struct task_struct *curr, struct held_lock *prev,
 		   struct held_lock *next)
@@ -1682,6 +1702,7 @@ print_deadlock_bug(struct task_struct *curr, struct held_lock *prev,
 	print_lock(prev);
 
 	printk("\nother info that might help us debug this:\n");
+	print_deadlock_scenario(next, prev);
 	lockdep_print_held_locks(curr);
 
 	printk("\nstack backtrace:\n");
