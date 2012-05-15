Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965552Ab2EOWEr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 18:04:47 -0400
Received: from mail127.messagelabs.com ([216.82.250.115]:44420 "EHLO
	mail127.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964810Ab2EOWEq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 18:04:46 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-2.tower-127.messagelabs.com!1337119483!5617666!3
X-Originating-IP: [216.166.12.180]
X-StarScan-Version: 6.5.7; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] staging: comedi: refactor cb_pcimdas driver and use module_comedi_pci_driver
Date: Tue, 15 May 2012 15:04:40 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201205151504.40472.hartleys@visionengravers.com>
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

 drivers/staging/comedi/drivers/cb_pcimdas.c |   81 +++++++-------------------
 1 files changed, 22 insertions(+), 59 deletions(-)

diff --git a/drivers/staging/comedi/drivers/cb_pcimdas.c b/drivers/staging/comedi/drivers/cb_pcimdas.c
index 842d99d..31541e1 100644
--- a/drivers/staging/comedi/drivers/cb_pcimdas.c
+++ b/drivers/staging/comedi/drivers/cb_pcimdas.c
@@ -123,15 +123,6 @@ static const struct cb_pcimdas_board cb_pcimdas_boards[] = {
 	 },
 };
 
-/* This is used by modprobe to translate PCI IDs to drivers.  Should
- * only be used for PCI and ISA-PnP devices */
-static DEFINE_PCI_DEVICE_TABLE(cb_pcimdas_pci_table) = {
-	{ PCI_DEVICE(PCI_VENDOR_ID_COMPUTERBOARDS, 0x0056) },
-	{ 0 }
-};
-
-MODULE_DEVICE_TABLE(pci, cb_pcimdas_pci_table);
-
 #define N_BOARDS 1		/*  Max number of boards supported */
 
 /*
@@ -175,22 +166,6 @@ struct cb_pcimdas_private {
  */
 #define devpriv ((struct cb_pcimdas_private *)dev->private)
 
-/*
- * The struct comedi_driver structure tells the Comedi core module
- * which functions to call to configure/deconfigure (attach/detach)
- * the board, and also about the kernel module that contains
- * the device code.
- */
-static int cb_pcimdas_attach(struct comedi_device *dev,
-			     struct comedi_devconfig *it);
-static int cb_pcimdas_detach(struct comedi_device *dev);
-static struct comedi_driver driver_cb_pcimdas = {
-	.driver_name = "cb_pcimdas",
-	.module = THIS_MODULE,
-	.attach = cb_pcimdas_attach,
-	.detach = cb_pcimdas_detach,
-};
-
 static int cb_pcimdas_ai_rinsn(struct comedi_device *dev,
 			       struct comedi_subdevice *s,
 			       struct comedi_insn *insn, unsigned int *data);
@@ -486,49 +461,37 @@ static int cb_pcimdas_ao_rinsn(struct comedi_device *dev,
 	return i;
 }
 
-/*
- * A convenient macro that defines init_module() and cleanup_module(),
- * as necessary.
- */
-static int __devinit driver_cb_pcimdas_pci_probe(struct pci_dev *dev,
-						 const struct pci_device_id
-						 *ent)
+static struct comedi_driver cb_pcimdas_driver = {
+	.driver_name	= "cb_pcimdas",
+	.module		= THIS_MODULE,
+	.attach		= cb_pcimdas_attach,
+	.detach		= cb_pcimdas_detach,
+};
+
+static int __devinit cb_pcimdas_pci_probe(struct pci_dev *dev,
+					  const struct pci_device_id *ent)
 {
-	return comedi_pci_auto_config(dev, &driver_cb_pcimdas);
+	return comedi_pci_auto_config(dev, &cb_pcimdas_driver);
 }
 
-static void __devexit driver_cb_pcimdas_pci_remove(struct pci_dev *dev)
+static void __devexit cb_pcimdas_pci_remove(struct pci_dev *dev)
 {
 	comedi_pci_auto_unconfig(dev);
 }
 
-static struct pci_driver driver_cb_pcimdas_pci_driver = {
-	.id_table = cb_pcimdas_pci_table,
-	.probe = &driver_cb_pcimdas_pci_probe,
-	.remove = __devexit_p(&driver_cb_pcimdas_pci_remove)
+static DEFINE_PCI_DEVICE_TABLE(cb_pcimdas_pci_table) = {
+	{ PCI_DEVICE(PCI_VENDOR_ID_COMPUTERBOARDS, 0x0056) },
+	{ 0 }
 };
+MODULE_DEVICE_TABLE(pci, cb_pcimdas_pci_table);
 
-static int __init driver_cb_pcimdas_init_module(void)
-{
-	int retval;
-
-	retval = comedi_driver_register(&driver_cb_pcimdas);
-	if (retval < 0)
-		return retval;
-
-	driver_cb_pcimdas_pci_driver.name =
-	    (char *)driver_cb_pcimdas.driver_name;
-	return pci_register_driver(&driver_cb_pcimdas_pci_driver);
-}
-
-static void __exit driver_cb_pcimdas_cleanup_module(void)
-{
-	pci_unregister_driver(&driver_cb_pcimdas_pci_driver);
-	comedi_driver_unregister(&driver_cb_pcimdas);
-}
-
-module_init(driver_cb_pcimdas_init_module);
-module_exit(driver_cb_pcimdas_cleanup_module);
+static struct pci_driver cb_pcimdas_pci_driver = {
+	.name		= "cb_pcimdas",
+	.id_table	= cb_pcimdas_pci_table,
+	.probe		= cb_pcimdas_pci_probe,
+	.remove		= __devexit_p(cb_pcimdas_pci_remove),
+};
+module_comedi_pci_driver(cb_pcimdas_driver, cb_pcimdas_pci_driver);
 
 MODULE_AUTHOR("Comedi http://www.comedi.org");
 MODULE_DESCRIPTION("Comedi low-level driver");
