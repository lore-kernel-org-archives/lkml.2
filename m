Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932253Ab2ACWno (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 17:43:44 -0500
Received: from cantor2.suse.de ([195.135.220.15]:40580 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756478Ab2ACWnH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 17:43:07 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Jan  3 14:33:26 2012
Message-Id: <20120103223325.991636596@clark.kroah.org>
User-Agent: quilt/0.50-25.1
Date: Tue, 03 Jan 2012 14:33:32 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, "David S. Miller" <davem@davemloft.net>
Subject: [59/75] sparc: Fix handling of orig_i0 wrt. debugging when restarting syscalls.
In-Reply-To: <20120103223332.GA4112@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

------------------


From: "David S. Miller" <davem@davemloft.net>

[ A combination of upstream commits 1d299bc7732c34d85bd43ac1a8745f5a2fed2078 and
  e88d2468718b0789b4c33da2f7e1cef2a1eee279 ]

Although we provide a proper way for a debugger to control whether
syscall restart occurs, we run into problems because orig_i0 is not
saved and restored properly.

Luckily we can solve this problem without having to make debuggers
aware of the issue.  Across system calls, several registers are
considered volatile and can be safely clobbered.

Therefore we use the pt_regs save area of one of those registers, %g6,
as a place to save and restore orig_i0.

Debuggers transparently will do the right thing because they save and
restore this register already.

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 arch/sparc/kernel/signal32.c  |   18 ++++++++++--------
 arch/sparc/kernel/signal_32.c |   30 +++++++++++++++++++++++++-----
 arch/sparc/kernel/signal_64.c |   42 ++++++++++++++++++++++++++++--------------
 3 files changed, 63 insertions(+), 27 deletions(-)

--- a/arch/sparc/kernel/signal32.c
+++ b/arch/sparc/kernel/signal32.c
@@ -822,21 +822,23 @@ static inline void syscall_restart32(uns
  * want to handle. Thus you cannot kill init even with a SIGKILL even by
  * mistake.
  */
-void do_signal32(sigset_t *oldset, struct pt_regs * regs,
-		 int restart_syscall, unsigned long orig_i0)
+void do_signal32(sigset_t *oldset, struct pt_regs * regs)
 {
 	struct k_sigaction ka;
+	unsigned long orig_i0;
+	int restart_syscall;
 	siginfo_t info;
 	int signr;
 	
 	signr = get_signal_to_deliver(&info, &ka, regs, NULL);
 
-	/* If the debugger messes with the program counter, it clears
-	 * the "in syscall" bit, directing us to not perform a syscall
-	 * restart.
-	 */
-	if (restart_syscall && !pt_regs_is_syscall(regs))
-		restart_syscall = 0;
+	restart_syscall = 0;
+	orig_i0 = 0;
+	if (pt_regs_is_syscall(regs) &&
+	    (regs->tstate & (TSTATE_XCARRY | TSTATE_ICARRY))) {
+		restart_syscall = 1;
+		orig_i0 = regs->u_regs[UREG_G6];
+	}
 
 	if (signr > 0) {
 		if (restart_syscall)
--- a/arch/sparc/kernel/signal_32.c
+++ b/arch/sparc/kernel/signal_32.c
@@ -519,10 +519,26 @@ static void do_signal(struct pt_regs *re
 	siginfo_t info;
 	int signr;
 
+	/* It's a lot of work and synchronization to add a new ptrace
+	 * register for GDB to save and restore in order to get
+	 * orig_i0 correct for syscall restarts when debugging.
+	 *
+	 * Although it should be the case that most of the global
+	 * registers are volatile across a system call, glibc already
+	 * depends upon that fact that we preserve them.  So we can't
+	 * just use any global register to save away the orig_i0 value.
+	 *
+	 * In particular %g2, %g3, %g4, and %g5 are all assumed to be
+	 * preserved across a system call trap by various pieces of
+	 * code in glibc.
+	 *
+	 * %g7 is used as the "thread register".   %g6 is not used in
+	 * any fixed manner.  %g6 is used as a scratch register and
+	 * a compiler temporary, but it's value is never used across
+	 * a system call.  Therefore %g6 is usable for orig_i0 storage.
+	 */
 	if (pt_regs_is_syscall(regs) && (regs->psr & PSR_C))
-		restart_syscall = 1;
-	else
-		restart_syscall = 0;
+		regs->u_regs[UREG_G6] = orig_i0;
 
 	if (test_thread_flag(TIF_RESTORE_SIGMASK))
 		oldset = &current->saved_sigmask;
@@ -535,8 +551,12 @@ static void do_signal(struct pt_regs *re
 	 * the software "in syscall" bit, directing us to not perform
 	 * a syscall restart.
 	 */
-	if (restart_syscall && !pt_regs_is_syscall(regs))
-		restart_syscall = 0;
+	restart_syscall = 0;
+	if (pt_regs_is_syscall(regs) && (regs->psr & PSR_C)) {
+		restart_syscall = 1;
+		orig_i0 = regs->u_regs[UREG_G6];
+	}
+
 
 	if (signr > 0) {
 		if (restart_syscall)
--- a/arch/sparc/kernel/signal_64.c
+++ b/arch/sparc/kernel/signal_64.c
@@ -529,11 +529,27 @@ static void do_signal(struct pt_regs *re
 	siginfo_t info;
 	int signr;
 	
+	/* It's a lot of work and synchronization to add a new ptrace
+	 * register for GDB to save and restore in order to get
+	 * orig_i0 correct for syscall restarts when debugging.
+	 *
+	 * Although it should be the case that most of the global
+	 * registers are volatile across a system call, glibc already
+	 * depends upon that fact that we preserve them.  So we can't
+	 * just use any global register to save away the orig_i0 value.
+	 *
+	 * In particular %g2, %g3, %g4, and %g5 are all assumed to be
+	 * preserved across a system call trap by various pieces of
+	 * code in glibc.
+	 *
+	 * %g7 is used as the "thread register".   %g6 is not used in
+	 * any fixed manner.  %g6 is used as a scratch register and
+	 * a compiler temporary, but it's value is never used across
+	 * a system call.  Therefore %g6 is usable for orig_i0 storage.
+	 */
 	if (pt_regs_is_syscall(regs) &&
-	    (regs->tstate & (TSTATE_XCARRY | TSTATE_ICARRY))) {
-		restart_syscall = 1;
-	} else
-		restart_syscall = 0;
+	    (regs->tstate & (TSTATE_XCARRY | TSTATE_ICARRY)))
+		regs->u_regs[UREG_G6] = orig_i0;
 
 	if (current_thread_info()->status & TS_RESTORE_SIGMASK)
 		oldset = &current->saved_sigmask;
@@ -542,22 +558,20 @@ static void do_signal(struct pt_regs *re
 
 #ifdef CONFIG_COMPAT
 	if (test_thread_flag(TIF_32BIT)) {
-		extern void do_signal32(sigset_t *, struct pt_regs *,
-					int restart_syscall,
-					unsigned long orig_i0);
-		do_signal32(oldset, regs, restart_syscall, orig_i0);
+		extern void do_signal32(sigset_t *, struct pt_regs *);
+		do_signal32(oldset, regs);
 		return;
 	}
 #endif	
 
 	signr = get_signal_to_deliver(&info, &ka, regs, NULL);
 
-	/* If the debugger messes with the program counter, it clears
-	 * the software "in syscall" bit, directing us to not perform
-	 * a syscall restart.
-	 */
-	if (restart_syscall && !pt_regs_is_syscall(regs))
-		restart_syscall = 0;
+	restart_syscall = 0;
+	if (pt_regs_is_syscall(regs) &&
+	    (regs->tstate & (TSTATE_XCARRY | TSTATE_ICARRY))) {
+		restart_syscall = 1;
+		orig_i0 = regs->u_regs[UREG_G6];
+	}
 
 	if (signr > 0) {
 		if (restart_syscall)


