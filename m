Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754641Ab2DWWnb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 18:43:31 -0400
Received: from mail132.messagelabs.com ([216.82.242.115]:52776 "EHLO
	mail132.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753017Ab2DWWna (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 18:43:30 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-14.tower-132.messagelabs.com!1335221008!9482173!3
X-Originating-IP: [216.166.12.178]
X-StarScan-Version: 6.5.7; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] staging: comedi: refactor adl_pci9111 driver to remove forward declarations
Date: Mon, 23 Apr 2012 15:43:22 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201204231543.22770.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the module_init/module_exit routines and variables to the
end of the source as is more typically done with other drivers.
Then rearrange the attach/detach and probe/remove functions,
this removes the need for all the forward declarations.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---

diff --git a/drivers/staging/comedi/drivers/adl_pci9111.c b/drivers/staging/comedi/drivers/adl_pci9111.c
index 6b4d98a..4e4e5fd 100644
--- a/drivers/staging/comedi/drivers/adl_pci9111.c
+++ b/drivers/staging/comedi/drivers/adl_pci9111.c
@@ -289,16 +289,6 @@ TODO:
 			PCI9111_IO_BASE+PCI9111_REGISTER_8254_COUNTER_2); \
 	} while (0)
 
-/*  Function prototypes */
-
-static int pci9111_attach(struct comedi_device *dev,
-			  struct comedi_devconfig *it);
-static int pci9111_detach(struct comedi_device *dev);
-static void pci9111_ai_munge(struct comedi_device *dev,
-			     struct comedi_subdevice *s, void *data,
-			     unsigned int num_bytes,
-			     unsigned int start_chan_index);
-
 static const struct comedi_lrange pci9111_hr_ai_range = {
 	5,
 	{
@@ -310,14 +300,6 @@ static const struct comedi_lrange pci9111_hr_ai_range = {
 	 }
 };
 
-static DEFINE_PCI_DEVICE_TABLE(pci9111_pci_table) = {
-	{ PCI_DEVICE(PCI_VENDOR_ID_ADLINK, PCI9111_HR_DEVICE_ID) },
-	/* { PCI_DEVICE(PCI_VENDOR_ID_ADLINK, PCI9111_HG_DEVICE_ID) }, */
-	{ 0 }
-};
-
-MODULE_DEVICE_TABLE(pci, pci9111_pci_table);
-
 /*  */
 /*  Board specification structure */
 /*  */
@@ -354,51 +336,6 @@ static const struct pci9111_board pci9111_boards[] = {
 #define pci9111_board_nbr \
 	(sizeof(pci9111_boards)/sizeof(struct pci9111_board))
 
-static struct comedi_driver pci9111_driver = {
-	.driver_name = PCI9111_DRIVER_NAME,
-	.module = THIS_MODULE,
-	.attach = pci9111_attach,
-	.detach = pci9111_detach,
-};
-
-static int __devinit pci9111_driver_pci_probe(struct pci_dev *dev,
-					      const struct pci_device_id *ent)
-{
-	return comedi_pci_auto_config(dev, &pci9111_driver);
-}
-
-static void __devexit pci9111_driver_pci_remove(struct pci_dev *dev)
-{
-	comedi_pci_auto_unconfig(dev);
-}
-
-static struct pci_driver pci9111_driver_pci_driver = {
-	.id_table = pci9111_pci_table,
-	.probe = &pci9111_driver_pci_probe,
-	.remove = __devexit_p(&pci9111_driver_pci_remove)
-};
-
-static int __init pci9111_driver_init_module(void)
-{
-	int retval;
-
-	retval = comedi_driver_register(&pci9111_driver);
-	if (retval < 0)
-		return retval;
-
-	pci9111_driver_pci_driver.name = (char *)pci9111_driver.driver_name;
-	return pci_register_driver(&pci9111_driver_pci_driver);
-}
-
-static void __exit pci9111_driver_cleanup_module(void)
-{
-	pci_unregister_driver(&pci9111_driver_pci_driver);
-	comedi_driver_unregister(&pci9111_driver);
-}
-
-module_init(pci9111_driver_init_module);
-module_exit(pci9111_driver_cleanup_module);
-
 /*  Private data structure */
 
 struct pci9111_private_data {
@@ -1470,6 +1407,57 @@ static int pci9111_detach(struct comedi_device *dev)
 	return 0;
 }
 
+static struct comedi_driver pci9111_driver = {
+	.driver_name	= PCI9111_DRIVER_NAME,
+	.module		= THIS_MODULE,
+	.attach		= pci9111_attach,
+	.detach		= pci9111_detach,
+};
+
+static int __devinit pci9111_driver_pci_probe(struct pci_dev *dev,
+					      const struct pci_device_id *ent)
+{
+	return comedi_pci_auto_config(dev, &pci9111_driver);
+}
+
+static void __devexit pci9111_driver_pci_remove(struct pci_dev *dev)
+{
+	comedi_pci_auto_unconfig(dev);
+}
+
+static DEFINE_PCI_DEVICE_TABLE(pci9111_pci_table) = {
+	{ PCI_DEVICE(PCI_VENDOR_ID_ADLINK, PCI9111_HR_DEVICE_ID) },
+	/* { PCI_DEVICE(PCI_VENDOR_ID_ADLINK, PCI9111_HG_DEVICE_ID) }, */
+	{ 0 }
+};
+MODULE_DEVICE_TABLE(pci, pci9111_pci_table);
+
+static struct pci_driver pci9111_driver_pci_driver = {
+	.id_table	= pci9111_pci_table,
+	.probe		= pci9111_driver_pci_probe,
+	.remove		= __devexit_p(pci9111_driver_pci_remove),
+};
+
+static int __init pci9111_driver_init_module(void)
+{
+	int retval;
+
+	retval = comedi_driver_register(&pci9111_driver);
+	if (retval < 0)
+		return retval;
+
+	pci9111_driver_pci_driver.name = (char *)pci9111_driver.driver_name;
+	return pci_register_driver(&pci9111_driver_pci_driver);
+}
+module_init(pci9111_driver_init_module);
+
+static void __exit pci9111_driver_cleanup_module(void)
+{
+	pci_unregister_driver(&pci9111_driver_pci_driver);
+	comedi_driver_unregister(&pci9111_driver);
+}
+module_exit(pci9111_driver_cleanup_module);
+
 MODULE_AUTHOR("Comedi http://www.comedi.org");
 MODULE_DESCRIPTION("Comedi low-level driver");
 MODULE_LICENSE("GPL");
