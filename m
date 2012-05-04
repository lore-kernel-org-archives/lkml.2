Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760708Ab2EDXuA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 19:50:00 -0400
Received: from mail131.messagelabs.com ([216.82.242.99]:48202 "EHLO
	mail131.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756751Ab2EDXt6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 19:49:58 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-10.tower-131.messagelabs.com!1336175396!21608604!3
X-Originating-IP: [216.166.12.72]
X-StarScan-Version: 6.5.7; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] staging: comedi: refactor dt3000 driver to remove forward declarations
Date: Fri, 4 May 2012 16:49:45 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201205041649.46016.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the module_init/module_exit routines and the associated
struct comedi_driver and other variables to the end of the source.
This is more typical of how other drivers are written.

Also, refactor a couple of the pci helper functions used during the
attach. The removes the need for the forward declarations.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---

diff --git a/drivers/staging/comedi/drivers/dt3000.c b/drivers/staging/comedi/drivers/dt3000.c
index d44c89d..932eac9 100644
--- a/drivers/staging/comedi/drivers/dt3000.c
+++ b/drivers/staging/comedi/drivers/dt3000.c
@@ -164,19 +164,6 @@ static const struct dt3k_boardtype dt3k_boardtypes[] = {
 #define n_dt3k_boards sizeof(dt3k_boardtypes)/sizeof(struct dt3k_boardtype)
 #define this_board ((const struct dt3k_boardtype *)dev->board_ptr)
 
-static DEFINE_PCI_DEVICE_TABLE(dt3k_pci_table) = {
-	{ PCI_DEVICE(PCI_VENDOR_ID_DT, 0x0022) },
-	{ PCI_DEVICE(PCI_VENDOR_ID_DT, 0x0027) },
-	{ PCI_DEVICE(PCI_VENDOR_ID_DT, 0x0023) },
-	{ PCI_DEVICE(PCI_VENDOR_ID_DT, 0x0024) },
-	{ PCI_DEVICE(PCI_VENDOR_ID_DT, 0x0028) },
-	{ PCI_DEVICE(PCI_VENDOR_ID_DT, 0x0025) },
-	{ PCI_DEVICE(PCI_VENDOR_ID_DT, 0x0026) },
-	{ 0 }
-};
-
-MODULE_DEVICE_TABLE(pci, dt3k_pci_table);
-
 #define DT3000_SIZE		(4*0x1000)
 
 /* dual-ported RAM location definitions */
@@ -276,54 +263,6 @@ struct dt3k_private {
 
 #define devpriv ((struct dt3k_private *)dev->private)
 
-static int dt3000_attach(struct comedi_device *dev,
-			 struct comedi_devconfig *it);
-static int dt3000_detach(struct comedi_device *dev);
-static struct comedi_driver driver_dt3000 = {
-	.driver_name = "dt3000",
-	.module = THIS_MODULE,
-	.attach = dt3000_attach,
-	.detach = dt3000_detach,
-};
-
-static int __devinit driver_dt3000_pci_probe(struct pci_dev *dev,
-					     const struct pci_device_id *ent)
-{
-	return comedi_pci_auto_config(dev, &driver_dt3000);
-}
-
-static void __devexit driver_dt3000_pci_remove(struct pci_dev *dev)
-{
-	comedi_pci_auto_unconfig(dev);
-}
-
-static struct pci_driver driver_dt3000_pci_driver = {
-	.id_table = dt3k_pci_table,
-	.probe = &driver_dt3000_pci_probe,
-	.remove = __devexit_p(&driver_dt3000_pci_remove)
-};
-
-static int __init driver_dt3000_init_module(void)
-{
-	int retval;
-
-	retval = comedi_driver_register(&driver_dt3000);
-	if (retval < 0)
-		return retval;
-
-	driver_dt3000_pci_driver.name = (char *)driver_dt3000.driver_name;
-	return pci_register_driver(&driver_dt3000_pci_driver);
-}
-
-static void __exit driver_dt3000_cleanup_module(void)
-{
-	pci_unregister_driver(&driver_dt3000_pci_driver);
-	comedi_driver_unregister(&driver_dt3000);
-}
-
-module_init(driver_dt3000_init_module);
-module_exit(driver_dt3000_cleanup_module);
-
 static void dt3k_ai_empty_fifo(struct comedi_device *dev,
 			       struct comedi_subdevice *s);
 static int dt3k_ns_to_timer(unsigned int timer_base, unsigned int *arg,
@@ -841,7 +780,77 @@ static int dt3k_mem_insn_read(struct comedi_device *dev,
 	return i;
 }
 
-static int dt_pci_probe(struct comedi_device *dev, int bus, int slot);
+static int setup_pci(struct comedi_device *dev)
+{
+	resource_size_t addr;
+	int ret;
+
+	ret = comedi_pci_enable(devpriv->pci_dev, "dt3000");
+	if (ret < 0)
+		return ret;
+
+	addr = pci_resource_start(devpriv->pci_dev, 0);
+	devpriv->phys_addr = addr;
+	devpriv->io_addr = ioremap(devpriv->phys_addr, DT3000_SIZE);
+	if (!devpriv->io_addr)
+		return -ENOMEM;
+#if DEBUG
+	printk("0x%08llx mapped to %p, ",
+	       (unsigned long long)devpriv->phys_addr, devpriv->io_addr);
+#endif
+
+	return 0;
+}
+
+static struct pci_dev *dt_pci_find_device(struct pci_dev *from, int *board)
+{
+	int i;
+
+	for (from = pci_get_device(PCI_VENDOR_ID_DT, PCI_ANY_ID, from);
+	     from != NULL;
+	     from = pci_get_device(PCI_VENDOR_ID_DT, PCI_ANY_ID, from)) {
+		for (i = 0; i < n_dt3k_boards; i++) {
+			if (from->device == dt3k_boardtypes[i].device_id) {
+				*board = i;
+				return from;
+			}
+		}
+		printk
+		    ("unknown Data Translation PCI device found with device_id=0x%04x\n",
+		     from->device);
+	}
+	*board = -1;
+	return from;
+}
+
+static int dt_pci_probe(struct comedi_device *dev, int bus, int slot)
+{
+	int board;
+	int ret;
+	struct pci_dev *pcidev;
+
+	pcidev = NULL;
+	while ((pcidev = dt_pci_find_device(pcidev, &board)) != NULL) {
+		if ((bus == 0 && slot == 0) ||
+		    (pcidev->bus->number == bus &&
+		     PCI_SLOT(pcidev->devfn) == slot)) {
+			break;
+		}
+	}
+	devpriv->pci_dev = pcidev;
+
+	if (board >= 0)
+		dev->board_ptr = dt3k_boardtypes + board;
+
+	if (!devpriv->pci_dev)
+		return 0;
+
+	ret = setup_pci(dev);
+	if (ret < 0)
+		return ret;
+
+	return 1;
+}
 
 static int dt3000_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 {
@@ -949,85 +958,65 @@ static int dt3000_detach(struct comedi_device *dev)
 		if (devpriv->io_addr)
 			iounmap(devpriv->io_addr);
 	}
-	/* XXX */
 
 	return 0;
 }
 
-static struct pci_dev *dt_pci_find_device(struct pci_dev *from, int *board);
-static int setup_pci(struct comedi_device *dev);
+static struct comedi_driver driver_dt3000 = {
+	.driver_name	= "dt3000",
+	.module		= THIS_MODULE,
+	.attach		= dt3000_attach,
+	.detach		= dt3000_detach,
+};
 
-static int dt_pci_probe(struct comedi_device *dev, int bus, int slot)
+static int __devinit driver_dt3000_pci_probe(struct pci_dev *dev,
+					     const struct pci_device_id *ent)
 {
-	int board;
-	int ret;
-	struct pci_dev *pcidev;
-
-	pcidev = NULL;
-	while ((pcidev = dt_pci_find_device(pcidev, &board)) != NULL) {
-		if ((bus == 0 && slot == 0) ||
-		    (pcidev->bus->number == bus &&
-		     PCI_SLOT(pcidev->devfn) == slot)) {
-			break;
-		}
-	}
-	devpriv->pci_dev = pcidev;
-
-	if (board >= 0)
-		dev->board_ptr = dt3k_boardtypes + board;
+	return comedi_pci_auto_config(dev, &driver_dt3000);
+}
 
-	if (!devpriv->pci_dev)
-		return 0;
+static void __devexit driver_dt3000_pci_remove(struct pci_dev *dev)
+{
+	comedi_pci_auto_unconfig(dev);
+}
 
-	ret = setup_pci(dev);
-	if (ret < 0)
-		return ret;
+static DEFINE_PCI_DEVICE_TABLE(dt3k_pci_table) = {
+	{ PCI_DEVICE(PCI_VENDOR_ID_DT, 0x0022) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_DT, 0x0027) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_DT, 0x0023) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_DT, 0x0024) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_DT, 0x0028) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_DT, 0x0025) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_DT, 0x0026) },
+	{ 0 }
+};
+MODULE_DEVICE_TABLE(pci, dt3k_pci_table);
 
-	return 1;
-}
+static struct pci_driver driver_dt3000_pci_driver = {
+	.id_table	= dt3k_pci_table,
+	.probe		= driver_dt3000_pci_probe,
+	.remove		= __devexit_p(driver_dt3000_pci_remove),
+};
 
-static int setup_pci(struct comedi_device *dev)
+static int __init driver_dt3000_init_module(void)
 {
-	resource_size_t addr;
-	int ret;
-
-	ret = comedi_pci_enable(devpriv->pci_dev, "dt3000");
-	if (ret < 0)
-		return ret;
+	int retval;
 
-	addr = pci_resource_start(devpriv->pci_dev, 0);
-	devpriv->phys_addr = addr;
-	devpriv->io_addr = ioremap(devpriv->phys_addr, DT3000_SIZE);
-	if (!devpriv->io_addr)
-		return -ENOMEM;
-#if DEBUG
-	printk("0x%08llx mapped to %p, ",
-	       (unsigned long long)devpriv->phys_addr, devpriv->io_addr);
-#endif
+	retval = comedi_driver_register(&driver_dt3000);
+	if (retval < 0)
+		return retval;
 
-	return 0;
+	driver_dt3000_pci_driver.name = (char *)driver_dt3000.driver_name;
+	return pci_register_driver(&driver_dt3000_pci_driver);
 }
+module_init(driver_dt3000_init_module);
 
-static struct pci_dev *dt_pci_find_device(struct pci_dev *from, int *board)
+static void __exit driver_dt3000_cleanup_module(void)
 {
-	int i;
-
-	for (from = pci_get_device(PCI_VENDOR_ID_DT, PCI_ANY_ID, from);
-	     from != NULL;
-	     from = pci_get_device(PCI_VENDOR_ID_DT, PCI_ANY_ID, from)) {
-		for (i = 0; i < n_dt3k_boards; i++) {
-			if (from->device == dt3k_boardtypes[i].device_id) {
-				*board = i;
-				return from;
-			}
-		}
-		printk
-		    ("unknown Data Translation PCI device found with device_id=0x%04x\n",
-		     from->device);
-	}
-	*board = -1;
-	return from;
+	pci_unregister_driver(&driver_dt3000_pci_driver);
+	comedi_driver_unregister(&driver_dt3000);
 }
+module_exit(driver_dt3000_cleanup_module);
 
 MODULE_AUTHOR("Comedi http://www.comedi.org");
 MODULE_DESCRIPTION("Comedi low-level driver");
