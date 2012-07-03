Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932279Ab2GCKYU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 06:24:20 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:50762 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753515Ab2GCKYF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 06:24:05 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux PM list <linux-pm@vger.kernel.org>
Subject: [PATCH 2/2] PM / Domains: Allow device callbacks to be added at any time
Date: Tue, 3 Jul 2012 12:29:25 +0200
User-Agent: KMail/1.13.6 (Linux/3.5.0-rc5+; KDE/4.6.0; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>, Magnus Damm <magnus.damm@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>
References: <201207031227.45383.rjw@sisk.pl>
In-Reply-To: <201207031227.45383.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201207031229.25301.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Make it possible to modify device callbacks used by the generic PM
domains core code at any time, not only after the device has been
added to a domain.  This will allow device drivers to provide their
own device PM domain callbacks even if they are registered before
adding the devices to PM domains.

For this purpose, use the observation that the struct
generic_pm_domain_data object containing the relevant callback
pointers may be allocated by pm_genpd_add_callbacks() and the
callbacks may be set before __pm_genpd_add_device() is run for
the given device.  This object will then be used by
__pm_genpd_add_device(), but it has to be protected from
premature removal by reference counting.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/base/power/domain.c |   66 ++++++++++++++++++++++++++++++++++----------
 1 file changed, 51 insertions(+), 15 deletions(-)

Index: linux/drivers/base/power/domain.c
===================================================================
--- linux.orig/drivers/base/power/domain.c
+++ linux/drivers/base/power/domain.c
@@ -1609,33 +1609,52 @@ int pm_genpd_remove_subdomain(struct gen
  * @dev: Device to add the callbacks to.
  * @ops: Set of callbacks to add.
  * @td: Timing data to add to the device along with the callbacks (optional).
+ *
+ * Every call to this routine should be balanced with a call to
+ * __pm_genpd_remove_callbacks() and they must not be nested.
  */
 int pm_genpd_add_callbacks(struct device *dev, struct gpd_dev_ops *ops,
 			   struct gpd_timing_data *td)
 {
-	struct pm_domain_data *pdd;
+	struct generic_pm_domain_data *gpd_data_new, *gpd_data = NULL;
 	int ret = 0;
 
-	if (!(dev && dev->power.subsys_data && ops))
+	if (!(dev && ops))
 		return -EINVAL;
 
+	gpd_data_new = __pm_genpd_alloc_dev_data(dev);
+	if (!gpd_data_new)
+		return -ENOMEM;
+
 	pm_runtime_disable(dev);
 	device_pm_lock();
 
-	pdd = dev->power.subsys_data->domain_data;
-	if (pdd) {
-		struct generic_pm_domain_data *gpd_data = to_gpd_data(pdd);
-
-		gpd_data->ops = *ops;
-		if (td)
-			gpd_data->td = *td;
+	ret = dev_pm_get_subsys_data(dev);
+	if (ret)
+		goto out;
+
+	spin_lock_irq(&dev->power.lock);
+
+	if (dev->power.subsys_data->domain_data) {
+		gpd_data = to_gpd_data(dev->power.subsys_data->domain_data);
 	} else {
-		ret = -EINVAL;
+		gpd_data = gpd_data_new;
+		dev->power.subsys_data->domain_data = &gpd_data->base;
 	}
+	gpd_data->refcount++;
+	gpd_data->ops = *ops;
+	if (td)
+		gpd_data->td = *td;
+
+	spin_unlock_irq(&dev->power.lock);
 
+ out:
 	device_pm_unlock();
 	pm_runtime_enable(dev);
 
+	if (gpd_data != gpd_data_new)
+		__pm_genpd_free_dev_data(dev, gpd_data_new);
+
 	return ret;
 }
 EXPORT_SYMBOL_GPL(pm_genpd_add_callbacks);
@@ -1644,10 +1663,13 @@ EXPORT_SYMBOL_GPL(pm_genpd_add_callbacks
  * __pm_genpd_remove_callbacks - Remove PM domain callbacks from a given device.
  * @dev: Device to remove the callbacks from.
  * @clear_td: If set, clear the device's timing data too.
+ *
+ * This routine can only be called after pm_genpd_add_callbacks().
  */
 int __pm_genpd_remove_callbacks(struct device *dev, bool clear_td)
 {
-	struct pm_domain_data *pdd;
+	struct generic_pm_domain_data *gpd_data = NULL;
+	bool remove = false;
 	int ret = 0;
 
 	if (!(dev && dev->power.subsys_data))
@@ -1656,21 +1678,35 @@ int __pm_genpd_remove_callbacks(struct d
 	pm_runtime_disable(dev);
 	device_pm_lock();
 
-	pdd = dev->power.subsys_data->domain_data;
-	if (pdd) {
-		struct generic_pm_domain_data *gpd_data = to_gpd_data(pdd);
+	spin_lock_irq(&dev->power.lock);
 
+	if (dev->power.subsys_data->domain_data) {
+		gpd_data = to_gpd_data(dev->power.subsys_data->domain_data);
 		gpd_data->ops = (struct gpd_dev_ops){ 0 };
 		if (clear_td)
 			gpd_data->td = (struct gpd_timing_data){ 0 };
+
+		if (--gpd_data->refcount == 0) {
+			dev->power.subsys_data->domain_data = NULL;
+			remove = true;
+		}
 	} else {
 		ret = -EINVAL;
 	}
 
+	spin_unlock_irq(&dev->power.lock);
+
 	device_pm_unlock();
 	pm_runtime_enable(dev);
 
-	return ret;
+	if (ret)
+		return ret;
+
+	dev_pm_put_subsys_data(dev);
+	if (remove)
+		__pm_genpd_free_dev_data(dev, gpd_data);
+
+	return 0;
 }
 EXPORT_SYMBOL_GPL(__pm_genpd_remove_callbacks);
 

