Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755426Ab2DWWQb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 18:16:31 -0400
Received: from mail132.messagelabs.com ([216.82.242.115]:43968 "EHLO
	mail132.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753195Ab2DWWQa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 18:16:30 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-8.tower-132.messagelabs.com!1335219388!6593530!2
X-Originating-IP: [216.166.12.98]
X-StarScan-Version: 6.5.7; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] staging: comedi: refactor adl_pci7230 driver to remove forward declarations
Date: Mon, 23 Apr 2012 15:16:23 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201204231516.24093.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the struct comedi_driver variable and the associated
attach/detach routines to remove the need for the forward
declarations.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Mori Hess <fmhess@users.sourceforge.net>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---

diff --git a/drivers/staging/comedi/drivers/adl_pci7230.c b/drivers/staging/comedi/drivers/adl_pci7230.c
index c322433..7bb66b0 100644
--- a/drivers/staging/comedi/drivers/adl_pci7230.c
+++ b/drivers/staging/comedi/drivers/adl_pci7230.c
@@ -43,13 +43,6 @@ Configuration Options:
 
 #define PCI_DEVICE_ID_PCI7230 0x7230
 
-static DEFINE_PCI_DEVICE_TABLE(adl_pci7230_pci_table) = {
-	{ PCI_DEVICE(PCI_VENDOR_ID_ADLINK, PCI_DEVICE_ID_PCI7230) },
-	{0}
-};
-
-MODULE_DEVICE_TABLE(pci, adl_pci7230_pci_table);
-
 struct adl_pci7230_private {
 	int data;
 	struct pci_dev *pci_dev;
@@ -57,27 +50,36 @@ struct adl_pci7230_private {
 
 #define devpriv ((struct adl_pci7230_private *)dev->private)
 
-static int adl_pci7230_attach(struct comedi_device *dev,
-	struct comedi_devconfig *it);
-static int adl_pci7230_detach(struct comedi_device *dev);
-static struct comedi_driver driver_adl_pci7230 = {
-	.driver_name = "adl_pci7230",
-	.module = THIS_MODULE,
-	.attach = adl_pci7230_attach,
-	.detach = adl_pci7230_detach,
-};
+static int adl_pci7230_do_insn_bits(struct comedi_device *dev,
+	struct comedi_subdevice *s,
+	struct comedi_insn *insn,
+	unsigned int *data)
+{
+	if (insn->n != 2)
+		return -EINVAL;
 
-/* Digital IO */
+	if (data[0]) {
+		s->state &= ~data[0];
+		s->state |= (data[0] & data[1]);
+
+		outl((s->state  << 16) & 0xffffffff, dev->iobase + PCI7230_DO);
+	}
+
+	return 2;
+}
 
 static int adl_pci7230_di_insn_bits(struct comedi_device *dev,
 	struct comedi_subdevice *s,
 	struct comedi_insn *insn,
-	unsigned int *data);
+	unsigned int *data)
+{
+	if (insn->n != 2)
+		return -EINVAL;
 
-static int adl_pci7230_do_insn_bits(struct comedi_device *dev,
-	struct comedi_subdevice *s,
-	struct comedi_insn *insn,
-	unsigned int *data);
+	data[1] = inl(dev->iobase + PCI7230_DI) & 0xffffffff;
+
+	return 2;
+}
 
 static int adl_pci7230_attach(struct comedi_device *dev,
 	struct comedi_devconfig *it)
@@ -161,36 +163,12 @@ static int adl_pci7230_detach(struct comedi_device *dev)
 	return 0;
 }
 
-static int adl_pci7230_do_insn_bits(struct comedi_device *dev,
-	struct comedi_subdevice *s,
-	struct comedi_insn *insn,
-	unsigned int *data)
-{
-	if (insn->n != 2)
-		return -EINVAL;
-
-	if (data[0]) {
-		s->state &= ~data[0];
-		s->state |= (data[0] & data[1]);
-
-		outl((s->state  << 16) & 0xffffffff, dev->iobase + PCI7230_DO);
-	}
-
-	return 2;
-}
-
-static int adl_pci7230_di_insn_bits(struct comedi_device *dev,
-	struct comedi_subdevice *s,
-	struct comedi_insn *insn,
-	unsigned int *data)
-{
-	if (insn->n != 2)
-		return -EINVAL;
-
-	data[1] = inl(dev->iobase + PCI7230_DI) & 0xffffffff;
-
-	return 2;
-}
+static struct comedi_driver driver_adl_pci7230 = {
+	.driver_name	= "adl_pci7230",
+	.module		= THIS_MODULE,
+	.attach		= adl_pci7230_attach,
+	.detach		= adl_pci7230_detach,
+};
 
 static int __devinit driver_adl_pci7230_pci_probe(struct pci_dev *dev,
 						  const struct pci_device_id
@@ -204,10 +182,16 @@ static void __devexit driver_adl_pci7230_pci_remove(struct pci_dev *dev)
 	comedi_pci_auto_unconfig(dev);
 }
 
+static DEFINE_PCI_DEVICE_TABLE(adl_pci7230_pci_table) = {
+	{ PCI_DEVICE(PCI_VENDOR_ID_ADLINK, PCI_DEVICE_ID_PCI7230) },
+	{0}
+};
+MODULE_DEVICE_TABLE(pci, adl_pci7230_pci_table);
+
 static struct pci_driver driver_adl_pci7230_pci_driver = {
-	.id_table = adl_pci7230_pci_table,
-	.probe = &driver_adl_pci7230_pci_probe,
-	.remove = __devexit_p(&driver_adl_pci7230_pci_remove)
+	.id_table	= adl_pci7230_pci_table,
+	.probe		= driver_adl_pci7230_pci_probe,
+	.remove		= __devexit_p(driver_adl_pci7230_pci_remove)
 };
 
 static int __init driver_adl_pci7230_init_module(void)
@@ -222,14 +206,13 @@ static int __init driver_adl_pci7230_init_module(void)
 	    (char *)driver_adl_pci7230.driver_name;
 	return pci_register_driver(&driver_adl_pci7230_pci_driver);
 }
+module_init(driver_adl_pci7230_init_module);
 
 static void __exit driver_adl_pci7230_cleanup_module(void)
 {
 	pci_unregister_driver(&driver_adl_pci7230_pci_driver);
 	comedi_driver_unregister(&driver_adl_pci7230);
 }
-
-module_init(driver_adl_pci7230_init_module);
 module_exit(driver_adl_pci7230_cleanup_module);
 
 MODULE_AUTHOR("Comedi http://www.comedi.org");
