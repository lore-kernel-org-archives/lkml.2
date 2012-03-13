Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759362Ab2CMVar (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 17:30:47 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:43206 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755216Ab2CMVap (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 17:30:45 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Linux-sh list" <linux-sh@vger.kernel.org>
Subject: [Update][PATCH 3/6] PM / Domains: Introduce "always on" device flag
Date: Tue, 13 Mar 2012 22:34:52 +0100
User-Agent: KMail/1.13.6 (Linux/3.3.0-rc7+; KDE/4.6.0; x86_64; ; )
Cc: Linux PM list <linux-pm@vger.kernel.org>, Paul Mundt <lethal@linux-sh.org>,
        Simon Horman <horms@verge.net.au>, Magnus Damm <magnus.damm@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, Cao Minh Hiep <hiepcm@gmail.com>
References: <201203130123.16268.rjw@sisk.pl> <201203130125.43385.rjw@sisk.pl>
In-Reply-To: <201203130125.43385.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201203132234.52298.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

The TMU device on the Mackerel board belongs to the A4R power domain
and loses power when the domain is turned off.  Unfortunately, the
TMU driver is not prepared to cope with such situations and crashes
the system when that happens.  To work around this problem introduce
a new helper function, pm_genpd_dev_always_on(), allowing a device
driver to mark its device as "always on" in case it belongs to a PM
domain, which will make the generic PM domains core code avoid
powering off the domain containing the device, both at run time and
during system suspend.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Tested-by: Simon Horman <horms@verge.net.au>
Acked-by: Paul Mundt <lethal@linux-sh.org>
---

The only change with respect to the previous version is the hunk in
pm_genpd_restore_noirq() which only affects hibernation.

Thanks,
Rafael

---
 drivers/base/power/domain.c |   37 +++++++++++++++++++++++++++++++------
 include/linux/pm_domain.h   |    3 +++
 2 files changed, 34 insertions(+), 6 deletions(-)

Index: linux/drivers/base/power/domain.c
===================================================================
--- linux.orig/drivers/base/power/domain.c
+++ linux/drivers/base/power/domain.c
@@ -366,7 +366,7 @@ static int pm_genpd_poweroff(struct gene
 	not_suspended = 0;
 	list_for_each_entry(pdd, &genpd->dev_list, list_node)
 		if (pdd->dev->driver && (!pm_runtime_suspended(pdd->dev)
-		    || pdd->dev->power.irq_safe))
+		    || pdd->dev->power.irq_safe || to_gpd_data(pdd)->always_on))
 			not_suspended++;
 
 	if (not_suspended > genpd->in_progress)
@@ -503,6 +503,9 @@ static int pm_genpd_runtime_suspend(stru
 
 	might_sleep_if(!genpd->dev_irq_safe);
 
+	if (dev_gpd_data(dev)->always_on)
+		return -EBUSY;
+
 	stop_ok = genpd->gov ? genpd->gov->stop_ok : NULL;
 	if (stop_ok && !stop_ok(dev))
 		return -EBUSY;
@@ -859,7 +862,7 @@ static int pm_genpd_suspend_noirq(struct
 	if (IS_ERR(genpd))
 		return -EINVAL;
 
-	if (genpd->suspend_power_off
+	if (genpd->suspend_power_off || dev_gpd_data(dev)->always_on
 	    || (dev->power.wakeup_path && genpd_dev_active_wakeup(genpd, dev)))
 		return 0;
 
@@ -892,7 +895,7 @@ static int pm_genpd_resume_noirq(struct
 	if (IS_ERR(genpd))
 		return -EINVAL;
 
-	if (genpd->suspend_power_off
+	if (genpd->suspend_power_off || dev_gpd_data(dev)->always_on
 	    || (dev->power.wakeup_path && genpd_dev_active_wakeup(genpd, dev)))
 		return 0;
 
@@ -1012,7 +1015,8 @@ static int pm_genpd_freeze_noirq(struct
 	if (IS_ERR(genpd))
 		return -EINVAL;
 
-	return genpd->suspend_power_off ? 0 : genpd_stop_dev(genpd, dev);
+	return genpd->suspend_power_off || dev_gpd_data(dev)->always_on ?
+		0 : genpd_stop_dev(genpd, dev);
 }
 
 /**
@@ -1032,7 +1036,8 @@ static int pm_genpd_thaw_noirq(struct de
 	if (IS_ERR(genpd))
 		return -EINVAL;
 
-	return genpd->suspend_power_off ? 0 : genpd_start_dev(genpd, dev);
+	return genpd->suspend_power_off || dev_gpd_data(dev)->always_on ?
+		0 : genpd_start_dev(genpd, dev);
 }
 
 /**
@@ -1125,7 +1130,7 @@ static int pm_genpd_restore_noirq(struct
 
 	pm_genpd_poweron(genpd);
 
-	return genpd_start_dev(genpd, dev);
+	return dev_gpd_data(dev)->always_on ? 0 : genpd_start_dev(genpd, dev);
 }
 
 /**
@@ -1289,6 +1294,26 @@ int pm_genpd_remove_device(struct generi
 }
 
 /**
+ * pm_genpd_dev_always_on - Set/unset the "always on" flag for a given device.
+ * @dev: Device to set/unset the flag for.
+ * @val: The new value of the device's "always on" flag.
+ */
+void pm_genpd_dev_always_on(struct device *dev, bool val)
+{
+	struct pm_subsys_data *psd;
+	unsigned long flags;
+
+	spin_lock_irqsave(&dev->power.lock, flags);
+
+	psd = dev_to_psd(dev);
+	if (psd && psd->domain_data)
+		to_gpd_data(psd->domain_data)->always_on = val;
+
+	spin_unlock_irqrestore(&dev->power.lock, flags);
+}
+EXPORT_SYMBOL_GPL(pm_genpd_dev_always_on);
+
+/**
  * pm_genpd_add_subdomain - Add a subdomain to an I/O PM domain.
  * @genpd: Master PM domain to add the subdomain to.
  * @subdomain: Subdomain to be added.
Index: linux/include/linux/pm_domain.h
===================================================================
--- linux.orig/include/linux/pm_domain.h
+++ linux/include/linux/pm_domain.h
@@ -97,6 +97,7 @@ struct generic_pm_domain_data {
 	struct gpd_dev_ops ops;
 	struct gpd_timing_data td;
 	bool need_restore;
+	bool always_on;
 };
 
 #ifdef CONFIG_PM_GENERIC_DOMAINS
@@ -125,6 +126,7 @@ static inline int pm_genpd_add_device(st
 
 extern int pm_genpd_remove_device(struct generic_pm_domain *genpd,
 				  struct device *dev);
+extern void pm_genpd_dev_always_on(struct device *dev, bool val);
 extern int pm_genpd_add_subdomain(struct generic_pm_domain *genpd,
 				  struct generic_pm_domain *new_subdomain);
 extern int pm_genpd_remove_subdomain(struct generic_pm_domain *genpd,
@@ -167,6 +169,7 @@ static inline int pm_genpd_remove_device
 {
 	return -ENOSYS;
 }
+static inline void pm_genpd_dev_always_on(struct device *dev, bool val) {}
 static inline int pm_genpd_add_subdomain(struct generic_pm_domain *genpd,
 					 struct generic_pm_domain *new_sd)
 {
