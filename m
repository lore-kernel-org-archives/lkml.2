Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755488Ab2EXBT2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 21:19:28 -0400
Received: from mail209.messagelabs.com ([216.82.255.3]:27517 "EHLO
	mail209.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751409Ab2EXBT0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 21:19:26 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-16.tower-209.messagelabs.com!1337822364!6488596!1
X-Originating-IP: [216.166.12.69]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] staging: comedi: das1800: complete the refactor to remove all forward declarations
Date: Wed, 23 May 2012 18:19:17 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201205231819.17687.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Complete the refactor of the das1800 driver to remove all the
forward declarations.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---

No code changes here, just moving of the functions. This file
still has a lot of checkpatch warnings that will be addressed.

 drivers/staging/comedi/drivers/das1800.c | 1242 ++++++++++++++----------------
 1 files changed, 598 insertions(+), 644 deletions(-)

diff --git a/drivers/staging/comedi/drivers/das1800.c b/drivers/staging/comedi/drivers/das1800.c
index 2ac3443..079fb06 100644
--- a/drivers/staging/comedi/drivers/das1800.c
+++ b/drivers/staging/comedi/drivers/das1800.c
@@ -183,46 +183,6 @@ enum {
 	das1802hr, das1802hr_da, das1801hc, das1802hc, das1801ao, das1802ao
 };
 
-static int das1800_probe(struct comedi_device *dev);
-static int das1800_cancel(struct comedi_device *dev,
-			  struct comedi_subdevice *s);
-static irqreturn_t das1800_interrupt(int irq, void *d);
-static int das1800_ai_poll(struct comedi_device *dev,
-			   struct comedi_subdevice *s);
-static void das1800_ai_handler(struct comedi_device *dev);
-static void das1800_handle_dma(struct comedi_device *dev,
-			       struct comedi_subdevice *s, unsigned int status);
-static void das1800_flush_dma(struct comedi_device *dev,
-			      struct comedi_subdevice *s);
-static void das1800_flush_dma_channel(struct comedi_device *dev,
-				      struct comedi_subdevice *s,
-				      unsigned int channel, uint16_t *buffer);
-static void das1800_handle_fifo_half_full(struct comedi_device *dev,
-					  struct comedi_subdevice *s);
-static void das1800_handle_fifo_not_empty(struct comedi_device *dev,
-					  struct comedi_subdevice *s);
-static int das1800_ai_do_cmdtest(struct comedi_device *dev,
-				 struct comedi_subdevice *s,
-				 struct comedi_cmd *cmd);
-static int das1800_ai_do_cmd(struct comedi_device *dev,
-			     struct comedi_subdevice *s);
-static int das1800_ai_rinsn(struct comedi_device *dev,
-			    struct comedi_subdevice *s,
-			    struct comedi_insn *insn, unsigned int *data);
-static int das1800_ao_winsn(struct comedi_device *dev,
-			    struct comedi_subdevice *s,
-			    struct comedi_insn *insn, unsigned int *data);
-static int das1800_di_rbits(struct comedi_device *dev,
-			    struct comedi_subdevice *s,
-			    struct comedi_insn *insn, unsigned int *data);
-static int das1800_do_wbits(struct comedi_device *dev,
-			    struct comedi_subdevice *s,
-			    struct comedi_insn *insn, unsigned int *data);
-
-static int das1800_set_frequency(struct comedi_device *dev);
-static unsigned int burst_convert_arg(unsigned int convert_arg, int round_mode);
-static unsigned int suggest_transfer_size(struct comedi_cmd *cmd);
-
 /* analog input ranges */
 static const struct comedi_lrange range_ai_das1801 = {
 	8,
@@ -515,491 +475,6 @@ static const struct comedi_lrange range_ao_2 = {
 };
 */
 
-static int das1800_init_dma(struct comedi_device *dev, unsigned int dma0,
-			    unsigned int dma1)
-{
-	unsigned long flags;
-
-	/*  need an irq to do dma */
-	if (dev->irq && dma0) {
-		/* encode dma0 and dma1 into 2 digit hexadecimal for switch */
-		switch ((dma0 & 0x7) | (dma1 << 4)) {
-		case 0x5:	/*  dma0 == 5 */
-			devpriv->dma_bits |= DMA_CH5;
-			break;
-		case 0x6:	/*  dma0 == 6 */
-			devpriv->dma_bits |= DMA_CH6;
-			break;
-		case 0x7:	/*  dma0 == 7 */
-			devpriv->dma_bits |= DMA_CH7;
-			break;
-		case 0x65:	/*  dma0 == 5, dma1 == 6 */
-			devpriv->dma_bits |= DMA_CH5_CH6;
-			break;
-		case 0x76:	/*  dma0 == 6, dma1 == 7 */
-			devpriv->dma_bits |= DMA_CH6_CH7;
-			break;
-		case 0x57:	/*  dma0 == 7, dma1 == 5 */
-			devpriv->dma_bits |= DMA_CH7_CH5;
-			break;
-		default:
-			dev_err(dev->hw_dev, " only supports dma channels 5 through 7\n"
-				" Dual dma only allows the following combinations:\n"
-				" dma 5,6 / 6,7 / or 7,5\n");
-			return -EINVAL;
-			break;
-		}
-		if (request_dma(dma0, dev->driver->driver_name)) {
-			dev_err(dev->hw_dev, "failed to allocate dma channel %i\n",
-				dma0);
-			return -EINVAL;
-		}
-		devpriv->dma0 = dma0;
-		devpriv->dma_current = dma0;
-		if (dma1) {
-			if (request_dma(dma1, dev->driver->driver_name)) {
-				dev_err(dev->hw_dev, "failed to allocate dma channel %i\n",
-					dma1);
-				return -EINVAL;
-			}
-			devpriv->dma1 = dma1;
-		}
-		devpriv->ai_buf0 = kmalloc(DMA_BUF_SIZE, GFP_KERNEL | GFP_DMA);
-		if (devpriv->ai_buf0 == NULL)
-			return -ENOMEM;
-		devpriv->dma_current_buf = devpriv->ai_buf0;
-		if (dma1) {
-			devpriv->ai_buf1 =
-			    kmalloc(DMA_BUF_SIZE, GFP_KERNEL | GFP_DMA);
-			if (devpriv->ai_buf1 == NULL)
-				return -ENOMEM;
-		}
-		flags = claim_dma_lock();
-		disable_dma(devpriv->dma0);
-		set_dma_mode(devpriv->dma0, DMA_MODE_READ);
-		if (dma1) {
-			disable_dma(devpriv->dma1);
-			set_dma_mode(devpriv->dma1, DMA_MODE_READ);
-		}
-		release_dma_lock(flags);
-	}
-	return 0;
-}
-
-static int das1800_attach(struct comedi_device *dev,
-			  struct comedi_devconfig *it)
-{
-	struct comedi_subdevice *s;
-	unsigned long iobase = it->options[0];
-	unsigned int irq = it->options[1];
-	unsigned int dma0 = it->options[2];
-	unsigned int dma1 = it->options[3];
-	unsigned long iobase2;
-	int board;
-	int retval;
-
-	/* allocate and initialize dev->private */
-	if (alloc_private(dev, sizeof(struct das1800_private)) < 0)
-		return -ENOMEM;
-
-	printk(KERN_DEBUG "comedi%d: %s: io 0x%lx", dev->minor,
-	       dev->driver->driver_name, iobase);
-	if (irq) {
-		printk(KERN_CONT ", irq %u", irq);
-		if (dma0) {
-			printk(KERN_CONT ", dma %u", dma0);
-			if (dma1)
-				printk(KERN_CONT " and %u", dma1);
-		}
-	}
-	printk(KERN_CONT "\n");
-
-	if (iobase == 0) {
-		dev_err(dev->hw_dev, "io base address required\n");
-		return -EINVAL;
-	}
-
-	/* check if io addresses are available */
-	if (!request_region(iobase, DAS1800_SIZE, dev->driver->driver_name)) {
-		printk
-		    (" I/O port conflict: failed to allocate ports 0x%lx to 0x%lx\n",
-		     iobase, iobase + DAS1800_SIZE - 1);
-		return -EIO;
-	}
-	dev->iobase = iobase;
-
-	board = das1800_probe(dev);
-	if (board < 0) {
-		dev_err(dev->hw_dev, "unable to determine board type\n");
-		return -ENODEV;
-	}
-
-	dev->board_ptr = das1800_boards + board;
-	dev->board_name = thisboard->name;
-
-	/*  if it is an 'ao' board with fancy analog out then we need extra io ports */
-	if (thisboard->ao_ability == 2) {
-		iobase2 = iobase + IOBASE2;
-		if (!request_region(iobase2, DAS1800_SIZE,
-				    dev->driver->driver_name)) {
-			printk
-			    (" I/O port conflict: failed to allocate ports 0x%lx to 0x%lx\n",
-			     iobase2, iobase2 + DAS1800_SIZE - 1);
-			return -EIO;
-		}
-		devpriv->iobase2 = iobase2;
-	}
-
-	/* grab our IRQ */
-	if (irq) {
-		if (request_irq(irq, das1800_interrupt, 0,
-				dev->driver->driver_name, dev)) {
-			dev_dbg(dev->hw_dev, "unable to allocate irq %u\n",
-				irq);
-			return -EINVAL;
-		}
-	}
-	dev->irq = irq;
-
-	/*  set bits that tell card which irq to use */
-	switch (irq) {
-	case 0:
-		break;
-	case 3:
-		devpriv->irq_dma_bits |= 0x8;
-		break;
-	case 5:
-		devpriv->irq_dma_bits |= 0x10;
-		break;
-	case 7:
-		devpriv->irq_dma_bits |= 0x18;
-		break;
-	case 10:
-		devpriv->irq_dma_bits |= 0x28;
-		break;
-	case 11:
-		devpriv->irq_dma_bits |= 0x30;
-		break;
-	case 15:
-		devpriv->irq_dma_bits |= 0x38;
-		break;
-	default:
-		dev_err(dev->hw_dev, "irq out of range\n");
-		return -EINVAL;
-		break;
-	}
-
-	retval = das1800_init_dma(dev, dma0, dma1);
-	if (retval < 0)
-		return retval;
-
-	if (devpriv->ai_buf0 == NULL) {
-		devpriv->ai_buf0 =
-		    kmalloc(FIFO_SIZE * sizeof(uint16_t), GFP_KERNEL);
-		if (devpriv->ai_buf0 == NULL)
-			return -ENOMEM;
-	}
-
-	if (alloc_subdevices(dev, 4) < 0)
-		return -ENOMEM;
-
-	/* analog input subdevice */
-	s = dev->subdevices + 0;
-	dev->read_subdev = s;
-	s->type = COMEDI_SUBD_AI;
-	s->subdev_flags = SDF_READABLE | SDF_DIFF | SDF_GROUND | SDF_CMD_READ;
-	if (thisboard->common)
-		s->subdev_flags |= SDF_COMMON;
-	s->n_chan = thisboard->qram_len;
-	s->len_chanlist = thisboard->qram_len;
-	s->maxdata = (1 << thisboard->resolution) - 1;
-	s->range_table = thisboard->range_ai;
-	s->do_cmd = das1800_ai_do_cmd;
-	s->do_cmdtest = das1800_ai_do_cmdtest;
-	s->insn_read = das1800_ai_rinsn;
-	s->poll = das1800_ai_poll;
-	s->cancel = das1800_cancel;
-
-	/* analog out */
-	s = dev->subdevices + 1;
-	if (thisboard->ao_ability == 1) {
-		s->type = COMEDI_SUBD_AO;
-		s->subdev_flags = SDF_WRITABLE;
-		s->n_chan = thisboard->ao_n_chan;
-		s->maxdata = (1 << thisboard->resolution) - 1;
-		s->range_table = &range_ao_1;
-		s->insn_write = das1800_ao_winsn;
-	} else {
-		s->type = COMEDI_SUBD_UNUSED;
-	}
-
-	/* di */
-	s = dev->subdevices + 2;
-	s->type = COMEDI_SUBD_DI;
-	s->subdev_flags = SDF_READABLE;
-	s->n_chan = 4;
-	s->maxdata = 1;
-	s->range_table = &range_digital;
-	s->insn_bits = das1800_di_rbits;
-
-	/* do */
-	s = dev->subdevices + 3;
-	s->type = COMEDI_SUBD_DO;
-	s->subdev_flags = SDF_WRITABLE | SDF_READABLE;
-	s->n_chan = thisboard->do_n_chan;
-	s->maxdata = 1;
-	s->range_table = &range_digital;
-	s->insn_bits = das1800_do_wbits;
-
-	das1800_cancel(dev, dev->read_subdev);
-
-	/*  initialize digital out channels */
-	outb(devpriv->do_bits, dev->iobase + DAS1800_DIGITAL);
-
-	/*  initialize analog out channels */
-	if (thisboard->ao_ability == 1) {
-		/*  select 'update' dac channel for baseAddress + 0x0 */
-		outb(DAC(thisboard->ao_n_chan - 1),
-		     dev->iobase + DAS1800_SELECT);
-		outw(devpriv->ao_update_bits, dev->iobase + DAS1800_DAC);
-	}
-
-	return 0;
-};
-
-static void das1800_detach(struct comedi_device *dev)
-{
-	if (dev->iobase)
-		release_region(dev->iobase, DAS1800_SIZE);
-	if (dev->irq)
-		free_irq(dev->irq, dev);
-	if (dev->private) {
-		if (devpriv->iobase2)
-			release_region(devpriv->iobase2, DAS1800_SIZE);
-		if (devpriv->dma0)
-			free_dma(devpriv->dma0);
-		if (devpriv->dma1)
-			free_dma(devpriv->dma1);
-		kfree(devpriv->ai_buf0);
-		kfree(devpriv->ai_buf1);
-	}
-};
-
-/* probes and checks das-1800 series board type
- */
-static int das1800_probe(struct comedi_device *dev)
-{
-	int id;
-	int board;
-
-	id = (inb(dev->iobase + DAS1800_DIGITAL) >> 4) & 0xf;	/* get id bits */
-	board = ((struct das1800_board *)dev->board_ptr) - das1800_boards;
-
-	switch (id) {
-	case 0x3:
-		if (board == das1801st_da || board == das1802st_da ||
-		    board == das1701st_da || board == das1702st_da) {
-			dev_dbg(dev->hw_dev, "Board model: %s\n",
-				das1800_boards[board].name);
-			return board;
-		}
-		printk
-		    (" Board model (probed, not recommended): das-1800st-da series\n");
-		return das1801st;
-		break;
-	case 0x4:
-		if (board == das1802hr_da || board == das1702hr_da) {
-			dev_dbg(dev->hw_dev, "Board model: %s\n",
-				das1800_boards[board].name);
-			return board;
-		}
-		printk
-		    (" Board model (probed, not recommended): das-1802hr-da\n");
-		return das1802hr;
-		break;
-	case 0x5:
-		if (board == das1801ao || board == das1802ao ||
-		    board == das1701ao || board == das1702ao) {
-			dev_dbg(dev->hw_dev, "Board model: %s\n",
-				das1800_boards[board].name);
-			return board;
-		}
-		printk
-		    (" Board model (probed, not recommended): das-1800ao series\n");
-		return das1801ao;
-		break;
-	case 0x6:
-		if (board == das1802hr || board == das1702hr) {
-			dev_dbg(dev->hw_dev, "Board model: %s\n",
-				das1800_boards[board].name);
-			return board;
-		}
-		printk
-		    (" Board model (probed, not recommended): das-1802hr\n");
-		return das1802hr;
-		break;
-	case 0x7:
-		if (board == das1801st || board == das1802st ||
-		    board == das1701st || board == das1702st) {
-			dev_dbg(dev->hw_dev, "Board model: %s\n",
-				das1800_boards[board].name);
-			return board;
-		}
-		printk
-		    (" Board model (probed, not recommended): das-1800st series\n");
-		return das1801st;
-		break;
-	case 0x8:
-		if (board == das1801hc || board == das1802hc) {
-			dev_dbg(dev->hw_dev, "Board model: %s\n",
-				das1800_boards[board].name);
-			return board;
-		}
-		printk
-		    (" Board model (probed, not recommended): das-1800hc series\n");
-		return das1801hc;
-		break;
-	default:
-		printk
-		    (" Board model: probe returned 0x%x (unknown, please report)\n",
-		     id);
-		return board;
-		break;
-	}
-	return -1;
-}
-
-static int das1800_ai_poll(struct comedi_device *dev,
-			   struct comedi_subdevice *s)
-{
-	unsigned long flags;
-
-	/*  prevent race with interrupt handler */
-	spin_lock_irqsave(&dev->spinlock, flags);
-	das1800_ai_handler(dev);
-	spin_unlock_irqrestore(&dev->spinlock, flags);
-
-	return s->async->buf_write_count - s->async->buf_read_count;
-}
-
-static irqreturn_t das1800_interrupt(int irq, void *d)
-{
-	struct comedi_device *dev = d;
-	unsigned int status;
-
-	if (dev->attached == 0) {
-		comedi_error(dev, "premature interrupt");
-		return IRQ_HANDLED;
-	}
-
-	/* Prevent race with das1800_ai_poll() on multi processor systems.
-	 * Also protects indirect addressing in das1800_ai_handler */
-	spin_lock(&dev->spinlock);
-	status = inb(dev->iobase + DAS1800_STATUS);
-
-	/* if interrupt was not caused by das-1800 */
-	if (!(status & INT)) {
-		spin_unlock(&dev->spinlock);
-		return IRQ_NONE;
-	}
-	/* clear the interrupt status bit INT */
-	outb(CLEAR_INTR_MASK & ~INT, dev->iobase + DAS1800_STATUS);
-	/*  handle interrupt */
-	das1800_ai_handler(dev);
-
-	spin_unlock(&dev->spinlock);
-	return IRQ_HANDLED;
-}
-
-/* the guts of the interrupt handler, that is shared with das1800_ai_poll */
-static void das1800_ai_handler(struct comedi_device *dev)
-{
-	struct comedi_subdevice *s = dev->subdevices + 0;	/* analog input subdevice */
-	struct comedi_async *async = s->async;
-	struct comedi_cmd *cmd = &async->cmd;
-	unsigned int status = inb(dev->iobase + DAS1800_STATUS);
-
-	async->events = 0;
-	/*  select adc for base address + 0 */
-	outb(ADC, dev->iobase + DAS1800_SELECT);
-	/*  dma buffer full */
-	if (devpriv->irq_dma_bits & DMA_ENABLED) {
-		/*  look for data from dma transfer even if dma terminal count hasn't happened yet */
-		das1800_handle_dma(dev, s, status);
-	} else if (status & FHF) {	/*  if fifo half full */
-		das1800_handle_fifo_half_full(dev, s);
-	} else if (status & FNE) {	/*  if fifo not empty */
-		das1800_handle_fifo_not_empty(dev, s);
-	}
-
-	async->events |= COMEDI_CB_BLOCK;
-	/* if the card's fifo has overflowed */
-	if (status & OVF) {
-		/*  clear OVF interrupt bit */
-		outb(CLEAR_INTR_MASK & ~OVF, dev->iobase + DAS1800_STATUS);
-		comedi_error(dev, "DAS1800 FIFO overflow");
-		das1800_cancel(dev, s);
-		async->events |= COMEDI_CB_ERROR | COMEDI_CB_EOA;
-		comedi_event(dev, s);
-		return;
-	}
-	/*  stop taking data if appropriate */
-	/* stop_src TRIG_EXT */
-	if (status & CT0TC) {
-		/*  clear CT0TC interrupt bit */
-		outb(CLEAR_INTR_MASK & ~CT0TC, dev->iobase + DAS1800_STATUS);
-		/*  make sure we get all remaining data from board before quitting */
-		if (devpriv->irq_dma_bits & DMA_ENABLED)
-			das1800_flush_dma(dev, s);
-		else
-			das1800_handle_fifo_not_empty(dev, s);
-		das1800_cancel(dev, s);	/* disable hardware conversions */
-		async->events |= COMEDI_CB_EOA;
-	} else if (cmd->stop_src == TRIG_COUNT && devpriv->count == 0) {	/*  stop_src TRIG_COUNT */
-		das1800_cancel(dev, s);	/* disable hardware conversions */
-		async->events |= COMEDI_CB_EOA;
-	}
-
-	comedi_event(dev, s);
-
-	return;
-}
-
-static void das1800_handle_dma(struct comedi_device *dev,
-			       struct comedi_subdevice *s, unsigned int status)
-{
-	unsigned long flags;
-	const int dual_dma = devpriv->irq_dma_bits & DMA_DUAL;
-
-	flags = claim_dma_lock();
-	das1800_flush_dma_channel(dev, s, devpriv->dma_current,
-				  devpriv->dma_current_buf);
-	/*  re-enable  dma channel */
-	set_dma_addr(devpriv->dma_current,
-		     virt_to_bus(devpriv->dma_current_buf));
-	set_dma_count(devpriv->dma_current, devpriv->dma_transfer_size);
-	enable_dma(devpriv->dma_current);
-	release_dma_lock(flags);
-
-	if (status & DMATC) {
-		/*  clear DMATC interrupt bit */
-		outb(CLEAR_INTR_MASK & ~DMATC, dev->iobase + DAS1800_STATUS);
-		/*  switch dma channels for next time, if appropriate */
-		if (dual_dma) {
-			/*  read data from the other channel next time */
-			if (devpriv->dma_current == devpriv->dma0) {
-				devpriv->dma_current = devpriv->dma1;
-				devpriv->dma_current_buf = devpriv->ai_buf1;
-			} else {
-				devpriv->dma_current = devpriv->dma0;
-				devpriv->dma_current_buf = devpriv->ai_buf0;
-			}
-		}
-	}
-
-	return;
-}
-
 static inline uint16_t munge_bipolar_sample(const struct comedi_device *dev,
 					    uint16_t sample)
 {
@@ -1023,6 +498,50 @@ static void munge_data(struct comedi_device *dev, uint16_t * array,
 	}
 }
 
+static void das1800_handle_fifo_half_full(struct comedi_device *dev,
+					  struct comedi_subdevice *s)
+{
+	int numPoints = 0;	/* number of points to read */
+	struct comedi_cmd *cmd = &s->async->cmd;
+
+	numPoints = FIFO_SIZE / 2;
+	/* if we only need some of the points */
+	if (cmd->stop_src == TRIG_COUNT && devpriv->count < numPoints)
+		numPoints = devpriv->count;
+	insw(dev->iobase + DAS1800_FIFO, devpriv->ai_buf0, numPoints);
+	munge_data(dev, devpriv->ai_buf0, numPoints);
+	cfc_write_array_to_buffer(s, devpriv->ai_buf0,
+				  numPoints * sizeof(devpriv->ai_buf0[0]));
+	if (cmd->stop_src == TRIG_COUNT)
+		devpriv->count -= numPoints;
+	return;
+}
+
+static void das1800_handle_fifo_not_empty(struct comedi_device *dev,
+					  struct comedi_subdevice *s)
+{
+	short dpnt;
+	int unipolar;
+	struct comedi_cmd *cmd = &s->async->cmd;
+
+	unipolar = inb(dev->iobase + DAS1800_CONTROL_C) & UB;
+
+	while (inb(dev->iobase + DAS1800_STATUS) & FNE) {
+		if (cmd->stop_src == TRIG_COUNT && devpriv->count == 0)
+			break;
+		dpnt = inw(dev->iobase + DAS1800_FIFO);
+		/* convert to unsigned type if we are in a bipolar mode */
+		if (!unipolar)
+			;
+		dpnt = munge_bipolar_sample(dev, dpnt);
+		cfc_write_to_buffer(s, dpnt);
+		if (cmd->stop_src == TRIG_COUNT)
+			devpriv->count--;
+	}
+
+	return;
+}
+
 /* Utility function used by das1800_flush_dma() and das1800_handle_dma().
  * Assumes dma lock is held */
 static void das1800_flush_dma_channel(struct comedi_device *dev,
@@ -1087,45 +606,36 @@ static void das1800_flush_dma(struct comedi_device *dev,
 	return;
 }
 
-static void das1800_handle_fifo_half_full(struct comedi_device *dev,
-					  struct comedi_subdevice *s)
+static void das1800_handle_dma(struct comedi_device *dev,
+			       struct comedi_subdevice *s, unsigned int status)
 {
-	int numPoints = 0;	/* number of points to read */
-	struct comedi_cmd *cmd = &s->async->cmd;
+	unsigned long flags;
+	const int dual_dma = devpriv->irq_dma_bits & DMA_DUAL;
 
-	numPoints = FIFO_SIZE / 2;
-	/* if we only need some of the points */
-	if (cmd->stop_src == TRIG_COUNT && devpriv->count < numPoints)
-		numPoints = devpriv->count;
-	insw(dev->iobase + DAS1800_FIFO, devpriv->ai_buf0, numPoints);
-	munge_data(dev, devpriv->ai_buf0, numPoints);
-	cfc_write_array_to_buffer(s, devpriv->ai_buf0,
-				  numPoints * sizeof(devpriv->ai_buf0[0]));
-	if (cmd->stop_src == TRIG_COUNT)
-		devpriv->count -= numPoints;
-	return;
-}
+	flags = claim_dma_lock();
+	das1800_flush_dma_channel(dev, s, devpriv->dma_current,
+				  devpriv->dma_current_buf);
+	/*  re-enable  dma channel */
+	set_dma_addr(devpriv->dma_current,
+		     virt_to_bus(devpriv->dma_current_buf));
+	set_dma_count(devpriv->dma_current, devpriv->dma_transfer_size);
+	enable_dma(devpriv->dma_current);
+	release_dma_lock(flags);
 
-static void das1800_handle_fifo_not_empty(struct comedi_device *dev,
-					  struct comedi_subdevice *s)
-{
-	short dpnt;
-	int unipolar;
-	struct comedi_cmd *cmd = &s->async->cmd;
-
-	unipolar = inb(dev->iobase + DAS1800_CONTROL_C) & UB;
-
-	while (inb(dev->iobase + DAS1800_STATUS) & FNE) {
-		if (cmd->stop_src == TRIG_COUNT && devpriv->count == 0)
-			break;
-		dpnt = inw(dev->iobase + DAS1800_FIFO);
-		/* convert to unsigned type if we are in a bipolar mode */
-		if (!unipolar)
-			;
-		dpnt = munge_bipolar_sample(dev, dpnt);
-		cfc_write_to_buffer(s, dpnt);
-		if (cmd->stop_src == TRIG_COUNT)
-			devpriv->count--;
+	if (status & DMATC) {
+		/*  clear DMATC interrupt bit */
+		outb(CLEAR_INTR_MASK & ~DMATC, dev->iobase + DAS1800_STATUS);
+		/*  switch dma channels for next time, if appropriate */
+		if (dual_dma) {
+			/*  read data from the other channel next time */
+			if (devpriv->dma_current == devpriv->dma0) {
+				devpriv->dma_current = devpriv->dma1;
+				devpriv->dma_current_buf = devpriv->ai_buf1;
+			} else {
+				devpriv->dma_current = devpriv->dma0;
+				devpriv->dma_current_buf = devpriv->ai_buf0;
+			}
+		}
 	}
 
 	return;
@@ -1143,6 +653,131 @@ static int das1800_cancel(struct comedi_device *dev, struct comedi_subdevice *s)
 	return 0;
 }
 
+/* the guts of the interrupt handler, that is shared with das1800_ai_poll */
+static void das1800_ai_handler(struct comedi_device *dev)
+{
+	struct comedi_subdevice *s = dev->subdevices + 0;	/* analog input subdevice */
+	struct comedi_async *async = s->async;
+	struct comedi_cmd *cmd = &async->cmd;
+	unsigned int status = inb(dev->iobase + DAS1800_STATUS);
+
+	async->events = 0;
+	/*  select adc for base address + 0 */
+	outb(ADC, dev->iobase + DAS1800_SELECT);
+	/*  dma buffer full */
+	if (devpriv->irq_dma_bits & DMA_ENABLED) {
+		/*  look for data from dma transfer even if dma terminal count hasn't happened yet */
+		das1800_handle_dma(dev, s, status);
+	} else if (status & FHF) {	/*  if fifo half full */
+		das1800_handle_fifo_half_full(dev, s);
+	} else if (status & FNE) {	/*  if fifo not empty */
+		das1800_handle_fifo_not_empty(dev, s);
+	}
+
+	async->events |= COMEDI_CB_BLOCK;
+	/* if the card's fifo has overflowed */
+	if (status & OVF) {
+		/*  clear OVF interrupt bit */
+		outb(CLEAR_INTR_MASK & ~OVF, dev->iobase + DAS1800_STATUS);
+		comedi_error(dev, "DAS1800 FIFO overflow");
+		das1800_cancel(dev, s);
+		async->events |= COMEDI_CB_ERROR | COMEDI_CB_EOA;
+		comedi_event(dev, s);
+		return;
+	}
+	/*  stop taking data if appropriate */
+	/* stop_src TRIG_EXT */
+	if (status & CT0TC) {
+		/*  clear CT0TC interrupt bit */
+		outb(CLEAR_INTR_MASK & ~CT0TC, dev->iobase + DAS1800_STATUS);
+		/*  make sure we get all remaining data from board before quitting */
+		if (devpriv->irq_dma_bits & DMA_ENABLED)
+			das1800_flush_dma(dev, s);
+		else
+			das1800_handle_fifo_not_empty(dev, s);
+		das1800_cancel(dev, s);	/* disable hardware conversions */
+		async->events |= COMEDI_CB_EOA;
+	} else if (cmd->stop_src == TRIG_COUNT && devpriv->count == 0) {	/*  stop_src TRIG_COUNT */
+		das1800_cancel(dev, s);	/* disable hardware conversions */
+		async->events |= COMEDI_CB_EOA;
+	}
+
+	comedi_event(dev, s);
+
+	return;
+}
+
+static int das1800_ai_poll(struct comedi_device *dev,
+			   struct comedi_subdevice *s)
+{
+	unsigned long flags;
+
+	/*  prevent race with interrupt handler */
+	spin_lock_irqsave(&dev->spinlock, flags);
+	das1800_ai_handler(dev);
+	spin_unlock_irqrestore(&dev->spinlock, flags);
+
+	return s->async->buf_write_count - s->async->buf_read_count;
+}
+
+static irqreturn_t das1800_interrupt(int irq, void *d)
+{
+	struct comedi_device *dev = d;
+	unsigned int status;
+
+	if (dev->attached == 0) {
+		comedi_error(dev, "premature interrupt");
+		return IRQ_HANDLED;
+	}
+
+	/* Prevent race with das1800_ai_poll() on multi processor systems.
+	 * Also protects indirect addressing in das1800_ai_handler */
+	spin_lock(&dev->spinlock);
+	status = inb(dev->iobase + DAS1800_STATUS);
+
+	/* if interrupt was not caused by das-1800 */
+	if (!(status & INT)) {
+		spin_unlock(&dev->spinlock);
+		return IRQ_NONE;
+	}
+	/* clear the interrupt status bit INT */
+	outb(CLEAR_INTR_MASK & ~INT, dev->iobase + DAS1800_STATUS);
+	/*  handle interrupt */
+	das1800_ai_handler(dev);
+
+	spin_unlock(&dev->spinlock);
+	return IRQ_HANDLED;
+}
+
+/* converts requested conversion timing to timing compatible with
+ * hardware, used only when card is in 'burst mode'
+ */
+static unsigned int burst_convert_arg(unsigned int convert_arg, int round_mode)
+{
+	unsigned int micro_sec;
+
+	/*  in burst mode, the maximum conversion time is 64 microseconds */
+	if (convert_arg > 64000)
+		convert_arg = 64000;
+
+	/*  the conversion time must be an integral number of microseconds */
+	switch (round_mode) {
+	case TRIG_ROUND_NEAREST:
+	default:
+		micro_sec = (convert_arg + 500) / 1000;
+		break;
+	case TRIG_ROUND_DOWN:
+		micro_sec = convert_arg / 1000;
+		break;
+	case TRIG_ROUND_UP:
+		micro_sec = (convert_arg - 1) / 1000 + 1;
+		break;
+	}
+
+	/*  return number of nanoseconds */
+	return micro_sec * 1000;
+}
+
 /* test analog input cmd */
 static int das1800_ai_do_cmdtest(struct comedi_device *dev,
 				 struct comedi_subdevice *s,
@@ -1322,10 +957,6 @@ static int das1800_ai_do_cmdtest(struct comedi_device *dev,
 	return 0;
 }
 
-/* analog input cmd interface */
-
-/* first, some utility functions used in the main ai_do_cmd() */
-
 /* returns appropriate bits for control register a, depending on command */
 static int control_a_bits(struct comedi_cmd cmd)
 {
@@ -1396,6 +1027,25 @@ static int control_c_bits(struct comedi_cmd cmd)
 	return control_c;
 }
 
+/* loads counters with divisor1, divisor2 from private structure */
+static int das1800_set_frequency(struct comedi_device *dev)
+{
+	int err = 0;
+
+	/*  counter 1, mode 2 */
+	if (i8254_load(dev->iobase + DAS1800_COUNTER, 0, 1, devpriv->divisor1,
+		       2))
+		err++;
+	/*  counter 2, mode 2 */
+	if (i8254_load(dev->iobase + DAS1800_COUNTER, 0, 2, devpriv->divisor2,
+		       2))
+		err++;
+	if (err)
+		return -1;
+
+	return 0;
+}
+
 /* sets up counters */
 static int setup_counters(struct comedi_device *dev, struct comedi_cmd cmd)
 {
@@ -1436,6 +1086,44 @@ static int setup_counters(struct comedi_device *dev, struct comedi_cmd cmd)
 	return 0;
 }
 
+/* utility function that suggests a dma transfer size based on the conversion period 'ns' */
+static unsigned int suggest_transfer_size(struct comedi_cmd *cmd)
+{
+	unsigned int size = DMA_BUF_SIZE;
+	static const int sample_size = 2;	/*  size in bytes of one sample from board */
+	unsigned int fill_time = 300000000;	/*  target time in nanoseconds for filling dma buffer */
+	unsigned int max_size;	/*  maximum size we will allow for a transfer */
+
+	/*  make dma buffer fill in 0.3 seconds for timed modes */
+	switch (cmd->scan_begin_src) {
+	case TRIG_FOLLOW:	/*  not in burst mode */
+		if (cmd->convert_src == TRIG_TIMER)
+			size = (fill_time / cmd->convert_arg) * sample_size;
+		break;
+	case TRIG_TIMER:
+		size = (fill_time / (cmd->scan_begin_arg * cmd->chanlist_len)) *
+		    sample_size;
+		break;
+	default:
+		size = DMA_BUF_SIZE;
+		break;
+	}
+
+	/*  set a minimum and maximum size allowed */
+	max_size = DMA_BUF_SIZE;
+	/*  if we are taking limited number of conversions, limit transfer size to that */
+	if (cmd->stop_src == TRIG_COUNT &&
+	    cmd->stop_arg * cmd->chanlist_len * sample_size < max_size)
+		max_size = cmd->stop_arg * cmd->chanlist_len * sample_size;
+
+	if (size > max_size)
+		size = max_size;
+	if (size < sample_size)
+		size = sample_size;
+
+	return size;
+}
+
 /* sets up dma */
 static void setup_dma(struct comedi_device *dev, struct comedi_cmd cmd)
 {
@@ -1689,91 +1377,357 @@ static int das1800_do_wbits(struct comedi_device *dev,
 	return 2;
 }
 
-/* loads counters with divisor1, divisor2 from private structure */
-static int das1800_set_frequency(struct comedi_device *dev)
+static int das1800_init_dma(struct comedi_device *dev, unsigned int dma0,
+			    unsigned int dma1)
 {
-	int err = 0;
-
-	/*  counter 1, mode 2 */
-	if (i8254_load(dev->iobase + DAS1800_COUNTER, 0, 1, devpriv->divisor1,
-		       2))
-		err++;
-	/*  counter 2, mode 2 */
-	if (i8254_load(dev->iobase + DAS1800_COUNTER, 0, 2, devpriv->divisor2,
-		       2))
-		err++;
-	if (err)
-		return -1;
+	unsigned long flags;
 
+	/*  need an irq to do dma */
+	if (dev->irq && dma0) {
+		/* encode dma0 and dma1 into 2 digit hexadecimal for switch */
+		switch ((dma0 & 0x7) | (dma1 << 4)) {
+		case 0x5:	/*  dma0 == 5 */
+			devpriv->dma_bits |= DMA_CH5;
+			break;
+		case 0x6:	/*  dma0 == 6 */
+			devpriv->dma_bits |= DMA_CH6;
+			break;
+		case 0x7:	/*  dma0 == 7 */
+			devpriv->dma_bits |= DMA_CH7;
+			break;
+		case 0x65:	/*  dma0 == 5, dma1 == 6 */
+			devpriv->dma_bits |= DMA_CH5_CH6;
+			break;
+		case 0x76:	/*  dma0 == 6, dma1 == 7 */
+			devpriv->dma_bits |= DMA_CH6_CH7;
+			break;
+		case 0x57:	/*  dma0 == 7, dma1 == 5 */
+			devpriv->dma_bits |= DMA_CH7_CH5;
+			break;
+		default:
+			dev_err(dev->hw_dev, " only supports dma channels 5 through 7\n"
+				" Dual dma only allows the following combinations:\n"
+				" dma 5,6 / 6,7 / or 7,5\n");
+			return -EINVAL;
+			break;
+		}
+		if (request_dma(dma0, dev->driver->driver_name)) {
+			dev_err(dev->hw_dev, "failed to allocate dma channel %i\n",
+				dma0);
+			return -EINVAL;
+		}
+		devpriv->dma0 = dma0;
+		devpriv->dma_current = dma0;
+		if (dma1) {
+			if (request_dma(dma1, dev->driver->driver_name)) {
+				dev_err(dev->hw_dev, "failed to allocate dma channel %i\n",
+					dma1);
+				return -EINVAL;
+			}
+			devpriv->dma1 = dma1;
+		}
+		devpriv->ai_buf0 = kmalloc(DMA_BUF_SIZE, GFP_KERNEL | GFP_DMA);
+		if (devpriv->ai_buf0 == NULL)
+			return -ENOMEM;
+		devpriv->dma_current_buf = devpriv->ai_buf0;
+		if (dma1) {
+			devpriv->ai_buf1 =
+			    kmalloc(DMA_BUF_SIZE, GFP_KERNEL | GFP_DMA);
+			if (devpriv->ai_buf1 == NULL)
+				return -ENOMEM;
+		}
+		flags = claim_dma_lock();
+		disable_dma(devpriv->dma0);
+		set_dma_mode(devpriv->dma0, DMA_MODE_READ);
+		if (dma1) {
+			disable_dma(devpriv->dma1);
+			set_dma_mode(devpriv->dma1, DMA_MODE_READ);
+		}
+		release_dma_lock(flags);
+	}
 	return 0;
 }
 
-/* converts requested conversion timing to timing compatible with
- * hardware, used only when card is in 'burst mode'
- */
-static unsigned int burst_convert_arg(unsigned int convert_arg, int round_mode)
+static int das1800_probe(struct comedi_device *dev)
 {
-	unsigned int micro_sec;
+	int id;
+	int board;
 
-	/*  in burst mode, the maximum conversion time is 64 microseconds */
-	if (convert_arg > 64000)
-		convert_arg = 64000;
+	id = (inb(dev->iobase + DAS1800_DIGITAL) >> 4) & 0xf;	/* get id bits */
+	board = ((struct das1800_board *)dev->board_ptr) - das1800_boards;
 
-	/*  the conversion time must be an integral number of microseconds */
-	switch (round_mode) {
-	case TRIG_ROUND_NEAREST:
-	default:
-		micro_sec = (convert_arg + 500) / 1000;
+	switch (id) {
+	case 0x3:
+		if (board == das1801st_da || board == das1802st_da ||
+		    board == das1701st_da || board == das1702st_da) {
+			dev_dbg(dev->hw_dev, "Board model: %s\n",
+				das1800_boards[board].name);
+			return board;
+		}
+		printk
+		    (" Board model (probed, not recommended): das-1800st-da series\n");
+		return das1801st;
+		break;
+	case 0x4:
+		if (board == das1802hr_da || board == das1702hr_da) {
+			dev_dbg(dev->hw_dev, "Board model: %s\n",
+				das1800_boards[board].name);
+			return board;
+		}
+		printk
+		    (" Board model (probed, not recommended): das-1802hr-da\n");
+		return das1802hr;
+		break;
+	case 0x5:
+		if (board == das1801ao || board == das1802ao ||
+		    board == das1701ao || board == das1702ao) {
+			dev_dbg(dev->hw_dev, "Board model: %s\n",
+				das1800_boards[board].name);
+			return board;
+		}
+		printk
+		    (" Board model (probed, not recommended): das-1800ao series\n");
+		return das1801ao;
+		break;
+	case 0x6:
+		if (board == das1802hr || board == das1702hr) {
+			dev_dbg(dev->hw_dev, "Board model: %s\n",
+				das1800_boards[board].name);
+			return board;
+		}
+		printk
+		    (" Board model (probed, not recommended): das-1802hr\n");
+		return das1802hr;
 		break;
-	case TRIG_ROUND_DOWN:
-		micro_sec = convert_arg / 1000;
+	case 0x7:
+		if (board == das1801st || board == das1802st ||
+		    board == das1701st || board == das1702st) {
+			dev_dbg(dev->hw_dev, "Board model: %s\n",
+				das1800_boards[board].name);
+			return board;
+		}
+		printk
+		    (" Board model (probed, not recommended): das-1800st series\n");
+		return das1801st;
 		break;
-	case TRIG_ROUND_UP:
-		micro_sec = (convert_arg - 1) / 1000 + 1;
+	case 0x8:
+		if (board == das1801hc || board == das1802hc) {
+			dev_dbg(dev->hw_dev, "Board model: %s\n",
+				das1800_boards[board].name);
+			return board;
+		}
+		printk
+		    (" Board model (probed, not recommended): das-1800hc series\n");
+		return das1801hc;
+		break;
+	default:
+		printk
+		    (" Board model: probe returned 0x%x (unknown, please report)\n",
+		     id);
+		return board;
 		break;
 	}
-
-	/*  return number of nanoseconds */
-	return micro_sec * 1000;
+	return -1;
 }
 
-/* utility function that suggests a dma transfer size based on the conversion period 'ns' */
-static unsigned int suggest_transfer_size(struct comedi_cmd *cmd)
+static int das1800_attach(struct comedi_device *dev,
+			  struct comedi_devconfig *it)
 {
-	unsigned int size = DMA_BUF_SIZE;
-	static const int sample_size = 2;	/*  size in bytes of one sample from board */
-	unsigned int fill_time = 300000000;	/*  target time in nanoseconds for filling dma buffer */
-	unsigned int max_size;	/*  maximum size we will allow for a transfer */
+	struct comedi_subdevice *s;
+	unsigned long iobase = it->options[0];
+	unsigned int irq = it->options[1];
+	unsigned int dma0 = it->options[2];
+	unsigned int dma1 = it->options[3];
+	unsigned long iobase2;
+	int board;
+	int retval;
+
+	/* allocate and initialize dev->private */
+	if (alloc_private(dev, sizeof(struct das1800_private)) < 0)
+		return -ENOMEM;
+
+	printk(KERN_DEBUG "comedi%d: %s: io 0x%lx", dev->minor,
+	       dev->driver->driver_name, iobase);
+	if (irq) {
+		printk(KERN_CONT ", irq %u", irq);
+		if (dma0) {
+			printk(KERN_CONT ", dma %u", dma0);
+			if (dma1)
+				printk(KERN_CONT " and %u", dma1);
+		}
+	}
+	printk(KERN_CONT "\n");
+
+	if (iobase == 0) {
+		dev_err(dev->hw_dev, "io base address required\n");
+		return -EINVAL;
+	}
+
+	/* check if io addresses are available */
+	if (!request_region(iobase, DAS1800_SIZE, dev->driver->driver_name)) {
+		printk
+		    (" I/O port conflict: failed to allocate ports 0x%lx to 0x%lx\n",
+		     iobase, iobase + DAS1800_SIZE - 1);
+		return -EIO;
+	}
+	dev->iobase = iobase;
+
+	board = das1800_probe(dev);
+	if (board < 0) {
+		dev_err(dev->hw_dev, "unable to determine board type\n");
+		return -ENODEV;
+	}
+
+	dev->board_ptr = das1800_boards + board;
+	dev->board_name = thisboard->name;
+
+	/*  if it is an 'ao' board with fancy analog out then we need extra io ports */
+	if (thisboard->ao_ability == 2) {
+		iobase2 = iobase + IOBASE2;
+		if (!request_region(iobase2, DAS1800_SIZE,
+				    dev->driver->driver_name)) {
+			printk
+			    (" I/O port conflict: failed to allocate ports 0x%lx to 0x%lx\n",
+			     iobase2, iobase2 + DAS1800_SIZE - 1);
+			return -EIO;
+		}
+		devpriv->iobase2 = iobase2;
+	}
+
+	/* grab our IRQ */
+	if (irq) {
+		if (request_irq(irq, das1800_interrupt, 0,
+				dev->driver->driver_name, dev)) {
+			dev_dbg(dev->hw_dev, "unable to allocate irq %u\n",
+				irq);
+			return -EINVAL;
+		}
+	}
+	dev->irq = irq;
 
-	/*  make dma buffer fill in 0.3 seconds for timed modes */
-	switch (cmd->scan_begin_src) {
-	case TRIG_FOLLOW:	/*  not in burst mode */
-		if (cmd->convert_src == TRIG_TIMER)
-			size = (fill_time / cmd->convert_arg) * sample_size;
+	/*  set bits that tell card which irq to use */
+	switch (irq) {
+	case 0:
+		break;
+	case 3:
+		devpriv->irq_dma_bits |= 0x8;
+		break;
+	case 5:
+		devpriv->irq_dma_bits |= 0x10;
+		break;
+	case 7:
+		devpriv->irq_dma_bits |= 0x18;
+		break;
+	case 10:
+		devpriv->irq_dma_bits |= 0x28;
+		break;
+	case 11:
+		devpriv->irq_dma_bits |= 0x30;
 		break;
-	case TRIG_TIMER:
-		size = (fill_time / (cmd->scan_begin_arg * cmd->chanlist_len)) *
-		    sample_size;
+	case 15:
+		devpriv->irq_dma_bits |= 0x38;
 		break;
 	default:
-		size = DMA_BUF_SIZE;
+		dev_err(dev->hw_dev, "irq out of range\n");
+		return -EINVAL;
 		break;
 	}
 
-	/*  set a minimum and maximum size allowed */
-	max_size = DMA_BUF_SIZE;
-	/*  if we are taking limited number of conversions, limit transfer size to that */
-	if (cmd->stop_src == TRIG_COUNT &&
-	    cmd->stop_arg * cmd->chanlist_len * sample_size < max_size)
-		max_size = cmd->stop_arg * cmd->chanlist_len * sample_size;
+	retval = das1800_init_dma(dev, dma0, dma1);
+	if (retval < 0)
+		return retval;
 
-	if (size > max_size)
-		size = max_size;
-	if (size < sample_size)
-		size = sample_size;
+	if (devpriv->ai_buf0 == NULL) {
+		devpriv->ai_buf0 =
+		    kmalloc(FIFO_SIZE * sizeof(uint16_t), GFP_KERNEL);
+		if (devpriv->ai_buf0 == NULL)
+			return -ENOMEM;
+	}
 
-	return size;
-}
+	if (alloc_subdevices(dev, 4) < 0)
+		return -ENOMEM;
+
+	/* analog input subdevice */
+	s = dev->subdevices + 0;
+	dev->read_subdev = s;
+	s->type = COMEDI_SUBD_AI;
+	s->subdev_flags = SDF_READABLE | SDF_DIFF | SDF_GROUND | SDF_CMD_READ;
+	if (thisboard->common)
+		s->subdev_flags |= SDF_COMMON;
+	s->n_chan = thisboard->qram_len;
+	s->len_chanlist = thisboard->qram_len;
+	s->maxdata = (1 << thisboard->resolution) - 1;
+	s->range_table = thisboard->range_ai;
+	s->do_cmd = das1800_ai_do_cmd;
+	s->do_cmdtest = das1800_ai_do_cmdtest;
+	s->insn_read = das1800_ai_rinsn;
+	s->poll = das1800_ai_poll;
+	s->cancel = das1800_cancel;
+
+	/* analog out */
+	s = dev->subdevices + 1;
+	if (thisboard->ao_ability == 1) {
+		s->type = COMEDI_SUBD_AO;
+		s->subdev_flags = SDF_WRITABLE;
+		s->n_chan = thisboard->ao_n_chan;
+		s->maxdata = (1 << thisboard->resolution) - 1;
+		s->range_table = &range_ao_1;
+		s->insn_write = das1800_ao_winsn;
+	} else {
+		s->type = COMEDI_SUBD_UNUSED;
+	}
+
+	/* di */
+	s = dev->subdevices + 2;
+	s->type = COMEDI_SUBD_DI;
+	s->subdev_flags = SDF_READABLE;
+	s->n_chan = 4;
+	s->maxdata = 1;
+	s->range_table = &range_digital;
+	s->insn_bits = das1800_di_rbits;
+
+	/* do */
+	s = dev->subdevices + 3;
+	s->type = COMEDI_SUBD_DO;
+	s->subdev_flags = SDF_WRITABLE | SDF_READABLE;
+	s->n_chan = thisboard->do_n_chan;
+	s->maxdata = 1;
+	s->range_table = &range_digital;
+	s->insn_bits = das1800_do_wbits;
+
+	das1800_cancel(dev, dev->read_subdev);
+
+	/*  initialize digital out channels */
+	outb(devpriv->do_bits, dev->iobase + DAS1800_DIGITAL);
+
+	/*  initialize analog out channels */
+	if (thisboard->ao_ability == 1) {
+		/*  select 'update' dac channel for baseAddress + 0x0 */
+		outb(DAC(thisboard->ao_n_chan - 1),
+		     dev->iobase + DAS1800_SELECT);
+		outw(devpriv->ao_update_bits, dev->iobase + DAS1800_DAC);
+	}
+
+	return 0;
+};
+
+static void das1800_detach(struct comedi_device *dev)
+{
+	if (dev->iobase)
+		release_region(dev->iobase, DAS1800_SIZE);
+	if (dev->irq)
+		free_irq(dev->irq, dev);
+	if (dev->private) {
+		if (devpriv->iobase2)
+			release_region(devpriv->iobase2, DAS1800_SIZE);
+		if (devpriv->dma0)
+			free_dma(devpriv->dma0);
+		if (devpriv->dma1)
+			free_dma(devpriv->dma1);
+		kfree(devpriv->ai_buf0);
+		kfree(devpriv->ai_buf1);
+	}
+};
 
 static struct comedi_driver das1800_driver = {
 	.driver_name	= "das1800",
