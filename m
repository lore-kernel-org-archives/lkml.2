Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758511Ab0FOVL0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 17:11:26 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:24835 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758473Ab0FOVLT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 17:11:19 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6014"; a="44404156"
From: Gregory Bean <gbean@codeaurora.org>
To: akpm@linux-foundation.org
Cc: linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
       Gregory Bean <gbean@codeaurora.org>,
       David Brown <davidb@codeaurora.org>,
       Daniel Walker <dwalker@codeaurora.org>,
       Bryan Huntsman <bryanh@codeaurora.org>
Subject: [PATCH 2/2 v4] gpio: msm7200a: Add irq support to msm-gpiolib.
Date: Tue, 15 Jun 2010 14:11:08 -0700
Message-Id: <1276636268-4891-3-git-send-email-gbean@codeaurora.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1276636268-4891-1-git-send-email-gbean@codeaurora.org>
References: <1276636268-4891-1-git-send-email-gbean@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Gregory Bean <gbean@codeaurora.org>
---
 drivers/gpio/msm7200a-gpio.c  |  168 ++++++++++++++++++++++++++++++++++++++++-
 include/linux/msm7200a-gpio.h |   25 ++++++
 2 files changed, 192 insertions(+), 1 deletions(-)

diff --git a/drivers/gpio/msm7200a-gpio.c b/drivers/gpio/msm7200a-gpio.c
index 22ae631..89d3a4d 100644
--- a/drivers/gpio/msm7200a-gpio.c
+++ b/drivers/gpio/msm7200a-gpio.c
@@ -23,6 +23,8 @@
 #include <linux/kernel.h>
 #include <linux/gpio.h>
 #include <linux/io.h>
+#include <linux/interrupt.h>
+#include <linux/irq.h>
 #include <linux/module.h>
 #include <linux/platform_device.h>
 #include <linux/slab.h>
@@ -31,6 +33,9 @@
 struct msm_gpio_dev {
 	struct gpio_chip		gpio_chip;
 	spinlock_t			lock;
+	unsigned			irq_base;
+	unsigned			irq_summary;
+	bool				latch_level_irqs;
 	struct msm7200a_gpio_regs	regs;
 };
 
@@ -110,11 +115,130 @@ static void gpio_chip_set(struct gpio_chip *chip, unsigned offset, int value)
 	spin_unlock_irqrestore(&msm_gpio->lock, irq_flags);
 }
 
+static int gpio_chip_to_irq(struct gpio_chip *chip, unsigned offset)
+{
+	struct msm_gpio_dev *msm_gpio = to_msm_gpio_dev(chip);
+	return msm_gpio->irq_base + offset;
+}
+
+static void forget_level_irq(struct msm_gpio_dev *msm_gpio, unsigned offset)
+{
+	if (!msm_gpio->latch_level_irqs) {
+		unsigned v = readl(msm_gpio->regs.int_edge);
+		unsigned b = BIT(offset);
+
+		if (!(v & b))
+			writel(b, msm_gpio->regs.int_clear);
+	}
+}
+
+static void msm_gpio_irq_mask(unsigned int irq)
+{
+	unsigned long irq_flags;
+	struct msm_gpio_dev *msm_gpio = get_irq_chip_data(irq);
+	unsigned offset = irq - msm_gpio->irq_base;
+
+	spin_lock_irqsave(&msm_gpio->lock, irq_flags);
+	forget_level_irq(msm_gpio, offset);
+	clr_gpio_bit(offset, msm_gpio->regs.int_en);
+	spin_unlock_irqrestore(&msm_gpio->lock, irq_flags);
+}
+
+static void msm_gpio_irq_unmask(unsigned int irq)
+{
+	unsigned long irq_flags;
+	struct msm_gpio_dev *msm_gpio = get_irq_chip_data(irq);
+	unsigned offset = irq - msm_gpio->irq_base;
+
+	spin_lock_irqsave(&msm_gpio->lock, irq_flags);
+	forget_level_irq(msm_gpio, offset);
+	set_gpio_bit(offset, msm_gpio->regs.int_en);
+	spin_unlock_irqrestore(&msm_gpio->lock, irq_flags);
+}
+
+static int msm_gpio_irq_set_type(unsigned int irq, unsigned int flow_type)
+{
+	unsigned long irq_flags;
+	struct msm_gpio_dev *msm_gpio = get_irq_chip_data(irq);
+	unsigned offset = irq - msm_gpio->irq_base;
+
+	if ((flow_type & IRQ_TYPE_EDGE_BOTH) ==	IRQ_TYPE_EDGE_BOTH)
+		return -EINVAL;
+
+	if ((flow_type & (IRQF_TRIGGER_HIGH | IRQF_TRIGGER_LOW)) ==
+		(IRQF_TRIGGER_HIGH | IRQF_TRIGGER_LOW))
+		return -EINVAL;
+
+	spin_lock_irqsave(&msm_gpio->lock, irq_flags);
+
+	if (flow_type & IRQ_TYPE_EDGE_BOTH) {
+		set_gpio_bit(offset, msm_gpio->regs.int_edge);
+		irq_desc[irq].handle_irq = handle_edge_irq;
+	} else {
+		clr_gpio_bit(offset, msm_gpio->regs.int_edge);
+		irq_desc[irq].handle_irq = handle_level_irq;
+	}
+
+	if (flow_type & (IRQF_TRIGGER_HIGH | IRQF_TRIGGER_RISING))
+		set_gpio_bit(offset, msm_gpio->regs.int_pos);
+	else
+		clr_gpio_bit(offset, msm_gpio->regs.int_pos);
+
+	spin_unlock_irqrestore(&msm_gpio->lock, irq_flags);
+
+	return 0;
+}
+
+static void msm_gpio_irq_mask_ack(unsigned int irq)
+{
+	msm_gpio_irq_mask(irq);
+}
+
+static irqreturn_t msm_gpio_irq_handler(int irq, void *dev)
+{
+	struct msm_gpio_dev *msm_gpio = dev;
+	unsigned e, s, triggered_irqs;
+	int b;
+
+	/*
+	 * The int_status register latches trigger events whether or not
+	 * the gpio line is enabled as an interrupt source.  Therefore,
+	 * the set of pins which defines the interrupts which need to fire
+	 * is the intersection of int_status and int_en - int_status
+	 * alone provides an incomplete picture.
+	 */
+	spin_lock(&msm_gpio->lock);
+	s = readl(msm_gpio->regs.int_status);
+	e = readl(msm_gpio->regs.int_en);
+	triggered_irqs = s & e;
+	if (triggered_irqs)
+		writel(triggered_irqs, msm_gpio->regs.int_clear);
+	spin_unlock(&msm_gpio->lock);
+
+	if (!triggered_irqs)
+		return IRQ_NONE;
+
+	while (triggered_irqs) {
+		b = ffs(triggered_irqs) - 1;
+		triggered_irqs &= ~BIT(b);
+		generic_handle_irq(msm_gpio->irq_base + b);
+	}
+	return IRQ_HANDLED;
+}
+
+static struct irq_chip msm_gpio_irq_chip = {
+	.name			= "msm_gpio",
+	.mask			= msm_gpio_irq_mask,
+	.mask_ack		= msm_gpio_irq_mask_ack,
+	.unmask			= msm_gpio_irq_unmask,
+	.set_type		= msm_gpio_irq_set_type,
+};
+
 static int msm_gpio_probe(struct platform_device *dev)
 {
 	struct msm_gpio_dev *msm_gpio;
 	struct msm7200a_gpio_platform_data *pdata = dev->dev.platform_data;
-	int ret;
+	int i, irq, ret;
 
 	if (!pdata)
 		return -EINVAL;
@@ -134,12 +258,53 @@ static int msm_gpio_probe(struct platform_device *dev)
 	msm_gpio->gpio_chip.direction_output = gpio_chip_direction_output;
 	msm_gpio->gpio_chip.get              = gpio_chip_get;
 	msm_gpio->gpio_chip.set              = gpio_chip_set;
+	msm_gpio->gpio_chip.to_irq           = gpio_chip_to_irq;
+	msm_gpio->irq_base                   = pdata->irq_base;
+	msm_gpio->irq_summary                = pdata->irq_summary;
+	msm_gpio->latch_level_irqs           = pdata->latch_level_irqs;
 
 	ret = gpiochip_add(&msm_gpio->gpio_chip);
 	if (ret < 0)
 		goto err_post_malloc;
 
+	for (i = 0; i < msm_gpio->gpio_chip.ngpio; ++i) {
+		irq = msm_gpio->irq_base + i;
+		set_irq_chip_data(irq, msm_gpio);
+		set_irq_chip(irq, &msm_gpio_irq_chip);
+		set_irq_handler(irq, handle_level_irq);
+		set_irq_flags(irq, IRQF_VALID);
+	}
+
+	/*
+	 * We use a level-triggered interrupt because of the nature
+	 * of the shared GPIO-group interrupt.
+	 *
+	 * Many GPIO chips may be sharing the same group IRQ line, and
+	 * it is possible for GPIO interrupt to re-occur while the system
+	 * is still servicing the group interrupt associated with it.
+	 * The group IRQ line would not de-assert and re-assert, and
+	 * we'd get no second edge to cause the group IRQ to be handled again.
+	 *
+	 * Using a level interrupt guarantees that the group IRQ handlers
+	 * will continue to be called as long as any GPIO chip in the group
+	 * is asserting, even if the condition began while the group
+	 * handler was in mid-pass.
+	 */
+	ret = request_irq(msm_gpio->irq_summary,
+			  msm_gpio_irq_handler,
+			  IRQF_SHARED | IRQF_TRIGGER_HIGH,
+			  dev_name(&dev->dev),
+			  msm_gpio);
+	if (ret < 0)
+		goto err_post_gpiochip_add;
+
 	return ret;
+err_post_gpiochip_add:
+	/*
+	 * Under no circumstances should a line be held on a gpiochip
+	 * which hasn't finished probing.
+	 */
+	BUG_ON(gpiochip_remove(&msm_gpio->gpio_chip) < 0);
 err_post_malloc:
 	platform_set_drvdata(dev, NULL);
 	kfree(msm_gpio);
@@ -154,6 +319,7 @@ static int msm_gpio_remove(struct platform_device *dev)
 	if (ret < 0)
 		return ret;
 
+	free_irq(msm_gpio->irq_summary, msm_gpio);
 	kfree(msm_gpio);
 
 	return 0;
diff --git a/include/linux/msm7200a-gpio.h b/include/linux/msm7200a-gpio.h
index c44d16b..317c1fd 100644
--- a/include/linux/msm7200a-gpio.h
+++ b/include/linux/msm7200a-gpio.h
@@ -34,6 +34,11 @@
  * @in:		GPIO_IN_n
  * @out:	GPIO_OUT_n
  * @oe:		GPIO_OE_n
+ * @int_status:	GPIO_INT_STATUS_n
+ * @int_clear:	GPIO_INT_CLEAR_n
+ * @int_en:	GPIO_INT_EN_n
+ * @int_edge:	GPIO_INT_EDGE_n
+ * @int_pos:	GPIO_INT_POS_n
  *
  * Registers are not guaranteed to be packed in memory, or even
  * located in a predictable pattern.
@@ -42,6 +47,11 @@ struct msm7200a_gpio_regs {
 	void __iomem *in;
 	void __iomem *out;
 	void __iomem *oe;
+	void __iomem *int_status;
+	void __iomem *int_clear;
+	void __iomem *int_en;
+	void __iomem *int_edge;
+	void __iomem *int_pos;
 };
 
 /**
@@ -50,12 +60,27 @@ struct msm7200a_gpio_regs {
  *		directly to gpio_chip.base.
  * @ngpio:	The number of gpio lines to be managed by the device.
  *		Must be <= 32.  Corresponds directly to gpio_chip.ngpio.
+ * @irq_base:	The first irq to be assigned to the device.  The gpio
+ *		at 'gpio_base' will be assigned irq 'irq_base',
+ *		gpio 'gpio_base + 1' will receive irq 'irq_base + 1',
+ *		and so on.
+ * @irq_summary:	The summary irq line which will be used by the device
+ *			to notify the kernel when an interrupt occurs on
+ *			any of its gpio lines.  Most MSM SoCs have more
+ *			than one gpio device sharing each of these.
+ * @latch_level_irqs:	The MSM gpio hardware latches level interrupts,
+ *			which is atypical.  Setting this flag to false
+ *			makes the driver compensate for this and produce
+ *			the traditional unlatched behavior for level irqs.
  * @regs:	Addresses of the registers which control the gpios
  *		to be managed by the device.
  */
 struct msm7200a_gpio_platform_data {
 	unsigned gpio_base;
 	unsigned ngpio;
+	unsigned irq_base;
+	unsigned irq_summary;
+	bool latch_level_irqs;
 	struct msm7200a_gpio_regs regs;
 };
 
-- 
1.7.0.4

--
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
