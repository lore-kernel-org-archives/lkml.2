Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966844Ab2EOVIY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 17:08:24 -0400
Received: from mail127.messagelabs.com ([216.82.250.115]:41494 "EHLO
	mail127.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933103Ab2EOVIW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 17:08:22 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-11.tower-127.messagelabs.com!1337116100!5599958!5
X-Originating-IP: [216.166.12.98]
X-StarScan-Version: 6.5.7; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] staging: comedi: refactor amplc_pci230 driver and use module_comedi_pci_driver
Date: Tue, 15 May 2012 14:08:11 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201205151408.11695.hartleys@visionengravers.com>
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

 drivers/staging/comedi/drivers/amplc_pci230.c |  102 +++++++++----------------
 1 files changed, 36 insertions(+), 66 deletions(-)

diff --git a/drivers/staging/comedi/drivers/amplc_pci230.c b/drivers/staging/comedi/drivers/amplc_pci230.c
index 1d2eb47..2a23f15 100644
--- a/drivers/staging/comedi/drivers/amplc_pci230.c
+++ b/drivers/staging/comedi/drivers/amplc_pci230.c
@@ -500,13 +500,6 @@ static const struct pci230_board pci230_boards[] = {
 	 },
 };
 
-static DEFINE_PCI_DEVICE_TABLE(pci230_pci_table) = {
-	{ PCI_DEVICE(PCI_VENDOR_ID_AMPLICON, PCI_DEVICE_ID_PCI230) },
-	{ PCI_DEVICE(PCI_VENDOR_ID_AMPLICON, PCI_DEVICE_ID_PCI260) },
-	{0}
-};
-
-MODULE_DEVICE_TABLE(pci, pci230_pci_table);
 /*
  * Useful for shorthand access to the particular board structure
  */
@@ -595,65 +588,6 @@ static const struct comedi_lrange pci230_ao_range = { 2, {
 /* PCI230 daccon bipolar flag for each analogue output range. */
 static const unsigned char pci230_ao_bipolar[2] = { 0, 1 };
 
-/*
- * The struct comedi_driver structure tells the Comedi core module
- * which functions to call to configure/deconfigure (attach/detach)
- * the board, and also about the kernel module that contains
- * the device code.
- */
-static int pci230_attach(struct comedi_device *dev,
-			 struct comedi_devconfig *it);
-static int pci230_detach(struct comedi_device *dev);
-static struct comedi_driver driver_amplc_pci230 = {
-	.driver_name = "amplc_pci230",
-	.module = THIS_MODULE,
-	.attach = pci230_attach,
-	.detach = pci230_detach,
-	.board_name = &pci230_boards[0].name,
-	.offset = sizeof(pci230_boards[0]),
-	.num_names = ARRAY_SIZE(pci230_boards),
-};
-
-static int __devinit driver_amplc_pci230_pci_probe(struct pci_dev *dev,
-						   const struct pci_device_id
-						   *ent)
-{
-	return comedi_pci_auto_config(dev, &driver_amplc_pci230);
-}
-
-static void __devexit driver_amplc_pci230_pci_remove(struct pci_dev *dev)
-{
-	comedi_pci_auto_unconfig(dev);
-}
-
-static struct pci_driver driver_amplc_pci230_pci_driver = {
-	.id_table = pci230_pci_table,
-	.probe = &driver_amplc_pci230_pci_probe,
-	.remove = __devexit_p(&driver_amplc_pci230_pci_remove)
-};
-
-static int __init driver_amplc_pci230_init_module(void)
-{
-	int retval;
-
-	retval = comedi_driver_register(&driver_amplc_pci230);
-	if (retval < 0)
-		return retval;
-
-	driver_amplc_pci230_pci_driver.name =
-	    (char *)driver_amplc_pci230.driver_name;
-	return pci_register_driver(&driver_amplc_pci230_pci_driver);
-}
-
-static void __exit driver_amplc_pci230_cleanup_module(void)
-{
-	pci_unregister_driver(&driver_amplc_pci230_pci_driver);
-	comedi_driver_unregister(&driver_amplc_pci230);
-}
-
-module_init(driver_amplc_pci230_init_module);
-module_exit(driver_amplc_pci230_cleanup_module);
-
 static int pci230_ai_rinsn(struct comedi_device *dev,
 			   struct comedi_subdevice *s, struct comedi_insn *insn,
 			   unsigned int *data);
@@ -3048,6 +2982,42 @@ static int pci230_ai_cancel(struct comedi_device *dev,
 	return 0;
 }
 
+static struct comedi_driver amplc_pci230_driver = {
+	.driver_name	= "amplc_pci230",
+	.module		= THIS_MODULE,
+	.attach		= pci230_attach,
+	.detach		= pci230_detach,
+	.board_name	= &pci230_boards[0].name,
+	.offset		= sizeof(pci230_boards[0]),
+	.num_names	= ARRAY_SIZE(pci230_boards),
+};
+
+static int __devinit amplc_pci230_pci_probe(struct pci_dev *dev,
+					    const struct pci_device_id *ent)
+{
+	return comedi_pci_auto_config(dev, &amplc_pci230_driver);
+}
+
+static void __devexit amplc_pci230_pci_remove(struct pci_dev *dev)
+{
+	comedi_pci_auto_unconfig(dev);
+}
+
+static DEFINE_PCI_DEVICE_TABLE(amplc_pci230_pci_table) = {
+	{ PCI_DEVICE(PCI_VENDOR_ID_AMPLICON, PCI_DEVICE_ID_PCI230) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_AMPLICON, PCI_DEVICE_ID_PCI260) },
+	{ 0 }
+};
+MODULE_DEVICE_TABLE(pci, amplc_pci230_pci_table);
+
+static struct pci_driver amplc_pci230_pci_driver = {
+	.name		= "amplc_pci230",
+	.id_table	= amplc_pci230_pci_table,
+	.probe		= amplc_pci230_pci_probe,
+	.remove		= __devexit_p(amplc_pci230_pci_remove)
+};
+module_comedi_pci_driver(amplc_pci230_driver, amplc_pci230_pci_driver);
+
 MODULE_AUTHOR("Comedi http://www.comedi.org");
 MODULE_DESCRIPTION("Comedi low-level driver");
 MODULE_LICENSE("GPL");
