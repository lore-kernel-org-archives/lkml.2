Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933620Ab2HQCsG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 22:48:06 -0400
Received: from mail209.messagelabs.com ([216.82.255.3]:20012 "EHLO
	mail209.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933175Ab2HQCsC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 22:48:02 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-9.tower-209.messagelabs.com!1345171681!7671599!2
X-Originating-IP: [216.166.12.32]
X-StarScan-Received: 
X-StarScan-Version: 6.6.1.2; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 15/35] staging: comedi: cb_pcimdda: remove thisboard and devpriv macros
Date: Thu, 16 Aug 2012 19:47:51 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201208161947.51371.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These macros rely on a local variable having a specific name.
Remove them and use the comedi_board() helper to get the thisboard
pointer.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/cb_pcimdda.c | 33 ++++++++++++-----------------
 1 file changed, 14 insertions(+), 19 deletions(-)

diff --git a/drivers/staging/comedi/drivers/cb_pcimdda.c b/drivers/staging/comedi/drivers/cb_pcimdda.c
index 04a9d5b..04b9995 100644
--- a/drivers/staging/comedi/drivers/cb_pcimdda.c
+++ b/drivers/staging/comedi/drivers/cb_pcimdda.c
@@ -131,11 +131,6 @@ static const struct board_struct boards[] = {
 };
 
 /*
- * Useful for shorthand access to the particular board structure
- */
-#define thisboard    ((const struct board_struct *)dev->board_ptr)
-
-/*
  * this structure is for data unique to this hardware driver.  If
  * several hardware drivers keep similar information in this structure,
  * feel free to suggest moving the variable to the struct comedi_device
@@ -154,12 +149,6 @@ struct board_private_struct {
 
 };
 
-/*
- * most drivers define the following macro to make it easy to
- * access the private structure.
- */
-#define devpriv ((struct board_private_struct *)dev->private)
-
 static int ao_winsn(struct comedi_device *dev, struct comedi_subdevice *s,
 		    struct comedi_insn *insn, unsigned int *data);
 static int ao_rinsn(struct comedi_device *dev, struct comedi_subdevice *s,
@@ -203,17 +192,15 @@ static int probe(struct comedi_device *dev, const struct comedi_devconfig *it);
  */
 static int attach(struct comedi_device *dev, struct comedi_devconfig *it)
 {
+	const struct board_struct *thisboard;
+	struct board_private_struct *devpriv;
 	struct comedi_subdevice *s;
 	int err;
 
-/*
- * Allocate the private structure area.  alloc_private() is a
- * convenient macro defined in comedidev.h.
- * if this function fails (returns negative) then the private area is
- * kfree'd by comedi
- */
-	if (alloc_private(dev, sizeof(struct board_private_struct)) < 0)
-		return -ENOMEM;
+	err = alloc_private(dev, sizeof(*devpriv));
+	if (err)
+		return err;
+	devpriv = dev->private;
 
 /*
  * If you can probe the device to determine what device in a series
@@ -223,6 +210,7 @@ static int attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	err = probe(dev, it);
 	if (err)
 		return err;
+	thisboard = comedi_board(dev);
 
 /* Output some info */
 	printk("comedi%d: %s: ", dev->minor, thisboard->name);
@@ -281,6 +269,8 @@ static int attach(struct comedi_device *dev, struct comedi_devconfig *it)
 
 static void detach(struct comedi_device *dev)
 {
+	struct board_private_struct *devpriv = dev->private;
+
 	if (devpriv) {
 		if (dev->subdevices && devpriv->attached_to_8255) {
 			subdev_8255_cleanup(dev, dev->subdevices + 2);
@@ -297,6 +287,7 @@ static void detach(struct comedi_device *dev)
 static int ao_winsn(struct comedi_device *dev, struct comedi_subdevice *s,
 		    struct comedi_insn *insn, unsigned int *data)
 {
+	struct board_private_struct *devpriv = dev->private;
 	int i;
 	int chan = CR_CHAN(insn->chanspec);
 	unsigned long offset = devpriv->registers + chan * 2;
@@ -336,6 +327,7 @@ static int ao_winsn(struct comedi_device *dev, struct comedi_subdevice *s,
 static int ao_rinsn(struct comedi_device *dev, struct comedi_subdevice *s,
 		    struct comedi_insn *insn, unsigned int *data)
 {
+	struct board_private_struct *devpriv = dev->private;
 	int i;
 	int chan = CR_CHAN(insn->chanspec);
 
@@ -372,6 +364,8 @@ static int ao_rinsn(struct comedi_device *dev, struct comedi_subdevice *s,
  */
 static int probe(struct comedi_device *dev, const struct comedi_devconfig *it)
 {
+	const struct board_struct *thisboard;
+	struct board_private_struct *devpriv = dev->private;
 	struct pci_dev *pcidev = NULL;
 	int index;
 	unsigned long registers;
@@ -396,6 +390,7 @@ static int probe(struct comedi_device *dev, const struct comedi_devconfig *it)
 
 			devpriv->pci_dev = pcidev;
 			dev->board_ptr = boards + index;
+			thisboard = comedi_board(dev);
 			if (comedi_pci_enable(pcidev, thisboard->name)) {
 				printk
 				    ("cb_pcimdda: Failed to enable PCI device and request regions\n");
-- 
1.7.11

