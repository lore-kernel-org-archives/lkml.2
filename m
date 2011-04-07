Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757226Ab1DGADa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 20:03:30 -0400
Received: from na3sys009aog109.obsmtp.com ([74.125.149.201]:47998 "EHLO
	na3sys009aog109.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757162Ab1DGACw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 20:02:52 -0400
From: Kevin Hilman <khilman@ti.com>
To: linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        linux-sh@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Magnus Damm <magnus.damm@gmail.com>,
        "Rafael J. Wysocki" <rjw@suse.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH/RFC 4/6] ARM: move SH-mobile runtime PM to arm/common for sharing with other platforms
Date: Wed,  6 Apr 2011 17:02:47 -0700
Message-Id: <1302134569-22825-5-git-send-email-khilman@ti.com>
X-Mailer: git-send-email 1.7.4
In-Reply-To: <1302134569-22825-1-git-send-email-khilman@ti.com>
References: <1302134569-22825-1-git-send-email-khilman@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is really nothing SH-mobile specific about this runtime PM
implementation.  Any platform wanting to implement runtime PM based on
simple clock gating can use this implementation.

Signed-off-by: Kevin Hilman <khilman@ti.com>
---
 arch/arm/common/Makefile            |    1 +
 arch/arm/common/pm_runtime_clock.c  |  176 ++++++++++++++++++++++++++++++++++
 arch/arm/include/asm/pm_runtime.h   |   17 ++++
 arch/arm/mach-shmobile/pm_runtime.c |  179 -----------------------------------
 4 files changed, 194 insertions(+), 179 deletions(-)
 create mode 100644 arch/arm/common/pm_runtime_clock.c
 create mode 100644 arch/arm/include/asm/pm_runtime.h
 delete mode 100644 arch/arm/mach-shmobile/pm_runtime.c

diff --git a/arch/arm/common/Makefile b/arch/arm/common/Makefile
index e7521bca..efa79c7 100644
--- a/arch/arm/common/Makefile
+++ b/arch/arm/common/Makefile
@@ -18,3 +18,4 @@ obj-$(CONFIG_ARCH_IXP23XX)	+= uengine.o
 obj-$(CONFIG_PCI_HOST_ITE8152)  += it8152.o
 obj-$(CONFIG_COMMON_CLKDEV)	+= clkdev.o
 obj-$(CONFIG_ARM_TIMER_SP804)	+= timer-sp.o
+obj-$(CONFIG_PM_RUNTIME)	+= pm_runtime_clock.o
diff --git a/arch/arm/common/pm_runtime_clock.c b/arch/arm/common/pm_runtime_clock.c
new file mode 100644
index 0000000..453fc95
--- /dev/null
+++ b/arch/arm/common/pm_runtime_clock.c
@@ -0,0 +1,176 @@
+/*
+ * Generic Runtime PM support code for managing device clocks
+ *
+ *  Copyright (C) 2009-2010 Magnus Damm
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License.  See the file "COPYING" in the main directory of this archive
+ * for more details.
+ */
+
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/io.h>
+#include <linux/pm_runtime.h>
+#include <linux/platform_device.h>
+#include <linux/clk.h>
+#include <linux/bitmap.h>
+#include <linux/err.h>
+
+#ifdef CONFIG_PM_RUNTIME
+#define BIT_ONCE 0
+#define BIT_ACTIVE 1
+#define BIT_CLK_ENABLED 2
+
+struct pm_runtime_data {
+	unsigned long flags;
+	struct clk *clk;
+};
+
+static void __devres_release(struct device *dev, void *res)
+{
+	struct pm_runtime_data *prd = res;
+
+	dev_dbg(dev, "__devres_release()\n");
+
+	if (test_bit(BIT_CLK_ENABLED, &prd->flags))
+		clk_disable(prd->clk);
+
+	if (test_bit(BIT_ACTIVE, &prd->flags))
+		clk_put(prd->clk);
+}
+
+static struct pm_runtime_data *__to_prd(struct device *dev)
+{
+	return devres_find(dev, __devres_release, NULL, NULL);
+}
+
+static void platform_pm_runtime_init(struct device *dev,
+				     struct pm_runtime_data *prd)
+{
+	if (prd && !test_and_set_bit(BIT_ONCE, &prd->flags)) {
+		prd->clk = clk_get(dev, NULL);
+		if (!IS_ERR(prd->clk)) {
+			set_bit(BIT_ACTIVE, &prd->flags);
+			dev_info(dev, "clocks managed by runtime pm\n");
+		}
+	}
+}
+
+static void platform_pm_runtime_bug(struct device *dev,
+				    struct pm_runtime_data *prd)
+{
+	if (prd && !test_and_set_bit(BIT_ONCE, &prd->flags))
+		dev_err(dev, "runtime pm suspend before resume\n");
+}
+
+static int platform_pm_runtime_suspend(struct device *dev)
+{
+	struct pm_runtime_data *prd = __to_prd(dev);
+
+	dev_dbg(dev, "platform_pm_runtime_suspend()\n");
+
+	platform_pm_runtime_bug(dev, prd);
+
+	if (prd && test_bit(BIT_ACTIVE, &prd->flags)) {
+		clk_disable(prd->clk);
+		clear_bit(BIT_CLK_ENABLED, &prd->flags);
+	}
+
+	return 0;
+}
+
+static int platform_pm_runtime_resume(struct device *dev)
+{
+	struct pm_runtime_data *prd = __to_prd(dev);
+
+	dev_dbg(dev, "platform_pm_runtime_resume()\n");
+
+	platform_pm_runtime_init(dev, prd);
+
+	if (prd && test_bit(BIT_ACTIVE, &prd->flags)) {
+		clk_enable(prd->clk);
+		set_bit(BIT_CLK_ENABLED, &prd->flags);
+	}
+
+	return 0;
+}
+
+static int platform_pm_runtime_idle(struct device *dev)
+{
+	/* suspend synchronously to disable clocks immediately */
+	return pm_runtime_suspend(dev);
+}
+
+static struct dev_power_domain platform_pm_power_domain = {
+	.ops = {
+		.runtime_suspend = platform_pm_runtime_suspend,
+		.runtime_resume = platform_pm_runtime_resume,
+		.runtime_idle = platform_pm_runtime_idle,
+	},
+};
+
+static int platform_bus_notify(struct notifier_block *nb,
+			       unsigned long action, void *data)
+{
+	struct device *dev = data;
+	struct pm_runtime_data *prd;
+
+	dev_dbg(dev, "platform_bus_notify() %ld !\n", action);
+
+	if (action == BUS_NOTIFY_BIND_DRIVER) {
+		prd = devres_alloc(__devres_release, sizeof(*prd), GFP_KERNEL);
+		if (prd) {
+			devres_add(dev, prd);
+			dev->pwr_domain = &platform_pm_power_domain;
+		} else {
+			dev_err(dev, "unable to alloc memory for runtime pm\n");
+		}
+	}
+
+	return 0;
+}
+
+#else /* CONFIG_PM_RUNTIME */
+
+static int platform_bus_notify(struct notifier_block *nb,
+			       unsigned long action, void *data)
+{
+	struct device *dev = data;
+	struct clk *clk;
+
+	dev_dbg(dev, "platform_bus_notify() %ld !\n", action);
+
+	switch (action) {
+	case BUS_NOTIFY_BIND_DRIVER:
+		clk = clk_get(dev, NULL);
+		if (!IS_ERR(clk)) {
+			clk_enable(clk);
+			clk_put(clk);
+			dev_info(dev, "runtime pm disabled, clock forced on\n");
+		}
+		break;
+	case BUS_NOTIFY_UNBOUND_DRIVER:
+		clk = clk_get(dev, NULL);
+		if (!IS_ERR(clk)) {
+			clk_disable(clk);
+			clk_put(clk);
+			dev_info(dev, "runtime pm disabled, clock forced off\n");
+		}
+		break;
+	}
+
+	return 0;
+}
+
+#endif /* CONFIG_PM_RUNTIME */
+
+static struct notifier_block platform_bus_notifier = {
+	.notifier_call = platform_bus_notify
+};
+
+int __init pm_runtime_clock_init(void)
+{
+	bus_register_notifier(&platform_bus_type, &platform_bus_notifier);
+	return 0;
+}
diff --git a/arch/arm/include/asm/pm_runtime.h b/arch/arm/include/asm/pm_runtime.h
new file mode 100644
index 0000000..0c54b07
--- /dev/null
+++ b/arch/arm/include/asm/pm_runtime.h
@@ -0,0 +1,17 @@
+/*
+ * ARM common runtime PM definitions/prototypes
+ *
+ * Author: Kevin Hilman
+ *
+ * Copyright (C) 2010 Texas Instruments, Inc.
+ *
+ * This file is licensed under the terms of the GNU General Public
+ * License version 2. This program is licensed "as is" without any
+ * warranty of any kind, whether express or implied.
+ */
+#ifndef __ASM_PM_RUNTIME_H__
+#define __ASM_PM_RUNTIME_H__
+
+int __init pm_runtime_clock_init(void);
+
+#endif /* __ASM_PM_RUNTIME_H__ */
diff --git a/arch/arm/mach-shmobile/pm_runtime.c b/arch/arm/mach-shmobile/pm_runtime.c
deleted file mode 100644
index 6c75c3f..0000000
--- a/arch/arm/mach-shmobile/pm_runtime.c
+++ /dev/null
@@ -1,179 +0,0 @@
-/*
- * arch/arm/mach-shmobile/pm_runtime.c
- *
- * Runtime PM support code for SuperH Mobile ARM
- *
- *  Copyright (C) 2009-2010 Magnus Damm
- *
- * This file is subject to the terms and conditions of the GNU General Public
- * License.  See the file "COPYING" in the main directory of this archive
- * for more details.
- */
-
-#include <linux/init.h>
-#include <linux/kernel.h>
-#include <linux/io.h>
-#include <linux/pm_runtime.h>
-#include <linux/platform_device.h>
-#include <linux/clk.h>
-#include <linux/sh_clk.h>
-#include <linux/bitmap.h>
-
-#ifdef CONFIG_PM_RUNTIME
-#define BIT_ONCE 0
-#define BIT_ACTIVE 1
-#define BIT_CLK_ENABLED 2
-
-struct pm_runtime_data {
-	unsigned long flags;
-	struct clk *clk;
-};
-
-static void __devres_release(struct device *dev, void *res)
-{
-	struct pm_runtime_data *prd = res;
-
-	dev_dbg(dev, "__devres_release()\n");
-
-	if (test_bit(BIT_CLK_ENABLED, &prd->flags))
-		clk_disable(prd->clk);
-
-	if (test_bit(BIT_ACTIVE, &prd->flags))
-		clk_put(prd->clk);
-}
-
-static struct pm_runtime_data *__to_prd(struct device *dev)
-{
-	return devres_find(dev, __devres_release, NULL, NULL);
-}
-
-static void platform_pm_runtime_init(struct device *dev,
-				     struct pm_runtime_data *prd)
-{
-	if (prd && !test_and_set_bit(BIT_ONCE, &prd->flags)) {
-		prd->clk = clk_get(dev, NULL);
-		if (!IS_ERR(prd->clk)) {
-			set_bit(BIT_ACTIVE, &prd->flags);
-			dev_info(dev, "clocks managed by runtime pm\n");
-		}
-	}
-}
-
-static void platform_pm_runtime_bug(struct device *dev,
-				    struct pm_runtime_data *prd)
-{
-	if (prd && !test_and_set_bit(BIT_ONCE, &prd->flags))
-		dev_err(dev, "runtime pm suspend before resume\n");
-}
-
-static int platform_pm_runtime_suspend(struct device *dev)
-{
-	struct pm_runtime_data *prd = __to_prd(dev);
-
-	dev_dbg(dev, "platform_pm_runtime_suspend()\n");
-
-	platform_pm_runtime_bug(dev, prd);
-
-	if (prd && test_bit(BIT_ACTIVE, &prd->flags)) {
-		clk_disable(prd->clk);
-		clear_bit(BIT_CLK_ENABLED, &prd->flags);
-	}
-
-	return 0;
-}
-
-static int platform_pm_runtime_resume(struct device *dev)
-{
-	struct pm_runtime_data *prd = __to_prd(dev);
-
-	dev_dbg(dev, "platform_pm_runtime_resume()\n");
-
-	platform_pm_runtime_init(dev, prd);
-
-	if (prd && test_bit(BIT_ACTIVE, &prd->flags)) {
-		clk_enable(prd->clk);
-		set_bit(BIT_CLK_ENABLED, &prd->flags);
-	}
-
-	return 0;
-}
-
-static int platform_pm_runtime_idle(struct device *dev)
-{
-	/* suspend synchronously to disable clocks immediately */
-	return pm_runtime_suspend(dev);
-}
-
-static struct dev_power_domain platform_pm_power_domain = {
-	.ops = {
-		.runtime_suspend = platform_pm_runtime_suspend,
-		.runtime_resume = platform_pm_runtime_resume,
-		.runtime_idle = platform_pm_runtime_idle,
-	},
-};
-
-static int platform_bus_notify(struct notifier_block *nb,
-			       unsigned long action, void *data)
-{
-	struct device *dev = data;
-	struct pm_runtime_data *prd;
-
-	dev_dbg(dev, "platform_bus_notify() %ld !\n", action);
-
-	if (action == BUS_NOTIFY_BIND_DRIVER) {
-		prd = devres_alloc(__devres_release, sizeof(*prd), GFP_KERNEL);
-		if (prd) {
-			devres_add(dev, prd);
-			dev->pwr_domain = &platform_pm_power_domain;
-		} else {
-			dev_err(dev, "unable to alloc memory for runtime pm\n");
-		}
-	}
-
-	return 0;
-}
-
-#else /* CONFIG_PM_RUNTIME */
-
-static int platform_bus_notify(struct notifier_block *nb,
-			       unsigned long action, void *data)
-{
-	struct device *dev = data;
-	struct clk *clk;
-
-	dev_dbg(dev, "platform_bus_notify() %ld !\n", action);
-
-	switch (action) {
-	case BUS_NOTIFY_BIND_DRIVER:
-		clk = clk_get(dev, NULL);
-		if (!IS_ERR(clk)) {
-			clk_enable(clk);
-			clk_put(clk);
-			dev_info(dev, "runtime pm disabled, clock forced on\n");
-		}
-		break;
-	case BUS_NOTIFY_UNBOUND_DRIVER:
-		clk = clk_get(dev, NULL);
-		if (!IS_ERR(clk)) {
-			clk_disable(clk);
-			clk_put(clk);
-			dev_info(dev, "runtime pm disabled, clock forced off\n");
-		}
-		break;
-	}
-
-	return 0;
-}
-
-#endif /* CONFIG_PM_RUNTIME */
-
-static struct notifier_block platform_bus_notifier = {
-	.notifier_call = platform_bus_notify
-};
-
-static int __init sh_pm_runtime_init(void)
-{
-	bus_register_notifier(&platform_bus_type, &platform_bus_notifier);
-	return 0;
-}
-core_initcall(sh_pm_runtime_init);
-- 
1.7.4

