Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757953Ab3AIOFO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 09:05:14 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:43339 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757926Ab3AIOFM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 09:05:12 -0500
Subject: [PATCH 07/10] goldfish: power device
To: arve@android.com, x86@kernel.org, linux-kernel@vger.kernel.org,
        mikechan@google.com
From: Alan Cox <alan@linux.intel.com>
Date: Wed, 09 Jan 2013 14:25:16 +0000
Message-ID: <20130109142500.9239.26543.stgit@bob.linux.org.uk>
In-Reply-To: <20130109142212.9239.62026.stgit@bob.linux.org.uk>
References: <20130109142212.9239.62026.stgit@bob.linux.org.uk>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mike Lockwood <lockwood@android.com>

Add the emulated power driver for the Goldfish platform.

This folds together the code from the Google tree, Jun Nakajima's cleanups
and x86 porting work, and then a tidy up to pass checkpatch.

Signed-off-by: Mike A. Chan <mikechan@google.com>
[cleanup and x86 support]
Signed-off-by: Sheng Yang <sheng@linux.intel.com>
Signed-off-by: Yunhong Jiang <yunhong.jiang@intel.com>
Signed-off-by: Xiaohui Xin <xiaohui.xin@intel.com>
Signed-off-by: Jun Nakajima <jun.nakajima@intel.com>
Signed-off-by: Bruce Beare <bruce.j.beare@intel.com>
[ported to 3.4]
Signed-off-by: Tom Keel <thomas.keel@intel.com>
[ported to 3.7 and final tidy]
Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/power/Kconfig            |    8 +
 drivers/power/Makefile           |    1 
 drivers/power/goldfish_battery.c |  262 ++++++++++++++++++++++++++++++++++++++
 3 files changed, 270 insertions(+), 1 deletion(-)
 create mode 100644 drivers/power/goldfish_battery.c


diff --git a/drivers/power/Kconfig b/drivers/power/Kconfig
index 9f45e2f..0c5208d 100644
--- a/drivers/power/Kconfig
+++ b/drivers/power/Kconfig
@@ -346,8 +346,14 @@ config AB8500_BM
 	help
 	  Say Y to include support for AB8500 battery management.
 
-source "drivers/power/reset/Kconfig"
+config BATTERY_GOLDFISH
+	tristate "Goldfish battery driver"
+	depends on GOLDFISH
+	help
+	  Say Y to enable support for the battery and AC power in the
+	  Goldfish emulator.
 
+source "drivers/power/reset/Kconfig"
 endif # POWER_SUPPLY
 
 source "drivers/power/avs/Kconfig"
diff --git a/drivers/power/Makefile b/drivers/power/Makefile
index b11e0c7..a9f5c06 100644
--- a/drivers/power/Makefile
+++ b/drivers/power/Makefile
@@ -20,6 +20,7 @@ obj-$(CONFIG_BATTERY_DS2760)	+= ds2760_battery.o
 obj-$(CONFIG_BATTERY_DS2780)	+= ds2780_battery.o
 obj-$(CONFIG_BATTERY_DS2781)	+= ds2781_battery.o
 obj-$(CONFIG_BATTERY_DS2782)	+= ds2782_battery.o
+obj-$(CONFIG_BATTERY_GOLDFISH)	+= goldfish_battery.o
 obj-$(CONFIG_BATTERY_PMU)	+= pmu_battery.o
 obj-$(CONFIG_BATTERY_OLPC)	+= olpc_battery.o
 obj-$(CONFIG_BATTERY_TOSA)	+= tosa_battery.o
diff --git a/drivers/power/goldfish_battery.c b/drivers/power/goldfish_battery.c
new file mode 100644
index 0000000..06602802
--- /dev/null
+++ b/drivers/power/goldfish_battery.c
@@ -0,0 +1,262 @@
+/*
+ * Power supply driver for the goldfish emulator
+ *
+ * Copyright (C) 2008 Google, Inc.
+ * Copyright (C) 2012 Intel, Inc.
+ * Author: Mike Lockwood <lockwood@android.com>
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ */
+
+#include <linux/module.h>
+#include <linux/err.h>
+#include <linux/platform_device.h>
+#include <linux/power_supply.h>
+#include <linux/types.h>
+#include <linux/pci.h>
+#include <linux/interrupt.h>
+#include <linux/io.h>
+
+
+struct goldfish_battery_data {
+	void __iomem *reg_base;
+	int irq;
+	spinlock_t lock;
+
+	struct power_supply battery;
+	struct power_supply ac;
+};
+
+#define GOLDFISH_BATTERY_READ(data, addr)   (readl(data->reg_base + addr))
+#define GOLDFISH_BATTERY_WRITE(data, addr, x)   (writel(x, data->reg_base + addr))
+
+
+/* temporary variable used between goldfish_battery_probe() and goldfish_battery_open() */
+static struct goldfish_battery_data *battery_data;
+
+enum {
+	/* status register */
+	BATTERY_INT_STATUS	    = 0x00,
+	/* set this to enable IRQ */
+	BATTERY_INT_ENABLE	    = 0x04,
+
+	BATTERY_AC_ONLINE       = 0x08,
+	BATTERY_STATUS          = 0x0C,
+	BATTERY_HEALTH          = 0x10,
+	BATTERY_PRESENT         = 0x14,
+	BATTERY_CAPACITY        = 0x18,
+
+	BATTERY_STATUS_CHANGED	= 1U << 0,
+	AC_STATUS_CHANGED	= 1U << 1,
+	BATTERY_INT_MASK        = BATTERY_STATUS_CHANGED | AC_STATUS_CHANGED,
+};
+
+
+static int goldfish_ac_get_property(struct power_supply *psy,
+			enum power_supply_property psp,
+			union power_supply_propval *val)
+{
+	struct goldfish_battery_data *data = container_of(psy,
+		struct goldfish_battery_data, ac);
+	int ret = 0;
+
+	switch (psp) {
+	case POWER_SUPPLY_PROP_ONLINE:
+		val->intval = GOLDFISH_BATTERY_READ(data, BATTERY_AC_ONLINE);
+		break;
+	default:
+		ret = -EINVAL;
+		break;
+	}
+	return ret;
+}
+
+static int goldfish_battery_get_property(struct power_supply *psy,
+				 enum power_supply_property psp,
+				 union power_supply_propval *val)
+{
+	struct goldfish_battery_data *data = container_of(psy,
+		struct goldfish_battery_data, battery);
+	int ret = 0;
+
+	switch (psp) {
+	case POWER_SUPPLY_PROP_STATUS:
+		val->intval = GOLDFISH_BATTERY_READ(data, BATTERY_STATUS);
+		break;
+	case POWER_SUPPLY_PROP_HEALTH:
+		val->intval = GOLDFISH_BATTERY_READ(data, BATTERY_HEALTH);
+		break;
+	case POWER_SUPPLY_PROP_PRESENT:
+		val->intval = GOLDFISH_BATTERY_READ(data, BATTERY_PRESENT);
+		break;
+	case POWER_SUPPLY_PROP_TECHNOLOGY:
+		val->intval = POWER_SUPPLY_TECHNOLOGY_LION;
+		break;
+	case POWER_SUPPLY_PROP_CAPACITY:
+		val->intval = GOLDFISH_BATTERY_READ(data, BATTERY_CAPACITY);
+		break;
+	default:
+		ret = -EINVAL;
+		break;
+	}
+
+	return ret;
+}
+
+static enum power_supply_property goldfish_battery_props[] = {
+	POWER_SUPPLY_PROP_STATUS,
+	POWER_SUPPLY_PROP_HEALTH,
+	POWER_SUPPLY_PROP_PRESENT,
+	POWER_SUPPLY_PROP_TECHNOLOGY,
+	POWER_SUPPLY_PROP_CAPACITY,
+};
+
+static enum power_supply_property goldfish_ac_props[] = {
+	POWER_SUPPLY_PROP_ONLINE,
+};
+
+static irqreturn_t goldfish_battery_interrupt(int irq, void *dev_id)
+{
+	unsigned long irq_flags;
+	struct goldfish_battery_data *data = dev_id;
+	uint32_t status;
+
+	spin_lock_irqsave(&data->lock, irq_flags);
+
+	/* read status flags, which will clear the interrupt */
+	status = GOLDFISH_BATTERY_READ(data, BATTERY_INT_STATUS);
+	status &= BATTERY_INT_MASK;
+
+	if (status & BATTERY_STATUS_CHANGED)
+		power_supply_changed(&data->battery);
+	if (status & AC_STATUS_CHANGED)
+		power_supply_changed(&data->ac);
+
+	spin_unlock_irqrestore(&data->lock, irq_flags);
+	return status ? IRQ_HANDLED : IRQ_NONE;
+}
+
+
+static int goldfish_battery_probe(struct platform_device *pdev)
+{
+	int ret;
+	struct resource *r;
+	struct goldfish_battery_data *data;
+
+	data = kzalloc(sizeof(*data), GFP_KERNEL);
+	if (data == NULL) {
+		ret = -ENOMEM;
+		goto err_data_alloc_failed;
+	}
+	spin_lock_init(&data->lock);
+
+	data->battery.properties = goldfish_battery_props;
+	data->battery.num_properties = ARRAY_SIZE(goldfish_battery_props);
+	data->battery.get_property = goldfish_battery_get_property;
+	data->battery.name = "battery";
+	data->battery.type = POWER_SUPPLY_TYPE_BATTERY;
+
+	data->ac.properties = goldfish_ac_props;
+	data->ac.num_properties = ARRAY_SIZE(goldfish_ac_props);
+	data->ac.get_property = goldfish_ac_get_property;
+	data->ac.name = "ac";
+	data->ac.type = POWER_SUPPLY_TYPE_MAINS;
+
+	r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (r == NULL) {
+		pr_err("%s: platform_get_resource failed\n", pdev->name);
+		ret = -ENODEV;
+		goto err_no_io_base;
+	}
+	data->reg_base = ioremap(r->start, r->end - r->start + 1);
+	if (data->reg_base == NULL) {
+		pr_err("%s: unable to remap MMIO\n", pdev->name);
+		ret = -ENOMEM;
+		goto err_no_io_base;
+	}
+
+	data->irq = platform_get_irq(pdev, 0);
+	if (data->irq < 0) {
+		pr_err("%s: platform_get_irq failed\n", pdev->name);
+		ret = -ENODEV;
+		goto err_no_irq;
+	}
+
+	ret = request_irq(data->irq, goldfish_battery_interrupt,
+						IRQF_SHARED, pdev->name, data);
+	if (ret)
+		goto err_request_irq_failed;
+
+	ret = power_supply_register(&pdev->dev, &data->ac);
+	if (ret)
+		goto err_ac_failed;
+
+	ret = power_supply_register(&pdev->dev, &data->battery);
+	if (ret)
+		goto err_battery_failed;
+
+	platform_set_drvdata(pdev, data);
+	battery_data = data;
+
+	GOLDFISH_BATTERY_WRITE(data, BATTERY_INT_ENABLE, BATTERY_INT_MASK);
+	return 0;
+
+err_battery_failed:
+	power_supply_unregister(&data->ac);
+err_ac_failed:
+	free_irq(data->irq, data);
+err_request_irq_failed:
+err_no_irq:
+	iounmap(data->reg_base);
+err_no_io_base:
+	kfree(data);
+err_data_alloc_failed:
+	return ret;
+}
+
+static int goldfish_battery_remove(struct platform_device *pdev)
+{
+	struct goldfish_battery_data *data = platform_get_drvdata(pdev);
+
+	power_supply_unregister(&data->battery);
+	power_supply_unregister(&data->ac);
+
+	free_irq(data->irq, data);
+	iounmap(data->reg_base);
+	kfree(data);
+	battery_data = NULL;
+	return 0;
+}
+
+static struct platform_driver goldfish_battery_device = {
+	.probe		= goldfish_battery_probe,
+	.remove		= goldfish_battery_remove,
+	.driver = {
+		.name = "goldfish-battery"
+	}
+};
+
+static int __init goldfish_battery_init(void)
+{
+	return platform_driver_register(&goldfish_battery_device);
+}
+
+static void __exit goldfish_battery_exit(void)
+{
+	platform_driver_unregister(&goldfish_battery_device);
+}
+
+module_init(goldfish_battery_init);
+module_exit(goldfish_battery_exit);
+
+MODULE_AUTHOR("Mike Lockwood lockwood@android.com");
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("Battery driver for the Goldfish emulator");

