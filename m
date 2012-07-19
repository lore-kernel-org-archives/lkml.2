Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754944Ab2GSBdo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 21:33:44 -0400
Received: from mail131.messagelabs.com ([216.82.242.99]:28621 "EHLO
	mail131.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754192Ab2GSBdl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 21:33:41 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-10.tower-131.messagelabs.com!1342661617!25643428!2
X-Originating-IP: [216.166.12.178]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 21/90] staging: comedi: adv_pci_dio: factor out the "find pci device" code
Date: Wed, 18 Jul 2012 18:33:27 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201207181833.27471.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Factor the "find pci device" code out of the attach function.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/adv_pci_dio.c | 48 +++++++++++++++++-----------
 1 file changed, 29 insertions(+), 19 deletions(-)

diff --git a/drivers/staging/comedi/drivers/adv_pci_dio.c b/drivers/staging/comedi/drivers/adv_pci_dio.c
index ad653a5..e1f52c6 100644
--- a/drivers/staging/comedi/drivers/adv_pci_dio.c
+++ b/drivers/staging/comedi/drivers/adv_pci_dio.c
@@ -1077,23 +1077,16 @@ static int CheckAndAllocCard(struct comedi_device *dev,
 		pci_priv = devpriv;
 	}
 
-	devpriv->pcidev = pcidev;
-
 	return 1;
 }
 
-static int pci_dio_attach(struct comedi_device *dev,
-			  struct comedi_devconfig *it)
+static struct pci_dev *pci_dio_find_pci_dev(struct comedi_device *dev,
+					    struct comedi_devconfig *it)
 {
-	struct comedi_subdevice *s;
-	int ret, subdev, n_subdevices, i, j;
-	unsigned long iobase;
 	struct pci_dev *pcidev = NULL;
-
-
-	ret = alloc_private(dev, sizeof(struct pci_dio_private));
-	if (ret < 0)
-		return -ENOMEM;
+	unsigned long iobase;
+	int i;
+	int ret;
 
 	for_each_pci_dev(pcidev) {
 		/*  loop through cards supported by this driver */
@@ -1123,20 +1116,37 @@ static int pci_dio_attach(struct comedi_device *dev,
 	if (!dev->board_ptr) {
 		dev_err(dev->class_dev,
 			"Error: Requested type of the card was not found!\n");
-		return -EIO;
+		return NULL;
 	}
+	iobase = pci_resource_start(devpriv->pcidev, this_board->main_pci_region);
+	dev_dbg(dev->class_dev, "b:s:f=%d:%d:%d, io=0x%4lx\n",
+		pcidev->bus->number, PCI_SLOT(pcidev->devfn),
+		PCI_FUNC(pcidev->devfn), iobase);
+	return pcidev;
+}
 
-	if (comedi_pci_enable(pcidev, dev->driver->driver_name)) {
+static int pci_dio_attach(struct comedi_device *dev,
+			  struct comedi_devconfig *it)
+{
+	struct comedi_subdevice *s;
+	int ret, subdev, n_subdevices, i, j;
+
+	ret = alloc_private(dev, sizeof(struct pci_dio_private));
+	if (ret < 0)
+		return -ENOMEM;
+
+	devpriv->pcidev = pci_dio_find_pci_dev(dev, it);
+	if (!devpriv->pcidev)
+		return -EIO;
+
+	if (comedi_pci_enable(devpriv->pcidev, dev->driver->driver_name)) {
 		dev_err(dev->class_dev,
 			"Error: Can't enable PCI device and request regions!\n");
 		return -EIO;
 	}
-	iobase = pci_resource_start(pcidev, this_board->main_pci_region);
-	dev_dbg(dev->class_dev, "b:s:f=%d:%d:%d, io=0x%4lx\n",
-		pcidev->bus->number, PCI_SLOT(pcidev->devfn),
-		PCI_FUNC(pcidev->devfn), iobase);
 
-	dev->iobase = iobase;
+	dev->iobase = pci_resource_start(devpriv->pcidev,
+					 this_board->main_pci_region);
 	dev->board_name = this_board->name;
 
 	if (this_board->cardtype == TYPE_PCI1760) {
-- 
1.7.11

