Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752749Ab2EWXfH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 19:35:07 -0400
Received: from mail209.messagelabs.com ([216.82.255.3]:2053 "EHLO
	mail209.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751145Ab2EWXfF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 19:35:05 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-15.tower-209.messagelabs.com!1337816104!6494271!1
X-Originating-IP: [216.166.12.98]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] staging: comedi: adl_pci9118: factor out the find PCI device code
Date: Wed, 23 May 2012 16:34:58 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201205231634.58599.hartleys@visionengravers.com>
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

diff --git a/drivers/staging/comedi/drivers/adl_pci9118.c b/drivers/staging/comedi/drivers/adl_pci9118.c
index 7864586..8029687 100644
--- a/drivers/staging/comedi/drivers/adl_pci9118.c
+++ b/drivers/staging/comedi/drivers/adl_pci9118.c
@@ -2111,6 +2111,44 @@ static int pci9118_reset(struct comedi_device *dev)
 	return 0;
 }
 
+static struct pci_dev *pci9118_find_pci(struct comedi_device *dev,
+					struct comedi_devconfig *it)
+{
+	struct pci_dev *pcidev = NULL;
+	int bus = it->options[0];
+	int slot = it->options[1];
+
+	for_each_pci_dev(pcidev) {
+		if (pcidev->vendor != PCI_VENDOR_ID_AMCC)
+			continue;
+		if (pcidev->device != this_board->device_id)
+			continue;
+		if (bus || slot) {
+			/* requested particular bus/slot */
+			if (pcidev->bus->number != bus ||
+			    PCI_SLOT(pcidev->devfn) != slot)
+				continue;
+		}
+		/*
+		 * Look for device that isn't in use.
+		 * Enable PCI device and request regions.
+		 */
+		if (comedi_pci_enable(pcidev, "adl_pci9118"))
+			continue;
+		printk(KERN_ERR ", b:s:f=%d:%d:%d, io=0x%4lx, 0x%4lx",
+			pcidev->bus->number,
+			PCI_SLOT(pcidev->devfn),
+			PCI_FUNC(pcidev->devfn),
+			(unsigned long)pci_resource_start(pcidev, 2),
+			(unsigned long)pci_resource_start(pcidev, 0));
+		return pcidev;
+	}
+	printk(KERN_ERR
+		"comedi%d: no supported board found! (req. bus/slot : %d/%d)\n",
+		dev->minor, bus, slot);
+	return NULL;
+}
+
 static int pci9118_attach(struct comedi_device *dev,
 			  struct comedi_devconfig *it)
 {
@@ -2118,17 +2156,10 @@ static int pci9118_attach(struct comedi_device *dev,
 	int ret, pages, i;
 	unsigned short master;
 	unsigned int irq;
-	unsigned long iobase_a, iobase_9;
-	struct pci_dev *pcidev;
-	int opt_bus, opt_slot;
-	const char *errstr;
-	unsigned char pci_bus, pci_slot, pci_func;
 	u16 u16w;
 
 	printk("comedi%d: adl_pci9118: board=%s", dev->minor, this_board->name);
 
-	opt_bus = it->options[0];
-	opt_slot = it->options[1];
 	if (it->options[3] & 1)
 		master = 0;	/* user don't want use bus master */
 	else
@@ -2140,61 +2171,19 @@ static int pci9118_attach(struct comedi_device *dev,
 		return -ENOMEM;
 	}
 
-	/* Look for matching PCI device */
-	errstr = "not found!";
-	pcidev = NULL;
-	while (NULL != (pcidev = pci_get_device(PCI_VENDOR_ID_AMCC,
-						this_board->device_id,
-						pcidev))) {
-		/* Found matching vendor/device. */
-		if (opt_bus || opt_slot) {
-			/* Check bus/slot. */
-			if (opt_bus != pcidev->bus->number
-			    || opt_slot != PCI_SLOT(pcidev->devfn))
-				continue;	/* no match */
-		}
-		/*
-		 * Look for device that isn't in use.
-		 * Enable PCI device and request regions.
-		 */
-		if (comedi_pci_enable(pcidev, "adl_pci9118")) {
-			errstr =
-			    "failed to enable PCI device and request regions!";
-			continue;
-		}
-		break;
-	}
-
-	if (!pcidev) {
-		if (opt_bus || opt_slot) {
-			printk(KERN_ERR " - Card at b:s %d:%d %s\n",
-			       opt_bus, opt_slot, errstr);
-		} else {
-			printk(KERN_ERR " - Card %s\n", errstr);
-		}
+	devpriv->pcidev = pci9118_find_pci(dev, it);
+	if (!devpriv->pcidev)
 		return -EIO;
-	}
 
 	if (master)
-		pci_set_master(pcidev);
+		pci_set_master(devpriv->pcidev);
 
+	irq = devpriv->pcidev->irq;
+	devpriv->iobase_a = pci_resource_start(devpriv->pcidev, 0);
+	dev->iobase = pci_resource_start(devpriv->pcidev, 2);
 
-	pci_bus = pcidev->bus->number;
-	pci_slot = PCI_SLOT(pcidev->devfn);
-	pci_func = PCI_FUNC(pcidev->devfn);
-	irq = pcidev->irq;
-	iobase_a = pci_resource_start(pcidev, 0);
-	iobase_9 = pci_resource_start(pcidev, 2);
-
-	printk(KERN_ERR ", b:s:f=%d:%d:%d, io=0x%4lx, 0x%4lx", pci_bus,
-				pci_slot, pci_func, iobase_9, iobase_a);
-
-	dev->iobase = iobase_9;
 	dev->board_name = this_board->name;
 
-	devpriv->pcidev = pcidev;
-	devpriv->iobase_a = iobase_a;
-
 	pci9118_reset(dev);
 
 	if (it->options[3] & 2)
