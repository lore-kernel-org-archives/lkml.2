Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755049Ab2D0Vpf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 17:45:35 -0400
Received: from mail132.messagelabs.com ([216.82.242.115]:44340 "EHLO
	mail132.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754611Ab2D0Vpd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 17:45:33 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-3.tower-132.messagelabs.com!1335563112!9918345!18
X-Originating-IP: [216.166.12.178]
X-StarScan-Version: 6.5.7; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] staging: comedi: refactor s526 driver to remove forward declarations
Date: Fri, 27 Apr 2012 14:45:19 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201204271445.19917.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the module_init/module_exit routines and the associated
struct comedi_driver and other variables to the end of the source.
This is more typical of how other drivers are written and removes
the need for the forward declarations.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---

diff --git a/drivers/staging/comedi/drivers/s526.c b/drivers/staging/comedi/drivers/s526.c
index 2b34dae..ffe4362 100644
--- a/drivers/staging/comedi/drivers/s526.c
+++ b/drivers/staging/comedi/drivers/s526.c
@@ -230,287 +230,6 @@ struct s526_private {
  */
 #define devpriv ((struct s526_private *)dev->private)
 
-/*
- * The struct comedi_driver structure tells the Comedi core module
- * which functions to call to configure/deconfigure (attach/detach)
- * the board, and also about the kernel module that contains
- * the device code.
- */
-static int s526_attach(struct comedi_device *dev, struct comedi_devconfig *it);
-static int s526_detach(struct comedi_device *dev);
-static struct comedi_driver driver_s526 = {
-	.driver_name = "s526",
-	.module = THIS_MODULE,
-	.attach = s526_attach,
-	.detach = s526_detach,
-/* It is not necessary to implement the following members if you are
- * writing a driver for a ISA PnP or PCI card */
-	/* Most drivers will support multiple types of boards by
-	 * having an array of board structures.  These were defined
-	 * in s526_boards[] above.  Note that the element 'name'
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
-	.board_name = &s526_boards[0].name,
-	.offset = sizeof(struct s526_board),
-	.num_names = ARRAY_SIZE(s526_boards),
-};
-
-static int s526_gpct_rinsn(struct comedi_device *dev,
-			   struct comedi_subdevice *s, struct comedi_insn *insn,
-			   unsigned int *data);
-static int s526_gpct_insn_config(struct comedi_device *dev,
-				 struct comedi_subdevice *s,
-				 struct comedi_insn *insn, unsigned int *data);
-static int s526_gpct_winsn(struct comedi_device *dev,
-			   struct comedi_subdevice *s, struct comedi_insn *insn,
-			   unsigned int *data);
-static int s526_ai_insn_config(struct comedi_device *dev,
-			       struct comedi_subdevice *s,
-			       struct comedi_insn *insn, unsigned int *data);
-static int s526_ai_rinsn(struct comedi_device *dev, struct comedi_subdevice *s,
-			 struct comedi_insn *insn, unsigned int *data);
-static int s526_ao_winsn(struct comedi_device *dev, struct comedi_subdevice *s,
-			 struct comedi_insn *insn, unsigned int *data);
-static int s526_ao_rinsn(struct comedi_device *dev, struct comedi_subdevice *s,
-			 struct comedi_insn *insn, unsigned int *data);
-static int s526_dio_insn_bits(struct comedi_device *dev,
-			      struct comedi_subdevice *s,
-			      struct comedi_insn *insn, unsigned int *data);
-static int s526_dio_insn_config(struct comedi_device *dev,
-				struct comedi_subdevice *s,
-				struct comedi_insn *insn, unsigned int *data);
-
-/*
- * Attach is called by the Comedi core to configure the driver
- * for a particular board.  If you specified a board_name array
- * in the driver structure, dev->board_ptr contains that
- * address.
- */
-static int s526_attach(struct comedi_device *dev, struct comedi_devconfig *it)
-{
-	struct comedi_subdevice *s;
-	int iobase;
-	int i, n;
-/* short value; */
-/* int subdev_channel = 0; */
-	union cmReg cmReg;
-
-	printk(KERN_INFO "comedi%d: s526: ", dev->minor);
-
-	iobase = it->options[0];
-	if (!iobase || !request_region(iobase, S526_IOSIZE, thisboard->name)) {
-		comedi_error(dev, "I/O port conflict");
-		return -EIO;
-	}
-	dev->iobase = iobase;
-
-	printk("iobase=0x%lx\n", dev->iobase);
-
-	/*** make it a little quieter, exw, 8/29/06
-	for (i = 0; i < S526_NUM_PORTS; i++) {
-		printk("0x%02x: 0x%04x\n", ADDR_REG(s526_ports[i]),
-				inw(ADDR_REG(s526_ports[i])));
-	}
-	***/
-
-/*
- * Initialize dev->board_name.  Note that we can use the "thisboard"
- * macro now, since we just initialized it in the last line.
- */
-	dev->board_ptr = &s526_boards[0];
-
-	dev->board_name = thisboard->name;
-
-/*
- * Allocate the private structure area.  alloc_private() is a
- * convenient macro defined in comedidev.h.
- */
-	if (alloc_private(dev, sizeof(struct s526_private)) < 0)
-		return -ENOMEM;
-
-/*
- * Allocate the subdevice structures.  alloc_subdevice() is a
- * convenient macro defined in comedidev.h.
- */
-	dev->n_subdevices = 4;
-	if (alloc_subdevices(dev, dev->n_subdevices) < 0)
-		return -ENOMEM;
-
-	s = dev->subdevices + 0;
-	/* GENERAL-PURPOSE COUNTER/TIME (GPCT) */
-	s->type = COMEDI_SUBD_COUNTER;
-	s->subdev_flags = SDF_READABLE | SDF_WRITABLE | SDF_LSAMPL;
-	/* KG: What does SDF_LSAMPL (see multiq3.c) mean? */
-	s->n_chan = thisboard->gpct_chans;
-	s->maxdata = 0x00ffffff;	/* 24 bit counter */
-	s->insn_read = s526_gpct_rinsn;
-	s->insn_config = s526_gpct_insn_config;
-	s->insn_write = s526_gpct_winsn;
-
-	/* Command are not implemented yet, however they are necessary to
-	   allocate the necessary memory for the comedi_async struct (used
-	   to trigger the GPCT in case of pulsegenerator function */
-	/* s->do_cmd = s526_gpct_cmd; */
-	/* s->do_cmdtest = s526_gpct_cmdtest; */
-	/* s->cancel = s526_gpct_cancel; */
-
-	s = dev->subdevices + 1;
-	/* dev->read_subdev=s; */
-	/* analog input subdevice */
-	s->type = COMEDI_SUBD_AI;
-	/* we support differential */
-	s->subdev_flags = SDF_READABLE | SDF_DIFF;
-	/* channels 0 to 7 are the regular differential inputs */
-	/* channel 8 is "reference 0" (+10V), channel 9 is "reference 1" (0V) */
-	s->n_chan = 10;
-	s->maxdata = 0xffff;
-	s->range_table = &range_bipolar10;
-	s->len_chanlist = 16;	/* This is the maximum chanlist length that
-				   the board can handle */
-	s->insn_read = s526_ai_rinsn;
-	s->insn_config = s526_ai_insn_config;
-
-	s = dev->subdevices + 2;
-	/* analog output subdevice */
-	s->type = COMEDI_SUBD_AO;
-	s->subdev_flags = SDF_WRITABLE;
-	s->n_chan = 4;
-	s->maxdata = 0xffff;
-	s->range_table = &range_bipolar10;
-	s->insn_write = s526_ao_winsn;
-	s->insn_read = s526_ao_rinsn;
-
-	s = dev->subdevices + 3;
-	/* digital i/o subdevice */
-	if (thisboard->have_dio) {
-		s->type = COMEDI_SUBD_DIO;
-		s->subdev_flags = SDF_READABLE | SDF_WRITABLE;
-		s->n_chan = 8;
-		s->maxdata = 1;
-		s->range_table = &range_digital;
-		s->insn_bits = s526_dio_insn_bits;
-		s->insn_config = s526_dio_insn_config;
-	} else {
-		s->type = COMEDI_SUBD_UNUSED;
-	}
-
-	printk(KERN_INFO "attached\n");
-
-	return 1;
-
-#if 0
-	/*  Example of Counter Application */
-	/* One-shot (software trigger) */
-	cmReg.reg.coutSource = 0;	/*  out RCAP */
-	cmReg.reg.coutPolarity = 1;	/*  Polarity inverted */
-	cmReg.reg.autoLoadResetRcap = 1;/*  Auto load 0:disabled, 1:enabled */
-	cmReg.reg.hwCtEnableSource = 3;	/*  NOT RCAP */
-	cmReg.reg.ctEnableCtrl = 2;	/*  Hardware */
-	cmReg.reg.clockSource = 2;	/*  Internal */
-	cmReg.reg.countDir = 1;	/*  Down */
-	cmReg.reg.countDirCtrl = 1;	/*  Software */
-	cmReg.reg.outputRegLatchCtrl = 0;	/*  latch on read */
-	cmReg.reg.preloadRegSel = 0;	/*  PR0 */
-	cmReg.reg.reserved = 0;
-
-	outw(cmReg.value, ADDR_CHAN_REG(REG_C0M, subdev_channel));
-
-	outw(0x0001, ADDR_CHAN_REG(REG_C0H, subdev_channel));
-	outw(0x3C68, ADDR_CHAN_REG(REG_C0L, subdev_channel));
-
-	/*  Reset the counter */
-	outw(0x8000, ADDR_CHAN_REG(REG_C0C, subdev_channel));
-	/*  Load the counter from PR0 */
-	outw(0x4000, ADDR_CHAN_REG(REG_C0C, subdev_channel));
-	/*  Reset RCAP (fires one-shot) */
-	outw(0x0008, ADDR_CHAN_REG(REG_C0C, subdev_channel));
-
-#else
-
-	/*  Set Counter Mode Register */
-	cmReg.reg.coutSource = 0;	/*  out RCAP */
-	cmReg.reg.coutPolarity = 0;	/*  Polarity inverted */
-	cmReg.reg.autoLoadResetRcap = 0;	/*  Auto load disabled */
-	cmReg.reg.hwCtEnableSource = 2;	/*  NOT RCAP */
-	cmReg.reg.ctEnableCtrl = 1;	/*  1: Software,  >1 : Hardware */
-	cmReg.reg.clockSource = 3;	/*  x4 */
-	cmReg.reg.countDir = 0;	/*  up */
-	cmReg.reg.countDirCtrl = 0;	/*  quadrature */
-	cmReg.reg.outputRegLatchCtrl = 0;	/*  latch on read */
-	cmReg.reg.preloadRegSel = 0;	/*  PR0 */
-	cmReg.reg.reserved = 0;
-
-	n = 0;
-	printk(KERN_INFO "Mode reg=0x%04x, 0x%04lx\n",
-		cmReg.value, ADDR_CHAN_REG(REG_C0M, n));
-	outw(cmReg.value, ADDR_CHAN_REG(REG_C0M, n));
-	udelay(1000);
-	printk(KERN_INFO "Read back mode reg=0x%04x\n",
-		inw(ADDR_CHAN_REG(REG_C0M, n)));
-
-	/*  Load the pre-load register high word */
-/* value = (short) (0x55); */
-/* outw(value, ADDR_CHAN_REG(REG_C0H, n)); */
-
-	/*  Load the pre-load register low word */
-/* value = (short)(0xaa55); */
-/* outw(value, ADDR_CHAN_REG(REG_C0L, n)); */
-
-	/*  Write the Counter Control Register */
-/* outw(value, ADDR_CHAN_REG(REG_C0C, 0)); */
-
-	/*  Reset the counter if it is software preload */
-	if (cmReg.reg.autoLoadResetRcap == 0) {
-		/*  Reset the counter */
-		outw(0x8000, ADDR_CHAN_REG(REG_C0C, n));
-		/*  Load the counter from PR0 */
-		outw(0x4000, ADDR_CHAN_REG(REG_C0C, n));
-	}
-
-	outw(cmReg.value, ADDR_CHAN_REG(REG_C0M, n));
-	udelay(1000);
-	printk(KERN_INFO "Read back mode reg=0x%04x\n",
-			inw(ADDR_CHAN_REG(REG_C0M, n)));
-
-#endif
-	printk(KERN_INFO "Current registres:\n");
-
-	for (i = 0; i < S526_NUM_PORTS; i++) {
-		printk(KERN_INFO "0x%02lx: 0x%04x\n",
-			ADDR_REG(s526_ports[i]), inw(ADDR_REG(s526_ports[i])));
-	}
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
-static int s526_detach(struct comedi_device *dev)
-{
-	printk(KERN_INFO "comedi%d: s526: remove\n", dev->minor);
-
-	if (dev->iobase > 0)
-		release_region(dev->iobase, S526_IOSIZE);
-
-	return 0;
-}
-
 static int s526_gpct_rinsn(struct comedi_device *dev,
 			   struct comedi_subdevice *s, struct comedi_insn *insn,
 			   unsigned int *data)
@@ -1023,21 +742,232 @@ static int s526_dio_insn_config(struct comedi_device *dev,
 	return 1;
 }
 
+static int s526_attach(struct comedi_device *dev, struct comedi_devconfig *it)
+{
+	struct comedi_subdevice *s;
+	int iobase;
+	int i, n;
+/* short value; */
+/* int subdev_channel = 0; */
+	union cmReg cmReg;
+
+	printk(KERN_INFO "comedi%d: s526: ", dev->minor);
+
+	iobase = it->options[0];
+	if (!iobase || !request_region(iobase, S526_IOSIZE, thisboard->name)) {
+		comedi_error(dev, "I/O port conflict");
+		return -EIO;
+	}
+	dev->iobase = iobase;
+
+	printk("iobase=0x%lx\n", dev->iobase);
+
+	/*** make it a little quieter, exw, 8/29/06
+	for (i = 0; i < S526_NUM_PORTS; i++) {
+		printk("0x%02x: 0x%04x\n", ADDR_REG(s526_ports[i]),
+				inw(ADDR_REG(s526_ports[i])));
+	}
+	***/
+
+/*
+ * Initialize dev->board_name.  Note that we can use the "thisboard"
+ * macro now, since we just initialized it in the last line.
+ */
+	dev->board_ptr = &s526_boards[0];
+
+	dev->board_name = thisboard->name;
+
+/*
+ * Allocate the private structure area.  alloc_private() is a
+ * convenient macro defined in comedidev.h.
+ */
+	if (alloc_private(dev, sizeof(struct s526_private)) < 0)
+		return -ENOMEM;
+
 /*
- * A convenient macro that defines init_module() and cleanup_module(),
- * as necessary.
+ * Allocate the subdevice structures.  alloc_subdevice() is a
+ * convenient macro defined in comedidev.h.
  */
+	dev->n_subdevices = 4;
+	if (alloc_subdevices(dev, dev->n_subdevices) < 0)
+		return -ENOMEM;
+
+	s = dev->subdevices + 0;
+	/* GENERAL-PURPOSE COUNTER/TIME (GPCT) */
+	s->type = COMEDI_SUBD_COUNTER;
+	s->subdev_flags = SDF_READABLE | SDF_WRITABLE | SDF_LSAMPL;
+	/* KG: What does SDF_LSAMPL (see multiq3.c) mean? */
+	s->n_chan = thisboard->gpct_chans;
+	s->maxdata = 0x00ffffff;	/* 24 bit counter */
+	s->insn_read = s526_gpct_rinsn;
+	s->insn_config = s526_gpct_insn_config;
+	s->insn_write = s526_gpct_winsn;
+
+	/* Command are not implemented yet, however they are necessary to
+	   allocate the necessary memory for the comedi_async struct (used
+	   to trigger the GPCT in case of pulsegenerator function */
+	/* s->do_cmd = s526_gpct_cmd; */
+	/* s->do_cmdtest = s526_gpct_cmdtest; */
+	/* s->cancel = s526_gpct_cancel; */
+
+	s = dev->subdevices + 1;
+	/* dev->read_subdev=s; */
+	/* analog input subdevice */
+	s->type = COMEDI_SUBD_AI;
+	/* we support differential */
+	s->subdev_flags = SDF_READABLE | SDF_DIFF;
+	/* channels 0 to 7 are the regular differential inputs */
+	/* channel 8 is "reference 0" (+10V), channel 9 is "reference 1" (0V) */
+	s->n_chan = 10;
+	s->maxdata = 0xffff;
+	s->range_table = &range_bipolar10;
+	s->len_chanlist = 16;	/* This is the maximum chanlist length that
+				   the board can handle */
+	s->insn_read = s526_ai_rinsn;
+	s->insn_config = s526_ai_insn_config;
+
+	s = dev->subdevices + 2;
+	/* analog output subdevice */
+	s->type = COMEDI_SUBD_AO;
+	s->subdev_flags = SDF_WRITABLE;
+	s->n_chan = 4;
+	s->maxdata = 0xffff;
+	s->range_table = &range_bipolar10;
+	s->insn_write = s526_ao_winsn;
+	s->insn_read = s526_ao_rinsn;
+
+	s = dev->subdevices + 3;
+	/* digital i/o subdevice */
+	if (thisboard->have_dio) {
+		s->type = COMEDI_SUBD_DIO;
+		s->subdev_flags = SDF_READABLE | SDF_WRITABLE;
+		s->n_chan = 8;
+		s->maxdata = 1;
+		s->range_table = &range_digital;
+		s->insn_bits = s526_dio_insn_bits;
+		s->insn_config = s526_dio_insn_config;
+	} else {
+		s->type = COMEDI_SUBD_UNUSED;
+	}
+
+	printk(KERN_INFO "attached\n");
+
+	return 1;
+
+#if 0
+	/*  Example of Counter Application */
+	/* One-shot (software trigger) */
+	cmReg.reg.coutSource = 0;	/*  out RCAP */
+	cmReg.reg.coutPolarity = 1;	/*  Polarity inverted */
+	cmReg.reg.autoLoadResetRcap = 1;/*  Auto load 0:disabled, 1:enabled */
+	cmReg.reg.hwCtEnableSource = 3;	/*  NOT RCAP */
+	cmReg.reg.ctEnableCtrl = 2;	/*  Hardware */
+	cmReg.reg.clockSource = 2;	/*  Internal */
+	cmReg.reg.countDir = 1;	/*  Down */
+	cmReg.reg.countDirCtrl = 1;	/*  Software */
+	cmReg.reg.outputRegLatchCtrl = 0;	/*  latch on read */
+	cmReg.reg.preloadRegSel = 0;	/*  PR0 */
+	cmReg.reg.reserved = 0;
+
+	outw(cmReg.value, ADDR_CHAN_REG(REG_C0M, subdev_channel));
+
+	outw(0x0001, ADDR_CHAN_REG(REG_C0H, subdev_channel));
+	outw(0x3C68, ADDR_CHAN_REG(REG_C0L, subdev_channel));
+
+	/*  Reset the counter */
+	outw(0x8000, ADDR_CHAN_REG(REG_C0C, subdev_channel));
+	/*  Load the counter from PR0 */
+	outw(0x4000, ADDR_CHAN_REG(REG_C0C, subdev_channel));
+	/*  Reset RCAP (fires one-shot) */
+	outw(0x0008, ADDR_CHAN_REG(REG_C0C, subdev_channel));
+
+#else
+
+	/*  Set Counter Mode Register */
+	cmReg.reg.coutSource = 0;	/*  out RCAP */
+	cmReg.reg.coutPolarity = 0;	/*  Polarity inverted */
+	cmReg.reg.autoLoadResetRcap = 0;	/*  Auto load disabled */
+	cmReg.reg.hwCtEnableSource = 2;	/*  NOT RCAP */
+	cmReg.reg.ctEnableCtrl = 1;	/*  1: Software,  >1 : Hardware */
+	cmReg.reg.clockSource = 3;	/*  x4 */
+	cmReg.reg.countDir = 0;	/*  up */
+	cmReg.reg.countDirCtrl = 0;	/*  quadrature */
+	cmReg.reg.outputRegLatchCtrl = 0;	/*  latch on read */
+	cmReg.reg.preloadRegSel = 0;	/*  PR0 */
+	cmReg.reg.reserved = 0;
+
+	n = 0;
+	printk(KERN_INFO "Mode reg=0x%04x, 0x%04lx\n",
+		cmReg.value, ADDR_CHAN_REG(REG_C0M, n));
+	outw(cmReg.value, ADDR_CHAN_REG(REG_C0M, n));
+	udelay(1000);
+	printk(KERN_INFO "Read back mode reg=0x%04x\n",
+		inw(ADDR_CHAN_REG(REG_C0M, n)));
+
+	/*  Load the pre-load register high word */
+/* value = (short) (0x55); */
+/* outw(value, ADDR_CHAN_REG(REG_C0H, n)); */
+
+	/*  Load the pre-load register low word */
+/* value = (short)(0xaa55); */
+/* outw(value, ADDR_CHAN_REG(REG_C0L, n)); */
+
+	/*  Write the Counter Control Register */
+/* outw(value, ADDR_CHAN_REG(REG_C0C, 0)); */
+
+	/*  Reset the counter if it is software preload */
+	if (cmReg.reg.autoLoadResetRcap == 0) {
+		/*  Reset the counter */
+		outw(0x8000, ADDR_CHAN_REG(REG_C0C, n));
+		/*  Load the counter from PR0 */
+		outw(0x4000, ADDR_CHAN_REG(REG_C0C, n));
+	}
+
+	outw(cmReg.value, ADDR_CHAN_REG(REG_C0M, n));
+	udelay(1000);
+	printk(KERN_INFO "Read back mode reg=0x%04x\n",
+			inw(ADDR_CHAN_REG(REG_C0M, n)));
+
+#endif
+	printk(KERN_INFO "Current registres:\n");
+
+	for (i = 0; i < S526_NUM_PORTS; i++) {
+		printk(KERN_INFO "0x%02lx: 0x%04x\n",
+			ADDR_REG(s526_ports[i]), inw(ADDR_REG(s526_ports[i])));
+	}
+	return 1;
+}
+
+static int s526_detach(struct comedi_device *dev)
+{
+	printk(KERN_INFO "comedi%d: s526: remove\n", dev->minor);
+
+	if (dev->iobase > 0)
+		release_region(dev->iobase, S526_IOSIZE);
+
+	return 0;
+}
+
+static struct comedi_driver driver_s526 = {
+	.driver_name	= "s526",
+	.module		= THIS_MODULE,
+	.attach		= s526_attach,
+	.detach		= s526_detach,
+	.board_name	= &s526_boards[0].name,
+	.offset		= sizeof(struct s526_board),
+	.num_names	= ARRAY_SIZE(s526_boards),
+};
+
 static int __init driver_s526_init_module(void)
 {
 	return comedi_driver_register(&driver_s526);
 }
+module_init(driver_s526_init_module);
 
 static void __exit driver_s526_cleanup_module(void)
 {
 	comedi_driver_unregister(&driver_s526);
 }
-
-module_init(driver_s526_init_module);
 module_exit(driver_s526_cleanup_module);
 
 MODULE_AUTHOR("Comedi http://www.comedi.org");
