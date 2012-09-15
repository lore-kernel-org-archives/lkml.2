Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752279Ab2IOHmn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Sep 2012 03:42:43 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:20884 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750980Ab2IOHmk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Sep 2012 03:42:40 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6835"; a="237168021"
From: Rohit Vaswani <rvaswani@codeaurora.org>
To: Marc Zyngier <marc.zyngier@arm.com>, David Brown <davidb@codeaurora.org>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Daniel Walker <dwalker@fifo99.com>,
        Russell King <linux@arm.linux.org.uk>
Cc: Rohit Vaswani <rvaswani@codeaurora.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 RESEND 1/2] ARM: arch timer: Set the TVAL before timer is enabled
Date: Sat, 15 Sep 2012 00:41:53 -0700
Message-Id: <1347694914-1457-1-git-send-email-rvaswani@codeaurora.org>
X-Mailer: git-send-email 1.7.8.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On some hardware, the timer deasserts the interrupt when a
new TVAL is written only when the enable bit is cleared.
Hence explicitly disable the timer and then program the
TVAL followed by enabling the timer.
If this order is not followed, there are chances that
you would not receive any timer interrupts.

Signed-off-by: Rohit Vaswani <rvaswani@codeaurora.org>
---
 arch/arm/kernel/arch_timer.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/arm/kernel/arch_timer.c b/arch/arm/kernel/arch_timer.c
index c04c2a6..8672a75 100644
--- a/arch/arm/kernel/arch_timer.c
+++ b/arch/arm/kernel/arch_timer.c
@@ -206,9 +206,10 @@ static inline void set_next_event(const int access, unsigned long evt)
 {
 	unsigned long ctrl;
 	ctrl = arch_timer_reg_read(access, ARCH_TIMER_REG_CTRL);
-	ctrl |= ARCH_TIMER_CTRL_ENABLE;
-	ctrl &= ~ARCH_TIMER_CTRL_IT_MASK;
+	ctrl &= ~(ARCH_TIMER_CTRL_ENABLE | ARCH_TIMER_CTRL_IT_MASK);
+	arch_timer_reg_write(access, ARCH_TIMER_REG_CTRL, ctrl);
 	arch_timer_reg_write(access, ARCH_TIMER_REG_TVAL, evt);
+	ctrl |= ARCH_TIMER_CTRL_ENABLE;
 	arch_timer_reg_write(access, ARCH_TIMER_REG_CTRL, ctrl);
 }
 
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

