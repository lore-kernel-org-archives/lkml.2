Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933019Ab1JXRw2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 13:52:28 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:43717 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932216Ab1JXRw1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 13:52:27 -0400
From: Johannes Thumshirn <morbidrsa@googlemail.com>
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        morbidrsa@googlemail.com, abbotti@mev.co.uk,
        fmhess@users.sourceforge.net, lucas.demarchi@profusion.mobi
Subject: [PATCH] staging: comedi: Unbreak output of printk()s in pcmmio
Date: Mon, 24 Oct 2011 19:52:31 +0200
Message-Id: <1319478751-2644-1-git-send-email-morbidrsa@googlemail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <20111017221024.GA26595@kroah.com>
References: <20111017221024.GA26595@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Unbreak the output of some printk()s I broke.

Signed-off-by: Johannes Thumshirn <morbidrsa@googlemail.com>
---
 drivers/staging/comedi/drivers/pcmmio.c |   26 +++++++++++++++-----------
 1 files changed, 15 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/comedi/drivers/pcmmio.c b/drivers/staging/comedi/drivers/pcmmio.c
index 3ad04aa..b9ca040 100644
--- a/drivers/staging/comedi/drivers/pcmmio.c
+++ b/drivers/staging/comedi/drivers/pcmmio.c
@@ -371,15 +371,15 @@ static int pcmmio_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	iobase = it->options[0];
 	irq[0] = it->options[1];
 
-	printk(KERN_INFO "comedi%d: %s: io: %lx ", dev->minor, driver.driver_name,
-	       iobase);
+	printk(KERN_INFO "comedi%d: %s: io: %lx attaching...\n", dev->minor,
+			driver.driver_name, iobase);
 
 	dev->iobase = iobase;
 
 	if (!iobase || !request_region(iobase,
 				       thisboard->total_iosize,
 				       driver.driver_name)) {
-		printk(KERN_ERR "I/O port conflict\n");
+		printk(KERN_ERR "comedi%d: I/O port conflict\n", dev->minor);
 		return -EIO;
 	}
 
@@ -394,7 +394,8 @@ static int pcmmio_attach(struct comedi_device *dev, struct comedi_devconfig *it)
  * convenient macro defined in comedidev.h.
  */
 	if (alloc_private(dev, sizeof(struct pcmmio_private)) < 0) {
-		printk(KERN_ERR "cannot allocate private data structure\n");
+		printk(KERN_ERR "comedi%d: cannot allocate private data structure\n",
+				dev->minor);
 		return -ENOMEM;
 	}
 
@@ -417,7 +418,8 @@ static int pcmmio_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	    kcalloc(n_subdevs, sizeof(struct pcmmio_subdev_private),
 		    GFP_KERNEL);
 	if (!devpriv->sprivs) {
-		printk(KERN_ERR "cannot allocate subdevice private data structures\n");
+		printk(KERN_ERR "comedi%d: cannot allocate subdevice private data structures\n",
+				dev->minor);
 		return -ENOMEM;
 	}
 	/*
@@ -427,7 +429,8 @@ static int pcmmio_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	 * Allocate 1 AI + 1 AO + 2 DIO subdevs (24 lines per DIO)
 	 */
 	if (alloc_subdevices(dev, n_subdevs) < 0) {
-		printk(KERN_ERR "cannot allocate subdevice data structures\n");
+		printk(KERN_ERR "comedi%d: cannot allocate subdevice data structures\n",
+				dev->minor);
 		return -ENOMEM;
 	}
 
@@ -557,14 +560,15 @@ static int pcmmio_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 				 */
 
 	if (irq[0]) {
-		printk(KERN_DEBUG "irq: %u ", irq[0]);
+		printk(KERN_DEBUG "comedi%d: irq: %u\n", dev->minor, irq[0]);
 		if (thisboard->dio_num_asics == 2 && irq[1])
-			printk(KERN_DEBUG "second ASIC irq: %u ", irq[1]);
+			printk(KERN_DEBUG "comedi%d: second ASIC irq: %u\n",
+					dev->minor, irq[1]);
 	} else {
-		printk(KERN_INFO "(IRQ mode disabled) ");
+		printk(KERN_INFO "comedi%d: (IRQ mode disabled)\n", dev->minor);
 	}
 
-	printk(KERN_INFO "attached\n");
+	printk(KERN_INFO "comedi%d: attached\n", dev->minor);
 
 	return 1;
 }
@@ -663,7 +667,7 @@ static int pcmmio_dio_insn_bits(struct comedi_device *dev,
 		}
 #ifdef DAMMIT_ITS_BROKEN
 		/* DEBUG */
-		printk(KERN_DEBUG "data_out_byte %02x\n", (unsigned)byte);
+		printk("data_out_byte %02x\n", (unsigned)byte);
 #endif
 		/* save the digital input lines for this byte.. */
 		s->state |= ((unsigned int)byte) << offset;
-- 
1.7.5.4

