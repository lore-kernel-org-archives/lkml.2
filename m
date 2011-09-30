Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757508Ab1I3NT0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Sep 2011 09:19:26 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:51739 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756947Ab1I3NTX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Sep 2011 09:19:23 -0400
From: Ravishankar Karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
To: gregkh@suse.de, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Ravishankar Karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
Subject: [PATCH 4/9] Staging: comedi: fix printk issue in cb_pcidas64.c
Date: Fri, 30 Sep 2011 18:48:22 +0530
Message-Id: <1317388707-1980-4-git-send-email-ravishankar.km@greenturtles.in>
X-Mailer: git-send-email 1.7.6.2
In-Reply-To: <1317388707-1980-1-git-send-email-ravishankar.km@greenturtles.in>
References: <1317388707-1980-1-git-send-email-ravishankar.km@greenturtles.in>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the cb_pcidas64.c file that fixes up a printk warning found by the checkpatch.pl tool

Signed-off-by: Ravishankar Karkala Mallikarjunayya <ravishankar.km@greenturtles.in>
---
 drivers/staging/comedi/drivers/cb_pcidas64.c |   32 ++++++++++++++-----------
 1 files changed, 18 insertions(+), 14 deletions(-)

diff --git a/drivers/staging/comedi/drivers/cb_pcidas64.c b/drivers/staging/comedi/drivers/cb_pcidas64.c
index 3dc68ef..8598fa5 100644
--- a/drivers/staging/comedi/drivers/cb_pcidas64.c
+++ b/drivers/staging/comedi/drivers/cb_pcidas64.c
@@ -1739,7 +1739,8 @@ static int attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	uint32_t local_range, local_decode;
 	int retval;
 
-	pr_info("comedi%d: cb_pcidas64\n", dev->minor);
+	dev_info(&pcidev->dev, "comedi%d: cb_pcidas64\n",
+		dev->minor);
 
 /*
  * Allocate the private structure area.
@@ -1776,17 +1777,20 @@ static int attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	}
 
 	if (dev->board_ptr == NULL) {
-		printk
-		    ("No supported ComputerBoards/MeasurementComputing card found\n");
+		dev_err(&pcidev->dev, "No supported "
+			"ComputerBoards/MeasurementComputing "
+			"card found\n");
 		return -EIO;
 	}
 
-	printk("Found %s on bus %i, slot %i\n", board(dev)->name,
-	       pcidev->bus->number, PCI_SLOT(pcidev->devfn));
+	dev_info(&pcidev->dev, "Found %s on bus %i, slot %i\n",
+		board(dev)->name,
+		pcidev->bus->number,
+		PCI_SLOT(pcidev->devfn));
 
 	if (comedi_pci_enable(pcidev, driver_cb_pcidas.driver_name)) {
-		printk(KERN_WARNING
-		       " failed to enable PCI device and request regions\n");
+		dev_warn(&pcidev->dev, "failed to enable PCI "
+			"device and request regions\n");
 		return -EIO;
 	}
 	pci_set_master(pcidev);
@@ -1814,7 +1818,6 @@ static int attach(struct comedi_device *dev, struct comedi_devconfig *it)
 
 	if (!priv(dev)->plx9080_iobase || !priv(dev)->main_iobase
 	    || !priv(dev)->dio_counter_iobase) {
-		printk(" failed to remap io memory\n");
 		return -ENOMEM;
 	}
 
@@ -1850,17 +1853,17 @@ static int attach(struct comedi_device *dev, struct comedi_devconfig *it)
 
 	priv(dev)->hw_revision =
 	    hw_revision(dev, readw(priv(dev)->main_iobase + HW_STATUS_REG));
-	printk(" stc hardware revision %i\n", priv(dev)->hw_revision);
 	init_plx9080(dev);
 	init_stc_registers(dev);
 	/*  get irq */
 	if (request_irq(pcidev->irq, handle_interrupt, IRQF_SHARED,
 			"cb_pcidas64", dev)) {
-		printk(" unable to allocate irq %u\n", pcidev->irq);
+		dev_warn(&pcidev->dev, "unable to allocate irq %u\n",
+			pcidev->irq);
 		return -EINVAL;
 	}
 	dev->irq = pcidev->irq;
-	printk(" irq %u\n", dev->irq);
+	dev_dbg(&pcidev->dev, " irq %u\n", dev->irq);
 
 	retval = setup_subdevices(dev);
 	if (retval < 0)
@@ -1882,7 +1885,7 @@ static int detach(struct comedi_device *dev)
 {
 	unsigned int i;
 
-	printk("comedi%d: cb_pcidas: remove\n", dev->minor);
+	pr_info("comedi%d: cb_pcidas: remove\n", dev->minor);
 
 	if (dev->irq)
 		free_irq(dev->irq, dev);
@@ -2093,7 +2096,8 @@ static int ai_config_calibration_source(struct comedi_device *dev,
 	else
 		num_calibration_sources = 8;
 	if (source >= num_calibration_sources) {
-		printk("invalid calibration source: %i\n", source);
+		printk(KERN_WARNING "invalid calibration source: %i\n",
+			source);
 		return -EINVAL;
 	}
 
@@ -3483,7 +3487,7 @@ static int prep_ao_dma(struct comedi_device *dev, const struct comedi_cmd *cmd)
 	num_bytes = load_ao_dma_buffer(dev, cmd);
 	if (num_bytes == 0)
 		return -1;
-	if (num_bytes >= DMA_BUFFER_SIZE) ;
+	if (num_bytes >= DMA_BUFFER_SIZE);
 	load_ao_dma(dev, cmd);
 
 	dma_start_sync(dev, 0);
-- 
1.7.6.2

