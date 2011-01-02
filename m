Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754739Ab1ABHZM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 02:25:12 -0500
Received: from mail.windriver.com ([147.11.1.11]:36904 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754697Ab1ABHZI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 02:25:08 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Michael Neuling <mikey@neuling.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 207/260] powerpc: Don't use kernel stack with translation off
Date: Sun,  2 Jan 2011 02:18:23 -0500
Message-Id: <1293952756-15010-208-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.3.3
In-Reply-To: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
References: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
X-OriginalArrivalTime: 02 Jan 2011 07:23:57.0026 (UTC) FILETIME=[04861C20:01CBAA4E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Neuling <mikey@neuling.org>

commit 54a834043314c257210db2a9d59f8cc605571639 upstream.

In f761622e59433130bc33ad086ce219feee9eb961 we changed
early_setup_secondary so it's called using the proper kernel stack
rather than the emergency one.

Unfortunately, this stack pointer can't be used when translation is off
on PHYP as this stack pointer might be outside the RMO.  This results in
the following on all non zero cpus:
  cpu 0x1: Vector: 300 (Data Access) at [c00000001639fd10]
      pc: 000000000001c50c
      lr: 000000000000821c
      sp: c00000001639ff90
     msr: 8000000000001000
     dar: c00000001639ffa0
   dsisr: 42000000
    current = 0xc000000016393540
    paca    = 0xc000000006e00200
      pid   = 0, comm = swapper

The original patch was only tested on bare metal system, so it never
caught this problem.

This changes __secondary_start so that we calculate the new stack
pointer but only start using it after we've called early_setup_secondary.

With this patch, the above problem goes away.

Signed-off-by: Michael Neuling <mikey@neuling.org>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 arch/powerpc/kernel/head_64.S |   12 +++++++++---
 1 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/arch/powerpc/kernel/head_64.S b/arch/powerpc/kernel/head_64.S
index 579751e..ad90636 100644
--- a/arch/powerpc/kernel/head_64.S
+++ b/arch/powerpc/kernel/head_64.S
@@ -575,13 +575,19 @@ __secondary_start:
 	/* Initialize the kernel stack.  Just a repeat for iSeries.	 */
 	LOAD_REG_ADDR(r3, current_set)
 	sldi	r28,r24,3		/* get current_set[cpu#]	 */
-	ldx	r1,r3,r28
-	addi	r1,r1,THREAD_SIZE-STACK_FRAME_OVERHEAD
-	std	r1,PACAKSAVE(r13)
+	ldx	r14,r3,r28
+	addi	r14,r14,THREAD_SIZE-STACK_FRAME_OVERHEAD
+	std	r14,PACAKSAVE(r13)
 
 	/* Do early setup for that CPU (stab, slb, hash table pointer) */
 	bl	.early_setup_secondary
 
+	/*
+	 * setup the new stack pointer, but *don't* use this until
+	 * translation is on.
+	 */
+	mr	r1, r14
+
 	/* Clear backchain so we get nice backtraces */
 	li	r7,0
 	mtlr	r7
-- 
1.7.3.3

