Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933482Ab2GKWen (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 18:34:43 -0400
Received: from mail160.messagelabs.com ([216.82.253.99]:46146 "EHLO
	mail160.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933410Ab2GKWel (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 18:34:41 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-8.tower-160.messagelabs.com!1342046076!9406199!9
X-Originating-IP: [216.166.12.72]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 28/30] staging: comedi: ke_counter: factor out the "find pci device" code
Date: Wed, 11 Jul 2012 15:34:36 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201207111534.36379.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Factor the "find pci device" code out of the attach function.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/ke_counter.c | 46 ++++++++++++++++++-----------
 1 file changed, 28 insertions(+), 18 deletions(-)

diff --git a/drivers/staging/comedi/drivers/ke_counter.c b/drivers/staging/comedi/drivers/ke_counter.c
index 019e91a..ddb83d3 100644
--- a/drivers/staging/comedi/drivers/ke_counter.c
+++ b/drivers/staging/comedi/drivers/ke_counter.c
@@ -122,20 +122,13 @@ static int cnt_rinsn(struct comedi_device *dev,
 	return 1;
 }
 
-static int cnt_attach(struct comedi_device *dev, struct comedi_devconfig *it)
+static struct pci_dev *cnt_find_pci_dev(struct comedi_device *dev,
+					struct comedi_devconfig *it)
 {
-	struct comedi_subdevice *subdevice;
+	const struct cnt_board_struct *board;
 	struct pci_dev *pci_device = NULL;
-	struct cnt_board_struct *board;
-	unsigned long io_base;
-	int error, i;
+	int i;
 
-	/* allocate device private structure */
-	error = alloc_private(dev, sizeof(struct cnt_device_private));
-	if (error < 0)
-		return error;
-
-	/* Probe the device to determine what device in the series it is. */
 	for_each_pci_dev(pci_device) {
 		if (pci_device->vendor == PCI_VENDOR_ID_KOLTER) {
 			for (i = 0; i < cnt_board_nbr; i++) {
@@ -155,9 +148,7 @@ static int cnt_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 					}
 
 					dev->board_ptr = cnt_boards + i;
-					board =
-					    (struct cnt_board_struct *)
-					    dev->board_ptr;
+					board = dev->board_ptr;
 					goto found;
 				}
 			}
@@ -166,18 +157,37 @@ static int cnt_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	printk(KERN_WARNING
 	       "comedi%d: no supported board found! (req. bus/slot: %d/%d)\n",
 	       dev->minor, it->options[0], it->options[1]);
-	return -EIO;
+	return NULL;
 
 found:
 	printk(KERN_INFO
 	       "comedi%d: found %s at PCI bus %d, slot %d\n", dev->minor,
 	       board->name, pci_device->bus->number,
 	       PCI_SLOT(pci_device->devfn));
-	devpriv->pcidev = pci_device;
+	return pci_device;
+}
+
+static int cnt_attach(struct comedi_device *dev, struct comedi_devconfig *it)
+{
+	const struct cnt_board_struct *board;
+	struct comedi_subdevice *subdevice;
+	unsigned long io_base;
+	int error;
+
+	/* allocate device private structure */
+	error = alloc_private(dev, sizeof(struct cnt_device_private));
+	if (error < 0)
+		return error;
+
+	devpriv->pcidev = cnt_find_pci_dev(dev, it);
+	if (!devpriv->pcidev)
+		return -EIO;
+	board = dev->board_ptr;
+
 	dev->board_name = board->name;
 
 	/* enable PCI device and request regions */
-	error = comedi_pci_enable(pci_device, CNT_DRIVER_NAME);
+	error = comedi_pci_enable(devpriv->pcidev, CNT_DRIVER_NAME);
 	if (error < 0) {
 		printk(KERN_WARNING "comedi%d: "
 		       "failed to enable PCI device and request regions!\n",
@@ -186,7 +196,7 @@ found:
 	}
 
 	/* read register base address [PCI_BASE_ADDRESS #0] */
-	io_base = pci_resource_start(pci_device, 0);
+	io_base = pci_resource_start(devpriv->pcidev, 0);
 	dev->iobase = io_base;
 
 	error = comedi_alloc_subdevices(dev, 1);
-- 
1.7.11

