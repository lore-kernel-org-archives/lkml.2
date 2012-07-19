Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755194Ab2GSBfY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 21:35:24 -0400
Received: from mail132.messagelabs.com ([216.82.242.115]:29495 "EHLO
	mail132.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754074Ab2GSBfV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 21:35:21 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-6.tower-132.messagelabs.com!1342661719!13415213!1
X-Originating-IP: [216.166.12.31]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 24/90] staging: comedi: adv_pci_dio: store the pci_dev in the comedi_device
Date: Wed, 18 Jul 2012 18:35:13 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201207181835.13796.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the hw_dev pointer in the comedi_device struct to hold the
pci_dev instead of carrying it in the private data.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/adv_pci_dio.c | 23 ++++++++++++-----------
 1 file changed, 12 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/comedi/drivers/adv_pci_dio.c b/drivers/staging/comedi/drivers/adv_pci_dio.c
index c805208..97f06dc 100644
--- a/drivers/staging/comedi/drivers/adv_pci_dio.c
+++ b/drivers/staging/comedi/drivers/adv_pci_dio.c
@@ -382,7 +382,6 @@ static const struct dio_boardtype boardtypes[] = {
 };
 
 struct pci_dio_private {
-	struct pci_dev *pcidev;	/*  pointer to board's pci_dev */
 	char valid;		/*  card is usable */
 	char GlobalIrqEnabled;	/*  1= any IRQ source is enabled */
 	/*  PCI-1760 specific data */
@@ -1085,6 +1084,7 @@ static struct pci_dev *pci_dio_find_pci_dev(struct comedi_device *dev,
 static int pci_dio_attach(struct comedi_device *dev,
 			  struct comedi_devconfig *it)
 {
+	struct pci_dev *pcidev;
 	struct comedi_subdevice *s;
 	int ret, subdev, n_subdevices, i, j;
 
@@ -1092,18 +1092,18 @@ static int pci_dio_attach(struct comedi_device *dev,
 	if (ret < 0)
 		return -ENOMEM;
 
-	devpriv->pcidev = pci_dio_find_pci_dev(dev, it);
-	if (!devpriv->pcidev)
+	pcidev = pci_dio_find_pci_dev(dev, it);
+	if (!pcidev)
 		return -EIO;
+	comedi_set_hw_dev(dev, &pcidev->dev);
 
-	if (comedi_pci_enable(devpriv->pcidev, dev->driver->driver_name)) {
+	if (comedi_pci_enable(pcidev, dev->driver->driver_name)) {
 		dev_err(dev->class_dev,
 			"Error: Can't enable PCI device and request regions!\n");
 		return -EIO;
 	}
 
-	dev->iobase = pci_resource_start(devpriv->pcidev,
-					 this_board->main_pci_region);
+	dev->iobase = pci_resource_start(pcidev, this_board->main_pci_region);
 	dev->board_name = this_board->name;
 
 	if (this_board->cardtype == TYPE_PCI1760) {
@@ -1180,6 +1180,7 @@ static int pci_dio_attach(struct comedi_device *dev,
 
 static void pci_dio_detach(struct comedi_device *dev)
 {
+	struct pci_dev *pcidev = comedi_to_pci_dev(dev);
 	int i, j;
 	struct comedi_subdevice *s;
 	int subdev;
@@ -1212,11 +1213,11 @@ static void pci_dio_detach(struct comedi_device *dev)
 			s = dev->subdevices + i;
 			s->private = NULL;
 		}
-		if (devpriv->pcidev) {
-			if (dev->iobase)
-				comedi_pci_disable(devpriv->pcidev);
-			pci_dev_put(devpriv->pcidev);
-		}
+	}
+	if (pcidev) {
+		if (dev->iobase)
+			comedi_pci_disable(pcidev);
+		pci_dev_put(pcidev);
 	}
 }
 
-- 
1.7.11

