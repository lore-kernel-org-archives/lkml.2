Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753685Ab2HRBSp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 21:18:45 -0400
Received: from mail160.messagelabs.com ([216.82.253.99]:37930 "EHLO
	mail160.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751606Ab2HRBSg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 21:18:36 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-6.tower-160.messagelabs.com!1345252713!8736702!13
X-Originating-IP: [216.166.12.98]
X-StarScan-Received: 
X-StarScan-Version: 6.6.1.2; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 11/20] staging: comedi: adv_pci1723: use attach_pci callback
Date: Fri, 17 Aug 2012 18:18:16 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201208171818.16343.hartleys@visionengravers.com>
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
 drivers/staging/comedi/drivers/adv_pci1723.c | 42 ++++------------------------
 1 file changed, 6 insertions(+), 36 deletions(-)

diff --git a/drivers/staging/comedi/drivers/adv_pci1723.c b/drivers/staging/comedi/drivers/adv_pci1723.c
index 21dfde2..63f0985 100644
--- a/drivers/staging/comedi/drivers/adv_pci1723.c
+++ b/drivers/staging/comedi/drivers/adv_pci1723.c
@@ -238,50 +238,21 @@ static int pci1723_dio_insn_bits(struct comedi_device *dev,
 	return insn->n;
 }
 
-static struct pci_dev *pci1723_find_pci_dev(struct comedi_device *dev,
-					    struct comedi_devconfig *it)
-{
-	struct pci_dev *pcidev = NULL;
-	int bus = it->options[0];
-	int slot = it->options[1];
-
-	for_each_pci_dev(pcidev) {
-		if (bus || slot) {
-			if (bus != pcidev->bus->number ||
-			    slot != PCI_SLOT(pcidev->devfn))
-				continue;
-		}
-		if (pcidev->vendor != PCI_VENDOR_ID_ADVANTECH)
-			continue;
-		if (pcidev->device != 0x1723)
-			continue;
-		return pcidev;
-	}
-	dev_err(dev->class_dev,
-		"No supported board found! (req. bus %d, slot %d)\n",
-		bus, slot);
-	return NULL;
-}
-
-static int pci1723_attach(struct comedi_device *dev,
-			  struct comedi_devconfig *it)
+static int pci1723_attach_pci(struct comedi_device *dev,
+			      struct pci_dev *pcidev)
 {
 	struct pci1723_private *devpriv;
-	struct pci_dev *pcidev;
 	struct comedi_subdevice *s;
 	int ret;
 
+	comedi_set_hw_dev(dev, &pcidev->dev);
+	dev->board_name = dev->driver->driver_name;
+
 	ret = alloc_private(dev, sizeof(*devpriv));
 	if (ret < 0)
 		return ret;
 	devpriv = dev->private;
 
-	pcidev = pci1723_find_pci_dev(dev, it);
-	if (!pcidev)
-		return -EIO;
-	comedi_set_hw_dev(dev, &pcidev->dev);
-	dev->board_name = dev->driver->driver_name;
-
 	ret = comedi_pci_enable(pcidev, dev->board_name);
 	if (ret)
 		return ret;
@@ -353,14 +324,13 @@ static void pci1723_detach(struct comedi_device *dev)
 	if (pcidev) {
 		if (dev->iobase)
 			comedi_pci_disable(pcidev);
-		pci_dev_put(pcidev);
 	}
 }
 
 static struct comedi_driver adv_pci1723_driver = {
 	.driver_name	= "adv_pci1723",
 	.module		= THIS_MODULE,
-	.attach		= pci1723_attach,
+	.attach_pci	= pci1723_attach_pci,
 	.detach		= pci1723_detach,
 };
 
-- 
1.7.11

