Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760490Ab2EDWkH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 18:40:07 -0400
Received: from mail160.messagelabs.com ([216.82.253.99]:6131 "EHLO
	mail160.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754683Ab2EDWkF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 18:40:05 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-13.tower-160.messagelabs.com!1336171203!5555163!4
X-Originating-IP: [216.166.12.99]
X-StarScan-Version: 6.5.7; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] staging: comedi: refactor me_daq driver to remove forward declarations
Date: Fri, 4 May 2012 15:39:55 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201205041539.55543.hartleys@visionengravers.com>
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

diff --git a/drivers/staging/comedi/drivers/me_daq.c b/drivers/staging/comedi/drivers/me_daq.c
index e286dcb..4ce6339 100644
--- a/drivers/staging/comedi/drivers/me_daq.c
+++ b/drivers/staging/comedi/drivers/me_daq.c
@@ -146,10 +146,6 @@ from http://www.comedi.org
 #define ME_COUNTER_STARTDATA_B		0x0022	/* - | W */
 #define ME_COUNTER_VALUE_B		0x0022	/* R | - */
 
-/* Function prototypes */
-static int me_attach(struct comedi_device *dev, struct comedi_devconfig *it);
-static int me_detach(struct comedi_device *dev);
-
 static const struct comedi_lrange me2000_ai_range = {
 	8,
 	{
@@ -187,14 +183,6 @@ static const struct comedi_lrange me2600_ao_range = {
 	 }
 };
 
-static DEFINE_PCI_DEVICE_TABLE(me_pci_table) = {
-	{ PCI_DEVICE(PCI_VENDOR_ID_MEILHAUS, ME2600_DEVICE_ID) },
-	{ PCI_DEVICE(PCI_VENDOR_ID_MEILHAUS, ME2000_DEVICE_ID) },
-	{0}
-};
-
-MODULE_DEVICE_TABLE(pci, me_pci_table);
-
 /* Board specification structure */
 struct me_board {
 	const char *name;	/* driver name */
@@ -247,51 +235,6 @@ static const struct me_board me_boards[] = {
 
 #define me_board_nbr (sizeof(me_boards)/sizeof(struct me_board))
 
-static struct comedi_driver me_driver = {
-	.driver_name = ME_DRIVER_NAME,
-	.module = THIS_MODULE,
-	.attach = me_attach,
-	.detach = me_detach,
-};
-
-static int __devinit me_driver_pci_probe(struct pci_dev *dev,
-					 const struct pci_device_id *ent)
-{
-	return comedi_pci_auto_config(dev, &me_driver);
-}
-
-static void __devexit me_driver_pci_remove(struct pci_dev *dev)
-{
-	comedi_pci_auto_unconfig(dev);
-}
-
-static struct pci_driver me_driver_pci_driver = {
-	.id_table = me_pci_table,
-	.probe = &me_driver_pci_probe,
-	.remove = __devexit_p(&me_driver_pci_remove)
-};
-
-static int __init me_driver_init_module(void)
-{
-	int retval;
-
-	retval = comedi_driver_register(&me_driver);
-	if (retval < 0)
-		return retval;
-
-	me_driver_pci_driver.name = (char *)me_driver.driver_name;
-	return pci_register_driver(&me_driver_pci_driver);
-}
-
-static void __exit me_driver_cleanup_module(void)
-{
-	pci_unregister_driver(&me_driver_pci_driver);
-	comedi_driver_unregister(&me_driver);
-}
-
-module_init(me_driver_init_module);
-module_exit(me_driver_cleanup_module);
-
 /* Private data structure */
 struct me_private_data {
 	struct pci_dev *pci_device;
@@ -669,12 +612,6 @@ static int me_reset(struct comedi_device *dev)
 	return 0;
 }
 
-/*
- * Attach
- *
- * - Register PCI device
- * - Declare device driver capability
- */
 static int me_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 {
 	struct pci_dev *pci_device = NULL;
@@ -869,7 +806,6 @@ found:
 	return 0;
 }
 
-/* Detach */
 static int me_detach(struct comedi_device *dev)
 {
 	if (dev_private) {
@@ -889,6 +825,57 @@ static int me_detach(struct comedi_device *dev)
 	return 0;
 }
 
+static struct comedi_driver me_driver = {
+	.driver_name	= ME_DRIVER_NAME,
+	.module		= THIS_MODULE,
+	.attach		= me_attach,
+	.detach		= me_detach,
+};
+
+static int __devinit me_driver_pci_probe(struct pci_dev *dev,
+					 const struct pci_device_id *ent)
+{
+	return comedi_pci_auto_config(dev, &me_driver);
+}
+
+static void __devexit me_driver_pci_remove(struct pci_dev *dev)
+{
+	comedi_pci_auto_unconfig(dev);
+}
+
+static DEFINE_PCI_DEVICE_TABLE(me_pci_table) = {
+	{ PCI_DEVICE(PCI_VENDOR_ID_MEILHAUS, ME2600_DEVICE_ID) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_MEILHAUS, ME2000_DEVICE_ID) },
+	{ 0 }
+};
+MODULE_DEVICE_TABLE(pci, me_pci_table);
+
+static struct pci_driver me_driver_pci_driver = {
+	.id_table	= me_pci_table,
+	.probe		= me_driver_pci_probe,
+	.remove		= __devexit_p(me_driver_pci_remove),
+};
+
+static int __init me_driver_init_module(void)
+{
+	int retval;
+
+	retval = comedi_driver_register(&me_driver);
+	if (retval < 0)
+		return retval;
+
+	me_driver_pci_driver.name = (char *)me_driver.driver_name;
+	return pci_register_driver(&me_driver_pci_driver);
+}
+module_init(me_driver_init_module);
+
+static void __exit me_driver_cleanup_module(void)
+{
+	pci_unregister_driver(&me_driver_pci_driver);
+	comedi_driver_unregister(&me_driver);
+}
+module_exit(me_driver_cleanup_module);
+
 MODULE_AUTHOR("Comedi http://www.comedi.org");
 MODULE_DESCRIPTION("Comedi low-level driver");
 MODULE_LICENSE("GPL");
