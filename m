Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758759Ab2CAJLj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 04:11:39 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:33819 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758715Ab2CAJLb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 04:11:31 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of paul.liu@linaro.org designates 10.68.216.7 as permitted sender) smtp.mail=paul.liu@linaro.org
MIME-Version: 1.0
From: "Ying-Chun Liu (PaulLiu)" <paul.liu@linaro.org>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, linaro-dev@lists.linaro.org,
        patches@linaro.org, "Ying-Chun Liu (PaulLiu)" <paul.liu@linaro.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Shawn Guo <shawn.guo@linaro.org>
Subject: [PATCH v5 1/2] mfd: Add anatop mfd driver
Date: Thu,  1 Mar 2012 17:10:51 +0800
Message-Id: <1330593052-15184-1-git-send-email-paul.liu@linaro.org>
X-Mailer: git-send-email 1.7.9
In-Reply-To: <1328734286-30091-1-git-send-email-paul.liu@linaro.org>
References: <1328734286-30091-1-git-send-email-paul.liu@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Ying-Chun Liu (PaulLiu)" <paul.liu@linaro.org>

Anatop is a mfd chip embedded in Freescale i.MX6Q SoC.
Anatop provides regulators and thermal.
This driver handles the address space and the operation of the mfd device.

Signed-off-by: Ying-Chun Liu (PaulLiu) <paul.liu@linaro.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Shawn Guo <shawn.guo@linaro.org>
---
 drivers/mfd/Kconfig        |    6 ++
 drivers/mfd/Makefile       |    1 +
 drivers/mfd/anatop-mfd.c   |  144 ++++++++++++++++++++++++++++++++++++++++++++
 include/linux/mfd/anatop.h |   40 ++++++++++++
 4 files changed, 191 insertions(+), 0 deletions(-)
 create mode 100644 drivers/mfd/anatop-mfd.c
 create mode 100644 include/linux/mfd/anatop.h

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index f147395..f787d17 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -830,6 +830,12 @@ config MFD_INTEL_MSIC
 	  Passage) chip. This chip embeds audio, battery, GPIO, etc.
 	  devices used in Intel Medfield platforms.
 
+config MFD_ANATOP
+        bool "Support for Anatop"
+	depends on SOC_IMX6Q
+	help
+	  Select this option to enable Anatop MFD driver.
+
 endmenu
 endif
 
diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
index b953bab..8e11060 100644
--- a/drivers/mfd/Makefile
+++ b/drivers/mfd/Makefile
@@ -112,3 +112,4 @@ obj-$(CONFIG_TPS65911_COMPARATOR)	+= tps65911-comparator.o
 obj-$(CONFIG_MFD_AAT2870_CORE)	+= aat2870-core.o
 obj-$(CONFIG_MFD_INTEL_MSIC)	+= intel_msic.o
 obj-$(CONFIG_MFD_S5M_CORE)	+= s5m-core.o s5m-irq.o
+obj-$(CONFIG_MFD_ANATOP)	+= anatop-mfd.o
diff --git a/drivers/mfd/anatop-mfd.c b/drivers/mfd/anatop-mfd.c
new file mode 100644
index 0000000..86e2b8e
--- /dev/null
+++ b/drivers/mfd/anatop-mfd.c
@@ -0,0 +1,144 @@
+/*
+ * Anatop MFD driver
+ *
+ * Copyright (C) 2012 Ying-Chun Liu (PaulLiu) <paul.liu@linaro.org>
+ * Copyright (C) 2012 Linaro
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; either version 2 of the License, or
+ *   (at your option) any later version.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License along
+ *  with this program; if not, write to the Free Software Foundation, Inc.,
+ *  51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; either version 2 of the License, or
+ *  (at your option) any later version.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License along
+ *  with this program; if not, write to the Free Software Foundation, Inc.,
+ *  51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
+ *
+ */
+
+#include <linux/io.h>
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/of.h>
+#include <linux/of_platform.h>
+#include <linux/of_address.h>
+#include <linux/mfd/anatop.h>
+
+u32 anatop_get_bits(struct anatop *adata, u32 addr, int bit_shift, int bits)
+{
+	u32 val;
+	int mask;
+
+	if (bits == 32)
+		mask = ~0;
+	else
+		mask = (1 << bits) - 1;
+
+	spin_lock(&adata->reglock);
+	val = readl(adata->ioreg + addr);
+	spin_unlock(&adata->reglock);
+	val = (val >> bit_shift) & mask;
+
+	return val;
+}
+EXPORT_SYMBOL(anatop_get_bits);
+
+void anatop_set_bits(struct anatop *adata, u32 addr, int bit_shift,
+		     int bits, u32 data)
+{
+	u32 val;
+	int mask;
+	if (bits == 32)
+		mask = ~0;
+	else
+		mask = (1 << bits) - 1;
+
+	spin_lock(&adata->reglock);
+	val = readl(adata->ioreg + addr) & ~(mask << bit_shift);
+	writel((data << bit_shift) | val, adata->ioreg);
+	spin_unlock(&adata->reglock);
+}
+EXPORT_SYMBOL(anatop_set_bits);
+
+static const struct of_device_id of_anatop_subdevice_match[] = {
+	{ .compatible = "fsl,anatop-regulator", },
+	{ .compatible = "fsl,anatop-thermal", },
+	{ },
+};
+
+static int of_anatop_probe(struct platform_device *pdev)
+{
+	struct device *dev = &pdev->dev;
+	struct device_node *np = dev->of_node;
+	void *ioreg;
+	struct anatop *drvdata;
+
+	ioreg = of_iomap(np, 0);
+	if (!ioreg)
+		return -EINVAL;
+	drvdata = devm_kzalloc(dev, sizeof(struct anatop), GFP_KERNEL);
+	if (!drvdata)
+		return -EINVAL;
+	drvdata->ioreg = ioreg;
+	spin_lock_init(&drvdata->reglock);
+	platform_set_drvdata(pdev, drvdata);
+	of_platform_bus_probe(np, of_anatop_subdevice_match, dev);
+
+	return 0;
+}
+
+static int of_anatop_remove(struct platform_device *pdev)
+{
+	struct anatop *drvdata;
+	drvdata = platform_get_drvdata(pdev);
+	iounmap(drvdata->ioreg);
+	return 0;
+}
+
+static const struct of_device_id of_anatop_match[] = {
+	{ .compatible = "fsl,imx6q-anatop", },
+	{ },
+};
+
+static struct platform_driver anatop_of_driver = {
+	.driver = {
+		.name = "anatop-mfd",
+		.owner = THIS_MODULE,
+		.of_match_table = of_anatop_match,
+	},
+	.probe		= of_anatop_probe,
+	.remove		= of_anatop_remove,
+};
+
+static int __init anatop_init(void)
+{
+	return platform_driver_register(&anatop_of_driver);
+}
+postcore_initcall(anatop_init);
+
+static void __exit anatop_exit(void)
+{
+	platform_driver_unregister(&anatop_of_driver);
+}
+module_exit(anatop_exit);
+
+MODULE_AUTHOR("Ying-Chun Liu (PaulLiu) <paul.liu@linaro.org>");
+MODULE_DESCRIPTION("ANATOP MFD driver");
+MODULE_LICENSE("GPL v2");
diff --git a/include/linux/mfd/anatop.h b/include/linux/mfd/anatop.h
new file mode 100644
index 0000000..22c1007
--- /dev/null
+++ b/include/linux/mfd/anatop.h
@@ -0,0 +1,40 @@
+/*
+ * anatop.h - Anatop MFD driver
+ *
+ *  Copyright (C) 2012 Ying-Chun Liu (PaulLiu) <paul.liu@linaro.org>
+ *  Copyright (C) 2012 Linaro
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
+#ifndef __LINUX_MFD_ANATOP_H
+#define __LINUX_MFD_ANATOP_H
+
+#include <linux/spinlock.h>
+
+/**
+ * anatop - MFD data
+ * @ioreg: ioremap register
+ * @reglock: spinlock for register read/write
+ */
+struct anatop {
+	void *ioreg;
+	spinlock_t reglock;
+};
+
+extern u32 anatop_get_bits(struct anatop *, u32, int, int);
+extern void anatop_set_bits(struct anatop *, u32, int, int, u32);
+
+#endif /*  __LINUX_MFD_ANATOP_H */
-- 
1.7.9

