Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755452Ab2DWWYm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 18:24:42 -0400
Received: from mail160.messagelabs.com ([216.82.253.99]:11637 "EHLO
	mail160.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751819Ab2DWWYl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 18:24:41 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-15.tower-160.messagelabs.com!1335219872!4586399!4
X-Originating-IP: [216.166.12.180]
X-StarScan-Version: 6.5.7; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] staging: comedi: refactor adl_pci7296 driver to remove forward declarations
Date: Mon, 23 Apr 2012 15:24:24 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201204231524.25318.hartleys@visionengravers.com>
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

diff --git a/drivers/staging/comedi/drivers/adl_pci7296.c b/drivers/staging/comedi/drivers/adl_pci7296.c
index bd18865..2bd749b 100644
--- a/drivers/staging/comedi/drivers/adl_pci7296.c
+++ b/drivers/staging/comedi/drivers/adl_pci7296.c
@@ -48,13 +48,6 @@ Configuration Options:
 
 #define PCI_DEVICE_ID_PCI7296 0x7296
 
-static DEFINE_PCI_DEVICE_TABLE(adl_pci7296_pci_table) = {
-	{ PCI_DEVICE(PCI_VENDOR_ID_ADLINK, PCI_DEVICE_ID_PCI7296) },
-	{0}
-};
-
-MODULE_DEVICE_TABLE(pci, adl_pci7296_pci_table);
-
 struct adl_pci7296_private {
 	int data;
 	struct pci_dev *pci_dev;
@@ -63,16 +56,6 @@ struct adl_pci7296_private {
 #define devpriv ((struct adl_pci7296_private *)dev->private)
 
 static int adl_pci7296_attach(struct comedi_device *dev,
-			      struct comedi_devconfig *it);
-static int adl_pci7296_detach(struct comedi_device *dev);
-static struct comedi_driver driver_adl_pci7296 = {
-	.driver_name = "adl_pci7296",
-	.module = THIS_MODULE,
-	.attach = adl_pci7296_attach,
-	.detach = adl_pci7296_detach,
-};
-
-static int adl_pci7296_attach(struct comedi_device *dev,
 			      struct comedi_devconfig *it)
 {
 	struct pci_dev *pcidev = NULL;
@@ -172,6 +155,13 @@ static int adl_pci7296_detach(struct comedi_device *dev)
 	return 0;
 }
 
+static struct comedi_driver driver_adl_pci7296 = {
+	.driver_name	= "adl_pci7296",
+	.module		= THIS_MODULE,
+	.attach		= adl_pci7296_attach,
+	.detach		= adl_pci7296_detach,
+};
+
 static int __devinit driver_adl_pci7296_pci_probe(struct pci_dev *dev,
 						  const struct pci_device_id
 						  *ent)
@@ -184,10 +174,16 @@ static void __devexit driver_adl_pci7296_pci_remove(struct pci_dev *dev)
 	comedi_pci_auto_unconfig(dev);
 }
 
+static DEFINE_PCI_DEVICE_TABLE(adl_pci7296_pci_table) = {
+	{ PCI_DEVICE(PCI_VENDOR_ID_ADLINK, PCI_DEVICE_ID_PCI7296) },
+	{0}
+};
+MODULE_DEVICE_TABLE(pci, adl_pci7296_pci_table);
+
 static struct pci_driver driver_adl_pci7296_pci_driver = {
-	.id_table = adl_pci7296_pci_table,
-	.probe = &driver_adl_pci7296_pci_probe,
-	.remove = __devexit_p(&driver_adl_pci7296_pci_remove)
+	.id_table	= adl_pci7296_pci_table,
+	.probe		= driver_adl_pci7296_pci_probe,
+	.remove		= __devexit_p(driver_adl_pci7296_pci_remove)
 };
 
 static int __init driver_adl_pci7296_init_module(void)
@@ -202,14 +198,13 @@ static int __init driver_adl_pci7296_init_module(void)
 	    (char *)driver_adl_pci7296.driver_name;
 	return pci_register_driver(&driver_adl_pci7296_pci_driver);
 }
+module_init(driver_adl_pci7296_init_module);
 
 static void __exit driver_adl_pci7296_cleanup_module(void)
 {
 	pci_unregister_driver(&driver_adl_pci7296_pci_driver);
 	comedi_driver_unregister(&driver_adl_pci7296);
 }
-
-module_init(driver_adl_pci7296_init_module);
 module_exit(driver_adl_pci7296_cleanup_module);
 
 MODULE_AUTHOR("Comedi http://www.comedi.org");
