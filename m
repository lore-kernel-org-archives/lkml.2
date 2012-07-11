Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933314Ab2GKVuL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 17:50:11 -0400
Received: from mail209.messagelabs.com ([216.82.255.3]:26493 "EHLO
	mail209.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933242Ab2GKVuJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 17:50:09 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-9.tower-209.messagelabs.com!1342043401!8410172!29
X-Originating-IP: [216.166.12.31]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 02/30] staging: comedi: adl_pci6208: use comedi_device pci_dev pointer
Date: Wed, 11 Jul 2012 14:49:55 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201207111449.55848.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the pci_dev pointer in the comedi_device struct instead of
carrying it in the private data.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/adl_pci6208.c | 17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/comedi/drivers/adl_pci6208.c b/drivers/staging/comedi/drivers/adl_pci6208.c
index 487fd4a..4828875 100644
--- a/drivers/staging/comedi/drivers/adl_pci6208.c
+++ b/drivers/staging/comedi/drivers/adl_pci6208.c
@@ -73,7 +73,6 @@ static const struct pci6208_board pci6208_boards[] = {
 };
 
 struct pci6208_private {
-	struct pci_dev *pci_dev;
 	unsigned int ao_readback[PCI6208_MAX_AO_CHANNELS];
 };
 
@@ -208,20 +207,20 @@ static int pci6208_attach(struct comedi_device *dev,
 		return ret;
 	devpriv = dev->private;
 
-	devpriv->pci_dev = pci6208_find_device(dev, it);
-	if (!devpriv->pci_dev)
+	dev->pcidev = pci6208_find_device(dev, it);
+	if (!dev->pcidev)
 		return -EIO;
 	thisboard = comedi_board(dev);
 
 	dev->board_name = thisboard->name;
 
-	ret = comedi_pci_enable(devpriv->pci_dev, dev->driver->driver_name);
+	ret = comedi_pci_enable(dev->pcidev, dev->driver->driver_name);
 	if (ret) {
 		dev_err(dev->class_dev,
 			"Failed to enable PCI device and request regions\n");
 		return ret;
 	}
-	dev->iobase = pci_resource_start(devpriv->pci_dev, 2);
+	dev->iobase = pci_resource_start(dev->pcidev, 2);
 
 	ret = comedi_alloc_subdevices(dev, 2);
 	if (ret)
@@ -258,12 +257,10 @@ static int pci6208_attach(struct comedi_device *dev,
 
 static void pci6208_detach(struct comedi_device *dev)
 {
-	struct pci6208_private *devpriv = dev->private;
-
-	if (devpriv && devpriv->pci_dev) {
+	if (dev->pcidev) {
 		if (dev->iobase)
-			comedi_pci_disable(devpriv->pci_dev);
-		pci_dev_put(devpriv->pci_dev);
+			comedi_pci_disable(dev->pcidev);
+		pci_dev_put(dev->pcidev);
 	}
 }
 
-- 
1.7.11

