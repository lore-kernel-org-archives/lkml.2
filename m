Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966732Ab2EOUNL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 16:13:11 -0400
Received: from mail131.messagelabs.com ([216.82.242.99]:15574 "EHLO
	mail131.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932843Ab2EOUNJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 16:13:09 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-3.tower-131.messagelabs.com!1337112763!20593556!29
X-Originating-IP: [216.166.12.31]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] staging: comedi: refactor adv_pci1710 driver and use module_comedi_pci_driver
Date: Tue, 15 May 2012 13:12:53 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201205151312.53467.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the module_init/module_exit routines and the associated
struct comedi_drive and struct pci_driver to the end of the
source. This is more typical of how other drivers are written and
removes the need for the forward declarations.

Convert the driver to use the module_comedi_pci_driver() macro
which makes the code smaller and a bit simpler.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---

 drivers/staging/comedi/drivers/adv_pci1710.c |   95 ++++++++------------------
 1 files changed, 29 insertions(+), 66 deletions(-)

diff --git a/drivers/staging/comedi/drivers/adv_pci1710.c b/drivers/staging/comedi/drivers/adv_pci1710.c
index 6279e88..ff61dff 100644
--- a/drivers/staging/comedi/drivers/adv_pci1710.c
+++ b/drivers/staging/comedi/drivers/adv_pci1710.c
@@ -191,10 +191,6 @@ static const struct comedi_lrange range_pci171x_da = { 2, {
 							   }
 };
 
-static int pci1710_attach(struct comedi_device *dev,
-			  struct comedi_devconfig *it);
-static int pci1710_detach(struct comedi_device *dev);
-
 struct boardtype {
 	const char *name;	/*  board name */
 	int device_id;
@@ -216,17 +212,6 @@ struct boardtype {
 	unsigned int fifo_half_size;	/*  size of FIFO/2 */
 };
 
-static DEFINE_PCI_DEVICE_TABLE(pci1710_pci_table) = {
-	{ PCI_DEVICE(PCI_VENDOR_ID_ADVANTECH, 0x1710) },
-	{ PCI_DEVICE(PCI_VENDOR_ID_ADVANTECH, 0x1711) },
-	{ PCI_DEVICE(PCI_VENDOR_ID_ADVANTECH, 0x1713) },
-	{ PCI_DEVICE(PCI_VENDOR_ID_ADVANTECH, 0x1720) },
-	{ PCI_DEVICE(PCI_VENDOR_ID_ADVANTECH, 0x1731) },
-	{ 0 }
-};
-
-MODULE_DEVICE_TABLE(pci, pci1710_pci_table);
-
 static const struct boardtype boardtypes[] = {
 	{"pci1710", 0x1710,
 	 IORANGE_171x, 1, TYPE_PCI171X,
@@ -264,16 +249,6 @@ static const struct boardtype boardtypes[] = {
 	{.name = DRV_NAME},
 };
 
-static struct comedi_driver driver_pci1710 = {
-	.driver_name = DRV_NAME,
-	.module = THIS_MODULE,
-	.attach = pci1710_attach,
-	.detach = pci1710_detach,
-	.num_names = ARRAY_SIZE(boardtypes),
-	.board_name = &boardtypes[0].name,
-	.offset = sizeof(struct boardtype),
-};
-
 struct pci1710_private {
 	struct pci_dev *pcidev;	/*  ptr to PCI device */
 	char valid;		/*  card is usable */
@@ -1360,9 +1335,6 @@ static int pci1710_reset(struct comedi_device *dev)
 	DPRINTK("adv_pci1710 EDBG: END: pci1710_reset(...)\n");
 }
 
-/*
-==============================================================================
-*/
 static int pci1710_attach(struct comedi_device *dev,
 			  struct comedi_devconfig *it)
 {
@@ -1579,12 +1551,8 @@ static int pci1710_attach(struct comedi_device *dev,
 	return 0;
 }
 
-/*
-==============================================================================
-*/
 static int pci1710_detach(struct comedi_device *dev)
 {
-
 	if (dev->private) {
 		if (devpriv->valid)
 			pci1710_reset(dev);
@@ -1601,49 +1569,44 @@ static int pci1710_detach(struct comedi_device *dev)
 	return 0;
 }
 
-/*
-==============================================================================
-*/
-static int __devinit driver_pci1710_pci_probe(struct pci_dev *dev,
-					      const struct pci_device_id *ent)
+static struct comedi_driver adv_pci1710_driver = {
+	.driver_name	= "adv_pci1710",
+	.module		= THIS_MODULE,
+	.attach		= pci1710_attach,
+	.detach		= pci1710_detach,
+	.num_names	= ARRAY_SIZE(boardtypes),
+	.board_name	= &boardtypes[0].name,
+	.offset		= sizeof(struct boardtype),
+};
+
+static int __devinit adv_pci1710_pci_probe(struct pci_dev *dev,
+					   const struct pci_device_id *ent)
 {
-	return comedi_pci_auto_config(dev, &driver_pci1710);
+	return comedi_pci_auto_config(dev, &adv_pci1710_driver);
 }
 
-static void __devexit driver_pci1710_pci_remove(struct pci_dev *dev)
+static void __devexit adv_pci1710_pci_remove(struct pci_dev *dev)
 {
 	comedi_pci_auto_unconfig(dev);
 }
 
-static struct pci_driver driver_pci1710_pci_driver = {
-	.id_table = pci1710_pci_table,
-	.probe = &driver_pci1710_pci_probe,
-	.remove = __devexit_p(&driver_pci1710_pci_remove)
+static DEFINE_PCI_DEVICE_TABLE(adv_pci1710_pci_table) = {
+	{ PCI_DEVICE(PCI_VENDOR_ID_ADVANTECH, 0x1710) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_ADVANTECH, 0x1711) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_ADVANTECH, 0x1713) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_ADVANTECH, 0x1720) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_ADVANTECH, 0x1731) },
+	{ 0 }
 };
+MODULE_DEVICE_TABLE(pci, adv_pci1710_pci_table);
 
-static int __init driver_pci1710_init_module(void)
-{
-	int retval;
-
-	retval = comedi_driver_register(&driver_pci1710);
-	if (retval < 0)
-		return retval;
-
-	driver_pci1710_pci_driver.name = (char *)driver_pci1710.driver_name;
-	return pci_register_driver(&driver_pci1710_pci_driver);
-}
-
-static void __exit driver_pci1710_cleanup_module(void)
-{
-	pci_unregister_driver(&driver_pci1710_pci_driver);
-	comedi_driver_unregister(&driver_pci1710);
-}
-
-module_init(driver_pci1710_init_module);
-module_exit(driver_pci1710_cleanup_module);
-/*
-==============================================================================
-*/
+static struct pci_driver adv_pci1710_pci_driver = {
+	.name		= "adv_pci1710",
+	.id_table	= adv_pci1710_pci_table,
+	.probe		= adv_pci1710_pci_probe,
+	.remove		= __devexit_p(adv_pci1710_pci_remove),
+};
+module_comedi_pci_driver(adv_pci1710_driver, adv_pci1710_pci_driver);
 
 MODULE_AUTHOR("Comedi http://www.comedi.org");
 MODULE_DESCRIPTION("Comedi low-level driver");
