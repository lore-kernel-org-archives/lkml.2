Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756210Ab0F3UgF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 16:36:05 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:44581 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754796Ab0F3UgD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 16:36:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:x-mailer-version
         :in-reply-to:references;
        b=g8WYEOGHxfPHAiYJ0+90V7nP+DbYIWA/JhTHvgrHtKMDdI2A3vOJZ81lR+JLvoJRvp
         i9WOE5p5Fj0JwRVgQHZYFUqVUTou5ibq2pRh4V5srqccjoQlYHUu5c8EVwHh0JX0tp2Y
         NTPsS5EePlyHl04eU9eoil8Ss4K+5JJBP76Z4=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "2.6.33.x" <stable@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Prasad <prasad@linux.vnet.ibm.com>
Subject: [PATCH -stable 2.6.33.x] x86: Send a SIGTRAP for user icebp traps
Date: Wed, 30 Jun 2010 22:11:39 +0200
Message-Id: <1277928699-11539-1-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-regression
X-Mailer-version: 0.1, "The maintainer couldn't reproduce after one week full time debugging" special version.
In-Reply-To: <1277906559-10624-1-git-send-regression-fweisbec@gmail.com>
References: <1277906559-10624-1-git-send-regression-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

Reported-and-tested-by: Alexandre Julliard <julliard@winehq.org>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Prasad <prasad@linux.vnet.ibm.com>
---
 arch/x86/kernel/traps.c |   11 ++++++++++-
 1 files changed, 10 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index 3339917..b1e85b0 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -529,11 +529,20 @@ asmlinkage __kprobes struct pt_regs *sync_regs(struct pt_regs *eregs)
 dotraplinkage void __kprobes do_debug(struct pt_regs *regs, long error_code)
 {
 	struct task_struct *tsk = current;
+	int user_icebp = 0;
 	unsigned long dr6;
 	int si_code;
 
 	get_debugreg(dr6, 6);
 
+	/*
+	 * If dr6 has no reason to give us about the origin of this trap,
+	 * then it's very likely the result of an icebp/int01 trap.
+	 * User wants a sigtrap for that.
+	 */
+	if (!(dr6 & ~0xffff0ff0) && user_mode(regs))
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
 
-- 
1.6.2.3

