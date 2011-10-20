Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932379Ab1JTGVQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Oct 2011 02:21:16 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:65381 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932303Ab1JTGVN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Oct 2011 02:21:13 -0400
From: Ravishankar Karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
To: gregkh@suse.de, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Ravishankar Karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
Subject: [PATCH 12/24]  Staging: comedi: fix printk issue in cb_pcidio.c
Date: Thu, 20 Oct 2011 11:48:58 +0530
Message-Id: <1319091550-2558-12-git-send-email-ravishankar.km@greenturtles.in>
X-Mailer: git-send-email 1.7.6.4
In-Reply-To: <1319091550-2558-1-git-send-email-ravishankar.km@greenturtles.in>
References: <1319091550-2558-1-git-send-email-ravishankar.km@greenturtles.in>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the cb_pcidio.c file that fixes up a printk
warning found by the checkpatch.pl tool.
Added #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
Converted printks to dev_<level>.
Removed unnecessary printk statement.

Signed-off-by: Ravishankar Karkala Mallikarjunayya <ravishankar.km@greenturtles.in>
---
 drivers/staging/comedi/drivers/cb_pcidio.c |   23 ++++++++++-------------
 1 files changed, 10 insertions(+), 13 deletions(-)

diff --git a/drivers/staging/comedi/drivers/cb_pcidio.c b/drivers/staging/comedi/drivers/cb_pcidio.c
index 79477a5..ef025e0 100644
--- a/drivers/staging/comedi/drivers/cb_pcidio.c
+++ b/drivers/staging/comedi/drivers/cb_pcidio.c
@@ -39,6 +39,8 @@ Configuration Options:
 Passing a zero for an option is the same as leaving it unspecified.
 */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 /*------------------------------ HEADER FILES ---------------------------------*/
 #include "../comedidev.h"
 #include "comedi_pci.h"
@@ -184,8 +186,6 @@ static int pcidio_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	int index;
 	int i;
 
-	printk("comedi%d: cb_pcidio: \n", dev->minor);
-
 /*
  * Allocate the private structure area.  alloc_private() is a
  * convenient macro defined in comedidev.h.
@@ -223,8 +223,8 @@ static int pcidio_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 		}
 	}
 
-	printk("No supported ComputerBoards/MeasurementComputing card found on "
-	       "requested position\n");
+	dev_err(dev->hw_dev,
+		"No supported ComputerBoards/MeasurementComputing card found on requested position\n");
 	return -EIO;
 
 found:
@@ -236,12 +236,11 @@ found:
 	dev->board_name = thisboard->name;
 
 	devpriv->pci_dev = pcidev;
-	printk("Found %s on bus %i, slot %i\n", thisboard->name,
-	       devpriv->pci_dev->bus->number,
-	       PCI_SLOT(devpriv->pci_dev->devfn));
+	dev_dbg(dev->hw_dev, "Found %s on bus %i, slot %i\n", thisboard->name,
+		devpriv->pci_dev->bus->number,
+		PCI_SLOT(devpriv->pci_dev->devfn));
 	if (comedi_pci_enable(pcidev, thisboard->name)) {
-		printk
-		    ("cb_pcidio: failed to enable PCI device and request regions\n");
+		dev_err(dev->hw_dev, "failed to enable PCI device and request regions\n");
 		return -EIO;
 	}
 	devpriv->dio_reg_base
@@ -259,11 +258,10 @@ found:
 	for (i = 0; i < thisboard->n_8255; i++) {
 		subdev_8255_init(dev, dev->subdevices + i,
 				 NULL, devpriv->dio_reg_base + i * 4);
-		printk(" subdev %d: base = 0x%lx\n", i,
-		       devpriv->dio_reg_base + i * 4);
+		dev_dbg(dev->hw_dev, "subdev %d: base = 0x%lx\n", i,
+			devpriv->dio_reg_base + i * 4);
 	}
 
-	printk("attached\n");
 	return 1;
 }
 
@@ -277,7 +275,6 @@ found:
  */
 static int pcidio_detach(struct comedi_device *dev)
 {
-	printk("comedi%d: cb_pcidio: remove\n", dev->minor);
 	if (devpriv) {
 		if (devpriv->pci_dev) {
 			if (devpriv->dio_reg_base)
-- 
1.7.6.4

