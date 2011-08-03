Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752260Ab1HCNmS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 09:42:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28769 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751070Ab1HCNmK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 09:42:10 -0400
Date: Wed, 3 Aug 2011 15:39:28 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Matt Fleming <matt@console-pimps.org>
Cc: Haavard Skinnemoen <hskinnemoen@gmail.com>,
        Hans-Christian Egtvedt <egtvedt@samfundet.no>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] avr32: use set_current_blocked() in
	handle_signal/sys_rt_sigreturn
Message-ID: <20110803133928.GA12990@redhat.com>
References: <1312362279.10579.38.camel@mfleming-mobl1.ger.corp.intel.com> <20110803130813.GA11708@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110803130813.GA11708@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/03, Oleg Nesterov wrote:
>
> On 08/03, Matt Fleming wrote:
> >
> > 	 * Block the signal if we were unsuccessful.
> > 	 */
> > 	if (ret != 0 || !(ka->sa.sa_flags & SA_NODEFER)) {
> > 		spin_lock_irq(&current->sighand->siglock);
> > 		sigorsets(&current->blocked, &current->blocked,
> > 			  &ka->sa.sa_mask);
> > 		sigaddset(&current->blocked, sig);
> > 		recalc_sigpending();
> > 		spin_unlock_irq(&current->sighand->siglock);
> > 	}
>
> Agreed, this looks "obviously wrong". We should block the !SA_NODEFER
> signal it was delivered.

(I meant, it is was successfully delivered).

While at it, I'd also suggest another patch on top of Matt's.
Uncompiled/untested.

------------------------------------------------------------------------------
[PATCH] avr32: use set_current_blocked() in handle_signal/sys_rt_sigreturn

It is wrong to change ->blocked directly, see e6fa16ab.
Change  handle_signal() and sys_rt_sigreturn() to use
the right helper, set_current_blocked().

Signed-off-by: Oleg Nesterov <oleg@redhat.com>

 signal.c |   15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

--- x/arch/avr32/kernel/signal.c
+++ x/arch/avr32/kernel/signal.c
@@ -87,10 +87,7 @@ asmlinkage int sys_rt_sigreturn(struct p
 		goto badframe;
 
 	sigdelsetmask(&set, ~_BLOCKABLE);
-	spin_lock_irq(&current->sighand->siglock);
-	current->blocked = set;
-	recalc_sigpending();
-	spin_unlock_irq(&current->sighand->siglock);
+	set_current_blocked(&set);
 
 	if (restore_sigcontext(regs, &frame->uc.uc_mcontext))
 		goto badframe;
@@ -226,6 +223,7 @@ static inline void
 handle_signal(unsigned long sig, struct k_sigaction *ka, siginfo_t *info,
 	      sigset_t *oldset, struct pt_regs *regs, int syscall)
 {
+	sigset_t blocked;
 	int ret;
 
 	/*
@@ -246,13 +244,10 @@ handle_signal(unsigned long sig, struct 
 	/*
 	 * Block the signal if we were successful.
 	 */
-	spin_lock_irq(&current->sighand->siglock);
-	sigorsets(&current->blocked, &current->blocked,
-		  &ka->sa.sa_mask);
+	sigorsets(&blocked, &current->blocked, &ka->sa.sa_mask);
 	if (!(ka->sa.sa_flags & SA_NODEFER))
-		sigaddset(&current->blocked, sig);
-	recalc_sigpending();
-	spin_unlock_irq(&current->sighand->siglock);
+		sigaddset(&blocked, sig);
+	set_current_blocked(&blocked);
 }
 
 /*

