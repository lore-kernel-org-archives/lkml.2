Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933178Ab2EOVxk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 17:53:40 -0400
Received: from mail132.messagelabs.com ([216.82.242.115]:11813 "EHLO
	mail132.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932839Ab2EOVxj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 17:53:39 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-10.tower-132.messagelabs.com!1337118811!11728316!4
X-Originating-IP: [216.166.12.97]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] staging: comedi: refactor cb_pcidda driver and use module_comedi_pci_driver
Date: Tue, 15 May 2012 14:53:29 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201205151453.29988.hartleys@visionengravers.com>
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

 drivers/staging/comedi/drivers/cb_pcidda.c |   87 +++++++++-------------------
 1 files changed, 27 insertions(+), 60 deletions(-)

diff --git a/drivers/staging/comedi/drivers/cb_pcidda.c b/drivers/staging/comedi/drivers/cb_pcidda.c
index 38efb4a..31b21aa 100644
--- a/drivers/staging/comedi/drivers/cb_pcidda.c
+++ b/drivers/staging/comedi/drivers/cb_pcidda.c
@@ -204,18 +204,6 @@ static const struct cb_pcidda_board cb_pcidda_boards[] = {
 	 },
 };
 
-static DEFINE_PCI_DEVICE_TABLE(cb_pcidda_pci_table) = {
-	{ PCI_DEVICE(PCI_VENDOR_ID_CB, 0x0020) },
-	{ PCI_DEVICE(PCI_VENDOR_ID_CB, 0x0021) },
-	{ PCI_DEVICE(PCI_VENDOR_ID_CB, 0x0022) },
-	{ PCI_DEVICE(PCI_VENDOR_ID_CB, 0x0023) },
-	{ PCI_DEVICE(PCI_VENDOR_ID_CB, 0x0024) },
-	{ PCI_DEVICE(PCI_VENDOR_ID_CB, 0x0025) },
-	{ 0 }
-};
-
-MODULE_DEVICE_TABLE(pci, cb_pcidda_pci_table);
-
 /*
  * Useful for shorthand access to the particular board structure
  */
@@ -252,9 +240,6 @@ struct cb_pcidda_private {
  */
 #define devpriv ((struct cb_pcidda_private *)dev->private)
 
-static int cb_pcidda_attach(struct comedi_device *dev,
-			    struct comedi_devconfig *it);
-static int cb_pcidda_detach(struct comedi_device *dev);
 /* static int cb_pcidda_ai_rinsn(struct comedi_device *dev,struct comedi_subdevice *s,struct comedi_insn *insn,unsigned int *data); */
 static int cb_pcidda_ao_winsn(struct comedi_device *dev,
 			      struct comedi_subdevice *s,
@@ -273,19 +258,6 @@ static void cb_pcidda_calibrate(struct comedi_device *dev, unsigned int channel,
 				unsigned int range);
 
 /*
- * The struct comedi_driver structure tells the Comedi core module
- * which functions to call to configure/deconfigure (attach/detach)
- * the board, and also about the kernel module that contains
- * the device code.
- */
-static struct comedi_driver driver_cb_pcidda = {
-	.driver_name = "cb_pcidda",
-	.module = THIS_MODULE,
-	.attach = cb_pcidda_attach,
-	.detach = cb_pcidda_detach,
-};
-
-/*
  * Attach is called by the Comedi core to configure the driver
  * for a particular board.
  */
@@ -871,47 +843,42 @@ static void cb_pcidda_calibrate(struct comedi_device *dev, unsigned int channel,
 			       fine_gain_channel(channel), fine_gain);
 }
 
-/*
- * A convenient macro that defines init_module() and cleanup_module(),
- * as necessary.
- */
-static int __devinit driver_cb_pcidda_pci_probe(struct pci_dev *dev,
-						const struct pci_device_id *ent)
+static struct comedi_driver cb_pcidda_driver = {
+	.driver_name	= "cb_pcidda",
+	.module		= THIS_MODULE,
+	.attach		= cb_pcidda_attach,
+	.detach		= cb_pcidda_detach,
+};
+
+static int __devinit cb_pcidda_pci_probe(struct pci_dev *dev,
+					 const struct pci_device_id *ent)
 {
-	return comedi_pci_auto_config(dev, &driver_cb_pcidda);
+	return comedi_pci_auto_config(dev, &cb_pcidda_driver);
 }
 
-static void __devexit driver_cb_pcidda_pci_remove(struct pci_dev *dev)
+static void __devexit cb_pcidda_pci_remove(struct pci_dev *dev)
 {
 	comedi_pci_auto_unconfig(dev);
 }
 
-static struct pci_driver driver_cb_pcidda_pci_driver = {
-	.id_table = cb_pcidda_pci_table,
-	.probe = &driver_cb_pcidda_pci_probe,
-	.remove = __devexit_p(&driver_cb_pcidda_pci_remove)
+static DEFINE_PCI_DEVICE_TABLE(cb_pcidda_pci_table) = {
+	{ PCI_DEVICE(PCI_VENDOR_ID_CB, 0x0020) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_CB, 0x0021) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_CB, 0x0022) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_CB, 0x0023) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_CB, 0x0024) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_CB, 0x0025) },
+	{ 0 }
 };
+MODULE_DEVICE_TABLE(pci, cb_pcidda_pci_table);
 
-static int __init driver_cb_pcidda_init_module(void)
-{
-	int retval;
-
-	retval = comedi_driver_register(&driver_cb_pcidda);
-	if (retval < 0)
-		return retval;
-
-	driver_cb_pcidda_pci_driver.name = (char *)driver_cb_pcidda.driver_name;
-	return pci_register_driver(&driver_cb_pcidda_pci_driver);
-}
-
-static void __exit driver_cb_pcidda_cleanup_module(void)
-{
-	pci_unregister_driver(&driver_cb_pcidda_pci_driver);
-	comedi_driver_unregister(&driver_cb_pcidda);
-}
-
-module_init(driver_cb_pcidda_init_module);
-module_exit(driver_cb_pcidda_cleanup_module);
+static struct pci_driver cb_pcidda_pci_driver = {
+	.name		= "cb_pcidda",
+	.id_table	= cb_pcidda_pci_table,
+	.probe		= cb_pcidda_pci_probe,
+	.remove		= __devexit_p(cb_pcidda_pci_remove),
+};
+module_comedi_pci_driver(cb_pcidda_driver, cb_pcidda_pci_driver);
 
 MODULE_AUTHOR("Comedi http://www.comedi.org");
 MODULE_DESCRIPTION("Comedi low-level driver");
