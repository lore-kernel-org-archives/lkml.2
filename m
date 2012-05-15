Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967014Ab2EOVck (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 17:32:40 -0400
Received: from mail127.messagelabs.com ([216.82.250.115]:14528 "EHLO
	mail127.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966840Ab2EOVci (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 17:32:38 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-12.tower-127.messagelabs.com!1337117542!5616539!17
X-Originating-IP: [216.166.12.69]
X-StarScan-Version: 6.5.7; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] staging: comedi: refactor cb_pcidas64 driver and use module_comedi_pci_driver
Date: Tue, 15 May 2012 14:32:21 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201205151432.21818.hartleys@visionengravers.com>
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

 drivers/staging/comedi/drivers/cb_pcidas64.c |  130 ++++++++++----------------
 1 files changed, 51 insertions(+), 79 deletions(-)

diff --git a/drivers/staging/comedi/drivers/cb_pcidas64.c b/drivers/staging/comedi/drivers/cb_pcidas64.c
index ff79fd4..bea5120 100644
--- a/drivers/staging/comedi/drivers/cb_pcidas64.c
+++ b/drivers/staging/comedi/drivers/cb_pcidas64.c
@@ -1026,31 +1026,6 @@ static const struct pcidas64_board pcidas64_boards[] = {
 #endif
 };
 
-static DEFINE_PCI_DEVICE_TABLE(pcidas64_pci_table) = {
-	{ PCI_DEVICE(PCI_VENDOR_ID_COMPUTERBOARDS, 0x001d) },
-	{ PCI_DEVICE(PCI_VENDOR_ID_COMPUTERBOARDS, 0x001e) },
-	{ PCI_DEVICE(PCI_VENDOR_ID_COMPUTERBOARDS, 0x0035) },
-	{ PCI_DEVICE(PCI_VENDOR_ID_COMPUTERBOARDS, 0x0036) },
-	{ PCI_DEVICE(PCI_VENDOR_ID_COMPUTERBOARDS, 0x0037) },
-	{ PCI_DEVICE(PCI_VENDOR_ID_COMPUTERBOARDS, 0x0052) },
-	{ PCI_DEVICE(PCI_VENDOR_ID_COMPUTERBOARDS, 0x005d) },
-	{ PCI_DEVICE(PCI_VENDOR_ID_COMPUTERBOARDS, 0x005e) },
-	{ PCI_DEVICE(PCI_VENDOR_ID_COMPUTERBOARDS, 0x005f) },
-	{ PCI_DEVICE(PCI_VENDOR_ID_COMPUTERBOARDS, 0x0061) },
-	{ PCI_DEVICE(PCI_VENDOR_ID_COMPUTERBOARDS, 0x0062) },
-	{ PCI_DEVICE(PCI_VENDOR_ID_COMPUTERBOARDS, 0x0063) },
-	{ PCI_DEVICE(PCI_VENDOR_ID_COMPUTERBOARDS, 0x0064) },
-	{ PCI_DEVICE(PCI_VENDOR_ID_COMPUTERBOARDS, 0x0066) },
-	{ PCI_DEVICE(PCI_VENDOR_ID_COMPUTERBOARDS, 0x0067) },
-	{ PCI_DEVICE(PCI_VENDOR_ID_COMPUTERBOARDS, 0x0068) },
-	{ PCI_DEVICE(PCI_VENDOR_ID_COMPUTERBOARDS, 0x006f) },
-	{ PCI_DEVICE(PCI_VENDOR_ID_COMPUTERBOARDS, 0x0078) },
-	{ PCI_DEVICE(PCI_VENDOR_ID_COMPUTERBOARDS, 0x0079) },
-	{ 0 }
-};
-
-MODULE_DEVICE_TABLE(pci, pcidas64_pci_table);
-
 static inline struct pcidas64_board *board(const struct comedi_device *dev)
 {
 	return (struct pcidas64_board *)dev->board_ptr;
@@ -1127,21 +1102,6 @@ static inline struct pcidas64_private *priv(struct comedi_device *dev)
 	return dev->private;
 }
 
-/*
- * The comedi_driver structure tells the Comedi core module
- * which functions to call to configure/deconfigure (attach/detach)
- * the board, and also about the kernel module that contains
- * the device code.
- */
-static int attach(struct comedi_device *dev, struct comedi_devconfig *it);
-static int detach(struct comedi_device *dev);
-static struct comedi_driver driver_cb_pcidas = {
-	.driver_name = "cb_pcidas64",
-	.module = THIS_MODULE,
-	.attach = attach,
-	.detach = detach,
-};
-
 static int ai_rinsn(struct comedi_device *dev, struct comedi_subdevice *s,
 		    struct comedi_insn *insn, unsigned int *data);
 static int ai_config_insn(struct comedi_device *dev, struct comedi_subdevice *s,
@@ -1216,44 +1176,6 @@ static unsigned int get_ao_divisor(unsigned int ns, unsigned int flags);
 static void load_ao_dma(struct comedi_device *dev,
 			const struct comedi_cmd *cmd);
 
-static int __devinit driver_cb_pcidas_pci_probe(struct pci_dev *dev,
-						const struct pci_device_id *ent)
-{
-	return comedi_pci_auto_config(dev, &driver_cb_pcidas);
-}
-
-static void __devexit driver_cb_pcidas_pci_remove(struct pci_dev *dev)
-{
-	comedi_pci_auto_unconfig(dev);
-}
-
-static struct pci_driver driver_cb_pcidas_pci_driver = {
-	.id_table = pcidas64_pci_table,
-	.probe = &driver_cb_pcidas_pci_probe,
-	.remove = __devexit_p(&driver_cb_pcidas_pci_remove)
-};
-
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
-
 static unsigned int ai_range_bits_6xxx(const struct comedi_device *dev,
 				       unsigned int range_index)
 {
@@ -1781,7 +1703,7 @@ static int attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	dev_dbg(dev->hw_dev, "Found %s on bus %i, slot %i\n", board(dev)->name,
 		pcidev->bus->number, PCI_SLOT(pcidev->devfn));
 
-	if (comedi_pci_enable(pcidev, driver_cb_pcidas.driver_name)) {
+	if (comedi_pci_enable(pcidev, dev->driver->driver_name)) {
 		dev_warn(dev->hw_dev, "failed to enable PCI device and request regions\n");
 		return -EIO;
 	}
@@ -4315,6 +4237,56 @@ static void i2c_write(struct comedi_device *dev, unsigned int address,
 	i2c_stop(dev);
 }
 
+static struct comedi_driver cb_pcidas64_driver = {
+	.driver_name	= "cb_pcidas64",
+	.module		= THIS_MODULE,
+	.attach		= attach,
+	.detach		= detach,
+};
+
+static int __devinit cb_pcidas64_pci_probe(struct pci_dev *dev,
+					   const struct pci_device_id *ent)
+{
+	return comedi_pci_auto_config(dev, &cb_pcidas64_driver);
+}
+
+static void __devexit cb_pcidas64_pci_remove(struct pci_dev *dev)
+{
+	comedi_pci_auto_unconfig(dev);
+}
+
+static DEFINE_PCI_DEVICE_TABLE(cb_pcidas64_pci_table) = {
+	{ PCI_DEVICE(PCI_VENDOR_ID_COMPUTERBOARDS, 0x001d) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_COMPUTERBOARDS, 0x001e) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_COMPUTERBOARDS, 0x0035) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_COMPUTERBOARDS, 0x0036) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_COMPUTERBOARDS, 0x0037) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_COMPUTERBOARDS, 0x0052) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_COMPUTERBOARDS, 0x005d) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_COMPUTERBOARDS, 0x005e) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_COMPUTERBOARDS, 0x005f) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_COMPUTERBOARDS, 0x0061) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_COMPUTERBOARDS, 0x0062) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_COMPUTERBOARDS, 0x0063) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_COMPUTERBOARDS, 0x0064) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_COMPUTERBOARDS, 0x0066) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_COMPUTERBOARDS, 0x0067) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_COMPUTERBOARDS, 0x0068) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_COMPUTERBOARDS, 0x006f) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_COMPUTERBOARDS, 0x0078) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_COMPUTERBOARDS, 0x0079) },
+	{ 0 }
+};
+MODULE_DEVICE_TABLE(pci, cb_pcidas64_pci_table);
+
+static struct pci_driver cb_pcidas64_pci_driver = {
+	.name		= "cb_pcidas64",
+	.id_table	= cb_pcidas64_pci_table,
+	.probe		= cb_pcidas64_pci_probe,
+	.remove		= __devexit_p(cb_pcidas64_pci_remove),
+};
+module_comedi_pci_driver(cb_pcidas64_driver, cb_pcidas64_pci_driver);
+
 MODULE_AUTHOR("Comedi http://www.comedi.org");
 MODULE_DESCRIPTION("Comedi low-level driver");
 MODULE_LICENSE("GPL");
