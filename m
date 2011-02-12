Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758250Ab1BLCOe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Feb 2011 21:14:34 -0500
Received: from LUNGE.MIT.EDU ([18.54.1.69]:58293 "EHLO lunge.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752148Ab1BLCOc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Feb 2011 21:14:32 -0500
Date: Fri, 11 Feb 2011 18:14:29 -0800
From: Andres Salomon <dilinger@queued.net>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        David Brownell <dbrownell@users.sourceforge.net>,
        Greg Kroah-Hartman <gregkh@suse.de>, linux-usb@vger.kernel.org,
        linux-fbdev@vger.kernel.org
Subject: [PATCH 12/17] tc6393xb: mfd_cell is now implicitly available to
 drivers
Message-ID: <20110211181429.36866ba0@queued.net>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


No need to explicitly set the cell's platform_data/data_size.

Modify clients to use mfd_get_cell helper function instead of
accessing platform_data directly.

Signed-off-by: Andres Salomon <dilinger@queued.net>
---
 drivers/mfd/tc6393xb.c       |   19 -------------------
 drivers/usb/host/ohci-tmio.c |    8 ++++----
 drivers/video/tmiofb.c       |   20 +++++++++-----------
 3 files changed, 13 insertions(+), 34 deletions(-)

diff --git a/drivers/mfd/tc6393xb.c b/drivers/mfd/tc6393xb.c
index 9a23863..a71ff5c 100644
--- a/drivers/mfd/tc6393xb.c
+++ b/drivers/mfd/tc6393xb.c
@@ -694,26 +694,7 @@ static int __devinit tc6393xb_probe(struct platform_device *dev)
 	}
 
 	tc6393xb_cells[TC6393XB_CELL_NAND].driver_data = tcpd->nand_data;
-	tc6393xb_cells[TC6393XB_CELL_NAND].platform_data =
-		&tc6393xb_cells[TC6393XB_CELL_NAND];
-	tc6393xb_cells[TC6393XB_CELL_NAND].data_size =
-		sizeof(tc6393xb_cells[TC6393XB_CELL_NAND]);
-
-	tc6393xb_cells[TC6393XB_CELL_MMC].platform_data =
-		&tc6393xb_cells[TC6393XB_CELL_MMC];
-	tc6393xb_cells[TC6393XB_CELL_MMC].data_size =
-		sizeof(tc6393xb_cells[TC6393XB_CELL_MMC]);
-
-	tc6393xb_cells[TC6393XB_CELL_OHCI].platform_data =
-		&tc6393xb_cells[TC6393XB_CELL_OHCI];
-	tc6393xb_cells[TC6393XB_CELL_OHCI].data_size =
-		sizeof(tc6393xb_cells[TC6393XB_CELL_OHCI]);
-
 	tc6393xb_cells[TC6393XB_CELL_FB].driver_data = tcpd->fb_data;
-	tc6393xb_cells[TC6393XB_CELL_FB].platform_data =
-		&tc6393xb_cells[TC6393XB_CELL_FB];
-	tc6393xb_cells[TC6393XB_CELL_FB].data_size =
-		sizeof(tc6393xb_cells[TC6393XB_CELL_FB]);
 
 	ret = mfd_add_devices(&dev->dev, dev->id,
 			tc6393xb_cells, ARRAY_SIZE(tc6393xb_cells),
diff --git a/drivers/usb/host/ohci-tmio.c b/drivers/usb/host/ohci-tmio.c
index 8dabe8e..eeed164 100644
--- a/drivers/usb/host/ohci-tmio.c
+++ b/drivers/usb/host/ohci-tmio.c
@@ -185,7 +185,7 @@ static struct platform_driver ohci_hcd_tmio_driver;
 
 static int __devinit ohci_hcd_tmio_drv_probe(struct platform_device *dev)
 {
-	struct mfd_cell *cell = dev->dev.platform_data;
+	struct mfd_cell *cell = mfd_get_cell(dev);
 	struct resource *regs = platform_get_resource(dev, IORESOURCE_MEM, 0);
 	struct resource *config = platform_get_resource(dev, IORESOURCE_MEM, 1);
 	struct resource *sram = platform_get_resource(dev, IORESOURCE_MEM, 2);
@@ -274,7 +274,7 @@ static int __devexit ohci_hcd_tmio_drv_remove(struct platform_device *dev)
 {
 	struct usb_hcd *hcd = platform_get_drvdata(dev);
 	struct tmio_hcd *tmio = hcd_to_tmio(hcd);
-	struct mfd_cell *cell = dev->dev.platform_data;
+	struct mfd_cell *cell = mfd_get_cell(dev);
 
 	usb_remove_hcd(hcd);
 	tmio_stop_hc(dev);
@@ -293,7 +293,7 @@ static int __devexit ohci_hcd_tmio_drv_remove(struct platform_device *dev)
 #ifdef CONFIG_PM
 static int ohci_hcd_tmio_drv_suspend(struct platform_device *dev, pm_message_t state)
 {
-	struct mfd_cell *cell = dev->dev.platform_data;
+	struct mfd_cell *cell = mfd_get_cell(dev);
 	struct usb_hcd *hcd = platform_get_drvdata(dev);
 	struct ohci_hcd *ohci = hcd_to_ohci(hcd);
 	struct tmio_hcd *tmio = hcd_to_tmio(hcd);
@@ -326,7 +326,7 @@ static int ohci_hcd_tmio_drv_suspend(struct platform_device *dev, pm_message_t s
 
 static int ohci_hcd_tmio_drv_resume(struct platform_device *dev)
 {
-	struct mfd_cell *cell = dev->dev.platform_data;
+	struct mfd_cell *cell = mfd_get_cell(dev);
 	struct usb_hcd *hcd = platform_get_drvdata(dev);
 	struct ohci_hcd *ohci = hcd_to_ohci(hcd);
 	struct tmio_hcd *tmio = hcd_to_tmio(hcd);
diff --git a/drivers/video/tmiofb.c b/drivers/video/tmiofb.c
index dfef88c..6302882 100644
--- a/drivers/video/tmiofb.c
+++ b/drivers/video/tmiofb.c
@@ -250,7 +250,7 @@ static irqreturn_t tmiofb_irq(int irq, void *__info)
  */
 static int tmiofb_hw_stop(struct platform_device *dev)
 {
-	struct mfd_cell *cell = dev->dev.platform_data;
+	struct mfd_cell *cell = mfd_get_cell(dev);
 	struct tmio_fb_data *data = cell->driver_data;
 	struct fb_info *info = platform_get_drvdata(dev);
 	struct tmiofb_par *par = info->par;
@@ -268,7 +268,7 @@ static int tmiofb_hw_stop(struct platform_device *dev)
  */
 static int tmiofb_hw_init(struct platform_device *dev)
 {
-	struct mfd_cell *cell = dev->dev.platform_data;
+	struct mfd_cell *cell = mfd_get_cell(dev);
 	struct fb_info *info = platform_get_drvdata(dev);
 	struct tmiofb_par *par = info->par;
 	const struct resource *nlcr = &cell->resources[0];
@@ -312,7 +312,7 @@ static int tmiofb_hw_init(struct platform_device *dev)
  */
 static void tmiofb_hw_mode(struct platform_device *dev)
 {
-	struct mfd_cell *cell = dev->dev.platform_data;
+	struct mfd_cell *cell = mfd_get_cell(dev);
 	struct tmio_fb_data *data = cell->driver_data;
 	struct fb_info *info = platform_get_drvdata(dev);
 	struct fb_videomode *mode = info->mode;
@@ -559,8 +559,7 @@ static int tmiofb_ioctl(struct fb_info *fbi,
 static struct fb_videomode *
 tmiofb_find_mode(struct fb_info *info, struct fb_var_screeninfo *var)
 {
-	struct mfd_cell *cell =
-		info->device->platform_data;
+	struct mfd_cell *cell = mfd_get_cell(to_platform_device(info->device));
 	struct tmio_fb_data *data = cell->driver_data;
 	struct fb_videomode *best = NULL;
 	int i;
@@ -581,8 +580,7 @@ static int tmiofb_check_var(struct fb_var_screeninfo *var, struct fb_info *info)
 {
 
 	struct fb_videomode *mode;
-	struct mfd_cell *cell =
-		info->device->platform_data;
+	struct mfd_cell *cell = mfd_get_cell(to_platform_device(info->device));
 	struct tmio_fb_data *data = cell->driver_data;
 
 	mode = tmiofb_find_mode(info, var);
@@ -683,7 +681,7 @@ static struct fb_ops tmiofb_ops = {
 
 static int __devinit tmiofb_probe(struct platform_device *dev)
 {
-	struct mfd_cell *cell = dev->dev.platform_data;
+	struct mfd_cell *cell = mfd_get_cell(dev);
 	struct tmio_fb_data *data = cell->driver_data;
 	struct resource *ccr = platform_get_resource(dev, IORESOURCE_MEM, 1);
 	struct resource *lcr = platform_get_resource(dev, IORESOURCE_MEM, 0);
@@ -811,7 +809,7 @@ err_ioremap_ccr:
 
 static int __devexit tmiofb_remove(struct platform_device *dev)
 {
-	struct mfd_cell *cell = dev->dev.platform_data;
+	struct mfd_cell *cell = mfd_get_cell(dev);
 	struct fb_info *info = platform_get_drvdata(dev);
 	int irq = platform_get_irq(dev, 0);
 	struct tmiofb_par *par;
@@ -941,7 +939,7 @@ static int tmiofb_suspend(struct platform_device *dev, pm_message_t state)
 #ifdef CONFIG_FB_TMIO_ACCELL
 	struct tmiofb_par *par = info->par;
 #endif
-	struct mfd_cell *cell = dev->dev.platform_data;
+	struct mfd_cell *cell = mfd_get_cell(dev);
 	int retval = 0;
 
 	console_lock();
@@ -973,7 +971,7 @@ static int tmiofb_suspend(struct platform_device *dev, pm_message_t state)
 static int tmiofb_resume(struct platform_device *dev)
 {
 	struct fb_info *info = platform_get_drvdata(dev);
-	struct mfd_cell *cell = dev->dev.platform_data;
+	struct mfd_cell *cell = mfd_get_cell(dev);
 	int retval = 0;
 
 	console_lock();
-- 
1.7.2.3

