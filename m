Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753788Ab1DRNre (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 09:47:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25124 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754611Ab1DRNr1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 09:47:27 -0400
Date: Mon, 18 Apr 2011 15:46:15 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: "Nikita V. Youshchenko" <nyoushchenko@mvista.com>,
        Matt Fleming <matt@console-pimps.org>, linux-kernel@vger.kernel.org
Subject: [PATCH v2 6/7] x86: signal: handle_signal() should use
	set_current_blocked()
Message-ID: <20110418134615.GG15951@redhat.com>
References: <20110418134421.GA15951@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110418134421.GA15951@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is ugly, but if sigprocmask() needs retarget_shared_pending() then
handle signal should follow this logic. In theory it is newer correct to
add the new signals to current->blocked, the signal handler can sleep/etc
so we should notify other threads in case we block the pending signal and
nobody else has TIF_SIGPENDING.

Of course, this change doesn't make signals faster :/

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---

 arch/x86/kernel/signal.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

--- sigprocmask/arch/x86/kernel/signal.c~6_handle_signal	2011-04-15 19:21:30.000000000 +0200
+++ sigprocmask/arch/x86/kernel/signal.c	2011-04-17 23:07:14.000000000 +0200
@@ -682,6 +682,7 @@ static int
 handle_signal(unsigned long sig, siginfo_t *info, struct k_sigaction *ka,
 	      sigset_t *oldset, struct pt_regs *regs)
 {
+	sigset_t blocked;
 	int ret;
 
 	/* Are we from a system call? */
@@ -741,12 +742,10 @@ handle_signal(unsigned long sig, siginfo
 	 */
 	regs->flags &= ~X86_EFLAGS_TF;
 
-	spin_lock_irq(&current->sighand->siglock);
-	sigorsets(&current->blocked, &current->blocked, &ka->sa.sa_mask);
+	sigorsets(&blocked, &current->blocked, &ka->sa.sa_mask);
 	if (!(ka->sa.sa_flags & SA_NODEFER))
-		sigaddset(&current->blocked, sig);
-	recalc_sigpending();
-	spin_unlock_irq(&current->sighand->siglock);
+		sigaddset(&blocked, sig);
+	set_current_blocked(&blocked);
 
 	tracehook_signal_handler(sig, info, ka, regs,
 				 test_thread_flag(TIF_SINGLESTEP));

