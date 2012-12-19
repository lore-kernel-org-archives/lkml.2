Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751450Ab2LSFpH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 00:45:07 -0500
Received: from mga02.intel.com ([134.134.136.20]:32573 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751124Ab2LSFpA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 00:45:00 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,313,1355126400"; 
   d="scan'208";a="236229154"
Subject: [PATCH] mmc: sdio: Removing the unnecessary runtime_get/put in
 sdio_bus_remove()
From: Chuansheng Liu <chuansheng.liu@intel.com>
To: cjb@laptop.org, ohad@wizery.com
Cc: linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        chuansheng.liu@intel.com
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 19 Dec 2012 22:51:17 +0800
Message-ID: <1355928677.1839.9.camel@cliu38-desktop-build>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The runtime_get_sync() is called during sdio_bus_probe(), then the device
will be kept in active runtime state, so not neccessary to call
runtime_get_sync/put_noidle() again in sdio_bus_remove().

Signed-off-by: liu chuansheng <chuansheng.liu@intel.com>
---
 drivers/mmc/core/sdio_bus.c |    8 --------
 1 files changed, 0 insertions(+), 8 deletions(-)

diff --git a/drivers/mmc/core/sdio_bus.c b/drivers/mmc/core/sdio_bus.c
index 5e57048..b576b70 100644
--- a/drivers/mmc/core/sdio_bus.c
+++ b/drivers/mmc/core/sdio_bus.c
@@ -167,10 +167,6 @@ static int sdio_bus_remove(struct device *dev)
 	struct sdio_func *func = dev_to_sdio_func(dev);
 	int ret = 0;
 
-	/* Make sure card is powered before invoking ->remove() */
-	if (func->card->host->caps & MMC_CAP_POWER_OFF_CARD)
-		pm_runtime_get_sync(dev);
-
 	drv->remove(func);
 
 	if (func->irq_handler) {
@@ -181,10 +177,6 @@ static int sdio_bus_remove(struct device *dev)
 		sdio_release_host(func);
 	}
 
-	/* First, undo the increment made directly above */
-	if (func->card->host->caps & MMC_CAP_POWER_OFF_CARD)
-		pm_runtime_put_noidle(dev);
-
 	/* Then undo the runtime PM settings in sdio_bus_probe() */
 	if (func->card->host->caps & MMC_CAP_POWER_OFF_CARD)
 		pm_runtime_put_sync(dev);
-- 
1.7.0.4



