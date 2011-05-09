Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756575Ab1EIAdQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 May 2011 20:33:16 -0400
Received: from mga03.intel.com ([143.182.124.21]:32377 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756377Ab1EIAdM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 May 2011 20:33:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,337,1301900400"; 
   d="scan'208";a="432671172"
From: Samuel Ortiz <sameo@linux.intel.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Matt Reimer <mreimer@vpop.net>,
        Philipp Zabel <philipp.zabel@gmail.com>
Subject: [PATCH 05/19] w1: Use device platform_data to retrieve ds1wm platform bits
Date: Mon,  9 May 2011 02:31:57 +0200
Message-Id: <1304901131-7104-6-git-send-email-sameo@linux.intel.com>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1304901131-7104-1-git-send-email-sameo@linux.intel.com>
References: <1304901131-7104-1-git-send-email-sameo@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the addition of the platform device mfd_cell pointer, we can now
cleanly pass the sub device drivers platform data pointers through the
regular device platform_data one, and get rid of mfd_get_data().

Cc: Matt Reimer <mreimer@vpop.net>
Cc: Philipp Zabel <philipp.zabel@gmail.com>
Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
---
 drivers/mfd/asic3.c        |    3 ++-
 drivers/mfd/htc-pasic3.c   |    3 ++-
 drivers/w1/masters/ds1wm.c |   12 ++++++++++--
 3 files changed, 14 insertions(+), 4 deletions(-)

diff --git a/drivers/mfd/asic3.c b/drivers/mfd/asic3.c
index 1df4f2c..0536e11 100644
--- a/drivers/mfd/asic3.c
+++ b/drivers/mfd/asic3.c
@@ -676,7 +676,8 @@ static struct mfd_cell asic3_cell_ds1wm = {
 	.name          = "ds1wm",
 	.enable        = ds1wm_enable,
 	.disable       = ds1wm_disable,
-	.mfd_data      = &ds1wm_pdata,
+	.platform_data = &ds1wm_pdata,
+	.pdata_size    = sizeof(ds1wm_pdata),
 	.num_resources = ARRAY_SIZE(ds1wm_resources),
 	.resources     = ds1wm_resources,
 };
diff --git a/drivers/mfd/htc-pasic3.c b/drivers/mfd/htc-pasic3.c
index fb9770b..95a4ff4 100644
--- a/drivers/mfd/htc-pasic3.c
+++ b/drivers/mfd/htc-pasic3.c
@@ -117,7 +117,8 @@ static struct mfd_cell ds1wm_cell __initdata = {
 	.name          = "ds1wm",
 	.enable        = ds1wm_enable,
 	.disable       = ds1wm_disable,
-	.mfd_data      = &ds1wm_pdata,
+	.platform_data = &ds1wm_pdata,
+	.pdata_size    = sizeof(ds1wm_pdata),
 	.num_resources = 2,
 	.resources     = ds1wm_resources,
 };
diff --git a/drivers/w1/masters/ds1wm.c b/drivers/w1/masters/ds1wm.c
index 2f4fa02..0855d6c 100644
--- a/drivers/w1/masters/ds1wm.c
+++ b/drivers/w1/masters/ds1wm.c
@@ -216,7 +216,7 @@ static int ds1wm_find_divisor(int gclk)
 static void ds1wm_up(struct ds1wm_data *ds1wm_data)
 {
 	int divisor;
-	struct ds1wm_driver_data *plat = mfd_get_data(ds1wm_data->pdev);
+	struct ds1wm_driver_data *plat = ds1wm_data->pdev->dev.platform_data;
 
 	if (ds1wm_data->cell->enable)
 		ds1wm_data->cell->enable(ds1wm_data->pdev);
@@ -351,13 +351,21 @@ static int ds1wm_probe(struct platform_device *pdev)
 		ret = -ENOMEM;
 		goto err0;
 	}
-	plat = mfd_get_data(pdev);
 
 	/* calculate bus shift from mem resource */
 	ds1wm_data->bus_shift = resource_size(res) >> 3;
 
 	ds1wm_data->pdev = pdev;
 	ds1wm_data->cell = mfd_get_cell(pdev);
+	if (!ds1wm_data->cell) {
+		ret = -ENODEV;
+		goto err1;
+	}
+	plat = pdev->dev.platform_data;
+	if (!plat) {
+		ret = -ENODEV;
+		goto err1;
+	}
 
 	res = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
 	if (!res) {
-- 
1.7.2.3

