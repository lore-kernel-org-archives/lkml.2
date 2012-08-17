Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933251Ab2HQCnQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 22:43:16 -0400
Received: from mail131.messagelabs.com ([216.82.242.99]:13030 "EHLO
	mail131.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932118Ab2HQCnM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 22:43:12 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-4.tower-131.messagelabs.com!1345171391!24276571!1
X-Originating-IP: [216.166.12.98]
X-StarScan-Received: 
X-StarScan-Version: 6.6.1.2; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 04/35] staging: comedi: adl_pci8164: use attach_pci callback
Date: Thu, 16 Aug 2012 19:43:05 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201208161943.06147.hartleys@visionengravers.com>
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
 drivers/staging/comedi/drivers/adl_pci8164.c | 65 ++++++----------------------
 1 file changed, 13 insertions(+), 52 deletions(-)

diff --git a/drivers/staging/comedi/drivers/adl_pci8164.c b/drivers/staging/comedi/drivers/adl_pci8164.c
index 247ef00..ac406cf 100644
--- a/drivers/staging/comedi/drivers/adl_pci8164.c
+++ b/drivers/staging/comedi/drivers/adl_pci8164.c
@@ -27,11 +27,7 @@ Author: Michel Lachaine <mike@mikelachaine.ca>
 Status: experimental
 Updated: Mon, 14 Apr 2008 15:10:32 +0100
 
-Configuration Options:
-  [0] - PCI bus of device (optional)
-  [1] - PCI slot of device (optional)
-  If bus/slot is not specified, the first supported
-  PCI device found will be used.
+Configuration Options: not applicable, uses PCI auto config
 */
 
 #include "../comedidev.h"
@@ -216,59 +212,24 @@ static int adl_pci8164_insn_write_buf1(struct comedi_device *dev,
 	return 2;
 }
 
-static struct pci_dev *adl_pci8164_find_pci(struct comedi_device *dev,
-					    struct comedi_devconfig *it)
+static int adl_pci8164_attach_pci(struct comedi_device *dev,
+				  struct pci_dev *pcidev)
 {
-	struct pci_dev *pcidev = NULL;
-	int bus = it->options[0];
-	int slot = it->options[1];
-
-	for_each_pci_dev(pcidev) {
-		if (pcidev->vendor != PCI_VENDOR_ID_ADLINK ||
-		    pcidev->device != PCI_DEVICE_ID_PCI8164)
-			continue;
-		if (bus || slot) {
-			/* requested particular bus/slot */
-			if (pcidev->bus->number != bus ||
-			    PCI_SLOT(pcidev->devfn) != slot)
-				continue;
-		}
-		return pcidev;
-	}
-	printk(KERN_ERR
-		"comedi%d: no supported board found! (req. bus/slot : %d/%d)\n",
-		dev->minor, bus, slot);
-	return NULL;
-}
-
-static int adl_pci8164_attach(struct comedi_device *dev,
-			      struct comedi_devconfig *it)
-{
-	struct pci_dev *pcidev;
 	struct comedi_subdevice *s;
 	int ret;
 
-	printk(KERN_INFO "comedi: attempt to attach...\n");
-	printk(KERN_INFO "comedi%d: adl_pci8164\n", dev->minor);
+	comedi_set_hw_dev(dev, &pcidev->dev);
 
-	dev->board_name = "pci8164";
+	dev->board_name = dev->driver->driver_name;
 
-	ret = comedi_alloc_subdevices(dev, 4);
+	ret = comedi_pci_enable(pcidev, dev->board_name);
 	if (ret)
 		return ret;
-
-	pcidev = adl_pci8164_find_pci(dev, it);
-	if (!pcidev)
-		return -EIO;
-	comedi_set_hw_dev(dev, &pcidev->dev);
-
-	if (comedi_pci_enable(pcidev, "adl_pci8164") < 0) {
-		printk(KERN_ERR "comedi%d: Failed to enable "
-		"PCI device and request regions\n", dev->minor);
-		return -EIO;
-	}
 	dev->iobase = pci_resource_start(pcidev, 2);
-	printk(KERN_DEBUG "comedi: base addr %4lx\n", dev->iobase);
+
+	ret = comedi_alloc_subdevices(dev, 4);
+	if (ret)
+		return ret;
 
 	s = dev->subdevices + 0;
 	s->type = COMEDI_SUBD_PROC;
@@ -310,7 +271,8 @@ static int adl_pci8164_attach(struct comedi_device *dev,
 	s->insn_read = adl_pci8164_insn_read_buf1;
 	s->insn_write = adl_pci8164_insn_write_buf1;
 
-	printk(KERN_INFO "comedi: attached\n");
+	dev_info(dev->class_dev, "%s attached\n", dev->board_name);
+
 	return 0;
 }
 
@@ -321,14 +283,13 @@ static void adl_pci8164_detach(struct comedi_device *dev)
 	if (pcidev) {
 		if (dev->iobase)
 			comedi_pci_disable(pcidev);
-		pci_dev_put(pcidev);
 	}
 }
 
 static struct comedi_driver adl_pci8164_driver = {
 	.driver_name	= "adl_pci8164",
 	.module		= THIS_MODULE,
-	.attach		= adl_pci8164_attach,
+	.attach_pci	= adl_pci8164_attach_pci,
 	.detach		= adl_pci8164_detach,
 };
 
-- 
1.7.11

