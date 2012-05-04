Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759738Ab2EDVhx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 17:37:53 -0400
Received: from mail132.messagelabs.com ([216.82.242.115]:59145 "EHLO
	mail132.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754231Ab2EDVhv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 17:37:51 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-7.tower-132.messagelabs.com!1336167467!9009832!12
X-Originating-IP: [216.166.12.69]
X-StarScan-Version: 6.5.7; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] staging: comedi: partial refactor of s626 driver to remove forward declarations
Date: Fri, 4 May 2012 14:37:36 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201205041437.37068.hartleys@visionengravers.com>
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

The attach/detach functions have not been moved yet. Moving them
creates a huge diff. The attach function is 966 lines and needs some
cleanup first.

diff --git a/drivers/staging/comedi/drivers/s626.c b/drivers/staging/comedi/drivers/s626.c
index a0b7c71..ad4d2f6 100644
--- a/drivers/staging/comedi/drivers/s626.c
+++ b/drivers/staging/comedi/drivers/s626.c
@@ -79,10 +79,6 @@ INSN_CONFIG instructions:
 #include "comedi_fc.h"
 #include "s626.h"
 
-MODULE_AUTHOR("Gianluca Palli <gpalli@deis.unibo.it>");
-MODULE_DESCRIPTION("Sensoray 626 Comedi driver module");
-MODULE_LICENSE("GPL");
-
 #define PCI_VENDOR_ID_S626 0x1131
 #define PCI_DEVICE_ID_S626 0x7146
 #define PCI_SUBVENDOR_ID_S626 0x6000
@@ -122,28 +118,6 @@ static const struct s626_board s626_boards[] = {
 
 #define thisboard ((const struct s626_board *)dev->board_ptr)
 
-/*
- * For devices with vendor:device id == 0x1131:0x7146 you must specify
- * also subvendor:subdevice ids, because otherwise it will conflict with
- * Philips SAA7146 media/dvb based cards.
- */
-static DEFINE_PCI_DEVICE_TABLE(s626_pci_table) = {
-	{PCI_VENDOR_ID_S626, PCI_DEVICE_ID_S626, PCI_SUBVENDOR_ID_S626, PCI_SUBDEVICE_ID_S626, 0, 0, 0},
-	{0}
-};
-
-MODULE_DEVICE_TABLE(pci, s626_pci_table);
-
-static int s626_attach(struct comedi_device *dev, struct comedi_devconfig *it);
-static int s626_detach(struct comedi_device *dev);
-
-static struct comedi_driver driver_s626 = {
-	.driver_name = "s626",
-	.module = THIS_MODULE,
-	.attach = s626_attach,
-	.detach = s626_detach,
-};
-
 struct s626_private {
 	struct pci_dev *pdev;
 	void *base_addr;
@@ -235,44 +209,6 @@ static struct dio_private *dio_private_word[]={
 #define devpriv ((struct s626_private *)dev->private)
 #define diopriv ((struct dio_private *)s->private)
 
-static int __devinit driver_s626_pci_probe(struct pci_dev *dev,
-					   const struct pci_device_id *ent)
-{
-	return comedi_pci_auto_config(dev, &driver_s626);
-}
-
-static void __devexit driver_s626_pci_remove(struct pci_dev *dev)
-{
-	comedi_pci_auto_unconfig(dev);
-}
-
-static struct pci_driver driver_s626_pci_driver = {
-	.id_table = s626_pci_table,
-	.probe = &driver_s626_pci_probe,
-	.remove = __devexit_p(&driver_s626_pci_remove)
-};
-
-static int __init driver_s626_init_module(void)
-{
-	int retval;
-
-	retval = comedi_driver_register(&driver_s626);
-	if (retval < 0)
-		return retval;
-
-	driver_s626_pci_driver.name = (char *)driver_s626.driver_name;
-	return pci_register_driver(&driver_s626_pci_driver);
-}
-
-static void __exit driver_s626_cleanup_module(void)
-{
-	pci_unregister_driver(&driver_s626_pci_driver);
-	comedi_driver_unregister(&driver_s626);
-}
-
-module_init(driver_s626_init_module);
-module_exit(driver_s626_cleanup_module);
-
 /* ioctl routines */
 static int s626_ai_insn_config(struct comedi_device *dev,
 			       struct comedi_subdevice *s,
@@ -3378,3 +3314,63 @@ static void CountersInit(struct comedi_device *dev)
 	DEBUG("CountersInit: counters initialized\n");
 
 }
+
+static struct comedi_driver driver_s626 = {
+	.driver_name	= "s626",
+	.module		= THIS_MODULE,
+	.attach		= s626_attach,
+	.detach		= s626_detach,
+};
+
+static int __devinit driver_s626_pci_probe(struct pci_dev *dev,
+					   const struct pci_device_id *ent)
+{
+	return comedi_pci_auto_config(dev, &driver_s626);
+}
+
+static void __devexit driver_s626_pci_remove(struct pci_dev *dev)
+{
+	comedi_pci_auto_unconfig(dev);
+}
+
+/*
+ * For devices with vendor:device id == 0x1131:0x7146 you must specify
+ * also subvendor:subdevice ids, because otherwise it will conflict with
+ * Philips SAA7146 media/dvb based cards.
+ */
+static DEFINE_PCI_DEVICE_TABLE(s626_pci_table) = {
+	{ PCI_VENDOR_ID_S626, PCI_DEVICE_ID_S626,
+		PCI_SUBVENDOR_ID_S626, PCI_SUBDEVICE_ID_S626, 0, 0, 0 },
+	{ 0 }
+};
+MODULE_DEVICE_TABLE(pci, s626_pci_table);
+
+static struct pci_driver driver_s626_pci_driver = {
+	.id_table	= s626_pci_table,
+	.probe		= driver_s626_pci_probe,
+	.remove		= __devexit_p(driver_s626_pci_remove),
+};
+
+static int __init driver_s626_init_module(void)
+{
+	int retval;
+
+	retval = comedi_driver_register(&driver_s626);
+	if (retval < 0)
+		return retval;
+
+	driver_s626_pci_driver.name = (char *)driver_s626.driver_name;
+	return pci_register_driver(&driver_s626_pci_driver);
+}
+module_init(driver_s626_init_module);
+
+static void __exit driver_s626_cleanup_module(void)
+{
+	pci_unregister_driver(&driver_s626_pci_driver);
+	comedi_driver_unregister(&driver_s626);
+}
+module_exit(driver_s626_cleanup_module);
+
+MODULE_AUTHOR("Gianluca Palli <gpalli@deis.unibo.it>");
+MODULE_DESCRIPTION("Sensoray 626 Comedi driver module");
+MODULE_LICENSE("GPL");
