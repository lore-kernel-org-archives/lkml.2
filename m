Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752983Ab1AXO3R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 09:29:17 -0500
Received: from mprc.pku.edu.cn ([162.105.203.9]:59732 "EHLO mprc.pku.edu.cn"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752894Ab1AXO3Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 09:29:16 -0500
From: "Guan Xuetao" <guanxuetao@mprc.pku.edu.cn>
To: <khali@linux-fr.org>
Cc: <ben-linux@fluff.org>, <linux-i2c@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCHv2] unicore32: add i2c bus driver for PKUnity SoC
Date: Mon, 24 Jan 2011 22:28:51 +0800
Message-ID: <010801cbbbd3$0542f980$0fc8ec80$@mprc.pku.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
thread-index: Acu70jR6lN8wO6xdRZONMs/qTTWc+g==
Content-Language: zh-cn
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Guan Xuetao <gxt@mprc.pku.edu.cn>

This patch adds i2c bus driver for PKUnity-v3 SoC.

Changes from v1 (from advice of Jean Delvare):
	1. remove global variable i2c_reg, replaced by local variables
	2. replace ENXIO with ENODEV when no platform resources
	3. add adapter->nr assignment before i2c_add_numbered_apapter() call
	4. add judgment for i2c_del_adapter() return value
	5. release adapter when driver removed
	6. add __devexit for puv3_i2c_remove() function
	7. modify several names to more appropriated ones
	8. adjust positions and contents in i2c/busses/ Kconfig and Makefile

Signed-off-by: Guan Xuetao <gxt@mprc.pku.edu.cn>
---
 drivers/i2c/busses/Kconfig    |   11 ++
 drivers/i2c/busses/Makefile   |    1 +
 drivers/i2c/busses/i2c-puv3.c |  306 +++++++++++++++++++++++++++++++++++++++++
 3 files changed, 318 insertions(+), 0 deletions(-)

diff --git a/drivers/i2c/busses/Kconfig b/drivers/i2c/busses/Kconfig
index 3a6321c..d358aae 100644
--- a/drivers/i2c/busses/Kconfig
+++ b/drivers/i2c/busses/Kconfig
@@ -523,6 +523,17 @@ config I2C_PNX
 	  This driver can also be built as a module.  If so, the module
 	  will be called i2c-pnx.
 
+config I2C_PUV3
+	tristate "PKUnity v3 I2C bus support"
+	depends on UNICORE32 && ARCH_PUV3
+	select I2C_ALGOBIT
+	help
+	  This driver supports the I2C IP inside the PKUnity-v3 SoC.
+	  This I2C bus controller is under AMBA/AXI bus.
+
+	  This driver can also be built as a module.  If so, the module
+	  will be called i2c-puv3.
+
 config I2C_PXA
 	tristate "Intel PXA2XX I2C adapter"
 	depends on ARCH_PXA || ARCH_MMP
diff --git a/drivers/i2c/busses/Makefile b/drivers/i2c/busses/Makefile
index 84cb16a..a66e903 100644
--- a/drivers/i2c/busses/Makefile
+++ b/drivers/i2c/busses/Makefile
@@ -51,6 +51,7 @@ obj-$(CONFIG_I2C_PASEMI)	+= i2c-pasemi.o
 obj-$(CONFIG_I2C_PCA_PLATFORM)	+= i2c-pca-platform.o
 obj-$(CONFIG_I2C_PMCMSP)	+= i2c-pmcmsp.o
 obj-$(CONFIG_I2C_PNX)		+= i2c-pnx.o
+obj-$(CONFIG_I2C_PUV3)		+= i2c-puv3.o
 obj-$(CONFIG_I2C_PXA)		+= i2c-pxa.o
 obj-$(CONFIG_I2C_S3C2410)	+= i2c-s3c2410.o
 obj-$(CONFIG_I2C_S6000)		+= i2c-s6000.o
diff --git a/drivers/i2c/busses/i2c-puv3.c b/drivers/i2c/busses/i2c-puv3.c
new file mode 100644
index 0000000..4800f6a
--- /dev/null
+++ b/drivers/i2c/busses/i2c-puv3.c
@@ -0,0 +1,306 @@
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
+	int i2c_reg = 0;
+
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
+	return 0;
+}
+
+static int xfer_write(struct i2c_adapter *adap, unsigned char *buf, int length)
+{
+	int i2c_reg = *buf;
+
+	/* Do nothing but storing the reg_num to a static variable */
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
+	struct resource *mem;
+	int rc;
+
+	mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!mem)
+		return -ENODEV;
+
+	if (!request_mem_region(mem->start, resource_size(mem), "puv3_i2c"))
+		return -EBUSY;
+
+	adapter = kzalloc(sizeof(struct i2c_adapter), GFP_KERNEL);
+	if (adapter == NULL) {
+		dev_err(&pdev->dev, "can't allocate inteface!\n");
+		rc = -ENOMEM;
+		goto fail_nomem;
+	}
+	snprintf(adapter->name, sizeof(adapter->name), "PUV3-I2C at 0x%08x",
+			mem->start);
+	adapter->algo = &puv3_i2c_algorithm;
+	adapter->class = I2C_CLASS_HWMON;
+	adapter->dev.parent = &pdev->dev;
+
+	platform_set_drvdata(pdev, adapter);
+
+	adapter->nr = pdev->id;
+	rc = i2c_add_numbered_adapter(adapter);
+	if (rc) {
+		dev_err(&pdev->dev, "Adapter '%s' registration failed\n",
+				adapter->name);
+		goto fail_add_adapter;
+	}
+
+	dev_info(&pdev->dev, "PKUnity v3 i2c bus adapter.\n");
+	return 0;
+
+fail_add_adapter:
+	platform_set_drvdata(pdev, NULL);
+	kfree(adapter);
+fail_nomem:
+	release_mem_region(mem->start, resource_size(mem));
+
+	return rc;
+}
+
+static int __devexit puv3_i2c_remove(struct platform_device *pdev)
+{
+	struct i2c_adapter *adapter = platform_get_drvdata(pdev);
+	struct resource *mem;
+	int rc;
+
+	rc = i2c_del_adapter(adapter);
+	if (rc) {
+		dev_err(&pdev->dev, "Adapter '%s' delete fail\n",
+				adapter->name);
+		return rc;
+	}
+
+	put_device(&pdev->dev);
+	platform_set_drvdata(pdev, NULL);
+
+	mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	release_mem_region(mem->start, resource_size(mem));
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

