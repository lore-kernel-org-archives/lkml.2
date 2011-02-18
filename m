Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932597Ab1BRDI1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 22:08:27 -0500
Received: from LUNGE.MIT.EDU ([18.54.1.69]:51906 "EHLO lunge.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932523Ab1BRDIQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 22:08:16 -0500
From: Andres Salomon <dilinger@queued.net>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>, linux-fbdev@vger.kernel.org
Subject: [PATCH 24/29] tmio-fb: use mfd_data instead of driver_data
Date: Thu, 17 Feb 2011 19:07:31 -0800
Message-Id: <1297998456-7615-25-git-send-email-dilinger@queued.net>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1297998456-7615-1-git-send-email-dilinger@queued.net>
References: <1297998456-7615-1-git-send-email-dilinger@queued.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use mfd_data for passing information from mfd drivers to mfd
clients.  The mfd_cell's driver_data field is being phased out.

Clients that were using driver_data now access .mfd_data
via mfd_get_data().  This changes tmio-fb only; mfd drivers with
other cells are not modified.

Signed-off-by: Andres Salomon <dilinger@queued.net>
---
 drivers/mfd/tc6393xb.c |    2 +-
 drivers/video/tmiofb.c |   15 +++++++--------
 2 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/drivers/mfd/tc6393xb.c b/drivers/mfd/tc6393xb.c
index ecb045b..3d62ded 100644
--- a/drivers/mfd/tc6393xb.c
+++ b/drivers/mfd/tc6393xb.c
@@ -694,7 +694,7 @@ static int __devinit tc6393xb_probe(struct platform_device *dev)
 	}
 
 	tc6393xb_cells[TC6393XB_CELL_NAND].mfd_data = tcpd->nand_data;
-	tc6393xb_cells[TC6393XB_CELL_FB].driver_data = tcpd->fb_data;
+	tc6393xb_cells[TC6393XB_CELL_FB].mfd_data = tcpd->fb_data;
 
 	ret = mfd_add_devices(&dev->dev, dev->id,
 			tc6393xb_cells, ARRAY_SIZE(tc6393xb_cells),
diff --git a/drivers/video/tmiofb.c b/drivers/video/tmiofb.c
index 6302882..7e57d3b 100644
--- a/drivers/video/tmiofb.c
+++ b/drivers/video/tmiofb.c
@@ -250,8 +250,7 @@ static irqreturn_t tmiofb_irq(int irq, void *__info)
  */
 static int tmiofb_hw_stop(struct platform_device *dev)
 {
-	struct mfd_cell *cell = mfd_get_cell(dev);
-	struct tmio_fb_data *data = cell->driver_data;
+	struct tmio_fb_data *data = mfd_get_data(dev);
 	struct fb_info *info = platform_get_drvdata(dev);
 	struct tmiofb_par *par = info->par;
 
@@ -313,7 +312,7 @@ static int tmiofb_hw_init(struct platform_device *dev)
 static void tmiofb_hw_mode(struct platform_device *dev)
 {
 	struct mfd_cell *cell = mfd_get_cell(dev);
-	struct tmio_fb_data *data = cell->driver_data;
+	struct tmio_fb_data *data = mfd_get_data(dev);
 	struct fb_info *info = platform_get_drvdata(dev);
 	struct fb_videomode *mode = info->mode;
 	struct tmiofb_par *par = info->par;
@@ -559,8 +558,8 @@ static int tmiofb_ioctl(struct fb_info *fbi,
 static struct fb_videomode *
 tmiofb_find_mode(struct fb_info *info, struct fb_var_screeninfo *var)
 {
-	struct mfd_cell *cell = mfd_get_cell(to_platform_device(info->device));
-	struct tmio_fb_data *data = cell->driver_data;
+	struct tmio_fb_data *data =
+			mfd_get_data(to_platform_device(info->device));
 	struct fb_videomode *best = NULL;
 	int i;
 
@@ -580,8 +579,8 @@ static int tmiofb_check_var(struct fb_var_screeninfo *var, struct fb_info *info)
 {
 
 	struct fb_videomode *mode;
-	struct mfd_cell *cell = mfd_get_cell(to_platform_device(info->device));
-	struct tmio_fb_data *data = cell->driver_data;
+	struct tmio_fb_data *data =
+			mfd_get_data(to_platform_device(info->device));
 
 	mode = tmiofb_find_mode(info, var);
 	if (!mode || var->bits_per_pixel > 16)
@@ -682,7 +681,7 @@ static struct fb_ops tmiofb_ops = {
 static int __devinit tmiofb_probe(struct platform_device *dev)
 {
 	struct mfd_cell *cell = mfd_get_cell(dev);
-	struct tmio_fb_data *data = cell->driver_data;
+	struct tmio_fb_data *data = mfd_get_data(dev);
 	struct resource *ccr = platform_get_resource(dev, IORESOURCE_MEM, 1);
 	struct resource *lcr = platform_get_resource(dev, IORESOURCE_MEM, 0);
 	struct resource *vram = platform_get_resource(dev, IORESOURCE_MEM, 2);
-- 
1.7.2.3

