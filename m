Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755274Ab1A1PJZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jan 2011 10:09:25 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:60587 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754924Ab1A1PJR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jan 2011 10:09:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=cSGePmZAYt7ptE5swElB9fcRcwYg09XRsJ5EIpyUrZoke4/zW4FURW8tDlwmyLs7a+
         kBz0pqT7scflD3TZ2GvurpYOKfDsUoTP98Yus8yQmTkeze4Tu3RabD+Fraxd+n/exz6T
         njTh+1bb5sCy9N4IIyzQBj7Yo0c08vCMdbmk8=
From: Tejun Heo <tj@kernel.org>
To: roland@redhat.com, oleg@redhat.com, jan.kratochvil@redhat.com,
        linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 09/10] ptrace: make do_signal_stop() use ptrace_stop() if the task is being ptraced
Date: Fri, 28 Jan 2011 16:08:43 +0100
Message-Id: <1296227324-25295-10-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1296227324-25295-1-git-send-email-tj@kernel.org>
References: <1296227324-25295-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A ptraced task would still stop at do_signal_stop() when it's stopping
for stop signals and do_signal_stop() behaves the same whether the
task is ptraced or not.  However, in addition to stopping,
ptrace_stop() also does ptrace specific stuff like calling
architecture specific callbacks, so this behavior makes the code more
fragile and difficult to understand.

This patch makes do_signal_stop() test whether the task is ptraced and
use ptrace_stop() if so.  This renders tracehook_notify_jctl() rather
pointless as the ptrace notification is now handled by ptrace_stop()
regardless of the return value from the tracehook.  It probably is a
good idea to update it.

This doesn't solve the whole problem as tasks already in stopped state
would stay in the regular stop when ptrace attached.  That part will
be handled by the next patch.

Oleg pointed out that this makes a userland-visible change.  Before,
SIGCONT would be able to wake up a task in group stop even if the task
is ptraced if the tracer hasn't issued another ptrace command
afterwards (as the next ptrace commands transitions the state into
TASK_TRACED which ignores SIGCONT wakeups).  With this and the next
patch, SIGCONT may race with the transition into TASK_TRACED and is
ignored if the tracee already entered TASK_TRACED.

Another userland visible change of this and the next patch is that the
ptracee's state would now be TASK_TRACED where it used to be
TASK_STOPPED, which is visible via fs/proc.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Roland McGrath <roland@redhat.com>
Cc: Jan Kratochvil <jan.kratochvil@redhat.com>
---
 kernel/signal.c |   43 +++++++++++++++++++++++++------------------
 1 files changed, 25 insertions(+), 18 deletions(-)

diff --git a/kernel/signal.c b/kernel/signal.c
index 2e20dad..4404474 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -1783,7 +1783,6 @@ void ptrace_notify(int exit_code)
 static int do_signal_stop(int signr)
 {
 	struct signal_struct *sig = current->signal;
-	int notify = 0;
 
 	if (!(current->group_stop & GROUP_STOP_PENDING)) {
 		unsigned int gstop = GROUP_STOP_PENDING | GROUP_STOP_CONSUME;
@@ -1813,29 +1812,37 @@ static int do_signal_stop(int signr)
 			} else
 				task_clear_group_stop_pending(t);
 	}
-	/*
-	 * If there are no other threads in the group, or if there is
-	 * a group stop in progress and we are the last to stop, report
-	 * to the parent.  When ptraced, every thread reports itself.
-	 */
-	if (task_participate_group_stop(current))
-		notify = CLD_STOPPED;
-	if (task_ptrace(current))
-		notify = CLD_STOPPED;
 
 	current->exit_code = sig->group_exit_code;
 	__set_current_state(TASK_STOPPED);
 
-	spin_unlock_irq(&current->sighand->siglock);
+	if (likely(!task_ptrace(current))) {
+		int notify = 0;
 
-	if (notify) {
-		read_lock(&tasklist_lock);
-		do_notify_parent_cldstop(current, notify);
-		read_unlock(&tasklist_lock);
-	}
+		/*
+		 * If there are no other threads in the group, or if there
+		 * is a group stop in progress and we are the last to stop,
+		 * report to the parent.
+		 */
+		if (task_participate_group_stop(current))
+			notify = CLD_STOPPED;
 
-	/* Now we don't run again until woken by SIGCONT or SIGKILL */
-	schedule();
+		spin_unlock_irq(&current->sighand->siglock);
+
+		if (notify) {
+			read_lock(&tasklist_lock);
+			do_notify_parent_cldstop(current, notify);
+			read_unlock(&tasklist_lock);
+		}
+
+		/* Now we don't run again until woken by SIGCONT or SIGKILL */
+		schedule();
+
+		spin_lock_irq(&current->sighand->siglock);
+	} else
+		ptrace_stop(current->exit_code, CLD_STOPPED, 0, NULL);
+
+	spin_unlock_irq(&current->sighand->siglock);
 
 	tracehook_finish_jctl();
 	current->exit_code = 0;
-- 
1.7.1

