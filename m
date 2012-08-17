Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030589Ab2HQCzx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 22:55:53 -0400
Received: from mail131.messagelabs.com ([216.82.242.99]:36525 "EHLO
	mail131.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030474Ab2HQCzu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 22:55:50 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-2.tower-131.messagelabs.com!1345172149!25272247!1
X-Originating-IP: [216.166.12.31]
X-StarScan-Received: 
X-StarScan-Version: 6.6.1.2; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 35/35] staging: comedi: ke_counter: use attach_pci callback
Date: Thu, 16 Aug 2012 19:55:43 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201208161955.43731.hartleys@visionengravers.com>
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
 drivers/staging/comedi/drivers/ke_counter.c | 83 +++++++++--------------------
 1 file changed, 25 insertions(+), 58 deletions(-)

diff --git a/drivers/staging/comedi/drivers/ke_counter.c b/drivers/staging/comedi/drivers/ke_counter.c
index d4e9292..a24e932 100644
--- a/drivers/staging/comedi/drivers/ke_counter.c
+++ b/drivers/staging/comedi/drivers/ke_counter.c
@@ -28,11 +28,7 @@ Author: Michael Hillmann
 Updated: Mon, 14 Apr 2008 15:42:42 +0100
 Status: tested
 
-Configuration Options:
-  [0] - PCI bus of device (optional)
-  [1] - PCI slot of device (optional)
-  If bus/slot is not specified, the first supported
-  PCI device found will be used.
+Configuration Options: not applicable, uses PCI auto config
 
 This driver is a simple driver to read the counter values from
 Kolter Electronic PCI Counter Card.
@@ -111,72 +107,43 @@ static int cnt_rinsn(struct comedi_device *dev,
 	return 1;
 }
 
-static struct pci_dev *cnt_find_pci_dev(struct comedi_device *dev,
-					struct comedi_devconfig *it)
+static const void *cnt_find_boardinfo(struct comedi_device *dev,
+				      struct pci_dev *pcidev)
 {
 	const struct cnt_board_struct *board;
-	struct pci_dev *pcidev = NULL;
-	int bus = it->options[0];
-	int slot = it->options[1];
 	int i;
 
-	/* Probe the device to determine what device in the series it is. */
-	for_each_pci_dev(pcidev) {
-		if (bus || slot) {
-			if (pcidev->bus->number != bus ||
-			    PCI_SLOT(pcidev->devfn) != slot)
-				continue;
-		}
-		if (pcidev->vendor != PCI_VENDOR_ID_KOLTER)
-			continue;
-
-		for (i = 0; i < ARRAY_SIZE(cnt_boards); i++) {
-			board = &cnt_boards[i];
-			if (board->device_id != pcidev->device)
-				continue;
-
-			dev->board_ptr = board;
-			return pcidev;
-		}
+	for (i = 0; i < ARRAY_SIZE(cnt_boards); i++) {
+		board = &cnt_boards[i];
+		if (board->device_id == pcidev->device)
+			return board;
 	}
-	dev_err(dev->class_dev,
-		"No supported board found! (req. bus %d, slot %d)\n",
-		bus, slot);
 	return NULL;
 }
 
-static int cnt_attach(struct comedi_device *dev, struct comedi_devconfig *it)
+static int cnt_attach_pci(struct comedi_device *dev,
+			  struct pci_dev *pcidev)
 {
 	const struct cnt_board_struct *board;
-	struct pci_dev *pcidev;
 	struct comedi_subdevice *subdevice;
-	unsigned long io_base;
-	int error;
+	int ret;
 
-	pcidev = cnt_find_pci_dev(dev, it);
-	if (!pcidev)
-		return -EIO;
 	comedi_set_hw_dev(dev, &pcidev->dev);
-	board = comedi_board(dev);
 
+	board = cnt_find_boardinfo(dev, pcidev);
+	if (!board)
+		return -ENODEV;
+	dev->board_ptr = board;
 	dev->board_name = board->name;
 
-	/* enable PCI device and request regions */
-	error = comedi_pci_enable(pcidev, CNT_DRIVER_NAME);
-	if (error < 0) {
-		printk(KERN_WARNING "comedi%d: "
-		       "failed to enable PCI device and request regions!\n",
-		       dev->minor);
-		return error;
-	}
-
-	/* read register base address [PCI_BASE_ADDRESS #0] */
-	io_base = pci_resource_start(pcidev, 0);
-	dev->iobase = io_base;
+	ret = comedi_pci_enable(pcidev, dev->board_name);
+	if (ret)
+		return ret;
+	dev->iobase = pci_resource_start(pcidev, 0);
 
-	error = comedi_alloc_subdevices(dev, 1);
-	if (error)
-		return error;
+	ret = comedi_alloc_subdevices(dev, 1);
+	if (ret)
+		return ret;
 
 	subdevice = dev->subdevices + 0;
 	dev->read_subdev = subdevice;
@@ -196,8 +163,9 @@ static int cnt_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	outb(0, dev->iobase + 0x20);
 	outb(0, dev->iobase + 0x40);
 
-	printk(KERN_INFO "comedi%d: " CNT_DRIVER_NAME " attached.\n",
-	       dev->minor);
+	dev_info(dev->class_dev, "%s: %s attached\n",
+		dev->driver->driver_name, dev->board_name);
+
 	return 0;
 }
 
@@ -208,14 +176,13 @@ static void cnt_detach(struct comedi_device *dev)
 	if (pcidev) {
 		if (dev->iobase)
 			comedi_pci_disable(pcidev);
-		pci_dev_put(pcidev);
 	}
 }
 
 static struct comedi_driver ke_counter_driver = {
 	.driver_name	= "ke_counter",
 	.module		= THIS_MODULE,
-	.attach		= cnt_attach,
+	.attach_pci	= cnt_attach_pci,
 	.detach		= cnt_detach,
 };
 
-- 
1.7.11

