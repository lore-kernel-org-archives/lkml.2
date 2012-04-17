Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754804Ab2DQHbG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 03:31:06 -0400
Received: from eu1sys200aog111.obsmtp.com ([207.126.144.131]:51180 "EHLO
	eu1sys200aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754137Ab2DQHbD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 03:31:03 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: Samuel Ortiz <sameo@linux.intel.com>, <linux-kernel@vger.kernel.org>
Cc: Michel JAOUEN <michel.jaouen@stericsson.com>,
        Maxime Coquelin <maxime.coquelin@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 5/6] mfd/ab8500: support of hierachical interrupt
Date: Tue, 17 Apr 2012 09:30:49 +0200
Message-ID: <1334647849-1773-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.9.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michel JAOUEN <michel.jaouen@stericsson.com>

Hierarchical interrupt is supported since ab8500 V2.
However, it is not implemented in ab8500-core driver.
With curent implementation, when an ab9540 interrupt occurs,
17 Latch registers are read through i2c. With hierarchical
interrupt implementation, there is only 4 i2c accesses.

Signed-off-by: Maxime Coquelin <maxime.coquelin@stericsson.com>
Tested-by: Michel Jaouen <michel.jaouen@stericsson.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/mfd/ab8500-core.c |   85 +++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 82 insertions(+), 3 deletions(-)

diff --git a/drivers/mfd/ab8500-core.c b/drivers/mfd/ab8500-core.c
index 9781e1e..8e56fd1 100644
--- a/drivers/mfd/ab8500-core.c
+++ b/drivers/mfd/ab8500-core.c
@@ -91,6 +91,15 @@
 #define AB8500_IT_MASK23_REG		0x56
 #define AB8500_IT_MASK24_REG		0x57
 
+/*
+ * latch hierarchy registers
+ */
+#define AB8500_IT_LATCHHIER1_REG	0x60
+#define AB8500_IT_LATCHHIER2_REG	0x61
+#define AB8500_IT_LATCHHIER3_REG	0x62
+
+#define AB8500_IT_LATCHHIER_NUM		3
+
 #define AB8500_REV_REG			0x80
 #define AB8500_IC_NAME_REG		0x82
 #define AB8500_SWITCH_OFF_STATUS	0x00
@@ -337,6 +346,67 @@ static struct irq_chip ab8500_irq_chip = {
 	.irq_unmask		= ab8500_irq_unmask,
 };
 
+static irqreturn_t ab8500_hierarchical_irq(int irq, void *dev)
+{
+	struct ab8500 *ab8500 = dev;
+	int i;
+
+	dev_vdbg(ab8500->dev, "interrupt\n");
+
+	/*  Hierarchical interrupt version */
+	for (i = 0; i < AB8500_IT_LATCHHIER_NUM; i++) {
+		int status;
+		u8 hier_val;
+
+		status = get_register_interruptible(ab8500, AB8500_INTERRUPT,
+			AB8500_IT_LATCHHIER1_REG + i, &hier_val);
+		if (status < 0 || hier_val == 0)
+			continue;
+
+		do {
+			int latch_bit = __ffs(hier_val);
+			u8 offset = i * 8 + latch_bit;
+			u8 latch_val;
+
+			/* Fix inconsistent ITFromLatch25 bit mapping... */
+			if (unlikely(offset == 17))
+				offset = 24;
+
+			status = get_register_interruptible(ab8500,
+					AB8500_INTERRUPT,
+					AB8500_IT_LATCH1_REG + offset,
+					&latch_val);
+			if (status < 0 || latch_val == 0)
+				goto discard;
+
+			do {
+				int int_bit = __ffs(latch_val);
+				int line;
+				int j;
+
+				for (j = 0; j < ab8500->mask_size; j++)
+					if (ab8500->irq_reg_offset[j] == offset)
+						break;
+
+				if (j >= ab8500->mask_size) {
+					dev_err(ab8500->dev,
+							"Register offset 0x%2x not declared\n",
+							offset);
+					return IRQ_HANDLED;
+				}
+
+				line = j * 8 + int_bit;
+
+				handle_nested_irq(ab8500->irq_base + line);
+				latch_val &= ~(1 << int_bit);
+			} while (latch_val);
+discard:
+			hier_val &= ~(1 << latch_bit);
+		} while (hier_val);
+	}
+	return IRQ_HANDLED;
+}
+
 static irqreturn_t ab8500_irq(int irq, void *dev)
 {
 	struct ab8500 *ab8500 = dev;
@@ -1196,9 +1266,18 @@ int __devinit ab8500_init(struct ab8500 *ab8500, enum ab8500_version version)
 		if (ret)
 			goto out_freeoldmask;
 
-		ret = request_threaded_irq(ab8500->irq, NULL, ab8500_irq,
-					   IRQF_ONESHOT | IRQF_NO_SUSPEND,
-					   "ab8500", ab8500);
+		/*  Activate this feature only in ab9540 */
+		/*  till tests are done on ab8500 1p2 or later*/
+		if (is_ab9540(ab8500))
+			ret = request_threaded_irq(ab8500->irq, NULL,
+					ab8500_hierarchical_irq,
+					IRQF_ONESHOT | IRQF_NO_SUSPEND,
+					"ab8500", ab8500);
+		else
+			ret = request_threaded_irq(ab8500->irq, NULL,
+					ab8500_irq,
+					IRQF_ONESHOT | IRQF_NO_SUSPEND,
+					"ab8500", ab8500);
 		if (ret)
 			goto out_removeirq;
 	}
-- 
1.7.9.2

