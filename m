Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753680Ab1BWEeA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 23:34:00 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:46293 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753236Ab1BWEdp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 23:33:45 -0500
Subject: [RFC PATCH 01/15] dt/powerpc: move of_bus_type infrastructure to
	ibmebus
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        devicetree-discuss@lists.ozlabs.org, sfr@canb.auug.org.au,
        linux-kernel@vger.kernel.org, davem@davemloft.net
From: Grant Likely <grant.likely@secretlab.ca>
Cc: sparclinux@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Date: Tue, 22 Feb 2011 21:33:40 -0700
Message-ID: <20110223043340.20795.84024.stgit@localhost6.localdomain6>
In-Reply-To: <20110223043015.20795.37090.stgit@localhost6.localdomain6>
References: <20110223043015.20795.37090.stgit@localhost6.localdomain6>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

arch/powerpc/kernel/ibmebus.c is the only remaining user of the
of_bus_type support code for initializing the bus and registering
drivers.  All others have either been switched to the vanilla platform
bus or already have their own infrastructure.

This patch moves the functionality that ibmebus is using out of
drivers/of/{platform,device}.c and into ibmebus.c where it is actually
used.  Also renames the moved symbols from of_platform_* to
ibmebus_bus_* to reflect the actual usage.

This patch is part of moving all of the of_platform_bus_type users
over to the platform_bus_type.

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
---
 arch/powerpc/kernel/ibmebus.c |  404 +++++++++++++++++++++++++++++++++++++++++
 drivers/of/device.c           |   34 ---
 drivers/of/platform.c         |  393 ----------------------------------------
 include/linux/of_platform.h   |    6 -
 4 files changed, 400 insertions(+), 437 deletions(-)

diff --git a/arch/powerpc/kernel/ibmebus.c b/arch/powerpc/kernel/ibmebus.c
index f62efdf..c00d4ca 100644
--- a/arch/powerpc/kernel/ibmebus.c
+++ b/arch/powerpc/kernel/ibmebus.c
@@ -201,13 +201,14 @@ int ibmebus_register_driver(struct of_platform_driver *drv)
 	/* If the driver uses devices that ibmebus doesn't know, add them */
 	ibmebus_create_devices(drv->driver.of_match_table);
 
-	return of_register_driver(drv, &ibmebus_bus_type);
+	drv->driver.bus = &ibmebus_bus_type;
+	return driver_register(&drv->driver);
 }
 EXPORT_SYMBOL(ibmebus_register_driver);
 
 void ibmebus_unregister_driver(struct of_platform_driver *drv)
 {
-	of_unregister_driver(drv);
+	driver_unregister(&drv->driver);
 }
 EXPORT_SYMBOL(ibmebus_unregister_driver);
 
@@ -308,15 +309,410 @@ static ssize_t ibmebus_store_remove(struct bus_type *bus,
 	}
 }
 
+
 static struct bus_attribute ibmebus_bus_attrs[] = {
 	__ATTR(probe, S_IWUSR, NULL, ibmebus_store_probe),
 	__ATTR(remove, S_IWUSR, NULL, ibmebus_store_remove),
 	__ATTR_NULL
 };
 
+static int ibmebus_bus_bus_match(struct device *dev, struct device_driver *drv)
+{
+	const struct of_device_id *matches = drv->of_match_table;
+
+	if (!matches)
+		return 0;
+
+	return of_match_device(matches, dev) != NULL;
+}
+
+static int ibmebus_bus_device_probe(struct device *dev)
+{
+	int error = -ENODEV;
+	struct of_platform_driver *drv;
+	struct platform_device *of_dev;
+	const struct of_device_id *match;
+
+	drv = to_of_platform_driver(dev->driver);
+	of_dev = to_platform_device(dev);
+
+	if (!drv->probe)
+		return error;
+
+	of_dev_get(of_dev);
+
+	match = of_match_device(drv->driver.of_match_table, dev);
+	if (match)
+		error = drv->probe(of_dev, match);
+	if (error)
+		of_dev_put(of_dev);
+
+	return error;
+}
+
+static int ibmebus_bus_device_remove(struct device *dev)
+{
+	struct platform_device *of_dev = to_platform_device(dev);
+	struct of_platform_driver *drv = to_of_platform_driver(dev->driver);
+
+	if (dev->driver && drv->remove)
+		drv->remove(of_dev);
+	return 0;
+}
+
+static void ibmebus_bus_device_shutdown(struct device *dev)
+{
+	struct platform_device *of_dev = to_platform_device(dev);
+	struct of_platform_driver *drv = to_of_platform_driver(dev->driver);
+
+	if (dev->driver && drv->shutdown)
+		drv->shutdown(of_dev);
+}
+
+/*
+ * ibmebus_bus_device_attrs
+ */
+static ssize_t devspec_show(struct device *dev,
+				struct device_attribute *attr, char *buf)
+{
+	struct platform_device *ofdev;
+
+	ofdev = to_platform_device(dev);
+	return sprintf(buf, "%s\n", ofdev->dev.of_node->full_name);
+}
+
+static ssize_t name_show(struct device *dev,
+				struct device_attribute *attr, char *buf)
+{
+	struct platform_device *ofdev;
+
+	ofdev = to_platform_device(dev);
+	return sprintf(buf, "%s\n", ofdev->dev.of_node->name);
+}
+
+static ssize_t modalias_show(struct device *dev,
+				struct device_attribute *attr, char *buf)
+{
+	ssize_t len = of_device_get_modalias(dev, buf, PAGE_SIZE - 2);
+	buf[len] = '\n';
+	buf[len+1] = 0;
+	return len+1;
+}
+
+struct device_attribute ibmebus_bus_device_attrs[] = {
+	__ATTR_RO(devspec),
+	__ATTR_RO(name),
+	__ATTR_RO(modalias),
+	__ATTR_NULL
+};
+
+#ifdef CONFIG_PM_SLEEP
+static int ibmebus_bus_legacy_suspend(struct device *dev, pm_message_t mesg)
+{
+	struct platform_device *of_dev = to_platform_device(dev);
+	struct of_platform_driver *drv = to_of_platform_driver(dev->driver);
+	int ret = 0;
+
+	if (dev->driver && drv->suspend)
+		ret = drv->suspend(of_dev, mesg);
+	return ret;
+}
+
+static int ibmebus_bus_legacy_resume(struct device *dev)
+{
+	struct platform_device *of_dev = to_platform_device(dev);
+	struct of_platform_driver *drv = to_of_platform_driver(dev->driver);
+	int ret = 0;
+
+	if (dev->driver && drv->resume)
+		ret = drv->resume(of_dev);
+	return ret;
+}
+
+static int ibmebus_bus_pm_prepare(struct device *dev)
+{
+	struct device_driver *drv = dev->driver;
+	int ret = 0;
+
+	if (drv && drv->pm && drv->pm->prepare)
+		ret = drv->pm->prepare(dev);
+
+	return ret;
+}
+
+static void ibmebus_bus_pm_complete(struct device *dev)
+{
+	struct device_driver *drv = dev->driver;
+
+	if (drv && drv->pm && drv->pm->complete)
+		drv->pm->complete(dev);
+}
+
+#ifdef CONFIG_SUSPEND
+
+static int ibmebus_bus_pm_suspend(struct device *dev)
+{
+	struct device_driver *drv = dev->driver;
+	int ret = 0;
+
+	if (!drv)
+		return 0;
+
+	if (drv->pm) {
+		if (drv->pm->suspend)
+			ret = drv->pm->suspend(dev);
+	} else {
+		ret = ibmebus_bus_legacy_suspend(dev, PMSG_SUSPEND);
+	}
+
+	return ret;
+}
+
+static int ibmebus_bus_pm_suspend_noirq(struct device *dev)
+{
+	struct device_driver *drv = dev->driver;
+	int ret = 0;
+
+	if (!drv)
+		return 0;
+
+	if (drv->pm) {
+		if (drv->pm->suspend_noirq)
+			ret = drv->pm->suspend_noirq(dev);
+	}
+
+	return ret;
+}
+
+static int ibmebus_bus_pm_resume(struct device *dev)
+{
+	struct device_driver *drv = dev->driver;
+	int ret = 0;
+
+	if (!drv)
+		return 0;
+
+	if (drv->pm) {
+		if (drv->pm->resume)
+			ret = drv->pm->resume(dev);
+	} else {
+		ret = ibmebus_bus_legacy_resume(dev);
+	}
+
+	return ret;
+}
+
+static int ibmebus_bus_pm_resume_noirq(struct device *dev)
+{
+	struct device_driver *drv = dev->driver;
+	int ret = 0;
+
+	if (!drv)
+		return 0;
+
+	if (drv->pm) {
+		if (drv->pm->resume_noirq)
+			ret = drv->pm->resume_noirq(dev);
+	}
+
+	return ret;
+}
+
+#else /* !CONFIG_SUSPEND */
+
+#define ibmebus_bus_pm_suspend		NULL
+#define ibmebus_bus_pm_resume		NULL
+#define ibmebus_bus_pm_suspend_noirq	NULL
+#define ibmebus_bus_pm_resume_noirq	NULL
+
+#endif /* !CONFIG_SUSPEND */
+
+#ifdef CONFIG_HIBERNATION
+
+static int ibmebus_bus_pm_freeze(struct device *dev)
+{
+	struct device_driver *drv = dev->driver;
+	int ret = 0;
+
+	if (!drv)
+		return 0;
+
+	if (drv->pm) {
+		if (drv->pm->freeze)
+			ret = drv->pm->freeze(dev);
+	} else {
+		ret = ibmebus_bus_legacy_suspend(dev, PMSG_FREEZE);
+	}
+
+	return ret;
+}
+
+static int ibmebus_bus_pm_freeze_noirq(struct device *dev)
+{
+	struct device_driver *drv = dev->driver;
+	int ret = 0;
+
+	if (!drv)
+		return 0;
+
+	if (drv->pm) {
+		if (drv->pm->freeze_noirq)
+			ret = drv->pm->freeze_noirq(dev);
+	}
+
+	return ret;
+}
+
+static int ibmebus_bus_pm_thaw(struct device *dev)
+{
+	struct device_driver *drv = dev->driver;
+	int ret = 0;
+
+	if (!drv)
+		return 0;
+
+	if (drv->pm) {
+		if (drv->pm->thaw)
+			ret = drv->pm->thaw(dev);
+	} else {
+		ret = ibmebus_bus_legacy_resume(dev);
+	}
+
+	return ret;
+}
+
+static int ibmebus_bus_pm_thaw_noirq(struct device *dev)
+{
+	struct device_driver *drv = dev->driver;
+	int ret = 0;
+
+	if (!drv)
+		return 0;
+
+	if (drv->pm) {
+		if (drv->pm->thaw_noirq)
+			ret = drv->pm->thaw_noirq(dev);
+	}
+
+	return ret;
+}
+
+static int ibmebus_bus_pm_poweroff(struct device *dev)
+{
+	struct device_driver *drv = dev->driver;
+	int ret = 0;
+
+	if (!drv)
+		return 0;
+
+	if (drv->pm) {
+		if (drv->pm->poweroff)
+			ret = drv->pm->poweroff(dev);
+	} else {
+		ret = ibmebus_bus_legacy_suspend(dev, PMSG_HIBERNATE);
+	}
+
+	return ret;
+}
+
+static int ibmebus_bus_pm_poweroff_noirq(struct device *dev)
+{
+	struct device_driver *drv = dev->driver;
+	int ret = 0;
+
+	if (!drv)
+		return 0;
+
+	if (drv->pm) {
+		if (drv->pm->poweroff_noirq)
+			ret = drv->pm->poweroff_noirq(dev);
+	}
+
+	return ret;
+}
+
+static int ibmebus_bus_pm_restore(struct device *dev)
+{
+	struct device_driver *drv = dev->driver;
+	int ret = 0;
+
+	if (!drv)
+		return 0;
+
+	if (drv->pm) {
+		if (drv->pm->restore)
+			ret = drv->pm->restore(dev);
+	} else {
+		ret = ibmebus_bus_legacy_resume(dev);
+	}
+
+	return ret;
+}
+
+static int ibmebus_bus_pm_restore_noirq(struct device *dev)
+{
+	struct device_driver *drv = dev->driver;
+	int ret = 0;
+
+	if (!drv)
+		return 0;
+
+	if (drv->pm) {
+		if (drv->pm->restore_noirq)
+			ret = drv->pm->restore_noirq(dev);
+	}
+
+	return ret;
+}
+
+#else /* !CONFIG_HIBERNATION */
+
+#define ibmebus_bus_pm_freeze		NULL
+#define ibmebus_bus_pm_thaw		NULL
+#define ibmebus_bus_pm_poweroff		NULL
+#define ibmebus_bus_pm_restore		NULL
+#define ibmebus_bus_pm_freeze_noirq	NULL
+#define ibmebus_bus_pm_thaw_noirq		NULL
+#define ibmebus_bus_pm_poweroff_noirq	NULL
+#define ibmebus_bus_pm_restore_noirq	NULL
+
+#endif /* !CONFIG_HIBERNATION */
+
+static struct dev_pm_ops ibmebus_bus_dev_pm_ops = {
+	.prepare = ibmebus_bus_pm_prepare,
+	.complete = ibmebus_bus_pm_complete,
+	.suspend = ibmebus_bus_pm_suspend,
+	.resume = ibmebus_bus_pm_resume,
+	.freeze = ibmebus_bus_pm_freeze,
+	.thaw = ibmebus_bus_pm_thaw,
+	.poweroff = ibmebus_bus_pm_poweroff,
+	.restore = ibmebus_bus_pm_restore,
+	.suspend_noirq = ibmebus_bus_pm_suspend_noirq,
+	.resume_noirq = ibmebus_bus_pm_resume_noirq,
+	.freeze_noirq = ibmebus_bus_pm_freeze_noirq,
+	.thaw_noirq = ibmebus_bus_pm_thaw_noirq,
+	.poweroff_noirq = ibmebus_bus_pm_poweroff_noirq,
+	.restore_noirq = ibmebus_bus_pm_restore_noirq,
+};
+
+#define IBMEBUS_BUS_PM_OPS_PTR	(&ibmebus_bus_dev_pm_ops)
+
+#else /* !CONFIG_PM_SLEEP */
+
+#define IBMEBUS_BUS_PM_OPS_PTR	NULL
+
+#endif /* !CONFIG_PM_SLEEP */
+
 struct bus_type ibmebus_bus_type = {
+	.name      = "ibmebus",
 	.uevent    = of_device_uevent,
-	.bus_attrs = ibmebus_bus_attrs
+	.bus_attrs = ibmebus_bus_attrs,
+	.match     = ibmebus_bus_bus_match,
+	.probe     = ibmebus_bus_device_probe,
+	.remove    = ibmebus_bus_device_remove,
+	.shutdown  = ibmebus_bus_device_shutdown,
+	.dev_attrs = ibmebus_bus_device_attrs,
+	.pm        = IBMEBUS_BUS_PM_OPS_PTR,
 };
 EXPORT_SYMBOL(ibmebus_bus_type);
 
@@ -326,7 +722,7 @@ static int __init ibmebus_bus_init(void)
 
 	printk(KERN_INFO "IBM eBus Device Driver\n");
 
-	err = of_bus_type_init(&ibmebus_bus_type, "ibmebus");
+	err = bus_register(&ibmebus_bus_type);
 	if (err) {
 		printk(KERN_ERR "%s: failed to register IBM eBus.\n",
 		       __func__);
diff --git a/drivers/of/device.c b/drivers/of/device.c
index 45d8653..62b4b32 100644
--- a/drivers/of/device.c
+++ b/drivers/of/device.c
@@ -47,40 +47,6 @@ void of_dev_put(struct platform_device *dev)
 }
 EXPORT_SYMBOL(of_dev_put);
 
-static ssize_t devspec_show(struct device *dev,
-				struct device_attribute *attr, char *buf)
-{
-	struct platform_device *ofdev;
-
-	ofdev = to_platform_device(dev);
-	return sprintf(buf, "%s\n", ofdev->dev.of_node->full_name);
-}
-
-static ssize_t name_show(struct device *dev,
-				struct device_attribute *attr, char *buf)
-{
-	struct platform_device *ofdev;
-
-	ofdev = to_platform_device(dev);
-	return sprintf(buf, "%s\n", ofdev->dev.of_node->name);
-}
-
-static ssize_t modalias_show(struct device *dev,
-				struct device_attribute *attr, char *buf)
-{
-	ssize_t len = of_device_get_modalias(dev, buf, PAGE_SIZE - 2);
-	buf[len] = '\n';
-	buf[len+1] = 0;
-	return len+1;
-}
-
-struct device_attribute of_platform_device_attrs[] = {
-	__ATTR_RO(devspec),
-	__ATTR_RO(name),
-	__ATTR_RO(modalias),
-	__ATTR_NULL
-};
-
 int of_device_add(struct platform_device *ofdev)
 {
 	BUG_ON(ofdev->dev.of_node == NULL);
diff --git a/drivers/of/platform.c b/drivers/of/platform.c
index c01cd1a..b71d0cd 100644
--- a/drivers/of/platform.c
+++ b/drivers/of/platform.c
@@ -114,399 +114,6 @@ EXPORT_SYMBOL(of_unregister_platform_driver);
 #include <asm/dcr.h>
 #endif
 
-extern struct device_attribute of_platform_device_attrs[];
-
-static int of_platform_bus_match(struct device *dev, struct device_driver *drv)
-{
-	const struct of_device_id *matches = drv->of_match_table;
-
-	if (!matches)
-		return 0;
-
-	return of_match_device(matches, dev) != NULL;
-}
-
-static int of_platform_device_probe(struct device *dev)
-{
-	int error = -ENODEV;
-	struct of_platform_driver *drv;
-	struct platform_device *of_dev;
-	const struct of_device_id *match;
-
-	drv = to_of_platform_driver(dev->driver);
-	of_dev = to_platform_device(dev);
-
-	if (!drv->probe)
-		return error;
-
-	of_dev_get(of_dev);
-
-	match = of_match_device(drv->driver.of_match_table, dev);
-	if (match)
-		error = drv->probe(of_dev, match);
-	if (error)
-		of_dev_put(of_dev);
-
-	return error;
-}
-
-static int of_platform_device_remove(struct device *dev)
-{
-	struct platform_device *of_dev = to_platform_device(dev);
-	struct of_platform_driver *drv = to_of_platform_driver(dev->driver);
-
-	if (dev->driver && drv->remove)
-		drv->remove(of_dev);
-	return 0;
-}
-
-static void of_platform_device_shutdown(struct device *dev)
-{
-	struct platform_device *of_dev = to_platform_device(dev);
-	struct of_platform_driver *drv = to_of_platform_driver(dev->driver);
-
-	if (dev->driver && drv->shutdown)
-		drv->shutdown(of_dev);
-}
-
-#ifdef CONFIG_PM_SLEEP
-
-static int of_platform_legacy_suspend(struct device *dev, pm_message_t mesg)
-{
-	struct platform_device *of_dev = to_platform_device(dev);
-	struct of_platform_driver *drv = to_of_platform_driver(dev->driver);
-	int ret = 0;
-
-	if (dev->driver && drv->suspend)
-		ret = drv->suspend(of_dev, mesg);
-	return ret;
-}
-
-static int of_platform_legacy_resume(struct device *dev)
-{
-	struct platform_device *of_dev = to_platform_device(dev);
-	struct of_platform_driver *drv = to_of_platform_driver(dev->driver);
-	int ret = 0;
-
-	if (dev->driver && drv->resume)
-		ret = drv->resume(of_dev);
-	return ret;
-}
-
-static int of_platform_pm_prepare(struct device *dev)
-{
-	struct device_driver *drv = dev->driver;
-	int ret = 0;
-
-	if (drv && drv->pm && drv->pm->prepare)
-		ret = drv->pm->prepare(dev);
-
-	return ret;
-}
-
-static void of_platform_pm_complete(struct device *dev)
-{
-	struct device_driver *drv = dev->driver;
-
-	if (drv && drv->pm && drv->pm->complete)
-		drv->pm->complete(dev);
-}
-
-#ifdef CONFIG_SUSPEND
-
-static int of_platform_pm_suspend(struct device *dev)
-{
-	struct device_driver *drv = dev->driver;
-	int ret = 0;
-
-	if (!drv)
-		return 0;
-
-	if (drv->pm) {
-		if (drv->pm->suspend)
-			ret = drv->pm->suspend(dev);
-	} else {
-		ret = of_platform_legacy_suspend(dev, PMSG_SUSPEND);
-	}
-
-	return ret;
-}
-
-static int of_platform_pm_suspend_noirq(struct device *dev)
-{
-	struct device_driver *drv = dev->driver;
-	int ret = 0;
-
-	if (!drv)
-		return 0;
-
-	if (drv->pm) {
-		if (drv->pm->suspend_noirq)
-			ret = drv->pm->suspend_noirq(dev);
-	}
-
-	return ret;
-}
-
-static int of_platform_pm_resume(struct device *dev)
-{
-	struct device_driver *drv = dev->driver;
-	int ret = 0;
-
-	if (!drv)
-		return 0;
-
-	if (drv->pm) {
-		if (drv->pm->resume)
-			ret = drv->pm->resume(dev);
-	} else {
-		ret = of_platform_legacy_resume(dev);
-	}
-
-	return ret;
-}
-
-static int of_platform_pm_resume_noirq(struct device *dev)
-{
-	struct device_driver *drv = dev->driver;
-	int ret = 0;
-
-	if (!drv)
-		return 0;
-
-	if (drv->pm) {
-		if (drv->pm->resume_noirq)
-			ret = drv->pm->resume_noirq(dev);
-	}
-
-	return ret;
-}
-
-#else /* !CONFIG_SUSPEND */
-
-#define of_platform_pm_suspend		NULL
-#define of_platform_pm_resume		NULL
-#define of_platform_pm_suspend_noirq	NULL
-#define of_platform_pm_resume_noirq	NULL
-
-#endif /* !CONFIG_SUSPEND */
-
-#ifdef CONFIG_HIBERNATION
-
-static int of_platform_pm_freeze(struct device *dev)
-{
-	struct device_driver *drv = dev->driver;
-	int ret = 0;
-
-	if (!drv)
-		return 0;
-
-	if (drv->pm) {
-		if (drv->pm->freeze)
-			ret = drv->pm->freeze(dev);
-	} else {
-		ret = of_platform_legacy_suspend(dev, PMSG_FREEZE);
-	}
-
-	return ret;
-}
-
-static int of_platform_pm_freeze_noirq(struct device *dev)
-{
-	struct device_driver *drv = dev->driver;
-	int ret = 0;
-
-	if (!drv)
-		return 0;
-
-	if (drv->pm) {
-		if (drv->pm->freeze_noirq)
-			ret = drv->pm->freeze_noirq(dev);
-	}
-
-	return ret;
-}
-
-static int of_platform_pm_thaw(struct device *dev)
-{
-	struct device_driver *drv = dev->driver;
-	int ret = 0;
-
-	if (!drv)
-		return 0;
-
-	if (drv->pm) {
-		if (drv->pm->thaw)
-			ret = drv->pm->thaw(dev);
-	} else {
-		ret = of_platform_legacy_resume(dev);
-	}
-
-	return ret;
-}
-
-static int of_platform_pm_thaw_noirq(struct device *dev)
-{
-	struct device_driver *drv = dev->driver;
-	int ret = 0;
-
-	if (!drv)
-		return 0;
-
-	if (drv->pm) {
-		if (drv->pm->thaw_noirq)
-			ret = drv->pm->thaw_noirq(dev);
-	}
-
-	return ret;
-}
-
-static int of_platform_pm_poweroff(struct device *dev)
-{
-	struct device_driver *drv = dev->driver;
-	int ret = 0;
-
-	if (!drv)
-		return 0;
-
-	if (drv->pm) {
-		if (drv->pm->poweroff)
-			ret = drv->pm->poweroff(dev);
-	} else {
-		ret = of_platform_legacy_suspend(dev, PMSG_HIBERNATE);
-	}
-
-	return ret;
-}
-
-static int of_platform_pm_poweroff_noirq(struct device *dev)
-{
-	struct device_driver *drv = dev->driver;
-	int ret = 0;
-
-	if (!drv)
-		return 0;
-
-	if (drv->pm) {
-		if (drv->pm->poweroff_noirq)
-			ret = drv->pm->poweroff_noirq(dev);
-	}
-
-	return ret;
-}
-
-static int of_platform_pm_restore(struct device *dev)
-{
-	struct device_driver *drv = dev->driver;
-	int ret = 0;
-
-	if (!drv)
-		return 0;
-
-	if (drv->pm) {
-		if (drv->pm->restore)
-			ret = drv->pm->restore(dev);
-	} else {
-		ret = of_platform_legacy_resume(dev);
-	}
-
-	return ret;
-}
-
-static int of_platform_pm_restore_noirq(struct device *dev)
-{
-	struct device_driver *drv = dev->driver;
-	int ret = 0;
-
-	if (!drv)
-		return 0;
-
-	if (drv->pm) {
-		if (drv->pm->restore_noirq)
-			ret = drv->pm->restore_noirq(dev);
-	}
-
-	return ret;
-}
-
-#else /* !CONFIG_HIBERNATION */
-
-#define of_platform_pm_freeze		NULL
-#define of_platform_pm_thaw		NULL
-#define of_platform_pm_poweroff		NULL
-#define of_platform_pm_restore		NULL
-#define of_platform_pm_freeze_noirq	NULL
-#define of_platform_pm_thaw_noirq		NULL
-#define of_platform_pm_poweroff_noirq	NULL
-#define of_platform_pm_restore_noirq	NULL
-
-#endif /* !CONFIG_HIBERNATION */
-
-static struct dev_pm_ops of_platform_dev_pm_ops = {
-	.prepare = of_platform_pm_prepare,
-	.complete = of_platform_pm_complete,
-	.suspend = of_platform_pm_suspend,
-	.resume = of_platform_pm_resume,
-	.freeze = of_platform_pm_freeze,
-	.thaw = of_platform_pm_thaw,
-	.poweroff = of_platform_pm_poweroff,
-	.restore = of_platform_pm_restore,
-	.suspend_noirq = of_platform_pm_suspend_noirq,
-	.resume_noirq = of_platform_pm_resume_noirq,
-	.freeze_noirq = of_platform_pm_freeze_noirq,
-	.thaw_noirq = of_platform_pm_thaw_noirq,
-	.poweroff_noirq = of_platform_pm_poweroff_noirq,
-	.restore_noirq = of_platform_pm_restore_noirq,
-};
-
-#define OF_PLATFORM_PM_OPS_PTR	(&of_platform_dev_pm_ops)
-
-#else /* !CONFIG_PM_SLEEP */
-
-#define OF_PLATFORM_PM_OPS_PTR	NULL
-
-#endif /* !CONFIG_PM_SLEEP */
-
-int of_bus_type_init(struct bus_type *bus, const char *name)
-{
-	bus->name = name;
-	bus->match = of_platform_bus_match;
-	bus->probe = of_platform_device_probe;
-	bus->remove = of_platform_device_remove;
-	bus->shutdown = of_platform_device_shutdown;
-	bus->dev_attrs = of_platform_device_attrs;
-	bus->pm = OF_PLATFORM_PM_OPS_PTR;
-	return bus_register(bus);
-}
-
-int of_register_driver(struct of_platform_driver *drv, struct bus_type *bus)
-{
-	/*
-	 * Temporary: of_platform_bus used to be distinct from the platform
-	 * bus.  It isn't anymore, and so drivers on the platform bus need
-	 * to be registered in a special way.
-	 *
-	 * After all of_platform_bus_type drivers are converted to
-	 * platform_drivers, this exception can be removed.
-	 */
-	if (bus == &platform_bus_type)
-		return of_register_platform_driver(drv);
-
-	/* register with core */
-	drv->driver.bus = bus;
-	return driver_register(&drv->driver);
-}
-EXPORT_SYMBOL(of_register_driver);
-
-void of_unregister_driver(struct of_platform_driver *drv)
-{
-	if (drv->driver.bus == &platform_bus_type)
-		of_unregister_platform_driver(drv);
-	else
-		driver_unregister(&drv->driver);
-}
-EXPORT_SYMBOL(of_unregister_driver);
-
 #if !defined(CONFIG_SPARC)
 /*
  * The following routines scan a subtree and registers a device for
diff --git a/include/linux/of_platform.h b/include/linux/of_platform.h
index a68716a..048949f 100644
--- a/include/linux/of_platform.h
+++ b/include/linux/of_platform.h
@@ -47,10 +47,6 @@ struct of_platform_driver
 #define	to_of_platform_driver(drv) \
 	container_of(drv,struct of_platform_driver, driver)
 
-extern int of_register_driver(struct of_platform_driver *drv,
-			      struct bus_type *bus);
-extern void of_unregister_driver(struct of_platform_driver *drv);
-
 /* Platform drivers register/unregister */
 extern int of_register_platform_driver(struct of_platform_driver *drv);
 extern void of_unregister_platform_driver(struct of_platform_driver *drv);
@@ -60,8 +56,6 @@ extern struct platform_device *of_device_alloc(struct device_node *np,
 					 struct device *parent);
 extern struct platform_device *of_find_device_by_node(struct device_node *np);
 
-extern int of_bus_type_init(struct bus_type *bus, const char *name);
-
 #if !defined(CONFIG_SPARC) /* SPARC has its own device registration method */
 /* Platform devices and busses creation */
 extern struct platform_device *of_platform_device_create(struct device_node *np,

