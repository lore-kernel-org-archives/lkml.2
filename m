Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967221Ab2EPBKe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 21:10:34 -0400
Received: from mail132.messagelabs.com ([216.82.242.115]:22836 "EHLO
	mail132.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757472Ab2EPBKc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 21:10:32 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-13.tower-132.messagelabs.com!1337130630!11715257!1
X-Originating-IP: [216.166.12.178]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] staging: comedi: refactor das16 driver and use module_comedi_driver
Date: Tue, 15 May 2012 18:10:25 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201205151810.25876.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the module_init/module_exit routines and the associated
struct comedi_drive to the end of the source. This is more
typical of how other drivers are written and removes the need
for the forward declarations.

Refactor some of the other functions to remove the remaining
forward declarations.

Convert the driver to use the module_comedi_driver() macro
which makes the code smaller and a bit simpler.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---

 drivers/staging/comedi/drivers/das16.c |  881 +++++++++++++++-----------------
 1 files changed, 404 insertions(+), 477 deletions(-)

diff --git a/drivers/staging/comedi/drivers/das16.c b/drivers/staging/comedi/drivers/das16.c
index e7905ba..73c0a2d 100644
--- a/drivers/staging/comedi/drivers/das16.c
+++ b/drivers/staging/comedi/drivers/das16.c
@@ -339,38 +339,6 @@ struct munge_info {
 	unsigned have_byte:1;
 };
 
-static int das16_ao_winsn(struct comedi_device *dev, struct comedi_subdevice *s,
-			  struct comedi_insn *insn, unsigned int *data);
-static int das16_do_wbits(struct comedi_device *dev, struct comedi_subdevice *s,
-			  struct comedi_insn *insn, unsigned int *data);
-static int das16_di_rbits(struct comedi_device *dev, struct comedi_subdevice *s,
-			  struct comedi_insn *insn, unsigned int *data);
-static int das16_ai_rinsn(struct comedi_device *dev, struct comedi_subdevice *s,
-			  struct comedi_insn *insn, unsigned int *data);
-
-static int das16_cmd_test(struct comedi_device *dev, struct comedi_subdevice *s,
-			  struct comedi_cmd *cmd);
-static int das16_cmd_exec(struct comedi_device *dev,
-			  struct comedi_subdevice *s);
-static int das16_cancel(struct comedi_device *dev, struct comedi_subdevice *s);
-static void das16_ai_munge(struct comedi_device *dev,
-			   struct comedi_subdevice *s, void *array,
-			   unsigned int num_bytes,
-			   unsigned int start_chan_index);
-
-static void das16_reset(struct comedi_device *dev);
-static irqreturn_t das16_dma_interrupt(int irq, void *d);
-static void das16_timer_interrupt(unsigned long arg);
-static void das16_interrupt(struct comedi_device *dev);
-
-static unsigned int das16_set_pacer(struct comedi_device *dev, unsigned int ns,
-				    int flags);
-static int das1600_mode_detect(struct comedi_device *dev);
-static unsigned int das16_suggest_transfer_size(struct comedi_device *dev,
-						struct comedi_cmd cmd);
-
-static void reg_dump(struct comedi_device *dev);
-
 struct das16_board {
 	const char *name;
 	void *ai;
@@ -389,344 +357,6 @@ struct das16_board {
 	unsigned int id;
 };
 
-static const struct das16_board das16_boards[] = {
-	{
-	 .name = "das-16",
-	 .ai = das16_ai_rinsn,
-	 .ai_nbits = 12,
-	 .ai_speed = 15000,
-	 .ai_pg = das16_pg_none,
-	 .ao = das16_ao_winsn,
-	 .ao_nbits = 12,
-	 .di = das16_di_rbits,
-	 .do_ = das16_do_wbits,
-	 .i8255_offset = 0x10,
-	 .i8254_offset = 0x0c,
-	 .size = 0x14,
-	 .id = 0x00,
-	 },
-	{
-	 .name = "das-16g",
-	 .ai = das16_ai_rinsn,
-	 .ai_nbits = 12,
-	 .ai_speed = 15000,
-	 .ai_pg = das16_pg_none,
-	 .ao = das16_ao_winsn,
-	 .ao_nbits = 12,
-	 .di = das16_di_rbits,
-	 .do_ = das16_do_wbits,
-	 .i8255_offset = 0x10,
-	 .i8254_offset = 0x0c,
-	 .size = 0x14,
-	 .id = 0x00,
-	 },
-	{
-	 .name = "das-16f",
-	 .ai = das16_ai_rinsn,
-	 .ai_nbits = 12,
-	 .ai_speed = 8500,
-	 .ai_pg = das16_pg_none,
-	 .ao = das16_ao_winsn,
-	 .ao_nbits = 12,
-	 .di = das16_di_rbits,
-	 .do_ = das16_do_wbits,
-	 .i8255_offset = 0x10,
-	 .i8254_offset = 0x0c,
-	 .size = 0x14,
-	 .id = 0x00,
-	 },
-	{
-	 .name = "cio-das16",	/*  cio-das16.pdf */
-	 .ai = das16_ai_rinsn,
-	 .ai_nbits = 12,
-	 .ai_speed = 20000,
-	 .ai_pg = das16_pg_none,
-	 .ao = das16_ao_winsn,
-	 .ao_nbits = 12,
-	 .di = das16_di_rbits,
-	 .do_ = das16_do_wbits,
-	 .i8255_offset = 0x10,
-	 .i8254_offset = 0x0c,
-	 .size = 0x14,
-	 .id = 0x80,
-	 },
-	{
-	 .name = "cio-das16/f",	/*  das16.pdf */
-	 .ai = das16_ai_rinsn,
-	 .ai_nbits = 12,
-	 .ai_speed = 10000,
-	 .ai_pg = das16_pg_none,
-	 .ao = das16_ao_winsn,
-	 .ao_nbits = 12,
-	 .di = das16_di_rbits,
-	 .do_ = das16_do_wbits,
-	 .i8255_offset = 0x10,
-	 .i8254_offset = 0x0c,
-	 .size = 0x14,
-	 .id = 0x80,
-	 },
-	{
-	 .name = "cio-das16/jr",	/*  cio-das16jr.pdf */
-	 .ai = das16_ai_rinsn,
-	 .ai_nbits = 12,
-	 .ai_speed = 7692,
-	 .ai_pg = das16_pg_16jr,
-	 .ao = NULL,
-	 .di = das16_di_rbits,
-	 .do_ = das16_do_wbits,
-	 .i8255_offset = 0,
-	 .i8254_offset = 0x0c,
-	 .size = 0x10,
-	 .id = 0x00,
-	 },
-	{
-	 .name = "pc104-das16jr",	/*  pc104-das16jr_xx.pdf */
-	 .ai = das16_ai_rinsn,
-	 .ai_nbits = 12,
-	 .ai_speed = 3300,
-	 .ai_pg = das16_pg_16jr,
-	 .ao = NULL,
-	 .di = das16_di_rbits,
-	 .do_ = das16_do_wbits,
-	 .i8255_offset = 0,
-	 .i8254_offset = 0x0c,
-	 .size = 0x10,
-	 .id = 0x00,
-	 },
-	{
-	 .name = "cio-das16jr/16",	/*  cio-das16jr_16.pdf */
-	 .ai = das16_ai_rinsn,
-	 .ai_nbits = 16,
-	 .ai_speed = 10000,
-	 .ai_pg = das16_pg_16jr_16,
-	 .ao = NULL,
-	 .di = das16_di_rbits,
-	 .do_ = das16_do_wbits,
-	 .i8255_offset = 0,
-	 .i8254_offset = 0x0c,
-	 .size = 0x10,
-	 .id = 0x00,
-	 },
-	{
-	 .name = "pc104-das16jr/16",	/*  pc104-das16jr_xx.pdf */
-	 .ai = das16_ai_rinsn,
-	 .ai_nbits = 16,
-	 .ai_speed = 10000,
-	 .ai_pg = das16_pg_16jr_16,
-	 .ao = NULL,
-	 .di = das16_di_rbits,
-	 .do_ = das16_do_wbits,
-	 .i8255_offset = 0,
-	 .i8254_offset = 0x0c,
-	 .size = 0x10,
-	 .id = 0x00,
-	 },
-	{
-	 .name = "das-1201",	/*  4924.pdf (keithley user's manual) */
-	 .ai = das16_ai_rinsn,
-	 .ai_nbits = 12,
-	 .ai_speed = 20000,
-	 .ai_pg = das16_pg_none,
-	 .ao = NULL,
-	 .di = das16_di_rbits,
-	 .do_ = das16_do_wbits,
-	 .i8255_offset = 0x400,
-	 .i8254_offset = 0x0c,
-	 .size = 0x408,
-	 .id = 0x20,
-	 },
-	{
-	 .name = "das-1202",	/*  4924.pdf (keithley user's manual) */
-	 .ai = das16_ai_rinsn,
-	 .ai_nbits = 12,
-	 .ai_speed = 10000,
-	 .ai_pg = das16_pg_none,
-	 .ao = NULL,
-	 .di = das16_di_rbits,
-	 .do_ = das16_do_wbits,
-	 .i8255_offset = 0x400,
-	 .i8254_offset = 0x0c,
-	 .size = 0x408,
-	 .id = 0x20,
-	 },
-	{
-	/*  4919.pdf and 4922.pdf (keithley user's manual) */
-	 .name = "das-1401",
-	 .ai = das16_ai_rinsn,
-	 .ai_nbits = 12,
-	 .ai_speed = 10000,
-	 .ai_pg = das16_pg_1601,
-	 .ao = NULL,
-	 .di = das16_di_rbits,
-	 .do_ = das16_do_wbits,
-	 .i8255_offset = 0x0,
-	 .i8254_offset = 0x0c,
-	 .size = 0x408,
-	 .id = 0xc0   /*  4919.pdf says id bits are 0xe0, 4922.pdf says 0xc0 */
-	 },
-	{
-	/*  4919.pdf and 4922.pdf (keithley user's manual) */
-	 .name = "das-1402",
-	 .ai = das16_ai_rinsn,
-	 .ai_nbits = 12,
-	 .ai_speed = 10000,
-	 .ai_pg = das16_pg_1602,
-	 .ao = NULL,
-	 .di = das16_di_rbits,
-	 .do_ = das16_do_wbits,
-	 .i8255_offset = 0x0,
-	 .i8254_offset = 0x0c,
-	 .size = 0x408,
-	 .id = 0xc0   /*  4919.pdf says id bits are 0xe0, 4922.pdf says 0xc0 */
-	 },
-	{
-	 .name = "das-1601",	/*  4919.pdf */
-	 .ai = das16_ai_rinsn,
-	 .ai_nbits = 12,
-	 .ai_speed = 10000,
-	 .ai_pg = das16_pg_1601,
-	 .ao = das16_ao_winsn,
-	 .ao_nbits = 12,
-	 .di = das16_di_rbits,
-	 .do_ = das16_do_wbits,
-	 .i8255_offset = 0x400,
-	 .i8254_offset = 0x0c,
-	 .size = 0x408,
-	 .id = 0xc0},
-	{
-	 .name = "das-1602",	/*  4919.pdf */
-	 .ai = das16_ai_rinsn,
-	 .ai_nbits = 12,
-	 .ai_speed = 10000,
-	 .ai_pg = das16_pg_1602,
-	 .ao = das16_ao_winsn,
-	 .ao_nbits = 12,
-	 .di = das16_di_rbits,
-	 .do_ = das16_do_wbits,
-	 .i8255_offset = 0x400,
-	 .i8254_offset = 0x0c,
-	 .size = 0x408,
-	 .id = 0xc0},
-	{
-	 .name = "cio-das1401/12",	/*  cio-das1400_series.pdf */
-	 .ai = das16_ai_rinsn,
-	 .ai_nbits = 12,
-	 .ai_speed = 6250,
-	 .ai_pg = das16_pg_1601,
-	 .ao = NULL,
-	 .di = das16_di_rbits,
-	 .do_ = das16_do_wbits,
-	 .i8255_offset = 0,
-	 .i8254_offset = 0x0c,
-	 .size = 0x408,
-	 .id = 0xc0},
-	{
-	 .name = "cio-das1402/12",	/*  cio-das1400_series.pdf */
-	 .ai = das16_ai_rinsn,
-	 .ai_nbits = 12,
-	 .ai_speed = 6250,
-	 .ai_pg = das16_pg_1602,
-	 .ao = NULL,
-	 .di = das16_di_rbits,
-	 .do_ = das16_do_wbits,
-	 .i8255_offset = 0,
-	 .i8254_offset = 0x0c,
-	 .size = 0x408,
-	 .id = 0xc0},
-	{
-	 .name = "cio-das1402/16",	/*  cio-das1400_series.pdf */
-	 .ai = das16_ai_rinsn,
-	 .ai_nbits = 16,
-	 .ai_speed = 10000,
-	 .ai_pg = das16_pg_1602,
-	 .ao = NULL,
-	 .di = das16_di_rbits,
-	 .do_ = das16_do_wbits,
-	 .i8255_offset = 0,
-	 .i8254_offset = 0x0c,
-	 .size = 0x408,
-	 .id = 0xc0},
-	{
-	 .name = "cio-das1601/12",	/*  cio-das160x-1x.pdf */
-	 .ai = das16_ai_rinsn,
-	 .ai_nbits = 12,
-	 .ai_speed = 6250,
-	 .ai_pg = das16_pg_1601,
-	 .ao = das16_ao_winsn,
-	 .ao_nbits = 12,
-	 .di = das16_di_rbits,
-	 .do_ = das16_do_wbits,
-	 .i8255_offset = 0x400,
-	 .i8254_offset = 0x0c,
-	 .size = 0x408,
-	 .id = 0xc0},
-	{
-	 .name = "cio-das1602/12",	/*  cio-das160x-1x.pdf */
-	 .ai = das16_ai_rinsn,
-	 .ai_nbits = 12,
-	 .ai_speed = 10000,
-	 .ai_pg = das16_pg_1602,
-	 .ao = das16_ao_winsn,
-	 .ao_nbits = 12,
-	 .di = das16_di_rbits,
-	 .do_ = das16_do_wbits,
-	 .i8255_offset = 0x400,
-	 .i8254_offset = 0x0c,
-	 .size = 0x408,
-	 .id = 0xc0},
-	{
-	 .name = "cio-das1602/16",	/*  cio-das160x-1x.pdf */
-	 .ai = das16_ai_rinsn,
-	 .ai_nbits = 16,
-	 .ai_speed = 10000,
-	 .ai_pg = das16_pg_1602,
-	 .ao = das16_ao_winsn,
-	 .ao_nbits = 12,
-	 .di = das16_di_rbits,
-	 .do_ = das16_do_wbits,
-	 .i8255_offset = 0x400,
-	 .i8254_offset = 0x0c,
-	 .size = 0x408,
-	 .id = 0xc0},
-	{
-	 .name = "cio-das16/330",	/*  ? */
-	 .ai = das16_ai_rinsn,
-	 .ai_nbits = 12,
-	 .ai_speed = 3030,
-	 .ai_pg = das16_pg_16jr,
-	 .ao = NULL,
-	 .di = das16_di_rbits,
-	 .do_ = das16_do_wbits,
-	 .i8255_offset = 0,
-	 .i8254_offset = 0x0c,
-	 .size = 0x14,
-	 .id = 0xf0},
-#if 0
-	{
-	 .name = "das16/330i",	/*  ? */
-	 },
-	{
-	 .name = "das16/jr/ctr5",	/*  ? */
-	 },
-	{
-	/*  cio-das16_m1_16.pdf, this board is a bit quirky, no dma */
-	 .name = "cio-das16/m1/16",
-	 },
-#endif
-};
-
-static int das16_attach(struct comedi_device *dev, struct comedi_devconfig *it);
-static int das16_detach(struct comedi_device *dev);
-static struct comedi_driver driver_das16 = {
-	.driver_name = "das16",
-	.module = THIS_MODULE,
-	.attach = das16_attach,
-	.detach = das16_detach,
-	.board_name = &das16_boards[0].name,
-	.num_names = ARRAY_SIZE(das16_boards),
-	.offset = sizeof(das16_boards[0]),
-};
-
 #define DAS16_TIMEOUT 1000
 
 /* Period for timer interrupt in jiffies.  It's a function
@@ -926,6 +556,62 @@ static int das16_cmd_test(struct comedi_device *dev, struct comedi_subdevice *s,
 	return 0;
 }
 
+/* utility function that suggests a dma transfer size in bytes */
+static unsigned int das16_suggest_transfer_size(struct comedi_device *dev,
+						struct comedi_cmd cmd)
+{
+	unsigned int size;
+	unsigned int freq;
+
+	/* if we are using timer interrupt, we don't care how long it
+	 * will take to complete transfer since it will be interrupted
+	 * by timer interrupt */
+	if (devpriv->timer_mode)
+		return DAS16_DMA_SIZE;
+
+	/* otherwise, we are relying on dma terminal count interrupt,
+	 * so pick a reasonable size */
+	if (cmd.convert_src == TRIG_TIMER)
+		freq = 1000000000 / cmd.convert_arg;
+	else if (cmd.scan_begin_src == TRIG_TIMER)
+		freq = (1000000000 / cmd.scan_begin_arg) * cmd.chanlist_len;
+	/*  return some default value */
+	else
+		freq = 0xffffffff;
+
+	if (cmd.flags & TRIG_WAKE_EOS) {
+		size = sample_size * cmd.chanlist_len;
+	} else {
+		/*  make buffer fill in no more than 1/3 second */
+		size = (freq / 3) * sample_size;
+	}
+
+	/*  set a minimum and maximum size allowed */
+	if (size > DAS16_DMA_SIZE)
+		size = DAS16_DMA_SIZE - DAS16_DMA_SIZE % sample_size;
+	else if (size < sample_size)
+		size = sample_size;
+
+	if (cmd.stop_src == TRIG_COUNT && size > devpriv->adc_byte_count)
+		size = devpriv->adc_byte_count;
+
+	return size;
+}
+
+static unsigned int das16_set_pacer(struct comedi_device *dev, unsigned int ns,
+				    int rounding_flags)
+{
+	i8253_cascade_ns_to_timer_2div(devpriv->clockbase, &(devpriv->divisor1),
+				       &(devpriv->divisor2), &ns,
+				       rounding_flags & TRIG_ROUND_MASK);
+
+	/* Write the values of ctr1 and ctr2 into counters 1 and 2 */
+	i8254_load(dev->iobase + DAS16_CNTR0_DATA, 0, 1, devpriv->divisor1, 2);
+	i8254_load(dev->iobase + DAS16_CNTR0_DATA, 0, 2, devpriv->divisor2, 2);
+
+	return ns;
+}
+
 static int das16_cmd_exec(struct comedi_device *dev, struct comedi_subdevice *s)
 {
 	struct comedi_async *async = s->async;
@@ -1170,34 +856,6 @@ static int das16_ao_winsn(struct comedi_device *dev, struct comedi_subdevice *s,
 	return i;
 }
 
-static irqreturn_t das16_dma_interrupt(int irq, void *d)
-{
-	int status;
-	struct comedi_device *dev = d;
-
-	status = inb(dev->iobase + DAS16_STATUS);
-
-	if ((status & DAS16_INT) == 0) {
-		DEBUG_PRINT("spurious interrupt\n");
-		return IRQ_NONE;
-	}
-
-	/* clear interrupt */
-	outb(0x00, dev->iobase + DAS16_STATUS);
-	das16_interrupt(dev);
-	return IRQ_HANDLED;
-}
-
-static void das16_timer_interrupt(unsigned long arg)
-{
-	struct comedi_device *dev = (struct comedi_device *)arg;
-
-	das16_interrupt(dev);
-
-	if (devpriv->timer_running)
-		mod_timer(&devpriv->timer, jiffies + timer_period());
-}
-
 /* the pc104-das16jr (at least) has problems if the dma
 	transfer is interrupted in the middle of transferring
 	a 16 bit sample, so this function takes care to get
@@ -1309,18 +967,32 @@ static void das16_interrupt(struct comedi_device *dev)
 	cfc_handle_events(dev, s);
 }
 
-static unsigned int das16_set_pacer(struct comedi_device *dev, unsigned int ns,
-				    int rounding_flags)
+static irqreturn_t das16_dma_interrupt(int irq, void *d)
 {
-	i8253_cascade_ns_to_timer_2div(devpriv->clockbase, &(devpriv->divisor1),
-				       &(devpriv->divisor2), &ns,
-				       rounding_flags & TRIG_ROUND_MASK);
+	int status;
+	struct comedi_device *dev = d;
 
-	/* Write the values of ctr1 and ctr2 into counters 1 and 2 */
-	i8254_load(dev->iobase + DAS16_CNTR0_DATA, 0, 1, devpriv->divisor1, 2);
-	i8254_load(dev->iobase + DAS16_CNTR0_DATA, 0, 2, devpriv->divisor2, 2);
+	status = inb(dev->iobase + DAS16_STATUS);
 
-	return ns;
+	if ((status & DAS16_INT) == 0) {
+		DEBUG_PRINT("spurious interrupt\n");
+		return IRQ_NONE;
+	}
+
+	/* clear interrupt */
+	outb(0x00, dev->iobase + DAS16_STATUS);
+	das16_interrupt(dev);
+	return IRQ_HANDLED;
+}
+
+static void das16_timer_interrupt(unsigned long arg)
+{
+	struct comedi_device *dev = (struct comedi_device *)arg;
+
+	das16_interrupt(dev);
+
+	if (devpriv->timer_running)
+		mod_timer(&devpriv->timer, jiffies + timer_period());
 }
 
 static void reg_dump(struct comedi_device *dev)
@@ -1394,6 +1066,22 @@ static int das1600_mode_detect(struct comedi_device *dev)
 	return 0;
 }
 
+static void das16_ai_munge(struct comedi_device *dev,
+			   struct comedi_subdevice *s, void *array,
+			   unsigned int num_bytes,
+			   unsigned int start_chan_index)
+{
+	unsigned int i, num_samples = num_bytes / sizeof(short);
+	short *data = array;
+
+	for (i = 0; i < num_samples; i++) {
+		data[i] = le16_to_cpu(data[i]);
+		if (thisboard->ai_nbits == 12)
+			data[i] = (data[i] >> 4) & 0xfff;
+
+	}
+}
+
 /*
  *
  * Options list:
@@ -1402,7 +1090,6 @@ static int das1600_mode_detect(struct comedi_device *dev)
  *   2  DMA
  *   3  Clock speed (in MHz)
  */
-
 static int das16_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 {
 	struct comedi_subdevice *s;
@@ -1715,76 +1402,316 @@ static int das16_detach(struct comedi_device *dev)
 	return 0;
 }
 
-static int __init driver_das16_init_module(void)
-{
-	return comedi_driver_register(&driver_das16);
-}
+static const struct das16_board das16_boards[] = {
+	{
+		.name		= "das-16",
+		.ai		= das16_ai_rinsn,
+		.ai_nbits	= 12,
+		.ai_speed	= 15000,
+		.ai_pg		= das16_pg_none,
+		.ao		= das16_ao_winsn,
+		.ao_nbits	= 12,
+		.di		= das16_di_rbits,
+		.do_		= das16_do_wbits,
+		.i8255_offset	= 0x10,
+		.i8254_offset	= 0x0c,
+		.size		= 0x14,
+		.id		= 0x00,
+	}, {
+		.name		= "das-16g",
+		.ai		= das16_ai_rinsn,
+		.ai_nbits	= 12,
+		.ai_speed	= 15000,
+		.ai_pg		= das16_pg_none,
+		.ao		= das16_ao_winsn,
+		.ao_nbits	= 12,
+		.di		= das16_di_rbits,
+		.do_		= das16_do_wbits,
+		.i8255_offset	= 0x10,
+		.i8254_offset	= 0x0c,
+		.size		= 0x14,
+		.id		= 0x00,
+	}, {
+		.name		= "das-16f",
+		.ai		= das16_ai_rinsn,
+		.ai_nbits	= 12,
+		.ai_speed	= 8500,
+		.ai_pg		= das16_pg_none,
+		.ao		= das16_ao_winsn,
+		.ao_nbits	= 12,
+		.di		= das16_di_rbits,
+		.do_		= das16_do_wbits,
+		.i8255_offset	= 0x10,
+		.i8254_offset	= 0x0c,
+		.size		= 0x14,
+		.id		= 0x00,
+	}, {
+		.name		= "cio-das16",
+		.ai		= das16_ai_rinsn,
+		.ai_nbits	= 12,
+		.ai_speed	= 20000,
+		.ai_pg		= das16_pg_none,
+		.ao		= das16_ao_winsn,
+		.ao_nbits	= 12,
+		.di		= das16_di_rbits,
+		.do_		= das16_do_wbits,
+		.i8255_offset	= 0x10,
+		.i8254_offset	= 0x0c,
+		.size		= 0x14,
+		.id		= 0x80,
+	}, {
+		.name		= "cio-das16/f",
+		.ai		= das16_ai_rinsn,
+		.ai_nbits	= 12,
+		.ai_speed	= 10000,
+		.ai_pg		= das16_pg_none,
+		.ao		= das16_ao_winsn,
+		.ao_nbits	= 12,
+		.di		= das16_di_rbits,
+		.do_		= das16_do_wbits,
+		.i8255_offset	= 0x10,
+		.i8254_offset	= 0x0c,
+		.size		= 0x14,
+		.id		= 0x80,
+	}, {
+		.name		= "cio-das16/jr",
+		.ai		= das16_ai_rinsn,
+		.ai_nbits	= 12,
+		.ai_speed	= 7692,
+		.ai_pg		= das16_pg_16jr,
+		.ao		= NULL,
+		.di		= das16_di_rbits,
+		.do_		= das16_do_wbits,
+		.i8255_offset	= 0,
+		.i8254_offset	= 0x0c,
+		.size		= 0x10,
+		.id		= 0x00,
+	}, {
+		.name		= "pc104-das16jr",
+		.ai		= das16_ai_rinsn,
+		.ai_nbits	= 12,
+		.ai_speed	= 3300,
+		.ai_pg		= das16_pg_16jr,
+		.ao		= NULL,
+		.di		= das16_di_rbits,
+		.do_		= das16_do_wbits,
+		.i8255_offset	= 0,
+		.i8254_offset	= 0x0c,
+		.size		= 0x10,
+		.id		= 0x00,
+	}, {
+		.name		= "cio-das16jr/16",
+		.ai		= das16_ai_rinsn,
+		.ai_nbits	= 16,
+		.ai_speed	= 10000,
+		.ai_pg		= das16_pg_16jr_16,
+		.ao		= NULL,
+		.di		= das16_di_rbits,
+		.do_		= das16_do_wbits,
+		.i8255_offset	= 0,
+		.i8254_offset	= 0x0c,
+		.size		= 0x10,
+		.id		= 0x00,
+	}, {
+		.name		= "pc104-das16jr/16",
+		.ai		= das16_ai_rinsn,
+		.ai_nbits	= 16,
+		.ai_speed	= 10000,
+		.ai_pg		= das16_pg_16jr_16,
+		.ao		= NULL,
+		.di		= das16_di_rbits,
+		.do_		= das16_do_wbits,
+		.i8255_offset	= 0,
+		.i8254_offset	= 0x0c,
+		.size		= 0x10,
+		.id		= 0x00,
+	}, {
+		.name		= "das-1201",
+		.ai		= das16_ai_rinsn,
+		.ai_nbits	= 12,
+		.ai_speed	= 20000,
+		.ai_pg		= das16_pg_none,
+		.ao		= NULL,
+		.di		= das16_di_rbits,
+		.do_		= das16_do_wbits,
+		.i8255_offset	= 0x400,
+		.i8254_offset	= 0x0c,
+		.size		= 0x408,
+		.id		= 0x20,
+	}, {
+		.name		= "das-1202",
+		.ai		= das16_ai_rinsn,
+		.ai_nbits	= 12,
+		.ai_speed	= 10000,
+		.ai_pg		= das16_pg_none,
+		.ao		= NULL,
+		.di		= das16_di_rbits,
+		.do_		= das16_do_wbits,
+		.i8255_offset	= 0x400,
+		.i8254_offset	= 0x0c,
+		.size		= 0x408,
+		.id		= 0x20,
+	}, {
+		.name		= "das-1401",
+		.ai		= das16_ai_rinsn,
+		.ai_nbits	= 12,
+		.ai_speed	= 10000,
+		.ai_pg		= das16_pg_1601,
+		.ao		= NULL,
+		.di		= das16_di_rbits,
+		.do_		= das16_do_wbits,
+		.i8255_offset	= 0x0,
+		.i8254_offset	= 0x0c,
+		.size		= 0x408,
+		.id		= 0xc0,
+	}, {
+		.name		= "das-1402",
+		.ai		= das16_ai_rinsn,
+		.ai_nbits	= 12,
+		.ai_speed	= 10000,
+		.ai_pg		= das16_pg_1602,
+		.ao		= NULL,
+		.di		= das16_di_rbits,
+		.do_		= das16_do_wbits,
+		.i8255_offset	= 0x0,
+		.i8254_offset	= 0x0c,
+		.size		= 0x408,
+		.id		= 0xc0,
+	}, {
+		.name		= "das-1601",
+		.ai		= das16_ai_rinsn,
+		.ai_nbits	= 12,
+		.ai_speed	= 10000,
+		.ai_pg		= das16_pg_1601,
+		.ao		= das16_ao_winsn,
+		.ao_nbits	= 12,
+		.di		= das16_di_rbits,
+		.do_		= das16_do_wbits,
+		.i8255_offset	= 0x400,
+		.i8254_offset	= 0x0c,
+		.size		= 0x408,
+		.id		= 0xc0,
+	}, {
+		.name		= "das-1602",
+		.ai		= das16_ai_rinsn,
+		.ai_nbits	= 12,
+		.ai_speed	= 10000,
+		.ai_pg		= das16_pg_1602,
+		.ao		= das16_ao_winsn,
+		.ao_nbits	= 12,
+		.di		= das16_di_rbits,
+		.do_		= das16_do_wbits,
+		.i8255_offset	= 0x400,
+		.i8254_offset	= 0x0c,
+		.size		= 0x408,
+		.id		= 0xc0,
+	}, {
+		.name		= "cio-das1401/12",
+		.ai		= das16_ai_rinsn,
+		.ai_nbits	= 12,
+		.ai_speed	= 6250,
+		.ai_pg		= das16_pg_1601,
+		.ao		= NULL,
+		.di		= das16_di_rbits,
+		.do_		= das16_do_wbits,
+		.i8255_offset	= 0,
+		.i8254_offset	= 0x0c,
+		.size		= 0x408,
+		.id		= 0xc0,
+	}, {
+		.name		= "cio-das1402/12",
+		.ai		= das16_ai_rinsn,
+		.ai_nbits	= 12,
+		.ai_speed	= 6250,
+		.ai_pg		= das16_pg_1602,
+		.ao		= NULL,
+		.di		= das16_di_rbits,
+		.do_		= das16_do_wbits,
+		.i8255_offset	= 0,
+		.i8254_offset	= 0x0c,
+		.size		= 0x408,
+		.id		= 0xc0,
+	}, {
+		.name		= "cio-das1402/16",
+		.ai		= das16_ai_rinsn,
+		.ai_nbits	= 16,
+		.ai_speed	= 10000,
+		.ai_pg		= das16_pg_1602,
+		.ao		= NULL,
+		.di		= das16_di_rbits,
+		.do_		= das16_do_wbits,
+		.i8255_offset	= 0,
+		.i8254_offset	= 0x0c,
+		.size		= 0x408,
+		.id		= 0xc0,
+	}, {
+		.name		= "cio-das1601/12",
+		.ai		= das16_ai_rinsn,
+		.ai_nbits	= 12,
+		.ai_speed	= 6250,
+		.ai_pg		= das16_pg_1601,
+		.ao		= das16_ao_winsn,
+		.ao_nbits	= 12,
+		.di		= das16_di_rbits,
+		.do_		= das16_do_wbits,
+		.i8255_offset	= 0x400,
+		.i8254_offset	= 0x0c,
+		.size		= 0x408,
+		.id		= 0xc0,
+	}, {
+		.name		= "cio-das1602/12",
+		.ai		= das16_ai_rinsn,
+		.ai_nbits	= 12,
+		.ai_speed	= 10000,
+		.ai_pg		= das16_pg_1602,
+		.ao		= das16_ao_winsn,
+		.ao_nbits	= 12,
+		.di		= das16_di_rbits,
+		.do_		= das16_do_wbits,
+		.i8255_offset	= 0x400,
+		.i8254_offset	= 0x0c,
+		.size		= 0x408,
+		.id		= 0xc0,
+	}, {
+		.name		= "cio-das1602/16",
+		.ai		= das16_ai_rinsn,
+		.ai_nbits	= 16,
+		.ai_speed	= 10000,
+		.ai_pg		= das16_pg_1602,
+		.ao		= das16_ao_winsn,
+		.ao_nbits	= 12,
+		.di		= das16_di_rbits,
+		.do_		= das16_do_wbits,
+		.i8255_offset	= 0x400,
+		.i8254_offset	= 0x0c,
+		.size		= 0x408,
+		.id		= 0xc0,
+	}, {
+		.name		= "cio-das16/330",
+		.ai		= das16_ai_rinsn,
+		.ai_nbits	= 12,
+		.ai_speed	= 3030,
+		.ai_pg		= das16_pg_16jr,
+		.ao		= NULL,
+		.di		= das16_di_rbits,
+		.do_		= das16_do_wbits,
+		.i8255_offset	= 0,
+		.i8254_offset	= 0x0c,
+		.size		= 0x14,
+		.id		= 0xf0,
+	},
+};
 
-static void __exit driver_das16_cleanup_module(void)
-{
-	comedi_driver_unregister(&driver_das16);
-}
-
-module_init(driver_das16_init_module);
-module_exit(driver_das16_cleanup_module);
-
-/* utility function that suggests a dma transfer size in bytes */
-static unsigned int das16_suggest_transfer_size(struct comedi_device *dev,
-						struct comedi_cmd cmd)
-{
-	unsigned int size;
-	unsigned int freq;
-
-	/* if we are using timer interrupt, we don't care how long it
-	 * will take to complete transfer since it will be interrupted
-	 * by timer interrupt */
-	if (devpriv->timer_mode)
-		return DAS16_DMA_SIZE;
-
-	/* otherwise, we are relying on dma terminal count interrupt,
-	 * so pick a reasonable size */
-	if (cmd.convert_src == TRIG_TIMER)
-		freq = 1000000000 / cmd.convert_arg;
-	else if (cmd.scan_begin_src == TRIG_TIMER)
-		freq = (1000000000 / cmd.scan_begin_arg) * cmd.chanlist_len;
-	/*  return some default value */
-	else
-		freq = 0xffffffff;
-
-	if (cmd.flags & TRIG_WAKE_EOS) {
-		size = sample_size * cmd.chanlist_len;
-	} else {
-		/*  make buffer fill in no more than 1/3 second */
-		size = (freq / 3) * sample_size;
-	}
-
-	/*  set a minimum and maximum size allowed */
-	if (size > DAS16_DMA_SIZE)
-		size = DAS16_DMA_SIZE - DAS16_DMA_SIZE % sample_size;
-	else if (size < sample_size)
-		size = sample_size;
-
-	if (cmd.stop_src == TRIG_COUNT && size > devpriv->adc_byte_count)
-		size = devpriv->adc_byte_count;
-
-	return size;
-}
-
-static void das16_ai_munge(struct comedi_device *dev,
-			   struct comedi_subdevice *s, void *array,
-			   unsigned int num_bytes,
-			   unsigned int start_chan_index)
-{
-	unsigned int i, num_samples = num_bytes / sizeof(short);
-	short *data = array;
-
-	for (i = 0; i < num_samples; i++) {
-		data[i] = le16_to_cpu(data[i]);
-		if (thisboard->ai_nbits == 12)
-			data[i] = (data[i] >> 4) & 0xfff;
-
-	}
-}
+static struct comedi_driver das16_driver = {
+	.driver_name	= "das16",
+	.module		= THIS_MODULE,
+	.attach		= das16_attach,
+	.detach		= das16_detach,
+	.board_name	= &das16_boards[0].name,
+	.num_names	= ARRAY_SIZE(das16_boards),
+	.offset		= sizeof(das16_boards[0]),
+};
+module_comedi_driver(das16_driver);
 
 MODULE_AUTHOR("Comedi http://www.comedi.org");
 MODULE_DESCRIPTION("Comedi low-level driver");
