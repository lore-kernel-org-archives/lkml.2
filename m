Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965265Ab2EVXzz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 19:55:55 -0400
Received: from mail209.messagelabs.com ([216.82.255.3]:49498 "EHLO
	mail209.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932839Ab2EVXzx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 19:55:53 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-5.tower-209.messagelabs.com!1337730952!6390713!1
X-Originating-IP: [216.166.12.97]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] staging: comedi: remove this_board macro in the pcl724 driver
Date: Tue, 22 May 2012 16:55:37 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201205221655.37737.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The 'this_board' macro depends on having a local variable with
a magic name. The CodingStyle document suggests not doing this
to avoid confusion. Remove the macro and use the comedi_board()
inline helper to get the dev->board_ptr information.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---

diff --git a/drivers/staging/comedi/drivers/pcl724.c b/drivers/staging/comedi/drivers/pcl724.c
index 1f66fe1..4136a03 100644
--- a/drivers/staging/comedi/drivers/pcl724.c
+++ b/drivers/staging/comedi/drivers/pcl724.c
@@ -67,8 +67,6 @@ struct pcl724_board {
 	char is_pet48;
 };
 
-#define this_board ((const struct pcl724_board *)dev->board_ptr)
-
 static int subdev_8255_cb(int dir, int port, int data, unsigned long arg)
 {
 	unsigned long iobase = arg;
@@ -100,6 +98,7 @@ static int subdev_8255mapped_cb(int dir, int port, int data,
 
 static int pcl724_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 {
+	const struct pcl724_board *board = comedi_board(dev);
 	unsigned long iobase;
 	unsigned int iorange;
 	int ret, i, n_subdevices;
@@ -108,12 +107,12 @@ static int pcl724_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 #endif
 
 	iobase = it->options[0];
-	iorange = this_board->io_range;
-	if ((this_board->can_have96) && ((it->options[1] == 1)
+	iorange = board->io_range;
+	if ((board->can_have96) && ((it->options[1] == 1)
 					 || (it->options[1] == 96)))
 		iorange = PCL722_96_SIZE; /* PCL-724 in 96 DIO configuration */
 	printk(KERN_INFO "comedi%d: pcl724: board=%s, 0x%03lx ", dev->minor,
-	       this_board->name, iobase);
+	       board->name, iobase);
 	if (!request_region(iobase, iorange, "pcl724")) {
 		printk("I/O port conflict\n");
 		return -EIO;
@@ -121,14 +120,14 @@ static int pcl724_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 
 	dev->iobase = iobase;
 
-	dev->board_name = this_board->name;
+	dev->board_name = board->name;
 
 #ifdef PCL724_IRQ
 	irq = 0;
-	if (this_board->IRQbits != 0) {	/* board support IRQ */
+	if (board->IRQbits != 0) {	/* board support IRQ */
 		irq = it->options[1];
 		if (irq) {	/* we want to use IRQ */
-			if (((1 << irq) & this_board->IRQbits) == 0) {
+			if (((1 << irq) & board->IRQbits) == 0) {
 				printk(KERN_WARNING
 				       ", IRQ %u is out of allowed range, "
 				       "DISABLING IT", irq);
@@ -152,8 +151,8 @@ static int pcl724_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 
 	printk("\n");
 
-	n_subdevices = this_board->numofports;
-	if ((this_board->can_have96) && ((it->options[1] == 1)
+	n_subdevices = board->numofports;
+	if ((board->can_have96) && ((it->options[1] == 1)
 					 || (it->options[1] == 96)))
 		n_subdevices = 4;	/*  PCL-724 in 96 DIO configuration */
 
@@ -162,7 +161,7 @@ static int pcl724_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 		return ret;
 
 	for (i = 0; i < dev->n_subdevices; i++) {
-		if (this_board->is_pet48) {
+		if (board->is_pet48) {
 			subdev_8255_init(dev, dev->subdevices + i,
 					 subdev_8255mapped_cb,
 					 (unsigned long)(dev->iobase +
@@ -179,6 +178,7 @@ static int pcl724_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 
 static void pcl724_detach(struct comedi_device *dev)
 {
+	const struct pcl724_board *board = comedi_board(dev);
 	int i;
 
 	for (i = 0; i < dev->n_subdevices; i++)
@@ -187,7 +187,7 @@ static void pcl724_detach(struct comedi_device *dev)
 	if (dev->irq)
 		free_irq(dev->irq, dev);
 #endif
-	release_region(dev->iobase, this_board->io_range);
+	release_region(dev->iobase, board->io_range);
 }
 
 static const struct pcl724_board boardtypes[] = {
