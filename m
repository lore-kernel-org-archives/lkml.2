Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754188Ab1AZXEP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 18:04:15 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:6897 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752824Ab1AZXEO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 18:04:14 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6238"; a="71891034"
From: Stephen Boyd <sboyd@codeaurora.org>
To: Russell King <linux@arm.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH] ARM: Fix SMP_ON_UP for non ARM ltd. implementations
Date: Wed, 26 Jan 2011 15:04:12 -0800
Message-Id: <1296083052-20034-1-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.7.4.rc3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The SMP_ON_UP checks restrict the feature to ARM limited designs,
when other implementers support SMP designs. Instead of checking
for an ARM CPU and ARMv6/v7 just check for a v6 or v7 and then
rely on the MPIDR for non ARM 11MPCore designs.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 arch/arm/kernel/head.S |   13 +++++++++----
 1 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/arch/arm/kernel/head.S b/arch/arm/kernel/head.S
index f17d9a0..ede5b70 100644
--- a/arch/arm/kernel/head.S
+++ b/arch/arm/kernel/head.S
@@ -393,20 +393,25 @@ ENDPROC(__turn_mmu_on)
 #ifdef CONFIG_SMP_ON_UP
 __fixup_smp:
 	mov	r4, #0x00070000
-	orr	r3, r4, #0xff000000	@ mask 0xff070000
-	orr	r4, r4, #0x41000000	@ val 0x41070000
-	and	r0, r9, r3
-	teq	r0, r4			@ ARM CPU and ARMv6/v7?
+	and	r0, r9, r4
+	teq	r0, r4			@ ARMv6/v7?
 	bne	__fixup_smp_on_up	@ no, assume UP
 
+	orr	r3, r4, #0xff000000	@ mask 0xff070000
 	orr	r3, r3, #0x0000ff00
 	orr	r3, r3, #0x000000f0	@ mask 0xff07fff0
+	orr	r4, r4, #0x41000000	@ val 0x41070000
 	orr	r4, r4, #0x0000b000
 	orr	r4, r4, #0x00000020	@ val 0x4107b020
 	and	r0, r9, r3
 	teq	r0, r4			@ ARM 11MPCore?
 	moveq	pc, lr			@ yes, assume SMP
 
+	mov	r4, #0x00070000
+	and	r0, r9, #0x000f0000
+	teq	r0, r4			@ ARMv6?
+	beq	__fixup_smp_on_up	@ yes, assume UP
+
 	mrc	p15, 0, r0, c0, c0, 5	@ read MPIDR
 	tst	r0, #1 << 31
 	movne	pc, lr			@ bit 31 => SMP
-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

