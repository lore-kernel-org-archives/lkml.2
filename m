Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757794Ab2F0Vzg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 17:55:36 -0400
Received: from mail131.messagelabs.com ([216.82.242.99]:57089 "EHLO
	mail131.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753987Ab2F0Vzf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 17:55:35 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-10.tower-131.messagelabs.com!1340834125!23694599!20
X-Originating-IP: [216.166.12.97]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 02/19] staging: comedi: adl_pci6208: refactor pci6208_find_device()
Date: Wed, 27 Jun 2012 14:55:19 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201206271455.20035.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make the "find pci device" functions consistent in the comedi
drivers. Hopefully well be able to move it into the core...

Refactor the "find pci device" function to return a pointer to
the found struct pci_dev instead of an error code. Also, change
some of the tests to reduce the indent level of the code. Pass
the struct comedi_devconfig pointer to the function instead of
the bus/slot numbers.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Frank Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/adl_pci6208.c | 81 +++++++++++-----------------
 1 file changed, 32 insertions(+), 49 deletions(-)

diff --git a/drivers/staging/comedi/drivers/adl_pci6208.c b/drivers/staging/comedi/drivers/adl_pci6208.c
index 720f870..5f073c5 100644
--- a/drivers/staging/comedi/drivers/adl_pci6208.c
+++ b/drivers/staging/comedi/drivers/adl_pci6208.c
@@ -178,60 +178,43 @@ static int pci6208_ao_rinsn(struct comedi_device *dev,
 /* return 1; */
 /* } */
 
-static int pci6208_find_device(struct comedi_device *dev, int bus, int slot)
+static struct pci_dev *pci6208_find_device(struct comedi_device *dev,
+					   struct comedi_devconfig *it)
 {
-	struct pci6208_private *devpriv = dev->private;
+	const struct pci6208_board *thisboard;
 	struct pci_dev *pci_dev = NULL;
+	int bus = it->options[0];
+	int slot = it->options[1];
 	int i;
 
 	for_each_pci_dev(pci_dev) {
-		if (pci_dev->vendor == PCI_VENDOR_ID_ADLINK) {
-			for (i = 0; i < ARRAY_SIZE(pci6208_boards); i++) {
-				if (pci6208_boards[i].dev_id ==
-					pci_dev->device) {
-					/*
-					 * was a particular bus/slot requested?
-					*/
-					if ((bus != 0) || (slot != 0)) {
-						/*
-						 * are we on the
-						 * wrong bus/slot?
-						*/
-						if (pci_dev->bus->number
-						    != bus ||
-						    PCI_SLOT(pci_dev->devfn)
-						    != slot) {
-							continue;
-						}
-					}
-					dev->board_ptr = pci6208_boards + i;
-					goto found;
-				}
+		if (pci_dev->vendor != PCI_VENDOR_ID_ADLINK)
+			continue;
+		for (i = 0; i < ARRAY_SIZE(pci6208_boards); i++) {
+			thisboard = &pci6208_boards[i];
+			if (thisboard->dev_id != pci_dev->device)
+				continue;
+			/* was a particular bus/slot requested? */
+			if (bus || slot) {
+				/* are we on the wrong bus/slot? */
+				if (pci_dev->bus->number != bus ||
+				    PCI_SLOT(pci_dev->devfn) != slot)
+					continue;
 			}
+			dev_dbg(dev->class_dev,
+				"Found %s on bus %d, slot, %d, irq=%d\n",
+				thisboard->name,
+				pci_dev->bus->number,
+				PCI_SLOT(pci_dev->devfn),
+				pci_dev->irq);
+			dev->board_ptr = thisboard;
+			return pci_dev;
 		}
 	}
-
-	printk(KERN_ERR "comedi%d: no supported board found! "
-			"(req. bus/slot : %d/%d)\n",
-			dev->minor, bus, slot);
-	return -EIO;
-
-found:
-	printk("comedi%d: found %s (b:s:f=%d:%d:%d) , irq=%d\n",
-	       dev->minor,
-	       pci6208_boards[i].name,
-	       pci_dev->bus->number,
-	       PCI_SLOT(pci_dev->devfn),
-	       PCI_FUNC(pci_dev->devfn), pci_dev->irq);
-
-	/*  TODO: Warn about non-tested boards. */
-	/* switch(board->device_id) */
-	/* { */
-	/* }; */
-
-	devpriv->pci_dev = pci_dev;
-
-	return 0;
+	dev_err(dev->class_dev,
+		"No supported board found! (req. bus %d, slot %d)\n",
+		bus, slot);
+	return NULL;
 }
 
 static int
@@ -289,9 +272,9 @@ static int pci6208_attach(struct comedi_device *dev,
 		return retval;
 	devpriv = dev->private;
 
-	retval = pci6208_find_device(dev, it->options[0], it->options[1]);
-	if (retval < 0)
-		return retval;
+	devpriv->pci_dev = pci6208_find_device(dev, it);
+	if (!devpriv->pci_dev)
+		return -EIO;
 	thisboard = comedi_board(dev);
 
 	retval = pci6208_pci_setup(devpriv->pci_dev, &io_base, dev->minor);
-- 
1.7.11

