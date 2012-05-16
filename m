Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967085Ab2EPAJQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 20:09:16 -0400
Received: from mail131.messagelabs.com ([216.82.242.99]:22506 "EHLO
	mail131.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966737Ab2EPAJP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 20:09:15 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-8.tower-131.messagelabs.com!1337126954!4941596!1
X-Originating-IP: [216.166.12.32]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] staging: comedi: refactor ni_pcidio driver and use module_comedi_driver
Date: Tue, 15 May 2012 17:09:09 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201205151709.10241.hartleys@visionengravers.com>
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

More refactoring needs to be done to remove the remaining
forward declarations. Doing that is this patch makes it
difficult to review.

 drivers/staging/comedi/drivers/ni_pcidio.c |  137 ++++++++++++----------------
 1 files changed, 57 insertions(+), 80 deletions(-)

diff --git a/drivers/staging/comedi/drivers/ni_pcidio.c b/drivers/staging/comedi/drivers/ni_pcidio.c
index 6452841..ed42ee3 100644
--- a/drivers/staging/comedi/drivers/ni_pcidio.c
+++ b/drivers/staging/comedi/drivers/ni_pcidio.c
@@ -293,18 +293,9 @@ enum FPGA_Control_Bits {
 #define IntEn (TransferReady|CountExpired|Waited|PrimaryTC|SecondaryTC)
 #endif
 
-static int nidio_attach(struct comedi_device *dev, struct comedi_devconfig *it);
-static int nidio_detach(struct comedi_device *dev);
 static int ni_pcidio_cancel(struct comedi_device *dev,
 			    struct comedi_subdevice *s);
 
-static struct comedi_driver driver_pcidio = {
-	.driver_name = "ni_pcidio",
-	.module = THIS_MODULE,
-	.attach = nidio_attach,
-	.detach = nidio_detach,
-};
-
 struct nidio_board {
 
 	int dev_id;
@@ -381,22 +372,6 @@ static const struct nidio_board nidio_boards[] = {
 #define n_nidio_boards ARRAY_SIZE(nidio_boards)
 #define this_board ((const struct nidio_board *)dev->board_ptr)
 
-static DEFINE_PCI_DEVICE_TABLE(ni_pcidio_pci_table) = {
-	{PCI_DEVICE(PCI_VENDOR_ID_NI, 0x1150)},
-	{PCI_DEVICE(PCI_VENDOR_ID_NI, 0x1320)},
-	{PCI_DEVICE(PCI_VENDOR_ID_NI, 0x12b0)},
-	{PCI_DEVICE(PCI_VENDOR_ID_NI, 0x0160)},
-	{PCI_DEVICE(PCI_VENDOR_ID_NI, 0x1630)},
-	{PCI_DEVICE(PCI_VENDOR_ID_NI, 0x13c0)},
-	{PCI_DEVICE(PCI_VENDOR_ID_NI, 0x0400)},
-	{PCI_DEVICE(PCI_VENDOR_ID_NI, 0x1250)},
-	{PCI_DEVICE(PCI_VENDOR_ID_NI, 0x17d0)},
-	{PCI_DEVICE(PCI_VENDOR_ID_NI, 0x1800)},
-	{0}
-};
-
-MODULE_DEVICE_TABLE(pci, ni_pcidio_pci_table);
-
 struct nidio96_private {
 	struct mite_struct *mite;
 	int boardtype;
@@ -414,7 +389,6 @@ static int ni_pcidio_cmdtest(struct comedi_device *dev,
 static int ni_pcidio_cmd(struct comedi_device *dev, struct comedi_subdevice *s);
 static int ni_pcidio_inttrig(struct comedi_device *dev,
 			     struct comedi_subdevice *s, unsigned int trignum);
-static int nidio_find_device(struct comedi_device *dev, int bus, int slot);
 static int ni_pcidio_ns_to_timer(int *nanosec, int round_mode);
 static int setup_mite_dma(struct comedi_device *dev,
 			  struct comedi_subdevice *s);
@@ -1205,6 +1179,33 @@ static int pci_6534_upload_firmware(struct comedi_device *dev, int options[])
 	return 0;
 }
 
+static int nidio_find_device(struct comedi_device *dev, int bus, int slot)
+{
+	struct mite_struct *mite;
+	int i;
+
+	for (mite = mite_devices; mite; mite = mite->next) {
+		if (mite->used)
+			continue;
+		if (bus || slot) {
+			if (bus != mite->pcidev->bus->number ||
+			    slot != PCI_SLOT(mite->pcidev->devfn))
+				continue;
+		}
+		for (i = 0; i < n_nidio_boards; i++) {
+			if (mite_device_id(mite) == nidio_boards[i].dev_id) {
+				dev->board_ptr = nidio_boards + i;
+				devpriv->mite = mite;
+
+				return 0;
+			}
+		}
+	}
+	printk(KERN_WARNING "no device found\n");
+	mite_list_devices();
+	return -EIO;
+}
+
 static int nidio_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 {
 	struct comedi_subdevice *s;
@@ -1329,70 +1330,46 @@ static int nidio_detach(struct comedi_device *dev)
 	return 0;
 }
 
-static int nidio_find_device(struct comedi_device *dev, int bus, int slot)
-{
-	struct mite_struct *mite;
-	int i;
-
-	for (mite = mite_devices; mite; mite = mite->next) {
-		if (mite->used)
-			continue;
-		if (bus || slot) {
-			if (bus != mite->pcidev->bus->number ||
-			    slot != PCI_SLOT(mite->pcidev->devfn))
-				continue;
-		}
-		for (i = 0; i < n_nidio_boards; i++) {
-			if (mite_device_id(mite) == nidio_boards[i].dev_id) {
-				dev->board_ptr = nidio_boards + i;
-				devpriv->mite = mite;
-
-				return 0;
-			}
-		}
-	}
-	printk(KERN_WARNING "no device found\n");
-	mite_list_devices();
-	return -EIO;
-}
+static struct comedi_driver ni_pcidio_driver = {
+	.driver_name	= "ni_pcidio",
+	.module		= THIS_MODULE,
+	.attach		= nidio_attach,
+	.detach		= nidio_detach,
+};
 
-static int __devinit driver_pcidio_pci_probe(struct pci_dev *dev,
-					     const struct pci_device_id *ent)
+static int __devinit ni_pcidio_pci_probe(struct pci_dev *dev,
+					 const struct pci_device_id *ent)
 {
-	return comedi_pci_auto_config(dev, &driver_pcidio);
+	return comedi_pci_auto_config(dev, &ni_pcidio_driver);
 }
 
-static void __devexit driver_pcidio_pci_remove(struct pci_dev *dev)
+static void __devexit ni_pcidio_pci_remove(struct pci_dev *dev)
 {
 	comedi_pci_auto_unconfig(dev);
 }
 
-static struct pci_driver driver_pcidio_pci_driver = {
-	.id_table = ni_pcidio_pci_table,
-	.probe = &driver_pcidio_pci_probe,
-	.remove = __devexit_p(&driver_pcidio_pci_remove)
+static DEFINE_PCI_DEVICE_TABLE(ni_pcidio_pci_table) = {
+	{ PCI_DEVICE(PCI_VENDOR_ID_NI, 0x1150) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_NI, 0x1320) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_NI, 0x12b0) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_NI, 0x0160) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_NI, 0x1630) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_NI, 0x13c0) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_NI, 0x0400) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_NI, 0x1250) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_NI, 0x17d0) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_NI, 0x1800) },
+	{ 0 }
 };
+MODULE_DEVICE_TABLE(pci, ni_pcidio_pci_table);
 
-static int __init driver_pcidio_init_module(void)
-{
-	int retval;
-
-	retval = comedi_driver_register(&driver_pcidio);
-	if (retval < 0)
-		return retval;
-
-	driver_pcidio_pci_driver.name = (char *)driver_pcidio.driver_name;
-	return pci_register_driver(&driver_pcidio_pci_driver);
-}
-
-static void __exit driver_pcidio_cleanup_module(void)
-{
-	pci_unregister_driver(&driver_pcidio_pci_driver);
-	comedi_driver_unregister(&driver_pcidio);
-}
-
-module_init(driver_pcidio_init_module);
-module_exit(driver_pcidio_cleanup_module);
+static struct pci_driver ni_pcidio_pci_driver = {
+	.name		= "ni_pcidio",
+	.id_table	= ni_pcidio_pci_table,
+	.probe		= ni_pcidio_pci_probe,
+	.remove		= __devexit_p(ni_pcidio_pci_remove),
+};
+module_comedi_pci_driver(ni_pcidio_driver, ni_pcidio_pci_driver);
 
 MODULE_AUTHOR("Comedi http://www.comedi.org");
 MODULE_DESCRIPTION("Comedi low-level driver");
