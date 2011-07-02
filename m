Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755269Ab1GBTCl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jul 2011 15:02:41 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:20769 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752303Ab1GBTCi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jul 2011 15:02:38 -0400
X-Greylist: delayed 1047 seconds by postgrey-1.27 at vger.kernel.org; Sat, 02 Jul 2011 15:02:38 EDT
Date: Sat, 2 Jul 2011 11:44:36 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Greg KH <greg@kroah.com>, Ian Abbott <abbotti@mev.co.uk>,
        Frank Mori Hess <fmhess@users.sourceforge.net>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        driverdevel <devel@driverdev.osuosl.org>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, Ian Abbott <abbotti@mev.co.uk>,
        Frank Mori Hess <fmhess@users.sourceforge.net>
Subject: [PATCH -next] staging: fix comedi NI labpc driver build when
 ISA_DMA_API is not enabled
Message-Id: <20110702114436.b2b8a70b.randy.dunlap@oracle.com>
In-Reply-To: <20110701224604.GA7469@kroah.com>
References: <20110701160523.5626201d.sfr@canb.auug.org.au>
	<20110701154327.69c5b852.rdunlap@xenotime.net>
	<20110701224604.GA7469@kroah.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090209.4E0F6720.00DE:SCFMA922111,ss=1,re=-4.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 1 Jul 2011 15:46:04 -0700 Greg KH wrote:


> Ick.
> Care to make a patch?

I'd rather that someone who has a strong interest in comedi (or NI labpc)
do that, but here it is anyway.

---
From: Randy Dunlap <randy.dunlap@oracle.com>

Fix ni_labpc.c to build when CONFIG_ISA_DMA_API is not enabled.

This is a driver that supports both ISA and PCI devices.
It now builds when for PCI-only support or for both
ISA and PCI device support.
(It does not support ISA-only without PCI.)

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Frank Mori Hess <fmhess@users.sourceforge.net>
---
 drivers/staging/comedi/drivers/ni_labpc.c |   36 ++++++++++++++++++--
 1 file changed, 33 insertions(+), 3 deletions(-)

--- linux-next-20110701.orig/drivers/staging/comedi/drivers/ni_labpc.c
+++ linux-next-20110701/drivers/staging/comedi/drivers/ni_labpc.c
@@ -213,8 +213,10 @@ static int labpc_attach(struct comedi_de
 static int labpc_cancel(struct comedi_device *dev, struct comedi_subdevice *s);
 static irqreturn_t labpc_interrupt(int irq, void *d);
 static int labpc_drain_fifo(struct comedi_device *dev);
+#ifdef CONFIG_ISA_DMA_API
 static void labpc_drain_dma(struct comedi_device *dev);
 static void handle_isa_dma(struct comedi_device *dev);
+#endif
 static void labpc_drain_dregs(struct comedi_device *dev);
 static int labpc_ai_cmdtest(struct comedi_device *dev,
 			    struct comedi_subdevice *s, struct comedi_cmd *cmd);
@@ -238,9 +240,9 @@ static int labpc_eeprom_write_insn(struc
 				   struct comedi_subdevice *s,
 				   struct comedi_insn *insn,
 				   unsigned int *data);
-static unsigned int labpc_suggest_transfer_size(struct comedi_cmd cmd);
 static void labpc_adc_timing(struct comedi_device *dev, struct comedi_cmd *cmd);
 #ifdef CONFIG_COMEDI_PCI
+static unsigned int labpc_suggest_transfer_size(struct comedi_cmd cmd);
 static int labpc_find_device(struct comedi_device *dev, int bus, int slot);
 #endif
 static int labpc_dio_mem_callback(int dir, int port, int data,
@@ -527,7 +529,10 @@ int labpc_common_attach(struct comedi_de
 {
 	struct comedi_subdevice *s;
 	int i;
-	unsigned long dma_flags, isr_flags;
+	unsigned long isr_flags;
+#ifdef CONFIG_ISA_DMA_API
+	unsigned long dma_flags;
+#endif
 	short lsb, msb;
 
 	printk(KERN_ERR "comedi%d: ni_labpc: %s, io 0x%lx", dev->minor,
@@ -587,6 +592,7 @@ int labpc_common_attach(struct comedi_de
 	}
 	dev->irq = irq;
 
+#ifdef CONFIG_ISA_DMA_API
 	/* grab dma channel */
 	if (dma_chan > 3) {
 		printk(KERN_ERR " invalid dma channel %u\n", dma_chan);
@@ -610,6 +616,7 @@ int labpc_common_attach(struct comedi_de
 		set_dma_mode(devpriv->dma_chan, DMA_MODE_READ);
 		release_dma_lock(dma_flags);
 	}
+#endif
 
 	dev->board_name = thisboard->name;
 
@@ -724,9 +731,15 @@ static int labpc_attach(struct comedi_de
 	/* get base address, irq etc. based on bustype */
 	switch (thisboard->bustype) {
 	case isa_bustype:
+#ifdef CONFIG_ISA_DMA_API
 		iobase = it->options[0];
 		irq = it->options[1];
 		dma_chan = it->options[2];
+#else
+		printk(KERN_ERR " this driver has not been built with ISA DMA "
+								"support.\n");
+		return -EINVAL;
+#endif
 		break;
 	case pci_bustype:
 #ifdef CONFIG_COMEDI_PCI
@@ -797,10 +810,12 @@ int labpc_common_detach(struct comedi_de
 	if (dev->subdevices)
 		subdev_8255_cleanup(dev, dev->subdevices + 2);
 
+#ifdef CONFIG_ISA_DMA_API
 	/* only free stuff if it has been allocated by _attach */
 	kfree(devpriv->dma_buffer);
 	if (devpriv->dma_chan)
 		free_dma(devpriv->dma_chan);
+#endif
 	if (dev->irq)
 		free_irq(dev->irq, dev);
 	if (thisboard->bustype == isa_bustype && dev->iobase)
@@ -1135,7 +1150,9 @@ static int labpc_ai_cmdtest(struct comed
 static int labpc_ai_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
 {
 	int channel, range, aref;
+#ifdef CONFIG_ISA_DMA_API
 	unsigned long irq_flags;
+#endif
 	int ret;
 	struct comedi_async *async = s->async;
 	struct comedi_cmd *cmd = &async->cmd;
@@ -1182,6 +1199,7 @@ static int labpc_ai_cmd(struct comedi_de
 		devpriv->write_byte(INIT_A1_BITS,
 				    dev->iobase + COUNTER_A_CONTROL_REG);
 
+#ifdef CONFIG_ISA_DMA_API
 	/*  figure out what method we will use to transfer data */
 	if (devpriv->dma_chan &&	/*  need a dma channel allocated */
 		/*
@@ -1193,7 +1211,9 @@ static int labpc_ai_cmd(struct comedi_de
 	    thisboard->bustype == isa_bustype) {
 		xfer = isa_dma_transfer;
 		/* pc-plus has no fifo-half full interrupt */
-	} else if (thisboard->register_layout == labpc_1200_layout &&
+	} else
+#endif
+	if (thisboard->register_layout == labpc_1200_layout &&
 		   /*  wake-end-of-scan should interrupt on fifo not empty */
 		   (cmd->flags & TRIG_WAKE_EOS) == 0 &&
 		   /*  make sure we are taking more than just a few points */
@@ -1317,6 +1337,7 @@ static int labpc_ai_cmd(struct comedi_de
 
 	labpc_clear_adc_fifo(dev);
 
+#ifdef CONFIG_ISA_DMA_API
 	/*  set up dma transfer */
 	if (xfer == isa_dma_transfer) {
 		irq_flags = claim_dma_lock();
@@ -1340,6 +1361,7 @@ static int labpc_ai_cmd(struct comedi_de
 		devpriv->command3_bits |= DMA_EN_BIT | DMATC_INTR_EN_BIT;
 	} else
 		devpriv->command3_bits &= ~DMA_EN_BIT & ~DMATC_INTR_EN_BIT;
+#endif
 
 	/*  enable error interrupts */
 	devpriv->command3_bits |= ERR_INTR_EN_BIT;
@@ -1426,6 +1448,7 @@ static irqreturn_t labpc_interrupt(int i
 		return IRQ_HANDLED;
 	}
 
+#ifdef CONFIG_ISA_DMA_API
 	if (devpriv->current_transfer == isa_dma_transfer) {
 		/*
 		 * if a dma terminal count of external stop trigger
@@ -1437,6 +1460,7 @@ static irqreturn_t labpc_interrupt(int i
 			handle_isa_dma(dev);
 		}
 	} else
+#endif
 		labpc_drain_fifo(dev);
 
 	if (devpriv->status1_bits & TIMER_BIT) {
@@ -1509,6 +1533,7 @@ static int labpc_drain_fifo(struct comed
 	return 0;
 }
 
+#ifdef CONFIG_ISA_DMA_API
 static void labpc_drain_dma(struct comedi_device *dev)
 {
 	struct comedi_subdevice *s = dev->read_subdev;
@@ -1571,13 +1596,16 @@ static void handle_isa_dma(struct comedi
 	/*  clear dma tc interrupt */
 	devpriv->write_byte(0x1, dev->iobase + DMATC_CLEAR_REG);
 }
+#endif
 
 /* makes sure all data acquired by board is transferred to comedi (used
  * when acquisition is terminated by stop_src == TRIG_EXT). */
 static void labpc_drain_dregs(struct comedi_device *dev)
 {
+#ifdef CONFIG_ISA_DMA_API
 	if (devpriv->current_transfer == isa_dma_transfer)
 		labpc_drain_dma(dev);
+#endif
 
 	labpc_drain_fifo(dev);
 }
@@ -1769,6 +1797,7 @@ static int labpc_eeprom_write_insn(struc
 	return 1;
 }
 
+#ifdef CONFIG_ISA_DMA_API
 /* utility function that suggests a dma transfer size in bytes */
 static unsigned int labpc_suggest_transfer_size(struct comedi_cmd cmd)
 {
@@ -1792,6 +1821,7 @@ static unsigned int labpc_suggest_transf
 
 	return size;
 }
+#endif
 
 /* figures out what counter values to use based on command */
 static void labpc_adc_timing(struct comedi_device *dev, struct comedi_cmd *cmd)
