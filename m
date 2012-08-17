Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964794Ab2HQCqP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 22:46:15 -0400
Received: from mail209.messagelabs.com ([216.82.255.3]:10349 "EHLO
	mail209.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933235Ab2HQCp7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 22:45:59 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-7.tower-209.messagelabs.com!1345171558!7676394!1
X-Originating-IP: [216.166.12.99]
X-StarScan-Received: 
X-StarScan-Version: 6.6.1.2; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 10/35] staging: comedi: cb_pcidda: use attach_pci callback
Date: Thu, 16 Aug 2012 19:45:54 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201208161945.54784.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert this PCI driver to use the comedi PCI auto config attach
mechanism by adding an 'attach_pci' callback function. Since the
driver does not require any external configuration options, and
the legacy 'attach' callback is now optional, remove it.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/cb_pcidda.c | 98 +++++++++---------------------
 1 file changed, 30 insertions(+), 68 deletions(-)

diff --git a/drivers/staging/comedi/drivers/cb_pcidda.c b/drivers/staging/comedi/drivers/cb_pcidda.c
index 8a66e1a..c5944e3 100644
--- a/drivers/staging/comedi/drivers/cb_pcidda.c
+++ b/drivers/staging/comedi/drivers/cb_pcidda.c
@@ -56,14 +56,6 @@ Please report success/failure with other different cards to
 /* maximum number of ao channels for supported boards */
 #define MAX_AO_CHANNELS 8
 
-/* PCI-DDA base addresses */
-#define DIGITALIO_BADRINDEX	2
-	/*  DIGITAL I/O is pci_dev->resource[2] */
-#define DIGITALIO_SIZE 8
-	/*  DIGITAL I/O uses 8 I/O port addresses */
-#define DAC_BADRINDEX	3
-	/*  DAC is pci_dev->resource[3] */
-
 /* Digital I/O registers */
 #define PORT1A 0		/*  PORT 1A DATA */
 
@@ -670,87 +662,56 @@ static int cb_pcidda_ao_winsn(struct comedi_device *dev,
 	return 1;
 }
 
-static struct pci_dev *cb_pcidda_find_pci_dev(struct comedi_device *dev,
-					      struct comedi_devconfig *it)
+static const void *cb_pcidda_find_boardinfo(struct comedi_device *dev,
+					    struct pci_dev *pcidev)
 {
-	struct pci_dev *pcidev = NULL;
-	int bus = it->options[0];
-	int slot = it->options[1];
+	const struct cb_pcidda_board *thisboard;
 	int i;
 
-	for_each_pci_dev(pcidev) {
-		if (bus || slot) {
-			if (bus != pcidev->bus->number ||
-			    slot != PCI_SLOT(pcidev->devfn))
-				continue;
-		}
-		if (pcidev->vendor != PCI_VENDOR_ID_CB)
-			continue;
-
-		for (i = 0; i < ARRAY_SIZE(cb_pcidda_boards); i++) {
-			if (cb_pcidda_boards[i].device_id != pcidev->device)
-				continue;
-			dev->board_ptr = cb_pcidda_boards + i;
-			return pcidev;
-		}
+	for (i = 0; i < ARRAY_SIZE(cb_pcidda_boards); i++) {
+		thisboard = &cb_pcidda_boards[i];
+		if (thisboard->device_id != pcidev->device)
+			return thisboard;
 	}
-	dev_err(dev->class_dev,
-		"No supported board found! (req. bus %d, slot %d)\n",
-		bus, slot);
 	return NULL;
 }
 
-static int cb_pcidda_attach(struct comedi_device *dev,
-			    struct comedi_devconfig *it)
+static int cb_pcidda_attach_pci(struct comedi_device *dev,
+				struct pci_dev *pcidev)
 {
 	const struct cb_pcidda_board *thisboard;
 	struct cb_pcidda_private *devpriv;
-	struct pci_dev *pcidev;
 	struct comedi_subdevice *s;
 	int index;
 	int ret;
 
+	comedi_set_hw_dev(dev, &pcidev->dev);
+
+	thisboard = cb_pcidda_find_boardinfo(dev, pcidev);
+	if (!pcidev)
+		return -ENODEV;
+	dev->board_ptr = thisboard;
+	dev->board_name = thisboard->name;
+
 	ret = alloc_private(dev, sizeof(*devpriv));
 	if (ret)
 		return ret;
 	devpriv = dev->private;
 
-	pcidev = cb_pcidda_find_pci_dev(dev, it);
-	if (!pcidev)
-		return -EIO;
-	comedi_set_hw_dev(dev, &pcidev->dev);
-	thisboard = comedi_board(dev);
-
-	/*
-	 * Enable PCI device and request regions.
-	 */
-	if (comedi_pci_enable(pcidev, thisboard->name)) {
-		dev_err(dev->class_dev,
-			"cb_pcidda: failed to enable PCI device and request regions\n");
-		return -EIO;
-	}
+	ret = comedi_pci_enable(pcidev, dev->board_name);
+	if (ret)
+		return ret;
 
-/*
- * Allocate the I/O ports.
- */
-	devpriv->digitalio = pci_resource_start(pcidev, DIGITALIO_BADRINDEX);
-	devpriv->dac = pci_resource_start(pcidev, DAC_BADRINDEX);
+	devpriv->digitalio = pci_resource_start(pcidev, 2);
+	devpriv->dac = pci_resource_start(pcidev, 3);
 	dev->iobase = devpriv->dac;
 
-/*
- * Warn about the status of the driver.
- */
 	if (thisboard->status == 2)
 		printk
 		    ("WARNING: DRIVER FOR THIS BOARD NOT CHECKED WITH MANUAL. "
 		     "WORKS ASSUMING FULL COMPATIBILITY WITH PCI-DDA08/12. "
 		     "PLEASE REPORT USAGE TO <ivanmr@altavista.com>.\n");
 
-/*
- * Initialize dev->board_name.
- */
-	dev->board_name = thisboard->name;
-
 	ret = comedi_alloc_subdevices(dev, 3);
 	if (ret)
 		return ret;
@@ -785,28 +746,29 @@ static int cb_pcidda_attach(struct comedi_device *dev,
 	for (index = 0; index < thisboard->ao_chans; index++)
 		cb_pcidda_calibrate(dev, index, devpriv->ao_range[index]);
 
-	return 1;
+	dev_info(dev->class_dev, "%s attached\n", dev->board_name);
+
+	return 0;
 }
 
 static void cb_pcidda_detach(struct comedi_device *dev)
 {
 	struct pci_dev *pcidev = comedi_to_pci_dev(dev);
 
-	if (pcidev) {
-		if (dev->iobase)
-			comedi_pci_disable(pcidev);
-		pci_dev_put(pcidev);
-	}
 	if (dev->subdevices) {
 		subdev_8255_cleanup(dev, dev->subdevices + 1);
 		subdev_8255_cleanup(dev, dev->subdevices + 2);
 	}
+	if (pcidev) {
+		if (dev->iobase)
+			comedi_pci_disable(pcidev);
+	}
 }
 
 static struct comedi_driver cb_pcidda_driver = {
 	.driver_name	= "cb_pcidda",
 	.module		= THIS_MODULE,
-	.attach		= cb_pcidda_attach,
+	.attach_pci	= cb_pcidda_attach_pci,
 	.detach		= cb_pcidda_detach,
 };
 
-- 
1.7.11

