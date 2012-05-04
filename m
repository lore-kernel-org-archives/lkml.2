Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760695Ab2EDXt7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 19:49:59 -0400
Received: from mail131.messagelabs.com ([216.82.242.99]:48205 "EHLO
	mail131.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754010Ab2EDXt5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 19:49:57 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-10.tower-131.messagelabs.com!1336175396!21608604!2
X-Originating-IP: [216.166.12.72]
X-StarScan-Version: 6.5.7; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] staging: comedi: refactor dyna_pci10xx driver to remove forward declarations
Date: Fri, 4 May 2012 16:31:58 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201205041631.59210.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the struct comedi_driver and associated variables to the
end of the source. This is more typical of how other drivers are
written and removes the need for the forward declarations.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---

diff --git a/drivers/staging/comedi/drivers/dyna_pci10xx.c b/drivers/staging/comedi/drivers/dyna_pci10xx.c
index f54e7ff..bb86c85 100644
--- a/drivers/staging/comedi/drivers/dyna_pci10xx.c
+++ b/drivers/staging/comedi/drivers/dyna_pci10xx.c
@@ -48,17 +48,6 @@
 
 static DEFINE_MUTEX(start_stop_sem);
 
-static DEFINE_PCI_DEVICE_TABLE(dyna_pci10xx_pci_table) = {
-	{ PCI_DEVICE(PCI_VENDOR_ID_DYNALOG, 0x1050) },
-	{ 0 }
-};
-
-MODULE_DEVICE_TABLE(pci, dyna_pci10xx_pci_table);
-
-static int dyna_pci10xx_attach(struct comedi_device *dev,
-			  struct comedi_devconfig *it);
-static int dyna_pci10xx_detach(struct comedi_device *dev);
-
 static const struct comedi_lrange range_pci1050_ai = { 3, {
 							  BIP_RANGE(10),
 							  BIP_RANGE(5),
@@ -113,16 +102,6 @@ static const struct boardtype boardtypes[] = {
 	{.name = DRV_NAME},
 };
 
-static struct comedi_driver driver_dyna_pci10xx = {
-	.driver_name = DRV_NAME,
-	.module = THIS_MODULE,
-	.attach = dyna_pci10xx_attach,
-	.detach = dyna_pci10xx_detach,
-	.board_name = &boardtypes[0].name,
-	.offset = sizeof(struct boardtype),
-	.num_names = ARRAY_SIZE(boardtypes),
-};
-
 struct dyna_pci10xx_private {
 	struct pci_dev *pci_dev;	/*  ptr to PCI device */
 	char valid;			/*  card is usable */
@@ -418,6 +397,16 @@ static int dyna_pci10xx_detach(struct comedi_device *dev)
 	return 0;
 }
 
+static struct comedi_driver driver_dyna_pci10xx = {
+	.driver_name	= DRV_NAME,
+	.module		= THIS_MODULE,
+	.attach		= dyna_pci10xx_attach,
+	.detach		= dyna_pci10xx_detach,
+	.board_name	= &boardtypes[0].name,
+	.offset		= sizeof(struct boardtype),
+	.num_names	= ARRAY_SIZE(boardtypes),
+};
+
 static int __devinit driver_dyna_pci10xx_pci_probe(struct pci_dev *dev,
 					      const struct pci_device_id *ent)
 {
@@ -429,10 +418,16 @@ static void __devexit driver_dyna_pci10xx_pci_remove(struct pci_dev *dev)
 	comedi_pci_auto_unconfig(dev);
 }
 
+static DEFINE_PCI_DEVICE_TABLE(dyna_pci10xx_pci_table) = {
+	{ PCI_DEVICE(PCI_VENDOR_ID_DYNALOG, 0x1050) },
+	{ 0 }
+};
+MODULE_DEVICE_TABLE(pci, dyna_pci10xx_pci_table);
+
 static struct pci_driver driver_dyna_pci10xx_pci_driver = {
-	.id_table = dyna_pci10xx_pci_table,
-	.probe = &driver_dyna_pci10xx_pci_probe,
-	.remove = __devexit_p(&driver_dyna_pci10xx_pci_remove)
+	.id_table	= dyna_pci10xx_pci_table,
+	.probe		= driver_dyna_pci10xx_pci_probe,
+	.remove		= __devexit_p(driver_dyna_pci10xx_pci_remove),
 };
 
 static int __init driver_dyna_pci10xx_init_module(void)
@@ -447,14 +442,13 @@ static int __init driver_dyna_pci10xx_init_module(void)
 		(char *)driver_dyna_pci10xx.driver_name;
 	return pci_register_driver(&driver_dyna_pci10xx_pci_driver);
 }
+module_init(driver_dyna_pci10xx_init_module);
 
 static void __exit driver_dyna_pci10xx_cleanup_module(void)
 {
 	pci_unregister_driver(&driver_dyna_pci10xx_pci_driver);
 	comedi_driver_unregister(&driver_dyna_pci10xx);
 }
-
-module_init(driver_dyna_pci10xx_init_module);
 module_exit(driver_dyna_pci10xx_cleanup_module);
 
 MODULE_LICENSE("GPL");
