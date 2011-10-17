Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753067Ab1JQMcU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 08:32:20 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:59904 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750750Ab1JQMcT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 08:32:19 -0400
From: Ravishankar Karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
To: gregkh@suse.de, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Ravishankar Karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
Subject: [PATCH 10/10] Staging: comedi: fix printk issue in cb_pcidas64.c
Date: Mon, 17 Oct 2011 18:02:05 +0530
Message-Id: <1318854725-6775-1-git-send-email-ravishankar.km@greenturtles.in>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt.
Converted printks to dev_printk.
Removed unnecessary printk statement.

Signed-off-by: Ravishankar Karkala Mallikarjunayya <ravishankar.km@greenturtles.in>
---
 drivers/staging/comedi/drivers/cb_pcidas64.c |   31 ++++++++++++-------------
 1 files changed, 15 insertions(+), 16 deletions(-)

diff --git a/drivers/staging/comedi/drivers/cb_pcidas64.c b/drivers/staging/comedi/drivers/cb_pcidas64.c
index 3dc68ef..51c48e3 100644
--- a/drivers/staging/comedi/drivers/cb_pcidas64.c
+++ b/drivers/staging/comedi/drivers/cb_pcidas64.c
@@ -83,6 +83,8 @@ TODO:
 	make ao fifo size adjustable like ai fifo
 */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include "../comedidev.h"
 #include <linux/delay.h>
 #include <linux/interrupt.h>
@@ -1739,8 +1741,6 @@ static int attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	uint32_t local_range, local_decode;
 	int retval;
 
-	pr_info("comedi%d: cb_pcidas64\n", dev->minor);
-
 /*
  * Allocate the private structure area.
  */
@@ -1776,17 +1776,15 @@ static int attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	}
 
 	if (dev->board_ptr == NULL) {
-		printk
-		    ("No supported ComputerBoards/MeasurementComputing card found\n");
+		dev_err(dev->hw_dev, "No supported ComputerBoards/MeasurementComputing card found\n");
 		return -EIO;
 	}
 
-	printk("Found %s on bus %i, slot %i\n", board(dev)->name,
-	       pcidev->bus->number, PCI_SLOT(pcidev->devfn));
+	dev_dbg(dev->hw_dev,  "Found %s on bus %i, slot %i\n", board(dev)->name,
+		pcidev->bus->number, PCI_SLOT(pcidev->devfn));
 
 	if (comedi_pci_enable(pcidev, driver_cb_pcidas.driver_name)) {
-		printk(KERN_WARNING
-		       " failed to enable PCI device and request regions\n");
+		dev_err(dev->hw_dev, "failed to enable PCI device and request regions\n");
 		return -EIO;
 	}
 	pci_set_master(pcidev);
@@ -1814,7 +1812,7 @@ static int attach(struct comedi_device *dev, struct comedi_devconfig *it)
 
 	if (!priv(dev)->plx9080_iobase || !priv(dev)->main_iobase
 	    || !priv(dev)->dio_counter_iobase) {
-		printk(" failed to remap io memory\n");
+		dev_err(dev->hw_dev, "failed to remap io memory\n");
 		return -ENOMEM;
 	}
 
@@ -1850,17 +1848,19 @@ static int attach(struct comedi_device *dev, struct comedi_devconfig *it)
 
 	priv(dev)->hw_revision =
 	    hw_revision(dev, readw(priv(dev)->main_iobase + HW_STATUS_REG));
-	printk(" stc hardware revision %i\n", priv(dev)->hw_revision);
+	dev_dbg(dev->hw_dev, "stc hardware revision %i\n",
+		priv(dev)->hw_revision);
 	init_plx9080(dev);
 	init_stc_registers(dev);
 	/*  get irq */
 	if (request_irq(pcidev->irq, handle_interrupt, IRQF_SHARED,
 			"cb_pcidas64", dev)) {
-		printk(" unable to allocate irq %u\n", pcidev->irq);
+		dev_err(dev->hw_dev, "unable to allocate irq %u\n",
+			pcidev->irq);
 		return -EINVAL;
 	}
 	dev->irq = pcidev->irq;
-	printk(" irq %u\n", dev->irq);
+	dev_dbg(dev->hw_dev, "irq %u\n", dev->irq);
 
 	retval = setup_subdevices(dev);
 	if (retval < 0)
@@ -1882,8 +1882,6 @@ static int detach(struct comedi_device *dev)
 {
 	unsigned int i;
 
-	printk("comedi%d: cb_pcidas: remove\n", dev->minor);
-
 	if (dev->irq)
 		free_irq(dev->irq, dev);
 	if (priv(dev)) {
@@ -2093,7 +2091,8 @@ static int ai_config_calibration_source(struct comedi_device *dev,
 	else
 		num_calibration_sources = 8;
 	if (source >= num_calibration_sources) {
-		printk("invalid calibration source: %i\n", source);
+		dev_err(dev->hw_dev, "invalid calibration source: %i\n",
+			source);
 		return -EINVAL;
 	}
 
@@ -2924,7 +2923,7 @@ static void pio_drain_ai_fifo_16(struct comedi_device *dev)
 		}
 
 		if (num_samples < 0) {
-			printk(" cb_pcidas64: bug! num_samples < 0\n");
+			dev_err(dev->hw_dev, "bug! num_samples < 0\n");
 			break;
 		}
 
-- 
1.7.6.4

