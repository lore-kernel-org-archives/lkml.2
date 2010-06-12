Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756351Ab0FLATk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 20:19:40 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:43134 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752473Ab0FLATh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 20:19:37 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6010"; a="44210861"
From: Gregory Bean <gbean@codeaurora.org>
To: akpm@linux-foundation.org
Cc: linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
       Gregory Bean <gbean@codeaurora.org>, Joe Perches <joe@perches.com>,
       "David S. Miller" <davem@davemloft.net>,
       Samuel Ortiz <sameo@linux.intel.com>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Michael Hennerich <michael.hennerich@analog.com>,
       Mike Frysinger <vapier@gentoo.org>, David Brown <davidb@codeaurora.org>,
       Daniel Walker <dwalker@codeaurora.org>,
       Bryan Huntsman <bryanh@codeaurora.org>
Subject: [PATCH 1/2 v2] gpio: msm7200a: Add gpiolib support for MSM chips.
Date: Fri, 11 Jun 2010 17:19:28 -0700
Message-Id: <1276301969-31385-2-git-send-email-gbean@codeaurora.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1276301969-31385-1-git-send-email-gbean@codeaurora.org>
References: <1276301969-31385-1-git-send-email-gbean@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for uniprocessor MSM chips whose TLMM/GPIO design
is the same as the MSM7200A.
This includes, but is not necessarily limited to, the:
MSM7200A, MSM7x25, MSM7x27, MSM7x30, QSD8x50, QSD8x50A

Signed-off-by: Gregory Bean <gbean@codeaurora.org>
---
 MAINTAINERS                   |    2 +
 drivers/gpio/Kconfig          |    8 ++
 drivers/gpio/Makefile         |    1 +
 drivers/gpio/msm7200a-gpio.c  |  196 +++++++++++++++++++++++++++++++++++++++++
 include/linux/msm7200a-gpio.h |   44 +++++++++
 5 files changed, 251 insertions(+), 0 deletions(-)
 create mode 100644 drivers/gpio/msm7200a-gpio.c
 create mode 100644 include/linux/msm7200a-gpio.h

diff --git a/MAINTAINERS b/MAINTAINERS
index 6d119c9..bdfd31d 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -819,6 +819,8 @@ F:	drivers/mmc/host/msm_sdcc.c
 F:	drivers/mmc/host/msm_sdcc.h
 F:	drivers/serial/msm_serial.h
 F:	drivers/serial/msm_serial.c
+F:	drivers/gpio/msm7200a-gpio.c
+F:	include/linux/msm7200a-gpio.h
 T:	git git://codeaurora.org/quic/kernel/dwalker/linux-msm.git
 S:	Maintained
 
diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
index 724038d..557738a 100644
--- a/drivers/gpio/Kconfig
+++ b/drivers/gpio/Kconfig
@@ -76,6 +76,14 @@ config GPIO_IT8761E
 	help
 	  Say yes here to support GPIO functionality of IT8761E super I/O chip.
 
+config GPIO_MSM7200A
+	tristate "Qualcomm MSM7200A SoC GPIO support"
+	depends on GPIOLIB
+	help
+	  Say yes here to support GPIO functionality on Qualcomm's
+	  MSM chipsets which descend from the MSM7200a:
+	  MSM7x01(a), MSM7x25, MSM7x27, MSM7x30, QSD8x50(a).
+
 config GPIO_PL061
 	bool "PrimeCell PL061 GPIO support"
 	depends on ARM_AMBA
diff --git a/drivers/gpio/Makefile b/drivers/gpio/Makefile
index 51c3cdd..2389c29 100644
--- a/drivers/gpio/Makefile
+++ b/drivers/gpio/Makefile
@@ -13,6 +13,7 @@ obj-$(CONFIG_GPIO_MAX7301)	+= max7301.o
 obj-$(CONFIG_GPIO_MAX732X)	+= max732x.o
 obj-$(CONFIG_GPIO_MC33880)	+= mc33880.o
 obj-$(CONFIG_GPIO_MCP23S08)	+= mcp23s08.o
+obj-$(CONFIG_GPIO_MSM7200A)	+= msm7200a-gpio.o
 obj-$(CONFIG_GPIO_PCA953X)	+= pca953x.o
 obj-$(CONFIG_GPIO_PCF857X)	+= pcf857x.o
 obj-$(CONFIG_GPIO_PL061)	+= pl061.o
diff --git a/drivers/gpio/msm7200a-gpio.c b/drivers/gpio/msm7200a-gpio.c
new file mode 100644
index 0000000..62db753
--- /dev/null
+++ b/drivers/gpio/msm7200a-gpio.c
@@ -0,0 +1,196 @@
+/*
+ * Driver for Qualcomm MSM7200a and related SoC GPIO.
+ * Supported chipset families include:
+ * MSM7x01(a), MSM7x25, MSM7x27, MSM7x30, QSD8x50(a)
+ *
+ * Copyright (C) 2007 Google, Inc.
+ * Copyright (c) 2010, Code Aurora Forum. All rights reserved.
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
+ */
+#include <linux/kernel.h>
+#include <linux/gpio.h>
+#include <linux/io.h>
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/msm7200a-gpio.h>
+
+struct msm_gpio_dev {
+	struct gpio_chip		gpio_chip;
+	spinlock_t			lock;
+	struct msm7200a_gpio_regs	regs;
+};
+
+#define TO_MSM_GPIO_DEV(c) container_of(c, struct msm_gpio_dev, gpio_chip)
+
+static inline unsigned bit(unsigned offset)
+{
+	BUG_ON(offset >= sizeof(unsigned) * 8);
+	return 1U << offset;
+}
+
+/*
+ * This function assumes that msm_gpio_dev::lock is held.
+ */
+static inline void set_gpio_bit(unsigned n, void __iomem *reg)
+{
+	writel(readl(reg) | bit(n), reg);
+}
+
+/*
+ * This function assumes that msm_gpio_dev::lock is held.
+ */
+static inline void clr_gpio_bit(unsigned n, void __iomem *reg)
+{
+	writel(readl(reg) & ~bit(n), reg);
+}
+
+/*
+ * This function assumes that msm_gpio_dev::lock is held.
+ */
+static inline void
+msm_gpio_write(struct msm_gpio_dev *dev, unsigned n, unsigned on)
+{
+	if (on)
+		set_gpio_bit(n, dev->regs.out);
+	else
+		clr_gpio_bit(n, dev->regs.out);
+}
+
+static int gpio_chip_direction_input(struct gpio_chip *chip, unsigned offset)
+{
+	struct msm_gpio_dev *msm_gpio = TO_MSM_GPIO_DEV(chip);
+	unsigned long irq_flags;
+
+	spin_lock_irqsave(&msm_gpio->lock, irq_flags);
+	clr_gpio_bit(offset, msm_gpio->regs.oe);
+	spin_unlock_irqrestore(&msm_gpio->lock, irq_flags);
+
+	return 0;
+}
+
+static int
+gpio_chip_direction_output(struct gpio_chip *chip, unsigned offset, int value)
+{
+	struct msm_gpio_dev *msm_gpio = TO_MSM_GPIO_DEV(chip);
+	unsigned long irq_flags;
+
+	spin_lock_irqsave(&msm_gpio->lock, irq_flags);
+
+	msm_gpio_write(msm_gpio, offset, value);
+	set_gpio_bit(offset, msm_gpio->regs.oe);
+	spin_unlock_irqrestore(&msm_gpio->lock, irq_flags);
+
+	return 0;
+}
+
+static int gpio_chip_get(struct gpio_chip *chip, unsigned offset)
+{
+	struct msm_gpio_dev *msm_gpio = TO_MSM_GPIO_DEV(chip);
+	unsigned long irq_flags;
+	int ret;
+
+	spin_lock_irqsave(&msm_gpio->lock, irq_flags);
+	ret = readl(msm_gpio->regs.in) & bit(offset) ? 1 : 0;
+	spin_unlock_irqrestore(&msm_gpio->lock, irq_flags);
+
+	return ret;
+}
+
+static void gpio_chip_set(struct gpio_chip *chip, unsigned offset, int value)
+{
+	struct msm_gpio_dev *msm_gpio = TO_MSM_GPIO_DEV(chip);
+	unsigned long irq_flags;
+
+	spin_lock_irqsave(&msm_gpio->lock, irq_flags);
+	msm_gpio_write(msm_gpio, offset, value);
+	spin_unlock_irqrestore(&msm_gpio->lock, irq_flags);
+}
+
+static int msm_gpio_probe(struct platform_device *dev)
+{
+	struct msm_gpio_dev *msm_gpio;
+	struct msm7200a_gpio_platform_data *pdata =
+		(struct msm7200a_gpio_platform_data *)dev->dev.platform_data;
+	int ret;
+
+	if (!pdata)
+		return -EINVAL;
+
+	msm_gpio = kzalloc(sizeof(struct msm_gpio_dev), GFP_KERNEL);
+	if (!msm_gpio)
+		return -ENOMEM;
+
+	spin_lock_init(&msm_gpio->lock);
+	platform_set_drvdata(dev, msm_gpio);
+	memcpy(&msm_gpio->regs,
+	       &pdata->regs,
+	       sizeof(struct msm7200a_gpio_regs));
+
+	msm_gpio->gpio_chip.label            = dev->name;
+	msm_gpio->gpio_chip.base             = pdata->gpio_base;
+	msm_gpio->gpio_chip.ngpio            = pdata->ngpio;
+	msm_gpio->gpio_chip.direction_input  = gpio_chip_direction_input;
+	msm_gpio->gpio_chip.direction_output = gpio_chip_direction_output;
+	msm_gpio->gpio_chip.get              = gpio_chip_get;
+	msm_gpio->gpio_chip.set              = gpio_chip_set;
+
+	ret = gpiochip_add(&msm_gpio->gpio_chip);
+	if (ret < 0)
+		goto err_post_malloc;
+
+	return ret;
+err_post_malloc:
+	kfree(msm_gpio);
+	return ret;
+}
+
+static int msm_gpio_remove(struct platform_device *dev)
+{
+	struct msm_gpio_dev *msm_gpio = platform_get_drvdata(dev);
+	int ret = gpiochip_remove(&msm_gpio->gpio_chip);
+
+	if (ret < 0)
+		return ret;
+
+	kfree(msm_gpio);
+
+	return 0;
+}
+
+static struct platform_driver msm_gpio_driver = {
+	.probe = msm_gpio_probe,
+	.remove = msm_gpio_remove,
+	.driver = {
+		.name = "msm7200a-gpio",
+		.owner = THIS_MODULE,
+	},
+};
+
+static int __init msm_gpio_init(void)
+{
+	return platform_driver_register(&msm_gpio_driver);
+}
+
+static void __exit msm_gpio_exit(void)
+{
+	platform_driver_unregister(&msm_gpio_driver);
+}
+
+postcore_initcall(msm_gpio_init);
+module_exit(msm_gpio_exit);
+
+MODULE_DESCRIPTION("Driver for Qualcomm MSM 7200a-family SoC GPIOs");
+MODULE_LICENSE("GPLv2");
diff --git a/include/linux/msm7200a-gpio.h b/include/linux/msm7200a-gpio.h
new file mode 100644
index 0000000..3f1ef38
--- /dev/null
+++ b/include/linux/msm7200a-gpio.h
@@ -0,0 +1,44 @@
+/* Copyright (c) 2010, Code Aurora Forum. All rights reserved.
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions are
+ * met:
+ *     * Redistributions of source code must retain the above copyright
+ *       notice, this list of conditions and the following disclaimer.
+ *     * Redistributions in binary form must reproduce the above
+ *       copyright notice, this list of conditions and the following
+ *       disclaimer in the documentation and/or other materials provided
+ *       with the distribution.
+ *     * Neither the name of Code Aurora Forum, Inc. nor the names of its
+ *       contributors may be used to endorse or promote products derived
+ *       from this software without specific prior written permission.
+ *
+ * THIS SOFTWARE IS PROVIDED "AS IS" AND ANY EXPRESS OR IMPLIED
+ * WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
+ * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NON-INFRINGEMENT
+ * ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS
+ * BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
+ * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
+ * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
+ * BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
+ * WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
+ * OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN
+ * IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+ *
+ */
+#ifndef __LINUX_MSM7200A_GPIO_H
+#define __LINUX_MSM7200A_GPIO_H
+
+struct msm7200a_gpio_regs {
+	void __iomem *in;
+	void __iomem *out;
+	void __iomem *oe;
+};
+
+struct msm7200a_gpio_platform_data {
+	unsigned gpio_base;
+	unsigned ngpio;
+	struct msm7200a_gpio_regs regs;
+};
+
+#endif
-- 
1.7.0.4

--
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
