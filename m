Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932594Ab0KLSJI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 13:09:08 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:64347 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932296Ab0KLSJG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 13:09:06 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6165"; a="61660406"
From: Gregory Bean <gbean@codeaurora.org>
To: dwalker@codeaurora.org
Cc: linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Gregory Bean <gbean@codeaurora.org>
Subject: [PATCH 1/2] msm: gpio: Add v2 gpio support to MSM SoCs.
Date: Fri, 12 Nov 2010 10:09:01 -0800
Message-Id: <1289585342-21341-1-git-send-email-gbean@codeaurora.org>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Beginning with the MSM8x60, the hardware block responsible for gpio
support changes.  Provide gpiolib support for the new v2 architecture.

Signed-off-by: Gregory Bean <gbean@codeaurora.org>
---
 arch/arm/mach-msm/Makefile  |    4 +-
 arch/arm/mach-msm/gpio-v2.c |  180 +++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 183 insertions(+), 1 deletions(-)
 create mode 100644 arch/arm/mach-msm/gpio-v2.c

diff --git a/arch/arm/mach-msm/Makefile b/arch/arm/mach-msm/Makefile
index b5a7b07..4a1a7ea 100644
--- a/arch/arm/mach-msm/Makefile
+++ b/arch/arm/mach-msm/Makefile
@@ -28,6 +28,8 @@ obj-$(CONFIG_ARCH_MSM8X60) += board-msm8x60.o
 obj-$(CONFIG_ARCH_MSM7X30) += gpiomux-7x30.o gpiomux-v1.o gpiomux.o
 obj-$(CONFIG_ARCH_QSD8X50) += gpiomux-8x50.o gpiomux-v1.o gpiomux.o
 obj-$(CONFIG_ARCH_MSM8X60) += gpiomux-8x60.o gpiomux-v2.o gpiomux.o
-ifndef CONFIG_MSM_V2_TLMM
+ifdef CONFIG_MSM_V2_TLMM
+obj-y	+= gpio-v2.o
+else
 obj-y	+= gpio.o
 endif
diff --git a/arch/arm/mach-msm/gpio-v2.c b/arch/arm/mach-msm/gpio-v2.c
new file mode 100644
index 0000000..5d31a7c
--- /dev/null
+++ b/arch/arm/mach-msm/gpio-v2.c
@@ -0,0 +1,180 @@
+/* Copyright (c) 2010, Code Aurora Forum. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
+ * 02110-1301, USA.
+ *
+ */
+#include <linux/gpio.h>
+#include <linux/io.h>
+#include <linux/irq.h>
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/spinlock.h>
+#include <mach/msm_iomap.h>
+#include "gpiomux.h"
+
+/* Bits of interest in the GPIO_IN_OUT register.
+ */
+enum {
+	GPIO_IN_BIT  = 0,
+	GPIO_OUT_BIT = 1
+};
+
+/* Bits of interest in the GPIO_CFG register.
+ */
+enum {
+	GPIO_OE_BIT = 9,
+};
+
+#define GPIO_CONFIG(gpio)         (MSM_TLMM_BASE + 0x1000 + (0x10 * (gpio)))
+#define GPIO_IN_OUT(gpio)         (MSM_TLMM_BASE + 0x1004 + (0x10 * (gpio)))
+
+struct msm_gpio_dev {
+	struct gpio_chip gpio_chip;
+};
+
+static DEFINE_SPINLOCK(tlmm_lock);
+
+static inline struct msm_gpio_dev *to_msm_gpio_dev(struct gpio_chip *chip)
+{
+	return container_of(chip, struct msm_gpio_dev, gpio_chip);
+}
+
+static inline void set_gpio_bits(unsigned n, void __iomem *reg)
+{
+	writel(readl(reg) | n, reg);
+}
+
+static inline void clr_gpio_bits(unsigned n, void __iomem *reg)
+{
+	writel(readl(reg) & ~n, reg);
+}
+
+static int msm_gpio_get(struct gpio_chip *chip, unsigned offset)
+{
+	return readl(GPIO_IN_OUT(offset)) & BIT(GPIO_IN_BIT);
+}
+
+static void msm_gpio_set(struct gpio_chip *chip, unsigned offset, int val)
+{
+	writel(val ? BIT(GPIO_OUT_BIT) : 0, GPIO_IN_OUT(offset));
+}
+
+static int msm_gpio_direction_input(struct gpio_chip *chip, unsigned offset)
+{
+	unsigned long irq_flags;
+
+	spin_lock_irqsave(&tlmm_lock, irq_flags);
+	clr_gpio_bits(BIT(GPIO_OE_BIT), GPIO_CONFIG(offset));
+	spin_unlock_irqrestore(&tlmm_lock, irq_flags);
+	return 0;
+}
+
+static int msm_gpio_direction_output(struct gpio_chip *chip,
+				unsigned offset,
+				int val)
+{
+	unsigned long irq_flags;
+
+	spin_lock_irqsave(&tlmm_lock, irq_flags);
+	msm_gpio_set(chip, offset, val);
+	set_gpio_bits(BIT(GPIO_OE_BIT), GPIO_CONFIG(offset));
+	spin_unlock_irqrestore(&tlmm_lock, irq_flags);
+	return 0;
+}
+
+static int msm_gpio_request(struct gpio_chip *chip, unsigned offset)
+{
+	return msm_gpiomux_get(chip->base + offset);
+}
+
+static void msm_gpio_free(struct gpio_chip *chip, unsigned offset)
+{
+	msm_gpiomux_put(chip->base + offset);
+}
+
+static struct msm_gpio_dev msm_gpio = {
+	.gpio_chip = {
+		.base             = 0,
+		.ngpio            = NR_GPIO_IRQS,
+		.direction_input  = msm_gpio_direction_input,
+		.direction_output = msm_gpio_direction_output,
+		.get              = msm_gpio_get,
+		.set              = msm_gpio_set,
+		.request          = msm_gpio_request,
+		.free             = msm_gpio_free,
+	},
+};
+
+static int __devinit msm_gpio_probe(struct platform_device *dev)
+{
+	int ret;
+
+	spin_lock_init(&tlmm_lock);
+	msm_gpio.gpio_chip.label = dev->name;
+	ret = gpiochip_add(&msm_gpio.gpio_chip);
+
+	return ret;
+}
+
+static int __devexit msm_gpio_remove(struct platform_device *dev)
+{
+	int ret = gpiochip_remove(&msm_gpio.gpio_chip);
+
+	if (ret < 0)
+		return ret;
+
+	set_irq_handler(TLMM_SCSS_SUMMARY_IRQ, NULL);
+
+	return 0;
+}
+
+static struct platform_driver msm_gpio_driver = {
+	.probe = msm_gpio_probe,
+	.remove = __devexit_p(msm_gpio_remove),
+	.driver = {
+		.name = "msmgpio",
+		.owner = THIS_MODULE,
+	},
+};
+
+static struct platform_device msm_device_gpio = {
+	.name = "msmgpio",
+	.id   = 0,
+};
+
+static int __init msm_gpio_init(void)
+{
+	int rc;
+
+	rc = platform_driver_register(&msm_gpio_driver);
+	if (rc == 0)
+		rc = platform_device_register(&msm_device_gpio);
+
+	return rc;
+}
+
+static void __exit msm_gpio_exit(void)
+{
+	platform_device_unregister(&msm_device_gpio);
+	platform_driver_unregister(&msm_gpio_driver);
+}
+
+postcore_initcall(msm_gpio_init);
+module_exit(msm_gpio_exit);
+
+MODULE_AUTHOR("Gregory Bean <gbean@codeaurora.org>");
+MODULE_DESCRIPTION("Driver for Qualcomm MSM TLMMv2 SoC GPIOs");
+MODULE_LICENSE("GPL v2");
+MODULE_ALIAS("platform:msmgpio");
-- 
1.7.0.4

-- 
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
