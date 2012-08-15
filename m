Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755456Ab2HOBYA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 21:24:00 -0400
Received: from mail160.messagelabs.com ([216.82.253.99]:12311 "EHLO
	mail160.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751909Ab2HOBX7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 21:23:59 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-7.tower-160.messagelabs.com!1344993837!5742915!1
X-Originating-IP: [216.166.12.32]
X-StarScan-Received: 
X-StarScan-Version: 6.6.1.2; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/7] staging: comedi: dnya_pci10xx: use attach_pci callback
Date: Tue, 14 Aug 2012 18:23:49 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201208141823.49804.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert this PCI driver to use the comedi PCI auto config attach
mechanism by adding an attach_pci callback function. Since the
driver does not require any external configuration options, disable
the legacy attach by making the attach simply return -ENOSYS. This
removes the need to walk the pci bus to find the pci_dev and the
need for the pci_dev_put() in the detach.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/dyna_pci10xx.c | 88 +++++++++++----------------
 1 file changed, 35 insertions(+), 53 deletions(-)

diff --git a/drivers/staging/comedi/drivers/dyna_pci10xx.c b/drivers/staging/comedi/drivers/dyna_pci10xx.c
index 7884a94..15048aa 100644
--- a/drivers/staging/comedi/drivers/dyna_pci10xx.c
+++ b/drivers/staging/comedi/drivers/dyna_pci10xx.c
@@ -227,73 +227,49 @@ static int dyna_pci10xx_do_insn_bits(struct comedi_device *dev,
 	return insn->n;
 }
 
-static struct pci_dev *dyna_pci10xx_find_pci_dev(struct comedi_device *dev,
-						 struct comedi_devconfig *it)
+static const void *dyna_pci10xx_find_boardinfo(struct comedi_device *dev,
+					       struct pci_dev *pcidev)
 {
-	struct pci_dev *pcidev = NULL;
-	int bus = it->options[0];
-	int slot = it->options[1];
+	const struct boardtype *thisboard;
 	int i;
 
-	for_each_pci_dev(pcidev) {
-		if (bus || slot) {
-			if (bus != pcidev->bus->number ||
-			    slot != PCI_SLOT(pcidev->devfn))
-				continue;
-		}
-		if (pcidev->vendor != PCI_VENDOR_ID_DYNALOG)
-			continue;
-
-		for (i = 0; i < ARRAY_SIZE(boardtypes); ++i) {
-			if (pcidev->device != boardtypes[i].device_id)
-				continue;
-
-			dev->board_ptr = &boardtypes[i];
-			return pcidev;
-		}
+	for (i = 0; i < ARRAY_SIZE(boardtypes); ++i) {
+		thisboard = &boardtypes[i];
+		if (pcidev->device != thisboard->device_id)
+			return thisboard;
 	}
-	dev_err(dev->class_dev,
-		"No supported board found! (req. bus %d, slot %d)\n",
-		bus, slot);
 	return NULL;
 }
 
-static int dyna_pci10xx_attach(struct comedi_device *dev,
-			  struct comedi_devconfig *it)
+static int dyna_pci10xx_attach_pci(struct comedi_device *dev,
+				   struct pci_dev *pcidev)
 {
 	const struct boardtype *thisboard;
 	struct dyna_pci10xx_private *devpriv;
-	struct pci_dev *pcidev;
 	struct comedi_subdevice *s;
 	int ret;
 
-	ret = alloc_private(dev, sizeof(*devpriv));
-	if (ret)
-		return ret;
-	devpriv = dev->private;
-
-	pcidev = dyna_pci10xx_find_pci_dev(dev, it);
-	if (!pcidev)
-		return -EIO;
 	comedi_set_hw_dev(dev, &pcidev->dev);
-	thisboard = comedi_board(dev);
 
+	thisboard = dyna_pci10xx_find_boardinfo(dev, pcidev);
+	if (!thisboard)
+		return -ENODEV;
+	dev->board_ptr = thisboard;
 	dev->board_name = thisboard->name;
-	dev->irq = 0;
-
-	if (comedi_pci_enable(pcidev, DRV_NAME)) {
-		printk(KERN_ERR "comedi: dyna_pci10xx: "
-			"failed to enable PCI device and request regions!");
-		return -EIO;
-	}
-
-	mutex_init(&devpriv->mutex);
 
-	printk(KERN_INFO "comedi: dyna_pci10xx: device found!\n");
+	ret = alloc_private(dev, sizeof(*devpriv));
+	if (ret)
+		return ret;
+	devpriv = dev->private;
 
+	ret = comedi_pci_enable(pcidev, dev->board_name);
+	if (ret)
+		return ret;
 	dev->iobase = pci_resource_start(pcidev, 2);
 	devpriv->BADR3 = pci_resource_start(pcidev, 3);
 
+	mutex_init(&devpriv->mutex);
+
 	ret = comedi_alloc_subdevices(dev, 4);
 	if (ret)
 		return ret;
@@ -339,10 +315,19 @@ static int dyna_pci10xx_attach(struct comedi_device *dev,
 	s->state = 0;
 	s->insn_bits = dyna_pci10xx_do_insn_bits;
 
-	printk(KERN_INFO "comedi: dyna_pci10xx: %s - device setup completed!\n",
-		thisboard->name);
+	dev_info(dev->class_dev, "%s: %s attached\n",
+		dev->driver->driver_name, dev->board_name);
+
+	return 0;
+}
+
+static int dyna_pci10xx_attach(struct comedi_device *dev,
+			       struct comedi_devconfig *it)
+{
+	dev_warn(dev->class_dev,
+		"This driver does not support attach using comedi_config\n");
 
-	return 1;
+	return -ENOSYS;
 }
 
 static void dyna_pci10xx_detach(struct comedi_device *dev)
@@ -355,7 +340,6 @@ static void dyna_pci10xx_detach(struct comedi_device *dev)
 	if (pcidev) {
 		if (dev->iobase)
 			comedi_pci_disable(pcidev);
-		pci_dev_put(pcidev);
 	}
 }
 
@@ -363,10 +347,8 @@ static struct comedi_driver dyna_pci10xx_driver = {
 	.driver_name	= "dyna_pci10xx",
 	.module		= THIS_MODULE,
 	.attach		= dyna_pci10xx_attach,
+	.attach_pci	= dyna_pci10xx_attach_pci,
 	.detach		= dyna_pci10xx_detach,
-	.board_name	= &boardtypes[0].name,
-	.offset		= sizeof(struct boardtype),
-	.num_names	= ARRAY_SIZE(boardtypes),
 };
 
 static int __devinit dyna_pci10xx_pci_probe(struct pci_dev *dev,
-- 
1.7.11

