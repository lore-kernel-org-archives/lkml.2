Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751969Ab0IRIlT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Sep 2010 04:41:19 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:46195 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754243Ab0IRIlR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Sep 2010 04:41:17 -0400
Date: Sat, 18 Sep 2010 09:41:16 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: linux-kernel@vger.kernel.org
Cc: Richard Henderson <rth@twiddle.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-arch@vger.kernel.org
Subject: [PATCH 3/4] alpha: fix a 14 years old bug in sigreturn tracing
Message-ID: <20100918084116.GC31363@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The way sigreturn() is implemented on alpha breaks PTRACE_SYSCALL,
all way back to 1.3.95 when alpha has grown PTRACE_SYSCALL support.

What happens is direct return to ret_from_syscall, in order to bypass
mangling of a3 (error indicator) and prevent other mutilations of
registers (e.g. by syscall restart).  That's fine, but... the entire
TIF_SYSCALL_TRACE codepath is kept separate on alpha and post-syscall
stopping/notifying the tracer is after the syscall.  And the normal
path we are forcibly switching to doesn't have it.

So we end up with *one* stop in traced sigreturn() vs. two in other
syscalls.  And yes, strace is visibly broken by that; try to strace
the following
	#include <signal.h>
	#include <stdio.h>
	void f(int sig) {}
	main()
	{
		signal(SIGHUP, f);
		raise(SIGHUP);
		write(1, "eeeek\n", 6);
	}
and watch the show.  The
	close(1)                                = 405
in the end of strace output is coming from return value of write() (6 ==
__NR_close on alpha) and syscall number of exit_group() (__NR_exit_group ==
405 there).

The fix is fairly simple - the only thing we end up missing is the call
of syscall_trace() and we can tell whether we'd been called from the
SYSCALL_TRACE path by checking ra value.  Since we are setting the
switch_stack up (that's what sys_sigreturn() does), we have the right
environment for calling syscall_trace() - just before we call
undo_switch_stack() and return.  Since undo_switch_stack() will overwrite
s0 anyway, we can use it to store the result of "has it been called from
SYSCALL_TRACE path?" check.  The same thing applies in rt_sigreturn().

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 arch/alpha/kernel/entry.S |   13 +++++++++++--
 1 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/arch/alpha/kernel/entry.S b/arch/alpha/kernel/entry.S
index bceb325..a3e9cd8 100644
--- a/arch/alpha/kernel/entry.S
+++ b/arch/alpha/kernel/entry.S
@@ -430,6 +430,7 @@ strace:
 	beq	$1, 1f
 	ldq	$27, 0($2)
 1:	jsr	$26, ($27), sys_gettimeofday
+ret_from_straced:
 	ldgp	$gp, 0($26)
 
 	/* check return.. */
@@ -757,11 +758,15 @@ sys_vfork:
 	.ent	sys_sigreturn
 sys_sigreturn:
 	.prologue 0
+	lda	$9, ret_from_straced
+	cmpult	$26, $9, $9
 	mov	$sp, $17
 	lda	$18, -SWITCH_STACK_SIZE($sp)
 	lda	$sp, -SWITCH_STACK_SIZE($sp)
 	jsr	$26, do_sigreturn
-	br	$1, undo_switch_stack
+	bne	$9, 1f
+	jsr	$26, syscall_trace
+1:	br	$1, undo_switch_stack
 	br	ret_from_sys_call
 .end sys_sigreturn
 
@@ -770,11 +775,15 @@ sys_sigreturn:
 	.ent	sys_rt_sigreturn
 sys_rt_sigreturn:
 	.prologue 0
+	lda	$9, ret_from_straced
+	cmpult	$26, $9, $9
 	mov	$sp, $17
 	lda	$18, -SWITCH_STACK_SIZE($sp)
 	lda	$sp, -SWITCH_STACK_SIZE($sp)
 	jsr	$26, do_rt_sigreturn
-	br	$1, undo_switch_stack
+	bne	$9, 1f
+	jsr	$26, syscall_trace
+1:	br	$1, undo_switch_stack
 	br	ret_from_sys_call
 .end sys_rt_sigreturn
 
-- 
1.5.6.5

