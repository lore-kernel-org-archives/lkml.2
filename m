Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933033Ab2EOVsd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 17:48:33 -0400
Received: from mail131.messagelabs.com ([216.82.242.99]:16668 "EHLO
	mail131.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757604Ab2EOVsc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 17:48:32 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-10.tower-131.messagelabs.com!1337118491!22722934!28
X-Originating-IP: [216.166.12.180]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] staging: comedi: refactor cb_pcidas driver and use module_comedi_pci_driver
Date: Tue, 15 May 2012 14:48:04 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201205151448.04966.hartleys@visionengravers.com>
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

The attach/detach functions still need refactored to remove the
remaining forward declarations. Doing that is this patch makes it
difficult to review.

 drivers/staging/comedi/drivers/cb_pcidas.c |   91 +++++++++-------------------
 1 files changed, 29 insertions(+), 62 deletions(-)

diff --git a/drivers/staging/comedi/drivers/cb_pcidas.c b/drivers/staging/comedi/drivers/cb_pcidas.c
index f1ad286..7e11910 100644
--- a/drivers/staging/comedi/drivers/cb_pcidas.c
+++ b/drivers/staging/comedi/drivers/cb_pcidas.c
@@ -405,20 +405,6 @@ static const struct cb_pcidas_board cb_pcidas_boards[] = {
 	 },
 };
 
-static DEFINE_PCI_DEVICE_TABLE(cb_pcidas_pci_table) = {
-	{ PCI_DEVICE(PCI_VENDOR_ID_CB, 0x0001) },
-	{ PCI_DEVICE(PCI_VENDOR_ID_CB, 0x000f) },
-	{ PCI_DEVICE(PCI_VENDOR_ID_CB, 0x0010) },
-	{ PCI_DEVICE(PCI_VENDOR_ID_CB, 0x0019) },
-	{ PCI_DEVICE(PCI_VENDOR_ID_CB, 0x001c) },
-	{ PCI_DEVICE(PCI_VENDOR_ID_CB, 0x004c) },
-	{ PCI_DEVICE(PCI_VENDOR_ID_CB, 0x001a) },
-	{ PCI_DEVICE(PCI_VENDOR_ID_CB, 0x001b) },
-	{ 0 }
-};
-
-MODULE_DEVICE_TABLE(pci, cb_pcidas_pci_table);
-
 /*
  * Useful for shorthand access to the particular board structure
  */
@@ -462,22 +448,6 @@ struct cb_pcidas_private {
  */
 #define devpriv ((struct cb_pcidas_private *)dev->private)
 
-/*
- * The struct comedi_driver structure tells the Comedi core module
- * which functions to call to configure/deconfigure (attach/detach)
- * the board, and also about the kernel module that contains
- * the device code.
- */
-static int cb_pcidas_attach(struct comedi_device *dev,
-			    struct comedi_devconfig *it);
-static int cb_pcidas_detach(struct comedi_device *dev);
-static struct comedi_driver driver_cb_pcidas = {
-	.driver_name = "cb_pcidas",
-	.module = THIS_MODULE,
-	.attach = cb_pcidas_attach,
-	.detach = cb_pcidas_detach,
-};
-
 static int cb_pcidas_ai_rinsn(struct comedi_device *dev,
 			      struct comedi_subdevice *s,
 			      struct comedi_insn *insn, unsigned int *data);
@@ -1918,47 +1888,44 @@ static int nvram_read(struct comedi_device *dev, unsigned int address,
 	return 0;
 }
 
-/*
- * A convenient macro that defines init_module() and cleanup_module(),
- * as necessary.
- */
-static int __devinit driver_cb_pcidas_pci_probe(struct pci_dev *dev,
-						const struct pci_device_id *ent)
+static struct comedi_driver cb_pcidas_driver = {
+	.driver_name	= "cb_pcidas",
+	.module		= THIS_MODULE,
+	.attach		= cb_pcidas_attach,
+	.detach		= cb_pcidas_detach,
+};
+
+static int __devinit cb_pcidas_pci_probe(struct pci_dev *dev,
+					 const struct pci_device_id *ent)
 {
-	return comedi_pci_auto_config(dev, &driver_cb_pcidas);
+	return comedi_pci_auto_config(dev, &cb_pcidas_driver);
 }
 
-static void __devexit driver_cb_pcidas_pci_remove(struct pci_dev *dev)
+static void __devexit cb_pcidas_pci_remove(struct pci_dev *dev)
 {
 	comedi_pci_auto_unconfig(dev);
 }
 
-static struct pci_driver driver_cb_pcidas_pci_driver = {
-	.id_table = cb_pcidas_pci_table,
-	.probe = &driver_cb_pcidas_pci_probe,
-	.remove = __devexit_p(&driver_cb_pcidas_pci_remove)
+static DEFINE_PCI_DEVICE_TABLE(cb_pcidas_pci_table) = {
+	{ PCI_DEVICE(PCI_VENDOR_ID_CB, 0x0001) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_CB, 0x000f) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_CB, 0x0010) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_CB, 0x0019) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_CB, 0x001c) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_CB, 0x004c) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_CB, 0x001a) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_CB, 0x001b) },
+	{ 0 }
 };
+MODULE_DEVICE_TABLE(pci, cb_pcidas_pci_table);
 
-static int __init driver_cb_pcidas_init_module(void)
-{
-	int retval;
-
-	retval = comedi_driver_register(&driver_cb_pcidas);
-	if (retval < 0)
-		return retval;
-
-	driver_cb_pcidas_pci_driver.name = (char *)driver_cb_pcidas.driver_name;
-	return pci_register_driver(&driver_cb_pcidas_pci_driver);
-}
-
-static void __exit driver_cb_pcidas_cleanup_module(void)
-{
-	pci_unregister_driver(&driver_cb_pcidas_pci_driver);
-	comedi_driver_unregister(&driver_cb_pcidas);
-}
-
-module_init(driver_cb_pcidas_init_module);
-module_exit(driver_cb_pcidas_cleanup_module);
+static struct pci_driver cb_pcidas_pci_driver = {
+	.name		= "cb_pcidas",
+	.id_table	= cb_pcidas_pci_table,
+	.probe		= cb_pcidas_pci_probe,
+	.remove		= __devexit_p(cb_pcidas_pci_remove)
+};
+module_comedi_pci_driver(cb_pcidas_driver, cb_pcidas_pci_driver);
 
 MODULE_AUTHOR("Comedi http://www.comedi.org");
 MODULE_DESCRIPTION("Comedi low-level driver");
