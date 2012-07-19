Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754528Ab2GSB24 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 21:28:56 -0400
Received: from mail132.messagelabs.com ([216.82.242.115]:17406 "EHLO
	mail132.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751791Ab2GSB2z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 21:28:55 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-9.tower-132.messagelabs.com!1342661333!14772311!1
X-Originating-IP: [216.166.12.98]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 11/90] staging: comedi: adl_pci9111: store the pci_dev in the comedi_device
Date: Wed, 18 Jul 2012 18:28:43 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201207181828.43674.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the hw_dev pointer in the comedi_device struct to hold the
pci_dev instead of carrying it in the private data.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/adl_pci9111.c | 29 +++++++++++++++-------------
 1 file changed, 16 insertions(+), 13 deletions(-)

diff --git a/drivers/staging/comedi/drivers/adl_pci9111.c b/drivers/staging/comedi/drivers/adl_pci9111.c
index c41cfc5..a31dae6 100644
--- a/drivers/staging/comedi/drivers/adl_pci9111.c
+++ b/drivers/staging/comedi/drivers/adl_pci9111.c
@@ -338,7 +338,6 @@ static const struct pci9111_board pci9111_boards[] = {
 /*  Private data structure */
 
 struct pci9111_private_data {
-	struct pci_dev *pci_device;
 	unsigned long io_range;	/*  PCI6503 io range */
 
 	unsigned long lcr_io_base; /* Local configuration register base
@@ -1247,6 +1246,7 @@ static struct pci_dev *pci9111_find_pci(struct comedi_device *dev,
 static int pci9111_attach(struct comedi_device *dev,
 			  struct comedi_devconfig *it)
 {
+	struct pci_dev *pcidev;
 	struct comedi_subdevice *subdevice;
 	unsigned long io_base, io_range, lcr_io_base, lcr_io_range;
 	int error;
@@ -1259,9 +1259,10 @@ static int pci9111_attach(struct comedi_device *dev,
 	printk(KERN_ERR "comedi%d: " PCI9111_DRIVER_NAME " driver\n",
 								dev->minor);
 
-	dev_private->pci_device = pci9111_find_pci(dev, it);
-	if (!dev_private->pci_device)
+	pcidev = pci9111_find_pci(dev, it);
+	if (!pcidev)
 		return -EIO;
+	comedi_set_hw_dev(dev, &pcidev->dev);
 	board = (struct pci9111_board *)dev->board_ptr;
 
 	/*  TODO: Warn about non-tested boards. */
@@ -1269,15 +1270,15 @@ static int pci9111_attach(struct comedi_device *dev,
 	/*  Read local configuration register base address
 	 *  [PCI_BASE_ADDRESS #1]. */
 
-	lcr_io_base = pci_resource_start(dev_private->pci_device, 1);
-	lcr_io_range = pci_resource_len(dev_private->pci_device, 1);
+	lcr_io_base = pci_resource_start(pcidev, 1);
+	lcr_io_range = pci_resource_len(pcidev, 1);
 
 	printk
 	    ("comedi%d: local configuration registers at address 0x%4lx [0x%4lx]\n",
 	     dev->minor, lcr_io_base, lcr_io_range);
 
 	/*  Enable PCI device and request regions */
-	if (comedi_pci_enable(dev_private->pci_device, PCI9111_DRIVER_NAME) < 0) {
+	if (comedi_pci_enable(pcidev, PCI9111_DRIVER_NAME) < 0) {
 		printk
 		    ("comedi%d: Failed to enable PCI device and request regions\n",
 		     dev->minor);
@@ -1285,8 +1286,8 @@ static int pci9111_attach(struct comedi_device *dev,
 	}
 	/*  Read PCI6308 register base address [PCI_BASE_ADDRESS #2]. */
 
-	io_base = pci_resource_start(dev_private->pci_device, 2);
-	io_range = pci_resource_len(dev_private->pci_device, 2);
+	io_base = pci_resource_start(pcidev, 2);
+	io_range = pci_resource_len(pcidev, 2);
 
 	printk(KERN_ERR "comedi%d: 6503 registers at address 0x%4lx [0x%4lx]\n",
 	       dev->minor, io_base, io_range);
@@ -1303,8 +1304,8 @@ static int pci9111_attach(struct comedi_device *dev,
 	/*  Irq setup */
 
 	dev->irq = 0;
-	if (dev_private->pci_device->irq > 0) {
-		dev->irq = dev_private->pci_device->irq;
+	if (pcidev->irq > 0) {
+		dev->irq = pcidev->irq;
 
 		if (request_irq(dev->irq, pci9111_interrupt,
 				IRQF_SHARED, PCI9111_DRIVER_NAME, dev) != 0) {
@@ -1374,16 +1375,18 @@ static int pci9111_attach(struct comedi_device *dev,
 
 static void pci9111_detach(struct comedi_device *dev)
 {
+	struct pci_dev *pcidev = comedi_to_pci_dev(dev);
+
 	if (dev->private != NULL) {
 		if (dev_private->is_valid)
 			pci9111_reset(dev);
 	}
 	if (dev->irq != 0)
 		free_irq(dev->irq, dev);
-	if (dev_private != NULL && dev_private->pci_device != NULL) {
+	if (pcidev) {
 		if (dev->iobase)
-			comedi_pci_disable(dev_private->pci_device);
-		pci_dev_put(dev_private->pci_device);
+			comedi_pci_disable(pcidev);
+		pci_dev_put(pcidev);
 	}
 }
 
-- 
1.7.11

