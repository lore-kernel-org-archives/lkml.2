Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754193Ab2D0WSg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 18:18:36 -0400
Received: from mail209.messagelabs.com ([216.82.255.3]:27665 "EHLO
	mail209.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752207Ab2D0WSf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 18:18:35 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-15.tower-209.messagelabs.com!1335565107!4277597!17
X-Originating-IP: [216.166.12.31]
X-StarScan-Version: 6.5.7; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] staging: comedi: refactor poc driver to remove forward declarations
Date: Fri, 27 Apr 2012 15:18:23 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201204271518.23797.hartleys@visionengravers.com>
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

diff --git a/drivers/staging/comedi/drivers/poc.c b/drivers/staging/comedi/drivers/poc.c
index 831a576..e3690bb 100644
--- a/drivers/staging/comedi/drivers/poc.c
+++ b/drivers/staging/comedi/drivers/poc.c
@@ -41,20 +41,6 @@ Configuration options:
 
 #include <linux/ioport.h>
 
-static int poc_attach(struct comedi_device *dev, struct comedi_devconfig *it);
-static int poc_detach(struct comedi_device *dev);
-static int readback_insn(struct comedi_device *dev, struct comedi_subdevice *s,
-			 struct comedi_insn *insn, unsigned int *data);
-
-static int dac02_ao_winsn(struct comedi_device *dev, struct comedi_subdevice *s,
-			  struct comedi_insn *insn, unsigned int *data);
-static int pcl733_insn_bits(struct comedi_device *dev,
-			    struct comedi_subdevice *s,
-			    struct comedi_insn *insn, unsigned int *data);
-static int pcl734_insn_bits(struct comedi_device *dev,
-			    struct comedi_subdevice *s,
-			    struct comedi_insn *insn, unsigned int *data);
-
 struct boarddef_struct {
 	const char *name;
 	unsigned int iosize;
@@ -70,108 +56,9 @@ struct boarddef_struct {
 			 struct comedi_insn *, unsigned int *);
 	const struct comedi_lrange *range;
 };
-static const struct boarddef_struct boards[] = {
-	{
-	 .name = "dac02",
-	 .iosize = 8,
-	 /*      .setup = dac02_setup, */
-	 .type = COMEDI_SUBD_AO,
-	 .n_chan = 2,
-	 .n_bits = 12,
-	 .winsn = dac02_ao_winsn,
-	 .rinsn = readback_insn,
-	 .range = &range_unknown,
-	 },
-	{
-	 .name = "pcl733",
-	 .iosize = 4,
-	 .type = COMEDI_SUBD_DI,
-	 .n_chan = 32,
-	 .n_bits = 1,
-	 .insnbits = pcl733_insn_bits,
-	 .range = &range_digital,
-	 },
-	{
-	 .name = "pcl734",
-	 .iosize = 4,
-	 .type = COMEDI_SUBD_DO,
-	 .n_chan = 32,
-	 .n_bits = 1,
-	 .insnbits = pcl734_insn_bits,
-	 .range = &range_digital,
-	 },
-};
 
-#define n_boards ARRAY_SIZE(boards)
 #define this_board ((const struct boarddef_struct *)dev->board_ptr)
 
-static struct comedi_driver driver_poc = {
-	.driver_name = "poc",
-	.module = THIS_MODULE,
-	.attach = poc_attach,
-	.detach = poc_detach,
-	.board_name = &boards[0].name,
-	.num_names = n_boards,
-	.offset = sizeof(boards[0]),
-};
-
-static int poc_attach(struct comedi_device *dev, struct comedi_devconfig *it)
-{
-	struct comedi_subdevice *s;
-	unsigned long iobase;
-	unsigned int iosize;
-
-	iobase = it->options[0];
-	printk(KERN_INFO "comedi%d: poc: using %s iobase 0x%lx\n", dev->minor,
-	       this_board->name, iobase);
-
-	dev->board_name = this_board->name;
-
-	if (iobase == 0) {
-		printk(KERN_ERR "io base address required\n");
-		return -EINVAL;
-	}
-
-	iosize = this_board->iosize;
-	/* check if io addresses are available */
-	if (!request_region(iobase, iosize, "dac02")) {
-		printk(KERN_ERR "I/O port conflict: failed to allocate ports "
-			"0x%lx to 0x%lx\n", iobase, iobase + iosize - 1);
-		return -EIO;
-	}
-	dev->iobase = iobase;
-
-	if (alloc_subdevices(dev, 1) < 0)
-		return -ENOMEM;
-	if (alloc_private(dev, sizeof(unsigned int) * this_board->n_chan) < 0)
-		return -ENOMEM;
-
-	/* analog output subdevice */
-	s = dev->subdevices + 0;
-	s->type = this_board->type;
-	s->n_chan = this_board->n_chan;
-	s->maxdata = (1 << this_board->n_bits) - 1;
-	s->range_table = this_board->range;
-	s->insn_write = this_board->winsn;
-	s->insn_read = this_board->rinsn;
-	s->insn_bits = this_board->insnbits;
-	if (s->type == COMEDI_SUBD_AO || s->type == COMEDI_SUBD_DO)
-		s->subdev_flags = SDF_WRITABLE;
-
-	return 0;
-}
-
-static int poc_detach(struct comedi_device *dev)
-{
-	/* only free stuff if it has been allocated by _attach */
-	if (dev->iobase)
-		release_region(dev->iobase, this_board->iosize);
-
-	printk(KERN_INFO "comedi%d: dac02: remove\n", dev->minor);
-
-	return 0;
-}
-
 static int readback_insn(struct comedi_device *dev, struct comedi_subdevice *s,
 			 struct comedi_insn *insn, unsigned int *data)
 {
@@ -248,17 +135,113 @@ static int pcl734_insn_bits(struct comedi_device *dev,
 	return 2;
 }
 
+static int poc_attach(struct comedi_device *dev, struct comedi_devconfig *it)
+{
+	struct comedi_subdevice *s;
+	unsigned long iobase;
+	unsigned int iosize;
+
+	iobase = it->options[0];
+	printk(KERN_INFO "comedi%d: poc: using %s iobase 0x%lx\n", dev->minor,
+	       this_board->name, iobase);
+
+	dev->board_name = this_board->name;
+
+	if (iobase == 0) {
+		printk(KERN_ERR "io base address required\n");
+		return -EINVAL;
+	}
+
+	iosize = this_board->iosize;
+	/* check if io addresses are available */
+	if (!request_region(iobase, iosize, "dac02")) {
+		printk(KERN_ERR "I/O port conflict: failed to allocate ports "
+			"0x%lx to 0x%lx\n", iobase, iobase + iosize - 1);
+		return -EIO;
+	}
+	dev->iobase = iobase;
+
+	if (alloc_subdevices(dev, 1) < 0)
+		return -ENOMEM;
+	if (alloc_private(dev, sizeof(unsigned int) * this_board->n_chan) < 0)
+		return -ENOMEM;
+
+	/* analog output subdevice */
+	s = dev->subdevices + 0;
+	s->type = this_board->type;
+	s->n_chan = this_board->n_chan;
+	s->maxdata = (1 << this_board->n_bits) - 1;
+	s->range_table = this_board->range;
+	s->insn_write = this_board->winsn;
+	s->insn_read = this_board->rinsn;
+	s->insn_bits = this_board->insnbits;
+	if (s->type == COMEDI_SUBD_AO || s->type == COMEDI_SUBD_DO)
+		s->subdev_flags = SDF_WRITABLE;
+
+	return 0;
+}
+
+static int poc_detach(struct comedi_device *dev)
+{
+	/* only free stuff if it has been allocated by _attach */
+	if (dev->iobase)
+		release_region(dev->iobase, this_board->iosize);
+
+	printk(KERN_INFO "comedi%d: dac02: remove\n", dev->minor);
+
+	return 0;
+}
+
+static const struct boarddef_struct boards[] = {
+	{
+		.name		= "dac02",
+		.iosize		= 8,
+		/* .setup	= dac02_setup, */
+		.type		= COMEDI_SUBD_AO,
+		.n_chan		= 2,
+		.n_bits		= 12,
+		.winsn		= dac02_ao_winsn,
+		.rinsn		= readback_insn,
+		.range		= &range_unknown,
+	}, {
+		.name		= "pcl733",
+		.iosize		= 4,
+		.type		= COMEDI_SUBD_DI,
+		.n_chan		= 32,
+		.n_bits		= 1,
+		.insnbits	= pcl733_insn_bits,
+		.range		= &range_digital,
+	}, {
+		.name		= "pcl734",
+		.iosize		= 4,
+		.type		= COMEDI_SUBD_DO,
+		.n_chan		= 32,
+		.n_bits		= 1,
+		.insnbits	= pcl734_insn_bits,
+		.range		= &range_digital,
+	},
+};
+
+static struct comedi_driver driver_poc = {
+	.driver_name	= "poc",
+	.module		= THIS_MODULE,
+	.attach		= poc_attach,
+	.detach		= poc_detach,
+	.board_name	= &boards[0].name,
+	.num_names	= ARRAY_SIZE(boards),
+	.offset		= sizeof(boards[0]),
+};
+
 static int __init driver_poc_init_module(void)
 {
 	return comedi_driver_register(&driver_poc);
 }
+module_init(driver_poc_init_module);
 
 static void __exit driver_poc_cleanup_module(void)
 {
 	comedi_driver_unregister(&driver_poc);
 }
-
-module_init(driver_poc_init_module);
 module_exit(driver_poc_cleanup_module);
 
 MODULE_AUTHOR("Comedi http://www.comedi.org");
