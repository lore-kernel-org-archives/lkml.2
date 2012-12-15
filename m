Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932132Ab2LOEfS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 23:35:18 -0500
Received: from smtp.polymtl.ca ([132.207.4.11]:58237 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751440Ab2LOEfI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 23:35:08 -0500
From: Simon Marchi <simon.marchi@polymtl.ca>
To: cmetcalf@tilera.com
Cc: linux-kernel@vger.kernel.org, Simon Marchi <simon.marchi@polymtl.ca>
Subject: [PATCH 2/3] arch/tile: implement arch_ptrace using user_regset on tilegx
Date: Fri, 14 Dec 2012 23:34:50 -0500
Message-Id: <1355546091-32537-2-git-send-email-simon.marchi@polymtl.ca>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1355546091-32537-1-git-send-email-simon.marchi@polymtl.ca>
References: <1355546091-32537-1-git-send-email-simon.marchi@polymtl.ca>
X-Poly-FromMTA: ([132.207.72.18]) at Sat, 15 Dec 2012 04:34:59 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch changes arch_ptrace on tilegx so that it uses the user_regset
to implement the PTRACE_GETREGS and PTRACE_SETREGS operations.

The ifdefs and the old code can be removed when user_regset support for
the older architectures is there.

Signed-off-by: Simon Marchi <simon.marchi@polymtl.ca>
---
 arch/tile/kernel/ptrace.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/arch/tile/kernel/ptrace.c b/arch/tile/kernel/ptrace.c
index 0e68d06..9435dd1 100644
--- a/arch/tile/kernel/ptrace.c
+++ b/arch/tile/kernel/ptrace.c
@@ -196,18 +196,28 @@ long arch_ptrace(struct task_struct *child, long request,
 		break;
 
 	case PTRACE_GETREGS:  /* Get all registers from the child. */
+#ifdef __tilegx__
+		ret = copy_regset_to_user(child, &tile_user_regset_view, REGSET_GPR,
+					  0, sizeof(struct pt_regs), datap);
+#else /* __tilegx__ */
 		if (copy_to_user(datap, getregs(child, &copyregs),
 				 sizeof(struct pt_regs)) == 0) {
 			ret = 0;
 		}
+#endif /* __tilegx__ */
 		break;
 
 	case PTRACE_SETREGS:  /* Set all registers in the child. */
+#ifdef __tilegx__
+		ret = copy_regset_from_user(child, &tile_user_regset_view, REGSET_GPR,
+					    0, sizeof(struct pt_regs), datap);
+#else /* __tilegx__ */
 		if (copy_from_user(&copyregs, datap,
 				   sizeof(struct pt_regs)) == 0) {
 			putregs(child, &copyregs);
 			ret = 0;
 		}
+#endif /* __tilegx__ */
 		break;
 
 	case PTRACE_GETFPREGS:  /* Get the child FPU state. */
-- 
1.7.1

