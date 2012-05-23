Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933358Ab2EWAJL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 20:09:11 -0400
Received: from mail160.messagelabs.com ([216.82.253.99]:11165 "EHLO
	mail160.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756958Ab2EWAJI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 20:09:08 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-10.tower-160.messagelabs.com!1337731747!4583940!1
X-Originating-IP: [216.166.12.31]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] staging: comedi: remove this_board macro in the pcl812 driver
Date: Tue, 22 May 2012 17:09:03 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201205221709.04219.hartleys@visionengravers.com>
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

diff --git a/drivers/staging/comedi/drivers/pcl812.c b/drivers/staging/comedi/drivers/pcl812.c
index 51f4ca9..28780ed 100644
--- a/drivers/staging/comedi/drivers/pcl812.c
+++ b/drivers/staging/comedi/drivers/pcl812.c
@@ -336,8 +336,6 @@ struct pcl812_board {
 	unsigned char haveMPC508;	/*  1=board use MPC508A multiplexor */
 };
 
-#define this_board ((const struct pcl812_board *)dev->board_ptr)
-
 struct pcl812_private {
 
 	unsigned char valid;	/*  =1 device is OK */
@@ -560,6 +558,7 @@ static void pcl812_cmdtest_out(int e, struct comedi_cmd *cmd)
 static int pcl812_ai_cmdtest(struct comedi_device *dev,
 			     struct comedi_subdevice *s, struct comedi_cmd *cmd)
 {
+	const struct pcl812_board *board = comedi_board(dev);
 	int err = 0;
 	int tmp, divisor1, divisor2;
 
@@ -666,8 +665,8 @@ static int pcl812_ai_cmdtest(struct comedi_device *dev,
 	}
 
 	if (cmd->convert_src == TRIG_TIMER) {
-		if (cmd->convert_arg < this_board->ai_ns_min) {
-			cmd->convert_arg = this_board->ai_ns_min;
+		if (cmd->convert_arg < board->ai_ns_min) {
+			cmd->convert_arg = board->ai_ns_min;
 			err++;
 		}
 	} else {		/* TRIG_EXT */
@@ -682,7 +681,7 @@ static int pcl812_ai_cmdtest(struct comedi_device *dev,
 		err++;
 	}
 	if (cmd->chanlist_len > MAX_CHANLIST_LEN) {
-		cmd->chanlist_len = this_board->n_aichan;
+		cmd->chanlist_len = board->n_aichan;
 		err++;
 	}
 	if (cmd->scan_end_arg != cmd->chanlist_len) {
@@ -715,11 +714,11 @@ static int pcl812_ai_cmdtest(struct comedi_device *dev,
 
 	if (cmd->convert_src == TRIG_TIMER) {
 		tmp = cmd->convert_arg;
-		i8253_cascade_ns_to_timer(this_board->i8254_osc_base, &divisor1,
+		i8253_cascade_ns_to_timer(board->i8254_osc_base, &divisor1,
 					  &divisor2, &cmd->convert_arg,
 					  cmd->flags & TRIG_ROUND_MASK);
-		if (cmd->convert_arg < this_board->ai_ns_min)
-			cmd->convert_arg = this_board->ai_ns_min;
+		if (cmd->convert_arg < board->ai_ns_min)
+			cmd->convert_arg = board->ai_ns_min;
 		if (tmp != cmd->convert_arg)
 			err++;
 	}
@@ -741,6 +740,7 @@ static int pcl812_ai_cmdtest(struct comedi_device *dev,
 */
 static int pcl812_ai_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
 {
+	const struct pcl812_board *board = comedi_board(dev);
 	unsigned int divisor1 = 0, divisor2 = 0, i, dma_flags, bytes;
 	struct comedi_cmd *cmd = &s->async->cmd;
 
@@ -767,9 +767,9 @@ static int pcl812_ai_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
 		return -EINVAL;
 
 	if (cmd->convert_src == TRIG_TIMER) {
-		if (cmd->convert_arg < this_board->ai_ns_min)
-			cmd->convert_arg = this_board->ai_ns_min;
-		i8253_cascade_ns_to_timer(this_board->i8254_osc_base,
+		if (cmd->convert_arg < board->ai_ns_min)
+			cmd->convert_arg = board->ai_ns_min;
+		i8253_cascade_ns_to_timer(board->i8254_osc_base,
 					  &divisor1, &divisor2,
 					  &cmd->convert_arg,
 					  cmd->flags & TRIG_ROUND_MASK);
@@ -1192,6 +1192,7 @@ static void start_pacer(struct comedi_device *dev, int mode,
 */
 static void free_resources(struct comedi_device *dev)
 {
+	const struct pcl812_board *board = comedi_board(dev);
 
 	if (dev->private) {
 		if (devpriv->dmabuf[0])
@@ -1204,7 +1205,7 @@ static void free_resources(struct comedi_device *dev)
 	if (dev->irq)
 		free_irq(dev->irq, dev);
 	if (dev->iobase)
-		release_region(dev->iobase, this_board->io_range);
+		release_region(dev->iobase, board->io_range);
 }
 
 /*
@@ -1234,6 +1235,8 @@ static int pcl812_ai_cancel(struct comedi_device *dev,
 */
 static void pcl812_reset(struct comedi_device *dev)
 {
+	const struct pcl812_board *board = comedi_board(dev);
+
 #ifdef PCL812_EXTDEBUG
 	printk(KERN_DEBUG "pcl812 EDBG: BGN: pcl812_reset(...)\n");
 #endif
@@ -1242,7 +1245,7 @@ static void pcl812_reset(struct comedi_device *dev)
 	devpriv->old_chan_reg = -1;	/*  invalidate chain/gain memory */
 	devpriv->old_gain_reg = -1;
 
-	switch (this_board->board_type) {
+	switch (board->board_type) {
 	case boardPCL812PG:
 	case boardPCL812:
 	case boardACL8112:
@@ -1273,6 +1276,7 @@ static void pcl812_reset(struct comedi_device *dev)
 
 static int pcl812_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 {
+	const struct pcl812_board *board = comedi_board(dev);
 	int ret, subdev;
 	unsigned long iobase;
 	unsigned int irq;
@@ -1283,9 +1287,9 @@ static int pcl812_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 
 	iobase = it->options[0];
 	printk(KERN_INFO "comedi%d: pcl812:  board=%s, ioport=0x%03lx",
-	       dev->minor, this_board->name, iobase);
+	       dev->minor, board->name, iobase);
 
-	if (!request_region(iobase, this_board->io_range, "pcl812")) {
+	if (!request_region(iobase, board->io_range, "pcl812")) {
 		printk("I/O port conflict\n");
 		return -EIO;
 	}
@@ -1297,13 +1301,13 @@ static int pcl812_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 		return ret;	/* Can't alloc mem */
 	}
 
-	dev->board_name = this_board->name;
+	dev->board_name = board->name;
 
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
@@ -1328,9 +1332,9 @@ static int pcl812_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	devpriv->dma = dma;
 	if (!dev->irq)
 		goto no_dma;	/* if we haven't IRQ, we can't use DMA */
-	if (this_board->DMAbits != 0) {	/* board support DMA */
+	if (board->DMAbits != 0) {	/* board support DMA */
 		dma = it->options[2];
-		if (((1 << dma) & this_board->DMAbits) == 0) {
+		if (((1 << dma) & board->DMAbits) == 0) {
 			printk(", DMA is out of allowed range, FAIL!\n");
 			return -EINVAL;	/* Bad DMA */
 		}
@@ -1369,13 +1373,13 @@ static int pcl812_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 no_dma:
 
 	n_subdevices = 0;
-	if (this_board->n_aichan > 0)
+	if (board->n_aichan > 0)
 		n_subdevices++;
-	if (this_board->n_aochan > 0)
+	if (board->n_aochan > 0)
 		n_subdevices++;
-	if (this_board->n_dichan > 0)
+	if (board->n_dichan > 0)
 		n_subdevices++;
-	if (this_board->n_dochan > 0)
+	if (board->n_dochan > 0)
 		n_subdevices++;
 
 	ret = alloc_subdevices(dev, n_subdevices);
@@ -1387,46 +1391,46 @@ no_dma:
 	subdev = 0;
 
 	/* analog input */
-	if (this_board->n_aichan > 0) {
+	if (board->n_aichan > 0) {
 		s = dev->subdevices + subdev;
 		s->type = COMEDI_SUBD_AI;
 		s->subdev_flags = SDF_READABLE;
-		switch (this_board->board_type) {
+		switch (board->board_type) {
 		case boardA821:
 			if (it->options[2] == 1) {
-				s->n_chan = this_board->n_aichan_diff;
+				s->n_chan = board->n_aichan_diff;
 				s->subdev_flags |= SDF_DIFF;
 				devpriv->use_diff = 1;
 			} else {
-				s->n_chan = this_board->n_aichan;
+				s->n_chan = board->n_aichan;
 				s->subdev_flags |= SDF_GROUND;
 			}
 			break;
 		case boardACL8112:
 		case boardACL8216:
 			if (it->options[4] == 1) {
-				s->n_chan = this_board->n_aichan_diff;
+				s->n_chan = board->n_aichan_diff;
 				s->subdev_flags |= SDF_DIFF;
 				devpriv->use_diff = 1;
 			} else {
-				s->n_chan = this_board->n_aichan;
+				s->n_chan = board->n_aichan;
 				s->subdev_flags |= SDF_GROUND;
 			}
 			break;
 		default:
-			s->n_chan = this_board->n_aichan;
+			s->n_chan = board->n_aichan;
 			s->subdev_flags |= SDF_GROUND;
 			break;
 		}
-		s->maxdata = this_board->ai_maxdata;
+		s->maxdata = board->ai_maxdata;
 		s->len_chanlist = MAX_CHANLIST_LEN;
-		s->range_table = this_board->rangelist_ai;
-		if (this_board->board_type == boardACL8216)
+		s->range_table = board->rangelist_ai;
+		if (board->board_type == boardACL8216)
 			s->insn_read = acl8216_ai_insn_read;
 		else
 			s->insn_read = pcl812_ai_insn_read;
 
-		devpriv->use_MPC = this_board->haveMPC508;
+		devpriv->use_MPC = board->haveMPC508;
 		s->cancel = pcl812_ai_cancel;
 		if (dev->irq) {
 			dev->read_subdev = s;
@@ -1435,7 +1439,7 @@ no_dma:
 			s->do_cmd = pcl812_ai_cmd;
 			s->poll = pcl812_ai_poll;
 		}
-		switch (this_board->board_type) {
+		switch (board->board_type) {
 		case boardPCL812PG:
 			if (it->options[4] == 1)
 				s->range_table = &range_pcl812pg2_ai;
@@ -1529,17 +1533,17 @@ no_dma:
 	}
 
 	/* analog output */
-	if (this_board->n_aochan > 0) {
+	if (board->n_aochan > 0) {
 		s = dev->subdevices + subdev;
 		s->type = COMEDI_SUBD_AO;
 		s->subdev_flags = SDF_WRITABLE | SDF_GROUND;
-		s->n_chan = this_board->n_aochan;
+		s->n_chan = board->n_aochan;
 		s->maxdata = 0xfff;
 		s->len_chanlist = 1;
-		s->range_table = this_board->rangelist_ao;
+		s->range_table = board->rangelist_ao;
 		s->insn_read = pcl812_ao_insn_read;
 		s->insn_write = pcl812_ao_insn_write;
-		switch (this_board->board_type) {
+		switch (board->board_type) {
 		case boardA821:
 			if (it->options[3] == 1)
 				s->range_table = &range_unipolar10;
@@ -1558,32 +1562,32 @@ no_dma:
 	}
 
 	/* digital input */
-	if (this_board->n_dichan > 0) {
+	if (board->n_dichan > 0) {
 		s = dev->subdevices + subdev;
 		s->type = COMEDI_SUBD_DI;
 		s->subdev_flags = SDF_READABLE;
-		s->n_chan = this_board->n_dichan;
+		s->n_chan = board->n_dichan;
 		s->maxdata = 1;
-		s->len_chanlist = this_board->n_dichan;
+		s->len_chanlist = board->n_dichan;
 		s->range_table = &range_digital;
 		s->insn_bits = pcl812_di_insn_bits;
 		subdev++;
 	}
 
 	/* digital output */
-	if (this_board->n_dochan > 0) {
+	if (board->n_dochan > 0) {
 		s = dev->subdevices + subdev;
 		s->type = COMEDI_SUBD_DO;
 		s->subdev_flags = SDF_WRITABLE;
-		s->n_chan = this_board->n_dochan;
+		s->n_chan = board->n_dochan;
 		s->maxdata = 1;
-		s->len_chanlist = this_board->n_dochan;
+		s->len_chanlist = board->n_dochan;
 		s->range_table = &range_digital;
 		s->insn_bits = pcl812_do_insn_bits;
 		subdev++;
 	}
 
-	switch (this_board->board_type) {
+	switch (board->board_type) {
 	case boardACL8216:
 		devpriv->ai_is16b = 1;
 	case boardPCL812PG:
