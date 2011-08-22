Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754501Ab1HVXsS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 19:48:18 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:63908 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753483Ab1HVXsO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 19:48:14 -0400
Subject: Re: +
 prctl-add-pr_setget_child_reaper-to-allow-simple-process-supervision .patch
 added to -mm tree
From: Kay Sievers <kay.sievers@vrfy.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Lennart Poettering <mzxreary@0pointer.de>, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-man@vger.kernel.org,
        roland@hack.frob.com, torvalds@linux-foundation.org
Date: Tue, 23 Aug 2011 01:48:08 +0200
In-Reply-To: <20110822111402.GA13248@redhat.com>
References: <1313691091.1107.9.camel@mop>
	 <20110818184857.GA12094@redhat.com> <1313717521.991.4.camel@mop>
	 <20110819122503.GA8411@redhat.com>
	 <CAPXgP11KC2fTWBVYo6CBXe924YAyTGhx9=UTBDf4cP5Acuo0NA@mail.gmail.com>
	 <20110819131339.GB8411@redhat.com> <1313763653.1119.12.camel@mop>
	 <20110819145815.GA15420@redhat.com> <20110820153331.GA22577@redhat.com>
	 <1313951606.16175.7.camel@mop> <20110822111402.GA13248@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.1.4 (3.1.4-1.fc16) 
Content-Transfer-Encoding: 7bit
Message-ID: <1314056890.734.6.camel@mop>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 22, 2011 at 13:14, Oleg Nesterov <oleg@redhat.com> wrote:

> Reviewed-by: Oleg Nesterov <oleg@redhat.com>

Thanks Oleg for all the help.

Final version with updated changelog.

Linus' concern about the added overhead in the not-used case should be
addressed with the addition of a flag, which we inherit and skip all the
parent search, if none of our ancestors marked itself as a
CHILD_SUBREAPER.

Andrew, mind picking this up again? 

Thanks,
Kay


From: Lennart Poettering <lennart@poettering.net>
Subject: prctl: add PR_{SET,GET}_CHILD_SUBREAPER to allow simple process supervision

Userspace service managers/supervisors need to track their started
services. Many services daemonize by double-forking and get implicitely
re-parented to PID 1. The service manager will no longer be able to
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
output:

before:
  # ps afx
  253 ?        Ss     0:00 /bin/dbus-daemon --system --nofork
  294 ?        Sl     0:00 /usr/libexec/polkit-1/polkitd
  328 ?        S      0:00 /usr/sbin/modem-manager
  608 ?        Sl     0:00 /usr/libexec/colord
  658 ?        Sl     0:00 /usr/libexec/upowerd
  819 ?        Sl     0:00 /usr/libexec/imsettings-daemon
  916 ?        Sl     0:00 /usr/libexec/udisks-daemon
  917 ?        S      0:00  \_ udisks-daemon: not polling any devices

after:
  # ps afx
  294 ?        Ss     0:00 /bin/dbus-daemon --system --nofork
  426 ?        Sl     0:00  \_ /usr/libexec/polkit-1/polkitd
  449 ?        S      0:00  \_ /usr/sbin/modem-manager
  635 ?        Sl     0:00  \_ /usr/libexec/colord
  705 ?        Sl     0:00  \_ /usr/libexec/upowerd
  959 ?        Sl     0:00  \_ /usr/libexec/udisks-daemon
  960 ?        S      0:00  |   \_ udisks-daemon: not polling any devices
  977 ?        Sl     0:00  \_ /usr/libexec/packagekitd

This prctl is orthogonal to PID namespaces. PID namespaces are isolated
from each other, while a service management process usually requires
the services to live in the same namespace, to be able to talk to each
other.

Users of this will be the systemd per-user instance, which provides
init-like functionality for the user's login session and D-Bus, which
activates bus services on-demand. Both need init-like capabilities
to be able to properly keep track of the services they start.

Many thanks to Oleg for several rounds of review and insights.

Reviewed-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Lennart Poettering <lennart@poettering.net>
Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
---

 include/linux/prctl.h |    3 +++
 include/linux/sched.h |   12 ++++++++++++
 kernel/exit.c         |   28 +++++++++++++++++++++++-----
 kernel/fork.c         |    3 +++
 kernel/sys.c          |    8 ++++++++
 5 files changed, 49 insertions(+), 5 deletions(-)

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
+		     reaper != &init_task;
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
 
+	sig->has_child_subreaper = current->signal->has_child_subreaper ||
+				   current->signal->is_child_subreaper;
+
 	mutex_init(&sig->cred_guard_mutex);
 
 	return 0;
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -1799,6 +1799,14 @@ SYSCALL_DEFINE5(prctl, int, option, unsi
 			else
 				error = PR_MCE_KILL_DEFAULT;
 			break;
+		case PR_SET_CHILD_SUBREAPER:
+			me->signal->is_child_subreaper = !!arg2;
+			error = 0;
+			break;
+		case PR_GET_CHILD_SUBREAPER:
+			error = put_user(me->signal->is_child_subreaper,
+					 (int __user *) arg2);
+			break;
 		default:
 			error = -EINVAL;
 			break;



