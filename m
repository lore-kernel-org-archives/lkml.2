Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753986Ab2LRBIU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 20:08:20 -0500
Received: from smtp.polymtl.ca ([132.207.4.11]:32963 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752690Ab2LRBIS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 20:08:18 -0500
From: Simon Marchi <simon.marchi@polymtl.ca>
To: cmetcalf@tilera.com
Cc: linux-kernel@vger.kernel.org, Simon Marchi <simon.marchi@polymtl.ca>
Subject: [PATCH v3 2/3] arch/tile: implement arch_ptrace using user_regset on tile
Date: Mon, 17 Dec 2012 20:08:10 -0500
Message-Id: <1355792891-16145-2-git-send-email-simon.marchi@polymtl.ca>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1355792891-16145-1-git-send-email-simon.marchi@polymtl.ca>
References: <1355792891-16145-1-git-send-email-simon.marchi@polymtl.ca>
X-Poly-FromMTA: ([132.207.72.18]) at Tue, 18 Dec 2012 01:08:12 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch changes arch_ptrace on tile so that it uses user_regset
to implement the PTRACE_GETREGS and PTRACE_SETREGS operations.

Signed-off-by: Simon Marchi <simon.marchi@polymtl.ca>
---
 arch/tile/kernel/ptrace.c |   15 ++++++---------
 1 files changed, 6 insertions(+), 9 deletions(-)

diff --git a/arch/tile/kernel/ptrace.c b/arch/tile/kernel/ptrace.c
index 882e381..9835312 100644
--- a/arch/tile/kernel/ptrace.c
+++ b/arch/tile/kernel/ptrace.c
@@ -193,18 +193,15 @@ long arch_ptrace(struct task_struct *child, long request,
 		break;
 
 	case PTRACE_GETREGS:  /* Get all registers from the child. */
-		if (copy_to_user(datap, getregs(child, &copyregs),
-				 sizeof(struct pt_regs)) == 0) {
-			ret = 0;
-		}
+		ret = copy_regset_to_user(child, &tile_user_regset_view,
+					  REGSET_GPR, 0,
+					  sizeof(struct pt_regs), datap);
 		break;
 
 	case PTRACE_SETREGS:  /* Set all registers in the child. */
-		if (copy_from_user(&copyregs, datap,
-				   sizeof(struct pt_regs)) == 0) {
-			putregs(child, &copyregs);
-			ret = 0;
-		}
+		ret = copy_regset_from_user(child, &tile_user_regset_view,
+					    REGSET_GPR, 0,
+					    sizeof(struct pt_regs), datap);
 		break;
 
 	case PTRACE_GETFPREGS:  /* Get the child FPU state. */
-- 
1.7.1

