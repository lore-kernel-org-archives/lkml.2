Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756436Ab0IRTHb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Sep 2010 15:07:31 -0400
Received: from kroah.org ([198.145.64.141]:51888 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756178Ab0IRTC1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Sep 2010 15:02:27 -0400
X-Mailbox-Line: From gregkh@clark.site Sat Sep 18 12:00:02 2010
Message-Id: <20100918190002.585763704@clark.site>
User-Agent: quilt/0.48-11.2
Date: Sat, 18 Sep 2010 11:59:18 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Al Viro <viro@zeniv.linux.org.uk>,
        Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [114/123] arm: fix really nasty sigreturn bug
References: <20100918185724.290702750@clark.site>
Content-Disposition: inline; filename=arm-fix-really-nasty-sigreturn-bug.patch
In-Reply-To: <20100918190024.GA14388@kroah.com>
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
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/arm/kernel/entry-common.S |    2 ++
 1 file changed, 2 insertions(+)

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
 


