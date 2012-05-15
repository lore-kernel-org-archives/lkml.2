Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967094Ab2EOXoX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 19:44:23 -0400
Received: from mail127.messagelabs.com ([216.82.250.115]:14999 "EHLO
	mail127.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967068Ab2EOXoV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 19:44:21 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-7.tower-127.messagelabs.com!1337125460!5623129!2
X-Originating-IP: [216.166.12.31]
X-StarScan-Version: 6.5.7; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] staging: comedi: refactor gsc_hpdi driver and use module_comedi_pci_driver
Date: Tue, 15 May 2012 16:44:14 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201205151644.15060.hartleys@visionengravers.com>
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

 drivers/staging/comedi/drivers/gsc_hpdi.c |   93 +++++++++++------------------
 1 files changed, 35 insertions(+), 58 deletions(-)

diff --git a/drivers/staging/comedi/drivers/gsc_hpdi.c b/drivers/staging/comedi/drivers/gsc_hpdi.c
index a7b9f6e..3195022 100644
--- a/drivers/staging/comedi/drivers/gsc_hpdi.c
+++ b/drivers/staging/comedi/drivers/gsc_hpdi.c
@@ -53,8 +53,6 @@ support could be added to this driver.
 #include "plx9080.h"
 #include "comedi_fc.h"
 
-static int hpdi_attach(struct comedi_device *dev, struct comedi_devconfig *it);
-static int hpdi_detach(struct comedi_device *dev);
 static void abort_dma(struct comedi_device *dev, unsigned int channel);
 static int hpdi_cmd(struct comedi_device *dev, struct comedi_subdevice *s);
 static int hpdi_cmd_test(struct comedi_device *dev, struct comedi_subdevice *s,
@@ -287,15 +285,6 @@ static const struct hpdi_board hpdi_boards[] = {
 #endif
 };
 
-static DEFINE_PCI_DEVICE_TABLE(hpdi_pci_table) = {
-	{
-	PCI_VENDOR_ID_PLX, PCI_DEVICE_ID_PLX_9080, PCI_VENDOR_ID_PLX,
-		    0x2400, 0, 0, 0}, {
-	0}
-};
-
-MODULE_DEVICE_TABLE(pci, hpdi_pci_table);
-
 static inline struct hpdi_board *board(const struct comedi_device *dev)
 {
 	return (struct hpdi_board *)dev->board_ptr;
@@ -338,51 +327,6 @@ static inline struct hpdi_private *priv(struct comedi_device *dev)
 	return dev->private;
 }
 
-static struct comedi_driver driver_hpdi = {
-	.driver_name = "gsc_hpdi",
-	.module = THIS_MODULE,
-	.attach = hpdi_attach,
-	.detach = hpdi_detach,
-};
-
-static int __devinit driver_hpdi_pci_probe(struct pci_dev *dev,
-					   const struct pci_device_id *ent)
-{
-	return comedi_pci_auto_config(dev, &driver_hpdi);
-}
-
-static void __devexit driver_hpdi_pci_remove(struct pci_dev *dev)
-{
-	comedi_pci_auto_unconfig(dev);
-}
-
-static struct pci_driver driver_hpdi_pci_driver = {
-	.id_table = hpdi_pci_table,
-	.probe = &driver_hpdi_pci_probe,
-	.remove = __devexit_p(&driver_hpdi_pci_remove)
-};
-
-static int __init driver_hpdi_init_module(void)
-{
-	int retval;
-
-	retval = comedi_driver_register(&driver_hpdi);
-	if (retval < 0)
-		return retval;
-
-	driver_hpdi_pci_driver.name = (char *)driver_hpdi.driver_name;
-	return pci_register_driver(&driver_hpdi_pci_driver);
-}
-
-static void __exit driver_hpdi_cleanup_module(void)
-{
-	pci_unregister_driver(&driver_hpdi_pci_driver);
-	comedi_driver_unregister(&driver_hpdi);
-}
-
-module_init(driver_hpdi_init_module);
-module_exit(driver_hpdi_cleanup_module);
-
 static int dio_config_insn(struct comedi_device *dev,
 			   struct comedi_subdevice *s, struct comedi_insn *insn,
 			   unsigned int *data)
@@ -645,7 +589,7 @@ static int hpdi_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	       "gsc_hpdi: found %s on bus %i, slot %i\n", board(dev)->name,
 	       pcidev->bus->number, PCI_SLOT(pcidev->devfn));
 
-	if (comedi_pci_enable(pcidev, driver_hpdi.driver_name)) {
+	if (comedi_pci_enable(pcidev, dev->driver->driver_name)) {
 		printk(KERN_WARNING
 		       " failed enable PCI device and request regions\n");
 		return -EIO;
@@ -679,7 +623,7 @@ static int hpdi_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 
 	/*  get irq */
 	if (request_irq(pcidev->irq, handle_interrupt, IRQF_SHARED,
-			driver_hpdi.driver_name, dev)) {
+			dev->driver->driver_name, dev)) {
 		printk(KERN_WARNING
 		       " unable to allocate irq %u\n", pcidev->irq);
 		return -EINVAL;
@@ -1113,6 +1057,39 @@ static int hpdi_cancel(struct comedi_device *dev, struct comedi_subdevice *s)
 	return 0;
 }
 
+static struct comedi_driver gsc_hpdi_driver = {
+	.driver_name	= "gsc_hpdi",
+	.module		= THIS_MODULE,
+	.attach		= hpdi_attach,
+	.detach		= hpdi_detach,
+};
+
+static int __devinit gsc_hpdi_pci_probe(struct pci_dev *dev,
+					const struct pci_device_id *ent)
+{
+	return comedi_pci_auto_config(dev, &gsc_hpdi_driver);
+}
+
+static void __devexit gsc_hpdi_pci_remove(struct pci_dev *dev)
+{
+	comedi_pci_auto_unconfig(dev);
+}
+
+static DEFINE_PCI_DEVICE_TABLE(gsc_hpdi_pci_table) = {
+	{ PCI_VENDOR_ID_PLX, PCI_DEVICE_ID_PLX_9080, PCI_VENDOR_ID_PLX,
+		    0x2400, 0, 0, 0},
+	{ 0 }
+};
+MODULE_DEVICE_TABLE(pci, gsc_hpdi_pci_table);
+
+static struct pci_driver gsc_hpdi_pci_driver = {
+	.name		= "gsc_hpdi",
+	.id_table	= gsc_hpdi_pci_table,
+	.probe		= gsc_hpdi_pci_probe,
+	.remove		= __devexit_p(gsc_hpdi_pci_remove)
+};
+module_comedi_pci_driver(gsc_hpdi_driver, gsc_hpdi_pci_driver);
+
 MODULE_AUTHOR("Comedi http://www.comedi.org");
 MODULE_DESCRIPTION("Comedi low-level driver");
 MODULE_LICENSE("GPL");
