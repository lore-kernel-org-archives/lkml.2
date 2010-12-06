Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754073Ab0LFQ6n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 11:58:43 -0500
Received: from hera.kernel.org ([140.211.167.34]:59728 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754058Ab0LFQ6m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 11:58:42 -0500
From: Tejun Heo <tj@kernel.org>
To: oleg@redhat.com, roland@redhat.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org, rjw@sisk.pl,
        jan.kratochvil@redhat.com
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 09/16] ptrace: make do_signal_stop() use ptrace_stop() if the task is being ptraced
Date: Mon,  6 Dec 2010 17:56:57 +0100
Message-Id: <1291654624-6230-10-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1291654624-6230-1-git-send-email-tj@kernel.org>
References: <1291654624-6230-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 06 Dec 2010 16:57:40 +0000 (UTC)
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

Oleg spotted a minor userland visible change.  In some cases, the
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
index faf218b..a6bc4cf 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -1785,7 +1785,6 @@ void ptrace_notify(int exit_code)
 static int do_signal_stop(int signr)
 {
 	struct signal_struct *sig = current->signal;
-	int notify = 0;
 
 	if (!(current->group_stop & GROUP_STOP_PENDING)) {
 		unsigned int gstop = GROUP_STOP_PENDING | GROUP_STOP_CONSUME;
@@ -1815,29 +1814,37 @@ static int do_signal_stop(int signr)
 			} else
 				task_clear_group_stop(t);
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

