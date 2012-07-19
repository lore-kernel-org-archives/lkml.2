Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756087Ab2GSBus (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 21:50:48 -0400
Received: from mail131.messagelabs.com ([216.82.242.99]:33712 "EHLO
	mail131.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755905Ab2GSBuq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 21:50:46 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-5.tower-131.messagelabs.com!1342662645!25481793!1
X-Originating-IP: [216.166.12.97]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 58/90] staging: comedi: contec_pci_dio: store the pci_dev in the comedi_device
Date: Wed, 18 Jul 2012 18:50:42 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201207181850.42546.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the hw_dev pointer in the comedi_device struct to hold the
pci_dev instead of carrying it in the private data.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/contec_pci_dio.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/comedi/drivers/contec_pci_dio.c b/drivers/staging/comedi/drivers/contec_pci_dio.c
index b75a8af..5578c2c 100644
--- a/drivers/staging/comedi/drivers/contec_pci_dio.c
+++ b/drivers/staging/comedi/drivers/contec_pci_dio.c
@@ -59,9 +59,6 @@ static const struct contec_board contec_boards[] = {
 
 struct contec_private {
 	int data;
-
-	struct pci_dev *pci_dev;
-
 };
 
 #define devpriv ((struct contec_private *)dev->private)
@@ -143,7 +140,7 @@ static int contec_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	pcidev = contec_find_pci_dev(dev, it);
 	if (!pcidev)
 		return -EIO;
-	devpriv->pci_dev = pcidev;
+	comedi_set_hw_dev(dev, &pcidev->dev);
 
 	if (comedi_pci_enable(pcidev, "contec_pci_dio")) {
 		printk("error enabling PCI device and request regions!\n");
@@ -176,10 +173,12 @@ static int contec_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 
 static void contec_detach(struct comedi_device *dev)
 {
-	if (devpriv && devpriv->pci_dev) {
+	struct pci_dev *pcidev = comedi_to_pci_dev(dev);
+
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

