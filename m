Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758696Ab2EWBUl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 21:20:41 -0400
Received: from mail160.messagelabs.com ([216.82.253.99]:59185 "EHLO
	mail160.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753038Ab2EWBUj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 21:20:39 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-12.tower-160.messagelabs.com!1337736017!7266581!4
X-Originating-IP: [216.166.12.99]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] staging: comedi: remove this_board macro in the s526 driver
Date: Tue, 22 May 2012 18:20:10 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201205221820.10770.hartleys@visionengravers.com>
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

diff --git a/drivers/staging/comedi/drivers/s526.c b/drivers/staging/comedi/drivers/s526.c
index 7a56434..3c8e979 100644
--- a/drivers/staging/comedi/drivers/s526.c
+++ b/drivers/staging/comedi/drivers/s526.c
@@ -200,11 +200,6 @@ static const struct s526_board s526_boards[] = {
 #define ADDR_REG(reg) (dev->iobase + (reg))
 #define ADDR_CHAN_REG(reg, chan) (dev->iobase + (reg) + (chan) * 8)
 
-/*
- * Useful for shorthand access to the particular board structure
- */
-#define thisboard ((const struct s526_board *)dev->board_ptr)
-
 /* this structure is for data unique to this hardware driver.  If
    several hardware drivers keep similar information in this structure,
    feel free to suggest moving the variable to the struct comedi_device
@@ -744,6 +739,7 @@ static int s526_dio_insn_config(struct comedi_device *dev,
 
 static int s526_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 {
+	const struct s526_board *board = comedi_board(dev);
 	struct comedi_subdevice *s;
 	int iobase;
 	int i, n;
@@ -754,7 +750,7 @@ static int s526_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	printk(KERN_INFO "comedi%d: s526: ", dev->minor);
 
 	iobase = it->options[0];
-	if (!iobase || !request_region(iobase, S526_IOSIZE, thisboard->name)) {
+	if (!iobase || !request_region(iobase, S526_IOSIZE, board->name)) {
 		comedi_error(dev, "I/O port conflict");
 		return -EIO;
 	}
@@ -769,13 +765,7 @@ static int s526_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	}
 	***/
 
-/*
- * Initialize dev->board_name.  Note that we can use the "thisboard"
- * macro now, since we just initialized it in the last line.
- */
-	dev->board_ptr = &s526_boards[0];
-
-	dev->board_name = thisboard->name;
+	dev->board_name = board->name;
 
 /*
  * Allocate the private structure area.  alloc_private() is a
@@ -797,7 +787,7 @@ static int s526_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	s->type = COMEDI_SUBD_COUNTER;
 	s->subdev_flags = SDF_READABLE | SDF_WRITABLE | SDF_LSAMPL;
 	/* KG: What does SDF_LSAMPL (see multiq3.c) mean? */
-	s->n_chan = thisboard->gpct_chans;
+	s->n_chan = board->gpct_chans;
 	s->maxdata = 0x00ffffff;	/* 24 bit counter */
 	s->insn_read = s526_gpct_rinsn;
 	s->insn_config = s526_gpct_insn_config;
@@ -838,7 +828,7 @@ static int s526_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 
 	s = dev->subdevices + 3;
 	/* digital i/o subdevice */
-	if (thisboard->have_dio) {
+	if (board->have_dio) {
 		s->type = COMEDI_SUBD_DIO;
 		s->subdev_flags = SDF_READABLE | SDF_WRITABLE;
 		s->n_chan = 8;
