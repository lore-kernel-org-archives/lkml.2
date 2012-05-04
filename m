Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759685Ab2EDV1P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 17:27:15 -0400
Received: from mail131.messagelabs.com ([216.82.242.99]:29987 "EHLO
	mail131.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755957Ab2EDV1O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 17:27:14 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-15.tower-131.messagelabs.com!1336166825!21388593!3
X-Originating-IP: [216.166.12.99]
X-StarScan-Version: 6.5.7; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] staging: comedi: refactor ssv_dnp driver and use module_comedi_driver
Date: Fri, 4 May 2012 14:26:56 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201205041426.56419.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the module_init/module_exit routines and the associated
struct comedi_driver and other variables to the end of the source.
This is more typical of how other drivers are written and removes
the need for the forward declarations.

Convert the driver to use the module_comedi_driver() macro which
makes the code smaller and a bit simpler.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---

diff --git a/drivers/staging/comedi/drivers/ssv_dnp.c b/drivers/staging/comedi/drivers/ssv_dnp.c
index 526de2e..25cb659 100644
--- a/drivers/staging/comedi/drivers/ssv_dnp.c
+++ b/drivers/staging/comedi/drivers/ssv_dnp.c
@@ -59,16 +59,6 @@ struct dnp_board {
 	int have_dio;
 };
 
-/* We only support one DNP 'board' variant at the moment */
-static const struct dnp_board dnp_boards[] = {
-{
-	 .name = "dnp-1486",
-	 .ai_chans = 16,
-	 .ai_bits = 12,
-	 .have_dio = 1,
-	 },
-};
-
 /* Useful for shorthand access to the particular board structure ----------- */
 #define thisboard ((const struct dnp_board *)dev->board_ptr)
 
@@ -81,136 +71,6 @@ struct dnp_private_data {
 #define devpriv ((dnp_private *)dev->private)
 
 /* ------------------------------------------------------------------------- */
-/* The struct comedi_driver structure tells the Comedi core module which     */
-/* functions to call to configure/deconfigure (attach/detach) the board, and */
-/* also about the kernel module that contains the device code.               */
-/*                                                                           */
-/* In the following section we define the API of this driver.                */
-/* ------------------------------------------------------------------------- */
-
-static int dnp_attach(struct comedi_device *dev, struct comedi_devconfig *it);
-static int dnp_detach(struct comedi_device *dev);
-
-static struct comedi_driver driver_dnp = {
-	.driver_name = "ssv_dnp",
-	.module = THIS_MODULE,
-	.attach = dnp_attach,
-	.detach = dnp_detach,
-	.board_name = &dnp_boards[0].name,
-	/* only necessary for non-PnP devs   */
-	.offset = sizeof(struct dnp_board),   /* like ISA-PnP, PCI or PCMCIA */
-	.num_names = ARRAY_SIZE(dnp_boards),
-};
-
-static int __init driver_dnp_init_module(void)
-{
-	return comedi_driver_register(&driver_dnp);
-}
-
-static void __exit driver_dnp_cleanup_module(void)
-{
-	comedi_driver_unregister(&driver_dnp);
-}
-
-module_init(driver_dnp_init_module);
-module_exit(driver_dnp_cleanup_module);
-
-static int dnp_dio_insn_bits(struct comedi_device *dev,
-			     struct comedi_subdevice *s,
-			     struct comedi_insn *insn, unsigned int *data);
-
-static int dnp_dio_insn_config(struct comedi_device *dev,
-			       struct comedi_subdevice *s,
-			       struct comedi_insn *insn, unsigned int *data);
-
-/* ------------------------------------------------------------------------- */
-/* Attach is called by comedi core to configure the driver for a particular  */
-/* board. If you specified a board_name array in the driver structure,       */
-/* dev->board_ptr contains that address.                                     */
-/* ------------------------------------------------------------------------- */
-
-static int dnp_attach(struct comedi_device *dev, struct comedi_devconfig *it)
-{
-
-	struct comedi_subdevice *s;
-
-	printk(KERN_INFO "comedi%d: dnp: ", dev->minor);
-
-	/* Autoprobing: this should find out which board we have. Currently  */
-	/* only the 1486 board is supported and autoprobing is not           */
-	/* implemented :-)                                                   */
-	/* dev->board_ptr = dnp_probe(dev); */
-
-	/* Initialize the name of the board.                                 */
-	/* We can use the "thisboard" macro now.                             */
-	dev->board_name = thisboard->name;
-
-	/* Allocate the private structure area. alloc_private() is a         */
-	/* convenient macro defined in comedidev.h.                          */
-	if (alloc_private(dev, sizeof(struct dnp_private_data)) < 0)
-		return -ENOMEM;
-
-	/* Allocate the subdevice structures. alloc_subdevice() is a         */
-	/* convenient macro defined in comedidev.h.                          */
-
-	if (alloc_subdevices(dev, 1) < 0)
-		return -ENOMEM;
-
-	s = dev->subdevices + 0;
-	/* digital i/o subdevice                                             */
-	s->type = COMEDI_SUBD_DIO;
-	s->subdev_flags = SDF_READABLE | SDF_WRITABLE;
-	s->n_chan = 20;
-	s->maxdata = 1;
-	s->range_table = &range_digital;
-	s->insn_bits = dnp_dio_insn_bits;
-	s->insn_config = dnp_dio_insn_config;
-
-	printk("attached\n");
-
-	/* We use the I/O ports 0x22,0x23 and 0xa3-0xa9, which are always
-	 * allocated for the primary 8259, so we don't need to allocate them
-	 * ourselves. */
-
-	/* configure all ports as input (default)                            */
-	outb(PAMR, CSCIR);
-	outb(0x00, CSCDR);
-	outb(PBMR, CSCIR);
-	outb(0x00, CSCDR);
-	outb(PCMR, CSCIR);
-	outb((inb(CSCDR) & 0xAA), CSCDR);
-
-	return 1;
-
-}
-
-/* ------------------------------------------------------------------------- */
-/* detach is called to deconfigure a device. It should deallocate the        */
-/* resources. This function is also called when _attach() fails, so it       */
-/* should be careful not to release resources that were not necessarily      */
-/* allocated by _attach(). dev->private and dev->subdevices are              */
-/* deallocated automatically by the core.                                    */
-/* ------------------------------------------------------------------------- */
-
-static int dnp_detach(struct comedi_device *dev)
-{
-
-	/* configure all ports as input (default)                            */
-	outb(PAMR, CSCIR);
-	outb(0x00, CSCDR);
-	outb(PBMR, CSCIR);
-	outb(0x00, CSCDR);
-	outb(PCMR, CSCIR);
-	outb((inb(CSCDR) & 0xAA), CSCDR);
-
-	/* announce that we are finished                                     */
-	printk(KERN_INFO "comedi%d: dnp: remove\n", dev->minor);
-
-	return 0;
-
-}
-
-/* ------------------------------------------------------------------------- */
 /* The insn_bits interface allows packed reading/writing of DIO channels.    */
 /* The comedi core can convert between insn_bits and insn_read/write, so you */
 /* are able to use these instructions as well.                               */
@@ -326,6 +186,95 @@ static int dnp_dio_insn_config(struct comedi_device *dev,
 
 }
 
+static int dnp_attach(struct comedi_device *dev, struct comedi_devconfig *it)
+{
+	struct comedi_subdevice *s;
+
+	printk(KERN_INFO "comedi%d: dnp: ", dev->minor);
+
+	/* Autoprobing: this should find out which board we have. Currently  */
+	/* only the 1486 board is supported and autoprobing is not           */
+	/* implemented :-)                                                   */
+	/* dev->board_ptr = dnp_probe(dev); */
+
+	/* Initialize the name of the board.                                 */
+	/* We can use the "thisboard" macro now.                             */
+	dev->board_name = thisboard->name;
+
+	/* Allocate the private structure area. alloc_private() is a         */
+	/* convenient macro defined in comedidev.h.                          */
+	if (alloc_private(dev, sizeof(struct dnp_private_data)) < 0)
+		return -ENOMEM;
+
+	/* Allocate the subdevice structures. alloc_subdevice() is a         */
+	/* convenient macro defined in comedidev.h.                          */
+
+	if (alloc_subdevices(dev, 1) < 0)
+		return -ENOMEM;
+
+	s = dev->subdevices + 0;
+	/* digital i/o subdevice                                             */
+	s->type = COMEDI_SUBD_DIO;
+	s->subdev_flags = SDF_READABLE | SDF_WRITABLE;
+	s->n_chan = 20;
+	s->maxdata = 1;
+	s->range_table = &range_digital;
+	s->insn_bits = dnp_dio_insn_bits;
+	s->insn_config = dnp_dio_insn_config;
+
+	printk("attached\n");
+
+	/* We use the I/O ports 0x22,0x23 and 0xa3-0xa9, which are always
+	 * allocated for the primary 8259, so we don't need to allocate them
+	 * ourselves. */
+
+	/* configure all ports as input (default)                            */
+	outb(PAMR, CSCIR);
+	outb(0x00, CSCDR);
+	outb(PBMR, CSCIR);
+	outb(0x00, CSCDR);
+	outb(PCMR, CSCIR);
+	outb((inb(CSCDR) & 0xAA), CSCDR);
+
+	return 1;
+}
+
+static int dnp_detach(struct comedi_device *dev)
+{
+	/* configure all ports as input (default)                            */
+	outb(PAMR, CSCIR);
+	outb(0x00, CSCDR);
+	outb(PBMR, CSCIR);
+	outb(0x00, CSCDR);
+	outb(PCMR, CSCIR);
+	outb((inb(CSCDR) & 0xAA), CSCDR);
+
+	/* announce that we are finished                                     */
+	printk(KERN_INFO "comedi%d: dnp: remove\n", dev->minor);
+
+	return 0;
+}
+
+static const struct dnp_board dnp_boards[] = {
+	{
+		.name		= "dnp-1486",
+		.ai_chans	= 16,
+		.ai_bits	= 12,
+		.have_dio	= 1,
+	},
+};
+
+static struct comedi_driver dnp_driver = {
+	.driver_name	= "ssv_dnp",
+	.module		= THIS_MODULE,
+	.attach		= dnp_attach,
+	.detach		= dnp_detach,
+	.board_name	= &dnp_boards[0].name,
+	.offset		= sizeof(struct dnp_board),
+	.num_names	= ARRAY_SIZE(dnp_boards),
+};
+module_comedi_driver(dnp_driver);
+
 MODULE_AUTHOR("Comedi http://www.comedi.org");
 MODULE_DESCRIPTION("Comedi low-level driver");
 MODULE_LICENSE("GPL");
