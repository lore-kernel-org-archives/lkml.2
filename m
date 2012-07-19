Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755549Ab2GSCCi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 22:02:38 -0400
Received: from mail132.messagelabs.com ([216.82.242.115]:52831 "EHLO
	mail132.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751592Ab2GSCCg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 22:02:36 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-15.tower-132.messagelabs.com!1342663316!14795392!14
X-Originating-IP: [216.166.12.97]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 78/90] staging: comedi: ke_counter: cleanup "find pci device" code
Date: Wed, 18 Jul 2012 19:02:11 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201207181902.11638.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cleanup the "find pci device" code so that it follows the style
of the other comedi pci drivers.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/ke_counter.c | 60 +++++++++++------------------
 1 file changed, 23 insertions(+), 37 deletions(-)

diff --git a/drivers/staging/comedi/drivers/ke_counter.c b/drivers/staging/comedi/drivers/ke_counter.c
index f0b8652..826e6c2 100644
--- a/drivers/staging/comedi/drivers/ke_counter.c
+++ b/drivers/staging/comedi/drivers/ke_counter.c
@@ -125,49 +125,35 @@ static int cnt_rinsn(struct comedi_device *dev,
 static struct pci_dev *cnt_find_pci_dev(struct comedi_device *dev,
 					struct comedi_devconfig *it)
 {
-	struct cnt_board_struct *board;
-	struct pci_dev *pci_device = NULL;
+	const struct cnt_board_struct *board;
+	struct pci_dev *pcidev = NULL;
+	int bus = it->options[0];
+	int slot = it->options[1];
 	int i;
 
 	/* Probe the device to determine what device in the series it is. */
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
-					board =
-					    (struct cnt_board_struct *)
-					    dev->board_ptr;
-					goto found;
-				}
-			}
+	for_each_pci_dev(pcidev) {
+		if (bus || slot) {
+			if (pcidev->bus->number != bus ||
+			    PCI_SLOT(pcidev->devfn) != slot)
+				continue;
+		}
+		if (pcidev->vendor != PCI_VENDOR_ID_KOLTER)
+			continue;
+
+		for (i = 0; i < cnt_board_nbr; i++) {
+			board = &cnt_boards[i];
+			if (board->device_id != pcidev->device)
+				continue;
+
+			dev->board_ptr = board;
+			return pcidev;
 		}
 	}
-	printk(KERN_WARNING
-	       "comedi%d: no supported board found! (req. bus/slot: %d/%d)\n",
-	       dev->minor, it->options[0], it->options[1]);
+	dev_err(dev->class_dev,
+		"No supported board found! (req. bus %d, slot %d)\n",
+		bus, slot);
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

