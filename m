Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756129Ab2GSCDE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 22:03:04 -0400
Received: from mail209.messagelabs.com ([216.82.255.3]:30036 "EHLO
	mail209.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752498Ab2GSCC7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 22:02:59 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-3.tower-209.messagelabs.com!1342663378!8636303!2
X-Originating-IP: [216.166.12.31]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 80/90] staging: comedi: ke_counter: store the pci_dev in the comedi_device
Date: Wed, 18 Jul 2012 19:02:50 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201207181902.50905.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the hw_dev pointer in the comedi_device struct to hold the
pci_dev instead of carrying it in the private data.

Since the pci_dev was the only thing in the private data, remove
the struct, the devpriv macro, and it's allocation.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/ke_counter.c | 24 ++++++------------------
 1 file changed, 6 insertions(+), 18 deletions(-)

diff --git a/drivers/staging/comedi/drivers/ke_counter.c b/drivers/staging/comedi/drivers/ke_counter.c
index 78eb8d4..4153977 100644
--- a/drivers/staging/comedi/drivers/ke_counter.c
+++ b/drivers/staging/comedi/drivers/ke_counter.c
@@ -64,15 +64,6 @@ static const struct cnt_board_struct cnt_boards[] = {
 
 #define cnt_board_nbr (sizeof(cnt_boards)/sizeof(struct cnt_board_struct))
 
-/*-- device private structure -----------------------------------------------*/
-
-struct cnt_device_private {
-
-	struct pci_dev *pcidev;
-};
-
-#define devpriv ((struct cnt_device_private *)dev->private)
-
 /*-- counter write ----------------------------------------------------------*/
 
 /* This should be used only for resetting the counters; maybe it is better
@@ -164,15 +155,10 @@ static int cnt_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	unsigned long io_base;
 	int error;
 
-	/* allocate device private structure */
-	error = alloc_private(dev, sizeof(struct cnt_device_private));
-	if (error < 0)
-		return error;
-
 	pcidev = cnt_find_pci_dev(dev, it);
 	if (!pcidev)
 		return -EIO;
-	devpriv->pcidev = pcidev;
+	comedi_set_hw_dev(dev, &pcidev->dev);
 	board = comedi_board(dev);
 
 	dev->board_name = board->name;
@@ -219,10 +205,12 @@ static int cnt_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 
 static void cnt_detach(struct comedi_device *dev)
 {
-	if (devpriv && devpriv->pcidev) {
+	struct pci_dev *pcidev = comedi_to_pci_dev(dev);
+
+	if (pcidev) {
 		if (dev->iobase)
-			comedi_pci_disable(devpriv->pcidev);
-		pci_dev_put(devpriv->pcidev);
+			comedi_pci_disable(pcidev);
+		pci_dev_put(pcidev);
 	}
 }
 
-- 
1.7.11

