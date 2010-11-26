Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755203Ab0KZKvv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 05:51:51 -0500
Received: from hera.kernel.org ([140.211.167.34]:42319 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754860Ab0KZKu0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 05:50:26 -0500
From: Tejun Heo <tj@kernel.org>
To: roland@redhat.com, oleg@redhat.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        "rjw@sisk.plpavel"@ucw.cz
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 07/14] ptrace: add @why to ptrace_stop()
Date: Fri, 26 Nov 2010 11:49:22 +0100
Message-Id: <1290768569-16224-8-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1290768569-16224-1-git-send-email-tj@kernel.org>
References: <1290768569-16224-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 26 Nov 2010 10:49:49 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To prepare for cleanup of the interaction between group stop and
ptrace, add @why to ptrace_stop().  Existing users are updateda such
that there is no behavior change.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/signal.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/kernel/signal.c b/kernel/signal.c
index b859690..3b3e69c 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -1633,7 +1633,7 @@ static int sigkill_pending(struct task_struct *tsk)
  * If we actually decide not to stop at all because the tracer
  * is gone, we keep current->exit_code unless clear_code.
  */
-static void ptrace_stop(int exit_code, int clear_code, siginfo_t *info)
+static void ptrace_stop(int exit_code, int why, int clear_code, siginfo_t *info)
 	__releases(&current->sighand->siglock)
 	__acquires(&current->sighand->siglock)
 {
@@ -1671,7 +1671,7 @@ static void ptrace_stop(int exit_code, int clear_code, siginfo_t *info)
 	spin_unlock_irq(&current->sighand->siglock);
 	read_lock(&tasklist_lock);
 	if (may_ptrace_stop()) {
-		do_notify_parent_cldstop(current, CLD_TRAPPED);
+		do_notify_parent_cldstop(current, why);
 		/*
 		 * Don't want to allow preemption here, because
 		 * sys_ptrace() needs this task to be inactive.
@@ -1730,7 +1730,7 @@ void ptrace_notify(int exit_code)
 
 	/* Let the debugger run.  */
 	spin_lock_irq(&current->sighand->siglock);
-	ptrace_stop(exit_code, 1, &info);
+	ptrace_stop(exit_code, CLD_TRAPPED, 1, &info);
 	spin_unlock_irq(&current->sighand->siglock);
 }
 
@@ -1826,7 +1826,7 @@ static int ptrace_signal(int signr, siginfo_t *info,
 	ptrace_signal_deliver(regs, cookie);
 
 	/* Let the debugger run.  */
-	ptrace_stop(signr, 0, info);
+	ptrace_stop(signr, CLD_TRAPPED, 0, info);
 
 	/* We're back.  Did the debugger cancel the sig?  */
 	signr = current->exit_code;
-- 
1.7.1

