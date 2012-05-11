Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761259Ab2EKXwG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 19:52:06 -0400
Received: from mail160.messagelabs.com ([216.82.253.99]:20631 "EHLO
	mail160.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761221Ab2EKXwB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 19:52:01 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-10.tower-160.messagelabs.com!1336780320!3506407!2
X-Originating-IP: [216.166.12.178]
X-StarScan-Version: 6.5.7; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] staging: comedi: refactor ni_pcimio driver and use module_comedi_pci_driver
Date: Fri, 11 May 2012 16:51:56 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201205111651.56541.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the module_init/module_exit routines and the associated
struct comedi_drive and struct pci_driver to the end of the
source. This is more typical of how other drivers are written and
removes the need for the forward declarations.

Convert the driver to use the module_comedi_pci_driver() macro
which makes the code smaller and a bit simpler.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---

This is only a partial refactor. The attach/detach routines still need
to be moved to remove the remaining forward declarations.

 drivers/staging/comedi/drivers/ni_pcimio.c |  192 ++++++++++++----------------
 1 files changed, 84 insertions(+), 108 deletions(-)

diff --git a/drivers/staging/comedi/drivers/ni_pcimio.c b/drivers/staging/comedi/drivers/ni_pcimio.c
index 1065b2c..9d0a08f 100644
--- a/drivers/staging/comedi/drivers/ni_pcimio.c
+++ b/drivers/staging/comedi/drivers/ni_pcimio.c
@@ -129,66 +129,6 @@ Bugs:
 
 #define DRV_NAME "ni_pcimio"
 
-/* The following two tables must be in the same order */
-static DEFINE_PCI_DEVICE_TABLE(ni_pci_table) = {
-	{PCI_DEVICE(PCI_VENDOR_ID_NI, 0x0162)},
-	{PCI_DEVICE(PCI_VENDOR_ID_NI, 0x1170)},
-	{PCI_DEVICE(PCI_VENDOR_ID_NI, 0x1180)},
-	{PCI_DEVICE(PCI_VENDOR_ID_NI, 0x1190)},
-	{PCI_DEVICE(PCI_VENDOR_ID_NI, 0x11b0)},
-	{PCI_DEVICE(PCI_VENDOR_ID_NI, 0x11c0)},
-	{PCI_DEVICE(PCI_VENDOR_ID_NI, 0x11d0)},
-	{PCI_DEVICE(PCI_VENDOR_ID_NI, 0x1270)},
-	{PCI_DEVICE(PCI_VENDOR_ID_NI, 0x1330)},
-	{PCI_DEVICE(PCI_VENDOR_ID_NI, 0x1340)},
-	{PCI_DEVICE(PCI_VENDOR_ID_NI, 0x1350)},
-	{PCI_DEVICE(PCI_VENDOR_ID_NI, 0x14e0)},
-	{PCI_DEVICE(PCI_VENDOR_ID_NI, 0x14f0)},
-	{PCI_DEVICE(PCI_VENDOR_ID_NI, 0x1580)},
-	{PCI_DEVICE(PCI_VENDOR_ID_NI, 0x15b0)},
-	{PCI_DEVICE(PCI_VENDOR_ID_NI, 0x1880)},
-	{PCI_DEVICE(PCI_VENDOR_ID_NI, 0x1870)},
-	{PCI_DEVICE(PCI_VENDOR_ID_NI, 0x18b0)},
-	{PCI_DEVICE(PCI_VENDOR_ID_NI, 0x18c0)},
-	{PCI_DEVICE(PCI_VENDOR_ID_NI, 0x2410)},
-	{PCI_DEVICE(PCI_VENDOR_ID_NI, 0x2420)},
-	{PCI_DEVICE(PCI_VENDOR_ID_NI, 0x2430)},
-	{PCI_DEVICE(PCI_VENDOR_ID_NI, 0x2890)},
-	{PCI_DEVICE(PCI_VENDOR_ID_NI, 0x28c0)},
-	{PCI_DEVICE(PCI_VENDOR_ID_NI, 0x2a60)},
-	{PCI_DEVICE(PCI_VENDOR_ID_NI, 0x2a70)},
-	{PCI_DEVICE(PCI_VENDOR_ID_NI, 0x2a80)},
-	{PCI_DEVICE(PCI_VENDOR_ID_NI, 0x2ab0)},
-	{PCI_DEVICE(PCI_VENDOR_ID_NI, 0x2b80)},
-	{PCI_DEVICE(PCI_VENDOR_ID_NI, 0x2b90)},
-	{PCI_DEVICE(PCI_VENDOR_ID_NI, 0x2c80)},
-	{PCI_DEVICE(PCI_VENDOR_ID_NI, 0x2ca0)},
-	{PCI_DEVICE(PCI_VENDOR_ID_NI, 0x70aa)},
-	{PCI_DEVICE(PCI_VENDOR_ID_NI, 0x70ab)},
-	{PCI_DEVICE(PCI_VENDOR_ID_NI, 0x70ac)},
-	{PCI_DEVICE(PCI_VENDOR_ID_NI, 0x70af)},
-	{PCI_DEVICE(PCI_VENDOR_ID_NI, 0x70b0)},
-	{PCI_DEVICE(PCI_VENDOR_ID_NI, 0x70b4)},
-	{PCI_DEVICE(PCI_VENDOR_ID_NI, 0x70b6)},
-	{PCI_DEVICE(PCI_VENDOR_ID_NI, 0x70b7)},
-	{PCI_DEVICE(PCI_VENDOR_ID_NI, 0x70b8)},
-	{PCI_DEVICE(PCI_VENDOR_ID_NI, 0x70bc)},
-	{PCI_DEVICE(PCI_VENDOR_ID_NI, 0x70bd)},
-	{PCI_DEVICE(PCI_VENDOR_ID_NI, 0x70bf)},
-	{PCI_DEVICE(PCI_VENDOR_ID_NI, 0x70c0)},
-	{PCI_DEVICE(PCI_VENDOR_ID_NI, 0x70f2)},
-	{PCI_DEVICE(PCI_VENDOR_ID_NI, 0x710d)},
-	{PCI_DEVICE(PCI_VENDOR_ID_NI, 0x716c)},
-	{PCI_DEVICE(PCI_VENDOR_ID_NI, 0x716d)},
-	{PCI_DEVICE(PCI_VENDOR_ID_NI, 0x717f)},
-	{PCI_DEVICE(PCI_VENDOR_ID_NI, 0x71bc)},
-	{PCI_DEVICE(PCI_VENDOR_ID_NI, 0x717d)},
-	{PCI_DEVICE(PCI_VENDOR_ID_NI, 0x72e8)},
-	{0}
-};
-
-MODULE_DEVICE_TABLE(pci, ni_pci_table);
-
 /* These are not all the possible ao ranges for 628x boards.
  They can do OFFSET +- REFERENCE where OFFSET can be
  0V, 5V, APFI<0,1>, or AO<0...3> and RANGE can
@@ -1250,54 +1190,6 @@ static const struct ni_board_struct ni_boards[] = {
 
 #define n_pcimio_boards ARRAY_SIZE(ni_boards)
 
-static int pcimio_attach(struct comedi_device *dev,
-			 struct comedi_devconfig *it);
-static int pcimio_detach(struct comedi_device *dev);
-static struct comedi_driver driver_pcimio = {
-	.driver_name = DRV_NAME,
-	.module = THIS_MODULE,
-	.attach = pcimio_attach,
-	.detach = pcimio_detach,
-};
-
-static int __devinit driver_pcimio_pci_probe(struct pci_dev *dev,
-					     const struct pci_device_id *ent)
-{
-	return comedi_pci_auto_config(dev, &driver_pcimio);
-}
-
-static void __devexit driver_pcimio_pci_remove(struct pci_dev *dev)
-{
-	comedi_pci_auto_unconfig(dev);
-}
-
-static struct pci_driver driver_pcimio_pci_driver = {
-	.id_table = ni_pci_table,
-	.probe = &driver_pcimio_pci_probe,
-	.remove = __devexit_p(&driver_pcimio_pci_remove)
-};
-
-static int __init driver_pcimio_init_module(void)
-{
-	int retval;
-
-	retval = comedi_driver_register(&driver_pcimio);
-	if (retval < 0)
-		return retval;
-
-	driver_pcimio_pci_driver.name = (char *)driver_pcimio.driver_name;
-	return pci_register_driver(&driver_pcimio_pci_driver);
-}
-
-static void __exit driver_pcimio_cleanup_module(void)
-{
-	pci_unregister_driver(&driver_pcimio_pci_driver);
-	comedi_driver_unregister(&driver_pcimio);
-}
-
-module_init(driver_pcimio_init_module);
-module_exit(driver_pcimio_cleanup_module);
-
 struct ni_private {
 NI_PRIVATE_COMMON};
 #define devpriv ((struct ni_private *)dev->private)
@@ -1874,6 +1766,90 @@ static int pcimio_dio_change(struct comedi_device *dev,
 	return 0;
 }
 
+static struct comedi_driver ni_pcimio_driver = {
+	.driver_name	= "ni_pcimio",
+	.module		= THIS_MODULE,
+	.attach		= pcimio_attach,
+	.detach		= pcimio_detach,
+};
+
+static int __devinit ni_pcimio_pci_probe(struct pci_dev *dev,
+					 const struct pci_device_id *ent)
+{
+	return comedi_pci_auto_config(dev, &ni_pcimio_driver);
+}
+
+static void __devexit ni_pcimio_pci_remove(struct pci_dev *dev)
+{
+	comedi_pci_auto_unconfig(dev);
+}
+
+static DEFINE_PCI_DEVICE_TABLE(ni_pcimio_pci_table) = {
+	{ PCI_DEVICE(PCI_VENDOR_ID_NI, 0x0162) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_NI, 0x1170) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_NI, 0x1180) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_NI, 0x1190) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_NI, 0x11b0) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_NI, 0x11c0) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_NI, 0x11d0) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_NI, 0x1270) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_NI, 0x1330) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_NI, 0x1340) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_NI, 0x1350) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_NI, 0x14e0) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_NI, 0x14f0) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_NI, 0x1580) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_NI, 0x15b0) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_NI, 0x1880) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_NI, 0x1870) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_NI, 0x18b0) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_NI, 0x18c0) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_NI, 0x2410) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_NI, 0x2420) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_NI, 0x2430) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_NI, 0x2890) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_NI, 0x28c0) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_NI, 0x2a60) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_NI, 0x2a70) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_NI, 0x2a80) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_NI, 0x2ab0) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_NI, 0x2b80) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_NI, 0x2b90) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_NI, 0x2c80) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_NI, 0x2ca0) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_NI, 0x70aa) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_NI, 0x70ab) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_NI, 0x70ac) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_NI, 0x70af) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_NI, 0x70b0) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_NI, 0x70b4) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_NI, 0x70b6) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_NI, 0x70b7) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_NI, 0x70b8) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_NI, 0x70bc) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_NI, 0x70bd) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_NI, 0x70bf) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_NI, 0x70c0) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_NI, 0x70f2) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_NI, 0x710d) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_NI, 0x716c) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_NI, 0x716d) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_NI, 0x717f) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_NI, 0x71bc) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_NI, 0x717d) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_NI, 0x72e8) },
+	{ 0 }
+};
+MODULE_DEVICE_TABLE(pci, ni_pcimio_pci_table);
+
+static struct pci_driver ni_pcimio_pci_driver = {
+	.name		= "ni_pcimio",
+	.id_table	= ni_pcimio_pci_table,
+	.probe		= ni_pcimio_pci_probe,
+	.remove		= __devexit_p(ni_pcimio_pci_remove)
+};
+module_comedi_pci_driver(ni_pcimio_driver, ni_pcimio_pci_driver)
+
 MODULE_AUTHOR("Comedi http://www.comedi.org");
 MODULE_DESCRIPTION("Comedi low-level driver");
 MODULE_LICENSE("GPL");
