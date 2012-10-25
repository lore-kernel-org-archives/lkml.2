Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759215Ab2JYCXW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 22:23:22 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:60624 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759113Ab2JYCXU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 22:23:20 -0400
From: YAMANE Toshiaki <yamanetoshi@gmail.com>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: Ian Abbott <abbotti@mev.co.uk>,
        Frank Mori Hess <fmhess@users.sourceforge.net>,
        linux-kernel@vger.kernel.org, YAMANE Toshiaki <yamanetoshi@gmail.com>
Subject: [PATCH v2] staging/comedi: Use pr_ or dev_ printks in drivers/gsc_hdpi.c
Date: Thu, 25 Oct 2012 11:23:13 +0900
Message-Id: <1351131793-6611-1-git-send-email-yamanetoshi@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <20121022195250.GD8567@kroah.com>
References: <20121022195250.GD8567@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fixed below checkpatch warning.
- WARNING: Prefer netdev_warn(netdev, ... then dev_warn(dev, ... then pr_warn(...  to printk(KERN_WARNING ...

some of them have been replaced by dev_dbg or pr_debug,
and added pr_fmt.

Signed-off-by: YAMANE Toshiaki <yamanetoshi@gmail.com>
---
 drivers/staging/comedi/drivers/gsc_hpdi.c |   31 +++++++++++++++--------------
 1 file changed, 16 insertions(+), 15 deletions(-)

diff --git a/drivers/staging/comedi/drivers/gsc_hpdi.c b/drivers/staging/comedi/drivers/gsc_hpdi.c
index abff660..31d89d5 100644
--- a/drivers/staging/comedi/drivers/gsc_hpdi.c
+++ b/drivers/staging/comedi/drivers/gsc_hpdi.c
@@ -45,6 +45,8 @@ support could be added to this driver.
 
 */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/interrupt.h>
 #include "../comedidev.h"
 #include <linux/delay.h>
@@ -107,8 +109,7 @@ enum hpdi_registers {
 int command_channel_valid(unsigned int channel)
 {
 	if (channel == 0 || channel > 6) {
-		printk(KERN_WARNING
-		       "gsc_hpdi: bug! invalid cable command channel\n");
+		pr_debug("bug! invalid cable command channel\n");
 		return 0;
 	}
 	return 1;
@@ -553,7 +554,7 @@ static int hpdi_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	int i;
 	int retval;
 
-	printk(KERN_WARNING "comedi%d: gsc_hpdi\n", dev->minor);
+	dev_dbg(dev->class_dev, "gsc_hpdi\n");
 
 	if (alloc_private(dev, sizeof(struct hpdi_private)) < 0)
 		return -ENOMEM;
@@ -582,17 +583,17 @@ static int hpdi_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 		} while (pcidev != NULL);
 	}
 	if (dev->board_ptr == NULL) {
-		printk(KERN_WARNING "gsc_hpdi: no hpdi card found\n");
+		dev_warn(dev->class_dev, "no hpdi card found\n");
 		return -EIO;
 	}
 
-	printk(KERN_WARNING
-	       "gsc_hpdi: found %s on bus %i, slot %i\n", board(dev)->name,
-	       pcidev->bus->number, PCI_SLOT(pcidev->devfn));
+	dev_dbg(dev->class_dev,
+		"found %s on bus %i, slot %i\n", board(dev)->name,
+		pcidev->bus->number, PCI_SLOT(pcidev->devfn));
 
 	if (comedi_pci_enable(pcidev, dev->driver->driver_name)) {
-		printk(KERN_WARNING
-		       " failed enable PCI device and request regions\n");
+		dev_warn(dev->class_dev,
+			 " failed enable PCI device and request regions\n");
 		return -EIO;
 	}
 	pci_set_master(pcidev);
@@ -613,7 +614,7 @@ static int hpdi_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	    ioremap(priv(dev)->hpdi_phys_iobase,
 		    pci_resource_len(pcidev, HPDI_BADDRINDEX));
 	if (!priv(dev)->plx9080_iobase || !priv(dev)->hpdi_iobase) {
-		printk(KERN_WARNING " failed to remap io memory\n");
+		dev_warn(dev->class_dev, "failed to remap io memory\n");
 		return -ENOMEM;
 	}
 
@@ -625,13 +626,13 @@ static int hpdi_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	/*  get irq */
 	if (request_irq(pcidev->irq, handle_interrupt, IRQF_SHARED,
 			dev->driver->driver_name, dev)) {
-		printk(KERN_WARNING
-		       " unable to allocate irq %u\n", pcidev->irq);
+		dev_warn(dev->class_dev,
+			 "unable to allocate irq %u\n", pcidev->irq);
 		return -EINVAL;
 	}
 	dev->irq = pcidev->irq;
 
-	printk(KERN_WARNING " irq %u\n", dev->irq);
+	dev_dbg(dev->class_dev, "irq %u\n", dev->irq);
 
 	/*  allocate pci dma buffers */
 	for (i = 0; i < NUM_DMA_BUFFERS; i++) {
@@ -649,8 +650,8 @@ static int hpdi_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 						   &priv(dev)->
 						   dma_desc_phys_addr);
 	if (priv(dev)->dma_desc_phys_addr & 0xf) {
-		printk(KERN_WARNING
-		       " dma descriptors not quad-word aligned (bug)\n");
+		dev_warn(dev->class_dev,
+			 "dma descriptors not quad-word aligned (bug)\n");
 		return -EIO;
 	}
 
-- 
1.7.9.5

