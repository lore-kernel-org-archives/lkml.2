Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752575Ab2ABNKY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jan 2012 08:10:24 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:60746 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751311Ab2ABNKW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jan 2012 08:10:22 -0500
From: Ravishankar karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
To: gregkh@suse.de, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        dan.carpenter@oracle.com, rmallon@gmail.com, joe@perches.com,
        valdis.kletnieks@vt.edu, jj@chaosbits.net,
        Ravishankar karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
Subject: [PATCH 1/6] Staging: comedi: fix printk warning issue in ni_at_a2150.c
Date: Mon,  2 Jan 2012 18:39:57 +0530
Message-Id: <1325509801-20036-1-git-send-email-ravishankar.km@greenturtles.in>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes a printk warning found by the checkpatch.pl tool.
Convert printk messages to dev_<levels> and removes useless printk
messages.

Signed-off-by: Ravishankar Karkala Mallikarjunayya <ravishankar.km@greenturtles.in>
---
 drivers/staging/comedi/drivers/ni_at_a2150.c |   48 ++++++--------------------
 1 files changed, 11 insertions(+), 37 deletions(-)

diff --git a/drivers/staging/comedi/drivers/ni_at_a2150.c b/drivers/staging/comedi/drivers/ni_at_a2150.c
index c25e44c..ee888bd 100644
--- a/drivers/staging/comedi/drivers/ni_at_a2150.c
+++ b/drivers/staging/comedi/drivers/ni_at_a2150.c
@@ -215,9 +215,10 @@ module_exit(driver_a2150_cleanup_module);
 
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
 
 #endif
@@ -347,61 +348,35 @@ static int a2150_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	static const int timeout = 2000;
 	int i;
 
-	printk("comedi%d: %s: io 0x%lx", dev->minor, driver_a2150.driver_name,
-	       iobase);
-	if (irq) {
-		printk(", irq %u", irq);
-	} else {
-		printk(", no irq");
-	}
-	if (dma) {
-		printk(", dma %u", dma);
-	} else {
-		printk(", no dma");
-	}
-	printk("\n");
-
 	/* allocate and initialize dev->private */
 	if (alloc_private(dev, sizeof(struct a2150_private)) < 0)
 		return -ENOMEM;
 
-	if (iobase == 0) {
-		printk(" io base address required\n");
+	if (iobase == 0)
 		return -EINVAL;
-	}
 
 	/* check if io addresses are available */
-	if (!request_region(iobase, A2150_SIZE, driver_a2150.driver_name)) {
-		printk(" I/O port conflict\n");
+	if (!request_region(iobase, A2150_SIZE, driver_a2150.driver_name))
 		return -EIO;
-	}
 	dev->iobase = iobase;
 
 	/* grab our IRQ */
 	if (irq) {
 		/*  check that irq is supported */
-		if (irq < 3 || irq == 8 || irq == 13 || irq > 15) {
-			printk(" invalid irq line %u\n", irq);
+		if (irq < 3 || irq == 8 || irq == 13 || irq > 15)
 			return -EINVAL;
-		}
 		if (request_irq(irq, a2150_interrupt, 0,
-				driver_a2150.driver_name, dev)) {
-			printk("unable to allocate irq %u\n", irq);
+					driver_a2150.driver_name, dev))
 			return -EINVAL;
-		}
 		devpriv->irq_dma_bits |= IRQ_LVL_BITS(irq);
 		dev->irq = irq;
 	}
 	/*  initialize dma */
 	if (dma) {
-		if (dma == 4 || dma > 7) {
-			printk(" invalid dma channel %u\n", dma);
+		if (dma == 4 || dma > 7)
 			return -EINVAL;
-		}
-		if (request_dma(dma, driver_a2150.driver_name)) {
-			printk(" failed to allocate dma channel %u\n", dma);
+		if (request_dma(dma, driver_a2150.driver_name))
 			return -EINVAL;
-		}
 		devpriv->dma = dma;
 		devpriv->dma_buffer =
 		    kmalloc(A2150_DMA_BUFFER_SIZE, GFP_KERNEL | GFP_DMA);
@@ -466,7 +441,6 @@ static int a2150_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 
 static int a2150_detach(struct comedi_device *dev)
 {
-	printk("comedi%d: %s: remove\n", dev->minor, driver_a2150.driver_name);
 
 	/* only free stuff if it has been allocated by _attach */
 	if (dev->iobase) {
@@ -801,7 +775,7 @@ static int a2150_ai_rinsn(struct comedi_device *dev, struct comedi_subdevice *s,
 #endif
 		data[n] = inw(dev->iobase + FIFO_DATA_REG);
 #ifdef A2150_DEBUG
-		printk(" data is %i\n", data[n]);
+		dev_dbg(dev->hw_dev, "data is %i\n", data[n]);
 #endif
 		data[n] ^= 0x8000;
 	}
-- 
1.7.0.4

