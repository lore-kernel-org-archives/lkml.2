Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752301Ab2GSBuY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 21:50:24 -0400
Received: from mail209.messagelabs.com ([216.82.255.3]:61192 "EHLO
	mail209.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751181Ab2GSBuV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 21:50:21 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-13.tower-209.messagelabs.com!1342662619!9091978!1
X-Originating-IP: [216.166.12.72]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 57/90] staging: comedi: contec_pci_dio: cleanup "find pci device" code
Date: Wed, 18 Jul 2012 18:50:16 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201207181850.16843.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a couple local variables and reorder the tests to make
to make the more concise.

Change the printk to a dev_err when no match is found and reword
the message.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/contec_pci_dio.c | 27 ++++++++++++++-----------
 1 file changed, 15 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/comedi/drivers/contec_pci_dio.c b/drivers/staging/comedi/drivers/contec_pci_dio.c
index e4d37fc..b75a8af 100644
--- a/drivers/staging/comedi/drivers/contec_pci_dio.c
+++ b/drivers/staging/comedi/drivers/contec_pci_dio.c
@@ -101,22 +101,25 @@ static struct pci_dev *contec_find_pci_dev(struct comedi_device *dev,
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
+		if (bus || slot) {
+			if (bus != pcidev->bus->number ||
+				slot != PCI_SLOT(pcidev->devfn))
+				continue;
 		}
+		if (pcidev->vendor != PCI_VENDOR_ID_CONTEC ||
+		    pcidev->device != PCI_DEVICE_ID_PIO1616L)
+			continue;
+
+		dev->board_ptr = contec_boards + 0;
+		return pcidev;
 	}
-	printk("card not present!\n");
+	dev_err(dev->class_dev,
+		"No supported board found! (req. bus %d, slot %d)\n",
+		bus, slot);
 	return NULL;
 }
 
-- 
1.7.11

