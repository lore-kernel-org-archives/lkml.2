Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030321Ab2HQCtj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 22:49:39 -0400
Received: from mail127.messagelabs.com ([216.82.250.115]:20004 "EHLO
	mail127.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933137Ab2HQCti (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 22:49:38 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-6.tower-127.messagelabs.com!1345171776!7768430!5
X-Originating-IP: [216.166.12.97]
X-StarScan-Received: 
X-StarScan-Version: 6.6.1.2; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 18/35] staging: comedi: cb_pcimdda: cleanup pci probe
Date: Thu, 16 Aug 2012 19:48:56 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201208161948.57213.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make cb_pcimdda_probe() return the pointer to the found pci_dev
and move the comedi_pci_enable() call into the 'attach' function.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/cb_pcimdda.c | 62 ++++++++---------------------
 1 file changed, 17 insertions(+), 45 deletions(-)

diff --git a/drivers/staging/comedi/drivers/cb_pcimdda.c b/drivers/staging/comedi/drivers/cb_pcimdda.c
index edce275..0c6d941 100644
--- a/drivers/staging/comedi/drivers/cb_pcimdda.c
+++ b/drivers/staging/comedi/drivers/cb_pcimdda.c
@@ -213,54 +213,30 @@ static int cb_pcimdda_ao_rinsn(struct comedi_device *dev,
 	return i;
 }
 
-static int cb_pcimdda_probe(struct comedi_device *dev,
-			    const struct comedi_devconfig *it)
+static struct pci_dev *cb_pcimdda_probe(struct comedi_device *dev,
+					struct comedi_devconfig *it)
 {
-	const struct cb_pcimdda_board *thisboard;
-	struct cb_pcimdda_private *devpriv = dev->private;
 	struct pci_dev *pcidev = NULL;
 	int index;
-	unsigned long registers;
 
 	for_each_pci_dev(pcidev) {
-		/*  is it not a computer boards card? */
 		if (pcidev->vendor != PCI_VENDOR_ID_COMPUTERBOARDS)
 			continue;
-		/*  loop through cards supported by this driver */
 		for (index = 0; index < ARRAY_SIZE(cb_pcimdda_boards); index++) {
 			if (cb_pcimdda_boards[index].device_id != pcidev->device)
 				continue;
-			/*  was a particular bus/slot requested? */
 			if (it->options[0] || it->options[1]) {
-				/*  are we on the wrong bus/slot? */
 				if (pcidev->bus->number != it->options[0] ||
 				    PCI_SLOT(pcidev->devfn) != it->options[1]) {
 					continue;
 				}
 			}
-			/* found ! */
 
-			devpriv->pci_dev = pcidev;
 			dev->board_ptr = cb_pcimdda_boards + index;
-			thisboard = comedi_board(dev);
-			if (comedi_pci_enable(pcidev, thisboard->name)) {
-				printk
-				    ("cb_pcimdda: Failed to enable PCI device and request regions\n");
-				return -EIO;
-			}
-			registers =
-			    pci_resource_start(devpriv->pci_dev,
-					       thisboard->regs_badrindex);
-			devpriv->registers = registers;
-			devpriv->dio_registers
-			    = devpriv->registers + thisboard->dio_offset;
-			return 0;
+			return pcidev;
 		}
 	}
-
-	printk("cb_pcimdda: No supported ComputerBoards/MeasurementComputing "
-	       "card found at the requested position\n");
-	return -ENODEV;
+	return NULL;
 }
 
 static int cb_pcimdda_attach(struct comedi_device *dev,
@@ -268,6 +244,7 @@ static int cb_pcimdda_attach(struct comedi_device *dev,
 {
 	const struct cb_pcimdda_board *thisboard;
 	struct cb_pcimdda_private *devpriv;
+	struct pci_dev *pcidev;
 	struct comedi_subdevice *s;
 	int err;
 
@@ -276,25 +253,20 @@ static int cb_pcimdda_attach(struct comedi_device *dev,
 		return err;
 	devpriv = dev->private;
 
-/*
- * If you can probe the device to determine what device in a series
- * it is, this is the place to do it.  Otherwise, dev->board_ptr
- * should already be initialized.
- */
-	err = cb_pcimdda_probe(dev, it);
-	if (err)
-		return err;
+	pcidev = cb_pcimdda_probe(dev, it);
+	if (!pcidev)
+		return -EIO;
+	devpriv->pci_dev = pcidev;
 	thisboard = comedi_board(dev);
-
-/* Output some info */
-	printk("comedi%d: %s: ", dev->minor, thisboard->name);
-
-/*
- * Initialize dev->board_name.  Note that we can use the "thisboard"
- * macro now, since we just initialized it in the last line.
- */
 	dev->board_name = thisboard->name;
 
+	err = comedi_pci_enable(pcidev, dev->board_name);
+	if (err)
+		return err;
+	devpriv->registers = pci_resource_start(devpriv->pci_dev,
+						thisboard->regs_badrindex);
+	devpriv->dio_registers = devpriv->registers + thisboard->dio_offset;
+
 	err = comedi_alloc_subdevices(dev, 2);
 	if (err)
 		return err;
@@ -336,7 +308,7 @@ static int cb_pcimdda_attach(struct comedi_device *dev,
 		s->type = COMEDI_SUBD_UNUSED;
 	}
 
-	printk("attached\n");
+	dev_info(dev->class_dev, "%s attached\n", dev->board_name);
 
 	return 1;
 }
-- 
1.7.11

