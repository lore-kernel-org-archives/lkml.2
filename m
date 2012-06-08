Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758948Ab2FHMSo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 08:18:44 -0400
Received: from fias.uni-frankfurt.de ([141.2.248.1]:50604 "EHLO
	fias.uni-frankfurt.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756092Ab2FHMSm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 08:18:42 -0400
X-Greylist: delayed 1301 seconds by postgrey-1.27 at vger.kernel.org; Fri, 08 Jun 2012 08:18:41 EDT
Message-ID: <1339156616.3870.9.camel@blech>
Subject: [PATCH] uio_pci_generic does not export memory resources
From: Dominic Eschweiler <eschweiler@fias.uni-frankfurt.de>
To: "Michael S. Tsirkin" <mst@redhat.com>, "Hans J. Koch" <hjk@hansjkoch.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Fri, 08 Jun 2012 13:56:56 +0200
Content-Type: multipart/mixed; boundary="=-RNMXFwlAbMgbi1jgW2+r"
X-Mailer: Evolution 3.2.3 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-RNMXFwlAbMgbi1jgW2+r
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hello,

the current version of the uio_pci_generic module does not export memory
resources, such as BARs. As far as I can see, the related module does
only support interrupts, which is not really useful. My suggestion in
this case would be to either fix this issue, or to completely remove it.
The latter would not be an option for us, since we need this
functionality at some stuff at CERN.

Therefore, here is a patch that fixes the issue. Please give me further
advice, since I'm doing this the first time ...



Signed-off-by: Dominic Eschweiler <eschweiler@fias.uni-frankfurt.de>
---
diff -uNr linux-3.4_old/drivers/uio/uio_pci_generic.c
linux-3.4_new/drivers/uio/uio_pci_generic.c
--- linux-3.4_old/drivers/uio/uio_pci_generic.c	2012-05-21
00:29:13.000000000 +0200
+++ linux-3.4_new/drivers/uio/uio_pci_generic.c	2012-06-08
13:01:12.000000000 +0200
@@ -25,10 +25,12 @@
 #include <linux/slab.h>
 #include <linux/uio_driver.h>
=20
-#define DRIVER_VERSION	"0.01.0"
+#define DRIVER_VERSION	"0.02.0"
 #define DRIVER_AUTHOR	"Michael S. Tsirkin <mst@redhat.com>"
 #define DRIVER_DESC	"Generic UIO driver for PCI 2.3 devices"
=20
+#define DRV_NAME "uio_pci_generic"
+
 struct uio_pci_generic_dev {
 	struct uio_info info;
 	struct pci_dev *pdev;
@@ -58,6 +60,7 @@
 {
 	struct uio_pci_generic_dev *gdev;
 	int err;
+	int i;
=20
 	err =3D pci_enable_device(pdev);
 	if (err) {
@@ -66,9 +69,33 @@
 		return err;
 	}
=20
+    /* set master */
+	pci_set_master(pdev);
+
+    /* set DMA mask */
+	err =3D pci_set_dma_mask(pdev, DMA_BIT_MASK(64));
+	if (err) {
+		dev_warn(&pdev->dev, "Warning: couldn't set 64-bit PCI DMA mask.\n");
+		err =3D pci_set_dma_mask(pdev, DMA_BIT_MASK(32));
+		if (err) {
+			dev_err(&pdev->dev, "Can't set PCI DMA mask, aborting\n");
+			return -ENODEV;
+		}
+	}
+
+	/* set consistent DMA mask */
+	err =3D pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(64));
+	if (err) {
+		dev_warn(&pdev->dev, "Warning: couldn't set 64-bit consistent PCI DMA
mask.\n");
+		err =3D pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(32));
+		if (err) {
+			dev_err(&pdev->dev, "Can't set consistent PCI DMA mask, aborting
\n");
+			return -ENODEV;
+		}
+	}
+
 	if (!pdev->irq) {
-		dev_warn(&pdev->dev, "No IRQ assigned to device: "
-			 "no support for interrupts?\n");
+		dev_warn(&pdev->dev, "No IRQ assigned to device: no support for
interrupts?\n");
 		pci_disable_device(pdev);
 		return -ENODEV;
 	}
@@ -91,10 +118,40 @@
 	gdev->info.handler =3D irqhandler;
 	gdev->pdev =3D pdev;
=20
+	/* request regions */
+	err =3D pci_request_regions(pdev, DRV_NAME);
+	if (err) {
+		dev_err(&pdev->dev, "Couldn't get PCI resources, aborting\n");
+		return err;
+	}
+
+	/* create attributes for BAR mappings */
+	for (i =3D 0; i < PCI_NUM_RESOURCES; i++) {
+		if (pdev->resource[i].flags &&
+		(pdev->resource[i].flags & IORESOURCE_IO)) {
+			gdev->info.port[i].size =3D 0;
+			gdev->info.port[i].porttype =3D UIO_PORT_OTHER;
+			#ifdef CONFIG_X86
+			gdev->info.port[i].porttype =3D UIO_PORT_X86;
+			#endif
+		}
+
+	if (pdev->resource[i].flags &&
+	(pdev->resource[i].flags & IORESOURCE_MEM)) {
+		gdev->info.mem[i].addr =3D pci_resource_start(pdev, i);
+		gdev->info.mem[i].size =3D pci_resource_len(pdev, i);
+		gdev->info.mem[i].internal_addr =3D NULL;
+		gdev->info.mem[i].memtype =3D UIO_MEM_PHYS;
+		}
+	}
+
 	if (uio_register_device(&pdev->dev, &gdev->info))
 		goto err_register;
 	pci_set_drvdata(pdev, gdev);
=20
+	pr_info("UIO_PCI_GENERIC : initialized new device (%x %x)\n",
+	pdev->vendor, pdev->device);
+
 	return 0;
 err_register:
 	kfree(gdev);
@@ -107,17 +164,21 @@
 static void remove(struct pci_dev *pdev)
 {
 	struct uio_pci_generic_dev *gdev =3D pci_get_drvdata(pdev);
-
 	uio_unregister_device(&gdev->info);
+
+	pci_release_regions(pdev);
 	pci_disable_device(pdev);
 	kfree(gdev);
+
+	pr_info("UIO_PCI_GENERIC : removed device (%x %x)\n",
+	pdev->vendor, pdev->device);
 }
=20
 static struct pci_driver driver =3D {
-	.name =3D "uio_pci_generic",
+	.name     =3D DRV_NAME,
 	.id_table =3D NULL, /* only dynamic id's */
-	.probe =3D probe,
-	.remove =3D remove,
+	.probe    =3D probe,
+	.remove   =3D remove,
 };
=20
 static int __init init(void)


--=20
Gru=C3=9F
  Dominic

Frankfurt Institute for Advanced Studies (FIAS)
Ruth-Moufang-Stra=C3=9Fe 1
D-60438 Frankfurt am Main
Germany

Phone:  +49 69 79844114

--=-RNMXFwlAbMgbi1jgW2+r
Content-Disposition: attachment; filename="uio_pci_generic_0.02.0.diff"
Content-Type: text/x-patch; name="uio_pci_generic_0.02.0.diff"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

Signed-off-by: Dominic Eschweiler <eschweiler@fias.uni-frankfurt.de>
---
diff -uNr linux-3.4_old/drivers/uio/uio_pci_generic.c linux-3.4_new/drivers/uio/uio_pci_generic.c
--- linux-3.4_old/drivers/uio/uio_pci_generic.c	2012-05-21 00:29:13.000000000 +0200
+++ linux-3.4_new/drivers/uio/uio_pci_generic.c	2012-06-08 13:01:12.000000000 +0200
@@ -25,10 +25,12 @@
 #include <linux/slab.h>
 #include <linux/uio_driver.h>
 
-#define DRIVER_VERSION	"0.01.0"
+#define DRIVER_VERSION	"0.02.0"
 #define DRIVER_AUTHOR	"Michael S. Tsirkin <mst@redhat.com>"
 #define DRIVER_DESC	"Generic UIO driver for PCI 2.3 devices"
 
+#define DRV_NAME "uio_pci_generic"
+
 struct uio_pci_generic_dev {
 	struct uio_info info;
 	struct pci_dev *pdev;
@@ -58,6 +60,7 @@
 {
 	struct uio_pci_generic_dev *gdev;
 	int err;
+	int i;
 
 	err = pci_enable_device(pdev);
 	if (err) {
@@ -66,9 +69,33 @@
 		return err;
 	}
 
+    /* set master */
+	pci_set_master(pdev);
+
+    /* set DMA mask */
+	err = pci_set_dma_mask(pdev, DMA_BIT_MASK(64));
+	if (err) {
+		dev_warn(&pdev->dev, "Warning: couldn't set 64-bit PCI DMA mask.\n");
+		err = pci_set_dma_mask(pdev, DMA_BIT_MASK(32));
+		if (err) {
+			dev_err(&pdev->dev, "Can't set PCI DMA mask, aborting\n");
+			return -ENODEV;
+		}
+	}
+
+	/* set consistent DMA mask */
+	err = pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(64));
+	if (err) {
+		dev_warn(&pdev->dev, "Warning: couldn't set 64-bit consistent PCI DMA mask.\n");
+		err = pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(32));
+		if (err) {
+			dev_err(&pdev->dev, "Can't set consistent PCI DMA mask, aborting\n");
+			return -ENODEV;
+		}
+	}
+
 	if (!pdev->irq) {
-		dev_warn(&pdev->dev, "No IRQ assigned to device: "
-			 "no support for interrupts?\n");
+		dev_warn(&pdev->dev, "No IRQ assigned to device: no support for interrupts?\n");
 		pci_disable_device(pdev);
 		return -ENODEV;
 	}
@@ -91,10 +118,40 @@
 	gdev->info.handler = irqhandler;
 	gdev->pdev = pdev;
 
+	/* request regions */
+	err = pci_request_regions(pdev, DRV_NAME);
+	if (err) {
+		dev_err(&pdev->dev, "Couldn't get PCI resources, aborting\n");
+		return err;
+	}
+
+	/* create attributes for BAR mappings */
+	for (i = 0; i < PCI_NUM_RESOURCES; i++) {
+		if (pdev->resource[i].flags &&
+		(pdev->resource[i].flags & IORESOURCE_IO)) {
+			gdev->info.port[i].size = 0;
+			gdev->info.port[i].porttype = UIO_PORT_OTHER;
+			#ifdef CONFIG_X86
+			gdev->info.port[i].porttype = UIO_PORT_X86;
+			#endif
+		}
+
+	if (pdev->resource[i].flags &&
+	(pdev->resource[i].flags & IORESOURCE_MEM)) {
+		gdev->info.mem[i].addr = pci_resource_start(pdev, i);
+		gdev->info.mem[i].size = pci_resource_len(pdev, i);
+		gdev->info.mem[i].internal_addr = NULL;
+		gdev->info.mem[i].memtype = UIO_MEM_PHYS;
+		}
+	}
+
 	if (uio_register_device(&pdev->dev, &gdev->info))
 		goto err_register;
 	pci_set_drvdata(pdev, gdev);
 
+	pr_info("UIO_PCI_GENERIC : initialized new device (%x %x)\n",
+	pdev->vendor, pdev->device);
+
 	return 0;
 err_register:
 	kfree(gdev);
@@ -107,17 +164,21 @@
 static void remove(struct pci_dev *pdev)
 {
 	struct uio_pci_generic_dev *gdev = pci_get_drvdata(pdev);
-
 	uio_unregister_device(&gdev->info);
+
+	pci_release_regions(pdev);
 	pci_disable_device(pdev);
 	kfree(gdev);
+
+	pr_info("UIO_PCI_GENERIC : removed device (%x %x)\n",
+	pdev->vendor, pdev->device);
 }
 
 static struct pci_driver driver = {
-	.name = "uio_pci_generic",
+	.name     = DRV_NAME,
 	.id_table = NULL, /* only dynamic id's */
-	.probe = probe,
-	.remove = remove,
+	.probe    = probe,
+	.remove   = remove,
 };
 
 static int __init init(void)

--=-RNMXFwlAbMgbi1jgW2+r--

