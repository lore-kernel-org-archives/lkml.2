Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753407Ab1HHWcZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 18:32:25 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:55712 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753239Ab1HHWcY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 18:32:24 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux PM mailing list <linux-pm@lists.linux-foundation.org>
Subject: [PATCH 4/4] PM: Move clock-related definitions and headers to separate file
Date: Tue, 9 Aug 2011 00:33:07 +0200
User-Agent: KMail/1.13.6 (Linux/3.1.0-rc1+; KDE/4.6.0; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>, linux-sh@vger.kernel.org,
        Magnus Damm <magnus.damm@gmail.com>, Greg KH <gregkh@suse.de>
References: <201108090028.12698.rjw@sisk.pl>
In-Reply-To: <201108090028.12698.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201108090033.08017.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Since the PM clock management code in drivers/base/power/clock_ops.c
is used for both runtime PM and system suspend/hibernation, the
definitions of data structures and headers related to it should not
be located in include/linux/pm_rumtime.h.  Move them to a separate
header file.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 arch/arm/mach-omap1/pm_bus.c            |    1 
 arch/arm/mach-shmobile/board-ap4evb.c   |    1 
 arch/arm/mach-shmobile/board-mackerel.c |    2 
 arch/arm/mach-shmobile/pm-sh7372.c      |    2 
 arch/arm/mach-shmobile/pm_runtime.c     |    1 
 drivers/base/power/clock_ops.c          |    2 
 drivers/base/power/common.c             |    3 -
 include/linux/pm_clock.h                |   70 ++++++++++++++++++++++++++++++++
 include/linux/pm_runtime.h              |   56 -------------------------
 9 files changed, 77 insertions(+), 61 deletions(-)

Index: linux-2.6/drivers/base/power/common.c
===================================================================
--- linux-2.6.orig/drivers/base/power/common.c
+++ linux-2.6/drivers/base/power/common.c
@@ -9,8 +9,7 @@
 #include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/slab.h>
-#include <linux/device.h>
-#include <linux/pm_runtime.h>
+#include <linux/pm_clock.h>
 
 /**
  * dev_pm_get_subsys_data - Create or refcount power.subsys_data for device.
Index: linux-2.6/include/linux/pm_clock.h
===================================================================
--- /dev/null
+++ linux-2.6/include/linux/pm_clock.h
@@ -0,0 +1,70 @@
+/*
+ * pm_clock.h - Definitions and headers related to device clocks.
+ *
+ * Copyright (C) 2011 Rafael J. Wysocki <rjw@sisk.pl>, Renesas Electronics Corp.
+ *
+ * This file is released under the GPLv2.
+ */
+
+#ifndef _LINUX_PM_CLOCK_H
+#define _LINUX_PM_CLOCK_H
+
+#include <linux/device.h>
+
+struct pm_clk_notifier_block {
+	struct notifier_block nb;
+	struct dev_pm_domain *pm_domain;
+	char *con_ids[];
+};
+
+#ifdef CONFIG_PM_CLK
+static inline bool pm_clk_no_clocks(struct device *dev)
+{
+	return dev && dev->power.subsys_data
+		&& list_empty(&dev->power.subsys_data->clock_list);
+}
+
+extern void pm_clk_init(struct device *dev);
+extern int pm_clk_create(struct device *dev);
+extern void pm_clk_destroy(struct device *dev);
+extern int pm_clk_add(struct device *dev, const char *con_id);
+extern void pm_clk_remove(struct device *dev, const char *con_id);
+extern int pm_clk_suspend(struct device *dev);
+extern int pm_clk_resume(struct device *dev);
+#else
+static inline bool pm_clk_no_clocks(struct device *dev)
+{
+	return true;
+}
+static inline void pm_clk_init(struct device *dev)
+{
+}
+static inline int pm_clk_create(struct device *dev)
+{
+	return -EINVAL;
+}
+static inline void pm_clk_destroy(struct device *dev)
+{
+}
+static inline int pm_clk_add(struct device *dev, const char *con_id)
+{
+	return -EINVAL;
+}
+static inline void pm_clk_remove(struct device *dev, const char *con_id)
+{
+}
+#define pm_clk_suspend	NULL
+#define pm_clk_resume	NULL
+#endif
+
+#ifdef CONFIG_HAVE_CLK
+extern void pm_clk_add_notifier(struct bus_type *bus,
+					struct pm_clk_notifier_block *clknb);
+#else
+static inline void pm_clk_add_notifier(struct bus_type *bus,
+					struct pm_clk_notifier_block *clknb)
+{
+}
+#endif
+
+#endif
Index: linux-2.6/include/linux/pm_runtime.h
===================================================================
--- linux-2.6.orig/include/linux/pm_runtime.h
+++ linux-2.6/include/linux/pm_runtime.h
@@ -251,60 +251,4 @@ static inline void pm_runtime_dont_use_a
 	__pm_runtime_use_autosuspend(dev, false);
 }
 
-struct pm_clk_notifier_block {
-	struct notifier_block nb;
-	struct dev_pm_domain *pm_domain;
-	char *con_ids[];
-};
-
-#ifdef CONFIG_PM_CLK
-static inline bool pm_clk_no_clocks(struct device *dev)
-{
-	return dev && dev->power.subsys_data
-		&& list_empty(&dev->power.subsys_data->clock_list);
-}
-
-extern void pm_clk_init(struct device *dev);
-extern int pm_clk_create(struct device *dev);
-extern void pm_clk_destroy(struct device *dev);
-extern int pm_clk_add(struct device *dev, const char *con_id);
-extern void pm_clk_remove(struct device *dev, const char *con_id);
-extern int pm_clk_suspend(struct device *dev);
-extern int pm_clk_resume(struct device *dev);
-#else
-static inline bool pm_clk_no_clocks(struct device *dev)
-{
-	return true;
-}
-static inline void pm_clk_init(struct device *dev)
-{
-}
-static inline int pm_clk_create(struct device *dev)
-{
-	return -EINVAL;
-}
-static inline void pm_clk_destroy(struct device *dev)
-{
-}
-static inline int pm_clk_add(struct device *dev, const char *con_id)
-{
-	return -EINVAL;
-}
-static inline void pm_clk_remove(struct device *dev, const char *con_id)
-{
-}
-#define pm_clk_suspend	NULL
-#define pm_clk_resume	NULL
-#endif
-
-#ifdef CONFIG_HAVE_CLK
-extern void pm_clk_add_notifier(struct bus_type *bus,
-					struct pm_clk_notifier_block *clknb);
-#else
-static inline void pm_clk_add_notifier(struct bus_type *bus,
-					struct pm_clk_notifier_block *clknb)
-{
-}
-#endif
-
 #endif
Index: linux-2.6/arch/arm/mach-shmobile/pm-sh7372.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-shmobile/pm-sh7372.c
+++ linux-2.6/arch/arm/mach-shmobile/pm-sh7372.c
@@ -15,7 +15,7 @@
 #include <linux/list.h>
 #include <linux/err.h>
 #include <linux/slab.h>
-#include <linux/pm_runtime.h>
+#include <linux/pm_clock.h>
 #include <linux/platform_device.h>
 #include <linux/delay.h>
 #include <asm/system.h>
Index: linux-2.6/drivers/base/power/clock_ops.c
===================================================================
--- linux-2.6.orig/drivers/base/power/clock_ops.c
+++ linux-2.6/drivers/base/power/clock_ops.c
@@ -10,7 +10,7 @@
 #include <linux/kernel.h>
 #include <linux/io.h>
 #include <linux/pm.h>
-#include <linux/pm_runtime.h>
+#include <linux/pm_clock.h>
 #include <linux/clk.h>
 #include <linux/slab.h>
 #include <linux/err.h>
Index: linux-2.6/arch/arm/mach-shmobile/pm_runtime.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-shmobile/pm_runtime.c
+++ linux-2.6/arch/arm/mach-shmobile/pm_runtime.c
@@ -15,6 +15,7 @@
 #include <linux/io.h>
 #include <linux/pm_runtime.h>
 #include <linux/pm_domain.h>
+#include <linux/pm_clock.h>
 #include <linux/platform_device.h>
 #include <linux/clk.h>
 #include <linux/sh_clk.h>
Index: linux-2.6/arch/arm/mach-shmobile/board-mackerel.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-shmobile/board-mackerel.c
+++ linux-2.6/arch/arm/mach-shmobile/board-mackerel.c
@@ -39,7 +39,7 @@
 #include <linux/mtd/mtd.h>
 #include <linux/mtd/partitions.h>
 #include <linux/mtd/physmap.h>
-#include <linux/pm_runtime.h>
+#include <linux/pm_clock.h>
 #include <linux/smsc911x.h>
 #include <linux/sh_intc.h>
 #include <linux/tca6416_keypad.h>
Index: linux-2.6/arch/arm/mach-shmobile/board-ap4evb.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-shmobile/board-ap4evb.c
+++ linux-2.6/arch/arm/mach-shmobile/board-ap4evb.c
@@ -42,6 +42,7 @@
 #include <linux/leds.h>
 #include <linux/input/sh_keysc.h>
 #include <linux/usb/r8a66597.h>
+#include <linux/pm_clock.h>
 
 #include <media/sh_mobile_ceu.h>
 #include <media/sh_mobile_csi2.h>
Index: linux-2.6/arch/arm/mach-omap1/pm_bus.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-omap1/pm_bus.c
+++ linux-2.6/arch/arm/mach-omap1/pm_bus.c
@@ -13,6 +13,7 @@
 #include <linux/kernel.h>
 #include <linux/io.h>
 #include <linux/pm_runtime.h>
+#include <linux/pm_clock.h>
 #include <linux/platform_device.h>
 #include <linux/mutex.h>
 #include <linux/clk.h>

