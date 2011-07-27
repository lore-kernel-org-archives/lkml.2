Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755050Ab1G0QhS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 12:37:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64632 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754897Ab1G0QhO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 12:37:14 -0400
Date: Wed, 27 Jul 2011 18:34:12 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Roland McGrath <roland@hack.frob.com>, Tejun Heo <tj@kernel.org>
Cc: Denys Vlasenko <dvlasenk@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Matt Fleming <matt.fleming@linux.intel.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 7/8] vfork: make it stoppable/traceable
Message-ID: <20110727163412.GG23793@redhat.com>
References: <20110727163159.GA23785@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110727163159.GA23785@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make vfork() stoppable/traceable.

Change clone_vfork_finish() paths to block all signals except
SIGKILL | SIGSTOP and do wait_for_completion_interruptible().

This means we should restart after the stop/ptrace_attach or
the spurious wakeup, implement clone_vfork_restart().

-ERESTART_RESTARTBLOCK is safe, we can never dequeue a signal
which has a handler, thus we can never return to the user-space.
Unless the debugger changes regs of course, but this is fine.

Note:

	- This changes the "killable" behavior, the vforking task
	  doesn't react to the fatal signals except SIGKILL. See
	  the next patch

	- The code asks for the final cleanups, for example we
	  should move put_task_struct() into clone_vfork_finish()
	  and simplify the usage of ->restart_block. Will be done
	  later

	- We use ->saved_sigmask to record the original sigmask.
	  This is safe, nobody should play with it, we do not do.
	  set_restore_sigmask(). Still it would be more clean to
	  use restart_block->vfork, but then we should somehow
	  export sigset_t for thread_info.h

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---

 include/linux/thread_info.h |    4 ++++
 kernel/fork.c               |   37 +++++++++++++++++++++++++++++++++++--
 2 files changed, 39 insertions(+), 2 deletions(-)

--- 3.1/include/linux/thread_info.h~7_vfork_restart	2011-07-27 15:27:38.000000000 +0200
+++ 3.1/include/linux/thread_info.h	2011-07-27 15:28:43.000000000 +0200
@@ -44,6 +44,10 @@ struct restart_block {
 			unsigned long tv_sec;
 			unsigned long tv_nsec;
 		} poll;
+
+		struct {
+			long pid;
+		} vfork;
 	};
 };
 
--- 3.1/kernel/fork.c~7_vfork_restart	2011-07-27 15:27:38.000000000 +0200
+++ 3.1/kernel/fork.c	2011-07-27 16:01:01.000000000 +0200
@@ -1454,18 +1454,24 @@ static void complete_vfork_done(struct t
 		complete(vfork_done);
 }
 
+static long clone_vfork_restart(struct restart_block *);
+
 static long clone_vfork_finish(struct task_struct *child, long pid)
 {
+	struct restart_block *restart = &current_thread_info()->restart_block;
 	struct completion vfork_done;
 	int killed;
 
+	if (!child || child->real_parent != current)
+		goto done;
+
 	init_completion(&vfork_done);
 
 	/* complete_vfork_done() was already called? */
 	if (xchg(&child->vfork_done, &vfork_done) == NULL)
 		goto done;
 
-	killed = wait_for_completion_killable(&vfork_done);
+	killed = wait_for_completion_interruptible(&vfork_done);
 	if (killed) {
 		struct completion *steal = xchg(&child->vfork_done,
 							VFORK_DONE_NOP);
@@ -1473,14 +1479,40 @@ static long clone_vfork_finish(struct ta
 		if (unlikely(!steal))
 			wait_for_completion(&vfork_done);
 
-		return -EINTR;
+		restart->fn = clone_vfork_restart;
+		restart->vfork.pid = pid;
+
+		return -ERESTART_RESTARTBLOCK;
 	}
 
 done:
+	restart->fn = do_no_restart_syscall; /* not really needed */
+	set_current_blocked(&current->saved_sigmask);
 	ptrace_event(PTRACE_EVENT_VFORK_DONE, pid);
 	return pid;
 }
 
+static long clone_vfork_restart(struct restart_block *restart)
+{
+	long pid = restart->vfork.pid;
+	struct task_struct *child = find_get_task_by_vpid(pid);
+	long ret;
+
+	ret = clone_vfork_finish(child, pid);
+	if (child)
+		put_task_struct(child);
+	return ret;
+}
+
+static void clone_vfork_prepare(void)
+{
+	sigset_t vfork_mask;
+
+	current->saved_sigmask = current->blocked;
+	siginitsetinv(&vfork_mask, sigmask(SIGKILL) | sigmask(SIGSTOP));
+	set_current_blocked(&vfork_mask);
+}
+
 /*
  *  Ok, this is the main fork-routine.
  *
@@ -1567,6 +1599,7 @@ long do_fork(unsigned long clone_flags,
 			ptrace_event(trace, nr);
 
 		if (clone_flags & CLONE_VFORK) {
+			clone_vfork_prepare();
 			nr = clone_vfork_finish(p, nr);
 			put_task_struct(p);
 		}

