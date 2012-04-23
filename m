Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755635Ab2DWWGv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 18:06:51 -0400
Received: from mail127.messagelabs.com ([216.82.250.115]:59803 "EHLO
	mail127.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753640Ab2DWWGu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 18:06:50 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-14.tower-127.messagelabs.com!1335218808!3836829!1
X-Originating-IP: [216.166.12.99]
X-StarScan-Version: 6.5.7; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] staging: comedi: refactor the adl_pci6208 driver to remove the forward declarations
Date: Mon, 23 Apr 2012 15:06:21 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201204231506.22380.hartleys@visionengravers.com>
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

diff --git a/drivers/staging/comedi/drivers/adl_pci6208.c b/drivers/staging/comedi/drivers/adl_pci6208.c
index de0ec80..889d147 100644
--- a/drivers/staging/comedi/drivers/adl_pci6208.c
+++ b/drivers/staging/comedi/drivers/adl_pci6208.c
@@ -85,17 +85,6 @@ static const struct pci6208_board pci6208_boards[] = {
 	 }
 };
 
-/* This is used by modprobe to translate PCI IDs to drivers.  Should
- * only be used for PCI and ISA-PnP devices */
-static DEFINE_PCI_DEVICE_TABLE(pci6208_pci_table) = {
-	/* { PCI_VENDOR_ID_ADLINK, 0x6208, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0 }, */
-	/* { PCI_VENDOR_ID_ADLINK, 0x6208, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0 }, */
-	{ PCI_DEVICE(PCI_VENDOR_ID_ADLINK, 0x6208) },
-	{ 0 }
-};
-
-MODULE_DEVICE_TABLE(pci, pci6208_pci_table);
-
 /* Will be initialized in pci6208_find device(). */
 #define thisboard ((const struct pci6208_board *)dev->board_ptr)
 
@@ -107,157 +96,6 @@ struct pci6208_private {
 
 #define devpriv ((struct pci6208_private *)dev->private)
 
-static int pci6208_attach(struct comedi_device *dev,
-			  struct comedi_devconfig *it);
-static int pci6208_detach(struct comedi_device *dev);
-
-static struct comedi_driver driver_pci6208 = {
-	.driver_name = PCI6208_DRIVER_NAME,
-	.module = THIS_MODULE,
-	.attach = pci6208_attach,
-	.detach = pci6208_detach,
-};
-
-static int __devinit driver_pci6208_pci_probe(struct pci_dev *dev,
-					      const struct pci_device_id *ent)
-{
-	return comedi_pci_auto_config(dev, &driver_pci6208);
-}
-
-static void __devexit driver_pci6208_pci_remove(struct pci_dev *dev)
-{
-	comedi_pci_auto_unconfig(dev);
-}
-
-static struct pci_driver driver_pci6208_pci_driver = {
-	.id_table = pci6208_pci_table,
-	.probe = &driver_pci6208_pci_probe,
-	.remove = __devexit_p(&driver_pci6208_pci_remove)
-};
-
-static int __init driver_pci6208_init_module(void)
-{
-	int retval;
-
-	retval = comedi_driver_register(&driver_pci6208);
-	if (retval < 0)
-		return retval;
-
-	driver_pci6208_pci_driver.name = (char *)driver_pci6208.driver_name;
-	return pci_register_driver(&driver_pci6208_pci_driver);
-}
-
-static void __exit driver_pci6208_cleanup_module(void)
-{
-	pci_unregister_driver(&driver_pci6208_pci_driver);
-	comedi_driver_unregister(&driver_pci6208);
-}
-
-module_init(driver_pci6208_init_module);
-module_exit(driver_pci6208_cleanup_module);
-
-static int pci6208_find_device(struct comedi_device *dev, int bus, int slot);
-static int
-pci6208_pci_setup(struct pci_dev *pci_dev, unsigned long *io_base_ptr,
-		  int dev_minor);
-
-/*read/write functions*/
-static int pci6208_ao_winsn(struct comedi_device *dev,
-			    struct comedi_subdevice *s,
-			    struct comedi_insn *insn, unsigned int *data);
-static int pci6208_ao_rinsn(struct comedi_device *dev,
-			    struct comedi_subdevice *s,
-			    struct comedi_insn *insn, unsigned int *data);
-/* static int pci6208_dio_insn_bits (struct comedi_device *dev,
- *					struct comedi_subdevice *s, */
-/* struct comedi_insn *insn,unsigned int *data); */
-/* static int pci6208_dio_insn_config(struct comedi_device *dev,
- *					struct comedi_subdevice *s, */
-/* struct comedi_insn *insn,unsigned int *data); */
-
-/*
- * Attach is called by the Comedi core to configure the driver
- * for a particular board.  If you specified a board_name array
- * in the driver structure, dev->board_ptr contains that
- * address.
- */
-static int pci6208_attach(struct comedi_device *dev,
-			  struct comedi_devconfig *it)
-{
-	struct comedi_subdevice *s;
-	int retval;
-	unsigned long io_base;
-
-	printk(KERN_INFO "comedi%d: pci6208: ", dev->minor);
-
-	retval = alloc_private(dev, sizeof(struct pci6208_private));
-	if (retval < 0)
-		return retval;
-
-	retval = pci6208_find_device(dev, it->options[0], it->options[1]);
-	if (retval < 0)
-		return retval;
-
-	retval = pci6208_pci_setup(devpriv->pci_dev, &io_base, dev->minor);
-	if (retval < 0)
-		return retval;
-
-	dev->iobase = io_base;
-	dev->board_name = thisboard->name;
-
-/*
- * Allocate the subdevice structures.  alloc_subdevice() is a
- * convenient macro defined in comedidev.h.
- */
-	if (alloc_subdevices(dev, 2) < 0)
-		return -ENOMEM;
-
-	s = dev->subdevices + 0;
-	/* analog output subdevice */
-	s->type = COMEDI_SUBD_AO;
-	s->subdev_flags = SDF_WRITABLE;	/* anything else to add here?? */
-	s->n_chan = thisboard->ao_chans;
-	s->maxdata = 0xffff;	/* 16-bit DAC */
-	s->range_table = &range_bipolar10;	/* this needs to be checked. */
-	s->insn_write = pci6208_ao_winsn;
-	s->insn_read = pci6208_ao_rinsn;
-
-	/* s=dev->subdevices+1; */
-	/* digital i/o subdevice */
-	/* s->type=COMEDI_SUBD_DIO; */
-	/* s->subdev_flags=SDF_READABLE|SDF_WRITABLE; */
-	/* s->n_chan=16; */
-	/* s->maxdata=1; */
-	/* s->range_table=&range_digital; */
-	/* s->insn_bits = pci6208_dio_insn_bits; */
-	/* s->insn_config = pci6208_dio_insn_config; */
-
-	printk(KERN_INFO "attached\n");
-
-	return 1;
-}
-
-/*
- * _detach is called to deconfigure a device.  It should deallocate
- * resources.
- * This function is also called when _attach() fails, so it should be
- * careful not to release resources that were not necessarily
- * allocated by _attach().  dev->private and dev->subdevices are
- * deallocated automatically by the core.
- */
-static int pci6208_detach(struct comedi_device *dev)
-{
-	printk(KERN_INFO "comedi%d: pci6208: remove\n", dev->minor);
-
-	if (devpriv && devpriv->pci_dev) {
-		if (dev->iobase)
-			comedi_pci_disable(devpriv->pci_dev);
-		pci_dev_put(devpriv->pci_dev);
-	}
-
-	return 0;
-}
-
 static int pci6208_ao_winsn(struct comedi_device *dev,
 			    struct comedi_subdevice *s,
 			    struct comedi_insn *insn, unsigned int *data)
@@ -442,6 +280,125 @@ pci6208_pci_setup(struct pci_dev *pci_dev, unsigned long *io_base_ptr,
 	return 0;
 }
 
+static int pci6208_attach(struct comedi_device *dev,
+			  struct comedi_devconfig *it)
+{
+	struct comedi_subdevice *s;
+	int retval;
+	unsigned long io_base;
+
+	printk(KERN_INFO "comedi%d: pci6208: ", dev->minor);
+
+	retval = alloc_private(dev, sizeof(struct pci6208_private));
+	if (retval < 0)
+		return retval;
+
+	retval = pci6208_find_device(dev, it->options[0], it->options[1]);
+	if (retval < 0)
+		return retval;
+
+	retval = pci6208_pci_setup(devpriv->pci_dev, &io_base, dev->minor);
+	if (retval < 0)
+		return retval;
+
+	dev->iobase = io_base;
+	dev->board_name = thisboard->name;
+
+	if (alloc_subdevices(dev, 2) < 0)
+		return -ENOMEM;
+
+	s = dev->subdevices + 0;
+	/* analog output subdevice */
+	s->type = COMEDI_SUBD_AO;
+	s->subdev_flags = SDF_WRITABLE;	/* anything else to add here?? */
+	s->n_chan = thisboard->ao_chans;
+	s->maxdata = 0xffff;	/* 16-bit DAC */
+	s->range_table = &range_bipolar10;	/* this needs to be checked. */
+	s->insn_write = pci6208_ao_winsn;
+	s->insn_read = pci6208_ao_rinsn;
+
+	/* s=dev->subdevices+1; */
+	/* digital i/o subdevice */
+	/* s->type=COMEDI_SUBD_DIO; */
+	/* s->subdev_flags=SDF_READABLE|SDF_WRITABLE; */
+	/* s->n_chan=16; */
+	/* s->maxdata=1; */
+	/* s->range_table=&range_digital; */
+	/* s->insn_bits = pci6208_dio_insn_bits; */
+	/* s->insn_config = pci6208_dio_insn_config; */
+
+	printk(KERN_INFO "attached\n");
+
+	return 1;
+}
+
+static int pci6208_detach(struct comedi_device *dev)
+{
+	printk(KERN_INFO "comedi%d: pci6208: remove\n", dev->minor);
+
+	if (devpriv && devpriv->pci_dev) {
+		if (dev->iobase)
+			comedi_pci_disable(devpriv->pci_dev);
+		pci_dev_put(devpriv->pci_dev);
+	}
+
+	return 0;
+}
+
+static struct comedi_driver driver_pci6208 = {
+	.driver_name	= PCI6208_DRIVER_NAME,
+	.module		= THIS_MODULE,
+	.attach		= pci6208_attach,
+	.detach		= pci6208_detach,
+};
+
+static int __devinit driver_pci6208_pci_probe(struct pci_dev *dev,
+					      const struct pci_device_id *ent)
+{
+	return comedi_pci_auto_config(dev, &driver_pci6208);
+}
+
+static void __devexit driver_pci6208_pci_remove(struct pci_dev *dev)
+{
+	comedi_pci_auto_unconfig(dev);
+}
+
+/* This is used by modprobe to translate PCI IDs to drivers.  Should
+ * only be used for PCI and ISA-PnP devices */
+static DEFINE_PCI_DEVICE_TABLE(pci6208_pci_table) = {
+	/* { PCI_VENDOR_ID_ADLINK, 0x6208, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0 }, */
+	/* { PCI_VENDOR_ID_ADLINK, 0x6208, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0 }, */
+	{ PCI_DEVICE(PCI_VENDOR_ID_ADLINK, 0x6208) },
+	{ 0 }
+};
+MODULE_DEVICE_TABLE(pci, pci6208_pci_table);
+
+static struct pci_driver driver_pci6208_pci_driver = {
+	.id_table	= pci6208_pci_table,
+	.probe		= driver_pci6208_pci_probe,
+	.remove		= __devexit_p(driver_pci6208_pci_remove),
+};
+
+static int __init driver_pci6208_init_module(void)
+{
+	int retval;
+
+	retval = comedi_driver_register(&driver_pci6208);
+	if (retval < 0)
+		return retval;
+
+	driver_pci6208_pci_driver.name = (char *)driver_pci6208.driver_name;
+	return pci_register_driver(&driver_pci6208_pci_driver);
+}
+module_init(driver_pci6208_init_module);
+
+static void __exit driver_pci6208_cleanup_module(void)
+{
+	pci_unregister_driver(&driver_pci6208_pci_driver);
+	comedi_driver_unregister(&driver_pci6208);
+}
+module_exit(driver_pci6208_cleanup_module);
+
 MODULE_AUTHOR("Comedi http://www.comedi.org");
 MODULE_DESCRIPTION("Comedi low-level driver");
 MODULE_LICENSE("GPL");
