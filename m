Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030415Ab2GKW0e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 18:26:34 -0400
Received: from mail160.messagelabs.com ([216.82.253.99]:47262 "EHLO
	mail160.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932159Ab2GKW0c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 18:26:32 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-4.tower-160.messagelabs.com!1342045569!8485884!20
X-Originating-IP: [216.166.12.180]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 14/30] staging: comedi: cb_pcidio: factor out the "find pci device" code
Date: Wed, 11 Jul 2012 15:26:28 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201207111526.28395.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Factor the "find pci device" code out of the attach function.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/cb_pcidio.c | 56 ++++++++++++++++--------------
 1 file changed, 29 insertions(+), 27 deletions(-)

diff --git a/drivers/staging/comedi/drivers/cb_pcidio.c b/drivers/staging/comedi/drivers/cb_pcidio.c
index 9160859..582ff3b 100644
--- a/drivers/staging/comedi/drivers/cb_pcidio.c
+++ b/drivers/staging/comedi/drivers/cb_pcidio.c
@@ -111,35 +111,19 @@ struct pcidio_private {
  */
 #define devpriv ((struct pcidio_private *)dev->private)
 
-static int pcidio_attach(struct comedi_device *dev, struct comedi_devconfig *it)
+static struct pci_dev *pcidio_find_pci_dev(struct comedi_device *dev,
+					   struct comedi_devconfig *it)
 {
 	struct pci_dev *pcidev = NULL;
-	int index;
 	int i;
-	int ret;
-
-/*
- * Allocate the private structure area.  alloc_private() is a
- * convenient macro defined in comedidev.h.
- */
-	if (alloc_private(dev, sizeof(struct pcidio_private)) < 0)
-		return -ENOMEM;
-/*
- * If you can probe the device to determine what device in a series
- * it is, this is the place to do it.  Otherwise, dev->board_ptr
- * should already be initialized.
- */
-/*
- * Probe the device to determine what device in the series it is.
- */
 
 	for_each_pci_dev(pcidev) {
 		/*  is it not a computer boards card? */
 		if (pcidev->vendor != PCI_VENDOR_ID_CB)
 			continue;
 		/*  loop through cards supported by this driver */
-		for (index = 0; index < ARRAY_SIZE(pcidio_boards); index++) {
-			if (pcidio_boards[index].dev_id != pcidev->device)
+		for (i = 0; i < ARRAY_SIZE(pcidio_boards); i++) {
+			if (pcidio_boards[i].dev_id != pcidev->device)
 				continue;
 
 			/*  was a particular bus/slot requested? */
@@ -150,14 +134,14 @@ static int pcidio_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 					continue;
 				}
 			}
-			dev->board_ptr = pcidio_boards + index;
+			dev->board_ptr = pcidio_boards + i;
 			goto found;
 		}
 	}
 
 	dev_err(dev->class_dev,
 		"No supported ComputerBoards/MeasurementComputing card found on requested position\n");
-	return -EIO;
+	return NULL;
 
 found:
 
@@ -167,17 +151,35 @@ found:
  */
 	dev->board_name = thisboard->name;
 
-	devpriv->pci_dev = pcidev;
 	dev_dbg(dev->class_dev, "Found %s on bus %i, slot %i\n",
-		thisboard->name, devpriv->pci_dev->bus->number,
-		PCI_SLOT(devpriv->pci_dev->devfn));
-	if (comedi_pci_enable(pcidev, thisboard->name))
+		thisboard->name, pcidev->bus->number,
+		PCI_SLOT(pcidev->devfn));
+	return pcidev;
+}
+
+static int pcidio_attach(struct comedi_device *dev, struct comedi_devconfig *it)
+{
+	int i;
+	int ret;
+
+/*
+ * Allocate the private structure area.  alloc_private() is a
+ * convenient macro defined in comedidev.h.
+ */
+	if (alloc_private(dev, sizeof(struct pcidio_private)) < 0)
+		return -ENOMEM;
+
+	devpriv->pci_dev = pcidio_find_pci_dev(dev, it);
+	if (!devpriv->pci_dev)
+		return -EIO;
+
+	if (comedi_pci_enable(devpriv->pci_dev, thisboard->name))
 		return -EIO;
 
 	devpriv->dio_reg_base
 	    =
 	    pci_resource_start(devpriv->pci_dev,
-			       pcidio_boards[index].dioregs_badrindex);
+			       thisboard->dioregs_badrindex);
 
 	ret = comedi_alloc_subdevices(dev, thisboard->n_8255);
 	if (ret)
-- 
1.7.11

