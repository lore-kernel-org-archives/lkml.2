Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933621Ab2HQCrP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 22:47:15 -0400
Received: from mail132.messagelabs.com ([216.82.242.115]:59816 "EHLO
	mail132.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756946Ab2HQCrN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 22:47:13 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-12.tower-132.messagelabs.com!1345171631!13469398!2
X-Originating-IP: [216.166.12.32]
X-StarScan-Received: 
X-StarScan-Version: 6.6.1.2; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 13/35] staging: comedi: cb_pcimdas: use attach_pci callback
Date: Thu, 16 Aug 2012 19:47:05 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201208161947.06066.hartleys@visionengravers.com>
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
 drivers/staging/comedi/drivers/cb_pcimdas.c | 68 ++++++++++-------------------
 1 file changed, 24 insertions(+), 44 deletions(-)

diff --git a/drivers/staging/comedi/drivers/cb_pcimdas.c b/drivers/staging/comedi/drivers/cb_pcimdas.c
index 5a5f102..fa3fd88 100644
--- a/drivers/staging/comedi/drivers/cb_pcimdas.c
+++ b/drivers/staging/comedi/drivers/cb_pcimdas.c
@@ -251,58 +251,42 @@ static int cb_pcimdas_ao_rinsn(struct comedi_device *dev,
 	return i;
 }
 
-static struct pci_dev *cb_pcimdas_find_pci_dev(struct comedi_device *dev,
-					       struct comedi_devconfig *it)
+static const void *cb_pcimdas_find_boardinfo(struct comedi_device *dev,
+					     struct pci_dev *pcidev)
 {
-	struct pci_dev *pcidev = NULL;
-	int bus = it->options[0];
-	int slot = it->options[1];
+	const struct cb_pcimdas_board *thisboard;
 	int i;
 
-	for_each_pci_dev(pcidev) {
-		if (bus || slot) {
-			if (bus != pcidev->bus->number ||
-				slot != PCI_SLOT(pcidev->devfn))
-				continue;
-		}
-		if (pcidev->vendor != PCI_VENDOR_ID_COMPUTERBOARDS)
-			continue;
-
-		for (i = 0; i < ARRAY_SIZE(cb_pcimdas_boards); i++) {
-			if (cb_pcimdas_boards[i].device_id != pcidev->device)
-				continue;
-
-			dev->board_ptr = cb_pcimdas_boards + i;
-			return pcidev;
-		}
+	for (i = 0; i < ARRAY_SIZE(cb_pcimdas_boards); i++) {
+		thisboard = &cb_pcimdas_boards[i];
+		if (thisboard->device_id == pcidev->device)
+			return thisboard;
 	}
-	dev_err(dev->class_dev,
-		"No supported board found! (req. bus %d, slot %d)\n",
-		bus, slot);
 	return NULL;
 }
 
-static int cb_pcimdas_attach(struct comedi_device *dev,
-			     struct comedi_devconfig *it)
+static int cb_pcimdas_attach_pci(struct comedi_device *dev,
+				 struct pci_dev *pcidev)
 {
 	const struct cb_pcimdas_board *thisboard;
 	struct cb_pcimdas_private *devpriv;
-	struct pci_dev *pcidev;
 	struct comedi_subdevice *s;
 	unsigned long iobase_8255;
 	int ret;
 
+	comedi_set_hw_dev(dev, &pcidev->dev);
+
+	thisboard = cb_pcimdas_find_boardinfo(dev, pcidev);
+	if (!thisboard)
+		return -ENODEV;
+	dev->board_ptr = thisboard;
+	dev->board_name = thisboard->name;
+
 	ret = alloc_private(dev, sizeof(*devpriv));
 	if (ret)
 		return ret;
 	devpriv = dev->private;
 
-	pcidev = cb_pcimdas_find_pci_dev(dev, it);
-	if (!pcidev)
-		return -EIO;
-	comedi_set_hw_dev(dev, &pcidev->dev);
-	thisboard = comedi_board(dev);
-
 	/*  Warn about non-tested features */
 	switch (thisboard->device_id) {
 	case 0x56:
@@ -313,11 +297,9 @@ static int cb_pcimdas_attach(struct comedi_device *dev,
 			"PLEASE REPORT USAGE TO <mocelet@sucs.org>\n");
 	}
 
-	if (comedi_pci_enable(pcidev, "cb_pcimdas")) {
-		dev_err(dev->class_dev,
-			"Failed to enable PCI device and request regions\n");
-		return -EIO;
-	}
+	ret = comedi_pci_enable(pcidev, dev->board_name);
+	if (ret)
+		return ret;
 
 	dev->iobase = pci_resource_start(pcidev, 2);
 	devpriv->BADR3 = pci_resource_start(pcidev, 3);
@@ -332,9 +314,6 @@ static int cb_pcimdas_attach(struct comedi_device *dev,
 /* } */
 /* dev->irq = pcidev->irq; */
 
-	/* Initialize dev->board_name */
-	dev->board_name = thisboard->name;
-
 	ret = comedi_alloc_subdevices(dev, 3);
 	if (ret)
 		return ret;
@@ -369,7 +348,9 @@ static int cb_pcimdas_attach(struct comedi_device *dev,
 	else
 		s->type = COMEDI_SUBD_UNUSED;
 
-	return 1;
+	dev_info(dev->class_dev, "%s attached\n", dev->board_name);
+
+	return 0;
 }
 
 static void cb_pcimdas_detach(struct comedi_device *dev)
@@ -381,14 +362,13 @@ static void cb_pcimdas_detach(struct comedi_device *dev)
 	if (pcidev) {
 		if (dev->iobase)
 			comedi_pci_disable(pcidev);
-		pci_dev_put(pcidev);
 	}
 }
 
 static struct comedi_driver cb_pcimdas_driver = {
 	.driver_name	= "cb_pcimdas",
 	.module		= THIS_MODULE,
-	.attach		= cb_pcimdas_attach,
+	.attach_pci	= cb_pcimdas_attach_pci,
 	.detach		= cb_pcimdas_detach,
 };
 
-- 
1.7.11

