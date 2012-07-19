Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754840Ab2GSBdR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 21:33:17 -0400
Received: from mail131.messagelabs.com ([216.82.242.99]:38870 "EHLO
	mail131.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751772Ab2GSBdP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 21:33:15 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-5.tower-131.messagelabs.com!1342661591!25480785!3
X-Originating-IP: [216.166.12.178]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 20/90] staging: comedi: adv_pci1710: store the pci_dev in the comedi_device
Date: Wed, 18 Jul 2012 18:33:06 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201207181833.06750.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the hw_dev pointer in the comedi_device struct to hold the
pci_dev instead of carrying it in the private data.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/adv_pci1710.c | 25 ++++++++++++++-----------
 1 file changed, 14 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/comedi/drivers/adv_pci1710.c b/drivers/staging/comedi/drivers/adv_pci1710.c
index 33dd1db..3198660 100644
--- a/drivers/staging/comedi/drivers/adv_pci1710.c
+++ b/drivers/staging/comedi/drivers/adv_pci1710.c
@@ -248,7 +248,6 @@ static const struct boardtype boardtypes[] = {
 };
 
 struct pci1710_private {
-	struct pci_dev *pcidev;	/*  ptr to PCI device */
 	char valid;		/*  card is usable */
 	char neverending_ai;	/*  we do unlimited AI */
 	unsigned int CntrlReg;	/*  Control register */
@@ -1378,6 +1377,7 @@ static struct pci_dev *pci1710_find_pci_dev(struct comedi_device *dev,
 static int pci1710_attach(struct comedi_device *dev,
 			  struct comedi_devconfig *it)
 {
+	struct pci_dev *pcidev;
 	struct comedi_subdevice *s;
 	int ret, subdev, n_subdevices;
 	unsigned int irq;
@@ -1388,16 +1388,17 @@ static int pci1710_attach(struct comedi_device *dev,
 	if (ret < 0)
 		return -ENOMEM;
 
-	devpriv->pcidev = pci1710_find_pci_dev(dev, it);
-	if (!devpriv->pcidev)
+	pcidev = pci1710_find_pci_dev(dev, it);
+	if (!pcidev)
 		return -EIO;
+	comedi_set_hw_dev(dev, &pcidev->dev);
 
-	ret = comedi_pci_enable(devpriv->pcidev, DRV_NAME);
+	ret = comedi_pci_enable(pcidev, DRV_NAME);
 	if (ret)
 		return ret;
 
-	dev->iobase = pci_resource_start(devpriv->pcidev, 2);
-	irq = devpriv->pcidev->irq;
+	dev->iobase = pci_resource_start(pcidev, 2);
+	irq = pcidev->irq;
 
 	dev->board_name = this_board->name;
 
@@ -1532,16 +1533,18 @@ static int pci1710_attach(struct comedi_device *dev,
 
 static void pci1710_detach(struct comedi_device *dev)
 {
+	struct pci_dev *pcidev = comedi_to_pci_dev(dev);
+
 	if (dev->private) {
 		if (devpriv->valid)
 			pci1710_reset(dev);
 		if (dev->irq)
 			free_irq(dev->irq, dev);
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

