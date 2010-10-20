Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754610Ab0JTCRU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 22:17:20 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:17369 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752313Ab0JTCRT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 22:17:19 -0400
X-PGP-Universal: processed;
	by hqnvupgp02.nvidia.com on Tue, 19 Oct 2010 19:17:18 -0700
From: rklein@nvidia.com
To: cboutatmailru@gmail.com
Cc: achew@nvidia.com, olof@lixom.net, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org, Rhyland Klein <rklein@nvidia.com>
Subject: [PATCH 1/1] power: bq24617: Adding initial charger support
Date: Tue, 19 Oct 2010 19:17:11 -0700
Message-Id: <1287541031-17409-1-git-send-email-rklein@nvidia.com>
X-Mailer: git-send-email 1.7.0.4
X-OriginalArrivalTime: 20 Oct 2010 02:17:13.0442 (UTC) FILETIME=[E8908C20:01CB6FFC]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rhyland Klein <rklein@nvidia.com>

Initial checkin adding basic support for the TI BQ24617 battery charger on the
Nvidia Tegra architecture.

Signed-off-by: Rhyland Klein <rklein@nvidia.com>
---
 drivers/power/Kconfig         |    7 +
 drivers/power/Makefile        |    1 +
 drivers/power/tegra_bq24617.c |  259 +++++++++++++++++++++++++++++++++++++++++
 include/linux/tegra_bq24617.h |   10 ++
 4 files changed, 277 insertions(+), 0 deletions(-)
 create mode 100644 drivers/power/tegra_bq24617.c
 create mode 100644 include/linux/tegra_bq24617.h

diff --git a/drivers/power/Kconfig b/drivers/power/Kconfig
index 60d83d9..cec4a63 100644
--- a/drivers/power/Kconfig
+++ b/drivers/power/Kconfig
@@ -185,4 +185,11 @@ config CHARGER_TWL4030
 	help
 	  Say Y here to enable support for TWL4030 Battery Charge Interface.
 
+config CHARGER_BQ24617_TEGRA
+	tristate "BQ24617 Tegra battery charger"
+	depends on I2C && ARCH_TEGRA
+	help
+	 Say Y to include support for the TI BQ24617 battery charger on
+	 the Nvidia Tegra platform.
+
 endif # POWER_SUPPLY
diff --git a/drivers/power/Makefile b/drivers/power/Makefile
index c75772e..95d8163 100644
--- a/drivers/power/Makefile
+++ b/drivers/power/Makefile
@@ -32,3 +32,4 @@ obj-$(CONFIG_BATTERY_JZ4740)	+= jz4740-battery.o
 obj-$(CONFIG_BATTERY_INTEL_MID)	+= intel_mid_battery.o
 obj-$(CONFIG_CHARGER_ISP1704)	+= isp1704_charger.o
 obj-$(CONFIG_CHARGER_TWL4030)	+= twl4030_charger.o
+obj-$(CONFIG_CHARGER_BQ24617_TEGRA)	+= tegra_bq24617.o
diff --git a/drivers/power/tegra_bq24617.c b/drivers/power/tegra_bq24617.c
new file mode 100644
index 0000000..02c8a76
--- /dev/null
+++ b/drivers/power/tegra_bq24617.c
@@ -0,0 +1,259 @@
+/*
+ * Charger driver for TI's BQ24617
+ *
+ * Copyright (c) 2010, NVIDIA Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along
+ * with this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
+ */
+
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/err.h>
+#include <linux/power_supply.h>
+#include <linux/slab.h>
+#include <linux/gpio.h>
+#include <linux/tegra_bq24617.h>
+#include <linux/interrupt.h>
+#include <linux/platform_device.h>
+#include <linux/irq.h>
+
+struct bq24617_info {
+	struct power_supply		power_supply;
+	struct bq24617_platform_data	*pdata;
+	struct platform_device		*pdev;
+	struct mutex			work_lock;
+	struct work_struct		ac_work;
+	int				status;
+};
+
+static enum power_supply_property bq24617_properties[] = {
+	POWER_SUPPLY_PROP_ONLINE,
+};
+
+static void bq24617_batt_update(struct bq24617_info *chip)
+{
+	int old_status = chip->status;
+	int new_status = old_status;
+	struct bq24617_platform_data *pdata;
+	int gpio_value = 0;
+
+	pdata = chip->pdata;
+
+	mutex_lock(&chip->work_lock);
+
+	gpio_value = gpio_get_value(pdata->gpio_addr);
+
+	new_status = !gpio_value;
+	chip->status = new_status;
+
+	mutex_unlock(&chip->work_lock);
+
+	if (old_status != -1 &&
+		old_status != new_status) {
+		dev_dbg(&chip->pdev->dev,
+			"%s: %i -> %i\n", __func__, old_status,
+			new_status);
+		kobject_uevent(&chip->power_supply.dev->kobj, KOBJ_CHANGE);
+	}
+
+}
+
+static irqreturn_t bq24617_irq_switch(int irq, void *devid)
+{
+	struct bq24617_info *chip = devid;
+
+	schedule_work(&chip->ac_work);
+
+	return IRQ_HANDLED;
+}
+
+static int bq24617_get_property(struct power_supply *psy,
+	enum power_supply_property psp,
+	union power_supply_propval *val)
+{
+	struct bq24617_info *chip = container_of(psy, struct bq24617_info,
+						power_supply);
+
+	switch (psp) {
+	case POWER_SUPPLY_PROP_ONLINE:
+		bq24617_batt_update(chip);
+		val->intval = chip->status;
+		break;
+	default:
+		dev_err(&chip->pdev->dev,
+			"%s: Unknown property requested.\n", __func__);
+		return -EINVAL;
+		break;
+	}
+	return 0;
+}
+
+static void bq24617_ac_work(struct work_struct *work)
+{
+	struct bq24617_info *chip;
+	chip = container_of(work, struct bq24617_info, ac_work);
+	bq24617_batt_update(chip);
+}
+
+static int bq24617_probe(struct platform_device *pdev)
+{
+	struct bq24617_info *chip;
+	struct bq24617_platform_data *pdata = pdev->dev.platform_data;
+	int rc;
+
+	if (!pdata) {
+		dev_err(&pdev->dev, "No platform data\n");
+		return -ENXIO;
+	}
+
+	if (!(gpio_is_valid(pdata->gpio_addr))) {
+		dev_err(&pdev->dev, "Gpio is not valid\n");
+		return -EINVAL;
+	}
+
+	chip = kzalloc(sizeof(struct bq24617_info), GFP_KERNEL);
+	if (!chip)
+		return -ENOMEM;
+
+	chip->pdata = pdata;
+	chip->pdev = pdev;
+	chip->power_supply.name = "ac";
+	chip->status = -1; /* set status to reflect unset */
+	chip->power_supply.type = POWER_SUPPLY_TYPE_MAINS;
+	chip->power_supply.properties = bq24617_properties;
+	chip->power_supply.num_properties = ARRAY_SIZE(bq24617_properties);
+	chip->power_supply.get_property = bq24617_get_property;
+	chip->power_supply.supplied_to = pdata->batteries;
+	chip->power_supply.num_supplicants = pdata->num_batteries;
+
+	mutex_init(&chip->work_lock);
+
+	platform_set_drvdata(pdev, chip);
+
+	rc = gpio_request(pdata->gpio_addr, "ac online");
+	if (rc) {
+		dev_err(&pdev->dev,
+			"%s: Failed to get gpio\n", __func__);
+		goto free_chip;
+	}
+
+	gpio_direction_input(pdata->gpio_addr);
+	if (rc) {
+		dev_err(&pdev->dev,
+			"%s: Failed to set gpio direction\n",
+			__func__);
+		goto release_gpio;
+	}
+
+	rc = request_irq(gpio_to_irq(pdata->gpio_addr),
+			bq24617_irq_switch,
+			IRQF_TRIGGER_FALLING | IRQF_TRIGGER_RISING,
+			"ac detect", chip);
+	if (rc) {
+		dev_err(&pdev->dev,
+			"%s: Failed to request IRQ\n", __func__);
+		goto release_gpio;
+	}
+
+	INIT_WORK(&chip->ac_work, bq24617_ac_work);
+
+	rc = power_supply_register(&pdev->dev, &chip->power_supply);
+	if (rc) {
+		dev_err(&pdev->dev,
+			"%s: Failed to register power supply\n", __func__);
+		goto free_irq;
+	}
+
+	dev_info(&pdev->dev,
+		"%s: battery charger ac device registered\n", pdev->name);
+
+	schedule_work(&chip->ac_work);
+
+	return 0;
+
+free_irq:
+	free_irq(gpio_to_irq(pdata->gpio_addr), chip);
+release_gpio:
+	gpio_free(pdata->gpio_addr);
+free_chip:
+	kfree(chip);
+	return rc;
+}
+
+static int bq24617_remove(struct platform_device *pdev)
+{
+	struct bq24617_info *chip = platform_get_drvdata(pdev);
+	struct bq24617_platform_data *pdata = chip->pdata;
+
+	flush_scheduled_work();
+
+	power_supply_unregister(&chip->power_supply);
+
+	free_irq(gpio_to_irq(pdata->gpio_addr), chip);
+	gpio_free(pdata->gpio_addr);
+	kfree(chip);
+
+	return 0;
+}
+
+#if CONFIG_PM
+static int bq24617_suspend(struct platform_device *pdev, pm_message_t state)
+{
+	flush_scheduled_work();
+
+	return 0;
+}
+
+static int bq24617_resume(struct platform_device *pdev)
+{
+	struct bq24617_info *chip = platform_get_drvdata(pdev);
+
+	schedule_work(&chip->ac_work);
+
+	return 0;
+}
+
+#else
+#define bq24617_suspend         NULL
+#define bq24617_resume          NULL
+#endif
+
+static struct platform_driver bq24617_driver = {
+	.driver = {
+		.name	= "tegra-bq24617",
+		.owner	= THIS_MODULE,
+	},
+	.probe		= bq24617_probe,
+	.remove		= __devexit_p(bq24617_remove),
+	.suspend	= bq24617_suspend,
+	.resume		= bq24617_resume,
+};
+
+static int __devinit bq24617_init(void)
+{
+	return platform_driver_register(&bq24617_driver);
+}
+module_init(bq24617_init);
+
+static void __devexit bq24617_exit(void)
+{
+	platform_driver_unregister(&bq24617_driver);
+}
+module_exit(bq24617_exit);
+
+MODULE_AUTHOR("Rhyland Klein <rklein@nvidia.com");
+MODULE_DESCRIPTION("BQ24617 battery charger driver");
+MODULE_LICENSE("GPL");
diff --git a/include/linux/tegra_bq24617.h b/include/linux/tegra_bq24617.h
new file mode 100644
index 0000000..4c58406
--- /dev/null
+++ b/include/linux/tegra_bq24617.h
@@ -0,0 +1,10 @@
+#ifndef _LINUX_BQ24617_H
+#define _LINUX_BQ24617_H
+
+struct bq24617_platform_data {
+	int	gpio_addr;
+	char	**batteries;
+	int	num_batteries;
+};
+
+#endif
-- 
1.7.0.4

