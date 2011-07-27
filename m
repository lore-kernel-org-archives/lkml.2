Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754928Ab1G0QgV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 12:36:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24928 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754732Ab1G0QgR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 12:36:17 -0400
Date: Wed, 27 Jul 2011 18:33:11 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Roland McGrath <roland@hack.frob.com>, Tejun Heo <tj@kernel.org>
Cc: Denys Vlasenko <dvlasenk@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Matt Fleming <matt.fleming@linux.intel.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 4/8] coredump_wait: don't call complete_vfork_done()
Message-ID: <20110727163311.GD23793@redhat.com>
References: <20110727163159.GA23785@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110727163159.GA23785@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that CLONE_VFORK is killable, coredump_wait() no longer needs
complete_vfork_done(). zap_threads() should find and kill all tasks
with the same ->mm, this includes our parent if ->vfork_done is set.

mm_release() becomes the only caller, unexport complete_vfork_done().

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---

 include/linux/sched.h |    1 -
 fs/exec.c             |    7 -------
 kernel/fork.c         |    3 ++-
 3 files changed, 2 insertions(+), 9 deletions(-)

--- 3.1/include/linux/sched.h~4_coredump_no_vfork_done	2011-07-26 20:23:28.000000000 +0200
+++ 3.1/include/linux/sched.h	2011-07-26 20:28:24.000000000 +0200
@@ -2253,7 +2253,6 @@ extern int do_execve(const char *,
 		     const char __user * const __user *,
 		     const char __user * const __user *, struct pt_regs *);
 extern long do_fork(unsigned long, unsigned long, struct pt_regs *, unsigned long, int __user *, int __user *);
-extern void complete_vfork_done(struct task_struct *tsk);
 struct task_struct *fork_idle(int);
 
 extern void set_task_comm(struct task_struct *tsk, char *from);
--- 3.1/fs/exec.c~4_coredump_no_vfork_done	2011-07-26 20:23:28.000000000 +0200
+++ 3.1/fs/exec.c	2011-07-26 20:28:24.000000000 +0200
@@ -1899,13 +1899,6 @@ static int coredump_wait(int exit_code, 
 	if (unlikely(core_waiters < 0))
 		goto fail;
 
-	/*
-	 * Make sure nobody is waiting for us to release the VM,
-	 * otherwise we can deadlock when we wait on each other
-	 */
-	if (tsk->vfork_done)
-		complete_vfork_done(tsk);
-
 	if (core_waiters)
 		wait_for_completion(&core_state->startup);
 fail:
--- 3.1/kernel/fork.c~4_coredump_no_vfork_done	2011-07-26 20:23:28.000000000 +0200
+++ 3.1/kernel/fork.c	2011-07-26 20:28:24.000000000 +0200
@@ -647,6 +647,7 @@ struct mm_struct *get_task_mm(struct tas
 }
 EXPORT_SYMBOL_GPL(get_task_mm);
 
+static void complete_vfork_done(struct task_struct *tsk);
 /* Please note the differences between mmput and mm_release.
  * mmput is called whenever we stop holding onto a mm_struct,
  * error success whatever.
@@ -1442,7 +1443,7 @@ struct task_struct * __cpuinit fork_idle
 	return task;
 }
 
-void complete_vfork_done(struct task_struct *tsk)
+static void complete_vfork_done(struct task_struct *tsk)
 {
 	struct completion *vfork_done = xchg(&tsk->vfork_done, NULL);
 

