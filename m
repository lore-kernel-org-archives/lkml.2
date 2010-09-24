Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753096Ab0IXFYD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 01:24:03 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:41085 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751185Ab0IXFYB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 01:24:01 -0400
Date: Fri, 24 Sep 2010 06:23:57 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Hirokazu Takata <takata@linux-m32r.org>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org
Subject: [PATCH 3/5] m32r: don't block signals if sigframe setup has failed
Message-ID: <20100924052357.GN19804@ZenIV.linux.org.uk>
References: <20100924052035.GL19804@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100924052035.GL19804@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 arch/m32r/kernel/signal.c |   23 +++++++++++++----------
 1 files changed, 13 insertions(+), 10 deletions(-)

diff --git a/arch/m32r/kernel/signal.c b/arch/m32r/kernel/signal.c
index db15226..a56fcbd 100644
--- a/arch/m32r/kernel/signal.c
+++ b/arch/m32r/kernel/signal.c
@@ -187,7 +187,7 @@ get_sigframe(struct k_sigaction *ka, unsigned long sp, size_t frame_size)
 	return (void __user *)((sp - frame_size) & -8ul);
 }
 
-static void setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
+static int setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
 			   sigset_t *set, struct pt_regs *regs)
 {
 	struct rt_sigframe __user *frame;
@@ -244,17 +244,18 @@ static void setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
 		current->comm, current->pid, frame, regs->pc);
 #endif
 
-	return;
+	return 0;
 
 give_sigsegv:
 	force_sigsegv(sig, current);
+	return -EFAULT;
 }
 
 /*
  * OK, we're invoking a handler
  */
 
-static void
+static int
 handle_signal(unsigned long sig, struct k_sigaction *ka, siginfo_t *info,
 	      sigset_t *oldset, struct pt_regs *regs)
 {
@@ -287,7 +288,8 @@ handle_signal(unsigned long sig, struct k_sigaction *ka, siginfo_t *info,
 	}
 
 	/* Set up the stack frame */
-	setup_rt_frame(sig, ka, info, oldset, regs);
+	if (setup_rt_frame(sig, ka, info, oldset, regs))
+		return -EFAULT;
 
 	spin_lock_irq(&current->sighand->siglock);
 	sigorsets(&current->blocked,&current->blocked,&ka->sa.sa_mask);
@@ -295,6 +297,7 @@ handle_signal(unsigned long sig, struct k_sigaction *ka, siginfo_t *info,
 		sigaddset(&current->blocked,sig);
 	recalc_sigpending();
 	spin_unlock_irq(&current->sighand->siglock);
+	return 0;
 }
 
 /*
@@ -302,7 +305,7 @@ handle_signal(unsigned long sig, struct k_sigaction *ka, siginfo_t *info,
  * want to handle. Thus you cannot kill init even with a SIGKILL even by
  * mistake.
  */
-static int do_signal(struct pt_regs *regs)
+static void do_signal(struct pt_regs *regs)
 {
 	siginfo_t info;
 	int signr;
@@ -317,7 +320,7 @@ static int do_signal(struct pt_regs *regs)
 	 * if so.
 	 */
 	if (!user_mode(regs))
-		return 1;
+		return;
 
 	if (try_to_freeze()) 
 		goto no_signal;
@@ -336,9 +339,10 @@ static int do_signal(struct pt_regs *regs)
 		 */
 
 		/* Whee!  Actually deliver the signal.  */
-		handle_signal(signr, &ka, &info, oldset, regs);
-		clear_thread_flag(TIF_RESTORE_SIGMASK);
-		return 1;
+		if (handle_signal(signr, &ka, &info, oldset, regs) == 0)
+			clear_thread_flag(TIF_RESTORE_SIGMASK);
+
+		return;
 	}
 
  no_signal:
@@ -370,7 +374,6 @@ static int do_signal(struct pt_regs *regs)
 		clear_thread_flag(TIF_RESTORE_SIGMASK);
 		sigprocmask(SIG_SETMASK, &current->saved_sigmask, NULL);
 	}
-	return 0;
 }
 
 /*
-- 
1.5.6.5

