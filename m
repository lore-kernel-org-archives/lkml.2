Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758481Ab2K0ItX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 03:49:23 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:51803 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758334Ab2K0ItV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 03:49:21 -0500
From: "Philip, Avinash" <avinashphilip@ti.com>
To: <thierry.reding@avionic-design.de>, <paul@pwsan.com>, <tony@atomide.com>,
        <linux@arm.linux.org.uk>, <b-cousson@ti.com>
CC: <hvaibhav@ti.com>, <anilkumar@ti.com>, <linux-kernel@vger.kernel.org>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <nsekhar@ti.com>, <gururaja.hebbar@ti.com>, <vaibhav.bedia@ti.com>,
        "Philip, Avinash" <avinashphilip@ti.com>
Subject: [PATCH v5 01/12] PWMSS: Add PWM Subsystem driver for parent<->child relationship
Date: Tue, 27 Nov 2012 14:18:06 +0530
Message-ID: <1354006097-25895-2-git-send-email-avinashphilip@ti.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1354006097-25895-1-git-send-email-avinashphilip@ti.com>
References: <1354006097-25895-1-git-send-email-avinashphilip@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In some platforms (like am33xx), PWM sub modules (ECAP, EHRPWM, EQEP)
are integrated to PWM subsystem. These PWM submodules has resources
shared and only one register bit-field is provided to control
module/clock enable/disable, makes it difficult to handle common
resources from independent PWMSS submodule drivers.

So the solution here implemented in this patch is, to create driver for
PWMSS and take the role of parent driver for PWM submodules. PWMSS
parent driver enumerates all the child nodes under PWMSS module. Also
symbol "pwmss_submodule_state_change" exported to enable clock gating
for individual PWMSS submodules, and submodule drivers has to enable
clock gating from their drivers.

As this is only supported during DT boot, the parent<->child relationship
is created and populated in DT execution flow. The only required change
is inside DTS file, making EHRPWM & ECAP as a child to PWMSS node.

Signed-off-by: Philip, Avinash <avinashphilip@ti.com>
---
Changes since v4:
        - Made dt match property in single line for consistency
	- Use SIMPLE_DEV_PM_OPS

Changes since v3:
	- Corrected the usage of ranges property in documentation.
	- Add pwm prefix to tipwmss.h file

Changes since v2:
	- Set build attribute to bool type.
	- Add pwm prefix to tipwmss.c file
	- Span mutex protection for read modify approach.
	- Use SET_SYSTEM_SLEEP_PM_OPS
	- Add PWM subsystem bit fields to tipwmss.h
	- Remove devinit & devexit attributes.
	- Left out adding of child node's DT property in Documentation
	  as those definitions are part of later patches.

Changes since v1:
	- Add conditional check for PWM subsystem clock enabling.
	- Add context save/restore for PWM subsystem clock config register.

 .../devicetree/bindings/pwm/pwm-tipwmss.txt        |   31 +++++
 drivers/pwm/Kconfig                                |   11 ++
 drivers/pwm/Makefile                               |    1 +
 drivers/pwm/pwm-tipwmss.c                          |  139 ++++++++++++++++++++
 drivers/pwm/pwm-tipwmss.h                          |   39 ++++++
 5 files changed, 221 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/pwm/pwm-tipwmss.txt
 create mode 100644 drivers/pwm/pwm-tipwmss.c
 create mode 100644 drivers/pwm/pwm-tipwmss.h

diff --git a/Documentation/devicetree/bindings/pwm/pwm-tipwmss.txt b/Documentation/devicetree/bindings/pwm/pwm-tipwmss.txt
new file mode 100644
index 0000000..f7eae77
--- /dev/null
+++ b/Documentation/devicetree/bindings/pwm/pwm-tipwmss.txt
@@ -0,0 +1,31 @@
+TI SOC based PWM Subsystem
+
+Required properties:
+- compatible: Must be "ti,am33xx-pwmss";
+- reg: physical base address and size of the registers map.
+- address-cells: Specify the number of u32 entries needed in child nodes.
+		  Should set to 1.
+- size-cells: specify number of u32 entries needed to specify child nodes size
+		in reg property. Should set to 1.
+- ranges: describes the address mapping of a memory-mapped bus. Should set to
+	   physical address map of child's base address, physical address within
+	   parent's address  space and length of the address map. For am33xx,
+	   3 set of child register maps present, ECAP register space, EQEP
+	   register space, EHRPWM register space.
+
+Also child nodes should also populated under PWMSS DT node.
+
+Example:
+pwmss0: pwmss@48300000 {
+	compatible = "ti,am33xx-pwmss";
+	reg = <0x48300000 0x10>;
+	ti,hwmods = "epwmss0";
+	#address-cells = <1>;
+	#size-cells = <1>;
+	status = "disabled";
+	ranges = <0x48300100 0x48300100 0x80   /* ECAP */
+		  0x48300180 0x48300180 0x80   /* EQEP */
+		  0x48300200 0x48300200 0x80>; /* EHRPWM */
+
+	/* child nodes go here */
+};
diff --git a/drivers/pwm/Kconfig b/drivers/pwm/Kconfig
index ed81720..1dc32a8 100644
--- a/drivers/pwm/Kconfig
+++ b/drivers/pwm/Kconfig
@@ -125,6 +125,7 @@ config PWM_TEGRA
 config  PWM_TIECAP
 	tristate "ECAP PWM support"
 	depends on SOC_AM33XX
+	select PWM_TIPWMSS
 	help
 	  PWM driver support for the ECAP APWM controller found on AM33XX
 	  TI SOC
@@ -135,6 +136,7 @@ config  PWM_TIECAP
 config  PWM_TIEHRPWM
 	tristate "EHRPWM PWM support"
 	depends on SOC_AM33XX
+	select PWM_TIPWMSS
 	help
 	  PWM driver support for the EHRPWM controller found on AM33XX
 	  TI SOC
@@ -142,6 +144,15 @@ config  PWM_TIEHRPWM
 	  To compile this driver as a module, choose M here: the module
 	  will be called pwm-tiehrpwm.
 
+config  PWM_TIPWMSS
+	bool
+	depends on SOC_AM33XX && (PWM_TIEHRPWM || PWM_TIECAP)
+	help
+	  PWM Subsystem driver support for AM33xx SOC.
+
+	  PWM submodules require PWM config space access from submodule
+	  drivers and require common parent driver support.
+
 config PWM_TWL6030
 	tristate "TWL6030 PWM support"
 	depends on TWL4030_CORE
diff --git a/drivers/pwm/Makefile b/drivers/pwm/Makefile
index acfe482..e12b722 100644
--- a/drivers/pwm/Makefile
+++ b/drivers/pwm/Makefile
@@ -11,5 +11,6 @@ obj-$(CONFIG_PWM_SAMSUNG)	+= pwm-samsung.o
 obj-$(CONFIG_PWM_TEGRA)		+= pwm-tegra.o
 obj-$(CONFIG_PWM_TIECAP)	+= pwm-tiecap.o
 obj-$(CONFIG_PWM_TIEHRPWM)	+= pwm-tiehrpwm.o
+obj-$(CONFIG_PWM_TIPWMSS)	+= pwm-tipwmss.o
 obj-$(CONFIG_PWM_TWL6030)	+= pwm-twl6030.o
 obj-$(CONFIG_PWM_VT8500)	+= pwm-vt8500.o
diff --git a/drivers/pwm/pwm-tipwmss.c b/drivers/pwm/pwm-tipwmss.c
new file mode 100644
index 0000000..3448a1c
--- /dev/null
+++ b/drivers/pwm/pwm-tipwmss.c
@@ -0,0 +1,139 @@
+/*
+ * TI PWM Subsystem driver
+ *
+ * Copyright (C) 2012 Texas Instruments Incorporated - http://www.ti.com/
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
+ * GNU General Public License for more details.
+ *
+ */
+
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/io.h>
+#include <linux/err.h>
+#include <linux/pm_runtime.h>
+#include <linux/of_device.h>
+
+#include "pwm-tipwmss.h"
+
+#define PWMSS_CLKCONFIG		0x8	/* Clock gating reg */
+#define PWMSS_CLKSTATUS		0xc	/* Clock gating status reg */
+
+struct pwmss_info {
+	void __iomem	*mmio_base;
+	struct mutex	pwmss_lock;
+	u16		pwmss_clkconfig;
+};
+
+u16 pwmss_submodule_state_change(struct device *dev, int set)
+{
+	struct pwmss_info *info = dev_get_drvdata(dev);
+	u16 val;
+
+	mutex_lock(&info->pwmss_lock);
+	val = readw(info->mmio_base + PWMSS_CLKCONFIG);
+	val |= set;
+	writew(val , info->mmio_base + PWMSS_CLKCONFIG);
+	mutex_unlock(&info->pwmss_lock);
+
+	return readw(info->mmio_base + PWMSS_CLKSTATUS);
+}
+EXPORT_SYMBOL(pwmss_submodule_state_change);
+
+static const struct of_device_id pwmss_of_match[] = {
+	{ .compatible	= "ti,am33xx-pwmss" },
+	{},
+};
+MODULE_DEVICE_TABLE(of, pwmss_of_match);
+
+static int pwmss_probe(struct platform_device *pdev)
+{
+	int ret;
+	struct resource *r;
+	struct pwmss_info *info;
+	struct device_node *node = pdev->dev.of_node;
+
+	info = devm_kzalloc(&pdev->dev, sizeof(*info), GFP_KERNEL);
+	if (!info) {
+		dev_err(&pdev->dev, "failed to allocate memory\n");
+		return -ENOMEM;
+	}
+
+	mutex_init(&info->pwmss_lock);
+
+	r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!r) {
+		dev_err(&pdev->dev, "no memory resource defined\n");
+		return -ENODEV;
+	}
+
+	info->mmio_base = devm_request_and_ioremap(&pdev->dev, r);
+	if (!info->mmio_base)
+		return -EADDRNOTAVAIL;
+
+	pm_runtime_enable(&pdev->dev);
+	pm_runtime_get_sync(&pdev->dev);
+	platform_set_drvdata(pdev, info);
+
+	/* Populate all the child nodes here... */
+	ret = of_platform_populate(node, NULL, NULL, &pdev->dev);
+	if (ret)
+		dev_err(&pdev->dev, "no child node found\n");
+
+	return ret;
+}
+
+static int pwmss_remove(struct platform_device *pdev)
+{
+	struct pwmss_info *info = platform_get_drvdata(pdev);
+
+	pm_runtime_put_sync(&pdev->dev);
+	pm_runtime_disable(&pdev->dev);
+	mutex_destroy(&info->pwmss_lock);
+	return 0;
+}
+
+static int pwmss_suspend(struct device *dev)
+{
+	struct pwmss_info *info = dev_get_drvdata(dev);
+
+	info->pwmss_clkconfig = readw(info->mmio_base + PWMSS_CLKCONFIG);
+	pm_runtime_put_sync(dev);
+	return 0;
+}
+
+static int pwmss_resume(struct device *dev)
+{
+	struct pwmss_info *info = dev_get_drvdata(dev);
+
+	pm_runtime_get_sync(dev);
+	writew(info->pwmss_clkconfig, info->mmio_base + PWMSS_CLKCONFIG);
+	return 0;
+}
+
+static SIMPLE_DEV_PM_OPS(pwmss_pm_ops, pwmss_suspend, pwmss_resume);
+
+static struct platform_driver pwmss_driver = {
+	.driver	= {
+		.name	= "pwmss",
+		.owner	= THIS_MODULE,
+		.pm	= &pwmss_pm_ops,
+		.of_match_table	= pwmss_of_match,
+	},
+	.probe	= pwmss_probe,
+	.remove	= pwmss_remove,
+};
+
+module_platform_driver(pwmss_driver);
+
+MODULE_DESCRIPTION("PWM Subsystem driver");
+MODULE_AUTHOR("Texas Instruments");
+MODULE_LICENSE("GPL");
diff --git a/drivers/pwm/pwm-tipwmss.h b/drivers/pwm/pwm-tipwmss.h
new file mode 100644
index 0000000..11f76a1
--- /dev/null
+++ b/drivers/pwm/pwm-tipwmss.h
@@ -0,0 +1,39 @@
+/*
+ * TI PWM Subsystem driver
+ *
+ * Copyright (C) 2012 Texas Instruments Incorporated - http://www.ti.com/
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
+ * GNU General Public License for more details.
+ *
+ */
+
+#ifndef __TIPWMSS_H
+#define __TIPWMSS_H
+
+#ifdef CONFIG_PWM_TIPWMSS
+/* PWM substem clock gating */
+#define PWMSS_ECAPCLK_EN	BIT(0)
+#define PWMSS_ECAPCLK_STOP_REQ	BIT(1)
+#define PWMSS_EPWMCLK_EN	BIT(8)
+#define PWMSS_EPWMCLK_STOP_REQ	BIT(9)
+
+#define PWMSS_ECAPCLK_EN_ACK	BIT(0)
+#define PWMSS_EPWMCLK_EN_ACK	BIT(8)
+
+extern u16 pwmss_submodule_state_change(struct device *dev, int set);
+#else
+static inline u16 pwmss_submodule_state_change(struct device *dev, int set)
+{
+	/* return success status value */
+	return 0xFFFF;
+}
+#endif
+#endif	/* __TIPWMSS_H */
-- 
1.7.0.4

