Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754802Ab1ELIra (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 04:47:30 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:59235 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754605Ab1ELIr2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 04:47:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=vddPhM2bRbNAqYNfA1fo8vvf4gTgHfL7qw5j/lqLjIw6an1kbltnlbKrPuQ3pNtAkh
         LZk/oJ9LEpeYQDRWfDHIT3QkS54lfUM+aE2kzqfhyYGhwVmxABDb9yb28wAv+YepniM9
         QTEK0cBeZQ81BzlLxB3Wp8clNyQ4mzuS1LcGc=
Date: Thu, 12 May 2011 10:47:23 +0200
From: Tejun Heo <tj@kernel.org>
To: oleg@redhat.com
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org
Subject: [PATCH] job control: reorganize wait_task_stopped()
Message-ID: <20110512084723.GC1030@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
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
Dropped the "it's not a bug fix" paragraph from description and added
Reviewed-by.

Thanks.

 kernel/exit.c |   30 +++++++++++++++++++++++-------
 1 file changed, 23 insertions(+), 7 deletions(-)

Index: work/kernel/exit.c
===================================================================
--- work.orig/kernel/exit.c
+++ work/kernel/exit.c
@@ -1377,11 +1377,23 @@ static int *task_stopped_code(struct tas
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
@@ -1397,6 +1409,9 @@ static int wait_task_stopped(struct wait
 	if (!ptrace && !(wo->wo_flags & WUNTRACED))
 		return 0;
 
+	if (!task_stopped_code(p, ptrace))
+		return 0;
+
 	exit_code = 0;
 	spin_lock_irq(&p->sighand->siglock);
 
@@ -1607,8 +1622,9 @@ static int wait_consider_task(struct wai
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
