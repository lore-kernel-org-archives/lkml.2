Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755171Ab2GSBfG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 21:35:06 -0400
Received: from mail132.messagelabs.com ([216.82.242.115]:41614 "EHLO
	mail132.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751772Ab2GSBfB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 21:35:01 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-3.tower-132.messagelabs.com!1342661700!14753972!1
X-Originating-IP: [216.166.12.32]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 23/90] staging: comedi: adv_pci_dio: cleanup "find pci device" code
Date: Wed, 18 Jul 2012 18:34:51 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201207181834.52069.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a couple local variables to make the tests more concise.
Reorder the tests to make the for() loop checking for a
matching boardtype quicker.

Drop the dev_dbg message for a match. It's just add noise.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/adv_pci_dio.c | 40 ++++++++++------------------
 1 file changed, 14 insertions(+), 26 deletions(-)

diff --git a/drivers/staging/comedi/drivers/adv_pci_dio.c b/drivers/staging/comedi/drivers/adv_pci_dio.c
index ab92169..c805208 100644
--- a/drivers/staging/comedi/drivers/adv_pci_dio.c
+++ b/drivers/staging/comedi/drivers/adv_pci_dio.c
@@ -1055,43 +1055,31 @@ static struct pci_dev *pci_dio_find_pci_dev(struct comedi_device *dev,
 					    struct comedi_devconfig *it)
 {
 	struct pci_dev *pcidev = NULL;
-	unsigned long iobase;
+	int bus = it->options[0];
+	int slot = it->options[1];
 	int i;
 
 	for_each_pci_dev(pcidev) {
-		/*  loop through cards supported by this driver */
+		if (bus || slot) {
+			if (bus != pcidev->bus->number ||
+			    slot != PCI_SLOT(pcidev->devfn))
+				continue;
+		}
+		if (pci_is_enabled(pcidev))
+			continue;
 		for (i = 0; i < ARRAY_SIZE(boardtypes); ++i) {
 			if (boardtypes[i].vendor_id != pcidev->vendor)
 				continue;
 			if (boardtypes[i].device_id != pcidev->device)
 				continue;
-			/*  was a particular bus/slot requested? */
-			if (it->options[0] || it->options[1]) {
-				/*  are we on the wrong bus/slot? */
-				if (pcidev->bus->number != it->options[0] ||
-				    PCI_SLOT(pcidev->devfn) != it->options[1]) {
-					continue;
-				}
-			}
-			if (pci_is_enabled(pcidev))
-				continue;
 			dev->board_ptr = boardtypes + i;
-			break;
+			return pcidev;
 		}
-		if (dev->board_ptr)
-			break;
-	}
-
-	if (!dev->board_ptr) {
-		dev_err(dev->class_dev,
-			"Error: Requested type of the card was not found!\n");
-		return NULL;
 	}
-	iobase = pci_resource_start(devpriv->pcidev, this_board->main_pci_region);
-	dev_dbg(dev->class_dev, "b:s:f=%d:%d:%d, io=0x%4lx\n",
-		pcidev->bus->number, PCI_SLOT(pcidev->devfn),
-		PCI_FUNC(pcidev->devfn), iobase);
-	return pcidev;
+	dev_err(dev->class_dev,
+		"No supported board found! (req. bus %d, slot %d)\n",
+		bus, slot);
+	return NULL;
 }
 
 static int pci_dio_attach(struct comedi_device *dev,
-- 
1.7.11

