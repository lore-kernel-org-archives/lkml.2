Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755320Ab0IRIma (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Sep 2010 04:42:30 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:46199 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754630Ab0IRIm2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Sep 2010 04:42:28 -0400
Date: Sat, 18 Sep 2010 09:42:27 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: linux-kernel@vger.kernel.org
Cc: Richard Henderson <rth@twiddle.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-arch@vger.kernel.org
Subject: [PATCH 4/4] alpha: deal with multiple simultaneously pending signals
 sanely
Message-ID: <20100918084227.GD31363@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Unlike the other targets, alpha sets _one_ sigframe and
buggers off until the next syscall/interrupt, even if
more signals are pending.  It leads to quite a few unpleasant
inconsistencies, starting with SIGSEGV potentially arriving
not where it should and including e.g. mess with sigsuspend();
consider two pending signals blocked until sigsuspend()
unblocks them.  We pick the first one; then, if we are hit
by interrupt while in the handler, we process the second one
as well.  If we are not, and if no syscalls had been made,
we get out of the first handler and leave the second signal
pending; normally sigreturn() would've picked it anyway, but
here it starts with restoring the original mask and voila -
the second signal is blocked again.  On everything else we
get both delivered consistently.

It's actually easy to fix; the only thing to watch out for
is prevention of double syscall restart.  Fortunately, the
idea I've nicked from arm fix by rmk works just fine...

Testcase demonstrating the behaviour in question; on alpha
we get one or both flags set (usually one), on everything
else both are always set.
	#include <signal.h>
	#include <stdio.h>
	int had1, had2;
	void f1(int sig) { had1 = 1; }
	void f2(int sig) { had2 = 1; }
	main()
	{
		sigset_t set1, set2;
		sigemptyset(&set1);
		sigemptyset(&set2);
		sigaddset(&set2, 1);
		sigaddset(&set2, 2);
		signal(1, f1);
		signal(2, f2);
		sigprocmask(SIG_SETMASK, &set2, NULL);
		raise(1);
		raise(2);
		sigsuspend(&set1);
		printf("had1:%d had2:%d\n", had1, had2);
	}

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 arch/alpha/kernel/entry.S |   16 +++++++++++-----
 1 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/arch/alpha/kernel/entry.S b/arch/alpha/kernel/entry.S
index a3e9cd8..ab1ee0a 100644
--- a/arch/alpha/kernel/entry.S
+++ b/arch/alpha/kernel/entry.S
@@ -317,14 +317,14 @@ ret_from_sys_call:
 	ldq	$0, SP_OFF($sp)
 	and	$0, 8, $0
 	beq	$0, restore_all
-ret_from_reschedule:
+ret_to_user:
 	/* Make sure need_resched and sigpending don't change between
 		sampling and the rti.  */
 	lda	$16, 7
 	call_pal PAL_swpipl
 	ldl	$5, TI_FLAGS($8)
 	and	$5, _TIF_WORK_MASK, $2
-	bne	$5, work_pending
+	bne	$2, work_pending
 restore_all:
 	RESTORE_ALL
 	call_pal PAL_rti
@@ -363,7 +363,7 @@ $ret_success:
  *       $8: current.
  *      $19: The old syscall number, or zero if this is not a return
  *           from a syscall that errored and is possibly restartable.
- *      $20: Error indication.
+ *      $20: The old a3 value
  */
 
 	.align	4
@@ -392,12 +392,18 @@ $work_resched:
 
 $work_notifysig:
 	mov	$sp, $16
-	br	$1, do_switch_stack
+	bsr	$1, do_switch_stack
 	mov	$sp, $17
 	mov	$5, $18
+	mov	$19, $9		/* save old syscall number */
+	mov	$20, $10	/* save old a3 */
+	and	$5, _TIF_SIGPENDING, $2
+	cmovne	$2, 0, $9	/* we don't want double syscall restarts */
 	jsr	$26, do_notify_resume
+	mov	$9, $19
+	mov	$10, $20
 	bsr	$1, undo_switch_stack
-	br	restore_all
+	br	ret_to_user
 .end work_pending
 
 /*
-- 
1.5.6.5

