Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752517Ab2GSBzz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 21:55:55 -0400
Received: from mail132.messagelabs.com ([216.82.242.115]:48406 "EHLO
	mail132.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751012Ab2GSBzx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 21:55:53 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-4.tower-132.messagelabs.com!1342662952!14779348!1
X-Originating-IP: [216.166.12.32]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 60/90] staging: comedi: daqboard2000: factor out the "find pci device" code
Date: Wed, 18 Jul 2012 18:51:18 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201207181851.19179.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Factor the "find pci device" code out of the attach function.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/daqboard2000.c | 68 +++++++++++++++------------
 1 file changed, 39 insertions(+), 29 deletions(-)

diff --git a/drivers/staging/comedi/drivers/daqboard2000.c b/drivers/staging/comedi/drivers/daqboard2000.c
index 8455cb9..fe2f39c 100644
--- a/drivers/staging/comedi/drivers/daqboard2000.c
+++ b/drivers/staging/comedi/drivers/daqboard2000.c
@@ -703,48 +703,38 @@ static int daqboard2000_8255_cb(int dir, int port, int data,
 	return result;
 }
 
-static int daqboard2000_attach(struct comedi_device *dev,
-			       struct comedi_devconfig *it)
+static struct pci_dev *daqboard2000_find_pci_dev(struct comedi_device *dev,
+						 struct comedi_devconfig *it)
 {
-	int result = 0;
-	struct comedi_subdevice *s;
-	struct pci_dev *card = NULL;
-	void *aux_data;
-	unsigned int aux_len;
-	int bus, slot;
-
-	bus = it->options[0];
-	slot = it->options[1];
+	struct pci_dev *pcidev = NULL;
+	int bus = it->options[0];
+	int slot = it->options[1];
 
-	result = alloc_private(dev, sizeof(struct daqboard2000_private));
-	if (result < 0)
-		return -ENOMEM;
-
-	for (card = pci_get_device(0x1616, 0x0409, NULL);
-	     card != NULL; card = pci_get_device(0x1616, 0x0409, card)) {
+	for (pcidev = pci_get_device(0x1616, 0x0409, NULL);
+	     pcidev != NULL; pcidev = pci_get_device(0x1616, 0x0409, pcidev)) {
 		if (bus || slot) {
 			/* requested particular bus/slot */
-			if (card->bus->number != bus ||
-			    PCI_SLOT(card->devfn) != slot) {
+			if (pcidev->bus->number != bus ||
+			    PCI_SLOT(pcidev->devfn) != slot) {
 				continue;
 			}
 		}
 		break;		/* found one */
 	}
-	if (!card) {
+	if (!pcidev) {
 		if (bus || slot)
 			dev_err(dev->class_dev,
 				"no daqboard2000 found at bus/slot: %d/%d\n",
 				bus, slot);
 		else
 			dev_err(dev->class_dev, "no daqboard2000 found\n");
-		return -EIO;
+		return NULL;
 	} else {
 		u32 id;
 		int i;
-		devpriv->pci_dev = card;
-		id = ((u32) card->
-		      subsystem_device << 16) | card->subsystem_vendor;
+
+		id = ((u32) pcidev->
+		      subsystem_device << 16) | pcidev->subsystem_vendor;
 		for (i = 0; i < ARRAY_SIZE(boardtypes); i++) {
 			if (boardtypes[i].id == id) {
 				dev_dbg(dev->class_dev, "%s\n",
@@ -758,9 +748,29 @@ static int daqboard2000_attach(struct comedi_device *dev,
 			     id);
 			dev->board_ptr = boardtypes;
 		}
+		return pcidev;
 	}
+}
+
+static int daqboard2000_attach(struct comedi_device *dev,
+			       struct comedi_devconfig *it)
+{
+	struct pci_dev *pcidev;
+	struct comedi_subdevice *s;
+	void *aux_data;
+	unsigned int aux_len;
+	int result;
+
+	result = alloc_private(dev, sizeof(struct daqboard2000_private));
+	if (result < 0)
+		return -ENOMEM;
+
+	pcidev = daqboard2000_find_pci_dev(dev, it);
+	if (!pcidev)
+		return -EIO;
+	devpriv->pci_dev = pcidev;
 
-	result = comedi_pci_enable(card, "daqboard2000");
+	result = comedi_pci_enable(pcidev, "daqboard2000");
 	if (result < 0) {
 		dev_err(dev->class_dev,
 			"failed to enable PCI device and request regions\n");
@@ -768,9 +778,9 @@ static int daqboard2000_attach(struct comedi_device *dev,
 	}
 	devpriv->got_regions = 1;
 	devpriv->plx =
-	    ioremap(pci_resource_start(card, 0), DAQBOARD2000_PLX_SIZE);
+	    ioremap(pci_resource_start(pcidev, 0), DAQBOARD2000_PLX_SIZE);
 	devpriv->daq =
-	    ioremap(pci_resource_start(card, 2), DAQBOARD2000_DAQ_SIZE);
+	    ioremap(pci_resource_start(pcidev, 2), DAQBOARD2000_DAQ_SIZE);
 	if (!devpriv->plx || !devpriv->daq)
 		return -ENOMEM;
 
@@ -783,7 +793,7 @@ static int daqboard2000_attach(struct comedi_device *dev,
 	/*
 	   u8 interrupt;
 	   Windows code does restore interrupts, but since we don't use them...
-	   pci_read_config_byte(card, PCI_INTERRUPT_LINE, &interrupt);
+	   pci_read_config_byte(pcidev, PCI_INTERRUPT_LINE, &interrupt);
 	   printk("Interrupt before is: %x\n", interrupt);
 	 */
 
@@ -803,7 +813,7 @@ static int daqboard2000_attach(struct comedi_device *dev,
 	daqboard2000_initializeDac(dev);
 	/*
 	   Windows code does restore interrupts, but since we don't use them...
-	   pci_read_config_byte(card, PCI_INTERRUPT_LINE, &interrupt);
+	   pci_read_config_byte(pcidev, PCI_INTERRUPT_LINE, &interrupt);
 	   printk("Interrupt after is: %x\n", interrupt);
 	 */
 
-- 
1.7.11

