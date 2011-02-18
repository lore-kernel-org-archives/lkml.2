Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932534Ab1BRDLB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 22:11:01 -0500
Received: from LUNGE.MIT.EDU ([18.54.1.69]:51879 "EHLO lunge.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932492Ab1BRDIN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 22:08:13 -0500
From: Andres Salomon <dilinger@queued.net>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org, Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: [PATCH 21/29] ds1wm: use mfd_data instead of driver_data
Date: Thu, 17 Feb 2011 19:07:28 -0800
Message-Id: <1297998456-7615-22-git-send-email-dilinger@queued.net>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1297998456-7615-1-git-send-email-dilinger@queued.net>
References: <1297998456-7615-1-git-send-email-dilinger@queued.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use mfd_data for passing information from mfd drivers to mfd
clients.  The mfd_cell's driver_data field is being phased out.

Clients that were using driver_data now access .mfd_data
via mfd_get_data().  This changes ds1wm only; mfd drivers with
other cells are not modified, with the exception of led_cell.

The led_cell.driver_data line is dropped from htc-pasic3.c in this
patch as well.  It's not used in mainline (there's no leds-pasic3
platform driver), so it should be safe to take care of that here.

Signed-off-by: Andres Salomon <dilinger@queued.net>
---
 drivers/mfd/asic3.c        |    2 +-
 drivers/mfd/htc-pasic3.c   |    3 +--
 drivers/w1/masters/ds1wm.c |    4 ++--
 3 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/mfd/asic3.c b/drivers/mfd/asic3.c
index 71d2901..549d14d 100644
--- a/drivers/mfd/asic3.c
+++ b/drivers/mfd/asic3.c
@@ -682,7 +682,7 @@ static struct mfd_cell asic3_cell_ds1wm = {
 	.name          = "ds1wm",
 	.enable        = ds1wm_enable,
 	.disable       = ds1wm_disable,
-	.driver_data   = &ds1wm_pdata,
+	.mfd_data      = &ds1wm_pdata,
 	.num_resources = ARRAY_SIZE(ds1wm_resources),
 	.resources     = ds1wm_resources,
 };
diff --git a/drivers/mfd/htc-pasic3.c b/drivers/mfd/htc-pasic3.c
index 079d396..fb9770b 100644
--- a/drivers/mfd/htc-pasic3.c
+++ b/drivers/mfd/htc-pasic3.c
@@ -117,7 +117,7 @@ static struct mfd_cell ds1wm_cell __initdata = {
 	.name          = "ds1wm",
 	.enable        = ds1wm_enable,
 	.disable       = ds1wm_disable,
-	.driver_data   = &ds1wm_pdata,
+	.mfd_data      = &ds1wm_pdata,
 	.num_resources = 2,
 	.resources     = ds1wm_resources,
 };
@@ -172,7 +172,6 @@ static int __init pasic3_probe(struct platform_device *pdev)
 	}
 
 	if (pdata && pdata->led_pdata) {
-		led_cell.driver_data = pdata->led_pdata;
 		ret = mfd_add_devices(&pdev->dev, pdev->id, &led_cell, 1, r, 0);
 		if (ret < 0)
 			dev_warn(dev, "failed to register LED device\n");
diff --git a/drivers/w1/masters/ds1wm.c b/drivers/w1/masters/ds1wm.c
index 94f55d8..22fc726 100644
--- a/drivers/w1/masters/ds1wm.c
+++ b/drivers/w1/masters/ds1wm.c
@@ -216,7 +216,7 @@ static int ds1wm_find_divisor(int gclk)
 static void ds1wm_up(struct ds1wm_data *ds1wm_data)
 {
 	int divisor;
-	struct ds1wm_driver_data *plat = ds1wm_data->cell->driver_data;
+	struct ds1wm_driver_data *plat = mfd_get_data(ds1wm_data->pdev);
 
 	if (ds1wm_data->cell->enable)
 		ds1wm_data->cell->enable(ds1wm_data->pdev);
@@ -356,7 +356,7 @@ static int ds1wm_probe(struct platform_device *pdev)
 		ret = -ENOMEM;
 		goto err0;
 	}
-	plat = cell->driver_data;
+	plat = mfd_get_data(pdev);
 
 	/* calculate bus shift from mem resource */
 	ds1wm_data->bus_shift = resource_size(res) >> 3;
-- 
1.7.2.3

