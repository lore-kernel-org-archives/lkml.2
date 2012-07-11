Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933448Ab2GKWYv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 18:24:51 -0400
Received: from mail160.messagelabs.com ([216.82.253.99]:52780 "EHLO
	mail160.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932159Ab2GKWYr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 18:24:47 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-14.tower-160.messagelabs.com!1342045467!9399771!26
X-Originating-IP: [216.166.12.178]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 11/30] staging: comedi: adl_pci9111: use comedi_device pci_dev pointer
Date: Wed, 11 Jul 2012 15:24:36 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201207111524.36682.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the pci_dev pointer in the comedi_device struct instead of
carrying it in the private data.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/adl_pci9111.c | 25 ++++++++++++-------------
 1 file changed, 12 insertions(+), 13 deletions(-)

diff --git a/drivers/staging/comedi/drivers/adl_pci9111.c b/drivers/staging/comedi/drivers/adl_pci9111.c
index c41cfc5..9db36f5 100644
--- a/drivers/staging/comedi/drivers/adl_pci9111.c
+++ b/drivers/staging/comedi/drivers/adl_pci9111.c
@@ -338,7 +338,6 @@ static const struct pci9111_board pci9111_boards[] = {
 /*  Private data structure */
 
 struct pci9111_private_data {
-	struct pci_dev *pci_device;
 	unsigned long io_range;	/*  PCI6503 io range */
 
 	unsigned long lcr_io_base; /* Local configuration register base
@@ -1259,8 +1258,8 @@ static int pci9111_attach(struct comedi_device *dev,
 	printk(KERN_ERR "comedi%d: " PCI9111_DRIVER_NAME " driver\n",
 								dev->minor);
 
-	dev_private->pci_device = pci9111_find_pci(dev, it);
-	if (!dev_private->pci_device)
+	dev->pcidev = pci9111_find_pci(dev, it);
+	if (!dev->pcidev)
 		return -EIO;
 	board = (struct pci9111_board *)dev->board_ptr;
 
@@ -1269,15 +1268,15 @@ static int pci9111_attach(struct comedi_device *dev,
 	/*  Read local configuration register base address
 	 *  [PCI_BASE_ADDRESS #1]. */
 
-	lcr_io_base = pci_resource_start(dev_private->pci_device, 1);
-	lcr_io_range = pci_resource_len(dev_private->pci_device, 1);
+	lcr_io_base = pci_resource_start(dev->pcidev, 1);
+	lcr_io_range = pci_resource_len(dev->pcidev, 1);
 
 	printk
 	    ("comedi%d: local configuration registers at address 0x%4lx [0x%4lx]\n",
 	     dev->minor, lcr_io_base, lcr_io_range);
 
 	/*  Enable PCI device and request regions */
-	if (comedi_pci_enable(dev_private->pci_device, PCI9111_DRIVER_NAME) < 0) {
+	if (comedi_pci_enable(dev->pcidev, PCI9111_DRIVER_NAME) < 0) {
 		printk
 		    ("comedi%d: Failed to enable PCI device and request regions\n",
 		     dev->minor);
@@ -1285,8 +1284,8 @@ static int pci9111_attach(struct comedi_device *dev,
 	}
 	/*  Read PCI6308 register base address [PCI_BASE_ADDRESS #2]. */
 
-	io_base = pci_resource_start(dev_private->pci_device, 2);
-	io_range = pci_resource_len(dev_private->pci_device, 2);
+	io_base = pci_resource_start(dev->pcidev, 2);
+	io_range = pci_resource_len(dev->pcidev, 2);
 
 	printk(KERN_ERR "comedi%d: 6503 registers at address 0x%4lx [0x%4lx]\n",
 	       dev->minor, io_base, io_range);
@@ -1303,8 +1302,8 @@ static int pci9111_attach(struct comedi_device *dev,
 	/*  Irq setup */
 
 	dev->irq = 0;
-	if (dev_private->pci_device->irq > 0) {
-		dev->irq = dev_private->pci_device->irq;
+	if (dev->pcidev->irq > 0) {
+		dev->irq = dev->pcidev->irq;
 
 		if (request_irq(dev->irq, pci9111_interrupt,
 				IRQF_SHARED, PCI9111_DRIVER_NAME, dev) != 0) {
@@ -1380,10 +1379,10 @@ static void pci9111_detach(struct comedi_device *dev)
 	}
 	if (dev->irq != 0)
 		free_irq(dev->irq, dev);
-	if (dev_private != NULL && dev_private->pci_device != NULL) {
+	if (dev->pcidev) {
 		if (dev->iobase)
-			comedi_pci_disable(dev_private->pci_device);
-		pci_dev_put(dev_private->pci_device);
+			comedi_pci_disable(dev->pcidev);
+		pci_dev_put(dev->pcidev);
 	}
 }
 
-- 
1.7.11

