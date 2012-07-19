Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755290Ab2GSBjK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 21:39:10 -0400
Received: from mail131.messagelabs.com ([216.82.242.99]:62434 "EHLO
	mail131.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751596Ab2GSBjI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 21:39:08 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-16.tower-131.messagelabs.com!1342661947!25510464!1
X-Originating-IP: [216.166.12.178]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 31/90] staging: comedi: amplc_pc236: cleanup "find pci device" code
Date: Wed, 18 Jul 2012 18:39:03 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201207181839.03847.hartleys@visionengravers.com>
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
 drivers/staging/comedi/drivers/amplc_pc236.c | 43 +++++++++++-----------------
 1 file changed, 17 insertions(+), 26 deletions(-)

diff --git a/drivers/staging/comedi/drivers/amplc_pc236.c b/drivers/staging/comedi/drivers/amplc_pc236.c
index 77dae8e..3eee7f3 100644
--- a/drivers/staging/comedi/drivers/amplc_pc236.c
+++ b/drivers/staging/comedi/drivers/amplc_pc236.c
@@ -155,49 +155,42 @@ static const struct pc236_board *pc236_find_pci_board(struct pci_dev *pci_dev)
  * This function looks for a PCI device matching the requested board name,
  * bus and slot.
  */
-static struct pci_dev *
-pc236_find_pci(struct comedi_device *dev, int bus, int slot)
+static struct pci_dev *pc236_find_pci_dev(struct comedi_device *dev,
+					  struct comedi_devconfig *it)
 {
 	const struct pc236_board *thisboard = comedi_board(dev);
 	struct pci_dev *pci_dev = NULL;
+	int bus = it->options[0];
+	int slot = it->options[1];
 
-	/* Look for matching PCI device. */
-	for (pci_dev = pci_get_device(PCI_VENDOR_ID_AMPLICON, PCI_ANY_ID, NULL);
-	     pci_dev != NULL;
-	     pci_dev = pci_get_device(PCI_VENDOR_ID_AMPLICON,
-				      PCI_ANY_ID, pci_dev)) {
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
 		if (thisboard->model == anypci_model) {
 			/* Wildcard board matches any supported PCI board. */
 			const struct pc236_board *foundboard;
+
 			foundboard = pc236_find_pci_board(pci_dev);
 			if (foundboard == NULL)
 				continue;
 			/* Replace wildcard board_ptr. */
-			dev->board_ptr = thisboard = foundboard;
+			dev->board_ptr = foundboard;
 		} else {
 			/* Match specific model name. */
 			if (pci_dev->device != thisboard->devid)
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
 
@@ -536,12 +529,10 @@ static int pc236_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 		return pc236_common_attach(dev, iobase, irq, 0);
 	} else if (IS_ENABLED(CONFIG_COMEDI_AMPLC_PC236_PCI) &&
 		   thisboard->bustype == pci_bustype) {
-		int bus = it->options[0];
-		int slot = it->options[1];
 		struct pci_dev *pci_dev;
 
-		pci_dev = pc236_find_pci(dev, bus, slot);
-		if (pci_dev == NULL)
+		pci_dev = pc236_find_pci_dev(dev, it);
+		if (!pci_dev)
 			return -EIO;
 		return pc236_pci_common_attach(dev, pci_dev);
 	} else {
-- 
1.7.11

