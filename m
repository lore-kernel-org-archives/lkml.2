Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753286Ab1FKUkx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jun 2011 16:40:53 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:48647 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752279Ab1FKUkk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jun 2011 16:40:40 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux PM mailing list <linux-pm@lists.linux-foundation.org>
Subject: [PATCH 6/8] PM / Domains: Move code from under #ifdef CONFIG_PM_RUNTIME
Date: Sat, 11 Jun 2011 22:37:48 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.39+; KDE/4.6.0; x86_64; ; )
Cc: "Greg Kroah-Hartman" <gregkh@suse.de>, Magnus Damm <magnus.damm@gmail.com>,
        Paul Walmsley <paul@pwsan.com>, Kevin Hilman <khilman@ti.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        LKML <linux-kernel@vger.kernel.org>, linux-sh@vger.kernel.org
References: <201106112223.04972.rjw@sisk.pl>
In-Reply-To: <201106112223.04972.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201106112237.48634.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

There is some code in drivers/base/power/domain.c that will be useful
for both runtime PM and system-wide power transitions, so make it
depend on CONFIG_PM instead of CONFIG_PM_RUNTIME.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/base/power/domain.c |  118 +++++++++++++++++++++++---------------------
 1 file changed, 64 insertions(+), 54 deletions(-)

Index: linux-2.6/drivers/base/power/domain.c
===================================================================
--- linux-2.6.orig/drivers/base/power/domain.c
+++ linux-2.6/drivers/base/power/domain.c
@@ -14,6 +14,66 @@
 #include <linux/slab.h>
 #include <linux/err.h>
 
+#ifdef CONFIG_PM
+
+static struct generic_pm_domain *dev_to_genpd(struct device *dev)
+{
+	if (IS_ERR_OR_NULL(dev->pm_domain))
+		return ERR_PTR(-EINVAL);
+
+	return container_of(dev->pm_domain, struct generic_pm_domain, domain);
+}
+
+/**
+ * pm_genpd_poweron - Restore power to a given PM domain and its parents.
+ * @genpd: PM domain to power up.
+ *
+ * Restore power to @genpd and all of its parents so that it is possible to
+ * resume a device belonging to it.
+ */
+static int pm_genpd_poweron(struct generic_pm_domain *genpd)
+{
+	int ret = 0;
+
+ start:
+	if (genpd->parent)
+		mutex_lock(&genpd->parent->lock);
+	mutex_lock(&genpd->lock);
+
+	if (!genpd->power_is_off)
+		goto out;
+
+	if (genpd->parent && genpd->parent->power_is_off) {
+		mutex_unlock(&genpd->lock);
+		mutex_unlock(&genpd->parent->lock);
+
+		ret = pm_genpd_poweron(genpd->parent);
+		if (ret)
+			return ret;
+
+		goto start;
+	}
+
+	if (genpd->power_on) {
+		int ret = genpd->power_on(&genpd->domain);
+		if (ret)
+			goto out;
+	}
+
+	genpd->power_is_off = false;
+	if (genpd->parent)
+		genpd->parent->sd_count++;
+
+ out:
+	mutex_unlock(&genpd->lock);
+	if (genpd->parent)
+		mutex_unlock(&genpd->parent->lock);
+
+	return ret;
+}
+
+#endif /* CONFIG_PM */
+
 #ifdef CONFIG_PM_RUNTIME
 
 static void genpd_sd_counter_dec(struct generic_pm_domain *genpd)
@@ -155,11 +215,10 @@ static int pm_genpd_runtime_suspend(stru
 
 	dev_dbg(dev, "%s()\n", __func__);
 
-	if (IS_ERR_OR_NULL(dev->pm_domain))
+	genpd = dev_to_genpd(dev);
+	if (IS_ERR(genpd))
 		return -EINVAL;
 
-	genpd = container_of(dev->pm_domain, struct generic_pm_domain, domain);
-
 	if (genpd->parent)
 		mutex_lock(&genpd->parent->lock);
 	mutex_lock(&genpd->lock);
@@ -182,54 +241,6 @@ static int pm_genpd_runtime_suspend(stru
 }
 
 /**
- * pm_genpd_poweron - Restore power to a given PM domain and its parents.
- * @genpd: PM domain to power up.
- *
- * Restore power to @genpd and all of its parents so that it is possible to
- * resume a device belonging to it.
- */
-static int pm_genpd_poweron(struct generic_pm_domain *genpd)
-{
-	int ret = 0;
-
- start:
-	if (genpd->parent)
-		mutex_lock(&genpd->parent->lock);
-	mutex_lock(&genpd->lock);
-
-	if (!genpd->power_is_off)
-		goto out;
-
-	if (genpd->parent && genpd->parent->power_is_off) {
-		mutex_unlock(&genpd->lock);
-		mutex_unlock(&genpd->parent->lock);
-
-		ret = pm_genpd_poweron(genpd->parent);
-		if (ret)
-			return ret;
-
-		goto start;
-	}
-
-	if (genpd->power_on) {
-		int ret = genpd->power_on(&genpd->domain);
-		if (ret)
-			goto out;
-	}
-
-	genpd->power_is_off = false;
-	if (genpd->parent)
-		genpd->parent->sd_count++;
-
- out:
-	mutex_unlock(&genpd->lock);
-	if (genpd->parent)
-		mutex_unlock(&genpd->parent->lock);
-
-	return ret;
-}
-
-/**
  * pm_genpd_runtime_resume - Resume a device belonging to I/O PM domain.
  * @dev: Device to resume.
  *
@@ -245,11 +256,10 @@ static int pm_genpd_runtime_resume(struc
 
 	dev_dbg(dev, "%s()\n", __func__);
 
-	if (IS_ERR_OR_NULL(dev->pm_domain))
+	genpd = dev_to_genpd(dev);
+	if (IS_ERR(genpd))
 		return -EINVAL;
 
-	genpd = container_of(dev->pm_domain, struct generic_pm_domain, domain);
-
 	ret = pm_genpd_poweron(genpd);
 	if (ret)
 		return ret;

