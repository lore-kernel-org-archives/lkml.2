Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932282Ab2AMPbK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jan 2012 10:31:10 -0500
Received: from eu1sys200aog109.obsmtp.com ([207.126.144.127]:44127 "EHLO
	eu1sys200aog109.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752938Ab2AMPbG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jan 2012 10:31:06 -0500
From: Linus Walleij <linus.walleij@stericsson.com>
To: Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        <linux-kernel@vger.kernel.org>
Cc: Bengt Jonsson <bengt.g.jonsson@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH] regulators/db8500: split off shared dbx500 code
Date: Fri, 13 Jan 2012 16:30:31 +0100
Message-ID: <1326468631-12041-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.8
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bengt Jonsson <bengt.g.jonsson@stericsson.com>

As we progress with DB5500 and future voltage domain regulators
based on very similar hardware as found in the DB8500 PRCMU,
it makes sense to split off the generic parts and introduce
some generic debug code for the DBx500 regulators. This patch
accoplish a basic abstraction of the DBx500 voltage domain
regulators.

Signed-off-by: Bengt Jonsson <bengt.g.jonsson@stericsson.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/regulator/Kconfig        |    4 +
 drivers/regulator/Makefile       |    1 +
 drivers/regulator/db8500-prcmu.c |  118 +++++--------------
 drivers/regulator/dbx500-prcmu.c |  241 ++++++++++++++++++++++++++++++++++++++
 drivers/regulator/dbx500-prcmu.h |   63 ++++++++++
 5 files changed, 341 insertions(+), 86 deletions(-)
 create mode 100644 drivers/regulator/dbx500-prcmu.c
 create mode 100644 drivers/regulator/dbx500-prcmu.h

diff --git a/drivers/regulator/Kconfig b/drivers/regulator/Kconfig
index 9713b1b..e000f22 100644
--- a/drivers/regulator/Kconfig
+++ b/drivers/regulator/Kconfig
@@ -291,9 +291,13 @@ config REGULATOR_AB8500
 	  This driver supports the regulators found on the ST-Ericsson mixed
 	  signal AB8500 PMIC
 
+config REGULATOR_DBX500_PRCMU
+	bool
+
 config REGULATOR_DB8500_PRCMU
 	bool "ST-Ericsson DB8500 Voltage Domain Regulators"
 	depends on MFD_DB8500_PRCMU
+	select REGULATOR_DBX500_PRCMU
 	help
 	  This driver supports the voltage domain regulators controlled by the
 	  DB8500 PRCMU
diff --git a/drivers/regulator/Makefile b/drivers/regulator/Makefile
index 93a6318..fc5095a 100644
--- a/drivers/regulator/Makefile
+++ b/drivers/regulator/Makefile
@@ -43,6 +43,7 @@ obj-$(CONFIG_REGULATOR_TPS65912) += tps65912-regulator.o
 obj-$(CONFIG_REGULATOR_88PM8607) += 88pm8607.o
 obj-$(CONFIG_REGULATOR_ISL6271A) += isl6271a-regulator.o
 obj-$(CONFIG_REGULATOR_AB8500)	+= ab8500.o
+obj-$(CONFIG_REGULATOR_DBX500_PRCMU) += dbx500-prcmu.o
 obj-$(CONFIG_REGULATOR_DB8500_PRCMU) += db8500-prcmu.o
 obj-$(CONFIG_REGULATOR_TPS65910) += tps65910-regulator.o
 obj-$(CONFIG_REGULATOR_AAT2870) += aat2870-regulator.o
diff --git a/drivers/regulator/db8500-prcmu.c b/drivers/regulator/db8500-prcmu.c
index 7832975..d703acd 100644
--- a/drivers/regulator/db8500-prcmu.c
+++ b/drivers/regulator/db8500-prcmu.c
@@ -18,74 +18,11 @@
 #include <linux/regulator/machine.h>
 #include <linux/regulator/db8500-prcmu.h>
 #include <linux/module.h>
-
-/*
- * power state reference count
- */
-static int power_state_active_cnt; /* will initialize to zero */
-static DEFINE_SPINLOCK(power_state_active_lock);
-
-static void power_state_active_enable(void)
-{
-	unsigned long flags;
-
-	spin_lock_irqsave(&power_state_active_lock, flags);
-	power_state_active_cnt++;
-	spin_unlock_irqrestore(&power_state_active_lock, flags);
-}
-
-static int power_state_active_disable(void)
-{
-	int ret = 0;
-	unsigned long flags;
-
-	spin_lock_irqsave(&power_state_active_lock, flags);
-	if (power_state_active_cnt <= 0) {
-		pr_err("power state: unbalanced enable/disable calls\n");
-		ret = -EINVAL;
-		goto out;
-	}
-
-	power_state_active_cnt--;
-out:
-	spin_unlock_irqrestore(&power_state_active_lock, flags);
-	return ret;
-}
-
-/*
- * Exported interface for CPUIdle only. This function is called when interrupts
- * are turned off. Hence, no locking.
- */
-int power_state_active_is_enabled(void)
-{
-	return (power_state_active_cnt > 0);
-}
-
-/**
- * struct db8500_regulator_info - db8500 regulator information
- * @dev: device pointer
- * @desc: regulator description
- * @rdev: regulator device pointer
- * @is_enabled: status of the regulator
- * @epod_id: id for EPOD (power domain)
- * @is_ramret: RAM retention switch for EPOD (power domain)
- * @operating_point: operating point (only for vape, to be removed)
- *
- */
-struct db8500_regulator_info {
-	struct device *dev;
-	struct regulator_desc desc;
-	struct regulator_dev *rdev;
-	bool is_enabled;
-	u16 epod_id;
-	bool is_ramret;
-	bool exclude_from_power_state;
-	unsigned int operating_point;
-};
+#include "dbx500-prcmu.h"
 
 static int db8500_regulator_enable(struct regulator_dev *rdev)
 {
-	struct db8500_regulator_info *info = rdev_get_drvdata(rdev);
+	struct dbx500_regulator_info *info = rdev_get_drvdata(rdev);
 
 	if (info == NULL)
 		return -EINVAL;
@@ -93,16 +30,18 @@ static int db8500_regulator_enable(struct regulator_dev *rdev)
 	dev_vdbg(rdev_get_dev(rdev), "regulator-%s-enable\n",
 		info->desc.name);
 
-	info->is_enabled = true;
-	if (!info->exclude_from_power_state)
-		power_state_active_enable();
+	if (!info->is_enabled) {
+		info->is_enabled = true;
+		if (!info->exclude_from_power_state)
+			power_state_active_enable();
+	}
 
 	return 0;
 }
 
 static int db8500_regulator_disable(struct regulator_dev *rdev)
 {
-	struct db8500_regulator_info *info = rdev_get_drvdata(rdev);
+	struct dbx500_regulator_info *info = rdev_get_drvdata(rdev);
 	int ret = 0;
 
 	if (info == NULL)
@@ -111,16 +50,18 @@ static int db8500_regulator_disable(struct regulator_dev *rdev)
 	dev_vdbg(rdev_get_dev(rdev), "regulator-%s-disable\n",
 		info->desc.name);
 
-	info->is_enabled = false;
-	if (!info->exclude_from_power_state)
-		ret = power_state_active_disable();
+	if (info->is_enabled) {
+		info->is_enabled = false;
+		if (!info->exclude_from_power_state)
+			ret = power_state_active_disable();
+	}
 
 	return ret;
 }
 
 static int db8500_regulator_is_enabled(struct regulator_dev *rdev)
 {
-	struct db8500_regulator_info *info = rdev_get_drvdata(rdev);
+	struct dbx500_regulator_info *info = rdev_get_drvdata(rdev);
 
 	if (info == NULL)
 		return -EINVAL;
@@ -197,7 +138,7 @@ static int disable_epod(u16 epod_id, bool ramret)
  */
 static int db8500_regulator_switch_enable(struct regulator_dev *rdev)
 {
-	struct db8500_regulator_info *info = rdev_get_drvdata(rdev);
+	struct dbx500_regulator_info *info = rdev_get_drvdata(rdev);
 	int ret;
 
 	if (info == NULL)
@@ -221,7 +162,7 @@ out:
 
 static int db8500_regulator_switch_disable(struct regulator_dev *rdev)
 {
-	struct db8500_regulator_info *info = rdev_get_drvdata(rdev);
+	struct dbx500_regulator_info *info = rdev_get_drvdata(rdev);
 	int ret;
 
 	if (info == NULL)
@@ -245,7 +186,7 @@ out:
 
 static int db8500_regulator_switch_is_enabled(struct regulator_dev *rdev)
 {
-	struct db8500_regulator_info *info = rdev_get_drvdata(rdev);
+	struct dbx500_regulator_info *info = rdev_get_drvdata(rdev);
 
 	if (info == NULL)
 		return -EINVAL;
@@ -266,8 +207,8 @@ static struct regulator_ops db8500_regulator_switch_ops = {
 /*
  * Regulator information
  */
-static struct db8500_regulator_info
-db8500_regulator_info[DB8500_NUM_REGULATORS] = {
+static struct dbx500_regulator_info
+dbx500_regulator_info[DB8500_NUM_REGULATORS] = {
 	[DB8500_REGULATOR_VAPE] = {
 		.desc = {
 			.name	= "db8500-vape",
@@ -476,12 +417,12 @@ static int __devinit db8500_regulator_probe(struct platform_device *pdev)
 	int i, err;
 
 	/* register all regulators */
-	for (i = 0; i < ARRAY_SIZE(db8500_regulator_info); i++) {
-		struct db8500_regulator_info *info;
+	for (i = 0; i < ARRAY_SIZE(dbx500_regulator_info); i++) {
+		struct dbx500_regulator_info *info;
 		struct regulator_init_data *init_data = &db8500_init_data[i];
 
 		/* assign per-regulator data */
-		info = &db8500_regulator_info[i];
+		info = &dbx500_regulator_info[i];
 		info->dev = &pdev->dev;
 
 		/* register with the regulator framework */
@@ -494,7 +435,7 @@ static int __devinit db8500_regulator_probe(struct platform_device *pdev)
 
 			/* if failing, unregister all earlier regulators */
 			while (--i >= 0) {
-				info = &db8500_regulator_info[i];
+				info = &dbx500_regulator_info[i];
 				regulator_unregister(info->rdev);
 			}
 			return err;
@@ -503,17 +444,22 @@ static int __devinit db8500_regulator_probe(struct platform_device *pdev)
 		dev_dbg(rdev_get_dev(info->rdev),
 			"regulator-%s-probed\n", info->desc.name);
 	}
+	err = ux500_regulator_debug_init(pdev,
+					 dbx500_regulator_info,
+					 ARRAY_SIZE(dbx500_regulator_info));
 
-	return 0;
+	return err;
 }
 
 static int __exit db8500_regulator_remove(struct platform_device *pdev)
 {
 	int i;
 
-	for (i = 0; i < ARRAY_SIZE(db8500_regulator_info); i++) {
-		struct db8500_regulator_info *info;
-		info = &db8500_regulator_info[i];
+	ux500_regulator_debug_exit();
+
+	for (i = 0; i < ARRAY_SIZE(dbx500_regulator_info); i++) {
+		struct dbx500_regulator_info *info;
+		info = &dbx500_regulator_info[i];
 
 		dev_vdbg(rdev_get_dev(info->rdev),
 			"regulator-%s-remove\n", info->desc.name);
diff --git a/drivers/regulator/dbx500-prcmu.c b/drivers/regulator/dbx500-prcmu.c
new file mode 100644
index 0000000..f2e5ecd
--- /dev/null
+++ b/drivers/regulator/dbx500-prcmu.c
@@ -0,0 +1,241 @@
+/*
+ * Copyright (C) ST-Ericsson SA 2010
+ *
+ * License Terms: GNU General Public License v2
+ * Authors: Sundar Iyer <sundar.iyer@stericsson.com> for ST-Ericsson
+ *          Bengt Jonsson <bengt.g.jonsson@stericsson.com> for ST-Ericsson
+ *
+ * UX500 common part of Power domain regulators
+ */
+
+#include <linux/kernel.h>
+#include <linux/err.h>
+#include <linux/regulator/driver.h>
+#include <linux/debugfs.h>
+#include <linux/seq_file.h>
+#include <linux/slab.h>
+
+#include "dbx500-prcmu.h"
+
+/*
+ * power state reference count
+ */
+static int power_state_active_cnt; /* will initialize to zero */
+static DEFINE_SPINLOCK(power_state_active_lock);
+
+int power_state_active_get(void)
+{
+	unsigned long flags;
+	int cnt;
+
+	spin_lock_irqsave(&power_state_active_lock, flags);
+	cnt = power_state_active_cnt;
+	spin_unlock_irqrestore(&power_state_active_lock, flags);
+
+	return cnt;
+}
+
+void power_state_active_enable(void)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&power_state_active_lock, flags);
+	power_state_active_cnt++;
+	spin_unlock_irqrestore(&power_state_active_lock, flags);
+}
+
+int power_state_active_disable(void)
+{
+	int ret = 0;
+	unsigned long flags;
+
+	spin_lock_irqsave(&power_state_active_lock, flags);
+	if (power_state_active_cnt <= 0) {
+		pr_err("power state: unbalanced enable/disable calls\n");
+		ret = -EINVAL;
+		goto out;
+	}
+
+	power_state_active_cnt--;
+out:
+	spin_unlock_irqrestore(&power_state_active_lock, flags);
+	return ret;
+}
+
+#ifdef CONFIG_REGULATOR_DEBUG
+
+static struct ux500_regulator_debug {
+	struct dentry *dir;
+	struct dentry *status_file;
+	struct dentry *power_state_cnt_file;
+	struct dbx500_regulator_info *regulator_array;
+	int num_regulators;
+	u8 *state_before_suspend;
+	u8 *state_after_suspend;
+} rdebug;
+
+void ux500_regulator_suspend_debug(void)
+{
+	int i;
+	for (i = 0; i < rdebug.num_regulators; i++)
+		rdebug.state_before_suspend[i] =
+			rdebug.regulator_array[i].is_enabled;
+}
+
+void ux500_regulator_resume_debug(void)
+{
+	int i;
+	for (i = 0; i < rdebug.num_regulators; i++)
+		rdebug.state_after_suspend[i] =
+			rdebug.regulator_array[i].is_enabled;
+}
+
+static int ux500_regulator_power_state_cnt_print(struct seq_file *s, void *p)
+{
+	struct device *dev = s->private;
+	int err;
+
+	/* print power state count */
+	err = seq_printf(s, "ux500-regulator power state count: %i\n",
+		power_state_active_get());
+	if (err < 0)
+		dev_err(dev, "seq_printf overflow\n");
+
+	return 0;
+}
+
+static int ux500_regulator_power_state_cnt_open(struct inode *inode,
+	struct file *file)
+{
+	return single_open(file, ux500_regulator_power_state_cnt_print,
+		inode->i_private);
+}
+
+static const struct file_operations ux500_regulator_power_state_cnt_fops = {
+	.open = ux500_regulator_power_state_cnt_open,
+	.read = seq_read,
+	.llseek = seq_lseek,
+	.release = single_release,
+	.owner = THIS_MODULE,
+};
+
+static int ux500_regulator_status_print(struct seq_file *s, void *p)
+{
+	struct device *dev = s->private;
+	int err;
+	int i;
+
+	/* print dump header */
+	err = seq_printf(s, "ux500-regulator status:\n");
+	if (err < 0)
+		dev_err(dev, "seq_printf overflow\n");
+
+	err = seq_printf(s, "%31s : %8s : %8s\n", "current",
+		"before", "after");
+	if (err < 0)
+		dev_err(dev, "seq_printf overflow\n");
+
+	for (i = 0; i < rdebug.num_regulators; i++) {
+		struct dbx500_regulator_info *info;
+		/* Access per-regulator data */
+		info = &rdebug.regulator_array[i];
+
+		/* print status */
+		err = seq_printf(s, "%20s : %8s : %8s : %8s\n", info->desc.name,
+			info->is_enabled ? "enabled" : "disabled",
+			rdebug.state_before_suspend[i] ? "enabled" : "disabled",
+			rdebug.state_after_suspend[i] ? "enabled" : "disabled");
+		if (err < 0)
+			dev_err(dev, "seq_printf overflow\n");
+	}
+
+	return 0;
+}
+
+static int ux500_regulator_status_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, ux500_regulator_status_print,
+		inode->i_private);
+}
+
+static const struct file_operations ux500_regulator_status_fops = {
+	.open = ux500_regulator_status_open,
+	.read = seq_read,
+	.llseek = seq_lseek,
+	.release = single_release,
+	.owner = THIS_MODULE,
+};
+
+int __attribute__((weak)) dbx500_regulator_testcase(
+	struct dbx500_regulator_info *regulator_info,
+	int num_regulators)
+{
+	return 0;
+}
+
+int __devinit
+ux500_regulator_debug_init(struct platform_device *pdev,
+	struct dbx500_regulator_info *regulator_info,
+	int num_regulators)
+{
+	/* create directory */
+	rdebug.dir = debugfs_create_dir("ux500-regulator", NULL);
+	if (!rdebug.dir)
+		goto exit_no_debugfs;
+
+	/* create "status" file */
+	rdebug.status_file = debugfs_create_file("status",
+		S_IRUGO, rdebug.dir, &pdev->dev,
+		&ux500_regulator_status_fops);
+	if (!rdebug.status_file)
+		goto exit_destroy_dir;
+
+	/* create "power-state-count" file */
+	rdebug.power_state_cnt_file = debugfs_create_file("power-state-count",
+		S_IRUGO, rdebug.dir, &pdev->dev,
+		&ux500_regulator_power_state_cnt_fops);
+	if (!rdebug.power_state_cnt_file)
+		goto exit_destroy_status;
+
+	rdebug.regulator_array = regulator_info;
+	rdebug.num_regulators = num_regulators;
+
+	rdebug.state_before_suspend = kzalloc(num_regulators, GFP_KERNEL);
+	if (!rdebug.state_before_suspend) {
+		dev_err(&pdev->dev,
+			"could not allocate memory for saving state\n");
+		goto exit_destroy_power_state;
+	}
+
+	rdebug.state_after_suspend = kzalloc(num_regulators, GFP_KERNEL);
+	if (!rdebug.state_after_suspend) {
+		dev_err(&pdev->dev,
+			"could not allocate memory for saving state\n");
+		goto exit_free;
+	}
+
+	dbx500_regulator_testcase(regulator_info, num_regulators);
+	return 0;
+
+exit_free:
+	kfree(rdebug.state_before_suspend);
+exit_destroy_power_state:
+	debugfs_remove(rdebug.power_state_cnt_file);
+exit_destroy_status:
+	debugfs_remove(rdebug.status_file);
+exit_destroy_dir:
+	debugfs_remove(rdebug.dir);
+exit_no_debugfs:
+	dev_err(&pdev->dev, "failed to create debugfs entries.\n");
+	return -ENOMEM;
+}
+
+int __devexit ux500_regulator_debug_exit(void)
+{
+	debugfs_remove_recursive(rdebug.dir);
+	kfree(rdebug.state_after_suspend);
+	kfree(rdebug.state_before_suspend);
+
+	return 0;
+}
+#endif
diff --git a/drivers/regulator/dbx500-prcmu.h b/drivers/regulator/dbx500-prcmu.h
new file mode 100644
index 0000000..e763883
--- /dev/null
+++ b/drivers/regulator/dbx500-prcmu.h
@@ -0,0 +1,63 @@
+/*
+ * Copyright (C) ST-Ericsson SA 2010
+ *
+ * Author: Bengt Jonsson <bengt.jonsson@stericsson.com> for ST-Ericsson,
+ *	   Jonas Aaberg <jonas.aberg@stericsson.com> for ST-Ericsson
+ *
+ * License Terms: GNU General Public License v2
+ *
+ */
+
+#ifndef DBX500_REGULATOR_H
+#define DBX500_REGULATOR_H
+
+#include <linux/platform_device.h>
+
+/**
+ * struct dbx500_regulator_info - dbx500 regulator information
+ * @dev: device pointer
+ * @desc: regulator description
+ * @rdev: regulator device pointer
+ * @is_enabled: status of the regulator
+ * @epod_id: id for EPOD (power domain)
+ * @is_ramret: RAM retention switch for EPOD (power domain)
+ * @operating_point: operating point (only for vape, to be removed)
+ *
+ */
+struct dbx500_regulator_info {
+	struct device *dev;
+	struct regulator_desc desc;
+	struct regulator_dev *rdev;
+	bool is_enabled;
+	u16 epod_id;
+	bool is_ramret;
+	bool exclude_from_power_state;
+	unsigned int operating_point;
+};
+
+void power_state_active_enable(void);
+int power_state_active_disable(void);
+
+
+#ifdef CONFIG_REGULATOR_DEBUG
+int ux500_regulator_debug_init(struct platform_device *pdev,
+			       struct dbx500_regulator_info *regulator_info,
+			       int num_regulators);
+
+int ux500_regulator_debug_exit(void);
+#else
+
+static inline int ux500_regulator_debug_init(struct platform_device *pdev,
+			     struct dbx500_regulator_info *regulator_info,
+			     int num_regulators)
+{
+	return 0;
+}
+
+static inline int ux500_regulator_debug_exit(void)
+{
+	return 0;
+}
+
+#endif
+#endif
-- 
1.7.8

