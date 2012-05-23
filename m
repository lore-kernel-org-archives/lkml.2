Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758014Ab2EWAXH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 20:23:07 -0400
Received: from mail132.messagelabs.com ([216.82.242.115]:61835 "EHLO
	mail132.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753531Ab2EWAXE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 20:23:04 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-14.tower-132.messagelabs.com!1337732541!12445780!15
X-Originating-IP: [216.166.12.178]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] staging: comedi: remove this_board macro in the pcl818 driver
Date: Tue, 22 May 2012 17:22:48 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201205221722.48945.hartleys@visionengravers.com>
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

diff --git a/drivers/staging/comedi/drivers/pcl818.c b/drivers/staging/comedi/drivers/pcl818.c
index 1406c97..6c84b29 100644
--- a/drivers/staging/comedi/drivers/pcl818.c
+++ b/drivers/staging/comedi/drivers/pcl818.c
@@ -326,7 +326,6 @@ static const unsigned int muxonechan[] = { 0x00, 0x11, 0x22, 0x33, 0x44, 0x55, 0
 };
 
 #define devpriv ((struct pcl818_private *)dev->private)
-#define this_board ((const struct pcl818_board *)dev->board_ptr)
 
 /*
 ==============================================================================
@@ -1264,6 +1263,7 @@ static int check_single_ended(unsigned int port)
 static int ai_cmdtest(struct comedi_device *dev, struct comedi_subdevice *s,
 		      struct comedi_cmd *cmd)
 {
+	const struct pcl818_board *board = comedi_board(dev);
 	int err = 0;
 	int tmp, divisor1 = 0, divisor2 = 0;
 
@@ -1334,8 +1334,8 @@ static int ai_cmdtest(struct comedi_device *dev, struct comedi_subdevice *s,
 	}
 
 	if (cmd->convert_src == TRIG_TIMER) {
-		if (cmd->convert_arg < this_board->ns_min) {
-			cmd->convert_arg = this_board->ns_min;
+		if (cmd->convert_arg < board->ns_min) {
+			cmd->convert_arg = board->ns_min;
 			err++;
 		}
 	} else {		/* TRIG_EXT */
@@ -1371,8 +1371,8 @@ static int ai_cmdtest(struct comedi_device *dev, struct comedi_subdevice *s,
 		i8253_cascade_ns_to_timer(devpriv->i8253_osc_base, &divisor1,
 					  &divisor2, &cmd->convert_arg,
 					  cmd->flags & TRIG_ROUND_MASK);
-		if (cmd->convert_arg < this_board->ns_min)
-			cmd->convert_arg = this_board->ns_min;
+		if (cmd->convert_arg < board->ns_min)
+			cmd->convert_arg = board->ns_min;
 		if (tmp != cmd->convert_arg)
 			err++;
 	}
@@ -1519,6 +1519,8 @@ static int pcl818_check(unsigned long iobase)
 */
 static void pcl818_reset(struct comedi_device *dev)
 {
+	const struct pcl818_board *board = comedi_board(dev);
+
 	if (devpriv->usefifo) {	/*  FIFO shutdown */
 		outb(0, dev->iobase + PCL818_FI_INTCLR);
 		outb(0, dev->iobase + PCL818_FI_FLUSH);
@@ -1537,7 +1539,7 @@ static void pcl818_reset(struct comedi_device *dev)
 	outb(0xb0, dev->iobase + PCL818_CTRCTL);	/* Stop pacer */
 	outb(0x70, dev->iobase + PCL818_CTRCTL);
 	outb(0x30, dev->iobase + PCL818_CTRCTL);
-	if (this_board->is_818) {
+	if (board->is_818) {
 		outb(0, dev->iobase + PCL818_RANGE);
 	} else {
 		outb(0, dev->iobase + PCL718_DA2_LO);
@@ -1636,6 +1638,7 @@ static int rtc_setfreq_irq(int freq)
 
 static int pcl818_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 {
+	const struct pcl818_board *board = comedi_board(dev);
 	int ret;
 	unsigned long iobase;
 	unsigned int irq;
@@ -1651,9 +1654,10 @@ static int pcl818_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	iobase = it->options[0];
 	printk
 	    ("comedi%d: pcl818:  board=%s, ioport=0x%03lx",
-	     dev->minor, this_board->name, iobase);
-	devpriv->io_range = this_board->io_range;
-	if ((this_board->fifo) && (it->options[2] == -1)) {	/*  we've board with FIFO and we want to use FIFO */
+	     dev->minor, board->name, iobase);
+	devpriv->io_range = board->io_range;
+	if ((board->fifo) && (it->options[2] == -1)) {
+		/*  we've board with FIFO and we want to use FIFO */
 		devpriv->io_range = PCLx1xFIFO_RANGE;
 		devpriv->usefifo = 1;
 	}
@@ -1669,14 +1673,14 @@ static int pcl818_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 		return -EIO;
 	}
 
-	/* set up some name stuff */
-	dev->board_name = this_board->name;
+	dev->board_name = board->name;
+
 	/* grab our IRQ */
 	irq = 0;
-	if (this_board->IRQbits != 0) {	/* board support IRQ */
+	if (board->IRQbits != 0) {	/* board support IRQ */
 		irq = it->options[1];
 		if (irq) {	/* we want to use IRQ */
-			if (((1 << irq) & this_board->IRQbits) == 0) {
+			if (((1 << irq) & board->IRQbits) == 0) {
 				printk
 				    (", IRQ %u is out of allowed range, DISABLING IT",
 				     irq);
@@ -1740,11 +1744,11 @@ no_rtc:
 	devpriv->dma = dma;
 	if ((devpriv->irq_free == 0) && (devpriv->dma_rtc == 0))
 		goto no_dma;	/* if we haven't IRQ, we can't use DMA */
-	if (this_board->DMAbits != 0) {	/* board support DMA */
+	if (board->DMAbits != 0) {	/* board support DMA */
 		dma = it->options[2];
 		if (dma < 1)
 			goto no_dma;	/* DMA disabled */
-		if (((1 << dma) & this_board->DMAbits) == 0) {
+		if (((1 << dma) & board->DMAbits) == 0) {
 			printk(KERN_ERR "DMA is out of allowed range, FAIL!\n");
 			return -EINVAL;	/* Bad DMA */
 		}
@@ -1779,24 +1783,24 @@ no_dma:
 		return ret;
 
 	s = dev->subdevices + 0;
-	if (!this_board->n_aichan_se) {
+	if (!board->n_aichan_se) {
 		s->type = COMEDI_SUBD_UNUSED;
 	} else {
 		s->type = COMEDI_SUBD_AI;
 		devpriv->sub_ai = s;
 		s->subdev_flags = SDF_READABLE;
 		if (check_single_ended(dev->iobase)) {
-			s->n_chan = this_board->n_aichan_se;
+			s->n_chan = board->n_aichan_se;
 			s->subdev_flags |= SDF_COMMON | SDF_GROUND;
 			printk(", %dchans S.E. DAC", s->n_chan);
 		} else {
-			s->n_chan = this_board->n_aichan_diff;
+			s->n_chan = board->n_aichan_diff;
 			s->subdev_flags |= SDF_DIFF;
 			printk(", %dchans DIFF DAC", s->n_chan);
 		}
-		s->maxdata = this_board->ai_maxdata;
+		s->maxdata = board->ai_maxdata;
 		s->len_chanlist = s->n_chan;
-		s->range_table = this_board->ai_range_type;
+		s->range_table = board->ai_range_type;
 		s->cancel = pcl818_ai_cancel;
 		s->insn_read = pcl818_ai_insn_read;
 		if ((irq) || (devpriv->dma_rtc)) {
@@ -1805,7 +1809,7 @@ no_dma:
 			s->do_cmdtest = ai_cmdtest;
 			s->do_cmd = ai_cmd;
 		}
-		if (this_board->is_818) {
+		if (board->is_818) {
 			if ((it->options[4] == 1) || (it->options[4] == 10))
 				s->range_table = &range_pcl818l_h_ai;	/*  secondary range list jumper selectable */
 		} else {
@@ -1845,15 +1849,15 @@ no_dma:
 	}
 
 	s = dev->subdevices + 1;
-	if (!this_board->n_aochan) {
+	if (!board->n_aochan) {
 		s->type = COMEDI_SUBD_UNUSED;
 	} else {
 		s->type = COMEDI_SUBD_AO;
 		s->subdev_flags = SDF_WRITABLE | SDF_GROUND;
-		s->n_chan = this_board->n_aochan;
-		s->maxdata = this_board->ao_maxdata;
-		s->len_chanlist = this_board->n_aochan;
-		s->range_table = this_board->ao_range_type;
+		s->n_chan = board->n_aochan;
+		s->maxdata = board->ao_maxdata;
+		s->len_chanlist = board->n_aochan;
+		s->range_table = board->ao_range_type;
 		s->insn_read = pcl818_ao_insn_read;
 		s->insn_write = pcl818_ao_insn_write;
 #ifdef unused
@@ -1864,7 +1868,7 @@ no_dma:
 		}
 #endif
 #endif
-		if (this_board->is_818) {
+		if (board->is_818) {
 			if ((it->options[4] == 1) || (it->options[4] == 10))
 				s->range_table = &range_unipolar10;
 			if (it->options[4] == 2)
@@ -1878,27 +1882,27 @@ no_dma:
 	}
 
 	s = dev->subdevices + 2;
-	if (!this_board->n_dichan) {
+	if (!board->n_dichan) {
 		s->type = COMEDI_SUBD_UNUSED;
 	} else {
 		s->type = COMEDI_SUBD_DI;
 		s->subdev_flags = SDF_READABLE;
-		s->n_chan = this_board->n_dichan;
+		s->n_chan = board->n_dichan;
 		s->maxdata = 1;
-		s->len_chanlist = this_board->n_dichan;
+		s->len_chanlist = board->n_dichan;
 		s->range_table = &range_digital;
 		s->insn_bits = pcl818_di_insn_bits;
 	}
 
 	s = dev->subdevices + 3;
-	if (!this_board->n_dochan) {
+	if (!board->n_dochan) {
 		s->type = COMEDI_SUBD_UNUSED;
 	} else {
 		s->type = COMEDI_SUBD_DO;
 		s->subdev_flags = SDF_WRITABLE;
-		s->n_chan = this_board->n_dochan;
+		s->n_chan = board->n_dochan;
 		s->maxdata = 1;
-		s->len_chanlist = this_board->n_dochan;
+		s->len_chanlist = board->n_dochan;
 		s->range_table = &range_digital;
 		s->insn_bits = pcl818_do_insn_bits;
 	}
@@ -1910,9 +1914,9 @@ no_dma:
 		devpriv->i8253_osc_base = 1000;
 
 	/* max sampling speed */
-	devpriv->ns_min = this_board->ns_min;
+	devpriv->ns_min = board->ns_min;
 
-	if (!this_board->is_818) {
+	if (!board->is_818) {
 		if ((it->options[6] == 1) || (it->options[6] == 100))
 			devpriv->ns_min = 10000;	/* extended PCL718 to 100kHz DAC */
 	}
