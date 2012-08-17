Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933556Ab2HQCnh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 22:43:37 -0400
Received: from mail127.messagelabs.com ([216.82.250.115]:38602 "EHLO
	mail127.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932118Ab2HQCne (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 22:43:34 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-8.tower-127.messagelabs.com!1345171400!3211174!9
X-Originating-IP: [216.166.12.31]
X-StarScan-Received: 
X-StarScan-Version: 6.6.1.2; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 05/35] staging: comedi: cb_pcidas: use attach_pci callback
Date: Thu, 16 Aug 2012 19:43:29 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201208161943.29881.hartleys@visionengravers.com>
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
 drivers/staging/comedi/drivers/cb_pcidas.c | 84 ++++++++++--------------------
 1 file changed, 28 insertions(+), 56 deletions(-)

diff --git a/drivers/staging/comedi/drivers/cb_pcidas.c b/drivers/staging/comedi/drivers/cb_pcidas.c
index 2b6a637..4b6fb88 100644
--- a/drivers/staging/comedi/drivers/cb_pcidas.c
+++ b/drivers/staging/comedi/drivers/cb_pcidas.c
@@ -45,11 +45,7 @@ Status:
   The boards may be autocalibrated using the comedi_calibrate
   utility.
 
-Configuration options:
-  [0] - PCI bus of device (optional)
-  [1] - PCI slot of device (optional)
-  If bus/slot is not specified, the first supported
-  PCI device found will be used.
+Configuration options: not applicable, uses PCI auto config
 
 For commands, the scanned channels must be consecutive
 (i.e. 4-5-6-7, 2-3-4,...), and must all have the same
@@ -1501,69 +1497,45 @@ static irqreturn_t cb_pcidas_interrupt(int irq, void *d)
 	return IRQ_HANDLED;
 }
 
-static struct pci_dev *cb_pcidas_find_pci_device(struct comedi_device *dev,
-						 struct comedi_devconfig *it)
+static const void *cb_pcidas_find_boardinfo(struct comedi_device *dev,
+					    struct pci_dev *pcidev)
 {
 	const struct cb_pcidas_board *thisboard;
-	struct pci_dev *pcidev = NULL;
-	int bus = it->options[0];
-	int slot = it->options[1];
 	int i;
 
-	for_each_pci_dev(pcidev) {
-		/*  is it not a computer boards card? */
-		if (pcidev->vendor != PCI_VENDOR_ID_CB)
-			continue;
-		/*  loop through cards supported by this driver */
-		for (i = 0; i < ARRAY_SIZE(cb_pcidas_boards); i++) {
-			thisboard = &cb_pcidas_boards[i];
-			if (thisboard->device_id != pcidev->device)
-				continue;
-			/*  was a particular bus/slot requested? */
-			if (bus || slot) {
-				/*  are we on the wrong bus/slot? */
-				if (pcidev->bus->number != bus ||
-				    PCI_SLOT(pcidev->devfn) != slot) {
-					continue;
-				}
-			}
-			dev_dbg(dev->class_dev,
-				"Found %s on bus %i, slot %i\n",
-				thisboard->name,
-				pcidev->bus->number, PCI_SLOT(pcidev->devfn));
-			dev->board_ptr = thisboard;
-			return pcidev;
-		}
+	for (i = 0; i < ARRAY_SIZE(cb_pcidas_boards); i++) {
+		thisboard = &cb_pcidas_boards[i];
+		if (thisboard->device_id == pcidev->device)
+			return thisboard;
 	}
-	dev_err(dev->class_dev, "No supported card found\n");
 	return NULL;
 }
 
-static int cb_pcidas_attach(struct comedi_device *dev,
-			    struct comedi_devconfig *it)
+static int cb_pcidas_attach_pci(struct comedi_device *dev,
+				struct pci_dev *pcidev)
 {
 	const struct cb_pcidas_board *thisboard;
 	struct cb_pcidas_private *devpriv;
-	struct pci_dev *pcidev;
 	struct comedi_subdevice *s;
 	int i;
 	int ret;
 
-	if (alloc_private(dev, sizeof(struct cb_pcidas_private)) < 0)
-		return -ENOMEM;
-	devpriv = dev->private;
-
-	pcidev = cb_pcidas_find_pci_device(dev, it);
-	if (!pcidev)
-		return -EIO;
 	comedi_set_hw_dev(dev, &pcidev->dev);
-	thisboard = comedi_board(dev);
 
-	if (comedi_pci_enable(pcidev, dev->driver->driver_name)) {
-		dev_err(dev->class_dev,
-			"Failed to enable PCI device and request regions\n");
-		return -EIO;
-	}
+	thisboard = cb_pcidas_find_boardinfo(dev, pcidev);
+	if (!thisboard)
+		return -ENODEV;
+	dev->board_ptr  = thisboard;
+	dev->board_name = thisboard->name;
+
+	ret = alloc_private(dev, sizeof(*devpriv));
+	if (ret)
+		return ret;
+	devpriv = dev->private;
+
+	ret = comedi_pci_enable(pcidev, dev->board_name);
+	if (ret)
+		return ret;
 
 	devpriv->s5933_config = pci_resource_start(pcidev, 0);
 	devpriv->control_status = pci_resource_start(pcidev, 1);
@@ -1584,8 +1556,6 @@ static int cb_pcidas_attach(struct comedi_device *dev,
 	}
 	dev->irq = pcidev->irq;
 
-	dev->board_name = thisboard->name;
-
 	ret = comedi_alloc_subdevices(dev, 7);
 	if (ret)
 		return ret;
@@ -1698,7 +1668,10 @@ static int cb_pcidas_attach(struct comedi_device *dev,
 	outl(devpriv->s5933_intcsr_bits | INTCSR_INBOX_INTR_STATUS,
 	     devpriv->s5933_config + AMCC_OP_REG_INTCSR);
 
-	return 1;
+	dev_info(dev->class_dev, "%s: %s attached\n",
+		dev->driver->driver_name, dev->board_name);
+
+	return 0;
 }
 
 static void cb_pcidas_detach(struct comedi_device *dev)
@@ -1719,14 +1692,13 @@ static void cb_pcidas_detach(struct comedi_device *dev)
 	if (pcidev) {
 		if (devpriv->s5933_config)
 			comedi_pci_disable(pcidev);
-		pci_dev_put(pcidev);
 	}
 }
 
 static struct comedi_driver cb_pcidas_driver = {
 	.driver_name	= "cb_pcidas",
 	.module		= THIS_MODULE,
-	.attach		= cb_pcidas_attach,
+	.attach_pci	= cb_pcidas_attach_pci,
 	.detach		= cb_pcidas_detach,
 };
 
-- 
1.7.11

