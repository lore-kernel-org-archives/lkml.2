Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755357Ab1DVMWD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Apr 2011 08:22:03 -0400
Received: from hera.kernel.org ([140.211.167.34]:57104 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753446Ab1DVMV7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Apr 2011 08:21:59 -0400
Date: Fri, 22 Apr 2011 12:21:43 GMT
From: tip-bot for Steven Rostedt <srostedt@redhat.com>
Message-ID: <tip-282b5c2f6f663c008444321fd8fcdd374596046b@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        torvalds@linux-foundation.org, a.p.zijlstra@chello.nl,
        fweisbec@gmail.com, akpm@linux-foundation.org, rostedt@goodmis.org,
        srostedt@redhat.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, torvalds@linux-foundation.org,
        fweisbec@gmail.com, akpm@linux-foundation.org, rostedt@goodmis.org,
        srostedt@redhat.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20110421014300.436140880@goodmis.org>
References: <20110421014300.436140880@goodmis.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/locking] lockdep: Print a nicer description for simple irq lock inversions
Git-Commit-ID: 282b5c2f6f663c008444321fd8fcdd374596046b
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 22 Apr 2011 12:21:43 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  282b5c2f6f663c008444321fd8fcdd374596046b
Gitweb:     http://git.kernel.org/tip/282b5c2f6f663c008444321fd8fcdd374596046b
Author:     Steven Rostedt <srostedt@redhat.com>
AuthorDate: Wed, 20 Apr 2011 21:41:59 -0400
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 22 Apr 2011 11:06:59 +0200

lockdep: Print a nicer description for simple irq lock inversions

Lockdep output can be pretty cryptic, having nicer output
can save a lot of head scratching. When a simple irq inversion
scenario is detected by lockdep (lock A taken in interrupt
context but also in thread context without disabling interrupts)
we now get the following (hopefully more informative) output:

other info that might help us debug this:
 Possible unsafe locking scenario:

       CPU0
       ----
  lock(lockA);
  <Interrupt>
    lock(lockA);

 *** DEADLOCK ***

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Link: http://lkml.kernel.org/r/20110421014300.436140880@goodmis.org
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/lockdep.c |   20 ++++++++++++++++++++
 1 files changed, 20 insertions(+), 0 deletions(-)

diff --git a/kernel/lockdep.c b/kernel/lockdep.c
index 270cfa4..27c609f 100644
--- a/kernel/lockdep.c
+++ b/kernel/lockdep.c
@@ -2158,6 +2158,24 @@ static void check_chain_key(struct task_struct *curr)
 #endif
 }
 
+static void
+print_usage_bug_scenario(struct held_lock *lock)
+{
+	struct lock_class *class = hlock_class(lock);
+
+	printk(" Possible unsafe locking scenario:\n\n");
+	printk("       CPU0\n");
+	printk("       ----\n");
+	printk("  lock(");
+	__print_lock_name(class);
+	printk(");\n");
+	printk("  <Interrupt>\n");
+	printk("    lock(");
+	__print_lock_name(class);
+	printk(");\n");
+	printk("\n *** DEADLOCK ***\n\n");
+}
+
 static int
 print_usage_bug(struct task_struct *curr, struct held_lock *this,
 		enum lock_usage_bit prev_bit, enum lock_usage_bit new_bit)
@@ -2186,6 +2204,8 @@ print_usage_bug(struct task_struct *curr, struct held_lock *this,
 
 	print_irqtrace_events(curr);
 	printk("\nother info that might help us debug this:\n");
+	print_usage_bug_scenario(this);
+
 	lockdep_print_held_locks(curr);
 
 	printk("\nstack backtrace:\n");
