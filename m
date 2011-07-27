Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754904Ab1G0Qf6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 12:35:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37381 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754584Ab1G0Qfy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 12:35:54 -0400
Date: Wed, 27 Jul 2011 18:32:54 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Roland McGrath <roland@hack.frob.com>, Tejun Heo <tj@kernel.org>
Cc: Denys Vlasenko <dvlasenk@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Matt Fleming <matt.fleming@linux.intel.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/8] vfork: make it killable
Message-ID: <20110727163254.GC23793@redhat.com>
References: <20110727163159.GA23785@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110727163159.GA23785@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make vfork() killable().

Change clone_vfork_finish() to do wait_for_completion_killable().
If it fails we do not return to the user-mode and never touch mm
shared with our child.

However, we should clear child->vfork_done before return.
complete_vfork_done() and clone_vfork_finish() use xchg-and-check
to avoid the races with each other. If clone_vfork_finish() fails
to clear child->vfork_done it does another wait_for_completion() to
ensure the child finishes complete-in-progress.

NOTE: this and the next patches do not affect in-kernel users of
CLONE_VFORK, kernel threads run with all signals ignored, including
SIGKILL/SIGSTOP.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---

 kernel/fork.c |   27 +++++++++++++++++++--------
 1 file changed, 19 insertions(+), 8 deletions(-)

--- 3.1/kernel/fork.c~3_make_killable	2011-07-26 19:26:03.000000000 +0200
+++ 3.1/kernel/fork.c	2011-07-26 20:23:28.000000000 +0200
@@ -688,7 +688,8 @@ void mm_release(struct task_struct *tsk,
 	 * If we're exiting normally, clear a user-space tid field if
 	 * requested.  We leave this alone when dying by signal, to leave
 	 * the value intact in a core dump, and to save the unnecessary
-	 * trouble otherwise.  Userland only wants this done for a sys_exit.
+	 * trouble, say, a killed vfork parent shouldn't touch this mm.
+	 * Userland only wants this done for a sys_exit.
 	 */
 	if (tsk->clear_child_tid) {
 		if (!(tsk->flags & PF_SIGNALED) &&
@@ -1443,18 +1444,25 @@ struct task_struct * __cpuinit fork_idle
 
 void complete_vfork_done(struct task_struct *tsk)
 {
-	struct completion *vfork_done = tsk->vfork_done;
+	struct completion *vfork_done = xchg(&tsk->vfork_done, NULL);
 
-	tsk->vfork_done = NULL;
-	complete(vfork_done);
+	if (vfork_done)
+		complete(vfork_done);
 }
 
 static long clone_vfork_finish(struct task_struct *child,
 				struct completion *vfork_done, long pid)
 {
-	freezer_do_not_count();
-	wait_for_completion(vfork_done);
-	freezer_count();
+	int killed = wait_for_completion_killable(vfork_done);
+
+	if (killed) {
+		struct completion *steal = xchg(&child->vfork_done, NULL);
+		/* if we race with complete_vfork_done() we have to wait */
+		if (unlikely(!steal))
+			wait_for_completion(vfork_done);
+
+		return -EINTR;
+	}
 
 	ptrace_event(PTRACE_EVENT_VFORK_DONE, pid);
 	return pid;
@@ -1527,6 +1535,7 @@ long do_fork(unsigned long clone_flags,
 			put_user(nr, parent_tidptr);
 
 		if (clone_flags & CLONE_VFORK) {
+			get_task_struct(p);
 			p->vfork_done = &vfork;
 			init_completion(&vfork);
 		}
@@ -1547,8 +1556,10 @@ long do_fork(unsigned long clone_flags,
 		if (unlikely(trace))
 			ptrace_event(trace, nr);
 
-		if (clone_flags & CLONE_VFORK)
+		if (clone_flags & CLONE_VFORK) {
 			nr = clone_vfork_finish(p, &vfork, nr);
+			put_task_struct(p);
+		}
 	} else {
 		nr = PTR_ERR(p);
 	}

