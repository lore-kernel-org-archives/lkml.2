Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752760Ab0LWIxn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Dec 2010 03:53:43 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:31603 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752694Ab0LWIxl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Dec 2010 03:53:41 -0500
Date: Thu, 23 Dec 2010 17:53:36 +0900
From: MyungJoo Ham <myungjoo.ham@samsung.com>
Subject: [PATCH v3 1/4] MFD MAX8998/LP3974: Support Hibernation
In-reply-to: <1293094419-24221-1-git-send-email-myungjoo.ham@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: Samuel Ortiz <sameo@linux.intel.com>, Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Lukasz Majewski <l.majewski@samsung.com>, myungjoo.ham@gmail.com
Message-id: <1293094419-24221-2-git-send-email-myungjoo.ham@samsung.com>
X-Mailer: git-send-email 1.7.1
Content-transfer-encoding: 7BIT
References: <1293094419-24221-1-git-send-email-myungjoo.ham@samsung.com>
X-OriginalArrivalTime: 23 Dec 2010 08:53:39.0514 (UTC)
 FILETIME=[E49B19A0:01CBA27E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes the driver to save and restore register values
for hibernation.

Signed-off-by: MyungJoo Ham <myungjoo.ham@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/mfd/max8998-irq.c           |    7 ++
 drivers/mfd/max8998.c               |  108 +++++++++++++++++++++++++++++++++++
 include/linux/mfd/max8998-private.h |    2 +
 include/linux/mfd/max8998.h         |    1 +
 4 files changed, 118 insertions(+), 0 deletions(-)

diff --git a/drivers/mfd/max8998-irq.c b/drivers/mfd/max8998-irq.c
index 45bfe77..93c621d 100644
--- a/drivers/mfd/max8998-irq.c
+++ b/drivers/mfd/max8998-irq.c
@@ -181,6 +181,13 @@ static irqreturn_t max8998_irq_thread(int irq, void *data)
 	return IRQ_HANDLED;
 }
 
+int max8998_irq_resume(struct max8998_dev *max8998)
+{
+	if (max8998->irq && max8998->irq_base)
+		max8998_irq_thread(max8998->irq_base, max8998);
+	return 0;
+}
+
 int max8998_irq_init(struct max8998_dev *max8998)
 {
 	int i;
diff --git a/drivers/mfd/max8998.c b/drivers/mfd/max8998.c
index bb9977b..5ce00ad 100644
--- a/drivers/mfd/max8998.c
+++ b/drivers/mfd/max8998.c
@@ -25,6 +25,8 @@
 #include <linux/init.h>
 #include <linux/slab.h>
 #include <linux/i2c.h>
+#include <linux/interrupt.h>
+#include <linux/pm_runtime.h>
 #include <linux/mutex.h>
 #include <linux/mfd/core.h>
 #include <linux/mfd/max8998.h>
@@ -135,6 +137,7 @@ static int max8998_i2c_probe(struct i2c_client *i2c,
 	if (pdata) {
 		max8998->ono = pdata->ono;
 		max8998->irq_base = pdata->irq_base;
+		max8998->wakeup = pdata->wakeup;
 	}
 	mutex_init(&max8998->iolock);
 
@@ -146,6 +149,8 @@ static int max8998_i2c_probe(struct i2c_client *i2c,
 	ret = mfd_add_devices(max8998->dev, -1,
 			      max8998_devs, ARRAY_SIZE(max8998_devs),
 			      NULL, 0);
+	pm_runtime_set_active(max8998->dev);
+
 	if (ret < 0)
 		goto err;
 
@@ -178,10 +183,113 @@ static const struct i2c_device_id max8998_i2c_id[] = {
 };
 MODULE_DEVICE_TABLE(i2c, max8998_i2c_id);
 
+static int max8998_suspend(struct device *dev)
+{
+	struct i2c_client *i2c = container_of(dev, struct i2c_client, dev);
+	struct max8998_dev *max8998 = i2c_get_clientdata(i2c);
+
+	if (max8998->wakeup)
+		set_irq_wake(max8998->irq, 1);
+	return 0;
+}
+
+static int max8998_resume(struct device *dev)
+{
+	struct i2c_client *i2c = container_of(dev, struct i2c_client, dev);
+	struct max8998_dev *max8998 = i2c_get_clientdata(i2c);
+
+	if (max8998->wakeup)
+		set_irq_wake(max8998->irq, 0);
+	/*
+	 * In LP3974, if IRQ registers are not "read & clear"
+	 * when it's set during sleep, the interrupt becomes
+	 * disabled.
+	 */
+	return max8998_irq_resume(i2c_get_clientdata(i2c));
+}
+
+struct max8998_reg_dump {
+	u8	addr;
+	u8	val;
+};
+#define SAVE_ITEM(x)	{ .addr = (x), .val = 0x0, }
+struct max8998_reg_dump max8998_dump[] = {
+	SAVE_ITEM(MAX8998_REG_IRQM1),
+	SAVE_ITEM(MAX8998_REG_IRQM2),
+	SAVE_ITEM(MAX8998_REG_IRQM3),
+	SAVE_ITEM(MAX8998_REG_IRQM4),
+	SAVE_ITEM(MAX8998_REG_STATUSM1),
+	SAVE_ITEM(MAX8998_REG_STATUSM2),
+	SAVE_ITEM(MAX8998_REG_CHGR1),
+	SAVE_ITEM(MAX8998_REG_CHGR2),
+	SAVE_ITEM(MAX8998_REG_LDO_ACTIVE_DISCHARGE1),
+	SAVE_ITEM(MAX8998_REG_LDO_ACTIVE_DISCHARGE1),
+	SAVE_ITEM(MAX8998_REG_BUCK_ACTIVE_DISCHARGE3),
+	SAVE_ITEM(MAX8998_REG_ONOFF1),
+	SAVE_ITEM(MAX8998_REG_ONOFF2),
+	SAVE_ITEM(MAX8998_REG_ONOFF3),
+	SAVE_ITEM(MAX8998_REG_ONOFF4),
+	SAVE_ITEM(MAX8998_REG_BUCK1_VOLTAGE1),
+	SAVE_ITEM(MAX8998_REG_BUCK1_VOLTAGE2),
+	SAVE_ITEM(MAX8998_REG_BUCK1_VOLTAGE3),
+	SAVE_ITEM(MAX8998_REG_BUCK1_VOLTAGE4),
+	SAVE_ITEM(MAX8998_REG_BUCK2_VOLTAGE1),
+	SAVE_ITEM(MAX8998_REG_BUCK2_VOLTAGE2),
+	SAVE_ITEM(MAX8998_REG_LDO2_LDO3),
+	SAVE_ITEM(MAX8998_REG_LDO4),
+	SAVE_ITEM(MAX8998_REG_LDO5),
+	SAVE_ITEM(MAX8998_REG_LDO6),
+	SAVE_ITEM(MAX8998_REG_LDO7),
+	SAVE_ITEM(MAX8998_REG_LDO8_LDO9),
+	SAVE_ITEM(MAX8998_REG_LDO10_LDO11),
+	SAVE_ITEM(MAX8998_REG_LDO12),
+	SAVE_ITEM(MAX8998_REG_LDO13),
+	SAVE_ITEM(MAX8998_REG_LDO14),
+	SAVE_ITEM(MAX8998_REG_LDO15),
+	SAVE_ITEM(MAX8998_REG_LDO16),
+	SAVE_ITEM(MAX8998_REG_LDO17),
+	SAVE_ITEM(MAX8998_REG_BKCHR),
+	SAVE_ITEM(MAX8998_REG_LBCNFG1),
+	SAVE_ITEM(MAX8998_REG_LBCNFG2),
+};
+/* Save registers before hibernation */
+static int max8998_freeze(struct device *dev)
+{
+	struct i2c_client *i2c = container_of(dev, struct i2c_client, dev);
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(max8998_dump); i++)
+		max8998_read_reg(i2c, max8998_dump[i].addr,
+				&max8998_dump[i].val);
+
+	return 0;
+}
+
+/* Restore registers after hibernation */
+static int max8998_restore(struct device *dev)
+{
+	struct i2c_client *i2c = container_of(dev, struct i2c_client, dev);
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(max8998_dump); i++)
+		max8998_write_reg(i2c, max8998_dump[i].addr,
+				max8998_dump[i].val);
+
+	return 0;
+}
+
+const struct dev_pm_ops max8998_pm = {
+	.suspend = max8998_suspend,
+	.resume = max8998_resume,
+	.freeze = max8998_freeze,
+	.restore = max8998_restore,
+};
+
 static struct i2c_driver max8998_i2c_driver = {
 	.driver = {
 		   .name = "max8998",
 		   .owner = THIS_MODULE,
+		   .pm = &max8998_pm,
 	},
 	.probe = max8998_i2c_probe,
 	.remove = max8998_i2c_remove,
diff --git a/include/linux/mfd/max8998-private.h b/include/linux/mfd/max8998-private.h
index 7363dea..effa5d3 100644
--- a/include/linux/mfd/max8998-private.h
+++ b/include/linux/mfd/max8998-private.h
@@ -159,10 +159,12 @@ struct max8998_dev {
 	u8 irq_masks_cur[MAX8998_NUM_IRQ_REGS];
 	u8 irq_masks_cache[MAX8998_NUM_IRQ_REGS];
 	int type;
+	bool wakeup;
 };
 
 int max8998_irq_init(struct max8998_dev *max8998);
 void max8998_irq_exit(struct max8998_dev *max8998);
+int max8998_irq_resume(struct max8998_dev *max8998);
 
 extern int max8998_read_reg(struct i2c_client *i2c, u8 reg, u8 *dest);
 extern int max8998_bulk_read(struct i2c_client *i2c, u8 reg, int count,
diff --git a/include/linux/mfd/max8998.h b/include/linux/mfd/max8998.h
index f8c9f88..686a744 100644
--- a/include/linux/mfd/max8998.h
+++ b/include/linux/mfd/max8998.h
@@ -88,6 +88,7 @@ struct max8998_platform_data {
 	int				buck1_set1;
 	int				buck1_set2;
 	int				buck2_set3;
+	bool				wakeup;
 };
 
 #endif /*  __LINUX_MFD_MAX8998_H */
-- 
1.7.1

