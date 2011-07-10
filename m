Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756626Ab1GJT3n (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jul 2011 15:29:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34670 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756611Ab1GJT3j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jul 2011 15:29:39 -0400
Date: Sun, 10 Jul 2011 21:27:27 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Tejun Heo <tj@kernel.org>, Matt Fleming <matt.fleming@linux.intel.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] signals: convert the X86_32 code to use
	set_current_blocked()
Message-ID: <20110710192727.GA31759@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sys_sigsuspend() and sys_sigreturn() change ->blocked directly.
This is not correct, see the changelog in e6fa16ab
"signal: sigprocmask() should do retarget_shared_pending()"

Change them to use set_current_blocked().

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---

 arch/x86/kernel/signal.c |   18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

--- ptrace/arch/x86/kernel/signal.c~3_x86_set_current_blocked	2011-07-10 19:45:21.000000000 +0200
+++ ptrace/arch/x86/kernel/signal.c	2011-07-10 21:00:04.000000000 +0200
@@ -485,17 +485,18 @@ static int __setup_rt_frame(int sig, str
 asmlinkage int
 sys_sigsuspend(int history0, int history1, old_sigset_t mask)
 {
-	mask &= _BLOCKABLE;
-	spin_lock_irq(&current->sighand->siglock);
+	sigset_t blocked;
+
 	current->saved_sigmask = current->blocked;
-	siginitset(&current->blocked, mask);
-	recalc_sigpending();
-	spin_unlock_irq(&current->sighand->siglock);
+
+	mask &= _BLOCKABLE;
+	siginitset(&blocked, mask);
+	set_current_blocked(&blocked);
 
 	current->state = TASK_INTERRUPTIBLE;
 	schedule();
-	set_restore_sigmask();
 
+	set_restore_sigmask();
 	return -ERESTARTNOHAND;
 }
 
@@ -572,10 +573,7 @@ unsigned long sys_sigreturn(struct pt_re
 		goto badframe;
 
 	sigdelsetmask(&set, ~_BLOCKABLE);
-	spin_lock_irq(&current->sighand->siglock);
-	current->blocked = set;
-	recalc_sigpending();
-	spin_unlock_irq(&current->sighand->siglock);
+	set_current_blocked(&set);
 
 	if (restore_sigcontext(regs, &frame->sc, &ax))
 		goto badframe;

