Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752098Ab1GVH1z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jul 2011 03:27:55 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:33994 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751543Ab1GVH1y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jul 2011 03:27:54 -0400
From: Ravishankar <ravishankarkm32@gmail.com>
To: gregkh@suse.de, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Ravishankar <ravi.shankar@greenturtles.in>,
        Ravishankar <ravishankarkm32@gmail.com>
Subject: [PATCH 1/1 v3] Staging: comedi: fix printk issue in das6402.c
Date: Fri, 22 Jul 2011 12:57:35 +0530
Message-Id: <1311319655-4324-1-git-send-email-ravishankarkm@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <[PATCH]Staging: Comedi: fix printk issue in das6402.c>
References: <[PATCH]Staging: Comedi: fix printk issue in das6402.c>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ravishankar <ravi.shankar@greenturtles.in>

This is a patch to the das6402.c file that fixes up a printk() warning found by the checkpatch.pl tool

Signed-off-by: Ravishankar <ravishankarkm32@gmail.com>
---

Converted pr_<level> to dev_version 
and Printk to pr_<level>

 drivers/staging/comedi/drivers/das6402.c |   21 +++++++++++----------
 1 files changed, 11 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/comedi/drivers/das6402.c b/drivers/staging/comedi/drivers/das6402.c
index facf173..8d61f28 100644
--- a/drivers/staging/comedi/drivers/das6402.c
+++ b/drivers/staging/comedi/drivers/das6402.c
@@ -176,16 +176,15 @@ static irqreturn_t intr_handler(int irq, void *d)
 		dev_warn(dev->hw_dev, "BUG: spurious interrupt\n");
 		return IRQ_HANDLED;
 	}
-	pr_debug("interrupt! das6402_irqcount=%i\n",
+	dev_dbg(dev->hw_dev, "interrupt! das6402_irqcount=%i\n",
 			devpriv->das6402_irqcount);
-	pr_debug("iobase+2=%i\n", inw_p(dev->iobase + 2));
-
+	dev_dbg(dev->hw_dev, "iobase+2=%i\n", inw_p(dev->iobase + 2));
 	das6402_ai_fifo_dregs(dev, s);
 
 	if (s->async->buf_write_count >= devpriv->ai_bytes_to_read) {
 		outw_p(SCANL, dev->iobase + 2);	/* clears the fifo */
 		outb(0x07, dev->iobase + 8);	/* clears all flip-flops */
-		pr_debug("Got %i samples\n\n",
+		dev_dbg(dev->hw_dev, "Got %i samples\n\n",
 				devpriv->das6402_wordsread - diff);
 		s->async->events |= COMEDI_CB_EOA;
 		comedi_event(dev, s);
@@ -226,7 +225,7 @@ static int das6402_ai_cancel(struct comedi_device *dev,
 	 */
 
 	devpriv->das6402_ignoreirq = 1;
-	pr_debug("Stopping acquisition\n");
+	dev_dbg(dev->hw_dev, "Stopping acquisition\n");
 	devpriv->das6402_ignoreirq = 1;
 	outb_p(0x02, dev->iobase + 10);	/* disable external trigging */
 	outw_p(SCANL, dev->iobase + 2);	/* resets the card fifo */
@@ -242,7 +241,7 @@ static int das6402_ai_mode2(struct comedi_device *dev,
 			    struct comedi_subdevice *s, comedi_trig * it)
 {
 	devpriv->das6402_ignoreirq = 1;
-	pr_debug("Starting acquisition\n");
+	dev_dbg(dev->hw_dev, "Starting acquisition\n");
 	outb_p(0x03, dev->iobase + 10);	/* enable external trigging */
 	outw_p(SCANL, dev->iobase + 2);	/* resets the card fifo */
 	outb_p(IRQ | CONVSRC | BURSTEN | INTE, dev->iobase + 9);
@@ -322,10 +321,11 @@ static int das6402_attach(struct comedi_device *dev,
 	if (iobase == 0)
 		iobase = 0x300;
 
-	printk(KERN_INFO "comedi%d: das6402: 0x%04lx", dev->minor, iobase);
+	pr_info("comedi%d: das6402: 0x%04lx", dev->minor, iobase);
 
 	if (!request_region(iobase, DAS6402_SIZE, "das6402")) {
-		printk(KERN_CONT " I/O port conflict\n");
+		pr_cont("I/O port conflict\n");
+		dev_dbg(dev->hw_dev, "I/O port conflict\n");
 		return -EIO;
 	}
 	dev->iobase = iobase;
@@ -333,10 +333,11 @@ static int das6402_attach(struct comedi_device *dev,
 	/* should do a probe here */
 
 	irq = it->options[0];
-	printk(KERN_CONT " ( irq = %u )", irq);
+	pr_cont("( irq = %u )", irq);
 	ret = request_irq(irq, intr_handler, 0, "das6402", dev);
 	if (ret < 0) {
-		printk(KERN_CONT "irq conflict\n");
+		pr_cont("irq conflict\n");
+		dev_dbg(dev->hw_dev, "irq conflict\n");
 		return ret;
 	}
 	dev->irq = irq;
-- 
1.6.5.2

