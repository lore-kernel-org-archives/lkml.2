Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755232Ab2GSBgQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 21:36:16 -0400
Received: from mail132.messagelabs.com ([216.82.242.115]:26841 "EHLO
	mail132.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754738Ab2GSBgP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 21:36:15 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-13.tower-132.messagelabs.com!1342661773!13775663!1
X-Originating-IP: [216.166.12.72]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 26/90] staging: comedi: cb_pcidio: factor out the "find pci device" code
Date: Wed, 18 Jul 2012 18:36:08 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201207181836.08600.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Factor the "find pci device" code out of the attach function.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/cb_pcidio.c | 54 ++++++++++++++----------------
 1 file changed, 25 insertions(+), 29 deletions(-)

diff --git a/drivers/staging/comedi/drivers/cb_pcidio.c b/drivers/staging/comedi/drivers/cb_pcidio.c
index 9160859..5f4d0a5 100644
--- a/drivers/staging/comedi/drivers/cb_pcidio.c
+++ b/drivers/staging/comedi/drivers/cb_pcidio.c
@@ -111,27 +111,11 @@ struct pcidio_private {
  */
 #define devpriv ((struct pcidio_private *)dev->private)
 
-static int pcidio_attach(struct comedi_device *dev, struct comedi_devconfig *it)
+static struct pci_dev *pcidio_find_pci_dev(struct comedi_device *dev,
+					   struct comedi_devconfig *it)
 {
 	struct pci_dev *pcidev = NULL;
 	int index;
-	int i;
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
@@ -151,15 +135,32 @@ static int pcidio_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 				}
 			}
 			dev->board_ptr = pcidio_boards + index;
-			goto found;
+			dev_dbg(dev->class_dev, "Found %s on bus %i, slot %i\n",
+				thisboard->name, devpriv->pci_dev->bus->number,
+				PCI_SLOT(devpriv->pci_dev->devfn));
+			return pcidev;
 		}
 	}
-
 	dev_err(dev->class_dev,
 		"No supported ComputerBoards/MeasurementComputing card found on requested position\n");
-	return -EIO;
+	return NULL;
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
 
-found:
+	devpriv->pci_dev = pcidio_find_pci_dev(dev, it);
+	if (!devpriv->pci_dev)
+		return -EIO;
 
 /*
  * Initialize dev->board_name.  Note that we can use the "thisboard"
@@ -167,17 +168,12 @@ found:
  */
 	dev->board_name = thisboard->name;
 
-	devpriv->pci_dev = pcidev;
-	dev_dbg(dev->class_dev, "Found %s on bus %i, slot %i\n",
-		thisboard->name, devpriv->pci_dev->bus->number,
-		PCI_SLOT(devpriv->pci_dev->devfn));
-	if (comedi_pci_enable(pcidev, thisboard->name))
+	if (comedi_pci_enable(devpriv->pci_dev, thisboard->name))
 		return -EIO;
 
 	devpriv->dio_reg_base
 	    =
-	    pci_resource_start(devpriv->pci_dev,
-			       pcidio_boards[index].dioregs_badrindex);
+	    pci_resource_start(devpriv->pci_dev, thisboard->dioregs_badrindex);
 
 	ret = comedi_alloc_subdevices(dev, thisboard->n_8255);
 	if (ret)
-- 
1.7.11

