Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754590Ab1DKRXK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Apr 2011 13:23:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8637 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753128Ab1DKRXI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Apr 2011 13:23:08 -0400
Date: Mon, 11 Apr 2011 19:22:29 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: "Nikita V. Youshchenko" <nyoushchenko@mvista.com>,
        Matt Fleming <matt@console-pimps.org>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: [PATCH 6/6] x86: signal: sys_rt_sigreturn() should use
	sigprocmask()
Message-ID: <20110411172229.GG32469@redhat.com>
References: <20110411171957.GA32469@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110411171957.GA32469@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Normally sys_rt_sigreturn() restores the old current->blocked which was
changed by handle_signal(), and unblocking is always fine.

But the debugger or application itself can change frame->uc_sigmask and
thus we need sigprocmask()->retarget_shared_pending().

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---

 arch/x86/kernel/signal.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

--- sigprocmask/arch/x86/kernel/signal.c~6_sigreturn	2011-04-11 18:33:17.000000000 +0200
+++ sigprocmask/arch/x86/kernel/signal.c	2011-04-11 18:57:27.000000000 +0200
@@ -601,10 +601,7 @@ long sys_rt_sigreturn(struct pt_regs *re
 		goto badframe;
 
 	sigdelsetmask(&set, ~_BLOCKABLE);
-	spin_lock_irq(&current->sighand->siglock);
-	current->blocked = set;
-	recalc_sigpending();
-	spin_unlock_irq(&current->sighand->siglock);
+	sigprocmask(SIG_SETMASK, &set, NULL);
 
 	if (restore_sigcontext(regs, &frame->uc.uc_mcontext, &ax))
 		goto badframe;

