Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966305Ab2C3VXZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 17:23:25 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:49266 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964818Ab2C3VXR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 17:23:17 -0400
Message-Id: <20120330194851.861211475@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 30 Mar 2012 12:50:33 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Simon Horman <horms@verge.net.au>, Paul Mundt <lethal@linux-sh.org>
Subject: [ 128/175] PM / Domains: Introduce "always on" device flag
In-Reply-To: <20120330195801.GA31806@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Rafael J. Wysocki <rjw@sisk.pl>

This is a backport of mainline commit
1e78a0c7fc92aee076965d516cf54475c39e9894.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/base/power/domain.c |   36 ++++++++++++++++++++++++++++++------
 include/linux/pm_domain.h   |    3 +++
 2 files changed, 33 insertions(+), 6 deletions(-)

--- a/drivers/base/power/domain.c
+++ b/drivers/base/power/domain.c
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
@@ -847,7 +850,8 @@ static int pm_genpd_suspend_noirq(struct
 	if (ret)
 		return ret;
 
-	if (dev->power.wakeup_path && genpd_dev_active_wakeup(genpd, dev))
+	if (dev_gpd_data(dev)->always_on
+	    || (dev->power.wakeup_path && genpd_dev_active_wakeup(genpd, dev)))
 		return 0;
 
 	genpd_stop_dev(genpd, dev);
@@ -882,7 +886,7 @@ static int pm_genpd_resume_noirq(struct
 	if (IS_ERR(genpd))
 		return -EINVAL;
 
-	if (genpd->suspend_power_off
+	if (genpd->suspend_power_off || dev_gpd_data(dev)->always_on
 	    || (dev->power.wakeup_path && genpd_dev_active_wakeup(genpd, dev)))
 		return 0;
 
@@ -960,7 +964,7 @@ static int pm_genpd_freeze_noirq(struct
 	if (IS_ERR(genpd))
 		return -EINVAL;
 
-	if (genpd->suspend_power_off)
+	if (genpd->suspend_power_off || dev_gpd_data(dev)->always_on)
 		return 0;
 
 	ret = genpd_freeze_late(genpd, dev);
@@ -991,7 +995,7 @@ static int pm_genpd_thaw_noirq(struct de
 	if (IS_ERR(genpd))
 		return -EINVAL;
 
-	if (genpd->suspend_power_off)
+	if (genpd->suspend_power_off || dev_gpd_data(dev)->always_on)
 		return 0;
 
 	genpd_start_dev(genpd, dev);
@@ -1064,7 +1068,7 @@ static int pm_genpd_restore_noirq(struct
 		}
 	}
 
-	if (genpd->suspend_power_off)
+	if (genpd->suspend_power_off || dev_gpd_data(dev)->always_on)
 		return 0;
 
 	pm_genpd_poweron(genpd);
@@ -1230,6 +1234,26 @@ int pm_genpd_remove_device(struct generi
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
--- a/include/linux/pm_domain.h
+++ b/include/linux/pm_domain.h
@@ -97,6 +97,7 @@ struct generic_pm_domain_data {
 	struct gpd_dev_ops ops;
 	struct gpd_timing_data td;
 	bool need_restore;
+	bool always_on;
 };
 
 static inline struct generic_pm_domain_data *to_gpd_data(struct pm_domain_data *pdd)
@@ -125,6 +126,7 @@ static inline int pm_genpd_add_device(st
 
 extern int pm_genpd_remove_device(struct generic_pm_domain *genpd,
 				  struct device *dev);
+extern void pm_genpd_dev_always_on(struct device *dev, bool val);
 extern int pm_genpd_add_subdomain(struct generic_pm_domain *genpd,
 				  struct generic_pm_domain *new_subdomain);
 extern int pm_genpd_remove_subdomain(struct generic_pm_domain *genpd,
@@ -163,6 +165,7 @@ static inline int pm_genpd_remove_device
 {
 	return -ENOSYS;
 }
+static inline void pm_genpd_dev_always_on(struct device *dev, bool val) {}
 static inline int pm_genpd_add_subdomain(struct generic_pm_domain *genpd,
 					 struct generic_pm_domain *new_sd)
 {


