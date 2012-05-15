Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966047Ab2EOWUO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 18:20:14 -0400
Received: from mail160.messagelabs.com ([216.82.253.99]:56026 "EHLO
	mail160.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965655Ab2EOWUL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 18:20:11 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-11.tower-160.messagelabs.com!1337120404!5036945!6
X-Originating-IP: [216.166.12.72]
X-StarScan-Version: 6.5.7; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] staging: comedi: refactor comedi_bond driver and use module_comedi_driver
Date: Tue, 15 May 2012 15:20:02 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201205151520.03222.hartleys@visionengravers.com>
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

 drivers/staging/comedi/drivers/comedi_bond.c |  213 +++++++++-----------------
 1 files changed, 73 insertions(+), 140 deletions(-)

diff --git a/drivers/staging/comedi/drivers/comedi_bond.c b/drivers/staging/comedi/drivers/comedi_bond.c
index d8aefb2..4507bab 100644
--- a/drivers/staging/comedi/drivers/comedi_bond.c
+++ b/drivers/staging/comedi/drivers/comedi_bond.c
@@ -60,7 +60,6 @@ Configuration Options:
 #define MAX_CHANS 256
 
 #define MODULE_NAME "comedi_bond"
-MODULE_LICENSE("GPL");
 #ifndef STR
 #  define STR1(x) #x
 #  define STR(x) STR1(x)
@@ -79,10 +78,6 @@ MODULE_PARM_DESC(debug, "If true, print extra cryptic debugging output useful"
 	} while (0)
 #define WARNING(x...)  printk(KERN_WARNING MODULE_NAME ": WARNING: "x)
 #define ERROR(x...)  printk(KERN_ERR MODULE_NAME ": INTERNAL ERROR: "x)
-MODULE_AUTHOR("Calin A. Culianu");
-MODULE_DESCRIPTION(MODULE_NAME "A driver for COMEDI to bond multiple COMEDI "
-		   "devices together as one.  In the words of John Lennon: "
-		   "'And the world will live as one...'");
 
 /*
  * Board descriptions for two imaginary boards.  Describing the
@@ -93,12 +88,6 @@ struct BondingBoard {
 	const char *name;
 };
 
-static const struct BondingBoard bondingBoards[] = {
-	{
-	 .name = MODULE_NAME,
-	 },
-};
-
 /*
  * Useful for shorthand access to the particular board structure
  */
@@ -133,129 +122,6 @@ struct Private {
  */
 #define devpriv ((struct Private *)dev->private)
 
-/*
- * The struct comedi_driver structure tells the Comedi core module
- * which functions to call to configure/deconfigure (attach/detach)
- * the board, and also about the kernel module that contains
- * the device code.
- */
-static int bonding_attach(struct comedi_device *dev,
-			  struct comedi_devconfig *it);
-static int bonding_detach(struct comedi_device *dev);
-/** Build Private array of all devices.. */
-static int doDevConfig(struct comedi_device *dev, struct comedi_devconfig *it);
-static void doDevUnconfig(struct comedi_device *dev);
-/* Ugly implementation of realloc that always copies memory around -- I'm lazy,
- * what can I say?  I like to do wasteful memcopies.. :) */
-static void *Realloc(const void *ptr, size_t len, size_t old_len);
-
-static struct comedi_driver driver_bonding = {
-	.driver_name = MODULE_NAME,
-	.module = THIS_MODULE,
-	.attach = bonding_attach,
-	.detach = bonding_detach,
-	/* It is not necessary to implement the following members if you are
-	 * writing a driver for a ISA PnP or PCI card */
-	/* Most drivers will support multiple types of boards by
-	 * having an array of board structures.  These were defined
-	 * in skel_boards[] above.  Note that the element 'name'
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
-	.board_name = &bondingBoards[0].name,
-	.offset = sizeof(struct BondingBoard),
-	.num_names = ARRAY_SIZE(bondingBoards),
-};
-
-static int bonding_dio_insn_bits(struct comedi_device *dev,
-				 struct comedi_subdevice *s,
-				 struct comedi_insn *insn, unsigned int *data);
-static int bonding_dio_insn_config(struct comedi_device *dev,
-				   struct comedi_subdevice *s,
-				   struct comedi_insn *insn,
-				   unsigned int *data);
-
-/*
- * Attach is called by the Comedi core to configure the driver
- * for a particular board.  If you specified a board_name array
- * in the driver structure, dev->board_ptr contains that
- * address.
- */
-static int bonding_attach(struct comedi_device *dev,
-			  struct comedi_devconfig *it)
-{
-	struct comedi_subdevice *s;
-
-	LOG_MSG("comedi%d\n", dev->minor);
-
-	/*
-	 * Allocate the private structure area.  alloc_private() is a
-	 * convenient macro defined in comedidev.h.
-	 */
-	if (alloc_private(dev, sizeof(struct Private)) < 0)
-		return -ENOMEM;
-
-	/*
-	 * Setup our bonding from config params.. sets up our Private struct..
-	 */
-	if (!doDevConfig(dev, it))
-		return -EINVAL;
-
-	/*
-	 * Initialize dev->board_name.  Note that we can use the "thisboard"
-	 * macro now, since we just initialized it in the last line.
-	 */
-	dev->board_name = devpriv->name;
-
-	/*
-	 * Allocate the subdevice structures.  alloc_subdevice() is a
-	 * convenient macro defined in comedidev.h.
-	 */
-	if (alloc_subdevices(dev, 1) < 0)
-		return -ENOMEM;
-
-	s = dev->subdevices + 0;
-	s->type = COMEDI_SUBD_DIO;
-	s->subdev_flags = SDF_READABLE | SDF_WRITABLE;
-	s->n_chan = devpriv->nchans;
-	s->maxdata = 1;
-	s->range_table = &range_digital;
-	s->insn_bits = bonding_dio_insn_bits;
-	s->insn_config = bonding_dio_insn_config;
-
-	LOG_MSG("attached with %u DIO channels coming from %u different "
-		"subdevices all bonded together.  "
-		"John Lennon would be proud!\n",
-		devpriv->nchans, devpriv->ndevs);
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
-static int bonding_detach(struct comedi_device *dev)
-{
-	LOG_MSG("comedi%d: remove\n", dev->minor);
-	doDevUnconfig(dev);
-	return 0;
-}
-
 /* DIO devices are slightly special.  Although it is possible to
  * implement the insn_read/insn_write interface, it is much more
  * useful to applications if you implement the insn_bits interface.
@@ -490,15 +356,82 @@ static void doDevUnconfig(struct comedi_device *dev)
 	}
 }
 
-static int __init init(void)
+static int bonding_attach(struct comedi_device *dev,
+			  struct comedi_devconfig *it)
 {
-	return comedi_driver_register(&driver_bonding);
+	struct comedi_subdevice *s;
+
+	LOG_MSG("comedi%d\n", dev->minor);
+
+	/*
+	 * Allocate the private structure area.  alloc_private() is a
+	 * convenient macro defined in comedidev.h.
+	 */
+	if (alloc_private(dev, sizeof(struct Private)) < 0)
+		return -ENOMEM;
+
+	/*
+	 * Setup our bonding from config params.. sets up our Private struct..
+	 */
+	if (!doDevConfig(dev, it))
+		return -EINVAL;
+
+	/*
+	 * Initialize dev->board_name.  Note that we can use the "thisboard"
+	 * macro now, since we just initialized it in the last line.
+	 */
+	dev->board_name = devpriv->name;
+
+	/*
+	 * Allocate the subdevice structures.  alloc_subdevice() is a
+	 * convenient macro defined in comedidev.h.
+	 */
+	if (alloc_subdevices(dev, 1) < 0)
+		return -ENOMEM;
+
+	s = dev->subdevices + 0;
+	s->type = COMEDI_SUBD_DIO;
+	s->subdev_flags = SDF_READABLE | SDF_WRITABLE;
+	s->n_chan = devpriv->nchans;
+	s->maxdata = 1;
+	s->range_table = &range_digital;
+	s->insn_bits = bonding_dio_insn_bits;
+	s->insn_config = bonding_dio_insn_config;
+
+	LOG_MSG("attached with %u DIO channels coming from %u different "
+		"subdevices all bonded together.  "
+		"John Lennon would be proud!\n",
+		devpriv->nchans, devpriv->ndevs);
+
+	return 1;
 }
 
-static void __exit cleanup(void)
+static int bonding_detach(struct comedi_device *dev)
 {
-	comedi_driver_unregister(&driver_bonding);
+	LOG_MSG("comedi%d: remove\n", dev->minor);
+	doDevUnconfig(dev);
+	return 0;
 }
 
-module_init(init);
-module_exit(cleanup);
+static const struct BondingBoard bondingBoards[] = {
+	{
+		.name		= "comedi_bond",
+	},
+};
+
+static struct comedi_driver bonding_driver = {
+	.driver_name	= "comedi_bond",
+	.module		= THIS_MODULE,
+	.attach		= bonding_attach,
+	.detach		= bonding_detach,
+	.board_name	= &bondingBoards[0].name,
+	.offset		= sizeof(struct BondingBoard),
+	.num_names	= ARRAY_SIZE(bondingBoards),
+};
+module_comedi_driver(bonding_driver);
+
+MODULE_AUTHOR("Calin A. Culianu");
+MODULE_DESCRIPTION(MODULE_NAME "A driver for COMEDI to bond multiple COMEDI "
+		   "devices together as one.  In the words of John Lennon: "
+		   "'And the world will live as one...'");
+MODULE_LICENSE("GPL");
