Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755937Ab2DWWbY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 18:31:24 -0400
Received: from mail127.messagelabs.com ([216.82.250.115]:25985 "EHLO
	mail127.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753549Ab2DWWbW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 18:31:22 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-7.tower-127.messagelabs.com!1335220226!3828114!57
X-Originating-IP: [216.166.12.178]
X-StarScan-Version: 6.5.7; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] staging: comedi: refactor adl_pci7432 driver to remove forward declarations
Date: Mon, 23 Apr 2012 15:31:08 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201204231531.09059.hartleys@visionengravers.com>
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

diff --git a/drivers/staging/comedi/drivers/adl_pci7432.c b/drivers/staging/comedi/drivers/adl_pci7432.c
index 1e0db48..db15ec6e 100644
--- a/drivers/staging/comedi/drivers/adl_pci7432.c
+++ b/drivers/staging/comedi/drivers/adl_pci7432.c
@@ -43,13 +43,6 @@ Configuration Options:
 
 #define PCI_DEVICE_ID_PCI7432 0x7432
 
-static DEFINE_PCI_DEVICE_TABLE(adl_pci7432_pci_table) = {
-	{ PCI_DEVICE(PCI_VENDOR_ID_ADLINK, PCI_DEVICE_ID_PCI7432) },
-	{0}
-};
-
-MODULE_DEVICE_TABLE(pci, adl_pci7432_pci_table);
-
 struct adl_pci7432_private {
 	int data;
 	struct pci_dev *pci_dev;
@@ -57,29 +50,44 @@ struct adl_pci7432_private {
 
 #define devpriv ((struct adl_pci7432_private *)dev->private)
 
-static int adl_pci7432_attach(struct comedi_device *dev,
-			      struct comedi_devconfig *it);
-static int adl_pci7432_detach(struct comedi_device *dev);
-static struct comedi_driver driver_adl_pci7432 = {
-	.driver_name = "adl_pci7432",
-	.module = THIS_MODULE,
-	.attach = adl_pci7432_attach,
-	.detach = adl_pci7432_detach,
-};
+static int adl_pci7432_do_insn_bits(struct comedi_device *dev,
+				    struct comedi_subdevice *s,
+				    struct comedi_insn *insn,
+				    unsigned int *data)
+{
+	printk(KERN_DEBUG "comedi: pci7432_do_insn_bits called\n");
+	printk(KERN_DEBUG "comedi: data0: %8x data1: %8x\n", data[0], data[1]);
+
+	if (insn->n != 2)
+		return -EINVAL;
 
-/* Digital IO */
+	if (data[0]) {
+		s->state &= ~data[0];
+		s->state |= (data[0] & data[1]);
+
+		printk(KERN_DEBUG "comedi: out: %8x on iobase %4lx\n", s->state,
+		       dev->iobase + PCI7432_DO);
+		outl(s->state & 0xffffffff, dev->iobase + PCI7432_DO);
+	}
+	return 2;
+}
 
 static int adl_pci7432_di_insn_bits(struct comedi_device *dev,
 				    struct comedi_subdevice *s,
 				    struct comedi_insn *insn,
-				    unsigned int *data);
+				    unsigned int *data)
+{
+	printk(KERN_DEBUG "comedi: pci7432_di_insn_bits called\n");
+	printk(KERN_DEBUG "comedi: data0: %8x data1: %8x\n", data[0], data[1]);
 
-static int adl_pci7432_do_insn_bits(struct comedi_device *dev,
-				    struct comedi_subdevice *s,
-				    struct comedi_insn *insn,
-				    unsigned int *data);
+	if (insn->n != 2)
+		return -EINVAL;
 
-/*            */
+	data[1] = inl(dev->iobase + PCI7432_DI) & 0xffffffff;
+	printk(KERN_DEBUG "comedi: data1 %8x\n", data[1]);
+
+	return 2;
+}
 
 static int adl_pci7432_attach(struct comedi_device *dev,
 			      struct comedi_devconfig *it)
@@ -166,44 +174,12 @@ static int adl_pci7432_detach(struct comedi_device *dev)
 	return 0;
 }
 
-static int adl_pci7432_do_insn_bits(struct comedi_device *dev,
-				    struct comedi_subdevice *s,
-				    struct comedi_insn *insn,
-				    unsigned int *data)
-{
-	printk(KERN_DEBUG "comedi: pci7432_do_insn_bits called\n");
-	printk(KERN_DEBUG "comedi: data0: %8x data1: %8x\n", data[0], data[1]);
-
-	if (insn->n != 2)
-		return -EINVAL;
-
-	if (data[0]) {
-		s->state &= ~data[0];
-		s->state |= (data[0] & data[1]);
-
-		printk(KERN_DEBUG "comedi: out: %8x on iobase %4lx\n", s->state,
-		       dev->iobase + PCI7432_DO);
-		outl(s->state & 0xffffffff, dev->iobase + PCI7432_DO);
-	}
-	return 2;
-}
-
-static int adl_pci7432_di_insn_bits(struct comedi_device *dev,
-				    struct comedi_subdevice *s,
-				    struct comedi_insn *insn,
-				    unsigned int *data)
-{
-	printk(KERN_DEBUG "comedi: pci7432_di_insn_bits called\n");
-	printk(KERN_DEBUG "comedi: data0: %8x data1: %8x\n", data[0], data[1]);
-
-	if (insn->n != 2)
-		return -EINVAL;
-
-	data[1] = inl(dev->iobase + PCI7432_DI) & 0xffffffff;
-	printk(KERN_DEBUG "comedi: data1 %8x\n", data[1]);
-
-	return 2;
-}
+static struct comedi_driver driver_adl_pci7432 = {
+	.driver_name	= "adl_pci7432",
+	.module		= THIS_MODULE,
+	.attach		= adl_pci7432_attach,
+	.detach		= adl_pci7432_detach,
+};
 
 static int __devinit driver_adl_pci7432_pci_probe(struct pci_dev *dev,
 						  const struct pci_device_id
@@ -217,10 +193,16 @@ static void __devexit driver_adl_pci7432_pci_remove(struct pci_dev *dev)
 	comedi_pci_auto_unconfig(dev);
 }
 
+static DEFINE_PCI_DEVICE_TABLE(adl_pci7432_pci_table) = {
+	{ PCI_DEVICE(PCI_VENDOR_ID_ADLINK, PCI_DEVICE_ID_PCI7432) },
+	{0}
+};
+MODULE_DEVICE_TABLE(pci, adl_pci7432_pci_table);
+
 static struct pci_driver driver_adl_pci7432_pci_driver = {
-	.id_table = adl_pci7432_pci_table,
-	.probe = &driver_adl_pci7432_pci_probe,
-	.remove = __devexit_p(&driver_adl_pci7432_pci_remove)
+	.id_table	= adl_pci7432_pci_table,
+	.probe		= driver_adl_pci7432_pci_probe,
+	.remove		= __devexit_p(driver_adl_pci7432_pci_remove)
 };
 
 static int __init driver_adl_pci7432_init_module(void)
@@ -235,14 +217,13 @@ static int __init driver_adl_pci7432_init_module(void)
 	    (char *)driver_adl_pci7432.driver_name;
 	return pci_register_driver(&driver_adl_pci7432_pci_driver);
 }
+module_init(driver_adl_pci7432_init_module);
 
 static void __exit driver_adl_pci7432_cleanup_module(void)
 {
 	pci_unregister_driver(&driver_adl_pci7432_pci_driver);
 	comedi_driver_unregister(&driver_adl_pci7432);
 }
-
-module_init(driver_adl_pci7432_init_module);
 module_exit(driver_adl_pci7432_cleanup_module);
 
 MODULE_AUTHOR("Comedi http://www.comedi.org");
