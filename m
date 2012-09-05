Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758126Ab2IEDTw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 23:19:52 -0400
Received: from db3ehsobe001.messaging.microsoft.com ([213.199.154.139]:26048
	"EHLO db3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752763Ab2IEDTt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 23:19:49 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 1
X-BigFish: VS1(zz154dMc8kzz1202h1082kzz8275bh8275dhz2dh2a8h668h839hd24he5bhf0ah107ah1155h)
From: Dong Aisheng <b29396@freescale.com>
To: <linux-kernel@vger.kernel.org>
CC: <linux-arm-kernel@lists.infradead.org>, <linus.walleij@stericsson.com>,
        <s.hauer@pengutronix.de>, <shawn.guo@linaro.org>,
        <kernel@pengutronix.de>, <grant.likely@secretlab.ca>,
        <rob.herring@calxeda.com>, <sameo@linux.intel.com>, <lrg@ti.com>,
        <broonie@opensource.wolfsonmicro.com>, <richard.zhao@freescale.com>,
        <devicetree-discuss@lists.ozlabs.org>, <swarren@wwwdotorg.org>
Subject: [PATCH v6 1/4] mfd: add syscon driver based on regmap
Date: Wed, 5 Sep 2012 10:57:13 +0800
Message-ID: <1346813836-28736-2-git-send-email-b29396@freescale.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1346813836-28736-1-git-send-email-b29396@freescale.com>
References: <1346813836-28736-1-git-send-email-b29396@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dong Aisheng <dong.aisheng@linaro.org>

Add regmap based syscon driver.
This is usually used for access misc bits in registers which does not belong
to a specific module, for example, IMX IOMUXC GPR and ANATOP.
With this driver, client can use generic regmap API to access registers
which are registered into syscon.

Reviewed-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Acked-by: Stephen Warren <swarren@wwwdotorg.org>
Signed-off-by: Dong Aisheng <dong.aisheng@linaro.org>
---
ChangeLog:
v5->v6:
 * using dev instead of &pdev->dev in probe
v4->v5:
 * depends on OF
 * do not call of_node_put in syscon_node_to_regmap
v3->v4:
 * add more description about syscon(provided by Stephen Warren) in binding doc.
 * fix a minor code indent error and remove set cache type code since the cache
   is disabled by default.
v2->v3:
 * export regmap lookup APIs including syscon_node_to_regmap
 * fix a few typo
v1->v2:
 * provide a way of retrieving the regmap, suggested by Mark Brown.
 * delete imx-syscon io accessors and using generic regmap API for client drivers.
 * change to a more generic name for other SoCs to use.
---
 Documentation/devicetree/bindings/mfd/syscon.txt |   20 +++
 drivers/mfd/Kconfig                              |    8 +
 drivers/mfd/Makefile                             |    1 +
 drivers/mfd/syscon.c                             |  176 ++++++++++++++++++++++
 include/linux/mfd/syscon.h                       |   23 +++
 5 files changed, 228 insertions(+), 0 deletions(-)

diff --git a/Documentation/devicetree/bindings/mfd/syscon.txt b/Documentation/devicetree/bindings/mfd/syscon.txt
new file mode 100644
index 0000000..fe8150b
--- /dev/null
+++ b/Documentation/devicetree/bindings/mfd/syscon.txt
@@ -0,0 +1,20 @@
+* System Controller Registers R/W driver
+
+System controller node represents a register region containing a set
+of miscellaneous registers. The registers are not cohesive enough to
+represent as any specific type of device. The typical use-case is for
+some other node's driver, or platform-specific code, to acquire a
+reference to the syscon node (e.g. by phandle, node path, or search
+using a specific compatible value), interrogate the node (or associated
+OS driver) to determine the location of the registers, and access the
+registers directly.
+
+Required properties:
+- compatible: Should contain "syscon".
+- reg: the register region can be accessed from syscon
+
+Examples:
+gpr: iomuxc-gpr@020e0000 {
+	compatible = "fsl,imx6q-iomuxc-gpr", "syscon";
+	reg = <0x020e0000 0x38>;
+};
diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index b1a1462..82247b7 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -993,6 +993,14 @@ config MFD_ANATOP
 	  MFD controller. This controller embeds regulator and
 	  thermal devices for Freescale i.MX platforms.
 
+config MFD_SYSCON
+	bool "System Controller Register R/W Based on Regmap"
+	depends on OF
+	select REGMAP_MMIO
+	help
+	  Select this option to enable accessing system control registers
+	  via regmap.
+
 config MFD_PALMAS
 	bool "Support for the TI Palmas series chips"
 	select MFD_CORE
diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
index 79dd22d..8384bc9 100644
--- a/drivers/mfd/Makefile
+++ b/drivers/mfd/Makefile
@@ -131,4 +131,5 @@ obj-$(CONFIG_MFD_PALMAS)	+= palmas.o
 obj-$(CONFIG_MFD_RC5T583)	+= rc5t583.o rc5t583-irq.o
 obj-$(CONFIG_MFD_SEC_CORE)	+= sec-core.o sec-irq.o
 obj-$(CONFIG_MFD_ANATOP)	+= anatop-mfd.o
+obj-$(CONFIG_MFD_SYSCON)	+= syscon.o
 obj-$(CONFIG_MFD_LM3533)	+= lm3533-core.o lm3533-ctrlbank.o
diff --git a/drivers/mfd/syscon.c b/drivers/mfd/syscon.c
new file mode 100644
index 0000000..65fe609
--- /dev/null
+++ b/drivers/mfd/syscon.c
@@ -0,0 +1,176 @@
+/*
+ * System Control Driver
+ *
+ * Copyright (C) 2012 Freescale Semiconductor, Inc.
+ * Copyright (C) 2012 Linaro Ltd.
+ *
+ * Author: Dong Aisheng <dong.aisheng@linaro.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#include <linux/err.h>
+#include <linux/io.h>
+#include <linux/module.h>
+#include <linux/of.h>
+#include <linux/of_address.h>
+#include <linux/of_platform.h>
+#include <linux/platform_device.h>
+#include <linux/regmap.h>
+
+static struct platform_driver syscon_driver;
+
+struct syscon {
+	struct device *dev;
+	void __iomem *base;
+	struct regmap *regmap;
+};
+
+static int syscon_match(struct device *dev, void *data)
+{
+	struct syscon *syscon = dev_get_drvdata(dev);
+	struct device_node *dn = data;
+
+	return (syscon->dev->of_node == dn) ? 1 : 0;
+}
+
+struct regmap *syscon_node_to_regmap(struct device_node *np)
+{
+	struct syscon *syscon;
+	struct device *dev;
+
+	dev = driver_find_device(&syscon_driver.driver, NULL, np,
+				 syscon_match);
+	if (!dev)
+		return ERR_PTR(-EPROBE_DEFER);
+
+	syscon = dev_get_drvdata(dev);
+
+	return syscon->regmap;
+}
+EXPORT_SYMBOL_GPL(syscon_node_to_regmap);
+
+struct regmap *syscon_regmap_lookup_by_compatible(const char *s)
+{
+	struct device_node *syscon_np;
+	struct regmap *regmap;
+
+	syscon_np = of_find_compatible_node(NULL, NULL, s);
+	if (!syscon_np)
+		return ERR_PTR(-ENODEV);
+
+	regmap = syscon_node_to_regmap(syscon_np);
+	of_node_put(syscon_np);
+
+	return regmap;
+}
+EXPORT_SYMBOL_GPL(syscon_regmap_lookup_by_compatible);
+
+struct regmap *syscon_regmap_lookup_by_phandle(struct device_node *np,
+					const char *property)
+{
+	struct device_node *syscon_np;
+	struct regmap *regmap;
+
+	syscon_np = of_parse_phandle(np, property, 0);
+	if (!syscon_np)
+		return ERR_PTR(-ENODEV);
+
+	regmap = syscon_node_to_regmap(syscon_np);
+	of_node_put(syscon_np);
+
+	return regmap;
+}
+EXPORT_SYMBOL_GPL(syscon_regmap_lookup_by_phandle);
+
+static const struct of_device_id of_syscon_match[] = {
+	{ .compatible = "syscon", },
+	{ },
+};
+
+static struct regmap_config syscon_regmap_config = {
+	.reg_bits = 32,
+	.val_bits = 32,
+	.reg_stride = 4,
+};
+
+static int __devinit syscon_probe(struct platform_device *pdev)
+{
+	struct device *dev = &pdev->dev;
+	struct device_node *np = dev->of_node;
+	struct syscon *syscon;
+	struct resource res;
+	int ret;
+
+	if (!np)
+		return -ENOENT;
+
+	syscon = devm_kzalloc(dev, sizeof(struct syscon),
+			    GFP_KERNEL);
+	if (!syscon)
+		return -ENOMEM;
+
+	syscon->base = of_iomap(np, 0);
+	if (!syscon->base)
+		return -EADDRNOTAVAIL;
+
+	ret = of_address_to_resource(np, 0, &res);
+	if (ret)
+		return ret;
+
+	syscon_regmap_config.max_register = res.end - res.start - 3;
+	syscon->regmap = devm_regmap_init_mmio(dev, syscon->base,
+					&syscon_regmap_config);
+	if (IS_ERR(syscon->regmap)) {
+		dev_err(dev, "regmap init failed\n");
+		return PTR_ERR(syscon->regmap);
+	}
+
+	syscon->dev = dev;
+	platform_set_drvdata(pdev, syscon);
+
+	dev_info(dev, "syscon regmap start 0x%x end 0x%x registered\n",
+		res.start, res.end);
+
+	return 0;
+}
+
+static int __devexit syscon_remove(struct platform_device *pdev)
+{
+	struct syscon *syscon;
+
+	syscon = platform_get_drvdata(pdev);
+	iounmap(syscon->base);
+	platform_set_drvdata(pdev, NULL);
+
+	return 0;
+}
+
+static struct platform_driver syscon_driver = {
+	.driver = {
+		.name = "syscon",
+		.owner = THIS_MODULE,
+		.of_match_table = of_syscon_match,
+	},
+	.probe		= syscon_probe,
+	.remove		= __devexit_p(syscon_remove),
+};
+
+static int __init syscon_init(void)
+{
+	return platform_driver_register(&syscon_driver);
+}
+postcore_initcall(syscon_init);
+
+static void __exit syscon_exit(void)
+{
+	platform_driver_unregister(&syscon_driver);
+}
+module_exit(syscon_exit);
+
+MODULE_AUTHOR("Dong Aisheng <dong.aisheng@linaro.org>");
+MODULE_DESCRIPTION("System Control driver");
+MODULE_LICENSE("GPL v2");
diff --git a/include/linux/mfd/syscon.h b/include/linux/mfd/syscon.h
new file mode 100644
index 0000000..6aeb6b8
--- /dev/null
+++ b/include/linux/mfd/syscon.h
@@ -0,0 +1,23 @@
+/*
+ * System Control Driver
+ *
+ * Copyright (C) 2012 Freescale Semiconductor, Inc.
+ * Copyright (C) 2012 Linaro Ltd.
+ *
+ * Author: Dong Aisheng <dong.aisheng@linaro.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#ifndef __LINUX_MFD_SYSCON_H__
+#define __LINUX_MFD_SYSCON_H__
+
+extern struct regmap *syscon_node_to_regmap(struct device_node *np);
+extern struct regmap *syscon_regmap_lookup_by_compatible(const char *s);
+extern struct regmap *syscon_regmap_lookup_by_phandle(
+					struct device_node *np,
+					const char *property);
+#endif /* __LINUX_MFD_SYSCON_H__ */
-- 
1.7.0.4


