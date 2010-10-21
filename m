Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758220Ab0JUVDU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 17:03:20 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:35303 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758046Ab0JUVCA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 17:02:00 -0400
From: Cyril Chemparathy <cyril@ti.com>
To: davinci-linux-open-source@linux.davincidsp.com,
        spi-devel-general@lists.sourceforge.net,
        broonie@opensource.wolfsonmicro.com, lrg@slimlogic.co.uk,
        dbrownell@users.sourceforge.net, grant.likely@secretlab.ca,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        rpurdie@rpsys.net
Cc: Cyril Chemparathy <cyril@ti.com>
Subject: [PATCH v3 08/12] gpio: add ti-ssp virtual gpio driver
Date: Thu, 21 Oct 2010 17:01:09 -0400
Message-Id: <1287694873-12904-9-git-send-email-cyril@ti.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1287694873-12904-1-git-send-email-cyril@ti.com>
References: <1287694873-12904-1-git-send-email-cyril@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a GPIO driver based on TI's SSP device.  This driver does not
support GPIO-IRQs.

Acked-by: Grant Likely <grant.likely@secretlab.ca>
Signed-off-by: Cyril Chemparathy <cyril@ti.com>
---
 arch/arm/mach-davinci/include/mach/ti_ssp.h |    4 +
 drivers/gpio/Kconfig                        |   10 ++
 drivers/gpio/Makefile                       |    1 +
 drivers/gpio/ti-ssp-gpio.c                  |  200 +++++++++++++++++++++++++++
 4 files changed, 215 insertions(+), 0 deletions(-)
 create mode 100644 drivers/gpio/ti-ssp-gpio.c

diff --git a/arch/arm/mach-davinci/include/mach/ti_ssp.h b/arch/arm/mach-davinci/include/mach/ti_ssp.h
index 63c88fe..21f1429 100644
--- a/arch/arm/mach-davinci/include/mach/ti_ssp.h
+++ b/arch/arm/mach-davinci/include/mach/ti_ssp.h
@@ -39,6 +39,10 @@ struct ti_ssp_spi_data {
 	void		(*select)(int cs);
 };
 
+struct ti_ssp_gpio_data {
+	int		start;
+};
+
 /*
  * Sequencer port IO pin configuration bits.  These do not correlate 1-1 with
  * the hardware.  The iosel field in the port data combines iosel1 and iosel2,
diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
index 510aa20..e400761 100644
--- a/drivers/gpio/Kconfig
+++ b/drivers/gpio/Kconfig
@@ -111,6 +111,16 @@ config GPIO_SCH
 	  This driver can also be built as a module. If so, the module
 	  will be called sch-gpio.
 
+config GPIO_TI_SSP
+	tristate "TI SSP Controller GPIO Driver"
+	depends on GPIOLIB && TI_SSP
+	help
+	  Say yes here to support a virtual GPIO interface on TI SSP ports.
+	  Each SSP port translates into 4 GPIOs, with no IRQ support.
+
+	  This driver can also be built as a module. If so, the module
+	  will be called ti-ssp-gpio.
+
 comment "I2C GPIO expanders:"
 
 config GPIO_MAX7300
diff --git a/drivers/gpio/Makefile b/drivers/gpio/Makefile
index fc6019d..98b4551 100644
--- a/drivers/gpio/Makefile
+++ b/drivers/gpio/Makefile
@@ -23,6 +23,7 @@ obj-$(CONFIG_GPIO_PL061)	+= pl061.o
 obj-$(CONFIG_GPIO_STMPE)	+= stmpe-gpio.o
 obj-$(CONFIG_GPIO_TC35892)	+= tc35892-gpio.o
 obj-$(CONFIG_GPIO_TIMBERDALE)	+= timbgpio.o
+obj-$(CONFIG_GPIO_TI_SSP)	+= ti-ssp-gpio.o
 obj-$(CONFIG_GPIO_TWL4030)	+= twl4030-gpio.o
 obj-$(CONFIG_GPIO_UCB1400)	+= ucb1400_gpio.o
 obj-$(CONFIG_GPIO_XILINX)	+= xilinx_gpio.o
diff --git a/drivers/gpio/ti-ssp-gpio.c b/drivers/gpio/ti-ssp-gpio.c
new file mode 100644
index 0000000..c046713
--- /dev/null
+++ b/drivers/gpio/ti-ssp-gpio.c
@@ -0,0 +1,200 @@
+/*
+ * Sequencer Serial Port (SSP) based virtual GPIO driver
+ *
+ * Copyright (C) 2010 Texas Instruments Inc
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ */
+
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/io.h>
+#include <linux/err.h>
+#include <linux/slab.h>
+#include <linux/gpio.h>
+#include <linux/platform_device.h>
+
+#include <mach/ti_ssp.h>
+
+struct ti_ssp_gpio {
+	struct gpio_chip		chip;
+#define chip2gpio(chip)	container_of(chip, struct ti_ssp_gpio, chip)
+	struct device			*dev;
+	spinlock_t			lock;
+	u8				out;
+	u32				iosel;
+};
+
+static int direction_in(struct gpio_chip *chip, unsigned gpio_num)
+{
+	struct ti_ssp_gpio *gpio = chip2gpio(chip);
+	int error = 0;
+
+	spin_lock(&gpio->lock);
+
+	gpio->iosel &= ~SSP_PIN_MASK(gpio_num);
+	gpio->iosel |=  SSP_PIN_SEL(gpio_num, SSP_IN);
+
+	error = ti_ssp_set_iosel(gpio->dev, gpio->iosel);
+
+	spin_unlock(&gpio->lock);
+
+	return error;
+}
+
+static int direction_out(struct gpio_chip *chip, unsigned gpio_num, int val)
+{
+	struct ti_ssp_gpio *gpio = chip2gpio(chip);
+	int error;
+
+	spin_lock(&gpio->lock);
+
+	gpio->iosel &= ~SSP_PIN_MASK(gpio_num);
+	gpio->iosel |=  SSP_PIN_SEL(gpio_num, SSP_OUT);
+
+	error = ti_ssp_set_iosel(gpio->dev, gpio->iosel);
+
+	if (error < 0)
+		goto error;
+
+	if (val)
+		gpio->out |= BIT(gpio_num);
+	else
+		gpio->out &= ~BIT(gpio_num);
+
+	error = ti_ssp_raw_write(gpio->dev, gpio->out);
+
+error:
+	spin_unlock(&gpio->lock);
+	return error;
+}
+
+static int value_get(struct gpio_chip *chip, unsigned gpio_num)
+{
+	struct ti_ssp_gpio *gpio = chip2gpio(chip);
+	int ret;
+
+	spin_lock(&gpio->lock);
+
+	ret = ti_ssp_raw_read(gpio->dev);
+	if (ret >= 0)
+		ret = (ret & BIT(gpio_num)) ? 1 : 0;
+
+	spin_unlock(&gpio->lock);
+	return ret;
+}
+
+static void value_set(struct gpio_chip *chip, unsigned gpio_num, int val)
+{
+	struct ti_ssp_gpio *gpio = chip2gpio(chip);
+
+	spin_lock(&gpio->lock);
+
+	if (val)
+		gpio->out |= BIT(gpio_num);
+	else
+		gpio->out &= ~BIT(gpio_num);
+
+	ti_ssp_raw_write(gpio->dev, gpio->out);
+
+	spin_unlock(&gpio->lock);
+}
+
+static int __devinit ti_ssp_gpio_probe(struct platform_device *pdev)
+{
+	const struct ti_ssp_gpio_data *pdata = pdev->dev.platform_data;
+	struct device *dev = &pdev->dev;
+	struct ti_ssp_gpio *gpio;
+	int error;
+
+	if (!pdata) {
+		dev_err(dev, "platform data not found\n");
+		return -EINVAL;
+	}
+
+	gpio = kzalloc(sizeof(*gpio), GFP_KERNEL);
+	if (!gpio) {
+		dev_err(dev, "cannot allocate driver data\n");
+		return -ENOMEM;
+	}
+
+	gpio->dev = dev;
+	gpio->iosel = SSP_PIN_SEL(0, SSP_IN) | SSP_PIN_SEL(1, SSP_IN) |
+		      SSP_PIN_SEL(2, SSP_IN) | SSP_PIN_SEL(3, SSP_IN);
+	spin_lock_init(&gpio->lock);
+	platform_set_drvdata(pdev, gpio);
+
+	gpio->chip.base  = pdata->start;
+	gpio->chip.ngpio = 4;
+	gpio->chip.dev   = &pdev->dev;
+	gpio->chip.label = "ti_ssp_gpio";
+	gpio->chip.owner = THIS_MODULE;
+	gpio->chip.get   = value_get;
+	gpio->chip.set   = value_set;
+	gpio->chip.direction_input  = direction_in;
+	gpio->chip.direction_output = direction_out;
+
+	error = gpiochip_add(&gpio->chip);
+	if (error < 0) {
+		dev_err(dev, "gpio chip registration failed (%d)\n", error);
+		goto error;
+	}
+
+	dev_info(dev, "ssp gpio interface registered\n");
+	return 0;
+
+error:
+	kfree(gpio);
+	return error;
+}
+
+static int __devexit ti_ssp_gpio_remove(struct platform_device *pdev)
+{
+	struct ti_ssp_gpio *gpio = platform_get_drvdata(pdev);
+	int error;
+
+	error = gpiochip_remove(&gpio->chip);
+	if (error < 0)
+		return error;
+	kfree(gpio);
+	return 0;
+}
+
+static struct platform_driver ti_ssp_gpio_driver = {
+	.probe		= ti_ssp_gpio_probe,
+	.remove		= __devexit_p(ti_ssp_gpio_remove),
+	.driver		= {
+		.name	= "ti-ssp-gpio",
+		.owner	= THIS_MODULE,
+	},
+};
+
+static int __init ti_ssp_gpio_init(void)
+{
+	return platform_driver_register(&ti_ssp_gpio_driver);
+}
+subsys_initcall(ti_ssp_gpio_init);
+
+static void __exit ti_ssp_gpio_exit(void)
+{
+	platform_driver_unregister(&ti_ssp_gpio_driver);
+}
+module_exit(ti_ssp_gpio_exit);
+
+MODULE_DESCRIPTION("GPIO interface for TI-SSP");
+MODULE_AUTHOR("Cyril Chemparathy <cyril@ti.com>");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:ti-ssp-gpio");
-- 
1.7.0.4

