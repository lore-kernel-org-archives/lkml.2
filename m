Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756638Ab2D0WoT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 18:44:19 -0400
Received: from mail209.messagelabs.com ([216.82.255.3]:59033 "EHLO
	mail209.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756241Ab2D0WoT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 18:44:19 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-16.tower-209.messagelabs.com!1335566657!4273511!1
X-Originating-IP: [216.166.12.99]
X-StarScan-Version: 6.5.7; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] staging: comedi: refactor pcmda12 driver to remove forward declarations
Date: Fri, 27 Apr 2012 15:44:02 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201204271544.03390.hartleys@visionengravers.com>
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

diff --git a/drivers/staging/comedi/drivers/pcmda12.c b/drivers/staging/comedi/drivers/pcmda12.c
index 0e9ffa2..4846d98 100644
--- a/drivers/staging/comedi/drivers/pcmda12.c
+++ b/drivers/staging/comedi/drivers/pcmda12.c
@@ -80,12 +80,6 @@ static const struct comedi_lrange pcmda12_ranges = {
 	 }
 };
 
-static const struct pcmda12_board pcmda12_boards[] = {
-	{
-	 .name = "pcmda12",
-	 },
-};
-
 /*
  * Useful for shorthand access to the particular board structure
  */
@@ -99,57 +93,77 @@ struct pcmda12_private {
 
 #define devpriv ((struct pcmda12_private *)(dev->private))
 
-/*
- * The struct comedi_driver structure tells the Comedi core module
- * which functions to call to configure/deconfigure (attach/detach)
- * the board, and also about the kernel module that contains
- * the device code.
- */
-static int pcmda12_attach(struct comedi_device *dev,
-			  struct comedi_devconfig *it);
-static int pcmda12_detach(struct comedi_device *dev);
+static void zero_chans(struct comedi_device *dev)
+{				/* sets up an
+				   ASIC chip to defaults */
+	int i;
+	for (i = 0; i < CHANS; ++i) {
+/*      /\* do this as one instruction?? *\/ */
+/*      outw(0, LSB_PORT(chan)); */
+		outb(0, LSB_PORT(i));
+		outb(0, MSB_PORT(i));
+	}
+	inb(LSB_PORT(0));	/* update chans. */
+}
 
-static void zero_chans(struct comedi_device *dev);
+static int ao_winsn(struct comedi_device *dev, struct comedi_subdevice *s,
+		    struct comedi_insn *insn, unsigned int *data)
+{
+	int i;
+	int chan = CR_CHAN(insn->chanspec);
 
-static struct comedi_driver driver = {
-	.driver_name = "pcmda12",
-	.module = THIS_MODULE,
-	.attach = pcmda12_attach,
-	.detach = pcmda12_detach,
-/* It is not necessary to implement the following members if you are
- * writing a driver for a ISA PnP or PCI card */
-	/* Most drivers will support multiple types of boards by
-	 * having an array of board structures.  These were defined
-	 * in pcmda12_boards[] above.  Note that the element 'name'
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
-	.board_name = &pcmda12_boards[0].name,
-	.offset = sizeof(struct pcmda12_board),
-	.num_names = ARRAY_SIZE(pcmda12_boards),
-};
+	/* Writing a list of values to an AO channel is probably not
+	 * very useful, but that's how the interface is defined. */
+	for (i = 0; i < insn->n; ++i) {
 
-static int ao_winsn(struct comedi_device *dev, struct comedi_subdevice *s,
-		    struct comedi_insn *insn, unsigned int *data);
+/*      /\* do this as one instruction?? *\/ */
+/*      outw(data[i], LSB_PORT(chan)); */
+
+		/* Need to do this as two instructions due to 8-bit bus?? */
+		/*  first, load the low byte */
+		outb(LSB(data[i]), LSB_PORT(chan));
+		/*  next, write the high byte */
+		outb(MSB(data[i]), MSB_PORT(chan));
+
+		/* save shadow register */
+		devpriv->ao_readback[chan] = data[i];
+
+		if (!devpriv->simultaneous_xfer_mode)
+			inb(LSB_PORT(chan));
+	}
+
+	/* return the number of samples written */
+	return i;
+}
+
+/* AO subdevices should have a read insn as well as a write insn.
+
+   Usually this means copying a value stored in devpriv->ao_readback.
+   However, since this driver supports simultaneous xfer then sometimes
+   this function actually accomplishes work.
+
+   Simultaneaous xfer mode is accomplished by loading ALL the values
+   you want for AO in all the channels, then READing off one of the AO
+   registers to initiate the instantaneous simultaneous update of all
+   DAC outputs, which makes all AO channels update simultaneously.
+   This is useful for some control applications, I would imagine.
+*/
 static int ao_rinsn(struct comedi_device *dev, struct comedi_subdevice *s,
-		    struct comedi_insn *insn, unsigned int *data);
+		    struct comedi_insn *insn, unsigned int *data)
+{
+	int i;
+	int chan = CR_CHAN(insn->chanspec);
+
+	for (i = 0; i < insn->n; i++) {
+		if (devpriv->simultaneous_xfer_mode)
+			inb(LSB_PORT(chan));
+		/* read back shadow register */
+		data[i] = devpriv->ao_readback[chan];
+	}
+
+	return i;
+}
 
-/*
- * Attach is called by the Comedi core to configure the driver
- * for a particular board.  If you specified a board_name array
- * in the driver structure, dev->board_ptr contains that
- * address.
- */
 static int pcmda12_attach(struct comedi_device *dev,
 			  struct comedi_devconfig *it)
 {
@@ -213,14 +227,6 @@ static int pcmda12_attach(struct comedi_device *dev,
 	return 1;
 }
 
-/*
- * _detach is called to deconfigure a device.  It should deallocate
- * resources.
- * This function is also called when _attach() fails, so it should be
- * careful not to release resources that were not necessarily
- * allocated by _attach().  dev->private and dev->subdevices are
- * deallocated automatically by the core.
- */
 static int pcmda12_detach(struct comedi_device *dev)
 {
 	printk(KERN_INFO
@@ -230,92 +236,32 @@ static int pcmda12_detach(struct comedi_device *dev)
 	return 0;
 }
 
-static void zero_chans(struct comedi_device *dev)
-{				/* sets up an
-				   ASIC chip to defaults */
-	int i;
-	for (i = 0; i < CHANS; ++i) {
-/*      /\* do this as one instruction?? *\/ */
-/*      outw(0, LSB_PORT(chan)); */
-		outb(0, LSB_PORT(i));
-		outb(0, MSB_PORT(i));
-	}
-	inb(LSB_PORT(0));	/* update chans. */
-}
-
-static int ao_winsn(struct comedi_device *dev, struct comedi_subdevice *s,
-		    struct comedi_insn *insn, unsigned int *data)
-{
-	int i;
-	int chan = CR_CHAN(insn->chanspec);
-
-	/* Writing a list of values to an AO channel is probably not
-	 * very useful, but that's how the interface is defined. */
-	for (i = 0; i < insn->n; ++i) {
-
-/*      /\* do this as one instruction?? *\/ */
-/*      outw(data[i], LSB_PORT(chan)); */
-
-		/* Need to do this as two instructions due to 8-bit bus?? */
-		/*  first, load the low byte */
-		outb(LSB(data[i]), LSB_PORT(chan));
-		/*  next, write the high byte */
-		outb(MSB(data[i]), MSB_PORT(chan));
-
-		/* save shadow register */
-		devpriv->ao_readback[chan] = data[i];
-
-		if (!devpriv->simultaneous_xfer_mode)
-			inb(LSB_PORT(chan));
-	}
-
-	/* return the number of samples written */
-	return i;
-}
-
-/* AO subdevices should have a read insn as well as a write insn.
-
-   Usually this means copying a value stored in devpriv->ao_readback.
-   However, since this driver supports simultaneous xfer then sometimes
-   this function actually accomplishes work.
-
-   Simultaneaous xfer mode is accomplished by loading ALL the values
-   you want for AO in all the channels, then READing off one of the AO
-   registers to initiate the instantaneous simultaneous update of all
-   DAC outputs, which makes all AO channels update simultaneously.
-   This is useful for some control applications, I would imagine.
-*/
-static int ao_rinsn(struct comedi_device *dev, struct comedi_subdevice *s,
-		    struct comedi_insn *insn, unsigned int *data)
-{
-	int i;
-	int chan = CR_CHAN(insn->chanspec);
-
-	for (i = 0; i < insn->n; i++) {
-		if (devpriv->simultaneous_xfer_mode)
-			inb(LSB_PORT(chan));
-		/* read back shadow register */
-		data[i] = devpriv->ao_readback[chan];
-	}
+static const struct pcmda12_board pcmda12_boards[] = {
+	{
+		.name	= "pcmda12",
+	},
+};
 
-	return i;
-}
+static struct comedi_driver driver = {
+	.driver_name	= "pcmda12",
+	.module		= THIS_MODULE,
+	.attach		= pcmda12_attach,
+	.detach		= pcmda12_detach,
+	.board_name	= &pcmda12_boards[0].name,
+	.offset		= sizeof(struct pcmda12_board),
+	.num_names	= ARRAY_SIZE(pcmda12_boards),
+};
 
-/*
- * A convenient macro that defines init_module() and cleanup_module(),
- * as necessary.
- */
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
