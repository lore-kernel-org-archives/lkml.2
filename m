Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933384Ab2EWArL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 20:47:11 -0400
Received: from mail209.messagelabs.com ([216.82.255.3]:21564 "EHLO
	mail209.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755668Ab2EWArI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 20:47:08 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-13.tower-209.messagelabs.com!1337734027!6394392!1
X-Originating-IP: [216.166.12.98]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] staging: comedi: remove this_board macro in the pcmmio driver
Date: Tue, 22 May 2012 17:46:56 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201205221746.56949.hartleys@visionengravers.com>
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

diff --git a/drivers/staging/comedi/drivers/pcmmio.c b/drivers/staging/comedi/drivers/pcmmio.c
index efed168..c4482ae 100644
--- a/drivers/staging/comedi/drivers/pcmmio.c
+++ b/drivers/staging/comedi/drivers/pcmmio.c
@@ -183,11 +183,6 @@ static const struct comedi_lrange ranges_ao = {
 	  RANGE(-2.5, 2.5), RANGE(-2.5, 7.5)}
 };
 
-/*
- * Useful for shorthand access to the particular board structure
- */
-#define thisboard ((const struct pcmmio_board *)dev->board_ptr)
-
 /* this structure is for data unique to this subdevice.  */
 struct pcmmio_subdev_private {
 
@@ -423,7 +418,9 @@ static int pcmmio_dio_insn_config(struct comedi_device *dev,
 
 static void switch_page(struct comedi_device *dev, int asic, int page)
 {
-	if (asic < 0 || asic >= thisboard->dio_num_asics)
+	const struct pcmmio_board *board = comedi_board(dev);
+
+	if (asic < 0 || asic >= board->dio_num_asics)
 		return;		/* paranoia */
 	if (page < 0 || page >= NUM_PAGES)
 		return;		/* more paranoia */
@@ -439,9 +436,10 @@ static void switch_page(struct comedi_device *dev, int asic, int page)
 static void init_asics(struct comedi_device *dev)
 {				/* sets up an
 				   ASIC chip to defaults */
+	const struct pcmmio_board *board = comedi_board(dev);
 	int asic;
 
-	for (asic = 0; asic < thisboard->dio_num_asics; ++asic) {
+	for (asic = 0; asic < board->dio_num_asics; ++asic) {
 		int port, page;
 		unsigned long baseaddr = devpriv->asics[asic].iobase;
 
@@ -476,7 +474,9 @@ static void init_asics(struct comedi_device *dev)
 #ifdef notused
 static void lock_port(struct comedi_device *dev, int asic, int port)
 {
-	if (asic < 0 || asic >= thisboard->dio_num_asics)
+	const struct pcmmio_board *board = comedi_board(dev);
+
+	if (asic < 0 || asic >= board->dio_num_asics)
 		return;		/* paranoia */
 	if (port < 0 || port >= PORTS_PER_ASIC)
 		return;		/* more paranoia */
@@ -490,7 +490,9 @@ static void lock_port(struct comedi_device *dev, int asic, int port)
 
 static void unlock_port(struct comedi_device *dev, int asic, int port)
 {
-	if (asic < 0 || asic >= thisboard->dio_num_asics)
+	const struct pcmmio_board *board = comedi_board(dev);
+
+	if (asic < 0 || asic >= board->dio_num_asics)
 		return;		/* paranoia */
 	if (port < 0 || port >= PORTS_PER_ASIC)
 		return;		/* more paranoia */
@@ -1012,6 +1014,7 @@ static int ao_winsn(struct comedi_device *dev, struct comedi_subdevice *s,
 
 static int pcmmio_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 {
+	const struct pcmmio_board *board = comedi_board(dev);
 	struct comedi_subdevice *s;
 	int sdev_no, chans_left, n_dio_subdevs, n_subdevs, port, asic,
 	    thisasic_chanct = 0;
@@ -1027,17 +1030,13 @@ static int pcmmio_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	dev->iobase = iobase;
 
 	if (!iobase || !request_region(iobase,
-				       thisboard->total_iosize,
+				       board->total_iosize,
 				       dev->driver->driver_name)) {
 		printk(KERN_ERR "comedi%d: I/O port conflict\n", dev->minor);
 		return -EIO;
 	}
 
-/*
- * Initialize dev->board_name.  Note that we can use the "thisboard"
- * macro now, since we just initialized it in the last line.
- */
-	dev->board_name = thisboard->name;
+	dev->board_name = board->name;
 
 /*
  * Allocate the private structure area.  alloc_private() is a
@@ -1061,7 +1060,7 @@ static int pcmmio_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 		spin_lock_init(&devpriv->asics[asic].spinlock);
 	}
 
-	chans_left = CHANS_PER_ASIC * thisboard->dio_num_asics;
+	chans_left = CHANS_PER_ASIC * board->dio_num_asics;
 	n_dio_subdevs = CALC_N_DIO_SUBDEVS(chans_left);
 	n_subdevs = n_dio_subdevs + 2;
 	devpriv->sprivs =
@@ -1088,13 +1087,13 @@ static int pcmmio_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	sdev_no = 0;
 	s = dev->subdevices + sdev_no;
 	s->private = devpriv->sprivs + sdev_no;
-	s->maxdata = (1 << thisboard->ai_bits) - 1;
-	s->range_table = thisboard->ai_range_table;
+	s->maxdata = (1 << board->ai_bits) - 1;
+	s->range_table = board->ai_range_table;
 	s->subdev_flags = SDF_READABLE | SDF_GROUND | SDF_DIFF;
 	s->type = COMEDI_SUBD_AI;
-	s->n_chan = thisboard->n_ai_chans;
+	s->n_chan = board->n_ai_chans;
 	s->len_chanlist = s->n_chan;
-	s->insn_read = thisboard->ai_rinsn;
+	s->insn_read = board->ai_rinsn;
 	subpriv->iobase = dev->iobase + 0;
 	/* initialize the resource enable register by clearing it */
 	outb(0, subpriv->iobase + 3);
@@ -1104,14 +1103,14 @@ static int pcmmio_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	++sdev_no;
 	s = dev->subdevices + sdev_no;
 	s->private = devpriv->sprivs + sdev_no;
-	s->maxdata = (1 << thisboard->ao_bits) - 1;
-	s->range_table = thisboard->ao_range_table;
+	s->maxdata = (1 << board->ao_bits) - 1;
+	s->range_table = board->ao_range_table;
 	s->subdev_flags = SDF_READABLE;
 	s->type = COMEDI_SUBD_AO;
-	s->n_chan = thisboard->n_ao_chans;
+	s->n_chan = board->n_ao_chans;
 	s->len_chanlist = s->n_chan;
-	s->insn_read = thisboard->ao_rinsn;
-	s->insn_write = thisboard->ao_winsn;
+	s->insn_read = board->ao_rinsn;
+	s->insn_write = board->ao_winsn;
 	subpriv->iobase = dev->iobase + 8;
 	/* initialize the resource enable register by clearing it */
 	outb(0, subpriv->iobase + 3);
@@ -1192,7 +1191,7 @@ static int pcmmio_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	for (asic = 0; irq[0] && asic < MAX_ASICS; ++asic) {
 		if (irq[asic]
 		    && request_irq(irq[asic], interrupt_pcmmio,
-				   IRQF_SHARED, thisboard->name, dev)) {
+				   IRQF_SHARED, board->name, dev)) {
 			int i;
 			/* unroll the allocated irqs.. */
 			for (i = asic - 1; i >= 0; --i) {
@@ -1211,7 +1210,7 @@ static int pcmmio_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 
 	if (irq[0]) {
 		printk(KERN_DEBUG "comedi%d: irq: %u\n", dev->minor, irq[0]);
-		if (thisboard->dio_num_asics == 2 && irq[1])
+		if (board->dio_num_asics == 2 && irq[1])
 			printk(KERN_DEBUG "comedi%d: second ASIC irq: %u\n",
 					dev->minor, irq[1]);
 	} else {
@@ -1225,10 +1224,11 @@ static int pcmmio_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 
 static void pcmmio_detach(struct comedi_device *dev)
 {
+	const struct pcmmio_board *board = comedi_board(dev);
 	int i;
 
 	if (dev->iobase)
-		release_region(dev->iobase, thisboard->total_iosize);
+		release_region(dev->iobase, board->total_iosize);
 	for (i = 0; i < MAX_ASICS; ++i) {
 		if (devpriv && devpriv->asics[i].irq)
 			free_irq(devpriv->asics[i].irq, dev);
