Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758124Ab1I3KcT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Sep 2011 06:32:19 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:57886 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754109Ab1I3KcN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Sep 2011 06:32:13 -0400
From: Johannes Thumshirn <morbidrsa@googlemail.com>
To: gregkh@suse.de, abbotti@mev.co.uk, fmhess@users.sourceforge.net
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        Johannes Thumshirn <morbidrsa@googlemail.com>
Subject: [PATCH] staging: comedi: Added log subjects to printk()s in pcmmio
Date: Fri, 30 Sep 2011 12:31:33 +0200
Message-Id: <1317378693-18474-1-git-send-email-morbidrsa@googlemail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1316926152-7258-1-git-send-email-morbidrsa@googlemail.com>
References: <1316926152-7258-1-git-send-email-morbidrsa@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added log subject to printk()s in drivers/staging/comedi/drivers/pcmmio.c.
When necessary append trailing '\n' and leading identifier to log message to
unbreak the output.

Signed-off-by: Johannes Thumshirn <morbidrsa@googlemail.com>
---
 drivers/staging/comedi/drivers/pcmmio.c |   38 +++++++++++++++++-------------
 1 files changed, 21 insertions(+), 17 deletions(-)

diff --git a/drivers/staging/comedi/drivers/pcmmio.c b/drivers/staging/comedi/drivers/pcmmio.c
index f2e88e5..eddac00 100644
--- a/drivers/staging/comedi/drivers/pcmmio.c
+++ b/drivers/staging/comedi/drivers/pcmmio.c
@@ -371,15 +371,15 @@ static int pcmmio_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	iobase = it->options[0];
 	irq[0] = it->options[1];
 
-	printk("comedi%d: %s: io: %lx ", dev->minor, driver.driver_name,
-	       iobase);
+	printk(KERN_INFO "comedi%d: %s: io: %lx attaching...\n", dev->minor,
+			driver.driver_name, iobase);
 
 	dev->iobase = iobase;
 
 	if (!iobase || !request_region(iobase,
 				       thisboard->total_iosize,
 				       driver.driver_name)) {
-		printk("I/O port conflict\n");
+		printk(KERN_ERR "comedi%d: I/O port conflict\n", dev->minor);
 		return -EIO;
 	}
 
@@ -394,7 +394,8 @@ static int pcmmio_attach(struct comedi_device *dev, struct comedi_devconfig *it)
  * convenient macro defined in comedidev.h.
  */
 	if (alloc_private(dev, sizeof(struct pcmmio_private)) < 0) {
-		printk("cannot allocate private data structure\n");
+		printk(KERN_ERR "comedi%d: cannot allocate private data structure\n",
+				dev->minor);
 		return -ENOMEM;
 	}
 
@@ -417,7 +418,8 @@ static int pcmmio_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	    kcalloc(n_subdevs, sizeof(struct pcmmio_subdev_private),
 		    GFP_KERNEL);
 	if (!devpriv->sprivs) {
-		printk("cannot allocate subdevice private data structures\n");
+		printk(KERN_ERR "comedi%d: cannot allocate subdevice private data structures\n",
+				dev->minor);
 		return -ENOMEM;
 	}
 	/*
@@ -427,7 +429,8 @@ static int pcmmio_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	 * Allocate 1 AI + 1 AO + 2 DIO subdevs (24 lines per DIO)
 	 */
 	if (alloc_subdevices(dev, n_subdevs) < 0) {
-		printk("cannot allocate subdevice data structures\n");
+		printk(KERN_ERR "comedi%d: cannot allocate subdevice data structures\n",
+				dev->minor);
 		return -ENOMEM;
 	}
 
@@ -557,14 +560,15 @@ static int pcmmio_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 				 */
 
 	if (irq[0]) {
-		printk("irq: %u ", irq[0]);
+		printk(KERN_DEBUG "comedi%d: irq: %u\n", dev->minor, irq[0]);
 		if (thisboard->dio_num_asics == 2 && irq[1])
-			printk("second ASIC irq: %u ", irq[1]);
+			printk(KERN_DEBUG "comedi%d: second ASIC irq: %u\n",
+					dev->minor, irq[1]);
 	} else {
-		printk("(IRQ mode disabled) ");
+		printk(KERN_INFO "comedi%d: (IRQ mode disabled)\n", dev->minor);
 	}
 
-	printk("attached\n");
+	printk(KERN_INFO "comedi%d: attached\n", dev->minor);
 
 	return 1;
 }
@@ -581,7 +585,7 @@ static int pcmmio_detach(struct comedi_device *dev)
 {
 	int i;
 
-	printk("comedi%d: %s: remove\n", dev->minor, driver.driver_name);
+	printk(KERN_INFO "comedi%d: %s: remove\n", dev->minor, driver.driver_name);
 	if (dev->iobase)
 		release_region(dev->iobase, thisboard->total_iosize);
 
@@ -622,7 +626,7 @@ static int pcmmio_dio_insn_bits(struct comedi_device *dev,
 
 #ifdef DAMMIT_ITS_BROKEN
 	/* DEBUG */
-	printk("write mask: %08x  data: %08x\n", data[0], data[1]);
+	printk(KERN_DEBUG "write mask: %08x  data: %08x\n", data[0], data[1]);
 #endif
 
 	s->state = 0;
@@ -644,9 +648,9 @@ static int pcmmio_dio_insn_bits(struct comedi_device *dev,
 #ifdef DAMMIT_ITS_BROKEN
 		/* DEBUG */
 		printk
-		    ("byte %d wmb %02x db %02x offset %02d io %04x, data_in %02x ",
-		     byte_no, (unsigned)write_mask_byte, (unsigned)data_byte,
-		     offset, ioaddr, (unsigned)byte);
+		    (KERN_DEBUG "byte %d wmb %02x db %02x offset %02d io %04x,"
+		     " data_in %02x ", byte_no, (unsigned)write_mask_byte,
+		     (unsigned)data_byte, offset, ioaddr, (unsigned)byte);
 #endif
 
 		if (write_mask_byte) {
@@ -674,7 +678,7 @@ static int pcmmio_dio_insn_bits(struct comedi_device *dev,
 
 #ifdef DAMMIT_ITS_BROKEN
 	/* DEBUG */
-	printk("s->state %08x data_out %08x\n", s->state, data[1]);
+	printk(KERN_DEBUG "s->state %08x data_out %08x\n", s->state, data[1]);
 #endif
 
 	return 2;
@@ -886,7 +890,7 @@ static irqreturn_t interrupt_pcmmio(int irq, void *d)
 				 * with commands..
 				 */
 				printk
-				    ("PCMMIO DEBUG: got edge detect interrupt %d asic %d which_chans: %06x\n",
+				    (KERN_DEBUG "got edge detect interrupt %d asic %d which_chans: %06x\n",
 				     irq, asic, triggered);
 				for (s = dev->subdevices + 2;
 				     s < dev->subdevices + dev->n_subdevices;
-- 
1.7.5.4

