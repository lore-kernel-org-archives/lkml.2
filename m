Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758760Ab2EPBXM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 21:23:12 -0400
Received: from mail127.messagelabs.com ([216.82.250.115]:57374 "EHLO
	mail127.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757983Ab2EPBXK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 21:23:10 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-7.tower-127.messagelabs.com!1337131381!5629290!6
X-Originating-IP: [216.166.12.69]
X-StarScan-Version: 6.5.7; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] staging: comedi: refactor contec_pci_dio driver and use module_comedi_pci_driver
Date: Tue, 15 May 2012 18:23:03 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201205151823.03576.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the module_init/module_exit routines and the associated
struct comedi_drive and struct pci_driver to the end of the
source. This is more typical of how other drivers are written
and removes the need for the forward declarations.

Refactor some of the other functions to remove the remaining
forward declarations.

Remove some unused code stubs that are in #if 0 / #endif
blocks.

Convert the driver to use the module_comedi_pci_driver() macro
which makes the code smaller and a bit simpler.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---

 drivers/staging/comedi/drivers/contec_pci_dio.c |  157 ++++++++---------------
 1 files changed, 53 insertions(+), 104 deletions(-)

diff --git a/drivers/staging/comedi/drivers/contec_pci_dio.c b/drivers/staging/comedi/drivers/contec_pci_dio.c
index 621e8af..9dc3a92 100644
--- a/drivers/staging/comedi/drivers/contec_pci_dio.c
+++ b/drivers/staging/comedi/drivers/contec_pci_dio.c
@@ -56,13 +56,6 @@ static const struct contec_board contec_boards[] = {
 };
 
 #define PCI_DEVICE_ID_PIO1616L 0x8172
-static DEFINE_PCI_DEVICE_TABLE(contec_pci_table) = {
-	{ PCI_DEVICE(PCI_VENDOR_ID_CONTEC, PCI_DEVICE_ID_PIO1616L),
-		.driver_data = PIO1616L },
-	{0}
-};
-
-MODULE_DEVICE_TABLE(pci, contec_pci_table);
 
 #define thisboard ((const struct contec_board *)dev->board_ptr)
 
@@ -75,30 +68,42 @@ struct contec_private {
 
 #define devpriv ((struct contec_private *)dev->private)
 
-static int contec_attach(struct comedi_device *dev,
-			 struct comedi_devconfig *it);
-static int contec_detach(struct comedi_device *dev);
-static struct comedi_driver driver_contec = {
-	.driver_name = "contec_pci_dio",
-	.module = THIS_MODULE,
-	.attach = contec_attach,
-	.detach = contec_detach,
-};
-
-/* Classic digital IO */
-static int contec_di_insn_bits(struct comedi_device *dev,
-			       struct comedi_subdevice *s,
-			       struct comedi_insn *insn, unsigned int *data);
 static int contec_do_insn_bits(struct comedi_device *dev,
 			       struct comedi_subdevice *s,
-			       struct comedi_insn *insn, unsigned int *data);
+			       struct comedi_insn *insn, unsigned int *data)
+{
 
-#if 0
-static int contec_cmdtest(struct comedi_device *dev, struct comedi_subdevice *s,
-			  struct comedi_cmd *cmd);
+	dev_dbg(dev->hw_dev, "contec_do_insn_bits called\n");
+	dev_dbg(dev->hw_dev, "data: %d %d\n", data[0], data[1]);
 
-static int contec_ns_to_timer(unsigned int *ns, int round);
-#endif
+	if (insn->n != 2)
+		return -EINVAL;
+
+	if (data[0]) {
+		s->state &= ~data[0];
+		s->state |= data[0] & data[1];
+		dev_dbg(dev->hw_dev, "out: %d on %lx\n", s->state,
+			dev->iobase + thisboard->out_offs);
+		outw(s->state, dev->iobase + thisboard->out_offs);
+	}
+	return 2;
+}
+
+static int contec_di_insn_bits(struct comedi_device *dev,
+			       struct comedi_subdevice *s,
+			       struct comedi_insn *insn, unsigned int *data)
+{
+
+	dev_dbg(dev->hw_dev, "contec_di_insn_bits called\n");
+	dev_dbg(dev->hw_dev, "data: %d %d\n", data[0], data[1]);
+
+	if (insn->n != 2)
+		return -EINVAL;
+
+	data[1] = inw(dev->iobase + thisboard->in_offs);
+
+	return 2;
+}
 
 static int contec_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 {
@@ -177,94 +182,38 @@ static int contec_detach(struct comedi_device *dev)
 	return 0;
 }
 
-#if 0
-static int contec_cmdtest(struct comedi_device *dev, struct comedi_subdevice *s,
-			  struct comedi_cmd *cmd)
-{
-	printk("contec_cmdtest called\n");
-	return 0;
-}
-
-static int contec_ns_to_timer(unsigned int *ns, int round)
-{
-	return *ns;
-}
-#endif
-
-static int contec_do_insn_bits(struct comedi_device *dev,
-			       struct comedi_subdevice *s,
-			       struct comedi_insn *insn, unsigned int *data)
-{
-
-	dev_dbg(dev->hw_dev, "contec_do_insn_bits called\n");
-	dev_dbg(dev->hw_dev, "data: %d %d\n", data[0], data[1]);
-
-	if (insn->n != 2)
-		return -EINVAL;
-
-	if (data[0]) {
-		s->state &= ~data[0];
-		s->state |= data[0] & data[1];
-		dev_dbg(dev->hw_dev, "out: %d on %lx\n", s->state,
-			dev->iobase + thisboard->out_offs);
-		outw(s->state, dev->iobase + thisboard->out_offs);
-	}
-	return 2;
-}
-
-static int contec_di_insn_bits(struct comedi_device *dev,
-			       struct comedi_subdevice *s,
-			       struct comedi_insn *insn, unsigned int *data)
-{
-
-	dev_dbg(dev->hw_dev, "contec_di_insn_bits called\n");
-	dev_dbg(dev->hw_dev, "data: %d %d\n", data[0], data[1]);
-
-	if (insn->n != 2)
-		return -EINVAL;
-
-	data[1] = inw(dev->iobase + thisboard->in_offs);
-
-	return 2;
-}
+static struct comedi_driver contec_pci_dio_driver = {
+	.driver_name	= "contec_pci_dio",
+	.module		= THIS_MODULE,
+	.attach		= contec_attach,
+	.detach		= contec_detach,
+};
 
-static int __devinit driver_contec_pci_probe(struct pci_dev *dev,
-					     const struct pci_device_id *ent)
+static int __devinit contec_pci_dio_pci_probe(struct pci_dev *dev,
+					      const struct pci_device_id *ent)
 {
-	return comedi_pci_auto_config(dev, &driver_contec);
+	return comedi_pci_auto_config(dev, &contec_pci_dio_driver);
 }
 
-static void __devexit driver_contec_pci_remove(struct pci_dev *dev)
+static void __devexit contec_pci_dio_pci_remove(struct pci_dev *dev)
 {
 	comedi_pci_auto_unconfig(dev);
 }
 
-static struct pci_driver driver_contec_pci_driver = {
-	.id_table = contec_pci_table,
-	.probe = &driver_contec_pci_probe,
-	.remove = __devexit_p(&driver_contec_pci_remove)
+static DEFINE_PCI_DEVICE_TABLE(contec_pci_dio_pci_table) = {
+	{ PCI_DEVICE(PCI_VENDOR_ID_CONTEC, PCI_DEVICE_ID_PIO1616L),
+		.driver_data = PIO1616L },
+	{ 0 }
 };
+MODULE_DEVICE_TABLE(pci, contec_pci_dio_pci_table);
 
-static int __init driver_contec_init_module(void)
-{
-	int retval;
-
-	retval = comedi_driver_register(&driver_contec);
-	if (retval < 0)
-		return retval;
-
-	driver_contec_pci_driver.name = (char *)driver_contec.driver_name;
-	return pci_register_driver(&driver_contec_pci_driver);
-}
-
-static void __exit driver_contec_cleanup_module(void)
-{
-	pci_unregister_driver(&driver_contec_pci_driver);
-	comedi_driver_unregister(&driver_contec);
-}
-
-module_init(driver_contec_init_module);
-module_exit(driver_contec_cleanup_module);
+static struct pci_driver contec_pci_dio_pci_driver = {
+	.name		= "contec_pci_dio",
+	.id_table	= contec_pci_dio_pci_table,
+	.probe		= contec_pci_dio_pci_probe,
+	.remove		= __devexit_p(contec_pci_dio_pci_remove),
+};
+module_comedi_pci_driver(contec_pci_dio_driver, contec_pci_dio_pci_driver);
 
 MODULE_AUTHOR("Comedi http://www.comedi.org");
 MODULE_DESCRIPTION("Comedi low-level driver");
