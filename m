Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753294Ab2EWWoW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 18:44:22 -0400
Received: from mail131.messagelabs.com ([216.82.242.99]:48045 "EHLO
	mail131.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751808Ab2EWWoV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 18:44:21 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-10.tower-131.messagelabs.com!1337813044!23541212!33
X-Originating-IP: [216.166.12.32]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: PATCH] staging: comedi: adl_pci8164: factor out the PCI device code
Date: Wed, 23 May 2012 15:44:10 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201205231544.10789.hartleys@visionengravers.com>
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

diff --git a/drivers/staging/comedi/drivers/adl_pci8164.c b/drivers/staging/comedi/drivers/adl_pci8164.c
index 409ef13..36c8ccb 100644
--- a/drivers/staging/comedi/drivers/adl_pci8164.c
+++ b/drivers/staging/comedi/drivers/adl_pci8164.c
@@ -224,19 +224,40 @@ static int adl_pci8164_insn_write_buf1(struct comedi_device *dev,
 	return 2;
 }
 
+static struct pci_dev *adl_pci8164_find_pci(struct comedi_device *dev,
+					    struct comedi_devconfig *it)
+{
+	struct pci_dev *pcidev = NULL;
+	int bus = it->options[0];
+	int slot = it->options[1];
+
+	for_each_pci_dev(pcidev) {
+		if (pcidev->vendor != PCI_VENDOR_ID_ADLINK ||
+		    pcidev->device != PCI_DEVICE_ID_PCI8164)
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
+		dev->minor, bus, slot);
+	return NULL;
+}
+
 static int adl_pci8164_attach(struct comedi_device *dev,
 			      struct comedi_devconfig *it)
 {
-	struct pci_dev *pcidev = NULL;
 	struct comedi_subdevice *s;
-	int bus, slot;
 
 	printk(KERN_INFO "comedi: attempt to attach...\n");
 	printk(KERN_INFO "comedi%d: adl_pci8164\n", dev->minor);
 
 	dev->board_name = "pci8164";
-	bus = it->options[0];
-	slot = it->options[1];
 
 	if (alloc_private(dev, sizeof(struct adl_pci8164_private)) < 0)
 		return -ENOMEM;
@@ -244,74 +265,60 @@ static int adl_pci8164_attach(struct comedi_device *dev,
 	if (alloc_subdevices(dev, 4) < 0)
 		return -ENOMEM;
 
-	for_each_pci_dev(pcidev) {
-		if (pcidev->vendor == PCI_VENDOR_ID_ADLINK &&
-		    pcidev->device == PCI_DEVICE_ID_PCI8164) {
-			if (bus || slot) {
-				/* requested particular bus/slot */
-				if (pcidev->bus->number != bus
-					|| PCI_SLOT(pcidev->devfn) != slot)
-					continue;
-			}
-			devpriv->pci_dev = pcidev;
-			if (comedi_pci_enable(pcidev, "adl_pci8164") < 0) {
-				printk(KERN_ERR "comedi%d: Failed to enable "
-				"PCI device and request regions\n", dev->minor);
-				return -EIO;
-			}
-			dev->iobase = pci_resource_start(pcidev, 2);
-			printk(KERN_DEBUG "comedi: base addr %4lx\n",
-				   dev->iobase);
-
-			s = dev->subdevices + 0;
-			s->type = COMEDI_SUBD_PROC;
-			s->subdev_flags = SDF_READABLE | SDF_WRITABLE;
-			s->n_chan = 4;
-			s->maxdata = 0xffff;
-			s->len_chanlist = 4;
-			/* s->range_table = &range_axis; */
-			s->insn_read = adl_pci8164_insn_read_msts;
-			s->insn_write = adl_pci8164_insn_write_cmd;
+	devpriv->pci_dev = adl_pci8164_find_pci(dev, it);
+	if (!devpriv->pci_dev)
+		return -EIO;
 
-			s = dev->subdevices + 1;
-			s->type = COMEDI_SUBD_PROC;
-			s->subdev_flags = SDF_READABLE | SDF_WRITABLE;
-			s->n_chan = 4;
-			s->maxdata = 0xffff;
-			s->len_chanlist = 4;
-			/* s->range_table = &range_axis; */
-			s->insn_read = adl_pci8164_insn_read_ssts;
-			s->insn_write = adl_pci8164_insn_write_otp;
+	if (comedi_pci_enable(devpriv->pci_dev, "adl_pci8164") < 0) {
+		printk(KERN_ERR "comedi%d: Failed to enable "
+		"PCI device and request regions\n", dev->minor);
+		return -EIO;
+	}
+	dev->iobase = pci_resource_start(devpriv->pci_dev, 2);
+	printk(KERN_DEBUG "comedi: base addr %4lx\n", dev->iobase);
 
-			s = dev->subdevices + 2;
-			s->type = COMEDI_SUBD_PROC;
-			s->subdev_flags = SDF_READABLE | SDF_WRITABLE;
-			s->n_chan = 4;
-			s->maxdata = 0xffff;
-			s->len_chanlist = 4;
-			/* s->range_table = &range_axis; */
-			s->insn_read = adl_pci8164_insn_read_buf0;
-			s->insn_write = adl_pci8164_insn_write_buf0;
+	s = dev->subdevices + 0;
+	s->type = COMEDI_SUBD_PROC;
+	s->subdev_flags = SDF_READABLE | SDF_WRITABLE;
+	s->n_chan = 4;
+	s->maxdata = 0xffff;
+	s->len_chanlist = 4;
+	/* s->range_table = &range_axis; */
+	s->insn_read = adl_pci8164_insn_read_msts;
+	s->insn_write = adl_pci8164_insn_write_cmd;
 
-			s = dev->subdevices + 3;
-			s->type = COMEDI_SUBD_PROC;
-			s->subdev_flags = SDF_READABLE | SDF_WRITABLE;
-			s->n_chan = 4;
-			s->maxdata = 0xffff;
-			s->len_chanlist = 4;
-			/* s->range_table = &range_axis; */
-			s->insn_read = adl_pci8164_insn_read_buf1;
-			s->insn_write = adl_pci8164_insn_write_buf1;
+	s = dev->subdevices + 1;
+	s->type = COMEDI_SUBD_PROC;
+	s->subdev_flags = SDF_READABLE | SDF_WRITABLE;
+	s->n_chan = 4;
+	s->maxdata = 0xffff;
+	s->len_chanlist = 4;
+	/* s->range_table = &range_axis; */
+	s->insn_read = adl_pci8164_insn_read_ssts;
+	s->insn_write = adl_pci8164_insn_write_otp;
 
-			printk(KERN_INFO "comedi: attached\n");
+	s = dev->subdevices + 2;
+	s->type = COMEDI_SUBD_PROC;
+	s->subdev_flags = SDF_READABLE | SDF_WRITABLE;
+	s->n_chan = 4;
+	s->maxdata = 0xffff;
+	s->len_chanlist = 4;
+	/* s->range_table = &range_axis; */
+	s->insn_read = adl_pci8164_insn_read_buf0;
+	s->insn_write = adl_pci8164_insn_write_buf0;
 
-			return 1;
-		}
-	}
+	s = dev->subdevices + 3;
+	s->type = COMEDI_SUBD_PROC;
+	s->subdev_flags = SDF_READABLE | SDF_WRITABLE;
+	s->n_chan = 4;
+	s->maxdata = 0xffff;
+	s->len_chanlist = 4;
+	/* s->range_table = &range_axis; */
+	s->insn_read = adl_pci8164_insn_read_buf1;
+	s->insn_write = adl_pci8164_insn_write_buf1;
 
-	printk(KERN_ERR "comedi%d: no supported board found!"
-		   "(req. bus/slot : %d/%d)\n", dev->minor, bus, slot);
-	return -EIO;
+	printk(KERN_INFO "comedi: attached\n");
+	return 0;
 }
 
 static void adl_pci8164_detach(struct comedi_device *dev)
