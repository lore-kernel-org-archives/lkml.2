Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755612Ab2HTVap (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 17:30:45 -0400
Received: from mail160.messagelabs.com ([216.82.253.99]:4947 "EHLO
	mail160.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754941Ab2HTVaj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 17:30:39 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-15.tower-160.messagelabs.com!1345498237!8984279!3
X-Originating-IP: [216.166.12.72]
X-StarScan-Received: 
X-StarScan-Version: 6.6.1.2; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/4] staging: comedi: comedi_parport: cleanup dev->board_name
Date: Mon, 20 Aug 2012 14:30:27 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201208201430.27730.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the 'dev->driver->driver_name' for the 'dev->board_name'. And use
the 'dev->board_name' for the resource name passed to request_region
and request_irq.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/comedi_parport.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/comedi/drivers/comedi_parport.c b/drivers/staging/comedi/drivers/comedi_parport.c
index fcad423..fc59cb2 100644
--- a/drivers/staging/comedi/drivers/comedi_parport.c
+++ b/drivers/staging/comedi/drivers/comedi_parport.c
@@ -302,9 +302,11 @@ static int parport_attach(struct comedi_device *dev,
 	unsigned long iobase;
 	struct comedi_subdevice *s;
 
+	dev->board_name = dev->driver->driver_name;
+
 	iobase = it->options[0];
 	printk(KERN_INFO "comedi%d: parport: 0x%04lx ", dev->minor, iobase);
-	if (!request_region(iobase, PARPORT_SIZE, "parport (comedi)")) {
+	if (!request_region(iobase, PARPORT_SIZE, dev->board_name)) {
 		printk(KERN_ERR "I/O port conflict\n");
 		return -EIO;
 	}
@@ -313,7 +315,7 @@ static int parport_attach(struct comedi_device *dev,
 	irq = it->options[1];
 	if (irq) {
 		printk(KERN_INFO " irq=%u", irq);
-		ret = request_irq(irq, parport_interrupt, 0, "comedi_parport",
+		ret = request_irq(irq, parport_interrupt, 0, dev->board_name,
 				  dev);
 		if (ret < 0) {
 			printk(KERN_ERR " irq not available\n");
@@ -321,7 +323,6 @@ static int parport_attach(struct comedi_device *dev,
 		}
 		dev->irq = irq;
 	}
-	dev->board_name = "parport";
 
 	ret = comedi_alloc_subdevices(dev, 4);
 	if (ret)
-- 
1.7.11

