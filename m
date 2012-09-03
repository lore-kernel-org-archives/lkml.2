Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756673Ab2ICUY2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2012 16:24:28 -0400
Received: from filtteri5.pp.htv.fi ([213.243.153.188]:50542 "EHLO
	filtteri5.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756622Ab2ICUX2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2012 16:23:28 -0400
From: Aaro Koskinen <aaro.koskinen@iki.fi>
To: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: linux-i2c@vger.kernel.org
Subject: =?UTF-8?q?=5BPATCH=201/4=5D=20i2c=3A=20introduce=20i2c-cbus=20driver?=
Date: Mon,  3 Sep 2012 23:23:22 +0300
Message-Id: <1346703805-31598-2-git-send-email-aaro.koskinen@iki.fi>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1346703805-31598-1-git-send-email-aaro.koskinen@iki.fi>
References: <1346703805-31598-1-git-send-email-aaro.koskinen@iki.fi>
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
---
 arch/arm/mach-omap2/board-n8x0.c |   42 +++++
 drivers/i2c/busses/Kconfig       |   10 +
 drivers/i2c/busses/Makefile      |    1 +
 drivers/i2c/busses/i2c-cbus.c    |  369 ++++++++++++++++++++++++++++++++++++++
 include/linux/i2c-cbus.h         |   27 +++
 5 files changed, 449 insertions(+), 0 deletions(-)
 create mode 100644 drivers/i2c/busses/i2c-cbus.c
 create mode 100644 include/linux/i2c-cbus.h

diff --git a/arch/arm/mach-omap2/board-n8x0.c b/arch/arm/mach-omap2/board-n8x0.c
index 677357f..2495f2d 100644
--- a/arch/arm/mach-omap2/board-n8x0.c
+++ b/arch/arm/mach-omap2/board-n8x0.c
@@ -16,8 +16,10 @@
 #include <linux/gpio.h>
 #include <linux/init.h>
 #include <linux/io.h>
+#include <linux/irq.h>
 #include <linux/stddef.h>
 #include <linux/i2c.h>
+#include <linux/i2c-cbus.h>
 #include <linux/spi/spi.h>
 #include <linux/usb/musb.h>
 #include <sound/tlv320aic3x.h>
@@ -42,6 +44,45 @@
 #define TUSB6010_GPIO_ENABLE	0
 #define TUSB6010_DMACHAN	0x3f
 
+#if defined(CONFIG_I2C_CBUS) || defined(CONFIG_I2C_CBUS_MODULE)
+static struct i2c_cbus_platform_data n8x0_cbus_data = {
+	.clk_gpio = 66,
+	.dat_gpio = 65,
+	.sel_gpio = 64,
+};
+
+static struct platform_device n8x0_cbus_device = {
+	.name	= "i2c-cbus",
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
+#else /* CONFIG_I2C_CBUS */
+static void __init n8x0_cbus_init(void)
+{
+}
+#endif /* CONFIG_I2C_CBUS */
+
 #if defined(CONFIG_USB_MUSB_TUSB6010) || defined(CONFIG_USB_MUSB_TUSB6010_MODULE)
 /*
  * Enable or disable power to TUSB6010. When enabling, turn on 3.3 V and
@@ -681,6 +722,7 @@ static void __init n8x0_init_machine(void)
 	gpmc_onenand_init(board_onenand_data);
 	n8x0_mmc_init();
 	n8x0_usb_init();
+	n8x0_cbus_init();
 }
 
 MACHINE_START(NOKIA_N800, "Nokia N800")
diff --git a/drivers/i2c/busses/Kconfig b/drivers/i2c/busses/Kconfig
index b4aaa1b..184ef43 100644
--- a/drivers/i2c/busses/Kconfig
+++ b/drivers/i2c/busses/Kconfig
@@ -331,6 +331,16 @@ config I2C_BLACKFIN_TWI_CLK_KHZ
 	help
 	  The unit of the TWI clock is kHz.
 
+config I2C_CBUS
+	tristate "CBUS I2C driver"
+	depends on GENERIC_GPIO
+	help
+	  Support for CBUS access using I2C API. Mostly relevant for Nokia
+	  Internet Tablets (770, N800 and N810).
+
+	  This driver can also be built as a module.  If so, the module
+	  will be called i2c-cbus.
+
 config I2C_CPM
 	tristate "Freescale CPM1 or CPM2 (MPC8xx/826x)"
 	depends on (CPM1 || CPM2) && OF_I2C
diff --git a/drivers/i2c/busses/Makefile b/drivers/i2c/busses/Makefile
index ce3c2be..44dbfd1 100644
--- a/drivers/i2c/busses/Makefile
+++ b/drivers/i2c/busses/Makefile
@@ -31,6 +31,7 @@ obj-$(CONFIG_I2C_POWERMAC)	+= i2c-powermac.o
 obj-$(CONFIG_I2C_AT91)		+= i2c-at91.o
 obj-$(CONFIG_I2C_AU1550)	+= i2c-au1550.o
 obj-$(CONFIG_I2C_BLACKFIN_TWI)	+= i2c-bfin-twi.o
+obj-$(CONFIG_I2C_CBUS)		+= i2c-cbus.o
 obj-$(CONFIG_I2C_CPM)		+= i2c-cpm.o
 obj-$(CONFIG_I2C_DAVINCI)	+= i2c-davinci.o
 obj-$(CONFIG_I2C_DESIGNWARE_PLATFORM)	+= i2c-designware-platform.o
diff --git a/drivers/i2c/busses/i2c-cbus.c b/drivers/i2c/busses/i2c-cbus.c
new file mode 100644
index 0000000..bacf2a9
--- /dev/null
+++ b/drivers/i2c/busses/i2c-cbus.c
@@ -0,0 +1,369 @@
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
+#include <linux/i2c-cbus.h>
+#include <linux/interrupt.h>
+#include <linux/platform_device.h>
+
+struct cbus_host {
+	/* host lock */
+	spinlock_t	lock;
+
+	struct device	*dev;
+
+	int		clk_gpio;
+	int		dat_gpio;
+	int		sel_gpio;
+};
+
+/**
+ * cbus_send_bit - sends one bit over the bus
+ * @host: the host we're using
+ * @bit: one bit of information to send
+ * @input: whether to set data pin as input after sending
+ */
+static int cbus_send_bit(struct cbus_host *host, unsigned bit,
+		unsigned input)
+{
+	int ret = 0;
+
+	gpio_set_value(host->dat_gpio, bit ? 1 : 0);
+	gpio_set_value(host->clk_gpio, 1);
+
+	/* The data bit is read on the rising edge of CLK */
+	if (input)
+		ret = gpio_direction_input(host->dat_gpio);
+
+	gpio_set_value(host->clk_gpio, 0);
+
+	return ret;
+}
+
+/**
+ * cbus_send_data - sends @len amount of data over the bus
+ * @host: the host we're using
+ * @data: the data to send
+ * @len: size of the transfer
+ * @input: whether to set data pin as input after sending
+ */
+static int cbus_send_data(struct cbus_host *host, unsigned data, unsigned len,
+		unsigned input)
+{
+	int ret = 0;
+	int i;
+
+	for (i = len; i > 0; i--) {
+		ret = cbus_send_bit(host, data & (1 << (i - 1)),
+				input && (i == 1));
+		if (ret < 0)
+			goto out;
+	}
+
+out:
+	return ret;
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
+	if (ret < 0)
+		goto out;
+	gpio_set_value(host->clk_gpio, 0);
+
+out:
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
+			goto out;
+
+		if (bit)
+			ret |= 1 << (i - 1);
+	}
+
+out:
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
+	ret = cbus_send_data(host, dev, 3, 0);
+	if (ret < 0) {
+		dev_dbg(host->dev, "failed sending device addr\n");
+		goto out;
+	}
+
+	/* Send the rw flag */
+	ret = cbus_send_bit(host, rw == I2C_SMBUS_READ, 0);
+	if (ret < 0) {
+		dev_dbg(host->dev, "failed sending read/write flag\n");
+		goto out;
+	}
+
+	/* Send the device address */
+	ret = cbus_send_data(host, reg, 5, rw == I2C_SMBUS_READ);
+	if (ret < 0) {
+		dev_dbg(host->dev, "failed sending register addr\n");
+		goto out;
+	}
+
+	if (rw == I2C_SMBUS_WRITE) {
+		ret = cbus_send_data(host, data, 16, 0);
+		if (ret < 0) {
+			dev_dbg(host->dev, "failed sending data\n");
+			goto out;
+		}
+	} else {
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
+	struct cbus_host *chost = i2c_get_adapdata(adapter);
+	int ret;
+
+	ret = i2c_del_adapter(adapter);
+	if (ret)
+		return ret;
+	gpio_free(chost->clk_gpio);
+	gpio_free(chost->dat_gpio);
+	gpio_free(chost->sel_gpio);
+	kfree(chost);
+	kfree(adapter);
+	platform_set_drvdata(pdev, NULL);
+
+	return 0;
+}
+
+static int cbus_i2c_probe(struct platform_device *pdev)
+{
+	struct i2c_adapter *adapter;
+	struct cbus_host *chost;
+	struct gpio gpios[3];
+	int ret;
+
+	adapter = kzalloc(sizeof(struct i2c_adapter), GFP_KERNEL);
+	if (!adapter) {
+		ret = -ENOMEM;
+		goto error;
+	}
+
+	chost = kzalloc(sizeof(*chost), GFP_KERNEL);
+	if (!chost) {
+		ret = -ENOMEM;
+		goto error_mem;
+	}
+
+	if (pdev->dev.of_node) {
+		struct device_node *dnode = pdev->dev.of_node;
+		if (of_gpio_count(dnode) != 3) {
+			ret = -ENODEV;
+			goto error_mem;
+		}
+		chost->clk_gpio = of_get_gpio(dnode, 0);
+		chost->dat_gpio = of_get_gpio(dnode, 1);
+		chost->sel_gpio = of_get_gpio(dnode, 2);
+	} else if (pdev->dev.platform_data) {
+		struct i2c_cbus_platform_data *pdata = pdev->dev.platform_data;
+		chost->clk_gpio = pdata->clk_gpio;
+		chost->dat_gpio = pdata->dat_gpio;
+		chost->sel_gpio = pdata->sel_gpio;
+	} else {
+		ret = -ENODEV;
+		goto error_mem;
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
+	gpios[0].gpio  = chost->clk_gpio;
+	gpios[0].flags = GPIOF_OUT_INIT_LOW;
+	gpios[0].label = "CBUS clk";
+
+	gpios[1].gpio  = chost->dat_gpio;
+	gpios[1].flags = GPIOF_IN;
+	gpios[1].label = "CBUS data";
+
+	gpios[2].gpio  = chost->sel_gpio;
+	gpios[2].flags = GPIOF_OUT_INIT_HIGH;
+	gpios[2].label = "CBUS sel";
+
+	ret = gpio_request_array(gpios, ARRAY_SIZE(gpios));
+	if (ret)
+		goto error_gpio;
+
+	gpio_set_value(chost->clk_gpio, 1);
+	gpio_set_value(chost->clk_gpio, 0);
+
+	i2c_set_adapdata(adapter, chost);
+	platform_set_drvdata(pdev, adapter);
+
+	ret = i2c_add_numbered_adapter(adapter);
+	if (ret)
+		goto error_i2c;
+
+	return 0;
+
+error_i2c:
+	gpio_free_array(gpios, ARRAY_SIZE(gpios));
+error_gpio:
+	kfree(chost);
+error_mem:
+	kfree(adapter);
+error:
+	return ret;
+}
+
+#if defined(CONFIG_OF)
+static const struct of_device_id i2c_cbus_dt_ids[] = {
+	{ .compatible = "i2c-cbus", },
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
+		.name	= "i2c-cbus",
+	},
+};
+module_platform_driver(cbus_i2c_driver);
+
+MODULE_ALIAS("platform:i2c-cbus");
+MODULE_DESCRIPTION("CBUS I2C driver");
+MODULE_AUTHOR("Juha Yrjölä");
+MODULE_AUTHOR("David Weinehall");
+MODULE_AUTHOR("Mikko Ylinen");
+MODULE_AUTHOR("Felipe Balbi");
+MODULE_AUTHOR("Aaro Koskinen <aaro.koskinen@iki.fi>");
+MODULE_LICENSE("GPL");
diff --git a/include/linux/i2c-cbus.h b/include/linux/i2c-cbus.h
new file mode 100644
index 0000000..636d726
--- /dev/null
+++ b/include/linux/i2c-cbus.h
@@ -0,0 +1,27 @@
+/*
+ * i2c-cbus.h - CBUS I2C platform_data definition
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
+#ifndef __INCLUDE_LINUX_I2C_CBUS_H
+#define __INCLUDE_LINUX_I2C_CBUS_H
+
+struct i2c_cbus_platform_data {
+	int dat_gpio;
+	int clk_gpio;
+	int sel_gpio;
+};
+
+#endif /* __INCLUDE_LINUX_I2C_CBUS_H */
-- 
1.7.2.5

