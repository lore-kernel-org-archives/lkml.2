Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755949Ab0GCT0A (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jul 2010 15:26:00 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:2611 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755255Ab0GCTZ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jul 2010 15:25:59 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6032"; a="46403967"
From: Gregory Bean <gbean@codeaurora.org>
To: dwalker@codeaurora.org
Cc: linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
       linux-kernel@vger.kernel.org, Gregory Bean <gbean@codeaurora.org>
Subject: [PATCH v2] msm: gpio: Add set_wake support to msm7200a-gpio's irq_chip.
Date: Sat,  3 Jul 2010 12:25:28 -0700
Message-Id: <1278185128-29161-1-git-send-email-gbean@codeaurora.org>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add power-management and irq_chip hooks to allow configuration
of msm-gpio irq lines as wakeup sources.

Signed-off-by: Gregory Bean <gbean@codeaurora.org>
---
 arch/arm/mach-msm/msm7200a-gpio.c |   72 +++++++++++++++++++++++++++++++++++-
 1 files changed, 70 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-msm/msm7200a-gpio.c b/arch/arm/mach-msm/msm7200a-gpio.c
index 1f9d53c..a490765 100644
--- a/arch/arm/mach-msm/msm7200a-gpio.c
+++ b/arch/arm/mach-msm/msm7200a-gpio.c
@@ -30,6 +30,12 @@
 #include <linux/slab.h>
 #include "msm7200a-gpio.h"
 
+enum {
+	IRQ_MASK_NORMAL = 0,
+	IRQ_MASK_WAKE_ON,
+	IRQ_MASK_MAX
+};
+
 struct msm_gpio_dev {
 	struct gpio_chip		gpio_chip;
 	spinlock_t			lock;
@@ -37,6 +43,8 @@ struct msm_gpio_dev {
 	unsigned			irq_summary;
 	bool				latch_level_irqs;
 	struct msm7200a_gpio_regs	regs;
+	u32				irq_masks[IRQ_MASK_MAX];
+	int				nsuspend;
 };
 
 static inline struct msm_gpio_dev *to_msm_gpio_dev(struct gpio_chip *chip)
@@ -140,7 +148,8 @@ static void msm_gpio_irq_mask(unsigned int irq)
 
 	spin_lock_irqsave(&msm_gpio->lock, irq_flags);
 	forget_level_irq(msm_gpio, offset);
-	clr_gpio_bit(offset, msm_gpio->regs.int_en);
+	msm_gpio->irq_masks[IRQ_MASK_NORMAL] &= ~BIT(offset);
+	writel(msm_gpio->irq_masks[IRQ_MASK_NORMAL], msm_gpio->regs.int_en);
 	spin_unlock_irqrestore(&msm_gpio->lock, irq_flags);
 }
 
@@ -152,7 +161,8 @@ static void msm_gpio_irq_unmask(unsigned int irq)
 
 	spin_lock_irqsave(&msm_gpio->lock, irq_flags);
 	forget_level_irq(msm_gpio, offset);
-	set_gpio_bit(offset, msm_gpio->regs.int_en);
+	msm_gpio->irq_masks[IRQ_MASK_NORMAL] |= BIT(offset);
+	writel(msm_gpio->irq_masks[IRQ_MASK_NORMAL], msm_gpio->regs.int_en);
 	spin_unlock_irqrestore(&msm_gpio->lock, irq_flags);
 }
 
@@ -194,6 +204,22 @@ static void msm_gpio_irq_mask_ack(unsigned int irq)
 	msm_gpio_irq_mask(irq);
 }
 
+static int msm_gpio_irq_set_wake(unsigned int irq, unsigned int on)
+{
+	struct msm_gpio_dev *msm_gpio = get_irq_chip_data(irq);
+	unsigned offset = irq - msm_gpio->irq_base;
+	unsigned long irq_flags;
+
+	spin_lock_irqsave(&msm_gpio->lock, irq_flags);
+	if (on)
+		msm_gpio->irq_masks[IRQ_MASK_WAKE_ON] |= BIT(offset);
+	else
+		msm_gpio->irq_masks[IRQ_MASK_WAKE_ON] &= ~BIT(offset);
+	spin_unlock_irqrestore(&msm_gpio->lock, irq_flags);
+
+	return set_irq_wake(msm_gpio->irq_summary, on);
+}
+
 static irqreturn_t msm_gpio_irq_handler(int irq, void *dev)
 {
 	struct msm_gpio_dev *msm_gpio = dev;
@@ -232,6 +258,7 @@ static struct irq_chip msm_gpio_irq_chip = {
 	.mask_ack		= msm_gpio_irq_mask_ack,
 	.unmask			= msm_gpio_irq_unmask,
 	.set_type		= msm_gpio_irq_set_type,
+	.set_wake		= msm_gpio_irq_set_wake,
 };
 
 static int __devinit msm_gpio_probe(struct platform_device *dev)
@@ -325,12 +352,53 @@ static int __devexit msm_gpio_remove(struct platform_device *dev)
 	return 0;
 }
 
+#ifdef CONFIG_PM
+static int msm_gpio_suspend(struct device *dev)
+{
+	struct platform_device *pdev = to_platform_device(dev);
+	struct msm_gpio_dev *msm_gpio = platform_get_drvdata(pdev);
+	unsigned long irq_flags;
+	unsigned long irq_mask;
+
+	spin_lock_irqsave(&msm_gpio->lock, irq_flags);
+	if ((msm_gpio->nsuspend)++ == 0) {
+		irq_mask = msm_gpio->irq_masks[IRQ_MASK_NORMAL] &
+			   msm_gpio->irq_masks[IRQ_MASK_WAKE_ON];
+		writel(irq_mask, msm_gpio->regs.int_en);
+	}
+	spin_unlock_irqrestore(&msm_gpio->lock, irq_flags);
+
+	return 0;
+}
+
+static int msm_gpio_resume(struct device *dev)
+{
+	struct platform_device *pdev = to_platform_device(dev);
+	struct msm_gpio_dev *msm_gpio = platform_get_drvdata(pdev);
+	unsigned long irq_flags;
+
+	spin_lock_irqsave(&msm_gpio->lock, irq_flags);
+	if (--(msm_gpio->nsuspend) == 0)
+		writel(msm_gpio->irq_masks[IRQ_MASK_NORMAL],
+		       msm_gpio->regs.int_en);
+	spin_unlock_irqrestore(&msm_gpio->lock, irq_flags);
+
+	return 0;
+}
+#else
+#define msm_gpio_suspend NULL
+#define msm_gpio_resume NULL
+#endif
+
+static SIMPLE_DEV_PM_OPS(msm_gpio_pm_ops, msm_gpio_suspend, msm_gpio_resume);
+
 static struct platform_driver msm_gpio_driver = {
 	.probe = msm_gpio_probe,
 	.remove = __devexit_p(msm_gpio_remove),
 	.driver = {
 		.name = "msm7200a-gpio",
 		.owner = THIS_MODULE,
+		.pm = &msm_gpio_pm_ops,
 	},
 };
 
-- 
1.7.0.4

--
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
