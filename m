Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756630Ab1EIAfh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 May 2011 20:35:37 -0400
Received: from mga14.intel.com ([143.182.124.37]:24356 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756583Ab1EIAd3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 May 2011 20:33:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,337,1301900400"; 
   d="scan'208";a="432671216"
From: Samuel Ortiz <sameo@linux.intel.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Ian Molton <spyro@f2s.com>,
        Dmitry Baryshkov <dbaryshkov@gmail.com>,
        Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Subject: [PATCH 09/19] mtd: Use platform_data to retrieve tmio_nand platform bits
Date: Mon,  9 May 2011 02:32:01 +0200
Message-Id: <1304901131-7104-10-git-send-email-sameo@linux.intel.com>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1304901131-7104-1-git-send-email-sameo@linux.intel.com>
References: <1304901131-7104-1-git-send-email-sameo@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the addition of the platform device mfd_cell pointer, we can now
cleanly pass the sub device drivers platform data pointers through the
regular device platform_data one, and get rid of mfd_get_data().

Cc: Ian Molton <spyro@f2s.com>
Cc: Dmitry Baryshkov <dbaryshkov@gmail.com>
Cc: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
---
 drivers/mfd/t7l66xb.c        |    3 ++-
 drivers/mfd/tc6393xb.c       |    4 +++-
 drivers/mtd/nand/tmio_nand.c |    2 +-
 3 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/mfd/t7l66xb.c b/drivers/mfd/t7l66xb.c
index 5ef0b8f..91ad21e 100644
--- a/drivers/mfd/t7l66xb.c
+++ b/drivers/mfd/t7l66xb.c
@@ -383,7 +383,8 @@ static int t7l66xb_probe(struct platform_device *dev)
 
 	t7l66xb_attach_irq(dev);
 
-	t7l66xb_cells[T7L66XB_CELL_NAND].mfd_data = pdata->nand_data;
+	t7l66xb_cells[T7L66XB_CELL_NAND].platform_data = pdata->nand_data;
+	t7l66xb_cells[T7L66XB_CELL_NAND].pdata_size = sizeof(*pdata->nand_data);
 
 	ret = mfd_add_devices(&dev->dev, dev->id,
 			      t7l66xb_cells, ARRAY_SIZE(t7l66xb_cells),
diff --git a/drivers/mfd/tc6393xb.c b/drivers/mfd/tc6393xb.c
index b3d5852..9612264 100644
--- a/drivers/mfd/tc6393xb.c
+++ b/drivers/mfd/tc6393xb.c
@@ -693,7 +693,9 @@ static int __devinit tc6393xb_probe(struct platform_device *dev)
 			goto err_setup;
 	}
 
-	tc6393xb_cells[TC6393XB_CELL_NAND].mfd_data = tcpd->nand_data;
+	tc6393xb_cells[TC6393XB_CELL_NAND].platform_data = tcpd->nand_data;
+	tc6393xb_cells[TC6393XB_CELL_NAND].pdata_size =
+						sizeof(*tcpd->nand_data);
 	tc6393xb_cells[TC6393XB_CELL_FB].platform_data = tcpd->fb_data;
 	tc6393xb_cells[TC6393XB_CELL_FB].pdata_size = sizeof(*tcpd->fb_data);
 
diff --git a/drivers/mtd/nand/tmio_nand.c b/drivers/mtd/nand/tmio_nand.c
index 14c5787..c004e47 100644
--- a/drivers/mtd/nand/tmio_nand.c
+++ b/drivers/mtd/nand/tmio_nand.c
@@ -372,7 +372,7 @@ static void tmio_hw_stop(struct platform_device *dev, struct tmio_nand *tmio)
 
 static int tmio_probe(struct platform_device *dev)
 {
-	struct tmio_nand_data *data = mfd_get_data(dev);
+	struct tmio_nand_data *data = dev->dev.platform_data;
 	struct resource *fcr = platform_get_resource(dev,
 			IORESOURCE_MEM, 0);
 	struct resource *ccr = platform_get_resource(dev,
-- 
1.7.2.3

