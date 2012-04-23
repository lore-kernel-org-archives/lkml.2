Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755997Ab2DWWhO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 18:37:14 -0400
Received: from mail160.messagelabs.com ([216.82.253.99]:12648 "EHLO
	mail160.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753640Ab2DWWhM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 18:37:12 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-11.tower-160.messagelabs.com!1335220622!3088357!8
X-Originating-IP: [216.166.12.32]
X-StarScan-Version: 6.5.7; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] staging: comedi: refactor adl_pci8164 driver to remove forward declarations
Date: Mon, 23 Apr 2012 15:37:02 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201204231537.03100.hartleys@visionengravers.com>
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

diff --git a/drivers/staging/comedi/drivers/adl_pci8164.c b/drivers/staging/comedi/drivers/adl_pci8164.c
index bd0c14b..6b32e45 100644
--- a/drivers/staging/comedi/drivers/adl_pci8164.c
+++ b/drivers/staging/comedi/drivers/adl_pci8164.c
@@ -56,13 +56,6 @@ Configuration Options:
 
 #define PCI_DEVICE_ID_PCI8164 0x8164
 
-static DEFINE_PCI_DEVICE_TABLE(adl_pci8164_pci_table) = {
-	{ PCI_DEVICE(PCI_VENDOR_ID_ADLINK, PCI_DEVICE_ID_PCI8164) },
-	{0}
-};
-
-MODULE_DEVICE_TABLE(pci, adl_pci8164_pci_table);
-
 struct adl_pci8164_private {
 	int data;
 	struct pci_dev *pci_dev;
@@ -70,159 +63,6 @@ struct adl_pci8164_private {
 
 #define devpriv ((struct adl_pci8164_private *)dev->private)
 
-static int adl_pci8164_attach(struct comedi_device *dev,
-			      struct comedi_devconfig *it);
-static int adl_pci8164_detach(struct comedi_device *dev);
-static struct comedi_driver driver_adl_pci8164 = {
-	.driver_name = "adl_pci8164",
-	.module = THIS_MODULE,
-	.attach = adl_pci8164_attach,
-	.detach = adl_pci8164_detach,
-};
-
-static int adl_pci8164_insn_read_msts(struct comedi_device *dev,
-				      struct comedi_subdevice *s,
-				      struct comedi_insn *insn,
-				      unsigned int *data);
-
-static int adl_pci8164_insn_read_ssts(struct comedi_device *dev,
-				      struct comedi_subdevice *s,
-				      struct comedi_insn *insn,
-				      unsigned int *data);
-
-static int adl_pci8164_insn_read_buf0(struct comedi_device *dev,
-				      struct comedi_subdevice *s,
-				      struct comedi_insn *insn,
-				      unsigned int *data);
-
-static int adl_pci8164_insn_read_buf1(struct comedi_device *dev,
-				      struct comedi_subdevice *s,
-				      struct comedi_insn *insn,
-				      unsigned int *data);
-
-static int adl_pci8164_insn_write_cmd(struct comedi_device *dev,
-				      struct comedi_subdevice *s,
-				      struct comedi_insn *insn,
-				      unsigned int *data);
-
-static int adl_pci8164_insn_write_otp(struct comedi_device *dev,
-				      struct comedi_subdevice *s,
-				      struct comedi_insn *insn,
-				      unsigned int *data);
-
-static int adl_pci8164_insn_write_buf0(struct comedi_device *dev,
-				       struct comedi_subdevice *s,
-				       struct comedi_insn *insn,
-				       unsigned int *data);
-
-static int adl_pci8164_insn_write_buf1(struct comedi_device *dev,
-				       struct comedi_subdevice *s,
-				       struct comedi_insn *insn,
-				       unsigned int *data);
-
-static int adl_pci8164_attach(struct comedi_device *dev,
-			      struct comedi_devconfig *it)
-{
-	struct pci_dev *pcidev = NULL;
-	struct comedi_subdevice *s;
-	int bus, slot;
-
-	printk(KERN_INFO "comedi: attempt to attach...\n");
-	printk(KERN_INFO "comedi%d: adl_pci8164\n", dev->minor);
-
-	dev->board_name = "pci8164";
-	bus = it->options[0];
-	slot = it->options[1];
-
-	if (alloc_private(dev, sizeof(struct adl_pci8164_private)) < 0)
-		return -ENOMEM;
-
-	if (alloc_subdevices(dev, 4) < 0)
-		return -ENOMEM;
-
-	for_each_pci_dev(pcidev) {
-		if (pcidev->vendor == PCI_VENDOR_ID_ADLINK &&
-		    pcidev->device == PCI_DEVICE_ID_PCI8164) {
-			if (bus || slot) {
-				/* requested particular bus/slot */
-				if (pcidev->bus->number != bus
-					|| PCI_SLOT(pcidev->devfn) != slot)
-					continue;
-			}
-			devpriv->pci_dev = pcidev;
-			if (comedi_pci_enable(pcidev, "adl_pci8164") < 0) {
-				printk(KERN_ERR "comedi%d: Failed to enable "
-				"PCI device and request regions\n", dev->minor);
-				return -EIO;
-			}
-			dev->iobase = pci_resource_start(pcidev, 2);
-			printk(KERN_DEBUG "comedi: base addr %4lx\n",
-				   dev->iobase);
-
-			s = dev->subdevices + 0;
-			s->type = COMEDI_SUBD_PROC;
-			s->subdev_flags = SDF_READABLE | SDF_WRITABLE;
-			s->n_chan = 4;
-			s->maxdata = 0xffff;
-			s->len_chanlist = 4;
-			/* s->range_table = &range_axis; */
-			s->insn_read = adl_pci8164_insn_read_msts;
-			s->insn_write = adl_pci8164_insn_write_cmd;
-
-			s = dev->subdevices + 1;
-			s->type = COMEDI_SUBD_PROC;
-			s->subdev_flags = SDF_READABLE | SDF_WRITABLE;
-			s->n_chan = 4;
-			s->maxdata = 0xffff;
-			s->len_chanlist = 4;
-			/* s->range_table = &range_axis; */
-			s->insn_read = adl_pci8164_insn_read_ssts;
-			s->insn_write = adl_pci8164_insn_write_otp;
-
-			s = dev->subdevices + 2;
-			s->type = COMEDI_SUBD_PROC;
-			s->subdev_flags = SDF_READABLE | SDF_WRITABLE;
-			s->n_chan = 4;
-			s->maxdata = 0xffff;
-			s->len_chanlist = 4;
-			/* s->range_table = &range_axis; */
-			s->insn_read = adl_pci8164_insn_read_buf0;
-			s->insn_write = adl_pci8164_insn_write_buf0;
-
-			s = dev->subdevices + 3;
-			s->type = COMEDI_SUBD_PROC;
-			s->subdev_flags = SDF_READABLE | SDF_WRITABLE;
-			s->n_chan = 4;
-			s->maxdata = 0xffff;
-			s->len_chanlist = 4;
-			/* s->range_table = &range_axis; */
-			s->insn_read = adl_pci8164_insn_read_buf1;
-			s->insn_write = adl_pci8164_insn_write_buf1;
-
-			printk(KERN_INFO "comedi: attached\n");
-
-			return 1;
-		}
-	}
-
-	printk(KERN_ERR "comedi%d: no supported board found!"
-		   "(req. bus/slot : %d/%d)\n", dev->minor, bus, slot);
-	return -EIO;
-}
-
-static int adl_pci8164_detach(struct comedi_device *dev)
-{
-	printk(KERN_INFO "comedi%d: pci8164: remove\n", dev->minor);
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
 /*
  all the read commands are the same except for the addition a constant
  * const to the data for inw()
@@ -384,6 +224,116 @@ static int adl_pci8164_insn_write_buf1(struct comedi_device *dev,
 	return 2;
 }
 
+static int adl_pci8164_attach(struct comedi_device *dev,
+			      struct comedi_devconfig *it)
+{
+	struct pci_dev *pcidev = NULL;
+	struct comedi_subdevice *s;
+	int bus, slot;
+
+	printk(KERN_INFO "comedi: attempt to attach...\n");
+	printk(KERN_INFO "comedi%d: adl_pci8164\n", dev->minor);
+
+	dev->board_name = "pci8164";
+	bus = it->options[0];
+	slot = it->options[1];
+
+	if (alloc_private(dev, sizeof(struct adl_pci8164_private)) < 0)
+		return -ENOMEM;
+
+	if (alloc_subdevices(dev, 4) < 0)
+		return -ENOMEM;
+
+	for_each_pci_dev(pcidev) {
+		if (pcidev->vendor == PCI_VENDOR_ID_ADLINK &&
+		    pcidev->device == PCI_DEVICE_ID_PCI8164) {
+			if (bus || slot) {
+				/* requested particular bus/slot */
+				if (pcidev->bus->number != bus
+					|| PCI_SLOT(pcidev->devfn) != slot)
+					continue;
+			}
+			devpriv->pci_dev = pcidev;
+			if (comedi_pci_enable(pcidev, "adl_pci8164") < 0) {
+				printk(KERN_ERR "comedi%d: Failed to enable "
+				"PCI device and request regions\n", dev->minor);
+				return -EIO;
+			}
+			dev->iobase = pci_resource_start(pcidev, 2);
+			printk(KERN_DEBUG "comedi: base addr %4lx\n",
+				   dev->iobase);
+
+			s = dev->subdevices + 0;
+			s->type = COMEDI_SUBD_PROC;
+			s->subdev_flags = SDF_READABLE | SDF_WRITABLE;
+			s->n_chan = 4;
+			s->maxdata = 0xffff;
+			s->len_chanlist = 4;
+			/* s->range_table = &range_axis; */
+			s->insn_read = adl_pci8164_insn_read_msts;
+			s->insn_write = adl_pci8164_insn_write_cmd;
+
+			s = dev->subdevices + 1;
+			s->type = COMEDI_SUBD_PROC;
+			s->subdev_flags = SDF_READABLE | SDF_WRITABLE;
+			s->n_chan = 4;
+			s->maxdata = 0xffff;
+			s->len_chanlist = 4;
+			/* s->range_table = &range_axis; */
+			s->insn_read = adl_pci8164_insn_read_ssts;
+			s->insn_write = adl_pci8164_insn_write_otp;
+
+			s = dev->subdevices + 2;
+			s->type = COMEDI_SUBD_PROC;
+			s->subdev_flags = SDF_READABLE | SDF_WRITABLE;
+			s->n_chan = 4;
+			s->maxdata = 0xffff;
+			s->len_chanlist = 4;
+			/* s->range_table = &range_axis; */
+			s->insn_read = adl_pci8164_insn_read_buf0;
+			s->insn_write = adl_pci8164_insn_write_buf0;
+
+			s = dev->subdevices + 3;
+			s->type = COMEDI_SUBD_PROC;
+			s->subdev_flags = SDF_READABLE | SDF_WRITABLE;
+			s->n_chan = 4;
+			s->maxdata = 0xffff;
+			s->len_chanlist = 4;
+			/* s->range_table = &range_axis; */
+			s->insn_read = adl_pci8164_insn_read_buf1;
+			s->insn_write = adl_pci8164_insn_write_buf1;
+
+			printk(KERN_INFO "comedi: attached\n");
+
+			return 1;
+		}
+	}
+
+	printk(KERN_ERR "comedi%d: no supported board found!"
+		   "(req. bus/slot : %d/%d)\n", dev->minor, bus, slot);
+	return -EIO;
+}
+
+static int adl_pci8164_detach(struct comedi_device *dev)
+{
+	printk(KERN_INFO "comedi%d: pci8164: remove\n", dev->minor);
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
+static struct comedi_driver driver_adl_pci8164 = {
+	.driver_name	= "adl_pci8164",
+	.module		= THIS_MODULE,
+	.attach		= adl_pci8164_attach,
+	.detach		= adl_pci8164_detach,
+};
+
 static int __devinit driver_adl_pci8164_pci_probe(struct pci_dev *dev,
 						  const struct pci_device_id
 						  *ent)
@@ -396,10 +346,16 @@ static void __devexit driver_adl_pci8164_pci_remove(struct pci_dev *dev)
 	comedi_pci_auto_unconfig(dev);
 }
 
+static DEFINE_PCI_DEVICE_TABLE(adl_pci8164_pci_table) = {
+	{ PCI_DEVICE(PCI_VENDOR_ID_ADLINK, PCI_DEVICE_ID_PCI8164) },
+	{0}
+};
+MODULE_DEVICE_TABLE(pci, adl_pci8164_pci_table);
+
 static struct pci_driver driver_adl_pci8164_pci_driver = {
-	.id_table = adl_pci8164_pci_table,
-	.probe = &driver_adl_pci8164_pci_probe,
-	.remove = __devexit_p(&driver_adl_pci8164_pci_remove)
+	.id_table	= adl_pci8164_pci_table,
+	.probe		= driver_adl_pci8164_pci_probe,
+	.remove		= __devexit_p(driver_adl_pci8164_pci_remove),
 };
 
 static int __init driver_adl_pci8164_init_module(void)
@@ -414,14 +370,13 @@ static int __init driver_adl_pci8164_init_module(void)
 	    (char *)driver_adl_pci8164.driver_name;
 	return pci_register_driver(&driver_adl_pci8164_pci_driver);
 }
+module_init(driver_adl_pci8164_init_module);
 
 static void __exit driver_adl_pci8164_cleanup_module(void)
 {
 	pci_unregister_driver(&driver_adl_pci8164_pci_driver);
 	comedi_driver_unregister(&driver_adl_pci8164);
 }
-
-module_init(driver_adl_pci8164_init_module);
 module_exit(driver_adl_pci8164_cleanup_module);
 
 MODULE_AUTHOR("Comedi http://www.comedi.org");
