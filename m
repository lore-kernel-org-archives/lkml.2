Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752113Ab1KHHGK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 02:06:10 -0500
Received: from eu1sys200aog106.obsmtp.com ([207.126.144.121]:43926 "EHLO
	eu1sys200aog106.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751314Ab1KHHGF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 02:06:05 -0500
From: Viresh Kumar <viresh.kumar@st.com>
To: <rabin.vincent@stericsson.com>, <linus.walleij@stericsson.com>,
        <linux-kernel@vger.kernel.org>, <sameo@linux.intel.com>
Cc: <armando.visconti@st.com>, <shiraz.hashim@st.com>, <vipin.kumar@st.com>,
        <rajeev-dlh.kumar@st.com>, <deepak.sikri@st.com>,
        <vipulkumar.samar@st.com>, <amit.virdi@st.com>, <viresh.kumar@st.com>,
        <pratyush.anand@st.com>, <bhupesh.sharma@st.com>,
        <viresh.linux@gmail.com>, <bhavna.yadav@st.com>,
        <vincenzo.frascino@st.com>, <mirko.gardi@st.com>,
        <srinidhi.kasagar@stericsson.com>
Subject: [PATCH 1/2] mfd/stmpe: separate out controller and interface specific code
Date: Tue, 8 Nov 2011 12:35:50 +0530
Message-ID: <e03ce6fa965b6d5d9589052e43c1ca7c121f81d4.1320735864.git.viresh.kumar@st.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <cover.1320735864.git.viresh.kumar@st.com>
References: <cover.1320735864.git.viresh.kumar@st.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Few STMPE controller can have register interface over SPI or I2C. Current
implementation only supports I2C and all code is present in a single file
stmpe.c. It would be better to separate out I2C interface specific code from
controller specific code. Later SPI specific code can be added in a separate
file.

This patch separates out I2C and controller specific code into separate files,
making stmpe.c independent of I2C.

Signed-off-by: Viresh Kumar <viresh.kumar@st.com>
---
 drivers/mfd/Kconfig       |   11 ++++
 drivers/mfd/Makefile      |    1 +
 drivers/mfd/stmpe-i2c.c   |  116 ++++++++++++++++++++++++++++++++++++++++
 drivers/mfd/stmpe.c       |  128 ++++++++++++++-------------------------------
 drivers/mfd/stmpe.h       |   33 ++++++++++++
 include/linux/mfd/stmpe.h |    7 ++-
 6 files changed, 205 insertions(+), 91 deletions(-)
 create mode 100644 drivers/mfd/stmpe-i2c.c

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index a67adcb..2f8561a 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -293,6 +293,17 @@ config MFD_STMPE
 		Keypad: stmpe-keypad
 		Touchscreen: stmpe-ts
 
+menu "STMPE Interface Drivers"
+depends on MFD_STMPE
+
+config STMPE_I2C
+	bool "STMPE I2C Inteface"
+	depends on I2C
+	default y
+	help
+	  This is used to enable I2C interface of STMPE
+endmenu
+
 config MFD_TC3589X
 	bool "Support Toshiba TC35892 and variants"
 	depends on I2C=y && GENERIC_HARDIRQS
diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
index c580203..24ee9bb 100644
--- a/drivers/mfd/Makefile
+++ b/drivers/mfd/Makefile
@@ -16,6 +16,7 @@ obj-$(CONFIG_MFD_DM355EVM_MSP)	+= dm355evm_msp.o
 obj-$(CONFIG_MFD_TI_SSP)	+= ti-ssp.o
 
 obj-$(CONFIG_MFD_STMPE)		+= stmpe.o
+obj-$(CONFIG_STMPE_I2C)		+= stmpe-i2c.o
 obj-$(CONFIG_MFD_TC3589X)	+= tc3589x.o
 obj-$(CONFIG_MFD_T7L66XB)	+= t7l66xb.o tmio_core.o
 obj-$(CONFIG_MFD_TC6387XB)	+= tc6387xb.o tmio_core.o
diff --git a/drivers/mfd/stmpe-i2c.c b/drivers/mfd/stmpe-i2c.c
new file mode 100644
index 0000000..72fa08b
--- /dev/null
+++ b/drivers/mfd/stmpe-i2c.c
@@ -0,0 +1,116 @@
+/*
+ * ST Microelectronics MFD: stmpe's i2c client specific driver
+ *
+ * Copyright (C) ST-Ericsson SA 2010
+ * Copyright (C) ST Microelectronics SA 2011
+ *
+ * License Terms: GNU General Public License, version 2
+ * Author: Rabin Vincent <rabin.vincent@stericsson.com> for ST-Ericsson
+ * Author: Viresh Kumar <viresh.kumar@st.com> for ST Microelectronics
+ */
+
+#include <linux/i2c.h>
+#include <linux/interrupt.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/types.h>
+#include "stmpe.h"
+
+static int i2c_reg_read(struct stmpe *stmpe, u8 reg)
+{
+	struct i2c_client *i2c = stmpe->client;
+
+	return i2c_smbus_read_byte_data(i2c, reg);
+}
+
+static int i2c_reg_write(struct stmpe *stmpe, u8 reg, u8 val)
+{
+	struct i2c_client *i2c = stmpe->client;
+
+	return i2c_smbus_write_byte_data(i2c, reg, val);
+}
+
+static int i2c_block_read(struct stmpe *stmpe, u8 reg, u8 length, u8 *values)
+{
+	struct i2c_client *i2c = stmpe->client;
+
+	return i2c_smbus_read_i2c_block_data(i2c, reg, length, values);
+}
+
+static int i2c_block_write(struct stmpe *stmpe, u8 reg, u8 length,
+		const u8 *values)
+{
+	struct i2c_client *i2c = stmpe->client;
+
+	return i2c_smbus_write_i2c_block_data(i2c, reg, length, values);
+}
+
+static void i2c_init(struct stmpe *stmpe)
+{
+	struct i2c_device_id *id = stmpe->ci->data;
+
+	stmpe->partnum = id->driver_data;
+	dev_set_drvdata(stmpe->dev, stmpe);
+}
+
+static struct stmpe_client_info i2c_ci = {
+	.read_byte = i2c_reg_read,
+	.write_byte = i2c_reg_write,
+	.read_block = i2c_block_read,
+	.write_block = i2c_block_write,
+	.init = i2c_init,
+};
+
+static int __devinit
+stmpe_i2c_probe(struct i2c_client *i2c, const struct i2c_device_id *id)
+{
+	i2c_ci.data = (void *)id;
+	i2c_ci.irq = i2c->irq;
+	i2c_ci.client = i2c;
+	i2c_ci.dev = &i2c->dev;
+
+	return stmpe_probe(&i2c_ci);
+}
+
+static int __devexit stmpe_i2c_remove(struct i2c_client *i2c)
+{
+	struct stmpe *stmpe = dev_get_drvdata(&i2c->dev);
+
+	return stmpe_remove(stmpe);
+}
+
+static const struct i2c_device_id stmpe_i2c_id[] = {
+	{ "stmpe811", STMPE811 },
+	{ "stmpe1601", STMPE1601 },
+	{ "stmpe2401", STMPE2401 },
+	{ "stmpe2403", STMPE2403 },
+	{ }
+};
+MODULE_DEVICE_TABLE(i2c, stmpe_id);
+
+static struct i2c_driver stmpe_i2c_driver = {
+	.driver.name	= "stmpe-i2c",
+	.driver.owner	= THIS_MODULE,
+#ifdef CONFIG_PM
+	.driver.pm	= &stmpe_dev_pm_ops,
+#endif
+	.probe		= stmpe_i2c_probe,
+	.remove		= __devexit_p(stmpe_i2c_remove),
+	.id_table	= stmpe_i2c_id,
+};
+
+static int __init stmpe_init(void)
+{
+	return i2c_add_driver(&stmpe_i2c_driver);
+}
+subsys_initcall(stmpe_init);
+
+static void __exit stmpe_exit(void)
+{
+	i2c_del_driver(&stmpe_i2c_driver);
+}
+module_exit(stmpe_exit);
+
+MODULE_LICENSE("GPL v2");
+MODULE_DESCRIPTION("STMPE MFD core driver");
+MODULE_AUTHOR("Rabin Vincent <rabin.vincent@stericsson.com>");
diff --git a/drivers/mfd/stmpe.c b/drivers/mfd/stmpe.c
index 39efa62..3ff2edb 100644
--- a/drivers/mfd/stmpe.c
+++ b/drivers/mfd/stmpe.c
@@ -1,4 +1,6 @@
 /*
+ * ST Microelectronics MFD: stmpe's driver
+ *
  * Copyright (C) ST-Ericsson SA 2010
  *
  * License Terms: GNU General Public License, version 2
@@ -7,13 +9,11 @@
 
 #include <linux/gpio.h>
 #include <linux/kernel.h>
-#include <linux/module.h>
 #include <linux/interrupt.h>
 #include <linux/irq.h>
+#include <linux/pm.h>
 #include <linux/slab.h>
-#include <linux/i2c.h>
 #include <linux/mfd/core.h>
-#include <linux/mfd/stmpe.h>
 #include "stmpe.h"
 
 static int __stmpe_enable(struct stmpe *stmpe, unsigned int blocks)
@@ -30,10 +30,9 @@ static int __stmpe_reg_read(struct stmpe *stmpe, u8 reg)
 {
 	int ret;
 
-	ret = i2c_smbus_read_byte_data(stmpe->i2c, reg);
+	ret = stmpe->ci->read_byte(stmpe, reg);
 	if (ret < 0)
-		dev_err(stmpe->dev, "failed to read reg %#x: %d\n",
-			reg, ret);
+		dev_err(stmpe->dev, "failed to read reg %#x: %d\n", reg, ret);
 
 	dev_vdbg(stmpe->dev, "rd: reg %#x => data %#x\n", reg, ret);
 
@@ -46,10 +45,9 @@ static int __stmpe_reg_write(struct stmpe *stmpe, u8 reg, u8 val)
 
 	dev_vdbg(stmpe->dev, "wr: reg %#x <= %#x\n", reg, val);
 
-	ret = i2c_smbus_write_byte_data(stmpe->i2c, reg, val);
+	ret = stmpe->ci->write_byte(stmpe, reg, val);
 	if (ret < 0)
-		dev_err(stmpe->dev, "failed to write reg %#x: %d\n",
-			reg, ret);
+		dev_err(stmpe->dev, "failed to write reg %#x: %d\n", reg, ret);
 
 	return ret;
 }
@@ -73,10 +71,9 @@ static int __stmpe_block_read(struct stmpe *stmpe, u8 reg, u8 length,
 {
 	int ret;
 
-	ret = i2c_smbus_read_i2c_block_data(stmpe->i2c, reg, length, values);
+	ret = stmpe->ci->read_block(stmpe, reg, length, values);
 	if (ret < 0)
-		dev_err(stmpe->dev, "failed to read regs %#x: %d\n",
-			reg, ret);
+		dev_err(stmpe->dev, "failed to read regs %#x: %d\n", reg, ret);
 
 	dev_vdbg(stmpe->dev, "rd: reg %#x (%d) => ret %#x\n", reg, length, ret);
 	stmpe_dump_bytes("stmpe rd: ", values, length);
@@ -92,11 +89,9 @@ static int __stmpe_block_write(struct stmpe *stmpe, u8 reg, u8 length,
 	dev_vdbg(stmpe->dev, "wr: regs %#x (%d)\n", reg, length);
 	stmpe_dump_bytes("stmpe wr: ", values, length);
 
-	ret = i2c_smbus_write_i2c_block_data(stmpe->i2c, reg, length,
-					     values);
+	ret = stmpe->ci->write_block(stmpe, reg, length, values);
 	if (ret < 0)
-		dev_err(stmpe->dev, "failed to write regs %#x: %d\n",
-			reg, ret);
+		dev_err(stmpe->dev, "failed to write regs %#x: %d\n", reg, ret);
 
 	return ret;
 }
@@ -874,34 +869,10 @@ static int __devinit stmpe_devices_init(struct stmpe *stmpe)
 	return ret;
 }
 
-#ifdef CONFIG_PM
-static int stmpe_suspend(struct device *dev)
-{
-	struct i2c_client *i2c = to_i2c_client(dev);
-	struct stmpe *stmpe = i2c_get_clientdata(i2c);
-
-	if (device_may_wakeup(&i2c->dev))
-		enable_irq_wake(stmpe->irq);
-
-	return 0;
-}
-
-static int stmpe_resume(struct device *dev)
+/* Called from client specific probe routines */
+int stmpe_probe(struct stmpe_client_info *ci)
 {
-	struct i2c_client *i2c = to_i2c_client(dev);
-	struct stmpe *stmpe = i2c_get_clientdata(i2c);
-
-	if (device_may_wakeup(&i2c->dev))
-		disable_irq_wake(stmpe->irq);
-
-	return 0;
-}
-#endif
-
-static int __devinit stmpe_probe(struct i2c_client *i2c,
-				 const struct i2c_device_id *id)
-{
-	struct stmpe_platform_data *pdata = i2c->dev.platform_data;
+	struct stmpe_platform_data *pdata = dev_get_platdata(ci->dev);
 	struct stmpe *stmpe;
 	int ret;
 
@@ -915,18 +886,16 @@ static int __devinit stmpe_probe(struct i2c_client *i2c,
 	mutex_init(&stmpe->irq_lock);
 	mutex_init(&stmpe->lock);
 
-	stmpe->dev = &i2c->dev;
-	stmpe->i2c = i2c;
-
+	stmpe->dev = ci->dev;
+	stmpe->client = ci->client;
 	stmpe->pdata = pdata;
 	stmpe->irq_base = pdata->irq_base;
-
-	stmpe->partnum = id->driver_data;
+	stmpe->ci = ci;
 	stmpe->variant = stmpe_variant_info[stmpe->partnum];
 	stmpe->regs = stmpe->variant->regs;
 	stmpe->num_gpios = stmpe->variant->num_gpios;
 
-	i2c_set_clientdata(i2c, stmpe);
+	ci->init(stmpe);
 
 	if (pdata->irq_over_gpio) {
 		ret = gpio_request_one(pdata->irq_gpio, GPIOF_DIR_IN, "stmpe");
@@ -938,7 +907,7 @@ static int __devinit stmpe_probe(struct i2c_client *i2c,
 
 		stmpe->irq = gpio_to_irq(pdata->irq_gpio);
 	} else {
-		stmpe->irq = i2c->irq;
+		stmpe->irq = ci->irq;
 	}
 
 	ret = stmpe_chip_init(stmpe);
@@ -950,8 +919,7 @@ static int __devinit stmpe_probe(struct i2c_client *i2c,
 		goto free_gpio;
 
 	ret = request_threaded_irq(stmpe->irq, NULL, stmpe_irq,
-				   pdata->irq_trigger | IRQF_ONESHOT,
-				   "stmpe", stmpe);
+			pdata->irq_trigger | IRQF_ONESHOT, "stmpe", stmpe);
 	if (ret) {
 		dev_err(stmpe->dev, "failed to request IRQ: %d\n", ret);
 		goto out_removeirq;
@@ -978,10 +946,8 @@ out_free:
 	return ret;
 }
 
-static int __devexit stmpe_remove(struct i2c_client *client)
+int stmpe_remove(struct stmpe *stmpe)
 {
-	struct stmpe *stmpe = i2c_get_clientdata(client);
-
 	mfd_remove_devices(stmpe->dev);
 
 	free_irq(stmpe->irq, stmpe);
@@ -995,45 +961,29 @@ static int __devexit stmpe_remove(struct i2c_client *client)
 	return 0;
 }
 
-static const struct i2c_device_id stmpe_id[] = {
-	{ "stmpe811", STMPE811 },
-	{ "stmpe1601", STMPE1601 },
-	{ "stmpe2401", STMPE2401 },
-	{ "stmpe2403", STMPE2403 },
-	{ }
-};
-MODULE_DEVICE_TABLE(i2c, stmpe_id);
-
 #ifdef CONFIG_PM
-static const struct dev_pm_ops stmpe_dev_pm_ops = {
-	.suspend	= stmpe_suspend,
-	.resume		= stmpe_resume,
-};
-#endif
+static int stmpe_suspend(struct device *dev)
+{
+	struct stmpe *stmpe = dev_get_drvdata(dev);
 
-static struct i2c_driver stmpe_driver = {
-	.driver.name	= "stmpe",
-	.driver.owner	= THIS_MODULE,
-#ifdef CONFIG_PM
-	.driver.pm	= &stmpe_dev_pm_ops,
-#endif
-	.probe		= stmpe_probe,
-	.remove		= __devexit_p(stmpe_remove),
-	.id_table	= stmpe_id,
-};
+	if (device_may_wakeup(dev))
+		enable_irq_wake(stmpe->irq);
 
-static int __init stmpe_init(void)
-{
-	return i2c_add_driver(&stmpe_driver);
+	return 0;
 }
-subsys_initcall(stmpe_init);
 
-static void __exit stmpe_exit(void)
+static int stmpe_resume(struct device *dev)
 {
-	i2c_del_driver(&stmpe_driver);
+	struct stmpe *stmpe = dev_get_drvdata(dev);
+
+	if (device_may_wakeup(dev))
+		disable_irq_wake(stmpe->irq);
+
+	return 0;
 }
-module_exit(stmpe_exit);
 
-MODULE_LICENSE("GPL v2");
-MODULE_DESCRIPTION("STMPE MFD core driver");
-MODULE_AUTHOR("Rabin Vincent <rabin.vincent@stericsson.com>");
+const struct dev_pm_ops stmpe_dev_pm_ops = {
+	.suspend	= stmpe_suspend,
+	.resume		= stmpe_resume,
+};
+#endif
diff --git a/drivers/mfd/stmpe.h b/drivers/mfd/stmpe.h
index e4ee3895..c716044 100644
--- a/drivers/mfd/stmpe.h
+++ b/drivers/mfd/stmpe.h
@@ -8,6 +8,14 @@
 #ifndef __STMPE_H
 #define __STMPE_H
 
+#include <linux/device.h>
+#include <linux/mfd/core.h>
+#include <linux/mfd/stmpe.h>
+#include <linux/printk.h>
+#include <linux/types.h>
+
+extern const struct dev_pm_ops stmpe_dev_pm_ops;
+
 #ifdef STMPE_DUMP_BYTES
 static inline void stmpe_dump_bytes(const char *str, const void *buf,
 				    size_t len)
@@ -67,6 +75,31 @@ struct stmpe_variant_info {
 	int (*enable_autosleep)(struct stmpe *stmpe, int autosleep_timeout);
 };
 
+/**
+ * struct stmpe_client_info - i2c or spi specific routines/info
+ * @data: client specific data
+ * @read_byte: read single byte
+ * @write_byte: write single byte
+ * @read_block: read block or multiple bytes
+ * @write_block: write block or multiple bytes
+ * @init: client init routine, called during probe
+ */
+struct stmpe_client_info {
+	void *data;
+	int irq;
+	void *client;
+	struct device *dev;
+	int (*read_byte)(struct stmpe *stmpe, u8 reg);
+	int (*write_byte)(struct stmpe *stmpe, u8 reg, u8 val);
+	int (*read_block)(struct stmpe *stmpe, u8 reg, u8 len, u8 *values);
+	int (*write_block)(struct stmpe *stmpe, u8 reg, u8 len,
+			const u8 *values);
+	void (*init)(struct stmpe *stmpe);
+};
+
+int stmpe_probe(struct stmpe_client_info *ci);
+int stmpe_remove(struct stmpe *stmpe);
+
 #define STMPE_ICR_LSB_HIGH	(1 << 2)
 #define STMPE_ICR_LSB_EDGE	(1 << 1)
 #define STMPE_ICR_LSB_GIM	(1 << 0)
diff --git a/include/linux/mfd/stmpe.h b/include/linux/mfd/stmpe.h
index 270d661..babc6b2 100644
--- a/include/linux/mfd/stmpe.h
+++ b/include/linux/mfd/stmpe.h
@@ -50,13 +50,15 @@ enum {
 
 
 struct stmpe_variant_info;
+struct stmpe_client_info;
 
 /**
  * struct stmpe - STMPE MFD structure
  * @lock: lock protecting I/O operations
  * @irq_lock: IRQ bus lock
  * @dev: device, mostly for dev_dbg()
- * @i2c: i2c client
+ * @client: client - i2c or spi
+ * @ci: client specific information
  * @partnum: part number
  * @variant: the detected STMPE model number
  * @regs: list of addresses of registers which are at different addresses on
@@ -72,7 +74,8 @@ struct stmpe {
 	struct mutex lock;
 	struct mutex irq_lock;
 	struct device *dev;
-	struct i2c_client *i2c;
+	void *client;
+	struct stmpe_client_info *ci;
 	enum stmpe_partnum partnum;
 	struct stmpe_variant_info *variant;
 	const u8 *regs;
-- 
1.7.2.2

