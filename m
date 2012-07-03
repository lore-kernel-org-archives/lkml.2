Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932360Ab2GCKYW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 06:24:22 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:50758 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753900Ab2GCKYF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 06:24:05 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux PM list <linux-pm@vger.kernel.org>
Subject: [PATCH 1/2] PM / Domains: Add device domain data reference counter
Date: Tue, 3 Jul 2012 12:28:41 +0200
User-Agent: KMail/1.13.6 (Linux/3.5.0-rc5+; KDE/4.6.0; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>, Magnus Damm <magnus.damm@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>
References: <201207031227.45383.rjw@sisk.pl>
In-Reply-To: <201207031227.45383.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201207031228.41960.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Add a mechanism for counting references to the
struct generic_pm_domain_data object pointed to by
dev->power.subsys_data->domain_data if the device in question
belongs to a generic PM domain.

This change is necessary for a subsequent patch making it possible to
allocate that object from within pm_genpd_add_callbacks(), so that
drivers can attach their PM domain device callbacks to devices before
those devices are added to PM domains.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/base/power/domain.c |   83 ++++++++++++++++++++++++++++++--------------
 include/linux/pm_domain.h   |    1 
 2 files changed, 58 insertions(+), 26 deletions(-)

Index: linux/include/linux/pm_domain.h
===================================================================
--- linux.orig/include/linux/pm_domain.h
+++ linux/include/linux/pm_domain.h
@@ -112,6 +112,7 @@ struct generic_pm_domain_data {
 	struct gpd_timing_data td;
 	struct notifier_block nb;
 	struct mutex lock;
+	unsigned int refcount;
 	bool need_restore;
 	bool always_on;
 };
Index: linux/drivers/base/power/domain.c
===================================================================
--- linux.orig/drivers/base/power/domain.c
+++ linux/drivers/base/power/domain.c
@@ -299,7 +299,7 @@ static int genpd_dev_pm_qos_notifier(str
 
 		pdd = dev->power.subsys_data ?
 				dev->power.subsys_data->domain_data : NULL;
-		if (pdd) {
+		if (pdd && pdd->dev) {
 			to_gpd_data(pdd)->td.constraint_changed = true;
 			genpd = dev_to_genpd(dev);
 		} else {
@@ -1272,6 +1272,27 @@ static void pm_genpd_complete(struct dev
 
 #endif /* CONFIG_PM_SLEEP */
 
+static struct generic_pm_domain_data *__pm_genpd_alloc_dev_data(struct device *dev)
+{
+	struct generic_pm_domain_data *gpd_data;
+
+	gpd_data = kzalloc(sizeof(*gpd_data), GFP_KERNEL);
+	if (!gpd_data)
+		return NULL;
+
+	mutex_init(&gpd_data->lock);
+	gpd_data->nb.notifier_call = genpd_dev_pm_qos_notifier;
+	dev_pm_qos_add_notifier(dev, &gpd_data->nb);
+	return gpd_data;
+}
+
+static void __pm_genpd_free_dev_data(struct device *dev,
+				     struct generic_pm_domain_data *gpd_data)
+{
+	dev_pm_qos_remove_notifier(dev, &gpd_data->nb);
+	kfree(gpd_data);
+}
+
 /**
  * __pm_genpd_add_device - Add a device to an I/O PM domain.
  * @genpd: PM domain to add the device to.
@@ -1281,7 +1302,7 @@ static void pm_genpd_complete(struct dev
 int __pm_genpd_add_device(struct generic_pm_domain *genpd, struct device *dev,
 			  struct gpd_timing_data *td)
 {
-	struct generic_pm_domain_data *gpd_data;
+	struct generic_pm_domain_data *gpd_data_new, *gpd_data = NULL;
 	struct pm_domain_data *pdd;
 	int ret = 0;
 
@@ -1290,14 +1311,10 @@ int __pm_genpd_add_device(struct generic
 	if (IS_ERR_OR_NULL(genpd) || IS_ERR_OR_NULL(dev))
 		return -EINVAL;
 
-	gpd_data = kzalloc(sizeof(*gpd_data), GFP_KERNEL);
-	if (!gpd_data)
+	gpd_data_new = __pm_genpd_alloc_dev_data(dev);
+	if (!gpd_data_new)
 		return -ENOMEM;
 
-	mutex_init(&gpd_data->lock);
-	gpd_data->nb.notifier_call = genpd_dev_pm_qos_notifier;
-	dev_pm_qos_add_notifier(dev, &gpd_data->nb);
-
 	genpd_acquire_lock(genpd);
 
 	if (genpd->prepared_count > 0) {
@@ -1311,35 +1328,42 @@ int __pm_genpd_add_device(struct generic
 			goto out;
 		}
 
+	ret = dev_pm_get_subsys_data(dev);
+	if (ret)
+		goto out;
+
 	genpd->device_count++;
 	genpd->max_off_time_changed = true;
 
-	dev_pm_get_subsys_data(dev);
-
-	mutex_lock(&gpd_data->lock);
 	spin_lock_irq(&dev->power.lock);
+
 	dev->pm_domain = &genpd->domain;
-	dev->power.subsys_data->domain_data = &gpd_data->base;
-	gpd_data->base.dev = dev;
-	list_add_tail(&gpd_data->base.list_node, &genpd->dev_list);
-	gpd_data->need_restore = genpd->status == GPD_STATE_POWER_OFF;
+	if (dev->power.subsys_data->domain_data) {
+		gpd_data = to_gpd_data(dev->power.subsys_data->domain_data);
+	} else {
+		gpd_data = gpd_data_new;
+		dev->power.subsys_data->domain_data = &gpd_data->base;
+	}
+	gpd_data->refcount++;
 	if (td)
 		gpd_data->td = *td;
 
+	spin_unlock_irq(&dev->power.lock);
+
+	mutex_lock(&gpd_data->lock);
+	gpd_data->base.dev = dev;
+	list_add_tail(&gpd_data->base.list_node, &genpd->dev_list);
+	gpd_data->need_restore = genpd->status == GPD_STATE_POWER_OFF;
 	gpd_data->td.constraint_changed = true;
 	gpd_data->td.effective_constraint_ns = -1;
-	spin_unlock_irq(&dev->power.lock);
 	mutex_unlock(&gpd_data->lock);
 
-	genpd_release_lock(genpd);
-
-	return 0;
-
  out:
 	genpd_release_lock(genpd);
 
-	dev_pm_qos_remove_notifier(dev, &gpd_data->nb);
-	kfree(gpd_data);
+	if (gpd_data != gpd_data_new)
+		__pm_genpd_free_dev_data(dev, gpd_data_new);
+
 	return ret;
 }
 
@@ -1385,6 +1409,7 @@ int pm_genpd_remove_device(struct generi
 {
 	struct generic_pm_domain_data *gpd_data;
 	struct pm_domain_data *pdd;
+	bool remove = false;
 	int ret = 0;
 
 	dev_dbg(dev, "%s()\n", __func__);
@@ -1405,22 +1430,28 @@ int pm_genpd_remove_device(struct generi
 	genpd->max_off_time_changed = true;
 
 	spin_lock_irq(&dev->power.lock);
+
 	dev->pm_domain = NULL;
 	pdd = dev->power.subsys_data->domain_data;
 	list_del_init(&pdd->list_node);
-	dev->power.subsys_data->domain_data = NULL;
+	gpd_data = to_gpd_data(pdd);
+	if (--gpd_data->refcount == 0) {
+		dev->power.subsys_data->domain_data = NULL;
+		remove = true;
+	}
+
 	spin_unlock_irq(&dev->power.lock);
 
-	gpd_data = to_gpd_data(pdd);
 	mutex_lock(&gpd_data->lock);
 	pdd->dev = NULL;
 	mutex_unlock(&gpd_data->lock);
 
 	genpd_release_lock(genpd);
 
-	dev_pm_qos_remove_notifier(dev, &gpd_data->nb);
-	kfree(gpd_data);
 	dev_pm_put_subsys_data(dev);
+	if (remove)
+		__pm_genpd_free_dev_data(dev, gpd_data);
+
 	return 0;
 
  out:

