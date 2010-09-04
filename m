Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754260Ab0IDBSa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 21:18:30 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:49628 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753428Ab0IDBSC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 21:18:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=Gx6QcJyqByMzoI+rs5fHMoUHJgWVbUC8uqEeDgFsKJq3TsrYq4cm3pJpU/JVSyyFnl
         pWzibmQbbibMYODlNZWmYUS9abYMtT3dZLL2qIJY3iE/WPY5/9Z1b/7OdV03rAJpbocI
         g4NW0NEBJ9FN1Ni773K6LgL/QK5+PC9cKP0TE=
From: Brian Gerst <brgerst@gmail.com>
To: hpa@zytor.com
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, penberg@kernel.org
Subject: [PATCH 08/12] x86-32: Remove math_emulate stub
Date: Fri,  3 Sep 2010 21:17:15 -0400
Message-Id: <1283563039-3466-9-git-send-email-brgerst@gmail.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <1283563039-3466-1-git-send-email-brgerst@gmail.com>
References: <1283563039-3466-1-git-send-email-brgerst@gmail.com>
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

