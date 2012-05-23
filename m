Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760899Ab2EWV3T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 17:29:19 -0400
Received: from mail160.messagelabs.com ([216.82.253.99]:38883 "EHLO
	mail160.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758864Ab2EWV3F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 17:29:05 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-8.tower-160.messagelabs.com!1337808543!7349922!3
X-Originating-IP: [216.166.12.31]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] staging: comedi: adl_pci7296: factor out the PCI device code
Date: Wed, 23 May 2012 14:28:47 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201205231428.48061.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Factor out the code that finds a matching PCI device from attach
function. This allows reducing the indent level of the remaining
code in the attach function.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---

diff --git a/drivers/staging/comedi/drivers/adl_pci7296.c b/drivers/staging/comedi/drivers/adl_pci7296.c
index b4dae3b..4df57b1 100644
--- a/drivers/staging/comedi/drivers/adl_pci7296.c
+++ b/drivers/staging/comedi/drivers/adl_pci7296.c
@@ -55,19 +55,40 @@ struct adl_pci7296_private {
 
 #define devpriv ((struct adl_pci7296_private *)dev->private)
 
+static struct pci_dev *adl_pci7296_find_pci(struct comedi_device *dev,
+					    struct comedi_devconfig *it)
+{
+	struct pci_dev *pcidev = NULL;
+	int bus = it->options[0];
+	int slot = it->options[1];
+
+	for_each_pci_dev(pcidev) {
+		if (pcidev->vendor != PCI_VENDOR_ID_ADLINK ||
+		    pcidev->device != PCI_DEVICE_ID_PCI7296)
+			continue;
+		if (bus || slot) {
+			/* requested particular bus/slot */
+			if (pcidev->bus->number != bus ||
+			    PCI_SLOT(pcidev->devfn) != slot)
+				continue;
+		}
+		return pcidev;
+	}
+	printk(KERN_ERR
+		"comedi%d: no supported board found! (req. bus/slot : %d/%d)\n",
+	       dev->minor, bus, slot);
+	return NULL;
+}
+
 static int adl_pci7296_attach(struct comedi_device *dev,
 			      struct comedi_devconfig *it)
 {
-	struct pci_dev *pcidev = NULL;
 	struct comedi_subdevice *s;
-	int bus, slot;
 	int ret;
 
 	printk(KERN_INFO "comedi%d: attach adl_pci7432\n", dev->minor);
 
 	dev->board_name = "pci7432";
-	bus = it->options[0];
-	slot = it->options[1];
 
 	if (alloc_private(dev, sizeof(struct adl_pci7296_private)) < 0)
 		return -ENOMEM;
@@ -75,63 +96,45 @@ static int adl_pci7296_attach(struct comedi_device *dev,
 	if (alloc_subdevices(dev, 4) < 0)
 		return -ENOMEM;
 
-	for_each_pci_dev(pcidev) {
-		if (pcidev->vendor == PCI_VENDOR_ID_ADLINK &&
-		    pcidev->device == PCI_DEVICE_ID_PCI7296) {
-			if (bus || slot) {
-				/* requested particular bus/slot */
-				if (pcidev->bus->number != bus
-				    || PCI_SLOT(pcidev->devfn) != slot) {
-					continue;
-				}
-			}
-			devpriv->pci_dev = pcidev;
-			if (comedi_pci_enable(pcidev, "adl_pci7296") < 0) {
-				printk(KERN_ERR "comedi%d: Failed to enable PCI device and request regions\n",
-				     dev->minor);
-				return -EIO;
-			}
+	devpriv->pci_dev = adl_pci7296_find_pci(dev, it);
+	if (!devpriv->pci_dev)
+		return -EIO;
 
-			dev->iobase = pci_resource_start(pcidev, 2);
-			printk(KERN_INFO "comedi: base addr %4lx\n",
-				dev->iobase);
+	if (comedi_pci_enable(devpriv->pci_dev, "adl_pci7296") < 0) {
+		printk(KERN_ERR
+			"comedi%d: Failed to enable PCI device and request regions\n",
+			dev->minor);
+		return -EIO;
+	}
 
-			/*  four 8255 digital io subdevices */
-			s = dev->subdevices + 0;
-			subdev_8255_init(dev, s, NULL,
-					 (unsigned long)(dev->iobase));
+	dev->iobase = pci_resource_start(devpriv->pci_dev, 2);
+	printk(KERN_INFO "comedi: base addr %4lx\n", dev->iobase);
 
-			s = dev->subdevices + 1;
-			ret = subdev_8255_init(dev, s, NULL,
-					       (unsigned long)(dev->iobase +
-							       PORT2A));
-			if (ret < 0)
-				return ret;
+	/*  four 8255 digital io subdevices */
+	s = dev->subdevices + 0;
+	subdev_8255_init(dev, s, NULL, (unsigned long)(dev->iobase));
 
-			s = dev->subdevices + 2;
-			ret = subdev_8255_init(dev, s, NULL,
-					       (unsigned long)(dev->iobase +
-							       PORT3A));
-			if (ret < 0)
-				return ret;
+	s = dev->subdevices + 1;
+	ret = subdev_8255_init(dev, s, NULL,
+				(unsigned long)(dev->iobase + PORT2A));
+	if (ret < 0)
+		return ret;
 
-			s = dev->subdevices + 3;
-			ret = subdev_8255_init(dev, s, NULL,
-					       (unsigned long)(dev->iobase +
-							       PORT4A));
-			if (ret < 0)
-				return ret;
+	s = dev->subdevices + 2;
+	ret = subdev_8255_init(dev, s, NULL,
+				(unsigned long)(dev->iobase + PORT3A));
+	if (ret < 0)
+		return ret;
 
-			printk(KERN_DEBUG "comedi%d: adl_pci7432 attached\n",
-				dev->minor);
+	s = dev->subdevices + 3;
+	ret = subdev_8255_init(dev, s, NULL,
+				(unsigned long)(dev->iobase + PORT4A));
+	if (ret < 0)
+		return ret;
 
-			return 1;
-		}
-	}
+	printk(KERN_DEBUG "comedi%d: adl_pci7432 attached\n", dev->minor);
 
-	printk(KERN_ERR "comedi%d: no supported board found! (req. bus/slot : %d/%d)\n",
-	       dev->minor, bus, slot);
-	return -EIO;
+	return 0;
 }
 
 static void adl_pci7296_detach(struct comedi_device *dev)
