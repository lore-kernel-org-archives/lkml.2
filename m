Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755469Ab2GSCBW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 22:01:22 -0400
Received: from mail127.messagelabs.com ([216.82.250.115]:63646 "EHLO
	mail127.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754089Ab2GSCBT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 22:01:19 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-2.tower-127.messagelabs.com!1342663279!9008321!1
X-Originating-IP: [216.166.12.99]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 75/90] staging: comedi: dyna_pci10xx: store the pci_dev in the comedi_device
Date: Wed, 18 Jul 2012 19:01:13 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201207181901.13380.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the hw_dev pointer in the comedi_device struct to hold the
pci_dev instead of carrying it in the private data.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/dyna_pci10xx.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/comedi/drivers/dyna_pci10xx.c b/drivers/staging/comedi/drivers/dyna_pci10xx.c
index e7086b1..6821f87 100644
--- a/drivers/staging/comedi/drivers/dyna_pci10xx.c
+++ b/drivers/staging/comedi/drivers/dyna_pci10xx.c
@@ -100,10 +100,7 @@ static const struct boardtype boardtypes[] = {
 };
 
 struct dyna_pci10xx_private {
-	struct pci_dev *pci_dev;	/*  ptr to PCI device */
 	struct mutex mutex;
-
-	/* device base address registers */
 	unsigned long BADR3;
 };
 
@@ -273,7 +270,7 @@ static int dyna_pci10xx_attach(struct comedi_device *dev,
 	pcidev = dyna_pci10xx_find_pci_dev(dev, it);
 	if (!pcidev)
 		return -EIO;
-	devpriv->pci_dev = pcidev;
+	comedi_set_hw_dev(dev, &pcidev->dev);
 
 	dev->board_name = thisboard->name;
 	dev->irq = 0;
@@ -344,9 +341,12 @@ static int dyna_pci10xx_attach(struct comedi_device *dev,
 
 static void dyna_pci10xx_detach(struct comedi_device *dev)
 {
-	if (devpriv && devpriv->pci_dev) {
-		comedi_pci_disable(devpriv->pci_dev);
+	struct pci_dev *pcidev = comedi_to_pci_dev(dev);
+
+	if (devpriv)
 		mutex_destroy(&devpriv->mutex);
+	if (pcidev) {
+		comedi_pci_disable(pcidev);
 	}
 }
 
-- 
1.7.11

