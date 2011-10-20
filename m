Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932507Ab1JTGWJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Oct 2011 02:22:09 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:65381 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932477Ab1JTGWG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Oct 2011 02:22:06 -0400
From: Ravishankar Karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
To: gregkh@suse.de, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Ravishankar Karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
Subject: [PATCH 20/24] Staging: comedi: fix printk issue in cb_pcidas.c
Date: Thu, 20 Oct 2011 11:49:06 +0530
Message-Id: <1319091550-2558-20-git-send-email-ravishankar.km@greenturtles.in>
X-Mailer: git-send-email 1.7.6.4
In-Reply-To: <1319091550-2558-1-git-send-email-ravishankar.km@greenturtles.in>
References: <1319091550-2558-1-git-send-email-ravishankar.km@greenturtles.in>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the cb_pcidas.c file that fixes up a printk
warning found by the checkpatch.pl tool
converted printks to dev_printk.
Removed unnecessary printk statements.

Signed-off-by: Ravishankar Karkala Mallikarjunayya <ravishankar.km@greenturtles.in>
---
 drivers/staging/comedi/drivers/cb_pcidas.c |   49 ++++++++++------------------
 1 files changed, 17 insertions(+), 32 deletions(-)

diff --git a/drivers/staging/comedi/drivers/cb_pcidas.c b/drivers/staging/comedi/drivers/cb_pcidas.c
index 9dec153..a0ce1ae 100644
--- a/drivers/staging/comedi/drivers/cb_pcidas.c
+++ b/drivers/staging/comedi/drivers/cb_pcidas.c
@@ -565,8 +565,6 @@ static int cb_pcidas_attach(struct comedi_device *dev,
 	int index;
 	int i;
 
-	pr_info("comedi%d: cb_pcidas: ", dev->minor);
-
 /*
  * Allocate the private structure area.
  */
@@ -576,7 +574,6 @@ static int cb_pcidas_attach(struct comedi_device *dev,
 /*
  * Probe the device to determine what device in the series it is.
  */
-	printk("\n");
 
 	for_each_pci_dev(pcidev) {
 		/*  is it not a computer boards card? */
@@ -600,20 +597,17 @@ static int cb_pcidas_attach(struct comedi_device *dev,
 		}
 	}
 
-	printk("No supported ComputerBoards/MeasurementComputing card found on "
-	       "requested position\n");
+	dev_err(dev->hw_dev,
+		"No supported ComputerBoards/MeasurementComputing card found on requested position\n");
 	return -EIO;
 
 found:
 
-	printk("Found %s on bus %i, slot %i\n", cb_pcidas_boards[index].name,
-	       pcidev->bus->number, PCI_SLOT(pcidev->devfn));
-
 	/*
 	 * Enable PCI device and reserve I/O ports.
 	 */
 	if (comedi_pci_enable(pcidev, "cb_pcidas")) {
-		printk(" Failed to enable PCI device and request regions\n");
+		dev_err(dev->hw_dev, "Failed to enable PCI device and request regions\n");
 		return -EIO;
 	}
 	/*
@@ -639,7 +633,8 @@ found:
 	/*  get irq */
 	if (request_irq(devpriv->pci_dev->irq, cb_pcidas_interrupt,
 			IRQF_SHARED, "cb_pcidas", dev)) {
-		printk(" unable to allocate irq %d\n", devpriv->pci_dev->irq);
+		dev_err(dev->hw_dev, "unable to allocate irq %d\n",
+			devpriv->pci_dev->irq);
 		return -EINVAL;
 	}
 	dev->irq = devpriv->pci_dev->irq;
@@ -768,17 +763,13 @@ found:
  */
 static int cb_pcidas_detach(struct comedi_device *dev)
 {
-	pr_info("comedi%d: cb_pcidas: remove\n", dev->minor);
-
 	if (devpriv) {
 		if (devpriv->s5933_config) {
 			/*  disable and clear interrupts on amcc s5933 */
 			outl(INTCSR_INBOX_INTR_STATUS,
 			     devpriv->s5933_config + AMCC_OP_REG_INTCSR);
-#ifdef CB_PCIDAS_DEBUG
-			printk("detaching, incsr is 0x%x\n",
-			       inl(devpriv->s5933_config + AMCC_OP_REG_INTCSR));
-#endif
+			dev_dbg(dev->hw_dev, "detaching, incsr is 0x%x\n",
+				inl(devpriv->s5933_config + AMCC_OP_REG_INTCSR));
 		}
 	}
 	if (dev->irq)
@@ -858,7 +849,8 @@ static int ai_config_calibration_source(struct comedi_device *dev,
 	unsigned int source = data[1];
 
 	if (source >= num_calibration_sources) {
-		printk("invalid calibration source: %i\n", source);
+		dev_err(dev->hw_dev, "invalid calibration source: %i\n",
+			source);
 		return -EINVAL;
 	}
 
@@ -1278,9 +1270,7 @@ static int cb_pcidas_ai_cmd(struct comedi_device *dev,
 		bits |= PACER_INT;
 	outw(bits, devpriv->control_status + ADCMUX_CONT);
 
-#ifdef CB_PCIDAS_DEBUG
-	printk("comedi: sent 0x%x to adcmux control\n", bits);
-#endif
+	dev_dbg(dev->hw_dev, "comedi: sent 0x%x to adcmux control\n", bits);
 
 	/*  load counters */
 	if (cmd->convert_src == TRIG_TIMER)
@@ -1305,9 +1295,8 @@ static int cb_pcidas_ai_cmd(struct comedi_device *dev,
 	} else {
 		devpriv->adc_fifo_bits |= INT_FHF;	/* interrupt fifo half full */
 	}
-#ifdef CB_PCIDAS_DEBUG
-	printk("comedi: adc_fifo_bits are 0x%x\n", devpriv->adc_fifo_bits);
-#endif
+	dev_dbg(dev->hw_dev, "comedi: adc_fifo_bits are 0x%x\n",
+		devpriv->adc_fifo_bits);
 	/*  enable (and clear) interrupts */
 	outw(devpriv->adc_fifo_bits | EOAI | INT | LADFUL,
 	     devpriv->control_status + INT_ADCFIFO);
@@ -1331,9 +1320,7 @@ static int cb_pcidas_ai_cmd(struct comedi_device *dev,
 	if (cmd->convert_src == TRIG_NOW && cmd->chanlist_len > 1)
 		bits |= BURSTE;
 	outw(bits, devpriv->control_status + TRIG_CONTSTAT);
-#ifdef CB_PCIDAS_DEBUG
-	printk("comedi: sent 0x%x to trig control\n", bits);
-#endif
+	dev_dbg(dev->hw_dev, "comedi: sent 0x%x to trig control\n", bits);
 
 	return 0;
 }
@@ -1548,9 +1535,8 @@ static int cb_pcidas_ao_inttrig(struct comedi_device *dev,
 	/*  enable dac half-full and empty interrupts */
 	spin_lock_irqsave(&dev->spinlock, flags);
 	devpriv->adc_fifo_bits |= DAEMIE | DAHFIE;
-#ifdef CB_PCIDAS_DEBUG
-	printk("comedi: adc_fifo_bits are 0x%x\n", devpriv->adc_fifo_bits);
-#endif
+	dev_dbg(dev->hw_dev, "comedi: adc_fifo_bits are 0x%x\n",
+		devpriv->adc_fifo_bits);
 	/*  enable and clear interrupts */
 	outw(devpriv->adc_fifo_bits | DAEMI | DAHFI,
 	     devpriv->control_status + INT_ADCFIFO);
@@ -1558,9 +1544,8 @@ static int cb_pcidas_ao_inttrig(struct comedi_device *dev,
 	/*  start dac */
 	devpriv->ao_control_bits |= DAC_START | DACEN | DAC_EMPTY;
 	outw(devpriv->ao_control_bits, devpriv->control_status + DAC_CSR);
-#ifdef CB_PCIDAS_DEBUG
-	printk("comedi: sent 0x%x to dac control\n", devpriv->ao_control_bits);
-#endif
+	dev_dbg(dev->hw_dev, "comedi: sent 0x%x to dac control\n",
+		devpriv->ao_control_bits);
 	spin_unlock_irqrestore(&dev->spinlock, flags);
 
 	async->inttrig = NULL;
-- 
1.7.6.4

