Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760839Ab2EWVOq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 17:14:46 -0400
Received: from mail131.messagelabs.com ([216.82.242.99]:45955 "EHLO
	mail131.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760814Ab2EWVOc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 17:14:32 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-2.tower-131.messagelabs.com!1337807666!24365296!9
X-Originating-IP: [216.166.12.69]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] staging: comedi: adl_pci7230: factor out the find PCI device code
Date: Wed, 23 May 2012 14:14:13 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201205231414.13686.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Factor out the code that finds a matching PCI device from attach
function.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---

diff --git a/drivers/staging/comedi/drivers/adl_pci7230.c b/drivers/staging/comedi/drivers/adl_pci7230.c
index e8053bc..e039e7c 100644
--- a/drivers/staging/comedi/drivers/adl_pci7230.c
+++ b/drivers/staging/comedi/drivers/adl_pci7230.c
@@ -81,18 +81,38 @@ static int adl_pci7230_di_insn_bits(struct comedi_device *dev,
 	return 2;
 }
 
-static int adl_pci7230_attach(struct comedi_device *dev,
+static struct pci_dev *adl_pci7230_find_pci(struct comedi_device *dev,
 	struct comedi_devconfig *it)
 {
 	struct pci_dev *pcidev = NULL;
+	int bus = it->options[0];
+	int slot = it->options[1];
+
+	for_each_pci_dev(pcidev) {
+		if (pcidev->vendor != PCI_VENDOR_ID_ADLINK ||
+		    pcidev->device != PCI_DEVICE_ID_PCI7230)
+			continue;
+		if (bus || slot) {
+			/* requested particular bus/slot */
+			if (pcidev->bus->number != bus ||
+			    PCI_SLOT(pcidev->devfn) != slot)
+				continue;
+		}
+		return pcidev;
+	}
+	printk(KERN_ERR "comedi%d: no supported board found! (req. bus/slot : %d/%d)\n",
+		dev->minor, bus, slot);
+	return NULL;
+}
+
+static int adl_pci7230_attach(struct comedi_device *dev,
+	struct comedi_devconfig *it)
+{
 	struct comedi_subdevice *s;
-	int bus, slot;
 
 	printk(KERN_INFO "comedi%d: adl_pci7230\n", dev->minor);
 
 	dev->board_name = "pci7230";
-	bus = it->options[0];
-	slot = it->options[1];
 
 	if (alloc_private(dev, sizeof(struct adl_pci7230_private)) < 0)
 		return -ENOMEM;
@@ -100,31 +120,16 @@ static int adl_pci7230_attach(struct comedi_device *dev,
 	if (alloc_subdevices(dev, 2) < 0)
 		return -ENOMEM;
 
-	for_each_pci_dev(pcidev) {
-		if (pcidev->vendor == PCI_VENDOR_ID_ADLINK &&
-			pcidev->device == PCI_DEVICE_ID_PCI7230) {
-			if (bus || slot) {
-				/* requested particular bus/slot */
-				if (pcidev->bus->number != bus ||
-					PCI_SLOT(pcidev->devfn) != slot) {
-					continue;
-				}
-			}
-			devpriv->pci_dev = pcidev;
-			break;
-		}
-	}
-	if (pcidev == NULL) {
-		printk(KERN_ERR "comedi%d: no supported board found! (req. bus/slot : %d/%d)\n",
-			dev->minor, bus, slot);
+	devpriv->pci_dev = adl_pci7230_find_pci(dev, it);
+	if (!devpriv->pci_dev)
 		return -EIO;
-	}
-	if (comedi_pci_enable(pcidev, "adl_pci7230") < 0) {
+
+	if (comedi_pci_enable(devpriv->pci_dev, "adl_pci7230") < 0) {
 		printk(KERN_ERR "comedi%d: Failed to enable PCI device and request regions\n",
 			dev->minor);
 		return -EIO;
 	}
-	dev->iobase = pci_resource_start(pcidev, 2);
+	dev->iobase = pci_resource_start(devpriv->pci_dev, 2);
 	printk(KERN_DEBUG "comedi: base addr %4lx\n", dev->iobase);
 
 	s = dev->subdevices + 0;
