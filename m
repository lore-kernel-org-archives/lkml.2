Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752992Ab1HSBcG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 21:32:06 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:54626 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751136Ab1HSBcE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 21:32:04 -0400
Subject: Re: +
 prctl-add-pr_setget_child_reaper-to-allow-simple-process-supervision .patch
 added to -mm tree
From: Kay Sievers <kay.sievers@vrfy.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Lennart Poettering <mzxreary@0pointer.de>, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-man@vger.kernel.org,
        roland@hack.frob.com, torvalds@linux-foundation.org
Date: Fri, 19 Aug 2011 03:31:59 +0200
In-Reply-To: <20110818184857.GA12094@redhat.com>
References: <201108162011.p7GKBcY0023134@imap1.linux-foundation.org>
	 <20110817115543.GA8745@redhat.com>
	 <CAPXgP12rYf2HmmsJAuJw=nrtcjTRR1WzDhLNM47eKhKA1UTfJQ@mail.gmail.com>
	 <20110817134516.GA14136@redhat.com>
	 <20110818124353.GA2839@tango.0pointer.de>
	 <20110818142508.GA30959@redhat.com> <1313691091.1107.9.camel@mop>
	 <20110818184857.GA12094@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.1.4 (3.1.4-1.fc16) 
Content-Transfer-Encoding: 7bit
Message-ID: <1313717521.991.4.camel@mop>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-08-18 at 20:48 +0200, Oleg Nesterov wrote:
> On 08/18, Kay Sievers wrote:

> No, this doesn't look right.
> 
> This code should do something like
> 
> 		for (reaper = father->real_parent;
> 		     !same_thread_group(reaper, pid_ns->child_reaper);

Without that check, bootup immediately hangs. The problem is, I expect,
that we need to exit the loop for re-parenting kernel threads, and
pid_ns->child_reaper seems out of scope in these cases. That's why we
initially had the &init_task check there.

> 			if (there is a !PF_EXITING thread)
> 				return thread;

Added this.

> And I forgot to mention, could you please-please rename child_reaper?
> Say, is_child_reaper or is_sub_reaper. Or whatever. I do not really
> care about the naming. But I use grep very often, and personally I
> dislike the task->child_reaper/signal->child_reaper confusion.

Right, makes sense. Renamed everything to subreaper, which makes it
clear that we still fall back to 'init' in case things go wrong.


version 3:
- rename all child_reaper to child_subreaper to avoid confusion with
  the PID namespace child_reaper variable

- check all possible threads of the reaper process for valid one 

- optimization: let processes inherit a flag to indicate that there is
  a subreaper to lookup, in case they need to be re-parented.

version 2:
- uses task->real_parent to walk up the chain of parents.

- does not use init_task but the the parent pointer to itself

- moves the flag into task->signal to have it process-wide
  and not per thread

- moves the parent walk after the check for
  pid_ns->child_reaper == father

- makes sure it does not return a PF_EXITING task

- adds some explanation of SIGCHLD + wait() vs. async events
  like taskstats, to the changelog

- updates the comments for find_new_reaper()



From: Lennart Poettering <lennart@poettering.net>
Subject: prctl: add PR_{SET,GET}_CHILD_SUBREAPER to allow simple process supervision

Userspace service managers/supervisors need to track their started
services. Many services daemonize by double-forking and get implicitely
re-parented to PID 1. The process manager will no longer be able to
receive the SIGCHLD signals for them, and is no longer in charge of
reaping the children with wait(). All information about the children
is lost at the moment PID 1 cleans up the re-parented processes.

With this prctl, a service manager process can mark itself as a sort of
'sub-init', able to stay as the parent for all orphaned processes
created by the started services. All SIGCHLD signals will be delivered
to the service manager.

Receiving SIGCHLD and doing wait() is in cases of a service-manager
much preferred over any possible asynchronous notification about
specific PIDs, because the service manager has full access to the
child process data in /proc and the PID can not be re-used until
the wait(), the service-manager itself is in charge of, has happended.

As a side effect, the relevant parent PID information does not get lost
by a double-fork, which results in a more elaborate process tree and 'ps'
output.

This is orthogonal to PID namespaces. PID namespaces are isolated
from each other, while a service management process usually requires
the serices to live in the same namespace, to be able to talk to each
other.

Users of this will be the systemd per-user instance, which provides
init-like functionality for the user's login session and D-Bus, which
activates bus services on on-demand. Both will need init-like capabilities
to be able to properly keep track of the services they start.

Cc: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Lennart Poettering <lennart@poettering.net>
Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
---

 include/linux/prctl.h |    3 +++
 include/linux/sched.h |   12 ++++++++++++
 kernel/exit.c         |   28 +++++++++++++++++++++++-----
 kernel/fork.c         |    3 +++
 kernel/sys.c          |    9 +++++++++
 5 files changed, 50 insertions(+), 5 deletions(-)

--- a/include/linux/prctl.h
+++ b/include/linux/prctl.h
@@ -102,4 +102,7 @@
 
 #define PR_MCE_KILL_GET 34
 
+#define PR_SET_CHILD_SUBREAPER 35
+#define PR_GET_CHILD_SUBREAPER 36
+
 #endif /* _LINUX_PRCTL_H */
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -550,6 +550,18 @@ struct signal_struct {
 	int			group_stop_count;
 	unsigned int		flags; /* see SIGNAL_* flags below */
 
+	/*
+	 * PR_SET_CHILD_SUBREAPER marks a process, like a service
+	 * manager, to re-parent orphan (double-forking) child processes
+	 * to this process instead of 'init'. The service manager is
+	 * able to receive SIGCHLD signals and is able to investigate
+	 * the process until it calls wait(). All children of this
+	 * process will inherit a flag if they should look for a
+	 * child_subreaper process at exit.
+	 */
+	unsigned int		is_child_subreaper:1;
+	unsigned int		has_child_subreaper:1;
+
 	/* POSIX.1b Interval Timers */
 	struct list_head posix_timers;
 
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -689,11 +689,12 @@ static void exit_mm(struct task_struct *
 }
 
 /*
- * When we die, we re-parent all our children.
- * Try to give them to another thread in our thread
- * group, and if no such member exists, give it to
- * the child reaper process (ie "init") in our pid
- * space.
+ * When we die, we re-parent all our children, and try to:
+ * 1. give them to another thread in our thread group, if such a
+ *    member exists
+ * 2. give it to the first anchestor process which prctl'd itself
+ *    as a child_subreaper for its children (like a service manager)
+ * 3. give it to the init process (PID 1) in our pid namespace
  */
 static struct task_struct *find_new_reaper(struct task_struct *father)
 	__releases(&tasklist_lock)
@@ -724,6 +725,23 @@ static struct task_struct *find_new_reap
 		 * forget_original_parent() must move them somewhere.
 		 */
 		pid_ns->child_reaper = init_pid_ns.child_reaper;
+	} else if (father->signal->has_child_subreaper) {
+		struct task_struct *reaper;
+
+		/* find the first ancestor marked as child_subreaper */
+		for (reaper = father->real_parent;
+		     reaper != reaper->real_parent;
+		     reaper = reaper->real_parent) {
+			if (same_thread_group(reaper, pid_ns->child_reaper))
+				break;
+			if (!reaper->signal->is_child_subreaper)
+				continue;
+			thread = reaper;
+			do {
+				if (!(thread->flags & PF_EXITING))
+					return reaper;
+			} while_each_thread(reaper, thread);
+		}
 	}
 
 	return pid_ns->child_reaper;
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -987,6 +987,9 @@ static int copy_signal(unsigned long clo
 	sig->oom_score_adj = current->signal->oom_score_adj;
 	sig->oom_score_adj_min = current->signal->oom_score_adj_min;
 
+	if (current->signal->has_child_subreaper)
+		sig->has_child_subreaper = true;
+
 	mutex_init(&sig->cred_guard_mutex);
 
 	return 0;
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -1799,6 +1799,15 @@ SYSCALL_DEFINE5(prctl, int, option, unsi
 			else
 				error = PR_MCE_KILL_DEFAULT;
 			break;
+		case PR_SET_CHILD_SUBREAPER:
+			me->signal->is_child_subreaper = !!arg2;
+			me->signal->has_child_subreaper = true;
+			error = 0;
+			break;
+		case PR_GET_CHILD_SUBREAPER:
+			error = put_user(me->signal->is_child_subreaper,
+					 (int __user *) arg2);
+			break;
 		default:
 			error = -EINVAL;
 			break;


