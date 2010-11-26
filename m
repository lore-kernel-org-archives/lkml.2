Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754845Ab0KZKuV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 05:50:21 -0500
Received: from hera.kernel.org ([140.211.167.34]:42296 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754635Ab0KZKuN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 05:50:13 -0500
From: Tejun Heo <tj@kernel.org>
To: roland@redhat.com, oleg@redhat.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        "rjw@sisk.plpavel"@ucw.cz
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 08/14] ptrace: make do_signal_stop() use ptrace_stop() if the task is being ptraced
Date: Fri, 26 Nov 2010 11:49:23 +0100
Message-Id: <1290768569-16224-9-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1290768569-16224-1-git-send-email-tj@kernel.org>
References: <1290768569-16224-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 26 Nov 2010 10:49:50 +0000 (UTC)
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

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Roland McGrath <roland@redhat.com>
---
 kernel/signal.c |   31 ++++++++++++++++++-------------
 1 files changed, 18 insertions(+), 13 deletions(-)

diff --git a/kernel/signal.c b/kernel/signal.c
index 3b3e69c..6d78da6 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -1788,10 +1788,8 @@ static int do_signal_stop(int signr)
 	 * we test GROUP_STOP_PENDING again.  If SIGCONT or SIGKILL
 	 * comes in between, it would be clear.
 	 */
-	if (!(current->group_stop & GROUP_STOP_PENDING)) {
-		spin_unlock_irq(&current->sighand->siglock);
-		goto out;
-	}
+	if (!(current->group_stop & GROUP_STOP_PENDING))
+		goto out_unlock;
 
 	if (consume_group_stop())
 		sig->flags = SIGNAL_STOP_STOPPED;
@@ -1800,17 +1798,24 @@ static int do_signal_stop(int signr)
 	current->group_stop &= ~GROUP_STOP_PENDING;
 	__set_current_state(TASK_STOPPED);
 
-	spin_unlock_irq(&current->sighand->siglock);
+	if (likely(!task_ptrace(current))) {
+		spin_unlock_irq(&current->sighand->siglock);
 
-	if (notify) {
-		read_lock(&tasklist_lock);
-		do_notify_parent_cldstop(current, notify);
-		read_unlock(&tasklist_lock);
-	}
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
+out_unlock:
+	spin_unlock_irq(&current->sighand->siglock);
 
-	/* Now we don't run again until woken by SIGCONT or SIGKILL */
-	schedule();
-out:
 	tracehook_finish_jctl();
 	current->exit_code = 0;
 
-- 
1.7.1

