Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759477Ab1EMPrQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 11:47:16 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:47953 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932988Ab1EMPqe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 11:46:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=r38tpgjxbbVU8sIRO/LTnLjgviQQRyxevT1tARoDk/YqtA6YaxyIWvgwu7dk6Odu7H
         faFxlKYeMq6zlMDUc7UmTx8hSgo1TisCFz5aMl/efeLoIkef+6PZ4WuAgfG+sOWcCtn7
         NizzC6KLVXZaHj1bqbxg7Z7tYhLLQFrq84DC4=
From: Tejun Heo <tj@kernel.org>
To: oleg@redhat.com, jan.kratochvil@redhat.com, vda.linux@googlemail.com
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, indan@nul.nu, bdonlan@gmail.com,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 6/9] job control: make task_clear_jobctl_pending() clear TRAPPING automatically
Date: Fri, 13 May 2011 17:46:17 +0200
Message-Id: <1305301580-9924-7-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1305301580-9924-1-git-send-email-tj@kernel.org>
References: <1305301580-9924-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

JOBCTL_TRAPPING indicates that ptracer is waiting for tracee to
(re)transit into TRACED.  task_clear_jobctl_pending() must be called
when either tracee enters TRACED or the transition is cancelled for
some reason.  The former is achieved by explicitly calling
task_clear_jobctl_pending() in ptrace_stop() and the latter by calling
it at the end of do_signal_stop().

Calling task_clear_jobctl_trapping() at the end of do_signal_stop()
limits the scope TRAPPING can be used and is fragile in that seemingly
unrelated changes to tracee's control flow can lead to stuck TRAPPING.

We already have task_clear_jobctl_pending() calls on those cancelling
events to clear JOBCTL_STOP_PENDING.  Cancellations can be handled by
making those call sites use JOBCTL_PENDING_MASK instead and updating
task_clear_jobctl_pending() such that task_clear_jobctl_trapping() is
called automatically if no stop/trap is pending.

This patch makes the above changes and removes the fallback
task_clear_jobctl_trapping() call from do_signal_stop().

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 fs/exec.c       |    2 +-
 kernel/signal.c |   13 ++++++++-----
 2 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/fs/exec.c b/fs/exec.c
index c654664..6ef8958 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1659,7 +1659,7 @@ static int zap_process(struct task_struct *start, int exit_code)
 
 	t = start;
 	do {
-		task_clear_jobctl_pending(t, JOBCTL_STOP_PENDING);
+		task_clear_jobctl_pending(t, JOBCTL_PENDING_MASK);
 		if (t != current && t->mm) {
 			sigaddset(&t->pending.signal, SIGKILL);
 			signal_wake_up(t, 1);
diff --git a/kernel/signal.c b/kernel/signal.c
index e67eaa0..91e57d3 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -253,6 +253,9 @@ static void task_clear_jobctl_trapping(struct task_struct *task)
  * %JOBCTL_PENDING_MASK.  If %JOBCTL_STOP_PENDING is being cleared, other
  * STOP bits are cleared together.
  *
+ * If clearing of @mask leaves no stop or trap pending, this function calls
+ * task_clear_jobctl_trapping().
+ *
  * CONTEXT:
  * Must be called with @task->sighand->siglock held.
  */
@@ -264,6 +267,9 @@ void task_clear_jobctl_pending(struct task_struct *task, unsigned int mask)
 		mask |= JOBCTL_STOP_CONSUME | JOBCTL_STOP_DEQUEUED;
 
 	task->jobctl &= ~mask;
+
+	if (!(task->jobctl & JOBCTL_PENDING_MASK))
+		task_clear_jobctl_trapping(task);
 }
 
 /**
@@ -933,7 +939,7 @@ static void complete_signal(int sig, struct task_struct *p, int group)
 			signal->group_stop_count = 0;
 			t = p;
 			do {
-				task_clear_jobctl_pending(t, JOBCTL_STOP_PENDING);
+				task_clear_jobctl_pending(t, JOBCTL_PENDING_MASK);
 				sigaddset(&t->pending.signal, SIGKILL);
 				signal_wake_up(t, 1);
 			} while_each_thread(p, t);
@@ -1168,7 +1174,7 @@ int zap_other_threads(struct task_struct *p)
 	p->signal->group_stop_count = 0;
 
 	while_each_thread(p, t) {
-		task_clear_jobctl_pending(t, JOBCTL_STOP_PENDING);
+		task_clear_jobctl_pending(t, JOBCTL_PENDING_MASK);
 		count++;
 
 		/* Don't bother with already dead threads */
@@ -1964,9 +1970,6 @@ retry:
 		goto retry;
 	}
 
-	/* PTRACE_ATTACH might have raced with task killing, clear trapping */
-	task_clear_jobctl_trapping(current);
-
 	spin_unlock_irq(&current->sighand->siglock);
 
 	tracehook_finish_jctl();
-- 
1.7.1

