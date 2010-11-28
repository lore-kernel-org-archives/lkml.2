Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751603Ab0K1GUN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Nov 2010 01:20:13 -0500
Received: from mga02.intel.com ([134.134.136.20]:64660 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751366Ab0K1GUM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Nov 2010 01:20:12 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,269,1288594800"; 
   d="scan'208,223";a="681636686"
Date: Sun, 28 Nov 2010 13:53:15 +0800
From: Yunpeng Gao <yunpeng.gao@intel.com>
To: linux-mmc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH v1 3/3]mmc: changes to enable runtime PM of mmc core layer
Message-ID: <20101128055315.GD3318@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>From cac07f43de68615cca9f01f619870fdce05df2a2 Mon Sep 17 00:00:00 2001
From: Yunpeng Gao <yunpeng.gao@intel.com>
Date: Sun, 28 Nov 2010 13:00:42 +0800
Subject: [PATCH] Do some changes in mmc core layer to enable mmc card runtime pm.

Seems current runtime PM support in mmc core layer has some problems:

1. If host controller is PCI device, then it's possibly that the PCI
host controller will be runtime suspended immediately after its PCI
probe. Then it will have trouble when do the following mmc_rescan
since at that time the function driver (mmc block driver or sdio
function driver) has not been called and there's no chance to execute
pm_runtime_get().

2. Currently mmc_host_class (defined in drivers/mmc/core/host.c) is
parent of mmc_card and child of host controller. But mmc_host_class
has not implemented the runtime pm APIs of itself. So seems it'll
cause the mmc runtime PM chain disconnect here.

This patch tries to fix above 2 problems.
For 1, it adds pm_runtime_get/put at the begging/end of function
mmc_rescan().
For2, it implements a set of dummy runtime PM API for the
mmc_host_class.

Signed-off-by: Yunpeng Gao <yunpeng.gao@intel.com>
---
 drivers/mmc/core/bus.c  |    2 +-
 drivers/mmc/core/core.c |    4 ++++
 drivers/mmc/core/host.c |   35 +++++++++++++++++++++++++++++++++++
 3 files changed, 40 insertions(+), 1 deletions(-)

diff --git a/drivers/mmc/core/bus.c b/drivers/mmc/core/bus.c
index af8dc6a..96b6cff 100644
--- a/drivers/mmc/core/bus.c
+++ b/drivers/mmc/core/bus.c
@@ -160,7 +160,7 @@ static int mmc_runtime_resume(struct device *dev)
 
 static int mmc_runtime_idle(struct device *dev)
 {
-	return pm_runtime_suspend(dev);
+	return pm_schedule_suspend(dev, 100);
 }
 
 static const struct dev_pm_ops mmc_bus_pm_ops = {
diff --git a/drivers/mmc/core/core.c b/drivers/mmc/core/core.c
index 6286898..2905dac 100644
--- a/drivers/mmc/core/core.c
+++ b/drivers/mmc/core/core.c
@@ -22,6 +22,7 @@
 #include <linux/scatterlist.h>
 #include <linux/log2.h>
 #include <linux/regulator/consumer.h>
+#include <linux/pm_runtime.h>
 
 #include <linux/mmc/card.h>
 #include <linux/mmc/host.h>
@@ -1503,6 +1504,7 @@ void mmc_rescan(struct work_struct *work)
 
 	spin_unlock_irqrestore(&host->lock, flags);
 
+	pm_runtime_get_sync(host->parent);
 
 	mmc_bus_get(host);
 
@@ -1598,6 +1600,8 @@ out_fail:
 		mmc_power_off(host);
 	}
 out:
+	pm_runtime_put_sync(host->parent);
+
 	if (host->caps & MMC_CAP_NEEDS_POLL)
 		mmc_schedule_delayed_work(&host->detect, HZ);
 }
diff --git a/drivers/mmc/core/host.c b/drivers/mmc/core/host.c
index 92e3370..8268b8e 100644
--- a/drivers/mmc/core/host.c
+++ b/drivers/mmc/core/host.c
@@ -19,6 +19,7 @@
 #include <linux/leds.h>
 #include <linux/slab.h>
 #include <linux/suspend.h>
+#include <linux/pm_runtime.h>
 
 #include <linux/mmc/host.h>
 #include <linux/mmc/card.h>
@@ -28,6 +29,33 @@
 
 #define cls_dev_to_mmc_host(d)	container_of(d, struct mmc_host, class_dev)
 
+#ifdef CONFIG_PM_RUNTIME
+static int mmc_host_runtime_suspend(struct device *dev)
+{
+	return 0;
+}
+
+static int mmc_host_runtime_resume(struct device *dev)
+{
+	return 0;
+}
+
+static int mmc_host_runtime_idle(struct device *dev)
+{
+	return pm_runtime_suspend(dev);
+}
+#else
+#define mmc_host_runtime_suspend	NULL
+#define mmc_host_runtime_resume		NULL
+#define mmc_host_runtime_idle		NULL
+#endif
+
+const static struct dev_pm_ops host_pm = {
+	.runtime_suspend = mmc_host_runtime_suspend,
+	.runtime_resume = mmc_host_runtime_resume,
+	.runtime_idle = mmc_host_runtime_idle,
+};
+
 static void mmc_host_classdev_release(struct device *dev)
 {
 	struct mmc_host *host = cls_dev_to_mmc_host(dev);
@@ -37,6 +65,7 @@ static void mmc_host_classdev_release(struct device *dev)
 static struct class mmc_host_class = {
 	.name		= "mmc_host",
 	.dev_release	= mmc_host_classdev_release,
+	.pm		= &host_pm,
 };
 
 int mmc_register_host_class(void)
@@ -333,6 +362,12 @@ int mmc_add_host(struct mmc_host *host)
 	if (err)
 		return err;
 
+	/* Enable runtime PM */
+	pm_runtime_get_noresume(&host->class_dev);
+	pm_runtime_set_active(&host->class_dev);
+	pm_runtime_enable(&host->class_dev);
+	pm_runtime_put_sync(&host->class_dev);
+
 #ifdef CONFIG_DEBUG_FS
 	mmc_add_host_debugfs(host);
 #endif
-- 
1.6.6.1

