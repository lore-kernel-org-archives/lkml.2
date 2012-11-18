Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752726Ab2KRQhp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Nov 2012 11:37:45 -0500
Received: from filtteri5.pp.htv.fi ([213.243.153.188]:49988 "EHLO
	filtteri5.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752408Ab2KRQgc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Nov 2012 11:36:32 -0500
From: Aaro Koskinen <aaro.koskinen@iki.fi>
To: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Aaro Koskinen <aaro.koskinen@iki.fi>, linux-i2c@vger.kernel.org,
        Wolfram Sang <w.sang@pengutronix.de>
Subject: =?UTF-8?q?=5BPATCH=20v4=201/4=5D=20i2c=3A=20introduce=20i2c-cbus-gpio=20driver?=
Date: Sun, 18 Nov 2012 18:36:19 +0200
Message-Id: <1353256582-12166-2-git-send-email-aaro.koskinen@iki.fi>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1353256582-12166-1-git-send-email-aaro.koskinen@iki.fi>
References: <1353256582-12166-1-git-send-email-aaro.koskinen@iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add i2c driver to enable access to devices behind CBUS on Nokia Internet
Tablets.

The patch also adds CBUS I2C configuration for N8x0 which is one of the
users of this driver.

Cc: linux-i2c@vger.kernel.org
Acked-by: Felipe Balbi <balbi@ti.com>
Acked-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Aaro Koskinen <aaro.koskinen@iki.fi>
Cc: Wolfram Sang <w.sang@pengutronix.de>
---
 .../devicetree/bindings/i2c/i2c-cbus-gpio.txt      |   27 ++
 arch/arm/mach-omap2/board-n8x0.c                   |   42 +++
 drivers/i2c/busses/Kconfig                         |   10 +
 drivers/i2c/busses/Makefile                        |    1 +
 drivers/i2c/busses/i2c-cbus-gpio.c                 |  300 ++++++++++++++++++++
 include/linux/platform_data/i2c-cbus-gpio.h        |   27 ++
 6 files changed, 407 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/i2c/i2c-cbus-gpio.txt
 create mode 100644 drivers/i2c/busses/i2c-cbus-gpio.c
 create mode 100644 include/linux/platform_data/i2c-cbus-gpio.h

diff --git a/Documentation/devicetree/bindings/i2c/i2c-cbus-gpio.txt b/Documentation/devicetree/bindings/i2c/i2c-cbus-gpio.txt
new file mode 100644
index 0000000..8ce9cd2
--- /dev/null
+++ b/Documentation/devicetree/bindings/i2c/i2c-cbus-gpio.txt
@@ -0,0 +1,27 @@
+Device tree bindings for i2c-cbus-gpio driver
+
+Required properties:
+	- compatible = "i2c-cbus-gpio";
+	- gpios: clk, dat, sel
+	- #address-cells = <1>;
+	- #size-cells = <0>;
+
+Optional properties:
+	- child nodes conforming to i2c bus binding
+
+Example:
+
+i2c@0 {
+	compatible = "i2c-cbus-gpio";
+	gpios = <&gpio 66 0 /* clk */
+		 &gpio 65 0 /* dat */
+		 &gpio 64 0 /* sel */
+		>;
+	#address-cells = <1>;
+	#size-cells = <0>;
+
+	retu-mfd: retu@1 {
+		compatible = "retu-mfd";
+		reg = <0x1>;
+	};
+};
diff --git a/arch/arm/mach-omap2/board-n8x0.c b/arch/arm/mach-omap2/board-n8x0.c
index d95f727..bbfd742 100644
--- a/arch/arm/mach-omap2/board-n8x0.c
+++ b/arch/arm/mach-omap2/board-n8x0.c
@@ -16,10 +16,12 @@
 #include <linux/gpio.h>
 #include <linux/init.h>
 #include <linux/io.h>
+#include <linux/irq.h>
 #include <linux/stddef.h>
 #include <linux/i2c.h>
 #include <linux/spi/spi.h>
 #include <linux/usb/musb.h>
+#include <linux/platform_data/i2c-cbus-gpio.h>
 #include <linux/platform_data/spi-omap2-mcspi.h>
 #include <linux/platform_data/mtd-onenand-omap2.h>
 #include <sound/tlv320aic3x.h>
@@ -39,6 +41,45 @@
 #define TUSB6010_GPIO_ENABLE	0
 #define TUSB6010_DMACHAN	0x3f
 
+#if defined(CONFIG_I2C_CBUS_GPIO) || defined(CONFIG_I2C_CBUS_GPIO_MODULE)
+static struct i2c_cbus_platform_data n8x0_cbus_data = {
+	.clk_gpio = 66,
+	.dat_gpio = 65,
+	.sel_gpio = 64,
+};
+
+static struct platform_device n8x0_cbus_device = {
+	.name	= "i2c-cbus-gpio",
+	.id	= 3,
+	.dev	= {
+		.platform_data = &n8x0_cbus_data,
+	},
+};
+
+static struct i2c_board_info n8x0_i2c_board_info_3[] __initdata = {
+	{
+		I2C_BOARD_INFO("retu-mfd", 0x01),
+	},
+};
+
+static void __init n8x0_cbus_init(void)
+{
+	const int retu_irq_gpio = 108;
+
+	if (gpio_request_one(retu_irq_gpio, GPIOF_IN, "Retu IRQ"))
+		return;
+	irq_set_irq_type(gpio_to_irq(retu_irq_gpio), IRQ_TYPE_EDGE_RISING);
+	n8x0_i2c_board_info_3[0].irq = gpio_to_irq(retu_irq_gpio);
+	i2c_register_board_info(3, n8x0_i2c_board_info_3,
+				ARRAY_SIZE(n8x0_i2c_board_info_3));
+	platform_device_register(&n8x0_cbus_device);
+}
+#else /* CONFIG_I2C_CBUS_GPIO */
+static void __init n8x0_cbus_init(void)
+{
+}
+#endif /* CONFIG_I2C_CBUS_GPIO */
+
 #if defined(CONFIG_USB_MUSB_TUSB6010) || defined(CONFIG_USB_MUSB_TUSB6010_MODULE)
 /*
  * Enable or disable power to TUSB6010. When enabling, turn on 3.3 V and
@@ -677,6 +718,7 @@ static void __init n8x0_init_machine(void)
 	gpmc_onenand_init(board_onenand_data);
 	n8x0_mmc_init();
 	n8x0_usb_init();
+	n8x0_cbus_init();
 }
 
 MACHINE_START(NOKIA_N800, "Nokia N800")
diff --git a/drivers/i2c/busses/Kconfig b/drivers/i2c/busses/Kconfig
index e9df461..e949edf 100644
--- a/drivers/i2c/busses/Kconfig
+++ b/drivers/i2c/busses/Kconfig
@@ -337,6 +337,16 @@ config I2C_BLACKFIN_TWI_CLK_KHZ
 	help
 	  The unit of the TWI clock is kHz.
 
+config I2C_CBUS_GPIO
+	tristate "CBUS I2C driver"
+	depends on GENERIC_GPIO
+	help
+	  Support for CBUS access using I2C API. Mostly relevant for Nokia
+	  Internet Tablets (770, N800 and N810).
+
+	  This driver can also be built as a module.  If so, the module
+	  will be called i2c-cbus-gpio.
+
 config I2C_CPM
 	tristate "Freescale CPM1 or CPM2 (MPC8xx/826x)"
 	depends on (CPM1 || CPM2) && OF_I2C
diff --git a/drivers/i2c/busses/Makefile b/drivers/i2c/busses/Makefile
index 395b516..f9e3e0b 100644
--- a/drivers/i2c/busses/Makefile
+++ b/drivers/i2c/busses/Makefile
@@ -31,6 +31,7 @@ obj-$(CONFIG_I2C_POWERMAC)	+= i2c-powermac.o
 obj-$(CONFIG_I2C_AT91)		+= i2c-at91.o
 obj-$(CONFIG_I2C_AU1550)	+= i2c-au1550.o
 obj-$(CONFIG_I2C_BLACKFIN_TWI)	+= i2c-bfin-twi.o
+obj-$(CONFIG_I2C_CBUS_GPIO)	+= i2c-cbus-gpio.o
 obj-$(CONFIG_I2C_CPM)		+= i2c-cpm.o
 obj-$(CONFIG_I2C_DAVINCI)	+= i2c-davinci.o
 obj-$(CONFIG_I2C_DESIGNWARE_CORE)	+= i2c-designware-core.o
diff --git a/drivers/i2c/busses/i2c-cbus-gpio.c b/drivers/i2c/busses/i2c-cbus-gpio.c
new file mode 100644
index 0000000..98386d6
--- /dev/null
+++ b/drivers/i2c/busses/i2c-cbus-gpio.c
@@ -0,0 +1,300 @@
+/*
+ * CBUS I2C driver for Nokia Internet Tablets.
+ *
+ * Copyright (C) 2004-2010 Nokia Corporation
+ *
+ * Based on code written by Juha Yrjölä, David Weinehall, Mikko Ylinen and
+ * Felipe Balbi. Converted to I2C driver by Aaro Koskinen.
+ *
+ * This file is subject to the terms and conditions of the GNU General
+ * Public License. See the file "COPYING" in the main directory of this
+ * archive for more details.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/io.h>
+#include <linux/i2c.h>
+#include <linux/gpio.h>
+#include <linux/init.h>
+#include <linux/slab.h>
+#include <linux/delay.h>
+#include <linux/errno.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/of_gpio.h>
+#include <linux/interrupt.h>
+#include <linux/platform_device.h>
+#include <linux/platform_data/i2c-cbus-gpio.h>
+
+/*
+ * Bit counts are derived from Nokia implementation. These should be checked
+ * if other CBUS implementations appear.
+ */
+#define CBUS_ADDR_BITS	3
+#define CBUS_REG_BITS	5
+
+struct cbus_host {
+	spinlock_t	lock;		/* host lock */
+	struct device	*dev;
+	int		clk_gpio;
+	int		dat_gpio;
+	int		sel_gpio;
+};
+
+/**
+ * cbus_send_bit - sends one bit over the bus
+ * @host: the host we're using
+ * @bit: one bit of information to send
+ */
+static void cbus_send_bit(struct cbus_host *host, unsigned bit)
+{
+	gpio_set_value(host->dat_gpio, bit ? 1 : 0);
+	gpio_set_value(host->clk_gpio, 1);
+	gpio_set_value(host->clk_gpio, 0);
+}
+
+/**
+ * cbus_send_data - sends @len amount of data over the bus
+ * @host: the host we're using
+ * @data: the data to send
+ * @len: size of the transfer
+ */
+static void cbus_send_data(struct cbus_host *host, unsigned data, unsigned len)
+{
+	int i;
+
+	for (i = len; i > 0; i--)
+		cbus_send_bit(host, data & (1 << (i - 1)));
+}
+
+/**
+ * cbus_receive_bit - receives one bit from the bus
+ * @host: the host we're using
+ */
+static int cbus_receive_bit(struct cbus_host *host)
+{
+	int ret;
+
+	gpio_set_value(host->clk_gpio, 1);
+	ret = gpio_get_value(host->dat_gpio);
+	gpio_set_value(host->clk_gpio, 0);
+	return ret;
+}
+
+/**
+ * cbus_receive_word - receives 16-bit word from the bus
+ * @host: the host we're using
+ */
+static int cbus_receive_word(struct cbus_host *host)
+{
+	int ret = 0;
+	int i;
+
+	for (i = 16; i > 0; i--) {
+		int bit = cbus_receive_bit(host);
+
+		if (bit < 0)
+			return bit;
+
+		if (bit)
+			ret |= 1 << (i - 1);
+	}
+	return ret;
+}
+
+/**
+ * cbus_transfer - transfers data over the bus
+ * @host: the host we're using
+ * @rw: read/write flag
+ * @dev: device address
+ * @reg: register address
+ * @data: if @rw == I2C_SBUS_WRITE data to send otherwise 0
+ */
+static int cbus_transfer(struct cbus_host *host, char rw, unsigned dev,
+			 unsigned reg, unsigned data)
+{
+	unsigned long flags;
+	int ret;
+
+	/* We don't want interrupts disturbing our transfer */
+	spin_lock_irqsave(&host->lock, flags);
+
+	/* Reset state and start of transfer, SEL stays down during transfer */
+	gpio_set_value(host->sel_gpio, 0);
+
+	/* Set the DAT pin to output */
+	gpio_direction_output(host->dat_gpio, 1);
+
+	/* Send the device address */
+	cbus_send_data(host, dev, CBUS_ADDR_BITS);
+
+	/* Send the rw flag */
+	cbus_send_bit(host, rw == I2C_SMBUS_READ);
+
+	/* Send the register address */
+	cbus_send_data(host, reg, CBUS_REG_BITS);
+
+	if (rw == I2C_SMBUS_WRITE) {
+		cbus_send_data(host, data, 16);
+		ret = 0;
+	} else {
+		ret = gpio_direction_input(host->dat_gpio);
+		if (ret) {
+			dev_dbg(host->dev, "failed setting direction\n");
+			goto out;
+		}
+		gpio_set_value(host->clk_gpio, 1);
+
+		ret = cbus_receive_word(host);
+		if (ret < 0) {
+			dev_dbg(host->dev, "failed receiving data\n");
+			goto out;
+		}
+	}
+
+	/* Indicate end of transfer, SEL goes up until next transfer */
+	gpio_set_value(host->sel_gpio, 1);
+	gpio_set_value(host->clk_gpio, 1);
+	gpio_set_value(host->clk_gpio, 0);
+
+out:
+	spin_unlock_irqrestore(&host->lock, flags);
+
+	return ret;
+}
+
+static int cbus_i2c_smbus_xfer(struct i2c_adapter	*adapter,
+			       u16			addr,
+			       unsigned short		flags,
+			       char			read_write,
+			       u8			command,
+			       int			size,
+			       union i2c_smbus_data	*data)
+{
+	struct cbus_host *chost = i2c_get_adapdata(adapter);
+	int ret;
+
+	if (size != I2C_SMBUS_WORD_DATA)
+		return -EINVAL;
+
+	ret = cbus_transfer(chost, read_write == I2C_SMBUS_READ, addr,
+			    command, data->word);
+	if (ret < 0)
+		return ret;
+
+	if (read_write == I2C_SMBUS_READ)
+		data->word = ret;
+
+	return 0;
+}
+
+static u32 cbus_i2c_func(struct i2c_adapter *adapter)
+{
+	return I2C_FUNC_SMBUS_READ_WORD_DATA | I2C_FUNC_SMBUS_WRITE_WORD_DATA;
+}
+
+static const struct i2c_algorithm cbus_i2c_algo = {
+	.smbus_xfer	= cbus_i2c_smbus_xfer,
+	.functionality	= cbus_i2c_func,
+};
+
+static int cbus_i2c_remove(struct platform_device *pdev)
+{
+	struct i2c_adapter *adapter = platform_get_drvdata(pdev);
+
+	return i2c_del_adapter(adapter);
+}
+
+static int cbus_i2c_probe(struct platform_device *pdev)
+{
+	struct i2c_adapter *adapter;
+	struct cbus_host *chost;
+	int ret;
+
+	adapter = devm_kzalloc(&pdev->dev, sizeof(struct i2c_adapter),
+			       GFP_KERNEL);
+	if (!adapter)
+		return -ENOMEM;
+
+	chost = devm_kzalloc(&pdev->dev, sizeof(*chost), GFP_KERNEL);
+	if (!chost)
+		return -ENOMEM;
+
+	if (pdev->dev.of_node) {
+		struct device_node *dnode = pdev->dev.of_node;
+		if (of_gpio_count(dnode) != 3)
+			return -ENODEV;
+		chost->clk_gpio = of_get_gpio(dnode, 0);
+		chost->dat_gpio = of_get_gpio(dnode, 1);
+		chost->sel_gpio = of_get_gpio(dnode, 2);
+	} else if (pdev->dev.platform_data) {
+		struct i2c_cbus_platform_data *pdata = pdev->dev.platform_data;
+		chost->clk_gpio = pdata->clk_gpio;
+		chost->dat_gpio = pdata->dat_gpio;
+		chost->sel_gpio = pdata->sel_gpio;
+	} else {
+		return -ENODEV;
+	}
+
+	adapter->owner		= THIS_MODULE;
+	adapter->class		= I2C_CLASS_HWMON;
+	adapter->dev.parent	= &pdev->dev;
+	adapter->nr		= pdev->id;
+	adapter->timeout	= HZ;
+	adapter->algo		= &cbus_i2c_algo;
+	strlcpy(adapter->name, "CBUS I2C adapter", sizeof(adapter->name));
+
+	spin_lock_init(&chost->lock);
+	chost->dev = &pdev->dev;
+
+	ret = devm_gpio_request_one(&pdev->dev, chost->clk_gpio,
+				    GPIOF_OUT_INIT_LOW, "CBUS clk");
+	if (ret)
+		return ret;
+
+	ret = devm_gpio_request_one(&pdev->dev, chost->dat_gpio, GPIOF_IN,
+				    "CBUS data");
+	if (ret)
+		return ret;
+
+	ret = devm_gpio_request_one(&pdev->dev, chost->sel_gpio,
+				    GPIOF_OUT_INIT_HIGH, "CBUS sel");
+	if (ret)
+		return ret;
+
+	i2c_set_adapdata(adapter, chost);
+	platform_set_drvdata(pdev, adapter);
+
+	return i2c_add_numbered_adapter(adapter);
+}
+
+#if defined(CONFIG_OF)
+static const struct of_device_id i2c_cbus_dt_ids[] = {
+	{ .compatible = "i2c-cbus-gpio", },
+	{ }
+};
+MODULE_DEVICE_TABLE(of, i2c_cbus_dt_ids);
+#endif
+
+static struct platform_driver cbus_i2c_driver = {
+	.probe	= cbus_i2c_probe,
+	.remove	= cbus_i2c_remove,
+	.driver	= {
+		.owner	= THIS_MODULE,
+		.name	= "i2c-cbus-gpio",
+	},
+};
+module_platform_driver(cbus_i2c_driver);
+
+MODULE_ALIAS("platform:i2c-cbus-gpio");
+MODULE_DESCRIPTION("CBUS I2C driver");
+MODULE_AUTHOR("Juha Yrjölä");
+MODULE_AUTHOR("David Weinehall");
+MODULE_AUTHOR("Mikko Ylinen");
+MODULE_AUTHOR("Felipe Balbi");
+MODULE_AUTHOR("Aaro Koskinen <aaro.koskinen@iki.fi>");
+MODULE_LICENSE("GPL");
diff --git a/include/linux/platform_data/i2c-cbus-gpio.h b/include/linux/platform_data/i2c-cbus-gpio.h
new file mode 100644
index 0000000..6faa992
--- /dev/null
+++ b/include/linux/platform_data/i2c-cbus-gpio.h
@@ -0,0 +1,27 @@
+/*
+ * i2c-cbus-gpio.h - CBUS I2C platform_data definition
+ *
+ * Copyright (C) 2004-2009 Nokia Corporation
+ *
+ * Written by Felipe Balbi and Aaro Koskinen.
+ *
+ * This file is subject to the terms and conditions of the GNU General
+ * Public License. See the file "COPYING" in the main directory of this
+ * archive for more details.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
+ * GNU General Public License for more details.
+ */
+
+#ifndef __INCLUDE_LINUX_I2C_CBUS_GPIO_H
+#define __INCLUDE_LINUX_I2C_CBUS_GPIO_H
+
+struct i2c_cbus_platform_data {
+	int dat_gpio;
+	int clk_gpio;
+	int sel_gpio;
+};
+
+#endif /* __INCLUDE_LINUX_I2C_CBUS_GPIO_H */
-- 
1.7.10.4

