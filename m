Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756080Ab2GSB7O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 21:59:14 -0400
Received: from mail127.messagelabs.com ([216.82.250.115]:56370 "EHLO
	mail127.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751012Ab2GSB7L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 21:59:11 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-6.tower-127.messagelabs.com!1342663150!9008906!1
X-Originating-IP: [216.166.12.99]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 69/90] staging: comedi: dyna_pci10xx: factor out the "find pci device" code
Date: Wed, 18 Jul 2012 18:59:00 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201207181859.00599.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Factor the "find pci device" code out of the attach function.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/dyna_pci10xx.c | 71 ++++++++++++++-------------
 1 file changed, 38 insertions(+), 33 deletions(-)

diff --git a/drivers/staging/comedi/drivers/dyna_pci10xx.c b/drivers/staging/comedi/drivers/dyna_pci10xx.c
index d0e3679..81af215 100644
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
+	int opt_bus = it->options[0];
+	int opt_slot = it->options[1];
+	int board_index;
+	int i;
 
-	/*
-	 * Probe the PCI bus and located the matching device
-	 */
 	for (pcidev = pci_get_device(PCI_ANY_ID, PCI_ANY_ID, NULL);
 		pcidev != NULL;
 		pcidev = pci_get_device(PCI_ANY_ID, PCI_ANY_ID, pcidev)) {
@@ -285,8 +264,7 @@ static int dyna_pci10xx_attach(struct comedi_device *dev,
 		goto found;
 	}
 	printk(KERN_ERR "comedi: dyna_pci10xx: no supported device found!\n");
-	mutex_unlock(&start_stop_sem);
-	return -EIO;
+	return NULL;
 
 found:
 
@@ -299,9 +277,38 @@ found:
 			printk(KERN_ERR "comedi: dyna_pci10xx: "
 				"invalid PCI device\n");
 		}
+		return NULL;
+	}
+
+	dev->board_ptr = &boardtypes[board_index];
+	return pcidev;
+}
+
+static int dyna_pci10xx_attach(struct comedi_device *dev,
+			  struct comedi_devconfig *it)
+{
+	struct pci_dev *pcidev;
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
+	pcidev = dyna_pci10xx_find_pci_dev(dev, it);
+	if (!pcidev) {
 		mutex_unlock(&start_stop_sem);
 		return -EIO;
 	}
+	devpriv->pci_dev = pcidev;
+
+	dev->board_name = thisboard->name;
+	dev->irq = 0;
 
 	if (comedi_pci_enable(pcidev, DRV_NAME)) {
 		printk(KERN_ERR "comedi: dyna_pci10xx: "
@@ -311,8 +318,6 @@ found:
 	}
 
 	mutex_init(&devpriv->mutex);
-	dev->board_ptr = &boardtypes[board_index];
-	devpriv->pci_dev = pcidev;
 
 	printk(KERN_INFO "comedi: dyna_pci10xx: device found!\n");
 
@@ -375,7 +380,7 @@ found:
 	mutex_unlock(&start_stop_sem);
 
 	printk(KERN_INFO "comedi: dyna_pci10xx: %s - device setup completed!\n",
-		boardtypes[board_index].name);
+		thisboard->name);
 
 	return 1;
 }
-- 
1.7.11

