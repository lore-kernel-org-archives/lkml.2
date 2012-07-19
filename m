Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755857Ab2GSBoh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 21:44:37 -0400
Received: from mail132.messagelabs.com ([216.82.242.115]:8398 "EHLO
	mail132.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755453Ab2GSBoe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 21:44:34 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-6.tower-132.messagelabs.com!1342662273!13415657!1
X-Originating-IP: [216.166.12.99]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 43/90] staging: comedi: cb_pcidda: cleanup "find pci device" code
Date: Wed, 18 Jul 2012 18:44:22 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201207181844.23042.hartleys@visionengravers.com>
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
 drivers/staging/comedi/drivers/cb_pcidda.c | 37 +++++++++++++++---------------
 1 file changed, 18 insertions(+), 19 deletions(-)

diff --git a/drivers/staging/comedi/drivers/cb_pcidda.c b/drivers/staging/comedi/drivers/cb_pcidda.c
index d3d8326..3567f4a 100644
--- a/drivers/staging/comedi/drivers/cb_pcidda.c
+++ b/drivers/staging/comedi/drivers/cb_pcidda.c
@@ -259,30 +259,29 @@ static struct pci_dev *cb_pcidda_find_pci_dev(struct comedi_device *dev,
 					      struct comedi_devconfig *it)
 {
 	struct pci_dev *pcidev = NULL;
-	int index;
+	int bus = it->options[0];
+	int slot = it->options[1];
+	int i;
 
 	for_each_pci_dev(pcidev) {
-		if (pcidev->vendor == PCI_VENDOR_ID_CB) {
-			if (it->options[0] || it->options[1]) {
-				if (pcidev->bus->number != it->options[0] ||
-				    PCI_SLOT(pcidev->devfn) != it->options[1]) {
-					continue;
-				}
-			}
-			for (index = 0; index < ARRAY_SIZE(cb_pcidda_boards); index++) {
-				if (cb_pcidda_boards[index].device_id ==
-				    pcidev->device) {
-					dev->board_ptr = cb_pcidda_boards + index;
-					dev_dbg(dev->class_dev,
-						"Found %s at requested position\n",
-						thisboard->name);
-					return pcidev;
-				}
-			}
+		if (bus || slot) {
+			if (bus != pcidev->bus->number ||
+			    slot != PCI_SLOT(pcidev->devfn))
+				continue;
+		}
+		if (pcidev->vendor != PCI_VENDOR_ID_CB)
+			continue;
+
+		for (i = 0; i < ARRAY_SIZE(cb_pcidda_boards); i++) {
+			if (cb_pcidda_boards[i].device_id != pcidev->device)
+				continue;
+			dev->board_ptr = cb_pcidda_boards + i;
+			return pcidev;
 		}
 	}
 	dev_err(dev->class_dev,
-		"Not a ComputerBoards/MeasurementComputing card on requested position\n");
+		"No supported board found! (req. bus %d, slot %d)\n",
+		bus, slot);
 	return NULL;
 }
 
-- 
1.7.11

