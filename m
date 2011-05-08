Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932108Ab1EHPuf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 May 2011 11:50:35 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:42994 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754877Ab1EHPt3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 May 2011 11:49:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=BHmo3Nd6bWFTM+yl14QOineS92jQ6s/VQHUbdC/MDKqJBcXnfX2W5RLFX0DLWzWoGr
         1/8/66oyZgXa0aaIb37w/bNU9HzUeyEwnBTp20K8alOvWVbKouh1Vhxw0g2eldJVddcV
         ndPy2sbUe71PJTl4bTtBtRGQRfE+bPr4cCKfo=
From: Tejun Heo <tj@kernel.org>
To: oleg@redhat.com, jan.kratochvil@redhat.com, vda.linux@googlemail.com
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, indan@nul.nu, Tejun Heo <tj@kernel.org>
Subject: [PATCH 07/11] ptrace: add JOBCTL_TRAPPED
Date: Sun,  8 May 2011 17:49:01 +0200
Message-Id: <1304869745-1073-8-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1304869745-1073-1-git-send-email-tj@kernel.org>
References: <1304869745-1073-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For to-be-added end of group stop notification, ptracer needs to tell
whether tracee is in group stop or INTERRUPT trap.  Add JOBCTL_TRAPPED
flag which is set when tracee commits to group stop or INTERRUPT trap
in ptrace_stop() and cleared when leaving ptrace_stop().

The flag isn't yet used and doesn't cause any behavior difference.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 include/linux/sched.h |    1 +
 kernel/signal.c       |    9 +++++++++
 2 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 221ab51..9d92444 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1787,6 +1787,7 @@ extern void thread_group_times(struct task_struct *p, cputime_t *ut, cputime_t *
 #define JOBCTL_TRAP_SEIZE	(1 << 19) /* trap for seize */
 #define JOBCTL_TRAP_INTERRUPT	(1 << 20) /* trap for interrupt */
 #define JOBCTL_TRAPPING		(1 << 22) /* switching to TRACED */
+#define JOBCTL_TRAPPED		(1 << 23) /* trapped for group stop */
 
 #define JOBCTL_TRAP_MASK	(JOBCTL_TRAP_SEIZE | JOBCTL_TRAP_INTERRUPT)
 #define JOBCTL_PENDING_MASK	(JOBCTL_STOP_PENDING | JOBCTL_TRAP_MASK)
diff --git a/kernel/signal.c b/kernel/signal.c
index 9705f5d..208f061 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -1764,6 +1764,14 @@ static void ptrace_stop(int exit_code, int why, int clear_code, siginfo_t *info)
 	if (is_intr)
 		current->jobctl &= ~JOBCTL_TRAP_INTERRUPT;
 
+	/*
+	 * Traps for both actual group stop and INTERRUPT are considered
+	 * trapped for job control and have TRAPPED set.  This enables
+	 * end-of-group-stop retrapping of INTERRUPTed tracees.
+	 */
+	if (why == CLD_STOPPED || is_intr)
+		current->jobctl |= JOBCTL_TRAPPED;
+
 	spin_unlock_irq(&current->sighand->siglock);
 	read_lock(&tasklist_lock);
 	if (may_ptrace_stop()) {
@@ -1824,6 +1832,7 @@ static void ptrace_stop(int exit_code, int why, int clear_code, siginfo_t *info)
 	 * any signal-sending on another CPU that wants to examine it.
 	 */
 	spin_lock_irq(&current->sighand->siglock);
+	current->jobctl &= ~JOBCTL_TRAPPED;
 	current->last_siginfo = NULL;
 
 	/*
-- 
1.7.1

