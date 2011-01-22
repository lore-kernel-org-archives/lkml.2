Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753072Ab1AXCag (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Jan 2011 21:30:36 -0500
Received: from mprc.pku.edu.cn ([162.105.203.9]:44473 "EHLO mprc.pku.edu.cn"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752683Ab1AXCaf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Jan 2011 21:30:35 -0500
From: "Guan Xuetao" <guanxuetao@mprc.pku.edu.cn>
To: <khali@linux-fr.org>, <ben-linux@fluff.org>
Cc: <linux-i2c@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] unicore32: add i2c bus driver for PKUnity SoC
Date: Sat, 22 Jan 2011 18:55:09 +0800
Message-ID: <01d101cbba22$d8071bb0$88155310$@mprc.pku.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
thread-index: Acu6IqIlv9n7UycbQQmwyDb+o0pOcA==
Content-Language: zh-cn
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Guan Xuetao <gxt@mprc.pku.edu.cn>

This patch adds framebuffer driver for unigfx engine in PKUnity SoC.

Signed-off-by: Guan Xuetao <gxt@mprc.pku.edu.cn>
---
 drivers/i2c/busses/Kconfig    |    5 +
 drivers/i2c/busses/Makefile   |    1 +
 drivers/i2c/busses/puv3_i2c.c |  300 +++++++++++++++++++++++++++++++++++++++++
 3 files changed, 306 insertions(+), 0 deletions(-)

diff --git a/drivers/i2c/busses/Kconfig b/drivers/i2c/busses/Kconfig
index 3a6321c..20d328c 100644
--- a/drivers/i2c/busses/Kconfig
+++ b/drivers/i2c/busses/Kconfig
@@ -236,6 +236,11 @@ config I2C_VIAPRO
 	  This driver can also be built as a module.  If so, the module
 	  will be called i2c-viapro.
 
+config I2C_PUV3
+	tristate "PKUnity v3 I2C bus support"
+	depends on I2C && UNICORE32 && ARCH_PUV3
+	select I2C_ALGOBIT
+
 if ACPI
 
 comment "ACPI drivers"
diff --git a/drivers/i2c/busses/Makefile b/drivers/i2c/busses/Makefile
index 84cb16a..cb4a097 100644
--- a/drivers/i2c/busses/Makefile
+++ b/drivers/i2c/busses/Makefile
@@ -61,6 +61,7 @@ obj-$(CONFIG_I2C_STU300)	+= i2c-stu300.o
 obj-$(CONFIG_I2C_VERSATILE)	+= i2c-versatile.o
 obj-$(CONFIG_I2C_OCTEON)	+= i2c-octeon.o
 obj-$(CONFIG_I2C_XILINX)	+= i2c-xiic.o
+obj-$(CONFIG_I2C_PUV3)		+= puv3_i2c.o
 
 # External I2C/SMBus adapter drivers
 obj-$(CONFIG_I2C_PARPORT)	+= i2c-parport.o
diff --git a/drivers/i2c/busses/puv3_i2c.c b/drivers/i2c/busses/puv3_i2c.c
new file mode 100644
index 0000000..fb4f1fd
--- /dev/null
+++ b/drivers/i2c/busses/puv3_i2c.c
@@ -0,0 +1,300 @@
+/*
+ * I2C driver for PKUnity-v3 SoC
+ * Code specific to PKUnity SoC and UniCore ISA
+ *
+ *	Maintained by GUAN Xue-tao <gxt@mprc.pku.edu.cn>
+ *	Copyright (C) 2001-2010 Guan Xuetao
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/err.h>
+#include <linux/slab.h>
+#include <linux/types.h>
+#include <linux/delay.h>
+#include <linux/i2c.h>
+#include <linux/init.h>
+#include <linux/clk.h>
+#include <linux/platform_device.h>
+#include <linux/io.h>
+#include <mach/hardware.h>
+
+static int i2c_reg = -1;
+
+/*
+ * Poll the i2c status register until the specified bit is set.
+ * Returns 0 if timed out (100 msec).
+ */
+static short poll_status(unsigned long bit)
+{
+	int loop_cntr = 1000;
+
+	if (bit & I2C_STATUS_TFNF) {
+		do {
+			udelay(10);
+		} while (!(I2C_STATUS & bit) && (--loop_cntr > 0));
+	} else {
+		/* RXRDY handler */
+		do {
+			if (I2C_TAR == I2C_TAR_EEPROM)
+				msleep(20);
+			else
+				udelay(10);
+		} while (!(I2C_RXFLR & 0xf) && (--loop_cntr > 0));
+	}
+
+	return (loop_cntr > 0);
+}
+
+static int xfer_read(struct i2c_adapter *adap, unsigned char *buf, int length)
+{
+	/* Read data */
+	while (length--) {
+		if (!poll_status(I2C_STATUS_TFNF)) {
+			dev_dbg(&adap->dev, "Tx FIFO Not Full timeout\n");
+			return -ETIMEDOUT;
+		}
+
+		/* send addr */
+		I2C_DATACMD = i2c_reg | I2C_DATACMD_WRITE;
+
+		/* get ready to next write */
+		i2c_reg++;
+
+		/* send read CMD */
+		I2C_DATACMD = I2C_DATACMD_READ;
+
+		/* wait until the Rx FIFO have available */
+		if (!poll_status(I2C_STATUS_RFNE)) {
+			dev_dbg(&adap->dev, "RXRDY timeout\n");
+			return -ETIMEDOUT;
+		}
+
+		/* read the data to buf */
+		*buf = (I2C_DATACMD & I2C_DATACMD_DAT_MASK);
+		buf++;
+	}
+
+	i2c_reg = -1;
+
+	return 0;
+}
+
+static int xfer_write(struct i2c_adapter *adap, unsigned char *buf, int length)
+{
+	/* Do nothing but storing the reg_num to a static variable */
+	i2c_reg = *buf;
+	if (i2c_reg == -1) {
+		printk(KERN_WARNING "Error i2c reg\n");
+		return -ETIMEDOUT;
+	}
+
+	if (length == 1)
+		return 0;
+
+	buf++;
+	length--;
+	while (length--) {
+		/* send addr */
+		I2C_DATACMD = i2c_reg | I2C_DATACMD_WRITE;
+
+		/* send write CMD */
+		I2C_DATACMD = *buf | I2C_DATACMD_WRITE;
+
+		/* wait until the Rx FIFO have available */
+		msleep(20);
+
+		/* read the data to buf */
+		i2c_reg++;
+		buf++;
+	}
+
+	i2c_reg = -1;
+
+	return 0;
+}
+
+/*
+ * Generic i2c master transfer entrypoint.
+ *
+ */
+static int puv3_i2c_xfer(struct i2c_adapter *adap, struct i2c_msg *pmsg,
+		int num)
+{
+	int i, ret;
+	unsigned char swap;
+
+	/* Disable i2c */
+	I2C_ENABLE = I2C_ENABLE_DISABLE;
+
+	/* Set the work mode and speed*/
+	I2C_CON = I2C_CON_MASTER | I2C_CON_SPEED_STD | I2C_CON_SLAVEDISABLE;
+
+	I2C_TAR = pmsg->addr;
+
+	/* Enable i2c */
+	I2C_ENABLE = I2C_ENABLE_ENABLE;
+
+	dev_dbg(&adap->dev, "puv3_i2c_xfer: processing %d messages:\n", num);
+
+	for (i = 0; i < num; i++) {
+		dev_dbg(&adap->dev, " #%d: %sing %d byte%s %s 0x%02x\n", i,
+			pmsg->flags & I2C_M_RD ? "read" : "writ",
+			pmsg->len, pmsg->len > 1 ? "s" : "",
+			pmsg->flags & I2C_M_RD ? "from" : "to",	pmsg->addr);
+
+		if (pmsg->len && pmsg->buf) {	/* sanity check */
+			if (pmsg->flags & I2C_M_RD)
+				ret = xfer_read(adap, pmsg->buf, pmsg->len);
+			else
+				ret = xfer_write(adap, pmsg->buf, pmsg->len);
+
+			if (ret)
+				return ret;
+
+		}
+		dev_dbg(&adap->dev, "transfer complete\n");
+		pmsg++;		/* next message */
+	}
+
+	/* XXX: fixup be16_to_cpu in bq27x00_battery.c */
+	if (pmsg->addr == I2C_TAR_PWIC) {
+		swap = pmsg->buf[0];
+		pmsg->buf[0] = pmsg->buf[1];
+		pmsg->buf[1] = swap;
+	}
+
+	return i;
+}
+
+/*
+ * Return list of supported functionality.
+ */
+static u32 puv3_i2c_func(struct i2c_adapter *adapter)
+{
+	return I2C_FUNC_I2C | I2C_FUNC_SMBUS_EMUL;
+}
+
+static struct i2c_algorithm puv3_i2c_algorithm = {
+	.master_xfer	= puv3_i2c_xfer,
+	.functionality	= puv3_i2c_func,
+};
+
+/*
+ * Main initialization routine.
+ */
+static int __devinit puv3_i2c_probe(struct platform_device *pdev)
+{
+	struct i2c_adapter *adapter;
+	struct resource *res;
+	int rc;
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!res)
+		return -ENXIO;
+
+	if (!request_mem_region(res->start, resource_size(res), "puv3_i2c"))
+		return -EBUSY;
+
+	adapter = kzalloc(sizeof(struct i2c_adapter), GFP_KERNEL);
+	if (adapter == NULL) {
+		dev_err(&pdev->dev, "can't allocate inteface!\n");
+		rc = -ENOMEM;
+		goto fail2;
+	}
+	snprintf(adapter->name, sizeof(adapter->name), "PUV3");
+	adapter->algo = &puv3_i2c_algorithm;
+	adapter->class = I2C_CLASS_HWMON;
+	adapter->dev.parent = &pdev->dev;
+
+	platform_set_drvdata(pdev, adapter);
+
+	rc = i2c_add_numbered_adapter(adapter);
+	if (rc) {
+		dev_err(&pdev->dev, "Adapter %s registration failed\n",
+				adapter->name);
+		goto fail3;
+	}
+
+	dev_info(&pdev->dev, "PKUnity v3 i2c bus driver.\n");
+	return 0;
+
+fail3:
+	platform_set_drvdata(pdev, NULL);
+	kfree(adapter);
+fail2:
+	release_mem_region(res->start, resource_size(res));
+
+	return rc;
+}
+
+static int puv3_i2c_remove(struct platform_device *pdev)
+{
+	struct i2c_adapter *adapter = platform_get_drvdata(pdev);
+	struct resource *res;
+	int rc;
+
+	rc = i2c_del_adapter(adapter);
+	platform_set_drvdata(pdev, NULL);
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	release_mem_region(res->start, resource_size(res));
+
+	return rc;
+}
+
+#ifdef CONFIG_PM
+static int puv3_i2c_suspend(struct platform_device *dev, pm_message_t state)
+{
+	int poll_count;
+	/* Disable the IIC */
+	I2C_ENABLE = I2C_ENABLE_DISABLE;
+	for (poll_count = 0; poll_count < 50; poll_count++) {
+		if (I2C_ENSTATUS & I2C_ENSTATUS_ENABLE)
+			udelay(25);
+	}
+
+	return 0;
+}
+
+static int puv3_i2c_resume(struct platform_device *dev)
+{
+	return 0 ;
+}
+#else
+#define puv3_i2c_suspend NULL
+#define puv3_i2c_resume NULL
+#endif
+
+MODULE_ALIAS("platform:puv3_i2c");
+
+static struct platform_driver puv3_i2c_driver = {
+	.probe		= puv3_i2c_probe,
+	.remove		= __devexit_p(puv3_i2c_remove),
+	.suspend	= puv3_i2c_suspend,
+	.resume		= puv3_i2c_resume,
+	.driver		= {
+		.name	= "PKUnity-v3-I2C",
+		.owner	= THIS_MODULE,
+	}
+};
+
+static int __init puv3_i2c_init(void)
+{
+	return platform_driver_register(&puv3_i2c_driver);
+}
+
+static void __exit puv3_i2c_exit(void)
+{
+	platform_driver_unregister(&puv3_i2c_driver);
+}
+
+module_init(puv3_i2c_init);
+module_exit(puv3_i2c_exit);
+
+MODULE_DESCRIPTION("PKUnity v3 I2C driver");
+MODULE_LICENSE("GPL v2");

