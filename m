Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933297Ab2EWAAX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 20:00:23 -0400
Received: from mail160.messagelabs.com ([216.82.253.99]:19821 "EHLO
	mail160.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932839Ab2EWAAV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 20:00:21 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-15.tower-160.messagelabs.com!1337731207!7247697!16
X-Originating-IP: [216.166.12.97]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] staging: comedi: remove this_board macro in the pcl726 driver
Date: Tue, 22 May 2012 16:59:57 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201205221659.58115.hartleys@visionengravers.com>
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

diff --git a/drivers/staging/comedi/drivers/pcl726.c b/drivers/staging/comedi/drivers/pcl726.c
index d25c30c..e9449bb 100644
--- a/drivers/staging/comedi/drivers/pcl726.c
+++ b/drivers/staging/comedi/drivers/pcl726.c
@@ -145,8 +145,6 @@ static const struct pcl726_board boardtypes[] = {
 	 &rangelist_728[0],},
 };
 
-#define this_board ((const struct pcl726_board *)dev->board_ptr)
-
 struct pcl726_private {
 
 	int bipolar[12];
@@ -197,11 +195,13 @@ static int pcl726_di_insn_bits(struct comedi_device *dev,
 			       struct comedi_subdevice *s,
 			       struct comedi_insn *insn, unsigned int *data)
 {
+	const struct pcl726_board *board = comedi_board(dev);
+
 	if (insn->n != 2)
 		return -EINVAL;
 
-	data[1] = inb(dev->iobase + this_board->di_lo) |
-	    (inb(dev->iobase + this_board->di_hi) << 8);
+	data[1] = inb(dev->iobase + board->di_lo) |
+	    (inb(dev->iobase + board->di_hi) << 8);
 
 	return 2;
 }
@@ -210,6 +210,8 @@ static int pcl726_do_insn_bits(struct comedi_device *dev,
 			       struct comedi_subdevice *s,
 			       struct comedi_insn *insn, unsigned int *data)
 {
+	const struct pcl726_board *board = comedi_board(dev);
+
 	if (insn->n != 2)
 		return -EINVAL;
 
@@ -218,9 +220,9 @@ static int pcl726_do_insn_bits(struct comedi_device *dev,
 		s->state |= data[0] & data[1];
 	}
 	if (data[1] & 0x00ff)
-		outb(s->state & 0xff, dev->iobase + this_board->do_lo);
+		outb(s->state & 0xff, dev->iobase + board->do_lo);
 	if (data[1] & 0xff00)
-		outb((s->state >> 8), dev->iobase + this_board->do_hi);
+		outb((s->state >> 8), dev->iobase + board->do_hi);
 
 	data[1] = s->state;
 
@@ -229,6 +231,7 @@ static int pcl726_do_insn_bits(struct comedi_device *dev,
 
 static int pcl726_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 {
+	const struct pcl726_board *board = comedi_board(dev);
 	struct comedi_subdevice *s;
 	unsigned long iobase;
 	unsigned int iorange;
@@ -238,9 +241,9 @@ static int pcl726_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 #endif
 
 	iobase = it->options[0];
-	iorange = this_board->io_range;
+	iorange = board->io_range;
 	printk(KERN_WARNING "comedi%d: pcl726: board=%s, 0x%03lx ", dev->minor,
-	       this_board->name, iobase);
+	       board->name, iobase);
 	if (!request_region(iobase, iorange, "pcl726")) {
 		printk(KERN_WARNING "I/O port conflict\n");
 		return -EIO;
@@ -248,7 +251,7 @@ static int pcl726_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 
 	dev->iobase = iobase;
 
-	dev->board_name = this_board->name;
+	dev->board_name = board->name;
 
 	ret = alloc_private(dev, sizeof(struct pcl726_private));
 	if (ret < 0)
@@ -297,23 +300,23 @@ static int pcl726_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	/* ao */
 	s->type = COMEDI_SUBD_AO;
 	s->subdev_flags = SDF_WRITABLE | SDF_GROUND;
-	s->n_chan = this_board->n_aochan;
+	s->n_chan = board->n_aochan;
 	s->maxdata = 0xfff;
 	s->len_chanlist = 1;
 	s->insn_write = pcl726_ao_insn;
 	s->insn_read = pcl726_ao_insn_read;
 	s->range_table_list = devpriv->rangelist;
-	for (i = 0; i < this_board->n_aochan; i++) {
+	for (i = 0; i < board->n_aochan; i++) {
 		int j;
 
 		j = it->options[2 + 1];
-		if ((j < 0) || (j >= this_board->num_of_ranges)) {
+		if ((j < 0) || (j >= board->num_of_ranges)) {
 			printk
 			    ("Invalid range for channel %d! Must be 0<=%d<%d\n",
-			     i, j, this_board->num_of_ranges - 1);
+			     i, j, board->num_of_ranges - 1);
 			j = 0;
 		}
-		devpriv->rangelist[i] = this_board->range_type_list[j];
+		devpriv->rangelist[i] = board->range_type_list[j];
 		if (devpriv->rangelist[i]->range[0].min ==
 		    -devpriv->rangelist[i]->range[0].max)
 			devpriv->bipolar[i] = 1;	/* bipolar range */
@@ -321,7 +324,7 @@ static int pcl726_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 
 	s = dev->subdevices + 1;
 	/* di */
-	if (!this_board->have_dio) {
+	if (!board->have_dio) {
 		s->type = COMEDI_SUBD_UNUSED;
 	} else {
 		s->type = COMEDI_SUBD_DI;
@@ -335,7 +338,7 @@ static int pcl726_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 
 	s = dev->subdevices + 2;
 	/* do */
-	if (!this_board->have_dio) {
+	if (!board->have_dio) {
 		s->type = COMEDI_SUBD_UNUSED;
 	} else {
 		s->type = COMEDI_SUBD_DO;
@@ -352,12 +355,14 @@ static int pcl726_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 
 static void pcl726_detach(struct comedi_device *dev)
 {
+	const struct pcl726_board *board = comedi_board(dev);
+
 #ifdef ACL6126_IRQ
 	if (dev->irq)
 		free_irq(dev->irq, dev);
 #endif
 	if (dev->iobase)
-		release_region(dev->iobase, this_board->io_range);
+		release_region(dev->iobase, board->io_range);
 }
 
 static struct comedi_driver pcl726_driver = {
