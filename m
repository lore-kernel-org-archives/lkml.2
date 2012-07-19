Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755349Ab2GSBkr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 21:40:47 -0400
Received: from mail132.messagelabs.com ([216.82.242.115]:56862 "EHLO
	mail132.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751772Ab2GSBkp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 21:40:45 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-12.tower-132.messagelabs.com!1342662044!14782149!1
X-Originating-IP: [216.166.12.97]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 35/90] staging: comedi: amplc_pci224: cleanup "find pci device" code
Date: Wed, 18 Jul 2012 18:40:38 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201207181840.39066.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For aesthetic reasons, rename the function and pass the
comedi_devconfig struct instead of pre-parsing out the bus/slot
information.

Use for_each_pci_dev() instead of open-coding the loop using
pci_get_device().

Consolidate the dev_err messages when a pci device is not found.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/amplc_pci224.c | 43 ++++++++++-----------------
 1 file changed, 16 insertions(+), 27 deletions(-)

diff --git a/drivers/staging/comedi/drivers/amplc_pci224.c b/drivers/staging/comedi/drivers/amplc_pci224.c
index b87e10d..d489367 100644
--- a/drivers/staging/comedi/drivers/amplc_pci224.c
+++ b/drivers/staging/comedi/drivers/amplc_pci224.c
@@ -1256,50 +1256,42 @@ static const struct pci224_board
  * This function looks for a PCI device matching the requested board name,
  * bus and slot.
  */
-static struct pci_dev *
-pci224_find_pci(struct comedi_device *dev, int bus, int slot)
+static struct pci_dev *pci224_find_pci_dev(struct comedi_device *dev,
+					   struct comedi_devconfig *it)
 {
 	const struct pci224_board *thisboard = comedi_board(dev);
 	struct pci_dev *pci_dev = NULL;
+	int bus = it->options[0];
+	int slot = it->options[1];
 
-	/* Look for matching PCI device. */
-	for (pci_dev = pci_get_device(PCI_VENDOR_ID_AMPLICON, PCI_ANY_ID, NULL);
-	     pci_dev != NULL;
-	     pci_dev = pci_get_device(PCI_VENDOR_ID_AMPLICON, PCI_ANY_ID,
-				      pci_dev)) {
-		/* If bus/slot specified, check them. */
+	for_each_pci_dev(pci_dev) {
 		if (bus || slot) {
-			if (bus != pci_dev->bus->number
-			    || slot != PCI_SLOT(pci_dev->devfn))
+			if (bus != pci_dev->bus->number ||
+			    slot != PCI_SLOT(pci_dev->devfn))
 				continue;
 		}
+		if (pci_dev->vendor != PCI_VENDOR_ID_AMPLICON)
+			continue;
+
 		if (thisboard->model == any_model) {
 			/* Match any supported model. */
 			const struct pci224_board *board_ptr;
+
 			board_ptr = pci224_find_pci_board(pci_dev);
 			if (board_ptr == NULL)
 				continue;
 			/* Change board_ptr to matched board. */
 			dev->board_ptr = board_ptr;
-			thisboard = comedi_board(dev);
 		} else {
 			/* Match specific model name. */
 			if (thisboard->devid != pci_dev->device)
 				continue;
 		}
-
-		/* Found a match. */
 		return pci_dev;
 	}
-	/* No match found. */
-	if (bus || slot) {
-		dev_err(dev->class_dev,
-			"error! no %s found at pci %02x:%02x!\n",
-			thisboard->name, bus, slot);
-	} else {
-		dev_err(dev->class_dev, "error! no %s found!\n",
-			thisboard->name);
-	}
+	dev_err(dev->class_dev,
+		"No supported board found! (req. bus %d, slot %d)\n",
+		bus, slot);
 	return NULL;
 }
 
@@ -1474,21 +1466,18 @@ static int pci224_attach_common(struct comedi_device *dev,
 static int pci224_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 {
 	struct pci_dev *pci_dev;
-	int bus, slot;
 	int ret;
 
 	dev_info(dev->class_dev, DRIVER_NAME ": attach\n");
 
-	bus = it->options[0];
-	slot = it->options[1];
 	ret = alloc_private(dev, sizeof(struct pci224_private));
 	if (ret < 0) {
 		dev_err(dev->class_dev, "error! out of memory!\n");
 		return ret;
 	}
 
-	pci_dev = pci224_find_pci(dev, bus, slot);
-	if (pci_dev == NULL)
+	pci_dev = pci224_find_pci_dev(dev, it);
+	if (!pci_dev)
 		return -EIO;
 
 	return pci224_attach_common(dev, pci_dev, it->options);
-- 
1.7.11

