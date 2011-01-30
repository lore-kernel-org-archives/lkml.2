Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754773Ab1A3AID (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Jan 2011 19:08:03 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:49581 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751342Ab1A3AIB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Jan 2011 19:08:01 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Linux-pm mailing list" <linux-pm@lists.linux-foundation.org>
Subject: [RFC][PATCH] Power domains for platform bus type
Date: Sun, 30 Jan 2011 01:07:19 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.38-rc2+; KDE/4.4.4; x86_64; ; )
Cc: Greg KH <greg@kroah.com>, LKML <linux-kernel@vger.kernel.org>,
        Magnus Damm <magnus.damm@gmail.com>, Kevin Hilman <khilman@ti.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Grant Likely <grant.likely@secretlab.ca>, Len Brown <lenb@kernel.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201101300107.19389.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This is something we discussed during the last Linux Plumbers Conference.

The problem appears to be that the same device may be used in different
systems in different configurations such that actions necessary for the
device's power management can vary from one system to another.  In those
cases the drivers' power management callbacks are generally not sufficient,
because they can't take the configuration of the whole system into account.

I think this issue may be addressed by adding objects that will represent
power domains and will provide power management callbacks to be executed
in addition to the device driver's PM callbacks, which is done by the patch
below.

Please have a look at it and tell me what you think.

Thanks,
Rafael

---
The platform bus type is often used to represent Systems-on-a-Chip
(SoC) where all devices are represented by objects of type struct
platform_device.  In those cases the same "platform" device driver
may be used in multiple different system configurations, but the
actions needed to put the devices it handles into a low-power state
and back into the full-power state may depend on the design of the
SoC.  The driver, however, cannot possibly include all the
information necessary for the power management of its device on all
the systems it's used with.  Moreover, the device hierarchy also
isn't suitable for holding this kind of information.

The patch below attempts to address this problem by introducing
objects of type struct power_domain that can be used for representing
power domains inside of the SoC.  Every struct power_domain object
consists of two sets of device power management callbacks that
can be used to perform what's needed for device power management
in addition to the operations carried out by the device's driver.
Namely, if a struct power_domain object is pointed to by the domain
field in a struct platform_device, the callbacks provided by its
pre_ops member will be executed for the dev member of that
struct platform_device before executing the corresponding callbacks
provided by the device's driver.  Analogously, the power domain's
post_ops callbacks will be executed after the corresponding callbacks
provided by the device's driver.
---
 drivers/base/platform.c         |  266 ++++++++++++++++++++++++++++------------
 include/linux/platform_device.h |    6 
 2 files changed, 198 insertions(+), 74 deletions(-)

Index: linux-2.6/include/linux/platform_device.h
===================================================================
--- linux-2.6.orig/include/linux/platform_device.h
+++ linux-2.6/include/linux/platform_device.h
@@ -14,6 +14,11 @@
 #include <linux/device.h>
 #include <linux/mod_devicetable.h>
 
+struct power_domain {
+	struct dev_pm_ops *pre_ops;
+	struct dev_pm_ops *post_ops;
+};
+
 struct platform_device {
 	const char	* name;
 	int		id;
@@ -22,6 +27,7 @@ struct platform_device {
 	struct resource	* resource;
 
 	const struct platform_device_id	*id_entry;
+	const struct power_domain *domain;
 
 	/* arch specific additions */
 	struct pdev_archdata	archdata;
Index: linux-2.6/drivers/base/platform.c
===================================================================
--- linux-2.6.orig/drivers/base/platform.c
+++ linux-2.6/drivers/base/platform.c
@@ -697,68 +697,98 @@ static void platform_pm_complete(struct
 int __weak platform_pm_suspend(struct device *dev)
 {
 	struct device_driver *drv = dev->driver;
+	struct platform_device *pdev = to_platform_device(dev);
+	const struct power_domain *pd = pdev->domain;
 	int ret = 0;
 
-	if (!drv)
-		return 0;
+	if (pd && pd->pre_ops && pd->pre_ops->suspend)
+		pd->pre_ops->suspend(dev);
 
-	if (drv->pm) {
-		if (drv->pm->suspend)
-			ret = drv->pm->suspend(dev);
-	} else {
-		ret = platform_legacy_suspend(dev, PMSG_SUSPEND);
+	if (drv) {
+		if (drv->pm) {
+			if (drv->pm->suspend)
+				ret = drv->pm->suspend(dev);
+		} else {
+			ret = platform_legacy_suspend(dev, PMSG_SUSPEND);
+		}
+		if (ret)
+			return ret;
 	}
 
+	if (pd && pd->post_ops && pd->post_ops->suspend)
+		pd->post_ops->suspend(dev);
+
 	return ret;
 }
 
 int __weak platform_pm_suspend_noirq(struct device *dev)
 {
 	struct device_driver *drv = dev->driver;
+	struct platform_device *pdev = to_platform_device(dev);
+	const struct power_domain *pd = pdev->domain;
 	int ret = 0;
 
-	if (!drv)
-		return 0;
+	if (pd && pd->pre_ops && pd->pre_ops->suspend_noirq)
+		pd->pre_ops->suspend_noirq(dev);
 
-	if (drv->pm) {
-		if (drv->pm->suspend_noirq)
-			ret = drv->pm->suspend_noirq(dev);
+	if (drv && drv->pm && drv->pm->suspend_noirq) {
+		ret = drv->pm->suspend_noirq(dev);
+		if (ret)
+			return ret;
 	}
 
+	if (pd && pd->post_ops && pd->post_ops->suspend_noirq)
+		pd->post_ops->suspend_noirq(dev);
+
 	return ret;
 }
 
 int __weak platform_pm_resume(struct device *dev)
 {
 	struct device_driver *drv = dev->driver;
+	struct platform_device *pdev = to_platform_device(dev);
+	const struct power_domain *pd = pdev->domain;
 	int ret = 0;
 
-	if (!drv)
-		return 0;
+	if (pd && pd->pre_ops && pd->pre_ops->resume)
+		pd->pre_ops->resume(dev);
 
-	if (drv->pm) {
-		if (drv->pm->resume)
-			ret = drv->pm->resume(dev);
-	} else {
-		ret = platform_legacy_resume(dev);
+	if (drv) {
+		if (drv->pm) {
+			if (drv->pm->resume)
+				ret = drv->pm->resume(dev);
+		} else {
+			ret = platform_legacy_resume(dev);
+		}
+		if (ret)
+			return ret;
 	}
 
+	if (pd && pd->post_ops && pd->post_ops->resume)
+		pd->post_ops->resume(dev);
+
 	return ret;
 }
 
 int __weak platform_pm_resume_noirq(struct device *dev)
 {
 	struct device_driver *drv = dev->driver;
+	struct platform_device *pdev = to_platform_device(dev);
+	const struct power_domain *pd = pdev->domain;
 	int ret = 0;
 
-	if (!drv)
-		return 0;
+	if (pd && pd->pre_ops && pd->pre_ops->resume_noirq)
+		pd->pre_ops->resume_noirq(dev);
 
-	if (drv->pm) {
-		if (drv->pm->resume_noirq)
-			ret = drv->pm->resume_noirq(dev);
+	if (drv && drv->pm && drv->pm->resume_noirq) {
+		ret = drv->pm->resume_noirq(dev);
+		if (ret)
+			return ret;
 	}
 
+	if (pd && pd->post_ops && pd->post_ops->resume_noirq)
+		pd->post_ops->resume_noirq(dev);
+
 	return ret;
 }
 
@@ -776,136 +806,196 @@ int __weak platform_pm_resume_noirq(stru
 static int platform_pm_freeze(struct device *dev)
 {
 	struct device_driver *drv = dev->driver;
+	struct platform_device *pdev = to_platform_device(dev);
+	const struct power_domain *pd = pdev->domain;
 	int ret = 0;
 
-	if (!drv)
-		return 0;
+	if (pd && pd->pre_ops && pd->pre_ops->freeze)
+		pd->pre_ops->freeze(dev);
 
-	if (drv->pm) {
-		if (drv->pm->freeze)
-			ret = drv->pm->freeze(dev);
-	} else {
-		ret = platform_legacy_suspend(dev, PMSG_FREEZE);
+	if (drv) {
+		if (drv->pm) {
+			if (drv->pm->freeze)
+				ret = drv->pm->freeze(dev);
+		} else {
+			ret = platform_legacy_suspend(dev, PMSG_FREEZE);
+		}
+		if (ret)
+			return ret;
 	}
 
+	if (pd && pd->post_ops && pd->post_ops->freeze)
+		pd->post_ops->freeze(dev);
+
 	return ret;
 }
 
 static int platform_pm_freeze_noirq(struct device *dev)
 {
 	struct device_driver *drv = dev->driver;
+	struct platform_device *pdev = to_platform_device(dev);
+	const struct power_domain *pd = pdev->domain;
 	int ret = 0;
 
-	if (!drv)
-		return 0;
+	if (pd && pd->pre_ops && pd->pre_ops->freeze_noirq)
+		pd->pre_ops->freeze_noirq(dev);
 
-	if (drv->pm) {
-		if (drv->pm->freeze_noirq)
-			ret = drv->pm->freeze_noirq(dev);
+	if (drv && drv->pm && drv->pm->freeze_noirq) {
+		ret = drv->pm->freeze_noirq(dev);
+		if (ret)
+			return ret;
 	}
 
+	if (pd && pd->post_ops && pd->post_ops->freeze_noirq)
+		pd->post_ops->freeze_noirq(dev);
+
 	return ret;
 }
 
 static int platform_pm_thaw(struct device *dev)
 {
 	struct device_driver *drv = dev->driver;
+	struct platform_device *pdev = to_platform_device(dev);
+	const struct power_domain *pd = pdev->domain;
 	int ret = 0;
 
-	if (!drv)
-		return 0;
+	if (pd && pd->pre_ops && pd->pre_ops->thaw)
+		pd->pre_ops->thaw(dev);
 
-	if (drv->pm) {
-		if (drv->pm->thaw)
-			ret = drv->pm->thaw(dev);
-	} else {
-		ret = platform_legacy_resume(dev);
+	if (drv) {
+		if (drv->pm) {
+			if (drv->pm->thaw)
+				ret = drv->pm->thaw(dev);
+		} else {
+			ret = platform_legacy_resume(dev);
+		}
+		if (ret)
+			return ret;
 	}
 
+	if (pd && pd->post_ops && pd->post_ops->thaw)
+		pd->post_ops->thaw(dev);
+
 	return ret;
 }
 
 static int platform_pm_thaw_noirq(struct device *dev)
 {
 	struct device_driver *drv = dev->driver;
+	struct platform_device *pdev = to_platform_device(dev);
+	const struct power_domain *pd = pdev->domain;
 	int ret = 0;
 
-	if (!drv)
-		return 0;
+	if (pd && pd->pre_ops && pd->pre_ops->thaw_noirq)
+		pd->pre_ops->thaw_noirq(dev);
 
-	if (drv->pm) {
-		if (drv->pm->thaw_noirq)
-			ret = drv->pm->thaw_noirq(dev);
+	if (drv && drv->pm && drv->pm->thaw_noirq) {
+		ret = drv->pm->thaw_noirq(dev);
+		if (ret)
+			return ret;
 	}
 
+	if (pd && pd->post_ops && pd->post_ops->thaw_noirq)
+		pd->post_ops->thaw_noirq(dev);
+
 	return ret;
 }
 
 static int platform_pm_poweroff(struct device *dev)
 {
 	struct device_driver *drv = dev->driver;
+	struct platform_device *pdev = to_platform_device(dev);
+	const struct power_domain *pd = pdev->domain;
 	int ret = 0;
 
-	if (!drv)
-		return 0;
+	if (pd && pd->pre_ops && pd->pre_ops->poweroff)
+		pd->pre_ops->poweroff(dev);
 
-	if (drv->pm) {
-		if (drv->pm->poweroff)
-			ret = drv->pm->poweroff(dev);
-	} else {
-		ret = platform_legacy_suspend(dev, PMSG_HIBERNATE);
+	if (drv) {
+		if (drv->pm) {
+			if (drv->pm->poweroff)
+				ret = drv->pm->poweroff(dev);
+		} else {
+			ret = platform_legacy_suspend(dev, PMSG_HIBERNATE);
+		}
+		if (ret)
+			return ret;
 	}
 
+	if (pd && pd->post_ops && pd->post_ops->poweroff)
+		pd->post_ops->poweroff(dev);
+
 	return ret;
 }
 
 static int platform_pm_poweroff_noirq(struct device *dev)
 {
 	struct device_driver *drv = dev->driver;
+	struct platform_device *pdev = to_platform_device(dev);
+	const struct power_domain *pd = pdev->domain;
 	int ret = 0;
 
-	if (!drv)
-		return 0;
+	if (pd && pd->pre_ops && pd->pre_ops->poweroff_noirq)
+		pd->pre_ops->poweroff_noirq(dev);
 
-	if (drv->pm) {
-		if (drv->pm->poweroff_noirq)
-			ret = drv->pm->poweroff_noirq(dev);
+	if (drv && drv->pm && drv->pm->poweroff_noirq) {
+		ret = drv->pm->poweroff_noirq(dev);
+		if (ret)
+			return ret;
 	}
 
+	if (pd && pd->post_ops && pd->post_ops->poweroff_noirq)
+		pd->post_ops->poweroff_noirq(dev);
+
 	return ret;
 }
 
 static int platform_pm_restore(struct device *dev)
 {
 	struct device_driver *drv = dev->driver;
+	struct platform_device *pdev = to_platform_device(dev);
+	const struct power_domain *pd = pdev->domain;
 	int ret = 0;
 
-	if (!drv)
-		return 0;
+	if (pd && pd->pre_ops && pd->pre_ops->restore)
+		pd->pre_ops->restore(dev);
 
-	if (drv->pm) {
-		if (drv->pm->restore)
-			ret = drv->pm->restore(dev);
-	} else {
-		ret = platform_legacy_resume(dev);
+	if (drv) {
+		if (drv->pm) {
+			if (drv->pm->restore)
+				ret = drv->pm->restore(dev);
+		} else {
+			ret = platform_legacy_resume(dev);
+		}
+		if (ret)
+			return ret;
 	}
 
+	if (pd && pd->post_ops && pd->post_ops->restore)
+		pd->post_ops->restore(dev);
+
 	return ret;
 }
 
 static int platform_pm_restore_noirq(struct device *dev)
 {
 	struct device_driver *drv = dev->driver;
+	struct platform_device *pdev = to_platform_device(dev);
+	const struct power_domain *pd = pdev->domain;
 	int ret = 0;
 
-	if (!drv)
-		return 0;
+	if (pd && pd->pre_ops && pd->pre_ops->restore_noirq)
+		pd->pre_ops->restore_noirq(dev);
 
-	if (drv->pm) {
-		if (drv->pm->restore_noirq)
-			ret = drv->pm->restore_noirq(dev);
+	if (drv && drv->pm && drv->pm->restore_noirq) {
+		ret = drv->pm->restore_noirq(dev);
+		if (ret)
+			return ret;
 	}
 
+	if (pd && pd->post_ops && pd->post_ops->restore_noirq)
+		pd->post_ops->restore_noirq(dev);
+
 	return ret;
 }
 
@@ -926,12 +1016,40 @@ static int platform_pm_restore_noirq(str
 
 int __weak platform_pm_runtime_suspend(struct device *dev)
 {
-	return pm_generic_runtime_suspend(dev);
+	struct platform_device *pdev = to_platform_device(dev);
+	const struct power_domain *pd = pdev->domain;
+	int ret;
+
+	if (pd && pd->pre_ops && pd->pre_ops->runtime_suspend)
+		pd->pre_ops->runtime_suspend(dev);
+
+	ret = pm_generic_runtime_suspend(dev);
+	if (ret)
+		return ret;
+
+	if (pd && pd->post_ops && pd->post_ops->runtime_suspend)
+		pd->post_ops->runtime_suspend(dev);
+
+	return 0;
 };
 
 int __weak platform_pm_runtime_resume(struct device *dev)
 {
-	return pm_generic_runtime_resume(dev);
+	struct platform_device *pdev = to_platform_device(dev);
+	const struct power_domain *pd = pdev->domain;
+	int ret;
+
+	if (pd && pd->pre_ops && pd->pre_ops->runtime_resume)
+		pd->pre_ops->runtime_resume(dev);
+
+	ret = pm_generic_runtime_resume(dev);
+	if (ret)
+		return ret;
+
+	if (pd && pd->post_ops && pd->post_ops->runtime_resume)
+		pd->post_ops->runtime_resume(dev);
+
+	return 0;
 };
 
 int __weak platform_pm_runtime_idle(struct device *dev)
