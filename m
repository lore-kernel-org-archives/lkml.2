Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755155Ab2APPca (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 10:32:30 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:40030 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753711Ab2APPc2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 10:32:28 -0500
From: Sascha Hauer <s.hauer@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: Samuel Ortiz <sameo@linux.intel.com>, Jean Delvare <khali@linux-fr.org>,
        Wim Van Sebroeck <wim@iguana.be>,
        Sascha Hauer <s.hauer@pengutronix.de>
Subject: [PATCH 2/3] i2c: Add Congatec CGEB I2C driver
Date: Mon, 16 Jan 2012 16:32:19 +0100
Message-Id: <1326727940-6078-3-git-send-email-s.hauer@pengutronix.de>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1326727940-6078-1-git-send-email-s.hauer@pengutronix.de>
References: <1326727940-6078-1-git-send-email-s.hauer@pengutronix.de>
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:219:66ff:fe5b:d076
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This driver provides a I2C bus driver for the CGEB interface
found on some Congatec x86 modules. No devices are registered
on the bus, the user has to do this via the i2c device /sys
interface.

Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
---
 drivers/i2c/busses/Kconfig             |    7 +
 drivers/i2c/busses/Makefile            |    1 +
 drivers/i2c/busses/i2c-congatec-cgeb.c |  206 ++++++++++++++++++++++++++++++++
 3 files changed, 214 insertions(+), 0 deletions(-)
 create mode 100644 drivers/i2c/busses/i2c-congatec-cgeb.c

diff --git a/drivers/i2c/busses/Kconfig b/drivers/i2c/busses/Kconfig
index a3afac4..cc8eb22 100644
--- a/drivers/i2c/busses/Kconfig
+++ b/drivers/i2c/busses/Kconfig
@@ -696,6 +696,13 @@ config I2C_EG20T
 	  ML7213/ML7223 is companion chip for Intel Atom E6xx series.
 	  ML7213/ML7223 is completely compatible for Intel EG20T PCH.
 
+config I2C_CONGATEC_CGEB
+	tristate "Congatec CGEB I2C driver"
+	depends on MFD_CONGATEC_CGEB
+	help
+	  This driver provides support for the I2C busses accssable via
+	  the Congatec CGEB interface found on Congatec boards.
+
 comment "External I2C/SMBus adapter drivers"
 
 config I2C_DIOLAN_U2C
diff --git a/drivers/i2c/busses/Makefile b/drivers/i2c/busses/Makefile
index fba6da6..4aab659 100644
--- a/drivers/i2c/busses/Makefile
+++ b/drivers/i2c/busses/Makefile
@@ -69,6 +69,7 @@ obj-$(CONFIG_I2C_VERSATILE)	+= i2c-versatile.o
 obj-$(CONFIG_I2C_OCTEON)	+= i2c-octeon.o
 obj-$(CONFIG_I2C_XILINX)	+= i2c-xiic.o
 obj-$(CONFIG_I2C_EG20T)         += i2c-eg20t.o
+obj-$(CONFIG_I2C_CONGATEC_CGEB)	+= i2c-congatec-cgeb.o
 
 # External I2C/SMBus adapter drivers
 obj-$(CONFIG_I2C_DIOLAN_U2C)	+= i2c-diolan-u2c.o
diff --git a/drivers/i2c/busses/i2c-congatec-cgeb.c b/drivers/i2c/busses/i2c-congatec-cgeb.c
new file mode 100644
index 0000000..a387662
--- /dev/null
+++ b/drivers/i2c/busses/i2c-congatec-cgeb.c
@@ -0,0 +1,206 @@
+/*
+ * CGEB i2c driver
+ *
+ * (c) 2011 Sascha Hauer, Pengutronix
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; version 2 of the License.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/slab.h>
+#include <linux/i2c.h>
+#include <linux/mfd/congatec-cgeb.h>
+
+#define CG_I2C_FLAG_START   0x00080	/* send START condition */
+#define CG_I2C_FLAG_STOP    0x00040	/* send STOP condition */
+#define CG_I2C_FLAG_ALL_ACK 0x08000	/* send ACK on all read bytes */
+#define CG_I2C_FLAG_ALL_NAK 0x04000	/* send NAK on all read bytes */
+
+struct cgeb_i2c_priv {
+	struct cgeb_board_data		*board;
+	struct i2c_adapter	adapter;
+	int unit;
+};
+
+static u32 cgeb_i2c_func(struct i2c_adapter *adapter)
+{
+	return I2C_FUNC_I2C | I2C_FUNC_SMBUS_EMUL;
+}
+
+static int cgeb_i2c_set_speed(struct cgeb_i2c_priv *priv, int speed)
+{
+	struct cgeb_function_parameters fps;
+
+	memset(&fps, 0, sizeof(fps));
+
+	fps.unit = priv->unit;
+	fps.pars[0] = speed;
+
+	return cgeb_call(priv->board, &fps, CgebI2CSetFrequency);
+}
+
+static int cgeb_i2c_xfer(struct i2c_adapter *adapter,
+		struct i2c_msg *msgs, int num)
+{
+	struct cgeb_function_parameters fps;
+	int i, ret;
+	unsigned long flags = CG_I2C_FLAG_START;
+	struct cgeb_i2c_priv *priv = i2c_get_adapdata(adapter);
+	unsigned long rdlen, wrlen;
+	unsigned char *rdbuf, *wrbuf, *raw_wrbuf;
+	unsigned short lmax = 0;
+
+	/*
+	 * With cgeb the I2C address is part of the write data
+	 * buffer, so allocate a buffer with the length of the
+	 * longest write buffer + 1
+	 */
+	for (i = 0; i < num; i++)
+		if (!(msgs[i].flags & I2C_M_RD))
+			lmax = max(lmax, msgs[i].len);
+
+	raw_wrbuf = kmalloc(lmax + 1, GFP_KERNEL);
+	if (!raw_wrbuf)
+		return -ENOMEM;
+
+	for (i = 0; i < num; i++) {
+
+		if (msgs[i].flags & I2C_M_RD) {
+			rdbuf = msgs[i].buf;
+			rdlen = msgs[i].len;
+			wrbuf = NULL;
+			wrlen = 0;
+		} else {
+			rdbuf = NULL;
+			rdlen = 0;
+			wrbuf = msgs[i].buf;
+			wrlen = msgs[i].len;
+		}
+
+		raw_wrbuf[0] = msgs[i].addr << 1;
+		if (wrlen)
+			memcpy(&raw_wrbuf[1], wrbuf, wrlen);
+
+		if (msgs[i].flags & I2C_M_RD)
+			raw_wrbuf[0] |= 1;
+
+		if (i == num - 1)
+			flags |= CG_I2C_FLAG_STOP;
+
+		dev_dbg(&adapter->dev,
+				"%s: rd: %p/%ld wr: %p/%ld flags: 0x%08lx %s\n",
+				__func__, rdbuf, rdlen, raw_wrbuf, wrlen + 1,
+				flags,
+				msgs[i].flags & I2C_M_RD ? "READ" : "WRITE");
+
+		memset(&fps, 0, sizeof(fps));
+
+		fps.unit = priv->unit;
+		fps.pars[0] = wrlen + 1;
+		fps.pars[1] = rdlen;
+		fps.pars[2] = flags;
+		fps.iptr = raw_wrbuf;
+		fps.optr = rdbuf;
+
+		ret = cgeb_call(priv->board, &fps, CgebI2CTransfer);
+		if (ret) {
+			ret = -EREMOTEIO;
+			goto out;
+		}
+	}
+
+	ret = num;
+
+out:
+	kfree(raw_wrbuf);
+
+	return ret;
+
+}
+
+static struct i2c_algorithm cgeb_i2c_algo = {
+	.master_xfer	= cgeb_i2c_xfer,
+	.functionality	= cgeb_i2c_func,
+};
+
+static int __devinit cgeb_i2c_probe(struct platform_device *pdev)
+{
+	struct cgeb_i2c_priv *priv;
+	struct cgeb_pdata *pdata = pdev->dev.platform_data;
+	int ret;
+
+	priv = devm_kzalloc(&pdev->dev, sizeof(*priv), GFP_KERNEL);
+	if (!priv)
+		return -ENOMEM;
+
+	strcpy(priv->adapter.name, pdev->name);
+	priv->adapter.owner		= THIS_MODULE;
+	priv->adapter.algo		= &cgeb_i2c_algo;
+	priv->adapter.dev.parent	= &pdev->dev;
+	priv->unit = pdata->unit;
+	priv->board = pdata->board;
+	i2c_set_adapdata(&priv->adapter, priv);
+
+	platform_set_drvdata(pdev, priv);
+
+	ret = cgeb_i2c_set_speed(priv, 400000);
+	if (ret)
+		/*
+		 * not a critical error, we can continue with the default speed.
+		 */
+		dev_warn(&pdev->dev, "Could not set speed to 400KHz\n");
+
+	ret = i2c_add_adapter(&priv->adapter);
+	if (ret < 0) {
+		dev_err(&pdev->dev, "registration failed\n");
+		return ret;
+	}
+
+	dev_info(&pdev->dev, "registered\n");
+
+	return 0;
+};
+
+static int __devexit cgeb_i2c_remove(struct platform_device *pdev)
+{
+	struct cgeb_i2c_priv *priv = platform_get_drvdata(pdev);
+
+	i2c_del_adapter(&priv->adapter);
+
+	platform_set_drvdata(pdev, NULL);
+
+	return 0;
+}
+
+static struct platform_driver cgeb_i2c_driver = {
+	.probe		= cgeb_i2c_probe,
+	.remove		= __exit_p(cgeb_i2c_remove),
+	.driver	= {
+		.name	= "cgeb-i2c",
+		.owner	= THIS_MODULE,
+	},
+};
+
+static int __init cgeb_i2c_driver_init(void)
+{
+	return platform_driver_register(&cgeb_i2c_driver);
+}
+
+static void __exit cgeb_i2c_driver_exit(void)
+{
+	platform_driver_unregister(&cgeb_i2c_driver);
+}
+
+module_init(cgeb_i2c_driver_init);
+module_exit(cgeb_i2c_driver_exit);
+
+MODULE_AUTHOR("Sascha Hauer <s.hauer@pengutronix.de>");
+MODULE_DESCRIPTION("cgeb i2c driver");
+MODULE_LICENSE("GPL");
-- 
1.7.2.5

