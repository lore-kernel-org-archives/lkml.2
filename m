Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933490Ab2GKWar (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 18:30:47 -0400
Received: from mail127.messagelabs.com ([216.82.250.115]:18321 "EHLO
	mail127.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933372Ab2GKWap (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 18:30:45 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-5.tower-127.messagelabs.com!1342045844!8353937!2
X-Originating-IP: [216.166.12.180]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 21/30] staging: comedi: contec_pci_dio: use comedi_device pci_dev pointer
Date: Wed, 11 Jul 2012 15:30:41 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201207111530.41511.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the pci_dev pointer in the comedi_device struct instead of
carrying it in the private data.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/contec_pci_dio.c | 17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/comedi/drivers/contec_pci_dio.c b/drivers/staging/comedi/drivers/contec_pci_dio.c
index 5d78c10..805f59c 100644
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
@@ -134,18 +131,18 @@ static int contec_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	if (ret)
 		return ret;
 
-	devpriv->pci_dev = contec_find_pci_dev(dev, it);
-	if (!devpriv->pci_dev)
+	dev->pcidev = contec_find_pci_dev(dev, it);
+	if (!dev->pcidev)
 		return -EIO;
 
 	dev->board_name = thisboard->name;
 
-	if (comedi_pci_enable(devpriv->pci_dev, "contec_pci_dio")) {
+	if (comedi_pci_enable(dev->pcidev, "contec_pci_dio")) {
 		printk("error enabling PCI device and request regions!\n");
 		return -EIO;
 	}
 
-	dev->iobase = pci_resource_start(devpriv->pci_dev, 0);
+	dev->iobase = pci_resource_start(dev->pcidev, 0);
 	printk(" base addr %lx ", dev->iobase);
 
 	s = dev->subdevices + 0;
@@ -172,10 +169,10 @@ static int contec_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 
 static void contec_detach(struct comedi_device *dev)
 {
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

