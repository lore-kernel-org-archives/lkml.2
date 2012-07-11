Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933446Ab2GKWdK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 18:33:10 -0400
Received: from mail131.messagelabs.com ([216.82.242.99]:25143 "EHLO
	mail131.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754309Ab2GKWdH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 18:33:07 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-2.tower-131.messagelabs.com!1342045982!25886524!7
X-Originating-IP: [216.166.12.99]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 25/30] staging: comedi: dyna_pci10xx: use comedi_device pci_dev pointer
Date: Wed, 11 Jul 2012 15:32:52 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201207111532.52738.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the pci_dev pointer in the comedi_device struct instead of
carrying it in the private data.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/dyna_pci10xx.c | 25 ++++++++++++-------------
 1 file changed, 12 insertions(+), 13 deletions(-)

diff --git a/drivers/staging/comedi/drivers/dyna_pci10xx.c b/drivers/staging/comedi/drivers/dyna_pci10xx.c
index d8ce5da..16ad05f 100644
--- a/drivers/staging/comedi/drivers/dyna_pci10xx.c
+++ b/drivers/staging/comedi/drivers/dyna_pci10xx.c
@@ -102,7 +102,6 @@ static const struct boardtype boardtypes[] = {
 };
 
 struct dyna_pci10xx_private {
-	struct pci_dev *pci_dev;	/*  ptr to PCI device */
 	char valid;			/*  card is usable */
 	struct mutex mutex;
 
@@ -272,8 +271,8 @@ static int dyna_pci10xx_attach(struct comedi_device *dev,
 		return -ENOMEM;
 	}
 
-	devpriv->pci_dev = dyna_pci10xx_find_pci_dev(dev, it);
-	if (!devpriv->pci_dev) {
+	dev->pcidev = dyna_pci10xx_find_pci_dev(dev, it);
+	if (!dev->pcidev) {
 		mutex_unlock(&start_stop_sem);
 		return -EIO;
 	}
@@ -281,7 +280,7 @@ static int dyna_pci10xx_attach(struct comedi_device *dev,
 	dev->board_name = thisboard->name;
 	dev->irq = 0;
 
-	if (comedi_pci_enable(devpriv->pci_dev, DRV_NAME)) {
+	if (comedi_pci_enable(dev->pcidev, DRV_NAME)) {
 		printk(KERN_ERR "comedi: dyna_pci10xx: "
 			"failed to enable PCI device and request regions!");
 		mutex_unlock(&start_stop_sem);
@@ -291,12 +290,12 @@ static int dyna_pci10xx_attach(struct comedi_device *dev,
 	mutex_init(&devpriv->mutex);
 
 	/* initialize device base address registers */
-	devpriv->BADR0 = pci_resource_start(devpriv->pci_dev, 0);
-	devpriv->BADR1 = pci_resource_start(devpriv->pci_dev, 1);
-	devpriv->BADR2 = pci_resource_start(devpriv->pci_dev, 2);
-	devpriv->BADR3 = pci_resource_start(devpriv->pci_dev, 3);
-	devpriv->BADR4 = pci_resource_start(devpriv->pci_dev, 4);
-	devpriv->BADR5 = pci_resource_start(devpriv->pci_dev, 5);
+	devpriv->BADR0 = pci_resource_start(dev->pcidev, 0);
+	devpriv->BADR1 = pci_resource_start(dev->pcidev, 1);
+	devpriv->BADR2 = pci_resource_start(dev->pcidev, 2);
+	devpriv->BADR3 = pci_resource_start(dev->pcidev, 3);
+	devpriv->BADR4 = pci_resource_start(dev->pcidev, 4);
+	devpriv->BADR5 = pci_resource_start(dev->pcidev, 5);
 
 	ret = comedi_alloc_subdevices(dev, 4);
 	if (ret) {
@@ -356,10 +355,10 @@ static int dyna_pci10xx_attach(struct comedi_device *dev,
 
 static void dyna_pci10xx_detach(struct comedi_device *dev)
 {
-	if (devpriv && devpriv->pci_dev) {
-		comedi_pci_disable(devpriv->pci_dev);
+	if (dev->pcidev)
+		comedi_pci_disable(dev->pcidev);
+	if (devpriv)
 		mutex_destroy(&devpriv->mutex);
-	}
 }
 
 static struct comedi_driver dyna_pci10xx_driver = {
-- 
1.7.11

