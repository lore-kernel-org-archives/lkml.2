Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755715Ab2DWXG2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 19:06:28 -0400
Received: from mail131.messagelabs.com ([216.82.242.99]:43979 "EHLO
	mail131.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753017Ab2DWXG1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 19:06:27 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-12.tower-131.messagelabs.com!1335222385!17808299!1
X-Originating-IP: [216.166.12.32]
X-StarScan-Version: 6.5.7; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] staging: comedi: refactor adv_pci7123 driver to remove forward declarations
Date: Mon, 23 Apr 2012 16:06:14 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201204231606.14819.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the struct comedi_driver variable and the associated
attach/detach routines to remove the need for the forward
declarations.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---

diff --git a/drivers/staging/comedi/drivers/adv_pci1723.c b/drivers/staging/comedi/drivers/adv_pci1723.c
index 4a4ae5f..54a3304 100644
--- a/drivers/staging/comedi/drivers/adv_pci1723.c
+++ b/drivers/staging/comedi/drivers/adv_pci1723.c
@@ -150,34 +150,6 @@ static const struct pci1723_board boardtypes[] = {
 	 },
 };
 
-/*
- * This is used by modprobe to translate PCI IDs to drivers.
- * Should only be used for PCI and ISA-PnP devices
- */
-static DEFINE_PCI_DEVICE_TABLE(pci1723_pci_table) = {
-	{ PCI_DEVICE(PCI_VENDOR_ID_ADVANTECH, 0x1723) },
-	{ 0 }
-};
-
-MODULE_DEVICE_TABLE(pci, pci1723_pci_table);
-
-/*
- * The struct comedi_driver structure tells the Comedi core module
- * which functions to call to configure/deconfigure (attach/detach)
- * the board, and also about the kernel module that contains
- * the device code.
- */
-static int pci1723_attach(struct comedi_device *dev,
-			  struct comedi_devconfig *it);
-static int pci1723_detach(struct comedi_device *dev);
-
-static struct comedi_driver driver_pci1723 = {
-	.driver_name = "adv_pci1723",
-	.module = THIS_MODULE,
-	.attach = pci1723_attach,
-	.detach = pci1723_detach,
-};
-
 /* This structure is for data unique to this hardware driver. */
 struct pci1723_private {
 	int valid;		/* card is usable; */
@@ -317,10 +289,6 @@ static int pci1723_dio_insn_bits(struct comedi_device *dev,
 	return 2;
 }
 
-/*
- * Attach is called by the Comedi core to configure the driver
- * for a pci1723 board.
- */
 static int pci1723_attach(struct comedi_device *dev,
 			  struct comedi_devconfig *it)
 {
@@ -463,14 +431,6 @@ static int pci1723_attach(struct comedi_device *dev,
 	return 0;
 }
 
-/*
- * _detach is called to deconfigure a device.  It should deallocate
- * resources.
- * This function is also called when _attach() fails, so it should be
- * careful not to release resources that were not necessarily
- * allocated by _attach().  dev->private and dev->subdevices are
- * deallocated automatically by the core.
- */
 static int pci1723_detach(struct comedi_device *dev)
 {
 	printk(KERN_ERR "comedi%d: pci1723: remove\n", dev->minor);
@@ -489,10 +449,13 @@ static int pci1723_detach(struct comedi_device *dev)
 	return 0;
 }
 
-/*
- * A convenient macro that defines init_module() and cleanup_module(),
- * as necessary.
- */
+static struct comedi_driver driver_pci1723 = {
+	.driver_name	= "adv_pci1723",
+	.module		= THIS_MODULE,
+	.attach		= pci1723_attach,
+	.detach		= pci1723_detach,
+};
+
 static int __devinit driver_pci1723_pci_probe(struct pci_dev *dev,
 					      const struct pci_device_id *ent)
 {
@@ -504,10 +467,16 @@ static void __devexit driver_pci1723_pci_remove(struct pci_dev *dev)
 	comedi_pci_auto_unconfig(dev);
 }
 
+static DEFINE_PCI_DEVICE_TABLE(pci1723_pci_table) = {
+	{ PCI_DEVICE(PCI_VENDOR_ID_ADVANTECH, 0x1723) },
+	{ 0 }
+};
+MODULE_DEVICE_TABLE(pci, pci1723_pci_table);
+
 static struct pci_driver driver_pci1723_pci_driver = {
-	.id_table = pci1723_pci_table,
-	.probe = &driver_pci1723_pci_probe,
-	.remove = __devexit_p(&driver_pci1723_pci_remove)
+	.id_table	= pci1723_pci_table,
+	.probe		= driver_pci1723_pci_probe,
+	.remove		= __devexit_p(driver_pci1723_pci_remove),
 };
 
 static int __init driver_pci1723_init_module(void)
@@ -521,14 +490,13 @@ static int __init driver_pci1723_init_module(void)
 	driver_pci1723_pci_driver.name = (char *)driver_pci1723.driver_name;
 	return pci_register_driver(&driver_pci1723_pci_driver);
 }
+module_init(driver_pci1723_init_module);
 
 static void __exit driver_pci1723_cleanup_module(void)
 {
 	pci_unregister_driver(&driver_pci1723_pci_driver);
 	comedi_driver_unregister(&driver_pci1723);
 }
-
-module_init(driver_pci1723_init_module);
 module_exit(driver_pci1723_cleanup_module);
 
 MODULE_AUTHOR("Comedi http://www.comedi.org");
