Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758797Ab2EXBcE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 21:32:04 -0400
Received: from mail132.messagelabs.com ([216.82.242.115]:3805 "EHLO
	mail132.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755845Ab2EXBcC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 21:32:02 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-3.tower-132.messagelabs.com!1337823120!12545329!1
X-Originating-IP: [216.166.12.69]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] staging: comedi: rtd520 complete the refactor to remove all forward declarations
Date: Wed, 23 May 2012 18:31:48 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201205231831.48827.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Complete the refactor of the rtd520 driver to remove all the
forward declarations.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---

No code changes here, just moving of the functions. This file
still has a lot of checkpatch warnings that will be addressed.

 drivers/staging/comedi/drivers/rtd520.c | 2704 +++++++++++++++----------------
 1 files changed, 1337 insertions(+), 1367 deletions(-)

diff --git a/drivers/staging/comedi/drivers/rtd520.c b/drivers/staging/comedi/drivers/rtd520.c
index 1678a0c..8a6f5bb 100644
--- a/drivers/staging/comedi/drivers/rtd520.c
+++ b/drivers/staging/comedi/drivers/rtd520.c
@@ -703,444 +703,47 @@ struct rtdPrivate {
 #define RtdDma1Status(dev) \
 	readb(devpriv->lcfg+LCFG_DMACSR1)
 
-static int rtd_ai_rinsn(struct comedi_device *dev, struct comedi_subdevice *s,
-			struct comedi_insn *insn, unsigned int *data);
-static int rtd_ao_winsn(struct comedi_device *dev, struct comedi_subdevice *s,
-			struct comedi_insn *insn, unsigned int *data);
-static int rtd_ao_rinsn(struct comedi_device *dev, struct comedi_subdevice *s,
-			struct comedi_insn *insn, unsigned int *data);
-static int rtd_dio_insn_bits(struct comedi_device *dev,
-			     struct comedi_subdevice *s,
-			     struct comedi_insn *insn, unsigned int *data);
-static int rtd_dio_insn_config(struct comedi_device *dev,
-			       struct comedi_subdevice *s,
-			       struct comedi_insn *insn, unsigned int *data);
-static int rtd_ai_cmdtest(struct comedi_device *dev, struct comedi_subdevice *s,
-			  struct comedi_cmd *cmd);
-static int rtd_ai_cmd(struct comedi_device *dev, struct comedi_subdevice *s);
-static int rtd_ai_cancel(struct comedi_device *dev, struct comedi_subdevice *s);
 /*
- * static int rtd_ai_poll(struct comedi_device *dev,
- *			  struct comedi_subdevice *s);
- */
-static int rtd_ns_to_timer(unsigned int *ns, int roundMode);
-static irqreturn_t rtd_interrupt(int irq, void *d);
-static int rtd520_probe_fifo_depth(struct comedi_device *dev);
+  Given a desired period and the clock period (both in ns),
+  return the proper counter value (divider-1).
+  Sets the original period to be the true value.
+  Note: you have to check if the value is larger than the counter range!
+*/
+static int rtd_ns_to_timer_base(unsigned int *nanosec,	/* desired period (in ns) */
+				int round_mode, int base)
+{				/* clock period (in ns) */
+	int divider;
 
-/*
- * Attach is called by the Comedi core to configure the driver
- * for a particular board.  If you specified a board_name array
- * in the driver structure, dev->board_ptr contains that
- * address.
- */
-static int rtd_attach(struct comedi_device *dev, struct comedi_devconfig *it)
-{				/* board name and options flags */
-	struct comedi_subdevice *s;
-	struct pci_dev *pcidev;
-	int ret;
-	resource_size_t physLas0;	/* configuration */
-	resource_size_t physLas1;	/* data area */
-	resource_size_t physLcfg;	/* PLX9080 */
-#ifdef USE_DMA
-	int index;
-#endif
-
-	printk(KERN_INFO "comedi%d: rtd520 attaching.\n", dev->minor);
-
-#if defined(CONFIG_COMEDI_DEBUG) && defined(USE_DMA)
-	/* You can set this a load time: modprobe comedi comedi_debug=1 */
-	if (0 == comedi_debug)	/* force DMA debug printks */
-		comedi_debug = 1;
-#endif
-
-	/*
-	 * Allocate the private structure area.  alloc_private() is a
-	 * convenient macro defined in comedidev.h.
-	 */
-	if (alloc_private(dev, sizeof(struct rtdPrivate)) < 0)
-		return -ENOMEM;
-
-	/*
-	 * Probe the device to determine what device in the series it is.
-	 */
-	for (pcidev = pci_get_device(PCI_VENDOR_ID_RTD, PCI_ANY_ID, NULL);
-	     pcidev != NULL;
-	     pcidev = pci_get_device(PCI_VENDOR_ID_RTD, PCI_ANY_ID, pcidev)) {
-		int i;
-
-		if (it->options[0] || it->options[1]) {
-			if (pcidev->bus->number != it->options[0]
-			    || PCI_SLOT(pcidev->devfn) != it->options[1]) {
-				continue;
-			}
-		}
-		for (i = 0; i < ARRAY_SIZE(rtd520Boards); ++i) {
-			if (pcidev->device == rtd520Boards[i].device_id) {
-				dev->board_ptr = &rtd520Boards[i];
-				break;
-			}
-		}
-		if (dev->board_ptr)
-			break;	/* found one */
-	}
-	if (!pcidev) {
-		if (it->options[0] && it->options[1]) {
-			printk(KERN_INFO "No RTD card at bus=%d slot=%d.\n",
-			       it->options[0], it->options[1]);
-		} else {
-			printk(KERN_INFO "No RTD card found.\n");
-		}
-		return -EIO;
-	}
-	devpriv->pci_dev = pcidev;
-	dev->board_name = thisboard->name;
-
-	ret = comedi_pci_enable(pcidev, DRV_NAME);
-	if (ret < 0) {
-		printk(KERN_INFO "Failed to enable PCI device and request regions.\n");
-		return ret;
-	}
-	devpriv->got_regions = 1;
-
-	/*
-	 * Initialize base addresses
-	 */
-	/* Get the physical address from PCI config */
-	physLas0 = pci_resource_start(devpriv->pci_dev, LAS0_PCIINDEX);
-	physLas1 = pci_resource_start(devpriv->pci_dev, LAS1_PCIINDEX);
-	physLcfg = pci_resource_start(devpriv->pci_dev, LCFG_PCIINDEX);
-	/* Now have the kernel map this into memory */
-	/* ASSUME page aligned */
-	devpriv->las0 = ioremap_nocache(physLas0, LAS0_PCISIZE);
-	devpriv->las1 = ioremap_nocache(physLas1, LAS1_PCISIZE);
-	devpriv->lcfg = ioremap_nocache(physLcfg, LCFG_PCISIZE);
-
-	if (!devpriv->las0 || !devpriv->las1 || !devpriv->lcfg)
-		return -ENOMEM;
-
-
-	DPRINTK("%s: LAS0=%llx, LAS1=%llx, CFG=%llx.\n", dev->board_name,
-		(unsigned long long)physLas0, (unsigned long long)physLas1,
-		(unsigned long long)physLcfg);
-	{			/* The RTD driver does this */
-		unsigned char pci_latency;
-		u16 revision;
-		/*uint32_t epld_version; */
-
-		pci_read_config_word(devpriv->pci_dev, PCI_REVISION_ID,
-				     &revision);
-		DPRINTK("%s: PCI revision %d.\n", dev->board_name, revision);
-
-		pci_read_config_byte(devpriv->pci_dev,
-				     PCI_LATENCY_TIMER, &pci_latency);
-		if (pci_latency < 32) {
-			printk(KERN_INFO "%s: PCI latency changed from %d to %d\n",
-			       dev->board_name, pci_latency, 32);
-			pci_write_config_byte(devpriv->pci_dev,
-					      PCI_LATENCY_TIMER, 32);
-		} else {
-			DPRINTK("rtd520: PCI latency = %d\n", pci_latency);
-		}
-
-		/*
-		 * Undocumented EPLD version (doesn't match RTD driver results)
-		 */
-		/*DPRINTK ("rtd520: Reading epld from %p\n",
-		   devpriv->las0+0);
-		   epld_version = readl (devpriv->las0+0);
-		   if ((epld_version & 0xF0) >> 4 == 0x0F) {
-		   DPRINTK("rtd520: pre-v8 EPLD. (%x)\n", epld_version);
-		   } else {
-		   DPRINTK("rtd520: EPLD version %x.\n", epld_version >> 4);
-		   } */
-	}
-
-	/* Show board configuration */
-	printk(KERN_INFO "%s:", dev->board_name);
-
-	/*
-	 * Allocate the subdevice structures.  alloc_subdevice() is a
-	 * convenient macro defined in comedidev.h.
-	 */
-	if (alloc_subdevices(dev, 4) < 0)
-		return -ENOMEM;
-
-
-	s = dev->subdevices + 0;
-	dev->read_subdev = s;
-	/* analog input subdevice */
-	s->type = COMEDI_SUBD_AI;
-	s->subdev_flags =
-	    SDF_READABLE | SDF_GROUND | SDF_COMMON | SDF_DIFF | SDF_CMD_READ;
-	s->n_chan = thisboard->aiChans;
-	s->maxdata = (1 << thisboard->aiBits) - 1;
-	if (thisboard->aiMaxGain <= 32)
-		s->range_table = &rtd_ai_7520_range;
-	else
-		s->range_table = &rtd_ai_4520_range;
-
-	s->len_chanlist = RTD_MAX_CHANLIST;	/* devpriv->fifoLen */
-	s->insn_read = rtd_ai_rinsn;
-	s->do_cmd = rtd_ai_cmd;
-	s->do_cmdtest = rtd_ai_cmdtest;
-	s->cancel = rtd_ai_cancel;
-	/* s->poll = rtd_ai_poll; *//* not ready yet */
-
-	s = dev->subdevices + 1;
-	/* analog output subdevice */
-	s->type = COMEDI_SUBD_AO;
-	s->subdev_flags = SDF_WRITABLE;
-	s->n_chan = 2;
-	s->maxdata = (1 << thisboard->aiBits) - 1;
-	s->range_table = &rtd_ao_range;
-	s->insn_write = rtd_ao_winsn;
-	s->insn_read = rtd_ao_rinsn;
-
-	s = dev->subdevices + 2;
-	/* digital i/o subdevice */
-	s->type = COMEDI_SUBD_DIO;
-	s->subdev_flags = SDF_READABLE | SDF_WRITABLE;
-	/* we only support port 0 right now.  Ignoring port 1 and user IO */
-	s->n_chan = 8;
-	s->maxdata = 1;
-	s->range_table = &range_digital;
-	s->insn_bits = rtd_dio_insn_bits;
-	s->insn_config = rtd_dio_insn_config;
-
-	/* timer/counter subdevices (not currently supported) */
-	s = dev->subdevices + 3;
-	s->type = COMEDI_SUBD_COUNTER;
-	s->subdev_flags = SDF_READABLE | SDF_WRITABLE;
-	s->n_chan = 3;
-	s->maxdata = 0xffff;
-
-	/* initialize board, per RTD spec */
-	/* also, initialize shadow registers */
-	RtdResetBoard(dev);
-	udelay(100);		/* needed? */
-	RtdPlxInterruptWrite(dev, 0);
-	RtdInterruptMask(dev, 0);	/* and sets shadow */
-	RtdInterruptClearMask(dev, ~0);	/* and sets shadow */
-	RtdInterruptClear(dev);	/* clears bits set by mask */
-	RtdInterruptOverrunClear(dev);
-	RtdClearCGT(dev);
-	RtdAdcClearFifo(dev);
-	RtdDacClearFifo(dev, 0);
-	RtdDacClearFifo(dev, 1);
-	/* clear digital IO fifo */
-	RtdDioStatusWrite(dev, 0);	/* safe state, set shadow */
-	RtdUtcCtrlPut(dev, 0, 0x30);	/* safe state, set shadow */
-	RtdUtcCtrlPut(dev, 1, 0x30);	/* safe state, set shadow */
-	RtdUtcCtrlPut(dev, 2, 0x30);	/* safe state, set shadow */
-	RtdUtcCtrlPut(dev, 3, 0);	/* safe state, set shadow */
-	/* TODO: set user out source ??? */
-
-	/* check if our interrupt is available and get it */
-	ret = request_irq(devpriv->pci_dev->irq, rtd_interrupt,
-			  IRQF_SHARED, DRV_NAME, dev);
-
-	if (ret < 0) {
-		printk("Could not get interrupt! (%u)\n",
-		       devpriv->pci_dev->irq);
-		return ret;
-	}
-	dev->irq = devpriv->pci_dev->irq;
-	printk(KERN_INFO "( irq=%u )", dev->irq);
-
-	ret = rtd520_probe_fifo_depth(dev);
-	if (ret < 0)
-		return ret;
-
-	devpriv->fifoLen = ret;
-	printk("( fifoLen=%d )", devpriv->fifoLen);
-
-#ifdef USE_DMA
-	if (dev->irq > 0) {
-		printk("( DMA buff=%d )\n", DMA_CHAIN_COUNT);
-		/*
-		 * The PLX9080 has 2 DMA controllers, but there could be
-		 * 4 sources: ADC, digital, DAC1, and DAC2.  Since only the
-		 * ADC supports cmd mode right now, this isn't an issue (yet)
-		 */
-		devpriv->dma0Offset = 0;
-
-		for (index = 0; index < DMA_CHAIN_COUNT; index++) {
-			devpriv->dma0Buff[index] =
-			    pci_alloc_consistent(devpriv->pci_dev,
-						 sizeof(u16) *
-						 devpriv->fifoLen / 2,
-						 &devpriv->
-						 dma0BuffPhysAddr[index]);
-			if (devpriv->dma0Buff[index] == NULL) {
-				ret = -ENOMEM;
-				goto rtd_attach_die_error;
-			}
-			/*DPRINTK ("buff[%d] @ %p virtual, %x PCI\n",
-			   index,
-			   devpriv->dma0Buff[index],
-			   devpriv->dma0BuffPhysAddr[index]); */
-		}
-
-		/*
-		 * setup DMA descriptor ring (use cpu_to_le32 for byte
-		 * ordering?)
-		 */
-		devpriv->dma0Chain =
-		    pci_alloc_consistent(devpriv->pci_dev,
-					 sizeof(struct plx_dma_desc) *
-					 DMA_CHAIN_COUNT,
-					 &devpriv->dma0ChainPhysAddr);
-		for (index = 0; index < DMA_CHAIN_COUNT; index++) {
-			devpriv->dma0Chain[index].pci_start_addr =
-			    devpriv->dma0BuffPhysAddr[index];
-			devpriv->dma0Chain[index].local_start_addr =
-			    DMALADDR_ADC;
-			devpriv->dma0Chain[index].transfer_size =
-			    sizeof(u16) * devpriv->fifoLen / 2;
-			devpriv->dma0Chain[index].next =
-			    (devpriv->dma0ChainPhysAddr + ((index +
-							    1) %
-							   (DMA_CHAIN_COUNT))
-			     * sizeof(devpriv->dma0Chain[0]))
-			    | DMA_TRANSFER_BITS;
-			/*DPRINTK ("ring[%d] @%lx PCI: %x, local: %x, N: 0x%x, next: %x\n",
-			   index,
-			   ((long)devpriv->dma0ChainPhysAddr
-			   + (index * sizeof(devpriv->dma0Chain[0]))),
-			   devpriv->dma0Chain[index].pci_start_addr,
-			   devpriv->dma0Chain[index].local_start_addr,
-			   devpriv->dma0Chain[index].transfer_size,
-			   devpriv->dma0Chain[index].next); */
-		}
-
-		if (devpriv->dma0Chain == NULL) {
-			ret = -ENOMEM;
-			goto rtd_attach_die_error;
-		}
-
-		RtdDma0Mode(dev, DMA_MODE_BITS);
-		/* set DMA trigger source */
-		RtdDma0Source(dev, DMAS_ADFIFO_HALF_FULL);
-	} else {
-		printk(KERN_INFO "( no IRQ->no DMA )");
-	}
-#endif /* USE_DMA */
-
-	if (dev->irq) {		/* enable plx9080 interrupts */
-		RtdPlxInterruptWrite(dev, ICS_PIE | ICS_PLIE);
-	}
-
-	printk("\ncomedi%d: rtd520 driver attached.\n", dev->minor);
-
-	return 1;
-
-#if 0
-	/* hit an error, clean up memory and return ret */
-/* rtd_attach_die_error: */
-#ifdef USE_DMA
-	for (index = 0; index < DMA_CHAIN_COUNT; index++) {
-		if (NULL != devpriv->dma0Buff[index]) {	/* free buffer memory */
-			pci_free_consistent(devpriv->pci_dev,
-					    sizeof(u16) * devpriv->fifoLen / 2,
-					    devpriv->dma0Buff[index],
-					    devpriv->dma0BuffPhysAddr[index]);
-			devpriv->dma0Buff[index] = NULL;
-		}
-	}
-	if (NULL != devpriv->dma0Chain) {
-		pci_free_consistent(devpriv->pci_dev,
-				    sizeof(struct plx_dma_desc)
-				    * DMA_CHAIN_COUNT,
-				    devpriv->dma0Chain,
-				    devpriv->dma0ChainPhysAddr);
-		devpriv->dma0Chain = NULL;
-	}
-#endif /* USE_DMA */
-	/* subdevices and priv are freed by the core */
-	if (dev->irq) {
-		/* disable interrupt controller */
-		RtdPlxInterruptWrite(dev, RtdPlxInterruptRead(dev)
-				     & ~(ICS_PLIE | ICS_DMA0_E | ICS_DMA1_E));
-		free_irq(dev->irq, dev);
+	switch (round_mode) {
+	case TRIG_ROUND_NEAREST:
+	default:
+		divider = (*nanosec + base / 2) / base;
+		break;
+	case TRIG_ROUND_DOWN:
+		divider = (*nanosec) / base;
+		break;
+	case TRIG_ROUND_UP:
+		divider = (*nanosec + base - 1) / base;
+		break;
 	}
+	if (divider < 2)
+		divider = 2;	/* min is divide by 2 */
 
-	/* release all regions that were allocated */
-	if (devpriv->las0)
-		iounmap(devpriv->las0);
-
-	if (devpriv->las1)
-		iounmap(devpriv->las1);
-
-	if (devpriv->lcfg)
-		iounmap(devpriv->lcfg);
-
-	if (devpriv->pci_dev)
-		pci_dev_put(devpriv->pci_dev);
+	/* Note: we don't check for max, because different timers
+	   have different ranges */
 
-	return ret;
-#endif
+	*nanosec = base * divider;
+	return divider - 1;	/* countdown is divisor+1 */
 }
 
-static void rtd_detach(struct comedi_device *dev)
+/*
+  Given a desired period (in ns),
+  return the proper counter value (divider-1) for the internal clock.
+  Sets the original period to be the true value.
+*/
+static int rtd_ns_to_timer(unsigned int *ns, int round_mode)
 {
-#ifdef USE_DMA
-	int index;
-#endif
-
-	if (devpriv) {
-		/* Shut down any board ops by resetting it */
-#ifdef USE_DMA
-		if (devpriv->lcfg) {
-			RtdDma0Control(dev, 0);	/* disable DMA */
-			RtdDma1Control(dev, 0);	/* disable DMA */
-			RtdPlxInterruptWrite(dev, ICS_PIE | ICS_PLIE);
-		}
-#endif /* USE_DMA */
-		if (devpriv->las0) {
-			RtdResetBoard(dev);
-			RtdInterruptMask(dev, 0);
-			RtdInterruptClearMask(dev, ~0);
-			RtdInterruptClear(dev);	/* clears bits set by mask */
-		}
-#ifdef USE_DMA
-		/* release DMA */
-		for (index = 0; index < DMA_CHAIN_COUNT; index++) {
-			if (NULL != devpriv->dma0Buff[index]) {
-				pci_free_consistent(devpriv->pci_dev,
-						    sizeof(u16) *
-						    devpriv->fifoLen / 2,
-						    devpriv->dma0Buff[index],
-						    devpriv->
-						    dma0BuffPhysAddr[index]);
-				devpriv->dma0Buff[index] = NULL;
-			}
-		}
-		if (NULL != devpriv->dma0Chain) {
-			pci_free_consistent(devpriv->pci_dev,
-					    sizeof(struct plx_dma_desc) *
-					    DMA_CHAIN_COUNT, devpriv->dma0Chain,
-					    devpriv->dma0ChainPhysAddr);
-			devpriv->dma0Chain = NULL;
-		}
-#endif /* USE_DMA */
-		if (dev->irq) {
-			RtdPlxInterruptWrite(dev, RtdPlxInterruptRead(dev)
-					     & ~(ICS_PLIE | ICS_DMA0_E |
-						 ICS_DMA1_E));
-			free_irq(dev->irq, dev);
-		}
-		if (devpriv->las0)
-			iounmap(devpriv->las0);
-		if (devpriv->las1)
-			iounmap(devpriv->las1);
-		if (devpriv->lcfg)
-			iounmap(devpriv->lcfg);
-		if (devpriv->pci_dev) {
-			if (devpriv->got_regions)
-				comedi_pci_disable(devpriv->pci_dev);
-			pci_dev_put(devpriv->pci_dev);
-		}
-	}
+	return rtd_ns_to_timer_base(ns, round_mode, RTD_CLOCK_BASE);
 }
 
 /*
@@ -2119,49 +1722,6 @@ static int rtd_ai_cancel(struct comedi_device *dev, struct comedi_subdevice *s)
 }
 
 /*
-  Given a desired period and the clock period (both in ns),
-  return the proper counter value (divider-1).
-  Sets the original period to be the true value.
-  Note: you have to check if the value is larger than the counter range!
-*/
-static int rtd_ns_to_timer_base(unsigned int *nanosec,	/* desired period (in ns) */
-				int round_mode, int base)
-{				/* clock period (in ns) */
-	int divider;
-
-	switch (round_mode) {
-	case TRIG_ROUND_NEAREST:
-	default:
-		divider = (*nanosec + base / 2) / base;
-		break;
-	case TRIG_ROUND_DOWN:
-		divider = (*nanosec) / base;
-		break;
-	case TRIG_ROUND_UP:
-		divider = (*nanosec + base - 1) / base;
-		break;
-	}
-	if (divider < 2)
-		divider = 2;	/* min is divide by 2 */
-
-	/* Note: we don't check for max, because different timers
-	   have different ranges */
-
-	*nanosec = base * divider;
-	return divider - 1;	/* countdown is divisor+1 */
-}
-
-/*
-  Given a desired period (in ns),
-  return the proper counter value (divider-1) for the internal clock.
-  Sets the original period to be the true value.
-*/
-static int rtd_ns_to_timer(unsigned int *ns, int round_mode)
-{
-	return rtd_ns_to_timer_base(ns, round_mode, RTD_CLOCK_BASE);
-}
-
-/*
   Output one (or more) analog values to a single port as fast as possible.
 */
 static int rtd_ao_winsn(struct comedi_device *dev,
@@ -2315,6 +1875,416 @@ static int rtd_dio_insn_config(struct comedi_device *dev,
 	return 1;
 }
 
+static int rtd_attach(struct comedi_device *dev, struct comedi_devconfig *it)
+{				/* board name and options flags */
+	struct comedi_subdevice *s;
+	struct pci_dev *pcidev;
+	int ret;
+	resource_size_t physLas0;	/* configuration */
+	resource_size_t physLas1;	/* data area */
+	resource_size_t physLcfg;	/* PLX9080 */
+#ifdef USE_DMA
+	int index;
+#endif
+
+	printk(KERN_INFO "comedi%d: rtd520 attaching.\n", dev->minor);
+
+#if defined(CONFIG_COMEDI_DEBUG) && defined(USE_DMA)
+	/* You can set this a load time: modprobe comedi comedi_debug=1 */
+	if (0 == comedi_debug)	/* force DMA debug printks */
+		comedi_debug = 1;
+#endif
+
+	/*
+	 * Allocate the private structure area.  alloc_private() is a
+	 * convenient macro defined in comedidev.h.
+	 */
+	if (alloc_private(dev, sizeof(struct rtdPrivate)) < 0)
+		return -ENOMEM;
+
+	/*
+	 * Probe the device to determine what device in the series it is.
+	 */
+	for (pcidev = pci_get_device(PCI_VENDOR_ID_RTD, PCI_ANY_ID, NULL);
+	     pcidev != NULL;
+	     pcidev = pci_get_device(PCI_VENDOR_ID_RTD, PCI_ANY_ID, pcidev)) {
+		int i;
+
+		if (it->options[0] || it->options[1]) {
+			if (pcidev->bus->number != it->options[0]
+			    || PCI_SLOT(pcidev->devfn) != it->options[1]) {
+				continue;
+			}
+		}
+		for (i = 0; i < ARRAY_SIZE(rtd520Boards); ++i) {
+			if (pcidev->device == rtd520Boards[i].device_id) {
+				dev->board_ptr = &rtd520Boards[i];
+				break;
+			}
+		}
+		if (dev->board_ptr)
+			break;	/* found one */
+	}
+	if (!pcidev) {
+		if (it->options[0] && it->options[1]) {
+			printk(KERN_INFO "No RTD card at bus=%d slot=%d.\n",
+			       it->options[0], it->options[1]);
+		} else {
+			printk(KERN_INFO "No RTD card found.\n");
+		}
+		return -EIO;
+	}
+	devpriv->pci_dev = pcidev;
+	dev->board_name = thisboard->name;
+
+	ret = comedi_pci_enable(pcidev, DRV_NAME);
+	if (ret < 0) {
+		printk(KERN_INFO "Failed to enable PCI device and request regions.\n");
+		return ret;
+	}
+	devpriv->got_regions = 1;
+
+	/*
+	 * Initialize base addresses
+	 */
+	/* Get the physical address from PCI config */
+	physLas0 = pci_resource_start(devpriv->pci_dev, LAS0_PCIINDEX);
+	physLas1 = pci_resource_start(devpriv->pci_dev, LAS1_PCIINDEX);
+	physLcfg = pci_resource_start(devpriv->pci_dev, LCFG_PCIINDEX);
+	/* Now have the kernel map this into memory */
+	/* ASSUME page aligned */
+	devpriv->las0 = ioremap_nocache(physLas0, LAS0_PCISIZE);
+	devpriv->las1 = ioremap_nocache(physLas1, LAS1_PCISIZE);
+	devpriv->lcfg = ioremap_nocache(physLcfg, LCFG_PCISIZE);
+
+	if (!devpriv->las0 || !devpriv->las1 || !devpriv->lcfg)
+		return -ENOMEM;
+
+
+	DPRINTK("%s: LAS0=%llx, LAS1=%llx, CFG=%llx.\n", dev->board_name,
+		(unsigned long long)physLas0, (unsigned long long)physLas1,
+		(unsigned long long)physLcfg);
+	{			/* The RTD driver does this */
+		unsigned char pci_latency;
+		u16 revision;
+		/*uint32_t epld_version; */
+
+		pci_read_config_word(devpriv->pci_dev, PCI_REVISION_ID,
+				     &revision);
+		DPRINTK("%s: PCI revision %d.\n", dev->board_name, revision);
+
+		pci_read_config_byte(devpriv->pci_dev,
+				     PCI_LATENCY_TIMER, &pci_latency);
+		if (pci_latency < 32) {
+			printk(KERN_INFO "%s: PCI latency changed from %d to %d\n",
+			       dev->board_name, pci_latency, 32);
+			pci_write_config_byte(devpriv->pci_dev,
+					      PCI_LATENCY_TIMER, 32);
+		} else {
+			DPRINTK("rtd520: PCI latency = %d\n", pci_latency);
+		}
+
+		/*
+		 * Undocumented EPLD version (doesn't match RTD driver results)
+		 */
+		/*DPRINTK ("rtd520: Reading epld from %p\n",
+		   devpriv->las0+0);
+		   epld_version = readl (devpriv->las0+0);
+		   if ((epld_version & 0xF0) >> 4 == 0x0F) {
+		   DPRINTK("rtd520: pre-v8 EPLD. (%x)\n", epld_version);
+		   } else {
+		   DPRINTK("rtd520: EPLD version %x.\n", epld_version >> 4);
+		   } */
+	}
+
+	/* Show board configuration */
+	printk(KERN_INFO "%s:", dev->board_name);
+
+	/*
+	 * Allocate the subdevice structures.  alloc_subdevice() is a
+	 * convenient macro defined in comedidev.h.
+	 */
+	if (alloc_subdevices(dev, 4) < 0)
+		return -ENOMEM;
+
+
+	s = dev->subdevices + 0;
+	dev->read_subdev = s;
+	/* analog input subdevice */
+	s->type = COMEDI_SUBD_AI;
+	s->subdev_flags =
+	    SDF_READABLE | SDF_GROUND | SDF_COMMON | SDF_DIFF | SDF_CMD_READ;
+	s->n_chan = thisboard->aiChans;
+	s->maxdata = (1 << thisboard->aiBits) - 1;
+	if (thisboard->aiMaxGain <= 32)
+		s->range_table = &rtd_ai_7520_range;
+	else
+		s->range_table = &rtd_ai_4520_range;
+
+	s->len_chanlist = RTD_MAX_CHANLIST;	/* devpriv->fifoLen */
+	s->insn_read = rtd_ai_rinsn;
+	s->do_cmd = rtd_ai_cmd;
+	s->do_cmdtest = rtd_ai_cmdtest;
+	s->cancel = rtd_ai_cancel;
+	/* s->poll = rtd_ai_poll; *//* not ready yet */
+
+	s = dev->subdevices + 1;
+	/* analog output subdevice */
+	s->type = COMEDI_SUBD_AO;
+	s->subdev_flags = SDF_WRITABLE;
+	s->n_chan = 2;
+	s->maxdata = (1 << thisboard->aiBits) - 1;
+	s->range_table = &rtd_ao_range;
+	s->insn_write = rtd_ao_winsn;
+	s->insn_read = rtd_ao_rinsn;
+
+	s = dev->subdevices + 2;
+	/* digital i/o subdevice */
+	s->type = COMEDI_SUBD_DIO;
+	s->subdev_flags = SDF_READABLE | SDF_WRITABLE;
+	/* we only support port 0 right now.  Ignoring port 1 and user IO */
+	s->n_chan = 8;
+	s->maxdata = 1;
+	s->range_table = &range_digital;
+	s->insn_bits = rtd_dio_insn_bits;
+	s->insn_config = rtd_dio_insn_config;
+
+	/* timer/counter subdevices (not currently supported) */
+	s = dev->subdevices + 3;
+	s->type = COMEDI_SUBD_COUNTER;
+	s->subdev_flags = SDF_READABLE | SDF_WRITABLE;
+	s->n_chan = 3;
+	s->maxdata = 0xffff;
+
+	/* initialize board, per RTD spec */
+	/* also, initialize shadow registers */
+	RtdResetBoard(dev);
+	udelay(100);		/* needed? */
+	RtdPlxInterruptWrite(dev, 0);
+	RtdInterruptMask(dev, 0);	/* and sets shadow */
+	RtdInterruptClearMask(dev, ~0);	/* and sets shadow */
+	RtdInterruptClear(dev);	/* clears bits set by mask */
+	RtdInterruptOverrunClear(dev);
+	RtdClearCGT(dev);
+	RtdAdcClearFifo(dev);
+	RtdDacClearFifo(dev, 0);
+	RtdDacClearFifo(dev, 1);
+	/* clear digital IO fifo */
+	RtdDioStatusWrite(dev, 0);	/* safe state, set shadow */
+	RtdUtcCtrlPut(dev, 0, 0x30);	/* safe state, set shadow */
+	RtdUtcCtrlPut(dev, 1, 0x30);	/* safe state, set shadow */
+	RtdUtcCtrlPut(dev, 2, 0x30);	/* safe state, set shadow */
+	RtdUtcCtrlPut(dev, 3, 0);	/* safe state, set shadow */
+	/* TODO: set user out source ??? */
+
+	/* check if our interrupt is available and get it */
+	ret = request_irq(devpriv->pci_dev->irq, rtd_interrupt,
+			  IRQF_SHARED, DRV_NAME, dev);
+
+	if (ret < 0) {
+		printk("Could not get interrupt! (%u)\n",
+		       devpriv->pci_dev->irq);
+		return ret;
+	}
+	dev->irq = devpriv->pci_dev->irq;
+	printk(KERN_INFO "( irq=%u )", dev->irq);
+
+	ret = rtd520_probe_fifo_depth(dev);
+	if (ret < 0)
+		return ret;
+
+	devpriv->fifoLen = ret;
+	printk("( fifoLen=%d )", devpriv->fifoLen);
+
+#ifdef USE_DMA
+	if (dev->irq > 0) {
+		printk("( DMA buff=%d )\n", DMA_CHAIN_COUNT);
+		/*
+		 * The PLX9080 has 2 DMA controllers, but there could be
+		 * 4 sources: ADC, digital, DAC1, and DAC2.  Since only the
+		 * ADC supports cmd mode right now, this isn't an issue (yet)
+		 */
+		devpriv->dma0Offset = 0;
+
+		for (index = 0; index < DMA_CHAIN_COUNT; index++) {
+			devpriv->dma0Buff[index] =
+			    pci_alloc_consistent(devpriv->pci_dev,
+						 sizeof(u16) *
+						 devpriv->fifoLen / 2,
+						 &devpriv->
+						 dma0BuffPhysAddr[index]);
+			if (devpriv->dma0Buff[index] == NULL) {
+				ret = -ENOMEM;
+				goto rtd_attach_die_error;
+			}
+			/*DPRINTK ("buff[%d] @ %p virtual, %x PCI\n",
+			   index,
+			   devpriv->dma0Buff[index],
+			   devpriv->dma0BuffPhysAddr[index]); */
+		}
+
+		/*
+		 * setup DMA descriptor ring (use cpu_to_le32 for byte
+		 * ordering?)
+		 */
+		devpriv->dma0Chain =
+		    pci_alloc_consistent(devpriv->pci_dev,
+					 sizeof(struct plx_dma_desc) *
+					 DMA_CHAIN_COUNT,
+					 &devpriv->dma0ChainPhysAddr);
+		for (index = 0; index < DMA_CHAIN_COUNT; index++) {
+			devpriv->dma0Chain[index].pci_start_addr =
+			    devpriv->dma0BuffPhysAddr[index];
+			devpriv->dma0Chain[index].local_start_addr =
+			    DMALADDR_ADC;
+			devpriv->dma0Chain[index].transfer_size =
+			    sizeof(u16) * devpriv->fifoLen / 2;
+			devpriv->dma0Chain[index].next =
+			    (devpriv->dma0ChainPhysAddr + ((index +
+							    1) %
+							   (DMA_CHAIN_COUNT))
+			     * sizeof(devpriv->dma0Chain[0]))
+			    | DMA_TRANSFER_BITS;
+			/*DPRINTK ("ring[%d] @%lx PCI: %x, local: %x, N: 0x%x, next: %x\n",
+			   index,
+			   ((long)devpriv->dma0ChainPhysAddr
+			   + (index * sizeof(devpriv->dma0Chain[0]))),
+			   devpriv->dma0Chain[index].pci_start_addr,
+			   devpriv->dma0Chain[index].local_start_addr,
+			   devpriv->dma0Chain[index].transfer_size,
+			   devpriv->dma0Chain[index].next); */
+		}
+
+		if (devpriv->dma0Chain == NULL) {
+			ret = -ENOMEM;
+			goto rtd_attach_die_error;
+		}
+
+		RtdDma0Mode(dev, DMA_MODE_BITS);
+		/* set DMA trigger source */
+		RtdDma0Source(dev, DMAS_ADFIFO_HALF_FULL);
+	} else {
+		printk(KERN_INFO "( no IRQ->no DMA )");
+	}
+#endif /* USE_DMA */
+
+	if (dev->irq) {		/* enable plx9080 interrupts */
+		RtdPlxInterruptWrite(dev, ICS_PIE | ICS_PLIE);
+	}
+
+	printk("\ncomedi%d: rtd520 driver attached.\n", dev->minor);
+
+	return 1;
+
+#if 0
+	/* hit an error, clean up memory and return ret */
+/* rtd_attach_die_error: */
+#ifdef USE_DMA
+	for (index = 0; index < DMA_CHAIN_COUNT; index++) {
+		if (NULL != devpriv->dma0Buff[index]) {	/* free buffer memory */
+			pci_free_consistent(devpriv->pci_dev,
+					    sizeof(u16) * devpriv->fifoLen / 2,
+					    devpriv->dma0Buff[index],
+					    devpriv->dma0BuffPhysAddr[index]);
+			devpriv->dma0Buff[index] = NULL;
+		}
+	}
+	if (NULL != devpriv->dma0Chain) {
+		pci_free_consistent(devpriv->pci_dev,
+				    sizeof(struct plx_dma_desc)
+				    * DMA_CHAIN_COUNT,
+				    devpriv->dma0Chain,
+				    devpriv->dma0ChainPhysAddr);
+		devpriv->dma0Chain = NULL;
+	}
+#endif /* USE_DMA */
+	/* subdevices and priv are freed by the core */
+	if (dev->irq) {
+		/* disable interrupt controller */
+		RtdPlxInterruptWrite(dev, RtdPlxInterruptRead(dev)
+				     & ~(ICS_PLIE | ICS_DMA0_E | ICS_DMA1_E));
+		free_irq(dev->irq, dev);
+	}
+
+	/* release all regions that were allocated */
+	if (devpriv->las0)
+		iounmap(devpriv->las0);
+
+	if (devpriv->las1)
+		iounmap(devpriv->las1);
+
+	if (devpriv->lcfg)
+		iounmap(devpriv->lcfg);
+
+	if (devpriv->pci_dev)
+		pci_dev_put(devpriv->pci_dev);
+
+	return ret;
+#endif
+}
+
+static void rtd_detach(struct comedi_device *dev)
+{
+#ifdef USE_DMA
+	int index;
+#endif
+
+	if (devpriv) {
+		/* Shut down any board ops by resetting it */
+#ifdef USE_DMA
+		if (devpriv->lcfg) {
+			RtdDma0Control(dev, 0);	/* disable DMA */
+			RtdDma1Control(dev, 0);	/* disable DMA */
+			RtdPlxInterruptWrite(dev, ICS_PIE | ICS_PLIE);
+		}
+#endif /* USE_DMA */
+		if (devpriv->las0) {
+			RtdResetBoard(dev);
+			RtdInterruptMask(dev, 0);
+			RtdInterruptClearMask(dev, ~0);
+			RtdInterruptClear(dev);	/* clears bits set by mask */
+		}
+#ifdef USE_DMA
+		/* release DMA */
+		for (index = 0; index < DMA_CHAIN_COUNT; index++) {
+			if (NULL != devpriv->dma0Buff[index]) {
+				pci_free_consistent(devpriv->pci_dev,
+						    sizeof(u16) *
+						    devpriv->fifoLen / 2,
+						    devpriv->dma0Buff[index],
+						    devpriv->
+						    dma0BuffPhysAddr[index]);
+				devpriv->dma0Buff[index] = NULL;
+			}
+		}
+		if (NULL != devpriv->dma0Chain) {
+			pci_free_consistent(devpriv->pci_dev,
+					    sizeof(struct plx_dma_desc) *
+					    DMA_CHAIN_COUNT, devpriv->dma0Chain,
+					    devpriv->dma0ChainPhysAddr);
+			devpriv->dma0Chain = NULL;
+		}
+#endif /* USE_DMA */
+		if (dev->irq) {
+			RtdPlxInterruptWrite(dev, RtdPlxInterruptRead(dev)
+					     & ~(ICS_PLIE | ICS_DMA0_E |
+						 ICS_DMA1_E));
+			free_irq(dev->irq, dev);
+		}
+		if (devpriv->las0)
+			iounmap(devpriv->las0);
+		if (devpriv->las1)
+			iounmap(devpriv->las1);
+		if (devpriv->lcfg)
+			iounmap(devpriv->lcfg);
+		if (devpriv->pci_dev) {
+			if (devpriv->got_regions)
+				comedi_pci_disable(devpriv->pci_dev);
+			pci_dev_put(devpriv->pci_dev);
+		}
+	}
+}
+
 static struct comedi_driver rtd520_driver = {
 	.driver_name	= "rtd520",
 	.module		= THIS_MODULE,
