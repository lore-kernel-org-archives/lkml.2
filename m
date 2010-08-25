Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753435Ab0HYE6j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Aug 2010 00:58:39 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:2664 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752833Ab0HYE6T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Aug 2010 00:58:19 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6084"; a="52012236"
X-IronPort-AV: E=Sophos;i="4.56,265,1280732400"; 
   d="scan'208";a="72366134"
From: Jeff Ohlstein <johlstei@codeaurora.org>
To: Russell King <linux@arm.linux.org.uk>
Cc: linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Daniel Walker <dwalker@codeaurora.org>,
        Abhijeet Dharmapurikar <adharmap@codeaurora.org>,
        Jeff Ohlstein <johlstei@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>
Subject: [PATCH 04/24] GIC: Dont disable INT in ack callback
Date: Tue, 24 Aug 2010 21:57:33 -0700
Message-Id: <1282712273-344-5-git-send-email-johlstei@codeaurora.org>
X-Mailer: git-send-email 1.7.2.1
In-Reply-To: <1282712273-344-1-git-send-email-johlstei@codeaurora.org>
References: <1282712273-344-1-git-send-email-johlstei@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Abhijeet Dharmapurikar <adharmap@codeaurora.org>

Unless gic_ack_irq is called from __do_IRQ, interrupt should not
be disabled in the ack function.

Signed-off-by: Abhijeet Dharmapurikar <adharmap@codeaurora.org>
Signed-off-by: Jeff Ohlstein <johlstei@codeaurora.org>
---
 arch/arm/common/gic.c |   14 --------------
 1 files changed, 0 insertions(+), 14 deletions(-)

diff --git a/arch/arm/common/gic.c b/arch/arm/common/gic.c
index 337741f..7d8ca5a 100644
--- a/arch/arm/common/gic.c
+++ b/arch/arm/common/gic.c
@@ -67,25 +67,11 @@ static inline unsigned int gic_irq(unsigned int irq)
 
 /*
  * Routines to acknowledge, disable and enable interrupts
- *
- * Linux assumes that when we're done with an interrupt we need to
- * unmask it, in the same way we need to unmask an interrupt when
- * we first enable it.
- *
- * The GIC has a separate notion of "end of interrupt" to re-enable
- * an interrupt after handling, in order to support hardware
- * prioritisation.
- *
- * We can make the GIC behave in the way that Linux expects by making
- * our "acknowledge" routine disable the interrupt, then mark it as
- * complete.
  */
 static void gic_ack_irq(unsigned int irq)
 {
-	u32 mask = 1 << (irq % 32);
 
 	spin_lock(&irq_controller_lock);
-	writel(mask, gic_dist_base(irq) + GIC_DIST_ENABLE_CLEAR + (gic_irq(irq) / 32) * 4);
 	writel(gic_irq(irq), gic_cpu_base(irq) + GIC_CPU_EOI);
 	spin_unlock(&irq_controller_lock);
 }
-- 
1.7.2.1

Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
