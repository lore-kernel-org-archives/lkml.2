Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760906Ab2EWVim (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 17:38:42 -0400
Received: from mail127.messagelabs.com ([216.82.250.115]:30655 "EHLO
	mail127.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759462Ab2EWVil (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 17:38:41 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-7.tower-127.messagelabs.com!1337809120!6397854!1
X-Originating-IP: [216.166.12.69]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] staging: comedi: adl_pci7432: factor out the PCI device code
Date: Wed, 23 May 2012 14:38:33 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201205231438.34289.hartleys@visionengravers.com>
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

diff --git a/drivers/staging/comedi/drivers/adl_pci7432.c b/drivers/staging/comedi/drivers/adl_pci7432.c
index 9cbfb61..7317a06 100644
--- a/drivers/staging/comedi/drivers/adl_pci7432.c
+++ b/drivers/staging/comedi/drivers/adl_pci7432.c
@@ -89,18 +89,39 @@ static int adl_pci7432_di_insn_bits(struct comedi_device *dev,
 	return 2;
 }
 
+static struct pci_dev *adl_pci7432_find_pci(struct comedi_device *dev,
+					    struct comedi_devconfig *it)
+{
+	struct pci_dev *pcidev = NULL;
+	int bus = it->options[0];
+	int slot = it->options[1];
+
+	for_each_pci_dev(pcidev) {
+		if (pcidev->vendor != PCI_VENDOR_ID_ADLINK ||
+		    pcidev->device != PCI_DEVICE_ID_PCI7432)
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
 static int adl_pci7432_attach(struct comedi_device *dev,
 			      struct comedi_devconfig *it)
 {
-	struct pci_dev *pcidev = NULL;
 	struct comedi_subdevice *s;
-	int bus, slot;
 
 	printk(KERN_INFO "comedi%d: attach adl_pci7432\n", dev->minor);
 
 	dev->board_name = "pci7432";
-	bus = it->options[0];
-	slot = it->options[1];
 
 	if (alloc_private(dev, sizeof(struct adl_pci7432_private)) < 0)
 		return -ENOMEM;
@@ -108,57 +129,40 @@ static int adl_pci7432_attach(struct comedi_device *dev,
 	if (alloc_subdevices(dev, 2) < 0)
 		return -ENOMEM;
 
-	for_each_pci_dev(pcidev) {
-		if (pcidev->vendor == PCI_VENDOR_ID_ADLINK &&
-		    pcidev->device == PCI_DEVICE_ID_PCI7432) {
-			if (bus || slot) {
-				/* requested particular bus/slot */
-				if (pcidev->bus->number != bus
-				    || PCI_SLOT(pcidev->devfn) != slot) {
-					continue;
-				}
-			}
-			devpriv->pci_dev = pcidev;
-			if (comedi_pci_enable(pcidev, "adl_pci7432") < 0) {
-				printk(KERN_ERR "comedi%d: Failed to enable PCI device and request regions\n",
-				     dev->minor);
-				return -EIO;
-			}
-			dev->iobase = pci_resource_start(pcidev, 2);
-			printk(KERN_INFO "comedi: base addr %4lx\n",
-				dev->iobase);
+	devpriv->pci_dev = adl_pci7432_find_pci(dev, it);
+	if (!devpriv->pci_dev)
+		return -EIO;
 
-			s = dev->subdevices + 0;
-			s->type = COMEDI_SUBD_DI;
-			s->subdev_flags =
-			    SDF_READABLE | SDF_GROUND | SDF_COMMON;
-			s->n_chan = 32;
-			s->maxdata = 1;
-			s->len_chanlist = 32;
-			s->io_bits = 0x00000000;
-			s->range_table = &range_digital;
-			s->insn_bits = adl_pci7432_di_insn_bits;
+	if (comedi_pci_enable(devpriv->pci_dev, "adl_pci7432") < 0) {
+		printk(KERN_ERR "comedi%d: Failed to enable PCI device and request regions\n",
+			dev->minor);
+		return -EIO;
+	}
+	dev->iobase = pci_resource_start(devpriv->pci_dev, 2);
+	printk(KERN_INFO "comedi: base addr %4lx\n", dev->iobase);
 
-			s = dev->subdevices + 1;
-			s->type = COMEDI_SUBD_DO;
-			s->subdev_flags =
-			    SDF_WRITABLE | SDF_GROUND | SDF_COMMON;
-			s->n_chan = 32;
-			s->maxdata = 1;
-			s->len_chanlist = 32;
-			s->io_bits = 0xffffffff;
-			s->range_table = &range_digital;
-			s->insn_bits = adl_pci7432_do_insn_bits;
+	s = dev->subdevices + 0;
+	s->type = COMEDI_SUBD_DI;
+	s->subdev_flags = SDF_READABLE | SDF_GROUND | SDF_COMMON;
+	s->n_chan = 32;
+	s->maxdata = 1;
+	s->len_chanlist = 32;
+	s->io_bits = 0x00000000;
+	s->range_table = &range_digital;
+	s->insn_bits = adl_pci7432_di_insn_bits;
 
-			printk(KERN_DEBUG "comedi%d: adl_pci7432 attached\n",
-				dev->minor);
-			return 1;
-		}
-	}
+	s = dev->subdevices + 1;
+	s->type = COMEDI_SUBD_DO;
+	s->subdev_flags = SDF_WRITABLE | SDF_GROUND | SDF_COMMON;
+	s->n_chan = 32;
+	s->maxdata = 1;
+	s->len_chanlist = 32;
+	s->io_bits = 0xffffffff;
+	s->range_table = &range_digital;
+	s->insn_bits = adl_pci7432_do_insn_bits;
 
-	printk(KERN_ERR "comedi%d: no supported board found! (req. bus/slot : %d/%d)\n",
-	       dev->minor, bus, slot);
-	return -EIO;
+	printk(KERN_DEBUG "comedi%d: adl_pci7432 attached\n", dev->minor);
+	return 0;
 }
 
 static void adl_pci7432_detach(struct comedi_device *dev)
