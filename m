Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753570Ab0CZUop (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Mar 2010 16:44:45 -0400
Received: from fischerfamily.org ([71.216.156.246]:23877 "EHLO gw"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753462Ab0CZUon (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Mar 2010 16:44:43 -0400
From: Todd Fischer <todd.fischer@ridgerun.com>
To: linux-kernel@vger.kernel.org,
       davinci-linux-open-source@linux.davincidsp.com, sameo@linux.intel.com,
       lrg@slimlogic.co.uk, broonie@opensource.wolfsonmicro.com,
       todd.fischer@ridgerun.com
Subject: [PATCH 3/5] Add MFD driver for TPS6507x family of multi-function chips
Date: Fri, 26 Mar 2010 14:11:30 -0600
Message-Id: <1269634292-29686-4-git-send-email-todd.fischer@ridgerun.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1269634292-29686-3-git-send-email-todd.fischer@ridgerun.com>
References: <1269634292-29686-1-git-send-email-todd.fischer@ridgerun.com>
 <1269634292-29686-2-git-send-email-todd.fischer@ridgerun.com>
 <1269634292-29686-3-git-send-email-todd.fischer@ridgerun.com>
Organization: RidgeRun
X-SA-Exim-Connect-IP: 10.0.0.3
X-SA-Exim-Mail-From: todd.fischer@ridgerun.com
X-SA-Exim-Scanned: No (on gw); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

MFD driver for TPS6507x family of multi-function chips.

Signed-off-by: Todd Fischer <todd.fischer@ridgerun.com>
---
 drivers/mfd/Kconfig          |   11 +++
 drivers/mfd/Makefile         |    3 +-
 drivers/mfd/tps6507x.c       |  186 ++++++++++++++++++++++++++++++++++++++++++
 include/linux/mfd/tps6507x.h |   20 +++++
 4 files changed, 219 insertions(+), 1 deletions(-)
 create mode 100644 drivers/mfd/tps6507x.c

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index 951fa9b..8853cab 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -111,6 +111,17 @@ config TPS65010
 	  This driver can also be built as a module.  If so, the module
 	  will be called tps65010.
 
+config TPS6507X
+	tristate "TPS6507x Power Management / Touch Screen chips"
+	depends on I2C
+	help
+	  If you say yes here you get support for the TPS6507x series of
+	  Power Management / Touch Screen chips.  These include voltage
+	  regulators, lithium ion/polymer battery charging, touch screen
+	  and other features that are often used in portable devices.
+	  This driver can also be built as a module.  If so, the module
+	  will be called tps6507x.
+
 config MENELAUS
 	bool "Texas Instruments TWL92330/Menelaus PM chip"
 	depends on I2C=y && ARCH_OMAP2
diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
index 22715ad..2bebc95 100644
--- a/drivers/mfd/Makefile
+++ b/drivers/mfd/Makefile
@@ -28,6 +28,7 @@ obj-$(CONFIG_MFD_WM8350_I2C)	+= wm8350-i2c.o
 obj-$(CONFIG_MFD_WM8994)	+= wm8994-core.o
 
 obj-$(CONFIG_TPS65010)		+= tps65010.o
+obj-$(CONFIG_TPS6507X)		+= tps6507x.o
 obj-$(CONFIG_MENELAUS)		+= menelaus.o
 
 obj-$(CONFIG_TWL4030_CORE)	+= twl-core.o twl4030-irq.o twl6030-irq.o
@@ -62,4 +63,4 @@ obj-$(CONFIG_AB3100_OTP)	+= ab3100-otp.o
 obj-$(CONFIG_AB4500_CORE)	+= ab4500-core.o
 obj-$(CONFIG_MFD_TIMBERDALE)    += timberdale.o
 obj-$(CONFIG_PMIC_ADP5520)	+= adp5520.o
-obj-$(CONFIG_LPC_SCH)		+= lpc_sch.o
\ No newline at end of file
+obj-$(CONFIG_LPC_SCH)		+= lpc_sch.o
diff --git a/drivers/mfd/tps6507x.c b/drivers/mfd/tps6507x.c
new file mode 100644
index 0000000..f0c2695
--- /dev/null
+++ b/drivers/mfd/tps6507x.c
@@ -0,0 +1,186 @@
+/*
+ * tps6507x.c  --  TPS6507x chip family multi-function driver
+ *
+ *  Copyright (c) 2010 RidgeRun (todd.fischer@ridgerun.com)
+ *
+ * Author: Todd Fischer
+ *         todd.fischer@ridgerun.com
+ *
+ * Credits:
+ *
+ *    Using code from wm8350-i2c.c, Wolfson Microelectronics PLC.
+ *
+ * For licencing details see kernel-base/COPYING
+ *
+ */
+
+#include <linux/module.h>
+#include <linux/moduleparam.h>
+#include <linux/init.h>
+#include <linux/i2c.h>
+#include <linux/platform_device.h>
+#include <linux/mfd/tps6507x.h>
+
+struct tps_sub_devices {
+	const char *name;
+	struct platform_device *pdev;
+};
+
+static struct tps_sub_devices tps6507x_sub_devices[] = {
+	{ NULL, NULL }
+};
+
+static int tps6507x_i2c_read_device(struct tps6507x_dev *tps6507x, char reg,
+				  int bytes, void *dest)
+{
+	int ret;
+
+	ret = i2c_master_send(tps6507x->i2c_client, &reg, 1);
+	if (ret < 0)
+		return ret;
+	ret = i2c_master_recv(tps6507x->i2c_client, dest, bytes);
+	if (ret < 0)
+		return ret;
+	if (ret != bytes)
+		return -EIO;
+	return 0;
+}
+
+static int tps6507x_i2c_write_device(struct tps6507x_dev *tps6507x, char reg,
+				   int bytes, void *src)
+{
+	/* we add 1 byte for device register */
+	u8 msg[(TPS6507X_MAX_REGISTER << 1) + 1];
+	int ret;
+
+	if (bytes > ((TPS6507X_MAX_REGISTER << 1) + 1))
+		return -EINVAL;
+
+	msg[0] = reg;
+	memcpy(&msg[1], src, bytes);
+	ret = i2c_master_send(tps6507x->i2c_client, msg, bytes + 1);
+	if (ret < 0)
+		return ret;
+	if (ret != bytes + 1)
+		return -EIO;
+	return 0;
+}
+
+/*
+ * Register a client device.  This is non-fatal since there is no need to
+ * fail the entire device init due to a single platform device failing.
+ */
+static void tps6507x_client_dev_register(struct tps6507x_dev *tps6507x,
+					 const char *name,
+					 struct platform_device **pdev)
+{
+	int ret;
+
+	*pdev = platform_device_alloc(name, -1);
+	if (*pdev == NULL) {
+		dev_err(tps6507x->dev, "Failed to allocate %s\n", name);
+		return;
+	}
+
+	(*pdev)->dev.parent = tps6507x->dev;
+	platform_set_drvdata(*pdev, tps6507x);
+	ret = platform_device_add(*pdev);
+	if (ret != 0) {
+		dev_err(tps6507x->dev, "Failed to register %s: %d\n",
+			name, ret);
+		platform_device_put(*pdev);
+		*pdev = NULL;
+	}
+}
+
+int tps6507x_device_init(struct tps6507x_dev *tps6507x, int irq,
+		       struct tps6507x_board *pdata)
+{
+	int ret = 0;
+	struct tps_sub_devices *d = &tps6507x_sub_devices[0];
+
+	while (d->name) {
+		tps6507x_client_dev_register(tps6507x, d->name, &(d->pdev));
+		d++;
+	}
+
+	return ret;
+}
+
+static int tps6507x_i2c_probe(struct i2c_client *i2c,
+			    const struct i2c_device_id *id)
+{
+	struct tps6507x_dev *tps6507x;
+	int ret = 0;
+
+	tps6507x = kzalloc(sizeof(struct tps6507x_dev), GFP_KERNEL);
+	if (tps6507x == NULL) {
+		kfree(i2c);
+		return -ENOMEM;
+	}
+
+	i2c_set_clientdata(i2c, tps6507x);
+	tps6507x->dev = &i2c->dev;
+	tps6507x->i2c_client = i2c;
+	tps6507x->read_dev = tps6507x_i2c_read_device;
+	tps6507x->write_dev = tps6507x_i2c_write_device;
+	mutex_init(&tps6507x->adc_mutex);
+
+	ret = tps6507x_device_init(tps6507x, i2c->irq, i2c->dev.platform_data);
+	if (ret < 0)
+		goto err;
+
+	return ret;
+
+err:
+	kfree(tps6507x);
+	return ret;
+}
+
+static int tps6507x_i2c_remove(struct i2c_client *i2c)
+{
+	struct tps6507x_dev *tps6507x = i2c_get_clientdata(i2c);
+	struct tps_sub_devices *d = &tps6507x_sub_devices[0];
+
+	while (d->name) {
+		platform_device_unregister(d->pdev);
+		d++;
+	}
+
+	kfree(tps6507x);
+
+	return 0;
+}
+
+static const struct i2c_device_id tps6507x_i2c_id[] = {
+       { "tps6507x", 0 },
+       { }
+};
+MODULE_DEVICE_TABLE(i2c, tps6507x_i2c_id);
+
+
+static struct i2c_driver tps6507x_i2c_driver = {
+	.driver = {
+		   .name = "tps6507x",
+		   .owner = THIS_MODULE,
+	},
+	.probe = tps6507x_i2c_probe,
+	.remove = tps6507x_i2c_remove,
+	.id_table = tps6507x_i2c_id,
+};
+
+static int __init tps6507x_i2c_init(void)
+{
+	return i2c_add_driver(&tps6507x_i2c_driver);
+}
+/* init early so consumer devices can complete system boot */
+subsys_initcall(tps6507x_i2c_init);
+
+static void __exit tps6507x_i2c_exit(void)
+{
+	i2c_del_driver(&tps6507x_i2c_driver);
+}
+module_exit(tps6507x_i2c_exit);
+
+MODULE_DESCRIPTION("TPS6507x chip family multi-function driver");
+MODULE_LICENSE("GPL");
diff --git a/include/linux/mfd/tps6507x.h b/include/linux/mfd/tps6507x.h
index fd73af5..46c3331 100644
--- a/include/linux/mfd/tps6507x.h
+++ b/include/linux/mfd/tps6507x.h
@@ -131,6 +131,8 @@
 /* VDCDC MASK */
 #define TPS6507X_DEFDCDCX_DCDC_MASK		0X3F
 
+#define TPS6507X_MAX_REGISTER			0X19
+
 /**
  * struct tps6507x_board - packages regulator and touchscreen init data
  * @tps6507x_regulator_data: regulator initialization values
@@ -142,4 +144,22 @@ struct tps6507x_board {
 	struct regulator_init_data *tps6507x_pmic_init_data;
 };
 
+/**
+ * struct tps6507x_dev - tps6507x sub-driver chip access routines
+ * @read_dev() - I2C register read function
+ * @write_dev() - I2C register write function
+ *
+ * Device data may be used to access the TPS6507x chip
+ */
+
+struct tps6507x_dev {
+	struct device *dev;
+	struct i2c_client *i2c_client;
+	int (*read_dev)(struct tps6507x_dev *tps6507x, char reg, int size,
+			void *dest);
+	int (*write_dev)(struct tps6507x_dev *tps6507x, char reg, int size,
+			 void *src);
+	struct mutex adc_mutex;
+};
+
 #endif /*  __LINUX_MFD_TPS6507X_H */
-- 
1.6.0.4

