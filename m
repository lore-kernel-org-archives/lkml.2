Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758607Ab2EWAy6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 20:54:58 -0400
Received: from mail160.messagelabs.com ([216.82.253.99]:24459 "EHLO
	mail160.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756837Ab2EWAy5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 20:54:57 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-3.tower-160.messagelabs.com!1337734495!7234196!1
X-Originating-IP: [216.166.12.178]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] staging: comedi: remove this_board macro in the poc driver
Date: Tue, 22 May 2012 17:54:46 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201205221754.47349.hartleys@visionengravers.com>
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

diff --git a/drivers/staging/comedi/drivers/poc.c b/drivers/staging/comedi/drivers/poc.c
index e712048..95e348f 100644
--- a/drivers/staging/comedi/drivers/poc.c
+++ b/drivers/staging/comedi/drivers/poc.c
@@ -57,8 +57,6 @@ struct boarddef_struct {
 	const struct comedi_lrange *range;
 };
 
-#define this_board ((const struct boarddef_struct *)dev->board_ptr)
-
 static int readback_insn(struct comedi_device *dev, struct comedi_subdevice *s,
 			 struct comedi_insn *insn, unsigned int *data)
 {
@@ -137,22 +135,23 @@ static int pcl734_insn_bits(struct comedi_device *dev,
 
 static int poc_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 {
+	const struct boarddef_struct *board = comedi_board(dev);
 	struct comedi_subdevice *s;
 	unsigned long iobase;
 	unsigned int iosize;
 
 	iobase = it->options[0];
 	printk(KERN_INFO "comedi%d: poc: using %s iobase 0x%lx\n", dev->minor,
-	       this_board->name, iobase);
+	       board->name, iobase);
 
-	dev->board_name = this_board->name;
+	dev->board_name = board->name;
 
 	if (iobase == 0) {
 		printk(KERN_ERR "io base address required\n");
 		return -EINVAL;
 	}
 
-	iosize = this_board->iosize;
+	iosize = board->iosize;
 	/* check if io addresses are available */
 	if (!request_region(iobase, iosize, "dac02")) {
 		printk(KERN_ERR "I/O port conflict: failed to allocate ports "
@@ -163,18 +162,18 @@ static int poc_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 
 	if (alloc_subdevices(dev, 1) < 0)
 		return -ENOMEM;
-	if (alloc_private(dev, sizeof(unsigned int) * this_board->n_chan) < 0)
+	if (alloc_private(dev, sizeof(unsigned int) * board->n_chan) < 0)
 		return -ENOMEM;
 
 	/* analog output subdevice */
 	s = dev->subdevices + 0;
-	s->type = this_board->type;
-	s->n_chan = this_board->n_chan;
-	s->maxdata = (1 << this_board->n_bits) - 1;
-	s->range_table = this_board->range;
-	s->insn_write = this_board->winsn;
-	s->insn_read = this_board->rinsn;
-	s->insn_bits = this_board->insnbits;
+	s->type = board->type;
+	s->n_chan = board->n_chan;
+	s->maxdata = (1 << board->n_bits) - 1;
+	s->range_table = board->range;
+	s->insn_write = board->winsn;
+	s->insn_read = board->rinsn;
+	s->insn_bits = board->insnbits;
 	if (s->type == COMEDI_SUBD_AO || s->type == COMEDI_SUBD_DO)
 		s->subdev_flags = SDF_WRITABLE;
 
@@ -183,8 +182,10 @@ static int poc_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 
 static void poc_detach(struct comedi_device *dev)
 {
+	const struct boarddef_struct *board = comedi_board(dev);
+
 	if (dev->iobase)
-		release_region(dev->iobase, this_board->iosize);
+		release_region(dev->iobase, board->iosize);
 }
 
 static const struct boarddef_struct boards[] = {
