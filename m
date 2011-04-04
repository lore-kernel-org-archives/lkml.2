Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754741Ab1DDO6K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Apr 2011 10:58:10 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:39497 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754601Ab1DDO6J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Apr 2011 10:58:09 -0400
From: Matt Fleming <matt@console-pimps.org>
To: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>
Cc: linux-kernel@vger.kernel.org, Oleg Nesterov <oleg@redhat.com>,
        Matt Fleming <matt.fleming@linux.intel.com>
Subject: [PATCH] avr32: init cannot ignore signals sent by force_sig_info()
Date: Mon,  4 Apr 2011 15:58:04 +0100
Message-Id: <1301929084-2025-1-git-send-email-matt@console-pimps.org>
X-Mailer: git-send-email 1.7.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matt Fleming <matt.fleming@linux.intel.com>

We can delete the code that checks to see if we're sending an ignored
signal to init because force_sig_info() already handles this case.
force_sig_info() will kill init even if the signal handler is SIG_DFL
and the scenario described in the comment where init might "generate
the same exception over and over again" cannot occur (force_sig_info()
clears SIGNAL_UNKILLABLE to ensure that init will die).

Also, the use of is_global_init() is not correct in the multhreaded
case, as Oleg Nesterov explains,

	"is_global_init() is not right in theory, /sbin/init can be
	multithreaded. And, this doesn't cover the sub-namespace
	inits... I'd suggest to check SIGNAL_UNKILLABLE, but looking
	closer I think you can simply remove this code."

It seems this code was copied from arch/powerpc in March 2007 in commit

  623b0355d5b1 "[AVR32] Clean up exception handling code"

but the code was deleted from arch/powerpc in November 2009 in commit

  a0592d42fe3e "powerpc: kill the obsolete code under is_global_init()"

So catch up with powerpc and delete the bogus code.

Signed-off-by: Matt Fleming <matt.fleming@linux.intel.com>
---
 arch/avr32/kernel/traps.c |   22 ----------------------
 1 files changed, 0 insertions(+), 22 deletions(-)

diff --git a/arch/avr32/kernel/traps.c b/arch/avr32/kernel/traps.c
index b91b204..7aa2575 100644
--- a/arch/avr32/kernel/traps.c
+++ b/arch/avr32/kernel/traps.c
@@ -95,28 +95,6 @@ void _exception(long signr, struct pt_regs *regs, int code,
 	info.si_code = code;
 	info.si_addr = (void __user *)addr;
 	force_sig_info(signr, &info, current);
-
-	/*
-	 * Init gets no signals that it doesn't have a handler for.
-	 * That's all very well, but if it has caused a synchronous
-	 * exception and we ignore the resulting signal, it will just
-	 * generate the same exception over and over again and we get
-	 * nowhere.  Better to kill it and let the kernel panic.
-	 */
-	if (is_global_init(current)) {
-		__sighandler_t handler;
-
-		spin_lock_irq(&current->sighand->siglock);
-		handler = current->sighand->action[signr-1].sa.sa_handler;
-		spin_unlock_irq(&current->sighand->siglock);
-		if (handler == SIG_DFL) {
-			/* init has generated a synchronous exception
-			   and it doesn't have a handler for the signal */
-			printk(KERN_CRIT "init has generated signal %ld "
-			       "but has no handler for it\n", signr);
-			do_exit(signr);
-		}
-	}
 }
 
 asmlinkage void do_nmi(unsigned long ecr, struct pt_regs *regs)
-- 
1.7.4

