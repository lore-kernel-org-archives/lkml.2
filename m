Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756602Ab1EIAda (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 May 2011 20:33:30 -0400
Received: from mga14.intel.com ([143.182.124.37]:24356 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755310Ab1EIAd0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 May 2011 20:33:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,337,1301900400"; 
   d="scan'208";a="432671206"
From: Samuel Ortiz <sameo@linux.intel.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Ian Molton <spyro@f2s.com>,
        Dmitry Baryshkov <dbaryshkov@gmail.com>,
        Paul Mundt <lethal@linux-sh.org>
Subject: [PATCH 08/19] fb: Use platform_data to retrieve tmiofb platform bits
Date: Mon,  9 May 2011 02:32:00 +0200
Message-Id: <1304901131-7104-9-git-send-email-sameo@linux.intel.com>
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
Cc: Paul Mundt <lethal@linux-sh.org>
Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
---
 drivers/mfd/tc6393xb.c |    3 ++-
 drivers/video/tmiofb.c |   12 +++++-------
 2 files changed, 7 insertions(+), 8 deletions(-)

diff --git a/drivers/mfd/tc6393xb.c b/drivers/mfd/tc6393xb.c
index 8e9b1b7..b3d5852 100644
--- a/drivers/mfd/tc6393xb.c
+++ b/drivers/mfd/tc6393xb.c
@@ -694,7 +694,8 @@ static int __devinit tc6393xb_probe(struct platform_device *dev)
 	}
 
 	tc6393xb_cells[TC6393XB_CELL_NAND].mfd_data = tcpd->nand_data;
-	tc6393xb_cells[TC6393XB_CELL_FB].mfd_data = tcpd->fb_data;
+	tc6393xb_cells[TC6393XB_CELL_FB].platform_data = tcpd->fb_data;
+	tc6393xb_cells[TC6393XB_CELL_FB].pdata_size = sizeof(*tcpd->fb_data);
 
 	ret = mfd_add_devices(&dev->dev, dev->id,
 			tc6393xb_cells, ARRAY_SIZE(tc6393xb_cells),
diff --git a/drivers/video/tmiofb.c b/drivers/video/tmiofb.c
index 0c341d7..cd1c4dc 100644
--- a/drivers/video/tmiofb.c
+++ b/drivers/video/tmiofb.c
@@ -250,7 +250,7 @@ static irqreturn_t tmiofb_irq(int irq, void *__info)
  */
 static int tmiofb_hw_stop(struct platform_device *dev)
 {
-	struct tmio_fb_data *data = mfd_get_data(dev);
+	struct tmio_fb_data *data = dev->dev.platform_data;
 	struct fb_info *info = platform_get_drvdata(dev);
 	struct tmiofb_par *par = info->par;
 
@@ -311,7 +311,7 @@ static int tmiofb_hw_init(struct platform_device *dev)
  */
 static void tmiofb_hw_mode(struct platform_device *dev)
 {
-	struct tmio_fb_data *data = mfd_get_data(dev);
+	struct tmio_fb_data *data = dev->dev.platform_data;
 	struct fb_info *info = platform_get_drvdata(dev);
 	struct fb_videomode *mode = info->mode;
 	struct tmiofb_par *par = info->par;
@@ -557,8 +557,7 @@ static int tmiofb_ioctl(struct fb_info *fbi,
 static struct fb_videomode *
 tmiofb_find_mode(struct fb_info *info, struct fb_var_screeninfo *var)
 {
-	struct tmio_fb_data *data =
-			mfd_get_data(to_platform_device(info->device));
+	struct tmio_fb_data *data = info->device->platform_data;
 	struct fb_videomode *best = NULL;
 	int i;
 
@@ -578,8 +577,7 @@ static int tmiofb_check_var(struct fb_var_screeninfo *var, struct fb_info *info)
 {
 
 	struct fb_videomode *mode;
-	struct tmio_fb_data *data =
-			mfd_get_data(to_platform_device(info->device));
+	struct tmio_fb_data *data = info->device->platform_data;
 
 	mode = tmiofb_find_mode(info, var);
 	if (!mode || var->bits_per_pixel > 16)
@@ -680,7 +678,7 @@ static struct fb_ops tmiofb_ops = {
 static int __devinit tmiofb_probe(struct platform_device *dev)
 {
 	const struct mfd_cell *cell = mfd_get_cell(dev);
-	struct tmio_fb_data *data = mfd_get_data(dev);
+	struct tmio_fb_data *data = dev->dev.platform_data;
 	struct resource *ccr = platform_get_resource(dev, IORESOURCE_MEM, 1);
 	struct resource *lcr = platform_get_resource(dev, IORESOURCE_MEM, 0);
 	struct resource *vram = platform_get_resource(dev, IORESOURCE_MEM, 2);
-- 
1.7.2.3

