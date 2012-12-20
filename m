Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751799Ab2LTJIt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 04:08:49 -0500
Received: from mail1.windriver.com ([147.11.146.13]:62644 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751338Ab2LTJIm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 04:08:42 -0500
From: Tiejun Chen <tiejun.chen@windriver.com>
To: <benh@kernel.crashing.org>
CC: <linuxppc-dev@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        <jason.wessel@windriver.com>
Subject: [v1][PATCH 1/6] powerpc/book3e: load critical/machine/debug exception stack
Date: Thu, 20 Dec 2012 17:08:25 +0800
Message-ID: <1355994510-11934-2-git-send-email-tiejun.chen@windriver.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1355994510-11934-1-git-send-email-tiejun.chen@windriver.com>
References: <1355994510-11934-1-git-send-email-tiejun.chen@windriver.com>
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
 arch/powerpc/kernel/exceptions-64e.S |   40 +++++++++++++++++++++++++++++++---
 1 file changed, 37 insertions(+), 3 deletions(-)

diff --git a/arch/powerpc/kernel/exceptions-64e.S b/arch/powerpc/kernel/exceptions-64e.S
index 4684e33..376e3d1 100644
--- a/arch/powerpc/kernel/exceptions-64e.S
+++ b/arch/powerpc/kernel/exceptions-64e.S
@@ -36,6 +36,28 @@
  */
 #define	SPECIAL_EXC_FRAME_SIZE	INT_FRAME_SIZE
 
+/* only on book3e */
+#define DBG_STACK_BASE		dbgirq_ctx
+#define MC_STACK_BASE		mcheckirq_ctx
+#define CRIT_STACK_BASE		critirq_ctx
+
+#ifdef CONFIG_SMP
+#define BOOK3E_LOAD_EXC_LEVEL_STACK(level)		\
+	mfspr	r14,SPRN_PIR;				\
+	slwi	r14,r14,3;				\
+	LOAD_REG_ADDR(r10, level##_STACK_BASE);		\
+	add	r10,r10,r14;				\
+	ld	r10,0(r10);				\
+	addi	r10,r10,THREAD_SIZE;			\
+	std	r10,PACA_##level##_STACK(r13);
+#else
+#define BOOK3E_LOAD_EXC_LEVEL_STACK(level)		\
+	LOAD_REG_ADDR(r10, level##_STACK_BASE);		\
+	ld	r10,0(r10);				\
+	addi	r10,r10,THREAD_SIZE;			\
+	std	r10,PACA_##level##_STACK(r13);
+#endif
+
 /* Exception prolog code for all exceptions */
 #define EXCEPTION_PROLOG(n, intnum, type, addition)	    		    \
 	mtspr	SPRN_SPRG_##type##_SCRATCH,r13;	/* get spare registers */   \
@@ -68,20 +90,32 @@
 #define SPRN_GDBELL_SRR1	SPRN_GSRR1
 
 #define CRIT_SET_KSTACK						            \
+	andi.	r10,r11,MSR_PR;							\
+	bne	1f;								\
+	BOOK3E_LOAD_EXC_LEVEL_STACK(CRIT);					\
 	ld	r1,PACA_CRIT_STACK(r13);				    \
-	subi	r1,r1,SPECIAL_EXC_FRAME_SIZE;
+	subi	r1,r1,SPECIAL_EXC_FRAME_SIZE;					\
+1:
 #define SPRN_CRIT_SRR0	SPRN_CSRR0
 #define SPRN_CRIT_SRR1	SPRN_CSRR1
 
 #define DBG_SET_KSTACK						            \
+	andi.	r10,r11,MSR_PR;							\
+	bne	1f;								\
+	BOOK3E_LOAD_EXC_LEVEL_STACK(DBG);					\
 	ld	r1,PACA_DBG_STACK(r13);					    \
-	subi	r1,r1,SPECIAL_EXC_FRAME_SIZE;
+	subi	r1,r1,SPECIAL_EXC_FRAME_SIZE;					\
+1:
 #define SPRN_DBG_SRR0	SPRN_DSRR0
 #define SPRN_DBG_SRR1	SPRN_DSRR1
 
 #define MC_SET_KSTACK						            \
+	andi.	r10,r11,MSR_PR;							\
+	bne	1f;								\
+	BOOK3E_LOAD_EXC_LEVEL_STACK(MC);					\
 	ld	r1,PACA_MC_STACK(r13);					    \
-	subi	r1,r1,SPECIAL_EXC_FRAME_SIZE;
+	subi	r1,r1,SPECIAL_EXC_FRAME_SIZE;					\
+1:
 #define SPRN_MC_SRR0	SPRN_MCSRR0
 #define SPRN_MC_SRR1	SPRN_MCSRR1
 
-- 
1.7.9.5

