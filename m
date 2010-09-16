Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756793Ab0IPWRS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 18:17:18 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:37762 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756782Ab0IPWRP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 18:17:15 -0400
Date: Thu, 16 Sep 2010 23:17:13 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: linux-arch@vger.kernel.org
Cc: Russell King <rmk@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH] really nasty sigreturn bug on arm
Message-ID: <20100916221713.GW31363@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[It's a part of long and growing series I'll be posting shortly, but
this one goes out of order due to sheer nastiness of the observed
behaviour.  Linus, PLEASE DO NOT APPLY until rmk is OK with it; the
fix touches the guts of syscall glue on arm and I really, really
want the people familiar with that area to review the damn thing
before it goes anywhere near the tree]

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
---
 arch/arm/kernel/entry-common.S |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/arm/kernel/entry-common.S b/arch/arm/kernel/entry-common.S
index f05a35a..34e5860 100644
--- a/arch/arm/kernel/entry-common.S
+++ b/arch/arm/kernel/entry-common.S
@@ -418,11 +418,13 @@ ENDPROC(sys_clone_wrapper)
 
 sys_sigreturn_wrapper:
 		add	r0, sp, #S_OFF
+		mov	why, #0
 		b	sys_sigreturn
 ENDPROC(sys_sigreturn_wrapper)
 
 sys_rt_sigreturn_wrapper:
 		add	r0, sp, #S_OFF
+		mov	why, #0
 		b	sys_rt_sigreturn
 ENDPROC(sys_rt_sigreturn_wrapper)
 
-- 
1.5.6.5

