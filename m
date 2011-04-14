Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933511Ab1DNRt6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 13:49:58 -0400
Received: from mail.windriver.com ([147.11.1.11]:38610 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933473Ab1DNRr1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 13:47:27 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, "David S. Miller" <davem@davemloft.net>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 110/209] sparc: Prevent no-handler signal syscall restart recursion.
Date: Thu, 14 Apr 2011 13:42:20 -0400
Message-Id: <1302803039-9400-111-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1302803039-9400-1-git-send-email-paul.gortmaker@windriver.com>
References: <1302803039-9400-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David S. Miller <davem@davemloft.net>

  =====================================================================
  | This is a commit scheduled for the next v2.6.34 longterm release. |
  | If you see a problem with using this for longterm, please comment.|
  =====================================================================

commit c27852597829128a9c9d96d79ec454a83c6b0da5 upstream.

Explicitly clear the "in-syscall" bit when we have no signal
handler and back up the program counters to back up the system
call.

Reported-by: Al Viro <viro@ZenIV.linux.org.uk>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 arch/sparc/kernel/signal32.c  |    4 +++-
 arch/sparc/kernel/signal_32.c |    2 ++
 arch/sparc/kernel/signal_64.c |    2 ++
 3 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/arch/sparc/kernel/signal32.c b/arch/sparc/kernel/signal32.c
index 643a354..75fad42 100644
--- a/arch/sparc/kernel/signal32.c
+++ b/arch/sparc/kernel/signal32.c
@@ -616,7 +616,7 @@ static int setup_frame32(struct k_sigaction *ka, struct pt_regs *regs,
 
 		flush_signal_insns(address);
 	}
-	return;
+	return 0;
 
 sigill:
 	do_exit(SIGILL);
@@ -840,12 +840,14 @@ void do_signal32(sigset_t *oldset, struct pt_regs * regs,
 		regs->u_regs[UREG_I0] = orig_i0;
 		regs->tpc -= 4;
 		regs->tnpc -= 4;
+		pt_regs_clear_syscall(regs);
 	}
 	if (restart_syscall &&
 	    regs->u_regs[UREG_I0] == ERESTART_RESTARTBLOCK) {
 		regs->u_regs[UREG_G1] = __NR_restart_syscall;
 		regs->tpc -= 4;
 		regs->tnpc -= 4;
+		pt_regs_clear_syscall(regs);
 	}
 
 	/* If there's no signal to deliver, we just put the saved sigmask
diff --git a/arch/sparc/kernel/signal_32.c b/arch/sparc/kernel/signal_32.c
index 99c85e9..5e5c5fd 100644
--- a/arch/sparc/kernel/signal_32.c
+++ b/arch/sparc/kernel/signal_32.c
@@ -580,12 +580,14 @@ static void do_signal(struct pt_regs *regs, unsigned long orig_i0)
 		regs->u_regs[UREG_I0] = orig_i0;
 		regs->pc -= 4;
 		regs->npc -= 4;
+		pt_regs_clear_syscall(regs);
 	}
 	if (restart_syscall &&
 	    regs->u_regs[UREG_I0] == ERESTART_RESTARTBLOCK) {
 		regs->u_regs[UREG_G1] = __NR_restart_syscall;
 		regs->pc -= 4;
 		regs->npc -= 4;
+		pt_regs_clear_syscall(regs);
 	}
 
 	/* if there's no signal to deliver, we just put the saved sigmask
diff --git a/arch/sparc/kernel/signal_64.c b/arch/sparc/kernel/signal_64.c
index 3f19e67..006fe45 100644
--- a/arch/sparc/kernel/signal_64.c
+++ b/arch/sparc/kernel/signal_64.c
@@ -600,12 +600,14 @@ static void do_signal(struct pt_regs *regs, unsigned long orig_i0)
 		regs->u_regs[UREG_I0] = orig_i0;
 		regs->tpc -= 4;
 		regs->tnpc -= 4;
+		pt_regs_clear_syscall(regs);
 	}
 	if (restart_syscall &&
 	    regs->u_regs[UREG_I0] == ERESTART_RESTARTBLOCK) {
 		regs->u_regs[UREG_G1] = __NR_restart_syscall;
 		regs->tpc -= 4;
 		regs->tnpc -= 4;
+		pt_regs_clear_syscall(regs);
 	}
 
 	/* If there's no signal to deliver, we just put the saved sigmask
-- 
1.7.4.4

