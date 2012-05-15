Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933242Ab2EOV77 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 17:59:59 -0400
Received: from mail132.messagelabs.com ([216.82.242.115]:29228 "EHLO
	mail132.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932881Ab2EOV75 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 17:59:57 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-9.tower-132.messagelabs.com!1337119134!11707800!71
X-Originating-IP: [216.166.12.32]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] staging: comedi: refactor cb_pcidio driver and use module_comedi_pci_driver
Date: Tue, 15 May 2012 14:59:47 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201205151459.48019.hartleys@visionengravers.com>
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

 drivers/staging/comedi/drivers/cb_pcidio.c |  128 +++++-----------------------
 1 files changed, 23 insertions(+), 105 deletions(-)

diff --git a/drivers/staging/comedi/drivers/cb_pcidio.c b/drivers/staging/comedi/drivers/cb_pcidio.c
index 3758af7..47a2c9b 100644
--- a/drivers/staging/comedi/drivers/cb_pcidio.c
+++ b/drivers/staging/comedi/drivers/cb_pcidio.c
@@ -86,19 +86,6 @@ static const struct pcidio_board pcidio_boards[] = {
 	 },
 };
 
-/* This is used by modprobe to translate PCI IDs to drivers.  Should
- * only be used for PCI and ISA-PnP devices */
-/* Please add your PCI vendor ID to comedidev.h, and it will be forwarded
- * upstream. */
-static DEFINE_PCI_DEVICE_TABLE(pcidio_pci_table) = {
-	{ PCI_DEVICE(PCI_VENDOR_ID_CB, 0x0028) },
-	{ PCI_DEVICE(PCI_VENDOR_ID_CB, 0x0014) },
-	{ PCI_DEVICE(PCI_VENDOR_ID_CB, 0x000b) },
-	{ 0 }
-};
-
-MODULE_DEVICE_TABLE(pci, pcidio_pci_table);
-
 /*
  * Useful for shorthand access to the particular board structure
  */
@@ -125,59 +112,6 @@ struct pcidio_private {
  */
 #define devpriv ((struct pcidio_private *)dev->private)
 
-/*
- * The struct comedi_driver structure tells the Comedi core module
- * which functions to call to configure/deconfigure (attach/detach)
- * the board, and also about the kernel module that contains
- * the device code.
- */
-static int pcidio_attach(struct comedi_device *dev,
-			 struct comedi_devconfig *it);
-static int pcidio_detach(struct comedi_device *dev);
-static struct comedi_driver driver_cb_pcidio = {
-	.driver_name = "cb_pcidio",
-	.module = THIS_MODULE,
-	.attach = pcidio_attach,
-	.detach = pcidio_detach,
-
-/* It is not necessary to implement the following members if you are
- * writing a driver for a ISA PnP or PCI card */
-
-	/* Most drivers will support multiple types of boards by
-	 * having an array of board structures.  These were defined
-	 * in pcidio_boards[] above.  Note that the element 'name'
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
-
-/* The following fields should NOT be initialized if you are dealing
- * with PCI devices
- *
- *	.board_name = pcidio_boards,
- *	.offset = sizeof(struct pcidio_board),
- *	.num_names = sizeof(pcidio_boards) / sizeof(structpcidio_board),
- */
-
-};
-
-/*------------------------------- FUNCTIONS -----------------------------------*/
-
-/*
- * Attach is called by the Comedi core to configure the driver
- * for a particular board.  If you specified a board_name array
- * in the driver structure, dev->board_ptr contains that
- * address.
- */
 static int pcidio_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 {
 	struct pci_dev *pcidev = NULL;
@@ -261,14 +195,6 @@ found:
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
 static int pcidio_detach(struct comedi_device *dev)
 {
 	if (devpriv) {
@@ -286,47 +212,39 @@ static int pcidio_detach(struct comedi_device *dev)
 	return 0;
 }
 
-/*
- * A convenient macro that defines init_module() and cleanup_module(),
- * as necessary.
- */
-static int __devinit driver_cb_pcidio_pci_probe(struct pci_dev *dev,
+static struct comedi_driver cb_pcidio_driver = {
+	.driver_name	= "cb_pcidio",
+	.module		= THIS_MODULE,
+	.attach		= pcidio_attach,
+	.detach		= pcidio_detach,
+};
+
+static int __devinit cb_pcidio_pci_probe(struct pci_dev *dev,
 						const struct pci_device_id *ent)
 {
-	return comedi_pci_auto_config(dev, &driver_cb_pcidio);
+	return comedi_pci_auto_config(dev, &cb_pcidio_driver);
 }
 
-static void __devexit driver_cb_pcidio_pci_remove(struct pci_dev *dev)
+static void __devexit cb_pcidio_pci_remove(struct pci_dev *dev)
 {
 	comedi_pci_auto_unconfig(dev);
 }
 
-static struct pci_driver driver_cb_pcidio_pci_driver = {
-	.id_table = pcidio_pci_table,
-	.probe = &driver_cb_pcidio_pci_probe,
-	.remove = __devexit_p(&driver_cb_pcidio_pci_remove)
+static DEFINE_PCI_DEVICE_TABLE(cb_pcidio_pci_table) = {
+	{ PCI_DEVICE(PCI_VENDOR_ID_CB, 0x0028) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_CB, 0x0014) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_CB, 0x000b) },
+	{ 0 }
 };
+MODULE_DEVICE_TABLE(pci, cb_pcidio_pci_table);
 
-static int __init driver_cb_pcidio_init_module(void)
-{
-	int retval;
-
-	retval = comedi_driver_register(&driver_cb_pcidio);
-	if (retval < 0)
-		return retval;
-
-	driver_cb_pcidio_pci_driver.name = (char *)driver_cb_pcidio.driver_name;
-	return pci_register_driver(&driver_cb_pcidio_pci_driver);
-}
-
-static void __exit driver_cb_pcidio_cleanup_module(void)
-{
-	pci_unregister_driver(&driver_cb_pcidio_pci_driver);
-	comedi_driver_unregister(&driver_cb_pcidio);
-}
-
-module_init(driver_cb_pcidio_init_module);
-module_exit(driver_cb_pcidio_cleanup_module);
+static struct pci_driver cb_pcidio_pci_driver = {
+	.name		= "cb_pcidio",
+	.id_table	= cb_pcidio_pci_table,
+	.probe		= cb_pcidio_pci_probe,
+	.remove		= __devexit_p(cb_pcidio_pci_remove),
+};
+module_comedi_pci_driver(cb_pcidio_driver, cb_pcidio_pci_driver);
 
 MODULE_AUTHOR("Comedi http://www.comedi.org");
 MODULE_DESCRIPTION("Comedi low-level driver");
