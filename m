Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759728Ab2HIVvQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 17:51:16 -0400
Received: from mail127.messagelabs.com ([216.82.250.115]:4904 "EHLO
	mail127.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757387Ab2HIVvO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 17:51:14 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-8.tower-127.messagelabs.com!1344549072!2503537!3
X-Originating-IP: [216.166.12.72]
X-StarScan-Received: 
X-StarScan-Version: 6.6.1.2; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/4] staging: comedi: adl_pci6208: use attach_pci callback
Date: Thu, 9 Aug 2012 14:50:35 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201208091450.37365.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert this PCI driver to use the comedi PCI auto config attach mechanism
by adding an attach_pci callback function. Since the driver does not require
any external configuration options, disable the legacy attach by making the
attach callback simply return -ENOSYS. This removes the need to walk the pci
bus to find the pci_dev and the need for the pci_dev_put() in the detach.

For aesthetic reasons, rename the local variable 'thisboard' to 'boardinfo'.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/adl_pci6208.c | 78 +++++++++++-----------------
 1 file changed, 30 insertions(+), 48 deletions(-)

diff --git a/drivers/staging/comedi/drivers/adl_pci6208.c b/drivers/staging/comedi/drivers/adl_pci6208.c
index 3bec0f6..6d887f7 100644
--- a/drivers/staging/comedi/drivers/adl_pci6208.c
+++ b/drivers/staging/comedi/drivers/adl_pci6208.c
@@ -33,8 +33,7 @@ Author: nsyeow <nsyeow@pd.jaring.my>
 Updated: Fri, 30 Jan 2004 14:44:27 +0800
 Status: untested
 
-Configuration Options:
-  none
+Configuration Options: not applicable, uses PCI auto config
 
 References:
 	- ni_660x.c
@@ -155,67 +154,41 @@ static int pci6208_dio_insn_config(struct comedi_device *dev,
 	return insn->n;
 }
 
-static struct pci_dev *pci6208_find_device(struct comedi_device *dev,
-					   struct comedi_devconfig *it)
+static const void *pci6208_find_boardinfo(struct comedi_device *dev,
+					  struct pci_dev *pcidev)
 {
-	const struct pci6208_board *thisboard;
-	struct pci_dev *pci_dev = NULL;
-	int bus = it->options[0];
-	int slot = it->options[1];
+	const struct pci6208_board *boardinfo;
 	int i;
 
-	for_each_pci_dev(pci_dev) {
-		if (pci_dev->vendor != PCI_VENDOR_ID_ADLINK)
-			continue;
-		for (i = 0; i < ARRAY_SIZE(pci6208_boards); i++) {
-			thisboard = &pci6208_boards[i];
-			if (thisboard->dev_id != pci_dev->device)
-				continue;
-			/* was a particular bus/slot requested? */
-			if (bus || slot) {
-				/* are we on the wrong bus/slot? */
-				if (pci_dev->bus->number != bus ||
-				    PCI_SLOT(pci_dev->devfn) != slot)
-					continue;
-			}
-			dev_dbg(dev->class_dev,
-				"Found %s on bus %d, slot, %d, irq=%d\n",
-				thisboard->name,
-				pci_dev->bus->number,
-				PCI_SLOT(pci_dev->devfn),
-				pci_dev->irq);
-			dev->board_ptr = thisboard;
-			return pci_dev;
-		}
+	for (i = 0; i < ARRAY_SIZE(pci6208_boards); i++) {
+		boardinfo = &pci6208_boards[i];
+		if (boardinfo->dev_id == pcidev->device)
+			return boardinfo;
 	}
-	dev_err(dev->class_dev,
-		"No supported board found! (req. bus %d, slot %d)\n",
-		bus, slot);
 	return NULL;
 }
 
-static int pci6208_attach(struct comedi_device *dev,
-			  struct comedi_devconfig *it)
+static int pci6208_attach_pci(struct comedi_device *dev,
+			      struct pci_dev *pcidev)
 {
-	const struct pci6208_board *thisboard;
+	const struct pci6208_board *boardinfo;
 	struct pci6208_private *devpriv;
-	struct pci_dev *pcidev;
 	struct comedi_subdevice *s;
 	int ret;
 
+	comedi_set_hw_dev(dev, &pcidev->dev);
+
+	boardinfo = pci6208_find_boardinfo(dev, pcidev);
+	if (!boardinfo)
+		return -ENODEV;
+	dev->board_ptr = boardinfo;
+	dev->board_name = boardinfo->name;
+
 	ret = alloc_private(dev, sizeof(*devpriv));
 	if (ret < 0)
 		return ret;
 	devpriv = dev->private;
 
-	pcidev = pci6208_find_device(dev, it);
-	if (!pcidev)
-		return -EIO;
-	comedi_set_hw_dev(dev, &pcidev->dev);
-	thisboard = comedi_board(dev);
-
-	dev->board_name = thisboard->name;
-
 	ret = comedi_pci_enable(pcidev, dev->driver->driver_name);
 	if (ret) {
 		dev_err(dev->class_dev,
@@ -232,7 +205,7 @@ static int pci6208_attach(struct comedi_device *dev,
 	/* analog output subdevice */
 	s->type		= COMEDI_SUBD_AO;
 	s->subdev_flags	= SDF_WRITABLE;
-	s->n_chan	= thisboard->ao_chans;
+	s->n_chan	= boardinfo->ao_chans;
 	s->maxdata	= 0xffff;
 	s->range_table	= &range_bipolar10;
 	s->insn_write	= pci6208_ao_winsn;
@@ -257,6 +230,15 @@ static int pci6208_attach(struct comedi_device *dev,
 	return 0;
 }
 
+static int pci6208_attach(struct comedi_device *dev,
+			  struct comedi_devconfig *it)
+{
+	dev_warn(dev->class_dev,
+		"This driver does not support attach using comedi_config\n");
+
+	return -ENOSYS;
+}
+
 static void pci6208_detach(struct comedi_device *dev)
 {
 	struct pci_dev *pcidev = comedi_to_pci_dev(dev);
@@ -264,7 +246,6 @@ static void pci6208_detach(struct comedi_device *dev)
 	if (pcidev) {
 		if (dev->iobase)
 			comedi_pci_disable(pcidev);
-		pci_dev_put(pcidev);
 	}
 }
 
@@ -272,6 +253,7 @@ static struct comedi_driver adl_pci6208_driver = {
 	.driver_name	= "adl_pci6208",
 	.module		= THIS_MODULE,
 	.attach		= pci6208_attach,
+	.attach_pci	= pci6208_attach_pci,
 	.detach		= pci6208_detach,
 };
 
-- 
1.7.11

