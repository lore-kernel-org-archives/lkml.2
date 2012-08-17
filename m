Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030545Ab2HQCtx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 22:49:53 -0400
Received: from mail160.messagelabs.com ([216.82.253.99]:3509 "EHLO
	mail160.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030363Ab2HQCtv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 22:49:51 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-2.tower-160.messagelabs.com!1345171784!8645985!15
X-Originating-IP: [216.166.12.178]
X-StarScan-Received: 
X-StarScan-Version: 6.6.1.2; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 20/35] staging: comedi: cb_pcimdda: store the pci_dev in the comedi_device
Date: Thu, 16 Aug 2012 19:49:38 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201208161949.38786.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the hw_dev pointer in the comed_device struct to hold the
pci_dev instead of carrying it in the private data.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/cb_pcimdda.c | 18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/comedi/drivers/cb_pcimdda.c b/drivers/staging/comedi/drivers/cb_pcimdda.c
index dc53f7e..4127aa7 100644
--- a/drivers/staging/comedi/drivers/cb_pcimdda.c
+++ b/drivers/staging/comedi/drivers/cb_pcimdda.c
@@ -139,8 +139,6 @@ static const struct cb_pcimdda_board cb_pcimdda_boards[] = {
 struct cb_pcimdda_private {
 	unsigned long dio_registers;
 	char attached_to_8255;	/* boolean */
-	/* would be useful for a PCI device */
-	struct pci_dev *pci_dev;
 
 #define MAX_AO_READBACK_CHANNELS 6
 	/* Used for AO readback */
@@ -255,15 +253,14 @@ static int cb_pcimdda_attach(struct comedi_device *dev,
 	pcidev = cb_pcimdda_probe(dev, it);
 	if (!pcidev)
 		return -EIO;
-	devpriv->pci_dev = pcidev;
+	comedi_set_hw_dev(dev, &pcidev->dev);
 	thisboard = comedi_board(dev);
 	dev->board_name = thisboard->name;
 
 	err = comedi_pci_enable(pcidev, dev->board_name);
 	if (err)
 		return err;
-	dev->iobase = pci_resource_start(devpriv->pci_dev,
-						thisboard->regs_badrindex);
+	dev->iobase = pci_resource_start(pcidev, thisboard->regs_badrindex);
 	devpriv->dio_registers = dev->iobase + thisboard->dio_offset;
 
 	err = comedi_alloc_subdevices(dev, 2);
@@ -314,6 +311,7 @@ static int cb_pcimdda_attach(struct comedi_device *dev,
 
 static void cb_pcimdda_detach(struct comedi_device *dev)
 {
+	struct pci_dev *pcidev = comedi_to_pci_dev(dev);
 	struct cb_pcimdda_private *devpriv = dev->private;
 
 	if (devpriv) {
@@ -321,11 +319,11 @@ static void cb_pcimdda_detach(struct comedi_device *dev)
 			subdev_8255_cleanup(dev, dev->subdevices + 2);
 			devpriv->attached_to_8255 = 0;
 		}
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

