Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755624Ab2ADMl1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 07:41:27 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:47296 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755517Ab2ADMlX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 07:41:23 -0500
From: Ravishankar karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
To: gregkh@suse.de, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        dan.carpenter@oracle.com, rmallon@gmail.com, joe@perches.com,
        valdis.kletnieks@vt.edu,
        Ravishankar karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
Subject: [PATCH 09/11] Staging: comedi: fix printk warning issue in amplc_pci230.c
Date: Wed,  4 Jan 2012 18:10:04 +0530
Message-Id: <1325680806-10917-9-git-send-email-ravishankar.km@greenturtles.in>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1325680806-10917-1-git-send-email-ravishankar.km@greenturtles.in>
References: <1325680806-10917-1-git-send-email-ravishankar.km@greenturtles.in>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes a printk warning found by the checkpatch.pl tool.
Convert printk messages to dev_<levels> and removes useless
printk messages.

Signed-off-by: Ravishankar Karkala Mallikarjunayya <ravishankar.km@greenturtles.in>
---
 drivers/staging/comedi/drivers/amplc_pci230.c |   38 +++++++-----------------
 1 files changed, 11 insertions(+), 27 deletions(-)

diff --git a/drivers/staging/comedi/drivers/amplc_pci230.c b/drivers/staging/comedi/drivers/amplc_pci230.c
index 5389795..8ace288 100644
--- a/drivers/staging/comedi/drivers/amplc_pci230.c
+++ b/drivers/staging/comedi/drivers/amplc_pci230.c
@@ -764,8 +764,9 @@ static int pci230_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	struct pci_dev *pci_dev = NULL;
 	int i = 0, irq_hdl, rc;
 
-	printk("comedi%d: amplc_pci230: attach %s %d,%d\n", dev->minor,
-	       thisboard->name, it->options[0], it->options[1]);
+	dev_info(dev->hw_dev, "comedi%d: amplc_pci230: attach %s %d,%d\n",
+		 dev->minor, thisboard->name, it->options[0],
+		 it->options[1]);
 
 	/* Allocate the private structure area using alloc_private().
 	 * Macro defined in comedidev.h - memsets struct fields to 0. */
@@ -838,11 +839,8 @@ static int pci230_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 			}
 		}
 	}
-	if (!pci_dev) {
-		printk("comedi%d: No %s card found\n", dev->minor,
-		       thisboard->name);
+	if (!pci_dev)
 		return -EIO;
-	}
 	devpriv->pci_dev = pci_dev;
 
 	/*
@@ -851,20 +849,14 @@ static int pci230_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	dev->board_name = thisboard->name;
 
 	/* Enable PCI device and reserve I/O spaces. */
-	if (comedi_pci_enable(pci_dev, "amplc_pci230") < 0) {
-		printk("comedi%d: failed to enable PCI device "
-		       "and request regions\n", dev->minor);
+	if (comedi_pci_enable(pci_dev, "amplc_pci230") < 0)
 		return -EIO;
-	}
 
 	/* Read base addresses of the PCI230's two I/O regions from PCI
 	 * configuration register. */
 	iobase1 = pci_resource_start(pci_dev, 2);
 	iobase2 = pci_resource_start(pci_dev, 3);
 
-	printk("comedi%d: %s I/O region 1 0x%04lx I/O region 2 0x%04lx\n",
-	       dev->minor, dev->board_name, iobase1, iobase2);
-
 	devpriv->iobase1 = iobase1;
 	dev->iobase = iobase2;
 
@@ -877,13 +869,8 @@ static int pci230_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 		unsigned short extfunc = 0;
 
 		devpriv->hwver = inw(dev->iobase + PCI230P_HWVER);
-		if (devpriv->hwver < thisboard->min_hwver) {
-			printk("comedi%d: %s - bad hardware version "
-			       "- got %u, need %u\n", dev->minor,
-			       dev->board_name, devpriv->hwver,
-			       thisboard->min_hwver);
+		if (devpriv->hwver < thisboard->min_hwver)
 			return -EIO;
-		}
 		if (devpriv->hwver > 0) {
 			if (!thisboard->have_dio) {
 				/* No DIO ports.  Route counters' external gates
@@ -929,13 +916,12 @@ static int pci230_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	irq_hdl = request_irq(devpriv->pci_dev->irq, pci230_interrupt,
 			      IRQF_SHARED, "amplc_pci230", dev);
 	if (irq_hdl < 0) {
-		printk("comedi%d: unable to register irq, "
-		       "commands will not be available %d\n", dev->minor,
-		       devpriv->pci_dev->irq);
+		dev_dbg(dev->hw_dev, "comedi%d: unable to register irq, commands will not be available %d\n",
+			dev->minor, devpriv->pci_dev->irq);
 	} else {
 		dev->irq = devpriv->pci_dev->irq;
-		printk("comedi%d: registered irq %u\n", dev->minor,
-		       devpriv->pci_dev->irq);
+		dev_dbg(dev->hw_dev, "comedi%d: registered irq %u\n",
+			dev->minor, devpriv->pci_dev->irq);
 	}
 
 	/*
@@ -998,8 +984,6 @@ static int pci230_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 		s->type = COMEDI_SUBD_UNUSED;
 	}
 
-	printk("comedi%d: attached\n", dev->minor);
-
 	return 1;
 }
 
@@ -1013,7 +997,7 @@ static int pci230_attach(struct comedi_device *dev, struct comedi_devconfig *it)
  */
 static int pci230_detach(struct comedi_device *dev)
 {
-	printk("comedi%d: amplc_pci230: remove\n", dev->minor);
+	dev_info(dev->hw_dev, "comedi%d: amplc_pci230: remove\n", dev->minor);
 
 	if (dev->subdevices && thisboard->have_dio)
 		/* Clean up dio subdevice. */
-- 
1.7.0.4

