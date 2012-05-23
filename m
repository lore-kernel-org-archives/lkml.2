Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753104Ab2EWXGq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 19:06:46 -0400
Received: from mail209.messagelabs.com ([216.82.255.3]:33446 "EHLO
	mail209.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751150Ab2EWXGp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 19:06:45 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-10.tower-209.messagelabs.com!1337814403!6501281!1
X-Originating-IP: [216.166.12.98]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] staging: comedi: adl_pci9111: factor out the find PCI device code
Date: Wed, 23 May 2012 16:06:39 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201205231606.39662.hartleys@visionengravers.com>
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

diff --git a/drivers/staging/comedi/drivers/adl_pci9111.c b/drivers/staging/comedi/drivers/adl_pci9111.c
index ccfb1a5..d150383 100644
--- a/drivers/staging/comedi/drivers/adl_pci9111.c
+++ b/drivers/staging/comedi/drivers/adl_pci9111.c
@@ -1210,17 +1210,47 @@ static int pci9111_reset(struct comedi_device *dev)
 	return 0;
 }
 
-/*  Attach */
-/*       - Register PCI device */
-/*       - Declare device driver capability */
+static struct pci_dev *pci9111_find_pci(struct comedi_device *dev,
+					struct comedi_devconfig *it)
+{
+	struct pci_dev *pcidev = NULL;
+	int bus = it->options[0];
+	int slot = it->options[1];
+	int i;
+
+	for_each_pci_dev(pcidev) {
+		if (pcidev->vendor != PCI_VENDOR_ID_ADLINK)
+			continue;
+		for (i = 0; i < pci9111_board_nbr; i++) {
+			if (pcidev->device != pci9111_boards[i].device_id)
+				continue;
+			if (bus || slot) {
+				/* requested particular bus/slot */
+				if (pcidev->bus->number != bus ||
+				    PCI_SLOT(pcidev->devfn) != slot)
+					continue;
+			}
+			dev->board_ptr = pci9111_boards + i;
+			printk(KERN_ERR
+				"comedi%d: found %s (b:s:f=%d:%d:%d), irq=%d\n",
+				dev->minor, pci9111_boards[i].name,
+				pcidev->bus->number, PCI_SLOT(pcidev->devfn),
+				PCI_FUNC(pcidev->devfn), pcidev->irq);
+			return pcidev;
+		}
+	}
+	printk(KERN_ERR
+		"comedi%d: no supported board found! (req. bus/slot : %d/%d)\n",
+		dev->minor, bus, slot);
+	return NULL;
+}
 
 static int pci9111_attach(struct comedi_device *dev,
 			  struct comedi_devconfig *it)
 {
 	struct comedi_subdevice *subdevice;
 	unsigned long io_base, io_range, lcr_io_base, lcr_io_range;
-	struct pci_dev *pci_device = NULL;
-	int error, i;
+	int error;
 	const struct pci9111_board *board;
 
 	if (alloc_private(dev, sizeof(struct pci9111_private_data)) < 0)
@@ -1230,65 +1260,25 @@ static int pci9111_attach(struct comedi_device *dev,
 	printk(KERN_ERR "comedi%d: " PCI9111_DRIVER_NAME " driver\n",
 								dev->minor);
 
-	for_each_pci_dev(pci_device) {
-		if (pci_device->vendor == PCI_VENDOR_ID_ADLINK) {
-			for (i = 0; i < pci9111_board_nbr; i++) {
-				if (pci9111_boards[i].device_id ==
-				    pci_device->device) {
-					/* was a particular bus/slot
-					 * requested? */
-					if ((it->options[0] != 0)
-					    || (it->options[1] != 0)) {
-						/* are we on the wrong
-						 * bus/slot? */
-						if (pci_device->bus->number !=
-						    it->options[0]
-						    ||
-						    PCI_SLOT(pci_device->devfn)
-						    != it->options[1]) {
-							continue;
-						}
-					}
-
-					dev->board_ptr = pci9111_boards + i;
-					board =
-					    (struct pci9111_board *)
-					    dev->board_ptr;
-					dev_private->pci_device = pci_device;
-					goto found;
-				}
-			}
-		}
-	}
-
-	printk(KERN_ERR
-		"comedi%d: no supported board found! (req. bus/slot : %d/%d)\n",
-			dev->minor, it->options[0], it->options[1]);
-	return -EIO;
-
-found:
-
-	printk(KERN_ERR "comedi%d: found %s (b:s:f=%d:%d:%d) , irq=%d\n",
-	       dev->minor,
-	       pci9111_boards[i].name,
-	       pci_device->bus->number,
-	       PCI_SLOT(pci_device->devfn),
-	       PCI_FUNC(pci_device->devfn), pci_device->irq);
+	dev_private->pci_device = pci9111_find_pci(dev, it);
+	if (!dev_private->pci_device)
+		return -EIO;
+	board = (struct pci9111_board *)dev->board_ptr;
 
 	/*  TODO: Warn about non-tested boards. */
 
 	/*  Read local configuration register base address
 	 *  [PCI_BASE_ADDRESS #1]. */
 
-	lcr_io_base = pci_resource_start(pci_device, 1);
-	lcr_io_range = pci_resource_len(pci_device, 1);
+	lcr_io_base = pci_resource_start(dev_private->pci_device, 1);
+	lcr_io_range = pci_resource_len(dev_private->pci_device, 1);
 
 	printk
 	    ("comedi%d: local configuration registers at address 0x%4lx [0x%4lx]\n",
 	     dev->minor, lcr_io_base, lcr_io_range);
 
 	/*  Enable PCI device and request regions */
-	if (comedi_pci_enable(pci_device, PCI9111_DRIVER_NAME) < 0) {
+	if (comedi_pci_enable(dev_private->pci_device, PCI9111_DRIVER_NAME) < 0) {
 		printk
 		    ("comedi%d: Failed to enable PCI device and request regions\n",
 		     dev->minor);
@@ -1296,8 +1286,8 @@ found:
 	}
 	/*  Read PCI6308 register base address [PCI_BASE_ADDRESS #2]. */
 
-	io_base = pci_resource_start(pci_device, 2);
-	io_range = pci_resource_len(pci_device, 2);
+	io_base = pci_resource_start(dev_private->pci_device, 2);
+	io_range = pci_resource_len(dev_private->pci_device, 2);
 
 	printk(KERN_ERR "comedi%d: 6503 registers at address 0x%4lx [0x%4lx]\n",
 	       dev->minor, io_base, io_range);
@@ -1314,16 +1304,17 @@ found:
 	/*  Irq setup */
 
 	dev->irq = 0;
-	if (pci_device->irq > 0) {
-		if (request_irq(pci_device->irq, pci9111_interrupt,
+	if (dev_private->pci_device->irq > 0) {
+		dev->irq = dev_private->pci_device->irq;
+
+		if (request_irq(dev->irq, pci9111_interrupt,
 				IRQF_SHARED, PCI9111_DRIVER_NAME, dev) != 0) {
 			printk(KERN_ERR
 				"comedi%d: unable to allocate irq  %u\n",
-					dev->minor, pci_device->irq);
+					dev->minor, dev->irq);
 			return -EINVAL;
 		}
 	}
-	dev->irq = pci_device->irq;
 
 	/*  TODO: Add external multiplexer setup (according to option[2]). */
 
