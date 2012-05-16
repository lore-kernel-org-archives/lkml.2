Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966141Ab2EPB31 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 21:29:27 -0400
Received: from mail209.messagelabs.com ([216.82.255.3]:57223 "EHLO
	mail209.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932839Ab2EPB3Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 21:29:25 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-10.tower-209.messagelabs.com!1337131764!5742938!1
X-Originating-IP: [216.166.12.98]
X-StarScan-Version: 6.5.7; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] staging: comedi: refactor daqboard2000 driver and use module_comedi_pci_driver
Date: Tue, 15 May 2012 18:29:18 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201205151829.19125.hartleys@visionengravers.com>
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

 drivers/staging/comedi/drivers/daqboard2000.c |   70 ++++++++-----------------
 1 files changed, 22 insertions(+), 48 deletions(-)

diff --git a/drivers/staging/comedi/drivers/daqboard2000.c b/drivers/staging/comedi/drivers/daqboard2000.c
index 480f418..dc974ce 100644
--- a/drivers/staging/comedi/drivers/daqboard2000.c
+++ b/drivers/staging/comedi/drivers/daqboard2000.c
@@ -301,17 +301,6 @@ struct daqboard2000_hw {
 #define DAQBOARD2000_PosRefDacSelect             0x0100
 #define DAQBOARD2000_NegRefDacSelect             0x0000
 
-static int daqboard2000_attach(struct comedi_device *dev,
-			       struct comedi_devconfig *it);
-static int daqboard2000_detach(struct comedi_device *dev);
-
-static struct comedi_driver driver_daqboard2000 = {
-	.driver_name = "daqboard2000",
-	.module = THIS_MODULE,
-	.attach = daqboard2000_attach,
-	.detach = daqboard2000_detach,
-};
-
 struct daq200_boardtype {
 	const char *name;
 	int id;
@@ -323,13 +312,6 @@ static const struct daq200_boardtype boardtypes[] = {
 
 #define this_board ((const struct daq200_boardtype *)dev->board_ptr)
 
-static DEFINE_PCI_DEVICE_TABLE(daqboard2000_pci_table) = {
-	{ PCI_DEVICE(0x1616, 0x0409) },
-	{0}
-};
-
-MODULE_DEVICE_TABLE(pci, daqboard2000_pci_table);
-
 struct daqboard2000_private {
 	enum {
 		card_daqboard_2000
@@ -876,45 +858,37 @@ static int daqboard2000_detach(struct comedi_device *dev)
 	return 0;
 }
 
-static int __devinit driver_daqboard2000_pci_probe(struct pci_dev *dev,
-						   const struct pci_device_id
-						   *ent)
+static struct comedi_driver daqboard2000_driver = {
+	.driver_name	= "daqboard2000",
+	.module		= THIS_MODULE,
+	.attach		= daqboard2000_attach,
+	.detach		= daqboard2000_detach,
+};
+
+static int __devinit daqboard2000_pci_probe(struct pci_dev *dev,
+					    const struct pci_device_id *ent)
 {
-	return comedi_pci_auto_config(dev, &driver_daqboard2000);
+	return comedi_pci_auto_config(dev, &daqboard2000_driver);
 }
 
-static void __devexit driver_daqboard2000_pci_remove(struct pci_dev *dev)
+static void __devexit daqboard2000_pci_remove(struct pci_dev *dev)
 {
 	comedi_pci_auto_unconfig(dev);
 }
 
-static struct pci_driver driver_daqboard2000_pci_driver = {
-	.id_table = daqboard2000_pci_table,
-	.probe = &driver_daqboard2000_pci_probe,
-	.remove = __devexit_p(&driver_daqboard2000_pci_remove)
+static DEFINE_PCI_DEVICE_TABLE(daqboard2000_pci_table) = {
+	{ PCI_DEVICE(0x1616, 0x0409) },
+	{ 0 }
 };
+MODULE_DEVICE_TABLE(pci, daqboard2000_pci_table);
 
-static int __init driver_daqboard2000_init_module(void)
-{
-	int retval;
-
-	retval = comedi_driver_register(&driver_daqboard2000);
-	if (retval < 0)
-		return retval;
-
-	driver_daqboard2000_pci_driver.name =
-	    (char *)driver_daqboard2000.driver_name;
-	return pci_register_driver(&driver_daqboard2000_pci_driver);
-}
-
-static void __exit driver_daqboard2000_cleanup_module(void)
-{
-	pci_unregister_driver(&driver_daqboard2000_pci_driver);
-	comedi_driver_unregister(&driver_daqboard2000);
-}
-
-module_init(driver_daqboard2000_init_module);
-module_exit(driver_daqboard2000_cleanup_module);
+static struct pci_driver daqboard2000_pci_driver = {
+	.name		= "daqboard2000",
+	.id_table	= daqboard2000_pci_table,
+	.probe		= daqboard2000_pci_probe,
+	.remove		= __devexit_p(daqboard2000_pci_remove),
+};
+module_comedi_pci_driver(daqboard2000_driver, daqboard2000_pci_driver);
 
 MODULE_AUTHOR("Comedi http://www.comedi.org");
 MODULE_DESCRIPTION("Comedi low-level driver");
