Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754337Ab2GSB2B (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 21:28:01 -0400
Received: from mail132.messagelabs.com ([216.82.242.115]:57673 "EHLO
	mail132.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750806Ab2GSB2A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 21:28:00 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-8.tower-132.messagelabs.com!1342661279!11912424!1
X-Originating-IP: [216.166.12.72]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 09/90] staging: comedi: adl_pci8164: store the pci_dev in the comedi_device
Date: Wed, 18 Jul 2012 18:27:53 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201207181827.53699.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the hw_dev pointer in the comedi_device struct to hold the
pci_dev instead of carrying it in the private data.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/adl_pci8164.c | 19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/comedi/drivers/adl_pci8164.c b/drivers/staging/comedi/drivers/adl_pci8164.c
index 1811375..94230d6 100644
--- a/drivers/staging/comedi/drivers/adl_pci8164.c
+++ b/drivers/staging/comedi/drivers/adl_pci8164.c
@@ -57,7 +57,6 @@ Configuration Options:
 
 struct adl_pci8164_private {
 	int data;
-	struct pci_dev *pci_dev;
 };
 
 #define devpriv ((struct adl_pci8164_private *)dev->private)
@@ -251,6 +250,7 @@ static struct pci_dev *adl_pci8164_find_pci(struct comedi_device *dev,
 static int adl_pci8164_attach(struct comedi_device *dev,
 			      struct comedi_devconfig *it)
 {
+	struct pci_dev *pcidev;
 	struct comedi_subdevice *s;
 	int ret;
 
@@ -266,16 +266,17 @@ static int adl_pci8164_attach(struct comedi_device *dev,
 	if (ret)
 		return ret;
 
-	devpriv->pci_dev = adl_pci8164_find_pci(dev, it);
-	if (!devpriv->pci_dev)
+	pcidev = adl_pci8164_find_pci(dev, it);
+	if (!pcidev)
 		return -EIO;
+	comedi_set_hw_dev(dev, &pcidev->dev);
 
-	if (comedi_pci_enable(devpriv->pci_dev, "adl_pci8164") < 0) {
+	if (comedi_pci_enable(pcidev, "adl_pci8164") < 0) {
 		printk(KERN_ERR "comedi%d: Failed to enable "
 		"PCI device and request regions\n", dev->minor);
 		return -EIO;
 	}
-	dev->iobase = pci_resource_start(devpriv->pci_dev, 2);
+	dev->iobase = pci_resource_start(pcidev, 2);
 	printk(KERN_DEBUG "comedi: base addr %4lx\n", dev->iobase);
 
 	s = dev->subdevices + 0;
@@ -324,10 +325,12 @@ static int adl_pci8164_attach(struct comedi_device *dev,
 
 static void adl_pci8164_detach(struct comedi_device *dev)
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

