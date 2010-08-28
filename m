Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753362Ab0H1QGO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Aug 2010 12:06:14 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:44080 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752882Ab0H1QGN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Aug 2010 12:06:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=ikNeqbO/uvsJ754ZxYKIqSLm5bATpvJSJOx0dwydvUSLZnGnRFKUdC0XC3ShEo3yyX
         pT5hbNsGJkNC+kTKQjuLxsc57LmH6r1wbcZsmj/0ZwC0QUgYQQSYT8CwjqxZDKa078JU
         WU8IDXIkKtUgM7hgTj+YK0HSMfr5mL72pj7UI=
From: Brian Gerst <brgerst@gmail.com>
To: hpa@zytor.com
Cc: x86@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 06/11] x86-64: Fix %cs value in convert_from_fxsr()
Date: Sat, 28 Aug 2010 12:04:33 -0400
Message-Id: <1283011478-27237-7-git-send-email-brgerst@gmail.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <1283011478-27237-1-git-send-email-brgerst@gmail.com>
References: <1283011478-27237-1-git-send-email-brgerst@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While %ds still contains the userspace selector, %cs is KERNEL_CS
at this point.  Always get %cs from pt_regs.

It actually is possible to get the correct segments for compat tasks,
but that involves using the [f]xsave instruction without a REX.W prefix.

Signed-off-by: Brian Gerst <brgerst@gmail.com>
---
 arch/x86/kernel/i387.c |   18 ++++++++----------
 1 files changed, 8 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kernel/i387.c b/arch/x86/kernel/i387.c
index c795675..b1a732d 100644
--- a/arch/x86/kernel/i387.c
+++ b/arch/x86/kernel/i387.c
@@ -383,19 +383,17 @@ convert_from_fxsr(struct user_i387_ia32_struct *env, struct task_struct *tsk)
 #ifdef CONFIG_X86_64
 	env->fip = fxsave->rip;
 	env->foo = fxsave->rdp;
+	/*
+	 * should be actually ds/cs at fpu exception time, but
+	 * that information is not available in 64bit mode.
+	 */
+	env->fcs = task_pt_regs(tsk)->cs;
 	if (tsk == current) {
-		/*
-		 * should be actually ds/cs at fpu exception time, but
-		 * that information is not available in 64bit mode.
-		 */
-		asm("mov %%ds, %[fos]" : [fos] "=r" (env->fos));
-		asm("mov %%cs, %[fcs]" : [fcs] "=r" (env->fcs));
+		savesegment(ds, env->fos);
 	} else {
-		struct pt_regs *regs = task_pt_regs(tsk);
-
-		env->fos = 0xffff0000 | tsk->thread.ds;
-		env->fcs = regs->cs;
+		env->fos = tsk->thread.ds;
 	}
+	env->fos |= 0xffff0000;
 #else
 	env->fip = fxsave->fip;
 	env->fcs = (u16) fxsave->fcs | ((u32) fxsave->fop << 16);
-- 
1.7.2.2

