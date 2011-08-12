Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753763Ab1HLR7K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Aug 2011 13:59:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51832 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753612Ab1HLR7G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Aug 2011 13:59:06 -0400
Date: Fri, 12 Aug 2011 19:56:12 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: Roland McGrath <roland@hack.frob.com>,
        Denys Vlasenko <dvlasenk@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Matt Fleming <matt.fleming@linux.intel.com>,
        linux-kernel@vger.kernel.org, Pavel Machek <pavel@ucw.cz>
Subject: [PATCH 1/3] vfork: introduce complete_vfork_done()
Message-ID: <20110812175612.GB7484@redhat.com>
References: <20110727163159.GA23785@redhat.com> <20110729192358.GB31717@mtj.dyndns.org> <20110812175550.GA7484@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110812175550.GA7484@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No functional changes.

Move the clear-and-complete-vfork_done code into the new trivial
helper, complete_vfork_done().

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---

 include/linux/sched.h |    1 +
 fs/exec.c             |    8 ++------
 kernel/fork.c         |   17 ++++++++++-------
 3 files changed, 13 insertions(+), 13 deletions(-)

--- 3.1/include/linux/sched.h~1_complete_vfork_done	2011-08-12 16:02:17.000000000 +0200
+++ 3.1/include/linux/sched.h	2011-08-12 16:05:40.000000000 +0200
@@ -2254,6 +2254,7 @@ extern int do_execve(const char *,
 		     const char __user * const __user *,
 		     const char __user * const __user *, struct pt_regs *);
 extern long do_fork(unsigned long, unsigned long, struct pt_regs *, unsigned long, int __user *, int __user *);
+extern void complete_vfork_done(struct task_struct *tsk);
 struct task_struct *fork_idle(int);
 
 extern void set_task_comm(struct task_struct *tsk, char *from);
--- 3.1/fs/exec.c~1_complete_vfork_done	2011-08-12 16:02:16.000000000 +0200
+++ 3.1/fs/exec.c	2011-08-12 16:05:40.000000000 +0200
@@ -1914,7 +1914,6 @@ static int coredump_wait(int exit_code, 
 {
 	struct task_struct *tsk = current;
 	struct mm_struct *mm = tsk->mm;
-	struct completion *vfork_done;
 	int core_waiters = -EBUSY;
 
 	init_completion(&core_state->startup);
@@ -1933,11 +1932,8 @@ static int coredump_wait(int exit_code, 
 	 * Make sure nobody is waiting for us to release the VM,
 	 * otherwise we can deadlock when we wait on each other
 	 */
-	vfork_done = tsk->vfork_done;
-	if (vfork_done) {
-		tsk->vfork_done = NULL;
-		complete(vfork_done);
-	}
+	if (tsk->vfork_done)
+		complete_vfork_done(tsk);
 
 	if (core_waiters)
 		wait_for_completion(&core_state->startup);
--- 3.1/kernel/fork.c~1_complete_vfork_done	2011-08-12 16:02:17.000000000 +0200
+++ 3.1/kernel/fork.c	2011-08-12 16:08:19.000000000 +0200
@@ -650,6 +650,14 @@ struct mm_struct *get_task_mm(struct tas
 }
 EXPORT_SYMBOL_GPL(get_task_mm);
 
+void complete_vfork_done(struct task_struct *tsk)
+{
+	struct completion *vfork_done = tsk->vfork_done;
+
+	tsk->vfork_done = NULL;
+	complete(vfork_done);
+}
+
 /* Please note the differences between mmput and mm_release.
  * mmput is called whenever we stop holding onto a mm_struct,
  * error success whatever.
@@ -665,8 +673,6 @@ EXPORT_SYMBOL_GPL(get_task_mm);
  */
 void mm_release(struct task_struct *tsk, struct mm_struct *mm)
 {
-	struct completion *vfork_done = tsk->vfork_done;
-
 	/* Get rid of any futexes when releasing the mm */
 #ifdef CONFIG_FUTEX
 	if (unlikely(tsk->robust_list)) {
@@ -686,11 +692,8 @@ void mm_release(struct task_struct *tsk,
 	/* Get rid of any cached register state */
 	deactivate_mm(tsk, mm);
 
-	/* notify parent sleeping on vfork() */
-	if (vfork_done) {
-		tsk->vfork_done = NULL;
-		complete(vfork_done);
-	}
+	if (tsk->vfork_done)
+		complete_vfork_done(tsk);
 
 	/*
 	 * If we're exiting normally, clear a user-space tid field if

