Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755310Ab1ABH6b (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 02:58:31 -0500
Received: from mail.windriver.com ([147.11.1.11]:35261 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753537Ab1ABHXD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 02:23:03 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 098/260] arm: fix really nasty sigreturn bug
Date: Sun,  2 Jan 2011 02:16:34 -0500
Message-Id: <1293952756-15010-99-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.3.3
In-Reply-To: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
References: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
X-OriginalArrivalTime: 02 Jan 2011 07:21:57.0649 (UTC) FILETIME=[BD5EA010:01CBAA4D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Al Viro <viro@zeniv.linux.org.uk>

commit 653d48b22166db2d8b1515ebe6f9f0f7c95dfc86 upstream.

If a signal hits us outside of a syscall and another gets delivered
when we are in sigreturn (e.g. because it had been in sa_mask for
the first one and got sent to us while we'd been in the first handler),
we have a chance of returning from the second handler to location one
insn prior to where we ought to return.  If r0 happens to contain -513
(-ERESTARTNOINTR), sigreturn will get confused into doing restart
syscall song and dance.

Incredible joy to debug, since it manifests as random, infrequent and
very hard to reproduce double execution of instructions in userland
code...

The fix is simple - mark it "don't bother with restarts" in wrapper,
i.e. set r8 to 0 in sys_sigreturn and sys_rt_sigreturn wrappers,
suppressing the syscall restart handling on return from these guys.
They can't legitimately return a restart-worthy error anyway.

Testcase:
	#include <unistd.h>
	#include <signal.h>
	#include <stdlib.h>
	#include <sys/time.h>
	#include <errno.h>

	void f(int n)
	{
		__asm__ __volatile__(
			"ldr r0, [%0]\n"
			"b 1f\n"
			"b 2f\n"
			"1:b .\n"
			"2:\n" : : "r"(&n));
	}

	void handler1(int sig) { }
	void handler2(int sig) { raise(1); }
	void handler3(int sig) { exit(0); }

	main()
	{
		struct sigaction s = {.sa_handler = handler2};
		struct itimerval t1 = { .it_value = {1} };
		struct itimerval t2 = { .it_value = {2} };

		signal(1, handler1);

		sigemptyset(&s.sa_mask);
		sigaddset(&s.sa_mask, 1);
		sigaction(SIGALRM, &s, NULL);

		signal(SIGVTALRM, handler3);

		setitimer(ITIMER_REAL, &t1, NULL);
		setitimer(ITIMER_VIRTUAL, &t2, NULL);

		f(-513); /* -ERESTARTNOINTR */

		write(1, "buggered\n", 9);
		return 1;
	}

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Acked-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 arch/arm/kernel/entry-common.S |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/arm/kernel/entry-common.S b/arch/arm/kernel/entry-common.S
index 2c1db77..a6c66f5 100644
--- a/arch/arm/kernel/entry-common.S
+++ b/arch/arm/kernel/entry-common.S
@@ -382,11 +382,13 @@ ENDPROC(sys_clone_wrapper)
 
 sys_sigreturn_wrapper:
 		add	r0, sp, #S_OFF
+		mov	why, #0		@ prevent syscall restart handling
 		b	sys_sigreturn
 ENDPROC(sys_sigreturn_wrapper)
 
 sys_rt_sigreturn_wrapper:
 		add	r0, sp, #S_OFF
+		mov	why, #0		@ prevent syscall restart handling
 		b	sys_rt_sigreturn
 ENDPROC(sys_rt_sigreturn_wrapper)
 
-- 
1.7.3.3

