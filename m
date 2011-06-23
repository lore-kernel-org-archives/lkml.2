Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934113Ab1FWR4r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 13:56:47 -0400
Received: from mail.windriver.com ([147.11.1.11]:35160 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933626Ab1FWRho (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 13:37:44 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Anton Blanchard <anton@samba.org>,
        Milton Miller <miltonm@bga.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 157/247] powerpc: Use more accurate limit for first segment memory allocations
Date: Thu, 23 Jun 2011 13:33:45 -0400
Message-Id: <1308850515-15242-98-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1308850515-15242-1-git-send-email-paul.gortmaker@windriver.com>
References: <1308849690-14530-1-git-send-email-paul.gortmaker@windriver.com>
 <1308850515-15242-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Anton Blanchard <anton@samba.org>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 095c7965f4dc870ed2b65143b1e2610de653416c upstream.

Author: Milton Miller <miltonm@bga.com>

On large machines we are running out of room below 256MB. In some cases we
only need to ensure the allocation is in the first segment, which may be
256MB or 1TB.

Add slb0_limit and use it to specify the upper limit for the irqstack and
emergency stacks.

On a large ppc64 box, this fixes a panic at boot when the crashkernel=
option is specified (previously we would run out of memory below 256MB).

Signed-off-by: Milton Miller <miltonm@bga.com>
Signed-off-by: Anton Blanchard <anton@samba.org>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 arch/powerpc/kernel/setup_64.c |   17 +++++++++++++----
 1 files changed, 13 insertions(+), 4 deletions(-)

diff --git a/arch/powerpc/kernel/setup_64.c b/arch/powerpc/kernel/setup_64.c
index 9143891..d44e38b 100644
--- a/arch/powerpc/kernel/setup_64.c
+++ b/arch/powerpc/kernel/setup_64.c
@@ -424,9 +424,18 @@ void __init setup_system(void)
 	DBG(" <- setup_system()\n");
 }
 
+static u64 slb0_limit(void)
+{
+	if (cpu_has_feature(CPU_FTR_1T_SEGMENT)) {
+		return 1UL << SID_SHIFT_1T;
+	}
+	return 1UL << SID_SHIFT;
+}
+
 #ifdef CONFIG_IRQSTACKS
 static void __init irqstack_early_init(void)
 {
+	u64 limit = slb0_limit();
 	unsigned int i;
 
 	/*
@@ -436,10 +445,10 @@ static void __init irqstack_early_init(void)
 	for_each_possible_cpu(i) {
 		softirq_ctx[i] = (struct thread_info *)
 			__va(lmb_alloc_base(THREAD_SIZE,
-					    THREAD_SIZE, 0x10000000));
+					    THREAD_SIZE, limit));
 		hardirq_ctx[i] = (struct thread_info *)
 			__va(lmb_alloc_base(THREAD_SIZE,
-					    THREAD_SIZE, 0x10000000));
+					    THREAD_SIZE, limit));
 	}
 }
 #else
@@ -470,7 +479,7 @@ static void __init exc_lvl_early_init(void)
  */
 static void __init emergency_stack_init(void)
 {
-	unsigned long limit;
+	u64 limit;
 	unsigned int i;
 
 	/*
@@ -482,7 +491,7 @@ static void __init emergency_stack_init(void)
 	 * bringup, we need to get at them in real mode. This means they
 	 * must also be within the RMO region.
 	 */
-	limit = min(0x10000000ULL, lmb.rmo_size);
+	limit = min(slb0_limit(), lmb.rmo_size);
 
 	for_each_possible_cpu(i) {
 		unsigned long sp;
-- 
1.7.4.4

