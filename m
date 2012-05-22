Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758363Ab2EVXKK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 19:10:10 -0400
Received: from mail209.messagelabs.com ([216.82.255.3]:16234 "EHLO
	mail209.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756156Ab2EVXKG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 19:10:06 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-10.tower-209.messagelabs.com!1337728204!6394446!1
X-Originating-IP: [216.166.12.31]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] staging: comedi: remove thisboard macro in the das16 driver
Date: Tue, 22 May 2012 16:09:58 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201205221609.58770.hartleys@visionengravers.com>
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

diff --git a/drivers/staging/comedi/drivers/das16.c b/drivers/staging/comedi/drivers/das16.c
index 998444c..6170536 100644
--- a/drivers/staging/comedi/drivers/das16.c
+++ b/drivers/staging/comedi/drivers/das16.c
@@ -393,11 +393,11 @@ struct das16_private_struct {
 	volatile short timer_mode;	/*  true if using timer mode */
 };
 #define devpriv ((struct das16_private_struct *)(dev->private))
-#define thisboard ((struct das16_board *)(dev->board_ptr))
 
 static int das16_cmd_test(struct comedi_device *dev, struct comedi_subdevice *s,
 			  struct comedi_cmd *cmd)
 {
+	const struct das16_board *board = comedi_board(dev);
 	int err = 0, tmp;
 	int gain, start_chan, i;
 	int mask;
@@ -411,7 +411,7 @@ static int das16_cmd_test(struct comedi_device *dev, struct comedi_subdevice *s,
 	tmp = cmd->scan_begin_src;
 	mask = TRIG_FOLLOW;
 	/*  if board supports burst mode */
-	if (thisboard->size > 0x400)
+	if (board->size > 0x400)
 		mask |= TRIG_TIMER | TRIG_EXT;
 	cmd->scan_begin_src &= mask;
 	if (!cmd->scan_begin_src || tmp != cmd->scan_begin_src)
@@ -420,7 +420,7 @@ static int das16_cmd_test(struct comedi_device *dev, struct comedi_subdevice *s,
 	tmp = cmd->convert_src;
 	mask = TRIG_TIMER | TRIG_EXT;
 	/*  if board supports burst mode */
-	if (thisboard->size > 0x400)
+	if (board->size > 0x400)
 		mask |= TRIG_NOW;
 	cmd->convert_src &= mask;
 	if (!cmd->convert_src || tmp != cmd->convert_src)
@@ -483,15 +483,15 @@ static int das16_cmd_test(struct comedi_device *dev, struct comedi_subdevice *s,
 	/*  check against maximum frequency */
 	if (cmd->scan_begin_src == TRIG_TIMER) {
 		if (cmd->scan_begin_arg <
-		    thisboard->ai_speed * cmd->chanlist_len) {
+		    board->ai_speed * cmd->chanlist_len) {
 			cmd->scan_begin_arg =
-			    thisboard->ai_speed * cmd->chanlist_len;
+			    board->ai_speed * cmd->chanlist_len;
 			err++;
 		}
 	}
 	if (cmd->convert_src == TRIG_TIMER) {
-		if (cmd->convert_arg < thisboard->ai_speed) {
-			cmd->convert_arg = thisboard->ai_speed;
+		if (cmd->convert_arg < board->ai_speed) {
+			cmd->convert_arg = board->ai_speed;
 			err++;
 		}
 	}
@@ -614,6 +614,7 @@ static unsigned int das16_set_pacer(struct comedi_device *dev, unsigned int ns,
 
 static int das16_cmd_exec(struct comedi_device *dev, struct comedi_subdevice *s)
 {
+	const struct das16_board *board = comedi_board(dev);
 	struct comedi_async *async = s->async;
 	struct comedi_cmd *cmd = &async->cmd;
 	unsigned int byte;
@@ -637,7 +638,7 @@ static int das16_cmd_exec(struct comedi_device *dev, struct comedi_subdevice *s)
 	    cmd->stop_arg * cmd->chanlist_len * sizeof(uint16_t);
 
 	/*  disable conversions for das1600 mode */
-	if (thisboard->size > 0x400)
+	if (board->size > 0x400)
 		outb(DAS1600_CONV_DISABLE, dev->iobase + DAS1600_CONV);
 
 	/*  set scan limits */
@@ -648,9 +649,9 @@ static int das16_cmd_exec(struct comedi_device *dev, struct comedi_subdevice *s)
 	/* set gain (this is also burst rate register but according to
 	 * computer boards manual, burst rate does nothing, even on
 	 * keithley cards) */
-	if (thisboard->ai_pg != das16_pg_none) {
+	if (board->ai_pg != das16_pg_none) {
 		range = CR_RANGE(cmd->chanlist[0]);
-		outb((das16_gainlists[thisboard->ai_pg])[range],
+		outb((das16_gainlists[board->ai_pg])[range],
 		     dev->iobase + DAS16_GAIN);
 	}
 
@@ -663,7 +664,7 @@ static int das16_cmd_exec(struct comedi_device *dev, struct comedi_subdevice *s)
 	/* enable counters */
 	byte = 0;
 	/* Enable burst mode if appropriate. */
-	if (thisboard->size > 0x400) {
+	if (board->size > 0x400) {
 		if (cmd->convert_src == TRIG_NOW) {
 			outb(DAS1600_BURST_VAL, dev->iobase + DAS1600_BURST);
 			/*  set burst length */
@@ -710,7 +711,7 @@ static int das16_cmd_exec(struct comedi_device *dev, struct comedi_subdevice *s)
 	outb(devpriv->control_state, dev->iobase + DAS16_CONTROL);
 
 	/* Enable conversions if using das1600 mode */
-	if (thisboard->size > 0x400)
+	if (board->size > 0x400)
 		outb(0, dev->iobase + DAS1600_CONV);
 
 
@@ -719,6 +720,7 @@ static int das16_cmd_exec(struct comedi_device *dev, struct comedi_subdevice *s)
 
 static int das16_cancel(struct comedi_device *dev, struct comedi_subdevice *s)
 {
+	const struct das16_board *board = comedi_board(dev);
 	unsigned long flags;
 
 	spin_lock_irqsave(&dev->spinlock, flags);
@@ -735,7 +737,7 @@ static int das16_cancel(struct comedi_device *dev, struct comedi_subdevice *s)
 	}
 
 	/* disable burst mode */
-	if (thisboard->size > 0x400)
+	if (board->size > 0x400)
 		outb(0, dev->iobase + DAS1600_BURST);
 
 
@@ -755,6 +757,7 @@ static void das16_reset(struct comedi_device *dev)
 static int das16_ai_rinsn(struct comedi_device *dev, struct comedi_subdevice *s,
 			  struct comedi_insn *insn, unsigned int *data)
 {
+	const struct das16_board *board = comedi_board(dev);
 	int i, n;
 	int range;
 	int chan;
@@ -770,9 +773,9 @@ static int das16_ai_rinsn(struct comedi_device *dev, struct comedi_subdevice *s,
 	outb(chan, dev->iobase + DAS16_MUX);
 
 	/* set gain */
-	if (thisboard->ai_pg != das16_pg_none) {
+	if (board->ai_pg != das16_pg_none) {
 		range = CR_RANGE(insn->chanspec);
-		outb((das16_gainlists[thisboard->ai_pg])[range],
+		outb((das16_gainlists[board->ai_pg])[range],
 		     dev->iobase + DAS16_GAIN);
 	}
 
@@ -790,7 +793,7 @@ static int das16_ai_rinsn(struct comedi_device *dev, struct comedi_subdevice *s,
 		}
 		msb = inb(dev->iobase + DAS16_AI_MSB);
 		lsb = inb(dev->iobase + DAS16_AI_LSB);
-		if (thisboard->ai_nbits == 12)
+		if (board->ai_nbits == 12)
 			data[n] = ((lsb >> 4) & 0xf) | (msb << 4);
 		else
 			data[n] = lsb | (msb << 8);
@@ -835,6 +838,7 @@ static int das16_do_wbits(struct comedi_device *dev, struct comedi_subdevice *s,
 static int das16_ao_winsn(struct comedi_device *dev, struct comedi_subdevice *s,
 			  struct comedi_insn *insn, unsigned int *data)
 {
+	const struct das16_board *board = comedi_board(dev);
 	int i;
 	int lsb, msb;
 	int chan;
@@ -842,7 +846,7 @@ static int das16_ao_winsn(struct comedi_device *dev, struct comedi_subdevice *s,
 	chan = CR_CHAN(insn->chanspec);
 
 	for (i = 0; i < insn->n; i++) {
-		if (thisboard->ao_nbits == 12) {
+		if (board->ao_nbits == 12) {
 			lsb = (data[i] << 4) & 0xff;
 			msb = (data[i] >> 4) & 0xff;
 		} else {
@@ -892,6 +896,7 @@ static int disable_dma_on_even(struct comedi_device *dev)
 
 static void das16_interrupt(struct comedi_device *dev)
 {
+	const struct das16_board *board = comedi_board(dev);
 	unsigned long dma_flags, spin_flags;
 	struct comedi_subdevice *s = dev->read_subdev;
 	struct comedi_async *async;
@@ -953,7 +958,7 @@ static void das16_interrupt(struct comedi_device *dev)
 		set_dma_count(devpriv->dma_chan, devpriv->dma_transfer_size);
 		enable_dma(devpriv->dma_chan);
 		/* reenable conversions for das1600 mode, (stupid hardware) */
-		if (thisboard->size > 0x400 && devpriv->timer_mode == 0)
+		if (board->size > 0x400 && devpriv->timer_mode == 0)
 			outb(0x00, dev->iobase + DAS1600_CONV);
 
 	}
@@ -1015,6 +1020,7 @@ static void reg_dump(struct comedi_device *dev)
 
 static int das16_probe(struct comedi_device *dev, struct comedi_devconfig *it)
 {
+	const struct das16_board *board = comedi_board(dev);
 	int status;
 	int diobits;
 
@@ -1039,9 +1045,9 @@ static int das16_probe(struct comedi_device *dev, struct comedi_devconfig *it)
 	diobits = inb(dev->iobase + DAS16_DIO) & 0xf0;
 
 	printk(KERN_INFO " id bits are 0x%02x\n", diobits);
-	if (thisboard->id != diobits) {
+	if (board->id != diobits) {
 		printk(KERN_INFO " requested board's id bits are 0x%x (ignore)\n",
-		       thisboard->id);
+		       board->id);
 	}
 
 	return 0;
@@ -1071,12 +1077,13 @@ static void das16_ai_munge(struct comedi_device *dev,
 			   unsigned int num_bytes,
 			   unsigned int start_chan_index)
 {
+	const struct das16_board *board = comedi_board(dev);
 	unsigned int i, num_samples = num_bytes / sizeof(short);
 	short *data = array;
 
 	for (i = 0; i < num_samples; i++) {
 		data[i] = le16_to_cpu(data[i]);
-		if (thisboard->ai_nbits == 12)
+		if (board->ai_nbits == 12)
 			data[i] = (data[i] >> 4) & 0xfff;
 
 	}
@@ -1092,6 +1099,7 @@ static void das16_ai_munge(struct comedi_device *dev,
  */
 static int das16_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 {
+	const struct das16_board *board = comedi_board(dev);
 	struct comedi_subdevice *s;
 	int ret;
 	unsigned int irq;
@@ -1130,9 +1138,9 @@ static int das16_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	if (ret < 0)
 		return ret;
 
-	if (thisboard->size < 0x400) {
-		printk(" 0x%04lx-0x%04lx\n", iobase, iobase + thisboard->size);
-		if (!request_region(iobase, thisboard->size, "das16")) {
+	if (board->size < 0x400) {
+		printk(" 0x%04lx-0x%04lx\n", iobase, iobase + board->size);
+		if (!request_region(iobase, board->size, "das16")) {
 			printk(KERN_ERR " I/O port conflict\n");
 			return -EIO;
 		}
@@ -1140,18 +1148,18 @@ static int das16_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 		printk(KERN_INFO " 0x%04lx-0x%04lx 0x%04lx-0x%04lx\n",
 		       iobase, iobase + 0x0f,
 		       iobase + 0x400,
-		       iobase + 0x400 + (thisboard->size & 0x3ff));
+		       iobase + 0x400 + (board->size & 0x3ff));
 		if (!request_region(iobase, 0x10, "das16")) {
 			printk(KERN_ERR " I/O port conflict:  0x%04lx-0x%04lx\n",
 			       iobase, iobase + 0x0f);
 			return -EIO;
 		}
-		if (!request_region(iobase + 0x400, thisboard->size & 0x3ff,
+		if (!request_region(iobase + 0x400, board->size & 0x3ff,
 				    "das16")) {
 			release_region(iobase, 0x10);
 			printk(KERN_ERR " I/O port conflict:  0x%04lx-0x%04lx\n",
 			       iobase + 0x400,
-			       iobase + 0x400 + (thisboard->size & 0x3ff));
+			       iobase + 0x400 + (board->size & 0x3ff));
 			return -EIO;
 		}
 	}
@@ -1163,10 +1171,10 @@ static int das16_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 		printk(KERN_ERR " id bits do not match selected board, aborting\n");
 		return -EINVAL;
 	}
-	dev->board_name = thisboard->name;
+	dev->board_name = board->name;
 
 	/*  get master clock speed */
-	if (thisboard->size < 0x400) {
+	if (board->size < 0x400) {
 		if (it->options[3])
 			devpriv->clockbase = 1000 / it->options[3];
 		else
@@ -1222,7 +1230,7 @@ static int das16_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	}
 
 	/*  get any user-defined input range */
-	if (thisboard->ai_pg == das16_pg_none &&
+	if (board->ai_pg == das16_pg_none &&
 	    (it->options[4] || it->options[5])) {
 		/*  allocate single-range range table */
 		devpriv->user_ai_range_table =
@@ -1263,7 +1271,7 @@ static int das16_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	s = dev->subdevices + 0;
 	dev->read_subdev = s;
 	/* ai */
-	if (thisboard->ai) {
+	if (board->ai) {
 		s->type = COMEDI_SUBD_AI;
 		s->subdev_flags = SDF_READABLE | SDF_CMD_READ;
 		if (devpriv->ai_singleended) {
@@ -1275,15 +1283,15 @@ static int das16_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 			s->len_chanlist = 8;
 			s->subdev_flags |= SDF_DIFF;
 		}
-		s->maxdata = (1 << thisboard->ai_nbits) - 1;
+		s->maxdata = (1 << board->ai_nbits) - 1;
 		if (devpriv->user_ai_range_table) { /*  user defined ai range */
 			s->range_table = devpriv->user_ai_range_table;
 		} else if (devpriv->ai_unipolar) {
-			s->range_table = das16_ai_uni_lranges[thisboard->ai_pg];
+			s->range_table = das16_ai_uni_lranges[board->ai_pg];
 		} else {
-			s->range_table = das16_ai_bip_lranges[thisboard->ai_pg];
+			s->range_table = das16_ai_bip_lranges[board->ai_pg];
 		}
-		s->insn_read = thisboard->ai;
+		s->insn_read = board->ai;
 		s->do_cmdtest = das16_cmd_test;
 		s->do_cmd = das16_cmd_exec;
 		s->cancel = das16_cancel;
@@ -1294,44 +1302,44 @@ static int das16_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 
 	s = dev->subdevices + 1;
 	/* ao */
-	if (thisboard->ao) {
+	if (board->ao) {
 		s->type = COMEDI_SUBD_AO;
 		s->subdev_flags = SDF_WRITABLE;
 		s->n_chan = 2;
-		s->maxdata = (1 << thisboard->ao_nbits) - 1;
+		s->maxdata = (1 << board->ao_nbits) - 1;
 		/*  user defined ao range */
 		if (devpriv->user_ao_range_table)
 			s->range_table = devpriv->user_ao_range_table;
 		else
 			s->range_table = &range_unknown;
 
-		s->insn_write = thisboard->ao;
+		s->insn_write = board->ao;
 	} else {
 		s->type = COMEDI_SUBD_UNUSED;
 	}
 
 	s = dev->subdevices + 2;
 	/* di */
-	if (thisboard->di) {
+	if (board->di) {
 		s->type = COMEDI_SUBD_DI;
 		s->subdev_flags = SDF_READABLE;
 		s->n_chan = 4;
 		s->maxdata = 1;
 		s->range_table = &range_digital;
-		s->insn_bits = thisboard->di;
+		s->insn_bits = board->di;
 	} else {
 		s->type = COMEDI_SUBD_UNUSED;
 	}
 
 	s = dev->subdevices + 3;
 	/* do */
-	if (thisboard->do_) {
+	if (board->do_) {
 		s->type = COMEDI_SUBD_DO;
 		s->subdev_flags = SDF_WRITABLE | SDF_READABLE;
 		s->n_chan = 4;
 		s->maxdata = 1;
 		s->range_table = &range_digital;
-		s->insn_bits = thisboard->do_;
+		s->insn_bits = board->do_;
 		/*  initialize digital output lines */
 		outb(s->state, dev->iobase + DAS16_DIO);
 	} else {
@@ -1340,9 +1348,9 @@ static int das16_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 
 	s = dev->subdevices + 4;
 	/* 8255 */
-	if (thisboard->i8255_offset != 0) {
+	if (board->i8255_offset != 0) {
 		subdev_8255_init(dev, s, NULL, (dev->iobase +
-						thisboard->i8255_offset));
+						board->i8255_offset));
 	} else {
 		s->type = COMEDI_SUBD_UNUSED;
 	}
@@ -1353,7 +1361,7 @@ static int das16_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	outb(devpriv->control_state, dev->iobase + DAS16_CONTROL);
 
 	/*  turn on das1600 mode if available */
-	if (thisboard->size > 0x400) {
+	if (board->size > 0x400) {
 		outb(DAS1600_ENABLE_VAL, dev->iobase + DAS1600_ENABLE);
 		outb(0, dev->iobase + DAS1600_CONV);
 		outb(0, dev->iobase + DAS1600_BURST);
@@ -1364,6 +1372,8 @@ static int das16_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 
 static void das16_detach(struct comedi_device *dev)
 {
+	const struct das16_board *board = comedi_board(dev);
+
 	das16_reset(dev);
 	if (dev->subdevices)
 		subdev_8255_cleanup(dev, dev->subdevices + 4);
@@ -1384,12 +1394,12 @@ static void das16_detach(struct comedi_device *dev)
 	if (dev->irq)
 		free_irq(dev->irq, dev);
 	if (dev->iobase) {
-		if (thisboard->size < 0x400) {
-			release_region(dev->iobase, thisboard->size);
+		if (board->size < 0x400) {
+			release_region(dev->iobase, board->size);
 		} else {
 			release_region(dev->iobase, 0x10);
 			release_region(dev->iobase + 0x400,
-				       thisboard->size & 0x3ff);
+				       board->size & 0x3ff);
 		}
 	}
 }
