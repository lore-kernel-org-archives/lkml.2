Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753763Ab2GSBZT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 21:25:19 -0400
Received: from mail160.messagelabs.com ([216.82.253.99]:38927 "EHLO
	mail160.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751729Ab2GSBZO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 21:25:14 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-11.tower-160.messagelabs.com!1342661089!8610330!10
X-Originating-IP: [216.166.12.97]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 02/90] staging: comedi: adl_pci6208: store the pci_dev in the comedi_device
Date: Wed, 18 Jul 2012 18:24:37 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201207181824.37659.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the hw_dev pointer in the comedi_device struct to hold the
pci_dev instead of carrying it in the private data.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/adl_pci6208.c | 19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/comedi/drivers/adl_pci6208.c b/drivers/staging/comedi/drivers/adl_pci6208.c
index 487fd4a..3bec0f6 100644
--- a/drivers/staging/comedi/drivers/adl_pci6208.c
+++ b/drivers/staging/comedi/drivers/adl_pci6208.c
@@ -73,7 +73,6 @@ static const struct pci6208_board pci6208_boards[] = {
 };
 
 struct pci6208_private {
-	struct pci_dev *pci_dev;
 	unsigned int ao_readback[PCI6208_MAX_AO_CHANNELS];
 };
 
@@ -200,6 +199,7 @@ static int pci6208_attach(struct comedi_device *dev,
 {
 	const struct pci6208_board *thisboard;
 	struct pci6208_private *devpriv;
+	struct pci_dev *pcidev;
 	struct comedi_subdevice *s;
 	int ret;
 
@@ -208,20 +208,21 @@ static int pci6208_attach(struct comedi_device *dev,
 		return ret;
 	devpriv = dev->private;
 
-	devpriv->pci_dev = pci6208_find_device(dev, it);
-	if (!devpriv->pci_dev)
+	pcidev = pci6208_find_device(dev, it);
+	if (!pcidev)
 		return -EIO;
+	comedi_set_hw_dev(dev, &pcidev->dev);
 	thisboard = comedi_board(dev);
 
 	dev->board_name = thisboard->name;
 
-	ret = comedi_pci_enable(devpriv->pci_dev, dev->driver->driver_name);
+	ret = comedi_pci_enable(pcidev, dev->driver->driver_name);
 	if (ret) {
 		dev_err(dev->class_dev,
 			"Failed to enable PCI device and request regions\n");
 		return ret;
 	}
-	dev->iobase = pci_resource_start(devpriv->pci_dev, 2);
+	dev->iobase = pci_resource_start(pcidev, 2);
 
 	ret = comedi_alloc_subdevices(dev, 2);
 	if (ret)
@@ -258,12 +259,12 @@ static int pci6208_attach(struct comedi_device *dev,
 
 static void pci6208_detach(struct comedi_device *dev)
 {
-	struct pci6208_private *devpriv = dev->private;
+	struct pci_dev *pcidev = comedi_to_pci_dev(dev);
 
-	if (devpriv && devpriv->pci_dev) {
+	if (pcidev) {
 		if (dev->iobase)
-			comedi_pci_disable(devpriv->pci_dev);
-		pci_dev_put(devpriv->pci_dev);
+			comedi_pci_disable(pcidev);
+		pci_dev_put(pcidev);
 	}
 }
 
-- 
1.7.11

