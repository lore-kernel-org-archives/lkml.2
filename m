Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757123Ab1I3NTV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Sep 2011 09:19:21 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:46656 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756397Ab1I3NTT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Sep 2011 09:19:19 -0400
From: Ravishankar Karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
To: gregkh@suse.de, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Ravishankar Karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
Subject: [PATCH 3/9] Staging: comedi: fix printk issue in cb_pcidas.c
Date: Fri, 30 Sep 2011 18:48:21 +0530
Message-Id: <1317388707-1980-3-git-send-email-ravishankar.km@greenturtles.in>
X-Mailer: git-send-email 1.7.6.2
In-Reply-To: <1317388707-1980-1-git-send-email-ravishankar.km@greenturtles.in>
References: <1317388707-1980-1-git-send-email-ravishankar.km@greenturtles.in>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the cb_pcidas.c file that fixes up a printk warning found by the checkpatch.pl tool

Signed-off-by: Ravishankar Karkala Mallikarjunayya <ravishankar.km@greenturtles.in>
---
 drivers/staging/comedi/drivers/cb_pcidas.c |   21 +++++++++++++--------
 1 files changed, 13 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/comedi/drivers/cb_pcidas.c b/drivers/staging/comedi/drivers/cb_pcidas.c
index 9dec153..9d16c6c 100644
--- a/drivers/staging/comedi/drivers/cb_pcidas.c
+++ b/drivers/staging/comedi/drivers/cb_pcidas.c
@@ -565,7 +565,8 @@ static int cb_pcidas_attach(struct comedi_device *dev,
 	int index;
 	int i;
 
-	pr_info("comedi%d: cb_pcidas: ", dev->minor);
+	dev_info(&pcidev->dev, "comedi%d: cb_pcidas:\n",
+		dev->minor);
 
 /*
  * Allocate the private structure area.
@@ -576,7 +577,6 @@ static int cb_pcidas_attach(struct comedi_device *dev,
 /*
  * Probe the device to determine what device in the series it is.
  */
-	printk("\n");
 
 	for_each_pci_dev(pcidev) {
 		/*  is it not a computer boards card? */
@@ -600,20 +600,24 @@ static int cb_pcidas_attach(struct comedi_device *dev,
 		}
 	}
 
-	printk("No supported ComputerBoards/MeasurementComputing card found on "
-	       "requested position\n");
+	dev_err(&pcidev->dev, "No supported "
+		"ComputerBoards/MeasurementComputing "
+		"card found on requested position\n");
 	return -EIO;
 
 found:
 
-	printk("Found %s on bus %i, slot %i\n", cb_pcidas_boards[index].name,
-	       pcidev->bus->number, PCI_SLOT(pcidev->devfn));
+	dev_info(&pcidev->dev, "Found %s on bus %i, slot %i\n",
+		cb_pcidas_boards[index].name,
+		pcidev->bus->number,
+		PCI_SLOT(pcidev->devfn));
 
 	/*
 	 * Enable PCI device and reserve I/O ports.
 	 */
 	if (comedi_pci_enable(pcidev, "cb_pcidas")) {
-		printk(" Failed to enable PCI device and request regions\n");
+		dev_err(&pcidev->dev, " Failed to enable PCI "
+			"device and request regions\n");
 		return -EIO;
 	}
 	/*
@@ -639,7 +643,8 @@ found:
 	/*  get irq */
 	if (request_irq(devpriv->pci_dev->irq, cb_pcidas_interrupt,
 			IRQF_SHARED, "cb_pcidas", dev)) {
-		printk(" unable to allocate irq %d\n", devpriv->pci_dev->irq);
+		dev_warn(&pcidev->dev, " unable to allocate irq %d\n",
+			devpriv->pci_dev->irq);
 		return -EINVAL;
 	}
 	dev->irq = devpriv->pci_dev->irq;
-- 
1.7.6.2

