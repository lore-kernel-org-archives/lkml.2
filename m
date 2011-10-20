Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932473Ab1JTGV5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Oct 2011 02:21:57 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:44102 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932243Ab1JTGVx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Oct 2011 02:21:53 -0400
From: Ravishankar Karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
To: gregkh@suse.de, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Ravishankar Karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
Subject: [PATCH 18/24] Staging: comedi: fix printk issue in ni_at_a2150.c
Date: Thu, 20 Oct 2011 11:49:04 +0530
Message-Id: <1319091550-2558-18-git-send-email-ravishankar.km@greenturtles.in>
X-Mailer: git-send-email 1.7.6.4
In-Reply-To: <1319091550-2558-1-git-send-email-ravishankar.km@greenturtles.in>
References: <1319091550-2558-1-git-send-email-ravishankar.km@greenturtles.in>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the ni_at_a2150.c file that fixes up a printk
warning found by the checkpatch.pl tool
converted printks to dev_printk.
Removed unnecessary printk statements.
Fixed brace coding issue.

Signed-off-by: Ravishankar Karkala Mallikarjunayya <ravishankar.km@greenturtles.in>
---
 drivers/staging/comedi/drivers/ni_at_a2150.c |   43 +++++++++----------------
 1 files changed, 16 insertions(+), 27 deletions(-)

diff --git a/drivers/staging/comedi/drivers/ni_at_a2150.c b/drivers/staging/comedi/drivers/ni_at_a2150.c
index 32e675e..54ddb2b 100644
--- a/drivers/staging/comedi/drivers/ni_at_a2150.c
+++ b/drivers/staging/comedi/drivers/ni_at_a2150.c
@@ -211,17 +211,14 @@ static void __exit driver_a2150_cleanup_module(void)
 module_init(driver_a2150_init_module);
 module_exit(driver_a2150_cleanup_module);
 
-#ifdef A2150_DEBUG
-
 static void ni_dump_regs(struct comedi_device *dev)
 {
-	printk("config bits 0x%x\n", devpriv->config_bits);
-	printk("irq dma bits 0x%x\n", devpriv->irq_dma_bits);
-	printk("status bits 0x%x\n", inw(dev->iobase + STATUS_REG));
+	dev_dbg(dev->hw_dev, "config bits 0x%x\n", devpriv->config_bits);
+	dev_dbg(dev->hw_dev, "irq dma bits 0x%x\n", devpriv->irq_dma_bits);
+	dev_dbg(dev->hw_dev, "status bits 0x%x\n",
+		inw(dev->iobase + STATUS_REG));
 }
 
-#endif
-
 /* interrupt service routine */
 static irqreturn_t a2150_interrupt(int irq, void *d)
 {
@@ -347,8 +344,6 @@ static int a2150_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	static const int timeout = 2000;
 	int i;
 
-	printk("comedi%d: %s: io 0x%lx", dev->minor, driver_a2150.driver_name,
-	       iobase);
 	if (irq) {
 		printk(", irq %u", irq);
 	} else {
@@ -359,20 +354,19 @@ static int a2150_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	} else {
 		printk(", no dma");
 	}
-	printk("\n");
 
 	/* allocate and initialize dev->private */
 	if (alloc_private(dev, sizeof(struct a2150_private)) < 0)
 		return -ENOMEM;
 
 	if (iobase == 0) {
-		printk(" io base address required\n");
+		dev_err(dev->hw_dev, "io base address required\n");
 		return -EINVAL;
 	}
 
 	/* check if io addresses are available */
 	if (!request_region(iobase, A2150_SIZE, driver_a2150.driver_name)) {
-		printk(" I/O port conflict\n");
+		dev_err(dev->hw_dev, "I/O port conflict\n");
 		return -EIO;
 	}
 	dev->iobase = iobase;
@@ -381,12 +375,13 @@ static int a2150_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	if (irq) {
 		/*  check that irq is supported */
 		if (irq < 3 || irq == 8 || irq == 13 || irq > 15) {
-			printk(" invalid irq line %u\n", irq);
+			dev_err(dev->hw_dev, "invalid irq line %u\n", irq);
 			return -EINVAL;
 		}
 		if (request_irq(irq, a2150_interrupt, 0,
 				driver_a2150.driver_name, dev)) {
-			printk("unable to allocate irq %u\n", irq);
+			dev_err(dev->hw_dev, "unable to allocate irq %u\n",
+				irq);
 			return -EINVAL;
 		}
 		devpriv->irq_dma_bits |= IRQ_LVL_BITS(irq);
@@ -395,11 +390,12 @@ static int a2150_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	/*  initialize dma */
 	if (dma) {
 		if (dma == 4 || dma > 7) {
-			printk(" invalid dma channel %u\n", dma);
+			dev_err(dev->hw_dev, "invalid dma channel %u\n", dma);
 			return -EINVAL;
 		}
 		if (request_dma(dma, driver_a2150.driver_name)) {
-			printk(" failed to allocate dma channel %u\n", dma);
+			dev_err(dev->hw_dev, "failed to allocate dma channel %u\n",
+				dma);
 			return -EINVAL;
 		}
 		devpriv->dma = dma;
@@ -466,7 +462,6 @@ static int a2150_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 
 static int a2150_detach(struct comedi_device *dev)
 {
-	printk("comedi%d: %s: remove\n", dev->minor, driver_a2150.driver_name);
 
 	/* only free stuff if it has been allocated by _attach */
 	if (dev->iobase) {
@@ -731,12 +726,9 @@ static int a2150_ai_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
 	outw(trigger_bits, dev->iobase + TRIGGER_REG);
 
 	/*  start acquisition for soft trigger */
-	if (cmd->start_src == TRIG_NOW) {
+	if (cmd->start_src == TRIG_NOW)
 		outw(0, dev->iobase + FIFO_START_REG);
-	}
-#ifdef A2150_DEBUG
 	ni_dump_regs(dev);
-#endif
 
 	return 0;
 }
@@ -801,9 +793,7 @@ static int a2150_ai_rinsn(struct comedi_device *dev, struct comedi_subdevice *s,
 		ni_dump_regs(dev);
 #endif
 		data[n] = inw(dev->iobase + FIFO_DATA_REG);
-#ifdef A2150_DEBUG
-		printk(" data is %i\n", data[n]);
-#endif
+		dev_dbg(dev->hw_dev, "data is %i\n", data[n]);
 		data[n] ^= 0x8000;
 	}
 
@@ -860,11 +850,10 @@ static int a2150_get_timing(struct comedi_device *dev, unsigned int *period,
 	case TRIG_ROUND_NEAREST:
 	default:
 		/*  if least upper bound is better approximation */
-		if (lub - *period < *period - glb) {
+		if (lub - *period < *period - glb)
 			*period = lub;
-		} else {
+		else
 			*period = glb;
-		}
 		break;
 	case TRIG_ROUND_UP:
 		*period = lub;
-- 
1.7.6.4

