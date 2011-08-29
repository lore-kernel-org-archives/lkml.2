Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753812Ab1H2O06 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 10:26:58 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:34794 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753604Ab1H2O0w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 10:26:52 -0400
From: Ravishankar <ravi.shankar@greenturtles.in>
To: gregkh@suse.de, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Ravishankarkm <ravi.shankar@greenturtles.in>
Subject: [PATCH 1/1] Staging: comedi: fix printk issue in das6402.c
Date: Mon, 29 Aug 2011 19:56:32 +0530
Message-Id: <1314627992-14358-1-git-send-email-ravi.shankar@greenturtles.in>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <[PATCH]Staging: comedi: fix printk issues in das6402.c>
References: <[PATCH]Staging: comedi: fix printk issues in das6402.c>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ravishankarkm <ravi.shankar@greenturtles.in>

This is a patch to the das6402.c file that fixes up a printk warning found by the checkpatch.pl tool

Signed-off-by: Ravishankarkm <ravi.shankar@greenturtles.in>
---
 Added #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 Converted printk to pr_<levels>, dev_verson.
 drivers/staging/comedi/drivers/das6402.c |   37 ++++++++++++-----------------
 1 files changed, 15 insertions(+), 22 deletions(-)

diff --git a/drivers/staging/comedi/drivers/das6402.c b/drivers/staging/comedi/drivers/das6402.c
index 6328f52..a6f9828 100644
--- a/drivers/staging/comedi/drivers/das6402.c
+++ b/drivers/staging/comedi/drivers/das6402.c
@@ -38,6 +38,9 @@ Devices: [Keithley Metrabyte] DAS6402 (das6402)
 This driver has suffered bitrot.
 */
 
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/interrupt.h>
 #include "../comedidev.h"
 
@@ -171,24 +174,20 @@ static irqreturn_t intr_handler(int irq, void *d)
 	struct comedi_subdevice *s = dev->subdevices;
 
 	if (!dev->attached || devpriv->das6402_ignoreirq) {
-		printk("das6402: BUG: spurious interrupt\n");
+		dev_warn(dev->hw_dev, " BUG: spurious interrupt\n");
 		return IRQ_HANDLED;
 	}
-#ifdef DEBUG
-	printk("das6402: interrupt! das6402_irqcount=%i\n",
-	       devpriv->das6402_irqcount);
-	printk("das6402: iobase+2=%i\n", inw_p(dev->iobase + 2));
-#endif
+	dev_dbg(dev->hw_dev, "interrupt! das6402_irqcount=%i\n",
+			devpriv->das6402_irqcount);
+	dev_dbg(dev->hw_dev, "iobase+2=%i\n", inw_p(dev->iobase + 2));
 
 	das6402_ai_fifo_dregs(dev, s);
 
 	if (s->async->buf_write_count >= devpriv->ai_bytes_to_read) {
 		outw_p(SCANL, dev->iobase + 2);	/* clears the fifo */
 		outb(0x07, dev->iobase + 8);	/* clears all flip-flops */
-#ifdef DEBUG
-		printk("das6402: Got %i samples\n\n",
-		       devpriv->das6402_wordsread - diff);
-#endif
+		dev_dbg(dev->hw_dev, "Got %i samples\n",
+				devpriv->das6402_wordsread - diff);
 		s->async->events |= COMEDI_CB_EOA;
 		comedi_event(dev, s);
 	}
@@ -228,9 +227,7 @@ static int das6402_ai_cancel(struct comedi_device *dev,
 	 */
 
 	devpriv->das6402_ignoreirq = 1;
-#ifdef DEBUG
-	printk("das6402: Stopping acquisition\n");
-#endif
+	dev_dbg(dev->hw_dev, "Stopping acquisition\n");
 	devpriv->das6402_ignoreirq = 1;
 	outb_p(0x02, dev->iobase + 10);	/* disable external trigging */
 	outw_p(SCANL, dev->iobase + 2);	/* resets the card fifo */
@@ -247,9 +244,7 @@ static int das6402_ai_mode2(struct comedi_device *dev,
 {
 	devpriv->das6402_ignoreirq = 1;
 
-#ifdef DEBUG
-	printk("das6402: Starting acquisition\n");
-#endif
+	dev_dbg(dev->hw_dev, "Starting acquisition\n");
 	outb_p(0x03, dev->iobase + 10);	/* enable external trigging */
 	outw_p(SCANL, dev->iobase + 2);	/* resets the card fifo */
 	outb_p(IRQ | CONVSRC | BURSTEN | INTE, dev->iobase + 9);
@@ -329,10 +324,11 @@ static int das6402_attach(struct comedi_device *dev,
 	if (iobase == 0)
 		iobase = 0x300;
 
-	printk("comedi%d: das6402: 0x%04lx", dev->minor, iobase);
+	pr_info("comedi%d: das6402: 0x%04lx", dev->minor, iobase);
 
 	if (!request_region(iobase, DAS6402_SIZE, "das6402")) {
-		printk(" I/O port conflict\n");
+		pr_cont("\n");
+		pr_warn("comedi%d: das6402: I/O port conflict\n", dev->minor);
 		return -EIO;
 	}
 	dev->iobase = iobase;
@@ -340,12 +336,9 @@ static int das6402_attach(struct comedi_device *dev,
 	/* should do a probe here */
 
 	irq = it->options[0];
-	printk(" ( irq = %u )", irq);
 	ret = request_irq(irq, intr_handler, 0, "das6402", dev);
-	if (ret < 0) {
-		printk("irq conflict\n");
+	if (ret < 0)
 		return ret;
-	}
 	dev->irq = irq;
 
 	ret = alloc_private(dev, sizeof(struct das6402_private));
-- 
1.7.6

