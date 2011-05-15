Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753395Ab1EOXeQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 May 2011 19:34:16 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:53452 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752977Ab1EOXeO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 May 2011 19:34:14 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux PM mailing list <linux-pm@lists.linux-foundation.org>
Subject: [PATCH 2/6] PM / Runtime: Support for generic I/O power domains (v4)
Date: Mon, 16 May 2011 01:31:17 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.39-rc7+; KDE/4.6.0; x86_64; ; )
Cc: Greg KH <gregkh@suse.de>, LKML <linux-kernel@vger.kernel.org>,
        Kevin Hilman <khilman@ti.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Magnus Damm <magnus.damm@gmail.com>, linux-sh@vger.kernel.org,
        MyungJoo Ham <myungjoo.ham@gmail.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Alan Stern <stern@rowland.harvard.edu>
References: <201104290154.12966.rjw@sisk.pl> <201105082320.57185.rjw@sisk.pl> <201105160117.46927.rjw@sisk.pl>
In-Reply-To: <201105160117.46927.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201105160131.18278.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Introduce common headers, helper functions and callbacks allowing
platforms to use simple generic power domains for runtime power
management.

Introduce struct generic_power_domain to be used for representing
power domains that each contain a number of devices and may be
master domains or subdomains with respect to other power domains.
Among other things, this structure includes callbacks to be
provided by platforms for performing specific tasks related to
power management (i.e. ->stop_device() may disable a device's
clocks, while ->start_device() may enable them, ->power_off() is
supposed to remove power from the entire power domain
and ->power_on() is supposed to restore it).

Introduce functions that can be used as power domain runtime PM
callbacks, pm_genpd_runtime_suspend() and pm_genpd_runtime_resume(),
as well as helper functions for the initialization of a power
domain represented by a struct generic_power_domain object,
adding a device to or removing a device from it and adding or
removing subdomains.

Introduce configuration option CONFIG_PM_GENERIC_DOMAINS to be
selected by the platforms that want to use the new code.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/power/Makefile |    1 
 drivers/base/power/domain.c |  446 ++++++++++++++++++++++++++++++++++++++++++++
 include/linux/pm.h          |    3 
 include/linux/pm_domain.h   |   75 +++++++
 kernel/power/Kconfig        |    4 
 5 files changed, 528 insertions(+), 1 deletion(-)

Index: linux-2.6/include/linux/pm_domain.h
===================================================================
--- /dev/null
+++ linux-2.6/include/linux/pm_domain.h
@@ -0,0 +1,75 @@
+/*
+ * pm_domain.h - Definitions and headers related to device power domains.
+ *
+ * Copyright (C) 2011 Rafael J. Wysocki <rjw@sisk.pl>, Renesas Electronics Corp.
+ *
+ * This file is released under the GPLv2.
+ */
+
+#ifndef _LINUX_PM_DOMAIN_H
+#define _LINUX_PM_DOMAIN_H
+
+#include <linux/device.h>
+
+struct dev_power_governor {
+	bool (*power_down_ok)(struct dev_power_domain *domain);
+};
+
+struct generic_power_domain {
+	struct dev_power_domain domain;
+	struct list_head node;
+	struct generic_power_domain *master;
+	struct list_head subdomain_list;
+	struct list_head device_list;
+	struct mutex lock;
+	struct dev_power_governor *gov;
+	unsigned int in_progress;
+	bool power_is_off;
+	int (*power_off)(struct dev_power_domain *domain);
+	int (*power_on)(struct dev_power_domain *domain);
+	int (*start_device)(struct device *dev);
+	int (*stop_device)(struct device *dev);
+};
+
+struct dev_list_entry {
+	struct list_head node;
+	struct device *dev;
+};
+
+#ifdef CONFIG_PM_GENERIC_DOMAINS
+extern int pm_genpd_add_device(struct generic_power_domain *genpd,
+			       struct device *dev);
+extern int pm_genpd_remove_device(struct generic_power_domain *genpd,
+				  struct device *dev);
+extern int pm_genpd_add_subdomain(struct generic_power_domain *genpd,
+				  struct generic_power_domain *new_subdomain);
+extern int pm_genpd_remove_subdomain(struct generic_power_domain *genpd,
+				     struct generic_power_domain *target);
+extern void pm_genpd_init(struct generic_power_domain *genpd,
+			  struct dev_power_governor *gov, bool is_off);
+#else
+static inline int pm_genpd_add_device(struct generic_power_domain *genpd,
+				      struct device *dev)
+{
+	return -ENOSYS;
+}
+static inline int pm_genpd_remove_device(struct generic_power_domain *genpd,
+					 struct device *dev)
+{
+	return -ENOSYS;
+}
+static inline int pm_genpd_add_subdomain(struct generic_power_domain *genpd,
+					 struct generic_power_domain *new_sd)
+{
+	return -ENOSYS;
+}
+static inline int pm_genpd_remove_subdomain(struct generic_power_domain *genpd,
+					    struct generic_power_domain *target)
+{
+	return -ENOSYS;
+}
+static inline void pm_genpd_init(struct generic_power_domain *genpd,
+				 struct dev_power_governor *gov, bool is_off) {}
+#endif
+
+#endif /* _LINUX_PM_DOMAIN_H */
Index: linux-2.6/include/linux/pm.h
===================================================================
--- linux-2.6.orig/include/linux/pm.h
+++ linux-2.6/include/linux/pm.h
@@ -472,7 +472,8 @@ extern void update_pm_runtime_accounting
  * subsystem-level and driver-level callbacks.
  */
 struct dev_power_domain {
-	struct dev_pm_ops	ops;
+	struct dev_pm_ops ops;
+	void *platform_data;
 };
 
 /*
Index: linux-2.6/drivers/base/power/Makefile
===================================================================
--- linux-2.6.orig/drivers/base/power/Makefile
+++ linux-2.6/drivers/base/power/Makefile
@@ -3,6 +3,7 @@ obj-$(CONFIG_PM_SLEEP)	+= main.o wakeup.
 obj-$(CONFIG_PM_RUNTIME)	+= runtime.o
 obj-$(CONFIG_PM_TRACE_RTC)	+= trace.o
 obj-$(CONFIG_PM_OPP)	+= opp.o
+obj-$(CONFIG_PM_GENERIC_DOMAINS)	+=  domain.o
 obj-$(CONFIG_HAVE_CLK)	+= clock_ops.o
 
 ccflags-$(CONFIG_DEBUG_DRIVER) := -DDEBUG
\ No newline at end of file
Index: linux-2.6/drivers/base/power/domain.c
===================================================================
--- /dev/null
+++ linux-2.6/drivers/base/power/domain.c
@@ -0,0 +1,446 @@
+/*
+ * drivers/base/power/domain.c - Common code related to device power domains.
+ *
+ * Copyright (C) 2011 Rafael J. Wysocki <rjw@sisk.pl>, Renesas Electronics Corp.
+ *
+ * This file is released under the GPLv2.
+ */
+
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/io.h>
+#include <linux/pm_runtime.h>
+#include <linux/pm_domain.h>
+#include <linux/slab.h>
+#include <linux/err.h>
+
+#ifdef CONFIG_PM_RUNTIME
+
+/**
+ * __pm_genpd_restore_device - Restore a pre-suspend state of a device.
+ * @dev: Device to restore the state of.
+ * @genpd: Power domain the device belongs to.
+ */
+static void __pm_genpd_restore_device(struct device *dev,
+				      struct generic_power_domain *genpd)
+{
+	struct device_driver *drv = dev->driver;
+
+	if (genpd->start_device)
+		genpd->start_device(dev);
+
+	if (drv && drv->pm && drv->pm->runtime_resume)
+		drv->pm->runtime_resume(dev);
+
+	if (genpd->stop_device)
+		genpd->stop_device(dev);
+}
+
+/**
+ * __pm_genpd_poweroff - Remove power from a given power domain.
+ * @genpd: Power domain to power down.
+ *
+ * If all of the @genpd's devices have been suspended and all of its subdomains
+ * have been powered down, run the runtime suspend callbacks provided by all of
+ * the @genpd's devices' drivers and remove power from @genpd.
+ */
+static int __pm_genpd_poweroff(struct generic_power_domain *genpd)
+{
+	struct generic_power_domain *subdomain;
+	struct dev_list_entry *dle;
+	unsigned int not_suspended;
+	int ret;
+
+	if (genpd->power_is_off)
+		return 0;
+
+	not_suspended = 0;
+	list_for_each_entry(dle, &genpd->device_list, node)
+		if (dle->dev->driver && !pm_runtime_suspended(dle->dev))
+			not_suspended++;
+
+	if (not_suspended > genpd->in_progress)
+		return -EBUSY;
+
+	list_for_each_entry_reverse(subdomain, &genpd->subdomain_list, node) {
+		mutex_lock(&subdomain->lock);
+		ret = __pm_genpd_poweroff(subdomain);
+		mutex_unlock(&subdomain->lock);
+		if (ret)
+			return ret;
+	}
+
+	if (genpd->gov && genpd->gov->power_down_ok) {
+		if (!genpd->gov->power_down_ok(&genpd->domain))
+			return -EAGAIN;
+	}
+
+	list_for_each_entry_reverse(dle, &genpd->device_list, node) {
+		struct device *dev = dle->dev;
+		struct device_driver *drv = dev->driver;
+
+		if (genpd->start_device)
+			genpd->start_device(dev);
+
+		if (drv && drv->pm && drv->pm->runtime_suspend)
+			ret = drv->pm->runtime_suspend(dev);
+
+		if (genpd->stop_device)
+			genpd->stop_device(dev);
+
+		if (ret)
+			goto err_dev;
+	}
+
+	if (genpd->power_off)
+		genpd->power_off(&genpd->domain);
+
+	genpd->power_is_off = true;
+
+	return 0;
+
+ err_dev:
+	list_for_each_entry_continue(dle, &genpd->device_list, node)
+		__pm_genpd_restore_device(dle->dev, genpd);
+
+	return ret;
+}
+
+/**
+ * pm_genpd_poweroff - Remove power from a given power domain and its masters.
+ * @genpd: Power domain to power down.
+ *
+ * Try to remove power from @genpd and all of its masters in order to save as
+ * much power as possible.
+ */
+static void pm_genpd_poweroff(struct generic_power_domain *genpd)
+{
+	struct generic_power_domain *master;
+
+	mutex_lock(&genpd->lock);
+	master = genpd->master;
+	if (master) {
+		mutex_unlock(&genpd->lock);
+		pm_genpd_poweroff(master);
+		return;
+	}
+	__pm_genpd_poweroff(genpd);
+	mutex_unlock(&genpd->lock);
+}
+
+/**
+ * pm_genpd_runtime_suspend - Suspend a device belonging to I/O power domain.
+ * @dev: Device to suspend.
+ *
+ * Carry out a runtime suspend of a device under the assumption that its
+ * pwr_domain field points to the domain member of an object of type
+ * struct generic_power_domain representing a power domain consisting of I/O
+ * devices.
+ */
+static int pm_genpd_runtime_suspend(struct device *dev)
+{
+	struct generic_power_domain *genpd, *master;
+
+	dev_dbg(dev, "%s()\n", __func__);
+
+	if (IS_ERR_OR_NULL(dev->pwr_domain))
+		return -EINVAL;
+
+	genpd = container_of(dev->pwr_domain,
+			     struct generic_power_domain, domain);
+
+	mutex_lock(&genpd->lock);
+
+	if (genpd->stop_device) {
+		int ret = genpd->stop_device(dev);
+		if (ret)
+			goto out;
+	}
+	genpd->in_progress++;
+
+	master = genpd->master;
+	if (master) {
+		mutex_unlock(&genpd->lock);
+
+		pm_genpd_poweroff(master);
+
+		mutex_lock(&genpd->lock);
+	} else {
+		__pm_genpd_poweroff(genpd);
+	}
+
+	genpd->in_progress--;
+
+ out:
+	mutex_unlock(&genpd->lock);
+
+	return 0;
+}
+
+/**
+ * __pm_genpd_poweron - Restore power for a given power domain.
+ * @genpd: Power domain to power up.
+ *
+ * Restore power for @genpd and run runtime resume callbacks provided by all of
+ * its devices' drivers.
+ */
+static int __pm_genpd_poweron(struct generic_power_domain *genpd)
+{
+	struct dev_list_entry *dle;
+
+	if (!genpd->power_is_off)
+		return 0;
+
+	if (genpd->power_on) {
+		int ret = genpd->power_on(&genpd->domain);
+		if (ret)
+			return ret;
+	}
+
+	genpd->power_is_off = false;
+
+	list_for_each_entry(dle, &genpd->device_list, node)
+		__pm_genpd_restore_device(dle->dev, genpd);
+
+	return 0;
+}
+
+/**
+ * pm_genpd_poweron - Restore power for a given power domain and its masters.
+ * @genpd: Power domain to power up.
+ *
+ * Restore power for @genpd and all of its masters so that it is possible to
+ * resume a device belonging to it.
+ */
+static int pm_genpd_poweron(struct generic_power_domain *genpd)
+{
+	struct generic_power_domain *master;
+	int ret;
+
+	mutex_lock(&genpd->lock);
+	master = genpd->master;
+	if (master) {
+		mutex_unlock(&genpd->lock);
+
+		ret = pm_genpd_poweron(master);
+		if (ret)
+			return ret;
+
+		mutex_lock(&genpd->lock);
+	}
+	ret = __pm_genpd_poweron(genpd);
+	mutex_unlock(&genpd->lock);
+
+	return ret;
+}
+
+/**
+ * pm_genpd_runtime_resume - Resume a device belonging to I/O power domain.
+ * @dev: Device to resume.
+ *
+ * Carry out a runtime resume of a device under the assumption that its
+ * pwr_domain field points to the domain member of an object of type
+ * struct generic_power_domain representing a power domain consisting of I/O
+ * devices.
+ */
+static int pm_genpd_runtime_resume(struct device *dev)
+{
+	struct generic_power_domain *genpd;
+	int ret;
+
+	dev_dbg(dev, "%s()\n", __func__);
+
+	if (IS_ERR_OR_NULL(dev->pwr_domain))
+		return -EINVAL;
+
+	genpd = container_of(dev->pwr_domain,
+			     struct generic_power_domain, domain);
+
+	ret = pm_genpd_poweron(genpd);
+	if (ret)
+		return ret;
+
+	if (genpd->start_device)
+		genpd->start_device(dev);
+
+	return 0;
+}
+
+#else
+
+#define pm_genpd_runtime_suspend	NULL
+#define pm_genpd_runtime_resume		NULL
+
+#endif /* CONFIG_PM_RUNTIME */
+
+/**
+ * pm_genpd_add_device - Add a device to an I/O power domain.
+ * @genpd: Power domain to add the device to.
+ * @dev: Device to be added.
+ */
+int pm_genpd_add_device(struct generic_power_domain *genpd, struct device *dev)
+{
+	struct dev_list_entry *dle;
+	int ret = 0;
+
+	dev_dbg(dev, "%s()\n", __func__);
+
+	if (IS_ERR_OR_NULL(genpd) || IS_ERR_OR_NULL(dev))
+		return -EINVAL;
+
+	mutex_lock(&genpd->lock);
+
+	list_for_each_entry(dle, &genpd->device_list, node)
+		if (dle->dev == dev) {
+			ret = -EINVAL;
+			goto out;
+		}
+
+	dle = kzalloc(sizeof(*dle), GFP_KERNEL);
+	if (!dle) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	dle->dev = dev;
+	list_add_tail(&dle->node, &genpd->device_list);
+
+	spin_lock_irq(&dev->power.lock);
+	dev->pwr_domain = &genpd->domain;
+	spin_unlock_irq(&dev->power.lock);
+
+ out:
+	mutex_unlock(&genpd->lock);
+
+	return ret;
+}
+
+/**
+ * pm_genpd_remove_device - Remove a device from an I/O power domain.
+ * @genpd: Power domain to remove the device from.
+ * @dev: Device to be removed.
+ */
+int pm_genpd_remove_device(struct generic_power_domain *genpd,
+			   struct device *dev)
+{
+	struct dev_list_entry *dle;
+	int ret = -EINVAL;
+
+	dev_dbg(dev, "%s()\n", __func__);
+
+	if (IS_ERR_OR_NULL(genpd) || IS_ERR_OR_NULL(dev))
+		return -EINVAL;
+
+	mutex_lock(&genpd->lock);
+
+	list_for_each_entry(dle, &genpd->device_list, node) {
+		if (dle->dev != dev)
+			continue;
+
+		spin_lock_irq(&dev->power.lock);
+		dev->pwr_domain = NULL;
+		spin_unlock_irq(&dev->power.lock);
+
+		list_del(&dle->node);
+		kfree(dle);
+
+		ret = 0;
+		break;
+	}
+
+	mutex_unlock(&genpd->lock);
+
+	return ret;
+}
+
+/**
+ * pm_genpd_add_subdomain - Add a subdomain to an I/O power domain.
+ * @genpd: Master power domain to add the subdomain to.
+ * @new_subdomain: Subdomain to be added.
+ */
+int pm_genpd_add_subdomain(struct generic_power_domain *genpd,
+			   struct generic_power_domain *new_subdomain)
+{
+	struct generic_power_domain *subdomain;
+	int ret = 0;
+
+	if (IS_ERR_OR_NULL(genpd) || IS_ERR_OR_NULL(new_subdomain))
+		return -EINVAL;
+
+	mutex_lock(&genpd->lock);
+
+	list_for_each_entry(subdomain, &genpd->subdomain_list, node)
+		if (subdomain == new_subdomain) {
+			ret = -EINVAL;
+			goto out;
+		}
+
+	mutex_lock(&new_subdomain->lock);
+	list_add_tail(&new_subdomain->node, &genpd->subdomain_list);
+	new_subdomain->master = genpd;
+	mutex_unlock(&new_subdomain->lock);
+
+ out:
+	mutex_unlock(&genpd->lock);
+
+	return ret;
+}
+
+/**
+ * pm_genpd_remove_subdomain - Remove a subdomain from an I/O power domain.
+ * @genpd: Master power domain to remove the subdomain from.
+ * @target: Subdomain to be removed.
+ */
+int pm_genpd_remove_subdomain(struct generic_power_domain *genpd,
+			      struct generic_power_domain *target)
+{
+	struct generic_power_domain *subdomain;
+	int ret = -EINVAL;
+
+	if (IS_ERR_OR_NULL(genpd) || IS_ERR_OR_NULL(target))
+		return -EINVAL;
+
+	mutex_lock(&genpd->lock);
+
+	list_for_each_entry(subdomain, &genpd->subdomain_list, node) {
+		if (subdomain != target)
+			continue;
+
+		mutex_lock(&subdomain->lock);
+		list_del(&subdomain->node);
+		subdomain->master = NULL;
+		mutex_unlock(&subdomain->lock);
+
+		ret = 0;
+		break;
+	}
+
+	mutex_unlock(&genpd->lock);
+
+	return ret;
+}
+
+/**
+ * pm_genpd_init - Initialize a generic I/O power domain object.
+ * @genpd: Power domain object to initialize.
+ * @gov: Power domain governor to associate with the domain (may be NULL).
+ * @is_off: Initial value of the domain's power_is_off field.
+ */
+void pm_genpd_init(struct generic_power_domain *genpd,
+		   struct dev_power_governor *gov, bool is_off)
+{
+	if (IS_ERR_OR_NULL(genpd))
+		return;
+
+	INIT_LIST_HEAD(&genpd->node);
+	genpd->master = NULL;
+	INIT_LIST_HEAD(&genpd->device_list);
+	INIT_LIST_HEAD(&genpd->subdomain_list);
+	mutex_init(&genpd->lock);
+	genpd->gov = gov;
+	genpd->in_progress = 0;
+	genpd->power_is_off = is_off;
+	genpd->domain.ops.runtime_suspend = pm_genpd_runtime_suspend;
+	genpd->domain.ops.runtime_resume = pm_genpd_runtime_resume;
+	genpd->domain.ops.runtime_idle = pm_generic_runtime_idle;
+}
Index: linux-2.6/kernel/power/Kconfig
===================================================================
--- linux-2.6.orig/kernel/power/Kconfig
+++ linux-2.6/kernel/power/Kconfig
@@ -227,3 +227,7 @@ config PM_OPP
 config PM_RUNTIME_CLK
 	def_bool y
 	depends on PM_RUNTIME && HAVE_CLK
+
+config PM_GENERIC_DOMAINS
+	bool
+	depends on PM

