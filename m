Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932686Ab0KLSJK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 13:09:10 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:64347 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932366Ab0KLSJH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 13:09:07 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6165"; a="61660407"
From: Gregory Bean <gbean@codeaurora.org>
To: dwalker@codeaurora.org
Cc: linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Gregory Bean <gbean@codeaurora.org>
Subject: [PATCH 2/2] msm: gpio: Add irq support to v2 gpiolib.
Date: Fri, 12 Nov 2010 10:09:02 -0800
Message-Id: <1289585342-21341-2-git-send-email-gbean@codeaurora.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1289585342-21341-1-git-send-email-gbean@codeaurora.org>
References: <1289585342-21341-1-git-send-email-gbean@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Complete the MSM v2 gpio subsystem by adding irq_chip.

Signed-off-by: Gregory Bean <gbean@codeaurora.org>
---
 arch/arm/mach-msm/gpio-v2.c |  293 ++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 291 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-msm/gpio-v2.c b/arch/arm/mach-msm/gpio-v2.c
index 5d31a7c..aa3e9ec 100644
--- a/arch/arm/mach-msm/gpio-v2.c
+++ b/arch/arm/mach-msm/gpio-v2.c
@@ -15,7 +15,11 @@
  * 02110-1301, USA.
  *
  */
+#include <linux/bitmap.h>
+#include <linux/bitops.h>
 #include <linux/gpio.h>
+#include <linux/init.h>
+#include <linux/interrupt.h>
 #include <linux/io.h>
 #include <linux/irq.h>
 #include <linux/module.h>
@@ -31,17 +35,78 @@ enum {
 	GPIO_OUT_BIT = 1
 };
 
+/* Bits of interest in the GPIO_INTR_STATUS register.
+ */
+enum {
+	INTR_STATUS_BIT = 0,
+};
+
 /* Bits of interest in the GPIO_CFG register.
  */
 enum {
 	GPIO_OE_BIT = 9,
 };
 
+/* Bits of interest in the GPIO_INTR_CFG register.
+ */
+enum {
+	INTR_ENABLE_BIT        = 0,
+	INTR_POL_CTL_BIT       = 1,
+	INTR_DECT_CTL_BIT      = 2,
+	INTR_RAW_STATUS_EN_BIT = 3,
+};
+
+/* Codes of interest in GPIO_INTR_CFG_SU.
+ */
+enum {
+	TARGET_PROC_SCORPION = 4,
+	TARGET_PROC_NONE     = 7,
+};
+
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
+
+#define GPIO_INTR_CFG_SU(gpio)    (MSM_TLMM_BASE + 0x0400 + (0x04 * (gpio)))
 #define GPIO_CONFIG(gpio)         (MSM_TLMM_BASE + 0x1000 + (0x10 * (gpio)))
 #define GPIO_IN_OUT(gpio)         (MSM_TLMM_BASE + 0x1004 + (0x10 * (gpio)))
+#define GPIO_INTR_CFG(gpio)       (MSM_TLMM_BASE + 0x1008 + (0x10 * (gpio)))
+#define GPIO_INTR_STATUS(gpio)    (MSM_TLMM_BASE + 0x100c + (0x10 * (gpio)))
 
+/**
+ * struct msm_gpio_dev: the MSM8660 SoC GPIO device structure
+ *
+ * @enabled_irqs: a bitmap used to optimize the summary-irq handler.  By
+ * keeping track of which gpios are unmasked as irq sources, we avoid
+ * having to do readl calls on hundreds of iomapped registers each time
+ * the summary interrupt fires in order to locate the active interrupts.
+ *
+ * @wake_irqs: a bitmap for tracking which interrupt lines are enabled
+ * as wakeup sources.  When the device is suspended, interrupts which are
+ * not wakeup sources are disabled.
+ *
+ * @dual_edge_irqs: a bitmap used to track which irqs are configured
+ * as dual-edge, as this is not supported by the hardware and requires
+ * some special handling in the driver.
+ */
 struct msm_gpio_dev {
 	struct gpio_chip gpio_chip;
+	DECLARE_BITMAP(enabled_irqs, NR_GPIO_IRQS);
+	DECLARE_BITMAP(wake_irqs, NR_GPIO_IRQS);
+	DECLARE_BITMAP(dual_edge_irqs, NR_GPIO_IRQS);
 };
 
 static DEFINE_SPINLOCK(tlmm_lock);
@@ -104,6 +169,16 @@ static void msm_gpio_free(struct gpio_chip *chip, unsigned offset)
 	msm_gpiomux_put(chip->base + offset);
 }
 
+static int msm_gpio_to_irq(struct gpio_chip *chip, unsigned offset)
+{
+	return MSM_GPIO_TO_INT(offset - chip->base);
+}
+
+static inline int msm_irq_to_gpio(struct gpio_chip *chip, unsigned irq)
+{
+	return irq - MSM_GPIO_TO_INT(chip->base);
+}
+
 static struct msm_gpio_dev msm_gpio = {
 	.gpio_chip = {
 		.base             = 0,
@@ -112,20 +187,193 @@ static struct msm_gpio_dev msm_gpio = {
 		.direction_output = msm_gpio_direction_output,
 		.get              = msm_gpio_get,
 		.set              = msm_gpio_set,
+		.to_irq           = msm_gpio_to_irq,
 		.request          = msm_gpio_request,
 		.free             = msm_gpio_free,
 	},
 };
 
+/* For dual-edge interrupts in software, since the hardware has no
+ * such support:
+ *
+ * At appropriate moments, this function may be called to flip the polarity
+ * settings of both-edge irq lines to try and catch the next edge.
+ *
+ * The attempt is considered successful if:
+ * - the status bit goes high, indicating that an edge was caught, or
+ * - the input value of the gpio doesn't change during the attempt.
+ * If the value changes twice during the process, that would cause the first
+ * test to fail but would force the second, as two opposite
+ * transitions would cause a detection no matter the polarity setting.
+ *
+ * The do-loop tries to sledge-hammer closed the timing hole between
+ * the initial value-read and the polarity-write - if the line value changes
+ * during that window, an interrupt is lost, the new polarity setting is
+ * incorrect, and the first success test will fail, causing a retry.
+ *
+ * Algorithm comes from Google's msmgpio driver, see mach-msm/gpio.c.
+ */
+static void msm_gpio_update_dual_edge_pos(unsigned gpio)
+{
+	int loop_limit = 100;
+	unsigned val, val2, intstat;
+
+	do {
+		val = readl(GPIO_IN_OUT(gpio)) & BIT(GPIO_IN_BIT);
+		if (val)
+			clr_gpio_bits(INTR_POL_CTL_HI, GPIO_INTR_CFG(gpio));
+		else
+			set_gpio_bits(INTR_POL_CTL_HI, GPIO_INTR_CFG(gpio));
+		val2 = readl(GPIO_IN_OUT(gpio)) & BIT(GPIO_IN_BIT);
+		intstat = readl(GPIO_INTR_STATUS(gpio)) & BIT(INTR_STATUS_BIT);
+		if (intstat || val == val2)
+			return;
+	} while (loop_limit-- > 0);
+	pr_err("%s: dual-edge irq failed to stabilize, "
+	       "interrupts dropped. %#08x != %#08x\n",
+	       __func__, val, val2);
+}
+
+static void msm_gpio_irq_ack(unsigned int irq)
+{
+	int gpio = msm_irq_to_gpio(&msm_gpio.gpio_chip, irq);
+
+	writel(BIT(INTR_STATUS_BIT), GPIO_INTR_STATUS(gpio));
+	if (test_bit(gpio, msm_gpio.dual_edge_irqs))
+		msm_gpio_update_dual_edge_pos(gpio);
+}
+
+static void msm_gpio_irq_mask(unsigned int irq)
+{
+	int gpio = msm_irq_to_gpio(&msm_gpio.gpio_chip, irq);
+	unsigned long irq_flags;
+
+	spin_lock_irqsave(&tlmm_lock, irq_flags);
+	writel(TARGET_PROC_NONE, GPIO_INTR_CFG_SU(gpio));
+	clr_gpio_bits(INTR_RAW_STATUS_EN | INTR_ENABLE, GPIO_INTR_CFG(gpio));
+	__clear_bit(gpio, msm_gpio.enabled_irqs);
+	spin_unlock_irqrestore(&tlmm_lock, irq_flags);
+}
+
+static void msm_gpio_irq_unmask(unsigned int irq)
+{
+	int gpio = msm_irq_to_gpio(&msm_gpio.gpio_chip, irq);
+	unsigned long irq_flags;
+
+	spin_lock_irqsave(&tlmm_lock, irq_flags);
+	__set_bit(gpio, msm_gpio.enabled_irqs);
+	set_gpio_bits(INTR_RAW_STATUS_EN | INTR_ENABLE, GPIO_INTR_CFG(gpio));
+	writel(TARGET_PROC_SCORPION, GPIO_INTR_CFG_SU(gpio));
+	spin_unlock_irqrestore(&tlmm_lock, irq_flags);
+}
+
+static int msm_gpio_irq_set_type(unsigned int irq, unsigned int flow_type)
+{
+	int gpio = msm_irq_to_gpio(&msm_gpio.gpio_chip, irq);
+	unsigned long irq_flags;
+	uint32_t bits;
+
+	spin_lock_irqsave(&tlmm_lock, irq_flags);
+
+	bits = readl(GPIO_INTR_CFG(gpio));
+
+	if (flow_type & IRQ_TYPE_EDGE_BOTH) {
+		bits |= INTR_DECT_CTL_EDGE;
+		irq_desc[irq].handle_irq = handle_edge_irq;
+		if ((flow_type & IRQ_TYPE_EDGE_BOTH) == IRQ_TYPE_EDGE_BOTH)
+			__set_bit(gpio, msm_gpio.dual_edge_irqs);
+		else
+			__clear_bit(gpio, msm_gpio.dual_edge_irqs);
+	} else {
+		bits &= ~INTR_DECT_CTL_EDGE;
+		irq_desc[irq].handle_irq = handle_level_irq;
+		__clear_bit(gpio, msm_gpio.dual_edge_irqs);
+	}
+
+	if (flow_type & (IRQ_TYPE_EDGE_RISING | IRQ_TYPE_LEVEL_HIGH))
+		bits |= INTR_POL_CTL_HI;
+	else
+		bits &= ~INTR_POL_CTL_HI;
+
+	writel(bits, GPIO_INTR_CFG(gpio));
+
+	if ((flow_type & IRQ_TYPE_EDGE_BOTH) == IRQ_TYPE_EDGE_BOTH)
+		msm_gpio_update_dual_edge_pos(gpio);
+
+	spin_unlock_irqrestore(&tlmm_lock, irq_flags);
+
+	return 0;
+}
+
+/*
+ * When the summary IRQ is raised, any number of GPIO lines may be high.
+ * It is the job of the summary handler to find all those GPIO lines
+ * which have been set as summary IRQ lines and which are triggered,
+ * and to call their interrupt handlers.
+ */
+static void msm_summary_irq_handler(unsigned int irq, struct irq_desc *desc)
+{
+	unsigned long i;
+
+	for (i = find_first_bit(msm_gpio.enabled_irqs, NR_GPIO_IRQS);
+	     i < NR_GPIO_IRQS;
+	     i = find_next_bit(msm_gpio.enabled_irqs, NR_GPIO_IRQS, i + 1)) {
+		if (readl(GPIO_INTR_STATUS(i)) & BIT(INTR_STATUS_BIT))
+			generic_handle_irq(msm_gpio_to_irq(&msm_gpio.gpio_chip,
+							   i));
+	}
+	desc->chip->ack(irq);
+}
+
+static int msm_gpio_irq_set_wake(unsigned int irq, unsigned int on)
+{
+	int gpio = msm_irq_to_gpio(&msm_gpio.gpio_chip, irq);
+
+	if (on) {
+		if (bitmap_empty(msm_gpio.wake_irqs, NR_GPIO_IRQS))
+			set_irq_wake(TLMM_SCSS_SUMMARY_IRQ, 1);
+		set_bit(gpio, msm_gpio.wake_irqs);
+	} else {
+		clear_bit(gpio, msm_gpio.wake_irqs);
+		if (bitmap_empty(msm_gpio.wake_irqs, NR_GPIO_IRQS))
+			set_irq_wake(TLMM_SCSS_SUMMARY_IRQ, 0);
+	}
+
+	return 0;
+}
+
+static struct irq_chip msm_gpio_irq_chip = {
+	.name		= "msmgpio",
+	.mask		= msm_gpio_irq_mask,
+	.unmask		= msm_gpio_irq_unmask,
+	.ack		= msm_gpio_irq_ack,
+	.set_type	= msm_gpio_irq_set_type,
+	.set_wake	= msm_gpio_irq_set_wake,
+};
+
 static int __devinit msm_gpio_probe(struct platform_device *dev)
 {
-	int ret;
+	int i, irq, ret;
 
 	spin_lock_init(&tlmm_lock);
+	bitmap_zero(msm_gpio.enabled_irqs, NR_GPIO_IRQS);
+	bitmap_zero(msm_gpio.wake_irqs, NR_GPIO_IRQS);
+	bitmap_zero(msm_gpio.dual_edge_irqs, NR_GPIO_IRQS);
 	msm_gpio.gpio_chip.label = dev->name;
 	ret = gpiochip_add(&msm_gpio.gpio_chip);
+	if (ret < 0)
+		return ret;
+
+	for (i = 0; i < msm_gpio.gpio_chip.ngpio; ++i) {
+		irq = msm_gpio_to_irq(&msm_gpio.gpio_chip, i);
+		set_irq_chip(irq, &msm_gpio_irq_chip);
+		set_irq_handler(irq, handle_level_irq);
+		set_irq_flags(irq, IRQF_VALID);
+	}
 
-	return ret;
+	set_irq_chained_handler(TLMM_SCSS_SUMMARY_IRQ,
+				msm_summary_irq_handler);
+	return 0;
 }
 
 static int __devexit msm_gpio_remove(struct platform_device *dev)
@@ -140,12 +388,53 @@ static int __devexit msm_gpio_remove(struct platform_device *dev)
 	return 0;
 }
 
+#ifdef CONFIG_PM
+static int msm_gpio_suspend_noirq(struct device *dev)
+{
+	unsigned long irq_flags;
+	unsigned long i;
+
+	spin_lock_irqsave(&tlmm_lock, irq_flags);
+	for_each_set_bit(i, msm_gpio.enabled_irqs, NR_GPIO_IRQS) {
+		if (!test_bit(i, msm_gpio.wake_irqs))
+			writel(TARGET_PROC_NONE, GPIO_INTR_CFG_SU(i));
+	}
+	spin_unlock_irqrestore(&tlmm_lock, irq_flags);
+	return 0;
+}
+
+static int msm_gpio_resume_noirq(struct device *dev)
+{
+	unsigned long irq_flags;
+	unsigned long i;
+
+	spin_lock_irqsave(&tlmm_lock, irq_flags);
+	for_each_set_bit(i, msm_gpio.enabled_irqs, NR_GPIO_IRQS)
+		writel(TARGET_PROC_SCORPION, GPIO_INTR_CFG_SU(i));
+	spin_unlock_irqrestore(&tlmm_lock, irq_flags);
+	return 0;
+}
+#else
+#define msm_gpio_suspend_noirq NULL
+#define msm_gpio_resume_noirq NULL
+#endif
+
+static const struct dev_pm_ops msm_gpio_dev_pm_ops = {
+	.suspend_noirq  = msm_gpio_suspend_noirq,
+	.resume_noirq   = msm_gpio_resume_noirq,
+	.freeze_noirq   = msm_gpio_suspend_noirq,
+	.thaw_noirq     = msm_gpio_resume_noirq,
+	.poweroff_noirq = msm_gpio_suspend_noirq,
+	.restore_noirq  = msm_gpio_resume_noirq,
+};
+
 static struct platform_driver msm_gpio_driver = {
 	.probe = msm_gpio_probe,
 	.remove = __devexit_p(msm_gpio_remove),
 	.driver = {
 		.name = "msmgpio",
 		.owner = THIS_MODULE,
+		.pm = &msm_gpio_dev_pm_ops,
 	},
 };
 
-- 
1.7.0.4

-- 
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
