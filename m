Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932426Ab1KHLPs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 06:15:48 -0500
Received: from mail-qy0-f181.google.com ([209.85.216.181]:42845 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752428Ab1KHLPq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 06:15:46 -0500
From: Ravishankar karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
To: gregkh@suse.de, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Ravishankar karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
Subject: [PATCH 01/20] Staging: comedi: fix printk issue in das6402.c
Date: Tue,  8 Nov 2011 16:45:11 +0530
Message-Id: <1320750930-9764-1-git-send-email-ravishankar.km@greenturtles.in>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the das6402.c file that fixes up a printk
warning found by the checkpatch.pl tool.

Converted printks to dev_version.
Removed unnecessary printk statements.

Signed-off-by: Ravishankar Karkala Mallikarjunayya <ravishankar.km@greenturtles.in>
---
 drivers/staging/comedi/drivers/das6402.c |   23 +++++++----------------
 1 files changed, 7 insertions(+), 16 deletions(-)

diff --git a/drivers/staging/comedi/drivers/das6402.c b/drivers/staging/comedi/drivers/das6402.c
index 6328f52..f256841 100644
--- a/drivers/staging/comedi/drivers/das6402.c
+++ b/drivers/staging/comedi/drivers/das6402.c
@@ -171,7 +171,7 @@ static irqreturn_t intr_handler(int irq, void *d)
 	struct comedi_subdevice *s = dev->subdevices;
 
 	if (!dev->attached || devpriv->das6402_ignoreirq) {
-		printk("das6402: BUG: spurious interrupt\n");
+		dev_warn(dev->hw_dev, "BUG: spurious interrupt\n");
 		return IRQ_HANDLED;
 	}
 #ifdef DEBUG
@@ -228,9 +228,7 @@ static int das6402_ai_cancel(struct comedi_device *dev,
 	 */
 
 	devpriv->das6402_ignoreirq = 1;
-#ifdef DEBUG
-	printk("das6402: Stopping acquisition\n");
-#endif
+	dev_dbg(dev->hw_dev, "Stopping acquisition\n");
 	devpriv->das6402_ignoreirq = 1;
 	outb_p(0x02, dev->iobase + 10);	/* disable external trigging */
 	outw_p(SCANL, dev->iobase + 2);	/* resets the card fifo */
@@ -246,10 +244,7 @@ static int das6402_ai_mode2(struct comedi_device *dev,
 			    struct comedi_subdevice *s, comedi_trig * it)
 {
 	devpriv->das6402_ignoreirq = 1;
-
-#ifdef DEBUG
-	printk("das6402: Starting acquisition\n");
-#endif
+	dev_dbg(dev->hw_dev, "Starting acquisition\n");
 	outb_p(0x03, dev->iobase + 10);	/* enable external trigging */
 	outw_p(SCANL, dev->iobase + 2);	/* resets the card fifo */
 	outb_p(IRQ | CONVSRC | BURSTEN | INTE, dev->iobase + 9);
@@ -329,10 +324,8 @@ static int das6402_attach(struct comedi_device *dev,
 	if (iobase == 0)
 		iobase = 0x300;
 
-	printk("comedi%d: das6402: 0x%04lx", dev->minor, iobase);
-
 	if (!request_region(iobase, DAS6402_SIZE, "das6402")) {
-		printk(" I/O port conflict\n");
+		dev_err(dev->hw_dev, "I/O port conflict\n");
 		return -EIO;
 	}
 	dev->iobase = iobase;
@@ -340,14 +333,12 @@ static int das6402_attach(struct comedi_device *dev,
 	/* should do a probe here */
 
 	irq = it->options[0];
-	printk(" ( irq = %u )", irq);
+	dev_dbg(dev->hw_dev, "( irq = %u )\n", irq);
 	ret = request_irq(irq, intr_handler, 0, "das6402", dev);
-	if (ret < 0) {
-		printk("irq conflict\n");
+	if (ret < 0)
 		return ret;
-	}
-	dev->irq = irq;
 
+	dev->irq = irq;
 	ret = alloc_private(dev, sizeof(struct das6402_private));
 	if (ret < 0)
 		return ret;
-- 
1.7.0.4

