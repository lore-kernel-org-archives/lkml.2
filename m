Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757694Ab2JYGn4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 02:43:56 -0400
Received: from mail.windriver.com ([147.11.1.11]:36666 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752516Ab2JYGnx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 02:43:53 -0400
From: Tiejun Chen <tiejun.chen@windriver.com>
To: <benh@kernel.crashing.org>
CC: <jason.wessel@windriver.com>, <linuxppc-dev@lists.ozlabs.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/3] powerpc/book3e: load critical/machine/debug exception stack
Date: Thu, 25 Oct 2012 14:43:28 +0800
Message-ID: <1351147410-17452-1-git-send-email-tiejun.chen@windriver.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We always alloc critical/machine/debug check exceptions. This is
different from the normal exception. So we should load these exception
stack properly like we did for booke.

Signed-off-by: Tiejun Chen <tiejun.chen@windriver.com>
---
 arch/powerpc/kernel/exceptions-64e.S |   27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/arch/powerpc/kernel/exceptions-64e.S b/arch/powerpc/kernel/exceptions-64e.S
index 4684e33..43b654a 100644
--- a/arch/powerpc/kernel/exceptions-64e.S
+++ b/arch/powerpc/kernel/exceptions-64e.S
@@ -36,6 +36,30 @@
  */
 #define	SPECIAL_EXC_FRAME_SIZE	INT_FRAME_SIZE
 
+/* only on book3e */
+#define DBG_STACK_BASE		dbgirq_ctx
+#define MC_STACK_BASE		mcheckirq_ctx
+#define CRIT_STACK_BASE		critirq_ctx
+
+#ifdef CONFIG_SMP
+#define BOOK3E_LOAD_EXC_LEVEL_STACK(level)		\
+	std	r14,PACA_EX##level+EX_R14(r13);		\
+	mfspr	r14,SPRN_PIR;				\
+	slwi	r14,r14,3;				\
+	LOAD_REG_ADDR(r10, level##_STACK_BASE);		\
+	add	r10,r10,r14;				\
+	ld	r10,0(r10);				\
+	addi	r10,r10,THREAD_SIZE;			\
+	std	r10,PACA_DBG_STACK(r13);		\
+	ld	r14,PACA_EX##level+EX_R14(r13);
+#else
+#define BOOK3E_LOAD_EXC_LEVEL_STACK(level)		\
+	LOAD_REG_ADDR(r10, level##_STACK_BASE);		\
+	ld	r10,0(r10);				\
+	addi	r10,r10,THREAD_SIZE;			\
+	std	r10,PACA_DBG_STACK(r13);
+#endif
+
 /* Exception prolog code for all exceptions */
 #define EXCEPTION_PROLOG(n, intnum, type, addition)	    		    \
 	mtspr	SPRN_SPRG_##type##_SCRATCH,r13;	/* get spare registers */   \
@@ -68,18 +92,21 @@
 #define SPRN_GDBELL_SRR1	SPRN_GSRR1
 
 #define CRIT_SET_KSTACK						            \
+	BOOK3E_LOAD_EXC_LEVEL_STACK(CRIT);					\
 	ld	r1,PACA_CRIT_STACK(r13);				    \
 	subi	r1,r1,SPECIAL_EXC_FRAME_SIZE;
 #define SPRN_CRIT_SRR0	SPRN_CSRR0
 #define SPRN_CRIT_SRR1	SPRN_CSRR1
 
 #define DBG_SET_KSTACK						            \
+	BOOK3E_LOAD_EXC_LEVEL_STACK(DBG);					\
 	ld	r1,PACA_DBG_STACK(r13);					    \
 	subi	r1,r1,SPECIAL_EXC_FRAME_SIZE;
 #define SPRN_DBG_SRR0	SPRN_DSRR0
 #define SPRN_DBG_SRR1	SPRN_DSRR1
 
 #define MC_SET_KSTACK						            \
+	BOOK3E_LOAD_EXC_LEVEL_STACK(MC);					\
 	ld	r1,PACA_MC_STACK(r13);					    \
 	subi	r1,r1,SPECIAL_EXC_FRAME_SIZE;
 #define SPRN_MC_SRR0	SPRN_MCSRR0
-- 
1.7.9.5

