Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753178Ab0H1QFx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Aug 2010 12:05:53 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:48411 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753019Ab0H1QFv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Aug 2010 12:05:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=bEmQ9pNSH/+q0ervY9BJzwoKqf5viiMBBDiAJIr+bSKdV+uEoKnfrgVl/1tYGhA8+l
         jepVEbaFxlcKG19jZr2SjX5x+xmACqrSefQLoDJHBf7z8ySJLCrjSBBoH+vfJBSI1dnZ
         p3bUpsHo62nViaaAXtGFf5UMIjgbf8VeMgBcY=
From: Brian Gerst <brgerst@gmail.com>
To: hpa@zytor.com
Cc: x86@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 08/11] x86-32: Remove math_emulate stub
Date: Sat, 28 Aug 2010 12:04:35 -0400
Message-Id: <1283011478-27237-9-git-send-email-brgerst@gmail.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <1283011478-27237-1-git-send-email-brgerst@gmail.com>
References: <1283011478-27237-1-git-send-email-brgerst@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

check_fpu() in bugs.c halts boot if no FPU is found and math emulation
isn't enabled.  Therefore this stub will never be used.

Signed-off-by: Brian Gerst <brgerst@gmail.com>
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
 
-- 
1.7.2.2

