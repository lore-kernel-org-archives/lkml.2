Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756421Ab1BOWZ6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 17:25:58 -0500
Received: from LUNGE.MIT.EDU ([18.54.1.69]:48952 "EHLO lunge.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756302Ab1BOWZj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 17:25:39 -0500
From: Andres Salomon <dilinger@queued.net>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org, David Woodhouse <dwmw2@infradead.org>,
        linux-mtd@lists.infradead.org
Subject: [PATCH 6/9] tmio-nand: use mfd_data instead of driver_data
Date: Tue, 15 Feb 2011 14:25:26 -0800
Message-Id: <1297808729-21110-7-git-send-email-dilinger@queued.net>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1297808729-21110-1-git-send-email-dilinger@queued.net>
References: <1297808729-21110-1-git-send-email-dilinger@queued.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use mfd_data for passing information from mfd drivers to mfd
clients.  The mfd_cell's driver_data field is being phased out.

Clients that were using driver_data now access .mfd_data
via mfd_get_data().  This changes tmio-nand only; mfd drivers with
other cells are not modified.

Signed-off-by: Andres Salomon <dilinger@queued.net>
---
 drivers/mfd/t7l66xb.c        |    2 +-
 drivers/mfd/tc6393xb.c       |    2 +-
 drivers/mtd/nand/tmio_nand.c |    3 +--
 3 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/mfd/t7l66xb.c b/drivers/mfd/t7l66xb.c
index 3c9e389..af57fc7 100644
--- a/drivers/mfd/t7l66xb.c
+++ b/drivers/mfd/t7l66xb.c
@@ -383,7 +383,7 @@ static int t7l66xb_probe(struct platform_device *dev)
 
 	t7l66xb_attach_irq(dev);
 
-	t7l66xb_cells[T7L66XB_CELL_NAND].driver_data = pdata->nand_data;
+	t7l66xb_cells[T7L66XB_CELL_NAND].mfd_data = pdata->nand_data;
 
 	ret = mfd_add_devices(&dev->dev, dev->id,
 			      t7l66xb_cells, ARRAY_SIZE(t7l66xb_cells),
diff --git a/drivers/mfd/tc6393xb.c b/drivers/mfd/tc6393xb.c
index 7f7b9fa..ecb045b 100644
--- a/drivers/mfd/tc6393xb.c
+++ b/drivers/mfd/tc6393xb.c
@@ -693,7 +693,7 @@ static int __devinit tc6393xb_probe(struct platform_device *dev)
 			goto err_setup;
 	}
 
-	tc6393xb_cells[TC6393XB_CELL_NAND].driver_data = tcpd->nand_data;
+	tc6393xb_cells[TC6393XB_CELL_NAND].mfd_data = tcpd->nand_data;
 	tc6393xb_cells[TC6393XB_CELL_FB].driver_data = tcpd->fb_data;
 
 	ret = mfd_add_devices(&dev->dev, dev->id,
diff --git a/drivers/mtd/nand/tmio_nand.c b/drivers/mtd/nand/tmio_nand.c
index 5bf63e3..2383b8f 100644
--- a/drivers/mtd/nand/tmio_nand.c
+++ b/drivers/mtd/nand/tmio_nand.c
@@ -372,8 +372,7 @@ static void tmio_hw_stop(struct platform_device *dev, struct tmio_nand *tmio)
 
 static int tmio_probe(struct platform_device *dev)
 {
-	struct mfd_cell *cell = mfd_get_cell(dev);
-	struct tmio_nand_data *data = cell->driver_data;
+	struct tmio_nand_data *data = mfd_get_data(dev);
 	struct resource *fcr = platform_get_resource(dev,
 			IORESOURCE_MEM, 0);
 	struct resource *ccr = platform_get_resource(dev,
-- 
1.7.2.3

