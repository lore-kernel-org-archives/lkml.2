Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755442Ab1CGSei (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 13:34:38 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:31477 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755288Ab1CGSeh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 13:34:37 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6278"; a="78490736"
From: Rohit Vaswani <rvaswani@codeaurora.org>
To: davidb@codeaurora.org, bryanh@codeaurora.org, linux@arm.linux.org.uk,
        dwalker@fifo99.com
Cc: dima@android.com, Rohit Vaswani <rvaswani@codeaurora.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Subject: [PATCH] msm: gpio-v2: Add missing BIT field macros for interrupt control
Date: Mon,  7 Mar 2011 10:33:52 -0800
Message-Id: <1299522832-31233-1-git-send-email-rvaswani@codeaurora.org>
X-Mailer: git-send-email 1.7.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The gpio-v2 file was missing the BIT field macros causing incorrect
values to be written at incorrect offsets within the TLMM block registers.
These registers are used for masking/unmasking interrupts and configuring them
This change fixes that problem.

Change-Id: Ib538a2d09bca039b058627ddc309a7faaaf6bc8d
Signed-off-by: Rohit Vaswani <rvaswani@codeaurora.org>
---
 arch/arm/mach-msm/gpio-v2.c |   36 ++++++++++++++++++++++++++----------
 1 files changed, 26 insertions(+), 10 deletions(-)

diff --git a/arch/arm/mach-msm/gpio-v2.c b/arch/arm/mach-msm/gpio-v2.c
index 0de19ec..fb52d6d 100644
--- a/arch/arm/mach-msm/gpio-v2.c
+++ b/arch/arm/mach-msm/gpio-v2.c
@@ -62,10 +62,10 @@ enum {
  * can be triggered but the status register will not reflect it.
  */
 enum {
-	INTR_ENABLE        = 0,
-	INTR_POL_CTL       = 1,
-	INTR_DECT_CTL      = 2,
-	INTR_RAW_STATUS_EN = 3,
+	INTR_ENABLE_BIT        = 0,
+	INTR_POL_CTL_BIT       = 1,
+	INTR_DECT_CTL_BIT      = 2,
+	INTR_RAW_STATUS_EN_BIT = 3,
 };
 
 /* Codes of interest in GPIO_INTR_CFG_SU.
@@ -75,6 +75,22 @@ enum {
 	TARGET_PROC_NONE     = 7,
 };
 
+/*
+ * When a GPIO triggers, two separate decisions are made, controlled
+ * by two separate flags.
+ *
+ * - First, INTR_RAW_STATUS_EN controls whether or not the GPIO_INTR_STATUS
+ * register for that GPIO will be updated to reflect the triggering of that
+ * gpio.  If this bit is 0, this register will not be updated.
+ * - Second, INTR_ENABLE controls whether an interrupt is triggered.
+ *
+ * If INTR_ENABLE is set and INTR_RAW_STATUS_EN is NOT set, an interrupt
+ * can be triggered but the status register will not reflect it.
+ */
+#define INTR_RAW_STATUS_EN BIT(INTR_RAW_STATUS_EN_BIT)
+#define INTR_ENABLE        BIT(INTR_ENABLE_BIT)
+#define INTR_DECT_CTL_EDGE BIT(INTR_DECT_CTL_BIT)
+#define INTR_POL_CTL_HI    BIT(INTR_POL_CTL_BIT)
 
 #define GPIO_INTR_CFG_SU(gpio)    (MSM_TLMM_BASE + 0x0400 + (0x04 * (gpio)))
 #define GPIO_CONFIG(gpio)         (MSM_TLMM_BASE + 0x1000 + (0x10 * (gpio)))
@@ -217,9 +233,9 @@ static void msm_gpio_update_dual_edge_pos(unsigned gpio)
 	do {
 		val = readl(GPIO_IN_OUT(gpio)) & BIT(GPIO_IN);
 		if (val)
-			clear_gpio_bits(BIT(INTR_POL_CTL), GPIO_INTR_CFG(gpio));
+			clear_gpio_bits(INTR_POL_CTL_HI, GPIO_INTR_CFG(gpio));
 		else
-			set_gpio_bits(BIT(INTR_POL_CTL), GPIO_INTR_CFG(gpio));
+			set_gpio_bits(INTR_POL_CTL_HI, GPIO_INTR_CFG(gpio));
 		val2 = readl(GPIO_IN_OUT(gpio)) & BIT(GPIO_IN);
 		intstat = readl(GPIO_INTR_STATUS(gpio)) & BIT(INTR_STATUS);
 		if (intstat || val == val2)
@@ -274,22 +290,22 @@ static int msm_gpio_irq_set_type(unsigned int irq, unsigned int flow_type)
 	bits = readl(GPIO_INTR_CFG(gpio));
 
 	if (flow_type & IRQ_TYPE_EDGE_BOTH) {
-		bits |= BIT(INTR_DECT_CTL);
+		bits |= INTR_DECT_CTL_EDGE;
 		irq_desc[irq].handle_irq = handle_edge_irq;
 		if ((flow_type & IRQ_TYPE_EDGE_BOTH) == IRQ_TYPE_EDGE_BOTH)
 			__set_bit(gpio, msm_gpio.dual_edge_irqs);
 		else
 			__clear_bit(gpio, msm_gpio.dual_edge_irqs);
 	} else {
-		bits &= ~BIT(INTR_DECT_CTL);
+		bits &= ~INTR_DECT_CTL_EDGE;
 		irq_desc[irq].handle_irq = handle_level_irq;
 		__clear_bit(gpio, msm_gpio.dual_edge_irqs);
 	}
 
 	if (flow_type & (IRQ_TYPE_EDGE_RISING | IRQ_TYPE_LEVEL_HIGH))
-		bits |= BIT(INTR_POL_CTL);
+		bits |= INTR_POL_CTL_HI;
 	else
-		bits &= ~BIT(INTR_POL_CTL);
+		bits &= ~INTR_POL_CTL_HI;
 
 	writel(bits, GPIO_INTR_CFG(gpio));
 
-- 
Sent by an employee of the Qualcomm Innovation Center,Inc
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

