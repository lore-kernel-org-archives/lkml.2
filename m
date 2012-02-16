Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755174Ab2BPTKm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 14:10:42 -0500
Received: from mx1.redhat.com ([209.132.183.28]:45168 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754953Ab2BPTKh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 14:10:37 -0500
Date: Thu, 16 Feb 2012 18:27:06 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: apw@canonical.com, arjan@linux.intel.com, fhrbata@redhat.com,
        john.johansen@canonical.com, penguin-kernel@I-love.SAKURA.ne.jp,
        rientjes@google.com, rusty@rustcorp.com.au, tj@kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/4] vfork: make it killable
Message-ID: <20120216172706.GC30393@redhat.com>
References: <20120214164709.GA21178@redhat.com> <20120214164914.GF21185@redhat.com> <20120215123049.6e938eed.akpm@linux-foundation.org> <20120216150429.GB11953@redhat.com> <20120216172626.GA30393@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120216172626.GA30393@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make vfork() killable.

Change do_fork(CLONE_VFORK) to do wait_for_completion_killable().
If it fails we do not return to the user-mode and never touch the
memory shared with our child.

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
Acked-by: Tejun Heo <tj@kernel.org>
---
 include/linux/sched.h |    2 +-
 kernel/fork.c         |   40 ++++++++++++++++++++++++++++++++--------
 2 files changed, 33 insertions(+), 9 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 1b25a37..b646771 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -2372,7 +2372,7 @@ static inline int thread_group_empty(struct task_struct *p)
  * Protects ->fs, ->files, ->mm, ->group_info, ->comm, keyring
  * subscriptions and synchronises with wait4().  Also used in procfs.  Also
  * pins the final release of task.io_context.  Also protects ->cpuset and
- * ->cgroup.subsys[].
+ * ->cgroup.subsys[]. And ->vfork_done.
  *
  * Nests both inside and outside of read_lock(&tasklist_lock).
  * It must not be nested with write_lock_irq(&tasklist_lock),
diff --git a/kernel/fork.c b/kernel/fork.c
index 5a41446..fc2c2f0 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -669,10 +669,34 @@ struct mm_struct *mm_access(struct task_struct *task, unsigned int mode)
 
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
@@ -716,7 +740,8 @@ void mm_release(struct task_struct *tsk, struct mm_struct *mm)
 	 * If we're exiting normally, clear a user-space tid field if
 	 * requested.  We leave this alone when dying by signal, to leave
 	 * the value intact in a core dump, and to save the unnecessary
-	 * trouble otherwise.  Userland only wants this done for a sys_exit.
+	 * trouble, say, a killed vfork parent shouldn't touch this mm.
+	 * Userland only wants this done for a sys_exit.
 	 */
 	if (tsk->clear_child_tid) {
 		if (!(tsk->flags & PF_SIGNALED) &&
@@ -1548,6 +1573,7 @@ long do_fork(unsigned long clone_flags,
 		if (clone_flags & CLONE_VFORK) {
 			p->vfork_done = &vfork;
 			init_completion(&vfork);
+			get_task_struct(p);
 		}
 
 		/*
@@ -1565,10 +1591,8 @@ long do_fork(unsigned long clone_flags,
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
-- 
1.5.5.1


