Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752593Ab1HPUBZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Aug 2011 16:01:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28398 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751236Ab1HPUBY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Aug 2011 16:01:24 -0400
Date: Tue, 16 Aug 2011 21:58:34 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Matt Fleming <matt@console-pimps.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/41] signal: Use set_current_blocked()
Message-ID: <20110816195834.GC6602@redhat.com>
References: <1313071035-12047-1-git-send-email-matt@console-pimps.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1313071035-12047-1-git-send-email-matt@console-pimps.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/11, Matt Fleming wrote:
>
> I did a tree wide scan of all the code that modifies current->blocked
> without using the set_current_blocked() accessor. This patch series is
> the result of the conversion to the new accessor functions.

Thanks Matt.

The whole series looks fine, except the nits I sent. Still I hope the
maintainers can recheck.

One more nit... Every handle_signal() in arch/ does
current->blocked |= ka->sa.sa_mask plus SA_NODEFER code. May be we
should start with the patch below?

The only problem is, I can't invent the good name for this helper.
Also, in this case you need to rediff a lot of patches in this
series, so I won't insist.

Oleg.


--- x/arch/x86/kernel/signal.c
+++ x/arch/x86/kernel/signal.c
@@ -678,11 +678,20 @@ setup_rt_frame(int sig, struct k_sigacti
 	return ret;
 }
 
+void xxx(struct k_sigaction *ka)
+{
+	sigset_t blocked;
+
+	sigorsets(&blocked, &current->blocked, &ka->sa.sa_mask);
+	if (!(ka->sa.sa_flags & SA_NODEFER))
+		sigaddset(&blocked, sig);
+	set_current_blocked(&blocked);
+}
+
 static int
 handle_signal(unsigned long sig, siginfo_t *info, struct k_sigaction *ka,
 		struct pt_regs *regs)
 {
-	sigset_t blocked;
 	int ret;
 
 	/* Are we from a system call? */
@@ -733,10 +742,7 @@ handle_signal(unsigned long sig, siginfo
 	 */
 	regs->flags &= ~X86_EFLAGS_TF;
 
-	sigorsets(&blocked, &current->blocked, &ka->sa.sa_mask);
-	if (!(ka->sa.sa_flags & SA_NODEFER))
-		sigaddset(&blocked, sig);
-	set_current_blocked(&blocked);
+	xxx(ka);
 
 	tracehook_signal_handler(sig, info, ka, regs,
 				 test_thread_flag(TIF_SINGLESTEP));

