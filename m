Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753817Ab0IXFY6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 01:24:58 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:41093 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751119Ab0IXFY5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 01:24:57 -0400
Date: Fri, 24 Sep 2010 06:24:53 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Hirokazu Takata <takata@linux-m32r.org>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org
Subject: [PATCH 4/5] m32r: hole in shifting pc back
Message-ID: <20100924052453.GO19804@ZenIV.linux.org.uk>
References: <20100924052035.GL19804@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100924052035.GL19804@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's a userland pointer; worse, an untrustable one since ptrace
has just provided a chance to modify it.

X-Roothole-Covering-Cabal: TINRCC
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 arch/m32r/kernel/signal.c |   38 +++++++++++++++++---------------------
 1 files changed, 17 insertions(+), 21 deletions(-)

diff --git a/arch/m32r/kernel/signal.c b/arch/m32r/kernel/signal.c
index a56fcbd..7bbe386 100644
--- a/arch/m32r/kernel/signal.c
+++ b/arch/m32r/kernel/signal.c
@@ -251,6 +251,19 @@ give_sigsegv:
 	return -EFAULT;
 }
 
+static int prev_insn(struct pt_regs *regs)
+{
+	u16 inst;
+	if (get_user(&inst, (u16 __user *)(regs->bpc - 2)))
+		return -EFAULT;
+	if ((inst & 0xfff0) == 0x10f0)	/* trap ? */
+		regs->bpc -= 2;
+	else
+		regs->bpc -= 4;
+	regs->syscall_nr = -1;
+	return 0;
+}
+
 /*
  * OK, we're invoking a handler
  */
@@ -259,8 +272,6 @@ static int
 handle_signal(unsigned long sig, struct k_sigaction *ka, siginfo_t *info,
 	      sigset_t *oldset, struct pt_regs *regs)
 {
-	unsigned short inst;
-
 	/* Are we from a system call? */
 	if (regs->syscall_nr >= 0) {
 		/* If so, check system call restarting.. */
@@ -278,12 +289,8 @@ handle_signal(unsigned long sig, struct k_sigaction *ka, siginfo_t *info,
 			/* fallthrough */
 			case -ERESTARTNOINTR:
 				regs->r0 = regs->orig_r0;
-				inst = *(unsigned short *)(regs->bpc - 2);
-				if ((inst & 0xfff0) == 0x10f0)	/* trap ? */
-					regs->bpc -= 2;
-				else
-					regs->bpc -= 4;
-				regs->syscall_nr = -1;
+				if (prev_insn(regs) < 0)
+					return -EFAULT;
 		}
 	}
 
@@ -310,7 +317,6 @@ static void do_signal(struct pt_regs *regs)
 	siginfo_t info;
 	int signr;
 	struct k_sigaction ka;
-	unsigned short inst;
 	sigset_t *oldset;
 
 	/*
@@ -353,21 +359,11 @@ static void do_signal(struct pt_regs *regs)
 		    regs->r0 == -ERESTARTSYS ||
 		    regs->r0 == -ERESTARTNOINTR) {
 			regs->r0 = regs->orig_r0;
-			inst = *(unsigned short *)(regs->bpc - 2);
-			if ((inst & 0xfff0) == 0x10f0)	/* trap ? */
-				regs->bpc -= 2;
-			else
-				regs->bpc -= 4;
-			regs->syscall_nr = -1;
+			prev_insn(regs);
 		} else if (regs->r0 == -ERESTART_RESTARTBLOCK){
 			regs->r0 = regs->orig_r0;
 			regs->r7 = __NR_restart_syscall;
-			inst = *(unsigned short *)(regs->bpc - 2);
-			if ((inst & 0xfff0) == 0x10f0)	/* trap ? */
-				regs->bpc -= 2;
-			else
-				regs->bpc -= 4;
-			regs->syscall_nr = -1;
+			prev_insn(regs);
 		}
 	}
 	if (test_thread_flag(TIF_RESTORE_SIGMASK)) {
-- 
1.5.6.5

