Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752848Ab1GTFod (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jul 2011 01:44:33 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:41975 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751868Ab1GTFob (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jul 2011 01:44:31 -0400
From: Ravishankar <ravishankarkm32@gmail.com>
To: gregkh@suse.de, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Ravishankar <ravi.shankar@greenturtles.in>,
        Ravishankar <ravishankarkm32@gmail.com>
Subject: [PATCH 1/1] Staging: comedi: fix printk issue in das6402.c
Date: Wed, 20 Jul 2011 11:27:19 +0530
Message-Id: <1311141439-15920-1-git-send-email-ravishankarkm32@gmail.com>
X-Mailer: git-send-email 1.6.5.2
In-Reply-To: <[PATCH]Staging: comedi: fix printk() issue in das6402.c>
References: <[PATCH]Staging: comedi: fix printk() issue in das6402.c>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ravishankar <ravi.shankar@greenturtles.in>

This is a patch to the das6402.c file that fixes up a printk() warning found by the checkpatch.pl tool

Signed-off-by: Ravishankar <ravishankarkm32@gmail.com>
---
 drivers/staging/comedi/drivers/das6402.c |   27 +++++++++++++++------------
 1 files changed, 15 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/comedi/drivers/das6402.c b/drivers/staging/comedi/drivers/das6402.c
index 6328f52..f9db533 100644
--- a/drivers/staging/comedi/drivers/das6402.c
+++ b/drivers/staging/comedi/drivers/das6402.c
@@ -171,13 +171,13 @@ static irqreturn_t intr_handler(int irq, void *d)
 	struct comedi_subdevice *s = dev->subdevices;
 
 	if (!dev->attached || devpriv->das6402_ignoreirq) {
-		printk("das6402: BUG: spurious interrupt\n");
+		printk(KERN_WARNING "das6402: BUG: spurious interrupt\n");
 		return IRQ_HANDLED;
 	}
 #ifdef DEBUG
-	printk("das6402: interrupt! das6402_irqcount=%i\n",
-	       devpriv->das6402_irqcount);
-	printk("das6402: iobase+2=%i\n", inw_p(dev->iobase + 2));
+	printk(KERN_DEBUG "das6402: interrupt! das6402_irqcount=%i\n",
+			devpriv->das6402_irqcount);
+	printk(KERN_DEBUG "das6402: iobase+2=%i\n", inw_p(dev->iobase + 2));
 #endif
 
 	das6402_ai_fifo_dregs(dev, s);
@@ -186,8 +186,8 @@ static irqreturn_t intr_handler(int irq, void *d)
 		outw_p(SCANL, dev->iobase + 2);	/* clears the fifo */
 		outb(0x07, dev->iobase + 8);	/* clears all flip-flops */
 #ifdef DEBUG
-		printk("das6402: Got %i samples\n\n",
-		       devpriv->das6402_wordsread - diff);
+		printk(KERN_DEBUG "das6402: Got %i samples\n\n",
+			devpriv->das6402_wordsread - diff);
 #endif
 		s->async->events |= COMEDI_CB_EOA;
 		comedi_event(dev, s);
@@ -229,7 +229,7 @@ static int das6402_ai_cancel(struct comedi_device *dev,
 
 	devpriv->das6402_ignoreirq = 1;
 #ifdef DEBUG
-	printk("das6402: Stopping acquisition\n");
+	printk(KERN_DEBUG "das6402: Stopping acquisition\n");
 #endif
 	devpriv->das6402_ignoreirq = 1;
 	outb_p(0x02, dev->iobase + 10);	/* disable external trigging */
@@ -248,7 +248,7 @@ static int das6402_ai_mode2(struct comedi_device *dev,
 	devpriv->das6402_ignoreirq = 1;
 
 #ifdef DEBUG
-	printk("das6402: Starting acquisition\n");
+	printk(KERN_DEBUG "das6402: Starting acquisition\n");
 #endif
 	outb_p(0x03, dev->iobase + 10);	/* enable external trigging */
 	outw_p(SCANL, dev->iobase + 2);	/* resets the card fifo */
@@ -329,10 +329,12 @@ static int das6402_attach(struct comedi_device *dev,
 	if (iobase == 0)
 		iobase = 0x300;
 
-	printk("comedi%d: das6402: 0x%04lx", dev->minor, iobase);
+	printk(KERN_INFO "comedi%d: das6402: 0x%04lx", dev->minor, iobase);
 
 	if (!request_region(iobase, DAS6402_SIZE, "das6402")) {
-		printk(" I/O port conflict\n");
+		printk(KERN_CONT "\n");
+		printk(KERN_ERR "comedi%d: das6402: 0x%04lx: I/O port conflict\n",
+		dev->minor, iobase);
 		return -EIO;
 	}
 	dev->iobase = iobase;
@@ -340,10 +342,11 @@ static int das6402_attach(struct comedi_device *dev,
 	/* should do a probe here */
 
 	irq = it->options[0];
-	printk(" ( irq = %u )", irq);
+	printk(KERN_DEBUG " ( irq = %u )", irq);
 	ret = request_irq(irq, intr_handler, 0, "das6402", dev);
 	if (ret < 0) {
-		printk("irq conflict\n");
+		printk(KERN_CONT "\n");
+		printk(KERN_DEBUG "( irq = %u)irq conflict\n", irq);
 		return ret;
 	}
 	dev->irq = irq;
-- 
1.6.5.2

