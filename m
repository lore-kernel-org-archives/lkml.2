Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756835Ab1DGAEa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 20:04:30 -0400
Received: from na3sys009aog112.obsmtp.com ([74.125.149.207]:40783 "EHLO
	na3sys009aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757134Ab1DGACs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 20:02:48 -0400
From: Kevin Hilman <khilman@ti.com>
To: linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        linux-sh@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Magnus Damm <magnus.damm@gmail.com>,
        "Rafael J. Wysocki" <rjw@suse.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Greg Kroah-Hartman <gregkh@suse.de>, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: [PATCH/RFC 2/6] OMAP2+: PM: move runtime PM implementation to use device power domains
Date: Wed,  6 Apr 2011 17:02:45 -0700
Message-Id: <1302134569-22825-3-git-send-email-khilman@ti.com>
X-Mailer: git-send-email 1.7.4
In-Reply-To: <1302134569-22825-1-git-send-email-khilman@ti.com>
References: <1302134569-22825-1-git-send-email-khilman@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In commit 7538e3db6e015e890825fbd9f8659952896ddd5b (PM: add support
for device power domains) a better way for handling platform-specific
power hooks was introduced.

Rather than using the platform_bus dev_pm_ops overrides
(platform_bus_set_pm_ops()), this patch moves the OMAP runtime PM
implementation over to using device power domains.

Since OMAP is the only user of platform_bus_set_pm_ops(), that
interface can be removed (and will be in a forthcoming patch.)

Cc: Grant Likely <grant.likely@secretlab.ca>
Cc: Magnus Damm <magnus.damm@gmail.com>
Cc: Rafael J. Wysocki <rjw@sisk.pl>
Signed-off-by: Kevin Hilman <khilman@ti.com>
---
 arch/arm/mach-omap2/Makefile     |    6 +-
 arch/arm/mach-omap2/pm_bus.c     |   85 --------------------------------------
 arch/arm/plat-omap/omap_device.c |   22 ++++++++++
 3 files changed, 25 insertions(+), 88 deletions(-)
 delete mode 100644 arch/arm/mach-omap2/pm_bus.c

diff --git a/arch/arm/mach-omap2/Makefile b/arch/arm/mach-omap2/Makefile
index a45cd64..b353584 100644
--- a/arch/arm/mach-omap2/Makefile
+++ b/arch/arm/mach-omap2/Makefile
@@ -59,10 +59,10 @@ endif
 # Power Management
 ifeq ($(CONFIG_PM),y)
 obj-$(CONFIG_ARCH_OMAP2)		+= pm24xx.o
-obj-$(CONFIG_ARCH_OMAP2)		+= sleep24xx.o pm_bus.o
+obj-$(CONFIG_ARCH_OMAP2)		+= sleep24xx.o
 obj-$(CONFIG_ARCH_OMAP3)		+= pm34xx.o sleep34xx.o \
-					   cpuidle34xx.o pm_bus.o
-obj-$(CONFIG_ARCH_OMAP4)		+= pm44xx.o pm_bus.o
+					   cpuidle34xx.o
+obj-$(CONFIG_ARCH_OMAP4)		+= pm44xx.o
 obj-$(CONFIG_PM_DEBUG)			+= pm-debug.o
 obj-$(CONFIG_OMAP_SMARTREFLEX)          += sr_device.o smartreflex.o
 obj-$(CONFIG_OMAP_SMARTREFLEX_CLASS3)	+= smartreflex-class3.o
diff --git a/arch/arm/mach-omap2/pm_bus.c b/arch/arm/mach-omap2/pm_bus.c
deleted file mode 100644
index 5acd2ab..0000000
--- a/arch/arm/mach-omap2/pm_bus.c
+++ /dev/null
@@ -1,85 +0,0 @@
-/*
- * Runtime PM support code for OMAP
- *
- * Author: Kevin Hilman, Deep Root Systems, LLC
- *
- * Copyright (C) 2010 Texas Instruments, Inc.
- *
- * This file is licensed under the terms of the GNU General Public
- * License version 2. This program is licensed "as is" without any
- * warranty of any kind, whether express or implied.
- */
-#include <linux/init.h>
-#include <linux/kernel.h>
-#include <linux/io.h>
-#include <linux/pm_runtime.h>
-#include <linux/platform_device.h>
-#include <linux/mutex.h>
-
-#include <plat/omap_device.h>
-#include <plat/omap-pm.h>
-
-#ifdef CONFIG_PM_RUNTIME
-static int omap_pm_runtime_suspend(struct device *dev)
-{
-	struct platform_device *pdev = to_platform_device(dev);
-	int r, ret = 0;
-
-	dev_dbg(dev, "%s\n", __func__);
-
-	ret = pm_generic_runtime_suspend(dev);
-
-	if (!ret && dev->parent == &omap_device_parent) {
-		r = omap_device_idle(pdev);
-		WARN_ON(r);
-	}
-
-	return ret;
-};
-
-static int omap_pm_runtime_resume(struct device *dev)
-{
-	struct platform_device *pdev = to_platform_device(dev);
-	int r;
-
-	dev_dbg(dev, "%s\n", __func__);
-
-	if (dev->parent == &omap_device_parent) {
-		r = omap_device_enable(pdev);
-		WARN_ON(r);
-	}
-
-	return pm_generic_runtime_resume(dev);
-};
-#else
-#define omap_pm_runtime_suspend NULL
-#define omap_pm_runtime_resume NULL
-#endif /* CONFIG_PM_RUNTIME */
-
-static int __init omap_pm_runtime_init(void)
-{
-	const struct dev_pm_ops *pm;
-	struct dev_pm_ops *omap_pm;
-
-	pm = platform_bus_get_pm_ops();
-	if (!pm) {
-		pr_err("%s: unable to get dev_pm_ops from platform_bus\n",
-			__func__);
-		return -ENODEV;
-	}
-
-	omap_pm = kmemdup(pm, sizeof(struct dev_pm_ops), GFP_KERNEL);
-	if (!omap_pm) {
-		pr_err("%s: unable to alloc memory for new dev_pm_ops\n",
-			__func__);
-		return -ENOMEM;
-	}
-
-	omap_pm->runtime_suspend = omap_pm_runtime_suspend;
-	omap_pm->runtime_resume = omap_pm_runtime_resume;
-
-	platform_bus_set_pm_ops(omap_pm);
-
-	return 0;
-}
-core_initcall(omap_pm_runtime_init);
diff --git a/arch/arm/plat-omap/omap_device.c b/arch/arm/plat-omap/omap_device.c
index 9bbda9a..93cd2fb 100644
--- a/arch/arm/plat-omap/omap_device.c
+++ b/arch/arm/plat-omap/omap_device.c
@@ -536,6 +536,27 @@ int omap_early_device_register(struct omap_device *od)
 	return 0;
 }
 
+static int _od_runtime_suspend(struct device *dev)
+{
+	struct platform_device *pdev = to_platform_device(dev);
+
+	return omap_device_idle(pdev);
+}
+
+static int _od_runtime_resume(struct device *dev)
+{
+	struct platform_device *pdev = to_platform_device(dev);
+
+	return omap_device_enable(pdev);
+}
+
+static struct dev_power_domain omap_device_power_domain = {
+	.ops = {
+		.runtime_suspend = _od_runtime_suspend,
+		.runtime_resume = _od_runtime_resume,
+	}
+};
+
 /**
  * omap_device_register - register an omap_device with one omap_hwmod
  * @od: struct omap_device * to register
@@ -549,6 +570,7 @@ int omap_device_register(struct omap_device *od)
 	pr_debug("omap_device: %s: registering\n", od->pdev.name);
 
 	od->pdev.dev.parent = &omap_device_parent;
+	od->pdev.dev.pwr_domain = &omap_device_power_domain;
 	return platform_device_register(&od->pdev);
 }
 
-- 
1.7.4

