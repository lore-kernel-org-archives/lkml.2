Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932945Ab1EXSiF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 14:38:05 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:60946 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932797Ab1EXSh6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 14:37:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=rafEh4uUj74r+/G3O7Rc2cZeNconh5Ow+e/F6mMZ+UdxPKzBq7HBFyeTLJgIuwhFCj
         iAHaJJvNgObT90cMJVsSD0N1UN6yaNH21J46H/yGUjpOTwunS3R1IXGH8cTsCgEYawg+
         nDT42woSpAIr9TASCiK5OMWsWxe/YyS0KpL7c=
From: Tejun Heo <tj@kernel.org>
To: oleg@redhat.com
Cc: vda.linux@googlemail.com, jan.kratochvil@redhat.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, indan@nul.nu, bdonlan@gmail.com,
        pedro@codesourcery.com, Tejun Heo <tj@kernel.org>
Subject: [PATCH 06/19] job control: introduce task_set_jobctl_pending()
Date: Tue, 24 May 2011 20:37:26 +0200
Message-Id: <1306262259-7285-7-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1306262259-7285-1-git-send-email-tj@kernel.org>
References: <1306262259-7285-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

task->jobctl currently hosts JOBCTL_STOP_PENDING and will host TRAP
pending bits too.  Setting pending conditions on a dying task may make
the task unkillable.  Currently, each setting site is responsible for
checking for the condition but with to-be-added job control traps this
becomes too fragile.

This patch adds task_set_jobctl_pending() which should be used when
setting task->jobctl bits to schedule a stop or trap.  The function
performs the followings to ease setting pending bits.

* Sanity checks.

* If fatal signal is pending or PF_EXITING is set, no bit is set.

* STOP_SIGMASK is automatically cleared if new value is being set.

do_signal_stop() and ptrace_attach() are updated to use
task_set_jobctl_pending() instead of setting STOP_PENDING explicitly.
The surrounding structures around setting are changed to fit
task_set_jobctl_pending() better but there should be no userland
visible behavior difference.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>
---
 include/linux/sched.h |    2 ++
 kernel/ptrace.c       |    5 +++--
 kernel/signal.c       |   46 ++++++++++++++++++++++++++++++++++++++++------
 3 files changed, 45 insertions(+), 8 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index e0ce64c..8519614 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1803,6 +1803,8 @@ extern void thread_group_times(struct task_struct *p, cputime_t *ut, cputime_t *
 
 #define JOBCTL_PENDING_MASK	JOBCTL_STOP_PENDING
 
+extern bool task_set_jobctl_pending(struct task_struct *task,
+				    unsigned int mask);
 extern void task_clear_jobctl_pending(struct task_struct *task,
 				      unsigned int mask);
 
diff --git a/kernel/ptrace.c b/kernel/ptrace.c
index abf6383..b44dc43 100644
--- a/kernel/ptrace.c
+++ b/kernel/ptrace.c
@@ -257,8 +257,9 @@ static int ptrace_attach(struct task_struct *task)
 	 * The following task_is_stopped() test is safe as both transitions
 	 * in and out of STOPPED are protected by siglock.
 	 */
-	if (task_is_stopped(task)) {
-		task->jobctl |= JOBCTL_STOP_PENDING | JOBCTL_TRAPPING;
+	if (task_is_stopped(task) &&
+	    task_set_jobctl_pending(task,
+				    JOBCTL_STOP_PENDING | JOBCTL_TRAPPING)) {
 		signal_wake_up(task, 1);
 		wait_trap = true;
 	}
diff --git a/kernel/signal.c b/kernel/signal.c
index 16826c4..17feedf 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -224,6 +224,39 @@ static inline void print_dropped_signal(int sig)
 }
 
 /**
+ * task_set_jobctl_pending - set jobctl pending bits
+ * @task: target task
+ * @mask: pending bits to set
+ *
+ * Clear @mask from @task->jobctl.  @mask must be subset of
+ * %JOBCTL_PENDING_MASK | %JOBCTL_STOP_CONSUME | %JOBCTL_STOP_SIGMASK |
+ * %JOBCTL_TRAPPING.  If stop signo is being set, the existing signo is
+ * cleared.  If @task is already being killed or exiting, this function
+ * becomes noop.
+ *
+ * CONTEXT:
+ * Must be called with @task->sighand->siglock held.
+ *
+ * RETURNS:
+ * %true if @mask is set, %false if made noop because @task was dying.
+ */
+bool task_set_jobctl_pending(struct task_struct *task, unsigned int mask)
+{
+	BUG_ON(mask & ~(JOBCTL_PENDING_MASK | JOBCTL_STOP_CONSUME |
+			JOBCTL_STOP_SIGMASK | JOBCTL_TRAPPING));
+	BUG_ON((mask & JOBCTL_TRAPPING) && !(mask & JOBCTL_PENDING_MASK));
+
+	if (unlikely(fatal_signal_pending(task) || (task->flags & PF_EXITING)))
+		return false;
+
+	if (mask & JOBCTL_STOP_SIGMASK)
+		task->jobctl &= ~JOBCTL_STOP_SIGMASK;
+
+	task->jobctl |= mask;
+	return true;
+}
+
+/**
  * task_clear_jobctl_trapping - clear jobctl trapping bit
  * @task: target task
  *
@@ -1902,19 +1935,20 @@ static int do_signal_stop(int signr)
 		else
 			WARN_ON_ONCE(!task_ptrace(current));
 
-		current->jobctl &= ~JOBCTL_STOP_SIGMASK;
-		current->jobctl |= signr | gstop;
-		sig->group_stop_count = 1;
+		sig->group_stop_count = 0;
+
+		if (task_set_jobctl_pending(current, signr | gstop))
+			sig->group_stop_count++;
+
 		for (t = next_thread(current); t != current;
 		     t = next_thread(t)) {
-			t->jobctl &= ~JOBCTL_STOP_SIGMASK;
 			/*
 			 * Setting state to TASK_STOPPED for a group
 			 * stop is always done with the siglock held,
 			 * so this check has no races.
 			 */
-			if (!(t->flags & PF_EXITING) && !task_is_stopped(t)) {
-				t->jobctl |= signr | gstop;
+			if (!task_is_stopped(t) &&
+			    task_set_jobctl_pending(t, signr | gstop)) {
 				sig->group_stop_count++;
 				signal_wake_up(t, 0);
 			}
-- 
1.7.1

