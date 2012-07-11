Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030427Ab2GKW1M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 18:27:12 -0400
Received: from mail160.messagelabs.com ([216.82.253.99]:27249 "EHLO
	mail160.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030333Ab2GKW1K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 18:27:10 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-3.tower-160.messagelabs.com!1342045627!9397313!3
X-Originating-IP: [216.166.12.72]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 15/30] staging: comedi: cb_pcidio: cleanup the "find pci device" code
Date: Wed, 11 Jul 2012 15:27:04 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201207111527.05177.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cleanup the "find pci device" code to follow the format of the
other comedi pci drivers.

Create local variables for the bus and slot options to clarify the
code. Reoder the tests so that if a bus/slot is requested the
loop checking against the boardinfo is not performed. Refactor
the code to remove the need for the 'goto'. Reword the messages
a bit. Also, move the setting of the dev->board_name back into the
attach.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/cb_pcidio.c | 47 ++++++++++++------------------
 1 file changed, 18 insertions(+), 29 deletions(-)

diff --git a/drivers/staging/comedi/drivers/cb_pcidio.c b/drivers/staging/comedi/drivers/cb_pcidio.c
index 582ff3b..2414d5a 100644
--- a/drivers/staging/comedi/drivers/cb_pcidio.c
+++ b/drivers/staging/comedi/drivers/cb_pcidio.c
@@ -115,46 +115,33 @@ static struct pci_dev *pcidio_find_pci_dev(struct comedi_device *dev,
 					   struct comedi_devconfig *it)
 {
 	struct pci_dev *pcidev = NULL;
+	int bus = it->options[0];
+	int slot = it->options[1];
 	int i;
 
 	for_each_pci_dev(pcidev) {
-		/*  is it not a computer boards card? */
 		if (pcidev->vendor != PCI_VENDOR_ID_CB)
 			continue;
-		/*  loop through cards supported by this driver */
-		for (i = 0; i < ARRAY_SIZE(pcidio_boards); i++) {
-			if (pcidio_boards[i].dev_id != pcidev->device)
+		if (bus || slot) {
+			if (pcidev->bus->number != bus ||
+			    PCI_SLOT(pcidev->devfn) != slot)
 				continue;
-
-			/*  was a particular bus/slot requested? */
-			if (it->options[0] || it->options[1]) {
-				/*  are we on the wrong bus/slot? */
-				if (pcidev->bus->number != it->options[0] ||
-				    PCI_SLOT(pcidev->devfn) != it->options[1]) {
-					continue;
-				}
+		}
+		for (i = 0; i < ARRAY_SIZE(pcidio_boards); i++) {
+			if (pcidio_boards[i].dev_id == pcidev->device) {
+				dev->board_ptr = pcidio_boards + i;
+				dev_dbg(dev->class_dev,
+					"Found %s on bus %i, slot %i\n",
+					thisboard->name, pcidev->bus->number,
+					PCI_SLOT(pcidev->devfn));
+				return pcidev;
 			}
-			dev->board_ptr = pcidio_boards + i;
-			goto found;
 		}
 	}
-
 	dev_err(dev->class_dev,
-		"No supported ComputerBoards/MeasurementComputing card found on requested position\n");
+		"No supported board found! (req. bus/slot: %d/%d)\n",
+		bus, slot);
 	return NULL;
-
-found:
-
-/*
- * Initialize dev->board_name.  Note that we can use the "thisboard"
- * macro now, since we just initialized it in the last line.
- */
-	dev->board_name = thisboard->name;
-
-	dev_dbg(dev->class_dev, "Found %s on bus %i, slot %i\n",
-		thisboard->name, pcidev->bus->number,
-		PCI_SLOT(pcidev->devfn));
-	return pcidev;
 }
 
 static int pcidio_attach(struct comedi_device *dev, struct comedi_devconfig *it)
@@ -173,6 +160,8 @@ static int pcidio_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	if (!devpriv->pci_dev)
 		return -EIO;
 
+	dev->board_name = thisboard->name;
+
 	if (comedi_pci_enable(devpriv->pci_dev, thisboard->name))
 		return -EIO;
 
-- 
1.7.11

