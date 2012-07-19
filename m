Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756106Ab2GSB72 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 21:59:28 -0400
Received: from mail209.messagelabs.com ([216.82.255.3]:21540 "EHLO
	mail209.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751721Ab2GSB7Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 21:59:25 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-13.tower-209.messagelabs.com!1342663162!9092297!4
X-Originating-IP: [216.166.12.180]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 70/90] staging: comedi: dyna_pci10xx: cleanup "find pci device" code
Date: Wed, 18 Jul 2012 18:59:17 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201207181859.17493.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cleanup the "find pci device" code so that it follows the style
of the other comedi pci drivers.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/dyna_pci10xx.c | 58 ++++++++-------------------
 1 file changed, 17 insertions(+), 41 deletions(-)

diff --git a/drivers/staging/comedi/drivers/dyna_pci10xx.c b/drivers/staging/comedi/drivers/dyna_pci10xx.c
index 81af215..bd804f1 100644
--- a/drivers/staging/comedi/drivers/dyna_pci10xx.c
+++ b/drivers/staging/comedi/drivers/dyna_pci10xx.c
@@ -233,55 +233,31 @@ static struct pci_dev *dyna_pci10xx_find_pci_dev(struct comedi_device *dev,
 						 struct comedi_devconfig *it)
 {
 	struct pci_dev *pcidev = NULL;
-	int opt_bus = it->options[0];
-	int opt_slot = it->options[1];
-	int board_index;
+	int bus = it->options[0];
+	int slot = it->options[1];
 	int i;
 
-	for (pcidev = pci_get_device(PCI_ANY_ID, PCI_ANY_ID, NULL);
-		pcidev != NULL;
-		pcidev = pci_get_device(PCI_ANY_ID, PCI_ANY_ID, pcidev)) {
-
-		board_index = -1;
-		for (i = 0; i < ARRAY_SIZE(boardtypes); ++i) {
-			if ((pcidev->vendor == PCI_VENDOR_ID_DYNALOG) &&
-				(pcidev->device == boardtypes[i].device_id)) {
-					board_index = i;
-					break;
-				}
+	for_each_pci_dev(pcidev) {
+		if (bus || slot) {
+			if (bus != pcidev->bus->number ||
+			    slot != PCI_SLOT(pcidev->devfn))
+				continue;
 		}
-		if (board_index < 0)
+		if (pcidev->vendor != PCI_VENDOR_ID_DYNALOG)
 			continue;
 
-		/* Found matching vendor/device. */
-		if (opt_bus || opt_slot) {
-			/* Check bus/slot. */
-			if (opt_bus != pcidev->bus->number
-			    || opt_slot != PCI_SLOT(pcidev->devfn))
-				continue;	/* no match */
-		}
-
-		goto found;
-	}
-	printk(KERN_ERR "comedi: dyna_pci10xx: no supported device found!\n");
-	return NULL;
-
-found:
+		for (i = 0; i < ARRAY_SIZE(boardtypes); ++i) {
+			if (pcidev->device != boardtypes[i].device_id)
+				continue;
 
-	if (!pcidev) {
-		if (opt_bus || opt_slot) {
-			printk(KERN_ERR "comedi: dyna_pci10xx: "
-				"invalid PCI device at b:s %d:%d\n",
-				opt_bus, opt_slot);
-		} else {
-			printk(KERN_ERR "comedi: dyna_pci10xx: "
-				"invalid PCI device\n");
+			dev->board_ptr = &boardtypes[i];
+			return pcidev;
 		}
-		return NULL;
 	}
-
-	dev->board_ptr = &boardtypes[board_index];
-	return pcidev;
+	dev_err(dev->class_dev,
+		"No supported board found! (req. bus %d, slot %d)\n",
+		bus, slot);
+	return NULL;
 }
 
 static int dyna_pci10xx_attach(struct comedi_device *dev,
-- 
1.7.11

