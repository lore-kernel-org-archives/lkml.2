Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753801Ab2GRKkz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 06:40:55 -0400
Received: from fias.uni-frankfurt.de ([141.2.248.1]:51063 "EHLO
	fias.uni-frankfurt.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753677Ab2GRKkv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 06:40:51 -0400
Message-ID: <1342608047.4194.0.camel@blech>
Subject: Re: UIO: missing resource mapping
From: Dominic Eschweiler <eschweiler@fias.uni-frankfurt.de>
To: "Hans J. Koch" <hjk@hansjkoch.de>
Cc: "Michael S. Tsirkin" <mst@redhat.com>,
        Andreas Schallenberg <embedded@gmx.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>, kvm@vger.kernel.org
Date: Wed, 18 Jul 2012 12:40:47 +0200
In-Reply-To: <20120716215823.GA7879@local>
References: <4FFE7C1F.7080702@gmx.net> <20120712194432.GA2592@local>
	 <20120712231632.GC9317@redhat.com> <1342166955.6607.5.camel@blech>
	 <20120713132223.GA10959@redhat.com> <1342190571.6607.36.camel@blech>
	 <20120713181953.GA11527@redhat.com> <1342462572.17531.18.camel@blech>
	 <20120716215823.GA7879@local>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 8BIT
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, den 16.07.2012, 23:58 +0200 schrieb Hans J. Koch:
> Try to hack up a patch to add generic BAR mapping to uio_pci_generic.c
> and post it for review.
> 

Here we go ...
> 
Signed-off-by: Dominic Eschweiler <eschweiler@fias.uni-frankfurt.de>
diff --git a/drivers/uio/uio_pci_generic.c
b/drivers/uio/uio_pci_generic.c
index 0bd08ef..e25991e 100644
--- a/drivers/uio/uio_pci_generic.c
+++ b/drivers/uio/uio_pci_generic.c
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
@@ -58,6 +60,7 @@ static int __devinit probe(struct pci_dev *pdev,
 {
 	struct uio_pci_generic_dev *gdev;
 	int err;
+	int i;
 
 	err = pci_enable_device(pdev);
 	if (err) {
@@ -67,8 +70,7 @@ static int __devinit probe(struct pci_dev *pdev,
 	}
 
 	if (!pdev->irq) {
-		dev_warn(&pdev->dev, "No IRQ assigned to device: "
-			 "no support for interrupts?\n");
+		dev_warn(&pdev->dev, "No IRQ assigned to device: no support for
interrupts?\n");
 		pci_disable_device(pdev);
 		return -ENODEV;
 	}
@@ -91,10 +93,31 @@ static int __devinit probe(struct pci_dev *pdev,
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
+		(pdev->resource[i].flags & IORESOURCE_MEM)) {
+			gdev->info.mem[i].addr = pci_resource_start(pdev, i);
+			gdev->info.mem[i].size = pci_resource_len(pdev, i);
+			gdev->info.mem[i].internal_addr = NULL;
+			gdev->info.mem[i].memtype = UIO_MEM_PHYS;
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
@@ -107,17 +130,21 @@ err_verify:
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

-- 
Gruß
  Dominic

Frankfurt Institute for Advanced Studies (FIAS)
Ruth-Moufang-Straße 1
D-60438 Frankfurt am Main
Germany

Phone:  +49 69 79844114

