Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755797Ab2HPAcl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 20:32:41 -0400
Received: from mail209.messagelabs.com ([216.82.255.3]:51505 "EHLO
	mail209.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753135Ab2HPAck (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 20:32:40 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-14.tower-209.messagelabs.com!1345077147!7541417!17
X-Originating-IP: [216.166.12.31]
X-StarScan-Received: 
X-StarScan-Version: 6.6.1.2; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 6/7] staging: comedi: contec_pci_dio: use attach_pci callback
Date: Wed, 15 Aug 2012 17:32:29 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201208151732.30056.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert this PCI driver to use the comedi PCI auto config attach
mechanism by adding an attach_pci callback function. Since the
driver does not require any external configuration options, disable
the legacy attach by making the attach simply return -ENOSYS. This
removes the need to walk to pci bus to find the pci_dev and the
need for the pci_dev_put in the detach.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Greg Kroah-hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/contec_pci_dio.c | 97 +++++++++----------------
 1 file changed, 35 insertions(+), 62 deletions(-)

diff --git a/drivers/staging/comedi/drivers/contec_pci_dio.c b/drivers/staging/comedi/drivers/contec_pci_dio.c
index 4b47fa0..b7b60d3 100644
--- a/drivers/staging/comedi/drivers/contec_pci_dio.c
+++ b/drivers/staging/comedi/drivers/contec_pci_dio.c
@@ -27,11 +27,7 @@ Author: Stefano Rivoir <s.rivoir@gts.it>
 Updated: Wed, 27 Jun 2007 13:00:06 +0100
 Status: works
 
-Configuration Options:
-  [0] - PCI bus of device (optional)
-  [1] - PCI slot of device (optional)
-  If bus/slot is not specified, the first supported
-  PCI device found will be used.
+Configuration Options: not applicable, uses comedi PCI auto config
 */
 
 #include "../comedidev.h"
@@ -66,76 +62,53 @@ static int contec_di_insn_bits(struct comedi_device *dev,
 	return insn->n;
 }
 
-static struct pci_dev *contec_find_pci_dev(struct comedi_device *dev,
-					   struct comedi_devconfig *it)
+static int contec_attach_pci(struct comedi_device *dev,
+			     struct pci_dev *pcidev)
 {
-	struct pci_dev *pcidev = NULL;
-	int bus = it->options[0];
-	int slot = it->options[1];
-
-	for_each_pci_dev(pcidev) {
-		if (bus || slot) {
-			if (bus != pcidev->bus->number ||
-				slot != PCI_SLOT(pcidev->devfn))
-				continue;
-		}
-		if (pcidev->vendor != PCI_VENDOR_ID_CONTEC ||
-		    pcidev->device != PCI_DEVICE_ID_PIO1616L)
-			continue;
-
-		return pcidev;
-	}
-	dev_err(dev->class_dev,
-		"No supported board found! (req. bus %d, slot %d)\n",
-		bus, slot);
-	return NULL;
-}
-
-static int contec_attach(struct comedi_device *dev, struct comedi_devconfig *it)
-{
-	struct pci_dev *pcidev;
 	struct comedi_subdevice *s;
 	int ret;
 
-	printk("comedi%d: contec: ", dev->minor);
-
-	ret = comedi_alloc_subdevices(dev, 2);
-	if (ret)
-		return ret;
-
-	pcidev = contec_find_pci_dev(dev, it);
-	if (!pcidev)
-		return -EIO;
 	comedi_set_hw_dev(dev, &pcidev->dev);
+
 	dev->board_name = dev->driver->driver_name;
 
-	if (comedi_pci_enable(pcidev, "contec_pci_dio")) {
-		printk("error enabling PCI device and request regions!\n");
-		return -EIO;
-	}
+	ret = comedi_pci_enable(pcidev, dev->board_name);
+	if (ret)
+		return ret;
 	dev->iobase = pci_resource_start(pcidev, 0);
-	printk(" base addr %lx ", dev->iobase);
 
-	s = dev->subdevices + 0;
+	ret = comedi_alloc_subdevices(dev, 2);
+	if (ret)
+		return ret;
 
-	s->type = COMEDI_SUBD_DI;
-	s->subdev_flags = SDF_READABLE;
-	s->n_chan = 16;
-	s->maxdata = 1;
-	s->range_table = &range_digital;
-	s->insn_bits = contec_di_insn_bits;
+	s = dev->subdevices + 0;
+	s->type		= COMEDI_SUBD_DI;
+	s->subdev_flags	= SDF_READABLE;
+	s->n_chan	= 16;
+	s->maxdata	= 1;
+	s->range_table	= &range_digital;
+	s->insn_bits	= contec_di_insn_bits;
 
 	s = dev->subdevices + 1;
-	s->type = COMEDI_SUBD_DO;
-	s->subdev_flags = SDF_WRITABLE;
-	s->n_chan = 16;
-	s->maxdata = 1;
-	s->range_table = &range_digital;
-	s->insn_bits = contec_do_insn_bits;
+	s->type		= COMEDI_SUBD_DO;
+	s->subdev_flags	= SDF_WRITABLE;
+	s->n_chan	= 16;
+	s->maxdata	= 1;
+	s->range_table	= &range_digital;
+	s->insn_bits	= contec_do_insn_bits;
+
+	dev_info(dev->class_dev, "%s attached\n", dev->board_name);
 
-	printk("attached\n");
+	return 0;
+}
+
+static int contec_attach(struct comedi_device *dev,
+			 struct comedi_devconfig *it)
+{
+	dev_warn(dev->class_dev,
+		"This driver does not support attach using comedi_config\n");
 
-	return 1;
+	return -ENOSYS;
 }
 
 static void contec_detach(struct comedi_device *dev)
@@ -145,7 +118,6 @@ static void contec_detach(struct comedi_device *dev)
 	if (pcidev) {
 		if (dev->iobase)
 			comedi_pci_disable(pcidev);
-		pci_dev_put(pcidev);
 	}
 }
 
@@ -153,6 +125,7 @@ static struct comedi_driver contec_pci_dio_driver = {
 	.driver_name	= "contec_pci_dio",
 	.module		= THIS_MODULE,
 	.attach		= contec_attach,
+	.attach_pci	= contec_attach_pci,
 	.detach		= contec_detach,
 };
 
-- 
1.7.11

