Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756252Ab2HRBUC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 21:20:02 -0400
Received: from mail131.messagelabs.com ([216.82.242.99]:24657 "EHLO
	mail131.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754415Ab2HRBTo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 21:19:44 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-12.tower-131.messagelabs.com!1345252783!21923467!1
X-Originating-IP: [216.166.12.72]
X-StarScan-Received: 
X-StarScan-Version: 6.6.1.2; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 15/20] staging: comedi: adv_pci_dio: use attach_pci callback
Date: Fri, 17 Aug 2012 18:19:36 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201208171819.37263.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert this PCI driver to use the comedi PCI auto config attach
mechanism by adding an 'attach_pci' callback function. Since the
driver does not require any external configuration options, and
the legacy 'attach' callback is now optional, remove it.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/adv_pci_dio.c | 61 ++++++++++------------------
 1 file changed, 22 insertions(+), 39 deletions(-)

diff --git a/drivers/staging/comedi/drivers/adv_pci_dio.c b/drivers/staging/comedi/drivers/adv_pci_dio.c
index 97fc6b8..36b7c8d 100644
--- a/drivers/staging/comedi/drivers/adv_pci_dio.c
+++ b/drivers/staging/comedi/drivers/adv_pci_dio.c
@@ -913,8 +913,7 @@ static int pci_dio_reset(struct comedi_device *dev)
 /*
 ==============================================================================
 */
-static int pci1760_attach(struct comedi_device *dev,
-			  struct comedi_devconfig *it)
+static int pci1760_attach(struct comedi_device *dev)
 {
 	struct comedi_subdevice *s;
 	int subdev = 0;
@@ -1042,60 +1041,45 @@ static int pci_dio_add_8254(struct comedi_device *dev,
 	return 0;
 }
 
-static struct pci_dev *pci_dio_find_pci_dev(struct comedi_device *dev,
-					    struct comedi_devconfig *it)
+static const void *pci_dio_find_boardinfo(struct comedi_device *dev,
+					  struct pci_dev *pcidev)
 {
-	struct pci_dev *pcidev = NULL;
-	int bus = it->options[0];
-	int slot = it->options[1];
+	const struct dio_boardtype *this_board;
 	int i;
 
-	for_each_pci_dev(pcidev) {
-		if (bus || slot) {
-			if (bus != pcidev->bus->number ||
-			    slot != PCI_SLOT(pcidev->devfn))
-				continue;
-		}
-		for (i = 0; i < ARRAY_SIZE(boardtypes); ++i) {
-			if (boardtypes[i].vendor_id != pcidev->vendor)
-				continue;
-			if (boardtypes[i].device_id != pcidev->device)
-				continue;
-			dev->board_ptr = boardtypes + i;
-			return pcidev;
-		}
+	for (i = 0; i < ARRAY_SIZE(boardtypes); ++i) {
+		this_board = &boardtypes[i];
+		if (this_board->vendor_id == pcidev->vendor &&
+		    this_board->device_id == pcidev->device)
+			return this_board;
 	}
-	dev_err(dev->class_dev,
-		"No supported board found! (req. bus %d, slot %d)\n",
-		bus, slot);
 	return NULL;
 }
 
-static int pci_dio_attach(struct comedi_device *dev,
-			  struct comedi_devconfig *it)
+static int pci_dio_attach_pci(struct comedi_device *dev,
+			      struct pci_dev *pcidev)
 {
 	const struct dio_boardtype *this_board;
 	struct pci_dio_private *devpriv;
-	struct pci_dev *pcidev;
 	struct comedi_subdevice *s;
 	int ret, subdev, n_subdevices, i, j;
 
+	comedi_set_hw_dev(dev, &pcidev->dev);
+
+	this_board = pci_dio_find_boardinfo(dev, pcidev);
+	if (!this_board)
+		return -ENODEV;
+	dev->board_ptr = this_board;
+	dev->board_name = this_board->name;
+
 	ret = alloc_private(dev, sizeof(*devpriv));
 	if (ret < 0)
 		return ret;
 	devpriv = dev->private;
 
-	pcidev = pci_dio_find_pci_dev(dev, it);
-	if (!pcidev)
-		return -EIO;
-	comedi_set_hw_dev(dev, &pcidev->dev);
-	this_board = comedi_board(dev);
-	dev->board_name = this_board->name;
-
 	ret = comedi_pci_enable(pcidev, dev->board_name);
 	if (ret)
 		return ret;
-
 	dev->iobase = pci_resource_start(pcidev, this_board->main_pci_region);
 
 	if (this_board->cardtype == TYPE_PCI1760) {
@@ -1161,7 +1145,7 @@ static int pci_dio_attach(struct comedi_device *dev,
 		}
 
 	if (this_board->cardtype == TYPE_PCI1760)
-		pci1760_attach(dev, it);
+		pci1760_attach(dev);
 
 	devpriv->valid = 1;
 
@@ -1211,15 +1195,14 @@ static void pci_dio_detach(struct comedi_device *dev)
 	if (pcidev) {
 		if (dev->iobase)
 			comedi_pci_disable(pcidev);
-		pci_dev_put(pcidev);
 	}
 }
 
 static struct comedi_driver adv_pci_dio_driver = {
 	.driver_name	= "adv_pci_dio",
 	.module		= THIS_MODULE,
-	.attach		= pci_dio_attach,
-	.detach		= pci_dio_detach
+	.attach_pci	= pci_dio_attach_pci,
+	.detach		= pci_dio_detach,
 };
 
 static int __devinit adv_pci_dio_pci_probe(struct pci_dev *dev,
-- 
1.7.11

