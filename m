Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755657Ab3AFKtr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2013 05:49:47 -0500
Received: from mail1.windriver.com ([147.11.146.13]:54174 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751598Ab3AFKtp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2013 05:49:45 -0500
From: Tiejun Chen <tiejun.chen@windriver.com>
To: <benh@kernel.crashing.org>
CC: <linuxppc-dev@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>
Subject: [v0][PATCH 1/1] powerpc/book3e: disable interrupt after preempt_schedule_irq
Date: Sun, 6 Jan 2013 18:49:34 +0800
Message-ID: <1357469374-25719-1-git-send-email-tiejun.chen@windriver.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In preempt case current arch_local_irq_restore() from
preempt_schedule_irq() may enable hard interrupt but we really
should disable interrupts when we return from the interrupt,
and so that we don't get interrupted after loading SRR0/1.

Signed-off-by: Tiejun Chen <tiejun.chen@windriver.com>
---
 arch/powerpc/kernel/entry_64.S |   13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/arch/powerpc/kernel/entry_64.S b/arch/powerpc/kernel/entry_64.S
index e9a906c..4e1de34 100644
--- a/arch/powerpc/kernel/entry_64.S
+++ b/arch/powerpc/kernel/entry_64.S
@@ -662,6 +662,19 @@ resume_kernel:
 	ld	r4,TI_FLAGS(r9)
 	andi.	r0,r4,_TIF_NEED_RESCHED
 	bne	1b
+
+	/*
+	 * arch_local_irq_restore() from preempt_schedule_irq above may
+	 * enable hard interrupt but we really should disable interrupts
+	 * when we return from the interrupt, and so that we don't get
+	 * interrupted after loading SRR0/1.
+	 */
+#ifdef CONFIG_PPC_BOOK3E
+	wrteei	0
+#else
+	ld	r10,PACAKMSR(r13) /* Get kernel MSR without EE */
+	mtmsrd	r10,1		  /* Update machine state */
+#endif /* CONFIG_PPC_BOOK3E */
 #endif /* CONFIG_PREEMPT */
 
 	.globl	fast_exc_return_irq
-- 
1.7.9.5

