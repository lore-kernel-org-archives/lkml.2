Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758396Ab2GKWcF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 18:32:05 -0400
Received: from mail209.messagelabs.com ([216.82.255.3]:65386 "EHLO
	mail209.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754867Ab2GKWcD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 18:32:03 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-4.tower-209.messagelabs.com!1342045920!8404487!4
X-Originating-IP: [216.166.12.180]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 23/30] staging: comedi: dyna_pci10xx: factor out the "find pci device" code
Date: Wed, 11 Jul 2012 15:31:51 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201207111531.51788.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Factor the "find pci device" code out of the attach function.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/dyna_pci10xx.c | 86 ++++++++++++++-------------
 1 file changed, 44 insertions(+), 42 deletions(-)

diff --git a/drivers/staging/comedi/drivers/dyna_pci10xx.c b/drivers/staging/comedi/drivers/dyna_pci10xx.c
index d0e3679..e189f71 100644
--- a/drivers/staging/comedi/drivers/dyna_pci10xx.c
+++ b/drivers/staging/comedi/drivers/dyna_pci10xx.c
@@ -229,36 +229,15 @@ static int dyna_pci10xx_do_insn_bits(struct comedi_device *dev,
 	return insn->n;
 }
 
-/******************************************************************************/
-/*********************** INITIALIZATION FUNCTIONS *****************************/
-/******************************************************************************/
-
-static int dyna_pci10xx_attach(struct comedi_device *dev,
-			  struct comedi_devconfig *it)
+static struct pci_dev *dyna_pci10xx_find_pci_dev(struct comedi_device *dev,
+						 struct comedi_devconfig *it)
 {
-	struct comedi_subdevice *s;
-	struct pci_dev *pcidev;
-	unsigned int opt_bus, opt_slot;
-	int board_index, i;
-	int ret;
-
-	mutex_lock(&start_stop_sem);
-
-	if (alloc_private(dev, sizeof(struct dyna_pci10xx_private)) < 0) {
-		printk(KERN_ERR "comedi: dyna_pci10xx: "
-			"failed to allocate memory!\n");
-		mutex_unlock(&start_stop_sem);
-		return -ENOMEM;
-	}
-
-	opt_bus = it->options[0];
-	opt_slot = it->options[1];
-	dev->board_name = thisboard->name;
-	dev->irq = 0;
+	struct pci_dev *pcidev = NULL;
+	unsigned int opt_bus = it->options[0];
+	unsigned int opt_slot = it->options[1];
+	int board_index;
+	int i;
 
-	/*
-	 * Probe the PCI bus and located the matching device
-	 */
 	for (pcidev = pci_get_device(PCI_ANY_ID, PCI_ANY_ID, NULL);
 		pcidev != NULL;
 		pcidev = pci_get_device(PCI_ANY_ID, PCI_ANY_ID, pcidev)) {
@@ -268,6 +247,7 @@ static int dyna_pci10xx_attach(struct comedi_device *dev,
 			if ((pcidev->vendor == PCI_VENDOR_ID_DYNALOG) &&
 				(pcidev->device == boardtypes[i].device_id)) {
 					board_index = i;
+					dev->board_ptr = &boardtypes[board_index];
 					break;
 				}
 		}
@@ -285,8 +265,7 @@ static int dyna_pci10xx_attach(struct comedi_device *dev,
 		goto found;
 	}
 	printk(KERN_ERR "comedi: dyna_pci10xx: no supported device found!\n");
-	mutex_unlock(&start_stop_sem);
-	return -EIO;
+	return NULL;
 
 found:
 
@@ -299,11 +278,38 @@ found:
 			printk(KERN_ERR "comedi: dyna_pci10xx: "
 				"invalid PCI device\n");
 		}
+		return NULL;
+	}
+
+	printk(KERN_INFO "comedi: dyna_pci10xx: device found!\n");
+	return pcidev;
+}
+
+static int dyna_pci10xx_attach(struct comedi_device *dev,
+			  struct comedi_devconfig *it)
+{
+	struct comedi_subdevice *s;
+	int ret;
+
+	mutex_lock(&start_stop_sem);
+
+	if (alloc_private(dev, sizeof(struct dyna_pci10xx_private)) < 0) {
+		printk(KERN_ERR "comedi: dyna_pci10xx: "
+			"failed to allocate memory!\n");
+		mutex_unlock(&start_stop_sem);
+		return -ENOMEM;
+	}
+
+	devpriv->pci_dev = dyna_pci10xx_find_pci_dev(dev, it);
+	if (!devpriv->pci_dev) {
 		mutex_unlock(&start_stop_sem);
 		return -EIO;
 	}
 
-	if (comedi_pci_enable(pcidev, DRV_NAME)) {
+	dev->board_name = thisboard->name;
+	dev->irq = 0;
+
+	if (comedi_pci_enable(devpriv->pci_dev, DRV_NAME)) {
 		printk(KERN_ERR "comedi: dyna_pci10xx: "
 			"failed to enable PCI device and request regions!");
 		mutex_unlock(&start_stop_sem);
@@ -311,18 +317,14 @@ found:
 	}
 
 	mutex_init(&devpriv->mutex);
-	dev->board_ptr = &boardtypes[board_index];
-	devpriv->pci_dev = pcidev;
-
-	printk(KERN_INFO "comedi: dyna_pci10xx: device found!\n");
 
 	/* initialize device base address registers */
-	devpriv->BADR0 = pci_resource_start(pcidev, 0);
-	devpriv->BADR1 = pci_resource_start(pcidev, 1);
-	devpriv->BADR2 = pci_resource_start(pcidev, 2);
-	devpriv->BADR3 = pci_resource_start(pcidev, 3);
-	devpriv->BADR4 = pci_resource_start(pcidev, 4);
-	devpriv->BADR5 = pci_resource_start(pcidev, 5);
+	devpriv->BADR0 = pci_resource_start(devpriv->pci_dev, 0);
+	devpriv->BADR1 = pci_resource_start(devpriv->pci_dev, 1);
+	devpriv->BADR2 = pci_resource_start(devpriv->pci_dev, 2);
+	devpriv->BADR3 = pci_resource_start(devpriv->pci_dev, 3);
+	devpriv->BADR4 = pci_resource_start(devpriv->pci_dev, 4);
+	devpriv->BADR5 = pci_resource_start(devpriv->pci_dev, 5);
 
 	ret = comedi_alloc_subdevices(dev, 4);
 	if (ret) {
@@ -375,7 +377,7 @@ found:
 	mutex_unlock(&start_stop_sem);
 
 	printk(KERN_INFO "comedi: dyna_pci10xx: %s - device setup completed!\n",
-		boardtypes[board_index].name);
+		thisboard->name);
 
 	return 1;
 }
-- 
1.7.11

