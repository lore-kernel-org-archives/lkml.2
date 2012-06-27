Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755563Ab2F0AxQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 20:53:16 -0400
Received: from mail127.messagelabs.com ([216.82.250.115]:25027 "EHLO
	mail127.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751036Ab2F0AxP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 20:53:15 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-6.tower-127.messagelabs.com!1340758394!6930121!1
X-Originating-IP: [216.166.12.97]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 11/36] staging: comedi: cb_pcidas: factor out the find pci device code
Date: Tue, 26 Jun 2012 17:53:08 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201206261753.09249.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Factor the "find pci device" code out of the attach function.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Frank Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/cb_pcidas.c | 70 ++++++++++++++++--------------
 1 file changed, 38 insertions(+), 32 deletions(-)

diff --git a/drivers/staging/comedi/drivers/cb_pcidas.c b/drivers/staging/comedi/drivers/cb_pcidas.c
index 146d078..051c94c 100644
--- a/drivers/staging/comedi/drivers/cb_pcidas.c
+++ b/drivers/staging/comedi/drivers/cb_pcidas.c
@@ -1608,64 +1608,70 @@ static irqreturn_t cb_pcidas_interrupt(int irq, void *d)
 	return IRQ_HANDLED;
 }
 
-static int cb_pcidas_attach(struct comedi_device *dev,
-			    struct comedi_devconfig *it)
+static struct pci_dev *cb_pcidas_find_pci_device(struct comedi_device *dev,
+						 struct comedi_devconfig *it)
 {
 	const struct cb_pcidas_board *thisboard;
-	struct cb_pcidas_private *devpriv;
-	struct comedi_subdevice *s;
 	struct pci_dev *pcidev = NULL;
-	int index;
+	int bus = it->options[0];
+	int slot = it->options[1];
 	int i;
-	int ret;
-
-/*
- * Allocate the private structure area.
- */
-	if (alloc_private(dev, sizeof(struct cb_pcidas_private)) < 0)
-		return -ENOMEM;
-	devpriv = dev->private;
-
-/*
- * Probe the device to determine what device in the series it is.
- */
 
 	for_each_pci_dev(pcidev) {
 		/*  is it not a computer boards card? */
 		if (pcidev->vendor != PCI_VENDOR_ID_CB)
 			continue;
 		/*  loop through cards supported by this driver */
-		for (index = 0; index < ARRAY_SIZE(cb_pcidas_boards); index++) {
-			if (cb_pcidas_boards[index].device_id != pcidev->device)
+		for (i = 0; i < ARRAY_SIZE(cb_pcidas_boards); i++) {
+			thisboard = &cb_pcidas_boards[i];
+			if (thisboard->device_id != pcidev->device)
 				continue;
 			/*  was a particular bus/slot requested? */
-			if (it->options[0] || it->options[1]) {
+			if (bus || slot) {
 				/*  are we on the wrong bus/slot? */
-				if (pcidev->bus->number != it->options[0] ||
-				    PCI_SLOT(pcidev->devfn) != it->options[1]) {
+				if (pcidev->bus->number != bus ||
+				    PCI_SLOT(pcidev->devfn) != slot) {
 					continue;
 				}
 			}
-			devpriv->pci_dev = pcidev;
-			dev->board_ptr = cb_pcidas_boards + index;
-			goto found;
+			dev->board_ptr = thisboard;
+			return pcidev;
 		}
 	}
+	return NULL;
+}
+
+static int cb_pcidas_attach(struct comedi_device *dev,
+			    struct comedi_devconfig *it)
+{
+	const struct cb_pcidas_board *thisboard;
+	struct cb_pcidas_private *devpriv;
+	struct comedi_subdevice *s;
+	int i;
+	int ret;
 
-	dev_err(dev->class_dev,
-		"No supported ComputerBoards/MeasurementComputing card found on requested position\n");
-	return -EIO;
+/*
+ * Allocate the private structure area.
+ */
+	if (alloc_private(dev, sizeof(struct cb_pcidas_private)) < 0)
+		return -ENOMEM;
+	devpriv = dev->private;
+
+	devpriv->pci_dev = cb_pcidas_find_pci_device(dev, it);
+	if (!devpriv->pci_dev) {
+		dev_err(dev->class_dev, "No supported card found\n");
+		return -EIO;
+	}
 
-found:
 	thisboard = comedi_board(dev);
 	dev_dbg(dev->class_dev, "Found %s on bus %i, slot %i\n",
-		cb_pcidas_boards[index].name, pcidev->bus->number,
-		PCI_SLOT(pcidev->devfn));
+		thisboard->name, devpriv->pci_dev->bus->number,
+		PCI_SLOT(devpriv->pci_dev->devfn));
 
 	/*
 	 * Enable PCI device and reserve I/O ports.
 	 */
-	if (comedi_pci_enable(pcidev, "cb_pcidas")) {
+	if (comedi_pci_enable(devpriv->pci_dev, "cb_pcidas")) {
 		dev_err(dev->class_dev,
 			"Failed to enable PCI device and request regions\n");
 		return -EIO;
-- 
1.7.11

