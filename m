Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753109Ab1HQM0g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Aug 2011 08:26:36 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:52135 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752730Ab1HQM0f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Aug 2011 08:26:35 -0400
From: Ravishankar <ravishankarkm32@gmail.com>
To: gregkh@suse.de, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Ravishankar <ravi.shankar@greenturtles.in>,
        Ravishankar <ravishankarkm32@gmail.com>
Subject: [PATCH 1/2] Staging: comedi: fix printk warning issue in das6402.c
Date: Wed, 17 Aug 2011 08:26:18 -0400
Message-Id: <1313583978-3940-1-git-send-email-ravishankarkm32@gmail.com>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <[PATCH]Staging: comedi:fix printk warning issue in das6402.c>
References: <[PATCH]Staging: comedi:fix printk warning issue in das6402.c>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ravishankar <ravi.shankar@greenturtles.in>

This is a patch to the das6402.c file that fixes up a printk warning found by the checkpatch.pl tool

Signed-off-by: Ravishankar <ravishankarkm32@gmail.com>
---
 Added define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 Converted printks to dynamic debugging(dev_dbg).

 drivers/staging/comedi/drivers/das6402.c |   26 ++++++++++----------------
 1 files changed, 10 insertions(+), 16 deletions(-)

diff --git a/drivers/staging/comedi/drivers/das6402.c b/drivers/staging/comedi/drivers/das6402.c
index 6328f52..031903c 100644
--- a/drivers/staging/comedi/drivers/das6402.c
+++ b/drivers/staging/comedi/drivers/das6402.c
@@ -38,6 +38,8 @@ Devices: [Keithley Metrabyte] DAS6402 (das6402)
 This driver has suffered bitrot.
 */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/interrupt.h>
 #include "../comedidev.h"
 
@@ -171,24 +173,20 @@ static irqreturn_t intr_handler(int irq, void *d)
 	struct comedi_subdevice *s = dev->subdevices;
 
 	if (!dev->attached || devpriv->das6402_ignoreirq) {
-		printk("das6402: BUG: spurious interrupt\n");
+		dev_warn(dev->hw_dev, "BUG: spurious interrupt\n");
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
+		dev_dbg(dev->hw_dev, "Got %i samples\n\n",
+				devpriv->das6402_wordsread - diff);
 		s->async->events |= COMEDI_CB_EOA;
 		comedi_event(dev, s);
 	}
@@ -228,9 +226,7 @@ static int das6402_ai_cancel(struct comedi_device *dev,
 	 */
 
 	devpriv->das6402_ignoreirq = 1;
-#ifdef DEBUG
-	printk("das6402: Stopping acquisition\n");
-#endif
+	dev_dbg(dev->hw_dev, "Stopping acquisition\n");
 	devpriv->das6402_ignoreirq = 1;
 	outb_p(0x02, dev->iobase + 10);	/* disable external trigging */
 	outw_p(SCANL, dev->iobase + 2);	/* resets the card fifo */
@@ -247,9 +243,7 @@ static int das6402_ai_mode2(struct comedi_device *dev,
 {
 	devpriv->das6402_ignoreirq = 1;
 
-#ifdef DEBUG
-	printk("das6402: Starting acquisition\n");
-#endif
+	dev_dbg(dev->hw_dev, "Starting acquisition\n");
 	outb_p(0x03, dev->iobase + 10);	/* enable external trigging */
 	outw_p(SCANL, dev->iobase + 2);	/* resets the card fifo */
 	outb_p(IRQ | CONVSRC | BURSTEN | INTE, dev->iobase + 9);
-- 
1.7.6

