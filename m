Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752762Ab1HRSLh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 14:11:37 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:57884 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752130Ab1HRSLf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 14:11:35 -0400
Subject: Re: +
 prctl-add-pr_setget_child_reaper-to-allow-simple-process-supervision .patch
 added to -mm tree
From: Kay Sievers <kay.sievers@vrfy.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Lennart Poettering <mzxreary@0pointer.de>, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-man@vger.kernel.org,
        roland@hack.frob.com, torvalds@linux-foundation.org
Date: Thu, 18 Aug 2011 20:11:29 +0200
In-Reply-To: <20110818142508.GA30959@redhat.com>
References: <201108162011.p7GKBcY0023134@imap1.linux-foundation.org>
	 <20110817115543.GA8745@redhat.com>
	 <CAPXgP12rYf2HmmsJAuJw=nrtcjTRR1WzDhLNM47eKhKA1UTfJQ@mail.gmail.com>
	 <20110817134516.GA14136@redhat.com>
	 <20110818124353.GA2839@tango.0pointer.de>
	 <20110818142508.GA30959@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.1.4 (3.1.4-1.fc16) 
Content-Transfer-Encoding: 7bit
Message-ID: <1313691091.1107.9.camel@mop>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-08-18 at 16:25 +0200, Oleg Nesterov wrote:
> On 08/18, Lennart Poettering wrote:
> >
> > On Wed, 17.08.11 15:45, Oleg Nesterov (oleg@redhat.com) wrote:
> >
> > > You should mark the whole process as sub-reaper, not a single thread
> > > which does prctl(). The parent/child relationship is process-wide.
> >
> > Hmm, how would we implement this best? Would it be sufficient to follow
> > group_leader pointer to set/get the flag,
> 
> You can mark task->group_leader. Or, probably better, task->signal.
> 
> INHO, the best option is SIGNAL_SUB_REAPER in signal->flags. But this
> is not possible until we cleanup the usage of signal->flags.
> 
> > and to follow real_parent
> 
> OOPS. I simly can't understand how I managed to miss this. Of course,
> in any case you should follow ->real_parent, not ->parent!

How about this? It:
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

Thanks a lot,
Kay


From: Lennart Poettering <lennart@poettering.net>
Subject: prctl: add PR_{SET,GET}_CHILD_REAPER to allow simple process supervision

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
 include/linux/sched.h |    8 ++++++++
 kernel/exit.c         |   24 +++++++++++++++++++-----
 kernel/sys.c          |    7 +++++++
 4 files changed, 37 insertions(+), 5 deletions(-)

--- a/include/linux/prctl.h
+++ b/include/linux/prctl.h
@@ -102,4 +102,7 @@
 
 #define PR_MCE_KILL_GET 34
 
+#define PR_SET_CHILD_REAPER 35
+#define PR_GET_CHILD_REAPER 36
+
 #endif /* _LINUX_PRCTL_H */
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -550,6 +550,14 @@ struct signal_struct {
 	int			group_stop_count;
 	unsigned int		flags; /* see SIGNAL_* flags below */
 
+	/*
+	 * PR_SET_CHILD_REAPER flag which marks a process like a service
+	 * manager to re-parent orphan (double-forking) child processes
+	 * to this process instead of init, so the service manager is
+	 * able to receive SIGCHLD and is resonsible to do the wait().
+	 */
+	unsigned int		child_reaper:1;
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
+ *    as a child_reaper for its children (like a service manager)
+ * 3. give it to the init process (PID 1) in our pid namespace
  */
 static struct task_struct *find_new_reaper(struct task_struct *father)
 	__releases(&tasklist_lock)
@@ -724,6 +725,19 @@ static struct task_struct *find_new_reap
 		 * forget_original_parent() must move them somewhere.
 		 */
 		pid_ns->child_reaper = init_pid_ns.child_reaper;
+	} else {
+		/* find the first ancestor which is marked as child_reaper */
+		for (thread = father->real_parent;
+		     thread != thread->real_parent;
+		     thread = thread->real_parent) {
+			if (thread == pid_ns->child_reaper)
+				break;
+			if (!thread->signal->child_reaper)
+				continue;
+			if (thread->flags & PF_EXITING)
+				continue;
+			return thread;
+		}
 	}
 
 	return pid_ns->child_reaper;
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -1799,6 +1799,13 @@ SYSCALL_DEFINE5(prctl, int, option, unsi
 			else
 				error = PR_MCE_KILL_DEFAULT;
 			break;
+		case PR_SET_CHILD_REAPER:
+			me->signal->child_reaper = !!arg2;
+			error = 0;
+			break;
+		case PR_GET_CHILD_REAPER:
+			error = put_user(me->signal->child_reaper, (int __user *) arg2);
+			break;
 		default:
 			error = -EINVAL;
 			break;


