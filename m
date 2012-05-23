Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933371Ab2EWADd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 20:03:33 -0400
Received: from mail209.messagelabs.com ([216.82.255.3]:25674 "EHLO
	mail209.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757606Ab2EWADb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 20:03:31 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-5.tower-209.messagelabs.com!1337731410!6391190!1
X-Originating-IP: [216.166.12.31]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] staging: comedi: remove this_board macro in the pcl730 driver
Date: Tue, 22 May 2012 17:03:19 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201205221703.19953.hartleys@visionengravers.com>
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

diff --git a/drivers/staging/comedi/drivers/pcl730.c b/drivers/staging/comedi/drivers/pcl730.c
index e11704a..02a4386 100644
--- a/drivers/staging/comedi/drivers/pcl730.c
+++ b/drivers/staging/comedi/drivers/pcl730.c
@@ -32,8 +32,6 @@ struct pcl730_board {
 	unsigned int io_range;	/*  len of I/O space */
 };
 
-#define this_board ((const struct pcl730_board *)dev->board_ptr)
-
 static int pcl730_do_insn(struct comedi_device *dev, struct comedi_subdevice *s,
 			  struct comedi_insn *insn, unsigned int *data)
 {
@@ -70,19 +68,20 @@ static int pcl730_di_insn(struct comedi_device *dev, struct comedi_subdevice *s,
 
 static int pcl730_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 {
+	const struct pcl730_board *board = comedi_board(dev);
 	struct comedi_subdevice *s;
 	unsigned long iobase;
 	unsigned int iorange;
 
 	iobase = it->options[0];
-	iorange = this_board->io_range;
+	iorange = board->io_range;
 	printk(KERN_INFO "comedi%d: pcl730: board=%s 0x%04lx ", dev->minor,
-	       this_board->name, iobase);
+	       board->name, iobase);
 	if (!request_region(iobase, iorange, "pcl730")) {
 		printk("I/O port conflict\n");
 		return -EIO;
 	}
-	dev->board_name = this_board->name;
+	dev->board_name = board->name;
 	dev->iobase = iobase;
 	dev->irq = 0;
 
@@ -136,8 +135,10 @@ static int pcl730_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 
 static void pcl730_detach(struct comedi_device *dev)
 {
+	const struct pcl730_board *board = comedi_board(dev);
+
 	if (dev->iobase)
-		release_region(dev->iobase, this_board->io_range);
+		release_region(dev->iobase, board->io_range);
 }
 
 static const struct pcl730_board boardtypes[] = {
