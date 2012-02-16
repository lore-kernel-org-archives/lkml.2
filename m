Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754413Ab2BPSRw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 13:17:52 -0500
Received: from mx1.redhat.com ([209.132.183.28]:50278 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754327Ab2BPSRt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 13:17:49 -0500
Date: Thu, 16 Feb 2012 18:27:24 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: apw@canonical.com, arjan@linux.intel.com, fhrbata@redhat.com,
        john.johansen@canonical.com, penguin-kernel@I-love.SAKURA.ne.jp,
        rientjes@google.com, rusty@rustcorp.com.au, tj@kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/4] coredump_wait: don't call complete_vfork_done()
Message-ID: <20120216172724.GD30393@redhat.com>
References: <20120214164709.GA21178@redhat.com> <20120214164914.GF21185@redhat.com> <20120215123049.6e938eed.akpm@linux-foundation.org> <20120216150429.GB11953@redhat.com> <20120216172626.GA30393@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120216172626.GA30393@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that CLONE_VFORK is killable, coredump_wait() no longer needs
complete_vfork_done(). zap_threads() should find and kill all tasks
with the same ->mm, this includes our parent if ->vfork_done is set.

mm_release() becomes the only caller, unexport complete_vfork_done().

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Tejun Heo <tj@kernel.org>
---
 fs/exec.c             |   14 ++------------
 include/linux/sched.h |    1 -
 kernel/fork.c         |    2 +-
 3 files changed, 3 insertions(+), 14 deletions(-)

diff --git a/fs/exec.c b/fs/exec.c
index dccdcec..153dee1 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1926,19 +1926,9 @@ static int coredump_wait(int exit_code, struct core_state *core_state)
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
 
diff --git a/include/linux/sched.h b/include/linux/sched.h
index b646771..11fcafa 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -2291,7 +2291,6 @@ extern int do_execve(const char *,
 		     const char __user * const __user *,
 		     const char __user * const __user *, struct pt_regs *);
 extern long do_fork(unsigned long, unsigned long, struct pt_regs *, unsigned long, int __user *, int __user *);
-extern void complete_vfork_done(struct task_struct *tsk);
 struct task_struct *fork_idle(int);
 
 extern void set_task_comm(struct task_struct *tsk, char *from);
diff --git a/kernel/fork.c b/kernel/fork.c
index fc2c2f0..57ebebb 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -667,7 +667,7 @@ struct mm_struct *mm_access(struct task_struct *task, unsigned int mode)
 	return mm;
 }
 
-void complete_vfork_done(struct task_struct *tsk)
+static void complete_vfork_done(struct task_struct *tsk)
 {
 	struct completion *vfork;
 
-- 
1.5.5.1


