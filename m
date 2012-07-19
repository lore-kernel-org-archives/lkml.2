Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755927Ab2GSBqi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 21:46:38 -0400
Received: from mail131.messagelabs.com ([216.82.242.99]:20501 "EHLO
	mail131.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755455Ab2GSBqg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 21:46:36 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-7.tower-131.messagelabs.com!1342662389!25514914!8
X-Originating-IP: [216.166.12.69]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 48/90] staging: comedi: cb_pcimdas: cleanup "find pci device" code
Date: Wed, 18 Jul 2012 18:46:27 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201207181846.28163.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a couple local variables to make the tests more concise.

Reorder the tests to make the for() loop checking for a
matching boardtype quicker.

Use ARRAY_SIZE() to determine the number of boards instead
of the hard-coded '1'.

Drop the dev_dbg for a match. It's just add noise.

Reword the dev_err when no match is found.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/cb_pcimdas.c | 38 ++++++++++++-----------------
 1 file changed, 15 insertions(+), 23 deletions(-)

diff --git a/drivers/staging/comedi/drivers/cb_pcimdas.c b/drivers/staging/comedi/drivers/cb_pcimdas.c
index 8999a72..1b6ebb7 100644
--- a/drivers/staging/comedi/drivers/cb_pcimdas.c
+++ b/drivers/staging/comedi/drivers/cb_pcimdas.c
@@ -122,8 +122,6 @@ static const struct cb_pcimdas_board cb_pcimdas_boards[] = {
 	 },
 };
 
-#define N_BOARDS 1		/*  Max number of boards supported */
-
 /*
  * Useful for shorthand access to the particular board structure
  */
@@ -179,36 +177,30 @@ static struct pci_dev *cb_pcimdas_find_pci_dev(struct comedi_device *dev,
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
 		if (pcidev->vendor != PCI_VENDOR_ID_COMPUTERBOARDS)
 			continue;
-		/*  loop through cards supported by this driver */
-		for (index = 0; index < N_BOARDS; index++) {
-			if (cb_pcimdas_boards[index].device_id !=
-			    pcidev->device)
+
+		for (i = 0; i < ARRAY_SIZE(cb_pcimdas_boards); i++) {
+			if (cb_pcimdas_boards[i].device_id != pcidev->device)
 				continue;
-			/*  was a particular bus/slot requested? */
-			if (it->options[0] || it->options[1]) {
-				/*  are we on the wrong bus/slot? */
-				if (pcidev->bus->number != it->options[0] ||
-				    PCI_SLOT(pcidev->devfn) != it->options[1]) {
-					continue;
-				}
-			}
-			dev->board_ptr = cb_pcimdas_boards + index;
-			dev_dbg(dev->class_dev,
-				"Found %s on bus %i, slot %i\n",
-				cb_pcimdas_boards[index].name,
-				pcidev->bus->number,
-				PCI_SLOT(pcidev->devfn));
+
+			dev->board_ptr = cb_pcimdas_boards + i;
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

