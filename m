Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753589Ab2GSB4i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 21:56:38 -0400
Received: from mail131.messagelabs.com ([216.82.242.99]:16261 "EHLO
	mail131.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751064Ab2GSB4g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 21:56:36 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-12.tower-131.messagelabs.com!1342662995!23128908!1
X-Originating-IP: [216.166.12.32]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 61/90] staging: comedi: daqboard2000: cleanup "find pci device" code
Date: Wed, 18 Jul 2012 18:56:29 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201207181856.29906.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The "find pci device" code for this driver was quite a bit
different from the other comedi pci drivers. Clean it up so
it follows the format of the other drivers.

Use for_each_pci_dev() instead of open-coding the loop using
pci_get_device().

Check for a specific bus/slot then the vendor/device ids.

The loop checking for the matching boardinfo was creating an
"id" based on the subsystem_device and subsystem_vendor info
from the pci_dev. The vendor id was already checked so just
check against the subsystem_device.

Only return the pci_dev if a matching boardinfo is found.

Consolidate the dev_err messages when a device is not found
into a single message.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/daqboard2000.c | 56 ++++++++++-----------------
 1 file changed, 20 insertions(+), 36 deletions(-)

diff --git a/drivers/staging/comedi/drivers/daqboard2000.c b/drivers/staging/comedi/drivers/daqboard2000.c
index fe2f39c..eb07466 100644
--- a/drivers/staging/comedi/drivers/daqboard2000.c
+++ b/drivers/staging/comedi/drivers/daqboard2000.c
@@ -120,8 +120,10 @@ Configuration options:
 
 #include "8255.h"
 
-#define DAQBOARD2000_SUBSYSTEM_IDS2 	0x00021616	/* Daqboard/2000 - 2 Dacs */
-#define DAQBOARD2000_SUBSYSTEM_IDS4 	0x00041616	/* Daqboard/2000 - 4 Dacs */
+#define PCI_VENDOR_ID_IOTECH		0x1616
+
+#define DAQBOARD2000_SUBSYSTEM_IDS2 	0x0002	/* Daqboard/2000 - 2 Dacs */
+#define DAQBOARD2000_SUBSYSTEM_IDS4 	0x0004	/* Daqboard/2000 - 4 Dacs */
 
 #define DAQBOARD2000_DAQ_SIZE 		0x1002
 #define DAQBOARD2000_PLX_SIZE 		0x100
@@ -709,47 +711,29 @@ static struct pci_dev *daqboard2000_find_pci_dev(struct comedi_device *dev,
 	struct pci_dev *pcidev = NULL;
 	int bus = it->options[0];
 	int slot = it->options[1];
+	int i;
 
-	for (pcidev = pci_get_device(0x1616, 0x0409, NULL);
-	     pcidev != NULL; pcidev = pci_get_device(0x1616, 0x0409, pcidev)) {
+	for_each_pci_dev(pcidev) {
 		if (bus || slot) {
-			/* requested particular bus/slot */
-			if (pcidev->bus->number != bus ||
-			    PCI_SLOT(pcidev->devfn) != slot) {
+			if (bus != pcidev->bus->number ||
+			    slot != PCI_SLOT(pcidev->devfn))
 				continue;
-			}
 		}
-		break;		/* found one */
-	}
-	if (!pcidev) {
-		if (bus || slot)
-			dev_err(dev->class_dev,
-				"no daqboard2000 found at bus/slot: %d/%d\n",
-				bus, slot);
-		else
-			dev_err(dev->class_dev, "no daqboard2000 found\n");
-		return NULL;
-	} else {
-		u32 id;
-		int i;
+		if (pcidev->vendor != PCI_VENDOR_ID_IOTECH ||
+		    pcidev->device != 0x0409)
+			continue;
 
-		id = ((u32) pcidev->
-		      subsystem_device << 16) | pcidev->subsystem_vendor;
 		for (i = 0; i < ARRAY_SIZE(boardtypes); i++) {
-			if (boardtypes[i].id == id) {
-				dev_dbg(dev->class_dev, "%s\n",
-					boardtypes[i].name);
-				dev->board_ptr = boardtypes + i;
-			}
-		}
-		if (!dev->board_ptr) {
-			printk
-			    (" unknown subsystem id %08x (pretend it is an ids2)",
-			     id);
-			dev->board_ptr = boardtypes;
+			if (boardtypes[i].id != pcidev->subsystem_device)
+				continue;
+			dev->board_ptr = boardtypes + i;
+			return pcidev;
 		}
-		return pcidev;
 	}
+	dev_err(dev->class_dev,
+		"No supported board found! (req. bus %d, slot %d)\n",
+		bus, slot);
+	return NULL;
 }
 
 static int daqboard2000_attach(struct comedi_device *dev,
@@ -886,7 +870,7 @@ static void __devexit daqboard2000_pci_remove(struct pci_dev *dev)
 }
 
 static DEFINE_PCI_DEVICE_TABLE(daqboard2000_pci_table) = {
-	{ PCI_DEVICE(0x1616, 0x0409) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_IOTECH, 0x0409) },
 	{ 0 }
 };
 MODULE_DEVICE_TABLE(pci, daqboard2000_pci_table);
-- 
1.7.11

