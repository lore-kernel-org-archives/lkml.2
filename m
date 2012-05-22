Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758220Ab2EVXXt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 19:23:49 -0400
Received: from mail160.messagelabs.com ([216.82.253.99]:36396 "EHLO
	mail160.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753944Ab2EVXXc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 19:23:32 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-7.tower-160.messagelabs.com!1337729010!4571636!2
X-Originating-IP: [216.166.12.72]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] staging: comedi: remove thisboard macro in the dmm32at driver
Date: Tue, 22 May 2012 16:23:09 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201205221623.09635.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The 'thisboard' macro depends on having a local variable with
a magic name. The CodingStyle document suggests not doing this
to avoid confusion. Remove the macro and use the comedi_board()
inline helper to get the dev->board_ptr information.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---

diff --git a/drivers/staging/comedi/drivers/dmm32at.c b/drivers/staging/comedi/drivers/dmm32at.c
index 8382890..5be99b5 100644
--- a/drivers/staging/comedi/drivers/dmm32at.c
+++ b/drivers/staging/comedi/drivers/dmm32at.c
@@ -189,11 +189,6 @@ static const struct dmm32at_board dmm32at_boards[] = {
 	 },
 };
 
-/*
- * Useful for shorthand access to the particular board structure
- */
-#define thisboard ((const struct dmm32at_board *)dev->board_ptr)
-
 /* this structure is for data unique to this hardware driver.  If
  * several hardware drivers keep similar information in this structure,
  * feel free to suggest moving the variable to the struct comedi_device struct.
@@ -290,6 +285,7 @@ void dmm32at_setaitimer(struct comedi_device *dev, unsigned int nansec);
 static int dmm32at_attach(struct comedi_device *dev,
 			  struct comedi_devconfig *it)
 {
+	const struct dmm32at_board *board = comedi_board(dev);
 	int ret;
 	struct comedi_subdevice *s;
 	unsigned char aihi, ailo, fifostat, aistat, intstat, airback;
@@ -304,7 +300,7 @@ static int dmm32at_attach(struct comedi_device *dev,
 	       iobase, irq);
 
 	/* register address space */
-	if (!request_region(iobase, DMM32AT_MEMSIZE, thisboard->name)) {
+	if (!request_region(iobase, DMM32AT_MEMSIZE, board->name)) {
 		printk(KERN_ERR "comedi%d: dmm32at: I/O port conflict\n",
 		       dev->minor);
 		return -EIO;
@@ -358,7 +354,7 @@ static int dmm32at_attach(struct comedi_device *dev,
 
 	/* board is there, register interrupt */
 	if (irq) {
-		ret = request_irq(irq, dmm32at_isr, 0, thisboard->name, dev);
+		ret = request_irq(irq, dmm32at_isr, 0, board->name, dev);
 		if (ret < 0) {
 			printk(KERN_ERR "dmm32at: irq conflict\n");
 			return ret;
@@ -366,18 +362,7 @@ static int dmm32at_attach(struct comedi_device *dev,
 		dev->irq = irq;
 	}
 
-/*
- * If you can probe the device to determine what device in a series
- * it is, this is the place to do it.  Otherwise, dev->board_ptr
- * should already be initialized.
- */
-	/* dev->board_ptr = dmm32at_probe(dev); */
-
-/*
- * Initialize dev->board_name.  Note that we can use the "thisboard"
- * macro now, since we just initialized it in the last line.
- */
-	dev->board_name = thisboard->name;
+	dev->board_name = board->name;
 
 /*
  * Allocate the private structure area.  alloc_private() is a
@@ -399,9 +384,9 @@ static int dmm32at_attach(struct comedi_device *dev,
 	s->type = COMEDI_SUBD_AI;
 	/* we support single-ended (ground) and differential */
 	s->subdev_flags = SDF_READABLE | SDF_GROUND | SDF_DIFF | SDF_CMD_READ;
-	s->n_chan = thisboard->ai_chans;
-	s->maxdata = (1 << thisboard->ai_bits) - 1;
-	s->range_table = thisboard->ai_ranges;
+	s->n_chan = board->ai_chans;
+	s->maxdata = (1 << board->ai_bits) - 1;
+	s->range_table = board->ai_ranges;
 	s->len_chanlist = 32;	/* This is the maximum chanlist length that
 				   the board can handle */
 	s->insn_read = dmm32at_ai_rinsn;
@@ -413,15 +398,15 @@ static int dmm32at_attach(struct comedi_device *dev,
 	/* analog output subdevice */
 	s->type = COMEDI_SUBD_AO;
 	s->subdev_flags = SDF_WRITABLE;
-	s->n_chan = thisboard->ao_chans;
-	s->maxdata = (1 << thisboard->ao_bits) - 1;
-	s->range_table = thisboard->ao_ranges;
+	s->n_chan = board->ao_chans;
+	s->maxdata = (1 << board->ao_bits) - 1;
+	s->range_table = board->ao_ranges;
 	s->insn_write = dmm32at_ao_winsn;
 	s->insn_read = dmm32at_ao_rinsn;
 
 	s = dev->subdevices + 2;
 	/* digital i/o subdevice */
-	if (thisboard->have_dio) {
+	if (board->have_dio) {
 
 		/* get access to the DIO regs */
 		dmm_outb(dev, DMM32AT_CNTRL, DMM32AT_DIOACC);
@@ -433,7 +418,7 @@ static int dmm32at_attach(struct comedi_device *dev,
 		/* set up the subdevice */
 		s->type = COMEDI_SUBD_DIO;
 		s->subdev_flags = SDF_READABLE | SDF_WRITABLE;
-		s->n_chan = thisboard->dio_chans;
+		s->n_chan = board->dio_chans;
 		s->maxdata = 1;
 		s->state = 0;
 		s->range_table = &range_digital;
