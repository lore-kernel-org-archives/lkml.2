Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753527Ab2L1MnL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2012 07:43:11 -0500
Received: from alvesta.synopsys.com ([198.182.60.77]:50906 "EHLO
	alvesta.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751318Ab2L1MnI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2012 07:43:08 -0500
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
To: <viro@ZenIV.linux.org.uk>
CC: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Vineet Gupta <Vineet.Gupta1@synopsys.com>
Subject: [PATCH 2/2] ARC: [Review] Prevent incorrect syscall restarts
Date: Fri, 28 Dec 2012 18:12:37 +0530
Message-ID: <1356698557-9000-2-git-send-email-vgupta@synopsys.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1356698557-9000-1-git-send-email-vgupta@synopsys.com>
References: <50DD91C1.3000809@synopsys.com>
 <1356698557-9000-1-git-send-email-vgupta@synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.12.197.205]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Per Al Viro's "signals for dummies" https://lkml.org/lkml/2012/12/6/366
there are 3 golden rules for (not) restarting syscalls:

"	What we need to guarantee is
* restarts do not happen on signals caught in interrupts or exceptions
* restarts do not happen on signals caught in sigreturn()
* restart should happen only once, even if we get through do_signal()
  many times."

ARC Port already handled #1, this patch fixes #2 and #3.

We use the additional state in pt_regs->orig_r8 to ckh if restarting
has already been done once.

Thanks to Al Viro for spotting this.

Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
---
 arch/arc/include/asm/ptrace.h |    3 +++
 arch/arc/kernel/signal.c      |   12 ++++++++----
 2 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/arch/arc/include/asm/ptrace.h b/arch/arc/include/asm/ptrace.h
index 7daa3a6..caf216e 100644
--- a/arch/arc/include/asm/ptrace.h
+++ b/arch/arc/include/asm/ptrace.h
@@ -93,6 +93,9 @@ struct user_regs_struct {
 #define in_syscall(regs) (regs->orig_r8 & orig_r8_IS_SCALL)
 #define in_brkpt_trap(regs) (regs->orig_r8 & orig_r8_IS_BRKPT)
 
+#define syscall_wont_restart(regs) (regs->orig_r8 |= orig_r8_IS_SCALL_RESTARTED)
+#define syscall_restartable(regs) !(regs->orig_r8 & orig_r8_IS_SCALL_RESTARTED)
+
 #define current_pt_regs()					\
 ({								\
 	/* open-coded current_thread_info() */			\
diff --git a/arch/arc/kernel/signal.c b/arch/arc/kernel/signal.c
index 464af3f..6671968 100644
--- a/arch/arc/kernel/signal.c
+++ b/arch/arc/kernel/signal.c
@@ -137,6 +137,9 @@ SYSCALL_DEFINE0(rt_sigreturn)
 		if (do_sigaltstack(&sf->uc.uc_stack, NULL, regs->sp) == -EFAULT)
 			goto badframe;
 
+	/* Don't restart from sigreturn */
+	syscall_wont_restart(regs);
+
 	return regs->r0;
 
 badframe:
@@ -331,13 +334,13 @@ void do_signal(struct pt_regs *regs)
 
 	signr = get_signal_to_deliver(&info, &ka, regs, NULL);
 
-	/* Are we from a system call? */
-	restart_scall = in_syscall(regs);
+	restart_scall = in_syscall(regs) && syscall_restartable(regs);
 
 	if (signr > 0) {
-		if (restart_scall)
+		if (restart_scall) {
 			arc_restart_syscall(&ka, regs);
-
+			syscall_wont_restart(regs);	/* No more restarts */
+		}
 		handle_signal(signr, &ka, &info, regs);
 		return;
 	}
@@ -352,6 +355,7 @@ void do_signal(struct pt_regs *regs)
 			regs->r8 = __NR_restart_syscall;
 			regs->ret -= 4;
 		}
+		syscall_wont_restart(regs);	/* No more restarts */
 	}
 
 	/* If there's no signal to deliver, restore the saved sigmask back */
-- 
1.7.4.1

