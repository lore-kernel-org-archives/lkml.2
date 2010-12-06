Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752515Ab0LFMwB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 07:52:01 -0500
Received: from mga09.intel.com ([134.134.136.24]:49951 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750732Ab0LFMwA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 07:52:00 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,305,1288594800"; 
   d="scan'208,223";a="684319838"
Date: Mon, 6 Dec 2010 20:24:32 +0800
From: Yunpeng Gao <yunpeng.gao@intel.com>
To: linux-mmc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH v2 3/3]mmc: changes to enable runtime PM of mmc core layer
Message-ID: <20101206122432.GD30654@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>From ab869336b1924e9f1d8bdc22aee5c5364941d286 Mon Sep 17 00:00:00 2001
From: Yunpeng Gao <yunpeng.gao@intel.com>
Date: Mon, 6 Dec 2010 20:03:00 +0800
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
For2, it calling the pm_runtime_no_callbacks() API to bypass the
mmc_host_class device.

Signed-off-by: Yunpeng Gao <yunpeng.gao@intel.com>
---
 drivers/mmc/core/core.c |    4 ++++
 drivers/mmc/core/host.c |    3 +++
 2 files changed, 7 insertions(+), 0 deletions(-)

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
index 92e3370..caa9e85 100644
--- a/drivers/mmc/core/host.c
+++ b/drivers/mmc/core/host.c
@@ -19,6 +19,7 @@
 #include <linux/leds.h>
 #include <linux/slab.h>
 #include <linux/suspend.h>
+#include <linux/pm_runtime.h>
 
 #include <linux/mmc/host.h>
 #include <linux/mmc/card.h>
@@ -303,6 +304,8 @@ struct mmc_host *mmc_alloc_host(int extra, struct device *dev)
 	host->max_blk_size = 512;
 	host->max_blk_count = PAGE_CACHE_SIZE / 512;
 
+	pm_runtime_no_callbacks(&host->class_dev);
+
 	return host;
 
 free:
-- 
1.6.6.1

