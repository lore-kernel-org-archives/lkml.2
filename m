Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965627Ab2EOWKn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 18:10:43 -0400
Received: from mail160.messagelabs.com ([216.82.253.99]:13032 "EHLO
	mail160.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932881Ab2EOWKl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 18:10:41 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-4.tower-160.messagelabs.com!1337119840!5613301!1
X-Originating-IP: [216.166.12.180]
X-StarScan-Version: 6.5.7; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] staging: comedi: refactor cb_pcimdda driver and use module_comedi_pci_driver
Date: Tue, 15 May 2012 15:10:25 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201205151510.26320.hartleys@visionengravers.com>
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

 drivers/staging/comedi/drivers/cb_pcimdda.c |  109 +++++++++-----------------
 1 files changed, 38 insertions(+), 71 deletions(-)

diff --git a/drivers/staging/comedi/drivers/cb_pcimdda.c b/drivers/staging/comedi/drivers/cb_pcimdda.c
index 8d1081e..857d0c3 100644
--- a/drivers/staging/comedi/drivers/cb_pcimdda.c
+++ b/drivers/staging/comedi/drivers/cb_pcimdda.c
@@ -140,17 +140,6 @@ static const struct board_struct boards[] = {
 #define REG_SZ (thisboard->reg_sz)
 #define REGS_BADRINDEX (thisboard->regs_badrindex)
 
-/* This is used by modprobe to translate PCI IDs to drivers.  Should
- * only be used for PCI and ISA-PnP devices */
-/* Please add your PCI vendor ID to comedidev.h, and it will be forwarded
- * upstream. */
-static DEFINE_PCI_DEVICE_TABLE(pci_table) = {
-	{ PCI_DEVICE(PCI_VENDOR_ID_COMPUTERBOARDS, PCI_ID_PCIM_DDA06_16) },
-	{0}
-};
-
-MODULE_DEVICE_TABLE(pci, pci_table);
-
 /*
  * this structure is for data unique to this hardware driver.  If
  * several hardware drivers keep similar information in this structure,
@@ -177,66 +166,6 @@ struct board_private_struct {
  */
 #define devpriv ((struct board_private_struct *)dev->private)
 
-/*
- * The struct comedi_driver structure tells the Comedi core module
- * which functions to call to configure/deconfigure (attach/detach)
- * the board, and also about the kernel module that contains
- * the device code.
- */
-static int attach(struct comedi_device *dev, struct comedi_devconfig *it);
-static int detach(struct comedi_device *dev);
-static struct comedi_driver cb_pcimdda_driver = {
-	.driver_name = "cb_pcimdda",
-	.module = THIS_MODULE,
-	.attach = attach,
-	.detach = detach,
-};
-
-MODULE_AUTHOR("Calin A. Culianu <calin@rtlab.org>");
-MODULE_DESCRIPTION("Comedi low-level driver for the Computerboards PCIM-DDA "
-		   "series.  Currently only supports PCIM-DDA06-16 (which "
-		   "also happens to be the only board in this series. :) ) ");
-MODULE_LICENSE("GPL");
-static int __devinit cb_pcimdda_driver_pci_probe(struct pci_dev *dev,
-						 const struct pci_device_id
-						 *ent)
-{
-	return comedi_pci_auto_config(dev, &cb_pcimdda_driver);
-}
-
-static void __devexit cb_pcimdda_driver_pci_remove(struct pci_dev *dev)
-{
-	comedi_pci_auto_unconfig(dev);
-}
-
-static struct pci_driver cb_pcimdda_driver_pci_driver = {
-	.id_table = pci_table,
-	.probe = &cb_pcimdda_driver_pci_probe,
-	.remove = __devexit_p(&cb_pcimdda_driver_pci_remove)
-};
-
-static int __init cb_pcimdda_driver_init_module(void)
-{
-	int retval;
-
-	retval = comedi_driver_register(&cb_pcimdda_driver);
-	if (retval < 0)
-		return retval;
-
-	cb_pcimdda_driver_pci_driver.name =
-	    (char *)cb_pcimdda_driver.driver_name;
-	return pci_register_driver(&cb_pcimdda_driver_pci_driver);
-}
-
-static void __exit cb_pcimdda_driver_cleanup_module(void)
-{
-	pci_unregister_driver(&cb_pcimdda_driver_pci_driver);
-	comedi_driver_unregister(&cb_pcimdda_driver);
-}
-
-module_init(cb_pcimdda_driver_init_module);
-module_exit(cb_pcimdda_driver_cleanup_module);
-
 static int ao_winsn(struct comedi_device *dev, struct comedi_subdevice *s,
 		    struct comedi_insn *insn, unsigned int *data);
 static int ao_rinsn(struct comedi_device *dev, struct comedi_subdevice *s,
@@ -515,3 +444,41 @@ static int probe(struct comedi_device *dev, const struct comedi_devconfig *it)
 	       "card found at the requested position\n");
 	return -ENODEV;
 }
+
+static struct comedi_driver cb_pcimdda_driver = {
+	.driver_name	= "cb_pcimdda",
+	.module		= THIS_MODULE,
+	.attach		= attach,
+	.detach		= detach,
+};
+
+static int __devinit cb_pcimdda_pci_probe(struct pci_dev *dev,
+					  const struct pci_device_id *ent)
+{
+	return comedi_pci_auto_config(dev, &cb_pcimdda_driver);
+}
+
+static void __devexit cb_pcimdda_pci_remove(struct pci_dev *dev)
+{
+	comedi_pci_auto_unconfig(dev);
+}
+
+static DEFINE_PCI_DEVICE_TABLE(cb_pcimdda_pci_table) = {
+	{ PCI_DEVICE(PCI_VENDOR_ID_COMPUTERBOARDS, PCI_ID_PCIM_DDA06_16) },
+	{ 0 }
+};
+MODULE_DEVICE_TABLE(pci, cb_pcimdda_pci_table);
+
+static struct pci_driver cb_pcimdda_driver_pci_driver = {
+	.name		= "cb_pcimdda",
+	.id_table	= cb_pcimdda_pci_table,
+	.probe		= cb_pcimdda_pci_probe,
+	.remove		= __devexit_p(cb_pcimdda_pci_remove),
+};
+module_comedi_pci_driver(cb_pcimdda_driver, cb_pcimdda_driver_pci_driver);
+
+MODULE_AUTHOR("Calin A. Culianu <calin@rtlab.org>");
+MODULE_DESCRIPTION("Comedi low-level driver for the Computerboards PCIM-DDA "
+		   "series.  Currently only supports PCIM-DDA06-16 (which "
+		   "also happens to be the only board in this series. :) ) ");
+MODULE_LICENSE("GPL");
