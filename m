Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756263Ab2D0Wjq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 18:39:46 -0400
Received: from mail131.messagelabs.com ([216.82.242.99]:55040 "EHLO
	mail131.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755339Ab2D0Wjp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 18:39:45 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-10.tower-131.messagelabs.com!1335566365!20889522!16
X-Originating-IP: [216.166.12.178]
X-StarScan-Version: 6.5.7; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] staging: comedi: refactor pcmmio driver to remove forward declarations
Date: Fri, 27 Apr 2012 15:39:37 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201204271539.38270.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Refactor the switch_page and pcmmio_stop_intr functions to avoid
needing the forward declarations.

Move the module_init/module_exit routines and the associated
struct comedi_driver and other variables to the end of the source.
This is more typical of how other drivers are written and removes
the need for the forward declarations.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---

diff --git a/drivers/staging/comedi/drivers/pcmmio.c b/drivers/staging/comedi/drivers/pcmmio.c
index eddac00..e05d157 100644
--- a/drivers/staging/comedi/drivers/pcmmio.c
+++ b/drivers/staging/comedi/drivers/pcmmio.c
@@ -145,13 +145,6 @@ Configuration Options:
 #define PAGE_ENAB 2
 #define PAGE_INT_ID 3
 
-static int ai_rinsn(struct comedi_device *, struct comedi_subdevice *,
-		    struct comedi_insn *, unsigned int *);
-static int ao_rinsn(struct comedi_device *, struct comedi_subdevice *,
-		    struct comedi_insn *, unsigned int *);
-static int ao_winsn(struct comedi_device *, struct comedi_subdevice *,
-		    struct comedi_insn *, unsigned int *);
-
 /*
  * Board descriptions for two imaginary boards.  Describing the
  * boards in this way is optional, and completely driver-dependent.
@@ -190,23 +183,6 @@ static const struct comedi_lrange ranges_ao = {
 	  RANGE(-2.5, 2.5), RANGE(-2.5, 7.5)}
 };
 
-static const struct pcmmio_board pcmmio_boards[] = {
-	{
-	 .name = "pcmmio",
-	 .dio_num_asics = 1,
-	 .dio_num_ports = 6,
-	 .total_iosize = 32,
-	 .ai_bits = 16,
-	 .ao_bits = 16,
-	 .n_ai_chans = 16,
-	 .n_ao_chans = 8,
-	 .ai_range_table = &ranges_ai,
-	 .ao_range_table = &ranges_ao,
-	 .ai_rinsn = ai_rinsn,
-	 .ao_rinsn = ao_rinsn,
-	 .ao_winsn = ao_winsn},
-};
-
 /*
  * Useful for shorthand access to the particular board structure
  */
@@ -293,312 +269,6 @@ struct pcmmio_private {
  */
 #define devpriv ((struct pcmmio_private *)dev->private)
 #define subpriv ((struct pcmmio_subdev_private *)s->private)
-/*
- * The struct comedi_driver structure tells the Comedi core module
- * which functions to call to configure/deconfigure (attach/detach)
- * the board, and also about the kernel module that contains
- * the device code.
- */
-static int pcmmio_attach(struct comedi_device *dev,
-			 struct comedi_devconfig *it);
-static int pcmmio_detach(struct comedi_device *dev);
-
-static struct comedi_driver driver = {
-	.driver_name = "pcmmio",
-	.module = THIS_MODULE,
-	.attach = pcmmio_attach,
-	.detach = pcmmio_detach,
-/* It is not necessary to implement the following members if you are
- * writing a driver for a ISA PnP or PCI card */
-	/* Most drivers will support multiple types of boards by
-	 * having an array of board structures.  These were defined
-	 * in pcmmio_boards[] above.  Note that the element 'name'
-	 * was first in the structure -- Comedi uses this fact to
-	 * extract the name of the board without knowing any details
-	 * about the structure except for its length.
-	 * When a device is attached (by comedi_config), the name
-	 * of the device is given to Comedi, and Comedi tries to
-	 * match it by going through the list of board names.  If
-	 * there is a match, the address of the pointer is put
-	 * into dev->board_ptr and driver->attach() is called.
-	 *
-	 * Note that these are not necessary if you can determine
-	 * the type of board in software.  ISA PnP, PCI, and PCMCIA
-	 * devices are such boards.
-	 */
-	.board_name = &pcmmio_boards[0].name,
-	.offset = sizeof(struct pcmmio_board),
-	.num_names = ARRAY_SIZE(pcmmio_boards),
-};
-
-static int pcmmio_dio_insn_bits(struct comedi_device *dev,
-				struct comedi_subdevice *s,
-				struct comedi_insn *insn, unsigned int *data);
-static int pcmmio_dio_insn_config(struct comedi_device *dev,
-				  struct comedi_subdevice *s,
-				  struct comedi_insn *insn, unsigned int *data);
-
-static irqreturn_t interrupt_pcmmio(int irq, void *d);
-static void pcmmio_stop_intr(struct comedi_device *, struct comedi_subdevice *);
-static int pcmmio_cancel(struct comedi_device *dev, struct comedi_subdevice *s);
-static int pcmmio_cmd(struct comedi_device *dev, struct comedi_subdevice *s);
-static int pcmmio_cmdtest(struct comedi_device *dev, struct comedi_subdevice *s,
-			  struct comedi_cmd *cmd);
-
-/* some helper functions to deal with specifics of this device's registers */
-/* sets up/clears ASIC chips to defaults */
-static void init_asics(struct comedi_device *dev);
-static void switch_page(struct comedi_device *dev, int asic, int page);
-#ifdef notused
-static void lock_port(struct comedi_device *dev, int asic, int port);
-static void unlock_port(struct comedi_device *dev, int asic, int port);
-#endif
-
-/*
- * Attach is called by the Comedi core to configure the driver
- * for a particular board.  If you specified a board_name array
- * in the driver structure, dev->board_ptr contains that
- * address.
- */
-static int pcmmio_attach(struct comedi_device *dev, struct comedi_devconfig *it)
-{
-	struct comedi_subdevice *s;
-	int sdev_no, chans_left, n_dio_subdevs, n_subdevs, port, asic,
-	    thisasic_chanct = 0;
-	unsigned long iobase;
-	unsigned int irq[MAX_ASICS];
-
-	iobase = it->options[0];
-	irq[0] = it->options[1];
-
-	printk(KERN_INFO "comedi%d: %s: io: %lx attaching...\n", dev->minor,
-			driver.driver_name, iobase);
-
-	dev->iobase = iobase;
-
-	if (!iobase || !request_region(iobase,
-				       thisboard->total_iosize,
-				       driver.driver_name)) {
-		printk(KERN_ERR "comedi%d: I/O port conflict\n", dev->minor);
-		return -EIO;
-	}
-
-/*
- * Initialize dev->board_name.  Note that we can use the "thisboard"
- * macro now, since we just initialized it in the last line.
- */
-	dev->board_name = thisboard->name;
-
-/*
- * Allocate the private structure area.  alloc_private() is a
- * convenient macro defined in comedidev.h.
- */
-	if (alloc_private(dev, sizeof(struct pcmmio_private)) < 0) {
-		printk(KERN_ERR "comedi%d: cannot allocate private data structure\n",
-				dev->minor);
-		return -ENOMEM;
-	}
-
-	for (asic = 0; asic < MAX_ASICS; ++asic) {
-		devpriv->asics[asic].num = asic;
-		devpriv->asics[asic].iobase =
-		    dev->iobase + 16 + asic * ASIC_IOSIZE;
-		/*
-		 * this gets actually set at the end of this function when we
-		 * request_irqs
-		 */
-		devpriv->asics[asic].irq = 0;
-		spin_lock_init(&devpriv->asics[asic].spinlock);
-	}
-
-	chans_left = CHANS_PER_ASIC * thisboard->dio_num_asics;
-	n_dio_subdevs = CALC_N_DIO_SUBDEVS(chans_left);
-	n_subdevs = n_dio_subdevs + 2;
-	devpriv->sprivs =
-	    kcalloc(n_subdevs, sizeof(struct pcmmio_subdev_private),
-		    GFP_KERNEL);
-	if (!devpriv->sprivs) {
-		printk(KERN_ERR "comedi%d: cannot allocate subdevice private data structures\n",
-				dev->minor);
-		return -ENOMEM;
-	}
-	/*
-	 * Allocate the subdevice structures.  alloc_subdevice() is a
-	 * convenient macro defined in comedidev.h.
-	 *
-	 * Allocate 1 AI + 1 AO + 2 DIO subdevs (24 lines per DIO)
-	 */
-	if (alloc_subdevices(dev, n_subdevs) < 0) {
-		printk(KERN_ERR "comedi%d: cannot allocate subdevice data structures\n",
-				dev->minor);
-		return -ENOMEM;
-	}
-
-	/* First, AI */
-	sdev_no = 0;
-	s = dev->subdevices + sdev_no;
-	s->private = devpriv->sprivs + sdev_no;
-	s->maxdata = (1 << thisboard->ai_bits) - 1;
-	s->range_table = thisboard->ai_range_table;
-	s->subdev_flags = SDF_READABLE | SDF_GROUND | SDF_DIFF;
-	s->type = COMEDI_SUBD_AI;
-	s->n_chan = thisboard->n_ai_chans;
-	s->len_chanlist = s->n_chan;
-	s->insn_read = thisboard->ai_rinsn;
-	subpriv->iobase = dev->iobase + 0;
-	/* initialize the resource enable register by clearing it */
-	outb(0, subpriv->iobase + 3);
-	outb(0, subpriv->iobase + 4 + 3);
-
-	/* Next, AO */
-	++sdev_no;
-	s = dev->subdevices + sdev_no;
-	s->private = devpriv->sprivs + sdev_no;
-	s->maxdata = (1 << thisboard->ao_bits) - 1;
-	s->range_table = thisboard->ao_range_table;
-	s->subdev_flags = SDF_READABLE;
-	s->type = COMEDI_SUBD_AO;
-	s->n_chan = thisboard->n_ao_chans;
-	s->len_chanlist = s->n_chan;
-	s->insn_read = thisboard->ao_rinsn;
-	s->insn_write = thisboard->ao_winsn;
-	subpriv->iobase = dev->iobase + 8;
-	/* initialize the resource enable register by clearing it */
-	outb(0, subpriv->iobase + 3);
-	outb(0, subpriv->iobase + 4 + 3);
-
-	++sdev_no;
-	port = 0;
-	asic = 0;
-	for (; sdev_no < (int)dev->n_subdevices; ++sdev_no) {
-		int byte_no;
-
-		s = dev->subdevices + sdev_no;
-		s->private = devpriv->sprivs + sdev_no;
-		s->maxdata = 1;
-		s->range_table = &range_digital;
-		s->subdev_flags = SDF_READABLE | SDF_WRITABLE;
-		s->type = COMEDI_SUBD_DIO;
-		s->insn_bits = pcmmio_dio_insn_bits;
-		s->insn_config = pcmmio_dio_insn_config;
-		s->n_chan = min(chans_left, MAX_CHANS_PER_SUBDEV);
-		subpriv->dio.intr.asic = -1;
-		subpriv->dio.intr.first_chan = -1;
-		subpriv->dio.intr.asic_chan = -1;
-		subpriv->dio.intr.num_asic_chans = -1;
-		subpriv->dio.intr.active = 0;
-		s->len_chanlist = 1;
-
-		/* save the ioport address for each 'port' of 8 channels in the
-		   subdevice */
-		for (byte_no = 0; byte_no < PORTS_PER_SUBDEV; ++byte_no, ++port) {
-			if (port >= PORTS_PER_ASIC) {
-				port = 0;
-				++asic;
-				thisasic_chanct = 0;
-			}
-			subpriv->iobases[byte_no] =
-			    devpriv->asics[asic].iobase + port;
-
-			if (thisasic_chanct <
-			    CHANS_PER_PORT * INTR_PORTS_PER_ASIC
-			    && subpriv->dio.intr.asic < 0) {
-				/*
-				 * this is an interrupt subdevice,
-				 * so setup the struct
-				 */
-				subpriv->dio.intr.asic = asic;
-				subpriv->dio.intr.active = 0;
-				subpriv->dio.intr.stop_count = 0;
-				subpriv->dio.intr.first_chan = byte_no * 8;
-				subpriv->dio.intr.asic_chan = thisasic_chanct;
-				subpriv->dio.intr.num_asic_chans =
-				    s->n_chan - subpriv->dio.intr.first_chan;
-				s->cancel = pcmmio_cancel;
-				s->do_cmd = pcmmio_cmd;
-				s->do_cmdtest = pcmmio_cmdtest;
-				s->len_chanlist =
-				    subpriv->dio.intr.num_asic_chans;
-			}
-			thisasic_chanct += CHANS_PER_PORT;
-		}
-		spin_lock_init(&subpriv->dio.intr.spinlock);
-
-		chans_left -= s->n_chan;
-
-		if (!chans_left) {
-			/*
-			 * reset the asic to our first asic,
-			 * to do intr subdevs
-			 */
-			asic = 0;
-			port = 0;
-		}
-
-	}
-
-	init_asics(dev);	/* clear out all the registers, basically */
-
-	for (asic = 0; irq[0] && asic < MAX_ASICS; ++asic) {
-		if (irq[asic]
-		    && request_irq(irq[asic], interrupt_pcmmio,
-				   IRQF_SHARED, thisboard->name, dev)) {
-			int i;
-			/* unroll the allocated irqs.. */
-			for (i = asic - 1; i >= 0; --i) {
-				free_irq(irq[i], dev);
-				devpriv->asics[i].irq = irq[i] = 0;
-			}
-			irq[asic] = 0;
-		}
-		devpriv->asics[asic].irq = irq[asic];
-	}
-
-	dev->irq = irq[0];	/*
-				 * grr.. wish comedi dev struct supported
-				 * multiple irqs..
-				 */
-
-	if (irq[0]) {
-		printk(KERN_DEBUG "comedi%d: irq: %u\n", dev->minor, irq[0]);
-		if (thisboard->dio_num_asics == 2 && irq[1])
-			printk(KERN_DEBUG "comedi%d: second ASIC irq: %u\n",
-					dev->minor, irq[1]);
-	} else {
-		printk(KERN_INFO "comedi%d: (IRQ mode disabled)\n", dev->minor);
-	}
-
-	printk(KERN_INFO "comedi%d: attached\n", dev->minor);
-
-	return 1;
-}
-
-/*
- * _detach is called to deconfigure a device.  It should deallocate
- * resources.
- * This function is also called when _attach() fails, so it should be
- * careful not to release resources that were not necessarily
- * allocated by _attach().  dev->private and dev->subdevices are
- * deallocated automatically by the core.
- */
-static int pcmmio_detach(struct comedi_device *dev)
-{
-	int i;
-
-	printk(KERN_INFO "comedi%d: %s: remove\n", dev->minor, driver.driver_name);
-	if (dev->iobase)
-		release_region(dev->iobase, thisboard->total_iosize);
-
-	for (i = 0; i < MAX_ASICS; ++i) {
-		if (devpriv && devpriv->asics[i].irq)
-			free_irq(devpriv->asics[i].irq, dev);
-	}
-
-	if (devpriv && devpriv->sprivs)
-		kfree(devpriv->sprivs);
-
-	return 0;
-}
 
 /* DIO devices are slightly special.  Although it is possible to
  * implement the insn_read/insn_write interface, it is much more
@@ -751,6 +421,21 @@ static int pcmmio_dio_insn_config(struct comedi_device *dev,
 	return insn->n;
 }
 
+static void switch_page(struct comedi_device *dev, int asic, int page)
+{
+	if (asic < 0 || asic >= thisboard->dio_num_asics)
+		return;		/* paranoia */
+	if (page < 0 || page >= NUM_PAGES)
+		return;		/* more paranoia */
+
+	devpriv->asics[asic].pagelock &= ~REG_PAGE_MASK;
+	devpriv->asics[asic].pagelock |= page << REG_PAGE_BITOFFSET;
+
+	/* now write out the shadow register */
+	outb(devpriv->asics[asic].pagelock,
+	     devpriv->asics[asic].iobase + REG_PAGELOCK);
+}
+
 static void init_asics(struct comedi_device *dev)
 {				/* sets up an
 				   ASIC chip to defaults */
@@ -788,21 +473,6 @@ static void init_asics(struct comedi_device *dev)
 	}
 }
 
-static void switch_page(struct comedi_device *dev, int asic, int page)
-{
-	if (asic < 0 || asic >= thisboard->dio_num_asics)
-		return;		/* paranoia */
-	if (page < 0 || page >= NUM_PAGES)
-		return;		/* more paranoia */
-
-	devpriv->asics[asic].pagelock &= ~REG_PAGE_MASK;
-	devpriv->asics[asic].pagelock |= page << REG_PAGE_BITOFFSET;
-
-	/* now write out the shadow register */
-	outb(devpriv->asics[asic].pagelock,
-	     devpriv->asics[asic].iobase + REG_PAGELOCK);
-}
-
 #ifdef notused
 static void lock_port(struct comedi_device *dev, int asic, int port)
 {
@@ -831,6 +501,27 @@ static void unlock_port(struct comedi_device *dev, int asic, int port)
 }
 #endif /* notused */
 
+static void pcmmio_stop_intr(struct comedi_device *dev,
+			     struct comedi_subdevice *s)
+{
+	int nports, firstport, asic, port;
+
+	asic = subpriv->dio.intr.asic;
+	if (asic < 0)
+		return;		/* not an interrupt subdev */
+
+	subpriv->dio.intr.enabled_mask = 0;
+	subpriv->dio.intr.active = 0;
+	s->async->inttrig = 0;
+	nports = subpriv->dio.intr.num_asic_chans / CHANS_PER_PORT;
+	firstport = subpriv->dio.intr.asic_chan / CHANS_PER_PORT;
+	switch_page(dev, asic, PAGE_ENAB);
+	for (port = firstport; port < firstport + nports; ++port) {
+		/* disable all intrs for this subdev.. */
+		outb(0, devpriv->asics[asic].iobase + REG_ENAB0 + port);
+	}
+}
+
 static irqreturn_t interrupt_pcmmio(int irq, void *d)
 {
 	int asic, got1 = 0;
@@ -981,35 +672,14 @@ static irqreturn_t interrupt_pcmmio(int irq, void *d)
 
 					}
 
-				}
-			}
-
-		}
-	}
-	if (!got1)
-		return IRQ_NONE;	/* interrupt from other source */
-	return IRQ_HANDLED;
-}
-
-static void pcmmio_stop_intr(struct comedi_device *dev,
-			     struct comedi_subdevice *s)
-{
-	int nports, firstport, asic, port;
-
-	asic = subpriv->dio.intr.asic;
-	if (asic < 0)
-		return;		/* not an interrupt subdev */
-
-	subpriv->dio.intr.enabled_mask = 0;
-	subpriv->dio.intr.active = 0;
-	s->async->inttrig = 0;
-	nports = subpriv->dio.intr.num_asic_chans / CHANS_PER_PORT;
-	firstport = subpriv->dio.intr.asic_chan / CHANS_PER_PORT;
-	switch_page(dev, asic, PAGE_ENAB);
-	for (port = firstport; port < firstport + nports; ++port) {
-		/* disable all intrs for this subdev.. */
-		outb(0, devpriv->asics[asic].iobase + REG_ENAB0 + port);
+				}
+			}
+
+		}
 	}
+	if (!got1)
+		return IRQ_NONE;	/* interrupt from other source */
+	return IRQ_HANDLED;
 }
 
 static int pcmmio_start_intr(struct comedi_device *dev,
@@ -1340,21 +1010,276 @@ static int ao_winsn(struct comedi_device *dev, struct comedi_subdevice *s,
 	return n;
 }
 
+static int pcmmio_attach(struct comedi_device *dev, struct comedi_devconfig *it)
+{
+	struct comedi_subdevice *s;
+	int sdev_no, chans_left, n_dio_subdevs, n_subdevs, port, asic,
+	    thisasic_chanct = 0;
+	unsigned long iobase;
+	unsigned int irq[MAX_ASICS];
+
+	iobase = it->options[0];
+	irq[0] = it->options[1];
+
+	printk(KERN_INFO "comedi%d: %s: io: %lx attaching...\n", dev->minor,
+			driver.driver_name, iobase);
+
+	dev->iobase = iobase;
+
+	if (!iobase || !request_region(iobase,
+				       thisboard->total_iosize,
+				       driver.driver_name)) {
+		printk(KERN_ERR "comedi%d: I/O port conflict\n", dev->minor);
+		return -EIO;
+	}
+
+/*
+ * Initialize dev->board_name.  Note that we can use the "thisboard"
+ * macro now, since we just initialized it in the last line.
+ */
+	dev->board_name = thisboard->name;
+
 /*
- * A convenient macro that defines init_module() and cleanup_module(),
- * as necessary.
+ * Allocate the private structure area.  alloc_private() is a
+ * convenient macro defined in comedidev.h.
  */
+	if (alloc_private(dev, sizeof(struct pcmmio_private)) < 0) {
+		printk(KERN_ERR "comedi%d: cannot allocate private data structure\n",
+				dev->minor);
+		return -ENOMEM;
+	}
+
+	for (asic = 0; asic < MAX_ASICS; ++asic) {
+		devpriv->asics[asic].num = asic;
+		devpriv->asics[asic].iobase =
+		    dev->iobase + 16 + asic * ASIC_IOSIZE;
+		/*
+		 * this gets actually set at the end of this function when we
+		 * request_irqs
+		 */
+		devpriv->asics[asic].irq = 0;
+		spin_lock_init(&devpriv->asics[asic].spinlock);
+	}
+
+	chans_left = CHANS_PER_ASIC * thisboard->dio_num_asics;
+	n_dio_subdevs = CALC_N_DIO_SUBDEVS(chans_left);
+	n_subdevs = n_dio_subdevs + 2;
+	devpriv->sprivs =
+	    kcalloc(n_subdevs, sizeof(struct pcmmio_subdev_private),
+		    GFP_KERNEL);
+	if (!devpriv->sprivs) {
+		printk(KERN_ERR "comedi%d: cannot allocate subdevice private data structures\n",
+				dev->minor);
+		return -ENOMEM;
+	}
+	/*
+	 * Allocate the subdevice structures.  alloc_subdevice() is a
+	 * convenient macro defined in comedidev.h.
+	 *
+	 * Allocate 1 AI + 1 AO + 2 DIO subdevs (24 lines per DIO)
+	 */
+	if (alloc_subdevices(dev, n_subdevs) < 0) {
+		printk(KERN_ERR "comedi%d: cannot allocate subdevice data structures\n",
+				dev->minor);
+		return -ENOMEM;
+	}
+
+	/* First, AI */
+	sdev_no = 0;
+	s = dev->subdevices + sdev_no;
+	s->private = devpriv->sprivs + sdev_no;
+	s->maxdata = (1 << thisboard->ai_bits) - 1;
+	s->range_table = thisboard->ai_range_table;
+	s->subdev_flags = SDF_READABLE | SDF_GROUND | SDF_DIFF;
+	s->type = COMEDI_SUBD_AI;
+	s->n_chan = thisboard->n_ai_chans;
+	s->len_chanlist = s->n_chan;
+	s->insn_read = thisboard->ai_rinsn;
+	subpriv->iobase = dev->iobase + 0;
+	/* initialize the resource enable register by clearing it */
+	outb(0, subpriv->iobase + 3);
+	outb(0, subpriv->iobase + 4 + 3);
+
+	/* Next, AO */
+	++sdev_no;
+	s = dev->subdevices + sdev_no;
+	s->private = devpriv->sprivs + sdev_no;
+	s->maxdata = (1 << thisboard->ao_bits) - 1;
+	s->range_table = thisboard->ao_range_table;
+	s->subdev_flags = SDF_READABLE;
+	s->type = COMEDI_SUBD_AO;
+	s->n_chan = thisboard->n_ao_chans;
+	s->len_chanlist = s->n_chan;
+	s->insn_read = thisboard->ao_rinsn;
+	s->insn_write = thisboard->ao_winsn;
+	subpriv->iobase = dev->iobase + 8;
+	/* initialize the resource enable register by clearing it */
+	outb(0, subpriv->iobase + 3);
+	outb(0, subpriv->iobase + 4 + 3);
+
+	++sdev_no;
+	port = 0;
+	asic = 0;
+	for (; sdev_no < (int)dev->n_subdevices; ++sdev_no) {
+		int byte_no;
+
+		s = dev->subdevices + sdev_no;
+		s->private = devpriv->sprivs + sdev_no;
+		s->maxdata = 1;
+		s->range_table = &range_digital;
+		s->subdev_flags = SDF_READABLE | SDF_WRITABLE;
+		s->type = COMEDI_SUBD_DIO;
+		s->insn_bits = pcmmio_dio_insn_bits;
+		s->insn_config = pcmmio_dio_insn_config;
+		s->n_chan = min(chans_left, MAX_CHANS_PER_SUBDEV);
+		subpriv->dio.intr.asic = -1;
+		subpriv->dio.intr.first_chan = -1;
+		subpriv->dio.intr.asic_chan = -1;
+		subpriv->dio.intr.num_asic_chans = -1;
+		subpriv->dio.intr.active = 0;
+		s->len_chanlist = 1;
+
+		/* save the ioport address for each 'port' of 8 channels in the
+		   subdevice */
+		for (byte_no = 0; byte_no < PORTS_PER_SUBDEV; ++byte_no, ++port) {
+			if (port >= PORTS_PER_ASIC) {
+				port = 0;
+				++asic;
+				thisasic_chanct = 0;
+			}
+			subpriv->iobases[byte_no] =
+			    devpriv->asics[asic].iobase + port;
+
+			if (thisasic_chanct <
+			    CHANS_PER_PORT * INTR_PORTS_PER_ASIC
+			    && subpriv->dio.intr.asic < 0) {
+				/*
+				 * this is an interrupt subdevice,
+				 * so setup the struct
+				 */
+				subpriv->dio.intr.asic = asic;
+				subpriv->dio.intr.active = 0;
+				subpriv->dio.intr.stop_count = 0;
+				subpriv->dio.intr.first_chan = byte_no * 8;
+				subpriv->dio.intr.asic_chan = thisasic_chanct;
+				subpriv->dio.intr.num_asic_chans =
+				    s->n_chan - subpriv->dio.intr.first_chan;
+				s->cancel = pcmmio_cancel;
+				s->do_cmd = pcmmio_cmd;
+				s->do_cmdtest = pcmmio_cmdtest;
+				s->len_chanlist =
+				    subpriv->dio.intr.num_asic_chans;
+			}
+			thisasic_chanct += CHANS_PER_PORT;
+		}
+		spin_lock_init(&subpriv->dio.intr.spinlock);
+
+		chans_left -= s->n_chan;
+
+		if (!chans_left) {
+			/*
+			 * reset the asic to our first asic,
+			 * to do intr subdevs
+			 */
+			asic = 0;
+			port = 0;
+		}
+
+	}
+
+	init_asics(dev);	/* clear out all the registers, basically */
+
+	for (asic = 0; irq[0] && asic < MAX_ASICS; ++asic) {
+		if (irq[asic]
+		    && request_irq(irq[asic], interrupt_pcmmio,
+				   IRQF_SHARED, thisboard->name, dev)) {
+			int i;
+			/* unroll the allocated irqs.. */
+			for (i = asic - 1; i >= 0; --i) {
+				free_irq(irq[i], dev);
+				devpriv->asics[i].irq = irq[i] = 0;
+			}
+			irq[asic] = 0;
+		}
+		devpriv->asics[asic].irq = irq[asic];
+	}
+
+	dev->irq = irq[0];	/*
+				 * grr.. wish comedi dev struct supported
+				 * multiple irqs..
+				 */
+
+	if (irq[0]) {
+		printk(KERN_DEBUG "comedi%d: irq: %u\n", dev->minor, irq[0]);
+		if (thisboard->dio_num_asics == 2 && irq[1])
+			printk(KERN_DEBUG "comedi%d: second ASIC irq: %u\n",
+					dev->minor, irq[1]);
+	} else {
+		printk(KERN_INFO "comedi%d: (IRQ mode disabled)\n", dev->minor);
+	}
+
+	printk(KERN_INFO "comedi%d: attached\n", dev->minor);
+
+	return 1;
+}
+
+static int pcmmio_detach(struct comedi_device *dev)
+{
+	int i;
+
+	printk(KERN_INFO "comedi%d: %s: remove\n", dev->minor, driver.driver_name);
+	if (dev->iobase)
+		release_region(dev->iobase, thisboard->total_iosize);
+
+	for (i = 0; i < MAX_ASICS; ++i) {
+		if (devpriv && devpriv->asics[i].irq)
+			free_irq(devpriv->asics[i].irq, dev);
+	}
+
+	if (devpriv && devpriv->sprivs)
+		kfree(devpriv->sprivs);
+
+	return 0;
+}
+
+static const struct pcmmio_board pcmmio_boards[] = {
+	{
+		.name		= "pcmmio",
+		.dio_num_asics	= 1,
+		.dio_num_ports	= 6,
+		.total_iosize	= 32,
+		.ai_bits	= 16,
+		.ao_bits	= 16,
+		.n_ai_chans	= 16,
+		.n_ao_chans	= 8,
+		.ai_range_table	= &ranges_ai,
+		.ao_range_table	= &ranges_ao,
+		.ai_rinsn	= ai_rinsn,
+		.ao_rinsn	= ao_rinsn,
+		.ao_winsn	= ao_winsn
+	},
+};
+
+static struct comedi_driver driver = {
+	.driver_name	= "pcmmio",
+	.module		= THIS_MODULE,
+	.attach		= pcmmio_attach,
+	.detach		= pcmmio_detach,
+	.board_name	= &pcmmio_boards[0].name,
+	.offset		= sizeof(struct pcmmio_board),
+	.num_names	= ARRAY_SIZE(pcmmio_boards),
+};
+
 static int __init driver_init_module(void)
 {
 	return comedi_driver_register(&driver);
 }
+module_init(driver_init_module);
 
 static void __exit driver_cleanup_module(void)
 {
 	comedi_driver_unregister(&driver);
 }
-
-module_init(driver_init_module);
 module_exit(driver_cleanup_module);
 
 MODULE_AUTHOR("Comedi http://www.comedi.org");
