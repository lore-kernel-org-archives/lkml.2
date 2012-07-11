Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932334Ab2GKA0K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 20:26:10 -0400
Received: from mail209.messagelabs.com ([216.82.255.3]:43904 "EHLO
	mail209.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932123Ab2GKA0H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 20:26:07 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-7.tower-209.messagelabs.com!1341966363!8300281!7
X-Originating-IP: [216.166.12.180]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 81/83] staging: comedi: rtd520: cleanup the "find pci device" code
Date: Tue, 10 Jul 2012 17:25:33 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201207101725.33875.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use for_each_pci_dev() instead of open-coding the for loop. Create
local variables for the bus and slot options as well as the thisboard
pointer in order to clarify the code. Consolidate the printk's when
a supported board is not found into one dev_warn message.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/rtd520.c | 43 +++++++++++++++------------------
 1 file changed, 19 insertions(+), 24 deletions(-)

diff --git a/drivers/staging/comedi/drivers/rtd520.c b/drivers/staging/comedi/drivers/rtd520.c
index 97d888f..9a29500 100644
--- a/drivers/staging/comedi/drivers/rtd520.c
+++ b/drivers/staging/comedi/drivers/rtd520.c
@@ -1608,36 +1608,31 @@ static int rtd_dio_insn_config(struct comedi_device *dev,
 static struct pci_dev *rtd_find_pci(struct comedi_device *dev,
 				    struct comedi_devconfig *it)
 {
-	struct pci_dev *pcidev;
-
-	for (pcidev = pci_get_device(PCI_VENDOR_ID_RTD, PCI_ANY_ID, NULL);
-	     pcidev != NULL;
-	     pcidev = pci_get_device(PCI_VENDOR_ID_RTD, PCI_ANY_ID, pcidev)) {
-		int i;
+	const struct rtdBoard *thisboard;
+	struct pci_dev *pcidev = NULL;
+	int bus = it->options[0];
+	int slot = it->options[1];
+	int i;
 
-		if (it->options[0] || it->options[1]) {
-			if (pcidev->bus->number != it->options[0]
-			    || PCI_SLOT(pcidev->devfn) != it->options[1]) {
+	for_each_pci_dev(pcidev) {
+		if (pcidev->vendor != PCI_VENDOR_ID_RTD)
+			continue;
+		if (bus || slot) {
+			if (pcidev->bus->number != bus ||
+			    PCI_SLOT(pcidev->devfn) != slot)
 				continue;
-			}
 		}
-		for (i = 0; i < ARRAY_SIZE(rtd520Boards); ++i) {
-			if (pcidev->device == rtd520Boards[i].device_id) {
-				dev->board_ptr = &rtd520Boards[i];
-				break;
+		for (i = 0; i < ARRAY_SIZE(rtd520Boards); i++) {
+			thisboard = &rtd520Boards[i];
+			if (pcidev->device == thisboard->device_id) {
+				dev->board_ptr = thisboard;
+				return pcidev;
 			}
 		}
-		if (dev->board_ptr)
-			return pcidev;	/* found one */
-	}
-	if (!pcidev) {
-		if (it->options[0] && it->options[1]) {
-			printk(KERN_INFO "No RTD card at bus=%d slot=%d.\n",
-			       it->options[0], it->options[1]);
-		} else {
-			printk(KERN_INFO "No RTD card found.\n");
-		}
 	}
+	dev_warn(dev->class_dev,
+		"no supported board found! (req. bus/slot: %d/%d)\n",
+		bus, slot);
 	return NULL;
 }
 
-- 
1.7.11

