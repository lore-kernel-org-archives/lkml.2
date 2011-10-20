Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932450Ab1JTGVj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Oct 2011 02:21:39 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:65381 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932243Ab1JTGVg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Oct 2011 02:21:36 -0400
From: Ravishankar Karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
To: gregkh@suse.de, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Ravishankar Karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
Subject: [PATCH 16/24] Staging: comedi: fix printk issue in amplc_pci230.c
Date: Thu, 20 Oct 2011 11:49:02 +0530
Message-Id: <1319091550-2558-16-git-send-email-ravishankar.km@greenturtles.in>
X-Mailer: git-send-email 1.7.6.4
In-Reply-To: <1319091550-2558-1-git-send-email-ravishankar.km@greenturtles.in>
References: <1319091550-2558-1-git-send-email-ravishankar.km@greenturtles.in>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the amplc_pci230.c file that fixes up a printk
warning found by the checkpatch.pl tool
Converted printks to dev_printk.
Removed unnecessary printk statement.

Signed-off-by: Ravishankar Karkala Mallikarjunayya <ravishankar.km@greenturtles.in>
---
 drivers/staging/comedi/drivers/amplc_pci230.c |   34 +++++++++----------------
 1 files changed, 12 insertions(+), 22 deletions(-)

diff --git a/drivers/staging/comedi/drivers/amplc_pci230.c b/drivers/staging/comedi/drivers/amplc_pci230.c
index 7edeb11..a21653e 100644
--- a/drivers/staging/comedi/drivers/amplc_pci230.c
+++ b/drivers/staging/comedi/drivers/amplc_pci230.c
@@ -767,9 +767,6 @@ static int pci230_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	struct pci_dev *pci_dev = NULL;
 	int i = 0, irq_hdl, rc;
 
-	printk("comedi%d: amplc_pci230: attach %s %d,%d\n", dev->minor,
-	       thisboard->name, it->options[0], it->options[1]);
-
 	/* Allocate the private structure area using alloc_private().
 	 * Macro defined in comedidev.h - memsets struct fields to 0. */
 	if ((alloc_private(dev, sizeof(struct pci230_private))) < 0)
@@ -842,8 +839,8 @@ static int pci230_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 		}
 	}
 	if (!pci_dev) {
-		printk("comedi%d: No %s card found\n", dev->minor,
-		       thisboard->name);
+		dev_err(dev->hw_dev, "comedi%d: No %s card found\n", dev->minor,
+			thisboard->name);
 		return -EIO;
 	}
 	devpriv->pci_dev = pci_dev;
@@ -855,8 +852,8 @@ static int pci230_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 
 	/* Enable PCI device and reserve I/O spaces. */
 	if (comedi_pci_enable(pci_dev, "amplc_pci230") < 0) {
-		printk("comedi%d: failed to enable PCI device "
-		       "and request regions\n", dev->minor);
+		dev_err(dev->hw_dev, "comedi%d: failed to enable PCI device and request regions\n",
+			dev->minor);
 		return -EIO;
 	}
 
@@ -865,8 +862,6 @@ static int pci230_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	iobase1 = pci_resource_start(pci_dev, 2);
 	iobase2 = pci_resource_start(pci_dev, 3);
 
-	printk("comedi%d: %s I/O region 1 0x%04lx I/O region 2 0x%04lx\n",
-	       dev->minor, dev->board_name, iobase1, iobase2);
 
 	devpriv->iobase1 = iobase1;
 	dev->iobase = iobase2;
@@ -881,10 +876,9 @@ static int pci230_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 
 		devpriv->hwver = inw(dev->iobase + PCI230P_HWVER);
 		if (devpriv->hwver < thisboard->min_hwver) {
-			printk("comedi%d: %s - bad hardware version "
-			       "- got %u, need %u\n", dev->minor,
-			       dev->board_name, devpriv->hwver,
-			       thisboard->min_hwver);
+			dev_err(dev->hw_dev, "comedi%d: %s - bad hardware version - got %u, need %u\n",
+				dev->minor, dev->board_name,
+				devpriv->hwver, thisboard->min_hwver);
 			return -EIO;
 		}
 		if (devpriv->hwver > 0) {
@@ -932,13 +926,12 @@ static int pci230_attach(struct comedi_device *dev, struct comedi_devconfig *it)
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
@@ -1001,8 +994,6 @@ static int pci230_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 		s->type = COMEDI_SUBD_UNUSED;
 	}
 
-	printk("comedi%d: attached\n", dev->minor);
-
 	return 1;
 }
 
@@ -1016,7 +1007,6 @@ static int pci230_attach(struct comedi_device *dev, struct comedi_devconfig *it)
  */
 static int pci230_detach(struct comedi_device *dev)
 {
-	printk("comedi%d: amplc_pci230: remove\n", dev->minor);
 
 	if (dev->subdevices && thisboard->have_dio)
 		/* Clean up dio subdevice. */
@@ -1205,7 +1195,7 @@ static int pci230_ai_rinsn(struct comedi_device *dev,
 		if (i == TIMEOUT) {
 			/* printk() should be used instead of printk()
 			 * whenever the code can be called from real-time. */
-			printk("timeout\n");
+			dev_err(dev->hw_dev, "timeout\n");
 			return -ETIMEDOUT;
 		}
 
-- 
1.7.6.4

