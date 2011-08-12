Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753926Ab1HLR76 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Aug 2011 13:59:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58423 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753612Ab1HLR75 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Aug 2011 13:59:57 -0400
Date: Fri, 12 Aug 2011 19:56:46 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: Roland McGrath <roland@hack.frob.com>,
        Denys Vlasenko <dvlasenk@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Matt Fleming <matt.fleming@linux.intel.com>,
        linux-kernel@vger.kernel.org, Pavel Machek <pavel@ucw.cz>
Subject: [PATCH 3/3] coredump_wait: don't call complete_vfork_done()
Message-ID: <20110812175646.GD7484@redhat.com>
References: <20110727163159.GA23785@redhat.com> <20110729192358.GB31717@mtj.dyndns.org> <20110812175550.GA7484@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110812175550.GA7484@redhat.com>
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
 fs/exec.c             |   14 ++------------
 kernel/fork.c         |    2 +-
 3 files changed, 3 insertions(+), 14 deletions(-)

--- 3.1/include/linux/sched.h~3_coredump_no_vfork_done	2011-08-12 18:50:11.000000000 +0200
+++ 3.1/include/linux/sched.h	2011-08-12 18:51:13.000000000 +0200
@@ -2254,7 +2254,6 @@ extern int do_execve(const char *,
 		     const char __user * const __user *,
 		     const char __user * const __user *, struct pt_regs *);
 extern long do_fork(unsigned long, unsigned long, struct pt_regs *, unsigned long, int __user *, int __user *);
-extern void complete_vfork_done(struct task_struct *tsk);
 struct task_struct *fork_idle(int);
 
 extern void set_task_comm(struct task_struct *tsk, char *from);
--- 3.1/fs/exec.c~3_coredump_no_vfork_done	2011-08-12 18:50:11.000000000 +0200
+++ 3.1/fs/exec.c	2011-08-12 18:51:13.000000000 +0200
@@ -1925,19 +1925,9 @@ static int coredump_wait(int exit_code, 
 		core_waiters = zap_threads(tsk, mm, core_state, exit_code);
 	up_write(&mm->mmap_sem);
 
-	if (unlikely(core_waiters < 0))
-		goto fail;
-
-	/*
-	 * Make sure nobody is waiting for us to release the VM,
-	 * otherwise we can deadlock when we wait on each other
-	 */
-	if (tsk->vfork_done)
-		complete_vfork_done(tsk);
-
-	if (core_waiters)
+	if (core_waiters > 0)
 		wait_for_completion(&core_state->startup);
-fail:
+
 	return core_waiters;
 }
 
--- 3.1/kernel/fork.c~3_coredump_no_vfork_done	2011-08-12 18:50:11.000000000 +0200
+++ 3.1/kernel/fork.c	2011-08-12 18:51:13.000000000 +0200
@@ -650,7 +650,7 @@ struct mm_struct *get_task_mm(struct tas
 }
 EXPORT_SYMBOL_GPL(get_task_mm);
 
-void complete_vfork_done(struct task_struct *tsk)
+static void complete_vfork_done(struct task_struct *tsk)
 {
 	struct completion *vfork;
 

