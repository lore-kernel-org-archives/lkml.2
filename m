Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759522Ab1EMPsf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 11:48:35 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:52886 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932409Ab1EMPq1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 11:46:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=PsZtEbbeiOtSzTqRQpGAZ5xvDJIi6M5b9dgyb1/yCNSuVhW8+3g2ILRnzIDXNnZ1Vc
         TNSqZzPnVCrVWmLfenUusJRDE1VvMJOW8PrkhQ7wOb0NyXLvwWW9dZ+Ex/vX/PV9JBzK
         AIafemom7zVgXCLZOgzlxhUcYwLsb+mOxqQlU=
From: Tejun Heo <tj@kernel.org>
To: oleg@redhat.com, jan.kratochvil@redhat.com, vda.linux@googlemail.com
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, indan@nul.nu, bdonlan@gmail.com,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 1/9] job control: reorganize wait_task_stopped()
Date: Fri, 13 May 2011 17:46:12 +0200
Message-Id: <1305301580-9924-2-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1305301580-9924-1-git-send-email-tj@kernel.org>
References: <1305301580-9924-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

wait_task_stopped() tested task_stopped_code() without acquiring
siglock and, if stop condition existed, called wait_task_stopped() and
directly returned the result.  This patch moves the initial
task_stopped_code() testing into wait_task_stopped() and make
wait_consider_task() fall through to wait_task_continue() on 0 return.

This is for the following two reasons.

* Because the initial task_stopped_code() test is done without
  acquiring siglock, it may race against SIGCONT generation.  The
  stopped condition might have been replaced by continued state by the
  time wait_task_stopped() acquired siglock.  This may lead to
  unexpected failure of WNOHANG waits.

  This reorganization addresses this single race case but there are
  other cases - TASK_RUNNING -> TASK_STOPPED transition and EXIT_*
  transitions.

* Scheduled ptrace updates require changes to the initial test which
  would fit better inside wait_task_stopped().

Signed-off-by: Tejun Heo <tj@kernel.org>
Reviewed-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/exit.c |   30 +++++++++++++++++++++++-------
 1 files changed, 23 insertions(+), 7 deletions(-)

diff --git a/kernel/exit.c b/kernel/exit.c
index 5cbc83e..3383793 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -1377,11 +1377,23 @@ static int *task_stopped_code(struct task_struct *p, bool ptrace)
 	return NULL;
 }
 
-/*
- * Handle sys_wait4 work for one task in state TASK_STOPPED.  We hold
- * read_lock(&tasklist_lock) on entry.  If we return zero, we still hold
- * the lock and this task is uninteresting.  If we return nonzero, we have
- * released the lock and the system call should return.
+/**
+ * wait_task_stopped - Wait for %TASK_STOPPED or %TASK_TRACED
+ * @wo: wait options
+ * @ptrace: is the wait for ptrace
+ * @p: task to wait for
+ *
+ * Handle sys_wait4() work for %p in state %TASK_STOPPED or %TASK_TRACED.
+ *
+ * CONTEXT:
+ * read_lock(&tasklist_lock), which is released if return value is
+ * non-zero.  Also, grabs and releases @p->sighand->siglock.
+ *
+ * RETURNS:
+ * 0 if wait condition didn't exist and search for other wait conditions
+ * should continue.  Non-zero return, -errno on failure and @p's pid on
+ * success, implies that tasklist_lock is released and wait condition
+ * search should terminate.
  */
 static int wait_task_stopped(struct wait_opts *wo,
 				int ptrace, struct task_struct *p)
@@ -1397,6 +1409,9 @@ static int wait_task_stopped(struct wait_opts *wo,
 	if (!ptrace && !(wo->wo_flags & WUNTRACED))
 		return 0;
 
+	if (!task_stopped_code(p, ptrace))
+		return 0;
+
 	exit_code = 0;
 	spin_lock_irq(&p->sighand->siglock);
 
@@ -1607,8 +1622,9 @@ static int wait_consider_task(struct wait_opts *wo, int ptrace,
 	 * Wait for stopped.  Depending on @ptrace, different stopped state
 	 * is used and the two don't interact with each other.
 	 */
-	if (task_stopped_code(p, ptrace))
-		return wait_task_stopped(wo, ptrace, p);
+	ret = wait_task_stopped(wo, ptrace, p);
+	if (ret)
+		return ret;
 
 	/*
 	 * Wait for continued.  There's only one continued state and the
-- 
1.7.1

