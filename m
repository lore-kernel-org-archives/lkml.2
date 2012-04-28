Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758326Ab2D1Aft (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 20:35:49 -0400
Received: from mail160.messagelabs.com ([216.82.253.99]:42597 "EHLO
	mail160.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757775Ab2D1Afs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 20:35:48 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-3.tower-160.messagelabs.com!1335573345!4974470!3
X-Originating-IP: [216.166.12.72]
X-StarScan-Version: 6.5.7; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] staging: comedi: refactor ke_counter driver to remove forward declarations
Date: Fri, 27 Apr 2012 17:35:22 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201204271735.23271.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the module_init/module_exit routines and the associated
struct comedi_driver and other variables to the end of the source.
This is more typical of how other drivers are written and removes
the need for the forward declarations.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---

diff --git a/drivers/staging/comedi/drivers/ke_counter.c b/drivers/staging/comedi/drivers/ke_counter.c
index fef6ea7..0db76a5 100644
--- a/drivers/staging/comedi/drivers/ke_counter.c
+++ b/drivers/staging/comedi/drivers/ke_counter.c
@@ -46,18 +46,6 @@ Kolter Electronic PCI Counter Card.
 #define PCI_VENDOR_ID_KOLTER    0x1001
 #define CNT_CARD_DEVICE_ID      0x0014
 
-/*-- function prototypes ----------------------------------------------------*/
-
-static int cnt_attach(struct comedi_device *dev, struct comedi_devconfig *it);
-static int cnt_detach(struct comedi_device *dev);
-
-static DEFINE_PCI_DEVICE_TABLE(cnt_pci_table) = {
-	{ PCI_DEVICE(PCI_VENDOR_ID_KOLTER, CNT_CARD_DEVICE_ID) },
-	{0}
-};
-
-MODULE_DEVICE_TABLE(pci, cnt_pci_table);
-
 /*-- board specification structure ------------------------------------------*/
 
 struct cnt_board_struct {
@@ -87,51 +75,6 @@ struct cnt_device_private {
 
 #define devpriv ((struct cnt_device_private *)dev->private)
 
-static struct comedi_driver cnt_driver = {
-	.driver_name = CNT_DRIVER_NAME,
-	.module = THIS_MODULE,
-	.attach = cnt_attach,
-	.detach = cnt_detach,
-};
-
-static int __devinit cnt_driver_pci_probe(struct pci_dev *dev,
-					  const struct pci_device_id *ent)
-{
-	return comedi_pci_auto_config(dev, &cnt_driver);
-}
-
-static void __devexit cnt_driver_pci_remove(struct pci_dev *dev)
-{
-	comedi_pci_auto_unconfig(dev);
-}
-
-static struct pci_driver cnt_driver_pci_driver = {
-	.id_table = cnt_pci_table,
-	.probe = &cnt_driver_pci_probe,
-	.remove = __devexit_p(&cnt_driver_pci_remove)
-};
-
-static int __init cnt_driver_init_module(void)
-{
-	int retval;
-
-	retval = comedi_driver_register(&cnt_driver);
-	if (retval < 0)
-		return retval;
-
-	cnt_driver_pci_driver.name = (char *)cnt_driver.driver_name;
-	return pci_register_driver(&cnt_driver_pci_driver);
-}
-
-static void __exit cnt_driver_cleanup_module(void)
-{
-	pci_unregister_driver(&cnt_driver_pci_driver);
-	comedi_driver_unregister(&cnt_driver);
-}
-
-module_init(cnt_driver_init_module);
-module_exit(cnt_driver_cleanup_module);
-
 /*-- counter write ----------------------------------------------------------*/
 
 /* This should be used only for resetting the counters; maybe it is better
@@ -181,8 +124,6 @@ static int cnt_rinsn(struct comedi_device *dev,
 	return 1;
 }
 
-/*-- attach -----------------------------------------------------------------*/
-
 static int cnt_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 {
 	struct comedi_subdevice *subdevice;
@@ -278,8 +219,6 @@ found:
 	return 0;
 }
 
-/*-- detach -----------------------------------------------------------------*/
-
 static int cnt_detach(struct comedi_device *dev)
 {
 	if (devpriv && devpriv->pcidev) {
@@ -292,6 +231,56 @@ static int cnt_detach(struct comedi_device *dev)
 	return 0;
 }
 
+static struct comedi_driver cnt_driver = {
+	.driver_name	= CNT_DRIVER_NAME,
+	.module		= THIS_MODULE,
+	.attach		= cnt_attach,
+	.detach		= cnt_detach,
+};
+
+static int __devinit cnt_driver_pci_probe(struct pci_dev *dev,
+					  const struct pci_device_id *ent)
+{
+	return comedi_pci_auto_config(dev, &cnt_driver);
+}
+
+static void __devexit cnt_driver_pci_remove(struct pci_dev *dev)
+{
+	comedi_pci_auto_unconfig(dev);
+}
+
+static DEFINE_PCI_DEVICE_TABLE(cnt_pci_table) = {
+	{ PCI_DEVICE(PCI_VENDOR_ID_KOLTER, CNT_CARD_DEVICE_ID) },
+	{ 0 }
+};
+MODULE_DEVICE_TABLE(pci, cnt_pci_table);
+
+static struct pci_driver cnt_driver_pci_driver = {
+	.id_table	= cnt_pci_table,
+	.probe		= cnt_driver_pci_probe,
+	.remove		= __devexit_p(cnt_driver_pci_remove),
+};
+
+static int __init cnt_driver_init_module(void)
+{
+	int retval;
+
+	retval = comedi_driver_register(&cnt_driver);
+	if (retval < 0)
+		return retval;
+
+	cnt_driver_pci_driver.name = (char *)cnt_driver.driver_name;
+	return pci_register_driver(&cnt_driver_pci_driver);
+}
+module_init(cnt_driver_init_module);
+
+static void __exit cnt_driver_cleanup_module(void)
+{
+	pci_unregister_driver(&cnt_driver_pci_driver);
+	comedi_driver_unregister(&cnt_driver);
+}
+module_exit(cnt_driver_cleanup_module);
+
 MODULE_AUTHOR("Comedi http://www.comedi.org");
 MODULE_DESCRIPTION("Comedi low-level driver");
 MODULE_LICENSE("GPL");
