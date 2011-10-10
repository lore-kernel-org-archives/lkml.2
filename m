Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753306Ab1JJJ6J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 05:58:09 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:65147 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753097Ab1JJJ6H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 05:58:07 -0400
From: Ravishankar Karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
To: gregkh@suse.de, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        rmallon@gmail.com, joe@perches.com,
        Ravishankar Karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
Subject: [PATCH v2 1/3] Staging: comedi: fix printk issue in cb_pcidio.c
Date: Mon, 10 Oct 2011 15:27:06 +0530
Message-Id: <1318240626-5898-1-git-send-email-ravishankar.km@greenturtles.in>
X-Mailer: git-send-email 1.7.6.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the cb_pcidio.c file that fixes up a printk warning
found by the checkpatch.pl tool

Signed-off-by: Ravishankar Karkala Mallikarjunayya <ravishankar.km@greenturtles.in>
---
 v2: printk strings are fixed as suggested by Ryan Mallon.
 Converted printks to pr_levels> and 2 prinks are removed from the
 function. i.e. printk("comedi%d: cb_pcidio: \n", dev->minor);
 printk("comedi%d: cb_pcidio: remove\n", dev->minor);
 
 v1: Used dev_<levels> instead of printks which is not possible because
 In the function, pcidev is initialized to NULL so the Earlier patch
 was broken.
 
 drivers/staging/comedi/drivers/cb_pcidio.c |   20 ++++++++------------
 1 files changed, 8 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/comedi/drivers/cb_pcidio.c b/drivers/staging/comedi/drivers/cb_pcidio.c
index 79477a5..650978d 100644
--- a/drivers/staging/comedi/drivers/cb_pcidio.c
+++ b/drivers/staging/comedi/drivers/cb_pcidio.c
@@ -184,8 +184,6 @@ static int pcidio_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	int index;
 	int i;
 
-	printk("comedi%d: cb_pcidio: \n", dev->minor);
-
 /*
  * Allocate the private structure area.  alloc_private() is a
  * convenient macro defined in comedidev.h.
@@ -223,7 +221,7 @@ static int pcidio_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 		}
 	}
 
-	printk("No supported ComputerBoards/MeasurementComputing card found on "
+	pr_err("No supported ComputerBoards/MeasurementComputing card found on "
 	       "requested position\n");
 	return -EIO;
 
@@ -236,12 +234,11 @@ found:
 	dev->board_name = thisboard->name;
 
 	devpriv->pci_dev = pcidev;
-	printk("Found %s on bus %i, slot %i\n", thisboard->name,
-	       devpriv->pci_dev->bus->number,
-	       PCI_SLOT(devpriv->pci_dev->devfn));
+	pr_info("Found %s on bus %i, slot %i\n", thisboard->name,
+		devpriv->pci_dev->bus->number,
+		PCI_SLOT(devpriv->pci_dev->devfn));
 	if (comedi_pci_enable(pcidev, thisboard->name)) {
-		printk
-		    ("cb_pcidio: failed to enable PCI device and request regions\n");
+		pr_err("cb_pcidio: failed to enable PCI device and request regions\n");
 		return -EIO;
 	}
 	devpriv->dio_reg_base
@@ -259,11 +256,11 @@ found:
 	for (i = 0; i < thisboard->n_8255; i++) {
 		subdev_8255_init(dev, dev->subdevices + i,
 				 NULL, devpriv->dio_reg_base + i * 4);
-		printk(" subdev %d: base = 0x%lx\n", i,
-		       devpriv->dio_reg_base + i * 4);
+		pr_debug("subdev %d: base = 0x%lx\n", i,
+			 devpriv->dio_reg_base + i * 4);
 	}
 
-	printk("attached\n");
+	pr_info("attached\n");
 	return 1;
 }
 
@@ -277,7 +274,6 @@ found:
  */
 static int pcidio_detach(struct comedi_device *dev)
 {
-	printk("comedi%d: cb_pcidio: remove\n", dev->minor);
 	if (devpriv) {
 		if (devpriv->pci_dev) {
 			if (devpriv->dio_reg_base)
-- 
1.7.6.4

