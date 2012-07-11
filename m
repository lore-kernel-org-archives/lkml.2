Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030435Ab2GKW1k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 18:27:40 -0400
Received: from mail131.messagelabs.com ([216.82.242.99]:60622 "EHLO
	mail131.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030328Ab2GKW1j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 18:27:39 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-8.tower-131.messagelabs.com!1342045656!7261347!4
X-Originating-IP: [216.166.12.69]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 16/30] staging: comedi: cb_pcidio: use comedi_device pci_dev pointer
Date: Wed, 11 Jul 2012 15:27:34 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201207111527.34890.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the pci_dev pointer in the comedi_device struct instead of
carrying it in the private data.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/cb_pcidio.c | 21 ++++++++-------------
 1 file changed, 8 insertions(+), 13 deletions(-)

diff --git a/drivers/staging/comedi/drivers/cb_pcidio.c b/drivers/staging/comedi/drivers/cb_pcidio.c
index 2414d5a..a21ae2b 100644
--- a/drivers/staging/comedi/drivers/cb_pcidio.c
+++ b/drivers/staging/comedi/drivers/cb_pcidio.c
@@ -96,9 +96,6 @@ static const struct pcidio_board pcidio_boards[] = {
 struct pcidio_private {
 	int data;		/*  currently unused */
 
-	/* would be useful for a PCI device */
-	struct pci_dev *pci_dev;
-
 	/* used for DO readback, currently unused */
 	unsigned int do_readback[4];	/* up to 4 unsigned int suffice to hold 96 bits for PCI-DIO96 */
 
@@ -156,18 +153,18 @@ static int pcidio_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	if (alloc_private(dev, sizeof(struct pcidio_private)) < 0)
 		return -ENOMEM;
 
-	devpriv->pci_dev = pcidio_find_pci_dev(dev, it);
-	if (!devpriv->pci_dev)
+	dev->pcidev = pcidio_find_pci_dev(dev, it);
+	if (!dev->pcidev)
 		return -EIO;
 
 	dev->board_name = thisboard->name;
 
-	if (comedi_pci_enable(devpriv->pci_dev, thisboard->name))
+	if (comedi_pci_enable(dev->pcidev, thisboard->name))
 		return -EIO;
 
 	devpriv->dio_reg_base
 	    =
-	    pci_resource_start(devpriv->pci_dev,
+	    pci_resource_start(dev->pcidev,
 			       thisboard->dioregs_badrindex);
 
 	ret = comedi_alloc_subdevices(dev, thisboard->n_8255);
@@ -186,12 +183,10 @@ static int pcidio_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 
 static void pcidio_detach(struct comedi_device *dev)
 {
-	if (devpriv) {
-		if (devpriv->pci_dev) {
-			if (devpriv->dio_reg_base)
-				comedi_pci_disable(devpriv->pci_dev);
-			pci_dev_put(devpriv->pci_dev);
-		}
+	if (dev->pcidev) {
+		if (devpriv && devpriv->dio_reg_base)
+			comedi_pci_disable(dev->pcidev);
+		pci_dev_put(dev->pcidev);
 	}
 	if (dev->subdevices) {
 		int i;
-- 
1.7.11

