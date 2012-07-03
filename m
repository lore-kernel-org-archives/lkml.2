Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756386Ab2GCBLg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 21:11:36 -0400
Received: from mail132.messagelabs.com ([216.82.242.115]:54774 "EHLO
	mail132.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755264Ab2GCBLf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 21:11:35 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-3.tower-132.messagelabs.com!1341277893!13214822!1
X-Originating-IP: [216.166.12.180]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/8] staging: comedi: dmm32at: remove forward declarations 1
Date: Mon, 2 Jul 2012 18:11:23 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201207021811.24198.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the attach/detach functions as well as the boardinfo variable
to remove the need to most of the forward declarations.

Add some whitespace to the boardinfo during the move.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Frank Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/dmm32at.c | 373 ++++++++++++++-----------------
 1 file changed, 172 insertions(+), 201 deletions(-)

diff --git a/drivers/staging/comedi/drivers/dmm32at.c b/drivers/staging/comedi/drivers/dmm32at.c
index ad7fef9..9c3d322 100644
--- a/drivers/staging/comedi/drivers/dmm32at.c
+++ b/drivers/staging/comedi/drivers/dmm32at.c
@@ -175,19 +175,6 @@ struct dmm32at_board {
 	int have_dio;
 	int dio_chans;
 };
-static const struct dmm32at_board dmm32at_boards[] = {
-	{
-	 .name = "dmm32at",
-	 .ai_chans = 32,
-	 .ai_bits = 16,
-	 .ai_ranges = &dmm32at_airanges,
-	 .ao_chans = 4,
-	 .ao_bits = 12,
-	 .ao_ranges = &dmm32at_aoranges,
-	 .have_dio = 1,
-	 .dio_chans = 24,
-	 },
-};
 
 /* this structure is for data unique to this hardware driver.  If
  * several hardware drivers keep similar information in this structure,
@@ -212,198 +199,10 @@ struct dmm32at_private {
 #define devpriv ((struct dmm32at_private *)dev->private)
 
 /* prototypes for driver functions below */
-static int dmm32at_ai_rinsn(struct comedi_device *dev,
-			    struct comedi_subdevice *s,
-			    struct comedi_insn *insn, unsigned int *data);
-static int dmm32at_ao_winsn(struct comedi_device *dev,
-			    struct comedi_subdevice *s,
-			    struct comedi_insn *insn, unsigned int *data);
-static int dmm32at_ao_rinsn(struct comedi_device *dev,
-			    struct comedi_subdevice *s,
-			    struct comedi_insn *insn, unsigned int *data);
-static int dmm32at_dio_insn_bits(struct comedi_device *dev,
-				 struct comedi_subdevice *s,
-				 struct comedi_insn *insn, unsigned int *data);
-static int dmm32at_dio_insn_config(struct comedi_device *dev,
-				   struct comedi_subdevice *s,
-				   struct comedi_insn *insn,
-				   unsigned int *data);
-static int dmm32at_ai_cmdtest(struct comedi_device *dev,
-			      struct comedi_subdevice *s,
-			      struct comedi_cmd *cmd);
-static int dmm32at_ai_cmd(struct comedi_device *dev,
-			  struct comedi_subdevice *s);
-static int dmm32at_ai_cancel(struct comedi_device *dev,
-			     struct comedi_subdevice *s);
 static int dmm32at_ns_to_timer(unsigned int *ns, int round);
-static irqreturn_t dmm32at_isr(int irq, void *d);
 void dmm32at_setaitimer(struct comedi_device *dev, unsigned int nansec);
 
 /*
- * Attach is called by the Comedi core to configure the driver
- * for a particular board.  If you specified a board_name array
- * in the driver structure, dev->board_ptr contains that
- * address.
- */
-static int dmm32at_attach(struct comedi_device *dev,
-			  struct comedi_devconfig *it)
-{
-	const struct dmm32at_board *board = comedi_board(dev);
-	int ret;
-	struct comedi_subdevice *s;
-	unsigned char aihi, ailo, fifostat, aistat, intstat, airback;
-	unsigned long iobase;
-	unsigned int irq;
-
-	iobase = it->options[0];
-	irq = it->options[1];
-
-	printk(KERN_INFO "comedi%d: dmm32at: attaching\n", dev->minor);
-	printk(KERN_DEBUG "dmm32at: probing at address 0x%04lx, irq %u\n",
-	       iobase, irq);
-
-	/* register address space */
-	if (!request_region(iobase, DMM32AT_MEMSIZE, board->name)) {
-		printk(KERN_ERR "comedi%d: dmm32at: I/O port conflict\n",
-		       dev->minor);
-		return -EIO;
-	}
-	dev->iobase = iobase;
-
-	/* the following just makes sure the board is there and gets
-	   it to a known state */
-
-	/* reset the board */
-	dmm_outb(dev, DMM32AT_CNTRL, DMM32AT_RESET);
-
-	/* allow a millisecond to reset */
-	udelay(1000);
-
-	/* zero scan and fifo control */
-	dmm_outb(dev, DMM32AT_FIFOCNTRL, 0x0);
-
-	/* zero interrupt and clock control */
-	dmm_outb(dev, DMM32AT_INTCLOCK, 0x0);
-
-	/* write a test channel range, the high 3 bits should drop */
-	dmm_outb(dev, DMM32AT_AILOW, 0x80);
-	dmm_outb(dev, DMM32AT_AIHIGH, 0xff);
-
-	/* set the range at 10v unipolar */
-	dmm_outb(dev, DMM32AT_AICONF, DMM32AT_RANGE_U10);
-
-	/* should take 10 us to settle, here's a hundred */
-	udelay(100);
-
-	/* read back the values */
-	ailo = dmm_inb(dev, DMM32AT_AILOW);
-	aihi = dmm_inb(dev, DMM32AT_AIHIGH);
-	fifostat = dmm_inb(dev, DMM32AT_FIFOSTAT);
-	aistat = dmm_inb(dev, DMM32AT_AISTAT);
-	intstat = dmm_inb(dev, DMM32AT_INTCLOCK);
-	airback = dmm_inb(dev, DMM32AT_AIRBACK);
-
-	printk(KERN_DEBUG "dmm32at: lo=0x%02x hi=0x%02x fifostat=0x%02x\n",
-	       ailo, aihi, fifostat);
-	printk(KERN_DEBUG
-	       "dmm32at: aistat=0x%02x intstat=0x%02x airback=0x%02x\n",
-	       aistat, intstat, airback);
-
-	if ((ailo != 0x00) || (aihi != 0x1f) || (fifostat != 0x80) ||
-	    (aistat != 0x60 || (intstat != 0x00) || airback != 0x0c)) {
-		printk(KERN_ERR "dmmat32: board detection failed\n");
-		return -EIO;
-	}
-
-	/* board is there, register interrupt */
-	if (irq) {
-		ret = request_irq(irq, dmm32at_isr, 0, board->name, dev);
-		if (ret < 0) {
-			printk(KERN_ERR "dmm32at: irq conflict\n");
-			return ret;
-		}
-		dev->irq = irq;
-	}
-
-	dev->board_name = board->name;
-
-/*
- * Allocate the private structure area.  alloc_private() is a
- * convenient macro defined in comedidev.h.
- */
-	if (alloc_private(dev, sizeof(struct dmm32at_private)) < 0)
-		return -ENOMEM;
-
-	ret = comedi_alloc_subdevices(dev, 3);
-	if (ret)
-		return ret;
-
-	s = dev->subdevices + 0;
-	dev->read_subdev = s;
-	/* analog input subdevice */
-	s->type = COMEDI_SUBD_AI;
-	/* we support single-ended (ground) and differential */
-	s->subdev_flags = SDF_READABLE | SDF_GROUND | SDF_DIFF | SDF_CMD_READ;
-	s->n_chan = board->ai_chans;
-	s->maxdata = (1 << board->ai_bits) - 1;
-	s->range_table = board->ai_ranges;
-	s->len_chanlist = 32;	/* This is the maximum chanlist length that
-				   the board can handle */
-	s->insn_read = dmm32at_ai_rinsn;
-	s->do_cmd = dmm32at_ai_cmd;
-	s->do_cmdtest = dmm32at_ai_cmdtest;
-	s->cancel = dmm32at_ai_cancel;
-
-	s = dev->subdevices + 1;
-	/* analog output subdevice */
-	s->type = COMEDI_SUBD_AO;
-	s->subdev_flags = SDF_WRITABLE;
-	s->n_chan = board->ao_chans;
-	s->maxdata = (1 << board->ao_bits) - 1;
-	s->range_table = board->ao_ranges;
-	s->insn_write = dmm32at_ao_winsn;
-	s->insn_read = dmm32at_ao_rinsn;
-
-	s = dev->subdevices + 2;
-	/* digital i/o subdevice */
-	if (board->have_dio) {
-
-		/* get access to the DIO regs */
-		dmm_outb(dev, DMM32AT_CNTRL, DMM32AT_DIOACC);
-		/* set the DIO's to the defualt input setting */
-		devpriv->dio_config = DMM32AT_DIRA | DMM32AT_DIRB |
-		    DMM32AT_DIRCL | DMM32AT_DIRCH | DMM32AT_DIENABLE;
-		dmm_outb(dev, DMM32AT_DIOCONF, devpriv->dio_config);
-
-		/* set up the subdevice */
-		s->type = COMEDI_SUBD_DIO;
-		s->subdev_flags = SDF_READABLE | SDF_WRITABLE;
-		s->n_chan = board->dio_chans;
-		s->maxdata = 1;
-		s->state = 0;
-		s->range_table = &range_digital;
-		s->insn_bits = dmm32at_dio_insn_bits;
-		s->insn_config = dmm32at_dio_insn_config;
-	} else {
-		s->type = COMEDI_SUBD_UNUSED;
-	}
-
-	/* success */
-	printk(KERN_INFO "comedi%d: dmm32at: attached\n", dev->minor);
-
-	return 1;
-
-}
-
-static void dmm32at_detach(struct comedi_device *dev)
-{
-	if (dev->irq)
-		free_irq(dev->irq, dev);
-	if (dev->iobase)
-		release_region(dev->iobase, DMM32AT_MEMSIZE);
-}
-
-/*
  * "instructions" read/write data in "one-shot" or "software-triggered"
  * mode.
  */
@@ -990,6 +789,178 @@ void dmm32at_setaitimer(struct comedi_device *dev, unsigned int nansec)
 
 }
 
+static int dmm32at_attach(struct comedi_device *dev,
+			  struct comedi_devconfig *it)
+{
+	const struct dmm32at_board *board = comedi_board(dev);
+	int ret;
+	struct comedi_subdevice *s;
+	unsigned char aihi, ailo, fifostat, aistat, intstat, airback;
+	unsigned long iobase;
+	unsigned int irq;
+
+	iobase = it->options[0];
+	irq = it->options[1];
+
+	printk(KERN_INFO "comedi%d: dmm32at: attaching\n", dev->minor);
+	printk(KERN_DEBUG "dmm32at: probing at address 0x%04lx, irq %u\n",
+	       iobase, irq);
+
+	/* register address space */
+	if (!request_region(iobase, DMM32AT_MEMSIZE, board->name)) {
+		printk(KERN_ERR "comedi%d: dmm32at: I/O port conflict\n",
+		       dev->minor);
+		return -EIO;
+	}
+	dev->iobase = iobase;
+
+	/* the following just makes sure the board is there and gets
+	   it to a known state */
+
+	/* reset the board */
+	dmm_outb(dev, DMM32AT_CNTRL, DMM32AT_RESET);
+
+	/* allow a millisecond to reset */
+	udelay(1000);
+
+	/* zero scan and fifo control */
+	dmm_outb(dev, DMM32AT_FIFOCNTRL, 0x0);
+
+	/* zero interrupt and clock control */
+	dmm_outb(dev, DMM32AT_INTCLOCK, 0x0);
+
+	/* write a test channel range, the high 3 bits should drop */
+	dmm_outb(dev, DMM32AT_AILOW, 0x80);
+	dmm_outb(dev, DMM32AT_AIHIGH, 0xff);
+
+	/* set the range at 10v unipolar */
+	dmm_outb(dev, DMM32AT_AICONF, DMM32AT_RANGE_U10);
+
+	/* should take 10 us to settle, here's a hundred */
+	udelay(100);
+
+	/* read back the values */
+	ailo = dmm_inb(dev, DMM32AT_AILOW);
+	aihi = dmm_inb(dev, DMM32AT_AIHIGH);
+	fifostat = dmm_inb(dev, DMM32AT_FIFOSTAT);
+	aistat = dmm_inb(dev, DMM32AT_AISTAT);
+	intstat = dmm_inb(dev, DMM32AT_INTCLOCK);
+	airback = dmm_inb(dev, DMM32AT_AIRBACK);
+
+	printk(KERN_DEBUG "dmm32at: lo=0x%02x hi=0x%02x fifostat=0x%02x\n",
+	       ailo, aihi, fifostat);
+	printk(KERN_DEBUG
+	       "dmm32at: aistat=0x%02x intstat=0x%02x airback=0x%02x\n",
+	       aistat, intstat, airback);
+
+	if ((ailo != 0x00) || (aihi != 0x1f) || (fifostat != 0x80) ||
+	    (aistat != 0x60 || (intstat != 0x00) || airback != 0x0c)) {
+		printk(KERN_ERR "dmmat32: board detection failed\n");
+		return -EIO;
+	}
+
+	/* board is there, register interrupt */
+	if (irq) {
+		ret = request_irq(irq, dmm32at_isr, 0, board->name, dev);
+		if (ret < 0) {
+			printk(KERN_ERR "dmm32at: irq conflict\n");
+			return ret;
+		}
+		dev->irq = irq;
+	}
+
+	dev->board_name = board->name;
+
+/*
+ * Allocate the private structure area.  alloc_private() is a
+ * convenient macro defined in comedidev.h.
+ */
+	if (alloc_private(dev, sizeof(struct dmm32at_private)) < 0)
+		return -ENOMEM;
+
+	ret = comedi_alloc_subdevices(dev, 3);
+	if (ret)
+		return ret;
+
+	s = dev->subdevices + 0;
+	dev->read_subdev = s;
+	/* analog input subdevice */
+	s->type = COMEDI_SUBD_AI;
+	/* we support single-ended (ground) and differential */
+	s->subdev_flags = SDF_READABLE | SDF_GROUND | SDF_DIFF | SDF_CMD_READ;
+	s->n_chan = board->ai_chans;
+	s->maxdata = (1 << board->ai_bits) - 1;
+	s->range_table = board->ai_ranges;
+	s->len_chanlist = 32;	/* This is the maximum chanlist length that
+				   the board can handle */
+	s->insn_read = dmm32at_ai_rinsn;
+	s->do_cmd = dmm32at_ai_cmd;
+	s->do_cmdtest = dmm32at_ai_cmdtest;
+	s->cancel = dmm32at_ai_cancel;
+
+	s = dev->subdevices + 1;
+	/* analog output subdevice */
+	s->type = COMEDI_SUBD_AO;
+	s->subdev_flags = SDF_WRITABLE;
+	s->n_chan = board->ao_chans;
+	s->maxdata = (1 << board->ao_bits) - 1;
+	s->range_table = board->ao_ranges;
+	s->insn_write = dmm32at_ao_winsn;
+	s->insn_read = dmm32at_ao_rinsn;
+
+	s = dev->subdevices + 2;
+	/* digital i/o subdevice */
+	if (board->have_dio) {
+
+		/* get access to the DIO regs */
+		dmm_outb(dev, DMM32AT_CNTRL, DMM32AT_DIOACC);
+		/* set the DIO's to the defualt input setting */
+		devpriv->dio_config = DMM32AT_DIRA | DMM32AT_DIRB |
+		    DMM32AT_DIRCL | DMM32AT_DIRCH | DMM32AT_DIENABLE;
+		dmm_outb(dev, DMM32AT_DIOCONF, devpriv->dio_config);
+
+		/* set up the subdevice */
+		s->type = COMEDI_SUBD_DIO;
+		s->subdev_flags = SDF_READABLE | SDF_WRITABLE;
+		s->n_chan = board->dio_chans;
+		s->maxdata = 1;
+		s->state = 0;
+		s->range_table = &range_digital;
+		s->insn_bits = dmm32at_dio_insn_bits;
+		s->insn_config = dmm32at_dio_insn_config;
+	} else {
+		s->type = COMEDI_SUBD_UNUSED;
+	}
+
+	/* success */
+	printk(KERN_INFO "comedi%d: dmm32at: attached\n", dev->minor);
+
+	return 1;
+
+}
+
+static void dmm32at_detach(struct comedi_device *dev)
+{
+	if (dev->irq)
+		free_irq(dev->irq, dev);
+	if (dev->iobase)
+		release_region(dev->iobase, DMM32AT_MEMSIZE);
+}
+
+static const struct dmm32at_board dmm32at_boards[] = {
+	{
+		.name		= "dmm32at",
+		.ai_chans	= 32,
+		.ai_bits	= 16,
+		.ai_ranges	= &dmm32at_airanges,
+		.ao_chans	= 4,
+		.ao_bits	= 12,
+		.ao_ranges	= &dmm32at_aoranges,
+		.have_dio	= 1,
+		.dio_chans	= 24,
+	},
+};
+
 static struct comedi_driver dmm32at_driver = {
 	.driver_name	= "dmm32at",
 	.module		= THIS_MODULE,
-- 
1.7.11

