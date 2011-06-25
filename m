Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751713Ab1FYQvi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jun 2011 12:51:38 -0400
Received: from queueout04-winn.ispmail.ntl.com ([81.103.221.58]:32939 "EHLO
	queueout04-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750767Ab1FYQvg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jun 2011 12:51:36 -0400
From: Daniel Drake <dsd@laptop.org>
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, dilinger@queued.net, bigeasy@linutronix.de,
        Daniel Drake <dsd@laptop.org>
Subject: [PATCH v3 03/11] x86, olpc: rename olpc-xo1 to olpc-xo1-pm
Date: Sat, 25 Jun 2011 17:34:10 +0100
Message-Id: <1309019658-1712-4-git-send-email-dsd@laptop.org>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1309019658-1712-1-git-send-email-dsd@laptop.org>
References: <1309019658-1712-1-git-send-email-dsd@laptop.org>
X-Cloudmark-Analysis: v=1.1 cv=R50lirqlHffDPPkwUlkuVa99MrvKdVWo//yz83qex8g= c=1 sm=0 a=lWwq-9n7KFoA:10 a=vJ1w_8FsMGIA:10 a=Op-mwl0xAAAA:8 a=In_Hgl4hAAAA:8 a=eXKRGl7jy5qYCweTZY8A:9 a=savmviVp9HIPsiQRVCoA:7 a=d4CUUju0HPYA:10 a=ro211Ng2IWAA:10 a=HpAAvcLHHh0Zw7uRqdWCyQ==:117
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Based on earlier review comments, we'll no longer try to stick all of
our XO-1 goodies in a single driver. We'll split it into a power management
driver, and an EC/SCI driver.

As a first step, rename olpc-xo1 to olpc-xo1-pm, and make it builtin
instead of modular.

Signed-off-by: Daniel Drake <dsd@laptop.org>
Acked-by: Andres Salomon <dilinger@queued.net>
---
 arch/x86/Kconfig                     |    7 +-
 arch/x86/platform/olpc/Makefile      |    2 +-
 arch/x86/platform/olpc/olpc-xo1-pm.c |  123 ++++++++++++++++++++++++++++++
 arch/x86/platform/olpc/olpc-xo1.c    |  136 ----------------------------------
 4 files changed, 128 insertions(+), 140 deletions(-)
 create mode 100644 arch/x86/platform/olpc/olpc-xo1-pm.c
 delete mode 100644 arch/x86/platform/olpc/olpc-xo1.c

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 26a14b4..e7851be 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -2075,11 +2075,12 @@ config OLPC
 	  Add support for detecting the unique features of the OLPC
 	  XO hardware.
 
-config OLPC_XO1
-	tristate "OLPC XO-1 support"
+config OLPC_XO1_PM
+	bool "OLPC XO-1 Power Management"
 	depends on OLPC && MFD_CS5535
+	select MFD_CORE
 	---help---
-	  Add support for non-essential features of the OLPC XO-1 laptop.
+	  Add support for poweroff of the OLPC XO-1 laptop.
 
 endif # X86_32
 
diff --git a/arch/x86/platform/olpc/Makefile b/arch/x86/platform/olpc/Makefile
index 81c5e21..cd25038 100644
--- a/arch/x86/platform/olpc/Makefile
+++ b/arch/x86/platform/olpc/Makefile
@@ -1,2 +1,2 @@
 obj-$(CONFIG_OLPC)		+= olpc.o olpc_ofw.o olpc_dt.o
-obj-$(CONFIG_OLPC_XO1)		+= olpc-xo1.o
+obj-$(CONFIG_OLPC_XO1_PM)		+= olpc-xo1-pm.o
diff --git a/arch/x86/platform/olpc/olpc-xo1-pm.c b/arch/x86/platform/olpc/olpc-xo1-pm.c
new file mode 100644
index 0000000..a2a59d3
--- /dev/null
+++ b/arch/x86/platform/olpc/olpc-xo1-pm.c
@@ -0,0 +1,123 @@
+/*
+ * Support for power management features of the OLPC XO-1 laptop
+ *
+ * Copyright (C) 2010 Andres Salomon <dilinger@queued.net>
+ * Copyright (C) 2010 One Laptop per Child
+ * Copyright (C) 2006 Red Hat, Inc.
+ * Copyright (C) 2006 Advanced Micro Devices, Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#include <linux/cs5535.h>
+#include <linux/platform_device.h>
+#include <linux/pm.h>
+#include <linux/mfd/core.h>
+
+#include <asm/io.h>
+#include <asm/olpc.h>
+
+#define DRV_NAME "olpc-xo1-pm"
+
+static unsigned long acpi_base;
+static unsigned long pms_base;
+
+static void xo1_power_off(void)
+{
+	printk(KERN_INFO "OLPC XO-1 power off sequence...\n");
+
+	/* Enable all of these controls with 0 delay */
+	outl(0x40000000, pms_base + CS5536_PM_SCLK);
+	outl(0x40000000, pms_base + CS5536_PM_IN_SLPCTL);
+	outl(0x40000000, pms_base + CS5536_PM_WKXD);
+	outl(0x40000000, pms_base + CS5536_PM_WKD);
+
+	/* Clear status bits (possibly unnecessary) */
+	outl(0x0002ffff, pms_base  + CS5536_PM_SSC);
+	outl(0xffffffff, acpi_base + CS5536_PM_GPE0_STS);
+
+	/* Write SLP_EN bit to start the machinery */
+	outl(0x00002000, acpi_base + CS5536_PM1_CNT);
+}
+
+static int __devinit xo1_pm_probe(struct platform_device *pdev)
+{
+	struct resource *res;
+	int err;
+
+	/* don't run on non-XOs */
+	if (!machine_is_olpc())
+		return -ENODEV;
+
+	err = mfd_cell_enable(pdev);
+	if (err)
+		return err;
+
+	res = platform_get_resource(pdev, IORESOURCE_IO, 0);
+	if (!res) {
+		dev_err(&pdev->dev, "can't fetch device resource info\n");
+		return -EIO;
+	}
+	if (strcmp(pdev->name, "cs5535-pms") == 0)
+		pms_base = res->start;
+	else if (strcmp(pdev->name, "olpc-xo1-pm-acpi") == 0)
+		acpi_base = res->start;
+
+	/* If we have both addresses, we can override the poweroff hook */
+	if (pms_base && acpi_base) {
+		pm_power_off = xo1_power_off;
+		printk(KERN_INFO "OLPC XO-1 support registered\n");
+	}
+
+	return 0;
+}
+
+static int __devexit xo1_pm_remove(struct platform_device *pdev)
+{
+	mfd_cell_disable(pdev);
+
+	if (strcmp(pdev->name, "cs5535-pms") == 0)
+		pms_base = 0;
+	else if (strcmp(pdev->name, "olpc-xo1-pm-acpi") == 0)
+		acpi_base = 0;
+
+	pm_power_off = NULL;
+	return 0;
+}
+
+static struct platform_driver cs5535_pms_driver = {
+	.driver = {
+		.name = "cs5535-pms",
+		.owner = THIS_MODULE,
+	},
+	.probe = xo1_pm_probe,
+	.remove = __devexit_p(xo1_pm_remove),
+};
+
+static struct platform_driver cs5535_acpi_driver = {
+	.driver = {
+		.name = "olpc-xo1-pm-acpi",
+		.owner = THIS_MODULE,
+	},
+	.probe = xo1_pm_probe,
+	.remove = __devexit_p(xo1_pm_remove),
+};
+
+static int __init xo1_pm_init(void)
+{
+	int r;
+
+	r = platform_driver_register(&cs5535_pms_driver);
+	if (r)
+		return r;
+
+	r = platform_driver_register(&cs5535_acpi_driver);
+	if (r)
+		platform_driver_unregister(&cs5535_pms_driver);
+
+	return r;
+}
+arch_initcall(xo1_pm_init);
diff --git a/arch/x86/platform/olpc/olpc-xo1.c b/arch/x86/platform/olpc/olpc-xo1.c
deleted file mode 100644
index a63e948..0000000
--- a/arch/x86/platform/olpc/olpc-xo1.c
+++ /dev/null
@@ -1,136 +0,0 @@
-/*
- * Support for features of the OLPC XO-1 laptop
- *
- * Copyright (C) 2010 Andres Salomon <dilinger@queued.net>
- * Copyright (C) 2010 One Laptop per Child
- * Copyright (C) 2006 Red Hat, Inc.
- * Copyright (C) 2006 Advanced Micro Devices, Inc.
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- */
-
-#include <linux/cs5535.h>
-#include <linux/module.h>
-#include <linux/platform_device.h>
-#include <linux/pm.h>
-#include <linux/mfd/core.h>
-
-#include <asm/io.h>
-#include <asm/olpc.h>
-
-#define DRV_NAME "olpc-xo1"
-
-static unsigned long acpi_base;
-static unsigned long pms_base;
-
-static void xo1_power_off(void)
-{
-	printk(KERN_INFO "OLPC XO-1 power off sequence...\n");
-
-	/* Enable all of these controls with 0 delay */
-	outl(0x40000000, pms_base + CS5536_PM_SCLK);
-	outl(0x40000000, pms_base + CS5536_PM_IN_SLPCTL);
-	outl(0x40000000, pms_base + CS5536_PM_WKXD);
-	outl(0x40000000, pms_base + CS5536_PM_WKD);
-
-	/* Clear status bits (possibly unnecessary) */
-	outl(0x0002ffff, pms_base  + CS5536_PM_SSC);
-	outl(0xffffffff, acpi_base + CS5536_PM_GPE0_STS);
-
-	/* Write SLP_EN bit to start the machinery */
-	outl(0x00002000, acpi_base + CS5536_PM1_CNT);
-}
-
-static int __devinit olpc_xo1_probe(struct platform_device *pdev)
-{
-	struct resource *res;
-	int err;
-
-	/* don't run on non-XOs */
-	if (!machine_is_olpc())
-		return -ENODEV;
-
-	err = mfd_cell_enable(pdev);
-	if (err)
-		return err;
-
-	res = platform_get_resource(pdev, IORESOURCE_IO, 0);
-	if (!res) {
-		dev_err(&pdev->dev, "can't fetch device resource info\n");
-		return -EIO;
-	}
-	if (strcmp(pdev->name, "cs5535-pms") == 0)
-		pms_base = res->start;
-	else if (strcmp(pdev->name, "olpc-xo1-pm-acpi") == 0)
-		acpi_base = res->start;
-
-	/* If we have both addresses, we can override the poweroff hook */
-	if (pms_base && acpi_base) {
-		pm_power_off = xo1_power_off;
-		printk(KERN_INFO "OLPC XO-1 support registered\n");
-	}
-
-	return 0;
-}
-
-static int __devexit olpc_xo1_remove(struct platform_device *pdev)
-{
-	mfd_cell_disable(pdev);
-
-	if (strcmp(pdev->name, "cs5535-pms") == 0)
-		pms_base = 0;
-	else if (strcmp(pdev->name, "olpc-xo1-pm-acpi") == 0)
-		acpi_base = 0;
-
-	pm_power_off = NULL;
-	return 0;
-}
-
-static struct platform_driver cs5535_pms_drv = {
-	.driver = {
-		.name = "cs5535-pms",
-		.owner = THIS_MODULE,
-	},
-	.probe = olpc_xo1_probe,
-	.remove = __devexit_p(olpc_xo1_remove),
-};
-
-static struct platform_driver cs5535_acpi_drv = {
-	.driver = {
-		.name = "olpc-xo1-pm-acpi",
-		.owner = THIS_MODULE,
-	},
-	.probe = olpc_xo1_probe,
-	.remove = __devexit_p(olpc_xo1_remove),
-};
-
-static int __init olpc_xo1_init(void)
-{
-	int r;
-
-	r = platform_driver_register(&cs5535_pms_drv);
-	if (r)
-		return r;
-
-	r = platform_driver_register(&cs5535_acpi_drv);
-	if (r)
-		platform_driver_unregister(&cs5535_pms_drv);
-
-	return r;
-}
-
-static void __exit olpc_xo1_exit(void)
-{
-	platform_driver_unregister(&cs5535_acpi_drv);
-	platform_driver_unregister(&cs5535_pms_drv);
-}
-
-MODULE_AUTHOR("Daniel Drake <dsd@laptop.org>");
-MODULE_LICENSE("GPL");
-MODULE_ALIAS("platform:cs5535-pms");
-
-module_init(olpc_xo1_init);
-module_exit(olpc_xo1_exit);
-- 
1.7.5.4

