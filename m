Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933652Ab2EVXwM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 19:52:12 -0400
Received: from mail132.messagelabs.com ([216.82.242.115]:39055 "EHLO
	mail132.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756868Ab2EVXwJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 19:52:09 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-12.tower-132.messagelabs.com!1337730724!12419210!2
X-Originating-IP: [216.166.12.72]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] staging: comedi: remove this_board macro in the pcl711 driver
Date: Tue, 22 May 2012 16:52:00 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201205221652.01131.hartleys@visionengravers.com>
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

diff --git a/drivers/staging/comedi/drivers/pcl711.c b/drivers/staging/comedi/drivers/pcl711.c
index 2e7753f..e943b52 100644
--- a/drivers/staging/comedi/drivers/pcl711.c
+++ b/drivers/staging/comedi/drivers/pcl711.c
@@ -148,8 +148,6 @@ struct pcl711_board {
 	const struct comedi_lrange *ai_range_type;
 };
 
-#define this_board ((const struct pcl711_board *)dev->board_ptr)
-
 struct pcl711_private {
 
 	int board;
@@ -169,6 +167,7 @@ static irqreturn_t pcl711_interrupt(int irq, void *d)
 	int lo, hi;
 	int data;
 	struct comedi_device *dev = d;
+	const struct pcl711_board *board = comedi_board(dev);
 	struct comedi_subdevice *s = dev->subdevices + 0;
 
 	if (!dev->attached) {
@@ -184,7 +183,7 @@ static irqreturn_t pcl711_interrupt(int irq, void *d)
 
 	/* FIXME! Nothing else sets ntrig! */
 	if (!(--devpriv->ntrig)) {
-		if (this_board->is_8112)
+		if (board->is_8112)
 			outb(1, dev->iobase + PCL711_MODE);
 		else
 			outb(0, dev->iobase + PCL711_MODE);
@@ -197,13 +196,14 @@ static irqreturn_t pcl711_interrupt(int irq, void *d)
 
 static void pcl711_set_changain(struct comedi_device *dev, int chan)
 {
+	const struct pcl711_board *board = comedi_board(dev);
 	int chan_register;
 
 	outb(CR_RANGE(chan), dev->iobase + PCL711_GAIN);
 
 	chan_register = CR_CHAN(chan);
 
-	if (this_board->is_8112) {
+	if (board->is_8112) {
 
 		/*
 		 *  Set the correct channel.  The two channel banks are switched
@@ -225,6 +225,7 @@ static void pcl711_set_changain(struct comedi_device *dev, int chan)
 static int pcl711_ai_insn(struct comedi_device *dev, struct comedi_subdevice *s,
 			  struct comedi_insn *insn, unsigned int *data)
 {
+	const struct pcl711_board *board = comedi_board(dev);
 	int i, n;
 	int hi, lo;
 
@@ -237,7 +238,7 @@ static int pcl711_ai_insn(struct comedi_device *dev, struct comedi_subdevice *s,
 		 */
 		outb(1, dev->iobase + PCL711_MODE);
 
-		if (!this_board->is_8112)
+		if (!board->is_8112)
 			outb(0, dev->iobase + PCL711_SOFTTRIG);
 
 		i = PCL711_TIMEOUT;
@@ -481,6 +482,7 @@ static int pcl711_do_insn_bits(struct comedi_device *dev,
 
 static int pcl711_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 {
+	const struct pcl711_board *board = comedi_board(dev);
 	int ret;
 	unsigned long iobase;
 	unsigned int irq;
@@ -498,12 +500,11 @@ static int pcl711_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 
 	/* there should be a sanity check here */
 
-	/* set up some name stuff */
-	dev->board_name = this_board->name;
+	dev->board_name = board->name;
 
 	/* grab our IRQ */
 	irq = it->options[1];
-	if (irq > this_board->maxirq) {
+	if (irq > board->maxirq) {
 		printk(KERN_ERR "irq out of range\n");
 		return -EINVAL;
 	}
@@ -529,10 +530,10 @@ static int pcl711_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	/* AI subdevice */
 	s->type = COMEDI_SUBD_AI;
 	s->subdev_flags = SDF_READABLE | SDF_GROUND;
-	s->n_chan = this_board->n_aichan;
+	s->n_chan = board->n_aichan;
 	s->maxdata = 0xfff;
 	s->len_chanlist = 1;
-	s->range_table = this_board->ai_range_type;
+	s->range_table = board->ai_range_type;
 	s->insn_read = pcl711_ai_insn;
 	if (irq) {
 		dev->read_subdev = s;
@@ -545,7 +546,7 @@ static int pcl711_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	/* AO subdevice */
 	s->type = COMEDI_SUBD_AO;
 	s->subdev_flags = SDF_WRITABLE;
-	s->n_chan = this_board->n_aochan;
+	s->n_chan = board->n_aochan;
 	s->maxdata = 0xfff;
 	s->len_chanlist = 1;
 	s->range_table = &range_bipolar5;
@@ -577,7 +578,7 @@ static int pcl711_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	   this is the "base value" for the mode register, which is
 	   used for the irq on the PCL711
 	 */
-	if (this_board->is_pcl711b)
+	if (board->is_pcl711b)
 		devpriv->mode = (dev->irq << 4);
 
 	/* clear DAC */
