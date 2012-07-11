Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030489Ab2GKWgR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 18:36:17 -0400
Received: from mail160.messagelabs.com ([216.82.253.99]:5512 "EHLO
	mail160.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030473Ab2GKWgL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 18:36:11 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-11.tower-160.messagelabs.com!1342046167!7907955!5
X-Originating-IP: [216.166.12.97]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 30/30] staging: comedi: ke_counter: use comedi_device pci_dev pointer
Date: Wed, 11 Jul 2012 15:36:05 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201207111536.05794.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Use the pci_dev pointer in the comedi_device struct instead of
carrying it in the private data.

Since the pci_dev pointer was the only variable in the private
data, remove it as well.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/ke_counter.c | 28 +++++++---------------------
 1 file changed, 7 insertions(+), 21 deletions(-)

diff --git a/drivers/staging/comedi/drivers/ke_counter.c b/drivers/staging/comedi/drivers/ke_counter.c
index 1a2a240..9d20f89 100644
--- a/drivers/staging/comedi/drivers/ke_counter.c
+++ b/drivers/staging/comedi/drivers/ke_counter.c
@@ -62,15 +62,6 @@ static const struct cnt_board_struct cnt_boards[] = {
 	 .cnt_bits = 24}
 };
 
-/*-- device private structure -----------------------------------------------*/
-
-struct cnt_device_private {
-
-	struct pci_dev *pcidev;
-};
-
-#define devpriv ((struct cnt_device_private *)dev->private)
-
 /*-- counter write ----------------------------------------------------------*/
 
 /* This should be used only for resetting the counters; maybe it is better
@@ -162,20 +153,15 @@ static int cnt_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	unsigned long io_base;
 	int error;
 
-	/* allocate device private structure */
-	error = alloc_private(dev, sizeof(struct cnt_device_private));
-	if (error < 0)
-		return error;
-
-	devpriv->pcidev = cnt_find_pci_dev(dev, it);
-	if (!devpriv->pcidev)
+	dev->pcidev = cnt_find_pci_dev(dev, it);
+	if (!dev->pcidev)
 		return -EIO;
 	board = dev->board_ptr;
 
 	dev->board_name = board->name;
 
 	/* enable PCI device and request regions */
-	error = comedi_pci_enable(devpriv->pcidev, CNT_DRIVER_NAME);
+	error = comedi_pci_enable(dev->pcidev, CNT_DRIVER_NAME);
 	if (error < 0) {
 		printk(KERN_WARNING "comedi%d: "
 		       "failed to enable PCI device and request regions!\n",
@@ -184,7 +170,7 @@ static int cnt_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	}
 
 	/* read register base address [PCI_BASE_ADDRESS #0] */
-	io_base = pci_resource_start(devpriv->pcidev, 0);
+	io_base = pci_resource_start(dev->pcidev, 0);
 	dev->iobase = io_base;
 
 	error = comedi_alloc_subdevices(dev, 1);
@@ -216,10 +202,10 @@ static int cnt_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 
 static void cnt_detach(struct comedi_device *dev)
 {
-	if (devpriv && devpriv->pcidev) {
+	if (dev->pcidev) {
 		if (dev->iobase)
-			comedi_pci_disable(devpriv->pcidev);
-		pci_dev_put(devpriv->pcidev);
+			comedi_pci_disable(dev->pcidev);
+		pci_dev_put(dev->pcidev);
 	}
 }
 
-- 
1.7.11

