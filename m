Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754929Ab2GSBbR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 21:31:17 -0400
Received: from mail127.messagelabs.com ([216.82.250.115]:33502 "EHLO
	mail127.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753933Ab2GSBbO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 21:31:14 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-14.tower-127.messagelabs.com!1342661473!9007820!1
X-Originating-IP: [216.166.12.98]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 16/90] staging: comedi: adv_pci1723: store the pci_dev in the comedi_device
Date: Wed, 18 Jul 2012 18:31:06 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201207181831.07022.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the hw_dev pointer in the comedi_device struct to hold the
pci_dev instead of carrying it in the private data.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/adv_pci1723.c | 23 +++++++++++++----------
 1 file changed, 13 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/comedi/drivers/adv_pci1723.c b/drivers/staging/comedi/drivers/adv_pci1723.c
index e971fa6..da5ee69 100644
--- a/drivers/staging/comedi/drivers/adv_pci1723.c
+++ b/drivers/staging/comedi/drivers/adv_pci1723.c
@@ -152,7 +152,6 @@ static const struct pci1723_board boardtypes[] = {
 struct pci1723_private {
 	int valid;		/* card is usable; */
 
-	struct pci_dev *pcidev;
 	unsigned char da_range[8];	/* D/A output range for each channel */
 
 	short ao_data[8];	/* data output buffer */
@@ -315,6 +314,7 @@ static struct pci_dev *pci1723_find_pci_dev(struct comedi_device *dev,
 static int pci1723_attach(struct comedi_device *dev,
 			  struct comedi_devconfig *it)
 {
+	struct pci_dev *pcidev;
 	struct comedi_subdevice *s;
 	int ret, subdev, n_subdevices;
 
@@ -327,15 +327,16 @@ static int pci1723_attach(struct comedi_device *dev,
 		return -ENOMEM;
 	}
 
-	devpriv->pcidev = pci1723_find_pci_dev(dev, it);
-	if (!devpriv->pcidev)
+	pcidev = pci1723_find_pci_dev(dev, it);
+	if (!pcidev)
 		return -EIO;
+	comedi_set_hw_dev(dev, &pcidev->dev);
 
-	ret = comedi_pci_enable(devpriv->pcidev, "adv_pci1723");
+	ret = comedi_pci_enable(pcidev, "adv_pci1723");
 	if (ret)
 		return ret;
 
-	dev->iobase = pci_resource_start(devpriv->pcidev, 2);
+	dev->iobase = pci_resource_start(pcidev, 2);
 
 	dev->board_name = this_board->name;
 
@@ -410,14 +411,16 @@ static int pci1723_attach(struct comedi_device *dev,
 
 static void pci1723_detach(struct comedi_device *dev)
 {
+	struct pci_dev *pcidev = comedi_to_pci_dev(dev);
+
 	if (dev->private) {
 		if (devpriv->valid)
 			pci1723_reset(dev);
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

