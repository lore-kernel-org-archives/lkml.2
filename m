Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756237Ab2EGNCW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 09:02:22 -0400
Received: from eu1sys200aog102.obsmtp.com ([207.126.144.113]:33637 "EHLO
	eu1sys200aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754153Ab2EGNCU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 09:02:20 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: Samuel Ortiz <sameo@linux.intel.com>, <linux-kernel@vger.kernel.org>
Cc: Michel JAOUEN <michel.jaouen@stericsson.com>,
        Maxime Coquelin <maxime.coquelin@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 5/6 v2] mfd/ab8500: support of hierachical interrupt
Date: Mon, 7 May 2012 15:02:03 +0200
Message-ID: <1336395723-32138-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.9.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michel JAOUEN <michel.jaouen@stericsson.com>

Hierarchical interrupt is supported since ab8500 V2.
However, it is not implemented in the ab8500-core driver.
With the current implementation, when an ab9540 interrupt
occurs, 17 Latch registers are read through i2c. With
hierarchical interrupt implementation, there are only 4 i2c
accesses.

Signed-off-by: Maxime Coquelin <maxime.coquelin@stericsson.com>
Reviewed-by: Michel Jaouen <michel.jaouen@stericsson.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
ChangeLog v1->v2: unnest the interrupt handler function at
                  Sam's request. This should apply fine on top
		  of the already applied stuff for AB8500 MFD.
---
 drivers/mfd/ab8500-core.c |  108 +++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 105 insertions(+), 3 deletions(-)

diff --git a/drivers/mfd/ab8500-core.c b/drivers/mfd/ab8500-core.c
index c79d354..2625eee 100644
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
@@ -340,6 +349,90 @@ static struct irq_chip ab8500_irq_chip = {
 	.irq_unmask		= ab8500_irq_unmask,
 };
 
+static int ab8500_handle_hierarchical_line(struct ab8500 *ab8500,
+					int latch_offset, u8 latch_val)
+{
+	int int_bit = __ffs(latch_val);
+	int line, i;
+
+	do {
+		int_bit = __ffs(latch_val);
+
+		for (i = 0; i < ab8500->mask_size; i++)
+			if (ab8500->irq_reg_offset[i] == latch_offset)
+				break;
+
+		if (i >= ab8500->mask_size) {
+			dev_err(ab8500->dev, "Register offset 0x%2x not declared\n",
+					latch_offset);
+			return -ENXIO;
+		}
+
+		line = (i << 3) + int_bit;
+		latch_val &= ~(1 << int_bit);
+
+		handle_nested_irq(ab8500->irq_base + line);
+	} while (latch_val);
+
+	return 0;
+}
+
+static int ab8500_handle_hierarchical_latch(struct ab8500 *ab8500,
+					int hier_offset, u8 hier_val)
+{
+	int latch_bit, status;
+	u8 latch_offset, latch_val;
+
+	do {
+		latch_bit = __ffs(hier_val);
+		latch_offset = (hier_offset << 3) + latch_bit;
+
+		/* Fix inconsistent ITFromLatch25 bit mapping... */
+		if (unlikely(latch_offset == 17))
+			latch_offset = 24;
+
+		status = get_register_interruptible(ab8500,
+				AB8500_INTERRUPT,
+				AB8500_IT_LATCH1_REG + latch_offset,
+				&latch_val);
+		if (status < 0 || latch_val == 0)
+			goto discard;
+
+		status = ab8500_handle_hierarchical_line(ab8500,
+				latch_offset, latch_val);
+		if (status < 0)
+			return status;
+discard:
+		hier_val &= ~(1 << latch_bit);
+	} while (hier_val);
+
+	return 0;
+}
+
+static irqreturn_t ab8500_hierarchical_irq(int irq, void *dev)
+{
+	struct ab8500 *ab8500 = dev;
+	u8 i;
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
+		status = ab8500_handle_hierarchical_latch(ab8500, i, hier_val);
+		if (status < 0)
+			break;
+	}
+	return IRQ_HANDLED;
+}
+
 static irqreturn_t ab8500_irq(int irq, void *dev)
 {
 	struct ab8500 *ab8500 = dev;
@@ -1203,9 +1296,18 @@ int __devinit ab8500_init(struct ab8500 *ab8500, enum ab8500_version version)
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

