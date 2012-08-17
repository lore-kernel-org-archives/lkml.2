Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030555Ab2HQCso (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 22:48:44 -0400
Received: from mail160.messagelabs.com ([216.82.253.99]:2321 "EHLO
	mail160.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030321Ab2HQCsm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 22:48:42 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-15.tower-160.messagelabs.com!1345171721!8652894!1
X-Originating-IP: [216.166.12.98]
X-StarScan-Received: 
X-StarScan-Version: 6.6.1.2; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 17/35] staging: comedi: cb_pcimdda: add namespace to the driver
Date: Thu, 16 Aug 2012 19:48:35 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201208161948.35844.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The structs, static data, and functions in this driver have
pretty generic names. Add namespace to everything to prevent
any problems.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/cb_pcimdda.c | 66 ++++++++++++++---------------
 1 file changed, 33 insertions(+), 33 deletions(-)

diff --git a/drivers/staging/comedi/drivers/cb_pcimdda.c b/drivers/staging/comedi/drivers/cb_pcimdda.c
index 75e803a..edce275 100644
--- a/drivers/staging/comedi/drivers/cb_pcimdda.c
+++ b/drivers/staging/comedi/drivers/cb_pcimdda.c
@@ -96,7 +96,7 @@ Configuration Options:
  * This is straight from skel.c -- I did this in case this source file
  * will someday support more than 1 board...
  */
-struct board_struct {
+struct cb_pcimdda_board {
 	const char *name;
 	unsigned short device_id;
 	int ao_chans;
@@ -116,7 +116,7 @@ enum DIO_METHODS {
 	DIO_INTERNAL		/* unimplemented */
 };
 
-static const struct board_struct boards[] = {
+static const struct cb_pcimdda_board cb_pcimdda_boards[] = {
 	{
 	 .name = "cb_pcimdda06-16",
 	 .device_id = PCI_ID_PCIM_DDA06_16,
@@ -136,7 +136,7 @@ static const struct board_struct boards[] = {
  * feel free to suggest moving the variable to the struct comedi_device
  * struct.
  */
-struct board_private_struct {
+struct cb_pcimdda_private {
 	unsigned long registers;	/* set by probe */
 	unsigned long dio_registers;
 	char attached_to_8255;	/* boolean */
@@ -149,16 +149,12 @@ struct board_private_struct {
 
 };
 
-/* returns a maxdata value for a given n_bits */
-static inline unsigned int figure_out_maxdata(int bits)
+static int cb_pcimdda_ao_winsn(struct comedi_device *dev,
+			       struct comedi_subdevice *s,
+			       struct comedi_insn *insn,
+			       unsigned int *data)
 {
-	return ((unsigned int)1 << bits) - 1;
-}
-
-static int ao_winsn(struct comedi_device *dev, struct comedi_subdevice *s,
-		    struct comedi_insn *insn, unsigned int *data)
-{
-	struct board_private_struct *devpriv = dev->private;
+	struct cb_pcimdda_private *devpriv = dev->private;
 	int i;
 	int chan = CR_CHAN(insn->chanspec);
 	unsigned long offset = devpriv->registers + chan * 2;
@@ -172,7 +168,7 @@ static int ao_winsn(struct comedi_device *dev, struct comedi_subdevice *s,
 		   the channel voltage updated in the DAC, unless
 		   we're in simultaneous xfer mode (jumper on card)
 		   then a rinsn is necessary to actually update the DAC --
-		   see ao_rinsn() below... */
+		   see cb_pcimdda_ao_rinsn() below... */
 		outb((char)(data[i] >> 8 & 0x00ff), offset + 1);
 
 		/* for testing only.. the actual rinsn SHOULD do an inw!
@@ -195,10 +191,12 @@ static int ao_winsn(struct comedi_device *dev, struct comedi_subdevice *s,
    all AO channels update simultaneously.  This is useful for some control
    applications, I would imagine.
 */
-static int ao_rinsn(struct comedi_device *dev, struct comedi_subdevice *s,
-		    struct comedi_insn *insn, unsigned int *data)
+static int cb_pcimdda_ao_rinsn(struct comedi_device *dev,
+			       struct comedi_subdevice *s,
+			       struct comedi_insn *insn,
+			       unsigned int *data)
 {
-	struct board_private_struct *devpriv = dev->private;
+	struct cb_pcimdda_private *devpriv = dev->private;
 	int i;
 	int chan = CR_CHAN(insn->chanspec);
 
@@ -215,10 +213,11 @@ static int ao_rinsn(struct comedi_device *dev, struct comedi_subdevice *s,
 	return i;
 }
 
-static int probe(struct comedi_device *dev, const struct comedi_devconfig *it)
+static int cb_pcimdda_probe(struct comedi_device *dev,
+			    const struct comedi_devconfig *it)
 {
-	const struct board_struct *thisboard;
-	struct board_private_struct *devpriv = dev->private;
+	const struct cb_pcimdda_board *thisboard;
+	struct cb_pcimdda_private *devpriv = dev->private;
 	struct pci_dev *pcidev = NULL;
 	int index;
 	unsigned long registers;
@@ -228,8 +227,8 @@ static int probe(struct comedi_device *dev, const struct comedi_devconfig *it)
 		if (pcidev->vendor != PCI_VENDOR_ID_COMPUTERBOARDS)
 			continue;
 		/*  loop through cards supported by this driver */
-		for (index = 0; index < ARRAY_SIZE(boards); index++) {
-			if (boards[index].device_id != pcidev->device)
+		for (index = 0; index < ARRAY_SIZE(cb_pcimdda_boards); index++) {
+			if (cb_pcimdda_boards[index].device_id != pcidev->device)
 				continue;
 			/*  was a particular bus/slot requested? */
 			if (it->options[0] || it->options[1]) {
@@ -242,7 +241,7 @@ static int probe(struct comedi_device *dev, const struct comedi_devconfig *it)
 			/* found ! */
 
 			devpriv->pci_dev = pcidev;
-			dev->board_ptr = boards + index;
+			dev->board_ptr = cb_pcimdda_boards + index;
 			thisboard = comedi_board(dev);
 			if (comedi_pci_enable(pcidev, thisboard->name)) {
 				printk
@@ -264,10 +263,11 @@ static int probe(struct comedi_device *dev, const struct comedi_devconfig *it)
 	return -ENODEV;
 }
 
-static int attach(struct comedi_device *dev, struct comedi_devconfig *it)
+static int cb_pcimdda_attach(struct comedi_device *dev,
+			     struct comedi_devconfig *it)
 {
-	const struct board_struct *thisboard;
-	struct board_private_struct *devpriv;
+	const struct cb_pcimdda_board *thisboard;
+	struct cb_pcimdda_private *devpriv;
 	struct comedi_subdevice *s;
 	int err;
 
@@ -281,7 +281,7 @@ static int attach(struct comedi_device *dev, struct comedi_devconfig *it)
  * it is, this is the place to do it.  Otherwise, dev->board_ptr
  * should already be initialized.
  */
-	err = probe(dev, it);
+	err = cb_pcimdda_probe(dev, it);
 	if (err)
 		return err;
 	thisboard = comedi_board(dev);
@@ -305,14 +305,14 @@ static int attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	s->type = COMEDI_SUBD_AO;
 	s->subdev_flags = SDF_WRITABLE | SDF_READABLE;
 	s->n_chan = thisboard->ao_chans;
-	s->maxdata = figure_out_maxdata(thisboard->ao_bits);
+	s->maxdata = (1 << thisboard->ao_bits) - 1;
 	/* this is hard-coded here */
 	if (it->options[2])
 		s->range_table = &range_bipolar10;
 	else
 		s->range_table = &range_bipolar5;
-	s->insn_write = &ao_winsn;
-	s->insn_read = &ao_rinsn;
+	s->insn_write = &cb_pcimdda_ao_winsn;
+	s->insn_read = &cb_pcimdda_ao_rinsn;
 
 	s = dev->subdevices + 1;
 	/* digital i/o subdevice */
@@ -341,9 +341,9 @@ static int attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	return 1;
 }
 
-static void detach(struct comedi_device *dev)
+static void cb_pcimdda_detach(struct comedi_device *dev)
 {
-	struct board_private_struct *devpriv = dev->private;
+	struct cb_pcimdda_private *devpriv = dev->private;
 
 	if (devpriv) {
 		if (dev->subdevices && devpriv->attached_to_8255) {
@@ -361,8 +361,8 @@ static void detach(struct comedi_device *dev)
 static struct comedi_driver cb_pcimdda_driver = {
 	.driver_name	= "cb_pcimdda",
 	.module		= THIS_MODULE,
-	.attach		= attach,
-	.detach		= detach,
+	.attach		= cb_pcimdda_attach,
+	.detach		= cb_pcimdda_detach,
 };
 
 static int __devinit cb_pcimdda_pci_probe(struct pci_dev *dev,
-- 
1.7.11

