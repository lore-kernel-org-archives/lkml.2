Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757645Ab0IJBxx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 21:53:53 -0400
Received: from hera.kernel.org ([140.211.167.34]:48287 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757614Ab0IJBxv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 21:53:51 -0400
Date: Fri, 10 Sep 2010 01:48:39 GMT
From: tip-bot for Brian Gerst <brgerst@gmail.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        brgerst@gmail.com, penberg@kernel.org, suresh.b.siddha@intel.com,
        tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        brgerst@gmail.com, penberg@kernel.org, suresh.b.siddha@intel.com,
        tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1283563039-3466-9-git-send-email-brgerst@gmail.com>
References: <1283563039-3466-9-git-send-email-brgerst@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/fpu] x86-32, fpu: Remove math_emulate stub
Message-ID: <tip-a334fe43d85f570ae907acf988a053c5eff78d6e@git.kernel.org>
Git-Commit-ID: a334fe43d85f570ae907acf988a053c5eff78d6e
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 10 Sep 2010 01:48:39 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a334fe43d85f570ae907acf988a053c5eff78d6e
Gitweb:     http://git.kernel.org/tip/a334fe43d85f570ae907acf988a053c5eff78d6e
Author:     Brian Gerst <brgerst@gmail.com>
AuthorDate: Fri, 3 Sep 2010 21:17:15 -0400
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Thu, 9 Sep 2010 14:17:11 -0700

x86-32, fpu: Remove math_emulate stub

check_fpu() in bugs.c halts boot if no FPU is found and math emulation
isn't enabled.  Therefore this stub will never be used.

Signed-off-by: Brian Gerst <brgerst@gmail.com>
Acked-by: Pekka Enberg <penberg@kernel.org>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>
LKML-Reference: <1283563039-3466-9-git-send-email-brgerst@gmail.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/kernel/traps.c |   23 ++++++-----------------
 1 files changed, 6 insertions(+), 17 deletions(-)

diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index d0029eb..d439685 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -776,21 +776,10 @@ asmlinkage void math_state_restore(void)
 }
 EXPORT_SYMBOL_GPL(math_state_restore);
 
-#ifndef CONFIG_MATH_EMULATION
-void math_emulate(struct math_emu_info *info)
-{
-	printk(KERN_EMERG
-		"math-emulation not enabled and no coprocessor found.\n");
-	printk(KERN_EMERG "killing %s.\n", current->comm);
-	force_sig(SIGFPE, current);
-	schedule();
-}
-#endif /* CONFIG_MATH_EMULATION */
-
 dotraplinkage void __kprobes
 do_device_not_available(struct pt_regs *regs, long error_code)
 {
-#ifdef CONFIG_X86_32
+#ifdef CONFIG_MATH_EMULATION
 	if (read_cr0() & X86_CR0_EM) {
 		struct math_emu_info info = { };
 
@@ -798,12 +787,12 @@ do_device_not_available(struct pt_regs *regs, long error_code)
 
 		info.regs = regs;
 		math_emulate(&info);
-	} else {
-		math_state_restore(); /* interrupts still off */
-		conditional_sti(regs);
+		return;
 	}
-#else
-	math_state_restore();
+#endif
+	math_state_restore(); /* interrupts still off */
+#ifdef CONFIG_X86_32
+	conditional_sti(regs);
 #endif
 }
 
