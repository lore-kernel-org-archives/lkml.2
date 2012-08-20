Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755627Ab2HTVbA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 17:31:00 -0400
Received: from mail209.messagelabs.com ([216.82.255.3]:31962 "EHLO
	mail209.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755300Ab2HTVa6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 17:30:58 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-11.tower-209.messagelabs.com!1345498239!3790891!34
X-Originating-IP: [216.166.12.31]
X-StarScan-Received: 
X-StarScan-Version: 6.6.1.2; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/4] staging: comedi: comedi_parport: cleanup 'attach' printk's
Date: Mon, 20 Aug 2012 14:30:53 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201208201430.53543.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert the printk messages in the 'attach' to dev_printk messages.
Consolidate the attach message into one message after the device
is attached.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/comedi_parport.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/comedi/drivers/comedi_parport.c b/drivers/staging/comedi/drivers/comedi_parport.c
index fc59cb2..48d529e 100644
--- a/drivers/staging/comedi/drivers/comedi_parport.c
+++ b/drivers/staging/comedi/drivers/comedi_parport.c
@@ -305,20 +305,18 @@ static int parport_attach(struct comedi_device *dev,
 	dev->board_name = dev->driver->driver_name;
 
 	iobase = it->options[0];
-	printk(KERN_INFO "comedi%d: parport: 0x%04lx ", dev->minor, iobase);
 	if (!request_region(iobase, PARPORT_SIZE, dev->board_name)) {
-		printk(KERN_ERR "I/O port conflict\n");
+		dev_err(dev->class_dev, "I/O port conflict\n");
 		return -EIO;
 	}
 	dev->iobase = iobase;
 
 	irq = it->options[1];
 	if (irq) {
-		printk(KERN_INFO " irq=%u", irq);
 		ret = request_irq(irq, parport_interrupt, 0, dev->board_name,
 				  dev);
 		if (ret < 0) {
-			printk(KERN_ERR " irq not available\n");
+			dev_err(dev->class_dev, "irq not available\n");
 			return -EINVAL;
 		}
 		dev->irq = irq;
@@ -379,8 +377,10 @@ static int parport_attach(struct comedi_device *dev,
 	devpriv->c_data = 0;
 	outb(devpriv->c_data, dev->iobase + PARPORT_C);
 
-	printk(KERN_INFO "\n");
-	return 1;
+	dev_info(dev->class_dev, "%s: iobase=0x%04lx, irq %sabled",
+		dev->board_name, dev->iobase, dev->irq ? "en" : "dis");
+
+	return 0;
 }
 
 static void parport_detach(struct comedi_device *dev)
-- 
1.7.11

