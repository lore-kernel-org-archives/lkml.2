Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755251Ab2GSBl7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 21:41:59 -0400
Received: from mail131.messagelabs.com ([216.82.242.99]:46227 "EHLO
	mail131.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751956Ab2GSBl4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 21:41:56 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-9.tower-131.messagelabs.com!1342662109!22563506!2
X-Originating-IP: [216.166.12.98]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 37/90] staging: comedi: amplc_pci230: cleanup "find pci device" code
Date: Wed, 18 Jul 2012 18:41:47 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201207181841.47682.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For aesthetic reasons, rename the function and pass the
comedi_devconfig struct instead of pre-parsing out the bus/slot
information.

Consolidate the dev_err messages when a pci device is not found.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/amplc_pci230.c | 22 ++++++++--------------
 1 file changed, 8 insertions(+), 14 deletions(-)

diff --git a/drivers/staging/comedi/drivers/amplc_pci230.c b/drivers/staging/comedi/drivers/amplc_pci230.c
index 3d7f2cd..0b09934 100644
--- a/drivers/staging/comedi/drivers/amplc_pci230.c
+++ b/drivers/staging/comedi/drivers/amplc_pci230.c
@@ -2683,11 +2683,13 @@ static const struct pci230_board *pci230_find_pci_board(struct pci_dev *pci_dev)
 }
 
 /* Look for PCI device matching requested board name, bus and slot. */
-static struct pci_dev *pci230_find_pci(struct comedi_device *dev,
-				       int bus, int slot)
+static struct pci_dev *pci230_find_pci_dev(struct comedi_device *dev,
+					   struct comedi_devconfig *it)
 {
 	const struct pci230_board *thisboard = comedi_board(dev);
 	struct pci_dev *pci_dev = NULL;
+	int bus = it->options[0];
+	int slot = it->options[1];
 
 	for_each_pci_dev(pci_dev) {
 		/* Check vendor ID (same for all supported PCI boards). */
@@ -2707,23 +2709,16 @@ static struct pci_dev *pci230_find_pci(struct comedi_device *dev,
 				continue;
 			/* Replace wildcard board_ptr. */
 			dev->board_ptr = foundboard;
-			thisboard = comedi_board(dev);
 		} else {
 			/* Need to match a specific board. */
 			if (!pci230_match_pci_board(thisboard, pci_dev))
 				continue;
 		}
-		/* Found a matching PCI device. */
 		return pci_dev;
 	}
-	/* No matching PCI device found. */
-	if (bus || slot)
-		dev_err(dev->class_dev,
-			"error! no %s found at pci %02x:%02x\n",
-			thisboard->name, bus, slot);
-	else
-		dev_err(dev->class_dev,
-			"error! no %s found\n", thisboard->name);
+	dev_err(dev->class_dev,
+		"No supported board found! (req. bus %d, slot %d)\n",
+		bus, slot);
 	return NULL;
 }
 
@@ -2909,8 +2904,7 @@ static int pci230_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	rc = pci230_alloc_private(dev); /* sets dev->private */
 	if (rc)
 		return rc;
-	/* Find card. */
-	pci_dev = pci230_find_pci(dev, it->options[0], it->options[1]);
+	pci_dev = pci230_find_pci_dev(dev, it);
 	if (!pci_dev)
 		return -EIO;
 	return pci230_attach_common(dev, pci_dev);
-- 
1.7.11

