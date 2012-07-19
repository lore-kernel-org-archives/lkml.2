Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755267Ab2GSBgi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 21:36:38 -0400
Received: from mail127.messagelabs.com ([216.82.250.115]:11333 "EHLO
	mail127.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754898Ab2GSBgg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 21:36:36 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-12.tower-127.messagelabs.com!1342661795!9009613!1
X-Originating-IP: [216.166.12.97]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 27/90] staging: comedi: cb_pcidio: cleanup "find pci device" code
Date: Wed, 18 Jul 2012 18:36:30 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201207181836.30600.hartleys@visionengravers.com>
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
 drivers/staging/comedi/drivers/cb_pcidio.c | 31 +++++++++++++-----------------
 1 file changed, 13 insertions(+), 18 deletions(-)

diff --git a/drivers/staging/comedi/drivers/cb_pcidio.c b/drivers/staging/comedi/drivers/cb_pcidio.c
index 5f4d0a5..5527b4b 100644
--- a/drivers/staging/comedi/drivers/cb_pcidio.c
+++ b/drivers/staging/comedi/drivers/cb_pcidio.c
@@ -115,34 +115,29 @@ static struct pci_dev *pcidio_find_pci_dev(struct comedi_device *dev,
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
+				slot != PCI_SLOT(pcidev->devfn))
+				continue;
+		}
 		if (pcidev->vendor != PCI_VENDOR_ID_CB)
 			continue;
-		/*  loop through cards supported by this driver */
-		for (index = 0; index < ARRAY_SIZE(pcidio_boards); index++) {
-			if (pcidio_boards[index].dev_id != pcidev->device)
+		for (i = 0; i < ARRAY_SIZE(pcidio_boards); i++) {
+			if (pcidio_boards[i].dev_id != pcidev->device)
 				continue;
 
-			/*  was a particular bus/slot requested? */
-			if (it->options[0] || it->options[1]) {
-				/*  are we on the wrong bus/slot? */
-				if (pcidev->bus->number != it->options[0] ||
-				    PCI_SLOT(pcidev->devfn) != it->options[1]) {
-					continue;
-				}
-			}
-			dev->board_ptr = pcidio_boards + index;
-			dev_dbg(dev->class_dev, "Found %s on bus %i, slot %i\n",
-				thisboard->name, devpriv->pci_dev->bus->number,
-				PCI_SLOT(devpriv->pci_dev->devfn));
+			dev->board_ptr = pcidio_boards + i;
 			return pcidev;
 		}
 	}
 	dev_err(dev->class_dev,
-		"No supported ComputerBoards/MeasurementComputing card found on requested position\n");
+		"No supported board found! (req. bus %d, slot %d)\n",
+		bus, slot);
 	return NULL;
 }
 
-- 
1.7.11

