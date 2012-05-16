Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967136Ab2EPAWL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 20:22:11 -0400
Received: from mail131.messagelabs.com ([216.82.242.99]:61408 "EHLO
	mail131.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966737Ab2EPAWJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 20:22:09 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-6.tower-131.messagelabs.com!1337127727!12714038!1
X-Originating-IP: [216.166.12.97]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] staging: comedi: refactor ni_at_ao driver and use module_comedi_driver
Date: Tue, 15 May 2012 17:22:02 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201205151722.02647.hartleys@visionengravers.com>
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

 drivers/staging/comedi/drivers/ni_at_ao.c |  242 ++++++++++++----------------
 1 files changed, 104 insertions(+), 138 deletions(-)

diff --git a/drivers/staging/comedi/drivers/ni_at_ao.c b/drivers/staging/comedi/drivers/ni_at_ao.c
index 138dcc2..d7963ba 100644
--- a/drivers/staging/comedi/drivers/ni_at_ao.c
+++ b/drivers/staging/comedi/drivers/ni_at_ao.c
@@ -157,17 +157,6 @@ struct atao_board {
 	int n_ao_chans;
 };
 
-static const struct atao_board atao_boards[] = {
-	{
-	 .name = "ai-ao-6",
-	 .n_ao_chans = 6,
-	 },
-	{
-	 .name = "ai-ao-10",
-	 .n_ao_chans = 10,
-	 },
-};
-
 #define thisboard ((struct atao_board *)dev->board_ptr)
 
 struct atao_private {
@@ -182,133 +171,6 @@ struct atao_private {
 
 #define devpriv ((struct atao_private *)dev->private)
 
-static int atao_attach(struct comedi_device *dev, struct comedi_devconfig *it);
-static int atao_detach(struct comedi_device *dev);
-static struct comedi_driver driver_atao = {
-	.driver_name = "ni_at_ao",
-	.module = THIS_MODULE,
-	.attach = atao_attach,
-	.detach = atao_detach,
-	.board_name = &atao_boards[0].name,
-	.offset = sizeof(struct atao_board),
-	.num_names = ARRAY_SIZE(atao_boards),
-};
-
-static int __init driver_atao_init_module(void)
-{
-	return comedi_driver_register(&driver_atao);
-}
-
-static void __exit driver_atao_cleanup_module(void)
-{
-	comedi_driver_unregister(&driver_atao);
-}
-
-module_init(driver_atao_init_module);
-module_exit(driver_atao_cleanup_module);
-
-static void atao_reset(struct comedi_device *dev);
-
-static int atao_ao_winsn(struct comedi_device *dev, struct comedi_subdevice *s,
-			 struct comedi_insn *insn, unsigned int *data);
-static int atao_ao_rinsn(struct comedi_device *dev, struct comedi_subdevice *s,
-			 struct comedi_insn *insn, unsigned int *data);
-static int atao_dio_insn_bits(struct comedi_device *dev,
-			      struct comedi_subdevice *s,
-			      struct comedi_insn *insn, unsigned int *data);
-static int atao_dio_insn_config(struct comedi_device *dev,
-				struct comedi_subdevice *s,
-				struct comedi_insn *insn, unsigned int *data);
-static int atao_calib_insn_read(struct comedi_device *dev,
-				struct comedi_subdevice *s,
-				struct comedi_insn *insn, unsigned int *data);
-static int atao_calib_insn_write(struct comedi_device *dev,
-				 struct comedi_subdevice *s,
-				 struct comedi_insn *insn, unsigned int *data);
-
-static int atao_attach(struct comedi_device *dev, struct comedi_devconfig *it)
-{
-	struct comedi_subdevice *s;
-	unsigned long iobase;
-	int ao_unipolar;
-
-	iobase = it->options[0];
-	if (iobase == 0)
-		iobase = 0x1c0;
-	ao_unipolar = it->options[3];
-
-	printk(KERN_INFO "comedi%d: ni_at_ao: 0x%04lx", dev->minor, iobase);
-
-	if (!request_region(iobase, ATAO_SIZE, "ni_at_ao")) {
-		printk(" I/O port conflict\n");
-		return -EIO;
-	}
-	dev->iobase = iobase;
-
-	/* dev->board_ptr = atao_probe(dev); */
-
-	dev->board_name = thisboard->name;
-
-	if (alloc_private(dev, sizeof(struct atao_private)) < 0)
-		return -ENOMEM;
-
-	if (alloc_subdevices(dev, 4) < 0)
-		return -ENOMEM;
-
-	s = dev->subdevices + 0;
-	/* analog output subdevice */
-	s->type = COMEDI_SUBD_AO;
-	s->subdev_flags = SDF_WRITABLE;
-	s->n_chan = thisboard->n_ao_chans;
-	s->maxdata = (1 << 12) - 1;
-	if (ao_unipolar)
-		s->range_table = &range_unipolar10;
-	else
-		s->range_table = &range_bipolar10;
-	s->insn_write = &atao_ao_winsn;
-	s->insn_read = &atao_ao_rinsn;
-
-	s = dev->subdevices + 1;
-	/* digital i/o subdevice */
-	s->type = COMEDI_SUBD_DIO;
-	s->subdev_flags = SDF_READABLE | SDF_WRITABLE;
-	s->n_chan = 8;
-	s->maxdata = 1;
-	s->range_table = &range_digital;
-	s->insn_bits = atao_dio_insn_bits;
-	s->insn_config = atao_dio_insn_config;
-
-	s = dev->subdevices + 2;
-	/* caldac subdevice */
-	s->type = COMEDI_SUBD_CALIB;
-	s->subdev_flags = SDF_WRITABLE | SDF_INTERNAL;
-	s->n_chan = 21;
-	s->maxdata = 0xff;
-	s->insn_read = atao_calib_insn_read;
-	s->insn_write = atao_calib_insn_write;
-
-	s = dev->subdevices + 3;
-	/* eeprom subdevice */
-	/* s->type=COMEDI_SUBD_EEPROM; */
-	s->type = COMEDI_SUBD_UNUSED;
-
-	atao_reset(dev);
-
-	printk(KERN_INFO "\n");
-
-	return 0;
-}
-
-static int atao_detach(struct comedi_device *dev)
-{
-	printk(KERN_INFO "comedi%d: atao: remove\n", dev->minor);
-
-	if (dev->iobase)
-		release_region(dev->iobase, ATAO_SIZE);
-
-	return 0;
-}
-
 static void atao_reset(struct comedi_device *dev)
 {
 	/* This is the reset sequence described in the manual */
@@ -471,6 +333,110 @@ static int atao_calib_insn_write(struct comedi_device *dev,
 	return insn->n;
 }
 
+static int atao_attach(struct comedi_device *dev, struct comedi_devconfig *it)
+{
+	struct comedi_subdevice *s;
+	unsigned long iobase;
+	int ao_unipolar;
+
+	iobase = it->options[0];
+	if (iobase == 0)
+		iobase = 0x1c0;
+	ao_unipolar = it->options[3];
+
+	printk(KERN_INFO "comedi%d: ni_at_ao: 0x%04lx", dev->minor, iobase);
+
+	if (!request_region(iobase, ATAO_SIZE, "ni_at_ao")) {
+		printk(" I/O port conflict\n");
+		return -EIO;
+	}
+	dev->iobase = iobase;
+
+	/* dev->board_ptr = atao_probe(dev); */
+
+	dev->board_name = thisboard->name;
+
+	if (alloc_private(dev, sizeof(struct atao_private)) < 0)
+		return -ENOMEM;
+
+	if (alloc_subdevices(dev, 4) < 0)
+		return -ENOMEM;
+
+	s = dev->subdevices + 0;
+	/* analog output subdevice */
+	s->type = COMEDI_SUBD_AO;
+	s->subdev_flags = SDF_WRITABLE;
+	s->n_chan = thisboard->n_ao_chans;
+	s->maxdata = (1 << 12) - 1;
+	if (ao_unipolar)
+		s->range_table = &range_unipolar10;
+	else
+		s->range_table = &range_bipolar10;
+	s->insn_write = &atao_ao_winsn;
+	s->insn_read = &atao_ao_rinsn;
+
+	s = dev->subdevices + 1;
+	/* digital i/o subdevice */
+	s->type = COMEDI_SUBD_DIO;
+	s->subdev_flags = SDF_READABLE | SDF_WRITABLE;
+	s->n_chan = 8;
+	s->maxdata = 1;
+	s->range_table = &range_digital;
+	s->insn_bits = atao_dio_insn_bits;
+	s->insn_config = atao_dio_insn_config;
+
+	s = dev->subdevices + 2;
+	/* caldac subdevice */
+	s->type = COMEDI_SUBD_CALIB;
+	s->subdev_flags = SDF_WRITABLE | SDF_INTERNAL;
+	s->n_chan = 21;
+	s->maxdata = 0xff;
+	s->insn_read = atao_calib_insn_read;
+	s->insn_write = atao_calib_insn_write;
+
+	s = dev->subdevices + 3;
+	/* eeprom subdevice */
+	/* s->type=COMEDI_SUBD_EEPROM; */
+	s->type = COMEDI_SUBD_UNUSED;
+
+	atao_reset(dev);
+
+	printk(KERN_INFO "\n");
+
+	return 0;
+}
+
+static int atao_detach(struct comedi_device *dev)
+{
+	printk(KERN_INFO "comedi%d: atao: remove\n", dev->minor);
+
+	if (dev->iobase)
+		release_region(dev->iobase, ATAO_SIZE);
+
+	return 0;
+}
+
+static const struct atao_board atao_boards[] = {
+	{
+		.name		= "ai-ao-6",
+		.n_ao_chans	= 6,
+	}, {
+		.name		= "ai-ao-10",
+		.n_ao_chans	= 10,
+	},
+};
+
+static struct comedi_driver ni_at_ao_driver = {
+	.driver_name	= "ni_at_ao",
+	.module		= THIS_MODULE,
+	.attach		= atao_attach,
+	.detach		= atao_detach,
+	.board_name	= &atao_boards[0].name,
+	.offset		= sizeof(struct atao_board),
+	.num_names	= ARRAY_SIZE(atao_boards),
+};
+module_comedi_driver(ni_at_ao_driver);
+
 MODULE_AUTHOR("Comedi http://www.comedi.org");
 MODULE_DESCRIPTION("Comedi low-level driver");
 MODULE_LICENSE("GPL");
