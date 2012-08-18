Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752902Ab2HRBRL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 21:17:11 -0400
Received: from mail209.messagelabs.com ([216.82.255.3]:14736 "EHLO
	mail209.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750937Ab2HRBRF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 21:17:05 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-14.tower-209.messagelabs.com!1345252624!7745507!1
X-Originating-IP: [216.166.12.72]
X-StarScan-Received: 
X-StarScan-Version: 6.6.1.2; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 07/20] staging: comedi: adv_pci1723: remove devpriv and this_board macros
Date: Fri, 17 Aug 2012 18:16:53 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201208171816.54363.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The devpriv macro relies on a local variable having a specific name.
Remove it.

The this_board macro in this driver is a bit different in this driver.
In other comedi drivers, this macro returns the dev->board_ptr. In this
driver its simply 'boardtypes' which returns the first boardinfo element.
Remove this macro also by making sure the dev->board_ptr is set in the
pci1723_find_pci_dev() function and using the comedi_board() helper
to get the pointer in pci1723_attach().

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/adv_pci1723.c | 35 ++++++++++++++--------------
 1 file changed, 17 insertions(+), 18 deletions(-)

diff --git a/drivers/staging/comedi/drivers/adv_pci1723.c b/drivers/staging/comedi/drivers/adv_pci1723.c
index 3c4978a..cc67dccb 100644
--- a/drivers/staging/comedi/drivers/adv_pci1723.c
+++ b/drivers/staging/comedi/drivers/adv_pci1723.c
@@ -157,16 +157,12 @@ struct pci1723_private {
 	short ao_data[8];	/* data output buffer */
 };
 
-/* The following macro to make it easy to access the private structure. */
-#define devpriv ((struct pci1723_private *)dev->private)
-
-#define this_board boardtypes
-
 /*
  * The pci1723 card reset;
  */
 static int pci1723_reset(struct comedi_device *dev)
 {
+	struct pci1723_private *devpriv = dev->private;
 	int i;
 
 	outw(0x01, dev->iobase + PCI1723_SYN_SET);
@@ -196,6 +192,7 @@ static int pci1723_insn_read_ao(struct comedi_device *dev,
 				struct comedi_subdevice *s,
 				struct comedi_insn *insn, unsigned int *data)
 {
+	struct pci1723_private *devpriv = dev->private;
 	int n, chan;
 
 	chan = CR_CHAN(insn->chanspec);
@@ -212,6 +209,7 @@ static int pci1723_ao_write_winsn(struct comedi_device *dev,
 				  struct comedi_subdevice *s,
 				  struct comedi_insn *insn, unsigned int *data)
 {
+	struct pci1723_private *devpriv = dev->private;
 	int n, chan;
 	chan = CR_CHAN(insn->chanspec);
 
@@ -296,6 +294,7 @@ static struct pci_dev *pci1723_find_pci_dev(struct comedi_device *dev,
 		}
 		if (pcidev->vendor != PCI_VENDOR_ID_ADVANTECH)
 			continue;
+		dev->board_ptr = &boardtypes[0];
 		return pcidev;
 	}
 	dev_err(dev->class_dev,
@@ -307,32 +306,29 @@ static struct pci_dev *pci1723_find_pci_dev(struct comedi_device *dev,
 static int pci1723_attach(struct comedi_device *dev,
 			  struct comedi_devconfig *it)
 {
+	const struct pci1723_board *this_board;
+	struct pci1723_private *devpriv;
 	struct pci_dev *pcidev;
 	struct comedi_subdevice *s;
 	int ret, subdev, n_subdevices;
 
-	printk(KERN_ERR "comedi%d: adv_pci1723: board=%s",
-						dev->minor, this_board->name);
-
-	ret = alloc_private(dev, sizeof(struct pci1723_private));
-	if (ret < 0) {
-		printk(" - Allocation failed!\n");
-		return -ENOMEM;
-	}
+	ret = alloc_private(dev, sizeof(*devpriv));
+	if (ret < 0)
+		return ret;
+	devpriv = dev->private;
 
 	pcidev = pci1723_find_pci_dev(dev, it);
 	if (!pcidev)
 		return -EIO;
 	comedi_set_hw_dev(dev, &pcidev->dev);
+	this_board = comedi_board(dev);
+	dev->board_name = this_board->name;
 
-	ret = comedi_pci_enable(pcidev, "adv_pci1723");
+	ret = comedi_pci_enable(pcidev, dev->board_name);
 	if (ret)
 		return ret;
-
 	dev->iobase = pci_resource_start(pcidev, 2);
 
-	dev->board_name = this_board->name;
-
 	n_subdevices = 0;
 
 	if (this_board->n_aochan)
@@ -399,14 +395,17 @@ static int pci1723_attach(struct comedi_device *dev,
 
 	pci1723_reset(dev);
 
+	dev_info(dev->class_dev, "%s attached\n", dev->board_name);
+
 	return 0;
 }
 
 static void pci1723_detach(struct comedi_device *dev)
 {
 	struct pci_dev *pcidev = comedi_to_pci_dev(dev);
+	struct pci1723_private *devpriv = dev->private;
 
-	if (dev->private) {
+	if (devpriv) {
 		if (devpriv->valid)
 			pci1723_reset(dev);
 	}
-- 
1.7.11

