Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759308Ab2EKKkt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 06:40:49 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:56846 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759186Ab2EKKkp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 06:40:45 -0400
From: Ravishankar Karkala Mallikarjunayya <ravishankarkm32@gmail.com>
To: gregkh@linuxfoundation.org, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Ravishankar Karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
Subject: [PATCH 08/25] Staging: comedi: fix printk issue in rti800.c
Date: Fri, 11 May 2012 16:07:56 +0530
Message-Id: <1336732693-7408-9-git-send-email-ravishankar.km@greenturtles.in>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1336732693-7408-1-git-send-email-ravishankar.km@greenturtles.in>
References: <1336732693-7408-1-git-send-email-ravishankar.km@greenturtles.in>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the rti800.c file that fixes up a printk found
by the checkpatch.pl tool.

Used dev_*() functions instead of printks wherver possible.

Signed-off-by: Ravishankar Karkala Mallikarjunayya <ravishankar.km@greenturtles.in>
---
 drivers/staging/comedi/drivers/rti800.c |   26 +++++++++++++-------------
 1 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/staging/comedi/drivers/rti800.c b/drivers/staging/comedi/drivers/rti800.c
index 9e082b3..b79d89c 100644
--- a/drivers/staging/comedi/drivers/rti800.c
+++ b/drivers/staging/comedi/drivers/rti800.c
@@ -205,7 +205,7 @@ static int rti800_ai_insn_read(struct comedi_device *dev,
 		for (t = RTI800_TIMEOUT; t; t--) {
 			status = inb(dev->iobase + RTI800_CSR);
 			if (status & RTI800_OVERRUN) {
-				printk(KERN_WARNING "rti800: a/d overrun\n");
+				dev_warn(dev->hw_dev, "a/d overrun\n");
 				outb(0, dev->iobase + RTI800_CLRFLAGS);
 				return -EIO;
 			}
@@ -214,7 +214,7 @@ static int rti800_ai_insn_read(struct comedi_device *dev,
 			udelay(1);
 		}
 		if (t == 0) {
-			printk(KERN_WARNING "rti800: timeout\n");
+			dev_warn(dev->hw_dev, "timeout\n");
 			return -ETIME;
 		}
 		data[i] = inb(dev->iobase + RTI800_ADCLO);
@@ -315,19 +315,19 @@ static int rti800_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	struct comedi_subdevice *s;
 
 	iobase = it->options[0];
-	printk(KERN_INFO "comedi%d: rti800: 0x%04lx\n", dev->minor, iobase);
+	dev_info(dev->hw_dev,  "comedi%d: 0x%04lx\n", dev->minor, iobase);
 	if (!request_region(iobase, RTI800_SIZE, "rti800")) {
-		printk(KERN_WARNING "I/O port conflict\n");
+		dev_warn(dev->hw_dev, "I/O port conflict\n");
 		return -EIO;
 	}
 	dev->iobase = iobase;
 
 #ifdef DEBUG
-	printk(KERN_DEBUG "fingerprint=%x,%x,%x,%x,%x ",
-	       inb(dev->iobase + 0),
-	       inb(dev->iobase + 1),
-	       inb(dev->iobase + 2),
-	       inb(dev->iobase + 3), inb(dev->iobase + 4));
+	dev_dbg(dev->hw_dev, "fingerprint=%x,%x,%x,%x,%x ",
+		inb(dev->iobase + 0),
+		inb(dev->iobase + 1),
+		inb(dev->iobase + 2),
+		inb(dev->iobase + 3), inb(dev->iobase + 4));
 #endif
 
 	outb(0, dev->iobase + RTI800_CSR);
@@ -336,15 +336,15 @@ static int rti800_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 
 	irq = it->options[1];
 	if (irq) {
-		printk(KERN_INFO "( irq = %u )\n", irq);
+		dev_info(dev->hw_dev, "( irq = %u )\n", irq);
 		ret = request_irq(irq, rti800_interrupt, 0, "rti800", dev);
 		if (ret < 0) {
-			printk(KERN_WARNING " Failed to allocate IRQ\n");
+			dev_warn(dev->hw_dev, "Failed to allocate IRQ\n");
 			return ret;
 		}
 		dev->irq = irq;
 	} else {
-		printk(KERN_INFO "( no irq )\n");
+		dev_info(dev->hw_dev, "( no irq )\n");
 	}
 
 	dev->board_name = this_board->name;
@@ -445,7 +445,7 @@ static int rti800_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 
 static int rti800_detach(struct comedi_device *dev)
 {
-	printk(KERN_INFO "comedi%d: rti800: remove\n", dev->minor);
+	dev_info(dev->hw_dev, "comedi%d: remove\n", dev->minor);
 
 	if (dev->iobase)
 		release_region(dev->iobase, RTI800_SIZE);
-- 
1.7.0.4

