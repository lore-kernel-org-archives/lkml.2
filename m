Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933463Ab2GKWch (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 18:32:37 -0400
Received: from mail132.messagelabs.com ([216.82.242.115]:48218 "EHLO
	mail132.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754309Ab2GKWcf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 18:32:35 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-7.tower-132.messagelabs.com!1342045936!12488910!32
X-Originating-IP: [216.166.12.97]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 24/30] staging: comedi: dyna_pci10xx: cleanup the "find pci device" code
Date: Wed, 11 Jul 2012 15:32:23 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201207111532.23939.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cleanup the "find pci device" code to follow the format of the
other comedi pci drivers.

Use for_each_pci_dev() instead of open-coding the for loop. Reorder
and refactor some of the tests to reduce the indent level. Change
the printk's to dev_printk's.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/dyna_pci10xx.c | 60 +++++++--------------------
 1 file changed, 16 insertions(+), 44 deletions(-)

diff --git a/drivers/staging/comedi/drivers/dyna_pci10xx.c b/drivers/staging/comedi/drivers/dyna_pci10xx.c
index e189f71..d8ce5da 100644
--- a/drivers/staging/comedi/drivers/dyna_pci10xx.c
+++ b/drivers/staging/comedi/drivers/dyna_pci10xx.c
@@ -233,56 +233,28 @@ static struct pci_dev *dyna_pci10xx_find_pci_dev(struct comedi_device *dev,
 						 struct comedi_devconfig *it)
 {
 	struct pci_dev *pcidev = NULL;
-	unsigned int opt_bus = it->options[0];
-	unsigned int opt_slot = it->options[1];
-	int board_index;
+	unsigned int bus = it->options[0];
+	unsigned int slot = it->options[1];
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
-					dev->board_ptr = &boardtypes[board_index];
-					break;
-				}
-		}
-		if (board_index < 0)
+	for_each_pci_dev(pcidev) {
+		if (pcidev->vendor != PCI_VENDOR_ID_DYNALOG)
 			continue;
-
-		/* Found matching vendor/device. */
-		if (opt_bus || opt_slot) {
-			/* Check bus/slot. */
-			if (opt_bus != pcidev->bus->number
-			    || opt_slot != PCI_SLOT(pcidev->devfn))
-				continue;	/* no match */
+		if (bus || slot) {
+			if (bus != pcidev->bus->number ||
+			    slot != PCI_SLOT(pcidev->devfn))
+				continue;
 		}
-
-		goto found;
-	}
-	printk(KERN_ERR "comedi: dyna_pci10xx: no supported device found!\n");
-	return NULL;
-
-found:
-
-	if (!pcidev) {
-		if (opt_bus || opt_slot) {
-			printk(KERN_ERR "comedi: dyna_pci10xx: "
-				"invalid PCI device at b:s %d:%d\n",
-				opt_bus, opt_slot);
-		} else {
-			printk(KERN_ERR "comedi: dyna_pci10xx: "
-				"invalid PCI device\n");
+		for (i = 0; i < ARRAY_SIZE(boardtypes); i++) {
+			if (pcidev->device == boardtypes[i].device_id) {
+				dev->board_ptr = &boardtypes[i];
+				dev_dbg(dev->class_dev, "device found!\n");
+				return pcidev;
+			}
 		}
-		return NULL;
 	}
-
-	printk(KERN_INFO "comedi: dyna_pci10xx: device found!\n");
-	return pcidev;
+	dev_err(dev->class_dev, "no supported device found!\n");
+	return NULL;
 }
 
 static int dyna_pci10xx_attach(struct comedi_device *dev,
-- 
1.7.11

