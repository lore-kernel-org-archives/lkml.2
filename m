Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752758Ab1H3WVQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 18:21:16 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:49745 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752269Ab1H3WVM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 18:21:12 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux PM mailing list <linux-pm@lists.linux-foundation.org>
Subject: [PATCH 1/5] PM / Domains: Split device PM domain data into base and need_restore
Date: Wed, 31 Aug 2011 00:18:43 +0200
User-Agent: KMail/1.13.6 (Linux/3.1.0-rc4+; KDE/4.6.0; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>,
        "Linux-sh list" <linux-sh@vger.kernel.org>,
        Magnus Damm <magnus.damm@gmail.com>, Kevin Hilman <khilman@ti.com>,
        jean.pihet@newoldbits.com
References: <201108310017.03103.rjw@sisk.pl>
In-Reply-To: <201108310017.03103.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201108310018.43385.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

The struct pm_domain_data data type is defined in such a way that
adding new fields specific to the generic PM domains code will
require include/linux/pm.h to be modified.  As a result, data types
used only by the generic PM domains code will be defined in two
headers, although they all should be defined in pm_domain.h and
pm.h will need to include more headers, which won't be very nice.

For this reason change the definition of struct pm_subsys_data
so that its domain_data member is a pointer, which will allow
struct pm_domain_data to be subclassed by various PM domains
implementations.  Remove the need_restore member from
struct pm_domain_data and make the generic PM domains code
subclass it by adding the need_restore member to the new data type.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/base/power/domain.c |   28 +++++++++++++++++++---------
 include/linux/pm.h          |    3 +--
 include/linux/pm_domain.h   |   10 ++++++++++
 3 files changed, 30 insertions(+), 11 deletions(-)

Index: linux/include/linux/pm.h
===================================================================
--- linux.orig/include/linux/pm.h
+++ linux/include/linux/pm.h
@@ -433,7 +433,6 @@ struct wakeup_source;
 struct pm_domain_data {
 	struct list_head list_node;
 	struct device *dev;
-	bool need_restore;
 };
 
 struct pm_subsys_data {
@@ -443,7 +442,7 @@ struct pm_subsys_data {
 	struct list_head clock_list;
 #endif
 #ifdef CONFIG_PM_GENERIC_DOMAINS
-	struct pm_domain_data domain_data;
+	struct pm_domain_data *domain_data;
 #endif
 };
 
Index: linux/include/linux/pm_domain.h
===================================================================
--- linux.orig/include/linux/pm_domain.h
+++ linux/include/linux/pm_domain.h
@@ -62,6 +62,16 @@ struct gpd_link {
 	struct list_head slave_node;
 };
 
+struct generic_pm_domain_data {
+	struct pm_domain_data base;
+	bool need_restore;
+};
+
+static inline struct generic_pm_domain_data *to_gpd_data(struct pm_domain_data *pdd)
+{
+	return container_of(pdd, struct generic_pm_domain_data, base);
+}
+
 #ifdef CONFIG_PM_GENERIC_DOMAINS
 extern int pm_genpd_add_device(struct generic_pm_domain *genpd,
 			       struct device *dev);
Index: linux/drivers/base/power/domain.c
===================================================================
--- linux.orig/drivers/base/power/domain.c
+++ linux/drivers/base/power/domain.c
@@ -188,11 +188,12 @@ static int __pm_genpd_save_device(struct
 				  struct generic_pm_domain *genpd)
 	__releases(&genpd->lock) __acquires(&genpd->lock)
 {
+	struct generic_pm_domain_data *gpd_data = to_gpd_data(pdd);
 	struct device *dev = pdd->dev;
 	struct device_driver *drv = dev->driver;
 	int ret = 0;
 
-	if (pdd->need_restore)
+	if (gpd_data->need_restore)
 		return 0;
 
 	mutex_unlock(&genpd->lock);
@@ -210,7 +211,7 @@ static int __pm_genpd_save_device(struct
 	mutex_lock(&genpd->lock);
 
 	if (!ret)
-		pdd->need_restore = true;
+		gpd_data->need_restore = true;
 
 	return ret;
 }
@@ -224,10 +225,11 @@ static void __pm_genpd_restore_device(st
 				      struct generic_pm_domain *genpd)
 	__releases(&genpd->lock) __acquires(&genpd->lock)
 {
+	struct generic_pm_domain_data *gpd_data = to_gpd_data(pdd);
 	struct device *dev = pdd->dev;
 	struct device_driver *drv = dev->driver;
 
-	if (!pdd->need_restore)
+	if (!gpd_data->need_restore)
 		return;
 
 	mutex_unlock(&genpd->lock);
@@ -244,7 +246,7 @@ static void __pm_genpd_restore_device(st
 
 	mutex_lock(&genpd->lock);
 
-	pdd->need_restore = false;
+	gpd_data->need_restore = false;
 }
 
 /**
@@ -493,7 +495,7 @@ static int pm_genpd_runtime_resume(struc
 		mutex_lock(&genpd->lock);
 	}
 	finish_wait(&genpd->status_wait_queue, &wait);
-	__pm_genpd_restore_device(&dev->power.subsys_data->domain_data, genpd);
+	__pm_genpd_restore_device(dev->power.subsys_data->domain_data, genpd);
 	genpd->resume_count--;
 	genpd_set_active(genpd);
 	wake_up_all(&genpd->status_wait_queue);
@@ -1080,6 +1082,7 @@ static void pm_genpd_complete(struct dev
  */
 int pm_genpd_add_device(struct generic_pm_domain *genpd, struct device *dev)
 {
+	struct generic_pm_domain_data *gpd_data;
 	struct pm_domain_data *pdd;
 	int ret = 0;
 
@@ -1106,14 +1109,20 @@ int pm_genpd_add_device(struct generic_p
 			goto out;
 		}
 
+	gpd_data = kzalloc(sizeof(*gpd_data), GFP_KERNEL);
+	if (!gpd_data) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
 	genpd->device_count++;
 
 	dev->pm_domain = &genpd->domain;
 	dev_pm_get_subsys_data(dev);
-	pdd = &dev->power.subsys_data->domain_data;
-	pdd->dev = dev;
-	pdd->need_restore = false;
-	list_add_tail(&pdd->list_node, &genpd->dev_list);
+	dev->power.subsys_data->domain_data = &gpd_data->base;
+	gpd_data->base.dev = dev;
+	gpd_data->need_restore = false;
+	list_add_tail(&gpd_data->base.list_node, &genpd->dev_list);
 
  out:
 	genpd_release_lock(genpd);
@@ -1152,6 +1161,7 @@ int pm_genpd_remove_device(struct generi
 		pdd->dev = NULL;
 		dev_pm_put_subsys_data(dev);
 		dev->pm_domain = NULL;
+		kfree(to_gpd_data(pdd));
 
 		genpd->device_count--;
 

