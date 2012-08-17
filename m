Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933617Ab2HQCoq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 22:44:46 -0400
Received: from mail209.messagelabs.com ([216.82.255.3]:33443 "EHLO
	mail209.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932118Ab2HQCom (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 22:44:42 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-9.tower-209.messagelabs.com!1345171481!7671427!1
X-Originating-IP: [216.166.12.72]
X-StarScan-Received: 
X-StarScan-Version: 6.6.1.2; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 07/35] staging: comedi: cb_pcidio: use attach_pci callback
Date: Thu, 16 Aug 2012 19:44:35 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201208161944.36018.hartleys@visionengravers.com>
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
 drivers/staging/comedi/drivers/cb_pcidio.c | 97 +++++++++++++-----------------
 1 file changed, 41 insertions(+), 56 deletions(-)

diff --git a/drivers/staging/comedi/drivers/cb_pcidio.c b/drivers/staging/comedi/drivers/cb_pcidio.c
index c377beb..52c6379 100644
--- a/drivers/staging/comedi/drivers/cb_pcidio.c
+++ b/drivers/staging/comedi/drivers/cb_pcidio.c
@@ -30,13 +30,7 @@ Status: experimental
 
 This driver has been modified from skel.c of comedi-0.7.70.
 
-Configuration Options:
-  [0] - PCI bus of device (optional)
-  [1] - PCI slot of device (optional)
-  If bus/slot is not specified, the first available PCI device will
-  be used.
-
-Passing a zero for an option is the same as leaving it unspecified.
+Configuration Options: not applicable, uses PCI auto config
 */
 
 /*------------------------------ HEADER FILES ---------------------------------*/
@@ -85,90 +79,81 @@ static const struct pcidio_board pcidio_boards[] = {
 	 },
 };
 
-static struct pci_dev *pcidio_find_pci_dev(struct comedi_device *dev,
-					   struct comedi_devconfig *it)
+static const void *pcidio_find_boardinfo(struct comedi_device *dev,
+					 struct pci_dev *pcidev)
 {
-	struct pci_dev *pcidev = NULL;
-	int bus = it->options[0];
-	int slot = it->options[1];
+	const struct pcidio_board *board;
 	int i;
 
-	for_each_pci_dev(pcidev) {
-		if (bus || slot) {
-			if (bus != pcidev->bus->number ||
-				slot != PCI_SLOT(pcidev->devfn))
-				continue;
-		}
-		if (pcidev->vendor != PCI_VENDOR_ID_CB)
-			continue;
-		for (i = 0; i < ARRAY_SIZE(pcidio_boards); i++) {
-			if (pcidio_boards[i].dev_id != pcidev->device)
-				continue;
-
-			dev->board_ptr = pcidio_boards + i;
-			return pcidev;
-		}
+	for (i = 0; i < ARRAY_SIZE(pcidio_boards); i++) {
+		board = &pcidio_boards[i];
+		if (board->dev_id == pcidev->device)
+			return board;
 	}
-	dev_err(dev->class_dev,
-		"No supported board found! (req. bus %d, slot %d)\n",
-		bus, slot);
 	return NULL;
 }
 
-static int pcidio_attach(struct comedi_device *dev, struct comedi_devconfig *it)
+static int pcidio_attach_pci(struct comedi_device *dev,
+			     struct pci_dev *pcidev)
 {
-	const struct pcidio_board *thisboard;
-	struct pci_dev *pcidev;
+	const struct pcidio_board *board;
+	struct comedi_subdevice *s;
 	int i;
 	int ret;
 
-	pcidev = pcidio_find_pci_dev(dev, it);
-	if (!pcidev)
-		return -EIO;
 	comedi_set_hw_dev(dev, &pcidev->dev);
-	thisboard = comedi_board(dev);
-	dev->board_name = thisboard->name;
 
-	if (comedi_pci_enable(pcidev, thisboard->name))
-		return -EIO;
+	board = pcidio_find_boardinfo(dev, pcidev);
+	if (!board)
+		return -ENODEV;
+	dev->board_ptr = board;
+	dev->board_name = board->name;
 
-	dev->iobase = pci_resource_start(pcidev, thisboard->dioregs_badrindex);
+	ret = comedi_pci_enable(pcidev, dev->board_name);
+	if (ret)
+		return ret;
+	dev->iobase = pci_resource_start(pcidev, board->dioregs_badrindex);
 
-	ret = comedi_alloc_subdevices(dev, thisboard->n_8255);
+	ret = comedi_alloc_subdevices(dev, board->n_8255);
 	if (ret)
 		return ret;
 
-	for (i = 0; i < thisboard->n_8255; i++) {
-		subdev_8255_init(dev, dev->subdevices + i,
-				 NULL, dev->iobase + i * 4);
-		dev_dbg(dev->class_dev, "subdev %d: base = 0x%lx\n", i,
-			dev->iobase + i * 4);
+	for (i = 0; i < board->n_8255; i++) {
+		s = dev->subdevices + i;
+		ret = subdev_8255_init(dev, s, NULL, dev->iobase + i * 4);
+		if (ret)
+			return ret;
 	}
 
-	return 1;
+	dev_info(dev->class_dev, "%s attached (%d digital i/o channels)\n",
+		dev->board_name, board->n_8255 * 24);
+
+	return 0;
 }
 
 static void pcidio_detach(struct comedi_device *dev)
 {
-	const struct pcidio_board *thisboard = comedi_board(dev);
+	const struct pcidio_board *board = comedi_board(dev);
 	struct pci_dev *pcidev = comedi_to_pci_dev(dev);
+	struct comedi_subdevice *s;
+	int i;
 
+	if (dev->subdevices) {
+		for (i = 0; i < board->n_8255; i++) {
+			s = dev->subdevices + i;
+			subdev_8255_cleanup(dev, s);
+		}
+	}
 	if (pcidev) {
 		if (dev->iobase)
 			comedi_pci_disable(pcidev);
-		pci_dev_put(pcidev);
-	}
-	if (dev->subdevices) {
-		int i;
-		for (i = 0; i < thisboard->n_8255; i++)
-			subdev_8255_cleanup(dev, dev->subdevices + i);
 	}
 }
 
 static struct comedi_driver cb_pcidio_driver = {
 	.driver_name	= "cb_pcidio",
 	.module		= THIS_MODULE,
-	.attach		= pcidio_attach,
+	.attach_pci	= pcidio_attach_pci,
 	.detach		= pcidio_detach,
 };
 
-- 
1.7.11

