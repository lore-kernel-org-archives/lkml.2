Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966782Ab2EOUuO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 16:50:14 -0400
Received: from mail132.messagelabs.com ([216.82.242.115]:42645 "EHLO
	mail132.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932618Ab2EOUuN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 16:50:13 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-2.tower-132.messagelabs.com!1337115004!11698820!5
X-Originating-IP: [216.166.12.98]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] staging: comedi: refactor amplc_pci224 driver and use module_comedi_pci_driver
Date: Tue, 15 May 2012 13:50:01 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201205151350.01352.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the module_init/module_exit routines and the associated
struct comedi_drive and struct pci_driver to the end of the
source. This is more typical of how other drivers are written
and removes the need for the forward declarations.

Convert the driver to use the module_comedi_pci_driver() macro
which makes the code smaller and a bit simpler.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---

 drivers/staging/comedi/drivers/amplc_pci224.c |  131 +++++++-----------------
 1 files changed, 38 insertions(+), 93 deletions(-)

diff --git a/drivers/staging/comedi/drivers/amplc_pci224.c b/drivers/staging/comedi/drivers/amplc_pci224.c
index fe65338..8b515f3 100644
--- a/drivers/staging/comedi/drivers/amplc_pci224.c
+++ b/drivers/staging/comedi/drivers/amplc_pci224.c
@@ -380,18 +380,6 @@ static const struct pci224_board pci224_boards[] = {
 };
 
 /*
- * PCI driver table.
- */
-
-static DEFINE_PCI_DEVICE_TABLE(pci224_pci_table) = {
-	{ PCI_DEVICE(PCI_VENDOR_ID_AMPLICON, PCI_DEVICE_ID_AMPLICON_PCI224) },
-	{ PCI_DEVICE(PCI_VENDOR_ID_AMPLICON, PCI_DEVICE_ID_AMPLICON_PCI234) },
-	{0}
-};
-
-MODULE_DEVICE_TABLE(pci, pci224_pci_table);
-
-/*
  * Useful for shorthand access to the particular board structure
  */
 #define thisboard ((struct pci224_board *)dev->board_ptr)
@@ -422,68 +410,6 @@ struct pci224_private {
 #define devpriv ((struct pci224_private *)dev->private)
 
 /*
- * The struct comedi_driver structure tells the Comedi core module
- * which functions to call to configure/deconfigure (attach/detach)
- * the board, and also about the kernel module that contains
- * the device code.
- */
-static int pci224_attach(struct comedi_device *dev,
-			 struct comedi_devconfig *it);
-static int pci224_detach(struct comedi_device *dev);
-static int pci224_attach_pci(struct comedi_device *dev,
-			     struct pci_dev *pci_dev);
-static struct comedi_driver driver_amplc_pci224 = {
-	.driver_name = DRIVER_NAME,
-	.module = THIS_MODULE,
-	.attach = pci224_attach,
-	.detach = pci224_detach,
-	.attach_pci = pci224_attach_pci,
-	.board_name = &pci224_boards[0].name,
-	.offset = sizeof(struct pci224_board),
-	.num_names = ARRAY_SIZE(pci224_boards),
-};
-
-static int __devinit driver_amplc_pci224_pci_probe(struct pci_dev *dev,
-						   const struct pci_device_id
-						   *ent)
-{
-	return comedi_pci_auto_config(dev, &driver_amplc_pci224);
-}
-
-static void __devexit driver_amplc_pci224_pci_remove(struct pci_dev *dev)
-{
-	comedi_pci_auto_unconfig(dev);
-}
-
-static struct pci_driver driver_amplc_pci224_pci_driver = {
-	.id_table = pci224_pci_table,
-	.probe = &driver_amplc_pci224_pci_probe,
-	.remove = __devexit_p(&driver_amplc_pci224_pci_remove)
-};
-
-static int __init driver_amplc_pci224_init_module(void)
-{
-	int retval;
-
-	retval = comedi_driver_register(&driver_amplc_pci224);
-	if (retval < 0)
-		return retval;
-
-	driver_amplc_pci224_pci_driver.name =
-	    (char *)driver_amplc_pci224.driver_name;
-	return pci_register_driver(&driver_amplc_pci224_pci_driver);
-}
-
-static void __exit driver_amplc_pci224_cleanup_module(void)
-{
-	pci_unregister_driver(&driver_amplc_pci224_pci_driver);
-	comedi_driver_unregister(&driver_amplc_pci224);
-}
-
-module_init(driver_amplc_pci224_init_module);
-module_exit(driver_amplc_pci224_cleanup_module);
-
-/*
  * Called from the 'insn_write' function to perform a single write.
  */
 static void
@@ -1547,12 +1473,6 @@ static int pci224_attach_common(struct comedi_device *dev,
 	return 1;
 }
 
-/*
- * _attach is called by the Comedi core to configure the driver
- * for a particular board.  If you specified a board_name array
- * in the driver structure, dev->board_ptr contains that
- * address.
- */
 static int pci224_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 {
 	struct pci_dev *pci_dev;
@@ -1577,11 +1497,6 @@ static int pci224_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	return pci224_attach_common(dev, pci_dev, it->options);
 }
 
-/*
- * _attach_pci is called by comedi_pci_auto_config() in the Comedi core
- * to configure a comedi device for a probed PCI device.
- * dev->board_ptr is NULL on entry.
- */
 static int
 pci224_attach_pci(struct comedi_device *dev, struct pci_dev *pci_dev)
 {
@@ -1607,14 +1522,6 @@ pci224_attach_pci(struct comedi_device *dev, struct pci_dev *pci_dev)
 	return pci224_attach_common(dev, pci_dev, NULL);
 }
 
-/*
- * _detach is called to deconfigure a device.  It should deallocate
- * resources.
- * This function is also called when _attach() fails, so it should be
- * careful not to release resources that were not necessarily
- * allocated by _attach().  dev->private and dev->subdevices are
- * deallocated automatically by the core.
- */
 static int pci224_detach(struct comedi_device *dev)
 {
 	printk(KERN_DEBUG "comedi%d: %s: detach\n", dev->minor, DRIVER_NAME);
@@ -1648,6 +1555,44 @@ static int pci224_detach(struct comedi_device *dev)
 	return 0;
 }
 
+static struct comedi_driver amplc_pci224_driver = {
+	.driver_name	= "amplc_pci224",
+	.module		= THIS_MODULE,
+	.attach		= pci224_attach,
+	.detach		= pci224_detach,
+	.attach_pci	= pci224_attach_pci,
+	.board_name	= &pci224_boards[0].name,
+	.offset		= sizeof(struct pci224_board),
+	.num_names	= ARRAY_SIZE(pci224_boards),
+};
+
+static int __devinit amplc_pci224_pci_probe(struct pci_dev *dev,
+						   const struct pci_device_id
+						   *ent)
+{
+	return comedi_pci_auto_config(dev, &amplc_pci224_driver);
+}
+
+static void __devexit amplc_pci224_pci_remove(struct pci_dev *dev)
+{
+	comedi_pci_auto_unconfig(dev);
+}
+
+static DEFINE_PCI_DEVICE_TABLE(amplc_pci224_pci_table) = {
+	{ PCI_DEVICE(PCI_VENDOR_ID_AMPLICON, PCI_DEVICE_ID_AMPLICON_PCI224) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_AMPLICON, PCI_DEVICE_ID_AMPLICON_PCI234) },
+	{ 0 }
+};
+MODULE_DEVICE_TABLE(pci, amplc_pci224_pci_table);
+
+static struct pci_driver amplc_pci224_pci_driver = {
+	.name		= "amplc_pci224",
+	.id_table	= amplc_pci224_pci_table,
+	.probe		= amplc_pci224_pci_probe,
+	.remove		= __devexit_p(amplc_pci224_pci_remove),
+};
+module_comedi_pci_driver(amplc_pci224_driver, amplc_pci224_pci_driver);
+
 MODULE_AUTHOR("Comedi http://www.comedi.org");
 MODULE_DESCRIPTION("Comedi low-level driver");
 MODULE_LICENSE("GPL");
