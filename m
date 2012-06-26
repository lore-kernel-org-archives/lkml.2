Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758041Ab2FZAMG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 20:12:06 -0400
Received: from mail160.messagelabs.com ([216.82.253.99]:28368 "EHLO
	mail160.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757958Ab2FZAMD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 20:12:03 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-4.tower-160.messagelabs.com!1340669521!6880181!3
X-Originating-IP: [216.166.12.180]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 22/33] staging: comedi: cb_das16_cs: probe for the device first
Date: Mon, 25 Jun 2012 17:11:56 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201206251711.57432.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

During the attach of the comedi_driver, the device type probe
can fail. We should do the probe before requesting the irq
for the driver.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Frank Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/cb_das16_cs.c | 16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/comedi/drivers/cb_das16_cs.c b/drivers/staging/comedi/drivers/cb_das16_cs.c
index 2d8ec68..20d77cf 100644
--- a/drivers/staging/comedi/drivers/cb_das16_cs.c
+++ b/drivers/staging/comedi/drivers/cb_das16_cs.c
@@ -454,6 +454,13 @@ static int das16cs_attach(struct comedi_device *dev,
 	if (!link)
 		return -EIO;
 
+	dev->board_ptr = das16cs_probe(dev, link);
+	if (!dev->board_ptr)
+		return -EIO;
+	thisboard = comedi_board(dev);
+
+	dev->board_name = thisboard->name;
+
 	dev->iobase = link->resource[0]->start;
 	dev_dbg(dev->class_dev, "I/O base=0x%04lx\n", dev->iobase);
 
@@ -461,23 +468,14 @@ static int das16cs_attach(struct comedi_device *dev,
 	for (i = 0; i < 48; i += 2)
 		dev_dbg(dev->class_dev, "%04x\n", inw(dev->iobase + i));
 
-
 	ret = request_irq(link->irq, das16cs_interrupt,
 			  IRQF_SHARED, "cb_das16_cs", dev);
 	if (ret < 0)
 		return ret;
-
 	dev->irq = link->irq;
 
 	dev_dbg(dev->class_dev, "irq=%u\n", dev->irq);
 
-	dev->board_ptr = das16cs_probe(dev, link);
-	if (!dev->board_ptr)
-		return -EIO;
-	thisboard = comedi_board(dev);
-
-	dev->board_name = thisboard->name;
-
 	if (alloc_private(dev, sizeof(struct das16cs_private)) < 0)
 		return -ENOMEM;
 
-- 
1.7.11

