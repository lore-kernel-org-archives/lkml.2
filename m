Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754820Ab1ABHgz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 02:36:55 -0500
Received: from mail.windriver.com ([147.11.1.11]:36905 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754662Ab1ABHZI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 02:25:08 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Matt Evans <matt@ozlabs.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 206/260] powerpc: Initialise paca->kstack before early_setup_secondary
Date: Sun,  2 Jan 2011 02:18:22 -0500
Message-Id: <1293952756-15010-207-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.3.3
In-Reply-To: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
References: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
X-OriginalArrivalTime: 02 Jan 2011 07:23:56.0010 (UTC) FILETIME=[03EB14A0:01CBAA4E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matt Evans <matt@ozlabs.org>

commit f761622e59433130bc33ad086ce219feee9eb961 upstream.

As early setup calls down to slb_initialize(), we must have kstack
initialised before checking "should we add a bolted SLB entry for our kstack?"

Failing to do so means stack access requires an SLB miss exception to refill
an entry dynamically, if the stack isn't accessible via SLB(0) (kernel text
& static data).  It's not always allowable to take such a miss, and
intermittent crashes will result.

Primary CPUs don't have this issue; an SLB entry is not bolted for their
stack anyway (as that lives within SLB(0)).  This patch therefore only
affects the init of secondaries.

Signed-off-by: Matt Evans <matt@ozlabs.org>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 arch/powerpc/kernel/head_64.S |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/powerpc/kernel/head_64.S b/arch/powerpc/kernel/head_64.S
index bed9a29..579751e 100644
--- a/arch/powerpc/kernel/head_64.S
+++ b/arch/powerpc/kernel/head_64.S
@@ -572,9 +572,6 @@ __secondary_start:
 	/* Set thread priority to MEDIUM */
 	HMT_MEDIUM
 
-	/* Do early setup for that CPU (stab, slb, hash table pointer) */
-	bl	.early_setup_secondary
-
 	/* Initialize the kernel stack.  Just a repeat for iSeries.	 */
 	LOAD_REG_ADDR(r3, current_set)
 	sldi	r28,r24,3		/* get current_set[cpu#]	 */
@@ -582,6 +579,9 @@ __secondary_start:
 	addi	r1,r1,THREAD_SIZE-STACK_FRAME_OVERHEAD
 	std	r1,PACAKSAVE(r13)
 
+	/* Do early setup for that CPU (stab, slb, hash table pointer) */
+	bl	.early_setup_secondary
+
 	/* Clear backchain so we get nice backtraces */
 	li	r7,0
 	mtlr	r7
-- 
1.7.3.3

