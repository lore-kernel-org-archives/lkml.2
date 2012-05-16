Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967113Ab2EPARU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 20:17:20 -0400
Received: from mail127.messagelabs.com ([216.82.250.115]:36128 "EHLO
	mail127.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966737Ab2EPART (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 20:17:19 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-3.tower-127.messagelabs.com!1337127437!5629008!4
X-Originating-IP: [216.166.12.180]
X-StarScan-Version: 6.5.7; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] staging: comedi: refactor ni_at_a2150 driver and use module_comedi_driver
Date: Tue, 15 May 2012 17:17:14 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201205151717.14480.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the module_init/module_exit routines and the associated
struct comedi_drive to the end of the source. This is more
typical of how other drivers are written and removes the need
for the forward declarations.

Convert the driver to use the module_comedi_driver() macro
which makes the code smaller and a bit simpler.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---

More refactoring needs to be done to remove the remaining
forward declarations. Doing that is this patch makes it
difficult to review.

 drivers/staging/comedi/drivers/ni_at_a2150.c |  351 ++++++++++++--------------
 1 files changed, 163 insertions(+), 188 deletions(-)

diff --git a/drivers/staging/comedi/drivers/ni_at_a2150.c b/drivers/staging/comedi/drivers/ni_at_a2150.c
index 4fc469d..3231d10 100644
--- a/drivers/staging/comedi/drivers/ni_at_a2150.c
+++ b/drivers/staging/comedi/drivers/ni_at_a2150.c
@@ -171,46 +171,13 @@ struct a2150_private {
 
 #define devpriv ((struct a2150_private *)dev->private)
 
-static int a2150_attach(struct comedi_device *dev, struct comedi_devconfig *it);
-static int a2150_detach(struct comedi_device *dev);
 static int a2150_cancel(struct comedi_device *dev, struct comedi_subdevice *s);
 
-static struct comedi_driver driver_a2150 = {
-	.driver_name = "ni_at_a2150",
-	.module = THIS_MODULE,
-	.attach = a2150_attach,
-	.detach = a2150_detach,
-};
-
-static irqreturn_t a2150_interrupt(int irq, void *d);
-static int a2150_ai_cmdtest(struct comedi_device *dev,
-			    struct comedi_subdevice *s, struct comedi_cmd *cmd);
-static int a2150_ai_cmd(struct comedi_device *dev, struct comedi_subdevice *s);
-static int a2150_ai_rinsn(struct comedi_device *dev, struct comedi_subdevice *s,
-			  struct comedi_insn *insn, unsigned int *data);
 static int a2150_get_timing(struct comedi_device *dev, unsigned int *period,
 			    int flags);
-static int a2150_probe(struct comedi_device *dev);
 static int a2150_set_chanlist(struct comedi_device *dev,
 			      unsigned int start_channel,
 			      unsigned int num_channels);
-/*
- * A convenient macro that defines init_module() and cleanup_module(),
- * as necessary.
- */
-static int __init driver_a2150_init_module(void)
-{
-	return comedi_driver_register(&driver_a2150);
-}
-
-static void __exit driver_a2150_cleanup_module(void)
-{
-	comedi_driver_unregister(&driver_a2150);
-}
-
-module_init(driver_a2150_init_module);
-module_exit(driver_a2150_cleanup_module);
-
 #ifdef A2150_DEBUG
 
 static void ni_dump_regs(struct comedi_device *dev)
@@ -331,161 +298,6 @@ static irqreturn_t a2150_interrupt(int irq, void *d)
 	return IRQ_HANDLED;
 }
 
-/* probes board type, returns offset */
-static int a2150_probe(struct comedi_device *dev)
-{
-	int status = inw(dev->iobase + STATUS_REG);
-	return ID_BITS(status);
-}
-
-static int a2150_attach(struct comedi_device *dev, struct comedi_devconfig *it)
-{
-	struct comedi_subdevice *s;
-	unsigned long iobase = it->options[0];
-	unsigned int irq = it->options[1];
-	unsigned int dma = it->options[2];
-	static const int timeout = 2000;
-	int i;
-
-	printk("comedi%d: %s: io 0x%lx", dev->minor, driver_a2150.driver_name,
-	       iobase);
-	if (irq) {
-		printk(", irq %u", irq);
-	} else {
-		printk(", no irq");
-	}
-	if (dma) {
-		printk(", dma %u", dma);
-	} else {
-		printk(", no dma");
-	}
-	printk("\n");
-
-	/* allocate and initialize dev->private */
-	if (alloc_private(dev, sizeof(struct a2150_private)) < 0)
-		return -ENOMEM;
-
-	if (iobase == 0) {
-		printk(" io base address required\n");
-		return -EINVAL;
-	}
-
-	/* check if io addresses are available */
-	if (!request_region(iobase, A2150_SIZE, driver_a2150.driver_name)) {
-		printk(" I/O port conflict\n");
-		return -EIO;
-	}
-	dev->iobase = iobase;
-
-	/* grab our IRQ */
-	if (irq) {
-		/*  check that irq is supported */
-		if (irq < 3 || irq == 8 || irq == 13 || irq > 15) {
-			printk(" invalid irq line %u\n", irq);
-			return -EINVAL;
-		}
-		if (request_irq(irq, a2150_interrupt, 0,
-				driver_a2150.driver_name, dev)) {
-			printk("unable to allocate irq %u\n", irq);
-			return -EINVAL;
-		}
-		devpriv->irq_dma_bits |= IRQ_LVL_BITS(irq);
-		dev->irq = irq;
-	}
-	/*  initialize dma */
-	if (dma) {
-		if (dma == 4 || dma > 7) {
-			printk(" invalid dma channel %u\n", dma);
-			return -EINVAL;
-		}
-		if (request_dma(dma, driver_a2150.driver_name)) {
-			printk(" failed to allocate dma channel %u\n", dma);
-			return -EINVAL;
-		}
-		devpriv->dma = dma;
-		devpriv->dma_buffer =
-		    kmalloc(A2150_DMA_BUFFER_SIZE, GFP_KERNEL | GFP_DMA);
-		if (devpriv->dma_buffer == NULL)
-			return -ENOMEM;
-
-		disable_dma(dma);
-		set_dma_mode(dma, DMA_MODE_READ);
-
-		devpriv->irq_dma_bits |= DMA_CHAN_BITS(dma);
-	}
-
-	dev->board_ptr = a2150_boards + a2150_probe(dev);
-	dev->board_name = thisboard->name;
-
-	if (alloc_subdevices(dev, 1) < 0)
-		return -ENOMEM;
-
-	/* analog input subdevice */
-	s = dev->subdevices + 0;
-	dev->read_subdev = s;
-	s->type = COMEDI_SUBD_AI;
-	s->subdev_flags = SDF_READABLE | SDF_GROUND | SDF_OTHER | SDF_CMD_READ;
-	s->n_chan = 4;
-	s->len_chanlist = 4;
-	s->maxdata = 0xffff;
-	s->range_table = &range_a2150;
-	s->do_cmd = a2150_ai_cmd;
-	s->do_cmdtest = a2150_ai_cmdtest;
-	s->insn_read = a2150_ai_rinsn;
-	s->cancel = a2150_cancel;
-
-	/* need to do this for software counting of completed conversions, to
-	 * prevent hardware count from stopping acquisition */
-	outw(HW_COUNT_DISABLE, dev->iobase + I8253_MODE_REG);
-
-	/*  set card's irq and dma levels */
-	outw(devpriv->irq_dma_bits, dev->iobase + IRQ_DMA_CNTRL_REG);
-
-	/*  reset and sync adc clock circuitry */
-	outw_p(DPD_BIT | APD_BIT, dev->iobase + CONFIG_REG);
-	outw_p(DPD_BIT, dev->iobase + CONFIG_REG);
-	/*  initialize configuration register */
-	devpriv->config_bits = 0;
-	outw(devpriv->config_bits, dev->iobase + CONFIG_REG);
-	/*  wait until offset calibration is done, then enable analog inputs */
-	for (i = 0; i < timeout; i++) {
-		if ((DCAL_BIT & inw(dev->iobase + STATUS_REG)) == 0)
-			break;
-		udelay(1000);
-	}
-	if (i == timeout) {
-		printk
-		    (" timed out waiting for offset calibration to complete\n");
-		return -ETIME;
-	}
-	devpriv->config_bits |= ENABLE0_BIT | ENABLE1_BIT;
-	outw(devpriv->config_bits, dev->iobase + CONFIG_REG);
-
-	return 0;
-};
-
-static int a2150_detach(struct comedi_device *dev)
-{
-	printk("comedi%d: %s: remove\n", dev->minor, driver_a2150.driver_name);
-
-	/* only free stuff if it has been allocated by _attach */
-	if (dev->iobase) {
-		/*  put board in power-down mode */
-		outw(APD_BIT | DPD_BIT, dev->iobase + CONFIG_REG);
-		release_region(dev->iobase, A2150_SIZE);
-	}
-
-	if (dev->irq)
-		free_irq(dev->irq, dev);
-	if (devpriv) {
-		if (devpriv->dma)
-			free_dma(devpriv->dma);
-		kfree(devpriv->dma_buffer);
-	}
-
-	return 0;
-};
-
 static int a2150_cancel(struct comedi_device *dev, struct comedi_subdevice *s)
 {
 	/*  disable dma on card */
@@ -928,6 +740,169 @@ static int a2150_set_chanlist(struct comedi_device *dev,
 	return 0;
 }
 
+/* probes board type, returns offset */
+static int a2150_probe(struct comedi_device *dev)
+{
+	int status = inw(dev->iobase + STATUS_REG);
+	return ID_BITS(status);
+}
+
+static int a2150_attach(struct comedi_device *dev, struct comedi_devconfig *it)
+{
+	struct comedi_subdevice *s;
+	unsigned long iobase = it->options[0];
+	unsigned int irq = it->options[1];
+	unsigned int dma = it->options[2];
+	static const int timeout = 2000;
+	int i;
+
+	printk("comedi%d: %s: io 0x%lx", dev->minor, dev->driver->driver_name,
+	       iobase);
+	if (irq) {
+		printk(", irq %u", irq);
+	} else {
+		printk(", no irq");
+	}
+	if (dma) {
+		printk(", dma %u", dma);
+	} else {
+		printk(", no dma");
+	}
+	printk("\n");
+
+	/* allocate and initialize dev->private */
+	if (alloc_private(dev, sizeof(struct a2150_private)) < 0)
+		return -ENOMEM;
+
+	if (iobase == 0) {
+		printk(" io base address required\n");
+		return -EINVAL;
+	}
+
+	/* check if io addresses are available */
+	if (!request_region(iobase, A2150_SIZE, dev->driver->driver_name)) {
+		printk(" I/O port conflict\n");
+		return -EIO;
+	}
+	dev->iobase = iobase;
+
+	/* grab our IRQ */
+	if (irq) {
+		/*  check that irq is supported */
+		if (irq < 3 || irq == 8 || irq == 13 || irq > 15) {
+			printk(" invalid irq line %u\n", irq);
+			return -EINVAL;
+		}
+		if (request_irq(irq, a2150_interrupt, 0,
+				dev->driver->driver_name, dev)) {
+			printk("unable to allocate irq %u\n", irq);
+			return -EINVAL;
+		}
+		devpriv->irq_dma_bits |= IRQ_LVL_BITS(irq);
+		dev->irq = irq;
+	}
+	/*  initialize dma */
+	if (dma) {
+		if (dma == 4 || dma > 7) {
+			printk(" invalid dma channel %u\n", dma);
+			return -EINVAL;
+		}
+		if (request_dma(dma, dev->driver->driver_name)) {
+			printk(" failed to allocate dma channel %u\n", dma);
+			return -EINVAL;
+		}
+		devpriv->dma = dma;
+		devpriv->dma_buffer =
+		    kmalloc(A2150_DMA_BUFFER_SIZE, GFP_KERNEL | GFP_DMA);
+		if (devpriv->dma_buffer == NULL)
+			return -ENOMEM;
+
+		disable_dma(dma);
+		set_dma_mode(dma, DMA_MODE_READ);
+
+		devpriv->irq_dma_bits |= DMA_CHAN_BITS(dma);
+	}
+
+	dev->board_ptr = a2150_boards + a2150_probe(dev);
+	dev->board_name = thisboard->name;
+
+	if (alloc_subdevices(dev, 1) < 0)
+		return -ENOMEM;
+
+	/* analog input subdevice */
+	s = dev->subdevices + 0;
+	dev->read_subdev = s;
+	s->type = COMEDI_SUBD_AI;
+	s->subdev_flags = SDF_READABLE | SDF_GROUND | SDF_OTHER | SDF_CMD_READ;
+	s->n_chan = 4;
+	s->len_chanlist = 4;
+	s->maxdata = 0xffff;
+	s->range_table = &range_a2150;
+	s->do_cmd = a2150_ai_cmd;
+	s->do_cmdtest = a2150_ai_cmdtest;
+	s->insn_read = a2150_ai_rinsn;
+	s->cancel = a2150_cancel;
+
+	/* need to do this for software counting of completed conversions, to
+	 * prevent hardware count from stopping acquisition */
+	outw(HW_COUNT_DISABLE, dev->iobase + I8253_MODE_REG);
+
+	/*  set card's irq and dma levels */
+	outw(devpriv->irq_dma_bits, dev->iobase + IRQ_DMA_CNTRL_REG);
+
+	/*  reset and sync adc clock circuitry */
+	outw_p(DPD_BIT | APD_BIT, dev->iobase + CONFIG_REG);
+	outw_p(DPD_BIT, dev->iobase + CONFIG_REG);
+	/*  initialize configuration register */
+	devpriv->config_bits = 0;
+	outw(devpriv->config_bits, dev->iobase + CONFIG_REG);
+	/*  wait until offset calibration is done, then enable analog inputs */
+	for (i = 0; i < timeout; i++) {
+		if ((DCAL_BIT & inw(dev->iobase + STATUS_REG)) == 0)
+			break;
+		udelay(1000);
+	}
+	if (i == timeout) {
+		printk
+		    (" timed out waiting for offset calibration to complete\n");
+		return -ETIME;
+	}
+	devpriv->config_bits |= ENABLE0_BIT | ENABLE1_BIT;
+	outw(devpriv->config_bits, dev->iobase + CONFIG_REG);
+
+	return 0;
+};
+
+static int a2150_detach(struct comedi_device *dev)
+{
+	printk("comedi%d: %s: remove\n", dev->minor, dev->driver->driver_name);
+
+	/* only free stuff if it has been allocated by _attach */
+	if (dev->iobase) {
+		/*  put board in power-down mode */
+		outw(APD_BIT | DPD_BIT, dev->iobase + CONFIG_REG);
+		release_region(dev->iobase, A2150_SIZE);
+	}
+
+	if (dev->irq)
+		free_irq(dev->irq, dev);
+	if (devpriv) {
+		if (devpriv->dma)
+			free_dma(devpriv->dma);
+		kfree(devpriv->dma_buffer);
+	}
+
+	return 0;
+};
+
+static struct comedi_driver ni_at_a2150_driver = {
+	.driver_name	= "ni_at_a2150",
+	.module		= THIS_MODULE,
+	.attach		= a2150_attach,
+	.detach		= a2150_detach,
+};
+module_comedi_driver(ni_at_a2150_driver);
+
 MODULE_AUTHOR("Comedi http://www.comedi.org");
 MODULE_DESCRIPTION("Comedi low-level driver");
 MODULE_LICENSE("GPL");
