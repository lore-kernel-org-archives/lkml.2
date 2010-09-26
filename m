Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757620Ab0IZS2Q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Sep 2010 14:28:16 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:50358 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752126Ab0IZS2P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Sep 2010 14:28:15 -0400
Date: Sun, 26 Sep 2010 19:28:12 +0100
To: linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] alpha: switch osf_sigprocmask() to use of
 sigprocmask()
Cc: mattst88@gmail.com, torvalds@linux-foundation.org
User-Agent: Heirloom mailx 12.4 7/29/08
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <E1OzvxM-0002ng-B5@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


get rid of a useless wrapper, while we are at it

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 arch/alpha/kernel/entry.S   |    9 --------
 arch/alpha/kernel/signal.c  |   46 +++++++++---------------------------------
 arch/alpha/kernel/systbls.S |    2 +-
 3 files changed, 11 insertions(+), 46 deletions(-)

diff --git a/arch/alpha/kernel/entry.S b/arch/alpha/kernel/entry.S
index d1273c1..6d159ce 100644
--- a/arch/alpha/kernel/entry.S
+++ b/arch/alpha/kernel/entry.S
@@ -915,15 +915,6 @@ sys_execve:
 .end sys_execve
 
 	.align	4
-	.globl	osf_sigprocmask
-	.ent	osf_sigprocmask
-osf_sigprocmask:
-	.prologue 0
-	mov	$sp, $18
-	jmp	$31, sys_osf_sigprocmask
-.end osf_sigprocmask
-
-	.align	4
 	.globl	alpha_ni_syscall
 	.ent	alpha_ni_syscall
 alpha_ni_syscall:
diff --git a/arch/alpha/kernel/signal.c b/arch/alpha/kernel/signal.c
index 0f6b51a..06609aa 100644
--- a/arch/alpha/kernel/signal.c
+++ b/arch/alpha/kernel/signal.c
@@ -41,46 +41,20 @@ static void do_signal(struct pt_regs *, struct switch_stack *,
 /*
  * The OSF/1 sigprocmask calling sequence is different from the
  * C sigprocmask() sequence..
- *
- * how:
- * 1 - SIG_BLOCK
- * 2 - SIG_UNBLOCK
- * 3 - SIG_SETMASK
- *
- * We change the range to -1 .. 1 in order to let gcc easily
- * use the conditional move instructions.
- *
- * Note that we don't need to acquire the kernel lock for SMP
- * operation, as all of this is local to this thread.
  */
-SYSCALL_DEFINE3(osf_sigprocmask, int, how, unsigned long, newmask,
-		struct pt_regs *, regs)
+SYSCALL_DEFINE2(osf_sigprocmask, int, how, unsigned long, newmask)
 {
-	unsigned long oldmask = -EINVAL;
-
-	if ((unsigned long)how-1 <= 2) {
-		long sign = how-2;		/* -1 .. 1 */
-		unsigned long block, unblock;
-
-		newmask &= _BLOCKABLE;
-		spin_lock_irq(&current->sighand->siglock);
-		oldmask = current->blocked.sig[0];
-
-		unblock = oldmask & ~newmask;
-		block = oldmask | newmask;
-		if (!sign)
-			block = unblock;
-		if (sign <= 0)
-			newmask = block;
-		if (_NSIG_WORDS > 1 && sign > 0)
-			sigemptyset(&current->blocked);
-		current->blocked.sig[0] = newmask;
-		recalc_sigpending();
-		spin_unlock_irq(&current->sighand->siglock);
-
-		regs->r0 = 0;		/* special no error return */
+	sigset_t oldmask;
+	sigset_t mask;
+	unsigned long res;
+
+	siginitset(&mask, newmask & ~_BLOCKABLE);
+	res = siprocmask(how, &mask, &oldmask);
+	if (!res) {
+		force_successful_syscall_return();
+		res = oldmask->sig[0];
 	}
-	return oldmask;
+	return res;
 }
 
 SYSCALL_DEFINE3(osf_sigaction, int, sig,
diff --git a/arch/alpha/kernel/systbls.S b/arch/alpha/kernel/systbls.S
index ce594ef..a6a1de9 100644
--- a/arch/alpha/kernel/systbls.S
+++ b/arch/alpha/kernel/systbls.S
@@ -58,7 +58,7 @@ sys_call_table:
 	.quad sys_open				/* 45 */
 	.quad alpha_ni_syscall
 	.quad sys_getxgid
-	.quad osf_sigprocmask
+	.quad sys_osf_sigprocmask
 	.quad alpha_ni_syscall
 	.quad alpha_ni_syscall			/* 50 */
 	.quad sys_acct
-- 
1.5.6.5

