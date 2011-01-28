Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754778Ab1A1PJL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jan 2011 10:09:11 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:51211 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753169Ab1A1PJH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jan 2011 10:09:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=EkYBuaqMiSmN9+XNhC6V3J5WwnmkEKxwRxK/AcvdA7tJdaOzr1jEKKZBlVvyCXZDGn
         05uq1ts6YHh0WIZ+8YyQVfp5gxXSeMjX3XuQlX9ZTosz1v//2v/0tM4Frd7Gi3z01QR6
         SdvsE/wjUbDIhhfFM/G1IZc7i+mJaJsupIeFM=
From: Tejun Heo <tj@kernel.org>
To: roland@redhat.com, oleg@redhat.com, jan.kratochvil@redhat.com,
        linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 05/10] ptrace: add @why to ptrace_stop()
Date: Fri, 28 Jan 2011 16:08:39 +0100
Message-Id: <1296227324-25295-6-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1296227324-25295-1-git-send-email-tj@kernel.org>
References: <1296227324-25295-1-git-send-email-tj@kernel.org>
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
index 7dc0ca2..4569801 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -1617,7 +1617,7 @@ static int sigkill_pending(struct task_struct *tsk)
  * If we actually decide not to stop at all because the tracer
  * is gone, we keep current->exit_code unless clear_code.
  */
-static void ptrace_stop(int exit_code, int clear_code, siginfo_t *info)
+static void ptrace_stop(int exit_code, int why, int clear_code, siginfo_t *info)
 	__releases(&current->sighand->siglock)
 	__acquires(&current->sighand->siglock)
 {
@@ -1655,7 +1655,7 @@ static void ptrace_stop(int exit_code, int clear_code, siginfo_t *info)
 	spin_unlock_irq(&current->sighand->siglock);
 	read_lock(&tasklist_lock);
 	if (may_ptrace_stop()) {
-		do_notify_parent_cldstop(current, CLD_TRAPPED);
+		do_notify_parent_cldstop(current, why);
 		/*
 		 * Don't want to allow preemption here, because
 		 * sys_ptrace() needs this task to be inactive.
@@ -1714,7 +1714,7 @@ void ptrace_notify(int exit_code)
 
 	/* Let the debugger run.  */
 	spin_lock_irq(&current->sighand->siglock);
-	ptrace_stop(exit_code, 1, &info);
+	ptrace_stop(exit_code, CLD_TRAPPED, 1, &info);
 	spin_unlock_irq(&current->sighand->siglock);
 }
 
@@ -1795,7 +1795,7 @@ static int ptrace_signal(int signr, siginfo_t *info,
 	ptrace_signal_deliver(regs, cookie);
 
 	/* Let the debugger run.  */
-	ptrace_stop(signr, 0, info);
+	ptrace_stop(signr, CLD_TRAPPED, 0, info);
 
 	/* We're back.  Did the debugger cancel the sig?  */
 	signr = current->exit_code;
-- 
1.7.1

