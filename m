Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758392Ab2GKWVp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 18:21:45 -0400
Received: from mail132.messagelabs.com ([216.82.242.115]:18201 "EHLO
	mail132.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755477Ab2GKWVo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 18:21:44 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-2.tower-132.messagelabs.com!1342045287!14075567!14
X-Originating-IP: [216.166.12.72]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 05/30] staging: comedi: adl_pci7296: use comedi_device pci_dev pointer
Date: Wed, 11 Jul 2012 15:21:24 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201207111521.24454.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the pci_dev pointer in the comedi_device struct instead of
carrying it in the private data.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/adl_pci7296.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/comedi/drivers/adl_pci7296.c b/drivers/staging/comedi/drivers/adl_pci7296.c
index 58deb60..ef6c773 100644
--- a/drivers/staging/comedi/drivers/adl_pci7296.c
+++ b/drivers/staging/comedi/drivers/adl_pci7296.c
@@ -49,7 +49,6 @@ Configuration Options:
 
 struct adl_pci7296_private {
 	int data;
-	struct pci_dev *pci_dev;
 };
 
 #define devpriv ((struct adl_pci7296_private *)dev->private)
@@ -96,18 +95,18 @@ static int adl_pci7296_attach(struct comedi_device *dev,
 	if (ret)
 		return ret;
 
-	devpriv->pci_dev = adl_pci7296_find_pci(dev, it);
-	if (!devpriv->pci_dev)
+	dev->pcidev = adl_pci7296_find_pci(dev, it);
+	if (!dev->pcidev)
 		return -EIO;
 
-	if (comedi_pci_enable(devpriv->pci_dev, "adl_pci7296") < 0) {
+	if (comedi_pci_enable(dev->pcidev, "adl_pci7296") < 0) {
 		printk(KERN_ERR
 			"comedi%d: Failed to enable PCI device and request regions\n",
 			dev->minor);
 		return -EIO;
 	}
 
-	dev->iobase = pci_resource_start(devpriv->pci_dev, 2);
+	dev->iobase = pci_resource_start(dev->pcidev, 2);
 	printk(KERN_INFO "comedi: base addr %4lx\n", dev->iobase);
 
 	/*  four 8255 digital io subdevices */
@@ -139,10 +138,10 @@ static int adl_pci7296_attach(struct comedi_device *dev,
 
 static void adl_pci7296_detach(struct comedi_device *dev)
 {
-	if (devpriv && devpriv->pci_dev) {
+	if (dev->pcidev) {
 		if (dev->iobase)
-			comedi_pci_disable(devpriv->pci_dev);
-		pci_dev_put(devpriv->pci_dev);
+			comedi_pci_disable(dev->pcidev);
+		pci_dev_put(dev->pcidev);
 	}
 	if (dev->subdevices) {
 		subdev_8255_cleanup(dev, dev->subdevices + 0);
-- 
1.7.11

