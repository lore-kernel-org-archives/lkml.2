Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756161Ab2GSCEH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 22:04:07 -0400
Received: from mail160.messagelabs.com ([216.82.253.99]:31724 "EHLO
	mail160.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751566Ab2GSCEE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 22:04:04 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-8.tower-160.messagelabs.com!1342663441!10108606!5
X-Originating-IP: [216.166.12.98]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 84/90] staging: comedi: me_daq: store the pci_dev in the comedi_device
Date: Wed, 18 Jul 2012 19:03:59 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201207181903.59489.hartleys@visionengravers.com>
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
 drivers/staging/comedi/drivers/me_daq.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/comedi/drivers/me_daq.c b/drivers/staging/comedi/drivers/me_daq.c
index cd66af9..8c6f8b9 100644
--- a/drivers/staging/comedi/drivers/me_daq.c
+++ b/drivers/staging/comedi/drivers/me_daq.c
@@ -233,7 +233,6 @@ static const struct me_board me_boards[] = {
 
 /* Private data structure */
 struct me_private_data {
-	struct pci_dev *pci_device;
 	void __iomem *plx_regbase;	/* PLX configuration base address */
 	void __iomem *me_regbase;	/* Base address of the Meilhaus card */
 	unsigned long plx_regbase_size;	/* Size of PLX configuration space */
@@ -662,7 +661,7 @@ static int me_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	pci_device = me_find_pci_dev(dev, it);
 	if (!pci_device)
 		return -EIO;
-	dev_private->pci_device = pci_device;
+	comedi_set_hw_dev(dev, &pci_device->dev);
 	board = (struct me_board *)dev->board_ptr;
 
 	/* Enable PCI device and request PCI regions */
@@ -799,6 +798,8 @@ static int me_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 
 static void me_detach(struct comedi_device *dev)
 {
+	struct pci_dev *pcidev = comedi_to_pci_dev(dev);
+
 	if (dev_private) {
 		if (dev_private->me_regbase) {
 			me_reset(dev);
@@ -806,11 +807,11 @@ static void me_detach(struct comedi_device *dev)
 		}
 		if (dev_private->plx_regbase)
 			iounmap(dev_private->plx_regbase);
-		if (dev_private->pci_device) {
-			if (dev_private->plx_regbase_size)
-				comedi_pci_disable(dev_private->pci_device);
-			pci_dev_put(dev_private->pci_device);
-		}
+	}
+	if (pcidev) {
+		if (dev_private->plx_regbase_size)
+			comedi_pci_disable(pcidev);
+		pci_dev_put(pcidev);
 	}
 }
 
-- 
1.7.11

