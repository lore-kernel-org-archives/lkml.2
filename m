Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754182Ab0IDBS1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 21:18:27 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:34406 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753423Ab0IDBR7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 21:17:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=tFpblqF1psPPMUGP0Z+lrwRBM4NtR6csrJjt2pn3CjtVylRPnlaKVCC/MU7TZO8311
         wpqnP97jcVke9E2KEENJY9Ic4UPa5CBBSktX4sYaxI7w++XAg44Nzorq+CTE5hr5Xkh5
         cEf99mFSYMleZvNai20mtJqTdl1oojd6rdOXE=
From: Brian Gerst <brgerst@gmail.com>
To: hpa@zytor.com
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, penberg@kernel.org
Subject: [PATCH 06/12] x86-64: Fix %cs value in convert_from_fxsr()
Date: Fri,  3 Sep 2010 21:17:13 -0400
Message-Id: <1283563039-3466-7-git-send-email-brgerst@gmail.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <1283563039-3466-1-git-send-email-brgerst@gmail.com>
References: <1283563039-3466-1-git-send-email-brgerst@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While %ds still contains the userspace selector, %cs is KERNEL_CS at
this point.  Always get %cs from pt_regs even for the current task.

Signed-off-by: Brian Gerst <brgerst@gmail.com>
---
 arch/x86/kernel/i387.c |   18 ++++++++----------
 1 files changed, 8 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kernel/i387.c b/arch/x86/kernel/i387.c
index 1f082f3..966fdcb 100644
--- a/arch/x86/kernel/i387.c
+++ b/arch/x86/kernel/i387.c
@@ -384,19 +384,17 @@ convert_from_fxsr(struct user_i387_ia32_struct *env, struct task_struct *tsk)
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

