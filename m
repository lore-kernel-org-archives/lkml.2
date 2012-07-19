Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756037Ab2GSBt2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 21:49:28 -0400
Received: from mail160.messagelabs.com ([216.82.253.99]:49391 "EHLO
	mail160.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755098Ab2GSBtZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 21:49:25 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-3.tower-160.messagelabs.com!1342662552!10100486!3
X-Originating-IP: [216.166.12.99]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 54/90] staging: comedi: cb_pcimdas: remove BADR0 from the private data
Date: Wed, 18 Jul 2012 18:49:03 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201207181849.03445.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The pci resource bar 0 address is only used as a "flag" to
let the datach function know that the pci device has been
enabled. Use dev->iobase in the detach instead and remove
BADR0 from the private data.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/cb_pcimdas.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/staging/comedi/drivers/cb_pcimdas.c b/drivers/staging/comedi/drivers/cb_pcimdas.c
index 4312e9b..ce08533 100644
--- a/drivers/staging/comedi/drivers/cb_pcimdas.c
+++ b/drivers/staging/comedi/drivers/cb_pcimdas.c
@@ -56,7 +56,6 @@ See http://www.mccdaq.com/PDFs/Manuals/pcim-das1602-16.pdf for more details.
 /* Registers for the PCIM-DAS1602/16 */
 
 /* sizes of io regions (bytes) */
-#define BADR0_SIZE 2		/* ?? */
 #define BADR3_SIZE 16
 
 /* DAC Offsets */
@@ -135,7 +134,6 @@ struct cb_pcimdas_private {
 	struct pci_dev *pci_dev;
 
 	/* base addresses */
-	unsigned long BADR0;
 	unsigned long BADR3;
 
 	/* Used for AO readback */
@@ -230,7 +228,6 @@ static int cb_pcimdas_attach(struct comedi_device *dev,
 		return -EIO;
 	}
 
-	devpriv->BADR0 = pci_resource_start(devpriv->pci_dev, 0);
 	dev->iobase = pci_resource_start(devpriv->pci_dev, 2);
 	devpriv->BADR3 = pci_resource_start(devpriv->pci_dev, 3);
 	iobase_8255 = pci_resource_start(devpriv->pci_dev, 4);
@@ -290,7 +287,7 @@ static void cb_pcimdas_detach(struct comedi_device *dev)
 		free_irq(dev->irq, dev);
 	if (devpriv) {
 		if (devpriv->pci_dev) {
-			if (devpriv->BADR0)
+			if (dev->iobase)
 				comedi_pci_disable(devpriv->pci_dev);
 			pci_dev_put(devpriv->pci_dev);
 		}
-- 
1.7.11

