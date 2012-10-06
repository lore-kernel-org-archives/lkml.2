Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752358Ab2JFFwm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Oct 2012 01:52:42 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:34629 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752064Ab2JFFwk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Oct 2012 01:52:40 -0400
From: YAMANE Toshiaki <yamanetoshi@gmail.com>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: Ian Abbott <abbotti@mev.co.uk>,
        Frank Mori Hess <fmhess@users.sourceforge.net>,
        linux-kernel@vger.kernel.org, YAMANE Toshiaki <yamanetoshi@gmail.com>
Subject: [PATCH] staging/comedi: Use dev_ printks in drivers/quatech_daqp_cs.c
Date: Sat,  6 Oct 2012 14:52:34 +0900
Message-Id: <1349502754-8775-1-git-send-email-yamanetoshi@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fixed below checkpatch warnings.
- WARNING: Prefer netdev_info(netdev, ... then dev_info(dev, ... then pr_info(...  to printk(KERN_INFO ...
- WARNING: Prefer netdev_warn(netdev, ... then dev_warn(dev, ... then pr_warn(...  to printk(KERN_WARNING ...
- WARNING: Prefer netdev_err(netdev, ... then dev_err(dev, ... then pr_err(...  to printk(KERN_ERR ...
- WARNING: Prefer netdev_info(netdev, ... then dev_info(dev, ... then pr_info(...  to printk(KERN_INFO ...
- WARNING: Prefer netdev_notice(netdev, ... then dev_notice(dev, ... then pr_notice(...  to printk(KERN_NOTICE ...

and added pr_fmt.

Signed-off-by: YAMANE Toshiaki <yamanetoshi@gmail.com>
---
 drivers/staging/comedi/drivers/quatech_daqp_cs.c |   34 ++++++++++------------
 1 file changed, 16 insertions(+), 18 deletions(-)

diff --git a/drivers/staging/comedi/drivers/quatech_daqp_cs.c b/drivers/staging/comedi/drivers/quatech_daqp_cs.c
index 3e276f7..d15bd8a 100644
--- a/drivers/staging/comedi/drivers/quatech_daqp_cs.c
+++ b/drivers/staging/comedi/drivers/quatech_daqp_cs.c
@@ -47,6 +47,8 @@ Status: works
 Devices: [Quatech] DAQP-208 (daqp), DAQP-308
 */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include "../comedidev.h"
 #include <linux/semaphore.h>
 
@@ -195,8 +197,8 @@ static struct comedi_driver driver_daqp = {
 
 static void daqp_dump(struct comedi_device *dev)
 {
-	printk(KERN_INFO "DAQP: status %02x; aux status %02x\n",
-	       inb(dev->iobase + DAQP_STATUS), inb(dev->iobase + DAQP_AUX));
+	dev_info(dev->class_dev, "status %02x; aux status %02x\n",
+		 inb(dev->iobase + DAQP_STATUS), inb(dev->iobase + DAQP_AUX));
 }
 
 static void hex_dump(char *str, void *ptr, int len)
@@ -255,33 +257,29 @@ static enum irqreturn daqp_interrupt(int irq, void *dev_id)
 	int status;
 
 	if (local == NULL) {
-		printk(KERN_WARNING
-		       "daqp_interrupt(): irq %d for unknown device.\n", irq);
+		pr_warn("irq %d for unknown device.\n", irq);
 		return IRQ_NONE;
 	}
 
 	dev = local->dev;
 	if (dev == NULL) {
-		printk(KERN_WARNING "daqp_interrupt(): NULL comedi_device.\n");
+		pr_warn("NULL comedi_device.\n");
 		return IRQ_NONE;
 	}
 
 	if (!dev->attached) {
-		printk(KERN_WARNING
-		       "daqp_interrupt(): struct comedi_device not yet attached.\n");
+		pr_warn("struct comedi_device not yet attached.\n");
 		return IRQ_NONE;
 	}
 
 	s = local->s;
 	if (s == NULL) {
-		printk(KERN_WARNING
-		       "daqp_interrupt(): NULL comedi_subdevice.\n");
+		pr_warn("NULL comedi_subdevice.\n");
 		return IRQ_NONE;
 	}
 
 	if ((struct local_info_t *)s->private != local) {
-		printk(KERN_WARNING
-		       "daqp_interrupt(): invalid comedi_subdevice.\n");
+		pr_warn("invalid comedi_subdevice.\n");
 		return IRQ_NONE;
 	}
 
@@ -331,8 +329,8 @@ static enum irqreturn daqp_interrupt(int irq, void *dev_id)
 		}
 
 		if (loop_limit <= 0) {
-			printk(KERN_WARNING
-			       "loop_limit reached in daqp_interrupt()\n");
+			dev_warn(dev->class_dev,
+				 "loop_limit reached in daqp_interrupt()\n");
 			daqp_ai_cancel(dev, s);
 			s->async->events |= COMEDI_CB_EOA | COMEDI_CB_ERROR;
 		}
@@ -736,8 +734,8 @@ static int daqp_ai_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
 	while (--counter
 	       && (inb(dev->iobase + DAQP_STATUS) & DAQP_STATUS_EVENTS)) ;
 	if (!counter) {
-		printk(KERN_ERR
-		       "daqp: couldn't clear interrupts in status register\n");
+		dev_err(dev->class_dev,
+			"couldn't clear interrupts in status register\n");
 		return -1;
 	}
 
@@ -852,8 +850,8 @@ static int daqp_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	if (ret)
 		return ret;
 
-	printk(KERN_INFO "comedi%d: attaching daqp%d (io 0x%04lx)\n",
-	       dev->minor, it->options[0], dev->iobase);
+	dev_info(dev->class_dev, "attaching daqp%d (io 0x%04lx)\n",
+		 it->options[0], dev->iobase);
 
 	s = &dev->subdevices[0];
 	dev->read_subdev = s;
@@ -958,7 +956,7 @@ static int daqp_cs_attach(struct pcmcia_device *link)
 		if (dev_table[i] == NULL)
 			break;
 	if (i == MAX_DEV) {
-		printk(KERN_NOTICE "daqp_cs: no devices available\n");
+		dev_notice(&link->dev, "no devices available\n");
 		return -ENODEV;
 	}
 
-- 
1.7.9.5

