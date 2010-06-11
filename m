Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760527Ab0FKT7A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 15:59:00 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:3322 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756866Ab0FKT67 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 15:58:59 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6010"; a="44189084"
From: Gregory Bean <gbean@codeaurora.org>
To: akpm@linux-foundation.org
Cc: linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
       Gregory Bean <gbean@codeaurora.org>,
       David Brown <davidb@codeaurora.org>,
       Daniel Walker <dwalker@codeaurora.org>,
       Bryan Huntsman <bryanh@codeaurora.org>
Subject: [PATCH 2/2] gpio: msm7200a: Add irq support to msm-gpiolib.
Date: Fri, 11 Jun 2010 12:58:52 -0700
Message-Id: <1276286332-13515-3-git-send-email-gbean@codeaurora.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1276286332-13515-1-git-send-email-gbean@codeaurora.org>
References: <1276286332-13515-1-git-send-email-gbean@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change-Id: Ib7f7dd05246c87096aabab12eb6cc260551c67cf
Signed-off-by: Gregory Bean <gbean@codeaurora.org>
---
 drivers/gpio/msm7200a-gpio.c  |  218 +++++++++++++++++++++++++++++++++++++++--
 include/linux/msm7200a-gpio.h |    7 ++
 2 files changed, 218 insertions(+), 7 deletions(-)

diff --git a/drivers/gpio/msm7200a-gpio.c b/drivers/gpio/msm7200a-gpio.c
index b31c25e..a9ea869 100644
--- a/drivers/gpio/msm7200a-gpio.c
+++ b/drivers/gpio/msm7200a-gpio.c
@@ -23,13 +23,25 @@
 #include <linux/kernel.h>
 #include <linux/gpio.h>
 #include <linux/io.h>
+#include <linux/interrupt.h>
+#include <linux/irq.h>
 #include <linux/module.h>
 #include <linux/platform_device.h>
 #include <linux/msm7200a-gpio.h>
 
+/*
+ * The INT_STATUS register latches both edge- and level-detection events,
+ * which is atypical.  Turning on DONT_LATCH_LEVEL_IRQS causes level irq
+ * triggers to be forgotten across mask/unmask calls, emulating a more
+ * traditional setup.
+ */
+#define MSM_GPIO_DONT_LATCH_LEVEL_IRQS 1
+
 struct msm_gpio_dev {
 	struct gpio_chip		gpio_chip;
 	spinlock_t			lock;
+	unsigned			irq_base;
+	unsigned			irq_summary;
 	struct msm7200a_gpio_regs	regs;
 };
 
@@ -119,12 +131,160 @@ static void gpio_chip_set(struct gpio_chip *chip, unsigned offset, int value)
 	spin_unlock_irqrestore(&msm_gpio->lock, irq_flags);
 }
 
+static int gpio_chip_to_irq(struct gpio_chip *chip, unsigned offset)
+{
+	struct msm_gpio_dev *msm_gpio = TO_MSM_GPIO_DEV(chip);
+	return msm_gpio->irq_base + offset;
+}
+
+#if MSM_GPIO_DONT_LATCH_LEVEL_IRQS
+static inline void forget_level_irq(struct msm_gpio_dev *msm_gpio,
+				unsigned offset)
+{
+	unsigned v = readl(msm_gpio->regs.int_edge);
+	unsigned b = bit(offset);
+
+	if (!(v & b))
+		writel(b, msm_gpio->regs.int_clear);
+
+}
+#else
+static inline void forget_level_irq(struct msm_gpio_dev *msm, unsigned off)
+{
+}
+#endif
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
+	if ((flow_type & (IRQF_TRIGGER_FALLING | IRQF_TRIGGER_RISING)) ==
+		(IRQF_TRIGGER_FALLING | IRQF_TRIGGER_RISING))
+		return -ENOTSUPP;
+
+	if ((flow_type & (IRQF_TRIGGER_HIGH | IRQF_TRIGGER_LOW)) ==
+		(IRQF_TRIGGER_HIGH | IRQF_TRIGGER_LOW))
+		return -ENOTSUPP;
+
+	spin_lock_irqsave(&msm_gpio->lock, irq_flags);
+
+	if (flow_type & (IRQF_TRIGGER_FALLING | IRQF_TRIGGER_RISING)) {
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
+static int msm_gpio_irq_set_affinity(unsigned int irq,
+				const struct cpumask *dest)
+{
+	return -ENOTSUPP;
+}
+
+static int msm_gpio_irq_retrigger(unsigned int irq)
+{
+	return -ENOTSUPP;
+}
+
+static int msm_gpio_irq_set_wake(unsigned int irq, unsigned int on)
+{
+	return -ENOTSUPP;
+}
+
+static irqreturn_t msm_gpio_irq_handler(int irq, void *dev)
+{
+	unsigned long irq_flags;
+	int b, m;
+	unsigned e, s, v;
+
+	struct msm_gpio_dev *msm_gpio = (struct msm_gpio_dev *)dev;
+
+	/*
+	 * The int_status register latches trigger events whether or not
+	 * the gpio line is enabled as an interrupt source.  Therefore,
+	 * the set of pins which defines the interrupts which need to fire
+	 * is the intersection of int_status and int_en - int_status
+	 * alone provides an incomplete picture.
+	 */
+	spin_lock_irqsave(&msm_gpio->lock, irq_flags);
+	s = readl(msm_gpio->regs.int_status);
+	e = readl(msm_gpio->regs.int_en);
+	v = s & e;
+	if (v)
+		writel(v, msm_gpio->regs.int_clear);
+	spin_unlock_irqrestore(&msm_gpio->lock, irq_flags);
+
+	if (!v)
+		return IRQ_NONE;
+
+	while (v) {
+		m = v & -v;
+		b = fls(m) - 1;
+		v &= ~m;
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
+	.set_affinity		= msm_gpio_irq_set_affinity,
+	.retrigger		= msm_gpio_irq_retrigger,
+	.set_type		= msm_gpio_irq_set_type,
+	.set_wake		= msm_gpio_irq_set_wake,
+};
+
 static int msm_gpio_probe(struct platform_device *dev)
 {
 	struct msm_gpio_dev *msm_gpio;
 	struct msm7200a_gpio_platform_data *pdata =
 		(struct msm7200a_gpio_platform_data *)dev->dev.platform_data;
-	int ret;
+	int i, irq, ret;
 
 	if (!pdata)
 		return -EINVAL;
@@ -146,13 +306,53 @@ static int msm_gpio_probe(struct platform_device *dev)
 	msm_gpio->gpio_chip.direction_output = gpio_chip_direction_output;
 	msm_gpio->gpio_chip.get              = gpio_chip_get;
 	msm_gpio->gpio_chip.set              = gpio_chip_set;
+	msm_gpio->gpio_chip.to_irq           = gpio_chip_to_irq;
+	msm_gpio->irq_base                   = pdata->irq_base;
+	msm_gpio->irq_summary                = pdata->irq_summary;
 
 	ret = gpiochip_add(&msm_gpio->gpio_chip);
 	if (ret < 0)
-		goto err;
+		goto err_post_malloc;
+
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
+			  dev->name,
+			  msm_gpio);
+	if (ret < 0)
+		goto err_post_gpiochip_add;
 
 	return ret;
-err:
+err_post_gpiochip_add:
+	/*
+	 * Under no circumstances should a line be held on a gpiochip
+	 * which hasn't finished probing.
+	 */
+	BUG_ON(gpiochip_remove(&msm_gpio->gpio_chip) < 0);
+err_post_malloc:
 	kfree(msm_gpio);
 	return ret;
 }
@@ -160,12 +360,16 @@ err:
 static int msm_gpio_remove(struct platform_device *dev)
 {
 	struct msm_gpio_dev *msm_gpio = platform_get_drvdata(dev);
-	int ret = gpiochip_remove(&msm_gpio->gpio_chip);
+	int ret;
 
-	if (ret == 0)
-		kfree(msm_gpio);
+	ret = gpiochip_remove(&msm_gpio->gpio_chip);
+	if (ret < 0)
+		return ret;
 
-	return ret;
+	free_irq(msm_gpio->irq_summary, msm_gpio);
+	kfree(msm_gpio);
+
+	return 0;
 }
 
 static struct platform_driver msm_gpio_driver = {
diff --git a/include/linux/msm7200a-gpio.h b/include/linux/msm7200a-gpio.h
index 3f1ef38..7af4dd6 100644
--- a/include/linux/msm7200a-gpio.h
+++ b/include/linux/msm7200a-gpio.h
@@ -33,11 +33,18 @@ struct msm7200a_gpio_regs {
 	void __iomem *in;
 	void __iomem *out;
 	void __iomem *oe;
+	void __iomem *int_status;
+	void __iomem *int_clear;
+	void __iomem *int_en;
+	void __iomem *int_edge;
+	void __iomem *int_pos;
 };
 
 struct msm7200a_gpio_platform_data {
 	unsigned gpio_base;
 	unsigned ngpio;
+	unsigned irq_base;
+	unsigned irq_summary;
 	struct msm7200a_gpio_regs regs;
 };
 
-- 
1.7.0.4

---
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
