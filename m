Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754987Ab1G0Qgt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 12:36:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23537 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754972Ab1G0Qgs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 12:36:48 -0400
Date: Wed, 27 Jul 2011 18:33:45 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Roland McGrath <roland@hack.frob.com>, Tejun Heo <tj@kernel.org>
Cc: Denys Vlasenko <dvlasenk@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Matt Fleming <matt.fleming@linux.intel.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 6/8] vfork: do not setup child->vfork_done beforehand
Message-ID: <20110727163345.GF23793@redhat.com>
References: <20110727163159.GA23785@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110727163159.GA23785@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

do_fork() allocates/initializes "struct completion" on stack and
sets p->vfork_done in advance, before the task becomes runnable.
This way clone_vfork_finish(p) can always trust ->vfork_done.

But, to make this restartable, we need to re-assign ->vfork_done
and wait in sys_restart_syscall(), and we must not do this if the
child has already passed complete_vfork_done().

With this patch we allocate/initialize and set child->vfork_done in
clone_vfork_finish() when we are going to actually wait. To prevent
the race with the child we use the fake VFORK_DONE_NOP marker set by
do_fork().

complete_vfork_done() does nothing if it sees VFORK_DONE_NOP but sets
->vfork_done = NULL.

This way clone_vfork_finish() can do xchg() and if it returns !NULL
we can be sure the child didn't exit yet, we can safely wait.

IOW, the logic is:

	- do_fork(CLONE_VFORK)

		child->vfork_done = VFORK_DONE_NOP; // != NULL

	- complete_vfork_done() 	// child

		vfork = xchg(tsk->vfork_done, NULL);

	- clone_vfork_finish()		// parent

		struct completion vfork_done;
		if (xchg(&child->vfork_done, &vfork_done) != NULL)
			 wait_for_completion(&vfork_done);

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---

 kernel/fork.c |   31 ++++++++++++++++++++-----------
 1 file changed, 20 insertions(+), 11 deletions(-)

--- 3.1/kernel/fork.c~6_no_vfork_done	2011-07-26 20:28:24.000000000 +0200
+++ 3.1/kernel/fork.c	2011-07-26 21:13:56.000000000 +0200
@@ -1443,28 +1443,40 @@ struct task_struct * __cpuinit fork_idle
 	return task;
 }
 
+#define VFORK_DONE_NOP		((struct completion *) 1)
+#define vfork_done_valid(vf)	((unsigned long)(vf) > 1)
+
 static void complete_vfork_done(struct task_struct *tsk)
 {
 	struct completion *vfork_done = xchg(&tsk->vfork_done, NULL);
 
-	if (vfork_done)
+	if (vfork_done_valid(vfork_done))
 		complete(vfork_done);
 }
 
-static long clone_vfork_finish(struct task_struct *child,
-				struct completion *vfork_done, long pid)
+static long clone_vfork_finish(struct task_struct *child, long pid)
 {
-	int killed = wait_for_completion_killable(vfork_done);
+	struct completion vfork_done;
+	int killed;
+
+	init_completion(&vfork_done);
 
+	/* complete_vfork_done() was already called? */
+	if (xchg(&child->vfork_done, &vfork_done) == NULL)
+		goto done;
+
+	killed = wait_for_completion_killable(&vfork_done);
 	if (killed) {
-		struct completion *steal = xchg(&child->vfork_done, NULL);
+		struct completion *steal = xchg(&child->vfork_done,
+							VFORK_DONE_NOP);
 		/* if we race with complete_vfork_done() we have to wait */
 		if (unlikely(!steal))
-			wait_for_completion(vfork_done);
+			wait_for_completion(&vfork_done);
 
 		return -EINTR;
 	}
 
+done:
 	ptrace_event(PTRACE_EVENT_VFORK_DONE, pid);
 	return pid;
 }
@@ -1526,8 +1538,6 @@ long do_fork(unsigned long clone_flags,
 	 * might get invalid after that point, if the thread exits quickly.
 	 */
 	if (!IS_ERR(p)) {
-		struct completion vfork;
-
 		trace_sched_process_fork(current, p);
 
 		nr = task_pid_vnr(p);
@@ -1536,9 +1546,8 @@ long do_fork(unsigned long clone_flags,
 			put_user(nr, parent_tidptr);
 
 		if (clone_flags & CLONE_VFORK) {
+			p->vfork_done = VFORK_DONE_NOP;
 			get_task_struct(p);
-			p->vfork_done = &vfork;
-			init_completion(&vfork);
 		}
 
 		audit_finish_fork(p);
@@ -1558,7 +1567,7 @@ long do_fork(unsigned long clone_flags,
 			ptrace_event(trace, nr);
 
 		if (clone_flags & CLONE_VFORK) {
-			nr = clone_vfork_finish(p, &vfork, nr);
+			nr = clone_vfork_finish(p, nr);
 			put_task_struct(p);
 		}
 	} else {

