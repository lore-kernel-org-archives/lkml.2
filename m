Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757873Ab1DXVov (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Apr 2011 17:44:51 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:47176 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757791Ab1DXVos (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Apr 2011 17:44:48 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux PM mailing list <linux-pm@lists.linux-foundation.org>
Subject: [PATCH 3/9] shmobile: Use power domains for platform runtime PM
Date: Sun, 24 Apr 2011 23:38:18 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.39-rc4+; KDE/4.6.0; x86_64; ; )
Cc: Kevin Hilman <khilman@ti.com>, LKML <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>, Len Brown <lenb@kernel.org>,
        linux-sh@vger.kernel.org, lethal@linux-sh.org,
        Magnus Damm <magnus.damm@gmail.com>,
        Alan Stern <stern@rowland.harvard.edu>, Greg KH <gregkh@suse.de>
References: <201104130205.26988.rjw@sisk.pl> <201104170135.19388.rjw@sisk.pl> <201104242330.13607.rjw@sisk.pl>
In-Reply-To: <201104242330.13607.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201104242338.18350.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

shmobile platforms replace the runtime PM callbacks of the platform
bus type with their own routines, but this means that the callbacks
are replaced system-wide.  This may not be the right approach if the
platform devices on the system are not of the same type (e.g. some
of them belong to an SoC and the others are located in separate
chips), because in those cases they may require different handling.
Thus it is better to use power domains to override the platform bus
type's PM handling, as it generally is possible to use different
power domains for devices with different PM requirements.

Define a default power domain for shmobile in both the SH and ARM
falvors and use it to override the platform bus type's PM callbacks.
Since the suspend and hibernate callbacks of the new "default" power
domains need to be the same and the platform bus type's suspend and
hibernate callbacks for the time being, export those callbacks so
that can be used outside of the platform bus type code.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 arch/arm/mach-shmobile/pm_runtime.c      |   25 ++++++++++++++++-------
 arch/sh/kernel/cpu/shmobile/pm_runtime.c |   33 ++++++++++++++++++++-----------
 2 files changed, 40 insertions(+), 18 deletions(-)

Index: linux-2.6/arch/arm/mach-shmobile/pm_runtime.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-shmobile/pm_runtime.c
+++ linux-2.6/arch/arm/mach-shmobile/pm_runtime.c
@@ -66,11 +66,11 @@ static void platform_pm_runtime_bug(stru
 		dev_err(dev, "runtime pm suspend before resume\n");
 }
 
-int platform_pm_runtime_suspend(struct device *dev)
+static int default_platform_runtime_suspend(struct device *dev)
 {
 	struct pm_runtime_data *prd = __to_prd(dev);
 
-	dev_dbg(dev, "platform_pm_runtime_suspend()\n");
+	dev_dbg(dev, "%s()\n", __func__);
 
 	platform_pm_runtime_bug(dev, prd);
 
@@ -82,11 +82,11 @@ int platform_pm_runtime_suspend(struct d
 	return 0;
 }
 
-int platform_pm_runtime_resume(struct device *dev)
+static int default_platform_runtime_resume(struct device *dev)
 {
 	struct pm_runtime_data *prd = __to_prd(dev);
 
-	dev_dbg(dev, "platform_pm_runtime_resume()\n");
+	dev_dbg(dev, "%s()\n", __func__);
 
 	platform_pm_runtime_init(dev, prd);
 
@@ -98,12 +98,21 @@ int platform_pm_runtime_resume(struct de
 	return 0;
 }
 
-int platform_pm_runtime_idle(struct device *dev)
+static int default_platform_runtime_idle(struct device *dev)
 {
 	/* suspend synchronously to disable clocks immediately */
 	return pm_runtime_suspend(dev);
 }
 
+static struct dev_power_domain default_power_domain = {
+	.ops = {
+		.runtime_suspend = default_platform_runtime_suspend,
+		.runtime_resume = default_platform_runtime_resume,
+		.runtime_idle = default_platform_runtime_idle,
+		USE_PLATFORM_PM_SLEEP_OPS
+	},
+};
+
 static int platform_bus_notify(struct notifier_block *nb,
 			       unsigned long action, void *data)
 {
@@ -114,10 +123,12 @@ static int platform_bus_notify(struct no
 
 	if (action == BUS_NOTIFY_BIND_DRIVER) {
 		prd = devres_alloc(__devres_release, sizeof(*prd), GFP_KERNEL);
-		if (prd)
+		if (prd) {
 			devres_add(dev, prd);
-		else
+			dev->pwr_domain = &default_power_domain;
+		} else {
 			dev_err(dev, "unable to alloc memory for runtime pm\n");
+		}
 	}
 
 	return 0;
Index: linux-2.6/arch/sh/kernel/cpu/shmobile/pm_runtime.c
===================================================================
--- linux-2.6.orig/arch/sh/kernel/cpu/shmobile/pm_runtime.c
+++ linux-2.6/arch/sh/kernel/cpu/shmobile/pm_runtime.c
@@ -139,7 +139,7 @@ void platform_pm_runtime_suspend_idle(vo
 	queue_work(pm_wq, &hwblk_work);
 }
 
-int platform_pm_runtime_suspend(struct device *dev)
+static int default_platform_runtime_suspend(struct device *dev)
 {
 	struct platform_device *pdev = to_platform_device(dev);
 	struct pdev_archdata *ad = &pdev->archdata;
@@ -147,7 +147,7 @@ int platform_pm_runtime_suspend(struct d
 	int hwblk = ad->hwblk_id;
 	int ret = 0;
 
-	dev_dbg(dev, "platform_pm_runtime_suspend() [%d]\n", hwblk);
+	dev_dbg(dev, "%s() [%d]\n", __func__, hwblk);
 
 	/* ignore off-chip platform devices */
 	if (!hwblk)
@@ -183,20 +183,20 @@ int platform_pm_runtime_suspend(struct d
 	mutex_unlock(&ad->mutex);
 
 out:
-	dev_dbg(dev, "platform_pm_runtime_suspend() [%d] returns %d\n",
-		hwblk, ret);
+	dev_dbg(dev, "%s() [%d] returns %d\n",
+		 __func__, hwblk, ret);
 
 	return ret;
 }
 
-int platform_pm_runtime_resume(struct device *dev)
+static int default_platform_runtime_resume(struct device *dev)
 {
 	struct platform_device *pdev = to_platform_device(dev);
 	struct pdev_archdata *ad = &pdev->archdata;
 	int hwblk = ad->hwblk_id;
 	int ret = 0;
 
-	dev_dbg(dev, "platform_pm_runtime_resume() [%d]\n", hwblk);
+	dev_dbg(dev, "%s() [%d]\n", __func__, hwblk);
 
 	/* ignore off-chip platform devices */
 	if (!hwblk)
@@ -228,19 +228,19 @@ int platform_pm_runtime_resume(struct de
 	 */
 	mutex_unlock(&ad->mutex);
 out:
-	dev_dbg(dev, "platform_pm_runtime_resume() [%d] returns %d\n",
-		hwblk, ret);
+	dev_dbg(dev, "%s() [%d] returns %d\n",
+		__func__, hwblk, ret);
 
 	return ret;
 }
 
-int platform_pm_runtime_idle(struct device *dev)
+static int default_platform_runtime_idle(struct device *dev)
 {
 	struct platform_device *pdev = to_platform_device(dev);
 	int hwblk = pdev->archdata.hwblk_id;
 	int ret = 0;
 
-	dev_dbg(dev, "platform_pm_runtime_idle() [%d]\n", hwblk);
+	dev_dbg(dev, "%s() [%d]\n", __func__, hwblk);
 
 	/* ignore off-chip platform devices */
 	if (!hwblk)
@@ -252,10 +252,19 @@ int platform_pm_runtime_idle(struct devi
 	/* suspend synchronously to disable clocks immediately */
 	ret = pm_runtime_suspend(dev);
 out:
-	dev_dbg(dev, "platform_pm_runtime_idle() [%d] done!\n", hwblk);
+	dev_dbg(dev, "%s() [%d] done!\n", __func__, hwblk);
 	return ret;
 }
 
+static struct dev_power_domain default_power_domain = {
+	.ops = {
+		.runtime_suspend = default_platform_runtime_suspend,
+		.runtime_resume = default_platform_runtime_resume,
+		.runtime_idle = default_platform_runtime_idle,
+		USE_PLATFORM_PM_SLEEP_OPS
+	},
+};
+
 static int platform_bus_notify(struct notifier_block *nb,
 			       unsigned long action, void *data)
 {
@@ -276,6 +285,7 @@ static int platform_bus_notify(struct no
 		hwblk_disable(hwblk_info, hwblk);
 		/* make sure driver re-inits itself once */
 		__set_bit(PDEV_ARCHDATA_FLAG_INIT, &pdev->archdata.flags);
+		dev->pwr_domain = &default_power_domain;
 		break;
 	/* TODO: add BUS_NOTIFY_BIND_DRIVER and increase idle count */
 	case BUS_NOTIFY_BOUND_DRIVER:
@@ -289,6 +299,7 @@ static int platform_bus_notify(struct no
 		__set_bit(PDEV_ARCHDATA_FLAG_INIT, &pdev->archdata.flags);
 		break;
 	case BUS_NOTIFY_DEL_DEVICE:
+		dev->pwr_domain = NULL;
 		break;
 	}
 	return 0;

