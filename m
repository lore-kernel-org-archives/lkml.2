Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756182Ab0F3OKn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 10:10:43 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:64659 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756074Ab0F3OKm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 10:10:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:x-mailer-version;
        b=GxZbDnmAIGlZU6BBjS5EkZ57ScduVMxGti058e8JJeGhW+uc81v8zuut5p6j1vdoe5
         HoJFwnBn+WCrskKP4MuBdkYnHIGCKBDFEqtmAOy8XOsOQT1NO2PiKuXhXIhHCIQ1i67p
         +R0C8+/K6HBwAWWYLVheN326mbn09xPObZAFg=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Alexandre Julliard <julliard@winehq.org>,
       "H . Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Prasad <prasad@linux.vnet.ibm.com>,
       "2 . 6 . 33 . x 2 . 6 . 34 . x" <stable@kernel.org>
Subject: [GIT PULL] x86 breakpoint regression fix
Date: Wed, 30 Jun 2010 16:02:39 +0200
Message-Id: <1277906559-10624-1-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-regression
X-Mailer-version: 0.1, "The maintainer couldn't reproduce after one week full time debugging" special version.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo,

Please pull the perf/urgent branch that can be found at:

git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git
	perf/urgent

Thanks,
	Frederic
---

Frederic Weisbecker (1):
      x86: Send a SIGTRAP for user icebp traps


 arch/x86/kernel/traps.c |   11 ++++++++++-
 1 files changed, 10 insertions(+), 1 deletions(-)

---
commit 0ba3546b92759463d30fb9ea014c7f42e1c551c2
Author: Frederic Weisbecker <fweisbec@gmail.com>
Date:   Wed Jun 30 15:09:06 2010 +0200

    x86: Send a SIGTRAP for user icebp traps
    
    Before we had a generic breakpoint layer, x86 used to send a
    sigtrap for any debug event that happened in userspace,
    except if it was caused by lazy dr7 switches.
    
    Currently we only send such signal for single step or breakpoint
    events.
    
    However, there are three other kind of debug exceptions:
    
    - debug register access detected: trigger an exception if the
      next instruction touches the debug registers. We don't use
      it.
    - task switch, but we don't use tss.
    - icebp/int01 trap. This instruction (0xf1) is undocumented and
      generates an int 1 exception. Unlike single step through TF
      flag, it doesn't set the single step origin of the exception
      in dr6.
    
    icebp then used to be reported in userspace using trap signals
    but this have been incidentally broken with the new breakpoint
    code. Reenable this. Since this is the only debug event that
    doesn't set anything in dr6, this is all we have to check.
    
    This fixes a regression in Wine where World Of Warcraft got broken
    as it uses this for software protection checks purposes. And
    probably other apps do.
    
    Reported-by: Alexandre Julliard <julliard@winehq.org>
    Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
    Cc: Ingo Molnar <mingo@elte.hu>
    Cc: H. Peter Anvin <hpa@zytor.com>
    Cc: Thomas Gleixner <tglx@linutronix.de>
    Cc: Prasad <prasad@linux.vnet.ibm.com>
    Cc: 2.6.33.x 2.6.34.x <stable@kernel.org>

diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index 142d70c..725ef4d 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -526,6 +526,7 @@ asmlinkage __kprobes struct pt_regs *sync_regs(struct pt_regs *eregs)
 dotraplinkage void __kprobes do_debug(struct pt_regs *regs, long error_code)
 {
 	struct task_struct *tsk = current;
+	int user_icebp = 0;
 	unsigned long dr6;
 	int si_code;
 
@@ -534,6 +535,14 @@ dotraplinkage void __kprobes do_debug(struct pt_regs *regs, long error_code)
 	/* Filter out all the reserved bits which are preset to 1 */
 	dr6 &= ~DR6_RESERVED;
 
+	/*
+	 * If dr6 has no reason to give us about the origin of this trap,
+	 * then it's very likely the result of an icebp/int01 trap.
+	 * User wants a sigtrap for that.
+	 */
+	if (!dr6 && user_mode(regs))
+		user_icebp = 1;
+
 	/* Catch kmemcheck conditions first of all! */
 	if ((dr6 & DR_STEP) && kmemcheck_trap(regs))
 		return;
@@ -575,7 +584,7 @@ dotraplinkage void __kprobes do_debug(struct pt_regs *regs, long error_code)
 		regs->flags &= ~X86_EFLAGS_TF;
 	}
 	si_code = get_si_code(tsk->thread.debugreg6);
-	if (tsk->thread.debugreg6 & (DR_STEP | DR_TRAP_BITS))
+	if (tsk->thread.debugreg6 & (DR_STEP | DR_TRAP_BITS) || user_icebp)
 		send_sigtrap(tsk, regs, error_code, si_code);
 	preempt_conditional_cli(regs);
 
