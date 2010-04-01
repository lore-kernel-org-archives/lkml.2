Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755414Ab0DALZI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 07:25:08 -0400
Received: from 81-174-11-161.static.ngi.it ([81.174.11.161]:54285 "EHLO
	mail.enneenne.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755249Ab0DALY6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 07:24:58 -0400
From: Rodolfo Giometti <giometti@linux.it>
To: linux-kernel@vger.kernel.org
Cc: Liam Girdwood <lrg@slimlogic.co.uk>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Rodolfo Giometti <giometti@linux.it>
Date: Thu,  1 Apr 2010 13:23:32 +0200
Message-Id: <1270121012-31916-1-git-send-email-giometti@linux.it>
X-Mailer: git-send-email 1.6.3.3
X-SA-Exim-Connect-IP: 192.168.32.37
X-SA-Exim-Mail-From: giometti@enneenne.com
Subject: [PATCH 04/19] regulator: add support for Dallas DS1803 dual digital potentiometer
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on mail.enneenne.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Rodolfo Giometti <giometti@linux.it>
Acked-by: Raffaele Recalcati <raffaele.recalcati@bticino.it>
Acked-by: Enrico Valtolina <enrico.valtolina@bticino.it>
---
 drivers/regulator/Kconfig        |    7 ++
 drivers/regulator/Makefile       |    1 +
 drivers/regulator/ds1803.c       |  201 ++++++++++++++++++++++++++++++++++++++
 include/linux/regulator/ds1803.h |   41 ++++++++
 4 files changed, 250 insertions(+), 0 deletions(-)
 create mode 100644 drivers/regulator/ds1803.c
 create mode 100644 include/linux/regulator/ds1803.h

diff --git a/drivers/regulator/Kconfig b/drivers/regulator/Kconfig
index 04f2e08..ebaf09b 100644
--- a/drivers/regulator/Kconfig
+++ b/drivers/regulator/Kconfig
@@ -201,5 +201,12 @@ config REGULATOR_88PM8607
 	help
 	  This driver supports 88PM8607 voltage regulator chips.
 
+config REGULATOR_DS1803
+	tristate "Dallas Maxim DS1803 addressable dual digital potentiometer"
+	depends on I2C
+	help
+	  Say Y here to support the dual digital potentiometer on
+	  Dallas Maxim DS1803
+
 endif
 
diff --git a/drivers/regulator/Makefile b/drivers/regulator/Makefile
index 4e7feec..c0fe050 100644
--- a/drivers/regulator/Makefile
+++ b/drivers/regulator/Makefile
@@ -31,5 +31,6 @@ obj-$(CONFIG_REGULATOR_AB3100) += ab3100.o
 obj-$(CONFIG_REGULATOR_TPS65023) += tps65023-regulator.o
 obj-$(CONFIG_REGULATOR_TPS6507X) += tps6507x-regulator.o
 obj-$(CONFIG_REGULATOR_88PM8607) += 88pm8607.o
+obj-$(CONFIG_REGULATOR_DS1803) += ds1803.o
 
 ccflags-$(CONFIG_REGULATOR_DEBUG) += -DDEBUG
diff --git a/drivers/regulator/ds1803.c b/drivers/regulator/ds1803.c
new file mode 100644
index 0000000..84719c9
--- /dev/null
+++ b/drivers/regulator/ds1803.c
@@ -0,0 +1,201 @@
+/*
+ * ds1803.c  --  Voltage regulation for the DS1803
+ *
+ * Copyright (C) 2009 Rodolfo Giometti <giometti@linux.it>
+ * Copyright (C) 2009 Bticino S.p.A. <info@bticino.it>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ */
+
+#include <linux/module.h>
+#include <linux/err.h>
+#include <linux/i2c.h>
+#include <linux/platform_device.h>
+#include <linux/regulator/driver.h>
+#include <linux/regulator/ds1803.h>
+
+struct ds1803_data {
+	struct i2c_client *client;
+	struct regulator_dev *rdev;
+
+	unsigned int min_uV;	/* voltage for selector value 0 */
+	unsigned int max_uV;	/* voltage for selector value 255 */
+	unsigned int init_uV;	/* initial voltage */
+};
+
+/*
+ * Low level functions
+ */
+
+static u8 ds1803_write_pot_lut[] = { 0xa9, 0xaa, /* both not supported */ };
+
+static int ds1803_set_voltage(struct regulator_dev *rdev,
+					int min_uV, int max_uV)
+{
+	struct ds1803_data *ds1803 = rdev_get_drvdata(rdev);
+	struct i2c_client *client = ds1803->client;
+	unsigned int id = rdev_get_id(rdev);
+	int val;
+	u8 buf[2] = { ds1803_write_pot_lut[id], 0 };
+	struct i2c_msg msgs[1] = {
+		{ client->addr  , 0, 2, buf },
+	};
+	int ret;
+
+	val = (min_uV - ds1803->min_uV) * 255 / ds1803->max_uV;
+
+	if (val < 0 || val > 255)
+		return -EINVAL;
+	buf[1] = val;
+
+	ret = i2c_transfer(client->adapter, &msgs[0], 1);
+	if (ret != 1) {
+		dev_err(&client->dev, "%s: write error\n", __func__);
+		return -EIO;
+	}
+
+	return 0;
+}
+
+static int ds1803_list_voltage(struct regulator_dev *rdev, unsigned index)
+{
+	struct ds1803_data *ds1803 = rdev_get_drvdata(rdev);
+
+	return (ds1803->max_uV - ds1803->min_uV) * index / 255
+							+ ds1803->min_uV;
+}
+
+/*
+ * Regulator methods
+ */
+
+static struct regulator_ops ds1803_voltage_ops = {
+	.set_voltage = ds1803_set_voltage,
+	.list_voltage = ds1803_list_voltage,
+};
+
+static char *ds1803_names[] = {
+	[DS1803_100K] = "trimmer_100k",
+	[DS1803_50K] = "trimmer_50k",
+	[DS1803_10K] = "trimmer_10k",
+};
+
+static struct regulator_desc ds1803_reg[] = {
+	{
+		.type = REGULATOR_VOLTAGE,
+		.id = 0,
+		.n_voltages = 256,
+		.ops = &ds1803_voltage_ops,
+		.owner = THIS_MODULE,
+	},
+	{
+		.type = REGULATOR_VOLTAGE,
+		.id = 1,
+		.n_voltages = 256,
+		.ops = &ds1803_voltage_ops,
+		.owner = THIS_MODULE,
+	},
+};
+
+static int ds1803_i2c_probe(struct i2c_client *client,
+			      const struct i2c_device_id *i2c_id)
+{
+	struct ds1803_platform_data *pdata = client->dev.platform_data;
+	struct ds1803_data *ds1803;
+	int i, ret = -ENOMEM;
+
+	ds1803 = kzalloc(sizeof(struct ds1803_data) * 2, GFP_KERNEL);
+	if (!ds1803)
+		goto out;
+
+	for (i = 0; i < 2; i++) {
+		ds1803[i].client = client;
+
+		/* No init_data -> no regulation */
+		if (!pdata->subdev[i].init)
+			continue;
+
+		/* Set chip's name according to user supplied type */
+		ds1803_reg[i].name = ds1803_names[pdata->type];
+
+		ds1803[i].min_uV = pdata->subdev[i].min_uV;
+		ds1803[i].max_uV = pdata->subdev[i].max_uV;
+		ds1803[i].rdev = regulator_register(&ds1803_reg[i],
+					&client->dev,
+					pdata->subdev[i].init, &ds1803[i]);
+		if (IS_ERR(ds1803[i].rdev)) {
+			dev_err(&client->dev,
+				"failed to register regulator %d\n", i);
+			goto err;
+		}
+	}
+
+	i2c_set_clientdata(client, ds1803);
+	dev_info(&client->dev, "DS1803 regulator driver loaded\n");
+	return 0;
+
+err:
+	while (--i >= 0)
+		regulator_unregister(ds1803[i].rdev);
+	kfree(ds1803);
+out:
+	return ret;
+}
+
+static int ds1803_i2c_remove(struct i2c_client *client)
+{
+	struct ds1803_data *ds1803 = i2c_get_clientdata(client);
+	int i;
+
+	for (i = 0; i < 2; i++)
+		if (ds1803[i].rdev)
+			regulator_unregister(ds1803[i].rdev);
+	kfree(ds1803);
+	i2c_set_clientdata(client, NULL);
+
+	return 0;
+}
+
+static const struct i2c_device_id ds1803_id[] = {
+	{ "ds1803", 0 },
+	{ }
+};
+MODULE_DEVICE_TABLE(i2c, ds1803_id);
+
+static struct i2c_driver ds1803_i2c_driver = {
+	.probe = ds1803_i2c_probe,
+	.remove = ds1803_i2c_remove,
+	.driver		= {
+		.name	= "ds1803",
+	},
+	.id_table	= ds1803_id,
+};
+
+static int __init ds1803_i2c_init(void)
+{
+	return i2c_add_driver(&ds1803_i2c_driver);
+}
+subsys_initcall(ds1803_i2c_init);
+
+static void __exit ds1803_i2c_exit(void)
+{
+	i2c_del_driver(&ds1803_i2c_driver);
+}
+module_exit(ds1803_i2c_exit);
+
+/* Module information */
+MODULE_DESCRIPTION("DS1803 voltage regulator driver");
+MODULE_AUTHOR("Rodolfo Giometti <giometti@linux.it>");
+MODULE_LICENSE("GPL v2");
diff --git a/include/linux/regulator/ds1803.h b/include/linux/regulator/ds1803.h
new file mode 100644
index 0000000..6bce0ec
--- /dev/null
+++ b/include/linux/regulator/ds1803.h
@@ -0,0 +1,41 @@
+/*
+ * ds1803.h  --  Voltage regulation for the DS1803
+ *
+ * Copyright (C) 2009 Rodolfo Giometti <giometti@linux.it>
+ * Copyright (C) 2009 Bticino S.p.A. <info@bticino.it>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation version 2.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ */
+
+#ifndef _DS1803_H
+#define _DS1803_H
+
+#include <linux/regulator/machine.h>
+
+enum ds1803_type {
+	DS1803_100K,
+	DS1803_50K,
+	DS1803_10K,
+};
+
+struct ds1803_platform_data {
+	enum ds1803_type type;
+	struct {
+		unsigned int min_uV;
+		unsigned int max_uV;
+		struct regulator_init_data *init;
+	} subdev[2];
+};
+
+#endif /* _DS1803_H */
-- 
1.6.3.3

