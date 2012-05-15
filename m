Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758734Ab2EOUYN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 16:24:13 -0400
Received: from mail127.messagelabs.com ([216.82.250.115]:38770 "EHLO
	mail127.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966087Ab2EOUYL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 16:24:11 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-10.tower-127.messagelabs.com!1337113447!5607207!8
X-Originating-IP: [216.166.12.97]
X-StarScan-Version: 6.5.7; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] staging: comedi: refactor adv_pci1_dio driver and use module_comedi_pci_driver
Date: Tue, 15 May 2012 13:23:58 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201205151323.58471.hartleys@visionengravers.com>
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

 drivers/staging/comedi/drivers/adv_pci_dio.c |  108 +++++++++-----------------
 1 files changed, 36 insertions(+), 72 deletions(-)

diff --git a/drivers/staging/comedi/drivers/adv_pci_dio.c b/drivers/staging/comedi/drivers/adv_pci_dio.c
index 7d920fe..9d3868e 100644
--- a/drivers/staging/comedi/drivers/adv_pci_dio.c
+++ b/drivers/staging/comedi/drivers/adv_pci_dio.c
@@ -237,10 +237,6 @@ enum hw_io_access {
 
 #define OMBCMD_RETRY	0x03	/* 3 times try request before error */
 
-static int pci_dio_attach(struct comedi_device *dev,
-			  struct comedi_devconfig *it);
-static int pci_dio_detach(struct comedi_device *dev);
-
 struct diosubd_data {
 	int chans;		/*  num of chans */
 	int addr;		/*  PCI address ofset */
@@ -263,26 +259,6 @@ struct dio_boardtype {
 	enum hw_io_access io_access;
 };
 
-static DEFINE_PCI_DEVICE_TABLE(pci_dio_pci_table) = {
-	{ PCI_DEVICE(PCI_VENDOR_ID_ADVANTECH, 0x1730) },
-	{ PCI_DEVICE(PCI_VENDOR_ID_ADVANTECH, 0x1733) },
-	{ PCI_DEVICE(PCI_VENDOR_ID_ADVANTECH, 0x1734) },
-	{ PCI_DEVICE(PCI_VENDOR_ID_ADVANTECH, 0x1735) },
-	{ PCI_DEVICE(PCI_VENDOR_ID_ADVANTECH, 0x1736) },
-	{ PCI_DEVICE(PCI_VENDOR_ID_ADVANTECH, 0x1739) },
-	{ PCI_DEVICE(PCI_VENDOR_ID_ADVANTECH, 0x1750) },
-	{ PCI_DEVICE(PCI_VENDOR_ID_ADVANTECH, 0x1751) },
-	{ PCI_DEVICE(PCI_VENDOR_ID_ADVANTECH, 0x1752) },
-	{ PCI_DEVICE(PCI_VENDOR_ID_ADVANTECH, 0x1753) },
-	{ PCI_DEVICE(PCI_VENDOR_ID_ADVANTECH, 0x1754) },
-	{ PCI_DEVICE(PCI_VENDOR_ID_ADVANTECH, 0x1756) },
-	{ PCI_DEVICE(PCI_VENDOR_ID_ADVANTECH, 0x1760) },
-	{ PCI_DEVICE(PCI_VENDOR_ID_ADVANTECH, 0x1762) },
-	{ 0 }
-};
-
-MODULE_DEVICE_TABLE(pci, pci_dio_pci_table);
-
 static const struct dio_boardtype boardtypes[] = {
 	{"pci1730", PCI_VENDOR_ID_ADVANTECH, 0x1730, PCIDIO_MAINREG,
 	 TYPE_PCI1730,
@@ -406,13 +382,6 @@ static const struct dio_boardtype boardtypes[] = {
 	 IO_16b}
 };
 
-static struct comedi_driver driver_pci_dio = {
-	.driver_name = "adv_pci_dio",
-	.module = THIS_MODULE,
-	.attach = pci_dio_attach,
-	.detach = pci_dio_detach
-};
-
 struct pci_dio_private {
 	struct pci_dio_private *prev;	/*  previous private struct */
 	struct pci_dio_private *next;	/*  next private struct */
@@ -1114,9 +1083,6 @@ static int CheckAndAllocCard(struct comedi_device *dev,
 	return 1;
 }
 
-/*
-==============================================================================
-*/
 static int pci_dio_attach(struct comedi_device *dev,
 			  struct comedi_devconfig *it)
 {
@@ -1160,7 +1126,7 @@ static int pci_dio_attach(struct comedi_device *dev,
 		return -EIO;
 	}
 
-	if (comedi_pci_enable(pcidev, driver_pci_dio.driver_name)) {
+	if (comedi_pci_enable(pcidev, dev->driver->driver_name)) {
 		dev_err(dev->hw_dev, "Error: Can't enable PCI device and request regions!\n");
 		return -EIO;
 	}
@@ -1244,9 +1210,6 @@ static int pci_dio_attach(struct comedi_device *dev,
 	return 0;
 }
 
-/*
-==============================================================================
-*/
 static int pci_dio_detach(struct comedi_device *dev)
 {
 	int i, j;
@@ -1311,49 +1274,50 @@ static int pci_dio_detach(struct comedi_device *dev)
 	return 0;
 }
 
-/*
-==============================================================================
-*/
-static int __devinit driver_pci_dio_pci_probe(struct pci_dev *dev,
-					      const struct pci_device_id *ent)
+static struct comedi_driver adv_pci_dio_driver = {
+	.driver_name	= "adv_pci_dio",
+	.module		= THIS_MODULE,
+	.attach		= pci_dio_attach,
+	.detach		= pci_dio_detach
+};
+
+static int __devinit adv_pci_dio_pci_probe(struct pci_dev *dev,
+					   const struct pci_device_id *ent)
 {
-	return comedi_pci_auto_config(dev, &driver_pci_dio);
+	return comedi_pci_auto_config(dev, &adv_pci_dio_driver);
 }
 
-static void __devexit driver_pci_dio_pci_remove(struct pci_dev *dev)
+static void __devexit adv_pci_dio_pci_remove(struct pci_dev *dev)
 {
 	comedi_pci_auto_unconfig(dev);
 }
 
-static struct pci_driver driver_pci_dio_pci_driver = {
-	.id_table = pci_dio_pci_table,
-	.probe = &driver_pci_dio_pci_probe,
-	.remove = __devexit_p(&driver_pci_dio_pci_remove)
+static DEFINE_PCI_DEVICE_TABLE(adv_pci_dio_pci_table) = {
+	{ PCI_DEVICE(PCI_VENDOR_ID_ADVANTECH, 0x1730) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_ADVANTECH, 0x1733) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_ADVANTECH, 0x1734) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_ADVANTECH, 0x1735) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_ADVANTECH, 0x1736) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_ADVANTECH, 0x1739) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_ADVANTECH, 0x1750) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_ADVANTECH, 0x1751) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_ADVANTECH, 0x1752) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_ADVANTECH, 0x1753) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_ADVANTECH, 0x1754) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_ADVANTECH, 0x1756) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_ADVANTECH, 0x1760) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_ADVANTECH, 0x1762) },
+	{ 0 }
 };
+MODULE_DEVICE_TABLE(pci, adv_pci_dio_pci_table);
 
-static int __init driver_pci_dio_init_module(void)
-{
-	int retval;
-
-	retval = comedi_driver_register(&driver_pci_dio);
-	if (retval < 0)
-		return retval;
-
-	driver_pci_dio_pci_driver.name = (char *)driver_pci_dio.driver_name;
-	return pci_register_driver(&driver_pci_dio_pci_driver);
-}
-
-static void __exit driver_pci_dio_cleanup_module(void)
-{
-	pci_unregister_driver(&driver_pci_dio_pci_driver);
-	comedi_driver_unregister(&driver_pci_dio);
-}
-
-module_init(driver_pci_dio_init_module);
-module_exit(driver_pci_dio_cleanup_module);
-/*
-==============================================================================
-*/
+static struct pci_driver adv_pci_dio_pci_driver = {
+	.name		= "adv_pci_dio",
+	.id_table	= adv_pci_dio_pci_table,
+	.probe		= adv_pci_dio_pci_probe,
+	.remove		= __devexit_p(adv_pci_dio_pci_remove),
+};
+module_comedi_pci_driver(adv_pci_dio_driver, adv_pci_dio_pci_driver);
 
 MODULE_AUTHOR("Comedi http://www.comedi.org");
 MODULE_DESCRIPTION("Comedi low-level driver");
