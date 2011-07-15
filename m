Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964855Ab1GOFrE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jul 2011 01:47:04 -0400
Received: from hera.kernel.org ([140.211.167.34]:49857 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964770Ab1GOFrB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jul 2011 01:47:01 -0400
Date: Fri, 15 Jul 2011 05:46:55 GMT
From: tip-bot for Oleg Nesterov <oleg@redhat.com>
Message-ID: <tip-3982294b0342474ff91472b34c6afb701785f524@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        oleg@redhat.com, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, oleg@redhat.com, hpa@linux.intel.com
In-Reply-To: <20110710192727.GA31759@redhat.com>
References: <20110710192727.GA31759@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/signal] x86, signals: Convert the X86_32 code to use set_current_blocked()
Git-Commit-ID: 3982294b0342474ff91472b34c6afb701785f524
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 15 Jul 2011 05:46:56 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3982294b0342474ff91472b34c6afb701785f524
Gitweb:     http://git.kernel.org/tip/3982294b0342474ff91472b34c6afb701785f524
Author:     Oleg Nesterov <oleg@redhat.com>
AuthorDate: Sun, 10 Jul 2011 21:27:27 +0200
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Thu, 14 Jul 2011 21:21:57 -0700

x86, signals: Convert the X86_32 code to use set_current_blocked()

sys_sigsuspend() and sys_sigreturn() change ->blocked directly.
This is not correct, see the changelog in e6fa16ab
"signal: sigprocmask() should do retarget_shared_pending()"

Change them to use set_current_blocked().

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Link: http://lkml.kernel.org/r/20110710192727.GA31759@redhat.com
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/kernel/signal.c |   18 ++++++++----------
 1 files changed, 8 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kernel/signal.c b/arch/x86/kernel/signal.c
index 40a2493..bf9345d 100644
--- a/arch/x86/kernel/signal.c
+++ b/arch/x86/kernel/signal.c
@@ -485,17 +485,18 @@ static int __setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
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
 
@@ -572,10 +573,7 @@ unsigned long sys_sigreturn(struct pt_regs *regs)
 		goto badframe;
 
 	sigdelsetmask(&set, ~_BLOCKABLE);
-	spin_lock_irq(&current->sighand->siglock);
-	current->blocked = set;
-	recalc_sigpending();
-	spin_unlock_irq(&current->sighand->siglock);
+	set_current_blocked(&set);
 
 	if (restore_sigcontext(regs, &frame->sc, &ax))
 		goto badframe;
