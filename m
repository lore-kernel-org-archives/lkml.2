Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755537Ab2GSBnI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 21:43:08 -0400
Received: from mail132.messagelabs.com ([216.82.242.115]:63855 "EHLO
	mail132.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754862Ab2GSBnE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 21:43:04 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-8.tower-132.messagelabs.com!1342662183!11913084!1
X-Originating-IP: [216.166.12.32]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 40/90] staging: comedi: cb_pcidas64: cleanup "find pci device" code
Date: Wed, 18 Jul 2012 18:42:57 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201207181842.57929.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a couple local variables to make the tests more concise.
Reorder the tests to make the for() loop checking for a
matching boardtype quicker.

Drop the dev_dbg for a match. It's just add noise.
Reword the dev_err when no match is found.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/cb_pcidas64.c | 34 ++++++++++++----------------
 1 file changed, 15 insertions(+), 19 deletions(-)

diff --git a/drivers/staging/comedi/drivers/cb_pcidas64.c b/drivers/staging/comedi/drivers/cb_pcidas64.c
index 704f5ea..d1b0327 100644
--- a/drivers/staging/comedi/drivers/cb_pcidas64.c
+++ b/drivers/staging/comedi/drivers/cb_pcidas64.c
@@ -1654,33 +1654,29 @@ static struct pci_dev *cb_pcidas64_find_pci_dev(struct comedi_device *dev,
 						struct comedi_devconfig *it)
 {
 	struct pci_dev *pcidev = NULL;
-	int index;
+	int bus = it->options[0];
+	int slot = it->options[1];
+	int i;
 
 	for_each_pci_dev(pcidev) {
-		/*  is it not a computer boards card? */
+		if (bus || slot) {
+			if (bus != pcidev->bus->number ||
+			    slot != PCI_SLOT(pcidev->devfn))
+				continue;
+		}
 		if (pcidev->vendor != PCI_VENDOR_ID_COMPUTERBOARDS)
 			continue;
-		/*  loop through cards supported by this driver */
-		for (index = 0; index < ARRAY_SIZE(pcidas64_boards); index++) {
-			if (pcidas64_boards[index].device_id != pcidev->device)
+
+		for (i = 0; i < ARRAY_SIZE(pcidas64_boards); i++) {
+			if (pcidas64_boards[i].device_id != pcidev->device)
 				continue;
-			/*  was a particular bus/slot requested? */
-			if (it->options[0] || it->options[1]) {
-				/*  are we on the wrong bus/slot? */
-				if (pcidev->bus->number != it->options[0] ||
-				    PCI_SLOT(pcidev->devfn) != it->options[1]) {
-					continue;
-				}
-			}
-			dev->board_ptr = pcidas64_boards + index;
-			dev_dbg(dev->class_dev, "Found %s on bus %i, slot %i\n",
-				board(dev)->name,
-				pcidev->bus->number, PCI_SLOT(pcidev->devfn));
+			dev->board_ptr = pcidas64_boards + i;
 			return pcidev;
 		}
 	}
-
-	printk("No supported ComputerBoards/MeasurementComputing card found\n");
+	dev_err(dev->class_dev,
+		"No supported board found! (req. bus %d, slot %d)\n",
+		bus, slot);
 	return NULL;
 }
 
-- 
1.7.11

