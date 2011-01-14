Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757345Ab1ANI2g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 03:28:36 -0500
Received: from mga02.intel.com ([134.134.136.20]:50031 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753577Ab1ANI23 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 03:28:29 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,322,1291622400"; 
   d="scan'208";a="696787019"
Date: Fri, 14 Jan 2011 16:23:10 +0800
From: Chuanxiao Dong <chuanxiao.dong@intel.com>
To: linux-mmc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, cjb@laptop.org, ohad@wizery.com
Subject: [PATCH v1 1/3]mmc: implemented runtime pm for mmc host
Message-ID: <20110114082310.GB27523@intel.com>
Reply-To: Chuanxiao Dong <chuanxiao.dong@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

MMC host need to power ungate host each time before sending a request and
try to power gate host each time after the request is done.

MMC host has a sysfs interface to let user specify the auto suspended delay.
Each slot of the host controller can have a different delay for runtime
suspended.

Signed-off-by: Chuanxiao Dong <chuanxiao.dong@intel.com>
---
 drivers/mmc/core/core.c |   15 +++++++++++++++
 drivers/mmc/core/host.c |   21 +++++++++++++++++++++
 2 files changed, 36 insertions(+), 0 deletions(-)

diff --git a/drivers/mmc/core/core.c b/drivers/mmc/core/core.c
index 6625c05..e296c5a 100644
--- a/drivers/mmc/core/core.c
+++ b/drivers/mmc/core/core.c
@@ -133,6 +133,9 @@ void mmc_request_done(struct mmc_host *host, struct mmc_request *mrq)
 			mrq->done(mrq);
 
 		mmc_host_clk_gate(host);
+
+		/* put the host after using */
+		pm_runtime_put(&host->class_dev);
 	}
 }
 
@@ -150,6 +153,12 @@ mmc_start_request(struct mmc_host *host, struct mmc_request *mrq)
 		 mmc_hostname(host), mrq->cmd->opcode,
 		 mrq->cmd->arg, mrq->cmd->flags);
 
+	/*
+	 * Before touch any of host controller registers,
+	 * driver should make sure the host is powered up
+	 */
+	pm_runtime_get_sync(&host->class_dev);
+
 	if (mrq->data) {
 		pr_debug("%s:     blksz %d blocks %d flags %08x "
 			"tsac %d ms nsac %d\n",
@@ -1522,6 +1531,9 @@ void mmc_rescan(struct work_struct *work)
 	if (host->rescan_disable)
 		return;
 
+	/* power up host controller first */
+	pm_runtime_get_sync(&host->class_dev);
+
 	mmc_bus_get(host);
 
 	/*
@@ -1564,6 +1576,9 @@ void mmc_rescan(struct work_struct *work)
 	mmc_release_host(host);
 
  out:
+	/* power off host controller */
+	pm_runtime_put(&host->class_dev);
+
 	if (host->caps & MMC_CAP_NEEDS_POLL)
 		mmc_schedule_delayed_work(&host->detect, HZ);
 }
diff --git a/drivers/mmc/core/host.c b/drivers/mmc/core/host.c
index b3ac6c5..a27b811 100644
--- a/drivers/mmc/core/host.c
+++ b/drivers/mmc/core/host.c
@@ -19,6 +19,7 @@
 #include <linux/leds.h>
 #include <linux/slab.h>
 #include <linux/suspend.h>
+#include <linux/pm_runtime.h>
 
 #include <linux/mmc/host.h>
 #include <linux/mmc/card.h>
@@ -28,6 +29,14 @@
 
 #define cls_dev_to_mmc_host(d)	container_of(d, struct mmc_host, class_dev)
 
+static const struct dev_pm_ops host_pm = {
+	SET_RUNTIME_PM_OPS(
+		pm_generic_runtime_suspend,
+		pm_generic_runtime_resume,
+		pm_generic_runtime_idle
+	)
+};
+
 static void mmc_host_classdev_release(struct device *dev)
 {
 	struct mmc_host *host = cls_dev_to_mmc_host(dev);
@@ -37,6 +46,7 @@ static void mmc_host_classdev_release(struct device *dev)
 static struct class mmc_host_class = {
 	.name		= "mmc_host",
 	.dev_release	= mmc_host_classdev_release,
+	.pm = &host_pm,
 };
 
 int mmc_register_host_class(void)
@@ -334,6 +344,15 @@ int mmc_add_host(struct mmc_host *host)
 	if (err)
 		return err;
 
+	/* enable runtime pm */
+	err = pm_runtime_set_active(&host->class_dev);
+	if (err)
+		pr_err("err is %d when active mmc host\n", err);
+	else {
+		pm_runtime_enable(&host->class_dev);
+		pm_runtime_set_autosuspend_delay(&host->class_dev, 100);
+	}
+
 #ifdef CONFIG_DEBUG_FS
 	mmc_add_host_debugfs(host);
 #endif
@@ -363,6 +382,8 @@ void mmc_remove_host(struct mmc_host *host)
 	mmc_remove_host_debugfs(host);
 #endif
 
+	pm_runtime_disable(&host->class_dev);
+
 	device_del(&host->class_dev);
 
 	led_trigger_unregister_simple(host->led);
-- 
1.6.6.1

