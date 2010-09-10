Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757723Ab0IJBy3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 21:54:29 -0400
Received: from hera.kernel.org ([140.211.167.34]:48312 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757092Ab0IJByZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 21:54:25 -0400
Date: Fri, 10 Sep 2010 01:47:56 GMT
From: tip-bot for Brian Gerst <brgerst@gmail.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        brgerst@gmail.com, penberg@kernel.org, suresh.b.siddha@intel.com,
        tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        brgerst@gmail.com, penberg@kernel.org, suresh.b.siddha@intel.com,
        tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1283563039-3466-7-git-send-email-brgerst@gmail.com>
References: <1283563039-3466-7-git-send-email-brgerst@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/fpu] x86-64, fpu: Fix %cs value in convert_from_fxsr()
Message-ID: <tip-10c11f304986a1f84201c2261a428701f9d2dffc@git.kernel.org>
Git-Commit-ID: 10c11f304986a1f84201c2261a428701f9d2dffc
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 10 Sep 2010 01:47:56 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  10c11f304986a1f84201c2261a428701f9d2dffc
Gitweb:     http://git.kernel.org/tip/10c11f304986a1f84201c2261a428701f9d2dffc
Author:     Brian Gerst <brgerst@gmail.com>
AuthorDate: Fri, 3 Sep 2010 21:17:13 -0400
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Thu, 9 Sep 2010 14:16:58 -0700

x86-64, fpu: Fix %cs value in convert_from_fxsr()

While %ds still contains the userspace selector, %cs is KERNEL_CS at
this point.  Always get %cs from pt_regs even for the current task.

Signed-off-by: Brian Gerst <brgerst@gmail.com>
Acked-by: Pekka Enberg <penberg@kernel.org>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>
LKML-Reference: <1283563039-3466-7-git-send-email-brgerst@gmail.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/kernel/i387.c |   18 ++++++++----------
 1 files changed, 8 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kernel/i387.c b/arch/x86/kernel/i387.c
index 8216651..f3775f5 100644
--- a/arch/x86/kernel/i387.c
+++ b/arch/x86/kernel/i387.c
@@ -389,19 +389,17 @@ convert_from_fxsr(struct user_i387_ia32_struct *env, struct task_struct *tsk)
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
