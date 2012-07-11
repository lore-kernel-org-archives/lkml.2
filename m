Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933454Ab2GKWaU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 18:30:20 -0400
Received: from mail160.messagelabs.com ([216.82.253.99]:9362 "EHLO
	mail160.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933372Ab2GKWaS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 18:30:18 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-2.tower-160.messagelabs.com!1342045814!9409562!6
X-Originating-IP: [216.166.12.31]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 20/30] staging: comedi: contec_pci_dio: cleanup the "find pci device" code
Date: Wed, 11 Jul 2012 15:30:11 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201207111530.11949.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cleanup the "find pci device" code to follow the format of the
other comedi pci drivers.

Create local variables for the bus and slot options to clarify the
code. Change the pci ven/dev test to reduce the indent level. Change
the printk into a dev_warn.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/contec_pci_dio.c | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/comedi/drivers/contec_pci_dio.c b/drivers/staging/comedi/drivers/contec_pci_dio.c
index b7313be..5d78c10 100644
--- a/drivers/staging/comedi/drivers/contec_pci_dio.c
+++ b/drivers/staging/comedi/drivers/contec_pci_dio.c
@@ -101,22 +101,22 @@ static struct pci_dev *contec_find_pci_dev(struct comedi_device *dev,
 					   struct comedi_devconfig *it)
 {
 	struct pci_dev *pcidev = NULL;
+	int bus = it->options[0];
+	int slot = it->options[1];
 
 	for_each_pci_dev(pcidev) {
-		if (pcidev->vendor == PCI_VENDOR_ID_CONTEC &&
-		    pcidev->device == PCI_DEVICE_ID_PIO1616L) {
-			if (it->options[0] || it->options[1]) {
-				/* Check bus and slot. */
-				if (it->options[0] != pcidev->bus->number ||
-				    it->options[1] != PCI_SLOT(pcidev->devfn)) {
-					continue;
-				}
-			}
-			dev->board_ptr = contec_boards + 0;
-			return pcidev;
+		if (pcidev->vendor != PCI_VENDOR_ID_CONTEC ||
+		    pcidev->device != PCI_DEVICE_ID_PIO1616L)
+			continue;
+		if (bus || slot) {
+			if (bus != pcidev->bus->number ||
+			    slot != PCI_SLOT(pcidev->devfn))
+				continue;
 		}
+		dev->board_ptr = contec_boards + 0;
+		return pcidev;
 	}
-	printk("card not present!\n");
+	dev_warn(dev->class_dev, "card not present!\n");
 	return NULL;
 }
 
-- 
1.7.11

