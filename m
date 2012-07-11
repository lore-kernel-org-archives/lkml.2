Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030459Ab2GKWfV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 18:35:21 -0400
Received: from mail209.messagelabs.com ([216.82.255.3]:10453 "EHLO
	mail209.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030355Ab2GKWfS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 18:35:18 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-14.tower-209.messagelabs.com!1342046079!8405789!40
X-Originating-IP: [216.166.12.178]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 29/30] staging: comedi: ke_counter: cleanup the "find pci device" code
Date: Wed, 11 Jul 2012 15:35:10 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201207111535.10799.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cleanup the "find pci device" code to follow the format of the
other comedi pci drivers.

Use local variables for the bus and slot options to clarify the code.
Reorder and refactor some of the tests to reduce the indent level and
get rid of the 'goto'. Change the printk's to dev_printk's.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/ke_counter.c | 58 ++++++++++++-----------------
 1 file changed, 23 insertions(+), 35 deletions(-)

diff --git a/drivers/staging/comedi/drivers/ke_counter.c b/drivers/staging/comedi/drivers/ke_counter.c
index ddb83d3..1a2a240 100644
--- a/drivers/staging/comedi/drivers/ke_counter.c
+++ b/drivers/staging/comedi/drivers/ke_counter.c
@@ -62,8 +62,6 @@ static const struct cnt_board_struct cnt_boards[] = {
 	 .cnt_bits = 24}
 };
 
-#define cnt_board_nbr (sizeof(cnt_boards)/sizeof(struct cnt_board_struct))
-
 /*-- device private structure -----------------------------------------------*/
 
 struct cnt_device_private {
@@ -126,45 +124,35 @@ static struct pci_dev *cnt_find_pci_dev(struct comedi_device *dev,
 					struct comedi_devconfig *it)
 {
 	const struct cnt_board_struct *board;
-	struct pci_dev *pci_device = NULL;
+	struct pci_dev *pcidev = NULL;
+	unsigned int bus = it->options[0];
+	unsigned int slot = it->options[1];
 	int i;
 
-	for_each_pci_dev(pci_device) {
-		if (pci_device->vendor == PCI_VENDOR_ID_KOLTER) {
-			for (i = 0; i < cnt_board_nbr; i++) {
-				if (cnt_boards[i].device_id ==
-				    pci_device->device) {
-					/* was a particular bus/slot requested? */
-					if ((it->options[0] != 0)
-					    || (it->options[1] != 0)) {
-						/* are we on the wrong bus/slot? */
-						if (pci_device->bus->number !=
-						    it->options[0]
-						    ||
-						    PCI_SLOT(pci_device->devfn)
-						    != it->options[1]) {
-							continue;
-						}
-					}
-
-					dev->board_ptr = cnt_boards + i;
-					board = dev->board_ptr;
-					goto found;
-				}
+	for_each_pci_dev(pcidev) {
+		if (pcidev->vendor != PCI_VENDOR_ID_KOLTER)
+			continue;
+		if (bus || slot) {
+			if (pcidev->bus->number != bus ||
+			    PCI_SLOT(pcidev->devfn) != slot)
+				continue;
+		}
+		for (i = 0; i < ARRAY_SIZE(cnt_boards); i++) {
+			board = &cnt_boards[i];
+			if (board->device_id == pcidev->device) {
+				dev->board_ptr = board;
+				dev_info(dev->class_dev,
+					"found %s on bus %d, slot %d\n",
+					board->name, pcidev->bus->number,
+					PCI_SLOT(pcidev->devfn));
+				return pcidev;
 			}
 		}
 	}
-	printk(KERN_WARNING
-	       "comedi%d: no supported board found! (req. bus/slot: %d/%d)\n",
-	       dev->minor, it->options[0], it->options[1]);
+	dev_warn(dev->class_dev,
+	       "no supported board found! (req. bus/slot: %d/%d)\n",
+	       bus, slot);
 	return NULL;
-
-found:
-	printk(KERN_INFO
-	       "comedi%d: found %s at PCI bus %d, slot %d\n", dev->minor,
-	       board->name, pci_device->bus->number,
-	       PCI_SLOT(pci_device->devfn));
-	return pci_device;
 }
 
 static int cnt_attach(struct comedi_device *dev, struct comedi_devconfig *it)
-- 
1.7.11

