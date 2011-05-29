Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756607Ab1E2XP6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 May 2011 19:15:58 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:53557 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753532Ab1E2XM4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 May 2011 19:12:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=UQzdAnFMs3/jJJ3OpUAkWbwhUlpeiLFTh6hQYidrJO4t5Cv8KWN7FZSR0EfhTqQ3Rk
         sf3y+DuqjkXdRzVUHF5ZXBAG1N//ZwyjcnuusgYKjRPp+vk8lHTOwD9Get1z++HWkyXI
         EgP3FXmFvAekElDkdIOSxlbKCKzSdafbClkLo=
From: Tejun Heo <tj@kernel.org>
To: oleg@redhat.com
Cc: vda.linux@googlemail.com, jan.kratochvil@redhat.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, indan@nul.nu, bdonlan@gmail.com,
        pedro@codesourcery.com, Tejun Heo <tj@kernel.org>
Subject: [PATCH 04/17] ptrace: relocate set_current_state(TASK_TRACED) in ptrace_stop()
Date: Mon, 30 May 2011 01:12:27 +0200
Message-Id: <1306710760-16440-5-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.5.2
In-Reply-To: <1306710760-16440-1-git-send-email-tj@kernel.org>
References: <1306710760-16440-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In ptrace_stop(), after arch hook is done, the task state and jobctl
bits are updated while holding siglock.  The ordering requirement
there is that TASK_TRACED is set before JOBCTL_TRAPPING is cleared to
prevent ptracer waiting on TRAPPING doesn't end up waking up TRACED is
actually set and sees TASK_RUNNING in wait(2).

Move set_current_state(TASK_TRACED) to the top of the block and
reorganize comments.  This makes the ordering more obvious
(TASK_TRACED before other updates) and helps future updates to group
stop participation.

This patch doesn't cause any functional change.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/signal.c |   28 +++++++++++++---------------
 1 files changed, 13 insertions(+), 15 deletions(-)

diff --git a/kernel/signal.c b/kernel/signal.c
index ab6851c..62a6c3b 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -1733,6 +1733,18 @@ static void ptrace_stop(int exit_code, int why, int clear_code, siginfo_t *info)
 	}
 
 	/*
+	 * We're committing to trapping.  TRACED should be visible before
+	 * TRAPPING is cleared; otherwise, the tracer might fail do_wait().
+	 * Also, transition to TRACED and updates to ->jobctl should be
+	 * atomic with respect to siglock and should be done after the arch
+	 * hook as siglock is released and regrabbed across it.
+	 */
+	set_current_state(TASK_TRACED);
+
+	current->last_siginfo = info;
+	current->exit_code = exit_code;
+
+	/*
 	 * If @why is CLD_STOPPED, we're trapping to participate in a group
 	 * stop.  Do the bookkeeping.  Note that if SIGCONT was delievered
 	 * while siglock was released for the arch hook, PENDING could be
@@ -1742,21 +1754,7 @@ static void ptrace_stop(int exit_code, int why, int clear_code, siginfo_t *info)
 	if (why == CLD_STOPPED && (current->jobctl & JOBCTL_STOP_PENDING))
 		gstop_done = task_participate_group_stop(current);
 
-	current->last_siginfo = info;
-	current->exit_code = exit_code;
-
-	/*
-	 * TRACED should be visible before TRAPPING is cleared; otherwise,
-	 * the tracer might fail do_wait().
-	 */
-	set_current_state(TASK_TRACED);
-
-	/*
-	 * We're committing to trapping.  Clearing JOBCTL_TRAPPING and
-	 * transition to TASK_TRACED should be atomic with respect to
-	 * siglock.  This should be done after the arch hook as siglock is
-	 * released and regrabbed across it.
-	 */
+	/* entering a trap, clear TRAPPING */
 	task_clear_jobctl_trapping(current);
 
 	spin_unlock_irq(&current->sighand->siglock);
-- 
1.7.5.2

