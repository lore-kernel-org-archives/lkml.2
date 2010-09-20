Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757527Ab0ITUtB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 16:49:01 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:36092 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757388Ab0ITUtA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 16:49:00 -0400
Date: Mon, 20 Sep 2010 21:48:57 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: linus-arch@ZenIV.linux.org.uk
Cc: linux-kernel@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: powerpc: fix double syscall restarts
Message-ID: <20100920204856.GF31363@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make sigreturn zero regs->trap, make do_signal() do the same on all
paths.  As it is, signal interrupting e.g. read() from fd 512 (==
ERESTARTSYS) with another signal getting unblocked when the first
handler finishes will lead to restart one insn earlier than it ought
to.  Same for multiple signals with in-kernel handlers interrupting
that sucker at the same time.  Same for multiple signals of any kind
interrupting that sucker on 64bit...

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 arch/powerpc/kernel/signal.c    |    2 ++
 arch/powerpc/kernel/signal_32.c |    3 +--
 arch/powerpc/kernel/signal_64.c |    2 +-
 3 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/arch/powerpc/kernel/signal.c b/arch/powerpc/kernel/signal.c
index 7109f5b..2300426 100644
--- a/arch/powerpc/kernel/signal.c
+++ b/arch/powerpc/kernel/signal.c
@@ -138,6 +138,7 @@ static int do_signal_pending(sigset_t *oldset, struct pt_regs *regs)
 			ti->local_flags &= ~_TLF_RESTORE_SIGMASK;
 			sigprocmask(SIG_SETMASK, &current->saved_sigmask, NULL);
 		}
+		regs->trap = 0;
 		return 0;               /* no signals delivered */
 	}
 
@@ -164,6 +165,7 @@ static int do_signal_pending(sigset_t *oldset, struct pt_regs *regs)
 		ret = handle_rt_signal64(signr, &ka, &info, oldset, regs);
 	}
 
+	regs->trap = 0;
 	if (ret) {
 		spin_lock_irq(&current->sighand->siglock);
 		sigorsets(&current->blocked, &current->blocked,
diff --git a/arch/powerpc/kernel/signal_32.c b/arch/powerpc/kernel/signal_32.c
index 2666101..b96a3a0 100644
--- a/arch/powerpc/kernel/signal_32.c
+++ b/arch/powerpc/kernel/signal_32.c
@@ -511,6 +511,7 @@ static long restore_user_regs(struct pt_regs *regs,
 	if (!sig)
 		save_r2 = (unsigned int)regs->gpr[2];
 	err = restore_general_regs(regs, sr);
+	regs->trap = 0;
 	err |= __get_user(msr, &sr->mc_gregs[PT_MSR]);
 	if (!sig)
 		regs->gpr[2] = (unsigned long) save_r2;
@@ -884,7 +885,6 @@ int handle_rt_signal32(unsigned long sig, struct k_sigaction *ka,
 	regs->nip = (unsigned long) ka->sa.sa_handler;
 	/* enter the signal handler in big-endian mode */
 	regs->msr &= ~MSR_LE;
-	regs->trap = 0;
 	return 1;
 
 badframe:
@@ -1228,7 +1228,6 @@ int handle_signal32(unsigned long sig, struct k_sigaction *ka,
 	regs->nip = (unsigned long) ka->sa.sa_handler;
 	/* enter the signal handler in big-endian mode */
 	regs->msr &= ~MSR_LE;
-	regs->trap = 0;
 
 	return 1;
 
diff --git a/arch/powerpc/kernel/signal_64.c b/arch/powerpc/kernel/signal_64.c
index 2fe6fc6..27c4a45 100644
--- a/arch/powerpc/kernel/signal_64.c
+++ b/arch/powerpc/kernel/signal_64.c
@@ -178,7 +178,7 @@ static long restore_sigcontext(struct pt_regs *regs, sigset_t *set, int sig,
 	err |= __get_user(regs->xer, &sc->gp_regs[PT_XER]);
 	err |= __get_user(regs->ccr, &sc->gp_regs[PT_CCR]);
 	/* skip SOFTE */
-	err |= __get_user(regs->trap, &sc->gp_regs[PT_TRAP]);
+	regs->trap = 0;
 	err |= __get_user(regs->dar, &sc->gp_regs[PT_DAR]);
 	err |= __get_user(regs->dsisr, &sc->gp_regs[PT_DSISR]);
 	err |= __get_user(regs->result, &sc->gp_regs[PT_RESULT]);
-- 
1.5.6.5

