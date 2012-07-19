Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755708Ab2GSCCF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 22:02:05 -0400
Received: from mail132.messagelabs.com ([216.82.242.115]:65002 "EHLO
	mail132.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751542Ab2GSCCC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 22:02:02 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-7.tower-132.messagelabs.com!1342663321!13181426!1
X-Originating-IP: [216.166.12.72]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 77/90] staging: comedi: ke_counter: factor out the "find pci device" code
Date: Wed, 18 Jul 2012 19:01:52 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201207181901.53190.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Factor the "find pci device" code out of the attach function.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/ke_counter.c | 37 ++++++++++++++++++++---------
 1 file changed, 26 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/comedi/drivers/ke_counter.c b/drivers/staging/comedi/drivers/ke_counter.c
index 019e91a..f0b8652 100644
--- a/drivers/staging/comedi/drivers/ke_counter.c
+++ b/drivers/staging/comedi/drivers/ke_counter.c
@@ -122,18 +122,12 @@ static int cnt_rinsn(struct comedi_device *dev,
 	return 1;
 }
 
-static int cnt_attach(struct comedi_device *dev, struct comedi_devconfig *it)
+static struct pci_dev *cnt_find_pci_dev(struct comedi_device *dev,
+					struct comedi_devconfig *it)
 {
-	struct comedi_subdevice *subdevice;
-	struct pci_dev *pci_device = NULL;
 	struct cnt_board_struct *board;
-	unsigned long io_base;
-	int error, i;
-
-	/* allocate device private structure */
-	error = alloc_private(dev, sizeof(struct cnt_device_private));
-	if (error < 0)
-		return error;
+	struct pci_dev *pci_device = NULL;
+	int i;
 
 	/* Probe the device to determine what device in the series it is. */
 	for_each_pci_dev(pci_device) {
@@ -166,14 +160,35 @@ static int cnt_attach(struct comedi_device *dev, struct comedi_devconfig *it)
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
+	return pci_device;
+}
+
+static int cnt_attach(struct comedi_device *dev, struct comedi_devconfig *it)
+{
+	struct pci_dev *pci_device;
+	struct comedi_subdevice *subdevice;
+	struct cnt_board_struct *board;
+	unsigned long io_base;
+	int error;
+
+	/* allocate device private structure */
+	error = alloc_private(dev, sizeof(struct cnt_device_private));
+	if (error < 0)
+		return error;
+
+	pci_device = cnt_find_pci_dev(dev, it);
+	if (!pci_device)
+		return -EIO;
 	devpriv->pcidev = pci_device;
+	board = (struct cnt_board_struct *)dev->board_ptr;
+
 	dev->board_name = board->name;
 
 	/* enable PCI device and request regions */
-- 
1.7.11

