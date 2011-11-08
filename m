Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755299Ab1KIQGH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 11:06:07 -0500
Received: from mo-p05-ob.rzone.de ([81.169.146.181]:10173 "EHLO
	mo-p05-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755204Ab1KIQGF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 11:06:05 -0500
X-RZG-AUTH: :KXokZlStbvrPCC8w2n2KADUjx90tFpDbrwvi3rISAmCHBWiKTAoKIqY5gZEywA==
X-RZG-CLASS-ID: mo05
Message-Id: <fc7ccca66f0ffea1aa9c0409162b4a66974c46b3.1320853921.git.n.voss@weinmann.de>
In-Reply-To: <cover.1320853921.git.n.voss@weinmann.de>
References: <cover.1320853921.git.n.voss@weinmann.de>
From: Nikolaus Voss <n.voss@weinmann.de>
Date: Tue, 8 Nov 2011 11:49:46 +0100
Subject: [PATCH v4 2/4] drivers/i2c/busses/i2c-at91.c: add new driver
To: linux-i2c@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Cc: ben-linux@fluff.org, khali@linux-fr.org, nicolas.ferre@atmel.com,
        rmallon@gmail.com, balbi@ti.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This driver has the following properties compared to the old driver:
1. Support for multiple interfaces.
2. Interrupt driven I/O as opposed to polling/busy waiting.
3. Support for _one_ repeated start (Sr) condition, which is enough
   for most real-world applications including all SMBus transfer types.
   (The hardware does not support issuing arbitrary Sr conditions on the
    bus.)

Tested on Atmel G45 with BQ20Z80 battery SMBus client.

Signed-off-by: Nikolaus Voss <n.voss@weinmann.de>
---
 drivers/i2c/busses/Kconfig    |   11 +-
 drivers/i2c/busses/Makefile   |    1 +
 drivers/i2c/busses/i2c-at91.c |  417 +++++++++++++++++++++++++++++++++++++++++
 drivers/i2c/busses/i2c-at91.h |   80 ++++++++
 4 files changed, 502 insertions(+), 7 deletions(-)
 create mode 100644 drivers/i2c/busses/i2c-at91.c
 create mode 100644 drivers/i2c/busses/i2c-at91.h

diff --git a/drivers/i2c/busses/Kconfig b/drivers/i2c/busses/Kconfig
index a3afac4..2ef618d 100644
--- a/drivers/i2c/busses/Kconfig
+++ b/drivers/i2c/busses/Kconfig
@@ -285,18 +285,15 @@ comment "I2C system bus drivers (mostly embedded / system-on-chip)"
 
 config I2C_AT91
 	tristate "Atmel AT91 I2C Two-Wire interface (TWI)"
-	depends on ARCH_AT91 && EXPERIMENTAL && BROKEN
+	depends on ARCH_AT91 && EXPERIMENTAL
 	help
 	  This supports the use of the I2C interface on Atmel AT91
 	  processors.
 
-	  This driver is BROKEN because the controller which it uses
-	  will easily trigger RX overrun and TX underrun errors.  Using
-	  low I2C clock rates may partially work around those issues
-	  on some systems.  Another serious problem is that there is no
-	  documented way to issue repeated START conditions, as needed
+	  A serious problem is that there is no documented way to issue
+	  repeated START conditions for more than two messages, as needed
 	  to support combined I2C messages.  Use the i2c-gpio driver
-	  unless your system can cope with those limitations.
+	  unless your system can cope with this limitation.
 
 config I2C_AU1550
 	tristate "Au1550/Au1200 SMBus interface"
diff --git a/drivers/i2c/busses/Makefile b/drivers/i2c/busses/Makefile
index e8a1852..fba6da6 100644
--- a/drivers/i2c/busses/Makefile
+++ b/drivers/i2c/busses/Makefile
@@ -28,6 +28,7 @@ obj-$(CONFIG_I2C_HYDRA)		+= i2c-hydra.o
 obj-$(CONFIG_I2C_POWERMAC)	+= i2c-powermac.o
 
 # Embedded system I2C/SMBus host controller drivers
+obj-$(CONFIG_I2C_AT91)		+= i2c-at91.o
 obj-$(CONFIG_I2C_AU1550)	+= i2c-au1550.o
 obj-$(CONFIG_I2C_BLACKFIN_TWI)	+= i2c-bfin-twi.o
 obj-$(CONFIG_I2C_CPM)		+= i2c-cpm.o
diff --git a/drivers/i2c/busses/i2c-at91.c b/drivers/i2c/busses/i2c-at91.c
new file mode 100644
index 0000000..5f4be34
--- /dev/null
+++ b/drivers/i2c/busses/i2c-at91.c
@@ -0,0 +1,417 @@
+/*
+    i2c Support for Atmel's AT91 Two-Wire Interface (TWI)
+
+    Copyright (C) 2011 Nikolaus Voss <n.voss@weinmann.de>
+
+    Evolved from original work by:
+    Copyright (C) 2004 Rick Bronson
+    Converted to 2.6 by Andrew Victor <andrew@sanpeople.com>
+
+    Borrowed heavily from original work by:
+    Copyright (C) 2000 Philip Edelbrock <phil@stimpy.netroedge.com>
+
+    This program is free software; you can redistribute it and/or modify
+    it under the terms of the GNU General Public License as published by
+    the Free Software Foundation; either version 2 of the License, or
+    (at your option) any later version.
+*/
+
+#include <linux/clk.h>
+#include <linux/completion.h>
+#include <linux/err.h>
+#include <linux/i2c.h>
+#include <linux/interrupt.h>
+#include <linux/io.h>
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/slab.h>
+
+#include <mach/cpu.h>
+
+#include "i2c-at91.h"
+
+#define TWI_CLOCK_HZ		100000			/* max 400 Kbits/s */
+#define AT91_I2C_TIMEOUT	msecs_to_jiffies(10)	/* transfer timeout */
+
+struct at91_twi_dev {
+	struct device		*dev;
+	void __iomem		*base;
+	struct completion	cmd_complete;
+	struct clk		*clk;
+	u8			*buf;
+	size_t			buf_len;
+	int			irq;
+	unsigned		transfer_status;
+	struct i2c_adapter	adapter;
+};
+
+static unsigned at91_twi_read(struct at91_twi_dev *dev, unsigned reg)
+{
+	return __raw_readl(dev->base + reg);
+}
+
+static void at91_twi_write(struct at91_twi_dev *dev, unsigned reg, unsigned val)
+{
+	__raw_writel(val, dev->base + reg);
+}
+
+static void at91_disable_twi_interrupts(struct at91_twi_dev *dev)
+{
+	at91_twi_write(dev, AT91_TWI_IDR,
+		       AT91_TWI_TXCOMP | AT91_TWI_RXRDY | AT91_TWI_TXRDY);
+}
+
+static void at91_init_twi_bus(struct at91_twi_dev *dev)
+{
+	at91_disable_twi_interrupts(dev);
+	at91_twi_write(dev, AT91_TWI_CR, AT91_TWI_SWRST);
+	at91_twi_write(dev, AT91_TWI_CR, AT91_TWI_MSEN);
+	at91_twi_write(dev, AT91_TWI_CR, AT91_TWI_SVDIS);
+}
+
+static void at91_set_twi_clock(struct at91_twi_dev *dev)
+{
+	unsigned long cdiv, ckdiv;
+
+	/* Calcuate clock dividers and round up */
+	cdiv = (clk_get_rate(dev->clk) / (2 * TWI_CLOCK_HZ)) - 3 + 1;
+	ckdiv = 0;
+	while (cdiv > 255) {
+		ckdiv++;
+		cdiv = cdiv >> 1;
+	}
+
+	if (cpu_is_at91rm9200() && (ckdiv > 5)) {
+		dev_err(dev->dev, "AT91RM9200 Erratum #22: using ckdiv = 5.\n");
+		ckdiv = 5;
+	}
+
+	at91_twi_write(dev, AT91_TWI_CWGR, (ckdiv << 16) | (cdiv << 8) | cdiv);
+}
+
+static void __devinit at91_twi_hwinit(struct at91_twi_dev *dev)
+{
+	at91_init_twi_bus(dev);
+	at91_set_twi_clock(dev);
+}
+
+static void at91_twi_write_next_byte(struct at91_twi_dev *dev)
+{
+	if (dev->buf_len <= 0)
+		return;
+
+	at91_twi_write(dev, AT91_TWI_THR, *dev->buf);
+
+	/* send stop when last byte has been written */
+	if (--dev->buf_len == 0)
+		at91_twi_write(dev, AT91_TWI_CR, AT91_TWI_STOP);
+
+	dev_dbg(dev->dev, "wrote 0x%x, to go %d\n", *dev->buf, dev->buf_len);
+
+	++dev->buf;
+}
+
+static void at91_twi_read_next_byte(struct at91_twi_dev *dev)
+{
+	*dev->buf = at91_twi_read(dev, AT91_TWI_RHR) & 0xff;
+
+	/* send stop if second but last byte has been read */
+	if (--dev->buf_len == 1)
+		at91_twi_write(dev, AT91_TWI_CR, AT91_TWI_STOP);
+
+	dev_dbg(dev->dev, "read 0x%x, to go %d\n", *dev->buf, dev->buf_len);
+
+	++dev->buf;
+}
+
+static irqreturn_t atmel_twi_interrupt(int irq, void *dev_id)
+{
+	struct at91_twi_dev *dev = dev_id;
+	const unsigned status = at91_twi_read(dev, AT91_TWI_SR);
+	const unsigned irqstatus = status & at91_twi_read(dev, AT91_TWI_IMR);
+
+	if (irqstatus & AT91_TWI_TXCOMP) {
+		at91_disable_twi_interrupts(dev);
+		dev->transfer_status = status;
+		complete(&dev->cmd_complete);
+	} else if (irqstatus & AT91_TWI_RXRDY) {
+		at91_twi_read_next_byte(dev);
+	} else if (irqstatus & AT91_TWI_TXRDY) {
+		at91_twi_write_next_byte(dev);
+	} else {
+		return IRQ_NONE;
+	}
+
+	return IRQ_HANDLED;
+}
+
+static int at91_do_twi_transfer(struct at91_twi_dev *dev, bool is_read)
+{
+	int ret;
+
+	INIT_COMPLETION(dev->cmd_complete);
+	if (is_read) {
+		if (!dev->buf_len)
+			at91_twi_write(dev, AT91_TWI_CR,
+				       AT91_TWI_START | AT91_TWI_STOP);
+		else
+			at91_twi_write(dev, AT91_TWI_CR, AT91_TWI_START);
+		at91_twi_write(dev, AT91_TWI_IER,
+			       AT91_TWI_TXCOMP | AT91_TWI_RXRDY);
+	} else {
+		at91_twi_write_next_byte(dev);
+		at91_twi_write(dev, AT91_TWI_IER,
+			       AT91_TWI_TXCOMP | AT91_TWI_TXRDY);
+	}
+
+	ret = wait_for_completion_interruptible_timeout(&dev->cmd_complete,
+							dev->adapter.timeout);
+	if (ret == 0) {
+		dev_err(dev->dev, "controller timed out\n");
+		at91_init_twi_bus(dev);
+		return -ETIMEDOUT;
+	}
+	if (dev->transfer_status & AT91_TWI_NACK) {
+		dev_dbg(dev->dev, "received nack\n");
+		return -ENODEV;
+	}
+	if (dev->transfer_status & AT91_TWI_OVRE) {
+		dev_err(dev->dev, "overrun while reading\n");
+		return -EIO;
+	}
+	dev_dbg(dev->dev, "transfer complete\n");
+
+	return 0;
+}
+
+static int at91_twi_xfer(struct i2c_adapter *adap, struct i2c_msg *msg, int num)
+{
+	struct at91_twi_dev *dev = i2c_get_adapdata(adap);
+	int ret;
+	unsigned int_addr_flag = 0;
+	struct i2c_msg *m_start = msg;
+
+	dev_dbg(&adap->dev, "at91_xfer: processing %d messages:\n", num);
+
+	/*
+	 * The hardware can handle at most two messages concatenated by a
+	 * repeated start via it's internal address feature.
+	 */
+	if (num > 2) {
+		dev_err(dev->dev,
+			"cannot handle more than two concatenated messages.\n");
+		return 0;
+	} else if (num == 2) {
+		int internal_address = 0;
+		int i;
+
+		if (msg->flags & I2C_M_RD) {
+			dev_err(dev->dev, "first transfer must be write.\n");
+			return -EINVAL;
+		}
+		if (msg->len > 3) {
+			dev_err(dev->dev, "first message size must be <= 3.\n");
+			return -EINVAL;
+		}
+
+		/* 1st msg is put into the internal address, start with 2nd */
+		m_start = &msg[1];
+		for (i = 0; i < msg->len; ++i) {
+			internal_address |= ((unsigned)msg->buf[i]) << (8 * i);
+			int_addr_flag += AT91_TWI_IADRSZ_1;
+		}
+		at91_twi_write(dev, AT91_TWI_IADR, internal_address);
+	}
+
+	at91_twi_write(dev, AT91_TWI_MMR, (m_start->addr << 16) | int_addr_flag
+		       | ((m_start->flags & I2C_M_RD) ? AT91_TWI_MREAD : 0));
+
+	dev->buf_len = m_start->len;
+	dev->buf = m_start->buf;
+
+	ret = at91_do_twi_transfer(dev, m_start->flags & I2C_M_RD);
+	if (ret < 0)
+		return ret;
+
+	return num;
+}
+
+static u32 at91_twi_func(struct i2c_adapter *adapter)
+{
+	return I2C_FUNC_I2C | I2C_FUNC_SMBUS_EMUL;
+}
+
+static struct i2c_algorithm at91_twi_algorithm = {
+	.master_xfer	= at91_twi_xfer,
+	.functionality	= at91_twi_func,
+};
+
+static int __devinit at91_twi_probe(struct platform_device *pdev)
+{
+	struct at91_twi_dev *dev;
+	struct resource *mem, *irq, *ioarea;
+	int rc;
+
+	mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!mem)
+		return -ENODEV;
+
+	irq = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
+	if (!irq)
+		return -ENODEV;
+
+	ioarea = request_mem_region(mem->start, resource_size(mem), pdev->name);
+	if (!ioarea)
+		return -EBUSY;
+
+	dev = kzalloc(sizeof(struct at91_twi_dev), GFP_KERNEL);
+	if (!dev) {
+		rc = -ENOMEM;
+		goto err_release_region;
+	}
+
+	init_completion(&dev->cmd_complete);
+
+	dev->dev = &pdev->dev;
+	dev->irq = irq->start;
+	platform_set_drvdata(pdev, dev);
+
+	dev->clk = clk_get(dev->dev, "twi_clk");
+	if (IS_ERR(dev->clk)) {
+		dev_err(dev->dev, "no clock defined\n");
+		rc = -ENODEV;
+		goto err_free_mem;
+	}
+	clk_prepare(dev->clk);
+	clk_enable(dev->clk);
+
+	dev->base = ioremap(mem->start, resource_size(mem));
+	if (!dev->base) {
+		rc = -EBUSY;
+		goto err_mem_ioremap;
+	}
+
+	at91_twi_hwinit(dev);
+
+	rc = request_irq(dev->irq, atmel_twi_interrupt, 0,
+			 dev_name(dev->dev), dev);
+	if (rc) {
+		dev_err(dev->dev, "Cannot get irq %d: %d\n", dev->irq, rc);
+		goto err_unuse_clocks;
+	}
+
+	snprintf(dev->adapter.name, sizeof(dev->adapter.name), "AT91");
+	i2c_set_adapdata(&dev->adapter, dev);
+	dev->adapter.owner = THIS_MODULE;
+	dev->adapter.class = I2C_CLASS_HWMON;
+	dev->adapter.algo = &at91_twi_algorithm;
+	dev->adapter.dev.parent = dev->dev;
+	dev->adapter.nr = pdev->id;
+	dev->adapter.timeout = AT91_I2C_TIMEOUT;
+
+	rc = i2c_add_numbered_adapter(&dev->adapter);
+	if (rc) {
+		dev_err(dev->dev, "Adapter %s registration failed\n",
+			dev->adapter.name);
+		goto err_free_irq;
+	}
+
+	dev_info(dev->dev, "AT91 i2c bus driver.\n");
+	return 0;
+
+err_free_irq:
+	free_irq(dev->irq, dev);
+err_unuse_clocks:
+	iounmap(dev->base);
+err_mem_ioremap:
+	clk_disable(dev->clk);
+	clk_put(dev->clk);
+err_free_mem:
+	kfree(dev);
+err_release_region:
+	release_mem_region(mem->start, resource_size(mem));
+
+	return rc;
+}
+
+static int __devexit at91_twi_remove(struct platform_device *pdev)
+{
+	struct at91_twi_dev *dev = platform_get_drvdata(pdev);
+	struct resource *mem;
+	int rc;
+
+	platform_set_drvdata(pdev, NULL);
+	rc = i2c_del_adapter(&dev->adapter);
+	put_device(dev->dev);
+
+	clk_disable(dev->clk);
+	clk_put(dev->clk);
+	dev->clk = NULL;
+
+	free_irq(dev->irq, dev);
+
+	iounmap(dev->base);
+	kfree(dev);
+
+	mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	release_mem_region(mem->start, resource_size(mem));
+
+	return rc;
+}
+
+#ifdef CONFIG_PM
+
+static int at91_twi_suspend(struct device *dev)
+{
+	struct at91_twi_dev *twi_dev = dev_get_drvdata(dev);
+
+	clk_disable(twi_dev->clk);
+
+	return 0;
+}
+
+static int at91_twi_resume(struct device *dev)
+{
+	struct at91_twi_dev *twi_dev = dev_get_drvdata(dev);
+
+	return clk_enable(twi_dev->clk);
+}
+
+static const struct dev_pm_ops at91_twi_pm = {
+	.suspend	= at91_twi_suspend,
+	.resume		= at91_twi_resume,
+};
+
+#define at91_twi_pm_ops (&at91_twi_pm)
+#else
+#define at91_twi_pm_ops NULL
+#endif
+
+MODULE_ALIAS("platform:at91_i2c");
+
+static struct platform_driver at91_twi_driver = {
+	.probe		= at91_twi_probe,
+	.remove		= __devexit_p(at91_twi_remove),
+	.driver		= {
+		.name	= "at91_i2c",
+		.owner	= THIS_MODULE,
+		.pm	= at91_twi_pm_ops,
+	},
+};
+
+static int __init at91_twi_init(void)
+{
+	return platform_driver_register(&at91_twi_driver);
+}
+
+static void __exit at91_twi_exit(void)
+{
+	platform_driver_unregister(&at91_twi_driver);
+}
+
+module_init(at91_twi_init);
+module_exit(at91_twi_exit);
+
+MODULE_AUTHOR("Nikolaus Voss");
+MODULE_DESCRIPTION("I2C (TWI) driver for Atmel AT91");
+MODULE_LICENSE("GPL");
diff --git a/drivers/i2c/busses/i2c-at91.h b/drivers/i2c/busses/i2c-at91.h
new file mode 100644
index 0000000..a898159
--- /dev/null
+++ b/drivers/i2c/busses/i2c-at91.h
@@ -0,0 +1,80 @@
+/*
+ * Copyright (C) 2005 Ivan Kokshaysky
+ * Copyright (C) SAN People
+ *
+ * Two-wire Interface (TWI) registers.
+ * Based on AT91RM9200 datasheet revision E.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#ifndef AT91_TWI_H
+#define AT91_TWI_H
+
+#define	AT91_TWI_CR		0x00		/* Control Register */
+#define	AT91_TWI_START		(1 <<  0)	/* Send a Start Condition */
+#define	AT91_TWI_STOP		(1 <<  1)	/* Send a Stop Condition */
+#define	AT91_TWI_MSEN		(1 <<  2)	/* Master Transfer Enable */
+#define	AT91_TWI_MSDIS		(1 <<  3)	/* Master Transfer Disable */
+#define	AT91_TWI_SVEN		(1 <<  4)	/* Slave Transfer Enable
+						 *  [SAM9260 only] */
+#define	AT91_TWI_SVDIS		(1 <<  5)	/* Slave Transfer Disable
+						 *  [SAM9260 only] */
+#define	AT91_TWI_SWRST		(1 <<  7)	/* Software Reset */
+
+#define	AT91_TWI_MMR		0x04		/* Master Mode Register */
+#define	AT91_TWI_IADRSZ		(3    <<  8)	/* Internal Device Address
+						 *  Size */
+#define	AT91_TWI_IADRSZ_NO	(0 << 8)
+#define	AT91_TWI_IADRSZ_1	(1 << 8)
+#define	AT91_TWI_IADRSZ_2	(2 << 8)
+#define	AT91_TWI_IADRSZ_3	(3 << 8)
+#define	AT91_TWI_MREAD		(1    << 12)	/* Master Read Direction */
+#define	AT91_TWI_DADR		(0x7f << 16)	/* Device Address */
+
+#define	AT91_TWI_SMR		0x08		/* Slave Mode Register
+						 *  [SAM9260 only] */
+#define	AT91_TWI_SADR		(0x7f << 16)	/* Slave Address */
+
+#define	AT91_TWI_IADR		0x0c		/* Internal Address Register */
+
+#define	AT91_TWI_CWGR		0x10		/* Clock Waveform Generator
+						 *  Register */
+#define	AT91_TWI_CLDIV		(0xff <<  0)	/* Clock Low Divisor */
+#define	AT91_TWI_CHDIV		(0xff <<  8)	/* Clock High Divisor */
+#define	AT91_TWI_CKDIV		(7    << 16)	/* Clock Divider */
+
+#define	AT91_TWI_SR		0x20		/* Status Register */
+#define	AT91_TWI_TXCOMP		(1 <<  0)	/* Transmission Complete */
+#define	AT91_TWI_RXRDY		(1 <<  1)	/* Receive Holding Register
+						 *  Ready */
+#define	AT91_TWI_TXRDY		(1 <<  2)	/* Transmit Holding Register
+						 *  Ready */
+#define	AT91_TWI_SVREAD		(1 <<  3)	/* Slave Read [SAM9260 only] */
+#define	AT91_TWI_SVACC		(1 <<  4)	/* Slave Access
+						 *  [SAM9260 only] */
+#define	AT91_TWI_GACC		(1 <<  5)	/* General Call Access
+						 *  [SAM9260 only] */
+#define	AT91_TWI_OVRE		(1 <<  6)	/* Overrun Error
+						 *  [AT91RM9200 only] */
+#define	AT91_TWI_UNRE		(1 <<  7)	/* Underrun Error
+						 *  [AT91RM9200 only] */
+#define	AT91_TWI_NACK		(1 <<  8)	/* Not Acknowledged */
+#define	AT91_TWI_ARBLST		(1 <<  9)	/* Arbitration Lost
+						 *  [SAM9260 only] */
+#define	AT91_TWI_SCLWS		(1 << 10)	/* Clock Wait State
+						 *  [SAM9260 only] */
+#define	AT91_TWI_EOSACC		(1 << 11)	/* End of Slave Address
+						 *  [SAM9260 only] */
+
+#define	AT91_TWI_IER		0x24		/* Interrupt Enable Register */
+#define	AT91_TWI_IDR		0x28		/* Interrupt Disable Register */
+#define	AT91_TWI_IMR		0x2c		/* Interrupt Mask Register */
+#define	AT91_TWI_RHR		0x30		/* Receive Holding Register */
+#define	AT91_TWI_THR		0x34		/* Transmit Holding Register */
+
+#endif
+
-- 
1.7.5.4

