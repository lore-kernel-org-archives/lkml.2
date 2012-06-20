Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757850Ab2FTW5I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 18:57:08 -0400
Received: from mail132.messagelabs.com ([216.82.242.115]:23488 "EHLO
	mail132.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757302Ab2FTW5F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 18:57:05 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-5.tower-132.messagelabs.com!1340232989!12024336!25
X-Originating-IP: [216.166.12.180]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] staging: comedi: skel: use module_comedi_{pci_,}driver()
Date: Wed, 20 Jun 2012 15:56:50 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201206201556.51336.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If PCI boards are supported, use the module_comedi_pci_driver() macro
to register the module as a comedi driver and a PCI driver. Otherwise,
only ISA boards are supported to use the module_comedi_driver() macro
to register the module as a comedi driver.

Refactor the code a bit due to the use of the module_comedi_* macros.

Rename the comedi_driver and pci_driver variables as well as the pci
driver related functions for aesthetic reasons. This makes the skel
driver conform to the changes to the other comedi drivers.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Frank Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/skel.c | 190 +++++++++++++++-------------------
 1 file changed, 81 insertions(+), 109 deletions(-)

diff --git a/drivers/staging/comedi/drivers/skel.c b/drivers/staging/comedi/drivers/skel.c
index 6baac52..f9f1f5f 100644
--- a/drivers/staging/comedi/drivers/skel.c
+++ b/drivers/staging/comedi/drivers/skel.c
@@ -83,11 +83,7 @@ Configuration Options:
 #define SKEL_START_AI_CONV	0
 #define SKEL_AI_READ		0
 
-/*
- * Board descriptions for two imaginary boards.  Describing the
- * boards in this way is optional, and completely driver-dependent.
- * Some drivers use arrays such as this, other do not.
- */
+/* Board specific information about the imaginary board */
 struct skel_board {
 	const char *name;
 	int ai_chans;
@@ -95,34 +91,6 @@ struct skel_board {
 	int have_dio;
 };
 
-static const struct skel_board skel_boards[] = {
-	{
-	 .name = "skel-100",
-	 .ai_chans = 16,
-	 .ai_bits = 12,
-	 .have_dio = 1,
-	 },
-	{
-	 .name = "skel-200",
-	 .ai_chans = 8,
-	 .ai_bits = 16,
-	 .have_dio = 0,
-	 },
-};
-
-/* This is used by modprobe to translate PCI IDs to drivers.  Should
- * only be used for PCI and ISA-PnP devices */
-/* Please add your PCI vendor ID to comedidev.h, and it will be forwarded
- * upstream. */
-#define PCI_VENDOR_ID_SKEL 0xdafe
-static DEFINE_PCI_DEVICE_TABLE(skel_pci_table) = {
-	{ PCI_DEVICE(PCI_VENDOR_ID_SKEL, 0x0100) },
-	{ PCI_DEVICE(PCI_VENDOR_ID_SKEL, 0x0200) },
-	{ 0 }
-};
-
-MODULE_DEVICE_TABLE(pci, skel_pci_table);
-
 /*
  * Useful for shorthand access to the particular board structure
  */
@@ -149,42 +117,6 @@ struct skel_private {
  */
 #define devpriv ((struct skel_private *)dev->private)
 
-/*
- * The struct comedi_driver structure tells the Comedi core module
- * which functions to call to configure/deconfigure (attach/detach)
- * the board, and also about the kernel module that contains
- * the device code.
- */
-static int skel_attach(struct comedi_device *dev, struct comedi_devconfig *it);
-static void skel_detach(struct comedi_device *dev);
-static struct comedi_driver driver_skel = {
-	.driver_name = "dummy",
-	.module = THIS_MODULE,
-	.attach = skel_attach,
-	.detach = skel_detach,
-/* It is not necessary to implement the following members if you are
- * writing a driver for a ISA PnP or PCI card */
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
-	.board_name = &skel_boards[0].name,
-	.offset = sizeof(struct skel_board),
-	.num_names = ARRAY_SIZE(skel_boards),
-};
-
 static int skel_ai_rinsn(struct comedi_device *dev, struct comedi_subdevice *s,
 			 struct comedi_insn *insn, unsigned int *data);
 static int skel_ao_winsn(struct comedi_device *dev, struct comedi_subdevice *s,
@@ -611,57 +543,97 @@ static int skel_dio_insn_config(struct comedi_device *dev,
 	return insn->n;
 }
 
+/*
+ * Board descriptions for two imaginary boards.  Describing the
+ * boards in this way is optional, and completely driver-dependent.
+ * Some drivers use arrays such as this, other do not.
+ */
+static const struct skel_board skel_boards[] = {
+	{
+		.name		= "skel-100",
+		.ai_chans	= 16,
+		.ai_bits	= 12,
+		.have_dio	= 1,
+	}, {
+		.name		= "skel-200",
+		.ai_chans	= 8,
+		.ai_bits	= 16,
+		.have_dio	= 0,
+	},
+};
+
+/*
+ * The struct comedi_driver structure tells the Comedi core module
+ * which functions to call to configure/deconfigure (attach/detach)
+ * the board, and also about the kernel module that contains
+ * the device code.
+ */
+static struct comedi_driver skel_driver = {
+	.driver_name	= "dummy",
+	.module		= THIS_MODULE,
+	.attach		= skel_attach,
+	.detach		= skel_detach,
+	/*
+	 * It is not necessary to implement the following members if
+	 * you are writing a driver for a ISA PnP or PCI card
+	 *
+	 * Most drivers will support multiple types of boards by
+	 * having an array of board structures.  These were defined
+	 * in skel_boards[] above.  Note that the element 'name'
+	 * was first in the structure -- Comedi uses this fact to
+	 * extract the name of the board without knowing any details
+	 * about the structure except for its length.
+	 * When a device is attached (by comedi_config), the name
+	 * of the device is given to Comedi, and Comedi tries to
+	 * match it by going through the list of board names.  If
+	 * there is a match, the address of the pointer is put
+	 * into dev->board_ptr and driver->attach() is called.
+	 *
+	 * Note that these are not necessary if you can determine
+	 * the type of board in software.  ISA PnP, PCI, and PCMCIA
+	 * devices are such boards.
+	 */
+	.board_name	= &skel_boards[0].name,
+	.offset		= sizeof(struct skel_board),
+	.num_names	= ARRAY_SIZE(skel_boards),
+};
+
 #ifdef CONFIG_COMEDI_PCI
-static int __devinit driver_skel_pci_probe(struct pci_dev *dev,
-					   const struct pci_device_id *ent)
+static int __devinit skel_pci_probe(struct pci_dev *dev,
+				    const struct pci_device_id *ent)
 {
-	return comedi_pci_auto_config(dev, &driver_skel);
+	return comedi_pci_auto_config(dev, &skel_driver);
 }
 
-static void __devexit driver_skel_pci_remove(struct pci_dev *dev)
+static void __devexit skel_pci_remove(struct pci_dev *dev)
 {
 	comedi_pci_auto_unconfig(dev);
 }
 
-static struct pci_driver driver_skel_pci_driver = {
-	.id_table = skel_pci_table,
-	.probe = &driver_skel_pci_probe,
-	.remove = __devexit_p(&driver_skel_pci_remove)
+/*
+ * This is used by modprobe to translate PCI IDs to drivers.
+ * Should only be used for PCI and ISA-PnP devices
+ *
+ * Please add your PCI vendor ID to comedidev.h, and it will
+ * be forwarded upstream.
+ */
+#define PCI_VENDOR_ID_SKEL 0xdafe
+static DEFINE_PCI_DEVICE_TABLE(skel_pci_table) = {
+	{ PCI_DEVICE(PCI_VENDOR_ID_SKEL, 0x0100) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_SKEL, 0x0200) },
+	{ 0 }
 };
+MODULE_DEVICE_TABLE(pci, skel_pci_table);
 
-static int __init driver_skel_init_module(void)
-{
-	int retval;
-
-	retval = comedi_driver_register(&driver_skel);
-	if (retval < 0)
-		return retval;
-
-	driver_skel_pci_driver.name = (char *)driver_skel.driver_name;
-	return pci_register_driver(&driver_skel_pci_driver);
-}
-
-static void __exit driver_skel_cleanup_module(void)
-{
-	pci_unregister_driver(&driver_skel_pci_driver);
-	comedi_driver_unregister(&driver_skel);
-}
-
-module_init(driver_skel_init_module);
-module_exit(driver_skel_cleanup_module);
+static struct pci_driver skel_pci_driver = {
+	.name		= "dummy",
+	.id_table	= skel_pci_table,
+	.probe		= skel_pci_probe,
+	.remove		= __devexit_p(skel_pci_remove),
+};
+module_comedi_pci_driver(skel_driver, skel_pci_driver);
 #else
-static int __init driver_skel_init_module(void)
-{
-	return comedi_driver_register(&driver_skel);
-}
-
-static void __exit driver_skel_cleanup_module(void)
-{
-	comedi_driver_unregister(&driver_skel);
-}
-
-module_init(driver_skel_init_module);
-module_exit(driver_skel_cleanup_module);
+module_comedi_driver(skel_driver);
 #endif
 
 MODULE_AUTHOR("Comedi http://www.comedi.org");
-- 
1.7.11

