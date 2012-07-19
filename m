Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755523Ab2GSBmr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 21:42:47 -0400
Received: from mail131.messagelabs.com ([216.82.242.99]:5656 "EHLO
	mail131.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755178Ab2GSBmm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 21:42:42 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-6.tower-131.messagelabs.com!1342662161!15712291!1
X-Originating-IP: [216.166.12.98]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 39/90] staging: comedi: cb_pcidas64: factor out the "find pci device" code
Date: Wed, 18 Jul 2012 18:42:36 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201207181842.36331.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Factor the "find pci device" code out of the attach function.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/cb_pcidas64.c | 57 ++++++++++++++--------------
 1 file changed, 29 insertions(+), 28 deletions(-)

diff --git a/drivers/staging/comedi/drivers/cb_pcidas64.c b/drivers/staging/comedi/drivers/cb_pcidas64.c
index 11ce3fd..704f5ea 100644
--- a/drivers/staging/comedi/drivers/cb_pcidas64.c
+++ b/drivers/staging/comedi/drivers/cb_pcidas64.c
@@ -1650,26 +1650,11 @@ static inline void warn_external_queue(struct comedi_device *dev)
 		     "Use internal AI channel queue (channels must be consecutive and use same range/aref)");
 }
 
-/*
- * Attach is called by the Comedi core to configure the driver
- * for a particular board.
- */
-static int attach(struct comedi_device *dev, struct comedi_devconfig *it)
+static struct pci_dev *cb_pcidas64_find_pci_dev(struct comedi_device *dev,
+						struct comedi_devconfig *it)
 {
 	struct pci_dev *pcidev = NULL;
 	int index;
-	uint32_t local_range, local_decode;
-	int retval;
-
-/*
- * Allocate the private structure area.
- */
-	if (alloc_private(dev, sizeof(struct pcidas64_private)) < 0)
-		return -ENOMEM;
-
-/*
- * Probe the device to determine what device in the series it is.
- */
 
 	for_each_pci_dev(pcidev) {
 		/*  is it not a computer boards card? */
@@ -1687,22 +1672,38 @@ static int attach(struct comedi_device *dev, struct comedi_devconfig *it)
 					continue;
 				}
 			}
-			priv(dev)->hw_dev = pcidev;
 			dev->board_ptr = pcidas64_boards + index;
-			break;
+			dev_dbg(dev->class_dev, "Found %s on bus %i, slot %i\n",
+				board(dev)->name,
+				pcidev->bus->number, PCI_SLOT(pcidev->devfn));
+			return pcidev;
 		}
-		if (dev->board_ptr)
-			break;
 	}
 
-	if (dev->board_ptr == NULL) {
-		printk
-		    ("No supported ComputerBoards/MeasurementComputing card found\n");
-		return -EIO;
-	}
+	printk("No supported ComputerBoards/MeasurementComputing card found\n");
+	return NULL;
+}
+
+/*
+ * Attach is called by the Comedi core to configure the driver
+ * for a particular board.
+ */
+static int attach(struct comedi_device *dev, struct comedi_devconfig *it)
+{
+	struct pci_dev *pcidev;
+	uint32_t local_range, local_decode;
+	int retval;
 
-	dev_dbg(dev->class_dev, "Found %s on bus %i, slot %i\n",
-		board(dev)->name, pcidev->bus->number, PCI_SLOT(pcidev->devfn));
+/*
+ * Allocate the private structure area.
+ */
+	if (alloc_private(dev, sizeof(struct pcidas64_private)) < 0)
+		return -ENOMEM;
+
+	pcidev = cb_pcidas64_find_pci_dev(dev, it);
+	if (!pcidev)
+		return -EIO;
+	priv(dev)->hw_dev = pcidev;
 
 	if (comedi_pci_enable(pcidev, dev->driver->driver_name)) {
 		dev_warn(dev->class_dev,
-- 
1.7.11

