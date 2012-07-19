Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755254Ab2GSB5U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 21:57:20 -0400
Received: from mail132.messagelabs.com ([216.82.242.115]:50845 "EHLO
	mail132.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751012Ab2GSB5R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 21:57:17 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-5.tower-132.messagelabs.com!1342663036!14774506!1
X-Originating-IP: [216.166.12.72]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 63/90] staging: comedi: daqboard2000: store the pci_dev in the comedi_device
Date: Wed, 18 Jul 2012 18:57:08 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201207181857.08402.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the hw_dev pointer in the comedi_device struct to hold the
pci_dev instead of carrying it in the private data.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/daqboard2000.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/comedi/drivers/daqboard2000.c b/drivers/staging/comedi/drivers/daqboard2000.c
index 1d94b58..ba61e32 100644
--- a/drivers/staging/comedi/drivers/daqboard2000.c
+++ b/drivers/staging/comedi/drivers/daqboard2000.c
@@ -317,7 +317,6 @@ struct daqboard2000_private {
 	enum {
 		card_daqboard_2000
 	} card;
-	struct pci_dev *pci_dev;
 	void *daq;
 	void *plx;
 	unsigned int ao_readback[2];
@@ -751,7 +750,7 @@ static int daqboard2000_attach(struct comedi_device *dev,
 	pcidev = daqboard2000_find_pci_dev(dev, it);
 	if (!pcidev)
 		return -EIO;
-	devpriv->pci_dev = pcidev;
+	comedi_set_hw_dev(dev, &pcidev->dev);
 
 	result = comedi_pci_enable(pcidev, "daqboard2000");
 	if (result < 0) {
@@ -833,6 +832,8 @@ out:
 
 static void daqboard2000_detach(struct comedi_device *dev)
 {
+	struct pci_dev *pcidev = comedi_to_pci_dev(dev);
+
 	if (dev->subdevices)
 		subdev_8255_cleanup(dev, dev->subdevices + 2);
 	if (dev->irq)
@@ -842,11 +843,11 @@ static void daqboard2000_detach(struct comedi_device *dev)
 			iounmap(devpriv->daq);
 		if (devpriv->plx)
 			iounmap(devpriv->plx);
-		if (devpriv->pci_dev) {
-			if (dev->iobase)
-				comedi_pci_disable(devpriv->pci_dev);
-			pci_dev_put(devpriv->pci_dev);
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

