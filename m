Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754197Ab2BPSJ6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 13:09:58 -0500
Received: from mx1.redhat.com ([209.132.183.28]:52340 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751445Ab2BPSJz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 13:09:55 -0500
Date: Thu, 16 Feb 2012 18:26:47 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: apw@canonical.com, arjan@linux.intel.com, fhrbata@redhat.com,
        john.johansen@canonical.com, penguin-kernel@I-love.SAKURA.ne.jp,
        rientjes@google.com, rusty@rustcorp.com.au, tj@kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/4] introduce complete_vfork_done()
Message-ID: <20120216172647.GB30393@redhat.com>
References: <20120214164709.GA21178@redhat.com> <20120214164914.GF21185@redhat.com> <20120215123049.6e938eed.akpm@linux-foundation.org> <20120216150429.GB11953@redhat.com> <20120216172626.GA30393@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120216172626.GA30393@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No functional changes.

Move the clear-and-complete-vfork_done code into the new trivial
helper, complete_vfork_done().

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Tejun Heo <tj@kernel.org>
---
 fs/exec.c             |    8 ++------
 include/linux/sched.h |    1 +
 kernel/fork.c         |   17 ++++++++++-------
 3 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/fs/exec.c b/fs/exec.c
index 92ce83a..dccdcec 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1915,7 +1915,6 @@ static int coredump_wait(int exit_code, struct core_state *core_state)
 {
 	struct task_struct *tsk = current;
 	struct mm_struct *mm = tsk->mm;
-	struct completion *vfork_done;
 	int core_waiters = -EBUSY;
 
 	init_completion(&core_state->startup);
@@ -1934,11 +1933,8 @@ static int coredump_wait(int exit_code, struct core_state *core_state)
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
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 7d379a6..1b25a37 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -2291,6 +2291,7 @@ extern int do_execve(const char *,
 		     const char __user * const __user *,
 		     const char __user * const __user *, struct pt_regs *);
 extern long do_fork(unsigned long, unsigned long, struct pt_regs *, unsigned long, int __user *, int __user *);
+extern void complete_vfork_done(struct task_struct *tsk);
 struct task_struct *fork_idle(int);
 
 extern void set_task_comm(struct task_struct *tsk, char *from);
diff --git a/kernel/fork.c b/kernel/fork.c
index b77fd55..5a41446 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -667,6 +667,14 @@ struct mm_struct *mm_access(struct task_struct *task, unsigned int mode)
 	return mm;
 }
 
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
@@ -682,8 +690,6 @@ struct mm_struct *mm_access(struct task_struct *task, unsigned int mode)
  */
 void mm_release(struct task_struct *tsk, struct mm_struct *mm)
 {
-	struct completion *vfork_done = tsk->vfork_done;
-
 	/* Get rid of any futexes when releasing the mm */
 #ifdef CONFIG_FUTEX
 	if (unlikely(tsk->robust_list)) {
@@ -703,11 +709,8 @@ void mm_release(struct task_struct *tsk, struct mm_struct *mm)
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
-- 
1.5.5.1


