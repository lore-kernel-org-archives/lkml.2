Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933063Ab1LFJjW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 04:39:22 -0500
Received: from terminus.zytor.com ([198.137.202.10]:34717 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932974Ab1LFJjU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 04:39:20 -0500
Date: Tue, 6 Dec 2011 01:38:56 -0800
From: tip-bot for Ben Hutchings <ben@decadent.org.uk>
Message-ID: <tip-fbdc4b9a6c29befbcca65e5366e5aaf2abb7a013@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu,
        ben@decadent.org.uk
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, ben@decadent.org.uk,
        mingo@elte.hu
In-Reply-To: <1319773015.6759.30.camel@deadeye>
References: <1319773015.6759.30.camel@deadeye>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/locking] lockdep, rtmutex, bug: Show taint flags on error
Git-Commit-ID: fbdc4b9a6c29befbcca65e5366e5aaf2abb7a013
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 06 Dec 2011 01:39:02 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  fbdc4b9a6c29befbcca65e5366e5aaf2abb7a013
Gitweb:     http://git.kernel.org/tip/fbdc4b9a6c29befbcca65e5366e5aaf2abb7a013
Author:     Ben Hutchings <ben@decadent.org.uk>
AuthorDate: Fri, 28 Oct 2011 04:36:55 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 6 Dec 2011 08:16:49 +0100

lockdep, rtmutex, bug: Show taint flags on error

Show the taint flags in all lockdep and rtmutex-debug error messages.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1319773015.6759.30.camel@deadeye
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/lockdep.c       |   23 +++++++++++++++--------
 kernel/rtmutex-debug.c |    1 +
 2 files changed, 16 insertions(+), 8 deletions(-)

diff --git a/kernel/lockdep.c b/kernel/lockdep.c
index 103bed8..a2ab30c 100644
--- a/kernel/lockdep.c
+++ b/kernel/lockdep.c
@@ -567,11 +567,12 @@ static void lockdep_print_held_locks(struct task_struct *curr)
 	}
 }
 
-static void print_kernel_version(void)
+static void print_kernel_ident(void)
 {
-	printk("%s %.*s\n", init_utsname()->release,
+	printk("%s %.*s %s\n", init_utsname()->release,
 		(int)strcspn(init_utsname()->version, " "),
-		init_utsname()->version);
+		init_utsname()->version,
+		print_tainted());
 }
 
 static int very_verbose(struct lock_class *class)
@@ -1149,7 +1150,7 @@ print_circular_bug_header(struct lock_list *entry, unsigned int depth,
 	printk("\n");
 	printk("======================================================\n");
 	printk("[ INFO: possible circular locking dependency detected ]\n");
-	print_kernel_version();
+	print_kernel_ident();
 	printk("-------------------------------------------------------\n");
 	printk("%s/%d is trying to acquire lock:\n",
 		curr->comm, task_pid_nr(curr));
@@ -1488,7 +1489,7 @@ print_bad_irq_dependency(struct task_struct *curr,
 	printk("======================================================\n");
 	printk("[ INFO: %s-safe -> %s-unsafe lock order detected ]\n",
 		irqclass, irqclass);
-	print_kernel_version();
+	print_kernel_ident();
 	printk("------------------------------------------------------\n");
 	printk("%s/%d [HC%u[%lu]:SC%u[%lu]:HE%u:SE%u] is trying to acquire:\n",
 		curr->comm, task_pid_nr(curr),
@@ -1717,7 +1718,7 @@ print_deadlock_bug(struct task_struct *curr, struct held_lock *prev,
 	printk("\n");
 	printk("=============================================\n");
 	printk("[ INFO: possible recursive locking detected ]\n");
-	print_kernel_version();
+	print_kernel_ident();
 	printk("---------------------------------------------\n");
 	printk("%s/%d is trying to acquire lock:\n",
 		curr->comm, task_pid_nr(curr));
@@ -2224,7 +2225,7 @@ print_usage_bug(struct task_struct *curr, struct held_lock *this,
 	printk("\n");
 	printk("=================================\n");
 	printk("[ INFO: inconsistent lock state ]\n");
-	print_kernel_version();
+	print_kernel_ident();
 	printk("---------------------------------\n");
 
 	printk("inconsistent {%s} -> {%s} usage.\n",
@@ -2289,7 +2290,7 @@ print_irq_inversion_bug(struct task_struct *curr,
 	printk("\n");
 	printk("=========================================================\n");
 	printk("[ INFO: possible irq lock inversion dependency detected ]\n");
-	print_kernel_version();
+	print_kernel_ident();
 	printk("---------------------------------------------------------\n");
 	printk("%s/%d just changed the state of lock:\n",
 		curr->comm, task_pid_nr(curr));
@@ -3170,6 +3171,7 @@ print_unlock_inbalance_bug(struct task_struct *curr, struct lockdep_map *lock,
 	printk("\n");
 	printk("=====================================\n");
 	printk("[ BUG: bad unlock balance detected! ]\n");
+	print_kernel_ident();
 	printk("-------------------------------------\n");
 	printk("%s/%d is trying to release lock (",
 		curr->comm, task_pid_nr(curr));
@@ -3614,6 +3616,7 @@ print_lock_contention_bug(struct task_struct *curr, struct lockdep_map *lock,
 	printk("\n");
 	printk("=================================\n");
 	printk("[ BUG: bad contention detected! ]\n");
+	print_kernel_ident();
 	printk("---------------------------------\n");
 	printk("%s/%d is trying to contend lock (",
 		curr->comm, task_pid_nr(curr));
@@ -3988,6 +3991,7 @@ print_freed_lock_bug(struct task_struct *curr, const void *mem_from,
 	printk("\n");
 	printk("=========================\n");
 	printk("[ BUG: held lock freed! ]\n");
+	print_kernel_ident();
 	printk("-------------------------\n");
 	printk("%s/%d is freeing memory %p-%p, with a lock still held there!\n",
 		curr->comm, task_pid_nr(curr), mem_from, mem_to-1);
@@ -4045,6 +4049,7 @@ static void print_held_locks_bug(struct task_struct *curr)
 	printk("\n");
 	printk("=====================================\n");
 	printk("[ BUG: lock held at task exit time! ]\n");
+	print_kernel_ident();
 	printk("-------------------------------------\n");
 	printk("%s/%d is exiting with locks still held!\n",
 		curr->comm, task_pid_nr(curr));
@@ -4142,6 +4147,7 @@ void lockdep_sys_exit(void)
 		printk("\n");
 		printk("================================================\n");
 		printk("[ BUG: lock held when returning to user space! ]\n");
+		print_kernel_ident();
 		printk("------------------------------------------------\n");
 		printk("%s/%d is leaving the kernel with locks still held!\n",
 				curr->comm, curr->pid);
@@ -4161,6 +4167,7 @@ void lockdep_rcu_suspicious(const char *file, const int line, const char *s)
 	printk("\n");
 	printk("===============================\n");
 	printk("[ INFO: suspicious RCU usage. ]\n");
+	print_kernel_ident();
 	printk("-------------------------------\n");
 	printk("%s:%d %s!\n", file, line, s);
 	printk("\nother info that might help us debug this:\n\n");
diff --git a/kernel/rtmutex-debug.c b/kernel/rtmutex-debug.c
index 8eafd1b..16502d3 100644
--- a/kernel/rtmutex-debug.c
+++ b/kernel/rtmutex-debug.c
@@ -101,6 +101,7 @@ void debug_rt_mutex_print_deadlock(struct rt_mutex_waiter *waiter)
 
 	printk("\n============================================\n");
 	printk(  "[ BUG: circular locking deadlock detected! ]\n");
+	printk("%s\n", print_tainted());
 	printk(  "--------------------------------------------\n");
 	printk("%s/%d is deadlocking current task %s/%d\n\n",
 	       task->comm, task_pid_nr(task),
