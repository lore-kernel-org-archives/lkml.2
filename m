Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030568Ab2HQCzQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 22:55:16 -0400
Received: from mail160.messagelabs.com ([216.82.253.99]:29132 "EHLO
	mail160.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933607Ab2HQCzN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 22:55:13 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-12.tower-160.messagelabs.com!1345172110!8664124!1
X-Originating-IP: [216.166.12.32]
X-StarScan-Received: 
X-StarScan-Version: 6.6.1.2; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 33/35] staging: comedi: cb_pcimdda: use attach_pci callback
Date: Thu, 16 Aug 2012 19:55:01 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201208161955.01945.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert this PCI driver to use the comedi PCI auto config attach
mechanism by adding an 'attach_pci' callback function.

This driver does use an external configuration option to determine
the analog output range which is controlled by a jumper on the board.
In order to remove the legacy 'attach' callback, an assumption is made
that the jumper is in the factory setting position for +/-5V outputs.
This does not effect the operation of the board just the range info
that is returned to the user.

A sysfs method will be investigated to allow the user to change the
range.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/cb_pcimdda.c | 65 +++++++----------------------
 1 file changed, 14 insertions(+), 51 deletions(-)

diff --git a/drivers/staging/comedi/drivers/cb_pcimdda.c b/drivers/staging/comedi/drivers/cb_pcimdda.c
index 350c807..ea96514 100644
--- a/drivers/staging/comedi/drivers/cb_pcimdda.c
+++ b/drivers/staging/comedi/drivers/cb_pcimdda.c
@@ -57,12 +57,7 @@ output modes on the board:
     then issue one comedi_data_read() on any channel on the AO subdevice
     to initiate the simultaneous XFER.
 
-Configuration Options:
-  [0] PCI bus (optional)
-  [1] PCI slot (optional)
-  [2] analog output range jumper setting
-      0 == +/- 5 V
-      1 == +/- 10 V
+Configuration Options: not applicable, uses PCI auto config
 */
 
 /*
@@ -157,47 +152,21 @@ static int cb_pcimdda_ao_rinsn(struct comedi_device *dev,
 	return insn->n;
 }
 
-static struct pci_dev *cb_pcimdda_probe(struct comedi_device *dev,
-					struct comedi_devconfig *it)
-{
-	struct pci_dev *pcidev = NULL;
-
-	for_each_pci_dev(pcidev) {
-		if (pcidev->vendor != PCI_VENDOR_ID_COMPUTERBOARDS)
-			continue;
-		if (pcidev->device != PCI_ID_PCIM_DDA06_16)
-			continue;
-		if (it->options[0] || it->options[1]) {
-			if (pcidev->bus->number != it->options[0] ||
-				PCI_SLOT(pcidev->devfn) != it->options[1]) {
-				continue;
-			}
-		}
-
-		return pcidev;
-	}
-	return NULL;
-}
-
-static int cb_pcimdda_attach(struct comedi_device *dev,
-			     struct comedi_devconfig *it)
+static int cb_pcimdda_attach_pci(struct comedi_device *dev,
+				 struct pci_dev *pcidev)
 {
 	struct cb_pcimdda_private *devpriv;
-	struct pci_dev *pcidev;
 	struct comedi_subdevice *s;
 	int ret;
 
+	comedi_set_hw_dev(dev, &pcidev->dev);
+	dev->board_name = dev->driver->driver_name;
+
 	ret = alloc_private(dev, sizeof(*devpriv));
 	if (ret)
 		return ret;
 	devpriv = dev->private;
 
-	pcidev = cb_pcimdda_probe(dev, it);
-	if (!pcidev)
-		return -EIO;
-	comedi_set_hw_dev(dev, &pcidev->dev);
-	dev->board_name = dev->driver->driver_name;
-
 	ret = comedi_pci_enable(pcidev, dev->board_name);
 	if (ret)
 		return ret;
@@ -208,19 +177,14 @@ static int cb_pcimdda_attach(struct comedi_device *dev,
 		return ret;
 
 	s = dev->subdevices + 0;
-
 	/* analog output subdevice */
-	s->type = COMEDI_SUBD_AO;
-	s->subdev_flags = SDF_WRITABLE | SDF_READABLE;
-	s->n_chan = 6;
-	s->maxdata = 0xffff;
-	/* this is hard-coded here */
-	if (it->options[2])
-		s->range_table = &range_bipolar10;
-	else
-		s->range_table = &range_bipolar5;
-	s->insn_write = &cb_pcimdda_ao_winsn;
-	s->insn_read = &cb_pcimdda_ao_rinsn;
+	s->type		= COMEDI_SUBD_AO;
+	s->subdev_flags	= SDF_WRITABLE | SDF_READABLE;
+	s->n_chan	= 6;
+	s->maxdata	= 0xffff;
+	s->range_table	= &range_bipolar5;
+	s->insn_write	= cb_pcimdda_ao_winsn;
+	s->insn_read	= cb_pcimdda_ao_rinsn;
 
 	s = dev->subdevices + 1;
 	/* digital i/o subdevice */
@@ -243,14 +207,13 @@ static void cb_pcimdda_detach(struct comedi_device *dev)
 	if (pcidev) {
 		if (dev->iobase)
 			comedi_pci_disable(pcidev);
-		pci_dev_put(pcidev);
 	}
 }
 
 static struct comedi_driver cb_pcimdda_driver = {
 	.driver_name	= "cb_pcimdda",
 	.module		= THIS_MODULE,
-	.attach		= cb_pcimdda_attach,
+	.attach_pci	= cb_pcimdda_attach_pci,
 	.detach		= cb_pcimdda_detach,
 };
 
-- 
1.7.11

