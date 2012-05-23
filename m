Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933213Ab2EWAOU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 20:14:20 -0400
Received: from mail131.messagelabs.com ([216.82.242.99]:33852 "EHLO
	mail131.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753633Ab2EWAOT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 20:14:19 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-8.tower-131.messagelabs.com!1337732058!5643774!1
X-Originating-IP: [216.166.12.98]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] staging: comedi: remove this_board macro in the pcl816 driver
Date: Tue, 22 May 2012 17:14:14 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201205221714.14595.hartleys@visionengravers.com>
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

diff --git a/drivers/staging/comedi/drivers/pcl816.c b/drivers/staging/comedi/drivers/pcl816.c
index cc67b6d..277a23e 100644
--- a/drivers/staging/comedi/drivers/pcl816.c
+++ b/drivers/staging/comedi/drivers/pcl816.c
@@ -126,7 +126,6 @@ struct pcl816_board {
 };
 
 #define devpriv ((struct pcl816_private *)dev->private)
-#define this_board ((const struct pcl816_board *)dev->board_ptr)
 
 #ifdef unused
 static int RTC_lock;	/* RTC lock */
@@ -451,6 +450,7 @@ static void pcl816_cmdtest_out(int e, struct comedi_cmd *cmd)
 static int pcl816_ai_cmdtest(struct comedi_device *dev,
 			     struct comedi_subdevice *s, struct comedi_cmd *cmd)
 {
+	const struct pcl816_board *board = comedi_board(dev);
 	int err = 0;
 	int tmp, divisor1 = 0, divisor2 = 0;
 
@@ -531,8 +531,8 @@ static int pcl816_ai_cmdtest(struct comedi_device *dev,
 		err++;
 	}
 	if (cmd->convert_src == TRIG_TIMER) {
-		if (cmd->convert_arg < this_board->ai_ns_min) {
-			cmd->convert_arg = this_board->ai_ns_min;
+		if (cmd->convert_arg < board->ai_ns_min) {
+			cmd->convert_arg = board->ai_ns_min;
 			err++;
 		}
 	} else {		/* TRIG_EXT */
@@ -565,12 +565,12 @@ static int pcl816_ai_cmdtest(struct comedi_device *dev,
 	/* step 4: fix up any arguments */
 	if (cmd->convert_src == TRIG_TIMER) {
 		tmp = cmd->convert_arg;
-		i8253_cascade_ns_to_timer(this_board->i8254_osc_base,
+		i8253_cascade_ns_to_timer(board->i8254_osc_base,
 					  &divisor1, &divisor2,
 					  &cmd->convert_arg,
 					  cmd->flags & TRIG_ROUND_MASK);
-		if (cmd->convert_arg < this_board->ai_ns_min)
-			cmd->convert_arg = this_board->ai_ns_min;
+		if (cmd->convert_arg < board->ai_ns_min)
+			cmd->convert_arg = board->ai_ns_min;
 		if (tmp != cmd->convert_arg)
 			err++;
 	}
@@ -592,6 +592,7 @@ static int pcl816_ai_cmdtest(struct comedi_device *dev,
 
 static int pcl816_ai_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
 {
+	const struct pcl816_board *board = comedi_board(dev);
 	unsigned int divisor1 = 0, divisor2 = 0, dma_flags, bytes, dmairq;
 	struct comedi_cmd *cmd = &s->async->cmd;
 	unsigned int seglen;
@@ -609,10 +610,10 @@ static int pcl816_ai_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
 		return -EBUSY;
 
 	if (cmd->convert_src == TRIG_TIMER) {
-		if (cmd->convert_arg < this_board->ai_ns_min)
-			cmd->convert_arg = this_board->ai_ns_min;
+		if (cmd->convert_arg < board->ai_ns_min)
+			cmd->convert_arg = board->ai_ns_min;
 
-		i8253_cascade_ns_to_timer(this_board->i8254_osc_base, &divisor1,
+		i8253_cascade_ns_to_timer(board->i8254_osc_base, &divisor1,
 					  &divisor2, &cmd->convert_arg,
 					  cmd->flags & TRIG_ROUND_MASK);
 
@@ -1028,6 +1029,7 @@ static int set_rtc_irq_bit(unsigned char bit)
 
 static int pcl816_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 {
+	const struct pcl816_board *board = comedi_board(dev);
 	int ret;
 	unsigned long iobase;
 	unsigned int irq, dma;
@@ -1038,9 +1040,9 @@ static int pcl816_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	/* claim our I/O space */
 	iobase = it->options[0];
 	printk("comedi%d: pcl816:  board=%s, ioport=0x%03lx", dev->minor,
-	       this_board->name, iobase);
+	       board->name, iobase);
 
-	if (!request_region(iobase, this_board->io_range, "pcl816")) {
+	if (!request_region(iobase, board->io_range, "pcl816")) {
 		printk("I/O port conflict\n");
 		return -EIO;
 	}
@@ -1056,15 +1058,14 @@ static int pcl816_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	if (ret < 0)
 		return ret;	/* Can't alloc mem */
 
-	/* set up some name stuff */
-	dev->board_name = this_board->name;
+	dev->board_name = board->name;
 
 	/* grab our IRQ */
 	irq = 0;
-	if (this_board->IRQbits != 0) {	/* board support IRQ */
+	if (board->IRQbits != 0) {	/* board support IRQ */
 		irq = it->options[1];
 		if (irq) {	/* we want to use IRQ */
-			if (((1 << irq) & this_board->IRQbits) == 0) {
+			if (((1 << irq) & board->IRQbits) == 0) {
 				printk
 				    (", IRQ %u is out of allowed range, "
 				     "DISABLING IT", irq);
@@ -1134,12 +1135,12 @@ no_rtc:
 	if ((devpriv->irq_free == 0) && (devpriv->dma_rtc == 0))
 		goto no_dma;	/* if we haven't IRQ, we can't use DMA */
 
-	if (this_board->DMAbits != 0) {	/* board support DMA */
+	if (board->DMAbits != 0) {	/* board support DMA */
 		dma = it->options[2];
 		if (dma < 1)
 			goto no_dma;	/* DMA disabled */
 
-		if (((1 << dma) & this_board->DMAbits) == 0) {
+		if (((1 << dma) & board->DMAbits) == 0) {
 			printk(", DMA is out of allowed range, FAIL!\n");
 			return -EINVAL;	/* Bad DMA */
 		}
@@ -1185,11 +1186,11 @@ no_rtc:
 
 no_dma:
 
-/*  if (this_board->n_aochan > 0)
+/*  if (board->n_aochan > 0)
     subdevs[1] = COMEDI_SUBD_AO;
-  if (this_board->n_dichan > 0)
+  if (board->n_dichan > 0)
     subdevs[2] = COMEDI_SUBD_DI;
-  if (this_board->n_dochan > 0)
+  if (board->n_dochan > 0)
     subdevs[3] = COMEDI_SUBD_DO;
 */
 
@@ -1198,17 +1199,17 @@ no_dma:
 		return ret;
 
 	s = dev->subdevices + 0;
-	if (this_board->n_aichan > 0) {
+	if (board->n_aichan > 0) {
 		s->type = COMEDI_SUBD_AI;
 		devpriv->sub_ai = s;
 		dev->read_subdev = s;
 		s->subdev_flags = SDF_READABLE | SDF_CMD_READ;
-		s->n_chan = this_board->n_aichan;
+		s->n_chan = board->n_aichan;
 		s->subdev_flags |= SDF_DIFF;
 		/* printk (", %dchans DIFF DAC - %d", s->n_chan, i); */
-		s->maxdata = this_board->ai_maxdata;
-		s->len_chanlist = this_board->ai_chanlist;
-		s->range_table = this_board->ai_range_type;
+		s->maxdata = board->ai_maxdata;
+		s->len_chanlist = board->ai_chanlist;
+		s->range_table = board->ai_range_type;
 		s->cancel = pcl816_ai_cancel;
 		s->do_cmdtest = pcl816_ai_cmdtest;
 		s->do_cmd = pcl816_ai_cmd;
@@ -1221,25 +1222,25 @@ no_dma:
 #if 0
 case COMEDI_SUBD_AO:
 	s->subdev_flags = SDF_WRITABLE | SDF_GROUND;
-	s->n_chan = this_board->n_aochan;
-	s->maxdata = this_board->ao_maxdata;
-	s->len_chanlist = this_board->ao_chanlist;
-	s->range_table = this_board->ao_range_type;
+	s->n_chan = board->n_aochan;
+	s->maxdata = board->ao_maxdata;
+	s->len_chanlist = board->ao_chanlist;
+	s->range_table = board->ao_range_type;
 	break;
 
 case COMEDI_SUBD_DI:
 	s->subdev_flags = SDF_READABLE;
-	s->n_chan = this_board->n_dichan;
+	s->n_chan = board->n_dichan;
 	s->maxdata = 1;
-	s->len_chanlist = this_board->n_dichan;
+	s->len_chanlist = board->n_dichan;
 	s->range_table = &range_digital;
 	break;
 
 case COMEDI_SUBD_DO:
 	s->subdev_flags = SDF_WRITABLE;
-	s->n_chan = this_board->n_dochan;
+	s->n_chan = board->n_dochan;
 	s->maxdata = 1;
-	s->len_chanlist = this_board->n_dochan;
+	s->len_chanlist = board->n_dochan;
 	s->range_table = &range_digital;
 	break;
 #endif
@@ -1253,6 +1254,8 @@ case COMEDI_SUBD_DO:
 
 static void pcl816_detach(struct comedi_device *dev)
 {
+	const struct pcl816_board *board = comedi_board(dev);
+
 	if (dev->private) {
 		pcl816_ai_cancel(dev, devpriv->sub_ai);
 		pcl816_reset(dev);
@@ -1275,7 +1278,7 @@ static void pcl816_detach(struct comedi_device *dev)
 	if (dev->irq)
 		free_irq(dev->irq, dev);
 	if (dev->iobase)
-		release_region(dev->iobase, this_board->io_range);
+		release_region(dev->iobase, board->io_range);
 #ifdef unused
 	if (devpriv->dma_rtc)
 		RTC_lock--;
