Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932739Ab1GOFqq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jul 2011 01:46:46 -0400
Received: from hera.kernel.org ([140.211.167.34]:49844 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932310Ab1GOFqo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jul 2011 01:46:44 -0400
Date: Fri, 15 Jul 2011 05:46:28 GMT
From: tip-bot for Oleg Nesterov <oleg@redhat.com>
Message-ID: <tip-905f29e2aa004560907199cc96248fa11bafea8a@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        oleg@redhat.com, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, oleg@redhat.com, hpa@linux.intel.com
In-Reply-To: <20110710192724.GA31755@redhat.com>
References: <20110710192724.GA31755@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/signal] x86, signals: Convert the IA32_EMULATION code to use set_current_blocked()
Git-Commit-ID: 905f29e2aa004560907199cc96248fa11bafea8a
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 15 Jul 2011 05:46:28 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  905f29e2aa004560907199cc96248fa11bafea8a
Gitweb:     http://git.kernel.org/tip/905f29e2aa004560907199cc96248fa11bafea8a
Author:     Oleg Nesterov <oleg@redhat.com>
AuthorDate: Sun, 10 Jul 2011 21:27:24 +0200
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Thu, 14 Jul 2011 21:21:31 -0700

x86, signals: Convert the IA32_EMULATION code to use set_current_blocked()

sys32_sigsuspend() and sys32_*sigreturn() change ->blocked directly.
This is not correct, see the changelog in e6fa16ab
"signal: sigprocmask() should do retarget_shared_pending()"

Change them to use set_current_blocked().

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Link: http://lkml.kernel.org/r/20110710192724.GA31755@redhat.com
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/ia32/ia32_signal.c |   22 +++++++++-------------
 1 files changed, 9 insertions(+), 13 deletions(-)

diff --git a/arch/x86/ia32/ia32_signal.c b/arch/x86/ia32/ia32_signal.c
index 588a7aa..6557769 100644
--- a/arch/x86/ia32/ia32_signal.c
+++ b/arch/x86/ia32/ia32_signal.c
@@ -127,15 +127,17 @@ int copy_siginfo_from_user32(siginfo_t *to, compat_siginfo_t __user *from)
 
 asmlinkage long sys32_sigsuspend(int history0, int history1, old_sigset_t mask)
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
+
 	set_restore_sigmask();
 	return -ERESTARTNOHAND;
 }
@@ -279,10 +281,7 @@ asmlinkage long sys32_sigreturn(struct pt_regs *regs)
 		goto badframe;
 
 	sigdelsetmask(&set, ~_BLOCKABLE);
-	spin_lock_irq(&current->sighand->siglock);
-	current->blocked = set;
-	recalc_sigpending();
-	spin_unlock_irq(&current->sighand->siglock);
+	set_current_blocked(&set);
 
 	if (ia32_restore_sigcontext(regs, &frame->sc, &ax))
 		goto badframe;
@@ -308,10 +307,7 @@ asmlinkage long sys32_rt_sigreturn(struct pt_regs *regs)
 		goto badframe;
 
 	sigdelsetmask(&set, ~_BLOCKABLE);
-	spin_lock_irq(&current->sighand->siglock);
-	current->blocked = set;
-	recalc_sigpending();
-	spin_unlock_irq(&current->sighand->siglock);
+	set_current_blocked(&set);
 
 	if (ia32_restore_sigcontext(regs, &frame->uc.uc_mcontext, &ax))
 		goto badframe;
