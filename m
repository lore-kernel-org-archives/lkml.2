Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753871Ab1HLR71 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Aug 2011 13:59:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2117 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753802Ab1HLR7X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Aug 2011 13:59:23 -0400
Date: Fri, 12 Aug 2011 19:56:29 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: Roland McGrath <roland@hack.frob.com>,
        Denys Vlasenko <dvlasenk@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Matt Fleming <matt.fleming@linux.intel.com>,
        linux-kernel@vger.kernel.org, Pavel Machek <pavel@ucw.cz>
Subject: [PATCH 2/3] vfork: make it killable
Message-ID: <20110812175629.GC7484@redhat.com>
References: <20110727163159.GA23785@redhat.com> <20110729192358.GB31717@mtj.dyndns.org> <20110812175550.GA7484@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110812175550.GA7484@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make vfork() killable.

Change do_fork(CLONE_VFORK) to do wait_for_completion_killable().
If it fails we do not return to the user-mode and never touch ->mm
shared with our child.

However, in this case we should clear child->vfork_done before
return, we use task_lock() in do_fork()->wait_for_vfork_done()
and complete_vfork_done() to serialize with each other.

Note: now that we use task_lock() we don't really need completion,
we could turn task->vfork_done into "task_struct *wake_up_me" but
this needs some complications.

NOTE: this and the next patches do not affect in-kernel users of
CLONE_VFORK, kernel threads run with all signals ignored including
SIGKILL/SIGSTOP.

However this is obviously the user-visible change. Not only a fatal
signal can kill the vforking parent, a sub-thread can do execve or
exit_group() and kill the thread sleeping in vfork().

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---

 kernel/fork.c |   40 ++++++++++++++++++++++++++++++++--------
 1 file changed, 32 insertions(+), 8 deletions(-)

--- 3.1/kernel/fork.c~2_make_vfork_killable	2011-08-12 16:08:19.000000000 +0200
+++ 3.1/kernel/fork.c	2011-08-12 18:50:11.000000000 +0200
@@ -652,10 +652,34 @@ EXPORT_SYMBOL_GPL(get_task_mm);
 
 void complete_vfork_done(struct task_struct *tsk)
 {
-	struct completion *vfork_done = tsk->vfork_done;
+	struct completion *vfork;
 
-	tsk->vfork_done = NULL;
-	complete(vfork_done);
+	task_lock(tsk);
+	vfork = tsk->vfork_done;
+	if (likely(vfork)) {
+		tsk->vfork_done = NULL;
+		complete(vfork);
+	}
+	task_unlock(tsk);
+}
+
+static int wait_for_vfork_done(struct task_struct *child,
+				struct completion *vfork)
+{
+	int killed;
+
+	freezer_do_not_count();
+	killed = wait_for_completion_killable(vfork);
+	freezer_count();
+
+	if (killed) {
+		task_lock(child);
+		child->vfork_done = NULL;
+		task_unlock(child);
+	}
+
+	put_task_struct(child);
+	return killed;
 }
 
 /* Please note the differences between mmput and mm_release.
@@ -699,7 +723,8 @@ void mm_release(struct task_struct *tsk,
 	 * If we're exiting normally, clear a user-space tid field if
 	 * requested.  We leave this alone when dying by signal, to leave
 	 * the value intact in a core dump, and to save the unnecessary
-	 * trouble otherwise.  Userland only wants this done for a sys_exit.
+	 * trouble, say, a killed vfork parent shouldn't touch this mm.
+	 * Userland only wants this done for a sys_exit.
 	 */
 	if (tsk->clear_child_tid) {
 		if (!(tsk->flags & PF_SIGNALED) &&
@@ -1534,6 +1559,7 @@ long do_fork(unsigned long clone_flags,
 		if (clone_flags & CLONE_VFORK) {
 			p->vfork_done = &vfork;
 			init_completion(&vfork);
+			get_task_struct(p);
 		}
 
 		audit_finish_fork(p);
@@ -1553,10 +1579,8 @@ long do_fork(unsigned long clone_flags,
 			ptrace_event(trace, nr);
 
 		if (clone_flags & CLONE_VFORK) {
-			freezer_do_not_count();
-			wait_for_completion(&vfork);
-			freezer_count();
-			ptrace_event(PTRACE_EVENT_VFORK_DONE, nr);
+			if (!wait_for_vfork_done(p, &vfork))
+				ptrace_event(PTRACE_EVENT_VFORK_DONE, nr);
 		}
 	} else {
 		nr = PTR_ERR(p);

