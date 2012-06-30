Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756023Ab2F3Afe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2012 20:35:34 -0400
Received: from mail160.messagelabs.com ([216.82.253.99]:37208 "EHLO
	mail160.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751971Ab2F3Afc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2012 20:35:32 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-6.tower-160.messagelabs.com!1341016526!8256774!3
X-Originating-IP: [216.166.12.97]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 01/10] staging: comedi: ni_670x: use module_comedi_pci_driver
Date: Fri, 29 Jun 2012 17:35:26 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201206291735.26583.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Refactor the driver to use the module_comedi_pci_driver() helper.
This gets rid of some of the module boilerplate code.

For aesthetic reasons, rename the comedi_driver and pci_driver to
follow the convention of the other comedi pci drivers.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Frank Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/ni_670x.c | 90 ++++++++++++--------------------
 1 file changed, 33 insertions(+), 57 deletions(-)

diff --git a/drivers/staging/comedi/drivers/ni_670x.c b/drivers/staging/comedi/drivers/ni_670x.c
index 9032bac..cea43de 100644
--- a/drivers/staging/comedi/drivers/ni_670x.c
+++ b/drivers/staging/comedi/drivers/ni_670x.c
@@ -88,14 +88,6 @@ static const struct ni_670x_board ni_670x_boards[] = {
 	 },
 };
 
-static DEFINE_PCI_DEVICE_TABLE(ni_670x_pci_table) = {
-	{PCI_DEVICE(PCI_VENDOR_ID_NI, 0x2c90)},
-	{PCI_DEVICE(PCI_VENDOR_ID_NI, 0x1920)},
-	{0}
-};
-
-MODULE_DEVICE_TABLE(pci, ni_670x_pci_table);
-
 #define thisboard ((struct ni_670x_board *)dev->board_ptr)
 
 struct ni_670x_private {
@@ -109,55 +101,6 @@ struct ni_670x_private {
 #define devpriv ((struct ni_670x_private *)dev->private)
 #define n_ni_670x_boards ARRAY_SIZE(ni_670x_boards)
 
-static int ni_670x_attach(struct comedi_device *dev,
-			  struct comedi_devconfig *it);
-static void ni_670x_detach(struct comedi_device *dev);
-
-static struct comedi_driver driver_ni_670x = {
-	.driver_name = "ni_670x",
-	.module = THIS_MODULE,
-	.attach = ni_670x_attach,
-	.detach = ni_670x_detach,
-};
-
-static int __devinit driver_ni_670x_pci_probe(struct pci_dev *dev,
-					      const struct pci_device_id *ent)
-{
-	return comedi_pci_auto_config(dev, &driver_ni_670x);
-}
-
-static void __devexit driver_ni_670x_pci_remove(struct pci_dev *dev)
-{
-	comedi_pci_auto_unconfig(dev);
-}
-
-static struct pci_driver driver_ni_670x_pci_driver = {
-	.id_table = ni_670x_pci_table,
-	.probe = &driver_ni_670x_pci_probe,
-	.remove = __devexit_p(&driver_ni_670x_pci_remove)
-};
-
-static int __init driver_ni_670x_init_module(void)
-{
-	int retval;
-
-	retval = comedi_driver_register(&driver_ni_670x);
-	if (retval < 0)
-		return retval;
-
-	driver_ni_670x_pci_driver.name = (char *)driver_ni_670x.driver_name;
-	return pci_register_driver(&driver_ni_670x_pci_driver);
-}
-
-static void __exit driver_ni_670x_cleanup_module(void)
-{
-	pci_unregister_driver(&driver_ni_670x_pci_driver);
-	comedi_driver_unregister(&driver_ni_670x);
-}
-
-module_init(driver_ni_670x_init_module);
-module_exit(driver_ni_670x_cleanup_module);
-
 static struct comedi_lrange range_0_20mA = { 1, {RANGE_mA(0, 20)} };
 
 static int ni_670x_find_device(struct comedi_device *dev, int bus, int slot);
@@ -377,6 +320,39 @@ static int ni_670x_find_device(struct comedi_device *dev, int bus, int slot)
 	return -EIO;
 }
 
+static struct comedi_driver ni_670x_driver = {
+	.driver_name	= "ni_670x",
+	.module		= THIS_MODULE,
+	.attach		= ni_670x_attach,
+	.detach		= ni_670x_detach,
+};
+
+static int __devinit ni_670x_pci_probe(struct pci_dev *dev,
+				       const struct pci_device_id *ent)
+{
+	return comedi_pci_auto_config(dev, &ni_670x_driver);
+}
+
+static void __devexit ni_670x_pci_remove(struct pci_dev *dev)
+{
+	comedi_pci_auto_unconfig(dev);
+}
+
+static DEFINE_PCI_DEVICE_TABLE(ni_670x_pci_table) = {
+	{ PCI_DEVICE(PCI_VENDOR_ID_NI, 0x2c90) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_NI, 0x1920) },
+	{ 0 }
+};
+MODULE_DEVICE_TABLE(pci, ni_670x_pci_table);
+
+static struct pci_driver ni_670x_pci_driver = {
+	.name		="ni_670x",
+	.id_table	= ni_670x_pci_table,
+	.probe		= ni_670x_pci_probe,
+	.remove		= __devexit_p(ni_670x_pci_remove),
+};
+module_comedi_pci_driver(ni_670x_driver, ni_670x_pci_driver);
+
 MODULE_AUTHOR("Comedi http://www.comedi.org");
 MODULE_DESCRIPTION("Comedi low-level driver");
 MODULE_LICENSE("GPL");
-- 
1.7.11

